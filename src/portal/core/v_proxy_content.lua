local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"


function _M.get_by(url)
  return "proxy_url_content"
end

return _M
