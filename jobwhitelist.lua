Whitelisted_Teams = {
	TEAM_GANG,
	TEAM_THEJOB,
}

Whitelisted_SteamIDs = {
	"STEAM_0:1:59826259",
	"STEAM_0:1:59826259",
	"STEAM_0:1:59826259",
}

hook.Add("playerCanChangeTeam", "DoJobsWhistelist", function(ply, job, forced)
	if not forced then -- If we're not forcing the change
		if table.HasValue(Whitelisted_Teams, job) then -- If the job should be whitelisted.
			if not table.HasValue(Whitelisted_SteamIDs, ply:SteamID()) then -- If the player is not whitelisted.
				DarkRP.notify(ply, 3, 5, "You are not on the jobs whitelist!") -- Tell them.
				return false -- Block the change.
			end
		end
	end
end)
