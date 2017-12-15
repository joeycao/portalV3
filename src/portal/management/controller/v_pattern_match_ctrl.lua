local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }
local NS = require "portal.store.namespace"
local storages = require "portal.store.storages"
local validator = require "portal.common.validator"
local log = require "portal.common.log"
local json_util = require "portal.common.json_util"
local string_util = require "portal.common.string_util"
local helper = require "portal.management.respose_helper"
local v_pattern_match = require "portal.core.v_pattern_match"

--- Example:
--{
--id = 'p1',
--pattern = '/.*',
--swtich_name='byweight',
--swtich_opts={v1=1,v2=2}
--sticky_name='session_cookie'
--}

function _M.vaild_get(json_text,errors)
  local has_err = false
  errors = errors or {}
  errors,has_err = validator.vaild_json_text(json_text,"is invalid. json data",errors)
  if has_err  then
    return errors,has_err,nil
  end
  local data = json_util.decode(json_text)
  for i,v in ipairs(data) do
    v.id=string_util.trim(v.id)
    errors,_ = validator.vaild_id(v.id,"[id] is invalid.",errors)
     
    v.swtich_name=string_util.trim(v.swtich_name)
    if(not string_util.is_blank(v.swtich_name))then      
      errors,_ = validator.vaild_en_name(v.swtich_name,"[swtich_name] is invalid.",errors)
    end   
     
    v.sticky_name=string_util.trim(v.sticky_name)
    if(not string_util.is_blank(v.sticky_name))then
      errors,_ = validator.vaild_en_name(v.sticky_name,"[sticky_name] is invalid.",errors)
    end    
  end
  
  if (#errors > 0) then
    has_err =true
  end
  return errors,has_err,data
end

-------------------------------------
-- POST: save and update a pattern.
---------------------------------------
function _M.save(body)
  --ngx.say("..body data.." ..body)
  local errors,has_err,data = _M.vaild_get(body)
  if has_err then
    return helper.error_or_success(errors)
  end
  ok,err = v_pattern_match.save(data)
  return helper.error_or_success(err,data)
end

-------------------------------------
-- POST: delete a pattern.
---------------------------------------
function _M.delete(id)
  ok,err = v_pattern_match.delete()
  return helper.error_or_success(err,data)
end


return _M
