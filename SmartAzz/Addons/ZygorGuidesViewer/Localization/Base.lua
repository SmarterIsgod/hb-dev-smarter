local _G = _G
local data = {}

local type=type

local mt = {__index=function(self, key)
	if type(key)=="number" then return end
	self[key] = key
	return key
end}
function _G.ZygorGuidesViewer_L(name, locale, translations)
	if locale == "enUS" then
		data[name] = translations()
		setmetatable(data[name], mt)
	elseif locale == GetLocale() then
		local trans = translations()
		for k, v in pairs(trans) do
			data[name][k] = v
		end
	end
	
	return data[name]
end