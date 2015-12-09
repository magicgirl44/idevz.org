local json = require 'cjson'
local IndexController = {}

function IndexController:index()
	-- babel --presets react src --watch --out-dir build
    local view = self:getView()
    local p = {}
    p['vanilla'] = 'Welcome To Vanilla...'
    p['zhoujing'] = 'Power by Openresty'
    -- return sprint_r(p)
    local req = self:getRequest()
    print_r(req)
    return '00'
    -- view:assign(p)
    -- return view:display()
end

function IndexController:helloworld()
    local req = self:getRequest()
	return 'helloworld'
end

function IndexController:home()
	pp('IndexController:home')
	pp(ngx.req.get_uri_args()['ddd'])
	-- https://github.com/idevz/vanilla/issues/new?title={idevz/vanilla}
	return  ngx.var.request_uri
end

function IndexController:info()
	ngx.say('=============')
	local zsh_dict = ngx.shared.zhou
	local key = '_zsh_dict'
	local p = {}
	local s = {}
	local rs = {}
	local req = self:getRequest()
	rs = zsh_dict:get(key)
	if rs ~= nil then
		rs = json.decode(rs)
	else
		rs = {}
	end
	if req:getMethod() == 'POST' then
		pp(req:getParams())
		local post_data = {}
		post_data['author'] = req:getParam('author')
		post_data['text'] = req:getParam('text')
		rs[#rs+1] = post_data
		zsh_dict:set(key, json.encode(rs))
	end
	-- for i=1,2 do
	-- 	p['author'] = 'zhoujing--' .. i
	-- 	p['text'] = '##*0000000000--*' .. i
	-- 	s[i] = p
	-- end
	-- local rs = json.encode(s)
	-- zsh_dict:set(key, rs)
	rs = zsh_dict:get(key)
	-- pp(rs)
	-- rs = json.decode(zsh_dict:get(key))
	return rs
end

return IndexController
