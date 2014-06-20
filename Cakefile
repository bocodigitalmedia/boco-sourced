ChildProcess = require 'child_process'
async = require 'async'
logger = console

COFFEE_PATH = "./node_modules/.bin/coffee"
MODULE_NAME = require('./package.json').name

# helper methods

rethrow = (error) -> throw error if error?

exec = (command, callback = rethrow) ->
  logger.log "• #{command}"

  proc = ChildProcess.exec command

  proc.stdout.pipe process.stdout
  proc.stderr.pipe process.stderr

  proc.on 'error', (error) ->
    logger.error 'An error occurred', error
    callback error if callback?

  proc.on 'exit', (code, signal) ->
    if code is 0
      callback(null)
    else
      callback new Error("Process exited with code: #{code}")

coffee = (args, done) ->
  exec "#{COFFEE_PATH} #{args}", done

# Task methods

compile = (done) ->
  coffee '--compile --map --output ./package/ ./coffee/', done

linkToGlobal = (done) ->
  exec 'npm link', done

linkLocally = (done) ->
  exec "npm link #{MODULE_NAME}", done

test = (done) ->
  coffee '--literate ./README.md', done

task 'compile', 'Compile coffee files', ->
  compile rethrow

task 'test', 'Execute tests', ->
  async.series [compile, linkToGlobal, linkLocally, test], rethrow
