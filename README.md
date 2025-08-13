<div align="center">

# **FiveM Retail & Fast Food Jobs Script** ??

### *The Ultimate Career Simulator for Your FiveM Server!*

[![Version](https://img.shields.io/badge/version-0.0.5-blue.svg)](https://github.com/GOD-GAMER/retail-script/releases)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)
[![FiveM](https://img.shields.io/badge/FiveM-Compatible-orange.svg)](https://fivem.net/)
[![ESX](https://img.shields.io/badge/ESX-?-success.svg)](https://github.com/esx-framework/esx-legacy)
[![QBCore](https://img.shields.io/badge/QBCore-?-success.svg)](https://github.com/qbcore-framework/qb-core)

**Transform your server into a thriving economic ecosystem!**

*From flipping burgers to running corporations - let your players live the retail dream!*

---

### ?? **NEW IN v0.0.5 - ADVANCED INVENTORY & MANAGEMENT!**

> **Advanced Inventory** | **Management Dashboard** | **Supplier System** | **Employee Scheduling**

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

</details>

<details>
<summary><strong>MULTIPLE JOB TYPES</strong> - Variety is the Spice of Life!</summary>

### **Retail Stores** & **Fast Food Restaurants**
- Electronics, Clothing, General Merchandise, Gaming Gear
- Pizza Joints, Coffee Shops, Quick Service, Chicken Chains

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
> ?? MySQL Database (Optional but Recommended for v0.0.5)  
> ?? ESX/QBCore Framework (Optional)

### **Step-by-Step Installation**

<details>
<summary><strong>STEP 1:</strong> Download the Magic</summary>

### **Get Your Copy!**

1. **Visit our releases**: [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/latest)
2. **Download**: `retail_jobs-v0.0.5.zip` 
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
?   ?       ??? database.sql       # IMPORTANT
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
<summary><strong>STEP 3:</strong> Database Setup (Required for v0.0.5 features)</summary>

### **Persistent Data Magic!**

**IMPORTANT**: v0.0.5 includes major database changes.
1. **Backup your old database!**
2. Run the new `database.sql` file in your MySQL database.
   ```sql
   mysql -u yourusername -p yourdatabase < database.sql
   ```

</details>

<details>
<summary><strong>STEP 4:</strong> Configuration Magic</summary>

### **Choose Your Adventure!**

Open `config.lua` and update it with the new sections from the v0.0.5 release.

```lua
-- Framework Setup
Config.Framework = 'esx'        -- 'esx' | 'qbcore' | 'standalone'
Config.UseDatabase = true       -- Recommended for v0.0.5

-- NEW: Advanced Inventory & Supplier Settings
Config.Inventory = {
    enableSpoilage = true,
    spoilageTime = 48, -- hours
}
Config.Suppliers = { ... }
```

</details>

<details>
<summary><strong>STEP 5:</strong> Server Configuration</summary>

### **Add to server.cfg**

```cfg
# Add this line to activate the magic!
ensure retail_jobs
```

**Restart your server and enjoy the new features!**

</details>

---

## **Player Experience** - *Living the Retail Dream!*

### **For New Players - Your First Day!**

<div align="center">

### **Welcome Bonus Package!** ??

**New employees get:** 100 XP + Training + Welcome Guide

</div>

#### **Getting Started Journey**

1. **Find a Store**: Look for blips on your map.
2. **Clock In**: Walk to the **GREEN** prompt and press your interact key.
3. **Complete Training**: Earn bonus XP with tutorial tasks.
4. **Start Working**: Use different work stations.
5. **Clock Out**: Find the **RED** prompt when you're done.

### **For Managers - New Tools!**
- **Management Dashboard**: Access from the office to view sales, manage employees, and set prices.
- **Supplier Orders**: Order new stock from different suppliers.
- **Employee Scheduling**: Set weekly shifts for your team.

---

## **Troubleshooting** - *We've Got You Covered!*

<details>
<summary><strong>Common Issues & Solutions</strong></summary>

### **"I get database errors after updating!"**
- ? Did you run the new `database.sql` file? This is required for v0.0.5.

### **"Players can't clock in"**
- ? Check store coordinates in `config.lua`.
- ? Ensure the script is started correctly in `server.cfg`.

### **"NPCs not spawning"**
- ? Set `Config.NPCCustomers.enabled = true` in `config.lua`.

</details>

---

## **Community & Support**

<div align="center">

### **Join Our Community!**

[![Discord](https://img.shields.io/badge/Discord-Join%20Server-7289da.svg)](https://discord.gg/your-discord)
[![GitHub Issues](https://img.shields.io/badge/GitHub-Report%20Bug-red.svg)](https://github.com/GOD-GAMER/retail-script/issues)
[![Documentation](https://img.shields.io/badge/Docs-Read%20More-blue.svg)](https://github.com/GOD-GAMER/retail-script/wiki)

</div>

---

## **Contributors & Credits**

<div align="center">

### **Hall of Fame** ?

*Special thanks to everyone who made this possible!*

</div>

- **GOD-GAMER** - *Lead Developer & Visionary*
- **FiveM Community** - *Testing, feedback, and support*
- **ESX/QBCore Teams** - *Framework compatibility*

---

<div align="center">

## **Ready to Transform Your Server?**

### **Download v0.0.5 Now!**

[![Download](https://img.shields.io/badge/Download-retail__jobs--v0.0.5.zip-success.svg?style=for-the-badge)](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.5/retail_jobs-v0.0.5.zip)

---

**Version**: `0.0.5` | **Repository**: [GitHub](https://github.com/GOD-GAMER/retail-script) | **License**: MIT

**Compatibility**: FiveM, ESX, QBCore | **Requirements**: MySQL Recommended

**Performance**: Optimized for 30+ concurrent players

---

### **Latest Updates - v0.0.5**

> **Advanced Inventory** | **Management Dashboard** | **Supplier System** | **Employee Scheduling**

---

*Made with ?? for the FiveM community*

**? Star this repo if you found it helpful!**

</div>