modifier_phased_custom = class({})

function modifier_phased_custom:IsHidden()
    return true
end

function modifier_phased_custom:IsDebuff()
    return false
end

function modifier_phased_custom:IsPurgable()
    return false
end

function modifier_phased_custom:CheckState()
    return {
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
end