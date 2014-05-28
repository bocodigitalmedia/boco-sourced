MemoryStorage = require './MemoryStorage'
Revision = require './Revision'
Schema = require './Schema'

module.exports = class Service

  constructor: (config = {}) ->
    @storage = config.storage
    @schemas = config.schemas
    @setDefaults()

  setDefaults: ->
    @storage = new MemoryStorage() unless @storage?
    @schemas = {}

  generateUUId: ->
    require('uuid').v4()

  createRevision: (type, uuid, version = 0) ->
    uuid = @generateUUId() unless uuid?
    new Revision
      resourceType: type,
      resourceId: uuid,
      resourceVersion: version

  storeRevision: (revision, callback) ->
    @storage.store revision, callback

  createSchema: (resourceType) ->
    new Schema resourceType: resourceType

  registerSchema: (schema) ->
    @schemas[schema.resourceType] = schema

  isSchemaRegisteredFor: (type) ->
    @schemas.hasOwnProperty type

  hydrate: (type, id, callback) ->
    schema = @schemas[type]
    resource = schema.constructResource id

    @storage.findRevisions type, id, (error, revisions) ->
      return callback(error) if error?

      revisions.forEach (revision) ->
        version = revision.resourceVersion + 1
        resource = schema.setResourceVersion resource, version

        revision.events.forEach (event) ->
          resource = schema.applyEvent resource, event

      callback null, resource
