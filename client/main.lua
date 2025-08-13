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
local workStations = {}
local isWorking = false
local lastInteractionTime = 0
local isFirstTimePlayer = true

-- UI State
local showingUI = false
local uiData = {}

-- Current interaction state
local currentInteractions = {}

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

-- Enhanced Main Loop with Interaction Priority System
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000
        local currentTime = GetGameTimer()
        
        -- Clear current interactions
        currentInteractions = {}
        
        -- Check nearby stores
        local closestStore, distance = RetailJobs.GetNearestStore(playerCoords)
        
        if distance < 50.0 then
            sleep = 100
            nearbyStore = closestStore
            
            -- Check for interactions based on priority
            CheckClockInOutInteraction(closestStore, playerCoords, currentTime)
            
            if onDuty and currentStoreId == closestStore.id then
                CheckWorkStationInteractions(closestStore, playerCoords, currentTime)
                CheckCustomerInteractions(playerCoords, currentTime)
            end
            
            -- Display highest priority interaction
            DisplayInteraction()
        else
            nearbyStore = nil
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Handle keybind input using FiveM native system
function HandleKeybindInput()
    -- The keybinds are now handled by FiveM's native system
    -- We just need to listen for our custom events
end

-- Event handlers for FiveM native keybinds
RegisterNetEvent('retail:localInteract')
AddEventHandler('retail:localInteract', function()
    HandleInteraction()
end)

RegisterNetEvent('retail:localOpenMenu')
AddEventHandler('retail:localOpenMenu', function()
    OpenJobMenu()
end)

RegisterNetEvent('retail:localQuickServe')
AddEventHandler('retail:localQuickServe', function()
    QuickServeNearestCustomer()
end)

-- Display the highest priority interaction
function DisplayInteraction()
    if #currentInteractions == 0 then return end
    
    -- Sort by priority (highest first)
    table.sort(currentInteractions, function(a, b)
        return a.priority > b.priority
    end)
    
    local topInteraction = currentInteractions[1]
    local coords = topInteraction.coords
    
    -- Adjust height based on interaction type
    local height = 1.0
    if topInteraction.type == 'workStation' then
        height = 0.5
    elseif topInteraction.type == 'customer' then
        height = 0.2
    end
    
    -- Use the FiveM keybind display text
    local displayText = topInteraction.text
    if topInteraction.type == 'clockInOut' or topInteraction.type == 'workStation' then
        displayText = displayText:gsub('%[E%]', '[INTERACT]') -- Replace with generic text
    elseif topInteraction.type == 'customer' then
        displayText = displayText:gsub('%[G%]', '[QUICK SERVE]') -- Replace with generic text
    end
    
    DrawText3D(coords.x, coords.y, coords.z + height, displayText)
end

-- Check clock in/out interactions (highest priority)
function CheckClockInOutInteraction(store, playerCoords, currentTime)
    local clockCoords = store.clockInOut or store.coords
    local distance = RetailJobs.GetDistance(playerCoords, clockCoords)
    
    if distance < Config.Interactions.distances.clockInOut then
        local interaction = {
            type = 'clockInOut',
            priority = Config.Interactions.priorities.clockInOut,
            coords = clockCoords,
            action = function()
                if currentTime - lastInteractionTime < Config.Interactions.cooldown then return end
                lastInteractionTime = currentTime
                
                if not onDuty then
                    ClockIn(store.id, store.type)
                elseif currentStoreId == store.id then
                    ClockOut()
                end
            end
        }
        
        if not onDuty then
            interaction.text = '[INTERACT] Clock In - ' .. store.name
        elseif onDuty and currentStoreId == store.id then
            interaction.text = '[INTERACT] Clock Out'
        end
        
        if interaction.text then
            table.insert(currentInteractions, interaction)
        end
    end
end

