import prologue
import std/[db_sqlite, strformat]
import karax / [karaxdsl, vdom]
import prologue/security/hasher
import prologue/middlewares/signedcookiesession
import prologue/middlewares/staticfile
from std/strutils import parseInt

import ./consts
import ./initdb
import
  templates/login,
  templates/register
import
  templates/share/head,
  templates/share/nav


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
    where race = ?
    """
    result = db.getAllRows(sql(entrant_sql), race_id)

proc index*(ctx: Context) {.async.} =
    let db = open(consts.dbPath, "", "", "")

    let driver_rows = db.getAllRows(sql("""SELECT * FROM drivers"""))
    let team_rows = db.getAllRows(sql("""SELECT * FROM teams"""))
    let race_sql = """select id, id - 16 as round, name, country, circuit, date from races where season = '2023-24'"""
    let race_rows = db.getAllRows(sql(race_sql))
    let head = sharedHead(ctx, "Formula E")
    let nav = sharedNav(ctx)
    let vNode = buildHtml(html):
        head
        nav
        main:
            section: drivers(rows=driver_rows)
            section: teams(rows=team_rows)
            section: races(rows=race_rows)

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

proc showRace* (ctx: Context) {.async.} =
  let
      db = open(consts.dbPath, "", "", "")
      race_id = ctx.getPathParams("race")
      race = db.getRow(sql"SELECT id, name, country, circuit, unixepoch() > unixepoch(date) as 'Closed' FROM races WHERE id = ?", race_id)
  let head = sharedHead(ctx, "Formula E")
  let nav = sharedNav(ctx)
  let user_id = ctx.session.getOrDefault("userId")
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
      if isResult:
        # TODO: We have to check if the user is an admin
        db.exec(sql"insert into results (race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", raceId, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
      elif not entryClosed:
        db.exec(sql"insert into predictions (user, race, pole, fam, fl, hgc, first, second, third, fdnf, safety_car) values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", user_id, raceId, pole, fam, fl, hgc, first, second, third, fdnf, safety_car)
      # TODO: We need to display a kind of message to say that the entry was not accepted because it was late.
    let vNode = buildHtml(html):
        head
        nav
        main:
            h2: text race_name
            if not entryClosed:
              h3: text "Entry"
              let 
                # TODO: This is non-robust to the case where the user hasn't yet set a prediction for this race.
                predictions = rowToPrediction(db.getRow(sql"select pole, fam, fl, hgc, first, second, third, fdnf, safety_car from predictions where user = ? and race = ?", user_id, raceId))
              predictionsForm(raceId, false, predictions, entrants) 
            else:
              h3: text "Enter results"
                # TODO: We have to check if the user is an admin
              let 
                # TODO: This is non-robust to the case where there are no results set yet for this race
                currentResults = rowToPrediction(db.getRow(sql"select pole, fam, fl, hgc, first, second, third, fdnf, safety_car  from results where race = ?", raceId))
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
    join results on predictions.race = results.race
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


proc showLeaderboard*(ctx: Context) {.async.} =
  let
      db = open(consts.dbPath, "", "", "")
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
         where races.season = ?
        )
    select user as 'User', sum(total) as 'Total score', sum(race_wins) as 'Race wins'
    from scored_predictions
    group by user_id
    order by sum(total) desc, sum(race_wins) desc
    ;
      """
      leaderboardRows = db.getAllRows(sql(leaderboardSql), season)
  let head = sharedHead(ctx, "Formula E")
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
      let race_sql = """select id as round, name, country, circuit, date from races where season = ?"""
      let race_rows = db.getAllRows(sql(race_sql), season)
      section: races(rows=race_rows)
  resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
  db.close



proc loginHandler*(ctx: Context) {.async.} =
  let db = open(consts.dbPath, "", "", "")
  if ctx.request.reqMethod == HttpPost:
    var
      error: string
      id: string
      fullname: string
      encoded: string
    let
      username = ctx.getPostParams("username")
      password = SecretKey(ctx.getPostParams("password"))
      row = db.getRow(sql"SELECT * FROM users WHERE username = ?", username)

    if row.len == 0:
      error = "Incorrect username"
    elif row.len < 3:
      error = "Incorrect username"
    else:
      id = row[0]
      fullname = row[1]
      encoded = row[3]

      if not pbkdf2_sha256verify(password, encoded):
        error = "Incorrect password"

    if error.len == 0:
      ctx.session.clear()
      ctx.session["userId"] = id
      ctx.session["userFullname"] = fullname
      resp redirect(urlFor(ctx, "index"), Http302)
    else:
      resp htmlResponse(loginPage(ctx, "Login", error))
  else:
    resp htmlResponse(loginPage(ctx, "Login"))

  db.close()

# /logout
proc logoutHandler*(ctx: Context) {.async.} =
  ctx.session.clear()
  resp redirect(urlFor(ctx, "index"), Http302)

# /register
proc registerHandler*(ctx: Context) {.async.} =
  let db = open(consts.dbPath, "", "", "")
  if ctx.request.reqMethod == HttpPost:
    var error: string
    let
      username = ctx.getPostParams("username")
      password = pbkdf2_sha256encode(SecretKey(ctx.getPostParams(
              "password")), "Prologue")
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
      resp htmlResponse(registerPage(ctx, "Register", error))
  else:
    resp htmlResponse(registerPage(ctx, "Register"))

  db.close()

let
  indexPatterns* = @[
    pattern("/", index, @[HttpGet], name = "index"),
    pattern("/race/{race}", showRace, @[HttpGet, HttpPost], name = "race"),
    pattern("/leaderboard/{season}", showLeaderboard, @[HttpGet], name = "leaderboard"),
  ]
  authPatterns* = @[
    pattern("/login", loginHandler, @[HttpGet, HttpPost], name = "login"),
    pattern("/register", registerHandler, @[HttpGet, HttpPost]),
    pattern("/logout", logoutHandler, @[HttpGet, HttpPost]),
  ]

let 
    env = loadPrologueEnv("src/.env")
    settings = newSettings(appName = env.get("appName"),
      debug = env.getOrDefault("debug", true),
      port = Port(env.getOrDefault("port", 3003)),
      secretKey = env.getOrDefault("secretKey", "")
    )

initdb.initDb()
var app = newApp( settings = settings )

app.use(staticFileMiddleware(env.get("staticDir")), sessionMiddleware(settings, path = "/"))
app.addRoute(indexPatterns, "")
app.addRoute(authPatterns, "/auth")
app.run()
