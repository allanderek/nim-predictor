import prologue
import std/[db_sqlite, strformat]
import karax / [karaxdsl, vdom]
import prologue/security/hasher
import prologue/middlewares/signedcookiesession
import prologue/middlewares/staticfile
from std/strutils import parseInt, parseBool
import std/[os, parseopt]
import std/json

import ./initdb
import
  templates/login,
  templates/register
import
  templates/share/head,
  templates/share/nav

var env_file = "config.debug.env"
var optparser = initOptParser(quoteShellCommand(commandLineParams()))
for kind, key, val in optparser.getopt():
  case kind
  of cmdArgument: discard
  of cmdLongOption, cmdShortOption:
    case key
    of "config", "c":
      env_file = val
  of cmdEnd: assert(false) # cannot happen

let 
    env = loadPrologueEnv(env_file)
    settings = newSettings(appName = env.get("appName"),
      debug = env.getOrDefault("debug", false),
      port = Port(env.getOrDefault("port", 3003)),
      secretKey = env.getOrDefault("secretKey", ""),
    )
    databasePath = env.getOrDefault("dbPath", "temp.db")
    staticPath = env.get("staticDir")
initdb.initDb(databasePath)

proc drivers*(rows: seq[seq[string]]): VNode =
    result = buildHtml(section):
        h2: text "List all drivers"
        table:
            thead:
                tr:
                    th: text "ID"
                    th: text "Name"
            tbody:
                for row in rows:
                    tr:
                        for col in row:
                            td: text col

proc teams* (rows: seq[seq[string]]): VNode =
    result = buildHtml(section):
        h2: text "List all the teams"
        table:
            thead:
                tr:
                    th: text "ID"
                    th: text "Full name"
                    th: text "Short name"
            tbody:
                for row in rows:
                    tr:
                        for col in row:
                            td: text col


proc races*(rows: seq[seq[string]]): VNode =
  result = buildHtml(section):
      h2: text "Races"
      table:
          thead:
              tr:
                  th: text "Round"
                  th: text "Name"
                  th: text "Country"
                  th: text "Circuit"
                  th: text "Date"
          tbody:
              for row in rows:
                tr:
                  for col_index, col in row:
                    if col_index != 0:
                      td:
                          a(href = "/race/" & row[0]):
                            text col  
        
proc getEntrants*(db: DbConn, race_id: string): seq[seq[string]] =
    let entrant_sql = """
    select e.id, d.name, t.shortname 
    from entrants e 
    inner join drivers d on e.driver = d.id 
    inner join teams t on e.team = t.id
    where race = ? and e.participating = 1
    """
    result = db.getAllRows(sql(entrant_sql), race_id)

proc index*(ctx: Context) {.async gcsafe.} =
    let db = open(databasePath, "", "", "")

    let driver_rows = db.getAllRows(sql("""SELECT * FROM drivers"""))
    let team_rows = db.getAllRows(sql("""SELECT * FROM teams"""))
    let race_sql = """select id, round, name, country, circuit, date from races where season = '2023-24' and cancelled = 0"""
    let race_rows = db.getAllRows(sql(race_sql))
    let head = sharedHead(ctx, staticPath, "Formula E", false)
    let nav = sharedNav(ctx)
    let vNode = buildHtml(html):
        head
        nav
        main:
            section: races(rows=race_rows)
            section: drivers(rows=driver_rows)
            section: teams(rows=team_rows)

    resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
    db.close()


proc showFormulaOneIndex*(ctx: Context) {.async gcsafe.} =
    let db = open(databasePath, "", "", "")

    let head = sharedHead(ctx, staticPath, "Formula One", true)
    let vNode = buildHtml(html):
        head
        body:
          script: verbatim """var app = Elm.Main.init({ "flags": { 'now' : Date.now() } }); """

    resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
    db.close()

type
  Prediction = tuple
    pole : string
    fam : string
    fl : string
    hgc : string
    first : string
    second : string
    third : string
    fdnf : string
    safety_car : bool

proc rowToPrediction* (row: seq[string]) : Prediction =
  result = (
    pole: row[0],
    fam: row[1],
    fl: row[2],
    hgc: row[3],
    first: row[4],
    second: row[5],
    third: row[6],
    fdnf: row[7],
    safety_car: row[8] == "yes"
  )

proc entrant_input* (name: string, label: string, entrants: seq[seq[string]], current:string): VNode =
  result = buildHtml(tdiv):
    label(`for` = name): text label
    select(name = name):
        option( value = "", selected = current == ""):
          text "Please select"
        for entrant in entrants:
            let
                entrant_id = entrant[0]
                entrant_name = entrant[1]
                entrant_team = entrant[2]

            option(value = entrant_id, selected = entrant_id == current):
                text entrant_name
                text " : "
                text entrant_team

