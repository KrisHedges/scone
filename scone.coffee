child_process = require 'child_process'
fs = require 'fs'

scone =
  process: null
  files: []
  restarting: false

  "coffeewatch": ->
    coffee = child_process.exec 'coffee -o '+process.cwd()+' -w -l -c '+process.cwd()+'/coffee/*.coffee'
    console.log "Making Coffee"
    coffee.stdout.addListener 'data', (data) ->
      process.stdout.write data, encoding='utf8'
    coffee.stderr.addListener 'data', (data) ->
      process.stdout.write data, encoding='utf8'

  "styluswatch": ->
    stylus = child_process.exec 'stylus -o '+process.cwd()+'/public/css -w -c '+process.cwd()+'/views/stylus'
    console.log "With Styl"
    stylus.stdout.addListener 'data', (data) ->
      process.stdout.write data, encoding='utf8'
    stylus.stderr.addListener 'data', (data) ->
      process.stdout.write data, encoding='utf8'

  "restart": ->
    this.restarting = true
    console.log "Stopping server for restart"
    this.process.kill()

  "start": ->
    self = this
    console.log 'Starting Node App'
    self.watchFiles()
    this.process = child_process.spawn(process.ARGV[0], ['app.js'])

    this.process.stdout.addListener 'data', (data) ->
      process.stdout.write data
     this.process.stderr.addListener 'data', (data) ->
      console.log data

    this.process.addListener 'exit', (code) ->
      console.log 'App Exited: ' + code
      this.process = null
      if self.restarting
        self.restarting = true
        self.unwatchFiles()
        self.start()

  "watchFiles": ->
    self = this
    child_process.exec 'find . | grep "\.js$"', (error, stdout, stderr) ->
      files = stdout.trim().split("\n")
      files.forEach (file) ->
        self.files.push(file)
        fs.watchFile file, interval : 500, (curr, prev) ->
          if curr.mtime.valueOf() != prev.mtime.valueOf() || curr.ctime.valueOf() != prev.ctime.valueOf()
            console.log 'Restarting because of changed file at ' + file
            scone.restart()

  "unwatchFiles": ->
    this.files.forEach (file) ->
      fs.unwatchFile(file)
    this.files = []

startitup = ->
  scone.coffeewatch()
  setTimeout ->
    scone.styluswatch()
  ,1000
  setTimeout ->
    scone.start()
  ,2000

startitup()
