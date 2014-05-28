module.exports = class Event

  constructor: (props = {}) ->
    @resourceType = props.resourceType
    @resourceId = props.resourceId
    @resourceVersion = props.resourceVersion
    @index = props.index
    @type = props.type
    @payload = props.payload
