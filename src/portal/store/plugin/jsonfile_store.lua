local _M = {}
_M._data = '1.0'
_M.name = "jsonfile_store"
local mt = { __index = _M }
local log = require "portal.common.log"
local lfs = require "lfs"
local file_util = require "portal.common.file_util"
local json_util = require "portal.common.json_util"
local now          = ngx.now
local var          = ngx.var
local file_store_root  = var.file_store_root  or "/home/store/"


function _M.query(pattern)
  log.debug("file_store:query["..pattern.."]")
  local table = "{"
  for file in lfs.dir(file_store_root) do
    p = file_store_root ..  file
    if file ~= "." and file ~= '..' then
      local mode = lfs.attributes(p, "mode")
      if mode == "file" then
        s ="{'file':'"..file.."','path':'" ..p.. "}"
        table = table .. s
      end
    end
  end
  table = table .. "}"
  log.debug("file_store:query["..pattern.."] data: "..table)
  return table
end

function _M.get(id)
  log.debug("file_store:get["..id.."]")
  local data_file = file_store_root..id
  local is_exists = file_util.exists(data_file)
  log.debug("file_store:get_data_file["..data_file.."]")
  if is_exists then
    data = file_util.read_file(data_file)
    log.debug("file_store:data["..data .."]")
    return json_util.decode(data),nil
  end
  return nil ,nil
end

function _M.save_update(id,data)
  log.debug("file_store:save_update["..#data.."]")
  local data_file = file_store_root..id
  if (file_util.exists(data_file)) then
    file_util.remove(data_file)
  end
  json_data = json_util.encode(data) or "{}"
  log.debug("file_store:save_update:write["..(json_data or "").."]")
  file_util.write(data_file,json_data)
  return true ,nil
end

function _M.delete(id)
  log.debug("file_store:delete["..id.."]")
  local data_file = file_store_root..id
  if (file_util.exists(data_file)) then
    file_util.remove(data_file)
    return true,nil
  end
  return true,nil
end

return _M
