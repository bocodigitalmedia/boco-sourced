ChildProcess = require 'child_process'

COFFEE_PATH = "./coffee"
TESTS_PATH = "./docs"
BUILD_PATH = "./package"

logger = console

# helper methods

noop = (error, results...) ->
  logger.error error if error?

spawn = (command, args, options, callback = noop) ->
  str = '• ' + command + ' ' + args.join ' '
  logger.log str

  proc = ChildProcess.spawn command, args, options

  proc.stdout.pipe process.stdout
  proc.stderr.pipe process.stderr

  proc.on 'error', (error) ->
    logger.error 'An error occurred', error
    callback error if callback?

  proc.on 'exit', (code, signal) ->
    (callback null, code, signal) if callback?

# Task methods

compile = (options, callback = noop) ->
  args = ['-cmo', BUILD_PATH, COFFEE_PATH]
  spawn 'coffee', args, null, callback

install = (options, callback = noop) ->
  spawn 'npm', ['install', BUILD_PATH], null, callback

test = (options, callback = noop) ->
  if options.file?
    spawn 'coffee', ['-l', options.file], null, callback
  else
    args = ['-l', options.file || TESTS_PATH]
    spawn 'coffee', args, null, callback

watch = (options, callback = noop) ->
  args = ['-cwmo', BUILD_PATH, COFFEE_PATH]
  spawn 'coffee', args, null, callback


option '-f', '--file [filename]', 'Use [filename] for the given task'
option '-v', '--verbose', 'Display additional information'

task 'compile', 'Compile coffee files', compile
task 'watch', 'Watch coffee files and compile', watch
task 'install', 'Install the sourced package for testing', install
task 'test', 'Execute tests', test
