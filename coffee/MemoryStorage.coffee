RevisionConflict = require './RevisionConflict'
RevisionOutOfSequence = require './RevisionOutOfSequence'

module.exports = class MemoryStorage
  constructor: (props = {}) ->
    @collection = props.collection
    @setDefaults()

  setDefaults: ->
    @collection = {} unless @collection?

  findRevisions: (type, id, callback) ->
    revisions = []

    for own key, revision of @collection
      if revision.resourceType is type and revision.resourceId is id
        revisions.push revision

    callback null, revisions

  store: (revision, callback) ->
    revisionId = [
        revision.resourceType,
        revision.resourceId,
        revision.resourceVersion
      ].join(',')

    if @collection[revisionId]?
      error = new RevisionConflict()
      return callback(error)

    previousId = [
      revision.resourceType,
      revision.resourceId,
      revision.resourceVersion - 1
    ].join(',')

    unless revision.resourceVersion is 0 or @collection[previousId]?
      error = new RevisionOutOfSequence()
      return callback(error)

    @collection[revisionId] = revision
    callback()
