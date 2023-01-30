-- Get translator:
local S = sunset_biomes.get_translator


minetest.register_entity("sunset_biomes:old_inhabitant", {
	initial_properties = {
		visual = "mesh",
		mesh = "old_inhabitant.b3d",
		textures = {"old_inhabitant.png"},
		backface_culling = false,
		physical = true,
		hp_max = 20,
		hp = 20,
	},

	on_activate = function(self, staticdata)
		self.walk_dir = {x=0, y=0, z=0}
	end,
	
	on_step = function(self, dtime)
		local tod = minetest.get_timeofday()
		if tod > 0.2 and tod < 0.8 then
			self.object:remove()
			return
		end

		if math.random(1, 25) == 1 then
			self.object:set_hp(self.object:get_hp() - 1)
		end

		self.object:set_animation({x = 1, y = 60}, 24, 0)
		if math.random() < 0.05 then
			self.walk_dir = {x = math.random(-1, 1), y = 0, z = math.random(-1, 1), z = math.random(-0.1, 0.1)}
		end
		local dir = vector.normalize(self.walk_dir)
		local yaw = math.atan(dir.z, dir.x)
		self.object:set_yaw(yaw)
		self.object:set_velocity(self.walk_dir)
	end,
})