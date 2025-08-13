local QBCore = nil
local ESX = nil

-- Framework Detection
if Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
end

local playerJobs = {}
local storeData = {}
local activeCustomers = {}

-- Initialize store data
for i, store in ipairs(Config.Stores) do
    storeData[i] = {
        products = {},
        employees = {},
        revenue = 0,
        dailyRevenue = 0
    }
    
    -- Initialize products
    for _, product in ipairs(store.products) do
        table.insert(storeData[i].products, {
            name = product.name,
            price = product.price,
            stock = product.stock,
            sold = 0
        })
    end
end

-- Player Management
RegisterNetEvent('retail:playerLoaded')
AddEventHandler('retail:playerLoaded', function()
    local playerId = source
    playerJobs[playerId] = {
        job = nil,
        rank = 1,
        experience = 0,
        onDuty = false,
        storeId = nil,
        earnings = 0,
        stats = {
            customersServed = 0,
            itemsSold = 0,
            shiftsWorked = 0,
            totalEarnings = 0
        }
    }
    
    -- Load from database if enabled
    if Config.UseDatabase then
        LoadPlayerJobData(playerId)
    end
end)

function LoadPlayerJobData(playerId)
    local identifier = GetPlayerIdentifier(playerId, 0)
    MySQL.Async.fetchAll('SELECT * FROM retail_jobs WHERE identifier = @identifier', {
        ['@identifier'] = identifier
    }, function(result)
        if result[1] then
            local data = result[1]
            playerJobs[playerId] = {
                job = data.job,
                rank = data.rank,
                experience = data.experience,
                onDuty = false,
                storeId = nil,
                earnings = data.earnings,
                stats = json.decode(data.stats) or {}
            }
        end
    end)
end

function SavePlayerJobData(playerId)
    if not Config.UseDatabase then return end
    
    local identifier = GetPlayerIdentifier(playerId, 0)
    local data = playerJobs[playerId]
    
    if data then
        MySQL.Async.execute('INSERT INTO retail_jobs (identifier, job, rank, experience, earnings, stats) VALUES (@identifier, @job, @rank, @experience, @earnings, @stats) ON DUPLICATE KEY UPDATE job = @job, rank = @rank, experience = @experience, earnings = @earnings, stats = @stats', {
            ['@identifier'] = identifier,
            ['@job'] = data.job,
            ['@rank'] = data.rank,
            ['@experience'] = data.experience,
            ['@earnings'] = data.earnings,
            ['@stats'] = json.encode(data.stats)
        })
    end
end

-- Job Management
RegisterNetEvent('retail:clockIn')
AddEventHandler('retail:clockIn', function(storeId, jobType)
    local playerId = source
    
    if not playerJobs[playerId] then
        playerJobs[playerId] = {
            job = nil,
            rank = 1,
            experience = 0,
            onDuty = false,
            storeId = nil,
            earnings = 0,
            stats = {
                customersServed = 0,
                itemsSold = 0,
                shiftsWorked = 0,
                totalEarnings = 0
            }
        }
    end
    
    local store = Config.Stores[storeId]
    if not store then return end
    
    -- Check if player can work at this store
    local currentEmployees = 0
    for pid, data in pairs(playerJobs) do
        if data.onDuty and data.storeId == storeId then
            currentEmployees = currentEmployees + 1
        end
    end
    
    local maxEmployees = Config.Jobs[jobType] and Config.Jobs[jobType].maxPlayers or 5
    if currentEmployees >= maxEmployees then
        TriggerClientEvent('retail:notify', playerId, 'This store is at maximum capacity!', 'error')
        return
    end
    
    playerJobs[playerId].job = jobType
    playerJobs[playerId].onDuty = true
    playerJobs[playerId].storeId = storeId
    playerJobs[playerId].stats.shiftsWorked = playerJobs[playerId].stats.shiftsWorked + 1
    
    table.insert(storeData[storeId].employees, playerId)
    
    TriggerClientEvent('retail:clockedIn', playerId, storeId, jobType)
    TriggerClientEvent('retail:notify', playerId, 'You have clocked in at ' .. store.name, 'success')
    
    -- Notify other employees
    for _, empId in ipairs(storeData[storeId].employees) do
        if empId ~= playerId then
            TriggerClientEvent('retail:notify', empId, GetPlayerName(playerId) .. ' has clocked in', 'info')
        end
    end
end)

