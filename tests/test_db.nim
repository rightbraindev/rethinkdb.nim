import einheit
import asyncdispatch
import json
import math

import ../rethinkdb

testSuite DatabaseManipulationTests:
  var
    r: RethinkClient
    db: string

  method setup()=
    self.r = newRethinkClient()
    waitFor self.r.connect()
    self.r.repl()
    randomize()
    self.db = "test_db_" & $random(9999)


  method tearDown()=
    self.r.close()

  method testCreateDatabase()=
    let res = waitFor self.r.dbCreate(self.db).run()
    self.check(res["dbs_created"].num == 1)

  method testListDatabase()=
    let res = waitFor self.r.dbList().run()
    var found = false
    for x in res.items():
      if x.str == self.db:
        found = true
        break
    self.check(found)

  method testDropDatabase()=
    let res = waitFor self.r.dbDrop(self.db).run()
    self.check(res["dbs_dropped"].num == 1)

when isMainModule:
  runTests()
