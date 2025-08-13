# ?? FiveM Retail Jobs Script v0.0.5

## ?? Release Summary

This is a major feature update, introducing an **Advanced Inventory System**, a new **Management Dashboard**, and a **Supplier System**. This release adds significant depth to the gameplay, especially for higher-ranked players.

## ? **What's New in v0.0.5**

### **?? Advanced Inventory System**
- **Individual Item Tracking**: Each item's stock is now tracked individually per store.
- **Spoilage System**: Perishable goods will spoil if not sold in time, adding a new layer of challenge.
- **Supplier Orders**: Managers can order stock from various suppliers with different prices and delivery times.
- **Stock Alerts**: Automatic notifications when items are running low.

### **?? Management Dashboard**
- **New UI**: A dedicated interface for managers to oversee store operations.
- **Sales Analytics**: View graphs of daily/weekly sales, top-selling items, and revenue.
- **Employee Performance**: Track employee hours, sales, and customer satisfaction.
- **Live Inventory View**: See real-time stock levels for your store.

### **?? Supplier System**
- **Multiple Suppliers**: Configure different suppliers with unique product offerings and pricing.
- **Delivery System**: Orders are delivered by NPC trucks, adding immersion.
- **Supplier Reputation**: Building a good relationship with suppliers can unlock discounts.

### **?? Employee Scheduling**
- **Weekly Schedules**: Managers can assign shifts to employees.
- **Time-off Requests**: Employees can request time off through the job menu.
- **Shift Bonuses**: Offer bonuses for working unpopular shifts.

### **?? Enhanced Gameplay**
- **Dynamic Pricing**: Managers can adjust prices based on demand or to clear out old stock.
- **Smarter Customers**: NPCs now have specific shopping lists and will leave if they can't find what they want.
- **Granular Permissions**: More detailed control over what each management rank can do.

## ?? **Installation**

1. **Download**: Download the latest release from [GitHub Releases](https://github.com/GOD-GAMER/retail-script/releases/tag/v0.0.5)
2. **Extract**: Extract to your `resources/retail_jobs/` folder.
3. **Database**: **IMPORTANT** - The database schema has changed. You must run the new `database.sql`.
4. **Configure**: Update `config.lua` with the new settings for inventory and suppliers.
5. **Start**: Add `ensure retail_jobs` to your `server.cfg`.

## ?? **Upgrade from v0.0.4**

### **?? Breaking Changes**
- **Database**: The database schema has been updated. You **must** run the new `database.sql` file. It's recommended to backup your old data first.
- **Configuration**: `config.lua` has new sections for `Config.Inventory` and `Config.Suppliers`. You'll need to add these from the new config file.

### **Migration Steps**
1. **Backup your database** and `config.lua`.
2. Replace all script files with the new v0.0.5 files.
3. **Execute the new `database.sql`** in your MySQL database.
4. **Copy the new sections** from the v0.0.5 `config.lua` into your existing config file.
5. Restart your server.

## ?? **New Configuration Options**

```lua
-- config.lua

-- Advanced Inventory Settings
Config.Inventory = {
    enableSpoilage = true,
    spoilageTime = 48, -- in hours
    lowStockThreshold = 10 -- percentage
}

-- Supplier System
Config.Suppliers = {
    {
        name = 'Mega Wholesale',
        products = {'water', 'sandwich', 'soda'},
        deliveryTime = 30, -- in minutes
        baseCostMultiplier = 0.8
    },
    {
        name = 'Premium Goods Inc.',
        products = {'energy_drink', 'cigarettes'},
        deliveryTime = 60,
        baseCostMultiplier = 0.9
    }
}
```

## ?? **New Player Experience**

### **For Managers**
- **Open Dashboard**: Use the office work station to open the new Management Dashboard.
- **Order Stock**: Access the supplier menu to order new inventory.
- **Set Schedules**: Use the dashboard to manage employee shifts.
- **Adjust Prices**: Dynamically change item prices to react to the market.

### **For Employees**
- **Check Stock**: See real-time stock levels at the inventory station.
- **View Schedule**: Check your upcoming shifts in the job menu.
- **Request Time Off**: Submit time-off requests to your manager.

---

**Full Changelog**: https://github.com/GOD-GAMER/retail-script/blob/main/CHANGELOG.md

**Download**: [retail_jobs-v0.0.5.zip](https://github.com/GOD-GAMER/retail-script/releases/download/v0.0.5/retail_jobs-v0.0.5.zip)