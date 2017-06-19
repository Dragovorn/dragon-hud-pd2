if not Steam then
	return
end

DragonHUD = DragonHUD or {}

function DragonHUD:GetVersion()
	local version = "ERROR"
	
	for k, v in pairs(LuaModManager.Mods) do
		local info = v.definition
		
		if info["name"] == "DragonHUD" then
			version = info["version"]
		end
	end
	
	return version;
end