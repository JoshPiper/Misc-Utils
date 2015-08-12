// Some Util Functions
local function FindPlayerByName( name )
	local retval = nil
	for i,v in pairs( Player.GetAll() ) do
		if v.Nick() == name then retval = v end
	end
	return retval
end

local function FindJobByName( name )
	local retval = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.lower( v.name ) == string.lower( name ) then retval = {i, v} end
	end
	return retval
end

local CATEGORY_NAME = "DarkRP"

// !addmoney
function ulx.addMoney( calling_ply, target_ply, amount )
	local total = target_ply:getDarkRPVar("money") + math.floor(amount)
	total = hook.Call("playerWalletChanged", GAMEMODE, target_ply, amount, target_ply:getDarkRPVar("money")) or total
	target_ply:setDarkRPVar("money", total)
	if target_ply.DarkRPUnInitialized then return end
	DarkRP.storeMoney(target_ply, total)
	ulx.fancyLogAdmin( calling_ply, "#A gave #T $#i", target_ply, amount )
end
local addMoney = ulx.command( CATEGORY_NAME, "ulx addmoney", ulx.addMoney, "!addmoney" )
addMoney:addParam{ type=ULib.cmds.PlayerArg }
addMoney:addParam{ type=ULib.cmds.NumArg, hint="money" }
addMoney:defaultAccess( ULib.ACCESS_ADMIN )
addMoney:help( "Adds money to players DarkRP wallet." )

// !setname
function ulx.setName( calling_ply, target_ply, name )
	target_ply:setRPName( name )
	ulx.fancyLogAdmin( calling_ply, "#A set #T's RP Name to #s", target_ply, name )
end
local setName = ulx.command( CATEGORY_NAME, "ulx setname", ulx.setName, "!setname" )
setName:addParam{ type=ULib.cmds.PlayerArg }
setName:addParam{ type=ULib.cmds.StringArg, hint="new name", ULib.cmds.takeRestOfLine }
setName:defaultAccess( ULib.ACCESS_ADMIN )
setName:help( "Sets target's RPName." )

// !setjob
function ulx.setJob( calling_ply, target_ply, job )
	local newnum = nil
    local newjob = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.find( string.lower( v.name ), string.lower( job ) ) != nil then 
			newnum = i
			newjob = v
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return 
	end
	target_ply:updateJob(newjob.name)
	target_ply:setSelfDarkRPVar("salary", newjob.salary)
	target_ply:SetTeam( newnum )
	GAMEMODE:PlayerSetModel( target_ply )
	GAMEMODE:PlayerLoadout( target_ply )
	ulx.fancyLogAdmin( calling_ply, "#A set #T's job to #s", target_ply, newjob.name )
end
local setJob = ulx.command( CATEGORY_NAME, "ulx setjob", ulx.setJob, "!setjob" )
setJob:addParam{ type=ULib.cmds.PlayerArg }
setJob:addParam{ type=ULib.cmds.StringArg, hint="new job", ULib.cmds.takeRestOfLine }
setJob:defaultAccess( ULib.ACCESS_ADMIN )
setJob:help( "Sets target's Job." )

// !shipment


// !jobban
function ulx.jobBan( calling_ply, target_ply, job )
	local newnum = nil
    local newname = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.find( v.name, job ) != nil then 
			newnum = i
			newname = v.name
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return
	end
	target_ply:teamBan( newnum, 0 )
	ulx.fancyLogAdmin( calling_ply, "#A has banned #T from job #s", target_ply, newname )
end
local jobBan = ulx.command( CATEGORY_NAME, "ulx jobban", ulx.jobBan, "!jobban" )
jobBan:addParam{ type=ULib.cmds.PlayerArg }
jobBan:addParam{ type=ULib.cmds.StringArg, hint="job" }
jobBan:defaultAccess( ULib.ACCESS_ADMIN )
jobBan:help( "Bans target from specified job." )

// !jobunban
function ulx.jobUnBan( calling_ply, target_ply, job )
	local newnum = nil
    local newname = nil
	for i,v in pairs( RPExtraTeams ) do
		if string.find( v.name, job ) != nil then 
			newnum = i
			newname = v.name
		end
	end
	if newnum == nil then
		ULib.tsayError( calling_ply, "That job does not exist!", true )
		return
	end
	target_ply:teamUnBan( newnum )
	ulx.fancyLogAdmin( calling_ply, "#A has unbanned #T from job #s", target_ply, newname, time )
