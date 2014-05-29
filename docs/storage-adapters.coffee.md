Storage Adapters
================================================================================

In order to persist revisions, you need to configure Sourced with one of the available storage adapters. If you don't see an adapter for the database of your choice, you have two options:

1. [Request an adapter] for the database you're using
2. [Create an adapter] yourself

### Available Adapters

  * [boco-sourced-mongodb] official MongoDB storage adapter

Request an adapter
--------------------------------------------------------------------------------

To request an adapter:

1. Go to the [boco-sourced] repository and [create an issue]
2. In the title field, type something like "Adapter request: MyDatabase", where "MyDatabase" is the name of the database you're using
3. Add a brief description to the issue
4. Under "Add Labels", click "enhancement"
5. Submit the issue

Create an Adapter
--------------------------------------------------------------------------------

We're still working on the documentation for creating your own adapter. For now, you're better off requesting an adapter and then working with us to get it off the ground. We hope to have documentation very soon.

However, the interface for the storage adapter is fairly simple. Take a look at one of the available adapter repositories, and you should be able to hack something together quickly.

If you do create an adapter, please [create an issue] to let us know about it and we'll add it to the list of available adapters.

<!-- Links below this comment -->

[boco-sourced]: http://github.com/bocodigitalmedia/boco-sourced
[boco-sourced-mongodb]: http://github.com/bocodigitalmedia/boco-sourced-mongodb

[create an issue]: http://github.com/bocodigitalmedia/boco-sourced/issues/new

[create an adapter]: #create-an-adapter
[request an adapter]: #request-an-adapter
