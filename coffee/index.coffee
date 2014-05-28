Sourced = exports

Sourced.Service = require './Service'
Sourced.Revision = require './Revision'
Sourced.MemoryStorage = require './MemoryStorage'
Sourced.RevisionConflict = require './RevisionConflict'
Sourced.RevisionOutOfSequence = require './RevisionOutOfSequence'
Sourced.Resource = require './Resource'
Sourced.Schema = require './Schema'

Sourced.createService = (config) ->
  new Sourced.Service config
