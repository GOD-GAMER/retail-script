# ?? FiveM Retail Jobs Script v0.0.2

## ?? Release Summary

This is the initial release of the comprehensive FiveM Retail and Fast Food Jobs Script. This script provides a complete job system with corporate ladder progression, advanced NPC interactions, and extensive customization options.

## ? What's New in v0.0.2

### ?? **Core Features**
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

### ?? **Key Capabilities**
- Customer service with commission system
- Inventory management and restocking
- Training modules for skill development
- Performance analytics and goal tracking
- Database integration (optional MySQL)

## ?? **Installation**

1. **Download**: Download the latest release from [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/tag/v0.0.2)
2. **Extract**: Extract to your `resources/retail_jobs/` folder
3. **Configure**: Edit `config.lua` to match your server setup
4. **Database**: Optionally import `database.sql` for persistent storage
5. **Start**: Add `ensure retail_jobs` to your `server.cfg`

## ?? **Configuration Options**

```lua
-- Framework Selection
Config.Framework = 'standalone' -- 'esx', 'qbcore', 'standalone'

-- Database Integration  
Config.UseDatabase = false -- Set true for MySQL storage

-- Performance Settings
Config.Optimization = {
    npcCleanupTime = 300000, -- 5 minutes
    maxRenderDistance = 100.0,
    enableLOD = true
}
```

## ?? **Player Experience**

### Getting Started
1. Find a retail store or fast food restaurant (marked on map)
2. Walk up and press `E` to clock in
3. Use work stations to serve customers and earn money
4. Complete training modules to advance your career
5. Climb the corporate ladder from Trainee to CEO

### Controls
- `E` - Interact with customers and work stations
- `F6` - Open job management menu
- `G` - Quick serve nearest customer

## ?? **Performance & Compatibility**

- ? **Optimized for 30+ concurrent players**
- ? **ESX Framework Compatible**
- ? **QBCore Framework Compatible**  
- ? **Standalone Mode Available**
- ? **MySQL Database Support (Optional)**
- ? **Advanced Performance Optimization**

## ?? **Known Issues**

- None reported in this release

## ?? **Upgrade Instructions**

This is the initial release - no upgrade required.

## ?? **Documentation**

- [Installation Guide](https://github.com/GOD-GAMER/retail-script#installation)
- [Configuration Reference](https://github.com/GOD-GAMER/retail-script#configuration)  
- [API Documentation](https://github.com/GOD-GAMER/retail-script#api-reference)
- [Troubleshooting Guide](https://github.com/GOD-GAMER/retail-script/blob/main/TROUBLESHOOTING.md)

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

**Download**: [retail_jobs-v0.0.2.zip](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.2/retail_jobs-v0.0.2.zip)