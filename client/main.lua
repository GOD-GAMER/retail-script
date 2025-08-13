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

-- UI State
local showingUI = false
local uiData = {}

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

-- Main Loop
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000
        
        -- Check nearby stores
        local closestStore, distance = RetailJobs.GetNearestStore(playerCoords)
        
        if distance < 50.0 then
            sleep = 100
            nearbyStore = closestStore
            
            -- Show store markers and interactions
            if distance < 3.0 then
                sleep = 0
                
                -- Clock in/out interaction
                if not onDuty then
                    DrawText3D(closestStore.coords.x, closestStore.coords.y, closestStore.coords.z + 1.0, 
                              '[E] Clock In - ' .. closestStore.name)
                    
                    if IsControlJustPressed(0, Config.UI.keybinds.interact) then
                        ClockIn(closestStore.id, closestStore.type)
                    end
                elseif onDuty and currentStoreId == closestStore.id then
                    DrawText3D(closestStore.coords.x, closestStore.coords.y, closestStore.coords.z + 1.0, 
                              '[E] Clock Out')
                    
                    if IsControlJustPressed(0, Config.UI.keybinds.interact) then
                        ClockOut()
                    end
                end
            end
            
            -- Work station interactions when on duty
            if onDuty and currentStoreId == closestStore.id then
                CheckWorkStations(closestStore, playerCoords)
            end
        else
            nearbyStore = nil
        end
        
        -- Job menu
        if onDuty and IsControlJustPressed(0, Config.UI.keybinds.menu) then
            OpenJobMenu()
        end
        
        -- Quick serve
        if onDuty and IsControlJustPressed(0, Config.UI.keybinds.quick_serve) then
            QuickServeNearestCustomer()
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Work Stations Management
function CheckWorkStations(store, playerCoords)
    if not store.workStations then return end
    
    for stationType, coords in pairs(store.workStations) do
        local distance = RetailJobs.GetDistance(playerCoords, coords)
        
        if distance < 2.0 then
            local actionText = GetWorkStationText(stationType)
            DrawText3D(coords.x, coords.y, coords.z + 0.5, actionText)
            
            if IsControlJustPressed(0, Config.UI.keybinds.interact) then
                PerformWorkStationAction(stationType, store)
            end
        end
    end
end

function GetWorkStationText(stationType)
    local texts = {
        cashier = '[E] Serve Customers',
        kitchen = '[E] Prepare Food',
        inventory = '[E] Manage Inventory',
        office = '[E] Management Tasks',
        drive_thru = '[E] Drive-Thru Service'
    }
    
    return texts[stationType] or '[E] Interact'
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
    TriggerServerEvent('retail:clockIn', storeId, jobType)
end

function ClockOut()
    TriggerServerEvent('retail:clockOut')
end

-- Menu Systems
function OpenJobMenu()
    local elements = {
        {label = 'View Stats', value = 'stats'},
        {label = 'Current Rank: ' .. (playerData.rank and Config.Ranks[playerData.rank].name or 'Trainee'), value = 'rank'},
        {label = 'Experience: ' .. (playerData.experience or 0), value = 'experience'},
        {label = 'Today\'s Earnings: $' .. (playerData.earnings or 0), value = 'earnings'}
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

-- Customer System
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
            
            if distance < 5.0 then
                table.insert(nearby, customerId)
            end
        end
    end
    
    return nearby
end

-- Utility Functions
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

-- Menu system (placeholder - replace with your preferred menu system)
function OpenMenu(menuId, title, elements, onSelect)
    -- This should be replaced with your actual menu system
    -- ESX: ESX.UI.Menu.Open
    -- QBCore: exports['qb-menu']:openMenu
    -- Or custom menu system
    
    print('Opening menu: ' .. title)
    for i, element in ipairs(elements) do
        print(i .. '. ' .. element.label)
    end
end

function CloseMenu(menu)
    -- Close menu implementation
end