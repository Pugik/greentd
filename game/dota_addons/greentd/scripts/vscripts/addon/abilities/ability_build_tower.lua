local forbiddenZones = {
    {min = Vector(-1000, -1000, 0), max = Vector(1000, 1000, 0)}
}

-----------------------------------------------------------------------------

ability_build_tower = class({})

-----------------------------------------------------------------------------

function ability_build_tower:GetAOERadius()
    return 64
end

function ability_build_tower:GetGoldCost(level) return self:GetSpecialValueFor("price") end 

function ability_build_tower:IsPointInForbiddenZone(target)
    for _, zone in pairs(forbiddenZones) do
        if target.x >= zone.min.x and target.x <= zone.max.x and target.y >= zone.min.y and target.y <= zone.max.y then
            return true
        end
    end
    return false
end

function ability_build_tower:IsTowerAtLocation(target)
    local towers = Entities:FindAllByClassnameWithin("npc_dota_tower", target, 32)
    return #towers > 0
end

function ability_build_tower:ReturnGold(ent)
    local gold = self:GetSpecialValueFor("price")
    ent:SpendGold(-gold, DOTA_ModifyGold_Unspecified)
end

function ability_build_tower:CreateTower(className, isAir)
    local caster = self:GetCaster()
    local casterid = caster:GetPlayerID()
    local target = self:GetCursorPosition()
    
    if self:IsPointInForbiddenZone(target) or self:IsTowerAtLocation(target) then
        self:ReturnGold(caster)
        return
    end
    
    local cellX = math.floor(target.x / 256 + 0.5)
    local cellY = math.floor(target.y / 256 + 0.5)

    local worldX = cellX * 256
    local worldY = cellY * 256

    local unitTable = 
    { 	
        MapUnitName = className, 
        teamnumber = DOTA_TEAM_GOODGUYS,
        NeverMoveToClearSpace = true
    }

    local unit = CreateUnitFromTable(unitTable, target)
    if unit then 
        unit:SetAbsOrigin(Vector(worldX, worldY, target.z)) 
        unit:SetOwner(caster)
        local airGround = "modifier_ground_tower"
        if isAir then airGround = "modifier_air_tower" end
        unit:AddNewModifier(unit, nil, airGround, nil)
        return unit
    end

    return nil
end

-----------------------------------------------------------------------------

ability_siege_tower = class(ability_build_tower)

function ability_siege_tower:GetGoldCost(level) return self:GetSpecialValueFor("price") end 

function ability_siege_tower:OnSpellStart()
	if IsServer() then self:CreateTower("npc_td_siege_tower_1", false) end
end

-----------------------------------------------------------------------------

ability_air_tower = class(ability_build_tower)

function ability_air_tower:GetGoldCost(level) return self:GetSpecialValueFor("price") end 

function ability_air_tower:OnSpellStart()
	if IsServer() then self:CreateTower("npc_td_siege_tower_1", true) end
end

-----------------------------------------------------------------------------

ability_aura_tower = class(ability_build_tower)

function ability_aura_tower:GetGoldCost(level) return self:GetSpecialValueFor("price") end 

function ability_aura_tower:OnSpellStart()
	if IsServer() then self:CreateTower("npc_td_siege_tower_1", false) end
end

-----------------------------------------------------------------------------

ability_poison_tower = class(ability_build_tower)

function ability_poison_tower:GetGoldCost(level) return self:GetSpecialValueFor("price") end 

function ability_poison_tower:OnSpellStart()
	if IsServer() then self:CreateTower("npc_td_siege_tower_1", false) end
end

-----------------------------------------------------------------------------

ability_frost_tower = class(ability_build_tower)

function ability_frost_tower:GetGoldCost(level) return self:GetSpecialValueFor("price") end 

function ability_frost_tower:OnSpellStart()
	if IsServer() then self:CreateTower("npc_td_siege_tower_1", false) end
end

-----------------------------------------------------------------------------