-- Handle inventory changes in accumulators
script.on_event(defines.events.on_entity_inventory_changed, function(event)
  local entity = event.entity
  if entity and entity.valid and entity.name == "battery-rechargeable-accumulator" then
    process_battery_insertion(entity)
  end
end)

-- Handle script-based insertions
script.on_event(defines.events.script_raised_set_tiles, function(event)
  -- This catches some automated insertions
  for _, surface in pairs(game.surfaces) do
    local accumulators = surface.find_entities_filtered{
      name = "battery-rechargeable-accumulator"
    }
    for _, accumulator in pairs(accumulators) do
      process_battery_insertion(accumulator)
    end
  end
end)

-- Function to process battery insertion and charging
function process_battery_insertion(accumulator)
  local fuel_inventory = accumulator.get_fuel_inventory()
  if fuel_inventory and fuel_inventory.valid then
    for i = 1, #fuel_inventory do
      local fuel_stack = fuel_inventory[i]
      if fuel_stack.valid_for_read and fuel_stack.name == "battery" then
        -- Add 20% charge (1MJ out of 5MJ capacity)
        local current_energy = accumulator.energy
        local max_energy = 5000000 -- 5MJ in Joules
        local charge_amount = 1000000 -- 1MJ in Joules (20% of 5MJ)
        
        if current_energy < max_energy then
          accumulator.energy = math.min(max_energy, current_energy + charge_amount)
          fuel_stack.count = fuel_stack.count - 1
          
          -- Visual feedback
          accumulator.surface.create_entity{
            name = "flying-text",
            position = accumulator.position,
            text = "+20% Charge",
            color = {r = 0.8, g = 0.4, b = 1.0}
          }
        end
        break
      end
    end
  end
end

-- Alternative approach: Use inserter events
script.on_event(defines.events.on_pre_player_mined_item, function(event)
  -- Clean up any tracking when accumulator is mined
  local entity = event.entity
  if entity and entity.name == "battery-rechargeable-accumulator" then
    -- Clean up any stored references
  end
end)

-- Handle direct player insertion via cursor
script.on_event(defines.events.on_player_cursor_stack_changed, function(event)
  local player = game.players[event.player_index]
  if player.opened and player.opened.name == "battery-rechargeable-accumulator" then
    -- Small delay to ensure inventory has been updated
    script.on_nth_tick(2, function()
      process_battery_insertion(player.opened)
      script.on_nth_tick(2, nil) -- Remove the handler
    end)
  end
end)
