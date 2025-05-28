-- Initialize ox_inventory stash and items
CreateThread(function()
    exports.ox_inventory:RegisterStash('burgershot_fridge', 'BurgerShot Fridge', 50, 100000)
end)


exports['ox_inventory']:ItemList('burgershot_invoice', {
    label = 'BurgerShot Invoice',
    weight = 10,
    stack = true,
    close = true,
    description = 'A receipt for your BurgerShot order'
}, function(event, item, inventory, slot, data)
    if event == 'usingItem' then
        if item.metadata then
            TriggerClientEvent('burgershot:showInvoice', inventory.id, item.metadata)
        end
        return false
    end
end)


RegisterNetEvent('burgershot:finishChopping')
AddEventHandler('burgershot:finishChopping', function(itemName, outputItem, amount)
    local source = source
    local hasItem = exports.ox_inventory:GetItem(source, itemName, nil, true) >= amount

    if not hasItem then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You don\'t have enough ' .. itemName
        })
        return
    end

    exports.ox_inventory:RemoveItem(source, itemName, amount)
    exports.ox_inventory:AddItem(source, outputItem, amount)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Successfully chopped ' .. amount .. ' ' .. itemName
    })
end)


RegisterNetEvent('burgershot:finishDrink')
AddEventHandler('burgershot:finishDrink', function(drinkName, amount)
    local source = source
    local drink = nil
    
    for _, d in ipairs(Config.Drinks) do
        if d.name == drinkName then
            drink = d
            break
        end
    end

    if not drink then return end

 
    for _, ingredient in ipairs(drink.ingredients) do
        local hasIngredient = exports.ox_inventory:GetItem(source, ingredient, nil, true) >= amount
        if not hasIngredient then
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'You don\'t have enough ' .. ingredient
            })
            return
        end
    end

   
    for _, ingredient in ipairs(drink.ingredients) do
        exports.ox_inventory:RemoveItem(source, ingredient, amount)
    end
    exports.ox_inventory:AddItem(source, drinkName, amount)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Successfully made ' .. amount .. ' ' .. drink.label
    })
end)


RegisterNetEvent('burgershot:finishFries')
AddEventHandler('burgershot:finishFries', function(friesName, amount)
    local source = source
    local fries = nil
    
    for _, f in ipairs(Config.Fries) do
        if f.name == friesName then
            fries = f
            break
        end
    end

    if not fries then return end

    -- Check ingredients
    for _, ingredient in ipairs(fries.ingredients) do
        local hasIngredient = exports.ox_inventory:GetItem(source, ingredient, nil, true) >= amount
        if not hasIngredient then
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'You don\'t have enough ' .. ingredient
            })
            return
        end
    end


    for _, ingredient in ipairs(fries.ingredients) do
        exports.ox_inventory:RemoveItem(source, ingredient, amount)
    end
    exports.ox_inventory:AddItem(source, friesName, amount)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Successfully made ' .. amount .. ' ' .. fries.label
    })
end)


RegisterNetEvent('burgershot:finishCooking')
AddEventHandler('burgershot:finishCooking', function(burgerName, amount)
    local source = source
    local burger = nil
    
    for _, b in ipairs(Config.Burgers) do
        if b.name == burgerName then
            burger = b
            break
        end
    end

    if not burger then return end


    for _, ingredient in ipairs(burger.ingredients) do
        local hasIngredient = exports.ox_inventory:GetItem(source, ingredient, nil, true) >= amount
        if not hasIngredient then
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'You don\'t have enough ' .. ingredient
            })
            return
        end
    end


    for _, ingredient in ipairs(burger.ingredients) do
        exports.ox_inventory:RemoveItem(source, ingredient, amount)
    end
    exports.ox_inventory:AddItem(source, burgerName, amount)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Successfully cooked ' .. amount .. ' ' .. burger.label
    })
end)


RegisterNetEvent('burgershot:finishIceCream')
AddEventHandler('burgershot:finishIceCream', function(icecreamName, amount)
    local source = source
    local icecream = nil
    
    for _, i in ipairs(Config.IceCream) do
        if i.name == icecreamName then
            icecream = i
            break
        end
    end

    if not icecream then return end


    for _, ingredient in ipairs(icecream.ingredients) do
        local hasIngredient = exports.ox_inventory:GetItem(source, ingredient, nil, true) >= amount
        if not hasIngredient then
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'You don\'t have enough ' .. ingredient
            })
            return
        end
    end


    for _, ingredient in ipairs(icecream.ingredients) do
        exports.ox_inventory:RemoveItem(source, ingredient, amount)
    end
    exports.ox_inventory:AddItem(source, icecreamName, amount)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Successfully made ' .. amount .. ' ' .. icecream.label
    })
