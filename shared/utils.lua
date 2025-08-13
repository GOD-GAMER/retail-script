RetailJobs = {}
RetailJobs.PlayerData = {}
RetailJobs.JobData = {}

-- Utility Functions
function RetailJobs.Debug(message)
    if Config.Debug then
        print('[RetailJobs Debug] ' .. tostring(message))
    end
end

function RetailJobs.GetDistance(pos1, pos2)
    if type(pos1) == "table" then
        pos1 = vector3(pos1.x or pos1[1], pos1.y or pos1[2], pos1.z or pos1[3])
    end
    if type(pos2) == "table" then
        pos2 = vector3(pos2.x or pos2[1], pos2.y or pos2[2], pos2.z or pos2[3])
    end
    return #(pos1 - pos2)
end

function RetailJobs.Round(num, decimals)
    local mult = 10^(decimals or 0)
    return math.floor(num * mult + 0.5) / mult
end

-- Experience and Ranking System
function RetailJobs.CalculateRequiredExp(rank)
    if Config.Ranks[rank] then
        return Config.Ranks[rank].required_exp
    end
    return 0
end

function RetailJobs.GetPlayerRank(experience)
    local rank = 1
    
    for i = #Config.Ranks, 1, -1 do
        if experience >= Config.Ranks[i].required_exp then
            rank = i
            break
        end
    end
    
    return rank
end

-- Check if player can perform an action based on rank and perks
function RetailJobs.CanPlayerPerformAction(playerData, action)
    if not playerData or not playerData.rank then return false end
    
    local rank = playerData.rank
    local rankData = Config.Ranks[rank]
    
    if not rankData then return false end
    
    -- Define action requirements
    local actionRequirements = {
        serve_customers = 1,      -- Everyone can serve customers
        manage_inventory = 4,     -- Team Leader and above
        hire_fire = 5,           -- Supervisor and above
        set_prices = 5,          -- Supervisor and above
        full_management = 6,     -- Assistant Manager and above
        owner_privileges = 7,    -- Store Manager and above
        multi_store_access = 8,  -- District Manager and above
        executive_perks = 9,     -- Regional Manager and above
        unlimited_perks = 10     -- CEO only
    }
    
    local requiredRank = actionRequirements[action]
    if not requiredRank then return false end
    
    return rank >= requiredRank
end

-- Store Management
function RetailJobs.GetNearestStore(coords)
    local closestStore = nil
    local closestDistance = math.huge
    local closestIndex = nil
    
    for i, store in ipairs(Config.Stores) do
        local distance = RetailJobs.GetDistance(coords, store.coords)
        if distance < closestDistance then
            closestDistance = distance
            closestStore = store
            closestIndex = i
        end
    end
    
    if closestStore then
        closestStore.id = closestIndex
    end
    
    return closestStore, closestDistance
end

function RetailJobs.IsPlayerAtWork(playerId)
    return RetailJobs.PlayerData[playerId] and RetailJobs.PlayerData[playerId].onDuty or false
end

-- Notification System
function RetailJobs.ShowNotification(message, type, duration)
    -- This will be implemented in client-side
    TriggerEvent('retail:showNotification', message, type or 'info', duration or 5000)
end

-- Money Handling
function RetailJobs.AddMoney(playerId, amount, reason)
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            xPlayer.addAccountMoney(Config.Currency, amount)
        end
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            Player.Functions.AddMoney(Config.Currency, amount, reason)
        end
    else
        -- Standalone - trigger client event to handle money
        TriggerClientEvent('retail:addMoney', playerId, amount, reason)
    end
end

function RetailJobs.RemoveMoney(playerId, amount)
    if Config.Framework == 'esx' then
        local xPlayer = ESX.GetPlayerFromId(playerId)
        if xPlayer then
            return xPlayer.removeMoney(amount)
        end
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            return Player.Functions.RemoveMoney('cash', amount)
        end
    else
        -- Standalone implementation
        TriggerClientEvent('retail:removeMoney', playerId, amount)
        return true
    end
    return false
end

-- Format money for display
function RetailJobs.FormatMoney(amount)
    return '$' .. string.format('%d', amount)
end

-- Debug logging function
function RetailJobs.DebugPrint(message, level)
    if not Config.Debug then return end
    
    level = level or 'info'
    if Config.LogLevel == 'debug' or 
       (Config.LogLevel == 'info' and level ~= 'debug') or
       (Config.LogLevel == 'warn' and (level == 'warn' or level == 'error')) or
       (Config.LogLevel == 'error' and level == 'error') then
        print('^3[RETAIL JOBS]^0 [' .. string.upper(level) .. '] ' .. message)
    end
end