local CATEGORY_NAME = "Fun"

--------- Infinite Ammo ---------
function ulx.uammo(calling_ply, target_plys, should_remove)
	for i, ply in pairs(target_plys) do
		if should_remove == true
			ply.infinateAmmo = false
		else
			ply.infinateAmmo = true
		end
			if ply.infinateAmmo == true then
				playerCurrentWeapons = {}
				playerCurrentWeapons = ply:GetWeapons()
				for weapon in playerCurrentWeapons do
					--Msg("Weapon: "..weapon)
					ptype = weapon:GetPrimaryAmmoType() 
					stype = weapon:GetSecondaryAmmoType()
					ply.origionalAmmo = {}
					ammoInUse = {}
					ply.origionalAmmo[ptype] = ply:GetAmmoCount(ptype)
					ply.origionalAmmo[stype] = ply:GetAmmoCount(stype)
					table.insert(ammoInUse, ptype)
					table.insert(ammoInUse, stype)
					--ply:SetAmmo(9999, ptype)
					--ply:SetAmmo(9999, stype)
				end
				for ammotype in ammoInUse do
					ply:SetAmmo(9999, ammotype)
				end
			else
				for ammotype, ammoamount in ply.origionalAmmo do
					ply:SetAmmo(ammoamount, ammotype)
				end
			end
	end
end


local uammo = ulx.command( CATEGORY_NAME, "ulx uammo", ulx.uammo, "!uammo" )
uammo:addParam{ type=ULib.cmds.PlayerArg, ULib.cmds.optional }
uammo:addParam{ type=ULib.cmds.invisible }
uammo:defaultAccess( ULib.ACCESS_ADMIN )
uammo:help( "Gives the target infinite ammo." )
uammo:setOpposite( "ulx unuammo", {_, _, true}, "!unuammo" )

function ulx.uammo2
	for team in GetAllTeams() do
		for player in team.GetPlayers do
			if player.infinateAmmo == true then
				if ply.infinateAmmo == true then
					playerCurrentWeapons = {}
					playerCurrentWeapons = ply:GetWeapons()
					for weapon in playerCurrentWeapons do
						ptype = weapon:GetPrimaryAmmoType() 
						stype = weapon:GetSecondaryAmmoType()
						ply:SetAmmo(9999, ptype)
						ply:SetAmmo(9999, stype)
					end
				end
			end
		end
	end
end

if ( SERVER ) then
	hook.Add("Reload", "Weapon Infinite Ammo Reloading", ulx.uammo2)
end