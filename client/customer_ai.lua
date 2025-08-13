-- Advanced NPC Customer AI System
local customerAI = {}
local customerBehaviors = {}

-- Customer Behavior States
local CustomerStates = {
    ENTERING = 'entering',
    BROWSING = 'browsing',
    DECIDING = 'deciding',
    WAITING_SERVICE = 'waiting_service',
    BEING_SERVED = 'being_served',
    PURCHASING = 'purchasing',
    LEAVING = 'leaving',
    COMPLAINING = 'complaining'
}

-- Customer Personality Types
local PersonalityTypes = {
    PATIENT = { patience_modifier = 1.5, tip_chance = 0.3, complaint_chance = 0.1 },
    IMPATIENT = { patience_modifier = 0.7, tip_chance = 0.1, complaint_chance = 0.4 },
    GENEROUS = { patience_modifier = 1.2, tip_chance = 0.5, complaint_chance = 0.15 },
    DIFFICULT = { patience_modifier = 0.8, tip_chance = 0.05, complaint_chance = 0.6 },
    NORMAL = { patience_modifier = 1.0, tip_chance = 0.2, complaint_chance = 0.25 }
}

function customerAI.CreateAdvancedCustomer(storeId)
    local store = Config.Stores[storeId]
    if not store then return nil end
    
    local model = Config.NPCCustomers.models[math.random(#Config.NPCCustomers.models)]
    local spawnPoint = customerAI.GetStoreEntrance(store)
    
    RequestModel(GetHashKey(model))
    while not HasModelLoaded(GetHashKey(model)) do
        Wait(1)
    end
    
    local customer = CreatePed(4, GetHashKey(model), spawnPoint.x, spawnPoint.y, spawnPoint.z, 0.0, true, true)
    SetEntityCanBeDamaged(customer, false)
    SetPedCanRagdollFromPlayerImpact(customer, false)
    SetBlockingOfNonTemporaryEvents(customer, true)
    
    local customerId = 'ai_customer_' .. GetGameTimer()
    local personality = customerAI.GetRandomPersonality()
    
    npcCustomers[customerId] = {
        entity = customer,
        state = CustomerStates.ENTERING,
        personality = personality,
        storeId = storeId,
        patience = customerAI.CalculatePatience(personality),
        maxPatience = customerAI.CalculatePatience(personality),
        wantsToBuy = math.random() < 0.85, -- 85% chance to buy
        items = {},
        timeInStore = 0,
        serviceQuality = 0,
        lastStateChange = GetGameTimer(),
        targetLocation = nil,
        browsingTime = 0,
        hasComplained = false
    }
    
    customerAI.StartCustomerBehavior(customerId)
    return customerId
end

function customerAI.GetRandomPersonality()
    local personalities = {'PATIENT', 'IMPATIENT', 'GENEROUS', 'DIFFICULT', 'NORMAL'}
    local weights = {15, 20, 10, 15, 40} -- Weighted distribution
    
    local total = 0
    for _, weight in ipairs(weights) do
        total = total + weight
    end
    
    local random = math.random() * total
    local current = 0
    
    for i, weight in ipairs(weights) do
        current = current + weight
        if random <= current then
            return personalities[i]
        end
    end
    
    return 'NORMAL'
end

function customerAI.CalculatePatience(personality)
    local basePatience = math.random(30, 90) -- Base patience in seconds
    local modifier = PersonalityTypes[personality].patience_modifier
    return math.floor(basePatience * modifier)
end

function customerAI.StartCustomerBehavior(customerId)
    Citizen.CreateThread(function()
        while npcCustomers[customerId] do
            customerAI.UpdateCustomerBehavior(customerId)
            Citizen.Wait(1000) -- Update every second
        end
    end)
end

function customerAI.UpdateCustomerBehavior(customerId)
    local customer = npcCustomers[customerId]
    if not customer or not DoesEntityExist(customer.entity) then
        npcCustomers[customerId] = nil
        return
    end
    
    customer.timeInStore = customer.timeInStore + 1
    customer.patience = customer.patience - 1
    
    -- Handle patience running out
    if customer.patience <= 0 then
        customerAI.HandleImpatientCustomer(customerId)
        return
    end
    
    -- State machine
    if customer.state == CustomerStates.ENTERING then
        customerAI.HandleEntering(customerId)
    elseif customer.state == CustomerStates.BROWSING then
        customerAI.HandleBrowsing(customerId)
    elseif customer.state == CustomerStates.DECIDING then
        customerAI.HandleDeciding(customerId)
    elseif customer.state == CustomerStates.WAITING_SERVICE then
        customerAI.HandleWaitingService(customerId)
    elseif customer.state == CustomerStates.BEING_SERVED then
        customerAI.HandleBeingServed(customerId)
    elseif customer.state == CustomerStates.LEAVING then
        customerAI.HandleLeaving(customerId)
    elseif customer.state == CustomerStates.COMPLAINING then
        customerAI.HandleComplaining(customerId)
    end
end

function customerAI.HandleEntering(customerId)
    local customer = npcCustomers[customerId]
    local store = Config.Stores[customer.storeId]
    
    -- Move to browsing area
    local browsingPoint = customerAI.GetRandomBrowsingPoint(store)
    customer.targetLocation = browsingPoint
    
    TaskGoToCoordAnyMeans(customer.entity, browsingPoint.x, browsingPoint.y, browsingPoint.z, 1.0, 0, 0, 786603, 0xbf800000)
    
    -- Transition to browsing after reaching location
    Citizen.SetTimeout(5000, function()
        if npcCustomers[customerId] then
            customerAI.ChangeState(customerId, CustomerStates.BROWSING)
        end
    end)
end

function customerAI.HandleBrowsing(customerId)
    local customer = npcCustomers[customerId]
    customer.browsingTime = customer.browsingTime + 1
    
    -- Occasionally move to different browsing points
    if customer.browsingTime % 15 == 0 then
        local store = Config.Stores[customer.storeId]
        local newPoint = customerAI.GetRandomBrowsingPoint(store)
        TaskGoToCoordAnyMeans(customer.entity, newPoint.x, newPoint.y, newPoint.z, 1.0, 0, 0, 786603, 0xbf800000)
    end
    
    -- Transition to deciding after enough browsing
    if customer.browsingTime >= math.random(20, 45) then
        customerAI.ChangeState(customerId, CustomerStates.DECIDING)
    end
end

function customerAI.HandleDeciding(customerId)
    local customer = npcCustomers[customerId]
    local store = Config.Stores[customer.storeId]
    
    if customer.wantsToBuy then
        -- Generate items to purchase
        customer.items = customerAI.GenerateShoppingList(store, customer.personality)
        
        if #customer.items > 0 then
            -- Move to cashier area
            local cashierPoint = store.workStations.cashier or store.coords
            TaskGoToCoordAnyMeans(customer.entity, cashierPoint.x, cashierPoint.y, cashierPoint.z, 1.0, 0, 0, 786603, 0xbf800000)
            customerAI.ChangeState(customerId, CustomerStates.WAITING_SERVICE)
        else
            customerAI.ChangeState(customerId, CustomerStates.LEAVING)
        end
    else
        -- Customer decided not to buy
        customerAI.ChangeState(customerId, CustomerStates.LEAVING)
    end
end

function customerAI.HandleWaitingService(customerId)
    local customer = npcCustomers[customerId]
    
    -- Look around impatiently
    if customer.patience < customer.maxPatience * 0.3 then
        -- Customer is getting impatient
        if math.random() < 0.1 then -- 10% chance per second when very impatient
            customerAI.MakeCustomerImpatient(customerId)
        end
    end
    
    -- Check if being served by nearby employee
    local nearbyEmployees = customerAI.GetNearbyEmployees(customer.entity)
    if #nearbyEmployees > 0 then
        customerAI.ChangeState(customerId, CustomerStates.BEING_SERVED)
    end
end

function customerAI.HandleBeingServed(customerId)
    local customer = npcCustomers[customerId]
    
    -- This state is managed by the player interaction system
    -- Customer waits patiently while being served
    customer.patience = customer.patience + 2 -- Regain some patience while being served
end

function customerAI.HandleLeaving(customerId)
    local customer = npcCustomers[customerId]
    local store = Config.Stores[customer.storeId]
    
    -- Move to exit
    local exitPoint = customerAI.GetStoreExit(store)
    TaskGoToCoordAnyMeans(customer.entity, exitPoint.x, exitPoint.y, exitPoint.z, 1.0, 0, 0, 786603, 0xbf800000)
    
    -- Remove customer after leaving
    Citizen.SetTimeout(10000, function()
        if npcCustomers[customerId] then
            DeleteEntity(customer.entity)
            npcCustomers[customerId] = nil
        end
    end)
end

function customerAI.HandleComplaining(customerId)
    local customer = npcCustomers[customerId]
    
    -- Customer stands and complains
    TaskStartScenarioInPlace(customer.entity, "WORLD_HUMAN_STAND_MOBILE", 0, true)
    
    -- Show complaint text
    customerAI.ShowCustomerSpeech(customerId, "This service is terrible!")
    
    -- Transition to leaving after complaining
    Citizen.SetTimeout(8000, function()
        if npcCustomers[customerId] then
            customerAI.ChangeState(customerId, CustomerStates.LEAVING)
        end
    end)
end

function customerAI.HandleImpatientCustomer(customerId)
    local customer = npcCustomers[customerId]
    local personality = PersonalityTypes[customer.personality]
    
    if not customer.hasComplained and math.random() < personality.complaint_chance then
        customer.hasComplained = true
        customerAI.ChangeState(customerId, CustomerStates.COMPLAINING)
        
        -- Negative impact on store
        TriggerServerEvent('retail:customerComplaint', customer.storeId, customerId)
    else
        customerAI.ChangeState(customerId, CustomerStates.LEAVING)
    end
end

function customerAI.ChangeState(customerId, newState)
    local customer = npcCustomers[customerId]
    if customer then
        customer.state = newState
        customer.lastStateChange = GetGameTimer()
    end
end

function customerAI.GenerateShoppingList(store, personality)
    local items = {}
    local personalityData = PersonalityTypes[personality]
    
    -- Determine number of items based on personality
    local maxItems = 1
    if personality == 'GENEROUS' then
        maxItems = math.random(2, 4)
    elseif personality == 'PATIENT' then
        maxItems = math.random(1, 3)
    else
        maxItems = math.random(1, 2)
    end
    
    for i = 1, maxItems do
        if #store.products > 0 then
            local product = store.products[math.random(#store.products)]
            local existingItem = nil
            
            -- Check if item already exists
            for _, item in ipairs(items) do
                if item.name == product.name then
                    existingItem = item
                    break
                end
            end
            
            if existingItem then
                existingItem.quantity = existingItem.quantity + 1
            else
                table.insert(items, {
                    name = product.name,
                    price = product.price,
                    quantity = 1
                })
            end
        end
    end
    
    return items
end

function customerAI.GetStoreEntrance(store)
    -- Get a point slightly outside the store
    local offset = vector3(math.random(-3, 3), math.random(-3, 3), 0)
    return store.coords + offset
end

function customerAI.GetStoreExit(store)
    -- Same as entrance for simplicity
    return customerAI.GetStoreEntrance(store)
end

function customerAI.GetRandomBrowsingPoint(store)
    local baseCoords = store.coords
    local offset = vector3(
        math.random(-8, 8),
        math.random(-8, 8),
        0
    )
    return baseCoords + offset
end

function customerAI.GetNearbyEmployees(customerEntity)
    local employees = {}
    local customerCoords = GetEntityCoords(customerEntity)
    
    -- Check for nearby players who are on duty
    for _, playerId in ipairs(GetActivePlayers()) do
        local player = GetPlayerPed(playerId)
        local playerCoords = GetEntityCoords(player)
        local distance = #(customerCoords - playerCoords)
        
        if distance < 5.0 then
            table.insert(employees, playerId)
        end
    end
    
    return employees
end

function customerAI.MakeCustomerImpatient(customerId)
    local customer = npcCustomers[customerId]
    
    -- Play impatient animation
    TaskStartScenarioInPlace(customer.entity, "WORLD_HUMAN_STAND_IMPATIENT", 0, true)
    
    -- Show impatient speech
    customerAI.ShowCustomerSpeech(customerId, "How long do I have to wait?")
end

function customerAI.ShowCustomerSpeech(customerId, text)
    local customer = npcCustomers[customerId]
    if not customer then return end
    
    local coords = GetEntityCoords(customer.entity)
    
    -- Create floating text above customer
    Citizen.CreateThread(function()
        local startTime = GetGameTimer()
        while GetGameTimer() - startTime < 3000 do -- Show for 3 seconds
            DrawText3D(coords.x, coords.y, coords.z + 1.0, text)
            Citizen.Wait(0)
        end
    end)
end

function customerAI.ProcessCustomerPurchase(customerId, serviceQuality)
    local customer = npcCustomers[customerId]
    if not customer then return false end
    
    local personality = PersonalityTypes[customer.personality]
    local total = 0
    
    for _, item in ipairs(customer.items) do
        total = total + (item.price * item.quantity)
    end
    
    -- Calculate tip based on service quality and personality
    local tip = 0
    if serviceQuality > 0.7 and math.random() < personality.tip_chance then
        tip = math.floor(total * math.random(0.1, 0.25))
    end
    
    -- Customer satisfaction
    local satisfaction = serviceQuality
    if customer.patience < customer.maxPatience * 0.5 then
        satisfaction = satisfaction * 0.7
    end
    
    customerAI.ChangeState(customerId, CustomerStates.LEAVING)
    
    return {
        total = total,
        tip = tip,
        satisfaction = satisfaction,
        items = customer.items
    }
end

-- Export for use in main client
_G.CustomerAI = customerAI