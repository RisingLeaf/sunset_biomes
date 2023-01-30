-- Get translator:
local S = sunset_biomes.get_translator


minetest.register_entity("sunset_biomes:mighty_thing", {
	initial_properties = {
		visual = "mesh",
		mesh = "mighty_thing.b3d",
		textures = {"mighty_thing.png"},
		physical = true,
		light_source = 4,
		hp_max = 20,
		hp = 20,
	},
	
	on_step = function(self, dtime)
		local tod = minetest.get_timeofday()
		if tod < 0.2 or tod > 0.8 then
			self.object:remove()
			return
		end

		if math.random(1, 100) == 1 then
			self.object:set_hp(self.object:get_hp() - 1)
			local pos = self.object:get_pos()
			if pos ~= nil then
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
					texture = "mighty_particle.png",
					glow = 10,
				})
			end
		end

		self.object:set_animation({x = 1, y = 119}, 24, 0)
	end,
})