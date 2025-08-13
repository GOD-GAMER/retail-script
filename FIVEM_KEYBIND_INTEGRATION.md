# ?? **FiveM Native Keybind Integration - v0.0.3**

## ?? **NEW: FiveM Settings Menu Integration**

Your retail jobs keybinds are now **fully integrated** with FiveM's native keybind system! This means they appear in the standard FiveM settings menu alongside ESX and other resource keybinds.

### ?? **How to Customize Keybinds**

1. **Open FiveM Settings**
   - Press `ESC` in-game
   - Click `Settings`
   - Go to `Key Bindings`
   - Look for the `FiveM` section

2. **Find Retail Jobs Keybinds**
   - `Retail Jobs: Interact` (Default: E)
   - `Retail Jobs: Open Job Menu` (Default: F6)
   - `Retail Jobs: Quick Serve Customer` (Default: G)

3. **Customize As Needed**
   - Click on any keybind to change it
   - Set to mouse buttons, different keys, etc.
   - Changes save automatically
   - Works exactly like ESX keybinds!

### ? **Benefits of Native Integration**

- ?? **Professional Integration** - Appears with all other FiveM keybinds
- ?? **Automatic Saving** - Your preferences persist across sessions
- ?? **Conflict Prevention** - FiveM handles duplicate key detection
- ?? **Multi-Language Support** - Works with any FiveM language
- ?? **Controller Support** - Can bind to gamepad buttons
- ?? **Real-Time Updates** - Changes apply immediately

### ?? **Available Keybinds**

| Action | Default Key | FiveM Keybind Name | Description |
|--------|-------------|-------------------|-------------|
| **Interact** | E | `retail_interact` | Clock in/out, use work stations |
| **Job Menu** | F6 | `retail_menu` | Open job management interface |
| **Quick Serve** | G | `retail_quickserve` | Serve nearest customer |

### ?? **For Players**

#### **Customizing Your Keybinds:**
1. Press `ESC` ? `Settings` ? `Key Bindings` ? `FiveM`
2. Scroll to find "Retail Jobs" entries
3. Click and set your preferred keys
4. Done! Changes work immediately

#### **Finding Your Keybinds:**
- Use `/retailhelp` command to see current bindings
- Use `/retailkeybinds` for detailed help
- Keybind names appear in interaction prompts

### ??? **For Server Owners**

#### **No Configuration Needed:**
- Keybinds are automatically registered on resource start
- Players can customize without server intervention  
- No config files to edit for keybind changes

#### **Default Settings:**
```lua
-- These are registered automatically:
RegisterKeyMapping('retail_interact', 'Retail Jobs: Interact', 'keyboard', 'E')
RegisterKeyMapping('retail_menu', 'Retail Jobs: Open Job Menu', 'keyboard', 'F6') 
RegisterKeyMapping('retail_quickserve', 'Retail Jobs: Quick Serve Customer', 'keyboard', 'G')
```

### ?? **Migration from v0.0.2**

If you're upgrading from the previous version:

- ? **No action required** - Old custom keybind system is replaced
- ? **Automatic defaults** - E, F6, G are set as defaults
- ? **Player choice** - Players can now customize as they prefer
- ? **Better experience** - Integrated with FiveM's professional keybind system

### ?? **How It Works**

```lua
-- When player customizes keybinds in FiveM settings:
1. FiveM registers the key press
2. FiveM triggers our registered command  
3. Our script handles the action
4. Works seamlessly with any key choice!
```

### ?? **Visual Guide**

To find and customize your keybinds:

```
FiveM Main Menu
??? Settings
    ??? Key Bindings
        ??? FiveM (scroll down)
            ??? Retail Jobs: Interact
            ??? Retail Jobs: Open Job Menu
            ??? Retail Jobs: Quick Serve Customer
```

### ?? **Professional Features**

- **Same system as ESX** - Familiar interface for ESX users
- **Same system as QBCore** - Familiar interface for QBCore users  
- **Controller support** - Can bind to Xbox/PS controller buttons
- **Conflict resolution** - FiveM prevents duplicate bindings
- **Accessibility** - Works with accessibility tools and custom hardware

### ?? **Tips for Players**

- **Mouse buttons work** - Try binding to mouse side buttons
- **Function keys** - F1-F12 keys are available
- **Modifier keys** - Can use Ctrl+Key, Alt+Key combinations
- **Number pad** - Numpad keys are separate from number row
- **Test immediately** - Changes work right away, no restart needed

---

## ?? **Result: Professional Keybind Experience**

Your retail jobs script now has the **same professional keybind system** as major frameworks like ESX and QBCore. Players get familiar, easy-to-use customization options right in the FiveM settings menu!

> **Perfect for servers:** Players no longer need to ask admins how to change keybinds - they can do it themselves in the standard FiveM way!