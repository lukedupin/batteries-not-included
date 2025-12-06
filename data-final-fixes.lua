-- Remove ice-melting from thruster technology
local thruster_tech = data.raw.technology["thruster"]

if thruster_tech then
  for i, effect in pairs(thruster_tech.effects or {}) do
    if effect.type == "unlock-recipe" and effect.recipe == "ice-melting" then
      table.remove(thruster_tech.effects, i)
      break
    end
  end
end

-- Add ice-melting to space science pack technology
local space_science_tech = data.raw.technology["space-science-pack"]

if space_science_tech then
  table.insert(space_science_tech.effects, {
    type = "unlock-recipe",
    recipe = "ice-melting"
  })
end
