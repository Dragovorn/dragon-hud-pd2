local original_init = HUDBlackScreen.init

function HUDBlackScreen:init(hud, ...)
	original_init(self, hud, ...)
	
	self.skip_text:set_text("TEST")
end