RegisterNetEvent('retail:clockOut')
AddEventHandler('retail:clockOut', function()
    local playerId = source
    
    if not playerJobs[playerId] or not playerJobs[playerId].onDuty then
        return
    end
    
    local storeId = playerJobs[playerId].storeId
    local earnings = playerJobs[playerId].earnings
    
    -- Calculate final paycheck
    local rank = playerJobs[playerId].rank
    local baseWage = Config.Ranks[rank] and Config.Ranks[rank].salary or 100
    local finalPay = earnings + baseWage
    
    -- Add money to player
    RetailJobs.AddMoney(playerId, finalPay, 'Job Payment')
    
    -- Update stats
    playerJobs[playerId].stats.totalEarnings = playerJobs[playerId].stats.totalEarnings + finalPay
    playerJobs[playerId].earnings = 0
    playerJobs[playerId].onDuty = false
    playerJobs[playerId].storeId = nil
    
    -- Remove from store employees
    if storeId and storeData[storeId] then
        for i, empId in ipairs(storeData[storeId].employees) do
            if empId == playerId then
                table.remove(storeData[storeId].employees, i)
                break
            end
        end
    end
    
    TriggerClientEvent('retail:clockedOut', playerId, finalPay)
    TriggerClientEvent('retail:notify', playerId, 'You have clocked out. Earned: $' .. finalPay, 'success')
    
    -- Save data
    SavePlayerJobData(playerId)
end)

-- Experience and Promotion System
RegisterNetEvent('retail:addExperience')
AddEventHandler('retail:addExperience', function(amount, reason)
    local playerId = source
    
    if not playerJobs[playerId] then return end
    
    local oldRank = playerJobs[playerId].rank
    playerJobs[playerId].experience = playerJobs[playerId].experience + amount
    
    -- Check for promotion
    local newRank = RetailJobs.GetPlayerRank(playerJobs[playerId].experience)
    
    if newRank > oldRank then
        playerJobs[playerId].rank = newRank
        local rankData = Config.Ranks[newRank]
        
        TriggerClientEvent('retail:promoted', playerId, newRank, rankData)
        TriggerClientEvent('retail:notify', playerId, 'Congratulations! You have been promoted to ' .. rankData.name, 'success')
        
        -- Notify coworkers
        if playerJobs[playerId].storeId then
            for _, empId in ipairs(storeData[playerJobs[playerId].storeId].employees) do
                if empId ~= playerId then
                    TriggerClientEvent('retail:notify', empId, GetPlayerName(playerId) .. ' has been promoted to ' .. rankData.name, 'info')
                end
            end
        end
    end
    
    TriggerClientEvent('retail:experienceGained', playerId, amount, reason)
end)

