local _M = {}
_M._data = '1.0'
local mt = { __index = _M }
local NS = require "portal.store.namespace"
local log = require "portal.common.log"
local resty_cookie = require "resty.cookie"
function _M.add(key,data)
  local cookie = resty_cookie:new()
  if not cookie then
    ngx.log(ngx.ERR, err)
    return
  end
  -- set cookie
  local name = NS.st_prefix(key)
  log.debug("session_cookie:add:cookie_name : ["..name.."]")
  cookie:set({
    key = name, value = data, age=-1,httponly = true,
  })
end

function _M.touch(key)
  local name = NS.st_prefix(key)
  log.debug("session_cookie:touch:cookie_name : ["..name.."]")
end

function _M.get(key)
  local cookie = resty_cookie:new()
  if not cookie then
    ngx.log(ngx.ERR, err)
    return
  end
  -- set cookie
  local name = NS.st_prefix(key)
  data = cookie:get( name)
  return data
end

return _M

























































































