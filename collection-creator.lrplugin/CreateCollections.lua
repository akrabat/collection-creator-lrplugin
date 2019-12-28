--[[-------------------------------------------------------------------------
CreateCollections.lua

Replicates keyword hierarchy under the `rootKeywordName` into set of
collections under `rootCollectionSetName`

---------------------------------------------------------------------------]]

-- Set the names of root keyword and root collection set - can be edited to taste
local rootCollectionSetName = '_Keyword Collections'
local rootKeywordName = "_Keywords To Become Collections"

-- Import the Lightroom SDK namespaces.
local LrApplication = import 'LrApplication'
local LrDialogs = import 'LrDialogs'
local LrLogger = import 'LrLogger'
local LrTasks = import 'LrTasks'

-- Set up the logger
local logger = LrLogger('AkrabatCollectionCreator')
logger:enable("print") -- set to "logfile" to write to ~/Documents/lrClassicLogs/AkrabatCollectionCreator.log
local log = logger:quickf('info')

--[[
Recursively process a set of keywords and add collections/collection sets as appropriate

For each keyword:
  - if it has children, create a collection set and then recursively call this function with the
    child keywords
  - if it has no children, then create an collection and add all photos with this keyword to it
]]
local function processKeywords(parentSet, keywords, sprefix)
  local catalog = LrApplication.activeCatalog()
  for _,keyword in ipairs(keywords) do
    local name = keyword:getName()
    log(" %s>%s", sprefix, name)

    local children = keyword:getChildren()
    if #children > 0 then
      -- we have children, so we need to create a collection set
      log("   Creating collection set %q (if it doesn't exist)", name)
      local collectionSet = catalog:createCollectionSet(name, parentSet, true)

      -- recursively process the child keywords of this keyword
      processKeywords(collectionSet, keyword:getChildren(), sprefix .. ">" .. name)
    else
      -- no children, so we need to create an album
      log("   Creating collection %q (if it doesn't exist)", name)
      local collection = catalog:createCollection(name, parentSet, true)
      log("   Adding photos to collection %q", name)
      collection:addPhotos(keyword:getPhotos())
    end
  end
end


--[[
This is the entry point function that's called when the Lightroom menu item is selected
]]
local function main ()
  log(" Starting")
  local catalog = LrApplication.activeCatalog()
  local rootSet = nil
  local rootKeyword = nil

  -- Create the root collection set and root keyword if they don't exist
  catalog:withWriteAccessDo("Create root collection set and keyword", function()
    rootSet = catalog:createCollectionSet(rootCollectionSetName, nil, true)
    log(" Created root collection set %q (if it didn't exist)", rootCollectionSetName)

    rootKeyword = catalog:createKeyword(rootKeywordName, {}, false, nil, true)
    log(" Created root keyword %q (if it didn't exist)", rootKeywordName)
  end)

  -- Create collections from child keywords of the root keyword
  catalog:withWriteAccessDo("Create collections from keywords", function()
    local childKeywords = rootKeyword:getChildren()
    if #childKeywords >0 then
      -- Process the child keywords (and their children) and create collections under rootSet
      processKeywords(rootSet, rootKeyword:getChildren(), "")
      LrDialogs.message("Collection Creator", "Collection sets and collections created", "info")
    else
      local msg = string.format("No keywords under %q to be converted to collections", rootKeywordName)
      log(msg)
      LrDialogs.message("Collection Creator", msg, "warning")
    end
    log(" Finished")
  end)
end

-- Run main()
LrTasks.startAsyncTask(main)
