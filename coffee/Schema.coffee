Resource = require './Resource'


module.exports = class Schema
  constructor: (props = {}) ->
    @resourceType = props.resourceType
    @handlers = props.handlers
    @setDefaults()

  setDefaults: ->
    @handlers = {}

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
    @handlers[event.type].call null, resource, event
