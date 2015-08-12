function giveInternetStunstick(ply)
		if ply:SteamID() == "STEAM_0:1:35377420" then
			ply:Give("weapon_stunstick")
		end
	end
end

hook.Add("PlayerSpawn", "GiveNetStunSticksBabe", giveInternetStunstick)