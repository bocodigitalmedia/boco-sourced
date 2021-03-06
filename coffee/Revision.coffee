Event = require './Event'

class Revision
  constructor: (props = {}) ->
    @domain = props.domain
    @resourceType = props.resourceType
    @resourceId = props.resourceId
    @resourceVersion = props.resourceVersion
    @events = props.events
    @setDefaults()

  setDefaults: ->
    @events ?= []

  addEvent: (event) ->
    event.domain ?= @domain
    event.resourceType ?= @resourceType
    event.resourceId ?= @resourceId
    event.resourceVersion ?= @resourceVersion
    event.index ?= @events.length
    @events.push event
    return event

module.exports = Revision
