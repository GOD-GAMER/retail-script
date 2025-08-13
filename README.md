<div align="center">

# **FiveM Retail & Fast Food Jobs Script** ??

### *The Ultimate Career Simulator for Your FiveM Server!*

[![Version](https://img.shields.io/badge/version-0.0.4-blue.svg)](https://github.com/GOD-GAMER/retail-script/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-orange.svg)](https://fivem.net/)
[![ESX](https://img.shields.io/badge/ESX-?-success.svg)](https://github.com/esx-framework/esx-legacy)
[![QBCore](https://img.shields.io/badge/QBCore-?-success.svg)](https://github.com/qbcore-framework/qb-core)

**Transform your server into a thriving economic ecosystem!**

*From flipping burgers to running corporations - let your players live the retail dream!*

---

### ?? **NEW IN v0.0.4 - CRITICAL FIXES APPLIED!**

> **No More Flickering** | **Fixed Clock In/Out** | **Better Performance** | **Clean Package**

</div>

---

## **What Makes This Script AMAZING?**

<details>
<summary><strong>CORPORATE LADDER SYSTEM</strong> - From Trainee to CEO!</summary>

### **Climb Your Way to the Top!**

| Rank | Title | Salary | Requirements | Special Perks |
|------|-------|--------|--------------|---------------|
| **1** | Trainee | $100 | 0 XP | *Learning the ropes* |
| **2** | Employee | $150 | 500 XP | 5% Discount |
| **3** | Senior Employee | $200 | 1,500 XP | Flexible Schedule |
| **4** | Team Leader | $300 | 3,000 XP | Inventory Management |
| **5** | Supervisor | $450 | 5,000 XP | Hire & Fire Powers |
| **6** | Assistant Manager | $600 | 8,000 XP | Full Management |
| **7** | Store Manager | $800 | 12,000 XP | Owner Privileges |
| **8** | District Manager | $1,200 | 20,000 XP | Multi-Store Access |
| **9** | Regional Manager | $1,800 | 35,000 XP | Executive Perks |
| **10** | CEO | $3,000 | 60,000 XP | **UNLIMITED POWER!** |

</details>

<details>
<summary><strong>SMART NPC CUSTOMERS</strong> - They're Almost Human!</summary>

### **Advanced AI Features:**

- **Personality Types**: Impatient Karens, Chill Customers, Penny Pinchers
- **Dynamic Shopping**: Browse, compare, change their minds
- **Patience System**: Keep them happy or lose the sale!
- **Mood Visualization**: See their satisfaction in real-time
- **Realistic Purchases**: Single items, bulk buying, or window shopping

```lua
-- Example: Customer AI in action
Customer {
    personality = "Impatient",
    patience = 30, -- seconds
    mood = "Neutral",
    shoppingList = {"Burger", "Fries", "Drink"},
    budget = 25
}
```

</details>

<details>
<summary><strong>MULTIPLE JOB TYPES</strong> - Variety is the Spice of Life!</summary>

### **Retail Stores**
- Electronics & Gadgets
- Clothing & Fashion  
- General Merchandise
- Gaming Gear

### **Fast Food Restaurants**
- Pizza Joints
- Coffee Shops
- Quick Service
- Chicken Chains

### **Work Stations**
- **Cashier**: *"Would you like fries with that?"*
- **Kitchen**: *"Order up!"*
- **Inventory**: *"Time to restock!"*
- **Management**: *"I run this place!"*

</details>

---

## **Installation Guide** - *Get Started in 5 Minutes!*

### **Prerequisites Checklist**

> ? FiveM Server (Latest Version)  
> ? Basic Server Knowledge  
> ?? MySQL Database (Optional)  
> ?? ESX/QBCore Framework (Optional)

### **Step-by-Step Installation**

<details>
<summary><strong>STEP 1:</strong> Download the Magic</summary>

### **Get Your Copy!**

1. **Visit our releases**: [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/latest)
2. **Download**: `retail_jobs-v0.0.4.zip` 
3. **Celebrate**: You're one step closer to retail greatness!

</details>

<details>
<summary><strong>STEP 2:</strong> Perfect Folder Structure</summary>

### **Organize Like a Pro!**

```
server-data/
??? resources/
?   ??? [jobs]/                    # Category folder (optional but neat!)
?   ?   ??? retail_jobs/           # EXACT NAME - No spaces!
?   ?       ??? fxmanifest.lua
?   ?       ??? config.lua
?   ?       ??? shared/
?   ?       ??? server/
?   ?       ??? client/
?   ?       ??? html/
?   ??? [other awesome resources]/
??? server.cfg
??? [other server files]
```

> **Pro Tip**: Keep your resource folder organized with categories!

</details>

<details>
<summary><strong>STEP 3:</strong> Configuration Magic</summary>

### **Choose Your Adventure!**

Open `config.lua` and pick your setup:

```lua
-- Framework Setup
Config.Framework = 'esx'        -- 'esx' | 'qbcore' | 'standalone'
Config.UseDatabase = true       -- MySQL magic? true | false
Config.Debug = false           -- Troubleshooting mode

-- Economy Settings
Config.Currency = 'cash'        -- 'cash' | 'bank' | 'money'

-- Store Locations (Add your own!)
Config.Stores = {
    -- Downtown General Store
    {
        type = 'retail',
        name = 'Downtown General Store',
        coords = vector3(25.7, -1347.3, 29.49),
        blip = { sprite = 52, color = 2, scale = 0.8 }
    }
}
```

</details>

<details>
<summary><strong>STEP 4:</strong> Database Setup (Optional)</summary>

### **Persistent Data Magic!**

If you want player data to survive server restarts:

```sql
-- Run this in your MySQL database
mysql -u yourusername -p yourdatabase < database.sql
```

**Or skip it!** The script works great without a database too!

</details>

<details>
<summary><strong>STEP 5:</strong> Server Configuration</summary>

### **Add to server.cfg**

```cfg
# Add this line to activate the magic!
ensure retail_jobs

# OR if you're using categories:
ensure [jobs]
```

**Restart your server and watch the magic happen!**

</details>

---

## **Player Experience** - *Living the Retail Dream!*

### **For New Players - Your First Day!**

<div align="center">

### **Welcome Bonus Package!** ??

**New employees get:** 100 XP + Training + Welcome Guide

</div>

#### **Getting Started Journey**

1. **Find a Store**: Look for these beautiful blips on your map!
   - **Retail**: Green store icons
   - **Fast Food**: Orange/red food icons

2. **Clock In**: Walk to the **GREEN** prompt and press your interact key
   - *No more conflicts or flickering - it just works!*

3. **Complete Training**: Earn bonus XP with tutorial tasks
   - Clock In Tutorial: **+25 XP**
   - First Customer: **+50 XP**
   - Inventory Management: **+25 XP**

4. **Start Working**: Use different work stations
   - Cashier counter
   - Kitchen area
   - Inventory room

5. **Clock Out**: Find the **RED** prompt when you're done

### **Work Station Guide**

| Station | What You Do | Experience Gained | Fun Factor |
|---------|-------------|-------------------|------------|
| **Cashier** | Serve customers, process sales | 10 XP per customer | ???? |
| **Kitchen** | Prepare delicious food | 8 XP per order | ????? |
| **Inventory** | Restock shelves, manage supplies | 5 XP per action | ??? |
| **Office** | Handle management tasks | Varies | ????? |

### **Controls** - *Fully Customizable!*

> **Change your keybinds in FiveM Settings > Key Bindings > FiveM**

- **INTERACT** - Work with stations and customers *(Default: E)*
- **JOB MENU** - Access your job dashboard *(Default: F6)*  
- **QUICK SERVE** - Instantly serve nearby customers *(Default: G)*

---

## **For Server Admins** - *Power Tools!*

### **Admin Commands**

```lua
-- Player Management
addexp [playerid] [amount]        -- Boost someone's experience
promoteplayer [playerid] [rank]   -- Instant promotion!

-- Server Monitoring  
/retailstats                      -- View server-wide statistics
/reloadretail                     -- Hot reload configuration
```

### **Performance Dashboard**

Monitor your server's retail economy:

- **Active Employees**: Real-time count
- **Daily Revenue**: Track economic impact
- **Store Performance**: Which locations are popular?
- **Error Tracking**: Automatic issue detection

### **Advanced Configuration**

<details>
<summary><strong>Economy Tuning</strong></summary>

```lua
-- Salary Structure
Config.Jobs = {
    retail = {
        name = 'Retail Associate',
        maxPlayers = 15,           -- Max employees per store
        paycheck = { 
            base = 75,             -- Base hourly wage
            multiplier = 1.3       -- Rank multiplier
        }
    },
    fastfood = {
        name = 'Food Service Worker',
        maxPlayers = 12,
        paycheck = { 
            base = 65,
            multiplier = 1.25 
        }
    }
}
```

</details>

<details>
<summary><strong>Experience System</strong></summary>

```lua
-- XP Rewards Configuration
Config.Experience = {
    serving_customer = 10,      -- Per customer served
    restocking = 5,            -- Per inventory action
    perfect_service = 20,      -- Bonus for excellent service
    training_completion = 100, -- Tutorial bonus
    overtime_bonus = 50,       -- Working long hours
    monthly_achievement = 200  -- Monthly goals
}
```

</details>

---

## **API Reference** - *For Developers!*

### **Exports**

```lua
-- Get player job information
local jobData = exports['retail_jobs']:getPlayerJobData(playerId)

-- Add experience points
exports['retail_jobs']:addExperience(playerId, 50, 'Excellent Service')

-- Promote a player
exports['retail_jobs']:promotePlayer(playerId, 5)

-- Get all store data
local stores = exports['retail_jobs']:getJobStores()
```

### **Events**

```lua
-- Server Events
TriggerServerEvent('retail:clockIn', storeId, jobType)
TriggerServerEvent('retail:serveCustomer', customerId, items, total)

-- Client Events  
TriggerClientEvent('retail:promoted', playerId, newRank, rankData)
TriggerClientEvent('retail:notify', playerId, 'Great job!', 'success')
```

---

## **Customization** - *Make It Yours!*

### **Adding New Stores**

Want a convenience store at the pier? No problem!

```lua
-- Add to Config.Stores
{
    type = 'retail',
    name = 'Pier Convenience Store',
    coords = vector3(-1686.8, -1072.4, 13.15),
    blip = { sprite = 52, color = 3, scale = 0.9 },
    products = {
        {name = 'Beach Sandwich', price = 8, stock = 30},
        {name = 'Sunscreen', price = 12, stock = 20},
        {name = 'Cold Drink', price = 4, stock = 50}
    },
    workStations = {
        cashier = vector3(-1687.2, -1072.8, 13.15),
        inventory = vector3(-1685.5, -1074.1, 13.15)
    }
}
```

### **Custom Training Modules**

Create specialized training for your server:

```lua
-- Advanced barista training
local baristaTraining = {
    name = 'Master Barista Certification',
    description = 'Learn the art of perfect coffee',
    requiredRank = 4,
    duration = 600,        -- 10 minutes
    experienceReward = 150,
    unlocks = {'premium_coffee_station'}
}
```

---

## **Achievements & Milestones**

Track your players' progress with built-in achievements:

| Achievement | Description | Reward |
|---------------|-------------|---------|
| **First Sale** | Complete your first transaction | 25 XP + Badge |
| **Hot Streak** | Serve 10 customers without a break | 50 XP |
| **Manager Material** | Reach Supervisor rank | Special uniform |
| **Corporate Legend** | Become CEO | Company car spawn |
| **Perfect Month** | 30 days of excellent service | 500 XP + Title |

---

## **Troubleshooting** - *We've Got You Covered!*

<details>
<summary><strong>Common Issues & Solutions</strong></summary>

### **"Players can't clock in"**
- ? Check store coordinates in `config.lua`
- ? Verify the store isn't at max capacity
- ? Ensure proper framework setup

### **"NPCs not spawning"**
- ? Set `Config.NPCCustomers.enabled = true`
- ? Check spawn radius and chance settings
- ? Monitor server performance

### **"Script errors in console"**
- ? Enable `Config.Debug = true`
- ? Check all dependencies are loaded
- ? Verify file permissions

### **"Poor performance"**
- ? Reduce `Config.NPCCustomers.maxCustomers`
- ? Increase cleanup intervals
- ? Enable optimization mode

</details>

### **Debug Mode**

Need to investigate? Turn on developer mode:

```lua
-- In config.lua
Config.Debug = true
Config.LogLevel = 'debug'  -- 'debug' | 'info' | 'warn' | 'error'
```

---

## **Community & Support**

<div align="center">

### **Join Our Community!**

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-7289da.svg)](https://discord.gg/your-discord)
[![GitHub Issues](https://img.shields.io/badge/GitHub-Report%20Bug-red.svg)](https://github.com/GOD-GAMER/retail-script/issues)
[![Documentation](https://img.shields.io/badge/Docs-Read%20More-blue.svg)](https://github.com/GOD-GAMER/retail-script/wiki)

</div>

### **How to Get Help**

1. **Check the docs** - Most answers are here!
2. **Search existing issues** - Someone might have asked already
3. **Report bugs** - Help us make it better
4. **Request features** - We love new ideas!

### **Roadmap - What's Coming Next!**

- [ ] **Multi-language support** *(Spanish, French, German)*
- [ ] **Mobile app integration** *(Check schedules on your phone)*
- [ ] **Franchise system** *(Own multiple stores)*
- [ ] **Mini-games** *(Cooking challenges, speed serving)*
- [ ] **Leaderboards** *(Top employees, stores, regions)*
- [ ] **Custom uniforms** *(Rank-based outfits)*

---

## **Contributors & Credits**

<div align="center">

### **Hall of Fame** ?

*Special thanks to everyone who made this possible!*

</div>

- **GOD-GAMER** - *Lead Developer & Visionary*
- **FiveM Community** - *Testing, feedback, and support*
- **ESX/QBCore Teams** - *Framework compatibility*
- **UI/UX Contributors** - *Making it beautiful*
- **Bug Hunters** - *Finding issues before you do*

### **Want to Contribute?**

We'd love your help! Check out our [Contributing Guide](CONTRIBUTING.md) to get started.

---

## **License**

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

*TL;DR: Use it, modify it, distribute it, just keep the license notice!*

---

<div align="center">

## **Ready to Transform Your Server?**

### **Download v0.0.4 Now!**

[![Download](https://img.shields.io/badge/Download-retail__jobs--v0.0.4.zip-success.svg?style=for-the-badge)](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.4/retail_jobs-v0.0.4.zip)

---

**Version**: `0.0.4` | **Repository**: [GitHub](https://github.com/GOD-GAMER/retail-script) | **License**: MIT

**Compatibility**: FiveM, ESX, QBCore | **Requirements**: None *(MySQL optional)*

**Performance**: Optimized for 30+ concurrent players

---

### **Latest Updates - v0.0.4**

> ? **No More Flickering** - Stable interaction points  
> ? **Clock In/Out Fixed** - Reliable clocking system  
> ? **Clean Codebase** - Optimized for server deployment  
> ? **Better Performance** - Improved rendering and reduced resource usage  
> ? **Enhanced ESX Integration** - Smoother framework compatibility

---

*Made with ?? for the FiveM community*

**? Star this repo if you found it helpful!**

</div>