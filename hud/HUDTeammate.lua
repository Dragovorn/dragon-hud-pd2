-- This is broken and needs fixing!

local init_original = HUDTeammate.init
local set_name_original = HUDTeammate.set_name
local set_state_original = HUDTeammate.set_state

function HUDTeammate:init(i, ...)
	init_original(self, i, ...)
	self:_init_killcount()
end

function HUDTeammate:set_name(teammate_name, ...)
	if teammate_name ~= self._name then
		self._name = teammate_name
		self:reset_kill_count()
	end
	
	local name_panel = self._panel:child("name")
	name_panel:set_text(teammate_name)
	set_name_original(self, name_panel:text(), ...)
	self:_truncate_name()
end

function _truncate_name()
	local name_panel = self._panel:child("name")
	local teammate_name = name_panel:text()
	local name_bg_panel = self._panel:child("name_bg")
	name_panel:set_vertical("center")
	self._kills_text:set_font_size(tweak_data.hud_players.name_size)
	self:_update_kill_count_pos()
	name_panel:set_font_size(tweak_data.hud_players.name_size)
	name_panel:set_w(self._panel:w())
	local _, _, w, h = name_panel:text_rect()
	while (name_panel:x() + w) > (self._kills_panel:x() + self._kill_icon:x() - 4) do
		if name_panel:font_size() > 15.1 then
			local newsize = name_panel:font_size() - 0.1
			self._kills_text:set_font_size(newsize)
			self:_update_kill_count_pos()
			name_panel:set_font_size(newsize)
		else
			name_panel:set_text(teammate_name:sub(1, teammate_name:len() - 1))
		end
		
		teammate_name = name_panel:text()
		_, _, w, h = name_panel:text_rect()
	end
	
	name_bg_panel:set_w(w + 4)
	name_bg_panel:set_h(h + 2)
	name_bg_panel:set_y(name_panel:y() + name_panel:h() / 2 - h / 2 - 1)
end

function HUDTeammate:_init_killcount()
	self._kills_panel = self._panel:panel({
		name = "kils_panel",
		visible = true,
		w = 150,
		h = 20,
		x = 0,
		halign = "right"
	})
	
	local player_panel = self._panel:child("player")
	local name_label = self._panel:child("name")
	self._kills_panel:set_rightbottom(player_panel:right(), name_label:bottom())
	self._kill_icon = self._kills_panel:bitmap({
		texture = "guis/textures/pd2/cn_miniskull",
		w = self._kills_panel:h() * 0.75,
		h = self._kills_panel:h(),
		texture_rect = { 0, 0, 12, 16 },
		alpha = 1,
		blend_mode = "add",
		layer = 1,
		color = Color(1, 0, 0, 0)
	})
	self._kills_text = self._kills_panel:text({
		name = "kills_text",
		text = "-",
		layer = 4,
		color = Color(1, 0, 0, 0),
		w = self._kills_panel:w() - self._kill_icon:w() - 4,
		h = self._kills_panel:h(),
		vertical = "center",
		align = "right",
		font_size = tweak_data.hud_players.name_size,
		font = tweak_data.hud_players.name_font
	})
	self.kills_text:set_right(self._kills_panel:w())
	local _, _, text_w, text_h = self._kills_text:text_rect()
	self.kills_text_bg = self._kills_panel:bitmap({
		name = "kills_text_bg",
		texture = "guis/textures/pd2/hud_tabs",
		texture_rect = {
			84,
			0,
			44,
			32
		},
		layer = 2,
		color = Color.white / 3,
		x = self._kills_text:left() - 4,
		y = self._kills_text:top() - 1,
		align = "left",
		vertical = "bottom",
		w = text_w + 4,
		h = text_h
	})
	
	self:reset_kill_count()
	self:refresh_kill_count_visibility()
end

function HUDTeammate:reset_kill_count()
	self._kill_count = 0
	self._kill_count_special = 0
	self._headshot_kills = 0
	self:_update_kill_count_text()
end

function HUDTeammate:_update_kill_count_text()
	local kill_string = tostring(self._kill_count)
	kill_string = kill_string .. "/" .. tostring(self._kill_count_special) .. " (" .. tostring(self._headshot_kills) .. ")"
	self._kills_text:set_text(kill_string)
	self:_update_kill_count_pos()
	self:refresh_kill_count_visibility()
	self:_truncate_name()
end

function HUDTeammate:_update_kill_count_pos()
	self._kills_text:set_right(self._kills_panel:w() - 4)
	local _, _, w, _ = self._kills_text:text_rect()
	self._kill_icon:set_right(self._kills_panel:w() - w - 4 - self._kill_icon:w() * 0.15)
	self._kills_text_bg:set_right(self._kills_panel:w())
	self._kills_text_bg:set_w(w + 8)
end

function HUDTeammate:refresh_kill_count_visibility()
	self._kills_panel:set_visible(true)
end

function HUDTeammate:set_state(...)
	set_state_original(self, ...)
	self:refresh_kill_count_visibility()
	
	if self._ai then
		self._kills_panel:set_bottom(self._panel:child("player"):bottom())
	else
		local name_label = self._panel:child("name")
		self._kills_panel:set_bottom(name_label:bottom())
	end
end