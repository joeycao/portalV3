local _M = {}
_M._VERSION = '1.0'
local mt = { __index = _M }

--- Read file content.
-- @param path filepath to read
-- @return file content as string, or `nil` if fail.
function _M.read_file(filepath)
  local content
  local file = io.open(filepath, "rb")
  if file then
    content = file:read("*all")
    file:close()
  end
  return content
end

--- Check exist of filepath.
-- -- @param path filepath to check
-- -- @return `true`   success, or `false` + error message on failure
function _M.exists(filepath)
  local f, err = io.open(filepath, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false, err
  end
end

--- delete  of filepath.
-- -- @param path filepath to check
-- -- @return `true`   success, or `false` + error message on failure
function _M.remove(filepath)
  local succ, message = os.remove(filepath)
  return succ,message
end

--- Write file content.
-- @param path filepath to write to
-- @return `true`  success, or `false` + error message on failure
function _M.write(filepath, content)
  local file, err = io.open(filepath, "w")
  if err then
    return false, err
  end
  file:write(content)
  file:close()
  return true

end

return _M
