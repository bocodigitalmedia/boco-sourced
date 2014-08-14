Resource = require './Resource'
EventHandlerUndefined = require './EventHandlerUndefined'

class Schema

  constructor: (props = {}) ->
    @resourceType = props.resourceType
    @handlers = props.handlers
    @setDefaults()

  setDefaults: ->
    @handlers ?= {}

  constructResource: (resourceId) ->
    new Resource id: resourceId

  setResourceVersion: (resource, version) ->
    resource.version = version
    return resource

  defineEventHandler: (type, handler) ->
    @handlers[type] = handler

  isEventHandlerDefined: (type) ->
    @handlers.hasOwnProperty type

  applyEvent: (resource, event) ->
    handler = @handlers[event.type]

    unless handler?
      error = new EventHandlerUndefined
      error.setPayload type: event.type
      throw error

    handler.call null, resource, event

module.exports = Schema
