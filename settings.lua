-- Allows the user to configure power output and total value
-- File: settings.lua

data:extend({
  {
    type = "int-setting",
    name = "bni-power-production",
    setting_type = "startup",
    default_value = 300,
    minimum_value = 1,
    maximum_value = 5000,
    order = "a-a"
  },
  {
    type = "int-setting", 
    name = "bni-energy-production",
    setting_type = "startup",
    default_value = 5,
    minimum_value = 1,
    maximum_value = 50,
    order = "a-b"
  }
})
