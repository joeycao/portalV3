local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }
local log = require "portal.common.log"
local json_util = require "portal.common.json_util"
local v_pattern_match = require "portal.core.v_pattern_match"

--- 根据页面数据 ，返回 选择策略NAME和访问保持NAME。
-- @param v_page
-- @return[swtich_name,switch_opts,sticky_name].
function _M.match(v_page)
  patterns = v_pattern_match.get_by()
  local request_uri = ngx.var.request_uri
  for i,v in pairs(patterns) do
    pattern = v.pattern
    if ngx.re.find(request_uri,pattern, "o") then
      swtich_name = v.swtich_name
      if(swtich_name == nil) then
        log.warn("not found switch for v_page:["..v_page.id.."]")
        return nil,nil
      end
      return swtich_name,v.swtich_opts,v.sticky_name
    end
  end
  return nil,nil
end

return _M