-- Customer and Sales System
RegisterNetEvent('retail:serveCustomer')
AddEventHandler('retail:serveCustomer', function(customerId, items, total)
    local playerId = source
    
    if not playerJobs[playerId] or not playerJobs[playerId].onDuty then
        return
    end
    
    local storeId = playerJobs[playerId].storeId
    if not storeId or not storeData[storeId] then return end
    
    -- Process sale
    local commission = math.floor(total * 0.1) -- 10% commission
    playerJobs[playerId].earnings = playerJobs[playerId].earnings + commission
    playerJobs[playerId].stats.customersServed = playerJobs[playerId].stats.customersServed + 1
    
    -- Update store revenue
    storeData[storeId].revenue = storeData[storeId].revenue + total
    storeData[storeId].dailyRevenue = storeData[storeId].dailyRevenue + total
    
    -- Update product sales and stock
    for _, item in ipairs(items) do
        for i, product in ipairs(storeData[storeId].products) do
            if product.name == item.name then
                product.stock = math.max(0, product.stock - item.quantity)
                product.sold = product.sold + item.quantity
                playerJobs[playerId].stats.itemsSold = playerJobs[playerId].stats.itemsSold + item.quantity
                break
            end
        end
    end
    
    -- Add experience
    TriggerEvent('retail:addExperience', playerId, Config.Experience.serving_customer, 'Serving Customer')
    
    -- Check for performance bonuses
    if playerJobs[playerId].stats.customersServed % 10 == 0 then
        TriggerEvent('retail:addExperience', playerId, Config.Experience.perfect_service, 'Perfect Service Bonus')
    end
    
    TriggerClientEvent('retail:saleCompleted', playerId, commission, total)
    TriggerClientEvent('retail:removeCustomer', -1, customerId)
    
    -- Notify player
    TriggerClientEvent('retail:notify', playerId, 'Sale completed! Commission: $' .. commission, 'success')
end)

-- Store Management
RegisterNetEvent('retail:restockItem')
AddEventHandler('retail:restockItem', function(storeId, productName, quantity)
    local playerId = source
    
    if not playerJobs[playerId] or not playerJobs[playerId].onDuty then
        return
    end
    
    if not RetailJobs.CanPlayerPerformAction(playerJobs[playerId], 'manage_inventory') then
        TriggerClientEvent('retail:notify', playerId, 'You do not have permission to manage inventory', 'error')
        return
    end
    
    if storeData[storeId] then
        for i, product in ipairs(storeData[storeId].products) do
            if product.name == productName then
                product.stock = product.stock + quantity
                TriggerClientEvent('retail:notify', playerId, 'Restocked ' .. quantity .. ' ' .. productName, 'success')
                TriggerEvent('retail:addExperience', playerId, Config.Experience.restocking, 'Restocking')
                break
            end
        end
    end
end)

-- Events for client synchronization
RegisterNetEvent('retail:requestStoreData')
AddEventHandler('retail:requestStoreData', function(storeId)
    local playerId = source
    TriggerClientEvent('retail:receiveStoreData', playerId, storeId, storeData[storeId])
end)

RegisterNetEvent('retail:requestPlayerData')
AddEventHandler('retail:requestPlayerData', function()
    local playerId = source
    TriggerClientEvent('retail:receivePlayerData', playerId, playerJobs[playerId])
end)

-- Cleanup when player disconnects
AddEventHandler('playerDropped', function()
    local playerId = source
    
    if playerJobs[playerId] and playerJobs[playerId].onDuty then
        -- Auto clock out
        TriggerEvent('retail:clockOut', playerId)
    end
    
    playerJobs[playerId] = nil
end)

-- Daily reset for store revenue
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(24 * 60 * 60 * 1000) -- 24 hours
        
        for storeId, data in pairs(storeData) do
            data.dailyRevenue = 0
            -- Reset some product sales data
            for _, product in ipairs(data.products) do
                product.sold = 0
            end
        end
    end
end)

-- Exports
exports('getPlayerJobData', function(playerId)
    return playerJobs[playerId]
end)

exports('addExperience', function(playerId, amount, reason)
    TriggerEvent('retail:addExperience', playerId, amount, reason or 'Manual Addition')
end)

exports('promotePlayer', function(playerId, newRank)
    if playerJobs[playerId] and Config.Ranks[newRank] then
        playerJobs[playerId].rank = newRank
        playerJobs[playerId].experience = Config.Ranks[newRank].required_exp
        TriggerClientEvent('retail:promoted', playerId, newRank, Config.Ranks[newRank])
    end
end)

exports('getJobStores', function()
    return storeData
end)