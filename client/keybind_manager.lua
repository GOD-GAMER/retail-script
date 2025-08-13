-- Proximity-Based Interaction Manager for Retail Jobs
-- No keybinds required - uses automatic proximity detection and menu system

local ProximityManager = {}
local isNearStore = false
local currentStoreProximity = nil
local interactionMenuOpen = false
local autoInteractionEnabled = true

-- Initialize the proximity-based system
function ProximityManager.Initialize()
    -- No keybind registration needed
    if Config.Debug then
        print('[RETAIL] Proximity-based interaction system initialized')
    end
end

-- Main proximity detection loop
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local sleep = 1000
        
        -- Check if player is near any store
        local closestStore, distance = RetailJobs.GetNearestStore(playerCoords)
        
        if closestStore and distance < Config.Interactions.distances.clockInOut then
            sleep = 100
            
            if not isNearStore then
                isNearStore = true
                currentStoreProximity = closestStore
                
                -- Show proximity notification
                ShowNotification('~b~Near ' .. closestStore.name .. '~w~\nUse ~g~/retailjob~w~ to see options', 'info', 3000)
                
                if Config.Debug then
                    print('[RETAIL] Player entered proximity of: ' .. closestStore.name)
                end
            end
        else
            if isNearStore then
                isNearStore = false
                currentStoreProximity = nil
                
                if interactionMenuOpen then
                    CloseInteractionMenu()
                end
                
                if Config.Debug then
                    print('[RETAIL] Player left store proximity')
                end
            end
        end
        
        Citizen.Wait(sleep)
    end
end)

-- Open interaction menu when near a store
function OpenInteractionMenu()
    if not currentStoreProximity then
        ShowNotification('~r~You must be near a store to access job options', 'error')
        return
    end
    
    if interactionMenuOpen then return end
    
    interactionMenuOpen = true
    local store = currentStoreProximity
    
    if Config.Framework == 'esx' and ESX then
        local elements = {}
        
        -- Clock in/out options
        if not onDuty then
            table.insert(elements, {
                label = '?? Clock In - ' .. store.name,
                value = 'clock_in',
                description = 'Start working at this location'
            })
        elseif onDuty and currentStoreId == store.id then
            table.insert(elements, {
                label = '?? Clock Out',
                value = 'clock_out', 
                description = 'End your shift and receive payment'
            })
        else
            table.insert(elements, {
                label = '?? Clock out of current job first',
                value = 'clock_out_other',
                description = 'You are working at another location'
            })
        end
        
        -- Work station options (when on duty)
        if onDuty and currentStoreId == store.id then
            table.insert(elements, {
                label = '?? Work Stations',
                value = 'work_stations',
                description = 'Access cashier, inventory, and other stations'
            })
            
            table.insert(elements, {
                label = '?? Job Menu',
                value = 'job_menu',
                description = 'View stats, training, and management'
            })
        end
        
        -- Training for all players
        table.insert(elements, {
            label = '?? Training Info',
            value = 'training_info',
            description = 'Learn about working here'
        })
        
        -- Close option
        table.insert(elements, {
            label = '? Close',
            value = 'close',
            description = 'Close this menu'
        })
        
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'retail_interaction', {
            title = store.name .. ' - Job Options',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            HandleMenuSelection(data.current.value, menu)
        end, function(data, menu)
            CloseInteractionMenu()
        end)
        
    else
        -- Fallback for other frameworks
        ShowNotification('~b~' .. store.name .. ' Options:~w~\n~g~/clockin~w~ - Start work\n~r~/clockout~w~ - End work\n~y~/retailmenu~w~ - Job menu', 'info', 8000)
        interactionMenuOpen = false
    end
end

-- Handle menu selections
function HandleMenuSelection(value, menu)
    local store = currentStoreProximity
    
    if value == 'clock_in' then
        ClockIn(store.id, store.type)
        menu.close()
        
    elseif value == 'clock_out' then
        ClockOut()
        menu.close()
        
    elseif value == 'clock_out_other' then
        ShowNotification('You must go to your current workplace to clock out', 'error')
        
    elseif value == 'work_stations' then
        menu.close()
        OpenWorkStationsMenu()
        
    elseif value == 'job_menu' then
        menu.close()
        OpenJobMenu()
        
    elseif value == 'training_info' then
        ShowTrainingInfo(store)
        
    elseif value == 'close' then
        menu.close()
    end
end

