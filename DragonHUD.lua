if not Steam then
	return
end

DragonHUD = DragonHUD or {}
if not DragonHUD.setup then -- Use this to setup our variables
	DragonHUD._path = ModPath
	DragonHUD.info = "[DragonHUD] [INFO]: "
	DragonHUD.error = "[DragonHUD] [ERROR]: "
	DragonHUD.warn = "[DragonHUD] [WARN]: "
	DragonHUD.debug = "[DragonHUD] [DEBUG]: "
	DragonHUD._config = SavePath .. "DragonHUD.json"
	DragonHUD._menus = {
		"dragonhud_options"
	}
	DragonHUD._language = {
		[1] = "english"
	}

	function DragonHUD:Load()
		self:LoadDefaults()

		local file = io.open(self._config)

		if file then
			local json_config = json.decode(file:read("*all"))
			file:close()

			for k, v in pairs(json_config) do
				self._data[k] = v
			end
		end

		self:Save()
	end

	function DragonHUD:GetOption(id)
		return self._data[id]
	end

	function DragonHUD:LoadDefaults()
		local default_file = io.open(self._path .. "/default_config.json")
		self._data = json.decode(default_file:read("*all"))
		default_file:close()
	end

	function DragonHUD:InitMenus()
		for _, menu in pairs(self._menus) do
			MenuHelper:LoadFromJsonFile(self._path .. "menu/" .. menu .. ".json", self, self._data)
		end
	end

	function DragonHUD:Save()
	end

	function DragonHUD:GetVersion()
		local id = string.match(self._path, "(%w+)[\\/]$") or "DragonHUD"
		local mod = BLT.Mods:GetMod(id)
		return tostring(mod and mod:GetVersion() or "ERROR")
	end

	DragonHUD:Load()
	DragonHUD.setup = true
	log(DragonHUD.info .. "DragonHUD Enabled")
end