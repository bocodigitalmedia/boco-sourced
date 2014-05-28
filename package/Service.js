// Generated by CoffeeScript 1.6.3
(function() {
  var MemoryStorage, Revision, Schema, Service;

  MemoryStorage = require('./MemoryStorage');

  Revision = require('./Revision');

  Schema = require('./Schema');

  module.exports = Service = (function() {
    function Service(config) {
      if (config == null) {
        config = {};
      }
      this.storage = config.storage;
      this.schemas = config.schemas;
      this.setDefaults();
    }

    Service.prototype.setDefaults = function() {
      if (this.storage == null) {
        this.storage = new MemoryStorage();
      }
      return this.schemas = {};
    };

    Service.prototype.generateUUId = function() {
      return require('uuid').v4();
    };

    Service.prototype.createRevision = function(type, uuid, version) {
      if (version == null) {
        version = 0;
      }
      if (uuid == null) {
        uuid = this.generateUUId();
      }
      return new Revision({
        resourceType: type,
        resourceId: uuid,
        resourceVersion: version
      });
    };

    Service.prototype.storeRevision = function(revision, callback) {
      return this.storage.store(revision, callback);
    };

    Service.prototype.createSchema = function(resourceType) {
      return new Schema({
        resourceType: resourceType
      });
    };

    Service.prototype.registerSchema = function(schema) {
      return this.schemas[schema.resourceType] = schema;
    };

    Service.prototype.isSchemaRegisteredFor = function(type) {
      return this.schemas.hasOwnProperty(type);
    };

    Service.prototype.hydrate = function(type, id, callback) {
      var resource, schema;
      schema = this.schemas[type];
      resource = schema.constructResource(id);
      return this.storage.findRevisions(type, id, function(error, revisions) {
        if (error != null) {
          return callback(error);
        }
        revisions.forEach(function(revision) {
          var version;
          version = revision.resourceVersion + 1;
          resource = schema.setResourceVersion(resource, version);
          return revision.events.forEach(function(event) {
            return resource = schema.applyEvent(resource, event);
          });
        });
        return callback(null, resource);
      });
    };

    return Service;

  })();

}).call(this);

/*
//@ sourceMappingURL=Service.map
*/
