class Resource

  constructor: (props = {}) ->
    @id = props.id
    @version = props.version
    @setDefaults()

  setDefaults: ->
    @version ?= 0

module.exports = Resource
