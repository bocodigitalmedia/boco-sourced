SourcedError = require './SourcedError'

class EventHandlerUndefined extends SourcedError
  setDefaults: ->
    @message ?= "Event handler undefined."
    super()
    
module.exports = EventHandlerUndefined