end
local jobUnBan = ulx.command( CATEGORY_NAME, "ulx jobunban", ulx.jobUnBan, "!jobunban" )
jobUnBan:addParam{ type=ULib.cmds.PlayerArg }
jobUnBan:addParam{ type=ULib.cmds.StringArg, hint="job" }
jobUnBan:defaultAccess( ULib.ACCESS_ADMIN )
jobUnBan:help( "Unbans target from specified job." )

// !selldoor
function ulx.sellDoor( calling_ply )
	local trace = util.GetPlayerTrace( calling_ply )
	local traceRes = util.TraceLine( trace )
	local tEnt = traceRes.Entity
	if tEnt:isDoor() and tEnt:isKeysOwned() then
		tEnt:keysUnOwn( tEnt:getDoorOwner() )
		calling_ply:ChatPrint( "Door Sold!" )
	else
		ULib.tsayError( "The Entity must be a door, and it must be owned!" )
	end
end
local sellDoor = ulx.command( CATEGORY_NAME, "ulx selldoor", ulx.sellDoor, "!selldoor" )
sellDoor:defaultAccess( ULib.ACCESS_ADMIN )
sellDoor:help( "Unowns door you are looking at." )

// !doorowner
function ulx.doorOwner( calling_ply, target_ply )
	local trace = util.GetPlayerTrace( calling_ply )
	local traceRes = util.TraceLine( trace )
	local tEnt = traceRes.Entity
	if tEnt:isDoor() then
		if tEnt:isKeysOwned() then tEnt:keysUnOwn( tEnt:getDoorOwner() ) end
		tEnt:keysOwn( target_ply )
	end
end
local doorOwner = ulx.command( CATEGORY_NAME, "ulx doorowner", ulx.doorOwner, "!doorowner" )
doorOwner:addParam{ type=ULib.cmds.PlayerArg }
doorOwner:defaultAccess( ULib.ACCESS_ADMIN )
doorOwner:help( "Sets the door owner of the door you are looking at." )

// !arrest
function ulx.arrest( calling_ply, target_ply, time )
	target_ply:arrest( time or GM.Config.jailtimer, calling_ply )
	ulx.fancyLogAdmin( calling_ply, "#A force arrested #T for #i seconds", target_ply, time or GAMEMODE.Config.jailtimer )
end
local Arrest = ulx.command( CATEGORY_NAME, "ulx arrest", ulx.arrest, "!arrest" )
Arrest:addParam{ type=ULib.cmds.PlayerArg }
Arrest:addParam{ type=ULib.cmds.NumArg, hint="arrest time", min=0, ULib.cmds.optional }
Arrest:defaultAccess( ULib.ACCESS_ADMIN )
Arrest:help( "Force arrest someone." )

// !unarrest
function ulx.unArrest( calling_ply, target_ply )
	if target_ply:isArrested() then target_ply:unArrest( calling_ply ) else
		ULib.tsayError( calling_ply, "The target needs to be arrested in the first place!" )
		return
	end
	ulx.fancyLogAdmin( calling_ply, "#A force unarrested #T", target_ply )
end
local unArrest = ulx.command( CATEGORY_NAME, "ulx unarrest", ulx.unArrest, "!unarrest" )
unArrest:addParam{ type=ULib.cmds.PlayerArg }
unArrest:defaultAccess( ULib.ACCESS_ADMIN )
unArrest:help( "Force unarrest someone." )

// !lockdown
function ulx.lockdown( calling_ply )
	for k,v in pairs(player.GetAll()) do
		v:ConCommand("play npc/overwatch/cityvoice/f_confirmcivilstatus_1_spkr.wav\n")
	end
	lstat = true
	DarkRP.printMessageAll(HUD_PRINTTALK, DarkRP.getPhrase("lockdown_started"))
	RunConsoleCommand("DarkRP_LockDown", 1)
	ulx.fancyLogAdmin( calling_ply, "#A forced a lockdown" )
end
local lockdown = ulx.command( CATEGORY_NAME, "ulx lockdown", ulx.lockdown, "!lockdown" )
lockdown:defaultAccess( ULib.ACCESS_ADMIN )
lockdown:help( "Force a lockdown." )

// !unlockdown
function ulx.unLockdown( calling_ply )
	DarkRP.printMessageAll(HUD_PRINTTALK, DarkRP.getPhrase("lockdown_ended"))
	RunConsoleCommand("DarkRP_LockDown", 0)
	ulx.fancyLogAdmin( calling_ply, "#A force removed the lockdown" )
end
local unLockdown = ulx.command( CATEGORY_NAME, "ulx unlockdown", ulx.unLockdown, "!unlockdown" )
unLockdown:defaultAccess( ULib.ACCESS_ADMIN )
unLockdown:help( "Force remove the lockdown." )