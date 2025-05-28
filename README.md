# BurgerShot Script

- A FiveM script for BurgerShot restaurant using ox_lib, ox_inventory, and ox_target.
- I Will Add qb-inventory & qb-target in future.

## Features
- Employee duty system
- Ingredient preparation (chopping)
- Food and drink preparation
- Order system with invoices
- NPC interaction
- Progress bars for all actions
- Stash/fridge system

## Dependencies
- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [ox_target](https://github.com/overextended/ox_target)
- [MLO](https://www.gta5-mods.com/maps/mlo-burgershot-2023-add-on-sp-fivem)

## Installation

1. Add the following items to your `ox_inventory/data/items.lua`:

```lua
-- Ingredients
['bun'] = {
    label = 'Burger Bun',
    weight = 100,
},
['patty'] = {
    label = 'Beef Patty',
    weight = 100,
},
['chicken_patty'] = {
    label = 'Chicken Patty',
    weight = 100,
},
['veggie_patty'] = {
    label = 'Veggie Patty',
    weight = 100,
},
['lettuce'] = {
    label = 'Lettuce',
    weight = 50,
},
['tomato'] = {
    label = 'Tomato',
    weight = 50,
},
['cheese'] = {
    label = 'Cheese',
    weight = 50,
},
['mayo'] = {
    label = 'Mayonnaise',
    weight = 50,
},
['cucumber'] = {
    label = 'Cucumber',
    weight = 50,
},
['potato'] = {
    label = 'Potato',
    weight = 100,
},
['salt'] = {
    label = 'Salt',
    weight = 10,
},
['meat'] = {
    label = 'Meat',
    weight = 50,
},
['coffee_beans'] = {
    label = 'Coffee Beans',
    weight = 50,
},
['milk'] = {
    label = 'Milk',
    weight = 100,
},
['cream'] = {
    label = 'Cream',
    weight = 50,
},
['cup'] = {
    label = 'Cup',
    weight = 10,
},
['icecream_cup'] = {
    label = 'Ice Cream Cup',
    weight = 10,
},
['vanilla_mix'] = {
    label = 'Vanilla Mix',
    weight = 50,
},
['chocolate_mix'] = {
    label = 'Chocolate Mix',
    weight = 50,
},
['strawberry_mix'] = {
    label = 'Strawberry Mix',
    weight = 50,
},
['mint_mix'] = {
    label = 'Mint Mix',
    weight = 50,
},
['cookie_crumbs'] = {
    label = 'Cookie Crumbs',
    weight = 20,
},
['cola_syrup'] = {
    label = 'Cola Syrup',
    weight = 100,
},
['sprite_syrup'] = {
    label = 'Sprite Syrup',
    weight = 100,
},
['fanta_syrup'] = {
    label = 'Fanta Syrup',
    weight = 100,
},

-- Chopped Ingredients
['chopped_potato'] = {
    label = 'Chopped Potato',
    weight = 100,
},
['chopped_tomato'] = {
    label = 'Chopped Tomato',
    weight = 50,
},
['chopped_lettuce'] = {
    label = 'Chopped Lettuce',
    weight = 50,
},
['chopped_cucumber'] = {
    label = 'Chopped Cucumber',
    weight = 50,
},

-- Final Products
['classic_burger'] = {
    label = 'Classic Burger',
    weight = 300,
},
['chicken_burger'] = {
    label = 'Chicken Burger',
    weight = 300,
},
['veggie_burger'] = {
    label = 'Veggie Burger',
    weight = 250,
},
['cola'] = {
    label = 'Cola',
    weight = 200,
},
['sprite'] = {
    label = 'Sprite',
    weight = 200,
},
['fanta'] = {
    label = 'Fanta',
    weight = 200,
},
['regular_fries'] = {
    label = 'Regular Fries',
    weight = 150,
},
['cheese_fries'] = {
    label = 'Cheese Fries',
    weight = 200,
},
['loaded_fries'] = {
    label = 'Loaded Fries',
    weight = 250,
},
['espresso'] = {
    label = 'Espresso',
    weight = 100,
},
['latte'] = {
    label = 'Latte',
    weight = 200,
},
['cappuccino'] = {
    label = 'Cappuccino',
    weight = 200,
},
['vanilla_icecream'] = {
    label = 'Vanilla Ice Cream',
    weight = 200,
},
['chocolate_icecream'] = {
    label = 'Chocolate Ice Cream',
    weight = 200,
},
['strawberry_icecream'] = {
    label = 'Strawberry Ice Cream',
    weight = 200,
},
['mint_icecream'] = {
    label = 'Mint Ice Cream',
    weight = 200,
},
['cookie_icecream'] = {
    label = 'Cookie Ice Cream',
    weight = 250,
},
['burgershot_invoice'] = {
    label = 'BurgerShot Invoice',
    weight = 0,
    stack = false,
    close = true,
    description = 'A receipt for your BurgerShot order',
    client = {
        export = 'DD-BurgerShot_OX.useInvoice'
    }
},
```
2. Add the following items images to your `ox_inventory/web/images`:
3. Copy the script to your resources folder
4. Add `ensure DD-BurgerShot` to your server.cfg
5. Restart your server

## Usage

### For Employees
1. Go on duty at the duty point
2. Use the fridge to get ingredients
3. Prepare ingredients at the chopping station
4. Make food and drinks at their respective stations
5. Receive orders through invoices

### For Customers
1. Approach order point
2. Select desired items from the menu
3. Choose quantities
4. Receive an invoice for the order

## Configuration
All configuration options can be found in `config.lua`:
- NPC location and model
- Target locations
- Food items and their ingredients
- Progress bar durations
- And more

## Support
For support, please Join The Discord [Discord](https://discord.gg/c3gwcDt6Vh) Server .
