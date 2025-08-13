-- Performance Optimization Module
local OptimizationManager = {}

-- Entity management
local managedEntities = {}
local entityPoolSize = {
    customers = 50,
    props = 100,
    vehicles = 10
}

-- LOD (Level of Detail) system
local LODDistances = {
    high = 25.0,
    medium = 50.0,
    low = 100.0,
    cull = 150.0
}

-- Performance monitoring
local PerformanceMetrics = {
    frameTime = 0,
    memoryUsage = 0,
    entityCount = 0,
    lastUpdate = 0
}

function OptimizationManager.Initialize()
    -- Set up performance monitoring
    Citizen.CreateThread(function()
        while true do
            OptimizationManager.UpdatePerformanceMetrics()
            OptimizationManager.OptimizeEntities()
            OptimizationManager.CleanupUnusedResources()
            
            Citizen.Wait(5000) -- Check every 5 seconds
        end
    end)
end

function OptimizationManager.UpdatePerformanceMetrics()
    PerformanceMetrics.frameTime = GetFrameTime()
    PerformanceMetrics.memoryUsage = collectgarbage("count")
    PerformanceMetrics.entityCount = #managedEntities
    PerformanceMetrics.lastUpdate = GetGameTimer()
end

function OptimizationManager.RegisterEntity(entity, entityType, coords)
    if not DoesEntityExist(entity) then return end
    
    managedEntities[entity] = {
        type = entityType,
        coords = coords,
        lastSeen = GetGameTimer(),
        lodLevel = 'high',
        isVisible = true,
        networkId = NetworkGetNetworkIdFromEntity(entity)
    }
end

function OptimizationManager.UnregisterEntity(entity)
    managedEntities[entity] = nil
end

function OptimizationManager.OptimizeEntities()
    local playerCoords = GetEntityCoords(PlayerPedId())
    local frameTime = GetFrameTime()
    
    -- Adjust optimization aggressiveness based on performance
    local aggressiveMode = frameTime > 0.020 -- If frame time > 20ms
    
    for entity, data in pairs(managedEntities) do
        if DoesEntityExist(entity) then
            local distance = #(playerCoords - data.coords)
            OptimizationManager.SetEntityLOD(entity, distance, aggressiveMode)
        else
            managedEntities[entity] = nil
        end
    end
end

function OptimizationManager.SetEntityLOD(entity, distance, aggressive)
    local data = managedEntities[entity]
    if not data then return end
    
    local newLodLevel = 'high'
    local shouldCull = false
    
    -- Determine LOD level based on distance
    if distance > LODDistances.cull then
        shouldCull = true
    elseif distance > LODDistances.low then
        newLodLevel = 'low'
    elseif distance > LODDistances.medium then
        newLodLevel = 'medium'
    else
        newLodLevel = 'high'
    end
    
    -- Apply aggressive optimizations if performance is poor
    if aggressive then
        if distance > LODDistances.medium then
            shouldCull = true
        elseif distance > LODDistances.high then
            newLodLevel = 'low'
        end
    end
    
    -- Apply optimizations
    if shouldCull and data.isVisible then
        SetEntityVisible(entity, false, false)
        FreezeEntityPosition(entity, true)
        SetEntityCollision(entity, false, false)
        data.isVisible = false
    elseif not shouldCull and not data.isVisible then
        SetEntityVisible(entity, true, false)
        FreezeEntityPosition(entity, false)
        SetEntityCollision(entity, true, true)
        data.isVisible = true
    end
    
    -- Apply LOD-specific optimizations
    if data.isVisible then
        if newLodLevel == 'low' then
            -- Reduce animation quality, disable facial expressions
            if data.type == 'customer' then
                ClearPedTasks(entity)
                SetBlockingOfNonTemporaryEvents(entity, true)
            end
        elseif newLodLevel == 'medium' then
            -- Reduce update frequency for AI
            if data.type == 'customer' then
                SetPedCanRagdollFromPlayerImpact(entity, false)
            end
        end
    end
    
    data.lodLevel = newLodLevel
end

function OptimizationManager.CleanupUnusedResources()
    -- Memory cleanup
    if PerformanceMetrics.memoryUsage > 512000 then -- 512MB threshold
        collectgarbage("collect")
    end
    
    -- Entity pool management
    for entityType, maxCount in pairs(entityPoolSize) do
        local count = 0
        for entity, data in pairs(managedEntities) do
            if data.type == entityType then
                count = count + 1
            end
        end
        
        if count > maxCount then
            OptimizationManager.RemoveOldestEntities(entityType, count - maxCount)
        end
    end
    
    -- Cleanup orphaned blips
    for entity, data in pairs(managedEntities) do
        if not DoesEntityExist(entity) then
            managedEntities[entity] = nil
        end
    end
end

