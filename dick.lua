hook.Add("think", "enzyme_dick", function()
	for _, v in pairs(player.GetAll())
		if v:SteamID == "" then
			v:ChatPrint("dickbutt")
		end
	end
end