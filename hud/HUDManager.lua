-- enter instantly skips blackscreen
-- this could also be moved to HUDBlackscreen i think
function HUDManager:set_blackscreen_skip_circle(current, total)
	IngameWaitingForPlayersState._skip_data = {
		total = 0,
		current = 1
	}
    managers.hud._hud_blackscreen:set_skip_circle(current, total)
end

function HUDManager:increment_kill_count(teammate_panel_id, special, headshot)
	self._teammate_panels[teammate_panel_id]:increment_kill_count(special, headshot)
end

function HUDManager:reset_kill_count(teammate_panel_id)
	self._teammate_panels[teammate_panel_id]:reset_kill_count()
end

-- Add our mid-text to the blackscreen
-- Move this to a seperate file with a seperate trigger in BLT as it probably can be done w/ a seperate trigger.
function HUDManager.set_blackscreen_mid_text(_ARG_0_, _ARG_1_, ...)
	managers.hud._hud_blackscreen._blackscreen_panel:child("mid_text"):set_center_y(managers.hud._hud_blackscreen._blackscreen_panel:child("mid_text"):y() - 50)
    managers.hud._hud_blackscreen:set_mid_text("DragonHUD v" .. DragonHUD:GetVersion() .. " Initialized!")
end