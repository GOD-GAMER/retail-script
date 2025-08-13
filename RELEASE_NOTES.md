# ?? FiveM Retail Jobs Script v0.0.4

## ?? Release Summary

This critical update fixes the major interaction issues from v0.0.3, including flickering interaction points and clock in/out access problems. The release also includes a cleaned-up codebase optimized for server deployment.

## ?? **Critical Fixes in v0.0.4**

### **?? No More Flickering**
- **Anti-Flicker System**: Complete rewrite of interaction detection
- **Stable Rendering**: Interaction checks now run at optimized 100ms intervals
- **Single Active Interaction**: Only one interaction displays at a time
- **Smooth Experience**: No more annoying text jumping or flickering

### **? Clock In/Out Fixed**
- **Reliable Access**: Clock in/out now works consistently at all stores
- **Dedicated Zones**: Separate clock in/out areas prevent conflicts
- **Priority System**: Clock in/out always takes precedence over work stations
- **Visual Feedback**: Clear color-coded prompts (Green for clock in, Red for clock out)

### **?? Interaction Improvements**
- **Distance Optimization**: Different interaction ranges for different functions
- **Conflict Resolution**: Eliminated overlapping interaction zones
- **Better Performance**: Reduced CPU usage and smoother gameplay
- **Enhanced Debugging**: Improved logging for troubleshooting

### **?? Clean Release Package**
- **Server-Ready**: Only essential files included for deployment
- **Reduced Size**: Removed development files and documentation
- **Streamlined Structure**: Optimized folder organization
- **Easy Installation**: Drop-in replacement for previous versions

## ?? **Core Features** (Maintained from v0.0.3)

### **?? FiveM Native Keybind Integration**
- Keybinds appear in FiveM Settings > Key Bindings > FiveM
- Same professional system as ESX and QBCore
- Real-time customization without resource restart
- Controller support through FiveM settings

### **?? Corporate Ladder System**
- 10 ranks from Trainee to CEO with unique perks
- Experience-based progression with salary increases
- Management capabilities unlock with higher ranks

### **?? Advanced NPC Customer System**
- Intelligent AI customers with personality types
- Dynamic shopping behaviors and patience systems
- Realistic complaint and satisfaction mechanics

### **?? Job Types**
- **Retail Stores**: General merchandise with customizable products
- **Fast Food Restaurants**: Kitchen operations and customer service

### **?? Included Locations**
- Downtown General Store (Retail)
- Sandy Shores Market (Retail)  
- Burger Shot Downtown (Fast Food)
- Cluckin Bell Paleto (Fast Food)

## ?? **Installation**

1. **Download**: Download the latest release from [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/tag/v0.0.4)
2. **Extract**: Extract to your `resources/retail_jobs/` folder
3. **Configure**: Edit `config.lua` to match your server setup (ESX, QBCore, or Standalone)
4. **Database**: Optionally import `database.sql` for persistent storage
5. **Start**: Add `ensure retail_jobs` to your `server.cfg`

## ?? **Upgrade from Previous Versions**

### **Drop-in Replacement**
- Simply replace your existing files with v0.0.4
- No configuration changes needed
- Player data automatically preserved
- Immediate performance improvements

### **What You'll Notice**
- **Instant Fix**: No more flickering interaction text
- **Reliable Clock In/Out**: Always works on first try
- **Smoother Performance**: Better FPS and responsiveness
- **Cleaner Interface**: More stable and professional feel

## ?? **Configuration**

```lua
-- Framework Selection (configure for your server)
Config.Framework = 'esx' -- 'esx', 'qbcore', 'standalone'
Config.UseDatabase = true -- Set true for MySQL storage
Config.Debug = false -- Set true for troubleshooting

-- Interaction System (optimized distances)
Config.Interactions = {
    distances = {
        clockInOut = 3.0,      -- Clock in/out distance
        workStation = 2.5,     -- Work station distance  
        customer = 4.0,        -- Customer interaction distance
    },
    cooldown = 1000           -- Interaction cooldown (prevents spam)
}
```

## ?? **Player Experience**

### **Getting Started**
1. Find a retail store or fast food restaurant (marked on map)
2. Walk to the **green clock in prompt** (separate from work stations)
3. Press your **Interact key** (customizable in FiveM settings)
4. Use work stations to serve customers and earn money
5. Walk to the **red clock out prompt** when finished

### **Fixed Interaction Guide**
- **?? Clock In**: Green text, highest priority, separate zone
- **?? Clock Out**: Red text, highest priority, same zone as clock in
- **?? Work Stations**: Blue text, work areas (cashier, kitchen, inventory)
- **?? Customer Service**: Yellow text, quick serve nearby customers

### **Keybind Customization**
- Open FiveM Settings (ESC menu)
- Go to Key Bindings > FiveM
- Find "Retail Jobs" entries
- Customize to your preference
- Changes apply immediately

## ?? **Performance & Compatibility**

- ? **Fixed Flickering Issues** - Stable interaction system
- ? **Reliable Clock In/Out** - Works every time
- ? **Optimized Performance** - Better FPS and responsiveness
- ? **ESX Framework Compatible** - Enhanced integration
- ? **QBCore Framework Compatible** - Full support
- ? **Standalone Mode Available** - No framework required
- ? **MySQL Database Support** - Optional persistent storage
- ? **FiveM Native Keybinds** - Professional customization

## ?? **Issues Fixed from v0.0.3**

- ? **"Interaction points flicker"** ? ? **Anti-flicker system implemented**
- ? **"Unable to access clock in/out"** ? ? **Dedicated zones with priority system**
- ? **"Interactions too close together"** ? ? **Optimized distances and conflicts resolved**
- ? **"Poor performance"** ? ? **Optimized rendering loops and memory usage**
- ? **"Package too large"** ? ? **Cleaned release with only essential files**

## ??? **Admin Tools**

### **Server Commands** (Console Only)
```
addexp [playerid] [amount]     - Give experience to a player
promoteplayer [playerid] [rank] - Promote player to specific rank
```

### **Debug Features**
- Set `Config.Debug = true` for detailed logging
- Enhanced error reporting and interaction tracking
- Performance monitoring built-in

## ?? **Documentation**

- [Installation Guide](https://github.com/GOD-GAMER/retail-script#installation)
- [Configuration Reference](https://github.com/GOD-GAMER/retail-script#configuration)  
- [API Documentation](https://github.com/GOD-GAMER/retail-script#api-reference)
- [Troubleshooting Guide](https://github.com/GOD-GAMER/retail-script/blob/main/TROUBLESHOOTING.md)

## ?? **Contributing**

We welcome contributions! See our [Contributing Guide](https://github.com/GOD-GAMER/retail-script/blob/main/CONTRIBUTING.md) for details.

## ?? **Support**

- ?? [Report Issues](https://github.com/GOD-GAMER/retail-script/issues)
- ?? [Feature Requests](https://github.com/GOD-GAMER/retail-script/issues/new?template=feature_request.md)

## ?? **What's Next**

### Planned for Future Releases
- Advanced inventory management system
- Multi-language support  
- Enhanced analytics dashboard
- Franchise management system

---

**Full Changelog**: https://github.com/GOD-GAMER/retail-script/blob/main/CHANGELOG.md

**Download**: [retail_jobs-v0.0.4.zip](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.4/retail_jobs-v0.0.4.zip)