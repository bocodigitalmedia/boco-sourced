RevisionConflict = require './RevisionConflict'
RevisionOutOfSequence = require './RevisionOutOfSequence'

class MemoryStorage
  constructor: (props = {}) ->
    @collection = props.collection
    @setDefaults()

  setDefaults: ->
    @collection ?= {}

  findRevisions: (domain, type, id, callback) ->
    revisions = []
    revisions.push rev for own key,rev of @collection when rev.resourceId is id
    callback null, revisions

  createRevisionId: (rev) ->
    [rev.domain, rev.resourceType, rev.resourceId, rev.resourceVersion].join ','

  exists: (revisionId) ->
    @collection.hasOwnProperty revisionId

  isOutOfSequence: (revision) ->
    return false if revision.resourceVersion is 0
    previousId = @createRevisionId
      domain: revision.domain
      resourceType: revision.resourceType
      resourceId: revision.resourceId
      resourceVersion: revision.resourceVersion - 1
    return !@exists previousId

  storeRevision: (revision, callback) ->
    revisionId = @createRevisionId revision

    if @exists revisionId
      error = new RevisionConflict()
      return callback(error)

    if @isOutOfSequence revision
      error = new RevisionOutOfSequence()
      return callback(error)

    @collection[revisionId] = revision
    callback()

module.exports = MemoryStorage
