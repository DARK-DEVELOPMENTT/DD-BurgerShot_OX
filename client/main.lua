local onDuty = false
local npc = nil
local currentDelivery = nil
local deliveryVehicle = nil
local hasVehicleKeys = false

CreateThread(function()
    local blip = AddBlipForCoord(Config.Location.x, Config.Location.y, Config.Location.z)
    SetBlipSprite(blip, 106)  -- 'B' sprite
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.7)
    SetBlipColour(blip, 1)    -- Red color
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString("BurgerShot")
    EndTextCommandSetBlipName(blip)
end)

if Config.Debug then
    RegisterCommand('bsduty', function()
        onDuty = not onDuty
        lib.notify({
            title = 'BurgerShot',
            description = onDuty and 'You are now on duty!' or 'You are now off duty!',
            type = onDuty and 'success' or 'error'
        })
    end)
end

exports('useInvoice', function(data, slot)
    if slot.metadata then
        local totalPrice = 0
        local itemsList = {}
        
        for line in slot.metadata.items:gmatch("[^\r\n]+") do
            local itemName, amount = line:match("(.+) x(%d+)")
            if itemName and amount then
                table.insert(itemsList, {
                    title = itemName,
                    description = 'Quantity: ' .. amount,
                })
                local basePrice = 10 -- Base price for any item
                totalPrice = totalPrice + (basePrice * tonumber(amount))
            end
        end

        table.insert(itemsList, {
            title = '───────────────',
            disabled = true,
        })
        table.insert(itemsList, {
            title = 'Total Amount',
            description = '$' .. totalPrice,
            disabled = true,
        })
        
        lib.registerContext({
            id = 'invoice_view',
            title = 'BurgerShot Invoice',
            options = {
                {
                    title = 'Customer Information',
                    description = 'Customer: ' .. slot.metadata.customer,
                    disabled = true,
                },
                {
                    title = '───────────────',
                    disabled = true,
                },
                {
                    title = 'Order Details',
                    description = 'Items ordered:',
                    disabled = true,
                },
                table.unpack(itemsList),
            },
        })
        
        lib.showContext('invoice_view')
        return true
    end
    return false
end)

