import std/[db_sqlite, os, strutils, logging]

import ./consts 

proc runSchema(db:DbConn, pathToSchema:string) =
    let schema = readFile(pathToSchema)
    for line in schema.split(";"):
      if line == "\c\n" or line == "\n":
        continue
      db.exec(sql(line.strip))


proc initDb*(dbPath:string) =
  if not fileExists(dbPath):
    let
      db = open(dbPath, "", "", "")
    runSchema(db, schemaPath)
    runSchema(db, "src/formula_one_schema.sql")
    db.close()
    logging.info("Initialized the database.")
