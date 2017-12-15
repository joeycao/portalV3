local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"
local json_util = require "portal.common.json_util"

function load(name)
  plugin =  "portal.abtesting.sticky.plugin."..name
  log.debug("stickies:match:load["..plugin.."]")
  return require (plugin)
end

function _M.match(name)
  name = name or "empty"
  return (load(name) or load("empty"))
end

return _M
