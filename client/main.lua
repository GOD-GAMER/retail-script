local QBCore = nil
local ESX = nil

-- Framework Detection
if Config.Framework == 'qbcore' then
    QBCore = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'esx' then
    ESX = exports["es_extended"]:getSharedObject()
end

-- Local variables
local playerData = {}
local nearbyStore = nil
local onDuty = false
local currentStoreId = nil
local jobType = nil
local npcCustomers = {}
local isFirstTimePlayer = true
local lastInteractionTime = 0

-- Current interaction state (prevent flickering)
local activeInteraction = nil
local lastInteractionCheck = 0

-- Initialize
Citizen.CreateThread(function()
    -- Create blips
    for i, store in ipairs(Config.Stores) do
        local blip = AddBlipForCoord(store.coords.x, store.coords.y, store.coords.z)
        SetBlipSprite(blip, store.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, store.blip.scale)
        SetBlipColour(blip, store.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(store.name)
        EndTextCommandSetBlipName(blip)
    end
    
    -- Create NPCs
    for i, store in ipairs(Config.Stores) do
        if store.npc then
            RequestModel(GetHashKey(store.npc.model))
            while not HasModelLoaded(GetHashKey(store.npc.model)) do
                Wait(1)
            end
            
            local npc = CreatePed(4, GetHashKey(store.npc.model), store.npc.coords.x, store.npc.coords.y, store.npc.coords.z - 1.0, store.npc.coords.w, false, true)
            SetEntityCanBeDamaged(npc, false)
            SetPedCanRagdollFromPlayerImpact(npc, false)
            SetBlockingOfNonTemporaryEvents(npc, true)
            SetPedFleeAttributes(npc, 0, 0)
            FreezeEntityPosition(npc, true)
            
            -- Store NPC reference
            store.npcEntity = npc
        end
    end
    
    TriggerServerEvent('retail:playerLoaded')
end)

-- Optimized Main Loop with Anti-Flicker System
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000
        local currentTime = GetGameTimer()
        
        -- Only check interactions every 100ms to prevent flickering
        if currentTime - lastInteractionCheck > 100 then
            lastInteractionCheck = currentTime
            
            -- Clear active interaction
            activeInteraction = nil
            
            -- Check nearby stores
            local closestStore, distance = RetailJobs.GetNearestStore(playerCoords)
            
            if distance < 50.0 then
                sleep = 100
                nearbyStore = closestStore
                
                -- Check interactions in priority order
                activeInteraction = GetHighestPriorityInteraction(closestStore, playerCoords, currentTime)
            else
                nearbyStore = nil
            end
        end
        
        -- Display interaction if one is active
        if activeInteraction then
            DrawText3D(activeInteraction.coords.x, activeInteraction.coords.y, activeInteraction.coords.z + activeInteraction.height, activeInteraction.text)
            sleep = 0 -- Keep rendering
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Get the highest priority interaction (prevents flickering)
function GetHighestPriorityInteraction(store, playerCoords, currentTime)
    local interactions = {}
    
    -- Check clock in/out (highest priority)
    local clockInteraction = CheckClockInOutInteraction(store, playerCoords, currentTime)
    if clockInteraction then
        table.insert(interactions, clockInteraction)
    end
    
    -- Check work stations (only when on duty)
    if onDuty and currentStoreId == store.id then
        local workStationInteractions = CheckWorkStationInteractions(store, playerCoords, currentTime)
        for _, interaction in ipairs(workStationInteractions) do
            table.insert(interactions, interaction)
        end
        
        -- Check customer interactions
        local customerInteraction = CheckCustomerInteractions(playerCoords, currentTime)
        if customerInteraction then
            table.insert(interactions, customerInteraction)
        end
    end
    
    -- Return highest priority interaction
    if #interactions > 0 then
        table.sort(interactions, function(a, b)
            return a.priority > b.priority
        end)
        return interactions[1]
    end
    
    return nil
end

-- Check clock in/out interactions
function CheckClockInOutInteraction(store, playerCoords, currentTime)
    local clockCoords = store.clockInOut or store.coords
    local distance = RetailJobs.GetDistance(playerCoords, clockCoords)
    
    if distance < Config.Interactions.distances.clockInOut then
        local interaction = {
            type = 'clockInOut',
            priority = Config.Interactions.priorities.clockInOut,
            coords = clockCoords,
            height = 1.2,
            storeId = store.id,
            jobType = store.type,
            action = function()
                if currentTime - lastInteractionTime < Config.Interactions.cooldown then 
                    if Config.Debug then
                        print('[RETAIL] Interaction on cooldown')
                    end
                    return 
                end
                lastInteractionTime = currentTime
                
                if Config.Debug then
                    print('[RETAIL] Executing clock in/out action')
                    print('[RETAIL] On duty: ' .. tostring(onDuty))
                    print('[RETAIL] Current store ID: ' .. tostring(currentStoreId))
                    print('[RETAIL] Target store ID: ' .. tostring(store.id))
                end
                
                if not onDuty then
                    ClockIn(store.id, store.type)
                elseif currentStoreId == store.id then
                    ClockOut()
                else
                    ShowNotification('You must clock out of your current job first', 'error')
                end
            end
        }
        
        if not onDuty then
            interaction.text = '~g~[Numpad 2]~w~ Clock In - ' .. store.name
        elseif onDuty and currentStoreId == store.id then
            interaction.text = '~r~[Numpad 2]~w~ Clock Out'
        else
            interaction.text = '~y~[Numpad 2]~w~ Clock out of current job first'
        end
        
        return interaction
    end
    
    return nil
end

-- Check work station interactions
function CheckWorkStationInteractions(store, playerCoords, currentTime)
    local interactions = {}
    
    if not store.workStations then return interactions end
    
    for stationType, coords in pairs(store.workStations) do
        local distance = RetailJobs.GetDistance(playerCoords, coords)
        
        if distance < Config.Interactions.distances.workStation then
            local interaction = {
                type = 'workStation',
                subType = stationType,
                priority = Config.Interactions.priorities.workStation,
                coords = coords,
                height = 0.8,
                text = '~b~[Numpad 2]~w~ ' .. GetWorkStationText(stationType),
                action = function()
                    if currentTime - lastInteractionTime < Config.Interactions.cooldown then return end
                    lastInteractionTime = currentTime
                    PerformWorkStationAction(stationType, store)
                end
            }
            
            table.insert(interactions, interaction)
        end
    end
    
    return interactions
end

-- Check customer interactions
function CheckCustomerInteractions(playerCoords, currentTime)
    local nearbyCustomers = GetNearbyCustomers()
    
    if #nearbyCustomers > 0 then
        return {
            type = 'customer',
            priority = Config.Interactions.priorities.customer,
            coords = playerCoords,
            height = 0.5,
            text = '~y~[G]~w~ Serve Customer (' .. #nearbyCustomers .. ' nearby)',
            action = function()
                if currentTime - lastInteractionTime < Config.Interactions.cooldown then return end
                lastInteractionTime = currentTime
                QuickServeNearestCustomer()
            end
        }
    end
    
    return nil
end

-- Event handlers for keybind events
RegisterNetEvent('retail:localInteract')
AddEventHandler('retail:localInteract', function()
    if Config.Debug then
        print('[RETAIL] Interact key pressed')
    end
    
    if activeInteraction and activeInteraction.action then
        if Config.Debug then
            print('[RETAIL] Executing interaction: ' .. activeInteraction.type)
        end
        
        local currentTime = GetGameTimer()
        if currentTime - lastInteractionTime > Config.Interactions.cooldown then
            lastInteractionTime = currentTime
            activeInteraction.action()
        else
            if Config.Debug then
                print('[RETAIL] Interaction on cooldown')
            end
        end
    else
        if Config.Debug then
            print('[RETAIL] No active interaction found')
        end
    end
end)

RegisterNetEvent('retail:localOpenMenu')
AddEventHandler('retail:localOpenMenu', function()
    if onDuty then
        OpenJobMenu()
    end
end)

RegisterNetEvent('retail:localQuickServe')
AddEventHandler('retail:localQuickServe', function()
    if onDuty then
        QuickServeNearestCustomer()
    end
end)

function GetWorkStationText(stationType)
    local texts = {
        cashier = 'Serve Customers',
        kitchen = 'Prepare Food',
        inventory = 'Manage Inventory',
        office = 'Management Tasks',
        drive_thru = 'Drive-Thru Service'
    }
    
    return texts[stationType] or 'Interact'
end

function PerformWorkStationAction(stationType, store)
    if stationType == 'cashier' then
        OpenCashierMenu()
    elseif stationType == 'kitchen' then
        StartCooking()
    elseif stationType == 'inventory' then
        OpenInventoryMenu()
    elseif stationType == 'office' then
        OpenManagementMenu()
    elseif stationType == 'drive_thru' then
        ServeDriveThru()
    end
end

-- Clock In/Out Functions
function ClockIn(storeId, jobType)
    RetailJobs.DebugPrint('Attempting to clock in at store ' .. storeId .. ' (job type: ' .. jobType .. ')', 'debug')
    
    -- Show immediate feedback
    ShowNotification('Clocking in...', 'info', 2000)
    
    TriggerServerEvent('retail:clockIn', storeId, jobType)
    
    -- Check if this is the player's first time
    if isFirstTimePlayer then
        isFirstTimePlayer = false
        TriggerServerEvent('retail:firstTimeBonus')
    end
end

function ClockOut()
    RetailJobs.DebugPrint('Attempting to clock out', 'debug')
    
    -- Show immediate feedback
    ShowNotification('Clocking out...', 'info', 2000)
    
    TriggerServerEvent('retail:clockOut')
end

-- Simplified Menu System (ESX compatible)
function OpenJobMenu()
    if Config.Framework == 'esx' and ESX then
        local elements = {
            {label = 'View Stats', value = 'stats'},
            {label = 'Current Rank: ' .. (playerData.rank and Config.Ranks[playerData.rank].name or 'Trainee'), value = 'rank'},
            {label = 'Experience: ' .. (playerData.experience or 0), value = 'experience'},
            {label = 'Today\'s Earnings: $' .. (playerData.earnings or 0), value = 'earnings'}
        }
        
        if playerData.rank and playerData.rank >= 4 then
            table.insert(elements, {label = 'Management Tools', value = 'management'})
        end
        
        table.insert(elements, {label = 'Training Modules', value = 'training'})
        table.insert(elements, {label = 'Clock Out', value = 'clockout'})
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'job_menu', {
            title = 'Job Menu',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'clockout' then
                ClockOut()
                menu.close()
            elseif data.current.value == 'stats' then
                ShowPlayerStats()
            end
        end, function(data, menu)
            menu.close()
        end)
    else
        -- Fallback for other frameworks
        ShowNotification('Job Menu - Experience: ' .. (playerData.experience or 0) .. ' | Rank: ' .. (playerData.rank and Config.Ranks[playerData.rank].name or 'Trainee'), 'info', 5000)
    end
end

function OpenCashierMenu()
    if not RetailJobs.CanPlayerPerformAction(playerData, 'serve_customers') then
        ShowNotification('You need more experience to use the cashier system', 'error')
        return
    end
    
    local nearbyCustomers = GetNearbyCustomers()
    if #nearbyCustomers == 0 then
        ShowNotification('No customers nearby', 'info')
        return
    end
    
    -- Serve the first customer automatically
    ServeCustomer(nearbyCustomers[1])
end

function OpenInventoryMenu()
    if not RetailJobs.CanPlayerPerformAction(playerData, 'manage_inventory') then
        ShowNotification('You do not have permission to manage inventory', 'error')
        return
    end
    
    ShowNotification('Restocking inventory...', 'info')
    -- Simulate restocking
    Citizen.SetTimeout(2000, function()
        TriggerServerEvent('retail:restockItem', currentStoreId, 'All Items', 10)
    end)
end

function OpenManagementMenu()
    if not RetailJobs.CanPlayerPerformAction(playerData, 'full_management') then
        ShowNotification('You do not have management permissions', 'error')
        return
    end
    
    ShowNotification('Management tools accessed', 'success')
end

function StartCooking()
    ShowNotification('Preparing food items...', 'info')
    -- Add cooking simulation here
end

function ServeDriveThru()
    ShowNotification('Serving drive-thru customer...', 'info')
    -- Add drive-thru logic here
end

-- Customer System
function SpawnCustomerNPC()
    if not Config.NPCCustomers.enabled or not onDuty then return end
    
    local store = Config.Stores[currentStoreId]
    if not store then return end
    
    local customerCount = 0
    for _ in pairs(npcCustomers) do
        customerCount = customerCount + 1
    end
    
    if customerCount >= Config.NPCCustomers.maxCustomers then return end
    
    if math.random(100) <= Config.NPCCustomers.spawnChance then
        local model = Config.NPCCustomers.models[math.random(#Config.NPCCustomers.models)]
        local spawnCoords = GetRandomSpawnPoint(store.coords, Config.NPCCustomers.spawnRadius)
        
        RequestModel(GetHashKey(model))
        while not HasModelLoaded(GetHashKey(model)) do
            Wait(1)
        end
        
        local customer = CreatePed(4, GetHashKey(model), spawnCoords.x, spawnCoords.y, spawnCoords.z, 0.0, true, true)
        SetEntityCanBeDamaged(customer, false)
        SetPedCanRagdollFromPlayerImpact(customer, false)
        SetBlockingOfNonTemporaryEvents(customer, true)
        
        local customerId = 'customer_' .. GetGameTimer()
        npcCustomers[customerId] = {
            entity = customer,
            state = 'browsing',
            wantsToBuy = math.random(100) <= (Config.NPCCustomers.purchaseChance.single_item + Config.NPCCustomers.purchaseChance.multiple_items),
            patience = math.random(Config.NPCCustomers.waitTimes.min, Config.NPCCustomers.waitTimes.max),
            items = GenerateCustomerItems()
        }
        
        -- Make customer walk around
        TaskWanderInArea(customer, spawnCoords.x, spawnCoords.y, spawnCoords.z, 10.0, 10.0, 10.0)
        
        Citizen.SetTimeout(Config.NPCCustomers.waitTimes.max, function()
            if npcCustomers[customerId] then
                DeleteCustomer(customerId)
            end
        end)
    end
end

function GenerateCustomerItems()
    local store = Config.Stores[currentStoreId]
    if not store or not store.products then return {} end
    
    local items = {}
    local purchaseType = math.random(100)
    
    if purchaseType <= Config.NPCCustomers.purchaseChance.single_item then
        local product = store.products[math.random(#store.products)]
        table.insert(items, {
            name = product.name,
            price = product.price,
            quantity = 1
        })
    elseif purchaseType <= (Config.NPCCustomers.purchaseChance.single_item + Config.NPCCustomers.purchaseChance.multiple_items) then
        local numItems = math.random(2, math.min(4, #store.products))
        for i = 1, numItems do
            local product = store.products[math.random(#store.products)]
            table.insert(items, {
                name = product.name,
                price = product.price,
                quantity = math.random(1, 2)
            })
        end
    end
    
    return items
end

function ServeCustomer(customerId)
    local customer = npcCustomers[customerId]
    if not customer then return end
    
    if not customer.wantsToBuy or #customer.items == 0 then
        ShowNotification('Customer decided not to buy anything', 'info')
        DeleteCustomer(customerId)
        return
    end
    
    local total = 0
    for _, item in ipairs(customer.items) do
        total = total + (item.price * item.quantity)
    end
    
    ShowNotification('Processing sale: ' .. RetailJobs.FormatMoney(total), 'info')
    
    Citizen.SetTimeout(2000, function()
        TriggerServerEvent('retail:serveCustomer', customerId, customer.items, total)
        DeleteCustomer(customerId)
    end)
end

function QuickServeNearestCustomer()
    local nearbyCustomers = GetNearbyCustomers()
    if #nearbyCustomers > 0 then
        ServeCustomer(nearbyCustomers[1])
    else
        ShowNotification('No customers nearby to serve', 'info')
    end
end

function DeleteCustomer(customerId)
    local customer = npcCustomers[customerId]
    if customer and customer.entity then
        DeleteEntity(customer.entity)
    end
    npcCustomers[customerId] = nil
end

function GetNearbyCustomers()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local nearby = {}
    
    for customerId, customer in pairs(npcCustomers) do
        if customer.entity and DoesEntityExist(customer.entity) then
            local customerCoords = GetEntityCoords(customer.entity)
            local distance = RetailJobs.GetDistance(playerCoords, customerCoords)
            
            if distance < Config.Interactions.distances.customer then
                table.insert(nearby, customerId)
            end
        end
    end
    
    return nearby
end

-- Utility Functions
function ShowNotification(message, type, duration)
    if Config.Debug then
        print('[RETAIL] Notification: ' .. message .. ' (Type: ' .. (type or 'info') .. ')')
    end
    
    -- ESX Notification (Primary method for ESX servers)
    if Config.Framework == 'esx' and ESX then
        if type == 'error' then
            ESX.ShowNotification('~r~' .. message)
        elseif type == 'success' then
            ESX.ShowNotification('~g~' .. message)
        elseif type == 'warning' then
            ESX.ShowNotification('~y~' .. message)
        else
            ESX.ShowNotification(message)
        end
    -- QBCore Notification
    elseif Config.Framework == 'qbcore' and QBCore then
        QBCore.Functions.Notify(message, type or 'primary', duration or 5000)
    else
        -- Fallback to native GTA notification
        SetNotificationTextEntry("STRING")
        AddTextComponentString(message)
        DrawNotification(0, 1)
        
        -- Also show in chat as backup
        TriggerEvent('chat:addMessage', {
            color = {255, 255, 255},
            args = {"Retail Jobs", message}
        })
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local px, py, pz = table.unpack(GetGameplayCamCoords())
        local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
        local scale = (1 / dist) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        scale = scale * fov
        
        SetTextScale(0.0 * scale, 0.5 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function GetRandomSpawnPoint(center, radius)
    local angle = math.random() * 2 * math.pi
    local distance = math.random() * radius
    
    return vector3(
        center.x + distance * math.cos(angle),
        center.y + distance * math.sin(angle),
        center.z
    )
end

function ShowPlayerStats()
    local message = string.format(
        "~b~Retail Job Stats~w~\n" ..
        "Rank: %s\n" ..
        "Experience: %d\n" ..
        "Earnings: $%d",
        playerData.rank and Config.Ranks[playerData.rank].name or 'Trainee',
        playerData.experience or 0,
        playerData.earnings or 0
    )
    ShowNotification(message, 'info', 8000)
end

-- Loops
Citizen.CreateThread(function()
    while true do
        if onDuty and currentStoreId then
            SpawnCustomerNPC()
        end
        Citizen.Wait(30000)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(Config.Optimization.npcCleanupTime)
        
        for customerId, customer in pairs(npcCustomers) do
            if customer.entity and not DoesEntityExist(customer.entity) then
                npcCustomers[customerId] = nil
            end
        end
    end
end)

-- Event Handlers
RegisterNetEvent('retail:clockedIn')
AddEventHandler('retail:clockedIn', function(storeId, jobType)
    onDuty = true
    currentStoreId = storeId
    jobType = jobType
    ShowNotification('Successfully clocked in at ' .. Config.Stores[storeId].name, 'success')
    RetailJobs.DebugPrint('Player clocked in at store ' .. storeId, 'info')
end)

RegisterNetEvent('retail:clockedOut')
AddEventHandler('retail:clockedOut', function(finalPay)
    onDuty = false
    currentStoreId = nil
    jobType = nil
    
    -- Cleanup customers
    for customerId, customer in pairs(npcCustomers) do
        DeleteCustomer(customerId)
    end
    
    ShowNotification('Clocked out successfully! Pay: ' .. RetailJobs.FormatMoney(finalPay), 'success')
    RetailJobs.DebugPrint('Player clocked out, final pay: ' .. finalPay, 'info')
end)

RegisterNetEvent('retail:experienceGained')
AddEventHandler('retail:experienceGained', function(amount, reason)
    ShowNotification('Experience gained: +' .. amount .. ' (' .. reason .. ')', 'success')
end)

RegisterNetEvent('retail:promoted')
AddEventHandler('retail:promoted', function(newRank, rankData)
    ShowNotification('?? PROMOTION! You are now a ' .. rankData.name, 'success', 10000)
end)

RegisterNetEvent('retail:receivePlayerData')
AddEventHandler('retail:receivePlayerData', function(data)
    playerData = data or {}
    RetailJobs.DebugPrint('Received player data: Rank ' .. (playerData.rank or 1) .. ', XP ' .. (playerData.experience or 0), 'debug')
end)

RegisterNetEvent('retail:notify')
AddEventHandler('retail:notify', function(message, type, duration)
    ShowNotification(message, type, duration)
end)

RegisterNetEvent('retail:newPlayerWelcome')
AddEventHandler('retail:newPlayerWelcome', function()
    if Config.NewPlayerBonus.enabled then
        ShowNotification('?? ' .. Config.NewPlayerBonus.welcomeMessage, 'success', 10000)
        ShowNotification('You\'ve received ' .. Config.NewPlayerBonus.startingExperience .. ' starting experience!', 'success', 8000)
    end
end)

-- Debug command for troubleshooting
RegisterCommand('retaildebug', function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestStore, distance = RetailJobs.GetNearestStore(playerCoords)
    
    local debugInfo = string.format([[:
^3=== RETAIL JOBS DEBUG INFO ===^0
^2Player Position:^0 %.2f, %.2f, %.2f
^2Nearest Store:^0 %s
^2Distance to Store:^0 %.2f
^2On Duty:^0 %s
^2Current Store ID:^0 %s
^2Active Interaction:^0 %s
^2Framework:^0 %s
^2ESX Available:^0 %s
    ]], 
    playerCoords.x, playerCoords.y, playerCoords.z,
    closestStore and closestStore.name or "None",
    distance or 0,
    onDuty and "Yes" or "No",
    currentStoreId or "None", 
    activeInteraction and activeInteraction.type or "None",
    Config.Framework,
    ESX and "Yes" or "No"
    )
    
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = true,
        args = {"Retail Debug", debugInfo}
    })
    
    -- Also check if player is near any store
    if closestStore and distance < 10.0 then
        local clockCoords = closestStore.clockInOut or closestStore.coords
        local clockDistance = RetailJobs.GetDistance(playerCoords, clockCoords)
        
        local storeDebug = string.format([[:
^3=== STORE DEBUG INFO ===^0
^2Store Coords:^0 %.2f, %.2f, %.2f
^2Clock Coords:^0 %.2f, %.2f, %.2f
^2Distance to Clock:^0 %.2f
^2Required Distance:^0 %.2f
^2Can Clock In:^0 %s
        ]],
        closestStore.coords.x, closestStore.coords.y, closestStore.coords.z,
        clockCoords.x, clockCoords.y, clockCoords.z,
        clockDistance,
        Config.Interactions.distances.clockInOut,
        clockDistance < Config.Interactions.distances.clockInOut and "Yes" or "No"
        )
        
        TriggerEvent('chat:addMessage', {
            color = {255, 255, 255},
            multiline = true,
            args = {"Store Debug", storeDebug}
        })
    end
end, false)