Event = require './Event'

class EventFactory

  constructor: (properties = {}) ->
    @constructors = properties.constructors
    @defaultConstructor = properties.defaultConstructor
    @setDefaults()

  setDefaults: ->
    @constructors ?= {}
    @defaultConstructor ?= Event

  register: (constructors = {}) ->
    @constructors[key] = constructor for own key,constructor of constructors

  isRegistered: (type) ->
    @constructors.hasOwnProperty type

  getConstructor: (type) ->
    if @isRegistered(type) then @constructors[type] else @defaultConstructor

  construct: (type, properties) ->
    EventConstructor = @getConstructor type
    event = new EventConstructor properties
    event = @decorate event
    event.type = type
    return event

  decorate: (event) ->
    return event

module.exports = EventFactory
