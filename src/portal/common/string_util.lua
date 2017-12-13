local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

function _M.endswith(text, suffix)
  if text == nil or suffix == nil then
    return false
  end

  if suffix == "" then
    return true
  end
  return string.sub(text, -string.len(suffix)) == suffix
end

function _M.startswith(text, prefix )
  if text == nil or prefix  == nil then
    return false
  end

  if prefix  == "" then
    return true
  end

  return string.sub(text, 1, string.len(prefix)) == prefix
end

function _M.trim(text)
  return (string.gsub(text, "^%s*(.-)%s*$", "%1"))
end

function _M.is_blank(text)
  return text == nil or _M.trim(text)==""
end

return _M
