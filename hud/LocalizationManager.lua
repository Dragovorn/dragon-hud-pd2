local original_text = LocalizationManager.text

-- This is a really ghetto fix and probably shouldn't be used for a long period of time as it makes some stuff look kinda weird
-- Depricated
function LocalizationManager:text(string_id, ...)
	return string_id == "menu_ultimate_edition_short" and "" or string_id == "menu_dlc_buy_ue" and "" or string_id == "menu_l_global_value_ue" and "" or string_id == "cn_menu_community" and "" or string_id == "menu_l_global_value_pd2_clan" and "" or original_text(self, string_id, ...)
end