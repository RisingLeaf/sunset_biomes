-- Get translator:
local S = sunset_biomes.get_translator

-----------------------------------------------------------
-----------------------------------------------------------
-- The old biome:
-----------------------------------------------------------
-----------------------------------------------------------

-----------------------------------------------------------
-- Standard Nodes:
-----------------------------------------------------------
minetest.register_node("sunset_biomes:old_cobble", {
	description = S("Old Cobblestone"),
	tiles = {"old_cobble.png"},
	is_ground_content = false,
	groups = {cracky = 3, stone = 2},
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("old:cobble", "sunset_biomes:old_cobble")
stairs.register_stair_and_slab(
	"old_cobble",
	"old:cobble",
	{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	{"old_cobble.png"},
	("Old Cobble Stair"),
	("Old Cobble Slab"),
	default.node_sound_wood_defaults()
)

minetest.register_node("sunset_biomes:old_stone", {
	description = S("Old Stone"),
	tiles = {"old_stone.png"},
	groups = {cracky = 3, stone = 1},
	drop = "sunset_biomes:old_cobble",
	legacy_mineral = true,
	sounds = default.node_sound_stone_defaults(),
})
minetest.register_alias("old:stone", "sunset_biomes:old_stone")

minetest.register_node("sunset_biomes:old_dirt", {
	description = S("Old Dirt"),
	tiles = {"old_dirt.png"},
	groups = {crumbly = 3, soil = 1},
	sounds = default.node_sound_dirt_defaults(),
})
minetest.register_alias("old:dirt", "sunset_biomes:old_dirt")
minetest.register_abm({
	label = "Old Grass spread",
	nodenames = {"old:dirt"},
	neighbors = {
		"air",
		"old:dirt",
		"old:dirt_with_grass"
	},
	interval = 6,
	chance = 50,
	catch_up = false,
	action = function(pos, node)
		local above = {x = pos.x, y = pos.y + 1, z = pos.z}
		if (minetest.get_node_light(above) or 0) < 13 then
			return
		end

		local p2 = minetest.find_node_near(pos, 1, "group:spreading_old_dirt_type")
		if p2 then
			local n3 = minetest.get_node(p2)
			minetest.set_node(pos, {name = n3.name})
			return
		end
	end
})

minetest.register_node("sunset_biomes:old_dirt_with_old_grass", {
	description = S("Old Dirt with Old Grass"),
	tiles = {"old_grass.png", "old_dirt.png",
		{name = "old_dirt.png^old_grass_side.png",
			tileable_vertical = false}},
	groups = {crumbly = 3, soil = 1, spreading_old_dirt_type = 1},
	drop = "sunset_biomes:old_dirt",
	sounds = default.node_sound_dirt_defaults({
		footstep = {name = "default_grass_footstep", gain = 0.25},
	}),
})
minetest.register_alias("old:dirt_with_grass", "sunset_biomes:old_dirt_with_old_grass")
minetest.register_abm({
	label = "Old Grass covered",
	nodenames = {"group:spreading_old_dirt_type"},
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
			minetest.set_node(pos, {name = "old:dirt"})
		end
	end
})
minetest.register_abm({
	label = "Spawn Old Inhabitant",
	nodenames = {"sunset_biomes:old_dirt_with_old_grass"},
	neighbors = {},
	interval = 10,
	chance = 1000,
	action = function(pos)
		local tod = minetest.get_timeofday()
		if tod > 0.2 and tod < 0.8 then
			return
		end
		minetest.add_entity({x=pos.x, y=pos.y+1, z=pos.z}, "sunset_biomes:old_inhabitant")
	end,
})

minetest.register_node("sunset_biomes:old_sand", {
	description = S("Old Sand"),
	tiles = {"old_sand.png"},
	groups = {crumbly = 3, falling_node = 1, sand = 1},
	sounds = default.node_sound_sand_defaults(),
})
minetest.register_alias("old:sand", "sunset_biomes:old_sand")


-----------------------------------------------------------
-- Old Tree:
-----------------------------------------------------------
minetest.register_node("sunset_biomes:old_tree", {
	description = S("Old Tree"),
	tiles = {"old_tree_top.png", "old_tree_top.png",
		"old_tree.png"},
	paramtype2 = "facedir",
	is_ground_content = false,
	groups = {tree = 1, choppy = 3, oddly_breakable_by_hand = 1, flammable = 3},
	sounds = default.node_sound_wood_defaults(),

	on_place = minetest.rotate_node
})
minetest.register_alias("old:tree", "sunset_biomes:old_tree")

minetest.register_node("sunset_biomes:old_wood", {
	description = S("Old Wood Planks"),
	paramtype2 = "facedir",
	place_param2 = 0,
	tiles = {"old_wood.png"},
	is_ground_content = false,
	groups = {choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	sounds = default.node_sound_wood_defaults(),
})
minetest.register_alias("old:wood", "sunset_biomes:old_wood")
stairs.register_stair_and_slab(
	"old_wood",
	"old:wood",
	{choppy = 3, oddly_breakable_by_hand = 2, flammable = 3, wood = 1},
	{"old_wood.png"},
	("Old Wood Stair"),
	("Old Wood Slab"),
	default.node_sound_wood_defaults()
)
minetest.register_craft({
	output = "old:wood 4",
	recipe = {{"old:tree"}}
})

minetest.register_node("sunset_biomes:old_leaves", {
	description = S("Old Tree Leaves"),
	drawtype = "allfaces_optional",
	tiles = {"old_leaves.png"},
	waving = 1,
	paramtype = "light",
	is_ground_content = false,
	groups = {snappy = 3, leafdecay = 3, flammable = 2, leaves = 1},
	drop = {
		max_items = 1,
		items = {
			{items = {"old:leaves"}}
		}
	},
	sounds = default.node_sound_leaves_defaults(),

	after_place_node = after_place_leaves,
})
minetest.register_alias("old:leaves", "sunset_biomes:old_leaves")


-----------------------------------------------------------
--Grass and Flowers:
-----------------------------------------------------------
minetest.register_node("sunset_biomes:old_grass_1", {
	description = S("Old Grass"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"old_grass_1.png"},
	-- Use texture of a taller grass stage in inventory
	inventory_image = "old_grass_3.png",
	wield_image = "old_grass_3.png",
	paramtype = "light",
	sunlight_propagates = true,
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1,
		normal_grass = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16},
	},

	on_place = function(itemstack, placer, pointed_thing)
		-- place a random grass node
		local stack = ItemStack("default:grass_" .. math.random(1,5))
		local ret = minetest.item_place(stack, placer, pointed_thing)
		return ItemStack("sunset_biomes:old_grass_1 " ..
			itemstack:get_count() - (1 - ret:get_count()))
	end,
})
minetest.register_alias("old:grass_1", "sunset_biomes:old_grass_1")
for i = 2, 4 do
	minetest.register_node("sunset_biomes:old_grass_" .. i, {
		description = S("Old Grass"),
		drawtype = "plantlike",
		waving = 1,
		tiles = {"old_grass_" .. i .. ".png"},
		inventory_image = "old_grass_" .. i .. ".png",
		wield_image = "old_grass_" .. i .. ".png",
		paramtype = "light",
		sunlight_propagates = true,
		walkable = false,
		buildable_to = true,
		drop = "old:grass_1",
		groups = {snappy = 3, flora = 1, attached_node = 1,
			not_in_creative_inventory = 1, grass = 1,
			normal_grass = 1, flammable = 1},
		sounds = default.node_sound_leaves_defaults(),
		selection_box = {
			type = "fixed",
			fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -3 / 16, 6 / 16},
		},
	})
	minetest.register_alias("old:grass_" .. i, "sunset_biomes:old_grass_" .. i)
end

minetest.register_node("sunset_biomes:old_flower", {
	description = S("Old Flower"),
	drawtype = "plantlike",
	waving = 1,
	tiles = {"old_flower.png"},
	-- Use texture of a taller grass stage in inventory
	inventory_image = "old_flower.png",
	wield_image = "old_flower.png",
	paramtype = "light",
	sunlight_propagates = true,
	light_source = 4,
	paramtype2 = "glasslikeliquidlevel",
	walkable = false,
	buildable_to = true,
	groups = {snappy = 3, flora = 1, attached_node = 1, grass = 1,
		normal_grass = 1, flammable = 1},
	sounds = default.node_sound_leaves_defaults(),
	selection_box = {
		type = "fixed",
		fixed = {-6 / 16, -0.5, -6 / 16, 6 / 16, -5 / 16, 6 / 16},
	},
})
minetest.register_alias("old:flower", "sunset_biomes:old_flower")
minetest.register_abm({
	nodenames = {"sunset_biomes:old_flower"},
	interval = 1,
	chance = 2,
	action = function(pos)
		minetest.add_particlespawner({
			amount = 4,
			time = 4,
			minpos = {x=pos.x-0.1, y=pos.y+0.1, z=pos.z-0.1},
			maxpos = {x=pos.x+0.1, y=pos.y+0.2, z=pos.z+0.1},
			minvel = {x=-0.1, y=0.3, z=-0.1},
			maxvel = {x=0.1, y=0.7, z=0.1},
			minacc = {x=-0.01, y=-0.01, z=-0.01},
			maxacc = {x=0.01, y=-0.01, z=0.01},
			minexptime = 1,
			maxexptime = 4,
			minsize = 0.5,
			maxsize = 1,
			texture = "old_flower_particle.png",
			glow = 2,
		})
	end
})


-----------------------------------------------------------
--Biomes:
-----------------------------------------------------------
minetest.register_biome({
	name = "old",
	node_top = "old:dirt_with_grass",
	depth_top = 1,
	node_filler = "old:dirt",
	depth_filler = 3,
	node_riverbed = "old:sand",
	depth_riverbed = 2,
	node_stone = "old:stone",
	node_dungeon = "old:cobble",
	y_max = 31000,
	y_min = 1,
	heat_point = 50,
	humidity_point = 50,
})

minetest.register_biome({
	name = "old_shore",
	node_top = "old:sand",
	depth_top = 1,
	node_filler = "old:sand",
	depth_filler = 3,
	node_riverbed = "old:sand",
	depth_riverbed = 2,
	node_stone = "old:stone",
	node_dungeon = "old:cobble",
	y_max = 0,
	y_min = -1,
	heat_point = 50,
	humidity_point = 50,
})

minetest.register_biome({
	name = "old_ocean",
	node_top = "old:sand",
	depth_top = 1,
	node_filler = "old:sand",
	depth_filler = 3,
	node_riverbed = "old:sand",
	depth_riverbed = 2,
	node_cave_liquid = "default:water_source",
	node_stone = "old:stone",
	node_dungeon = "old:cobble",
	vertical_blend = 1,
	y_max = -2,
	y_min = -255,
	heat_point = 50,
	humidity_point = 50,
})

minetest.register_biome({
	name = "old_under",
	node_cave_liquid = {"default:water_source", "default:lava_source"},
	node_stone = "old:stone",
	node_dungeon = "old:cobble",
	y_max = -256,
	y_min = -31000,
	heat_point = 50,
	humidity_point = 50,
})


-----------------------------------------------------------
-- Decorations:
-----------------------------------------------------------
minetest.register_decoration({
	name = "old_tree_1",
	deco_type = "schematic",
	place_on = {"old:dirt", "old:dirt_with_grass"},
	place_offset_y = 0,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"old"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/old_tree_1.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})
minetest.register_decoration({
	name = "old_tree_2",
	deco_type = "schematic",
	place_on = {"old:dirt", "old:dirt_with_grass"},
	place_offset_y = 0,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"old"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/old_tree_2.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})
minetest.register_decoration({
	name = "old_tree_3",
	deco_type = "schematic",
	place_on = {"old:dirt", "old:dirt_with_grass"},
	place_offset_y = 0,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"old"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/old_tree_3.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})
minetest.register_decoration({
	name = "old_tree_4",
	deco_type = "schematic",
	place_on = {"old:dirt", "old:dirt_with_grass"},
	place_offset_y = 0,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"old"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/old_tree_4.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})
minetest.register_decoration({
	name = "old_tree_5",
	deco_type = "schematic",
	place_on = {"old:dirt", "old:dirt_with_grass"},
	place_offset_y = 0,
	sidelen = 16,
	fill_ratio = 0.005,
	biomes = {"old"},
	y_max = 31000,
	y_min = 1,
	schematic = minetest.get_modpath("sunset_biomes").."/schematics/old_tree_5.mts",
	flags = "place_center_x, place_center_z",
	rotation = "random",
})

for length = 1, 4 do
	minetest.register_decoration({
		name = "old:grass_"..length,
		deco_type = "simple",
		place_on = {"old:dirt_with_grass"},
		sidelen = 16,
		noise_params = {
			offset = 0,
			scale = 0.1,
			spread = {x = 20, y = 20, z = 20},
			seed = 329,
			octaves = 3,
			persist = 0.6
		},
		y_max = 30,
		y_min = 1,
		decoration = "old:grass_"..length,
	})
end

minetest.register_decoration({
	name = "old:flower",
	deco_type = "simple",
	place_on = {"old:dirt_with_grass"},
	sidelen = 16,
	noise_params = {
		offset = 0,
		scale = 0.01,
		spread = {x = 20, y = 20, z = 20},
		seed = 329,
		octaves = 3,
		persist = 0.6
	},
	y_max = 30,
	y_min = 1,
	decoration = "old:flower",
})


-----------------------------------------------------------
--Houses:
-----------------------------------------------------------

function terrain_smooth(smooth_noise, top_pos, x1, x2, z1, z2)
	for x = x1, x2 do
		for z = z1, z2 do
			local smooth_val = smooth_noise:get_2d({x=x, y=z})
			local current_height = top_pos.y - 5
			local target_height = top_pos.y + ((smooth_val - 0.5))
			if target_height > current_height then
				for y = current_height, target_height do
					minetest.set_node({x=x, y=y, z=z}, {name="old:dirt_with_grass"})
					if minetest.get_node({x=x, y=y-1, z=z}).name == "sunset_biomes:old_dirt_with_old_grass" then
						minetest.set_node({x=x, y=y-1, z=z}, {name="old:dirt"})
					end
				end
			elseif target_height < current_height then
				for y = target_height, current_height do
					minetest.set_node({x=x, y=y, z=z}, {name="air"})
					if minetest.get_node({x=x, y=y-1, z=z}).name =="sunset_biomes:old_dirt" then
						minetest.set_node({x=x, y=y-1, z=z}, {name="old:dirt_with_grass"})
					end
				end
			end
		end
	end
end

minetest.register_on_generated(function(minp, maxp, seed)
	local perlin_noise = minetest.get_perlin(329, 3, 0.6, 0.007)
	local biome_threshold = 0.8
	local offset_distance = 30
	local density = 0.01

	for i, pos in ipairs(minetest.find_nodes_in_area(minp, maxp, "old:dirt_with_grass")) do
		local noise = perlin_noise:get_3d(pos)
		if noise > biome_threshold and math.random() < density then
			local offset_noise = perlin_noise:get_3d({x = pos.x + offset_distance, y = pos.y, z = pos.z + offset_distance})

			local max_height = minp.y - 10
			local min_height = maxp.y + 10

			for x = minp.x, maxp.x do
   				for z = minp.z, maxp.z do
					local height = min_height
					for y = minp.y, maxp.y do
						local node = minetest.get_node({x=x, y=y, z=z})
						if node.name == "old:dirt_with_grass" then
							height = y
							break
						end
					end
					if height > max_height then
						max_height = height
					end
					if height < min_height then
						min_height = height
					end
				end
			end

			if offset_noise < biome_threshold and max_height - min_height <= 5 then
				-- Find the top most node
				local top_pos = {x = pos.x, y = pos.y + 1, z = pos.z}
				for x = pos.x - 4, pos.x + 4 do
					for z = pos.z - 4, pos.z + 4 do
						local height = 0
						for y = minp.y, maxp.y do
							local node = minetest.get_node({x=x, y=y, z=z})
							if node.name == "old:dirt_with_grass" then
								height = y
								break
							end
						end
						if height > top_pos.y then
							top_pos.y = height
						end
					end
				end
				
				-- Terraform the area to a flat plateu
				for x = pos.x - 5, pos.x + 5 do
					for z = pos.z - 5, pos.z + 5 do
						minetest.set_node({x = x, y = top_pos.y, z = z}, {name = "old:dirt_with_grass"})
					end
				end

				local smooth_noise = minetest.get_perlin(329, 1, 1, 1)
				terrain_smooth(smooth_noise, top_pos, pos.x - 7, pos.x - 5, pos.z - 7, pos.z + 7)
				terrain_smooth(smooth_noise, top_pos, pos.x + 5, pos.x + 7, pos.z - 7, pos.z + 7)
				terrain_smooth(smooth_noise, top_pos, pos.x - 7, pos.x + 7, pos.z - 7, pos.z - 5)
				terrain_smooth(smooth_noise, top_pos, pos.x - 7, pos.x + 7, pos.z + 5, pos.z + 7)

				
				-- Place schematic of house at pos
				minetest.place_schematic({x=pos.x, y=top_pos.y+1, z=pos.z}, minetest.get_modpath("sunset_biomes").."/schematics/old_house.mts", "random", nil, true, "place_center_x, place_center_z")
			end
		end
	end
end)