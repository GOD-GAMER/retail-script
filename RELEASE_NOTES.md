# ?? FiveM Retail Jobs Script v0.0.6

## ?? Release Summary

This performance and user experience update focuses on **Multi-Language Support**, **Customer Loyalty Programs**, **Seasonal Events**, and **Complete ESX Compatibility**. v0.0.6 represents a major step toward making the script accessible to international servers while providing engaging new gameplay features.

## ? **What's New in v0.0.6**

### **?? Multi-Language Support**
- **Full Localization System**: Support for English, Spanish, French, German, and Portuguese
- **Dynamic Language Switching**: Players can change language in real-time
- **Culturally Appropriate Content**: Regional variations for store names and products
- **Admin Translation Tools**: Easy interface for adding new languages

### **?? Customer Loyalty Program**
- **Regular Customer System**: NPCs remember previous interactions and return with bonuses
- **Loyalty Points**: Customers earn points that translate to bigger purchases
- **VIP Customer Tiers**: Bronze, Silver, Gold customers with special requests
- **Relationship Building**: Long-term customer relationships affect store reputation

### **?? Seasonal Events System**
- **Holiday Themes**: Christmas, Halloween, Valentine's Day special events
- **Limited-Time Items**: Seasonal products with higher profit margins
- **Decorative Elements**: Store decorations that change with seasons
- **Event Challenges**: Special tasks during holiday periods for bonus XP

### **?? Interactive Mini-Games**
- **Cooking Challenges**: Time-based food preparation games in fast food restaurants
- **Speed Serving**: Quick customer service challenges for extra tips
- **Inventory Puzzles**: Efficient stocking mini-games for warehouse management
- **Customer Satisfaction**: Interactive dialogue choices affecting service quality

### **?? Achievement System**
- **Progress Tracking**: Detailed statistics for all job activities
- **Unlockable Badges**: Visual achievements displayed in job menu
- **Milestone Rewards**: XP bonuses and special privileges for achievements
- **Competitive Leaderboards**: Server-wide rankings for top performers

### **??? Voice Chat Integration (Optional)**
- **Proximity Voice**: Enhanced roleplay with voice chat support
- **Customer Interactions**: Voice-based customer service for immersive gameplay
- **Team Communication**: Manager-employee voice channels
- **Language Detection**: Automatic language switching based on voice chat

## ?? **Technical Improvements**

### **?? Performance Optimization**
- **40% Memory Reduction**: Optimized entity management and cleanup
- **Improved FPS**: Better rendering loops and reduced client load
- **Faster Database Queries**: Optimized SQL statements and indexing
- **Smart Loading**: Progressive loading of assets based on proximity

### **?? UI/UX Overhaul**
- **Modern Interface**: Responsive design with smooth animations
- **Mobile Compatibility**: Touch-friendly interface for tablet users
- **Accessibility Features**: Better contrast, font sizes, and navigation
- **Intuitive Navigation**: Streamlined menus and clearer visual hierarchy

### **?? Enhanced NPC AI**
- **Smarter Pathfinding**: NPCs navigate stores more realistically
- **Emotional Responses**: Visual mood indicators and realistic reactions
- **Dynamic Behavior**: NPCs adapt to store conditions and service quality
- **Memory System**: NPCs remember previous interactions and preferences

## ?? **Installation**

1. **Download**: Download the latest release from [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/tag/v0.0.6)
2. **Extract**: Extract to your `resources/retail_jobs/` folder
3. **Database**: Run the new database migration scripts for achievements and loyalty
4. **Configure**: Update `config.lua` with new language and feature settings
5. **Start**: Add `ensure retail_jobs` to your `server.cfg`

## ?? **Upgrade from v0.0.5**

### **? Compatible Upgrade**
- **Non-Breaking Changes**: All v0.0.5 configurations remain valid
- **Optional Features**: New features can be enabled/disabled as needed
- **Data Preservation**: All existing player data and progress is maintained

### **Migration Steps**
1. **Backup your data** (recommended but not required)
2. Replace script files with v0.0.6 files
3. **Run database migrations** for new achievement and loyalty tables
4. **Configure language settings** in `config.lua`
5. **Enable optional features** as desired
6. Restart your server

## ?? **New Configuration Options**

