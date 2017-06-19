-- Store the originals of the functions we will be hijacking
local _setup_item_rows_original = MenuNodeMainGui._setup_item_rows
local _add_version_string_original = MenuNodeMainGui._add_version_string

-- Hijack the add version function and make it add our stuff
function MenuNodeMainGui:_add_version_string()
	_add_version_string_original(self)
	self._version_string:set_text("DragonHUD v" .. DragonHUD:GetVersion() .. " (PD2 rel-" .. Application:version() .. ")")
	-- Move version text to where the annoying fucking adverts were
	self._version_string:set_align("right")
end

function MenuNodeMainGui:_setup_item_rows(node, ...)
	_setup_item_rows_original(self, node, ...)
end