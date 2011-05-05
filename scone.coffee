child_process = require 'child_process'
fs = require 'fs'

scone =
  process: null
  files: []
  restarting: false

  "makedir": (dir)->
    try
      fs.statSync dir
    catch error
      fs.mkdirSync dir, '0755'

  "appcoffeewatch": ->
    appcoffee = child_process.exec "coffee -o #{process.cwd()}/app -w -l -c #{process.cwd()}/src/app/**"
    console.log "Making App Coffee"
    this.captureOutput appcoffee

  "viewcoffeewatch": ->
    viewcoffee = child_process.exec "coffee -o #{process.cwd()}/public/js -w -l -c #{process.cwd()}/src/public/js/*.coffee"
    console.log "Making View Coffee"
    this.captureOutput viewcoffee

  "styluswatch": ->
    stylus = child_process.exec "stylus -o #{process.cwd()}/public/css -w -c #{process.cwd()}/src/public/css"
    console.log "With Styl"
    this.captureOutput stylus

  captureOutput: (proc)->
    proc.stdout.addListener 'data', (data) ->
      process.stdout.write data, encoding='utf8'
    proc.stderr.addListener 'data', (data) ->
      process.stdout.write data, encoding='utf8'

  "restart": ->
    this.restarting = true
    console.log "Stopping server for restart"
    this.process.kill()

  "start": ->
    self = this
    console.log 'Starting Node App'
    self.watchFiles()
    this.process = child_process.spawn(process.ARGV[0], ['app/app.js'])

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
    child_process.exec 'find app/. | grep "\.js$"', (error, stdout, stderr) ->
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
  scone.makedir "app"
  scone.makedir "public"
  scone.makedir "public/js"
  scone.makedir "public/css"
  scone.appcoffeewatch()
  scone.viewcoffeewatch()
  scone.styluswatch()
  setTimeout ->
    scone.start()
  ,2000

startitup()
