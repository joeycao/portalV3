local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }
local validator = require "portal.common.validator"
local log = require "portal.common.log"
local NS = require "portal.store.namespace"
local json_util = require "portal.common.json_util"
local helper = require "portal.management.respose_helper"
local v_page = require "portal.core.v_page"

function _M.vaild_get(json_text,errors)
  local has_err = false
  errors = errors or {}
  local errors,has_err = validator.vaild_json_text(json_text,"invalid json data",errors)
  if has_err  then
    return errors,has_err,nil
  end
  data = json_util.decode(json_text)
  data.id=string_util.trim(data.id)
  errors,has_err = validator.vaild_id(data.id,"[id] invalid",errors)

  return errors,has_err,data
end

-------------------------------------
-- POST: save and update a v_page.
---------------------------------------
-- http://localhost/
--
--{"id":"p100000","multi_content":{"v1":"/public/vcontent/c10000","v2":"/public/vcontent/c20000"}}
--
function _M.save(body)
  local errors,has_err,data = _M.vaild_get(body)

  if has_err then
    return helper.to_error(errors)
  end
  local ok,err = v_page.save(data.id,data)
  return helper.error_or_success(err,data)
end

-------------------------------------
-- POST: query v_pages.
---------------------------------------
function _M.list(filter)
  local data={}
  return helper.error_or_success(nil,data)
end

-------------------------------------
-- POST: delete a v_page.
---------------------------------------
----
--{"id":"p100000","multi_content":{"v1":"/public/vcontent/c10000","v2":"/public/vcontent/c20000"}}
--
function _M.delete(id)
  id = id or "-1"
  local ok,err = v_page.delete(id)
  return helper.error_or_success(err)
end

return _M
