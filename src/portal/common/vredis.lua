local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

local log = require "portal.common.log"
local red          = require "resty.redis"

local setmetatable = setmetatable
local tonumber     = tonumber
local concat       = table.concat
local floor        = math.floor
local sleep        = ngx.sleep
local null         = ngx.null
local now          = ngx.now
local var          = ngx.var

local function enabled(val)
  if val == nil then return nil end
  return val == true or (val == "1" or val == "true" or val == "on")
end

local defaults = {
  prefix       = var.storage_redis_prefix                 or "storages",
  socket       = var.storage_redis_socket,
  host         = var.storage_redis_host                   or "127.0.0.1",
  port         = tonumber(var.storage_redis_port)         or 6379,
  auth         = var.storage_redis_auth,
  uselocking   = enabled(var.storage_redis_uselocking     or true),
  spinlockwait = tonumber(var.storage_redis_spinlockwait) or 10000,
  maxlockwait  = tonumber(var.storage_redis_maxlockwait)  or 30,
  pool = {
    timeout  = tonumber(var.storage_redis_pool_timeout),
    size     = tonumber(var.storage_redis_pool_size)
  }
}

function _M.new(config)
  local r = config or defaults
  local p = r.pool   or defaults.pool
  local l = enabled(r.uselocking)
  if l == nil then
    l = defaults.uselocking
  end
  local self = {
    redis        = red:new(),
    auth         = r.auth or defaults.auth,
    prefix       = r.prefix or defaults.prefix,
    uselocking   = l,
    spinlockwait = tonumber(r.spinlockwait) or defaults.spinlockwait,
    maxlockwait  = tonumber(r.maxlockwait)  or defaults.maxlockwait,
    pool = {
      timeout  = tonumber(p.timeout) or defaults.pool.timeout,
      size     = tonumber(p.size)    or defaults.pool.size
    }
  }
  local s = r.socket or defaults.socket
  if s then
    self.socket = s
  else
    self.host = r.host or defaults.host
    self.port = r.port or defaults.port
  end
  return setmetatable(self, mt)
end

function _M:connect()
  local r = self.redis
  local ok, err
  if self.socket then
    ok, err = r:connect(self.socket)
  else
    ok, err = r:connect(self.host, self.port)
  end
  if ok and self.auth then
    ok, err = r:get_reused_times()
    if ok == 0 then
      ok, err = r:auth(self.auth)
    end
  end
  return ok, err
end

function _M:set_keepalive()
  local r = self.redis
  local pool = self.pool
  local timeout, size = pool.timeout, pool.size
  if timeout and size then
    return r:set_keepalive(timeout, size)
  end
  if timeout then
    return r:set_keepalive(timeout)
  end
  return r:set_keepalive()
end

function _M:key(i)
  return concat({ self.prefix, (i or "") }, ":" )
end

function _M:lock(key)
  if not self.uselocking then
    return true, nil
  end
  local spinlockwait = self.spinlockwait
  local maxlockwait = self.maxlockwait
  local w = spinlockwait / 1000000
  local r = self.redis
  local i = 1000000 / spinlockwait * maxlockwait
  local lock_key = concat({ key, "lock" }, "." )
  for _ = 1, i do
    local ok = r:setnx(lock_key, "1")
    if ok then
      return r:expire(lock_key, maxlockwait + 1)
    end
    sleep(w)
  end
  return false, "no lock"
end

function _M:unlock(key)
  if self.uselocking then
    return self.redis:del(concat({ key, "lock" }, "." ))
  end
  return true, nil
end


function _M:get(key)
  local data = self.redis:get(key)
  return data ~= null and data or nil
end

function _M:setex(key, data, lifetime)
  return self.redis:setex(key, lifetime, data)
end

function _M:set(key, data)
  return self.redis:set(key, data)
end

function _M:expire(key, lifetime)
  self.redis:expire(key, lifetime)
end

function _M:delete(key)
  self.redis:del(key)
end

function _M:open(key, lifetime)
  local ok, err = self:connect()
  if ok then
    local nkey = self:key(key)
    ok, err = self:lock(nkey)
    if ok then
      local d = self:get(nkey)
      if d then
        self:expire(nkey, floor(lifetime))
      end
      self:unlock(nkey)
      self:set_keepalive()
      return nkey, lifetime
    end
    self:set_keepalive()
    return nil, err
  else
    return nil, err
  end
  return nil, "invalid"
end

function _M:fetch(key,close)
  nkey = self:key(key)
  local ok, err = self:connect()
  if ok then
    data = self:get(nkey)
    if close then
      self:set_keepalive()
    end
    return data,err
  end
end

function _M:add(key, data, lifetime, close)
  local ok, err = self:connect()
  if ok then
    local  nkey =  self:key(key)
    lifetime =  lifetime or -1
    if lifetime > 0 then
      ok, err = self:setex(nkey, data, lifetime)
    else
      ok, err = self:set(nkey, data)
    end
    if close then
      self:unlock(nkey)
    end
    self:set_keepalive()
    if ok then
      return concat({ nkey, lifetime}, ":")
    end
    return ok, err
  end
  return ok, err
end


function _M:start(key)
  local ok, err = self:connect()
  if ok then
    ok, err = self:lock(self:key(key))
    self:set_keepalive()
  end
  return ok, err
end

function _M:destroy(key)
  local ok, err = self:connect()
  if ok then
    local nkey = self:key(key)
    self:delete(nkey)
    self:unlock(nkey)
    self:set_keepalive()
  end
  return ok, err
end

return _M


