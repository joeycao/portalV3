local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

--- virtual v_page.
local log = require "portal.common.log"
local NS = require "portal.store.namespace"
local storages = require "portal.store.storages"
local store=storages.match()
function _M.new(self,data)
  return setmetatable(data, mt)
end

function _M.get_by()
  local data = store.get(NS.pattern())
  if data == nil then
    return nil
  end
  return _M:new(data)
end

function _M.save(data)
  return store.save_update(NS.pattern(),data)
end

function _M.delete()
  return store.delete(NS.pattern())
end

return _M
