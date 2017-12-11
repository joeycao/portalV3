local _M = {}
_M._VERSION = '1.0'
_M.name = 'byweight'
local mt = { __index = _M }
local json_util = require "portal.common.json_util"
local log = require "portal.common.log"

local function extend(list,sub,count)
  for i=1,count do
    table.insert(list,sub)
  end
end

--- To match version id.
-- @param opts {version_id1:weight1,version_id2:weight2}  example: opts = {v1=5,v2=6}  or opts = {}
-- @return `version_id` or nil
function _M.match(opts)
  math.randomseed(os.time())
  if opts == nil then
    return nil
  end
  local list = {}
  local sum = 0
  for k,v in pairs(opts) do
    sum = sum + v
    extend(list,k,v)
  end

  if(#list == 0 ) then
    return nil
  end
  rnd = math.random(1,sum)
  log.debug("weight:select:["..table.concat(list,",") .. "],rnd:"..rnd)
  return list[rnd]
end

return _M
