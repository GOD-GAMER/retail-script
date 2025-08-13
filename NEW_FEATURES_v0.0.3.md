# ?? **NEW FEATURES IN v0.0.3 - Player Experience Improvements**

## ?? **Fixed Interaction Issues**

### **Problem Resolution**
- ? **Fixed overlapping interactions** - Clock in/out, cash register, and inventory no longer conflict
- ? **Separate interaction zones** - Each function has its own dedicated area with proper distances
- ? **Priority system** - Higher priority actions (like clocking out) take precedence
- ? **Interaction cooldown** - Prevents accidental double-interactions

### **Enhanced Controls**
- ?? **Smart interaction detection** - Only shows the most relevant action
- ?? **Improved distance management** - Different distances for different interaction types
- ?? **Cooldown system** - 1-second cooldown between interactions to prevent spam

## ?? **Customizable Keybinds**

### **In-Game Keybind Configuration**
- ?? **Change keybinds while playing** - No need to edit files!
- ?? **Automatically saved** - Your preferences persist across sessions
- ?? **Conflict prevention** - Won't let you assign the same key twice
- ?? **Easy management** - Simple commands to view and change keybinds

### **Available Commands**
```
/keybinds          - View current keybind settings
/setkeybind interact - Change the interact key
/setkeybind menu     - Change the job menu key  
/setkeybind quick_serve - Change the quick serve key
```

### **Default Keybinds**
- `E` - Interact with work stations and customers
- `F6` - Open job management menu
- `G` - Quick serve nearest customer
- `Z` - Open keybind configuration menu

## ?? **New Player Experience System**

### **Starting Bonus**
- ?? **Welcome package** - New players get 100 starting experience
- ?? **Instant training** - Begin at a higher level instead of struggling
- ?? **First-time bonuses** - Extra experience for initial actions

### **Tutorial Tasks**
New players can complete these tasks for bonus experience:

1. **Clock In Tutorial** (+25 XP) - Learn the basics
2. **Customer Service Basics** (+50 XP) - Serve your first customer  
3. **Inventory Management** (+25 XP) - Learn restocking

### **Progressive Learning**
- ?? **Smart progression** - Experience gains are balanced for new players
- ?? **Achievement system** - Complete tasks to advance faster
- ?? **Helpful hints** - On-screen guidance for new employees

## ??? **Improved Store Layouts**

### **Separated Interaction Zones**
Each store now has dedicated areas:

- ?? **Clock In/Out Area** - Separate from other interactions
- ?? **Cashier Station** - Customer service area
- ?? **Inventory Management** - Stock control zone  
- ?? **Management Office** - Supervisor functions

### **Clear Visual Feedback**
- ?? **Distinct interaction prompts** - Know exactly what you're interacting with
- ?? **Priority indicators** - Most important actions show first
- ?? **Distance optimization** - Interactions activate at appropriate ranges

## ?? **Enhanced Player Controls**

### **Smart Interaction System**
```lua
-- Interaction priorities (higher = more important)
Clock In/Out: Priority 10
Work Stations: Priority 8  
Customers: Priority 6
Management: Priority 4
```

### **Improved User Experience**
- ?? **Responsive controls** - No more missed interactions
- ?? **Customizable setup** - Configure controls to your preference
- ?? **Smooth operation** - Better performance and reliability

## ?? **Experience Gaining Guide**

### **How to Gain Experience When Starting**

#### **First Day Checklist:**
1. ?? **Clock In** (+50 XP) - First time bonus
2. ?? **Complete Tutorial** (+100 XP) - Automatic on first clock in
3. ?? **Serve First Customer** (+60 XP) - 10 base + 50 tutorial task
4. ?? **Restock Items** (+30 XP) - 5 base + 25 tutorial task
5. ?? **Perfect Service** (+20 XP) - Bonus for good service

#### **Daily Experience Sources:**
- **Serving Customers**: 10 XP per customer
- **Restocking Items**: 5 XP per restock action
- **Perfect Service Bonus**: 20 XP every 10 customers
- **Training Modules**: Various XP amounts
- **Overtime Work**: 50 XP bonus

#### **Experience Tips:**
- ?? **Stay busy** - The more customers you serve, the more XP you earn
- ?? **Focus on quality** - Good service gives bonus experience
- ?? **Complete training** - Training modules give substantial XP
- ? **Work consistently** - Regular shifts unlock bonuses

## ??? **Admin Tools**

### **Server Commands** (Console Only)
```
addexp [playerid] [amount]     - Give experience to a player
promoteplayer [playerid] [rank] - Promote player to specific rank
```

### **Debugging**
- ?? **Debug mode** - Set `Config.Debug = true` for detailed logging
- ?? **Performance monitoring** - Track interaction system performance
- ?? **Interaction testing** - Visual feedback for interaction zones

---

## ?? **Upgrade Instructions from v0.0.2**

1. **Backup your current setup**
2. **Replace all script files** with v0.0.3
3. **Update your config.lua** if you made custom changes
4. **Restart the resource**
5. **Test the new interaction system**

Your player data and store configurations will be preserved!

---

*These improvements make the retail job system much more user-friendly and eliminate the frustrating interaction conflicts that players experienced in v0.0.2.*