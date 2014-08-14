SourcedError = require './SourcedError'

class RevisionOutOfSequence extends SourcedError
  message: 'The revision you are trying to store has a version that is out of sequence.'

module.exports = RevisionOutOfSequence
