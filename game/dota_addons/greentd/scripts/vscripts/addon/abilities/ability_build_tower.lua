ability_build_tower = class({})
-----------------------------------------------------------------------------

function ability_build_tower:GetAOERadius()
    return 64
end

function ability_build_tower:GetGoldCost(level) return self:GetSpecialValueFor("price") end 

ability_build_tower.forbiddenZones = {
    {min = Vector(-1000, -1000, 0), max = Vector(1000, 1000, 0)}
}

function ability_build_tower:OnAbilityPhaseStart()
    local caster = self:GetCaster()
    local casterid = caster:GetPlayerID()
    local target = self:GetCursorPosition()
end

function ability_build_tower:OnSpellStart()
	if IsServer() then
        local caster = self:GetCaster()
        local casterid = caster:GetPlayerID()
        local target = self:GetCursorPosition()
        
        if self:IsPointInForbiddenZone(target) then
            print("z")
            self:ReturnGold(caster)
            return
        end

        if self:IsTowerAtLocation(target) then
            print("l")
            self:ReturnGold(caster)
            return
        end

        local cellX = math.floor(target.x / 256 + 0.5)
        local cellY = math.floor(target.y / 256 + 0.5)
    
        local worldX = cellX * 256
        local worldY = cellY * 256
    
        local unitTable = 
        { 	
            MapUnitName = "npc_td_tower_water", 
            teamnumber = DOTA_TEAM_GOODGUYS,
            NeverMoveToClearSpace = true
        }
    
        local unit = CreateUnitFromTable(unitTable, target)
        if unit then 
            unit:SetAbsOrigin(Vector(worldX, worldY, target.z)) 
            unit:SetOwner(caster)
        end
	end
end

function ability_build_tower:IsPointInForbiddenZone(target)
    for _, zone in pairs(self.forbiddenZones) do
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