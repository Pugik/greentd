_ADDON.currentWave = 0

local waveInterval = 30 
local waves = {
    {
        creeps = {
            {name = "npc_td_creep_ground_zombie", count = 10}
        }
    },
    {
        creeps = {
            {name = "npc_td_creep_ground_zombie", count = 10},
            {name = "npc_td_creep_air_test", count = 5}
        }
    },
    {
        creeps = {
            {name = "npc_td_creep_ground_zombie", count = 5},
            {name = "npc_td_creep_air_test", count = 10}
        }
    },
    {
        creeps = {
            {name = "npc_td_creep_air_test", count = 20}
        }
    },
    {
        creeps = {
            {name = "npc_td_creep_ground_zombie", count = 50},
            {name = "npc_td_creep_air_test", count = 10}
        }
    },
    {
        creeps = {
            {name = "npc_td_creep_air_test", count = 50}
        }
    }
}

function _ADDON:StartNextWave()
    self.currentWave = self.currentWave + 1

    if self.currentWave > #waves then
        self.currentWave = 1 -- only for testing
        --return
    end

    print("currentWave: ", self.currentWave)

    local waveData = waves[self.currentWave]
    local creeps = waveData.creeps
    local path = Entities:FindByName(nil, "path0")
    
    local totalCreeps = 0
    for _, creepData in ipairs(creeps) do
        totalCreeps = totalCreeps + creepData.count
    end

    local function SpawnCreep(creepName)
        local spawnPoint = path:GetAbsOrigin()
        local creep = self:CreateUnit(creepName, DOTA_TEAM_BADGUYS, spawnPoint)
        if creep then
            creep:SetInitialGoalEntity(path)
            creep:AddNewModifier(creep, nil, "modifier_phased_custom", nil)
        else
            print("[ERROR] Creep with classname: ", creepName, " can't appear.")
        end
    end

    local function SpawnWaveCreeps(creepIndex, count)
        if count > 0 then
            local creepData = creeps[creepIndex]
            if creepData then
                SpawnCreep(creepData.name)
                Timers:CreateTimer(1, function()
                    SpawnWaveCreeps(creepIndex, count - 1)
                end)
            else
                print("[ERROR] Invalid creep index: ", creepIndex)
            end
        else
            local nextCreepIndex = creepIndex + 1
            if creeps[nextCreepIndex] then
                SpawnWaveCreeps(nextCreepIndex, creeps[nextCreepIndex].count)
            end
        end
    end

    if #creeps > 0 then
        SpawnWaveCreeps(1, creeps[1].count)
    end
    
    local totalWaveTime = waveInterval + totalCreeps
    Timers:CreateTimer(totalWaveTime, function()
        self:StartNextWave()
    end)
end