-- Check work station interactions
function CheckWorkStationInteractions(store, playerCoords, currentTime)
    if not store.workStations then return end
    
    for stationType, coords in pairs(store.workStations) do
        local distance = RetailJobs.GetDistance(playerCoords, coords)
        
        if distance < Config.Interactions.distances.workStation then
            local interaction = {
                type = 'workStation',
                subType = stationType,
                priority = Config.Interactions.priorities.workStation,
                coords = coords,
                text = '[INTERACT] ' .. GetWorkStationText(stationType),
                action = function()
                    if currentTime - lastInteractionTime < Config.Interactions.cooldown then return end
                    lastInteractionTime = currentTime
                    PerformWorkStationAction(stationType, store)
                end
            }
            
            table.insert(currentInteractions, interaction)
        end
    end
end

-- Check customer interactions
function CheckCustomerInteractions(playerCoords, currentTime)
    local nearbyCustomers = GetNearbyCustomers()
    
    if #nearbyCustomers > 0 then
        local interaction = {
            type = 'customer',
            priority = Config.Interactions.priorities.customer,
            coords = playerCoords,
            text = '[QUICK SERVE] Serve Customer (' .. #nearbyCustomers .. ' nearby)',
            action = function()
                if currentTime - lastInteractionTime < Config.Interactions.cooldown then return end
                lastInteractionTime = currentTime
                QuickServeNearestCustomer()
            end
        }
        
        table.insert(currentInteractions, interaction)
    end
end

-- Handle the top priority interaction
function HandleInteraction()
    if #currentInteractions == 0 then return end
    
    -- Sort by priority and execute the highest priority action
    table.sort(currentInteractions, function(a, b)
        return a.priority > b.priority
    end)
    
    local topInteraction = currentInteractions[1]
    if topInteraction.action then
        topInteraction.action()
    end
end

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

-- Clock In/Out Functions with New Player Bonus
function ClockIn(storeId, jobType)
    TriggerServerEvent('retail:clockIn', storeId, jobType)
    
    -- Check if this is the player's first time
    if isFirstTimePlayer then
        isFirstTimePlayer = false
        TriggerServerEvent('retail:firstTimeBonus')
    end
end

function ClockOut()
    TriggerServerEvent('retail:clockOut')
end

-- Enhanced Menu Systems
function OpenJobMenu()
    local elements = {
        {label = 'View Stats', value = 'stats'},
        {label = 'Current Rank: ' .. (playerData.rank and Config.Ranks[playerData.rank].name or 'Trainee'), value = 'rank'},
        {label = 'Experience: ' .. (playerData.experience or 0), value = 'experience'},
        {label = 'Today\'s Earnings: $' .. (playerData.earnings or 0), value = 'earnings'},
        {label = '--- Controls ---', value = 'separator'},
        {label = 'Keybind Help (/retailhelp)', value = 'keybinds'},
        {label = '--- Job Functions ---', value = 'separator'}
    }
    
    if playerData.rank and playerData.rank >= 4 then -- Team Leader+
        table.insert(elements, {label = 'Management Tools', value = 'management'})
    end
    
    table.insert(elements, {label = 'Training Modules', value = 'training'})
    table.insert(elements, {label = 'Clock Out', value = 'clockout'})
    
    OpenMenu('job_menu', 'Job Menu', elements, function(data, menu)
        if data.current.value == 'stats' then
            ShowPlayerStats()
        elseif data.current.value == 'management' then
            OpenManagementMenu()
        elseif data.current.value == 'training' then
            OpenTrainingMenu()
        elseif data.current.value == 'keybinds' then
            RetailKeybinds.ShowHelp()
        elseif data.current.value == 'clockout' then
            ClockOut()
            CloseMenu(menu)
        end
    end)
end

function OpenCashierMenu()
    if not CanPerformAction('serve_customers') then
        ShowNotification('You need more experience to use the cashier system', 'error')
        return
    end
    
    local nearbyCustomers = GetNearbyCustomers()
    if #nearbyCustomers == 0 then
        ShowNotification('No customers nearby', 'info')
        return
    end
    
    local elements = {}
    for i, customer in ipairs(nearbyCustomers) do
        table.insert(elements, {
            label = 'Serve Customer #' .. i,
            value = customer
        })
    end
    
    OpenMenu('cashier_menu', 'Cashier System', elements, function(data, menu)
        ServeCustomer(data.current.value)
        CloseMenu(menu)
    end)
