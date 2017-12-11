local _M = {}           
_M._VERSION = '1.0'     
local mt = { __index = _M }

function _M.debug(...)
    ngx.log(ngx.DEBUG, "P: ", ...)
end
function _M.warn(...)
    ngx.log(ngx.WARN, "P: ", ...)
end

function _M.errlog(...)
    ngx.log(ngx.ERR, "P: ", ...)
end

return _M 



