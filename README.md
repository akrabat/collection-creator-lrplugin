# Keywords to Collections Lightroom Plug-in

This plug-in for Lightroom Classic will take a hierarchy of keywords that exist under a top level
root keyword and create a set of collections within collection sets under a top level root 
collection set.

## Installation

* Download the [release zip][1] file and extract it.
* Move `collection-creator.lrplugin` to the directory where you keep your Lightroom plug-ins.
* In Lightroom Classic, go to _File -> Plug-in Manager..._:
    * Click _Add_ at the bottom of the left hand list.
    * Click _Enable_ in the _Status_ section for the Collection Creator plugin.
    * Navigate to and select `collection-creator.lrdevplugin` and click _Add Plug-in_
    * Close the Plug-in Manager by clicking _Done_.


[1]: https://github.com/akrabat/collection-creator.lrplugin/archive/1.0.0.zip

## Running the plug-in

To run the plug-in, click _Library -> Plug-in Extras -> Create Collections_

This will:

1. Create a collection called "_\_Keyword Collections_" if it doesn't already exist
2. Create a keyword called "_\_Keywords To Become Collections_" if it doesn't already exist

If the "_\_KeywordsToBecomeCollections_" keyword has been created by the plug-in or is empty,
then a message will be displayed and the process will stop. You now need to place the keyword
hierarchy that you wish to be converted to collections within collection setsinside this
keyword and _Create Collections_ run again.

If there are child keywords within the "_\_KeywordsToBecomeCollections_" keyword, then the plug-in
will iterate through every child keyword (and their children):

* For each keyword that has a child keyword, it will create a collection set of the same name.
* For each keyword that does not have a child keyword, it will create collection of the same name
  and add all photos with that keyword to the collection.

The end result is that you will have a set of collections inside collection sets that match the
keyword hierarchy.


## Development notes

* `collection-creator.lrplugin` is a directory and can be renamed to `collection-creator.lrdevplugin`
  so that macOS doesn't treat it as a package.
* Change the variables `rootCollectionSetName` and `rootKeywordName` if you want to use a different
  root collection set or keyword.
* Logs go to the console. On Mac, sart Console.app and search for "AkrabatCollectionCreator" to
  filter for just the logs from this plug-in.
* Changing `CreateCollections.lua` doesn't require reloading the plug-in. Changing `Info.lua` does
  though.