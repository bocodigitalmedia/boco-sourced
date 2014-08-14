module.exports = class Event

  constructor: (props = {}) ->
    @resourceType = props.resourceType
    @resourceId = props.resourceId
    @resourceVersion = props.resourceVersion
    @index = props.index
    @type = props.type
    @setPayload props.payload

  setPayload: (payload) ->
    @payload = constructPayload payload

  constructPayload: (properties = {}) ->
    return properties
