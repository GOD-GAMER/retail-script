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
    if type(pos1) == 'table' then pos1 = vector3(pos1.x, pos1.y, pos1.z) end
    if type(pos2) == 'table' then pos2 = vector3(pos2.x, pos2.y, pos2.z) end
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

function RetailJobs.CanPlayerPerformAction(playerData, action)
    if not playerData or not playerData.rank then return false end
    
    local rank = playerData.rank
    local perks = Config.Ranks[rank] and Config.Ranks[rank].perks or {}
    
    local requiredPerks = {
        manage_inventory = {'manage_inventory'},
        hire_fire = {'hire_fire'},
        set_prices = {'set_prices'},
        full_management = {'full_management'},
        owner_privileges = {'owner_privileges'},
        multi_store_access = {'multi_store_access'},
        executive_perks = {'executive_perks'},
        unlimited_perks = {'unlimited_perks'}
    }
    
    if requiredPerks[action] then
        for _, perk in ipairs(requiredPerks[action]) do
            for _, playerPerk in ipairs(perks) do
                if playerPerk == perk or playerPerk == 'unlimited_perks' then
                    return true
                end
            end
        end
        return false
    end
    
    return true
end

-- Store Management
function RetailJobs.GetNearestStore(coords)
    local nearestStore = nil
    local nearestDistance = math.huge
    
    for i, store in ipairs(Config.Stores) do
        local distance = RetailJobs.GetDistance(coords, store.coords)
        if distance < nearestDistance then
            nearestDistance = distance
            nearestStore = store
            nearestStore.id = i
        end
    end
    
    return nearestStore, nearestDistance
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
            xPlayer.addMoney(amount)
        end
    elseif Config.Framework == 'qbcore' then
        local Player = QBCore.Functions.GetPlayer(playerId)
        if Player then
            Player.Functions.AddMoney('cash', amount)
        end
    else
        -- Standalone implementation
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