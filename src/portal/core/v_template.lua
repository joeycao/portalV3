local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"
local NS = require "portal.store.namespace"
local storages = require "portal.store.storages"
local store=storages.match()

function _M.new(self,data)
  return setmetatable({
    name=data.name,
    content=(data.content or ""),
    path=(data.path or ""),
    id=data.id,
  }, mt)
end

function _M.get_by(id)
  data = store.get(NS.vt_prefix(id))
  if  data == nil then
    return nil
  end
  return _M:new(data)
end

function _M.save(id,data)
  return store.save_update(NS.vt_prefix(data.id),data)
end

function _M.delete(id)
  return store.delete(NS.vt_prefix(id))
end

return _M
