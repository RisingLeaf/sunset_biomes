-- Get translator:
local S = sunset_biomes.get_translator

-----------------------------------------------------------
-----------------------------------------------------------
-- The lost kingdom "biome":
-----------------------------------------------------------
-----------------------------------------------------------

-----------------------------------------------------------
-- Place Holders:
-----------------------------------------------------------
minetest.register_node("sunset_biomes:house_placeholder", {
	description = S("House Placeholder"),
	tiles = {"house_placeholder.png"},
	groups = {cracky = 3, stone = 1},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("lost_kingdom:house","sunset_biomes:house_placeholder")


local castle_positions = {}
function distance(vec1, vec2)
	return math.sqrt((vec1.x - vec2.x)^2 + (vec1.y - vec2.y)^2 + (vec1.z - vec2.z)^2)
end

minetest.register_on_generated(function(minp, maxp, seed)
	local density = 0.0001
	for i, pos in ipairs(minetest.find_nodes_in_area(minp, maxp, "default:dirt_with_grass")) do
		local should_be_placed = true
		for _,cp in ipairs(castle_positions) do
			if distance(cp, pos) < 200 then
				should_be_placed = false
			end
		end
		if math.random() < density and pos.y <= 20 and should_be_placed then
			table.insert( castle_positions, pos )
			minetest.place_schematic(
				{x=pos.x, y=pos.y-44, z=pos.z},
				minetest.get_modpath("sunset_biomes").."/schematics/castle_base_1.mts",
				"0",
				nil,
				true,
				"place_center_x, place_center_z"
			)
			local cminp = {x=pos.x-80, y=pos.y-41, z=pos.z-80}
			local cmaxp = {x=pos.x+80, y=pos.y+41, z=pos.z+80}
			for r, rpos in ipairs(minetest.find_nodes_in_area(cminp, cmaxp, "sunset_biomes:house_placeholder")) do
				if math.random() > 0.05 then
					minetest.place_schematic(
						rpos,
						minetest.get_modpath("sunset_biomes").."/schematics/8x8_house_"..math.random(1,3)..".mts",
						"random",
						nil,
						true
					)
				else
					minetest.place_schematic(
						rpos,
						minetest.get_modpath("sunset_biomes").."/schematics/8x8_dec_"..math.random(1,2)..".mts",
						"random",
						nil,
						true
					)
				end
			end
		end
	end
end)

--minetest.register_on_generated(function(minp, maxp, seed)
--	for r, rpos in ipairs(minetest.find_nodes_in_area(minp, maxp, "sunset_biomes:house_placeholder")) do
--		if math.random() > 0.025 then
--			minetest.place_schematic(
--				rpos,
--				minetest.get_modpath("sunset_biomes").."/schematics/8x8_house_"..math.random(1,3)..".mts",
--				"random",
--				nil,
--				true
--			)
--		else
--			minetest.place_schematic(
--				rpos,
--				minetest.get_modpath("sunset_biomes").."/schematics/8x8_dec_"..math.random(1,2)..".mts",
--				"random",
--				nil,
--				true
--			)
--		end
--	end
--end)