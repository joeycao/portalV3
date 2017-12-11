local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"
local json_util = require "portal.common.json_util"
local defatult_store  ="jsonfile_store"

local function load(name)
  plugin =  "portal.store.plugin."..name
  log.debug("storages:match:load["..plugin.."]")
  return require (plugin)
end

function _M.match(name)
  return (load(name or defatult_store) or load(defatult_store))
end

return _M
