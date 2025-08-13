# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.2] - 2024-12-19

### ?? Initial Release

#### Added
- **Complete retail and fast food job system** for FiveM servers
- **10-tier corporate ladder** system with progression from Trainee to CEO
- **Advanced NPC customer AI** with personality types and realistic behaviors
- **Multi-framework support** (ESX, QBCore, Standalone)
- **Modern UI interface** with real-time analytics and management tools
- **Performance optimization** system with LOD and entity management
- **Training modules** for skill development and career advancement
- **Database integration** (optional MySQL support)
- **Comprehensive documentation** and troubleshooting guides

#### Features
- ?? **Corporate Ladder**: 10 ranks with unique perks and salary progression
- ?? **Smart NPCs**: Customers with patience, mood, and shopping behaviors
- ?? **Multiple Job Types**: Retail stores and fast food restaurants
- ?? **Analytics Dashboard**: Performance tracking and goal management
- ?? **Training System**: Interactive modules for skill development
- ? **Optimization**: Advanced performance management for servers
- ?? **Modern UI**: React-style interface with real-time updates
- ?? **Customization**: Extensive configuration options

#### Store Locations
- Downtown General Store (Retail)
- Sandy Shores Market (Retail)
- Burger Shot Downtown (Fast Food)
- Cluckin Bell Paleto (Fast Food)

#### Compatibility
- ? FiveM Server
- ? ESX Framework
- ? QBCore Framework
- ? Standalone Mode
- ? MySQL Database (optional)

#### Performance
- Optimized for 30+ concurrent players
- LOD system for entity management
- Memory cleanup and resource optimization
- Adaptive spawning based on server performance

### Technical Details

#### File Structure
```
retail_jobs/
??? fxmanifest.lua          # Resource manifest
??? config.lua              # Main configuration
??? database.sql            # Database schema
??? shared/
?   ??? utils.lua          # Shared utilities
?   ??? startup.lua        # Startup verification
??? server/
?   ??? main.lua           # Server-side logic
??? client/
?   ??? main.lua           # Main client script
?   ??? customer_ai.lua    # NPC AI system
?   ??? optimization.lua   # Performance optimization
??? html/
    ??? index.html         # UI interface
    ??? style.css          # Modern styling
    ??? script.js          # UI functionality
```

#### API Exports
- `getPlayerJobData(playerId)` - Get player job information
- `addExperience(playerId, amount, reason)` - Add experience points
- `promotePlayer(playerId, newRank)` - Promote player to new rank
- `getJobStores()` - Get all store data
- `testResource()` - Test resource functionality

#### Configuration Highlights
- Framework selection (ESX/QBCore/Standalone)
- Database toggle (MySQL optional)
- Store locations and products
- NPC customer behavior settings
- Performance optimization options
- UI keybinds and settings

### Known Issues
- None reported in initial release

### Installation Requirements
- FiveM Server (latest version recommended)
- Optional: MySQL database for persistent storage
- Optional: ESX or QBCore framework

### Breaking Changes
- N/A (Initial release)

---

## [Unreleased]

### Planned Features
- [ ] Advanced inventory management system
- [ ] Multi-language support (ES, FR, DE)
- [ ] Mobile companion app integration
- [ ] Enhanced analytics dashboard
- [ ] Franchise management system
- [ ] Advanced training certification system
- [ ] Customer loyalty program
- [ ] Seasonal events and promotions

### Potential Improvements
- [ ] Enhanced NPC pathfinding
- [ ] Voice chat integration for customer service
- [ ] 3D inventory visualization
- [ ] Advanced reporting system
- [ ] Integration with other job scripts