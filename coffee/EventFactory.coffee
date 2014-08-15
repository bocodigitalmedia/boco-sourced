Event = require './Event'
TypeFactory = require('boco-factory').TypeFactory

class EventFactory extends TypeFactory

  construct: (type, properties) ->
    properties.type ?= type
    super type, properties

  setDefaults: ->
    @defaultConstructor ?= Event
    super()

module.exports = EventFactory
