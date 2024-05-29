-- pugiko: https://steamcommunity.com/id/pepegi7/
-- #============================================#

function _GetModifiersList()
	local modifiersList = {
		modifier_status_tower = {LUA_MODIFIER_MOTION_NONE, nil},
		modifier_speed_cap = {LUA_MODIFIER_MOTION_NONE, nil},
		modifier_phased_custom = {LUA_MODIFIER_MOTION_NONE, nil},
		modifier_ground_tower = {LUA_MODIFIER_MOTION_NONE, "addon/modifiers/modifier_status_tower.lua"},
		modifier_air_tower = {LUA_MODIFIER_MOTION_NONE, "addon/modifiers/modifier_status_tower.lua"}
	}
	return modifiersList
end