end)


RegisterNetEvent('burgershot:createOrder')
AddEventHandler('burgershot:createOrder', function(order)
    local source = source
    local items = {}
    local totalPrice = 0

    if order.burger then
        for _, burger in ipairs(Config.Burgers) do
            if burger.name == order.burger then
                items[#items + 1] = burger.label .. ' x' .. order.amount
                break
            end
        end
    end

    if order.drink then
        for _, drink in ipairs(Config.Drinks) do
            if drink.name == order.drink then
                items[#items + 1] = drink.label .. ' x' .. order.amount
                break
            end
        end
    end

    if order.fries then
        for _, fries in ipairs(Config.Fries) do
            if fries.name == order.fries then
                items[#items + 1] = fries.label .. ' x' .. order.amount
                break
            end
        end
    end

    if order.coffee then
        for _, coffee in ipairs(Config.Coffee) do
            if coffee.name == order.coffee then
                items[#items + 1] = coffee.label .. ' x' .. order.amount
                break
            end
        end
    end

    if order.icecream then
        for _, icecream in ipairs(Config.IceCream) do
            if icecream.name == order.icecream then
                items[#items + 1] = icecream.label .. ' x' .. order.amount
                break
            end
        end
    end

    local invoiceData = {
        customer = GetPlayerName(source),
        items = table.concat(items, '\n'),
        amount = order.amount
    }

    exports.ox_inventory:AddItem(source, 'burgershot_invoice', 1, invoiceData)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        description = 'Order placed successfully!'
    })
end)


RegisterNetEvent('burgershot:buyIngredient')
AddEventHandler('burgershot:buyIngredient', function(itemName, amount, price)
    local source = source
    local totalPrice = price * amount
    
    local money = exports.ox_inventory:GetItem(source, 'money', nil, true)
    
    if money >= totalPrice then
        if exports.ox_inventory:CanCarryItem(source, itemName, amount) then
            if exports.ox_inventory:RemoveItem(source, 'money', totalPrice) then
                if exports.ox_inventory:AddItem(source, itemName, amount) then
                    TriggerClientEvent('ox_lib:notify', source, {
                        type = 'success',
                        description = ('Purchased %dx %s for $%d'):format(amount, itemName, totalPrice)
                    })
                else
                    exports.ox_inventory:AddItem(source, 'money', totalPrice)
                    TriggerClientEvent('ox_lib:notify', source, {
                        type = 'error',
                        description = 'Failed to purchase items!'
                    })
                end
            else
                TriggerClientEvent('ox_lib:notify', source, {
                    type = 'error',
                    description = 'Failed to process payment!'
                })
            end
        else
            TriggerClientEvent('ox_lib:notify', source, {
                type = 'error',
                description = 'You cannot carry that many items!'
            })
        end
    else
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'You cannot afford this purchase!'
        })
    end
end)


RegisterNetEvent('burgershot:receiveDeliveryPayment', function(amount)
    local source = source
    exports.ox_inventory:AddItem(source, 'money', amount)
end)


RegisterNetEvent('burgershot:giveVehicleKeys', function(plate)
    local source = source
    TriggerClientEvent('burgershot:receiveVehicleKeys', source, plate)
end)


RegisterNetEvent('burgershot:markDeliveryComplete', function(delivery)
    local source = source
    
    local hasAllItems = true
    for _, item in ipairs(delivery.order.items) do
        local count = exports.ox_inventory:Search(source, 'count', item)
        if count < 1 then
            hasAllItems = false
            break
        end
    end
    
    if not hasAllItems then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            description = 'Missing required items for delivery!'
        })
        return
    end
    
    for _, item in ipairs(delivery.order.items) do
        exports.ox_inventory:RemoveItem(source, item, 1)
    end
end)


RegisterNetEvent('burgershot:completeDelivery', function(delivery)
    local source = source
    
    local payment = Config.DeliveryPayments[delivery.type]
    exports.ox_inventory:AddItem(source, 'money', payment)
    
    TriggerClientEvent('burgershot:deliveryCompleted', source, payment)
end) 