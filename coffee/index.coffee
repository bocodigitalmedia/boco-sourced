Sourced = exports

exports.Event = require './Event'
exports.EventHandlerUndefined = require './EventHandlerUndefined'
exports.MemoryStorage = require './MemoryStorage'
exports.Resource = require './Resource'
exports.Revision = require './Revision'
exports.RevisionConflict = require './RevisionConflict'
exports.RevisionOutOfSequence = require './RevisionOutOfSequence'
exports.Schema = require './Schema'
exports.Service = require './Service'
exports.SourcedError = require './SourcedError'

exports.createService = (config) ->
  new Sourced.Service config
