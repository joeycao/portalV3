local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

---v_page
function _M.vp_prefix(name)
  return "vp_"..(name or "")
end

---v_content
function _M.vc_prefix(name)
  return "vc_"..(name or "")
end

---v_template
function _M.vt_prefix(name)
  return "vt_"..(name or "")
end

---sticky
function _M.st_prefix(uid,name)
  return "st_"..uid..":"..(name or "")
end

---switch
function _M.sw_prefix(name)
  return "sw_"..(name or "")
end

---pattern
function _M.pattern()
  return "pa_".."PATTERN"
end






return _M
