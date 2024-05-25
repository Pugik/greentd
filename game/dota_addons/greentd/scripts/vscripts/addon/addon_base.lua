-- pugiko: https://steamcommunity.com/id/pepegi7/
-- #============================================#
if not _G._ADDON then _G._ADDON = {} end

require("base/global")
require("base/settings")

require("addon/addon_func")
require("addon/addon_const")

require("addon/addon_waves")
require("lib/timers")

function _ADDON:InitAddon()
	local listenersList = {
		npc_spawned = "OnNPCSpawned",
		entity_killed = "OnEntityKilled",
		dota_on_hero_finish_spawn = "OnHeroFinishSpawn",
		game_rules_state_change = "OnGameRulesStateChanged"
	}
	
	local modifiersList = {
		modifier_tax = LUA_MODIFIER_MOTION_NONE
	}
    
	_RegisterListeners(self, listenersList)
	--_RegisterModifier(self, modifiersList)

	_DebugDeepPrint("Listeners: ", self.GameEventListeners)
	--_DebugDeepPrint("Modifiers: ", self.ModifiersList)
end


function _ADDON:OnNPCSpawned(keys)
	local npc
	if keys.entindex then npc = EntIndexToHScript(keys.entindex) else print("[EVENT -> npc_spawned] get nil entindex key") return end
	if not self.all_units then self.all_units = {} end
	self.all_units[npc] = npc:GetUnitName()
	
	if npc:IsRealHero() and not npc.firstTime then npc.firstTime = true BuildingHelper:AddUnit(npc) end
end

function _ADDON:OnEntityKilled(keys)
	local victim = EntIndexToHScript(keys.entindex_killed)
	local attacker = EntIndexToHScript(keys.entindex_attacker)
	if victim == nil then return end
	if self.all_units[victim] then self.all_units[victim] = nil end
end

function _ADDON:OnHeroFinishSpawn(keys)
	local hero = EntIndexToHScript(keys.heroindex)
	local path = Entities:FindByName(nil, "path0")
	
	--[[
	for i = 1, 1 do
		local unit = self:CreateUnit("lion_dance", DOTA_TEAM_BADGUYS, path:GetAbsOrigin())
		unit:SetInitialGoalEntity(path)
	end
	]]

	--self:DebugParseUnitByName(nil, nil)
end

function _ADDON:OnGameRulesStateChanged(keys)
	local CurrentState = GameRules:State_Get()
	if CurrentState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		_HOST:InitRules()
	end
	if CurrentState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:StartNextWave()
	end
end

_ADDON:InitAddon()

-- CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_alert", {message = "Alert_Ancient_Text", time = 2, color = 0, image = 4, sound = 2})

-- Convars:RegisterCommand( "dev_test", function(...) return _ADDON:test( ... ) end, "is good.", FCVAR_CHEAT )