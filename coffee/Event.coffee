module.exports = class Event

  constructor: (props = {}) ->
    @resourceType = props.resourceType
    @resourceId = props.resourceId
    @resourceVersion = props.resourceVersion
    @index = props.index
    @type = props.type
    @setPayload props.payload
    @setDefaults()

  setDefaults: ->
    @type ?= @constructor.name

  setPayload: (payload) ->
    @payload = @constructPayload payload

  constructPayload: (properties = {}) ->
    return properties
