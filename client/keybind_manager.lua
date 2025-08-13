-- Keybind Management System
local KeybindManager = {}

-- Initialize default keybinds
function KeybindManager.Initialize()
    -- Register keybinds with FiveM's native system
    RegisterKeyMapping('retail_interact', 'Retail Jobs: Interact', 'keyboard', 'NUMPAD2')
    RegisterKeyMapping('retail_menu', 'Retail Jobs: Open Job Menu', 'keyboard', 'F6')
    RegisterKeyMapping('retail_quickserve', 'Retail Jobs: Quick Serve Customer', 'keyboard', 'G')

    -- Load saved keybinds from client storage
    KeybindManager.LoadKeybinds()
end

-- Load keybinds from client storage
function KeybindManager.LoadKeybinds()
    local savedKeybinds = GetResourceKvpString('retail_keybinds')
    if savedKeybinds then
        local decodedKeybinds = json.decode(savedKeybinds)
        if decodedKeybinds then
            playerKeybinds = decodedKeybinds
        end
    end
end

-- Open keybind configuration menu
function KeybindManager.OpenKeybindMenu()
    if isKeybindMenuOpen then return end
    
    isKeybindMenuOpen = true
    
    local elements = {
        {
            label = 'Interact: ' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('interact')),
            value = 'interact',
            description = 'Key used to interact with work stations and customers'
        },
        {
            label = 'Job Menu: ' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('menu')),
            value = 'menu',
            description = 'Key used to open the job management menu'
        },
        {
            label = 'Quick Serve: ' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('quick_serve')),
            value = 'quick_serve',
            description = 'Key used to quickly serve the nearest customer'
        },
        {
            label = 'Keybind Menu: ' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('keybind_menu')),
            value = 'keybind_menu',
            description = 'Key used to open this keybind configuration menu'
        },
        {
            label = 'Reset to Defaults',
            value = 'reset',
            description = 'Reset all keybinds to default values'
        },
        {
            label = 'Close Menu',
            value = 'close',
            description = 'Close this menu'
        }
    }
    
    -- Use your preferred menu system here
    ShowKeybindMenu(elements)
end

function ShowKeybindMenu(elements)
    -- For now, use a simple notification-based system
    -- This should be replaced with your actual menu system
    
    ShowNotification('~b~Keybind Configuration~w~', 'info', 3000)
    ShowNotification('Current Interact Key: ~y~' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('interact')), 'info', 5000)
    ShowNotification('Current Menu Key: ~y~' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('menu')), 'info', 5000)
    ShowNotification('Current Quick Serve Key: ~y~' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('quick_serve')), 'info', 5000)
    ShowNotification('~g~Type /setkeybind [action] to change keybinds~w~', 'success', 10000)
    ShowNotification('~g~Available actions: interact, menu, quick_serve~w~', 'success', 10000)
    
    isKeybindMenuOpen = false
end

-- Close keybind menu
function KeybindManager.CloseKeybindMenu()
    isKeybindMenuOpen = false
    awaitingKeybind = nil
end

-- Handle keybind selection
function KeybindManager.HandleKeybindSelection(action)
    if action == 'reset' then
        KeybindManager.ResetKeybinds()
        return
    elseif action == 'close' then
        KeybindManager.CloseKeybindMenu()
        return
    end
    
    awaitingKeybind = action
    ShowNotification('Press any key to set as ' .. action .. ' key...', 'info', 5000)
    ShowNotification('Press ESC to cancel', 'info', 3000)
end

-- Reset keybinds to defaults
function KeybindManager.ResetKeybinds()
    playerKeybinds = {
        interact = Config.UI.keybinds.interact,
        menu = Config.UI.keybinds.menu,
        quick_serve = Config.UI.keybinds.quick_serve,
        keybind_menu = Config.UI.keybinds.keybind_menu
    }
    KeybindManager.SaveKeybinds()
    ShowNotification('Keybinds reset to defaults!', 'success')
    KeybindManager.CloseKeybindMenu()
end

-- Check if waiting for keybind input
function KeybindManager.IsAwaitingKeybind()
    return awaitingKeybind ~= nil
end