function OptimizationManager.RemoveOldestEntities(entityType, removeCount)
    local entitiesToRemove = {}
    
    for entity, data in pairs(managedEntities) do
        if data.type == entityType then
            table.insert(entitiesToRemove, {entity = entity, lastSeen = data.lastSeen})
        end
    end
    
    -- Sort by lastSeen (oldest first)
    table.sort(entitiesToRemove, function(a, b)
        return a.lastSeen < b.lastSeen
    end)
    
    -- Remove oldest entities
    for i = 1, math.min(removeCount, #entitiesToRemove) do
        local entity = entitiesToRemove[i].entity
        if DoesEntityExist(entity) then
            DeleteEntity(entity)
        end
        managedEntities[entity] = nil
    end
end

-- Streaming optimization
local StreamingManager = {}

function StreamingManager.RequestModel(modelHash, timeout)
    timeout = timeout or 10000
    local startTime = GetGameTimer()
    
    RequestModel(modelHash)
    
    while not HasModelLoaded(modelHash) do
        if GetGameTimer() - startTime > timeout then
            return false
        end
        Citizen.Wait(1)
    end
    
    return true
end

function StreamingManager.RequestAndCreatePed(modelHash, coords, heading, networkCreate, timeout)
    if not StreamingManager.RequestModel(modelHash, timeout) then
        return nil
    end
    
    local ped = CreatePed(4, modelHash, coords.x, coords.y, coords.z, heading, networkCreate or false, true)
    
    -- Register for optimization
    OptimizationManager.RegisterEntity(ped, 'customer', coords)
    
    -- Unload model to free memory
    SetModelAsNoLongerNeeded(modelHash)
    
    return ped
end

-- Performance-aware customer spawning
local SmartSpawning = {}

function SmartSpawning.ShouldSpawnCustomer()
    -- Check performance metrics
    if PerformanceMetrics.frameTime > 0.025 then -- 25ms threshold
        return false
    end
    
    if PerformanceMetrics.entityCount > 30 then
        return false
    end
    
    -- Check memory usage
    if PerformanceMetrics.memoryUsage > 400000 then -- 400MB threshold
        return false
    end
    
    return true
end

function SmartSpawning.GetOptimalSpawnCount()
    local baseCount = 3
    
    -- Reduce spawn count based on performance
    if PerformanceMetrics.frameTime > 0.020 then
        baseCount = 1
    elseif PerformanceMetrics.frameTime > 0.016 then
        baseCount = 2
    end
    
    return baseCount
end

-- Texture streaming optimization
local TextureManager = {}

function TextureManager.PreloadStoreTextures(storeId)
    local store = Config.Stores[storeId]
    if not store then return end
    
    -- Preload commonly used textures
    local textures = {
        'prop_food_bag01',
        'prop_food_cb_bag01',
        'prop_food_cups',
        'prop_till_01',
        'prop_cs_shopping_bag'
    }
    
    for _, texture in ipairs(textures) do
        RequestStreamedTextureDict(texture, false)
    end
end

function TextureManager.UnloadStoreTextures(storeId)
    -- Unload textures when leaving store area
    local textures = {
        'prop_food_bag01',
        'prop_food_cb_bag01',
        'prop_food_cups',
        'prop_till_01',
        'prop_cs_shopping_bag'
    }
    
    for _, texture in ipairs(textures) do
        SetStreamedTextureDictAsNoLongerNeeded(texture)
    end
end

-- Network optimization
local NetworkOptimizer = {}

function NetworkOptimizer.OptimizeEntityNetworking(entity)
    if not NetworkDoesEntityExistWithNetworkId(entity) then
        return
    end
    
    -- Reduce network updates for distant entities
    local playerCoords = GetEntityCoords(PlayerPedId())
    local entityCoords = GetEntityCoords(entity)
    local distance = #(playerCoords - entityCoords)
    
    if distance > 100.0 then
        SetNetworkIdExistsOnAllMachines(NetworkGetNetworkIdFromEntity(entity), false)
    end
end

-- Audio optimization
local AudioManager = {}

function AudioManager.SetAudioRange(entity, range)
    if DoesEntityExist(entity) then
        SetEntityMaxSpeed(entity, range)
    end
end

function AudioManager.OptimizeAudioForDistance(entity, distance)
    local volume = 1.0
    
    if distance > 20.0 then
        volume = 0.5
    elseif distance > 50.0 then
        volume = 0.2
    elseif distance > 100.0 then
        volume = 0.0
    end
    
    -- Apply volume adjustments (implementation depends on audio system)
end

-- Export functions for use in main script
_G.OptimizationManager = OptimizationManager
_G.StreamingManager = StreamingManager
_G.SmartSpawning = SmartSpawning
_G.TextureManager = TextureManager
_G.NetworkOptimizer = NetworkOptimizer
_G.AudioManager = AudioManager

-- Initialize optimization system
OptimizationManager.Initialize()