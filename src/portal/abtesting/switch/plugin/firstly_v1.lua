local _M = {}
_M._VERSION = '1.0'
_M.name = 'firstly_v1'
local mt = { __index = _M }
local json_util = require "portal.common.json_util"

---  To return "v1" always.
-- @param opts {version_id1:weight1,version_id2:weight2}  example: opts = {v1=5,v2=6}  or opts = {}
-- @return `version_id` or nil
function _M.match(opts)
  return "v1"
end

return _M
