local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"
local client = require "portal.common.client"
local uid = client.client_id()

local errorView = "error.html"
local json_util = require "portal.common.json_util"

local HAS_BODY = { PUT = 1, POST = 2, PATCH = 3 }
local ROUTE = {
  template = "v_template_ctrl",
  content = "v_content_ctrl",
  page = "v_page_ctrl",
  pattern_match = "v_pattern_match_ctrl"
}

local function parse_args()
  local args = nil
  local body_data = nil
  local request_method = ngx.var.request_method;
  if HAS_BODY[request_method] then
    local headers = ngx.req.get_headers()
    local content_type = headers["content-type"]
    if content_type and string.find(content_type:lower(), "application/json",
      nil, true) then
      ngx.req.read_body()
      body_data = ngx.req.get_body_data()
    else
      log.warn("dispatcher:parse_args:content_type:"..content_type)
      ngx.exit(ngx.HTTP_BAD_REQUEST)
    end
  end
  uri_args = ngx.req.get_uri_args()
  return uri_args,body_data
end

function _M.dispatch(object,action)
  request_method = ngx.var.request_method;
  log.debug("dispatch:object:" ..object .. "/action:" ..action)
  local ctrl =  ROUTE[object]
  local controller = nil
  if ctrl then
    controller = require ("portal.management.controller."..ctrl)
  else
    ngx.exit(ngx.HTTP_BAD_REQUEST)
  end

  local uri_args,body = parse_args()
  if "GET" == request_method then
    --resp = objectCtrl.save(body)
    if "query" == action then
      log.debug("query___no support.")
      return
    end
  end

  if "POST" == request_method then
    --save object
    if "create" == action then
      resp = controller.save(body)
      ngx.say(resp)
      return
    end
    if "delete" == action then
      local id = uri_args["id"] or "-1"
      log.debug("POST:".. "action:"..action.." id:".. id)
      resp = controller.delete(id)
      ngx.say(resp)
      return
    end

  end
end


return _M
