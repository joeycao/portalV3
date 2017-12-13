local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }
local NS = require "portal.store.namespace"
local storages = require "portal.store.storages"
local validator = require "portal.common.validator"
local log = require "portal.common.log"
local json_util = require "portal.common.json_util"
local helper = require "portal.management.respose_helper"
local v_pattern_match = require "portal.core.v_pattern_match"

--- Example:
--{
--id = 'p1',
--pattern = '/(.*)',
--swtich_name='byweight',
--sticky_name='session_cookie'
--}

function _M.vaild_get(json_text,errors)
  local has_err = false
  errors = errors or {}
  errors,has_err = validator.vaild_json_text(json_text,"invalid json data",errors)
  if has_err  then
    return errors,has_err,nil
  end
  local data = json_util.decode(json_text)
  for i,v in ipairs(data) do
    data.id=string_util.trim(data.id)
    errors,_ = validator.vaild_id(data.id,"[id] invalid",errors)

    data.swtich_name=string_util.trim(data.swtich_name)
    errors,_ = validator.vaild_en_name(data.swtich_name,"[swtich_name] invalid",errors)

    data.sticky_name=string_util.trim(data.sticky_name)
    errors,_ = validator.vaild_en_name(data.sticky_name,"[sticky_name] invalid",errors)
  end
  if (#errors >0) then
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
    return helper.to_error(errors)
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
