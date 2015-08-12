CanPlayerEnterVehicle( Player player, Vehicle vehicle, string sRole ) 
PlayerCanPickupWeapon( Player ply, Weapon wep ) 
PlayerSwitchWeapon( Player player, Weapon oldWeapon, Weapon newWeapon ) 


hook.Add("CanPlayerEnterVehicle", "Blacklists_VehicleBlacklistCheck", function(ply) if ply:isBlacklisted("vehicles") then return false end end)
hook.Add("PlayerCanPickupWeapon", "Blacklists_PhysgunBlacklistCheck", function(ply, wep) if ply:isBlacklisted("physgun") and wep:GetClass() == "weapon_physcannon" then return false end end)
hook.Add("PlayerCanPickupWeapon", "Blacklists_WeaponBlacklistCheck", function(ply) if ply:isBlacklisted("weapons") then return false end end)

META = GetMetaTable("player")

require("mysqloo")

function META:blacklist(strType, intTime, strReason, plyAdmin)
	assert(strType, "No Blacklist Type Provided to Blacklist Metafunction.")
	assert(intTime, "No Blacklist Time Provided to Blacklist Metafunction.")
	assert(strReason, "No Reason Provided to Blacklist Metafunction.")
	if not IsValid(plyAdmin) then
		local strAdminName = "(CONSOLE)"
		local strAdminSteam = "(CONSOLE)"
	else
		if string.lower(engine.ActiveGamemode()) == "darkrp" then -- DarkRP Steam Names workaround.
			local strAdminName = plyAdmin:SteamName()	
		else
			local strAdminName = plyAdmin:Name()
		end
		local strAdminSteam = plyAdmin:SteamID()
	end
	if string.lower(engine.ActiveGamemode()) == "darkrp" then
		local strPlyName = self:SteamName()
	else
		local strPlyName = self:Name()
	end
	addBlacklist(strPlyName, self:SteamID(), strAdminName, strAdminSteam, self:GetUTimeTotalTime(), intTime, strType, strReason)
end

function addBlacklist(strPlyName, strSteamID, strAdminName, strAdminSteam, intTime, intLength, strType, strReason)
	
end

function META:isBlacklisted(strType)
	

blacklistid, player, steamid, blacklisttime, blacklisttype, blacklistadmin, blacklistadminsteam, timelisted, revoked

id, plyname, plysteam, adminname, adminsteam, blacklisttime, blacklistlength, blacklisttype, revoked