# FiveM Retail & Fast Food Jobs Script

## ?? **INSTALLATION FIX - Important for Error Resolution**

### **Folder Structure Requirements**

Your FiveM server directory should look like this:
```
server-data/
??? resources/
?   ??? [retail]/           # Category folder (optional)
?   ?   ??? retail_jobs/    # ?? EXACT NAME MATTERS
?   ?       ??? fxmanifest.lua
?   ?       ??? config.lua
?   ?       ??? shared/
?   ?       ??? server/
?   ?       ??? client/
?   ?       ??? html/
?   ??? [other resources]/
??? server.cfg
??? [other server files]
```

### **Critical Setup Steps**

1. **Rename Your Folder**: 
   - Current: `C:\Users\cabca\Downloads\retail clerk\`
   - Must be: `retail_jobs` (no spaces, exact name)

2. **Move to Server Resources**:
   ```bash
   # Move from Downloads to your FiveM server
   FROM: C:\Users\cabca\Downloads\retail clerk\
   TO: [your-server-path]/resources/retail_jobs/
   ```

3. **Update server.cfg**:
   ```cfg
   # Add this line to your server.cfg
   ensure retail_jobs
   
   # OR if using resource categories:
   ensure [retail]
   ```

4. **Verify File Structure**:
   Make sure these files exist in `resources/retail_jobs/`:
   - ? fxmanifest.lua
   - ? config.lua
   - ? shared/utils.lua
   - ? server/main.lua
   - ? client/main.lua
   - ? client/customer_ai.lua
   - ? client/optimization.lua
   - ? html/index.html
   - ? html/style.css
   - ? html/script.js

## Overview
A comprehensive retail and fast food job system for FiveM featuring advanced NPC customer interactions, corporate ladder progression, performance analytics, and extensive customization options.

## Features

### ?? **Corporate Ladder System**
- 10 distinct ranks from Trainee to CEO
- Experience-based progression with unique perks per rank
- Salary increases and special privileges
- Management capabilities unlock with higher ranks

### ?? **Advanced NPC Customer System**
- Intelligent AI customers with personality types
- Dynamic shopping behaviors and patience systems
- Realistic complaint and satisfaction mechanics
- Customer mood visualization and interaction

### ?? **Multiple Job Types**
- **Retail Stores**: General merchandise, electronics, clothing
- **Fast Food**: Burger chains, coffee shops, quick service
- Customizable store locations and products
- Unique work stations per job type

### ?? **Performance Analytics**
- Real-time performance tracking
- Daily/weekly/monthly reports
- Goal setting and achievement system
- Commission and bonus calculations

### ?? **Training & Development**
- Interactive training modules
- Skill progression system
- Certification requirements for advancement
- Leadership development programs

### ?? **Advanced Features**
- **Optimization**: LOD system, entity pooling, performance monitoring
- **UI System**: Modern React-style interface with real-time updates
- **Database Support**: MySQL integration for persistent data
- **Framework Compatibility**: ESX, QBCore, and standalone support
- **Customization**: Extensive configuration options

## Installation

### Prerequisites
- FiveM Server
- (Optional) MySQL database for persistent storage
- (Optional) ESX or QBCore framework

### Setup Instructions

1. **Download Latest Release**
   ```bash
   # Download from GitHub releases
   https://github.com/GOD-GAMER/retail-script/releases/latest
   ```

2. **Extract to Server**
   ```bash
   # Place the script in your resources folder
   resources/retail_jobs/
   ```

3. **Database Setup (Optional)**
   ```sql
   # Import the database.sql file if using MySQL
   mysql -u username -p database_name < database.sql
   ```

4. **Configuration**
   ```lua
   -- Edit config.lua to match your server setup
   Config.Framework = 'esx' -- 'esx', 'qbcore', 'standalone'
   Config.UseDatabase = true -- Set to false for file-based storage
   ```

5. **Server Configuration**
   ```cfg
   # Add to server.cfg
   ensure retail_jobs
   ```

## Configuration

### Basic Settings
```lua
-- Framework integration
Config.Framework = 'standalone' -- 'esx', 'qbcore', 'standalone'
Config.UseDatabase = false -- Enable MySQL storage
Config.Currency = 'cash' -- Payment method

