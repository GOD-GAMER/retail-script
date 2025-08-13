Config = {}

-- Debug Settings (Enable for troubleshooting)
Config.Debug = true -- Set to true to see debug messages in console
Config.LogLevel = 'debug' -- 'debug', 'info', 'warn', 'error'

-- Framework Settings
Config.Framework = 'esx' -- 'esx', 'qbcore', 'standalone'
Config.UseDatabase = true -- Set to false if not using MySQL
Config.Currency = 'cash' -- 'cash', 'bank', 'money'

-- Job Settings
Config.Jobs = {
    retail = {
        name = 'Retail Worker',
        maxPlayers = 10,
        paycheck = {
            base = 50,
            multiplier = 1.2 -- Increases with rank
        }
    },
    fastfood = {
        name = 'Fast Food Worker',
        maxPlayers = 8,
        paycheck = {
            base = 45,
            multiplier = 1.15
        }
    }
}

-- Corporate Ladder System
Config.Ranks = {
    [1] = { name = 'Trainee', salary = 100, required_exp = 0, perks = {} },
    [2] = { name = 'Employee', salary = 150, required_exp = 500, perks = {'discount_5'} },
    [3] = { name = 'Senior Employee', salary = 200, required_exp = 1500, perks = {'discount_10', 'flexible_schedule'} },
    [4] = { name = 'Team Leader', salary = 300, required_exp = 3000, perks = {'discount_15', 'manage_inventory'} },
    [5] = { name = 'Supervisor', salary = 450, required_exp = 5000, perks = {'discount_20', 'hire_fire', 'set_prices'} },
    [6] = { name = 'Assistant Manager', salary = 600, required_exp = 8000, perks = {'discount_25', 'full_management'} },
    [7] = { name = 'Store Manager', salary = 800, required_exp = 12000, perks = {'discount_30', 'owner_privileges'} },
    [8] = { name = 'District Manager', salary = 1200, required_exp = 20000, perks = {'discount_40', 'multi_store_access'} },
    [9] = { name = 'Regional Manager', salary = 1800, required_exp = 35000, perks = {'discount_50', 'executive_perks'} },
    [10] = { name = 'CEO', salary = 3000, required_exp = 60000, perks = {'unlimited_perks', 'company_car'} }
}

-- New Player Experience System
Config.NewPlayerBonus = {
    enabled = true,
    startingExperience = 100, -- Start with some experience
    welcomeMessage = "Welcome to your first retail job! You've been given basic training.",
    initialTasks = {
        {name = "Clock In Tutorial", experience = 25, description = "Learn how to clock in and out"},
        {name = "Customer Service Basics", experience = 50, description = "Complete your first customer transaction"},
        {name = "Inventory Management", experience = 25, description = "Learn how to restock items"}
    }
}

-- Interaction System
Config.Interactions = {
    distances = {
        clockInOut = 4.0,      -- Increased distance for clock in/out
        workStation = 3.0,     -- Increased distance for work stations
        customer = 4.0,        -- Distance for customer interactions
        management = 2.0       -- Distance for management tasks
    },
    priorities = {
        clockInOut = 10,       -- Highest priority
        workStation = 8,       -- Medium-high priority
        customer = 6,          -- Medium priority
        management = 4         -- Lower priority
    },
    cooldown = 500            -- Reduced cooldown to 0.5 seconds
}

