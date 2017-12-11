local _M = {}

_M.__index = _M
local _M = {
  _VERSION = "0.01"
}

function _M.client_id()
  local header=ngx.req.get_headers()
  addr = header["CF-Connecting-IP"] or
    header["Fastly-Client-IP"] or
    header["Incap-Client-IP"]  or
    header["X-Real-IP"]
  if not addr then
    addr = header["X-Forwarded-For"]
    if addr then
      local s = find(addr, ',', 1, true)
      if s then
        addr = addr:sub(1, s - 1)
      end
    else
      addr = ngx.var.remote_addr
    end
  end
  return addr
end

return _M