proc bool_to_yes_no(b: bool) : string =
  if b:
    return "yes"
  else:
    return "no"

proc predictionsForm(raceId: string, isResult: bool, current: Prediction, entrants: seq[seq[string]]) : VNode =
  result = buildHtml(form(`method` = "post")):
    entrant_input("pole", "Pole", entrants, current.pole)
    entrant_input("fam", "FAM", entrants, current.fam)
    entrant_input("fl", "Fastest lap", entrants, current.fl)
    entrant_input("hgc", "HGC", entrants, current.hgc)
    entrant_input("first", "Winner", entrants, current.first)
    entrant_input("second", "second", entrants, current.second)
    entrant_input("third", "third", entrants, current.third)
    entrant_input("fdnf", "First DNF/Last", entrants, current.fdnf)
    tdiv:
      label(`for` = "safety_car"): text "Safety car"
      select(name = "safety_car"):
        option(value = "yes", selected = current.safety_car): text "Yes"
        option(value = "no", selected = not current.safety_car): text "No"
    if isResult:
      input(`type` = "hidden", name="isResult", value = "true")
    tdiv:
      input(`type` = "submit", value = "Save")

proc showPredictionPart(prediction: string, prediction_name: string, answer: string, points: string): VNode =
  result = buildHtml(td):
    text prediction_name
    if answer != "":
      text " : "
      if answer == prediction:
        text points
      else:
        text "0"

