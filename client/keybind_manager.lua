-- Keybind Management System
local KeybindManager = {}

-- Initialize default keybinds
function KeybindManager.Initialize()
    -- Register keybinds with FiveM's native system
    RegisterKeyMapping('retail_interact', 'Retail Jobs: Interact', 'keyboard', 'E')
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
    ShowNotification('Interact: ~y~' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('interact')), 'info', 5000)
    ShowNotification('Menu: ~y~' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('menu')), 'info', 5000)
    ShowNotification('Quick Serve: ~y~' .. KeybindManager.GetKeybindLabel(KeybindManager.GetKeybind('quick_serve')), 'info', 5000)
end)

-- FiveM Native Keybind System Integration
-- This integrates with FiveM's settings menu for keybind management

-- Commands that get triggered by the keybinds
RegisterCommand('retail_interact', function()
    if not onDuty then return end
    TriggerEvent('retail:localInteract')
end, false)

RegisterCommand('retail_menu', function()
    if not onDuty then return end
    TriggerEvent('retail:localOpenMenu')
end, false)

RegisterCommand('retail_quickserve', function()
    if not onDuty then return end
    TriggerEvent('retail:localQuickServe')
end, false)

-- Utility function to check if a keybind is currently pressed
function IsRetailKeyPressed(keyName)
    if keyName == 'interact' then
        return IsControlJustPressed(0, 38) or IsDisabledControlJustPressed(0, 38)
    elseif keyName == 'menu' then
        return IsControlJustPressed(0, 167) or IsDisabledControlJustPressed(0, 167)
    elseif keyName == 'quickserve' then
        return IsControlJustPressed(0, 47) or IsDisabledControlJustPressed(0, 47)
    end
    return false
end

-- Get the current keybind for display purposes
function GetRetailKeybindLabel(action)
    -- Since FiveM manages the keybinds, we'll use default labels
    -- Players can change these in FiveM Settings > Key Bindings
    local defaultLabels = {
        interact = 'E',
        menu = 'F6',
        quickserve = 'G'
    }
    
    return defaultLabels[action] or 'UNBOUND'
end

-- Initialize notification for players about keybind customization
Citizen.CreateThread(function()
    Citizen.Wait(5000) -- Wait 5 seconds after resource start
    
    if Config.Debug then
        print('[RETAIL JOBS] Native FiveM keybinds registered:')
        print('  - retail_interact (Default: E)')
        print('  - retail_menu (Default: F6)') 
        print('  - retail_quickserve (Default: G)')
        print('Players can customize these in Settings > Key Bindings > FiveM')
    end
end)

-- Helper function for showing keybind help
function ShowKeybindHelp()
    local message = "~b~Retail Jobs Keybinds:~w~\n"
    message = message .. "~y~Interact:~w~ Check your FiveM keybind settings\n"
    message = message .. "~y~Job Menu:~w~ Check your FiveM keybind settings\n"
    message = message .. "~y~Quick Serve:~w~ Check your FiveM keybind settings\n"
    message = message .. "~g~Customize in: Settings > Key Bindings > FiveM~w~"
    
    TriggerEvent('chat:addMessage', {
        color = {0, 255, 255},
        multiline = true,
        args = {"Retail Jobs", message}
    })
end

-- Command to show keybind help
RegisterCommand('retailkeybinds', function()
    ShowKeybindHelp()
end)

RegisterCommand('retailhelp', function()
    ShowKeybindHelp()
end)

-- Export the helper functions for use in main client script
_G.RetailKeybinds = {
    IsPressed = IsRetailKeyPressed,
    GetLabel = GetRetailKeybindLabel,
    ShowHelp = ShowKeybindHelp
}

-- Export functions
_G.KeybindManager = KeybindManager

-- Initialize when script loads
KeybindManager.Initialize()