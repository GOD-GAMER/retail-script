<div align="center">

# **FiveM Retail & Fast Food Jobs Script** ??

### *The Ultimate Career Simulator for Your FiveM Server!*

[![Version](https://img.shields.io/badge/version-0.0.6-blue.svg)](https://github.com/GOD-GAMER/retail-script/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-orange.svg)](https://fivem.net/)
[![ESX](https://img.shields.io/badge/ESX-?-success.svg)](https://github.com/esx-framework/esx-legacy)
[![QBCore](https://img.shields.io/badge/QBCore-?-success.svg)](https://github.com/qbcore-framework/qb-core)

**Transform your server into a thriving economic ecosystem!**

*From flipping burgers to running corporations - let your players live the retail dream!*

---

### ?? **NEW IN v0.0.6 - GLOBAL & ENGAGING!**

> **Multi-Language Support** | **Customer Loyalty** | **Seasonal Events** | **Mini-Games** | **Achievements**

</div>

---

## **What Makes This Script AMAZING?**

<details>
<summary><strong>MULTI-LANGUAGE SUPPORT</strong> - Global Server Ready!</summary>

### **?? International Compatibility**

| Language | Status | Coverage |
|----------|--------|----------|
| **English** | ? Complete | 100% |
| **Español** | ? Complete | 100% |
| **Français** | ? Complete | 100% |
| **Deutsch** | ? Complete | 100% |
| **Português** | ? Complete | 100% |

- **Dynamic Language Switching** - Players choose their preferred language
- **Cultural Adaptation** - Regional store names and products
- **Admin Translation Tools** - Easy interface for adding new languages
- **Community Driven** - Open translation system for community contributions

</details>

<details>
<summary><strong>CUSTOMER LOYALTY PROGRAM</strong> - Build Lasting Relationships!</summary>

### **?? Advanced Customer Relations**

- **Regular Customer System** - NPCs remember and return with bonuses
- **Loyalty Tiers** - Bronze, Silver, Gold customers with special perks
- **VIP Requests** - High-tier customers make special orders
- **Store Reputation** - Customer satisfaction affects overall business
- **Memory System** - NPCs remember service quality and interactions

</details>

<details>
<summary><strong>SEASONAL EVENTS</strong> - Year-Round Engagement!</summary>

### **?? Dynamic Holiday System**

- **Christmas Events** - Holiday decorations and special items
- **Halloween Specials** - Spooky themes and limited products
- **Valentine's Promotions** - Romantic items and couple discounts
- **Custom Events** - Server-specific holidays and celebrations
- **Automatic Scheduling** - Events activate based on real-world dates

</details>

<details>
<summary><strong>INTERACTIVE MINI-GAMES</strong> - Engaging Gameplay!</summary>

### **?? Skill-Based Challenges**

- **Cooking Challenges** - Time-based food preparation in kitchens
- **Speed Serving** - Quick customer service competitions
- **Inventory Puzzles** - Efficient stocking challenges
- **Customer Satisfaction** - Interactive dialogue with NPCs
- **Bonus Rewards** - Extra XP and tips for excellent performance

</details>

---

## **Installation Guide** - *Get Started in 5 Minutes!*

### **Prerequisites Checklist**

> ? FiveM Server (Latest Version)  
> ? Basic Server Knowledge  
> ?? MySQL Database (Recommended for full features)  
> ?? ESX/QBCore Framework (Optional)

### **Step-by-Step Installation**

<details>
<summary><strong>STEP 1:</strong> Download the Latest</summary>

### **Get Your Copy!**

1. **Visit our releases**: [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/latest)
2. **Download**: `retail_jobs-v0.0.6.zip` 
3. **Celebrate**: You're getting the most advanced version yet!

</details>

<details>
<summary><strong>STEP 2:</strong> Perfect Folder Structure</summary>

### **Organize Like a Pro!**

```
server-data/
??? resources/
?   ??? [jobs]/                    # Category folder (optional)
?   ?   ??? retail_jobs/           # EXACT NAME - No spaces!
?   ?       ??? fxmanifest.lua
?   ?       ??? config.lua
?   ?       ??? database.sql       # Enhanced for v0.0.6
?   ?       ??? locales/           # NEW: Language files
?   ?       ??? shared/
?   ?       ??? server/
?   ?       ??? client/
?   ?       ??? html/
?   ??? [other awesome resources]/
??? server.cfg
??? [other server files]
```

</details>

<details>
<summary><strong>STEP 3:</strong> Database Setup</summary>

### **Enhanced Database Features!**

**NEW in v0.0.6**: Additional tables for achievements and loyalty
1. **Backup your database** (if upgrading)
2. Run the updated `database.sql` file
   ```sql
   mysql -u yourusername -p yourdatabase < database.sql
   ```

</details>

<details>
<summary><strong>STEP 4:</strong> Configuration Magic</summary>

### **New v0.0.6 Settings!**

Open `config.lua` and configure the exciting new features:

```lua
-- Multi-Language Support
Config.Language = {
    default = 'en',                    -- Your server's primary language
    available = {'en', 'es', 'fr', 'de', 'pt'},
    allowPlayerChoice = true           -- Let players choose language
}

-- Customer Loyalty Program
Config.Loyalty = {
    enabled = true,                    -- Enable loyalty system
    memoryDuration = 7 * 24 * 60 * 60 -- Remember customers for 7 days
}

-- Seasonal Events
Config.Events = {
    enabled = true,                    -- Enable holiday events
    christmas = { start = '12-15', end = '01-05' }
}

-- Mini-Games
Config.MiniGames = {
    enabled = true,                    -- Enable interactive challenges
    difficulty = 'medium'              -- easy, medium, hard
}
```

</details>

<details>
<summary><strong>STEP 5:</strong> Launch & Enjoy</summary>

### **Go Live!**

```cfg
# Add to server.cfg
ensure retail_jobs
```

**Restart your server and experience the new features!**

</details>

---

## **Player Experience** - *Living the Global Retail Dream!*

### **?? For New Players - Your International Journey!**

<div align="center">

### **Welcome Bonus Package!** ??

**New employees get:** 100 XP + Training + Language Choice + Achievement Tracker

</div>

#### **Getting Started Journey**

1. **Choose Language**: Select your preferred language on first join
2. **Find a Store**: Look for seasonal decorations and special events
3. **Clock In**: Experience the improved ESX-compatible interaction system
4. **Complete Mini-Games**: Earn extra rewards through skill challenges
5. **Build Loyalty**: Create relationships with returning customers
6. **Unlock Achievements**: Progress through badge milestones

### **?? New Interactive Features**

- **Mini-Game Challenges**: Test your skills in cooking and serving competitions
- **Loyalty Management**: Track your regular customers and their preferences
- **Seasonal Participation**: Enjoy holiday themes and special events
- **Achievement Progress**: Unlock badges and compete on leaderboards
- **Language Switching**: Change language anytime in the job menu

---

## **Performance & Features**

### **?? What's Enhanced in v0.0.6**

- **40% Better Performance** - Optimized memory usage and faster loading
- **Complete ESX Compatibility** - No more conflicts with other job resources
- **Multi-Language Ready** - Full Unicode support for international servers
- **Interactive Gameplay** - Mini-games and challenges for engaging experiences
- **Customer Intelligence** - Advanced NPC AI with memory and emotions
- **Seasonal Content** - Year-round events and themed experiences

### **?? Global Server Features**

- **Language Detection** - Auto-detect player language from FiveM settings
- **Cultural Adaptation** - Regional store names and products
- **Translation Tools** - Built-in interface for community translations
- **Voice Chat Ready** - Optional integration with proximity voice systems
- **Mobile Compatible** - Touch-friendly UI for tablet users

---

## **Community & Support**

<div align="center">

### **Join Our International Community!**

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-7289da.svg)](https://discord.gg/your-discord)
[![GitHub Issues](https://img.shields.io/badge/GitHub-Report%20Bug-red.svg)](https://github.com/GOD-GAMER/retail-script/issues)
[![Translation](https://img.shields.io/badge/Help-Translate-brightgreen.svg)](https://github.com/GOD-GAMER/retail-script/blob/main/TRANSLATION.md)

</div>

### **?? Translation Contributors**

Special thanks to our international community for making this script globally accessible!

---

## **Contributors & Credits**

<div align="center">

### **Hall of Fame** ?

*Building the future of FiveM retail together!*

</div>

- **GOD-GAMER** - *Lead Developer & Visionary*
- **International Community** - *Translation and localization*
- **Beta Testers** - *Performance testing and feedback*
- **FiveM Community** - *Ongoing support and suggestions*

---

<div align="center">

## **Ready to Go Global?**

### **Download v0.0.6 Now!**

[![Download](https://img.shields.io/badge/Download-retail__jobs--v0.0.6.zip-success.svg?style=for-the-badge)](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.6/retail_jobs-v0.0.6.zip)

---

**Version**: `0.0.6` | **Repository**: [GitHub](https://github.com/GOD-GAMER/retail-script) | **License**: MIT

**Languages**: 5 Supported | **Frameworks**: ESX, QBCore, Standalone | **Database**: MySQL Recommended

**Performance**: Optimized for 50+ concurrent players | **Mobile**: Tablet Compatible

---

### **Latest Updates - v0.0.6**

> **?? Multi-Language** | **?? Customer Loyalty** | **?? Seasonal Events** | **?? Mini-Games** | **?? Achievements**

---

*Made with ?? for the global FiveM community*

**? Star this repo if you found it helpful!**

</div>