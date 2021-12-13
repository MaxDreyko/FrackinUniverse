require "/scripts/vec2.lua"

function init()
	self.targetSpeed = vec2.mag(mcontroller.velocity())
	self.controlForce = config.getParameter("baseHomingControlForce") * self.targetSpeed
	self.detonateProximity=config.getParameter("detonateProximity",2)
	self.scanRange=config.getParameter("scanRange",20)
end

function update()
	local targets = world.entityQuery(mcontroller.position(), self.scanRange, {
			withoutEntityId = projectile.sourceEntity(),
			includedTypes = {"creature"},
			order = "nearest"
		})

	for _, target in ipairs(targets) do
		if entity.isValidTarget(target) and entity.entityInSight(target) then
			local targetPos = world.entityPosition(target)
			local myPos = mcontroller.position()
			local dist = world.distance(targetPos, myPos)

			if self.controlForce then mcontroller.approachVelocity(vec2.mul(vec2.norm(dist), self.targetSpeed), self.controlForce) end
			if vec2.mag(dist)<self.detonateProximity then projectile.die() end
			return
		end
	end
end