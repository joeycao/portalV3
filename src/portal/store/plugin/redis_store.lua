local _M = {}
_M._data = '1.0'
_M.name = "redis_store"
local mt = { __index = _M }
local log = require "portal.common.log"
local lfs = require "lfs"
local file_util = require "portal.common.file_util"
local json_util = require "portal.common.json_util"
local now          = ngx.now
local var          = ngx.var


function _M.query(pattern)
  log.debug("file_store:query["..pattern.."]")
  local table ={}
  return table
end

function _M.get(id)
  log.debug("file_store:get["..id.."]")
end

function _M.save_update(id,data)
  log.debug("file_store:save_update["..#data.."]")
end

function _M.delete(id)
  log.debug("file_store:delete["..id.."]")
end

return _M