-- Work stations submenu
function OpenWorkStationsMenu()
    if not currentStoreProximity or not onDuty then return end
    
    local store = currentStoreProximity
    local elements = {}
    
    if store.workStations then
        for stationType, coords in pairs(store.workStations) do
            local playerCoords = GetEntityCoords(PlayerPedId())
            local distance = RetailJobs.GetDistance(playerCoords, coords)
            local accessible = distance < Config.Interactions.distances.workStation
            
            table.insert(elements, {
                label = accessible and ('? ' .. GetWorkStationName(stationType)) or ('? ' .. GetWorkStationName(stationType) .. ' (too far)'),
                value = accessible and stationType or 'too_far',
                description = accessible and ('Use the ' .. stationType .. ' station') or ('Move closer to access')
            })
        end
    end
    
    table.insert(elements, {
        label = '?? Back',
        value = 'back',
        description = 'Return to main menu'
    })
    
    if Config.Framework == 'esx' and ESX then
        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'work_stations', {
            title = 'Work Stations',
            align = 'top-left',
            elements = elements
        }, function(data, menu)
            if data.current.value == 'back' then
                menu.close()
                OpenInteractionMenu()
            elseif data.current.value ~= 'too_far' then
                PerformWorkStationAction(data.current.value, store)
                menu.close()
            else
                ShowNotification('Move closer to access this station', 'error')
            end
        end, function(data, menu)
            CloseInteractionMenu()
        end)
    end
end

function GetWorkStationName(stationType)
    local names = {
        cashier = 'Cashier Register',
        kitchen = 'Kitchen',
        inventory = 'Inventory Management',
        office = 'Manager Office',
        drive_thru = 'Drive-Thru Window'
    }
    return names[stationType] or stationType
end

function ShowTrainingInfo(store)
    local info = string.format([[:
~b~%s - Job Information~w~

~g~Job Type:~w~ %s
~g~Available Positions:~w~ Various roles available
~g~Starting Salary:~w~ $%d per hour

~y~How to Work:~w~
1. Use /retailjob near the store
2. Select "Clock In" to start working
3. Access work stations when on duty
4. Serve customers and gain experience
5. Clock out to receive payment

~g~Progression:~w~
Start as Trainee and work up to CEO!
Gain experience by serving customers.
]], store.name, store.type, Config.Jobs[store.type] and Config.Jobs[store.type].paycheck.base or 50)
    
    ShowNotification(info, 'info', 15000)
end

-- Close interaction menu
function CloseInteractionMenu()
    interactionMenuOpen = false
    if Config.Framework == 'esx' and ESX then
        ESX.UI.Menu.CloseAll()
    end
end

-- Commands for interaction
RegisterCommand('retailjob', function()
    if isNearStore then
        OpenInteractionMenu()
    else
        ShowNotification('~r~You must be near a store to access job options~w~\nLook for store blips on the map', 'error', 5000)
    end
end, false)

-- Alternative commands
RegisterCommand('clockin', function()
    if isNearStore and not onDuty then
        ClockIn(currentStoreProximity.id, currentStoreProximity.type)
    else
        ShowNotification('You must be near a store and not already working', 'error')
    end
end, false)

RegisterCommand('clockout', function()
    if onDuty then
        ClockOut()
    else
        ShowNotification('You are not currently working', 'error')
    end
end, false)

-- Help command
RegisterCommand('retailhelp', function()
    local helpText = [[
^3=== RETAIL JOBS - NO KEYBINDS SYSTEM ===^0
^2/retailjob^0 - Open job menu (when near store)
^2/clockin^0 - Quick clock in (when near store)
^2/clockout^0 - Quick clock out (anywhere)
^2/retailmenu^0 - Open job dashboard (when working)

^3=== HOW TO START WORKING ===^0
1. Go to any store (look for blips on map)
2. Get close to the store entrance
3. Type ^2/retailjob^0 to see options
4. Select "Clock In" from the menu
5. Use work stations when on duty

^3=== STORE LOCATIONS ===^0
• Downtown General Store
• Sandy Shores Market  
• Burger Shot Downtown
• Cluckin Bell Paleto

^3=== FEATURES ===^0
• No keybinds required!
• Automatic proximity detection
• Menu-based interactions
• Command alternatives available
    ]]
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = true,
        args = {"Retail Jobs", helpText}
    })
end)

-- Job menu command (when working)
RegisterCommand('retailmenu', function()
    if onDuty then
        OpenJobMenu()
    else
        ShowNotification('You must be working to access the job menu', 'error')
    end
end)

-- Debug command
RegisterCommand('retaildebug', function()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local closestStore, distance = RetailJobs.GetNearestStore(playerCoords)
    
    local debugInfo = string.format([[:
^3=== RETAIL JOBS DEBUG (NO KEYBINDS) ===^0
^2System Type:^0 Proximity-Based (No Keybinds)
^2Player Position:^0 %.2f, %.2f, %.2f
^2Near Store:^0 %s
^2Current Store:^0 %s
^2Distance:^0 %.2f
^2On Duty:^0 %s
^2Menu Available:^0 %s
    ]], 
    playerCoords.x, playerCoords.y, playerCoords.z,
    isNearStore and "Yes" or "No",
    currentStoreProximity and currentStoreProximity.name or "None",
    distance or 0,
    onDuty and "Yes" or "No",
    isNearStore and "Yes (/retailjob)" or "No"
    )
    
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = true,
        args = {"Retail Debug", debugInfo}
    })
end, false)

-- Export functions
_G.ProximityManager = ProximityManager

-- Initialize the system
ProximityManager.Initialize()

-- Disable old keybind events
RegisterNetEvent('retail:localInteract')
AddEventHandler('retail:localInteract', function()
    -- Redirect to new system
    if isNearStore then
        OpenInteractionMenu()
    end
end)