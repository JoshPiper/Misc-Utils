--[ Initialization ]--
-- Leave this bit, move to configuration.
falling = {}
falling.config = {}
falling.functions = {}


--[ Configuration ]--
-- Distance to fall before playing sound.
falling.config.fallDist = 1500
-- Maximum fall distance before resetting.
falling.config.resetDist = 30
-- Sound to play.
falling.config.sound = "items/ammo_pickup.wav"
-- How often to loop the timer (lower = faster response, more resources used)
falling.config.loopTime = 0.2


--[ Functions ]--

-- General Purpose function. Give it two times and two Y velocities, it tells you the distance fallen.
function falling.functions.getDistance(velOne, velTwo, timeOne, timeTwo, ply)
	if not ply then
		return (0 - ((((velOne + velTwo) * 0.5) * (timeTwo - timeOne))))
	elseif not ply:IsOnGround() then
		return (0 - ((((velOne + velTwo) * 0.5) * (timeTwo - timeOne))))
	else
		return 0
	end
end

-- Function for updating the player records.
function falling.functions.doTimers()
	for _, ply in pairs(player.GetAll()) do
		if IsValid(ply) then
			ply.oldtime = ply.newtime
			ply.newtime = CurTime()
			ply.oldvel = ply.newvel
			ply.newvel = tonumber(ply:GetVelocity()[3])
			--print(ply:IsOnGround())
			local falldist = falling.functions.getDistance(ply.oldvel, ply.newvel, ply.oldtime, ply.newtime, ply)
			if falldist >= falling.config.fallDist then
				if not ply.isFalling and not ply:IsOnGround() then
					ply.isFalling = true
					ply:SendLua([[surface.PlayerSound("falling.config.sound")]])
				end
			end
			if falldist <= falling.config.resetDist then
				ply.isFalling = false
			end
		end
	end
end

timer.Create("falling_timer", falling.config.loopTime, 0, falling.functions.doTimers)