local function GenerateRandomOrder()
    local orderTypes = {
        burgers = {'classic_burger', 'chicken_burger', 'veggie_burger'},
        drinks = {'cola', 'sprite', 'fanta'},
        fries = {'regular_fries', 'cheese_fries', 'loaded_fries'}
    }
    local order = {
        items = {},
        total = 0
    }
    local numBurgers = math.random(1, 2)
    for i = 1, numBurgers do
        table.insert(order.items, orderTypes.burgers[math.random(#orderTypes.burgers)])
    end
    local numDrinks = math.random(1, 2)
    for i = 1, numDrinks do
        table.insert(order.items, orderTypes.drinks[math.random(#orderTypes.drinks)])
    end
    if math.random() > 0.3 then
        table.insert(order.items, orderTypes.fries[math.random(#orderTypes.fries)])
    end
    return order
end

-- Function to max out vehicle performance
local function MaxOutVehicle(vehicle)
    -- Set modification kit
    SetVehicleModKit(vehicle, 0)
    -- Body Kits and Visual Mods
    SetVehicleMod(vehicle, 0, 2, false)  -- Spoiler
    SetVehicleMod(vehicle, 1, 2, false)  -- Front Bumper
    SetVehicleMod(vehicle, 2, 2, false)  -- Rear Bumper
    SetVehicleMod(vehicle, 3, 2, false)  -- Side Skirt
    SetVehicleMod(vehicle, 4, 2, false)  -- Exhaust
    SetVehicleMod(vehicle, 5, 2, false)  -- Frame/Roll Cage
    SetVehicleMod(vehicle, 6, 2, false)  -- Grille
    SetVehicleMod(vehicle, 7, 2, false)  -- Hood
    SetVehicleMod(vehicle, 8, 2, false)  -- Fender
    SetVehicleMod(vehicle, 9, 2, false)  -- Right Fender
    SetVehicleMod(vehicle, 10, 2, false) -- Roof
    -- Extra Visual Mods
    SetVehicleMod(vehicle, 25, 2, false) -- Plate Holder
    SetVehicleMod(vehicle, 26, 2, false) -- Vanity Plates
    SetVehicleMod(vehicle, 27, 2, false) -- Trim Design
    SetVehicleMod(vehicle, 28, 2, false) -- Ornaments
    SetVehicleMod(vehicle, 29, 2, false) -- Dashboard
    SetVehicleMod(vehicle, 30, 2, false) -- Dial Design
    SetVehicleMod(vehicle, 31, 2, false) -- Door Speakers
    SetVehicleMod(vehicle, 32, 2, false) -- Seats
    SetVehicleMod(vehicle, 33, 2, false) -- Steering Wheel
    SetVehicleMod(vehicle, 34, 2, false) -- Shift Lever
    SetVehicleMod(vehicle, 35, 2, false) -- Plaques
    SetVehicleMod(vehicle, 36, 2, false) -- Speakers
    SetVehicleMod(vehicle, 37, 2, false) -- Trunk
    SetVehicleMod(vehicle, 38, 2, false) -- Hydraulics
    SetVehicleMod(vehicle, 39, 2, false) -- Engine Block
    SetVehicleMod(vehicle, 40, 2, false) -- Air Filter
    SetVehicleMod(vehicle, 41, 2, false) -- Struts
    SetVehicleMod(vehicle, 42, 2, false) -- Arch Cover
    SetVehicleMod(vehicle, 43, 2, false) -- Aerials
    SetVehicleMod(vehicle, 44, 2, false) -- Trim
    SetVehicleMod(vehicle, 45, 2, false) -- Tank
    SetVehicleMod(vehicle, 46, 2, false) -- Windows
    SetVehicleMod(vehicle, 48, 2, false) -- Livery
    -- Wheels & Tires
    SetVehicleWheelType(vehicle, 0)
    SetVehicleMod(vehicle, 23, 10, false) -- Front Wheels
    SetVehicleMod(vehicle, 24, 10, false) -- Back Wheels
    SetVehicleTyresCanBurst(vehicle, false) -- Bulletproof tires
    -- Colors and Paint
    SetVehicleColours(vehicle, 12, 12) -- Metallic Black
    SetVehicleExtraColours(vehicle, 0, 0)
    SetVehicleModColor_1(vehicle, 3, 0, 0) -- Primary Color (Matte)
    SetVehicleModColor_2(vehicle, 3, 0, 0) -- Secondary Color (Matte)
end


local function GiveVehicleKeys(vehicle)
    if not vehicle or not DoesEntityExist(vehicle) then return end
    SetVehicleDoorsLocked(vehicle, 1)
    hasVehicleKeys = true
    lib.notify({
        title = 'Vehicle Keys',
        description = 'You received the keys for your delivery vehicle',
        type = 'success',
        duration = 3500
    })
end


CreateThread(function()
    while true do
        Wait(1000)
        if currentDelivery and currentDelivery.vehicle and DoesEntityExist(currentDelivery.vehicle) then
            if not hasVehicleKeys then
                GiveVehicleKeys(currentDelivery.vehicle)
            end
            local veh = currentDelivery.vehicle
            if DoesEntityExist(veh) then
                if GetVehicleDoorLockStatus(veh) ~= 1 then
                    SetVehicleDoorsLocked(veh, 1)
                end
                local playerPed = PlayerPedId()
                local playerCoords = GetEntityCoords(playerPed)
                local vehicleCoords = GetEntityCoords(veh)
                local distance = #(playerCoords - vehicleCoords)
                if distance < 10.0 and not hasVehicleKeys then
                    GiveVehicleKeys(veh)
                end
            end
        end
    end
end)


local function CreateDeliveryTarget(coords)
    exports.ox_target:removeZone('deliver_food')   
    exports.ox_target:addBoxZone({
        coords = vector3(coords.x, coords.y, coords.z),
        size = vector3(1.5, 1.5, 2.0),
        rotation = coords.w,
        debug = false,
        options = {
            {
                name = 'deliver_food',
                icon = 'fas fa-box',
                label = 'Deliver Order',
                distance = 2.0,
                onSelect = function()
                    local hasAllItems = true
                    local missingItem = ''
                    
                    for _, item in ipairs(currentDelivery.order.items) do
                        local count = exports.ox_inventory:Search('count', item)
                        if count < 1 then
                            hasAllItems = false
                            missingItem = item
                            break
                        end
                    end
                    
                    if not hasAllItems then
                        lib.notify({
                            title = 'BurgerShot Delivery',
                            description = 'You\'re missing ' .. missingItem .. ' for the delivery!',
                            type = 'error'
                        })
                        return
                    end
                    
                    if lib.progressBar({
                        duration = 5000,
                        label = 'Delivering Order...',
                        useWhileDead = false,
                        canCancel = true,
                        disable = {
                            car = true,
                            move = true,
                            combat = true
                        },
                        anim = {
                            dict = 'mp_common',
                            clip = 'givetake1_a',
                            flag = 49
                        },
                    }) then
                        TriggerServerEvent('burgershot:markDeliveryComplete', currentDelivery)
                        
                        exports.ox_target:removeZone('deliver_food')
                        
                        if currentDelivery.blip then
                            RemoveBlip(currentDelivery.blip)
                            currentDelivery.blip = nil
                        end
                        
                        lib.notify({
                            title = 'BurgerShot Delivery',
                            description = 'Order delivered! Return to BurgerShot to collect your payment.',
                            type = 'success',
                            duration = 5000
                        })
                        
                        currentDelivery.readyForPayment = true
                    end
                end
            }
        }
    })
end

local function StartDelivery(type)
    if currentDelivery then
        lib.notify({
            title = 'BurgerShot Delivery',
            description = 'You already have an active delivery!',
            type = 'error'
        })
        return
    end
    
    local locations = Config.DeliveryLocations[type]
    local location = locations[math.random(#locations)]
    local order = GenerateRandomOrder()
    
    lib.requestModel(Config.DeliveryVehicle)
    deliveryVehicle = CreateVehicle(GetHashKey(Config.DeliveryVehicle), 
        Config.VehicleSpawn.x, Config.VehicleSpawn.y, Config.VehicleSpawn.z, 
        Config.VehicleSpawn.w, true, false)
    SetEntityAsMissionEntity(deliveryVehicle, true, true)
    
    MaxOutVehicle(deliveryVehicle)
    
    SetVehicleDoorsLocked(deliveryVehicle, 1)
    SetVehicleEngineOn(deliveryVehicle, true, true, false)
    SetVehicleDirtLevel(deliveryVehicle, 0.0)
    
    local plate = GetVehicleNumberPlateText(deliveryVehicle)
    SetVehicleHasBeenOwnedByPlayer(deliveryVehicle, true)
    local netId = NetworkGetNetworkIdFromEntity(deliveryVehicle)
    SetNetworkIdCanMigrate(netId, true)
    
    Wait(500)
    GiveVehicleKeys(deliveryVehicle)
    
    CreateDeliveryTarget(location)
    
    SetNewWaypoint(location.x, location.y)
    
    local blip = AddBlipForCoord(location.x, location.y, location.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 2)
    SetBlipRoute(blip, true)
    
    currentDelivery = {
        type = type,
        location = location,
        order = order,
        vehicle = deliveryVehicle,
        plate = plate,
        netId = netId,
        blip = blip
    }
    
    lib.registerContext({
        id = 'delivery_order',
        title = 'Delivery Order Details',
        options = {
            {
                title = 'Order Items',
                description = table.concat(order.items, ', '),
                disabled = true
            },
            {
                title = 'Delivery Location',
                description = 'Check your GPS for the delivery location',
                disabled = true
            }
        }
    })
    lib.showContext('delivery_order')
    
    lib.notify({
        title = 'BurgerShot Delivery',
        description = 'Your delivery vehicle is waiting outside. Keys have been given to you.',
        type = 'success',
        duration = 5000
    })
end

local function CompleteDelivery()
    if not currentDelivery then
        lib.notify({
            title = 'BurgerShot Delivery',
            description = 'You don\'t have any active deliveries!',
            type = 'error'
        })
        return
    end
    if not currentDelivery.readyForPayment then
        lib.notify({
            title = 'BurgerShot Delivery',
            description = 'You need to deliver the order first!',
            type = 'error'
        })
        return
    end
    TriggerServerEvent('burgershot:completeDelivery', currentDelivery)
end


local function HasJob()
    return true
end

CreateThread(function()
    lib.requestModel(Config.NPCModel)
    npc = CreatePed(0, joaat(Config.NPCModel), Config.NPCLocation.x, Config.NPCLocation.y, Config.NPCLocation.z, Config.NPCLocation.w, false, false)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    
    exports.ox_target:addLocalEntity({npc}, {
        {
            name = 'burgershot_delivery_npc',
            icon = 'fas fa-motorcycle',
            label = 'Talk to Delivery Manager',
            distance = 2.5,
            onSelect = function()
                if currentDelivery then
                    lib.registerContext({
                        id = 'active_delivery',
                        title = 'Current Delivery Details',
                        menu = 'delivery_menu',
                        options = {
                            {
                                title = '📝 Order Items',
                                description = table.concat(currentDelivery.order.items, '\n'),
                                disabled = true
                            },
                            {
                                title = '📍 Delivery Location',
                                description = 'Check your GPS for the delivery location',
                                onSelect = function()
                                    SetNewWaypoint(currentDelivery.location.x, currentDelivery.location.y)
                                    lib.notify({
                                        title = 'BurgerShot Delivery',
                                        description = 'GPS updated with delivery location',
                                        type = 'info'
                                    })
                                end
                            },
                            {
                                title = '❌ Cancel Delivery',
                                description = 'Cancel current delivery (no payment)',
                                onSelect = function()
                                    if DoesEntityExist(currentDelivery.vehicle) then
                                        DeleteEntity(currentDelivery.vehicle)
                                    end
                                    currentDelivery = nil
                                    lib.notify({
                                        title = 'BurgerShot Delivery',
                                        description = 'Delivery cancelled',
                                        type = 'error'
                                    })
                                end
                            }
                        }
                    })
                    lib.showContext('active_delivery')
                    return
                end

                lib.registerContext({
                    id = 'delivery_menu',
                    title = 'BurgerShot Delivery',
                    options = {
                        {
                            title = 'Start Delivery',
                            description = 'Choose delivery type',
                            menu = 'delivery_types'
                        },
                        {
                            title = 'Collect Payment',
                            description = 'Collect payment for completed delivery',
                            onSelect = function()
                                CompleteDelivery()
                            end
                        }
                    }
                })
                
                lib.registerContext({
                    id = 'delivery_types',
                    title = 'Choose Delivery Type',
                    menu = 'delivery_menu',
                    options = {
                        {
                            title = 'Small Distance',
                            description = 'Short distance delivery - $' .. Config.DeliveryPayments.small,
                            onSelect = function()
                                StartDelivery('small')
                            end
                        },
                        {
                            title = 'Medium Distance',
                            description = 'Medium distance delivery - $' .. Config.DeliveryPayments.medium,
                            onSelect = function()
                                StartDelivery('medium')
                            end
                        },
                        {
                            title = 'Large Distance',
                            description = 'Long distance delivery - $' .. Config.DeliveryPayments.large,
                            onSelect = function()
                                StartDelivery('large')
                            end
                        }
                    }
                })
                
                lib.showContext('delivery_menu')
            end
        }
    })
end)

CreateThread(function()
    exports.ox_target:addBoxZone({
        coords = Config.Targets.duty,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_duty',
                icon = 'fas fa-clock',
                label = 'Toggle Duty',
                onSelect = function()
                    onDuty = not onDuty
                    lib.notify({
                        title = 'BurgerShot',
                        description = onDuty and 'You are now on duty!' or 'You are now off duty!',
                        type = onDuty and 'success' or 'error'
                    })
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.fridge,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_fridge',
                icon = 'fas fa-refrigerator',
                label = 'Open Fridge',
                onSelect = function()
                    if not onDuty then return lib.notify({type = 'error', description = 'You must be on duty!'}) end
                    exports.ox_inventory:openInventory('stash', 'burgershot_fridge')
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.chopping,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_chopping',
                icon = 'fas fa-knife',
                label = 'Start Chopping',
                onSelect = function()
                    if not onDuty then return lib.notify({type = 'error', description = 'You must be on duty!'}) end
                    OpenChoppingMenu()
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.cooking,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_cooking',
                icon = 'fas fa-burger',
                label = 'Start Cooking',
                onSelect = function()
                    if not onDuty then return lib.notify({type = 'error', description = 'You must be on duty!'}) end
                    OpenCookingMenu()
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.fries,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_fries',
                icon = 'fas fa-french-fries',
                label = 'Make Fries',
                onSelect = function()
                    if not onDuty then return lib.notify({type = 'error', description = 'You must be on duty!'}) end
                    OpenFriesMenu()
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.drinks,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_drinks',
                icon = 'fas fa-glass',
                label = 'Make Drinks',
                onSelect = function()
                    if not onDuty then return lib.notify({type = 'error', description = 'You must be on duty!'}) end
                    OpenDrinksMenu()
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.icecream,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_icecream',
                icon = 'fas fa-ice-cream',
                label = 'Make Ice Cream',
                onSelect = function()
                    if not onDuty then return lib.notify({type = 'error', description = 'You must be on duty!'}) end
                    OpenIceCreamMenu()
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.order,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_order',
                icon = 'fas fa-clipboard',
                label = 'Place Order',
                onSelect = function()
                    OpenOrderMenu()
                end
            }
        }
    })

    exports.ox_target:addBoxZone({
        coords = Config.Targets.ingredients,
        size = vec3(1, 1, 2),
        rotation = 45,
        debug = false,
        options = {
            {
                name = 'burgershot_ingredients',
                icon = 'fas fa-shopping-basket',
                label = 'Buy Ingredients',
                onSelect = function()
                    if not onDuty then return lib.notify({type = 'error', description = 'You must be on duty!'}) end
                    OpenIngredientsMenu()
                end
            }
        }
    })
end)

-- Menu Functions
function OpenChoppingMenu()
    local options = {}
    
    local itemUses = {
        potato = {
            label = "Potato",
            uses = "Used in: Regular Fries, Cheese Fries, Loaded Fries"
        },
        tomato = {
            label = "Tomato",
            uses = "Used in: Classic Burger, Veggie Burger"
        },
        lettuce = {
            label = "Lettuce",
            uses = "Used in: All Burgers"
        },
        cucumber = {
            label = "Cucumber",
            uses = "Used in: Veggie Burger"
        }
    }
    
    for _, item in ipairs(Config.ChoppableItems) do
        local itemInfo = itemUses[item.name]
        options[#options + 1] = {
            title = ('Chop %s'):format(item.label),
            description = itemInfo and itemInfo.uses or '',
            onSelect = function()
                local input = lib.inputDialog(('Chop %s'):format(item.label), {
                    { type = 'number', label = 'Amount', description = 'How many would you like to chop? (1-20)', default = 1, min = 1, max = 20 }
                })
                if not input then return end
                StartChopping(item, input[1])
            end
        }
    end
    
    lib.registerContext({
        id = 'chopping_menu',
        title = 'Chopping Station',
        options = options
    })
    
    lib.showContext('chopping_menu')
end

function OpenDrinksMenu()
    local options = {}
    
    for _, drink in ipairs(Config.Drinks) do
        local ingredientsList = ''
        for i, ingredient in ipairs(drink.ingredients) do
            ingredientsList = ingredientsList .. ingredient:gsub("^%l", string.upper)
            if i < #drink.ingredients then
                ingredientsList = ingredientsList .. ', '
            end
        end
        
        options[#options + 1] = {
            title = drink.label,
            description = 'Required Ingredients:\n' .. ingredientsList,
            onSelect = function()
                local input = lib.inputDialog(('Make %s'):format(drink.label), {
                    { type = 'number', label = 'Amount', description = 'How many would you like to make? (1-20)', default = 1, min = 1, max = 20 }
                })
                if not input then return end
                StartMakingDrink(drink, input[1])
            end
        }
    end
    
    lib.registerContext({
        id = 'drinks_menu',
        title = 'Drinks Station',
        options = options
    })
    
    lib.showContext('drinks_menu')
end

function OpenFriesMenu()
    local options = {}
    
    for _, fries in ipairs(Config.Fries) do
        local ingredientsList = ''
        for i, ingredient in ipairs(fries.ingredients) do
            ingredientsList = ingredientsList .. ingredient:gsub("^%l", string.upper)
            if i < #fries.ingredients then
                ingredientsList = ingredientsList .. ', '
            end
        end
        
        options[#options + 1] = {
            title = fries.label,
            description = 'Required Ingredients:\n' .. ingredientsList,
            onSelect = function()
                local input = lib.inputDialog(('Make %s'):format(fries.label), {
                    { type = 'number', label = 'Amount', description = 'How many would you like to make? (1-20)', default = 1, min = 1, max = 20 }
                })
                if not input then return end
                StartMakingFries(fries, input[1])
            end
        }
    end
    
    lib.registerContext({
        id = 'fries_menu',
        title = 'Fries Station',
        options = options
    })
    
    lib.showContext('fries_menu')
end

function OpenOrderMenu()
    local options = {
        { type = 'select', label = 'Burger', options = {} },
        { type = 'select', label = 'Drink', options = {} },
        { type = 'select', label = 'Fries', options = {} },
        { type = 'select', label = 'Coffee', options = {} },
        { type = 'select', label = 'Ice Cream', options = {} },
        { type = 'number', label = 'Amount', default = 1, min = 1, max = 20 }
    }

    for _, burger in ipairs(Config.Burgers) do
        local ingredientsList = table.concat(burger.ingredients, ', '):gsub("^%l", string.upper)
        options[1].options[#options[1].options + 1] = { 
            label = burger.label, 
            value = burger.name,
            description = 'Ingredients: ' .. ingredientsList
        }
    end
    for _, drink in ipairs(Config.Drinks) do
        local ingredientsList = table.concat(drink.ingredients, ', '):gsub("^%l", string.upper)
        options[2].options[#options[2].options + 1] = { 
            label = drink.label, 
            value = drink.name,
            description = 'Ingredients: ' .. ingredientsList
        }
    end
    for _, fries in ipairs(Config.Fries) do
        local ingredientsList = table.concat(fries.ingredients, ', '):gsub("^%l", string.upper)
        options[3].options[#options[3].options + 1] = { 
            label = fries.label, 
            value = fries.name,
            description = 'Ingredients: ' .. ingredientsList
        }
    end
    for _, coffee in ipairs(Config.Coffee) do
        local ingredientsList = table.concat(coffee.ingredients, ', '):gsub("^%l", string.upper)
        options[4].options[#options[4].options + 1] = { 
            label = coffee.label, 
            value = coffee.name,
            description = 'Ingredients: ' .. ingredientsList
        }
    end
    for _, icecream in ipairs(Config.IceCream) do
        local ingredientsList = table.concat(icecream.ingredients, ', '):gsub("^%l", string.upper)
        options[5].options[#options[5].options + 1] = { 
            label = icecream.label, 
            value = icecream.name,
            description = 'Ingredients: ' .. ingredientsList
        }
    end

    local input = lib.inputDialog('Place Order', options)
    if not input then return end

    local order = {
        burger = input[1],
        drink = input[2],
        fries = input[3],
        coffee = input[4],
        icecream = input[5],
        amount = input[6]
    }

    TriggerServerEvent('burgershot:createOrder', order)
end

function OpenIngredientsMenu()
    local options = {}
    
    local categories = {
        ['Burger Ingredients'] = {
            {name = 'bun', label = 'Burger Bun', price = 2},
            {name = 'patty', label = 'Beef Patty', price = 5},
            {name = 'chicken_patty', label = 'Chicken Patty', price = 4},
            {name = 'veggie_patty', label = 'Veggie Patty', price = 3},
            {name = 'lettuce', label = 'Lettuce', price = 1},
            {name = 'tomato', label = 'Tomato', price = 1},
            {name = 'cheese', label = 'Cheese', price = 2},
            {name = 'mayo', label = 'Mayonnaise', price = 1},
            {name = 'cucumber', label = 'Cucumber', price = 1}
        },
        ['Drink Ingredients'] = {
            {name = 'cup', label = 'Cup', price = 1},
            {name = 'cola_syrup', label = 'Cola Syrup', price = 3},
            {name = 'sprite_syrup', label = 'Sprite Syrup', price = 3},
            {name = 'fanta_syrup', label = 'Fanta Syrup', price = 3}
        },
        ['Fries Ingredients'] = {
            {name = 'potato', label = 'Potato', price = 2},
            {name = 'salt', label = 'Salt', price = 1},
            {name = 'meat', label = 'Meat', price = 3}
        },
        ['Coffee Ingredients'] = {
            {name = 'coffee_beans', label = 'Coffee Beans', price = 3},
            {name = 'milk', label = 'Milk', price = 2},
            {name = 'cream', label = 'Cream', price = 2}
        },
        ['Ice Cream Ingredients'] = {
            {name = 'icecream_cup', label = 'Ice Cream Cup', price = 1},
            {name = 'vanilla_mix', label = 'Vanilla Mix', price = 3},
            {name = 'chocolate_mix', label = 'Chocolate Mix', price = 3},
            {name = 'strawberry_mix', label = 'Strawberry Mix', price = 3},
            {name = 'mint_mix', label = 'Mint Mix', price = 3},
            {name = 'cookie_crumbs', label = 'Cookie Crumbs', price = 2}
        }
    }
    
    for category, items in pairs(categories) do
        local categoryOptions = {
            title = category,
            menu = 'ingredients_menu',
            options = {}
        }
        
        for _, item in ipairs(items) do
            table.insert(categoryOptions.options, {
                title = item.label,
                description = ('Price: $%d'):format(item.price),
                onSelect = function()
                    local input = lib.inputDialog(('Buy %s'):format(item.label), {
                        { type = 'number', label = 'Amount', description = 'How many would you like to buy? (1-50)', default = 1, min = 1, max = 50 }
                    })
                    if not input then return end
                    TriggerServerEvent('burgershot:buyIngredient', item.name, input[1], item.price)
                end
            })
        end
        
        local menuId = category:lower():gsub(' ', '_')
        lib.registerContext({
            id = menuId,
            title = category,
            menu = 'ingredients_menu',
            options = categoryOptions.options
        })
        
        table.insert(options, {
            title = category,
            description = 'Browse ' .. category,
            menu = menuId
        })
    end
    
    lib.registerContext({
        id = 'ingredients_menu',
        title = 'Ingredients Shop',
        options = options
    })
    
    lib.showContext('ingredients_menu')
end

function StartChopping(item, amount)
    if lib.progressBar({
        duration = item.time * amount,
        label = ('Chopping %s'):format(item.label),
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'anim@amb@business@coc@coc_unpack_cut@',
            clip = 'fullcut_cycle_v6_cokecutter'
        },
    }) then
        TriggerServerEvent('burgershot:finishChopping', item.name, item.output, amount)
    end
end

function StartMakingDrink(drink, amount)
    if lib.progressBar({
        duration = Config.ProgressBar.drinks.duration * amount,
        label = Config.ProgressBar.drinks.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'mp_ped_interaction',
            clip = 'handshake_guy_a'
        },
    }) then
        TriggerServerEvent('burgershot:finishDrink', drink.name, amount)
    end
end

function StartMakingFries(fries, amount)
    if lib.progressBar({
        duration = Config.ProgressBar.fries.duration * amount,
        label = Config.ProgressBar.fries.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'mp_ped_interaction',
            clip = 'handshake_guy_a'
        },
    }) then
        TriggerServerEvent('burgershot:finishFries', fries.name, amount)
    end
end

function OpenCookingMenu()
    local options = {}
    
    for _, burger in ipairs(Config.Burgers) do
        -- Create ingredients list text
        local ingredientsList = ''
        for i, ingredient in ipairs(burger.ingredients) do
            ingredientsList = ingredientsList .. ingredient:gsub("^%l", string.upper)
            if i < #burger.ingredients then
                ingredientsList = ingredientsList .. ', '
            end
        end
        
        options[#options + 1] = {
            title = burger.label,
            description = 'Required Ingredients:\n' .. ingredientsList,
            onSelect = function()
                local input = lib.inputDialog(('Cook %s'):format(burger.label), {
                    { type = 'number', label = 'Amount', description = 'How many would you like to cook? (1-20)', default = 1, min = 1, max = 20 }
                })
                if not input then return end
                StartCookingBurger(burger, input[1])
            end
        }
    end
    
    lib.registerContext({
        id = 'cooking_menu',
        title = 'Cooking Station',
        options = options
    })
    
    lib.showContext('cooking_menu')
end

function StartCookingBurger(burger, amount)
    -- Check ingredients first
    local hasIngredients = true
    local missingIngredient = ''
    
    for _, ingredient in ipairs(burger.ingredients) do
        local count = exports.ox_inventory:GetItemCount(ingredient)
        if count < amount then
            hasIngredients = false
            missingIngredient = ingredient
            break
        end
    end
    
    if not hasIngredients then
        return lib.notify({
            title = 'BurgerShot',
            description = 'Not enough ' .. missingIngredient,
            type = 'error'
        })
    end
    
    if lib.progressBar({
        duration = Config.ProgressBar.cooking.duration * amount,
        label = Config.ProgressBar.cooking.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'amb@prop_human_bbq@male@idle_a',
            clip = 'idle_b'
        },
    }) then
        TriggerServerEvent('burgershot:finishCooking', burger.name, amount)
    end
end

RegisterNetEvent('burgershot:openInvoice', function(data)
    lib.registerContext({
        id = 'invoice_details',
        title = 'Order Invoice',
        options = {
            {
                title = 'Order Details',
                description = ('Customer: %s\nItems:\n%s\nTotal Amount: %d'):format(
                    data.customer,
                    data.items,
                    data.amount
                ),
            }
        }
    })
    
    lib.showContext('invoice_details')
end)

RegisterNetEvent('burgershot:showInvoice', function(invoiceData)
    local totalPrice = 0
    local itemsList = {}
    
    for line in invoiceData.items:gmatch("[^\r\n]+") do
        local itemName, amount = line:match("(.+) x(%d+)")
        if itemName and amount then
            table.insert(itemsList, {
                title = itemName,
                description = 'Quantity: ' .. amount,
            })
            
            local basePrice = 10 -- Base price for any item
            totalPrice = totalPrice + (basePrice * tonumber(amount))
        end
    end
    
    table.insert(itemsList, {
        title = '───────────────',
        disabled = true,
    })
    table.insert(itemsList, {
        title = 'Total Amount',
        description = '$' .. totalPrice,
        disabled = true,
    })
    
    lib.registerContext({
        id = 'invoice_view',
        title = 'BurgerShot Invoice',
        menu = 'invoice_details',
        options = {
            {
                title = 'Customer Information',
                description = 'Customer: ' .. invoiceData.customer,
                disabled = true,
            },
            {
                title = '───────────────',
                disabled = true,
            },
            {
                title = 'Order Details',
                description = 'Items ordered:',
                disabled = true,
            },
            table.unpack(itemsList),
        },
    })
    
    lib.showContext('invoice_view')
end)

RegisterNetEvent('burgershot:receiveVehicleKeys', function(plate)
    lib.notify({
        title = 'BurgerShot Delivery',
        description = 'You received the vehicle keys',
        type = 'success'
    })
end)

RegisterNetEvent('burgershot:deliveryCompleted', function(payment)
    hasVehicleKeys = false
    if DoesEntityExist(currentDelivery.vehicle) then
        DeleteEntity(currentDelivery.vehicle)
    end
    currentDelivery = nil
    
    lib.notify({
        title = 'BurgerShot Delivery',
        description = ('Payment received! You earned $%d'):format(payment),
        type = 'success'
    })
end)

function OpenIceCreamMenu()
    local options = {}
    
    for _, icecream in ipairs(Config.IceCream) do
        local ingredientsList = ''
        for i, ingredient in ipairs(icecream.ingredients) do
            ingredientsList = ingredientsList .. ingredient:gsub("^%l", string.upper)
            if i < #icecream.ingredients then
                ingredientsList = ingredientsList .. ', '
            end
        end
        
        options[#options + 1] = {
            title = icecream.label,
            description = 'Required Ingredients:\n' .. ingredientsList,
            onSelect = function()
                local input = lib.inputDialog(('Make %s'):format(icecream.label), {
                    { type = 'number', label = 'Amount', description = 'How many would you like to make? (1-20)', default = 1, min = 1, max = 20 }
                })
                if not input then return end
                StartMakingIceCream(icecream, input[1])
            end
        }
    end
    
    lib.registerContext({
        id = 'icecream_menu',
        title = 'Ice Cream Station',
        options = options
    })
    
    lib.showContext('icecream_menu')
end

function StartMakingIceCream(icecream, amount)
    if lib.progressBar({
        duration = Config.ProgressBar.icecream.duration * amount,
        label = Config.ProgressBar.icecream.label,
        useWhileDead = false,
        canCancel = true,
        disable = {
            car = true,
            move = true,
            combat = true
        },
        anim = {
            dict = 'mp_ped_interaction',
            clip = 'handshake_guy_a'
        },
    }) then
        TriggerServerEvent('burgershot:finishIceCream', icecream.name, amount)
    end
end 