SourcedError = require './SourcedError'

class RevisionConflict extends SourcedError
  message: 'A conflict has occurred with an existing revision.'

module.exports = RevisionConflict