end

function OpenInventoryMenu()
    if not CanPerformAction('manage_inventory') then
        ShowNotification('You do not have permission to manage inventory', 'error')
        return
    end
    
    TriggerServerEvent('retail:requestStoreData', currentStoreId)
end

function OpenManagementMenu()
    if not CanPerformAction('full_management') then
        ShowNotification('You do not have management permissions', 'error')
        return
    end
    
    local elements = {
        {label = 'View Store Performance', value = 'performance'},
        {label = 'Manage Employees', value = 'employees'},
        {label = 'Set Product Prices', value = 'prices'},
        {label = 'Schedule Management', value = 'schedule'}
    }
    
    OpenMenu('management_menu', 'Management Tools', elements, function(data, menu)
        if data.current.value == 'performance' then
            ShowStorePerformance()
        elseif data.current.value == 'employees' then
            OpenEmployeeManagement()
        elseif data.current.value == 'prices' then
            OpenPriceManagement()
        elseif data.current.value == 'schedule' then
            OpenScheduleManagement()
        end
    end)
end

-- Enhanced Customer System
function SpawnCustomerNPC()
    if not Config.NPCCustomers.enabled or not onDuty then return end
    
    local store = Config.Stores[currentStoreId]
    if not store then return end
    
    local customerCount = #npcCustomers
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
    
    -- Simulate transaction
    ShowProgressBar('Processing Sale...', 3000)
    
    Citizen.SetTimeout(3000, function()
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
        if customer.entity then
            local customerCoords = GetEntityCoords(customer.entity)
            local distance = RetailJobs.GetDistance(playerCoords, customerCoords)
            
            if distance < Config.Interactions.distances.customer then
                table.insert(nearby, customerId)
            end
        end
    end
    
    return nearby
end

-- Enhanced Utility Functions
function ShowNotification(message, type, duration)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(message)
    DrawNotification(0, 1)
    
    -- For framework notifications
    if Config.Framework == 'esx' and ESX then
        ESX.ShowNotification(message)
    elseif Config.Framework == 'qbcore' and QBCore then
        QBCore.Functions.Notify(message, type or 'primary')
    end
end

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    if onScreen then
        local px, py, pz = table.unpack(GetGameplayCamCoords())
        local dist = GetDistanceBetweenCoords(px, py, pz, x, y, z, 1)
        local scale = (1 / dist) * 2
        local fov = (1 / GetGameplayCamFov()) * 100
        local scale = scale * fov
        
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(0)
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

function ShowProgressBar(text, duration)
    -- Implementation depends on your progress bar resource
    -- This is a basic placeholder
    ShowNotification(text, 'info')
end

function CanPerformAction(action)
    return RetailJobs.CanPlayerPerformAction(playerData, action)
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

-- Customer spawning loop
Citizen.CreateThread(function()
    while true do
        if onDuty and currentStoreId then
            SpawnCustomerNPC()
        end
        Citizen.Wait(30000) -- Check every 30 seconds
    end
end)

-- Cleanup customers periodically
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
    ShowNotification('Successfully clocked in!', 'success')
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
    
    ShowNotification('Clocked out successfully! Final pay: $' .. finalPay, 'success')
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

-- Menu system (placeholder - replace with your preferred menu system)
function OpenMenu(menuId, title, elements, onSelect)
    -- This should be replaced with your actual menu system
    -- ESX: ESX.UI.Menu.Open
    -- QBCore: exports['qb-menu']:openMenu
    -- Or custom menu system
    
    print('Opening menu: ' .. title)
    for i, element in ipairs(elements) do
        if element.value ~= 'separator' then
            print(i .. '. ' .. element.label)
        end
    end
end

function CloseMenu(menu)
    -- Close menu implementation
end