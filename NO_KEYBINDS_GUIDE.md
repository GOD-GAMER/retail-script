# ?? **NO KEYBINDS INTERACTION SYSTEM**

## ?? **How the New System Works**

Your retail jobs script now uses a **command-based proximity system** instead of keybinds!

### ? **What Changed**

- **? NO MORE KEYBINDS** - No Numpad 2, no E key, no conflicts!
- **? COMMAND-BASED** - Simple commands when near stores
- **? AUTOMATIC DETECTION** - Script knows when you're near a store
- **? MENU-DRIVEN** - Easy-to-use menus for all interactions

## ?? **How to Use**

### **Step 1: Go to a Store**
- Look for blips on the map (?? retail stores, ?? fast food)
- Walk close to any store entrance

### **Step 2: Get Job Options**
- When near a store, type: **`/retailjob`**
- A menu will appear with all available options

### **Step 3: Select Action**
- **Clock In** - Start working at the store
- **Clock Out** - End your shift and get paid
- **Work Stations** - Access cashier, kitchen, inventory
- **Job Menu** - View stats and progression
- **Training Info** - Learn about the job

## ?? **Available Commands**

| Command | Description | When to Use |
|---------|-------------|-------------|
| `/retailjob` | **Main interaction menu** | When near any store |
| `/clockin` | Quick clock in | When near store (not working) |
| `/clockout` | Quick clock out | Anywhere (when working) |
| `/retailmenu` | Job dashboard | Anywhere (when working) |
| `/retailhelp` | Show help information | Anywhere |
| `/retaildebug` | Debug information | Anywhere |

## ?? **Store Locations**

### **Retail Stores**
- **Downtown General Store** - City center
- **Sandy Shores Market** - Sandy Shores area

### **Fast Food Restaurants**  
- **Burger Shot Downtown** - City center
- **Cluckin Bell Paleto** - Paleto Bay

## ?? **Gameplay Flow**

1. **Find a Store** - Use map blips to locate stores
2. **Approach Store** - Walk close to the entrance
3. **Open Menu** - Type `/retailjob` to see options
4. **Clock In** - Select "Clock In" from the menu
5. **Work** - Use `/retailjob` to access work stations
6. **Serve Customers** - Follow on-screen prompts
7. **Clock Out** - Type `/clockout` or use menu

## ? **Benefits of New System**

- **?? No Keybind Conflicts** - Works with any other scripts
- **?? Mobile Friendly** - Easy to use commands
- **?? User Friendly** - Clear menus and instructions
- **?? Performance** - Less key detection overhead
- **??? Reliable** - Commands always work
- **?? Self-Explanatory** - Built-in help and guidance

## ?? **For Server Owners**

### **Configuration**
The new system is controlled in `config.lua`:
```lua
Config.UI = {
    interactionSystem = {
        type = 'proximity_commands',
        proximityDistance = 4.0,
        autoDetection = true,
        commandBased = true
    }
}
```

### **Player Instructions**
Tell your players:
1. Go near any store
2. Type `/retailjob` to start working
3. Type `/retailhelp` for full command list

## ?? **Tips for Players**

- **Look for notifications** when approaching stores
- **Use `/retailhelp`** to see all available commands
- **Try `/retaildebug`** if something isn't working
- **All interactions are menu-based** - no need to remember keybinds!

---

**?? Enjoy the simplified, conflict-free interaction system!**