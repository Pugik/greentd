LinkLuaModifier("modifier_ground_tower", "addon/modifiers/modifier_status_tower.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_air_tower", "addon/modifiers/modifier_status_tower.lua", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

modifier_status_tower = class({})

function modifier_status_tower:IsHidden()
    return false
end

function modifier_status_tower:IsDebuff()
    return false
end

function modifier_status_tower:IsPurgable()
    return false
end

function modifier_status_tower:FindNewTarget(attacker, isAir)
    local range = attacker:Script_GetAttackRange()
    local units = FindUnitsInRadius(
        attacker:GetTeamNumber(),
        attacker:GetAbsOrigin(),
        nil,
        range,
        DOTA_UNIT_TARGET_TEAM_ENEMY,
        DOTA_UNIT_TARGET_BASIC,
        DOTA_UNIT_TARGET_FLAG_NONE,
        FIND_ANY_ORDER,
        false
    )

    for _, unit in ipairs(units) do
        if isAir then
            if unit:HasFlyMovementCapability() then
                attacker:MoveToTargetToAttack(unit)
                return
            end
        else
            if not unit:HasFlyMovementCapability() then
                attacker:MoveToTargetToAttack(unit)
                return
            end
        end
    end
end

--------------------------------------------------------------------------------

modifier_ground_tower = class(modifier_status_tower)

--------------------------------------------------------------------------------

function modifier_ground_tower:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_ground_tower:OnAttackStart(data)
    if IsServer() then
        local attacker = data.attacker
        local target = data.target

        if attacker == self:GetParent() then
            if target:HasFlyMovementCapability() then
                attacker:Interrupt()
                self:FindNewTarget(attacker, false)
            end
        end
    end
end

--------------------------------------------------------------------------------

modifier_air_tower = class(modifier_status_tower)

--------------------------------------------------------------------------------

function modifier_air_tower:DeclareFunctions()
    return {
        MODIFIER_EVENT_ON_ATTACK_START,
    }
end

function modifier_air_tower:OnAttackStart(data)
    if IsServer() then
        local attacker = data.attacker
        local target = data.target

        if attacker == self:GetParent() then
            if not target:HasFlyMovementCapability() then
                attacker:Interrupt()
                self:FindNewTarget(attacker, true)
            end
        end
    end
end