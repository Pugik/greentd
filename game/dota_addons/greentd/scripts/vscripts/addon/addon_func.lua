-- pugiko: https://steamcommunity.com/id/pepegi7/
-- #============================================#

-- ===================================================================================

--  Example: _ADDON:CreateGoldEffect
--
--  _ADDON:CreateGoldEffect(WhoOwnEffect, WhoSeeEffect, GoldCount, true = plus, color, lifetime)

function _ADDON:CreateGoldEffect(caster, player, gold, increase, color, lifetime)
	local coins_p_name = "particles/generic_gameplay/lasthit_coins.vpcf"	
	local coins_p = ParticleManager:CreateParticleForPlayer( coins_p_name, PATTACH_ABSORIGIN, caster, player)
	ParticleManager:SetParticleControl( coins_p, 1, caster:GetAbsOrigin() )

    local p_symbol = 1
    if increase == true then p_symbol = 10 end
	local p_color = color or Vector(255, 200, 33)
	local p_lifetime = lifetime or 2.0
	local p_digits = string.len(gold) + 1
	local msg_p_name = "particles/msg_fx/msg_gold.vpcf"
	local msg_p = ParticleManager:CreateParticleForPlayer(msg_p_name, PATTACH_ABSORIGIN, caster, player)
	ParticleManager:SetParticleControl(msg_p, 1, Vector(p_symbol, gold, 0))
	ParticleManager:SetParticleControl(msg_p, 2, Vector(p_lifetime, p_digits, 0))
	ParticleManager:SetParticleControl(msg_p, 3, p_color)
end

-- ===================================================================================

--  Example: _ADDON:CreateUnit
--
--  _ADDON:CreateUnit(unitName: "npc_dota_neutral_kobold", teamNumber: DOTA_TEAM_GOODGUYS, RandomVector(RandomFloat(100, 500)) )

function _ADDON:CreateUnit(unitName, teamNumber, spawnVector, movetoClear)
    local unitTable = 
    { 	
        MapUnitName = unitName or "npc_dota_neutral_kobold", 
        teamnumber = teamNumber or DOTA_TEAM_NEUTRALS,
		NeverMoveToClearSpace = movetoClear or false
    }

    local unit = CreateUnitFromTable(unitTable, spawnVector or RandomVector(RandomFloat( 100, 500 )))
    return unit
end

-- ===================================================================================

--  Example: _ADDON:CreateUnit
--
--  _ADDON:DebugParseUnitByName(unitName: "npc_dota_neutral_kobold", text: "Example: ")

function _ADDON:DebugParseUnitByName(unitName, text)
	if text then print(text) end
	if unitName == nil then 
		for table, name in pairs(self.all_units) do
			print("Name: ", name, " Table: ", table)
		end
	else
		for table, name in pairs(self.all_units) do
			if name == unitName then print("Name: ", name, " Table: ", table) end
		end
	end
	print("\n")
end

-- ===================================================================================

--  Example: _ADDON:DropItem
--
--  _ADDON:DropItem(entity, unitName: "item_tango", autoPickup: nil, launchVector: RandomVector( RandomFloat( 100, 350 ) ))

function _ADDON:DropItem(entity, itemName, autoPickup, launchVector)
	local item = CreateItem( itemName or "item_tango", nil, nil)
	item:SetPurchaseTime( 0 )
	local drop = CreateItemOnPositionSync( entity:GetAbsOrigin(), item )
	if launchVector then 
		item:LaunchLoot( autoPickup or false, 300, 0.75, entity:GetAbsOrigin() + launchVector, nil) 
	end
	return item
end