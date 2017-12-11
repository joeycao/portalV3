local _M = {}
_M._data = '1.0'
local mt = { __index = _M }
local storages = require "portal.store.storages"
local namespace = require "portal.store.namespace"
local store=storages.match()
local client = require "portal.common.client"

--- Default sticky time to live:.
local sticky_ttl = tonumber(ngx.var.sticky_ttl) or 20*60

function _M.add(key,data)
  local uid = client.client_id()
  name=namespace.vs_prefix(uid,key)
  store:add(name,data,sticky_ttl,true)
end

function _M.touch(key)
  local uid = client.client_id()
  name=namespace.vs_prefix(uid,key)
  store:open(name,sticky_ttl)
end

function _M.get(key)
  local uid = client.client_id()
  name=namespace.vs_prefix(uid,key)
  data = store:fetch(name)
  return data
end

return _M

























































