-- Job settings
Config.Jobs = {
    retail = {
        name = 'Retail Worker',
        maxPlayers = 10,
        paycheck = { base = 50, multiplier = 1.2 }
    },
    fastfood = {
        name = 'Fast Food Worker', 
        maxPlayers = 8,
        paycheck = { base = 45, multiplier = 1.15 }
    }
}
```

### Store Locations
```lua
-- Add custom store locations
Config.Stores = {
    {
        type = 'retail',
        name = 'Downtown General Store',
        coords = vector3(25.7, -1347.3, 29.49),
        blip = { sprite = 52, color = 2, scale = 0.8 },
        products = {
            {name = 'Sandwich', price = 5, stock = 50},
            {name = 'Water', price = 2, stock = 100}
        },
        workStations = {
            cashier = vector3(25.0, -1347.0, 29.49),
            inventory = vector3(27.0, -1349.0, 29.49)
        }
    }
}
```

### Corporate Ranks
```lua
Config.Ranks = {
    [1] = { 
        name = 'Trainee', 
        salary = 100, 
        required_exp = 0, 
        perks = {} 
    },
    [2] = { 
        name = 'Employee', 
        salary = 150, 
        required_exp = 500, 
        perks = {'discount_5'} 
    }
    -- ... up to rank 10
}
```

## Usage

### For Players

#### Getting Started
1. **Find a Store**: Look for retail/fast food blips on the map
2. **Clock In**: Walk up to any store and press `E` to clock in
3. **Learn the Ropes**: Complete training modules to improve skills
4. **Serve Customers**: Use work stations to serve NPC customers
5. **Climb the Ladder**: Gain experience to unlock promotions

#### Controls
- **INTERACT** - Interact with customers/work stations (Default: E, customizable in FiveM settings)
- **JOB MENU** - Open job menu (Default: F6, customizable in FiveM settings)  
- **QUICK SERVE** - Quick serve nearest customer (Default: G, customizable in FiveM settings)

> **Note:** All keybinds can be customized in **FiveM Settings > Key Bindings > FiveM**. Look for "Retail Jobs" entries.

#### Work Stations
- **Cashier**: Process customer transactions
- **Kitchen**: Prepare food items (fast food)
- **Inventory**: Restock products and manage supplies
- **Office**: Access management tools (higher ranks)

### For Server Admins

#### Commands (if using admin system)
```lua
-- Promote player
/promoteplayer [id] [rank]

-- Add experience
/addexp [id] [amount]

-- Reset player job data
/resetjob [id]
```

#### Performance Monitoring
- Monitor frame time and memory usage
- Adjust spawn rates based on server performance
- Configure optimization settings in config.lua

## API Reference

### Exports
```lua
-- Get player job data
local jobData = exports['retail_jobs']:getPlayerJobData(playerId)

-- Add experience to player
exports['retail_jobs']:addExperience(playerId, amount, reason)

-- Promote player
exports['retail_jobs']:promotePlayer(playerId, newRank)

-- Get store data
local stores = exports['retail_jobs']:getJobStores()
```

### Events
```lua
-- Server Events
TriggerServerEvent('retail:clockIn', storeId, jobType)
TriggerServerEvent('retail:clockOut')
TriggerServerEvent('retail:serveCustomer', customerId, items, total)

-- Client Events  
TriggerClientEvent('retail:clockedIn', playerId, storeId, jobType)
TriggerClientEvent('retail:promoted', playerId, newRank, rankData)
TriggerClientEvent('retail:notify', playerId, message, type)
```

## Customization

### Adding New Store Types
1. Define in `Config.Jobs`
2. Add store locations in `Config.Stores`
3. Configure work stations and products
4. Set up job-specific mechanics

### Custom Training Modules
```lua
-- Add to training system
local newModule = {
    name = 'Advanced Sales',
    description = 'Learn upselling techniques',
    requiredRank = 3,
    duration = 300, -- 5 minutes
    experienceReward = 100
}
```

### Performance Optimization
```lua
-- Adjust optimization settings
Config.Optimization = {
    npcCleanupTime = 300000, -- 5 minutes
    maxRenderDistance = 100.0,
    updateInterval = 1000, -- 1 second
    useStreamedTextures = true,
    enableLOD = true
}
```

## Troubleshooting

### Common Issues

**Players can't clock in**
- Check store coordinates in config.lua
- Verify job permissions
- Ensure store isn't at capacity

**NPCs not spawning**
- Check `Config.NPCCustomers.enabled = true`
- Verify spawn radius and chance settings
- Monitor server performance

**Database errors**
- Verify MySQL connection
- Check table structure matches database.sql
- Ensure proper permissions

**Performance issues**
- Reduce max customers per store
- Increase cleanup intervals
- Enable aggressive optimization mode

### Debug Mode
```lua
-- Enable debug mode in config.lua
Config.Debug = true
```

## Contributing

We welcome contributions! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

### Development Guidelines
- Follow Lua coding standards
- Test on multiple frameworks (ESX, QBCore, Standalone)
- Document new features
- Ensure backward compatibility

## Support & Updates

### Getting Help
- ?? Check the [documentation](https://github.com/GOD-GAMER/retail-script/wiki)
- ?? Report issues on [GitHub Issues](https://github.com/GOD-GAMER/retail-script/issues)
- ?? Join our [Discord Community](https://discord.gg/your-discord)

### Roadmap
- [ ] Advanced inventory system
- [ ] Multi-language support
- [ ] Mobile app integration
- [ ] Advanced analytics dashboard
- [ ] Franchise system

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- FiveM community for testing and feedback
- Contributors who helped improve the script
- Framework developers (ESX, QBCore) for compatibility support

---

**Version**: 0.0.3  
**Repository**: https://github.com/GOD-GAMER/retail-script  
**Compatibility**: FiveM, ESX, QBCore  
**Requirements**: None (MySQL optional)  
**Performance**: Optimized for 30+ concurrent players

## ?? **New in v0.0.3: FiveM Native Keybind Integration**

- ? **Professional Keybind System** - Keybinds appear in FiveM Settings > Key Bindings > FiveM
- ? **Fixed Interaction Conflicts** - Separate zones for clock in/out and work stations
- ? **Enhanced New Player Experience** - Starting bonuses and tutorial system
- ? **Real-time Customization** - Change keybinds instantly like ESX resources