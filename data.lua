-- Deep copy the base accumulator
local battery_accumulator = table.deepcopy(data.raw["accumulator"]["accumulator"])

-- Modify the copied accumulator
battery_accumulator.name = "battery-rechargeable-accumulator"
battery_accumulator.minable = {mining_time = 0.5, result = "battery-rechargeable-accumulator"}
battery_accumulator.localised_name = {"entity-name.battery-rechargeable-accumulator"}
battery_accumulator.localised_description = {"entity-description.battery-rechargeable-accumulator"}

-- Add purple tint to entity graphics
battery_accumulator.picture.tint = {r = 0.8, g = 0.4, b = 1.0, a = 1.0}
if battery_accumulator.charge_animation then
  battery_accumulator.charge_animation.tint = {r = 0.8, g = 0.4, b = 1.0, a = 1.0}
end
if battery_accumulator.discharge_animation then
  battery_accumulator.discharge_animation.tint = {r = 0.8, g = 0.4, b = 1.0, a = 1.0}
end

-- Add energy source with fuel slot
battery_accumulator.energy_source = {
  type = "electric",
  buffer_capacity = "5MJ",
  usage_priority = "tertiary",
  input_flow_limit = "300kW",
  output_flow_limit = "300kW",
  fuel_category = "battery-fuel",
  fuel_inventory_size = 1,
  burnt_inventory_size = 1
}

-- Create the item
local battery_accumulator_item = table.deepcopy(data.raw["item"]["accumulator"])
battery_accumulator_item.name = "battery-rechargeable-accumulator"
battery_accumulator_item.place_result = "battery-rechargeable-accumulator"
battery_accumulator_item.localised_name = {"item-name.battery-rechargeable-accumulator"}
battery_accumulator_item.localised_description = {"item-description.battery-rechargeable-accumulator"}

-- Add purple tint to item icon
battery_accumulator_item.icon_tint = {r = 0.8, g = 0.4, b = 1.0, a = 1.0}

-- Create recipe
local battery_accumulator_recipe = {
  type = "recipe",
  name = "battery-rechargeable-accumulator",
  energy_required = 10,
  enabled = false,
  ingredients = {
    {"accumulator", 1},
    {"advanced-circuit", 2},
    {"steel-plate", 5}
  },
  result = "battery-rechargeable-accumulator"
}

-- Create fuel category for batteries
local battery_fuel_category = {
  type = "fuel-category",
  name = "battery-fuel"
}

-- Modify battery item to be fuel
local battery_fuel = table.deepcopy(data.raw["item"]["battery"])
battery_fuel.fuel_category = "battery-fuel"
battery_fuel.fuel_value = "1MJ" -- 20% of 5MJ accumulator capacity
battery_fuel.fuel_acceleration_multiplier = 1
battery_fuel.fuel_top_speed_multiplier = 1

-- Add technology
local battery_accumulator_tech = {
  type = "technology",
  name = "battery-rechargeable-accumulator",
  icon = "__base__/graphics/technology/electric-energy-accumulators.png",
  icon_size = 256,
  icon_mipmaps = 4,
  icon_tint = {r = 0.8, g = 0.4, b = 1.0, a = 1.0},
  effects = {
    {
      type = "unlock-recipe",
      recipe = "battery-rechargeable-accumulator"
    }
  },
  prerequisites = {"electric-energy-accumulators", "battery"},
  unit = {
    count = 150,
    ingredients = {
      {"automation-science-pack", 1},
      {"logistic-science-pack", 1}
    },
    time = 30
  },
  order = "c-e-b"
}

-- Add all to data
data:extend({
  battery_fuel_category,
  battery_accumulator,
  battery_accumulator_item,
  battery_accumulator_recipe,
  battery_accumulator_tech
})

-- Override the existing battery item
data.raw["item"]["battery"].fuel_category = "battery-fuel"
data.raw["item"]["battery"].fuel_value = "1MJ"
