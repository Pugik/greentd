_ADDON.currentWave = 0

local waveInterval = 30 
local waves = {
    {
        creeps = {"tiny_zombie"},
        count = 100
    },
    {
        creeps = {"tiny_zombie"},
        count = 10
    },
    {
        creeps = {"tiny_zombie"},
        count = 25
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
    local path = Entities:FindByName(nil, "path0")

    local function SpawnCreep()
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