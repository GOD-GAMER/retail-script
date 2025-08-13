-- Startup verification script
-- This will help debug resource loading issues

print("^2[RETAIL JOBS] ^0Resource loading started...")

-- Verify all required files exist
local requiredFiles = {
    'config.lua',
    'shared/utils.lua',
    'server/main.lua',
    'client/main.lua',
    'client/customer_ai.lua',
    'client/optimization.lua',
    'html/index.html',
    'html/style.css',
    'html/script.js'
}

-- Only do file path checking on server side where GetResourcePath is available
if IsDuplicityVersion() then -- Server side only
    for _, file in ipairs(requiredFiles) do
        local resourceName = GetCurrentResourceName()
        
        -- Note: We can't actually check file existence in FiveM runtime easily
        -- This is more for documentation of required files
        print("^3[RETAIL JOBS] ^0Required file: " .. file)
    end
else
    -- Client side - just list the files without path checking
    for _, file in ipairs(requiredFiles) do
        print("^3[RETAIL JOBS] ^0Required file: " .. file)
    end
end

-- Test configuration loading
if Config then
    print("^2[RETAIL JOBS] ^0Config loaded successfully")
    print("^3[RETAIL JOBS] ^0Framework: " .. (Config.Framework or "standalone"))
    if Config.Stores then
        print("^3[RETAIL JOBS] ^0Store count: " .. #Config.Stores)
    end
else
    print("^1[RETAIL JOBS] ^0ERROR: Config not loaded!")
end

-- Test shared utilities
if RetailJobs then
    print("^2[RETAIL JOBS] ^0Shared utilities loaded successfully")
else
    print("^1[RETAIL JOBS] ^0ERROR: Shared utilities not loaded!")
end

print("^2[RETAIL JOBS] ^0Resource verification complete!")

-- Export a test function to verify the resource is working
exports('testResource', function()
    return {
        status = "working",
        version = "0.0.6",
        stores = Config and Config.Stores and #Config.Stores or 0,
        framework = Config and Config.Framework or "standalone"
    }
end)