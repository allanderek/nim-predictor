import prologue
import std/[db_sqlite, strformat]
import karax / [karaxdsl, vdom]
import prologue/security/hasher
import prologue/middlewares/signedcookiesession
import prologue/middlewares/staticfile

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
        h2: text "List all items"
        table:
            thead:
                tr:
                    th: text "ID"
                    th: text "Number"
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
                    th: text "Powertrain"
            tbody:
                for row in rows:
                    tr:
                        for col in row:
                            td: text col

proc entrants*(rows: seq[seq[string]]): VNode =
    result = buildHtml(section):
        h2: text "List all the teams"
        table:
            thead:
                tr:
                    th: text "Driver"
                    th: text "Team"
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
                  th: text "ID"
                  th: text "Name"
                  th: text "Country"
                  th: text "Circuit"
                  th: text "Date"
          tbody:
              for row in rows:
                tr:
                  for col in row:
                    td: 
                      a(href = "/race/" & row[0]):
                        text col  
        
proc getEntrants*(db: DbConn): seq[seq[string]] =
    let entrant_sql = """select e.id, d.name, t.shortname from entrants e inner join drivers d on e.driver = d.id inner join teams t on e.team = t.id"""
    result = db.getAllRows(sql(entrant_sql))

proc index*(ctx: Context) {.async.} =
    let db = open(consts.dbPath, "", "", "")

    let driver_rows = db.getAllRows(sql("""SELECT * FROM drivers"""))
    let team_rows = db.getAllRows(sql("""SELECT * FROM teams"""))
    let entrant_rows = getEntrants(db)
    let race_sql = """select * from races"""
    let race_rows = db.getAllRows(sql(race_sql))
    let head = sharedHead(ctx, "Formula E")
    let nav = sharedNav(ctx)
    let vNode = buildHtml(html):
        head
        nav
        main:
            section: drivers(rows=driver_rows)
            section: teams(rows=team_rows)
            section: entrants(rows=entrant_rows)
            section: races(rows=race_rows)

    resp htmlResponse("<!DOCTYPE html>\n" & $vNode)
    db.close()

proc predictionsForm(raceId: string, isResult: bool, current: seq[string], entrants: seq[seq[string]]) : VNode =
  let
    current_pole = current[0]
  result = buildHtml(form(`method` = "post")):
    label(`for` = "pole"): text "Pole"
    select(name = "pole"):
        for entrant in entrants:
            let
                entrant_id = entrant[0]
                entrant_name = entrant[1]
                entrant_team = entrant[2]

            option(value = entrant_id, selected = current_pole == entrant_id):
                text entrant_name
                text " : "
                text entrant_team
    if isResult:
      input(`type` = "hidden", name="isResult", value = "true")
    tdiv:
      input(`type` = "submit", value = "Save")

proc showRace* (ctx: Context) {.async.} =
  let
      db = open(consts.dbPath, "", "", "")
      race = db.getRow(sql"SELECT id, name, country, circuit, unixepoch() > unixepoch(date) as 'Closed' FROM races WHERE id = ?", ctx.getPathParams("race"))
  let head = sharedHead(ctx, "Formula E")
  let nav = sharedNav(ctx)
  let user_id = ctx.session.getOrDefault("userId")
  # TODO, Obviously we have to check if the userId is empty
  if race.len > 0:
    let 
        raceId = race[0]
        race_name = race[1]
        entrants = getEntrants(db)
        entryClosed = race[4] == "1"
    if ctx.request.reqMethod == HttpPost:
      let
        pole = ctx.getPostParams("pole")
        isResult = ctx.getPostParams("isResult") == "true"
      if isResult:
        # TODO: We have to check if the user is an admin
        db.exec(sql"insert into results (race, pole) values (?, ?)", raceId, pole)
      elif not entryClosed:
        db.exec(sql"insert into predictions (user, race, pole) values (?, ?, ?)", user_id, raceId, pole)
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
                predictions = db.getRow(sql"select pole from predictions where user = ? and race = ?", user_id, raceId)
              predictionsForm(raceId, false, predictions, entrants) 
            else:
              h3: text "Enter results"
                # TODO: We have to check if the user is an admin
              let 
                # TODO: This is non-robust to the case where there are no results set yet for this race
                currentResults = db.getRow(sql"select pole from results where race = ?", raceId)
              predictionsForm(raceId, true, currentResults, entrants) 
              h3: text "All predictions"
              let 
                  all_predictions = db.getAllRows(sql"select u.username, d.name from predictions p inner join users u on p.user = u.id inner join entrants e on e.id = p.pole inner join drivers d on e.driver = d.id where p.race = ?", race_id)
              table:
                tbody:
                  for row in all_predictions:
                    tr:
                      for col in row:
                        td: text col
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
