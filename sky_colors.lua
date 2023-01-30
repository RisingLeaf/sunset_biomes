local lerp = function(a, b, t)
	return a + (b - a) * t
end

local interpolate_colors = function(colora, colorb, ratio)
	local r = math.floor(lerp(colora.r, colorb.r, ratio))
	local g = math.floor(lerp(colora.g, colorb.g, ratio))
	local b = math.floor(lerp(colora.b, colorb.b, ratio))
	return {r=r, g=g, b=b}
end

local biome_sky_colors = {
	["old"] = {r=50, g=27, b=27, type="plain"},
	["mighty"] = {r=70, g=206, b=235, type="plain"},
}
local biome_cloud_colors = {
	["old"] = {r=120, g=70, b=70},
	["mighty"] = {r=225, g=225, b=225},
}

-- Table to store the current sky color for each player
local player_sky_colors = {}
local player_trans_times = {}

-- Function to set sky color for a player
local function set_sky_color(player, dtime)
	local pos = player:get_pos()
	local biome = minetest.get_biome_data(pos)
	local biome_name = "plains"
	if biome ~= nil then
		biome_name = minetest.get_biome_name(biome.biome)
	end
	local sky_color = biome_sky_colors[biome_name] or {r=137, g=207, b=235, type="regular"}
	local cloud_color = biome_cloud_colors[biome_name] or {r=255, g=255, b=255}

	-- Only update the sky color if the player has moved to a new biome
	if player_sky_colors[player:get_player_name()] ~= sky_color then
		player_sky_colors[player:get_player_name()] = sky_color
		player_trans_times[player:get_player_name()] = 0
	end

	local time = 2 -- time for the color transition
	if player_trans_times[player:get_player_name()] <= time then
		local current_sky_color = player:get_sky()
		local current_cloud_color = player:get_clouds().color
		player_trans_times[player:get_player_name()] = player_trans_times[player:get_player_name()] + dtime
		if player_trans_times[player:get_player_name()] > time then
			player:set_sky({base_color = sky_color})
			player:set_clouds({ color = cloud_color })
			return
		end
		local new_sky_color = interpolate_colors(current_sky_color, sky_color, player_trans_times[player:get_player_name()]/time)
		local new_cloud_color = interpolate_colors(current_cloud_color, cloud_color, player_trans_times[player:get_player_name()]/time)
		player:set_sky({base_color = new_sky_color, type = sky_color.type})
		player:set_clouds({ color = new_cloud_color })
	end
end

-- Register a globalstep function to update sky color
minetest.register_globalstep(function(dtime)
	for _, player in ipairs(minetest.get_connected_players()) do
		set_sky_color(player, dtime)
	end
end)