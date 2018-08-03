local init_original = HUDManager.init
local set_mugshot_downed_original = HUDManager.set_mugshot_downed
local set_mugshot_custody_original = HUDManager.set_mugshot_custody
local set_mugshot_normal_original = HUDManager.set_mugshot_normal
local set_player_condition_original = HUDManager.set_player_condition

function HUDManager:init(...)
	init_original(self, ...)
end

function HUDManager:set_mugshot_downed(id)
	local panel_id = self:_mugshot_id_to_panel_id(id)
	local unit = self:_mugshot_id_to_unit(id)

	if panel_id and unit and unit:movement().current_state_name and unit:movement():current_state_name() == "bleed_out" then
		-- log("set mugshot downed")
		self._teammate_panels[panel_id]:increment_revives()
	end

	return set_mugshot_downed_original(self, id)
end

function HUDManager:set_mugshot_custody(id)
	local panel_id = self:_mugshot_id_to_panel_id(id)

	if panel_id then
		-- log("set mugshot custody")
		self._teammate_panels[panel_id]:reset_revives()
		self._teammate_panels[panel_id]:set_player_in_custody(true)
	end

	return set_mugshot_custody_original(self, id)
end

function HUDManager:set_mugshot_normal(id)
	local panel_id = self:_mugshot_id_to_panel_id(id)

	if panel_id then
		-- log("set mugshot normal")
		self._teammate_panels[panel_id]:set_player_in_custody(false)
	end

	return set_mugshot_normal_original(self, id)
end

function HUDManager:set_player_condition(icon_data, text)
	set_player_condition_original(self, icon_data, text)

	if icon_data == "mugshot_in_custody" then
		-- log("set mugshot custody (condition)")
		self._teammate_panels[self.PLAYER_PANEL]:set_player_in_custody(true)
	elseif icon_data == "mugshot_normal" then
		-- log("set mugshot normal (condition)")
		self._teammate_panels[self.PLAYER_PANEL]:set_player_in_custody(false)
	end
end

function HUDManager:_mugshot_id_to_panel_id(id)
	for _, data in pairs(managers.criminals:characters()) do
		if data.data.mugshot_id == id then
			return data.data.panel_id
		end
	end
end

function HUDManager:_mugshot_id_to_unit(id)
	for _, data in pairs(managers.criminals:characters()) do
		if data.data.mugshot_id == id then
			return data.unit
		end
	end
end

function HUDManager:teammate_panel_from_peer_id(id)
	for panel_id, panel in pairs(self._teammate_panels or {}) do
		if panel._peer_id == id then
			return panel_id
		end
	end
end

function HUDManager:reset_teammate_revives(panel_id)
	if self._teammate_panels[panel_id] then
		-- log("reset revives")
		self._teammate_panels[panel_id]:reset_revives()
	end
end

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
function HUDManager.set_blackscreen_mid_text(_ARG_0_, _ARG_1_, ...)
	managers.hud._hud_blackscreen._blackscreen_panel:child("mid_text"):set_center_y(managers.hud._hud_blackscreen._blackscreen_panel:child("mid_text"):y() - 50)
    managers.hud._hud_blackscreen:set_mid_text("DragonHUD v" .. DragonHUD:GetVersion() .. " Initialized!")
end

-- function HUDListManager:init()
	-- self._lists = {}

	-- self:_setup_left_list() Comment this out because I don't know if this is gonna crash the game
-- end

-- function HUDListManager:register_list(name, class, params, ...)
-- 	if not self._lists[name] then
-- 		class = type(class) == "string" and _G.HUDList[class] or class
-- 		self._lists[name] = class and class:new(nil, name, params, ...)
-- 	end

-- 	return self._lists[name]
-- end

-- function HUDListManager:_setup_left_list()
-- 	local list_width = 600
-- 	local list_height = 800
-- 	local x = 0
-- 	local y = HUDListManager.ListOptions.left_list_height_offset or 40
-- 	local scale = HUDListManager.ListOptions.left_list_scale or 1
-- 	local list = self:register_list("left_side_list", HUDList.VerticalList, { align = "left", x = x, y = y, w = list_width, h = list_height, top_to_bottom = true, item_margin = 5 })
-- end

-- -- HUDList Class

-- HUDList HUDList or {}

-- HUDList.ItemBase = HUDList.ItemBase or {}
-- function HUDList.ItemBase:init(parent_list, name, params)
-- 	self._parent_list = parent_list
-- 	self._name = name
-- 	self._align = params.align or "center"
-- 	self._fade_time = params.fade_time or 0.25
-- 	self._move_speed = params.move_speed or 150
-- 	self._priority = params.priority
-- 	self._listener_callbacks = {}

