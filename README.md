boco-sourced
================================================================================

Sourced is a module designed to support [event sourcing] in javascript. It provides methods for storing revisions (collections of events that have occurred atomically within a resource's lifecycle) as well as building views of resources through the application of events.

It is designed to be highly configurable, supporting any reasonable form of storage through [storage adapters].


Installation
--------------------------------------------------------------------------------

Install Sourced by using [npm]:

```sh
npm install boco-sourced
```

README Driven Development
--------------------------------------------------------------------------------

This document is written in [literate coffeescript]. When executed via the `coffee` command, the examples in this document act as high-level tests for the library itself. I've been calling this "Readme Driven Development", or RDD for short. I think it's pretty neat.

```sh
# test all the things
coffee -l docs/*.coffee.md
```


Usage
================================================================================

For the examples in this document, we will require the `sourced` module:

    Sourced = require 'boco-sourced'

In addition, the `assert` library will be used to demonstrate the results of various methods:

    assert = require 'assert'


Configuration
--------------------------------------------------------------------------------

The dependencies necessary for Sourced are injected via a configuration object. Let's create a simple object and then step through each dependency one by one, adding them to the `config` as we go.

    config = {}

### config.storage

Sourced needs to know how to persist data. The core library comes with a simple `MemoryStorage` adapter, which is useful for testing. Let's use that for now.

    config.storage = new Sourced.MemoryStorage()

For real applications, you will want to use one of the persisted [storage adapters] or write your own.


Create the service object
--------------------------------------------------------------------------------

Now that we have our configuration ready, let's get an instance of the service object we will use by calling the `createService` method:

    sourced = Sourced.createService config

Note that each of our configured dependencies appears as a property on the service object:

    assert.equal config.storage, sourced.storage


Creating revisions
--------------------------------------------------------------------------------

A revision represents a collection of events that have occurred atomically at a given point within a resource's lifecycle. To create a revision, pass in the resource `type`, `identity`, and the `version` of that resource to the service's `createRevision` method:

    userId = 'fcc6b227-3e52-40af-a1a3-b276ecf97daa'
    revision = sourced.createRevision 'User', userId, 5

The revision object should know about its associated resource:

    assert.equal 'User', revision.resourceType
    assert.equal 'fcc6b227-3e52-40af-a1a3-b276ecf97daa', revision.resourceId
    assert.equal 5, revision.resourceVersion

### Defaults

You may omit both the `identity` and `version` parameters, and sane defaults will be applied.

#### revision.resourceId

By default, a [uuid] will be generated for the resource's identity.

You can override the default uuid generator by replacing the `generateUUId` method with your own. Let's demonstrate that behavior:

    sourced.generateUUId = -> '83ff08d6-d23c-4431-8613-dd5aa3da5e4b'

    revision = sourced.createRevision 'User'
    assert.equal '83ff08d6-d23c-4431-8613-dd5aa3da5e4b', revision.resourceId

We don't want to leave that stubbed generator method there, so let's restore the original. Since the original method was defined on the service's `prototype`, we can just delete the overriden property:

    delete sourced.generateUUId

#### revision.resourceVersion

By default, the resource `version` will be set to `0`, meaning that the revision applies to a resource that has had no previous revisions in its lifecycle.

    assert.equal 0, revision.resourceVersion


Adding events to a revision
--------------------------------------------------------------------------------

A revision must contain one or more events. Let's add a single event to our initial revision by passing in the event's `type` and `payload`:

    revision.addEvent 'Registered',
      username: 'john.doe', email: 'john.doe@example.com'


The revision maintains a collection of the events that have been added:

    assert.equal 1, revision.events.length

You can access the events by their index, just like an array:

    event = revision.events[0]

Each event will hold a reference to the resource:

    assert.equal 'User', event.resourceType
    assert.equal '83ff08d6-d23c-4431-8613-dd5aa3da5e4b', event.resourceId
    assert.equal 0, event.resourceVersion

They also contain their `type`, and an `index` of the order in which they were added:

    assert.equal 'Registered', event.type
    assert.equal 0, event.index

The payload that they were assigned upon creation is accessible via the `payload` property:

    assert.equal 'john.doe', event.payload.username
    assert.equal 'john.doe@example.com', event.payload.email


Storing revisions
--------------------------------------------------------------------------------

Now that we have an initial revision for our User, it needs to be persisted to storage so that we can rebuild our resource at a later point. To store a revision, call the `storeRevision` method, passing the `revision` object and an optional `callback` method:

    sourced.storeRevision revision, (error) ->
      throw error if error?

### Revision conflicts

If you attempt to store a revision of a resource with a version that has previously been stored, a revision conflict will be raised:

      sourced.storeRevision revision, (error) ->
        assert error instanceof Sourced.RevisionConflict

### Sequence errors

If you attempt to store a revision with a version that is not in sequence (ie: it is not exactly 1 more than the previous version), a sequence error will be raised:

      rev2 = sourced.createRevision 'User', revision.resourceId, 2

      sourced.storeRevision rev2, (error) ->
        assert error instanceof Sourced.RevisionOutOfSequence


Defining a schema
--------------------------------------------------------------------------------

In order for Sourced to hydrate resources, you need to tell the service about the events for each resource type and how they are applied. Let's create a new schema by calling `createSchema` and passing in the resource `type`:

    schema = sourced.createSchema 'User'
    assert.equal 'User', schema.resourceType

### schema.constructResource

The schema defines a method for constructing your resource, given its identity. By default, it creates a generic `Resource` instance:

    user = schema.constructResource '89e43652-9288-404e-a047-2fe94491ef29'

    assert user instanceof Sourced.Resource
    assert.equal '89e43652-9288-404e-a047-2fe94491ef29', user.id
    assert.equal 0, user.version

You may want to define your own resource class instead:

    class User extends Sourced.Resource

      constructor: (props = {}) ->
        @id = props.id
        @version = props.version
        @setDefaults()

      setDefaults: ->
        @version = 0 unless @version?

You can then override the `constructResource` method to return an instance of that class:

    schema.constructResource = (resourceId) ->
      new User id: resourceId

The schema will now construct a new `User` resource:

    user = schema.constructResource '89e43652-9288-404e-a047-2fe94491ef29'

    assert user instanceof User
    assert.equal '89e43652-9288-404e-a047-2fe94491ef29', user.id
    assert.equal 0, user.version

### schema.setResourceVersion

It is useful to maintain a property reflecting the current version of a resource on the model itself. As each revision is applied during hydration, the `setResourceVersion` method of the schema will be called, passing in the `resource` and `version`. By default, it simply sets the `version` property of the given `resource` and returns it:

    user = schema.setResourceVersion user, 1
    assert.equal 1, user.version

You can override this method if you like, perhaps to use a different property name for maintaining the version. The default seems just fine for this example, and it's unlikely that you'll need to change this behavior.

### schema.defineEventHandler

Event handlers apply events to the resource during hydration. To define them, call the `defineEventHandler` method, passing in the event `type`, followed by a `handler` method that accepts the `resource` and `event`. This method *must* return an object representing the resource after the event has been applied.

Let's go ahead and define how the `Registered` and `ProfileUpdated` events affect a `user` model.

    schema.defineEventHandler 'Registered', (user, event) ->
      user.username = event.payload.username
      user.email = event.payload.email
      return user

    schema.defineEventHandler 'ProfileUpdated', (user, event) ->
      user.name = event.payload.name
      user.title = event.payload.title
      return user

The schema should know about the types of events it can handle:

    assert schema.isEventHandlerDefined('Registered')
    assert schema.isEventHandlerDefined('ProfileUpdated')
    assert !schema.isEventHandlerDefined('SomeUndefinedEvent')

Let's test the behavior of the `Registered` event with a mock object:

    registered = type: 'Registered', payload:
      username: 'foo.bar', email: 'foo.bar@example.com'

    user = schema.applyEvent user, registered
    assert.equal 'foo.bar', user.username
    assert.equal 'foo.bar@example.com', user.email

As well as our handler for `ProfileUpdated`:

    profileUpdated = type: 'ProfileUpdated', payload:
      name: 'Foo Bar', title: 'Foo Bar Baz'

    user = schema.applyEvent user, profileUpdated
    assert.equal 'Foo Bar', user.name
    assert.equal 'Foo Bar Baz', user.title

Applying an event that has no defined handler should throw an `EventHandlerUndefined` error:

    undefinedEvent = type: 'UndefinedEvent', payload: { foo: 'bar' }

    shouldThrow = ->
      schema.applyEvent user, undefinedEvent

    isCorrectError = (error) ->
      error instanceof Sourced.EventHandlerUndefined

    assert.throws shouldThrow, isCorrectError

Registering a schema
--------------------------------------------------------------------------------

Now that we have defined our schema, let's register it with the service:

    sourced.registerSchema schema

The service should know about the resource types it has a registered schema for:

    assert sourced.isSchemaRegisteredFor('User')
    assert !sourced.isSchemaRegisteredFor('UndefinedResource')

Hydrating a resource
--------------------------------------------------------------------------------

Event sourcing allows us to rebuild views of our resources by applying events. In Sourced, we call this process *hydration*.

### Setup

For these examples, we'll be working with a `User` resource with the following id:

    userId = '89e43652-9288-404e-a047-2fe94491ef29'

Let's say that at some point, the user has registered:

    rev0 = sourced.createRevision 'User', userId

    rev0.addEvent 'Registered',
      username: 'john.doe', email: 'john.doe@example.com'

    sourced.storeRevision rev0, (error) ->
      throw error if error?

Let's add another revision, in which the user updated their profile information:

      rev1 = sourced.createRevision 'User', userId, 1

      rev1.addEvent 'ProfileUpdated',
        name: 'John Doe', title: 'Software Developer'

      sourced.storeRevision rev1, (error) ->
        throw error if error?

### Hydrate a resource

To hydrate a resource, just call the `hydrate` method, passing in the resource `type` and `identity`, followed by a `callback` that accepts an `error` and the hydrated `resource`:

        sourced.hydrate 'User', userId, (error, user) ->
          throw error if error?

The resource should have its `id` and `version` set:

          assert.equal '89e43652-9288-404e-a047-2fe94491ef29', user.id
          assert.equal 2, user.version

The first revision should have set the `username` and `email` by applying the `Registered` event:

          assert.equal 'john.doe', user.username
          assert.equal 'john.doe@example.com', user.email

The second revision should have set the `name` and `title` by applying the `ProfileUpdated` event:

          assert.equal 'John Doe', user.name
          assert.equal 'Software Developer', user.title



[storage adapters]: http://github.com/bocodigitalmedia/boco-sourced/blob/master/docs/storage-adapters.coffee.md
[sinon]: http://sinonjs.org
[uuid]: http://wikipedia.org/wiki/Uuid
[promise]: http://promises-aplus.github.io/promises-spec/
[event sourcing]: http://martinfowler.com/eaaDev/EventSourcing.html
[npm]: http://npmjs.org
[literate coffeescript]: http://coffeescript.org/#literate
