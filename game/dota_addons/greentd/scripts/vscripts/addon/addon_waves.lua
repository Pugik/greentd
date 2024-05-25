_ADDON.currentWave = 0

local waveInterval = 30 
local waves = {
    {
        creeps = {"tiny_zombie"},
        count = 100,
        health_mult = 0.5,
        movespeed_mult = 0.5,
    },
    {
        creeps = {"tiny_zombie"},
        count = 10,
        health_mult = 2,
        movespeed_mult = 2,
    },
    {
        creeps = {"tiny_zombie"},
        count = 25,
        health_mult = 4,
        movespeed_mult = 4,
    }
}

function _ADDON:StartNextWave()
    self.currentWave = self.currentWave + 1
    print("currentWave: ", self.currentWave)

    if self.currentWave > #waves then
        return
    end

    local waveData = waves[self.currentWave]
    local creeps = waveData.creeps
    local count = waveData.count
    local health_mult = waveData.health_mult
    local movespeed_mult = waveData.movespeed_mult
    local path = Entities:FindByName(nil, "path0")

    local function SpawnCreep()
        for _, creepName in pairs(creeps) do
            local spawnPoint = path:GetAbsOrigin()
            local creep = self:CreateUnit(creepName, DOTA_TEAM_BADGUYS, path:GetAbsOrigin())
            if creep then
                local cHealth = math.floor(creep:GetHealth() * health_mult)
                creep:SetMaxHealth(150)
                creep:SetHealth(150)
                creep:SetInitialGoalEntity(path)
                creep:AddNewModifier(creep, nil, "modifier_phased", nil)
            else
                print("[ERROR] Creep with classname: ", creepName, " cant appear.")
            end
        end
    end

    local function SpawnWaveCreeps(i)
        if i <= count then
            SpawnCreep()
            Timers:CreateTimer(1, function()
                SpawnWaveCreeps(i + 1)
            end)
        end
    end

    SpawnWaveCreeps(1)

    --[[
    for i = 1, count do
        for _, creepName in pairs(creeps) do
            local spawnPoint = path:GetAbsOrigin()
            local creep = self:CreateUnit(creepName, DOTA_TEAM_BADGUYS, path:GetAbsOrigin())
            if creep then
                creep:SetInitialGoalEntity(path)
                creep:AddNewModifier(creep, nil, "modifier_phased", nil)
            else
                print("[ERROR] Creep with classname: ", creepName, " cant appear.")
            end
        end
    end
    ]]

    Timers:CreateTimer(waveInterval + count, function()
        self:StartNextWave()
    end)
end