local _M = {}
_M._data = '1.0'
local mt = { __index = _M }
local log = require "portal.common.log"

function _M.query(pattern)
  log.debug("empty_store:query["..pattern.."]")
end

function _M.get(id)
  log.debug("empty_store:get["..id.."]")
end

function _M.save_update(object)
  log.debug("empty_store:save_update["..object.."]")
end

function _M.delete(id)
  log.debug("empty_store:delete["..key.."]")
end

return _M