Revision = require './Revision'

class RevisionFactory

  construct: (properties = {}) ->
    revision = new Revision(properties)
    @decorate revision
    return revision

  generateId: ->
    require('uuid').v4()

  decorate: (revision) ->
    revision.resourceId ?= @generateId()
    return revision

module.exports = RevisionFactory
