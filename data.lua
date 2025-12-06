local space_age_sounds = require("__space-age__.prototypes.entity.sounds")
local space_age_item_sounds = require("__space-age__.prototypes.item_sounds")

-- Create battery fuel category first
data:extend({
  {
    type = "fuel-category",
    name = "battery"
  }
})

-- Make batteries work as fuel
data.raw["item"]["battery"].fuel_category = "battery"
data.raw["item"]["battery"].fuel_value = "5MJ"
data.raw["item"]["battery"].burnt_result = nil

-- Create battery-powered generator using deepcopy from steam turbine
local battery_generator = table.deepcopy(data.raw["generator"]["steam-turbine"])

-- Change type to burner-generator
battery_generator.name = "batteries-not-included"
battery_generator.type = "burner-generator"

-- Remove steam-related properties
battery_generator.fluid_box = nil
battery_generator.fluid_usage_per_tick = nil
battery_generator.maximum_temperature = nil
battery_generator.burns_fluid = nil
battery_generator.scale_fluid_usage = nil
battery_generator.effectivity = nil
battery_generator.destroy_non_fuel_fluid = nil

-- Copy accumulator visuals
-- local accumulator = data.raw["accumulator"]["accumulator"]
-- battery_generator.picture = table.deepcopy(accumulator.picture)
-- battery_generator.charge_animation = table.deepcopy(accumulator.charge_animation)
-- battery_generator.discharge_animation = table.deepcopy(accumulator.discharge_animation)

local anim = { 
    layers = {
    {
      filename = "__batteries-not-included__/graphics/battery-generator-discharge.png",
      height = 214,
      priority = "high",
      frame_count = 24,
      line_length = 6,
      scale = 0.5,
      shift = {
        0,
        -0.34375
      },
      tint = {
        1,
        1,
        1,
        1
      },
      width = 174
    },
    {
      draw_as_shadow = true,
      filename = "__base__/graphics/entity/accumulator/accumulator-shadow.png",
      height = 106,
      priority = "high",
      repeat_count = 24,
      scale = 0.5,
      shift = {
        0.90625,
        0.1875
      },
      width = 234
    }
  }
}

battery_generator.animation = {        
    east = anim,
    north = anim,
    south = anim,
    west = anim,
}

-- Set 2x2 footprint (copy from accumulator)
battery_generator.collision_box = {{-0.9, -0.9}, {0.9, 0.9}}
battery_generator.selection_box = {{-1, -1}, {1, 1}}
battery_generator.drawing_box = {{-1, -1.5}, {1, 1}}

-- Set up the burner
battery_generator.burner = {
  type = "burner",
  fuel_categories = {"battery"},
  effectivity = 1,
  fuel_inventory_size = 1,
  emissions_per_minute = { pollution = 0 },
  light_flicker = {
    color = {0.7, 0.3, 0.9},
    minimum_intensity = 0.1,
    maximum_intensity = 0.3,
  },
  smoke = {}
}

-- Set up electric output
battery_generator.max_power_output = "300kW"

-- Update minable result
battery_generator.minable = {mining_time = 0.2, result = "batteries-not-included"}

-- Add the generator entity
data:extend({battery_generator})

-- Create the item
local battery_generator_item = {
    type = "item",
    name = "batteries-not-included",
    icon = "__batteries-not-included__/graphics/battery-generator.png",
    place_result = "batteries-not-included",
    subgroup = "production-machine",
    order = "e[accumulator]-a[batteries-not-included]",
    weight = 0.02 * tons,
    inventory_move_sound = space_age_item_sounds.mechanical_large_inventory_move,
	pick_sound = space_age_item_sounds.mechanical_large_inventory_pickup,
	drop_sound = space_age_item_sounds.mechanical_large_inventory_move,
    stack_size = 50
}

data:extend({battery_generator_item})

-- Create the recipe
data:extend({
  {
    type = "recipe",
    name = "batteries-not-included",
    enabled = false,
    ingredients = {
      {type = "item", name = "iron-plate", amount = 10},
      {type = "item", name = "battery", amount = 5},
      {type = "item", name = "electronic-circuit", amount = 5}
    },
    results = {{type = "item", name = "batteries-not-included", amount = 1}}
  }
})

-- Add to accumulator technology
table.insert(data.raw["technology"]["electric-energy-accumulators"].effects, {
  type = "unlock-recipe",
  recipe = "batteries-not-included"
})

-- Update description
battery_generator.localised_description = {"", "Battery-powered generator. Insert batteries to generate electricity. Works in space!"}
