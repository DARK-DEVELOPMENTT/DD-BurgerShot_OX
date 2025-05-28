Config = {}

-- Debug Mode
Config.Debug = true -- Set to false in production

-- Job Settings
Config.JobName = 'burgershot'

-- Delivery Job Settings
Config.DeliveryVehicle = 'rebla' -- Sports car model (Rebla)
Config.DeliveryPayments = {
    small = 150,  -- Payment for small distance delivery
    medium = 300, -- Payment for medium distance delivery
    large = 500   -- Payment for large distance delivery
}

-- Delivery Locations (House doors)
Config.DeliveryLocations = {
    small = {
        vector4(-1185.22, -893.1, 13.89, 211.57),
        -- vector4(-1233.23, -732.39, 20.72, 27.45),
        -- vector4(-1134.56, -689.45, 21.34, 212.76),
        -- vector4(-1098.34, -642.87, 22.56, 98.45),
        -- vector4(-1045.67, -789.34, 19.23, 278.90)
    },
    medium = {
        vector4(278.28, -1071.62, 29.44, 181.53),
        -- vector4(-978.23, -256.78, 39.45, 198.34),  
        -- vector4(-1123.45, -389.23, 36.78, 267.89), 
        -- vector4(-856.78, -423.45, 30.23, 156.78),  
        -- vector4(-967.89, -478.90, 35.67, 234.56)   
    },
    large = {
        vector4(561.5, 93.54, 96.11, 341.14),  
        -- vector4(-789.23, -234.56, 45.67, 278.90),  
        -- vector4(-456.78, -345.67, 40.23, 167.89),  
        -- vector4(-678.90, -456.78, 43.45, 256.78),  
        -- vector4(-890.12, -567.89, 41.23, 145.67)   
    }
}

-- Vehicle Spawn Location
Config.VehicleSpawn = vector4(-1170.46, -879.77, 14.13, 125.08)

-- Burgershot Location
Config.Location = vector3(-1196.85, -892.64, 13.89)

-- NPC Location
Config.NPCLocation = vector4(-1189.79, -894.14, 12.89, 352.47)
Config.NPCModel = 'a_m_y_business_02'

-- Target Locations
Config.Targets = {
    duty = vector3(-1200.04, -902.48, 13.89),
    fridge = vector3(-1203.45, -895.75, 13.89),
    chopping = vector3(-1197.85, -898.64, 13.89),
    cooking = vector3(-1195.56, -898.19, 13.89),
    fries = vector3(-1195.89, -899.36, 13.89),
    drinks = vector3(-1191.55, -898.59, 13.89),
    order = vector3(-1196.91, -891.94, 13.89),
    ingredients = vector3(-1202.32, -897.47, 13.89),
    icecream = vector3(-1190.55, -898.0, 13.89),
}

-- Ingredients Shop Items
Config.ShopItems = {
    -- Burger Ingredients
    {name = 'bun', label = 'Burger Bun', price = 2},
    {name = 'patty', label = 'Beef Patty', price = 5},
    {name = 'chicken_patty', label = 'Chicken Patty', price = 4},
    {name = 'veggie_patty', label = 'Veggie Patty', price = 3},
    {name = 'lettuce', label = 'Lettuce', price = 1},
    {name = 'tomato', label = 'Tomato', price = 1},
    {name = 'cheese', label = 'Cheese', price = 2},
    {name = 'mayo', label = 'Mayonnaise', price = 1},
    {name = 'cucumber', label = 'Cucumber', price = 1},
    
    -- Drink Ingredients
    {name = 'cup', label = 'Cup', price = 1},
    {name = 'cola_syrup', label = 'Cola Syrup', price = 3},
    {name = 'sprite_syrup', label = 'Sprite Syrup', price = 3},
    {name = 'fanta_syrup', label = 'Fanta Syrup', price = 3},
    
    -- Fries Ingredients
    {name = 'potato', label = 'Potato', price = 2},
    {name = 'salt', label = 'Salt', price = 1},
    {name = 'meat', label = 'Meat', price = 3},
    
    -- Coffee Ingredients
    {name = 'coffee_beans', label = 'Coffee Beans', price = 3},
    {name = 'milk', label = 'Milk', price = 2},
    {name = 'cream', label = 'Cream', price = 2},
    
    -- Ice Cream Ingredients
    {name = 'icecream_cup', label = 'Ice Cream Cup', price = 1},
    {name = 'vanilla_mix', label = 'Vanilla Mix', price = 3},
    {name = 'chocolate_mix', label = 'Chocolate Mix', price = 3},
    {name = 'strawberry_mix', label = 'Strawberry Mix', price = 3},
    {name = 'mint_mix', label = 'Mint Mix', price = 3},
    {name = 'cookie_crumbs', label = 'Cookie Crumbs', price = 2}
}

