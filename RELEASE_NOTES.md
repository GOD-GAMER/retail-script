# ?? FiveM Retail Jobs Script v0.0.3

## ?? Release Summary

This major update introduces **FiveM Native Keybind Integration** and resolves all interaction conflicts from v0.0.2. Players can now customize keybinds directly in FiveM's settings menu, just like ESX and QBCore resources.

## ? What's New in v0.0.3

### ?? **FiveM Native Keybind Integration**
- **Settings Menu Integration**: Keybinds appear in FiveM Settings > Key Bindings > FiveM
- **Professional System**: Uses same system as ESX, QBCore, and other major frameworks
- **Real-time Customization**: Players can change keybinds instantly without resource restart
- **Controller Support**: Can bind to gamepad buttons through FiveM settings
- **Conflict Prevention**: FiveM automatically prevents duplicate key assignments

### ?? **Fixed Interaction Issues**
- **Clock Out Problems**: Resolved conflicts between clock out and work stations
- **Separate Interaction Zones**: Dedicated areas for clock in/out vs work stations
- **Priority System**: Smart interaction detection prevents overlapping prompts
- **Distance Management**: Different interaction ranges for different functions

### ?? **Enhanced New Player Experience**
- **Starting Bonus**: 100 XP welcome package for new players
- **Tutorial Tasks**: Guided progression with XP rewards
- **First-Time Bonuses**: Extra XP for initial job actions
- **Progressive Learning**: Balanced experience curve for beginners

### ?? **Core Features** (Carried from v0.0.2)
- **Corporate Ladder System**: 10 ranks from Trainee to CEO with unique perks
- **Advanced NPC Customers**: Intelligent AI with personality types and realistic behaviors  
- **Multi-Framework Support**: Compatible with ESX, QBCore, and Standalone
- **Modern UI Interface**: React-style dashboard with real-time analytics
- **Performance Optimization**: LOD system and entity management for optimal server performance

### ?? **Job Types**
- **Retail Stores**: General merchandise with customizable products
- **Fast Food Restaurants**: Kitchen operations and customer service

### ?? **Included Locations**
- Downtown General Store (Retail)
- Sandy Shores Market (Retail)  
- Burger Shot Downtown (Fast Food)
- Cluckin Bell Paleto (Fast Food)

## ?? **New Keybind System**

### **FiveM Settings Integration**
Your keybinds now appear alongside ESX and other professional resources:

1. Press `ESC` ? `Settings` ? `Key Bindings` ? `FiveM`
2. Find "Retail Jobs" entries:
   - **Retail Jobs: Interact** (Default: E)
   - **Retail Jobs: Open Job Menu** (Default: F6)
   - **Retail Jobs: Quick Serve Customer** (Default: G)
3. Click and customize to your preference
4. Changes work immediately!

### **Helper Commands**
- `/retailhelp` - Show keybind information and help
- `/retailkeybinds` - Display current keybind assignments

## ?? **Installation**

1. **Download**: Download the latest release from [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/tag/v0.0.3)
2. **Extract**: Extract to your `resources/retail_jobs/` folder
3. **Configure**: Edit `config.lua` to match your server setup
4. **Database**: Optionally import `database.sql` for persistent storage
5. **Start**: Add `ensure retail_jobs` to your `server.cfg`

## ?? **Upgrade from v0.0.2**

### **Automatic Migration**
- No manual configuration needed
- Keybind system automatically updates to FiveM native
- Player data and store configurations preserved
- Default keybinds (E, F6, G) set automatically

### **Player Benefits**
- Familiar keybind customization (same as ESX)
- No more interaction conflicts
- Better new player experience
- Professional integration

## ?? **Configuration Options**

```lua
-- Framework Selection
Config.Framework = 'standalone' -- 'esx', 'qbcore', 'standalone'

-- Database Integration  
Config.UseDatabase = false -- Set true for MySQL storage

-- New Player Experience
Config.NewPlayerBonus = {
    enabled = true,
    startingExperience = 100,
    welcomeMessage = "Welcome to your first retail job!"
}

-- Interaction System
Config.Interactions = {
    distances = {
        clockInOut = 3.0,      -- Clock in/out distance
        workStation = 2.5,     -- Work station distance
        customer = 4.0,        -- Customer interaction distance
    }
}
```

## ?? **Player Experience**

### **Getting Started**
1. Find a retail store or fast food restaurant (marked on map)
2. Walk to the **clock in area** (separate from work stations)
3. Press your **Interact key** to clock in
4. Use work stations to serve customers and earn money
5. Complete training modules to advance your career
6. Climb the corporate ladder from Trainee to CEO

### **Interaction Guide**
- **Clock In/Out**: Dedicated areas separate from work stations
- **Work Stations**: Cashier, kitchen, inventory, office (each with own zone)
- **Customer Service**: Quick serve with nearby customer detection
- **Priority System**: Most important interaction always shows first

### **Experience Sources**
- **First Clock In**: +50 XP bonus
- **Serving Customers**: 10 XP per customer
- **Restocking Items**: 5 XP per restock
- **Tutorial Tasks**: Up to 100 XP bonus
- **Perfect Service**: 20 XP every 10 customers

## ?? **Performance & Compatibility**

- ? **Optimized for 30+ concurrent players**
- ? **ESX Framework Compatible**
- ? **QBCore Framework Compatible**  
- ? **Standalone Mode Available**
- ? **MySQL Database Support (Optional)**
- ? **FiveM Native Keybind Integration**
- ? **Controller Support**

## ?? **Fixed Issues from v0.0.2**

- ? **"Unable to clock out"** ? ? **Separate clock in/out zones**
- ? **"Interactions too close together"** ? ? **Priority system with distinct areas**
- ? **"Can't change keybinds easily"** ? ? **FiveM settings integration**
- ? **"New players struggle with XP"** ? ? **Starting bonus and tutorial system**

## ??? **Admin Tools**

### **Server Commands** (Console Only)
```
addexp [playerid] [amount]     - Give experience to a player
promoteplayer [playerid] [rank] - Promote player to specific rank
```

### **Debug Features**
- Set `Config.Debug = true` for detailed logging
- Performance monitoring for interaction system
- Startup verification with file checking

## ?? **Documentation**

- [Installation Guide](https://github.com/GOD-GAMER/retail-script#installation)
- [Configuration Reference](https://github.com/GOD-GAMER/retail-script#configuration)  
- [API Documentation](https://github.com/GOD-GAMER/retail-script#api-reference)
- [Troubleshooting Guide](https://github.com/GOD-GAMER/retail-script/blob/main/TROUBLESHOOTING.md)
- [FiveM Keybind Integration Guide](https://github.com/GOD-GAMER/retail-script/blob/main/FIVEM_KEYBIND_INTEGRATION.md)

## ?? **Contributing**

We welcome contributions! See our [Contributing Guide](https://github.com/GOD-GAMER/retail-script/blob/main/CONTRIBUTING.md) for details.

## ?? **Support**

- ?? [Documentation](https://github.com/GOD-GAMER/retail-script/wiki)
- ?? [Report Issues](https://github.com/GOD-GAMER/retail-script/issues)
- ?? [Feature Requests](https://github.com/GOD-GAMER/retail-script/issues/new?template=feature_request.md)

## ?? **What's Next**

### Planned for Future Releases
- Advanced inventory management system
- Multi-language support  
- Mobile app integration
- Enhanced analytics dashboard
- Franchise management system

---

**Full Changelog**: https://github.com/GOD-GAMER/retail-script/blob/main/CHANGELOG.md

**Download**: [retail_jobs-v0.0.3.zip](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.3/retail_jobs-v0.0.3.zip)