-- 	self._panel = (self._parent_list and self._parent_list:panel() or params.native_panel or managers.hud:script(PlayerBase.PLAYER_INFO_HUD_PD2).panel):panel({
-- 		name = name,
-- 		visible = true,
-- 		alpha = 0,
-- 		w = params.w or 0,
-- 		h = params.h or 0,
-- 		x = params.x or 0,
-- 		y = params.y or 0,
-- 		layer = 10
-- 	})
-- end

-- function HUDList.ItemBase:post_init()
-- 	for i, data in ipairs(self._listener_callbacks) do
-- 		for _, event in pairs(data.event) do
-- 			managers.gameinfo:register_listener(data.name, data.source, event, data.callback, data.keys, data.data_only)
-- 		end
-- 	end
-- end

-- function HUDList.ItemBase:destroy()
-- 	for i, data in ipairs(self._listener_callbacks) do
-- 		for _, event in pairs(data.event) do
-- 			managers.gameinfo:unregister_listener(data.name, data.source, event)
-- 		end
-- 	end
-- end

-- function HUDList.ItemBase:name()
-- 	return self._name
-- end

-- function HUDList.ItemBase:panel()
-- 	return self._panel
-- end

-- function HUDList.ItemBase:parent_list()
-- 	return self._parent_list
-- end

-- function HUDList.ItemBase:align()
-- 	return self._align
-- end

-- function HUDList.ItemBase:is_active()
-- 	return self._active
-- end

-- function HUDList.ItemBase:priority()
-- 	return self._priority
-- end

-- function HUDList.ItemBase:fade_time()
-- 	return self._fade_time
-- end

-- function HUDList.ItemBase:hidden()
-- 	return self._force_hide
-- end

-- -- TODO I need to write tons more onto this!

-- -- Vertical List Class

-- HUDList.VerticalList = HUDList.VerticalList or class(HUDList.ListBase)
-- function HUDList.VerticalList:init(parent, name, params)
-- 	params.align = params.align == "left" and "left" or params.align == "right" and "right" or "center"
-- 	HUDList.VerticalList.super.init(self, parent, name, params)
-- 	self._top_to_bottom = params.top_to_bottom
-- 	self._bottom_to_top = params.bottom_to_top and not self._top_to_bottom
-- 	self._centered = params.centered and not (self._bottom_to_top or self._top_to_bottom)
-- end

-- function HUDList.VerticalList:_set_default_item_position(item)
-- 	local offset = self._panel:w() - item:panel:w()
-- 	local x = item:align() == "left" and 0 or item:align() == "right" and offset or offset / 2
-- 	item:panel():set_left(x)
-- end

-- function HUDList.VerticalList:_update_item_positions(insert_item, instant_move)
-- 	if self._centered then
-- 		local total_height = self._static_item and (self._static_item:panel():h() + self._item_margin) or 0
-- 		for i, item in ipairs(self._shown_items) do
-- 			if not item:hidden() then
-- 				total_height = total_width + item:panel():h() + self._item_margin
-- 			end
-- 		end

-- 		total_height = total_height - self._item_margin

-- 		local top = (self._panel:h() - math.min(total_height, self._panel:h())) / 2

-- 		if self._static_item then
-- 			self._static_item:move(item:panel():x(), top, instant_move)
-- 			top = top + self._static_item:panel():h() + self._item_margin
-- 		end

-- 		for i, item in ipairs(self._shown_items) do
-- 			if not item:hidden() then
-- 				if insert_item and item == insert_item then
-- 					if item:panel():y() ~= top then
-- 						item:panel():set_y(top - item:panel():h() / 2)
-- 						item:move(item:panel():x(), top, instant_move)
-- 					end
-- 				else
-- 					item:move(item:panel():x(), top, instant_move)
-- 				end

-- 				top = top + item:panel():h() + self._item_margin
-- 			end
-- 		end
-- 	else
-- 		local prev_height = self._static_item and (self._static_item:panel():h() + self._item_margin) or 0
-- 		for i, item in ipairs(self._shown_items) do
-- 			if not item:hidden() then
-- 				local heigh = item:panel():h()
-- 				local new_y = (self._top_to_bottom and prev_height) or (self._panel:h() - (height + prev_height))

-- 				if insert_item and item == insert_item then
-- 					item:panel():set_y(new_y)
-- 					item:cancel_move()
-- 				else
-- 					item:move(item:panel():x(), new_y, instant_move)
-- 				end

-- 				prev_height = prev_height + height + self._item_margin
-- 			end
-- 		end
-- 	end
-- end

-- -- Left List Item Class

-- HUDList.LeftListIcon = HUDList.LeftListIcon or class(HUDList.ItemBase)