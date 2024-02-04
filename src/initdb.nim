import std/[db_sqlite, os, strutils, logging]

import ./consts 

proc initDb*(dbPath:string) =
  if not fileExists(dbPath):
    let
      db = open(dbPath, "", "", "")
      schema = readFile(schemaPath)
    for line in schema.split(";"):
      if line == "\c\n" or line == "\n":
        continue
      db.exec(sql(line.strip))
    db.close()
    logging.info("Initialized the database.")
