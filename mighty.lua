-- Get translator:
local S = sunset_biomes.get_translator

-----------------------------------------------------------
-----------------------------------------------------------
-- The mighty biome:
-----------------------------------------------------------
-----------------------------------------------------------

-----------------------------------------------------------
-- Standard Nodes:
-----------------------------------------------------------

minetest.register_node("sunset_biomes:mighty_stone", {
	description = S("Mighty Stone"),
	tiles = {"mighty_stone.png"},
	groups = {cracky = 3, stone = 1},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("mighty:stone","sunset_biomes:mighty_stone")

minetest.register_node("sunset_biomes:mighty_material", {
	description = S("Mighty Material"),
	tiles = {"mighty_material.png"},
	groups = {cracky = 3, stone = 1},
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("mighty:material","sunset_biomes:mighty_material")

minetest.register_node("sunset_biomes:mighty_dirt", {
	description = S("Mighty Dirt"),
	tiles = {"mighty_dirt.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
})
minetest.register_alias("mighty:dirt", "sunset_biomes:mighty_dirt")
minetest.register_abm({
	label = "Mighty Grass spread",
	nodenames = {"mighty:dirt"},
	neighbors = {
		"air",
		"mighty:dirt",
		"mighty:dirt_with_grass"
	},
	interval = 6,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (minetest.get_node_light(above) or 0) < 13 then
			return
		end

		local p2 = minetest.find_node_near(pos, 1, "group:spreading_mighty_dirt_type")
		if p2 then
			local n3 = minetest.get_node(p2)
			minetest.set_node(pos, {name = n3.name})
			return
		end
	end
})

minetest.register_node("sunset_biomes:mighty_dirt_with_mighty_grass", {
	description = S("Mighty Dirt with Mighty Grass"),
	tiles = {"mighty_grass.png", "mighty_dirt.png",
		{name = "mighty_dirt.png^mighty_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_mighty_dirt_type = 1},
	drop = "sunset_biomes:old_dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})
minetest.register_alias("mighty:dirt_with_grass", "sunset_biomes:mighty_dirt_with_mighty_grass")
minetest.register_abm({
	label = "Mighty Grass covered",
	nodenames = {"group:spreading_mighty_dirt_type"},
	interval = 8,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		local name = minetest.get_node(above).name
		local nodedef = minetest.registered_nodes[name]
		if name ~= "ignore" and nodedef and not ((nodedef.sunlight_propagates or
				nodedef.paramtype == "light") and
				nodedef.liquidtype == "none") then
			minetest.set_node(pos, {name = "mighty:dirt"})
		end
	end
})
minetest.register_abm({
	label = "Spawn Mighty Thing",
	nodenames = {"sunset_biomes:mighty_dirt_with_mighty_grass"},
	neighbors = {},
	interval = 10,
	chance = 20000,
	action = function(pos)
		local tod = minetest.get_timeofday()
		if tod < 0.2 and tod > 0.8 then
			return
		end
		minetest.add_entity({x=pos.x, y=pos.y+2, z=pos.z}, "sunset_biomes:mighty_thing")
	end,
})

minetest.register_node("sunset_biomes:mighty_core", {
	description = S("Mighty Core"),
	drawtype = "glasslike",
	tiles = {"mighty_core.png"},
	paramtype = "light",
	sunlight_propagates = true,
	is_ground_content = false,
	groups = {cracky = 3},
	sounds = default.node_sound_glass_defaults(),
	light_source = default.LIGHT_MAX,
})
minetest.register_alias("mighty:core", "sunset_biomes:mighty_core")


-----------------------------------------------------------
--Biomes:
-----------------------------------------------------------
minetest.register_biome({
	name = "mighty",
	node_top = "mighty:dirt_with_grass",
	depth_top = 1,
	node_filler = "mighty:dirt",
	depth_filler = 3,
	node_riverbed = "mighty:material",
	depth_riverbed = 2,
	node_stone = "mighty:stone",
	node_dungeon = "mighty:material",
	y_max = 31000,
	y_min = 1,
	heat_point = 70,
	humidity_point = 70,
})

minetest.register_biome({
	name = "mighty_shore",
	node_top = "mighty:material",
	depth_top = 1,
	node_filler = "mighty:material",
	depth_filler = 3,
	node_riverbed = "mighty:material",
	depth_riverbed = 2,
	node_stone = "mighty:stone",
	node_dungeon = "mighty:material",
	y_max = 0,
	y_min = -1,
	heat_point = 70,
	humidity_point = 70,
})

minetest.register_biome({
	name = "old_ocean",
	node_top = "mighty:material",
	depth_top = 1,
	node_filler = "mighty:material",
	depth_filler = 3,
	node_riverbed = "mighty:material",
	depth_riverbed = 2,
	node_cave_liquid = "default:lava_source",
	node_stone = "mighty:stone",
	node_dungeon = "mighty:material",
	vertical_blend = 1,
	y_max = -2,
	y_min = -255,
	heat_point = 70,
	humidity_point = 70,
})

minetest.register_biome({
	name = "mighty_under",
	node_cave_liquid = {"default:lava_source"},
	node_stone = "mighty:stone",
	node_dungeon = "material:material",
	y_max = -256,
	y_min = -31000,
	heat_point = 70,
	humidity_point = 70,
})


-----------------------------------------------------------
--Decorations:
-----------------------------------------------------------
minetest.register_decoration({
	name = "mighty_sphere_3",
	deco_type = "schematic",
	place_on = {"mighty:dirt", "mighty:dirt_with_grass"},
	place_offset_y = 0,
	sidelen = 16,
	fill_ratio = 0.002,
	biomes = {"mighty"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/sphere_3.mts",
	flags = "place_center_x, place_center_z, force_placement",
	rotation = "random",
})
minetest.register_decoration({
	name = "mighty_sphere_5",
	deco_type = "schematic",
	place_on = {"mighty:dirt", "mighty:dirt_with_grass"},
	place_offset_y = -1,
	sidelen = 16,
	fill_ratio = 0.001,
	biomes = {"mighty"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/sphere_5.mts",
	flags = "place_center_x, place_center_z, force_placement",
	rotation = "random",
})
minetest.register_decoration({
	name = "mighty_sphere_5",
	deco_type = "schematic",
	place_on = {"mighty:dirt", "mighty:dirt_with_grass"},
	place_offset_y = -2,
	sidelen = 16,
	fill_ratio = 0.001,
	biomes = {"mighty"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/sphere_7.mts",
	flags = "place_center_x, place_center_z, force_placement",
	rotation = "random",
})
