{BufferedProcess} = require 'atom'
notifier = require './notifier'

module.exports = rsync =
  cmd: (args, options={ env: process.env.PATH, cwd: atom.project.getPaths()[0] }) ->
    notifier.addInfo('Syncing workspace...')
    new Promise (resolve, reject) ->
      output = ''
      process = new BufferedProcess
        command: atom.config.get('vagrant-rsync.vagrantPath') ? 'vagrant'
        args: args
        options: options
        stdout: (data) -> output += data.toString()
        stderr: (data) -> output += data.toString()
        exit: (code) ->
          if code is 0
            notifier.addSuccess(output)
            resolve output
          else
            notifier.addError(output)
            reject output
      process.onWillThrowError (errorObject) ->
        notifier.addError 'An error occurred.'
        reject 'An error occurred.'

  manual: ->
    rsync.cmd(['rsync'])
