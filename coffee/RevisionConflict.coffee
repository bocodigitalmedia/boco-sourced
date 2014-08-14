SourcedError = require './SourcedError'

class RevisionConflict extends SourcedError
  setDefaults: ->
    @message ?= 'A conflict has occurred with an existing revision.'
    super()

module.exports = RevisionConflict
