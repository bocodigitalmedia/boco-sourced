SourcedError = require './SourcedError'

module.exports = class RevisionConflict extends SourcedError
  message: 'A conflict has occurred with an existing revision.'
