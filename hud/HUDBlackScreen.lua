local original_init = HUDBlackScreen.init

function HUDBlackScreen:init(hud, ...)
	original_init(self, hud, ...)
	
	-- set the text to say press instead of hold
	local continue_button = managers.menu:is_pc_controller() and "[ENTER]" or nil
	self._blackscreen_panel:child("skip_text"):set_text("Press " .. continue_button .. " to skip")
end