local iresty_test    = require "test.iresty_test"
local tb = iresty_test.new({unit_name="test_rule"})

local switches   = require "portal.abtesting.switch.switches"
local storages   = require "portal.store.storages"
local json_util = require "portal.common.json_util"
local NS = require "portal.store.namespace"
local v_pattern_match = require "portal.core.v_pattern_match"


function tb:init(  )
  self:log("init complete")
end

---test firstly_v1
function tb:test_0000()
  switch = switches.match()
  if(switch ~= nil and switch.name =="firstly_v1") then
    self:log("load " .. switch.name .." is ok")
  else
    error("firstly_v1 is invalid.")
  end
  if(switch.match({}) ~="v1") then
    error("firstly_v1:select not is v1")
  end
end

---test byweight
function tb:test_0001()
  switch = switches.match("byweight")
  if(switch ~= nil and switch.name =="byweight") then
    self:log("load " .. switch.name .." is ok")
  else
    error("byweight is invalid.")
  end
  if(switch.match({v1=0,v2=1}) ~="v2") then
    error("byweight:select not is byweight")
  end
end


---test jsonfile_store.
function tb:test_0002()
  jsonfile_store = storages.match("jsonfile_store")
  if(jsonfile_store ~= nil) then
    self:log("jsonfile_store [" .. jsonfile_store.name .."] is ok")
    local data1 = {
      id="t100000",
      name="AD",
      path="",
      content="{* data.content *}"
    }
    jsonfile_store.save_update(data1.id,data1)

    local data2 = jsonfile_store.get(data1.id)
    if data2 == nil   then
      error("get data is null")
      return
    end

    if data2.id ~= data1.id then
      error("get data is invalid.data2.id="..data2.id.."data1.id="..data1.id)
      return
    end
    jsonfile_store.delete(data2.id)
  else
    error("jsonfile_store is invalid.")
  end
end



---v_page,v_template,v_content
function tb:test_0003()

  local v_template_data = {id="t100000",
      name="AD",
      path="",
      content="{* data.content *}"
  }

  local v_page_data  = { id = 'p100000',
    multi_content={v1="/public/vcontent/c10000",v2="/public/vcontent/c20000"}
  }

  local v_content1_data  = {id = 'c10000',
    template_id = 't100000',
    content= "<img src=\"https://img01.sogoucdn.com/app/a/100520122/d50a17ec_pc11.png\" />"
  }


  local v_content2_data  = {id = 'c20000',
    template_id = 't100000',
    content= "<img src=\"https://www.baidu.com/img/bd_logo1.png\" />"
  }

  local v_page = require "portal.core.v_page"
  local v_content = require "portal.core.v_content"
  local v_template = require "portal.core.v_template"

  v_template.save(NS.vt_prefix(v_template_data.id),v_template_data)
  v_page.save(NS.vp_prefix(v_page_data.id),v_page_data)
  v_content.save(NS.vc_prefix(v_content1_data.id),v_content1_data)
  v_content.save(NS.vc_prefix(v_content2_data.id),v_content2_data)


  local pattern={
    {
      id = 'p1',
      pattern = '/(.*)',
      swtich_name='byweight',
      swtich_opts={v1=5,v2=5},
      sticky_name='session_cookie'
    }
  }

  v_pattern_match.save(pattern)
  v_pattern_match.get_by()
  local pattern_matcher = require "portal.abtesting.pattern_matcher"
  switch_name,swtich_opts, sticky_name = pattern_matcher.match(v_page)
  self:log("switch_name [" .. switch_name .."] ,sticky_name [" .. sticky_name .."] is ok")

  local switch = switches.match(switch_name)
  local v = switch.match(swtich_opts)
  self:log("version_id: [" .. v .."] is ok")
end

function tb:test_0004()
  local stickies = require "portal.abtesting.sticky.stickies"
  sticky = stickies.match("session_cookie")
  if(sticky  == nil) then
    error("not found sticky")
  end
  sticky.add("caoshuai","prog")
  sticky.touch("caoshuai")
  sticky.get("caoshuai")
end

function tb:test_0005()
  local res = ngx.location.capture(
    '/public/vpage/p100000.html', { method = ngx.HTTP_GET}
  )
  if 200 ~= res.status then
    error("failed code:" .. res.status)
  end
end





-- units test
tb:run()
