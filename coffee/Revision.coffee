Event = require './Event'

module.exports = class Revision
  constructor: (props = {}) ->
    @resourceType = props.resourceType
    @resourceId = props.resourceId
    @resourceVersion = props.resourceVersion
    @events = props.events
    @setDefaults()

  setDefaults: ->
    @events = []

  addEvent: (type, payload = {}) ->
    event = new Event
      resourceType: @resourceType,
      resourceId: @resourceId,
      resourceVersion: @resourceVersion,
      type: type,
      payload: payload,
      index: @events.length

    @events.push event
    return event
