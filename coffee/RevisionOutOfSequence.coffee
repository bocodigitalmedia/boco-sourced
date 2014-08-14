SourcedError = require './SourcedError'

class RevisionOutOfSequence extends SourcedError
  setDefaults: ->
    @message ?= 'The revision you are trying to store has a version that is out of sequence.'
    super()

module.exports = RevisionOutOfSequence
