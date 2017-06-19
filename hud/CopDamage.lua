local original_damage_bullet = CopDamage.damage_bullet
local original_damage_explosion = CopDamage.damage_explosion
local original_damage_melee = CopDamage.damage_melee
local original_damage_fire = CopDamage.damage_fire
local original_sync_damage_bullet = CopDamage.sync_damage_bullet
local original_sync_damage_explosion = CopDamage.sync_damage_explosion
local original_sync_damage_melee = CopDamage.sync_damage_melee
local original_sync_damage_fire = CopDamage.sync_damage_fire
local original_sync_damage_dot = CopDamage.sync_damage_dot

function CopDamage:_process_kill(aggressor, body)
	if alive(aggressor) and aggressor:base() then
		if aggressor:base().sentry_gun then
			aggressor = aggressor:base():get_owner() or managers.criminals:character_unit_by_peer_id(aggressor:base().owner_id)
		elseif aggressor:base()._projectile_entry then
			aggressor = aggressor:base()._thrower_unit
		end
	end
	
	if alive(aggressor) then
		local panel_id
		
		if aggressor == managers.player:player_unit() then
			panel_id = HUDManager.PLAYER_PANEL
		else
			local char_data = managers.criminals:character_data_by_unit(aggressor)
			panel_id = char_data and char_data.panel_id
		end
		
		if panel_id then
			local body_name = body and self._unit:body(body) and self._unit:body(body):name()
			local headshot = self._head_body_name and body_name and body_name == self._ids_head_body_name or false
			local special = managers.groupai:state()._special_unit_types[self._unit:base()._tweak_table] or false
			
			managers.hud:increment_kill_count(panel_id, special, headshot)
		end
	end
end

function CopDamage:damage_bullet(data, ...)
	local result = original_damage_bullet(self, data, ...)
	
	if result and result.type == "death" then
		self:_process_kill(data.attacker_unit, self._unit:get_body_index(data.col_ray.body:name()))
	end
	
	return result
end

function CopDamage:sync_damage_bullet(unit, damage, body, offset_hight, variant, death, ...)
	if death then
		self._process_kill(unit, body)
	end
	
	return original_sync_damage_bullet(self, unit, damage, body, offset_hight, variant, death, ...)
end