-- Food Items
Config.Burgers = {
    {name = 'classic_burger', label = 'Classic Burger', ingredients = {'bun', 'patty', 'chopped_lettuce', 'chopped_tomato', 'cheese'}},
    {name = 'chicken_burger', label = 'Chicken Burger', ingredients = {'bun', 'chicken_patty', 'chopped_lettuce', 'mayo'}},
    {name = 'veggie_burger', label = 'Veggie Burger', ingredients = {'bun', 'veggie_patty', 'chopped_lettuce', 'chopped_tomato', 'chopped_cucumber'}}
}

Config.Drinks = {
    {name = 'cola', label = 'Cola', ingredients = {'cup', 'cola_syrup'}},
    {name = 'sprite', label = 'Sprite', ingredients = {'cup', 'sprite_syrup'}},
    {name = 'fanta', label = 'Fanta', ingredients = {'cup', 'fanta_syrup'}}
}

Config.Fries = {
    {name = 'regular_fries', label = 'Regular Fries', ingredients = {'chopped_potato', 'salt'}},
    {name = 'cheese_fries', label = 'Cheese Fries', ingredients = {'chopped_potato', 'salt', 'cheese'}},
    {name = 'loaded_fries', label = 'Loaded Fries', ingredients = {'chopped_potato', 'salt', 'cheese', 'meat'}}
}

Config.Coffee = {
    {name = 'espresso', label = 'Espresso', ingredients = {'coffee_beans', 'cup'}},
    {name = 'latte', label = 'Latte', ingredients = {'coffee_beans', 'cup', 'milk'}},
    {name = 'cappuccino', label = 'Cappuccino', ingredients = {'coffee_beans', 'cup', 'milk', 'cream'}}
}

Config.IceCream = {
    {name = 'vanilla_icecream', label = 'Vanilla Ice Cream', ingredients = {'icecream_cup', 'vanilla_mix', 'cream'}},
    {name = 'chocolate_icecream', label = 'Chocolate Ice Cream', ingredients = {'icecream_cup', 'chocolate_mix', 'cream'}},
    {name = 'strawberry_icecream', label = 'Strawberry Ice Cream', ingredients = {'icecream_cup', 'strawberry_mix', 'cream'}},
    {name = 'mint_icecream', label = 'Mint Ice Cream', ingredients = {'icecream_cup', 'mint_mix', 'cream'}},
    {name = 'cookie_icecream', label = 'Cookie Ice Cream', ingredients = {'icecream_cup', 'vanilla_mix', 'cream', 'cookie_crumbs'}}
}

-- Choppable Ingredients
Config.ChoppableItems = {
    {name = 'potato', label = 'Potato', output = 'chopped_potato', time = 5000},
    {name = 'tomato', label = 'Tomato', output = 'chopped_tomato', time = 3000},
    {name = 'lettuce', label = 'Lettuce', output = 'chopped_lettuce', time = 3000},
    {name = 'cucumber', label = 'Cucumber', output = 'chopped_cucumber', time = 3000}
}

-- Progress Bar Settings
Config.ProgressBar = {
    chopping = {duration = 5000, label = 'Chopping...', position = 'bottom'},
    cooking = {duration = 8000, label = 'Cooking...', position = 'bottom'},
    drinks = {duration = 4000, label = 'Preparing Drink...', position = 'bottom'},
    fries = {duration = 6000, label = 'Frying...', position = 'bottom'},
    icecream = {duration = 5000, label = 'Preparing Ice Cream...', position = 'bottom'}
} 