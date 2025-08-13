# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.0.4] - 2024-12-19

### ?? **Critical Fixes and Optimization**

#### Fixed
- **Flickering Interaction Points** - Completely eliminated interaction text flickering
- **Clock In/Out Access Issues** - Fixed problems with clocking in and out at stores
- **Interaction Conflicts** - Resolved overlapping interaction zones causing confusion
- **Performance Issues** - Optimized rendering loops and reduced CPU usage
- **Framework Integration** - Improved ESX compatibility and error handling

#### Enhanced
- **Anti-Flicker System** - New interaction detection system prevents text flickering
- **Optimized Rendering** - Interaction checks now run at 100ms intervals instead of every frame
- **Stable Interactions** - Single active interaction system ensures consistent behavior
- **Better Visual Feedback** - Improved text positioning and color coding for different interactions
- **Debug Logging** - Enhanced debugging capabilities for troubleshooting

#### Cleaned
- **Removed Development Files** - Excluded unnecessary documentation and scripts from release
- **Streamlined Package** - Release now contains only essential server files
- **Optimized File Structure** - Cleaner organization for better server deployment
- **Reduced Package Size** - Removed redundant files and improved compression

#### Technical Improvements
- **Interaction Priority System** - Clock in/out always takes precedence over work stations
- **Distance Optimization** - Different interaction ranges for different functions
- **Memory Management** - Better cleanup of NPCs and interaction states
- **Framework Detection** - Improved compatibility checking and initialization

### Breaking Changes
- **None** - All changes are backward compatible with existing installations

### Migration Guide
- **No action required** - Drop-in replacement for v0.0.3
- **Performance improvement** - Users will notice smoother interactions immediately
- **Server benefits** - Reduced resource usage and better stability

---

## [0.0.3] - 2024-12-19

### ?? **FiveM Native Keybind Integration**

#### Added
- **FiveM Settings Menu Integration** - Keybinds now appear in FiveM Settings > Key Bindings > FiveM
- **Professional Keybind System** - Same system used by ESX, QBCore, and other major frameworks
- **Native RegisterKeyMapping** - Uses FiveM's built-in keybind registration system
- **Real-time Customization** - Players can change keybinds instantly without resource restart
- **Controller Support** - Can bind to gamepad buttons through FiveM settings
- **Conflict Prevention** - FiveM automatically prevents duplicate key assignments

#### Enhanced
- **Interaction Priority System** - Fixed overlapping interaction issues
- **Separate Clock In/Out Zones** - Dedicated areas prevent work station conflicts  
- **Smart Distance Management** - Different interaction ranges for different functions
- **New Player Experience** - Starting bonuses and tutorial system for better onboarding
- **Experience Progression** - Enhanced XP system with multiple earning sources

#### Fixed
- **Clock Out Issues** - Can now reliably clock out without conflicts
- **Work Station Overlap** - Cash register and inventory interactions properly separated
- **Interaction Cooldown** - Prevents accidental double-interactions
- **Keybind Conflicts** - Eliminated through FiveM native system

#### Keybind Details
- `retail_interact` - Interact with work stations and customers (Default: E)
- `retail_menu` - Open job management menu (Default: F6)
- `retail_quickserve` - Quick serve nearest customer (Default: G)

#### Commands Added
- `/retailhelp` - Show keybind information and help
- `/retailkeybinds` - Display current keybind assignments
- `addexp [playerid] [amount]` - Admin command to give experience
- `promoteplayer [playerid] [rank]` - Admin command to promote players

#### New Player System
- **Starting Experience**: 100 XP welcome bonus
- **Tutorial Tasks**: Guided progression with XP rewards
- **First-Time Bonuses**: Extra XP for initial job actions
- **Progressive Learning**: Balanced experience curve for beginners

### Breaking Changes
- **Keybind System Replaced** - Old custom keybind system removed in favor of FiveM native
- **Config Changes** - UI.keybinds section restructured (automatic migration)

### Migration Guide
- **No action required** - Existing installations automatically use new system
- **Player Benefits** - Players can now customize keybinds in familiar FiveM settings
- **Server Benefits** - No more keybind-related support requests

---

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
?   ??? keybind_manager.lua # FiveM native keybind system
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
- FiveM native keybind integration

### Known Issues
- None reported in this release

### Installation Requirements
- FiveM Server (latest version recommended)
- Optional: MySQL database for persistent storage
- Optional: ESX or QBCore framework

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