-- Load support for MT game translation.
local S = minetest.get_translator("sunset_biomes")

sunset_biomes = {}
sunset_biomes.get_translator = S



local mod_path = minetest.get_modpath("sunset_biomes")

dofile(mod_path.."/old.lua")
dofile(mod_path.."/old_torch.lua")
dofile(mod_path.."/old_mobs.lua")

dofile(mod_path.."/mighty.lua")
dofile(mod_path.."/mighty_mobs.lua")

dofile(mod_path.."/sky_colors.lua")
