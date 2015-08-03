app = require 'app'
BrowserWindow = require 'browser-window'
mainWindow = null
path = require 'path'
cp = require 'child_process'

handleStartupEvent = ->
  if process.platform isnt 'win32' then return false
  executeSquirrelCommand = (args, done) ->
    updateDotExe = path.resolve path.dirname(process.execPath), '..', 'update.exe'
    child = cp.spawn updateDotExe, args, detatched: true
    child.on 'close', (code) ->
      done?()
  install = (done) ->
    target = path.basename process.execPath
    executeSquirrelCommand ['--createShortcut', target], done
  uninstall = (done) ->
    target = path.basename process.execPath
    executeSquirrelCommand ['--removeShortcut', target], done
  squirrelCommand = process.argv[1]
  switch squirrelCommand
    when '--squirrel-install'
      install app.quit
      return true
    when '--squirrel-updated'
      install app.quit
      return true
    when '--squirrel-uninstall'
      uninstall app.quit
      return true
    when '--squirrel-obsolete'
      app.quit()
      return true
    else
      return false

if handleStartupEvent()
  return
 
app.on 'window-all-closed', ->
  if process.platform isnt 'darwin' then app.quit()
  
app.on 'ready', ->
  screen = require 'screen'
  size = screen.getPrimaryDisplay().workAreaSize
  mainWindow = new BrowserWindow
    width: size.width
    height: size.height
    frame: false
    transparent: true
  mainWindow.loadUrl 'file://' + __dirname + '/index.html'
  mainWindow.on 'closed', ->
    mainWindow = null