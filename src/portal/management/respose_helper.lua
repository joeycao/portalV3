local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"
local json_util = require "portal.common.json_util"

function _M.error_or_success(errors,playload)
  errors = errors or {}
  playload = playload or {}
  local resp = {}
  if (#errors > 0) then
    resp = {
      success=false,
      message=table.concat(errors,", ")
    }
  else
    resp = {
      success=true,
      message="",
      data = playload
    }
  end
  return json_util.encode(resp)
end

return _M
