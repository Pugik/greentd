-- pugiko: https://steamcommunity.com/id/pepegi7/
-- #============================================#
if not _G._ADDON then _G._ADDON = {} end

require("base/global")
require("base/settings")

require("addon/addon_settings")
require("addon/addon_func")
require("addon/addon_const")

require("addon/addon_waves")
require("lib/timers")

function _ADDON:InitAddon()
	local listenersList = {
		npc_spawned = "OnNPCSpawned",
		entity_killed = "OnEntityKilled",
		game_rules_state_change = "OnGameRulesStateChanged"
	}

	local modifiersList = _GetModifiersList()

	_RegisterListeners(self, listenersList)
	_RegisterModifier(self, modifiersList)
	_DebugDeepPrint("Listeners: ", self.GameEventListeners)
	_DebugDeepPrint("Modifiers: ", self.ModifiersList)
end

function _ADDON:OnNPCSpawned(keys)
	local npc
	if keys.entindex then npc = EntIndexToHScript(keys.entindex) else print("[EVENT -> npc_spawned] get nil entindex key") return end
	if not self.all_units then self.all_units = {} end
	self.all_units[npc] = npc:GetUnitName()
	
	if npc:IsRealHero() then 
		npc:AddNewModifier(npc, nil, "modifier_speed_cap", nil)
		npc:AddNewModifier(npc, nil, "modifier_phased_custom", nil)
		
		local teleport_item = npc:FindItemInInventory("item_scroll") 
		if teleport_item then npc:RemoveItem(teleport_item) end

		npc:SetAbilityPoints(0)

		for i = 0, npc:GetAbilityCount() - 1 do
			local ability = npc:GetAbilityByIndex(i)
			if not ability then return end
			
			local ability_name = ability:GetName()

			if string.sub(ability_name, 1, string.len("ability")) == "ability" then 
				npc:FindAbilityByName(ability_name):SetLevel(1)
			else
				npc:RemoveAbility(ability_name)
			end
		end
	end
end

function _ADDON:OnEntityKilled(keys)
	local victim = EntIndexToHScript(keys.entindex_killed)
	local attacker = EntIndexToHScript(keys.entindex_attacker)
	if victim == nil then return end
	if self.all_units[victim] then self.all_units[victim] = nil end
end

function _ADDON:OnGameRulesStateChanged(keys)
	local CurrentState = GameRules:State_Get()
	if CurrentState == DOTA_GAMERULES_STATE_CUSTOM_GAME_SETUP then
		_HOST:InitRules()
	end
	if CurrentState == DOTA_GAMERULES_STATE_GAME_IN_PROGRESS then
		self:StartNextWave()
		GameRules:SetTimeOfDay(0.251)
	end
end

_ADDON:InitAddon()

-- CustomGameEventManager:Send_ServerToPlayer(player, "display_custom_alert", {message = "Alert_Ancient_Text", time = 2, color = 0, image = 4, sound = 2})

-- Convars:RegisterCommand( "dev_test", function(...) return _ADDON:test( ... ) end, "is good.", FCVAR_CHEAT )