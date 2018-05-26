if not Steam then
	return
end

DragonHUD = DragonHUD or {}
if not DragonHUD.setup then -- Use this to setup our variables
	DragonHUD._path = ModPath
end

function DragonHUD:GetVersion()
	local id = string.match(self._path, "(%w+)[\\/]$") or "DragonHUD"
	local mod = BLT.Mods:GetMod(id)
	return tostring(mod and mod:GetVersion() or "ERROR")
end