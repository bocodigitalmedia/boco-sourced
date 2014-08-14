MemoryStorage = require './MemoryStorage'
Revision = require './Revision'
RevisionFactory = require './RevisionFactory'
Schema = require './Schema'

class Service

  constructor: (config = {}) ->
    @storage = config.storage
    @schemas = config.schemas
    @revisionFactory = config.revisionFactory
    @setDefaults()

  setDefaults: ->
    @storage ?= new MemoryStorage()
    @revisionFactory ?= new RevisionFactory()
    @schemas ?= {}

  createRevision: (type, uuid, version = 0) ->
    @revisionFactory.construct
      resourceType: type,
      resourceId: uuid,
      resourceVersion: version

  storeRevision: (revision, callback) ->
    @storage.storeRevision revision, callback

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

module.exports = Service
