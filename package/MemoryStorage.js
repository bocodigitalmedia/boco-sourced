// Generated by CoffeeScript 1.6.3
(function() {
  var MemoryStorage, RevisionConflict, RevisionOutOfSequence,
    __hasProp = {}.hasOwnProperty;

  RevisionConflict = require('./RevisionConflict');

  RevisionOutOfSequence = require('./RevisionOutOfSequence');

  module.exports = MemoryStorage = (function() {
    function MemoryStorage(props) {
      if (props == null) {
        props = {};
      }
      this.collection = props.collection;
      this.setDefaults();
    }

    MemoryStorage.prototype.setDefaults = function() {
      if (this.collection == null) {
        return this.collection = {};
      }
    };

    MemoryStorage.prototype.findRevisions = function(type, id, callback) {
      var key, revision, revisions, _ref;
      revisions = [];
      _ref = this.collection;
      for (key in _ref) {
        if (!__hasProp.call(_ref, key)) continue;
        revision = _ref[key];
        if (revision.resourceType === type && revision.resourceId === id) {
          revisions.push(revision);
        }
      }
      return callback(null, revisions);
    };

    MemoryStorage.prototype.storeRevision = function(revision, callback) {
      var error, previousId, revisionId;
      revisionId = [revision.resourceType, revision.resourceId, revision.resourceVersion].join(',');
      if (this.collection[revisionId] != null) {
        error = new RevisionConflict();
        return callback(error);
      }
      previousId = [revision.resourceType, revision.resourceId, revision.resourceVersion - 1].join(',');
      if (!(revision.resourceVersion === 0 || (this.collection[previousId] != null))) {
        error = new RevisionOutOfSequence();
        return callback(error);
      }
      this.collection[revisionId] = revision;
      return callback();
    };

    return MemoryStorage;

  })();

}).call(this);

/*
//@ sourceMappingURL=MemoryStorage.map
*/
