local json = require 'cjson'
local AdminPlugin = require('vanilla.v.plugin'):new()

function AdminPlugin:routerStartup(request, response)
	local zsh_dict = ngx.shared.zhou
	local key = request.req_uri
	if request.method == 'GET' then
		local rs_json = zsh_dict:get(key)
		local cache_status = ''
		local rs = ''
		rs_json = nil
		if rs_json ~= nil then
			cache_status = 'HIT'
			rs = json.decode(rs_json)
		else
			cache_status = 'MISS'
			rs = ngx.location.capture("/index.php?" .. request.req_uri)
			if rs then zsh_dict:set(key, json.encode(rs)) end
		end
		-- pp(rs)
		response:setStatus(rs.status)
		rs.header['cache_status'] = cache_status
		response:setHeaders(rs.header)
		response.body = rs.body
		-- if response:response() then ngx.eof() end
	else
		pp(request.headers)
	end
end

function AdminPlugin:routerShutdown(request, response)
end

function AdminPlugin:dispatchLoopStartup(request, response)
end

function AdminPlugin:preDispatch(request, response)
end

function AdminPlugin:postDispatch(request, response)
end

function AdminPlugin:dispatchLoopShutdown(request, response)
	-- pp('AdminPlugin:dispatchLoopShutdown')
end

return AdminPlugin