modifier_speed_cap = class({})

function modifier_speed_cap:IsHidden()
    return true
end

function modifier_speed_cap:IsDebuff()
    return false
end

function modifier_speed_cap:IsPurgable()
    return false
end

function modifier_speed_cap:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_IGNORE_MOVESPEED_LIMIT,
    }

    return funcs
end

function modifier_speed_cap:GetModifierIgnoreMovespeedLimit( params )
    return 1
end