local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local template = require "resty.template"
local v_template = require "portal.core.v_template"
local v_content = require "portal.core.v_content"
local v_page = require "portal.core.v_page"
local stickies = require "portal.abtesting.sticky.stickies"
local switches = require "portal.abtesting.switch.switches"
local pattern_matcher = require "portal.abtesting.pattern_matcher"
local log = require "portal.common.log"

function _M.view(pid)
  _M.view_v_page(pid)
end

function _M.view_content(content_id)
  log.debug("view_content:["..content_id.."]")
  local vcontent = v_content.get_by(content_id)
  if (vcontent ~= nil ) then
    log.debug("view_content.content_id["..content_id.. " ] template_id[".. (vcontent.template_id or "NULL template_id".."]"))
    local vtemplate = v_template.get_by(vcontent.template_id)
    --template.caching(true)
    local view = vtemplate.path
    if string.len(view) == 0 then
      view = vtemplate.content
    end
    local func = template.compile(view)
    --执行函数，得到渲染之后的内容
    local context = {data=vcontent}
    local content = func(context)
    ngx.say(content)
  end
end

function _M.view_v_page(pid)

  local content_uri =nil

  -- 根据页面编码，获得页面元数据。
  local page = v_page.get_by(pid)
  if(page == nil ) then
    ngx.exit(ngx.HTTP_NOT_FOUND)
    return
  end

  -- 获得页面选择算法与会话保持状态 。
  local switch_name,swtich_opts, sticky_name = pattern_matcher.match(page)
  log.debug("view_v_page: [switch_name,sticky_name]=[" ..(switch_name or "nil") .."," ..(sticky_name or "nil").."]")
  local sticky = stickies.match(sticky_name)
  local v_sticky = sticky.get(pid)
  local v = nil
  if v_sticky ~= nil then
    v = v_sticky
    sticky.touch(pid)
  end

  if( v == nil) then
    log.debug("Try to match version by switch_name=[" ..(switch_name or "nil") .."]")
    local switch = switches.match(switch_name)
    v = switch.match(swtich_opts)
  end

  local content_uri = page.multi_content[v] or nil
  if(content_uri ~= nil) then
    --根据内容URL，获得并显示。
    local res = ngx.location.capture(content_uri)
    if not v_sticky and res.status == 200 then
      log.debug("Aview_v_page: dd sticky: (pid)" ..pid)
      sticky.add(pid,v)
    end
    ngx.say(res.body)
  end

end

return _M
