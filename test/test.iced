{Generator} = require '../lib/main.js'

g = new Generator()
g.generate 64, (vals) ->
  console.log vals.join ","
  await setTimeout defer(), 1000
  console.log "killing"
  g.kill()
  console.log "killed and waiting a sec"
  await setTimeout defer(), 1000
  console.log "exiting"
  process.exit 0