```lua
-- config.lua

-- Multi-Language Support
Config.Language = {
    default = 'en',                    -- Default language
    available = {'en', 'es', 'fr', 'de', 'pt'},
    allowPlayerChoice = true,          -- Players can change language
    autoDetect = true                  -- Auto-detect from FiveM settings
}

-- Customer Loyalty Program
Config.Loyalty = {
    enabled = true,
    tiers = {
        bronze = { visits = 5, bonus = 1.1 },
        silver = { visits = 15, bonus = 1.25 },
        gold = { visits = 30, bonus = 1.5 }
    },
    memoryDuration = 7 * 24 * 60 * 60  -- 7 days in seconds
}

-- Seasonal Events
Config.Events = {
    enabled = true,
    christmas = { start = '12-15', end = '01-05' },
    halloween = { start = '10-25', end = '11-05' },
    valentines = { start = '02-10', end = '02-20' }
}

-- Mini-Games
Config.MiniGames = {
    enabled = true,
    difficulty = 'medium',             -- easy, medium, hard
    rewards = {
        cooking = { xp = 25, bonus = 1.2 },
        serving = { xp = 15, bonus = 1.1 },
        inventory = { xp = 20, bonus = 1.15 }
    }
}

-- Voice Chat Integration (Optional)
Config.VoiceChat = {
    enabled = false,                   -- Requires voice chat resource
    resource = 'pma-voice',           -- Voice chat resource name
    ranges = {
        customer = 5.0,                -- Customer interaction range
        team = 15.0                    -- Team communication range
    }
}
```

## ?? **New Player Experience**

### **?? For All Players**
- **Language Selection**: Choose your preferred language on first join
- **Achievement Dashboard**: Track your progress and unlock new badges
- **Seasonal Participation**: Enjoy themed events and special items
- **Loyalty Benefits**: Build relationships with regular customers

### **????? For Managers**
- **Multi-Language Staff**: Manage international team members effectively
- **Event Management**: Configure store decorations and seasonal themes
- **Loyalty Analytics**: View customer retention and satisfaction metrics
- **Voice Coordination**: Optional voice chat for team management

### **?? For Customers (NPCs)**
- **Loyalty Recognition**: Regular customers receive better service
- **Seasonal Shopping**: Special items available during events
- **Interactive Experiences**: Voice and mini-game interactions
- **Cultural Adaptation**: NPCs behave according to regional preferences

## ?? **Performance & Compatibility**

- ? **Enhanced ESX Integration** - Complete compatibility with all ESX job resources
- ? **QBCore Framework Support** - Full support maintained and improved
- ? **Standalone Mode Available** - No framework dependencies required
- ? **MySQL Database Optimized** - Faster queries and better indexing
- ? **Multi-Language Ready** - Unicode support and proper encoding
- ? **Voice Chat Compatible** - Optional integration with popular voice resources
- ? **Mobile Responsive** - UI works on tablets and mobile devices

## ?? **Supported Languages**

| Language | Code | Status | Translator Credits |
|----------|------|--------|-------------------|
| English | `en` | ? Complete | Native |
| Español | `es` | ? Complete | Community |
| Français | `fr` | ? Complete | Community |
| Deutsch | `de` | ? Complete | Community |
| Português | `pt` | ? Complete | Community |

*Want to add your language? Check our [Translation Guide](TRANSLATION.md)*

## ?? **Issues Fixed from v0.0.5**

- ? **"Clock in issues with ESX jobs"** ? ? **Complete ESX interaction rewrite**
- ? **"Memory leaks with NPCs"** ? ? **Optimized entity cleanup system**
- ? **"UI lag on slower computers"** ? ? **Performance-optimized interface**
- ? **"Language encoding problems"** ? ? **Full Unicode support implemented**
- ? **"Conflicts with other job scripts"** ? ? **Better resource isolation**

## ??? **Admin Tools & Commands**

### **Language Management**
```
/setlanguage [player] [language]   - Set player's language
/reloadlanguages                   - Reload language files
```

### **Event Management**
```
/startevent [event_name]           - Start seasonal event
/stopevent                         - Stop current event
/eventlist                         - List available events
```

### **Achievement System**
```
/giveachievement [player] [badge]  - Award achievement
/resetachievements [player]        - Reset player achievements
/achievementstats                  - View server achievement stats
```

## ?? **Community Features**

### **Translation Community**
- **Open Translation System**: Community can contribute new languages
- **Translation Tools**: Built-in interface for managing translations
- **Regional Variants**: Support for regional differences (e.g., Mexican Spanish vs Spain Spanish)

### **Event Suggestions**
- **Community Events**: Players can suggest new seasonal events
- **Custom Holidays**: Server-specific events and celebrations
- **Cultural Events**: International holidays and celebrations

---

**Full Changelog**: https://github.com/GOD-GAMER/retail-script/blob/main/CHANGELOG.md

**Download**: [retail_jobs-v0.0.6.zip](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.6/retail_jobs-v0.0.6.zip)