-- Store Locations with improved positioning
Config.Stores = {
    -- Retail Stores
    {
        type = 'retail',
        name = 'Downtown General Store',
        coords = vector3(25.7, -1347.3, 29.49),
        blip = { sprite = 52, color = 2, scale = 0.8 },
        npc = { model = 'a_m_m_business_01', coords = vector4(24.5, -1347.8, 29.49, 270.0) },
        clockInOut = vector3(24.0, -1345.0, 29.49), -- Separate clock in/out location
        products = {
            {name = 'Sandwich', price = 5, stock = 50},
            {name = 'Water', price = 2, stock = 100},
            {name = 'Energy Drink', price = 8, stock = 30},
            {name = 'Cigarettes', price = 15, stock = 20}
        },
        workStations = {
            cashier = vector3(25.0, -1347.0, 29.49),
            inventory = vector3(27.0, -1349.0, 29.49),
            office = vector3(23.0, -1350.0, 29.49)
        }
    },
    {
        type = 'retail',
        name = 'Sandy Shores Market',
        coords = vector3(1961.3, 3740.0, 32.34),
        blip = { sprite = 52, color = 2, scale = 0.8 },
        npc = { model = 'a_m_m_business_01', coords = vector4(1960.8, 3740.5, 32.34, 90.0) },
        clockInOut = vector3(1959.0, 3738.0, 32.34), -- Separate clock in/out location
        products = {
            {name = 'Sandwich', price = 6, stock = 30},
            {name = 'Water', price = 3, stock = 80},
            {name = 'Snacks', price = 4, stock = 40}
        },
        workStations = {
            cashier = vector3(1961.0, 3740.0, 32.34),
            inventory = vector3(1963.0, 3742.0, 32.34),
            office = vector3(1958.0, 3738.0, 32.34)
        }
    },
    -- Fast Food Stores
    {
        type = 'fastfood',
        name = 'Burger Shot Downtown',
        coords = vector3(-1194.26, -884.88, 13.98),
        blip = { sprite = 106, color = 5, scale = 0.8 },
        npc = { model = 'a_f_y_business_02', coords = vector4(-1193.5, -885.2, 13.98, 35.0) },
        clockInOut = vector3(-1196.0, -882.0, 13.98), -- Separate clock in/out location
        products = {
            {name = 'Burger', price = 12, stock = 40},
            {name = 'Fries', price = 6, stock = 60},
            {name = 'Soda', price = 4, stock = 80},
            {name = 'Milkshake', price = 8, stock = 30}
        },
        workStations = {
            cashier = vector3(-1194.0, -885.0, 13.98),
            kitchen = vector3(-1196.0, -887.0, 13.98),
            drive_thru = vector3(-1192.0, -883.0, 13.98),
            office = vector3(-1198.0, -889.0, 13.98)
        }
    },
    {
        type = 'fastfood',
        name = 'Cluckin Bell Paleto',
        coords = vector3(-142.77, 6356.09, 31.49),
        blip = { sprite = 89, color = 17, scale = 0.8 },
        npc = { model = 'a_f_y_business_02', coords = vector4(-142.5, 6356.5, 31.49, 225.0) },
        clockInOut = vector3(-140.0, 6352.0, 31.49), -- Separate clock in/out location
        products = {
            {name = 'Chicken Burger', price = 14, stock = 35},
            {name = 'Wings', price = 10, stock = 45},
            {name = 'Soda', price = 4, stock = 70}
        },
        workStations = {
            cashier = vector3(-142.5, 6356.0, 31.49),
            kitchen = vector3(-144.0, 6358.0, 31.49),
            office = vector3(-140.0, 6354.0, 31.49)
        }
    }
}

-- NPC Customer Settings
Config.NPCCustomers = {
    enabled = true,
    spawnRadius = 50.0,
    maxCustomers = 5,
    spawnChance = 15, -- Percentage chance every 30 seconds
    models = {
        'a_m_m_bevhills_01', 'a_f_y_bevhills_01', 'a_m_y_business_01',
        'a_f_m_business_02', 'a_m_m_farmer_01', 'a_f_y_tourist_01',
        'a_m_y_downtown_01', 'a_f_m_downtown_01'
    },
    purchaseChance = {
        single_item = 40,
        multiple_items = 35,
        no_purchase = 25
    },
    waitTimes = {
        min = 5000,  -- 5 seconds
        max = 15000  -- 15 seconds
    }
}

-- Experience System
Config.Experience = {
    serving_customer = 10,
    restocking = 5,
    cleaning = 3,
    training_new_employee = 25,
    handling_complaint = 15,
    perfect_service = 20,
    overtime_bonus = 50,
    monthly_bonus = 200,
    first_clock_in = 50,      -- Bonus for first time clocking in
    tutorial_completion = 100  -- Bonus for completing tutorial
}

-- Optimization Settings
Config.Optimization = {
    npcCleanupTime = 300000, -- 5 minutes
    maxRenderDistance = 100.0,
    updateInterval = 1000, -- 1 second
    useStreamedTextures = true,
    enableLOD = true
}

-- UI Settings with FiveM Native Keybinds
Config.UI = {
    notifications = {
        position = 'top-right',
        duration = 5000
    },
    -- Note: Keybinds are now managed by FiveM's native system
    -- Players can customize them in: Settings > Key Bindings > FiveM
    keybindInfo = {
        interact = "retail_interact", -- FiveM keybind name
        menu = "retail_menu",         -- FiveM keybind name  
        quick_serve = "retail_quickserve" -- FiveM keybind name
    }
}