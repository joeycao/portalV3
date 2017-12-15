local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }
local NS = require "portal.store.namespace"
local validator = require "portal.common.validator"
local log = require "portal.common.log"
local json_util = require "portal.common.json_util"
local string_util = require "portal.common.string_util"
local helper = require "portal.management.respose_helper"
local v_template = require "portal.core.v_template"

--Example:
--
--{"id":"ad0001","name":"ad","path":"ad.html" }
--

function _M.vaild_get(json_text,errors)
  local has_err = false
  errors = errors or {}
  local errors,has_err = validator.vaild_json_text(json_text,"is invalid. json data",errors)
  if has_err  then
    return errors,has_err,nil
  end
  data = json_util.decode(json_text)
  data.id=string_util.trim(data.id)
  errors,_ = validator.vaild_id(data.id,"[id] is invalid.",errors)

  data.name=string_util.trim(data.name)
  errors,_ = validator.vaild_en_name(data.name,"[name] is invalid.",errors)

  data.path=string_util.trim(data.path)
  if(not string_util.is_blank(data.path))then
    errors,_ = validator.vaild_filename(data.path,"[path] is invalid.",errors)
  end

  if(#errors > 0 ) then
    has_err = true
  end
  return errors,has_err,data
end


-------------------------------------
-- POST: save and update a template.
---------------------------------------
function _M.save(body)
  --ngx.say("..body data.." ..body)
  local errors,has_err,data = _M.vaild_get(body)
  if has_err then
    return helper.error_or_success(errors)
  end
  local ok,err = v_template.save(data.id,data)
  return helper.error_or_success(err,data)
end

-------------------------------------
-- POST: query templates.
---------------------------------------
function _M.list(filter)
  local data={}
  return helper.error_or_success(nil,data)
end

-------------------------------------
-- POST: delete a template.
---------------------------------------
function _M.delete(id)
  id = id or "-1"
  local errors,has_err = validator.vaild_id(id,"[id] is invalid.",errors)
  if has_err then
    return helper.error_or_success(errors)
  end
  local ok,err = v_template.delete(id)
  return helper.error_or_success(err,{})
end


return _M
