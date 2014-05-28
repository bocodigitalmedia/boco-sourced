Storage Adapters
================================================================================

In order to persist revisions, you need to configure Sourced with one of the available storage adapters. If you don't see an adapter for the database of your choice, you have two options:

1. [Request an adapter] for the database you're using
2. [Create an adapter] yourself

### Available Adapters

* __MongoDb__
  * [sourced-storage-mongojs] uses the MongoJs library for MongoDb

Request an adapter
--------------------------------------------------------------------------------

To request an adapter:

1. Go to the [sourced-storage-abstract] repository and [create an issue]
2. In the title field, type something like "Adapter request: MyDatabase", where "MyDatabase" is the name of the database you're using
3. Add a brief description to the issue
4. Under "Add Labels", click "enhancement"
5. Submit the issue

Create an Adapter
--------------------------------------------------------------------------------

If you'd like to create your own storage adapter for Sourced, follow the instructions below.

### Select a name for your repository

If you are creating an adapter for postgresql using the `pg` library, name your repository `sourced-storage-pg`. Head over to http://npmjs.org and make sure a package with that name does not currently exist.

### Fork the abstract repository

The `sourced-storage-abstract` repository serves as a good starting point for creating your adapter. Head over to the [sourced-storage-abstract] repository page on github, or just [fork the repository] right now. 


<!-- Links below this comment -->

[sourced-storage-mongojs]: https://github.com/christianbradley/sourced-storage-mongojs

[sourced-storage-abstract]: https://github.com/christianbradley/sourced-storage-abstract

[fork the repository]: https://github.com/christianbradley/sourced-storage-abstract/fork

[create an issue]: https://github.com/christianbradley/sourced-storage-abstract/issues/new

[create an adapter]: #create-an-adapter
[request an adapter]: #request-an-adapter
