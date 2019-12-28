--[[-------------------------------------------------------------------------
Info.lua: Plug-in manifest file

Create a hierarchy of collections within collection sets from a set of
nested keywords.

Menu items:

* Library -> Plugin Extras -> Create Collections

---------------------------------------------------------------------------]]

--[[
See "Declaring the contents of a plug-in" in `Lightroom SDK Guide.pdf`
]]
return {
  VERSION = { major=1, minor=0, revision=0, },

  LrSdkVersion = 9.0,
  LrSdkMinimumVersion = 4.0,

  LrToolkitIdentifier = "com.akrabat.collection-creator",
  LrPluginName = "Collection Creator",
  LrPluginInfoUrl="https://github.com/akrabat/collection-creator.lrplugin",

  LrLibraryMenuItems = {
    {
      title = "Create Collections",
      file = "CreateCollections.lua",
    },
  },
}
