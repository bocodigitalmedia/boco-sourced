// Generated by CoffeeScript 1.6.3
(function() {
  var RevisionConflict, SourcedError, _ref,
    __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  SourcedError = require('./SourcedError');

  RevisionConflict = (function(_super) {
    __extends(RevisionConflict, _super);

    function RevisionConflict() {
      _ref = RevisionConflict.__super__.constructor.apply(this, arguments);
      return _ref;
    }

    RevisionConflict.prototype.setDefaults = function() {
      if (this.message == null) {
        this.message = 'A conflict has occurred with an existing revision.';
      }
      return RevisionConflict.__super__.setDefaults.call(this);
    };

    return RevisionConflict;

  })(SourcedError);

  module.exports = RevisionConflict;

}).call(this);

/*
//@ sourceMappingURL=RevisionConflict.map
*/
