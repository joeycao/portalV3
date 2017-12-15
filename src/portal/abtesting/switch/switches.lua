local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"
local json_util = require "portal.common.json_util"

local function load(name)
  plugin =  "portal.abtesting.switch.plugin."..name
  log.debug("switchs:match:load["..plugin.."]")
  return require (plugin)
end

function _M.match(name)
  name = name or "firstly_v1"
  prog = (load(name) or load("firstly_v1"))
  log.debug("switchs:match:name["..prog.name.."]")
  return prog
end

return _M