proc showRace* (ctx: Context) {.async gcsafe.} =
  let
      db = open(databasePath, "", "", "")
      race_id = ctx.getPathParams("race")
      race = db.getRow(sql"SELECT id, name, country, circuit, unixepoch() > unixepoch(date) as 'Closed' FROM races WHERE id = ?", race_id)
      head = sharedHead(ctx, staticPath, "Formula E", false)
      nav = sharedNav(ctx)
      user_id = ctx.session.getOrDefault("userId")
      user = db.getRow(sql"select admin from users where id = ?", user_id)
      is_admin = user.len > 0 and user[0] == "1"

  # TODO, Obviously we have to check if the userId is empty
  if race.len > 0:
    let 
        raceId = race[0]
        race_name = race[1]
        entrants = getEntrants(db, race_id)
        entryClosed = race[4] == "1"
    if ctx.request.reqMethod == HttpPost:
      let
        pole = ctx.getPostParams("pole")
        fam = ctx.getPostParams("fam")
        fl = ctx.getPostParams("fl")
        hgc = ctx.getPostParams("hgc")
        first = ctx.getPostParams("first")
        second = ctx.getPostParams("second")
        third = ctx.getPostParams("third")
        fdnf = ctx.getPostParams("fdnf")
        safety_car = ctx.getPostParams("safety_car")
        isResult = ctx.getPostParams("isResult") == "true"
      if isResult and is_admin:
        db.exec(sql"""
        insert into results 
          (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
          on conflict(race)
          do update set pole = excluded.pole, fam=excluded.fam, fl=excluded.fl, hgc=excluded.hgc, first=excluded.first, second=excluded.second, third = excluded.third, fdnf=excluded.fdnf, safety_car=excluded.safety_car
        """, raceId, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
        # TODO: We have to check if it is isResult but the user is not an admin
      elif not entryClosed:
        db.exec(sql"""
        insert into predictions (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        on conflict(user,race)
        do update set pole = excluded.pole, fam=excluded.fam, fl=excluded.fl, hgc=excluded.hgc, first=excluded.first, second=excluded.second, third = excluded.third, fdnf=excluded.fdnf, safety_car=excluded.safety_car
        """, user_id, raceId, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
      # TODO: We need to display a kind of message to say that the entry was not accepted because it was late.
      # TODO: We also have to display an error in the case that it is an attempt to post a result by a non admin user.
    let vNode = buildHtml(html):
        head
        nav
        main:
            h2: text race_name
            if not entryClosed:
              h3: text "Entry"
              let 
                # TODO: This is non-robust to the case where the user hasn't yet set a prediction for this race.
                # It seems like it works fine.
                predictions = rowToPrediction(db.getRow(sql"select pole, fam, fl, hgc, first, second, third, fdnf, safety_car from predictions where user = ? and race = ?", user_id, raceId))
              predictionsForm(raceId, false, predictions, entrants) 
            else:
              let
                  # TODO: This is non-robust to the case where there are no results set yet for this race
                  # Actually seems to be pretty robust to that.
                  currentResults = rowToPrediction(db.getRow(sql"select pole, fam, fl, hgc, first, second, third, fdnf, safety_car  from results where race = ?", raceId))
              if is_admin:
                h3: text "Enter results"
                predictionsForm(raceId, true, currentResults, entrants) 
              h3: text "All predictions"
              let 
                  all_predictions_sql = sql"""
with
    race_entrants as
    ( select entrants.id, drivers.name
      from entrants
      inner join drivers on entrants.driver = drivers.id
      where race = ?
    )
    select 
        users.username, 
        pole_entrants.id, pole_entrants.name,
        fam_entrants.id, fam_entrants.name,
        fl_entrants.id, fl_entrants.name,
        hgc_entrants.id, hgc_entrants.name,
        first_entrants.id, first_entrants.name,
        second_entrants.id, second_entrants.name,
        third_entrants.id, third_entrants.name,
        fdnf_entrants.id, fdnf_entrants.name,
        predictions.safety_car,
        case when predictions.pole = results.pole then 10 else 0 end +
        case when predictions.fam = results.fam then 10 else 0 end + 
        case when predictions.fl = results.fl then 10 else 0 end +
        case when predictions.hgc = results.hgc then 10 else 0 end +
        case when predictions.first = results.first then 20 else 0 end +
        case when predictions.second = results.second then 10 else 0 end +
        case when predictions.third = results.third then 10 else 0 end +
        case when predictions.fdnf = results.fdnf then 10 else 0 end +
        case when predictions.safety_car = results.safety_car then 10 else 0 end
        as total
    from predictions
    inner join users on predictions.user = users.id 
    inner join race_entrants as pole_entrants on pole_entrants.id == predictions.pole
    inner join race_entrants as fam_entrants on fam_entrants.id == predictions.fam
    inner join race_entrants as fl_entrants on fl_entrants.id == predictions.fl
    inner join race_entrants as hgc_entrants on hgc_entrants.id == predictions.hgc
    inner join race_entrants as first_entrants on first_entrants.id == predictions.first
    inner join race_entrants as second_entrants on second_entrants.id == predictions.second
    inner join race_entrants as third_entrants on third_entrants.id == predictions.third
    inner join race_entrants as fdnf_entrants on fdnf_entrants.id == predictions.fdnf
    left join results on predictions.race = results.race
    where predictions.race = ?
    order by total desc
    ;
                  """
                  all_predictions = db.getAllRows(all_predictions_sql, race_id, race_id) 
              table:
                thead:
                  tr:
                    th: text "User"
                    th: text "Pole"
                    th: text "FAM"
                    th: text "FL"
                    th: text "HGC"
                    th: text "First"
                    th: text "Second"
                    th: text "Third"
                    th: text "FDNF"
                    th: text "Safety car"
                    th: text "Total"
                tbody:
                  for row in all_predictions:
                    tr:
                      let
                        predictor = row[0]
                      td: text predictor
                      let 
                        row_pole = row[1]
                        row_pole_name = row[2]
                      showPredictionPart(row_pole, row_pole_name, currentResults.pole, "10")
                      let
                        row_fam = row[3]
                        row_fam_name = row[4]
                      showPredictionPart(row_fam, row_fam_name, currentResults.fam, "10")
                      let
                        row_fl = row[5]
                        row_fl_name = row[6]
                      showPredictionPart(row_fl, row_fl_name, currentResults.fl, "10")
                      let
                        row_hgc = row[7]
                        row_hgc_name = row[8]
                      showPredictionPart(row_hgc, row_hgc_name, currentResults.hgc, "10")
                      let
                        row_first = row[9]
                        row_first_name = row[10]
                      showPredictionPart(row_first, row_first_name, currentResults.first, "20")
                      let
                        row_second = row[11]
                        row_second_name = row[12]
                      showPredictionPart(row_second, row_second_name, currentResults.second, "10")
                      let
                        row_third = row[13]
                        row_third_name = row[14]
                      showPredictionPart(row_third, row_third_name, currentResults.third, "10")
                      let
                        row_fdnf = row[15]
                        row_fdnf_name = row[16]
                      showPredictionPart(row_fdnf, row_fdnf_name, currentResults.fdnf, "10")
                      let
                        row_safety_car = row[17]
                      showPredictionPart(row_safety_car, row_safety_car, boolto_yes_no(currentResults.safety_car), "10")
                      td: text row[18]

    if ctx.request.reqMethod == HttpPost:
      resp redirect(urlFor(ctx, "/race/" & race_id), Http302)
    else:
      resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
  else:
    let vNode = buildHtml(html):
        head
        nav
        text "Race not found."
    resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
  db.close()


proc showLeaderboard*(ctx: Context) {.async gcsafe.} =
  let
      db = open(databasePath, "", "", "")
      season = ctx.getPathParams("season")
      leaderboardSql = """
with
    scored_predictions
    as ( select
            users.fullname as user,
            users.id as user_id,
            case when predictions.first = results.first then 1 else 0 end as race_wins,
            case when predictions.pole = results.pole then 10 else 0 end +
            case when predictions.fam = results.fam then 10 else 0 end + 
            case when predictions.fl = results.fl then 10 else 0 end +
            case when predictions.hgc = results.hgc then 10 else 0 end +
            case when predictions.first = results.first then 20 else 0 end +
            case when predictions.second = results.second then 10 else 0 end +
            case when predictions.third = results.third then 10 else 0 end +
            case when predictions.fdnf = results.fdnf then 10 else 0 end +
            case when predictions.safety_car = results.safety_car then 10 else 0 end
            as total
         from predictions
         inner join races on predictions.race = races.id 
         join results on predictions.race = results.race
         join users on predictions.user = users.id
         where races.season = ? and races.cancelled = 0
        )
    select user as 'User', sum(total) as 'Total score', sum(race_wins) as 'Race wins'
    from scored_predictions
    group by user_id
    order by sum(total) desc, sum(race_wins) desc
    ;
      """
      leaderboardRows = db.getAllRows(sql(leaderboardSql), season)
  let head = sharedHead(ctx, staticPath, "Formula E", false)
  let nav = sharedNav(ctx)
  let vNode = buildHtml(html):
      head
      nav
      section:
        table:
          thead:
            tr:
              th:
                text "User"
              th:
                text "Score"
              th:
                text "Race wins"
          tbody:
            for row in leaderboardRows:
              tr:
                td: text row[0]
                td: text row[1]
                td: text row[2]
      let race_sql = """select id, round, name, country, circuit, date from races where season = ? and cancelled = 0"""
      let race_rows = db.getAllRows(sql(race_sql), season)
      section: races(rows=race_rows)
  resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
  db.close

proc showProfile*(ctx: Context) {.async gcsafe.} =
  let
    db = open(databasePath, "", "", "")
    user_id = ctx.session.getOrDefault("userId")
  if ctx.request.reqMethod == HttpPost:
    # TODO: Check that the repeat is the same?
    let 
      new_fullname = ctx.getPostParams("fullname")
      new_password = ctx.getPostParams("password")
    if new_password.len > 0:
      let
        encoded = pbkdf2_sha256encode(SecretKey(new_password), "Prologue")
      db.exec(sql"update users set password = ? where id = ?", encoded, user_id) 
    if new_fullname.len > 0:
      ctx.session["userFullname"] = new_fullname
      db.exec(sql"update users set fullname = ? where id = ?", new_fullname, user_id)
  let
    user_row = db.getRow(sql"select fullname from users where id = ?", user_id)
    vNode = buildHtml(html):
      sharedHead(ctx, staticPath, "Formula E", false)
      sharedNav(ctx)
      section:
        h1: text user_row[0]
        form(`method` = "post"):
          label(`for` = "fullname"): text "Full name"
          input(name = "fullname", id = "fullname")
          label(`for` = "password"): text "Password"
          input(`type` = "password", name = "password", id = "password")
          input(`type` = "submit", value = "Save")
  resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
  db.close

proc loginHandler*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  if ctx.request.reqMethod == HttpPost:
    var
      error: string
      id: string
      fullname: string
      encoded: string
    let
      username = ctx.getPostParams("username")
      password = SecretKey(ctx.getPostParams("password"))
      row = db.getRow(sql"SELECT id, fullname, password  FROM users WHERE username = ?", username)

    if row.len < 3:
      error = "Incorrect username"
    else:
      id = row[0]
      fullname = row[1]
      encoded = row[2]

      if not pbkdf2_sha256verify(password, encoded):
        error = "Incorrect password"

    if error.len == 0:
      ctx.session.clear()
      ctx.session["userId"] = id
      ctx.session["userFullname"] = fullname
      resp redirect(urlFor(ctx, "index"), Http302)
    else:
      resp htmlResponse(loginPage(ctx, staticPath, "Login", error))
  else:
    resp htmlResponse(loginPage(ctx, staticPath, "Login"))

  db.close()

proc apiLoginHandler*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  let form = parseJson(ctx.request.body())
  let username = form["username"].str
  let password = SecretKey(form["password"].str)
  let userRow = db.getRow(sql"SELECT id, fullname, username, admin, password FROM users WHERE username = ?", username)

  if userRow.len < 3:
    resp "User not found.", Http401

  else:
      let id = userRow[0]
      let fullname = userRow[1]
      var userJson = newJObject()
      userJson["id"] = %parseInt(id)
      userJson["fullname"] = %fullname
      userJson["username"] = %userRow[2]
      userJson["isAdmin"] = %(userRow[3] == "1")
      let encoded = userRow[4]
      if not pbkdf2_sha256verify(password, encoded):
        resp "Incorrect password", Http401
      else:
        ctx.session.clear()
        ctx.session["userId"] = id
        ctx.session["userFullname"] = fullname
        resp jsonResponse(userJson)

  db.close()

proc logoutHandler*(ctx: Context) {.async.} =
  ctx.session.clear()
  resp redirect(urlFor(ctx, "index"), Http302)

proc apiLogoutHandler*(ctx: Context) {.async.} =
  ctx.session.clear()
  resp jsonResponse(newJNull())

# /register
proc registerHandler*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  if ctx.request.reqMethod == HttpPost:
    var error: string
    let
      username = ctx.getPostParams("username")
      password = pbkdf2_sha256encode(SecretKey(ctx.getPostParams( "password")), "Prologue")
    var fullname = ctx.getPostParams("fullname")

    if username.len == 0:
      error = "username required"
    elif password.len == 0:
      error = "password required"
    elif db.getValue(sql"SELECT id FROM users WHERE username = ?",
            username).len != 0:
      error = fmt"Username {username} registered already"

    if error.len == 0:
      if fullname.len == 0: fullname = username
      db.exec(sql"INSERT INTO users (fullname, username, password) VALUES (?, ?, ?)",
              fullname, username, password)
      resp redirect(urlFor(ctx, "login"), Http301)
    else:
      resp htmlResponse(registerPage(ctx, staticPath, "Register", error))
  else:
    resp htmlResponse(registerPage(ctx, staticPath, "Register"))

  db.close()

proc getMe*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  let user_id = ctx.session.getOrDefault("userId")
  if user_id == "":
    resp "Unauthorised, no user to return.", Http401
  else:
    let user_sql = "select id, username, fullname, admin from users where id = ?"
    let userRow = db.getRow(sql(user_sql), user_id)
    db.close()

    if userRow.len >= 4:
      var userJson = newJObject()
      userJson["id"] = %parseInt(userRow[0])
      userJson["username"] = %userRow[1]
      userJson["fullname"] = %userRow[2]
      userJson["isAdmin"] = %(userRow[3] == "1")
      resp jsonResponse(userJson)
    else:
      resp "User not found.", Http401



proc formulaOneEvents*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  let event_sql = """
      select 
      id, round, name, season,
      case
        when exists (
            select 1
            from formula_one_sessions
            where event = events.id and name = "sprint"
        ) then 1
        else 0 
      end as isSprint,
      ( select min(start_time) from formula_one_sessions where event = events.id) as start_time
      from formula_one_events as events
      where season = "2024"
      """
  let dbRows = db.getAllRows(sql(event_sql))
  let jsonArray = newJArray()

  for row in dbRows:
    if row.len >= 6: 
      var jsonObj = newJObject()
      jsonObj["id"] = %parseInt(row[0])
      jsonObj["round"] = %parseInt(row[1])
      jsonObj["name"] = %row[2]
      jsonObj["season"] = %row[3] 
      jsonObj["isSprint" ] = %parseBool(row[4])
      jsonObj["startTime" ] = %row[5] 
      jsonArray.add(jsonObj)
  resp jsonResponse(jsonArray)
  db.close()

proc formulaOneSessions*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  # TODO: This SQL needs to only get those sessions associated with events in the current season.
  let event_sql = """
      select id, event, name, start_time, half_points
      from formula_one_sessions
      order by start_time
      """
  let dbRows = db.getAllRows(sql(event_sql))
  let jsonArray = newJArray()

  for row in dbRows:
    if row.len >= 5: # Ensure there are at least two elements
      var jsonObj = newJObject()
      jsonObj["id"] = %parseInt(row[0])
      jsonObj["event"] = %parseInt(row[1])
      jsonObj["name"] = %row[2]
      jsonObj["start_time"] = %row[3] 
      jsonObj["half_points"] = %(row[4] != "0")
      jsonArray.add(jsonObj)
  resp jsonResponse(jsonArray)
  db.close()

proc formulaOneEntrants*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  # TODO: This SQL needs to only get those sessions associated with events in the current season.
  let event_id = ctx.getPathParams("event")
  let entrant_sql = """
  select entrants.id, sessions.id as session_id, entrants.number, drivers.name, formula_one_teams.shortname
               from formula_one_entrants as entrants
               inner join drivers on entrants.driver = drivers.id
               inner join formula_one_teams on entrants.team = formula_one_teams.id
               inner join formula_one_sessions as sessions on entrants.session = sessions.id
               inner join formula_one_events as events on sessions.event = events.id
               where events.id = ? and entrants.participating = 1
               ;
      """
  let dbRows = db.getAllRows(sql(entrant_sql), event_id)
  let jsonArray = newJArray()

  for row in dbRows:
    if row.len >= 5: # Ensure there are at least two elements
      var jsonObj = newJObject()
      jsonObj["id"] = %parseInt(row[0])
      jsonObj["session"] = %parseInt(row[1])
      jsonObj["number"] = %parseInt(row[2])
      jsonObj["driver"] = %row[3] 
      jsonObj["team"] = %row[4]
      jsonArray.add(jsonObj)
  resp jsonResponse(jsonArray)
  db.close()

proc formulaOneTeams*(ctx: Context) {.async gcsafe.} =
  let db = open(databasePath, "", "", "")
  let season = ctx.getPathParams("season")
  let team_sql ="""
  select id, season, fullname, shortname, color
  from formula_one_teams
  where season = ?
  """
  let dbRows = db.getAllRows(sql(team_sql), season)
  let jsonArray = newJArray()
  for row in dbRows:
    if row.len >= 5: # Ensure there are at least two elements
      var jsonObj = newJObject()
      jsonObj["id"] = %parseInt(row[0])
      jsonObj["season"] = %row[1]
      jsonObj["fullname"] = %row[2]
      jsonObj["shortname"] = %row[3] 
      jsonObj["color"] = %row[4]
      jsonArray.add(jsonObj)
  resp jsonResponse(jsonArray)
  db.close()


proc submitFormulaOnePredictionsLines*(ctx: Context, user_id: string, session: string) {.async gcsafe.}=
  let db = open(databasePath, "", "", "")
  # TODO: Obviously I need to check that we are not past the time.
  let predictions = parseJson(ctx.request.body())
  if predictions.kind == JArray:
    for prediction in predictions:
      let position = prediction["position"].getInt()
      let entrant = prediction["entrant"].getInt()
      let fastest_lap = prediction["fastest_lap"].getBool()
      let upsert_sql = """
        insert into formula_one_prediction_lines(user, session, position, entrant, fastest_lap) values 
        (?, ?, ?, ?, ?)
        on conflict(user,session,position) 
        do update 
        set entrant=excluded.entrant, fastest_lap=excluded.fastest_lap
        ;
      """
      db.exec(sql(upsert_sql), user_id, session, position, entrant, fastest_lap)
  resp jsonResponse(predictions)
  db.close()

proc submitFormulaOnePredictions*(ctx: Context) {.async gcsafe.}=
  let user_id = ctx.session.getOrDefault("userId")
  let session = ctx.getPathParams("session")
  # TODO: First we have to get the user and check that they are a valid user. Second we should check that the session
  # has not yet started.
  if user_id != "":
    result = submitFormulaOnePredictionsLines(ctx, user_id, session)
  # TODO: Have to do something if the user_id is not empty

proc submitFormulaOneResults*(ctx: Context) {.async gcsafe.}=
  # let user_id = ctx.session.getOrDefault("userId")
  let session = ctx.getPathParams("session")
  # The user we store the predictions against is the empty user as that is how results are stored.
  let user_to_store = ""
  # TODO: First we have to get the user and check that they are an admin user. Second we should check that the
  # the session has indeed started, although that's not strictly necessary.
  result = submitFormulaOnePredictionsLines(ctx, user_to_store, session)

proc formulaOneSessionPredictions*(ctx: Context) {.async gcsafe.}=
  let db = open(databasePath, "", "", "")
  let user_id = ctx.session.getOrDefault("userId")
  let event = ctx.getPathParams("event")

  # TODO: Before the session has started this should only be the user that is logged in.
  let users_sql = """
  select distinct users.id, coalesce(nullif(users.fullname, ''), users.username) as username, sessions.id
  from 
  users
  inner join formula_one_prediction_lines as lines on lines.user = users.id
  inner join formula_one_sessions as sessions on lines.session = sessions.id
  inner join formula_one_events as events on sessions.event = events.id
  where events.id = ?
  union
  select distinct "", "Results" as user_name, sessions.id
  from 
  formula_one_prediction_lines as lines 
  inner join formula_one_sessions as sessions on lines.session = sessions.id
  inner join formula_one_events as events on sessions.event = events.id
  where events.id = ? and lines.user = ''
  ;
  """
  let userRows = db.getAllRows(sql(users_sql), event, event)
  let resultArray = newJArray()
  for user in userRows:
    var userObj = newJObject()
    let row_user_id = if user[0] == "": 0 else: parseInt(user[0])
    let row_session_id = parseInt(user[2])
    userObj["user"] = %row_user_id
    userObj["name"] = %user[1]
    userObj["session"] = %row_session_id
    # TODO: After the session has started, you need to return the *scored* predictions.
    let prediction_sql = """
      select entrant, position, fastest_lap
      from formula_one_prediction_lines
      where user = ? and session = ?
      ;
    """
    # We use user[0] here rather than row_user_id because if it is a result it won't be '0' but ""
    let predictionRows = db.getAllRows(sql(prediction_sql), user[0], row_session_id)
    let predArray = newJArray()
    for prediction in predictionRows:
      if prediction.len >= 3:
        var predObj = newJObject()
        predObj["entrant"] = %parseInt(prediction[0])
        predObj["position"] = %parseInt(prediction[1])
        predObj["fastest_lap"] = %parseBool(prediction[2])
        predArray.add(predObj)
    userObj["predictions"] = predArray
    resultArray.add(userObj)
  resp jsonResponse(resultArray)
  db.close()


proc formulaOneSeasonPredictions*(ctx: Context) {.async gcsafe.}=
  let db = open(databasePath, "", "", "")
  let user_id = ctx.session.getOrDefault("userId")
  let season = ctx.getPathParams("season")
  let users_sql = """
  select distinct users.id, case when users.fullname = "" then users.username else users.fullname end as user_name
  from users
  inner join formula_one_season_prediction_lines as predictions on predictions.user = users.id
  where predictions.season = ?
  ;
  """
  let userRows = db.getAllRows(sql(users_sql), season)
  let resultArray = newJArray()
  for user in userRows:
    var userObj = newJObject()
    let row_user_id = parseInt(user[0])
    userObj["user"] = %row_user_id
    userObj["name"] = %user[1]
    # TODO: After the season has started, you need to return the *scored* predictions.
    let prediction_sql = """
      select pred.position, teams.id as team_id, teams.shortname
      from formula_one_season_prediction_lines as pred
      inner join formula_one_teams as teams on teams.id = pred.team
      where pred.season = ? and user = ?
      order by pred.position
      ;
    """
    let predictionRows = db.getAllRows(sql(prediction_sql), season, row_user_id)
    let predArray = newJArray()
    for prediction in predictionRows:
      if prediction.len >= 3:
        var predObj = newJObject()
        predObj["position"] = %parseInt(prediction[0])
        predObj["team_id"] = %parseInt(prediction[1])
        predObj["team_name"] = %prediction[2]
        predArray.add(predObj)
    userObj["predictions"] = predArray
    resultArray.add(userObj)
  resp jsonResponse(resultArray)
  db.close()


proc submitFormulaOneSeasonPrediction*(ctx: Context) {.async gcsafe.}=
  let db = open(databasePath, "", "", "")
  let user_id = ctx.session.getOrDefault("userId")
  let season = ctx.getPathParams("season")
  let predictions = parseJson(ctx.request.body())
  if predictions.kind == JArray:
    for prediction in predictions:
      let position = prediction["position"].getInt()
      let team = prediction["team"].getInt()
      let upsert_sql = """
        insert into formula_one_season_prediction_lines(user, season, position, team) values 
        (?, ?, ?, ?)
        on conflict(user,season,position) 
        do update 
        set team = excluded.team
        ;
      """
      db.exec(sql(upsert_sql), user_id, season, position, team)
  db.close()
  result = formulaOneSeasonPredictions(ctx)

proc formulaOneLeaderboard*(ctx: Context) {.async gcsafe.}=
  let db = open(databasePath, "", "", "")
  let season = ctx.getPathParams("season")
  let leaderboard_sql = """
with
    predictions as (select * from formula_one_prediction_lines where user != "" and position <= 10),
    results as (select * from formula_one_prediction_lines where user == ""),
    scored_lines as (
    select 
        users.id as user_id,
        users.fullname as user_fullname,
        sessions.name as session_name,
        case when predictions.position <= 10 and results.position <= 10 
            then
                case when predictions.position == results.position 
                    then 4 
                    else 
                        case when predictions.position + 1 == results.position  or predictions.position - 1 == results.position
                        then 2
                        else 1
                        end
                    end +
                case when sessions.name == "race" and results.fastest_lap = "true" and predictions.fastest_lap = "true" 
                    then 1
                    else 0
                    end
            else
                0
            end
            as score
        from predictions
        inner join results on results.session == predictions.session and results.entrant == predictions.entrant
        inner join formula_one_sessions as sessions on predictions.session = sessions.id
        inner join formula_one_events as events on sessions.event == events.id and events.season == ?
        inner join users on predictions.user = users.id
    )
select 
    user_id,
    user_fullname,
    sum(
        case when session_name == "sprint-shootout" then score else 0 end
    ) as sprint_shootout,
    sum(
        case when session_name == "sprint" then score else 0 end
    ) as sprint,
    sum(
        case when session_name == "qualifying" then score else 0 end
    ) as qualifying,
    sum(
        case when session_name == "race" then score else 0 end
    ) as race,
    sum(score) as total
    from scored_lines
    group by user_id
    order by total desc
    ;
  """
  let leaderboardRows = db.getAllRows(sql(leaderboard_sql), season)
  let resultArray = newJArray()
  for user in leaderboardRows:
    var userObj = newJObject()
    userObj["user"] = %parseInt(user[0])
    userObj["fullname"] = %user[1]
    userObj["sprint-shootout"] = %parseInt(user[2])
    userObj["sprint"] = %parseInt(user[3])
    userObj["qualifying"] = %parseInt(user[4])
    userObj["race"] = %parseInt(user[5])
    userObj["total"] = %parseInt(user[6])
    resultArray.add(userObj)
  resp jsonResponse(resultArray)
  db.close()

let
  indexPatterns* = @[
    pattern("/", showFormulaOneIndex, @[HttpGet], name = "index"),
    pattern("/formulaone", showFormulaOneIndex, @[HttpGet], name = "formula-one" ),
    pattern("/formulaone/event/{event}", showFormulaOneIndex, @[HttpGet], name = "formula-one-event" ),
    pattern("/formulaone/profile", showFormulaOneIndex, @[HttpGet], name = "formula-one-profile" ),
    pattern("/formulaone/leaderboard", showFormulaOneIndex, @[HttpGet], name = "formula-one-leaderboard" ),
    pattern("/race/{race}", showRace, @[HttpGet, HttpPost], name = "race"),
    pattern("/leaderboard/{season}", showLeaderboard, @[HttpGet], name = "leaderboard"),
    pattern("/profile", showProfile, @[HttpGet, HttpPost], name = "profile"),
  ]
  authPatterns* = @[
    pattern("/login", loginHandler, @[HttpGet, HttpPost], name = "login"),
    pattern("/register", registerHandler, @[HttpGet, HttpPost]),
    pattern("/logout", logoutHandler, @[HttpGet, HttpPost]),
  ]
  authApiPatterns* = @[
    pattern("/me", getMe, @[HttpGet], name = "me"),
    pattern("/login", apiLoginHandler, @[HttpPost]),
    pattern("/logout", apiLogoutHandler, @[HttpPost]),
  ]
  formulaOneApiPatterns* = @[
    pattern("/events", formulaOneEvents, @[HttpGet]),
    pattern("/sessions", formulaOneSessions, @[HttpGet]),
    pattern("/entrants/{event}", formulaOneEntrants, @[HttpGet]),
    pattern("/teams/{season}", formulaOneTeams, @[HttpGet]),
    pattern("/submit-predictions/{session}", submitFormulaOnePredictions, @[HttpPost]),
    pattern("/submit-results/{session}", submitFormulaOneResults, @[HttpPost]),
    pattern("/submit-season-predictions/{season}", submitFormulaOneSeasonPrediction, @[HttpPost]),
    pattern("/season-predictions/{season}", formulaOneSeasonPredictions, @[HttpGet]),
    pattern("/session-predictions/{event}", formulaOneSessionPredictions, @[HttpGet]),
    pattern("/leaderboard/{season}", formulaOneLeaderboard, @[HttpGet]),
  ]


var app = newApp( settings = settings )

app.use(staticFileMiddleware(staticPath), sessionMiddleware(settings, path = "/"))
app.addRoute(indexPatterns, "")
app.addRoute(authPatterns, "/auth")
app.addRoute(authApiPatterns, "/api/auth")
app.addRoute(formulaOneApiPatterns, "/api/formulaone")
app.run()
