local _M = {}
_M._data = '1.0'
local mt = { __index = _M }
local log = require "portal.common.log"
function _M.add(key,data)
  log.debug("empty_sticky:add["..key.."|"..data.."]")
end

function _M.touch(key)
  log.debug("empty_sticky:touch["..key.."]")
end

function _M.get(key)
  log.debug("empty_sticky:get["..key.."]")
  return nil
end

return _M

























































































