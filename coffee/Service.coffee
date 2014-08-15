MemoryStorage = require './MemoryStorage'
Revision = require './Revision'
RevisionFactory = require './RevisionFactory'
EventFactory = require './EventFactory'
Schema = require './Schema'

class Service

  constructor: (config = {}) ->
    @storage = config.storage
    @schemas = config.schemas
    @revisionFactory = config.revisionFactory
    @eventFactory = config.eventFactory
    @setDefaults()

  setDefaults: ->
    @storage ?= new MemoryStorage()
    @revisionFactory ?= new RevisionFactory()
    @eventFactory ?= new EventFactory()
    @schemas ?= {}

  createRevision: (domain, type, uuid, version = 0) ->
    @revisionFactory.construct
      domain: domain
      resourceType: type
      resourceId: uuid
      resourceVersion: version

  createEvent: (type, payload) ->
    @eventFactory.construct type, payload: payload

  storeRevision: (revision, callback) ->
    @storage.storeRevision revision, callback

  createSchema: (resourceType) ->
    new Schema resourceType: resourceType

  registerSchema: (schema) ->
    @schemas[schema.resourceType] = schema

  isSchemaRegisteredFor: (type) ->
    @schemas.hasOwnProperty type

  hydrate: (domain, type, id, callback) ->
    schema = @schemas[type]
    resource = schema.constructResource id

    # TODO this may not handle large sets of revisions well...
    @storage.findRevisions domain, type, id, (error, revisions) ->
      return callback(error) if error?

      revisions.forEach (revision) ->
        version = revision.resourceVersion + 1
        resource = schema.setResourceVersion resource, version

        revision.events.forEach (event) ->
          resource = schema.applyEvent resource, event

      callback null, resource

module.exports = Service
