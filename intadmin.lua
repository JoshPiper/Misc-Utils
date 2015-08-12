intadmin = {}
intadmin.name = "Internet's Administration"
intadmin.version = "0.0.0.2"

intadmin.acl = {}
intadmin.acl.plylist = {}
-- intadmin.acl.plylist[ply][tag][access]
-- intadmin.acl.grouplist[group][tag][access]

intadmin.acl.grouplist = {}
intadmin.acl.grouplist.superadmin = {}
intadmin.acl.grouplist.superadmin.name = "Super-Administrator"
intadmin.acl.grouplist.superadmin.playerlist = {"STEAM_0:1:35377420"}
intadmin.acl.grouplist.superadmin.accesslist = {kick = "ALLOW", ban = "ALLOW", unban = "ALLOW", mute = "ALLOW", gag = "ALLOW"}

function intadmin.acl.query(ply, access)
	local grantAccess = 0
	local groups, group
	-- See if the group has access.
	for _, group in pairs(intadmin.acl.grouplist) do
		if ply:SteamID() in group.playerlist then
			for tag, var in pairs(group.accesslist) do
				if tag == access then
					if group.accesslist.tag == "ALLOW" then
						grantAccess = 1
					elseif group.accesslist.tag == "DENY" then
						grantaccess = -1
					end
				end
			end
		end
	end
end
		-- for group in groups do
			-- if ply.group == group then
			-- if not type(group[access]) == nil then
				-- if group[access] == "ALLOW" then
					-- grantAccess = 1
				-- elseif group[access] = "DENY" then
					-- grantAccess = -1
				-- end
			-- end
		-- end
	-- end
			
	-- for _, plys in pairs(intadmin.acl.list) do
		-- if plys == ply then
			-- for i, v in pairs(intadmin.acl.list[v]) do
				-- if i == tag then
					-- if v == "DENY" then
						-- denyAccess = true
						-- grantAccess = false
						-- end
				-- end
			-- end
		-- end
	-- end
-- end
-- end