-- Handle new keybind input
function KeybindManager.HandleKeybindInput(keybind)
    if not awaitingKeybind then return false end
    
    if keybind == 200 then -- ESC key
        ShowNotification('Keybind change cancelled', 'info')
        awaitingKeybind = nil
        return true
    end
    
    -- Check if keybind is already in use
    for action, currentKeybind in pairs(playerKeybinds) do
        if currentKeybind == keybind and action ~= awaitingKeybind then
            ShowNotification('Key already in use for ' .. action .. '!', 'error')
            awaitingKeybind = nil
            return true
        end
    end
    
    -- Set new keybind
    local oldKeybind = KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind(awaitingKeybind))
    local newKeybind = KeybindManager.GetKeybindLabel(keybind)
    
    KeybindManager.SetKeybind(awaitingKeybind, keybind)
    ShowNotification(awaitingKeybind .. ' key changed from ' .. oldKeybind .. ' to ' .. newKeybind, 'success')
    
    awaitingKeybind = nil
    return true
end

-- Command to set keybinds via chat
RegisterCommand('setkeybind', function(source, args)
    if #args ~= 1 then
        ShowNotification('Usage: /setkeybind [interact/menu/quick_serve]', 'error')
        return
    end
    
    local action = args[1]:lower()
    if not playerKeybinds[action] then
        ShowNotification('Invalid action. Available: interact, menu, quick_serve', 'error')
        return
    end
    
    KeybindManager.HandleKeybindSelection(action)
end)

-- Command to show current keybinds
RegisterCommand('keybinds', function()
    ShowNotification('~b~Current Keybinds:~w~', 'info', 2000)
    ShowNotification('Interact: ~y~Numpad 2', 'info', 5000)
    ShowNotification('Menu: ~y~F6', 'info', 5000)
    ShowNotification('Quick Serve: ~y~G', 'info', 5000)
end)

-- ESX-Compatible Keybind Manager for Retail Jobs
-- This system avoids conflicts with other ESX job resources

local isKeyPressed = false
local keyPressTimer = 0

-- Simple key detection without RegisterKeyMapping to avoid conflicts
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        
        -- Check for Numpad 2 key press (interact) - Control ID 97
        if IsControlJustPressed(0, 97) then -- Numpad 2 key
            if not isKeyPressed then
                isKeyPressed = true
                keyPressTimer = GetGameTimer()
                TriggerEvent('retail:localInteract')
            end
        end
        
        -- Check for F6 key press (job menu)
        if IsControlJustPressed(0, 167) then -- F6 key
            TriggerEvent('retail:localOpenMenu')
        end
        
        -- Check for G key press (quick serve)
        if IsControlJustPressed(0, 47) then -- G key
            TriggerEvent('retail:localQuickServe')
        end
        
        -- Reset key press state after 1 second
        if isKeyPressed and GetGameTimer() - keyPressTimer > 1000 then
            isKeyPressed = false
        end
    end
end)

-- Commands as backup method
RegisterCommand('retailhelp', function()
    local helpText = [[
^3=== RETAIL JOBS CONTROLS ===^0
^2Numpad 2^0 - Interact with stores/stations
^2F6^0 - Open job menu  
^2G^0 - Quick serve customers

^3=== COMMANDS ===^0
^2/retailhelp^0 - Show this help
^2/retailmenu^0 - Open job menu
^2/retailinteract^0 - Manual interact
^2/retaildebug^0 - Show debug information
^2/retailreset^0 - Reset interaction cooldown

^3=== TROUBLESHOOTING ===^0
If clock in/out isn't working:
1. Try ^2/retailreset^0 to clear cooldowns
2. Use ^2/retaildebug^0 to check status
3. Make sure you're near the store entrance
    ]]
    TriggerEvent('chat:addMessage', {
        color = {255, 255, 255},
        multiline = true,
        args = {"Retail Jobs", helpText}
    })
end)

RegisterCommand('retailmenu', function()
    TriggerEvent('retail:localOpenMenu')
end)

RegisterCommand('retailinteract', function()
    TriggerEvent('retail:localInteract')
end)

-- Export the interaction function for other resources
exports('triggerInteract', function()
    TriggerEvent('retail:localInteract')
end)

-- Export functions
_G.KeybindManager = KeybindManager

-- Initialize when script loads
KeybindManager.Initialize()