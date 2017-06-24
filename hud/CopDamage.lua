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

function CopDamage:damage_explosion(data, ...)
	if not self:dead() then
		explosion_original(self, data, ...)
		
		if self:dead() and alive(data.attacker_unit) then
			self:_process_kill(data.attacker_unit, data.col_ray and data.col_ray.body and self._unit:get_body_index(data.col_ray.body:name()))
		end
	end
end

function CopDamage:damage_melee(data, ...)
	local result = original_damage_melee(self, data, ...)
	
	if result and result.type == "death" then
		self:_process_kill(data.attacker_unit, self._unit:get_body_index(data.col_ray.body:name()))
	end
	
	return result
end

function CopDamage:damage_fire(data, ...)
	-- TODO: This is a hack, waiting for OVERKILL to learn to code
	if not self:dead() then
		original_damage_fire(self, data, ...)
		
		if self:dead() and alive(data.attacker_unit) then
			self:_process_kill(data.attacker_unit, data.col_ray and data.col_ray.body and self._unit:get_body_index(data.col_ray.body:name()))
		end
	end
	
	--local result = original_damage_melee(self, data, ...)
	
	--if result and result.type == "death" then
	--	self:_process_kill(data.attacker_unit, self._unit:get_body_index(data.col_ray.body:name()))
	--end
	
	--return result
end

function CopDamage:sync_damage_bullet(unit, damage, body, offset_height, variant, death, ...)
	if death then
		self._process_kill(unit, body)
	end
	
	return original_sync_damage_bullet(self, unit, damage, body, offset_height, variant, death, ...)
end

function CopDamage:sync_damage_explosion(unit, damage, variant, death, direction, weapon, ...)
	if death then
		self:_process_kill(unit)
	end
	
	return original_sync_damage_explosion(self, unit, damage, variant, death, direction, weapon, ...)
end

function CopDamage:sync_damage_melee(unit, damage, percent, body, offset_height, variant, death, ...)
	if death then
		self:_process_kill(unit, body)
	end
	
	return original_sync_damage_melee(self, unit, damage, percent, body, offset_height, variant, death, ...)
end

function CopDamage:sync_damage_fire(unit, percent, dance, death, direction, weapon_type, weapon_id, healed, ...)
	if death then
		self:_process_kill(unit)
	end
	
	return original_sync_damage_fire(self, unit, percent, dance, death, direction, weapon_type, weapon_id, healed, ...)
end

function CopDamage:sync_damage_dot(unit, damage, death, variant, hurt, weapon_id, ...)
	if death then
		self:_process_kill(unit)
	end
	
	return original_sync_damage_dot(self, unit, damage, death, variant, hurt, weapon_id, ...)
end