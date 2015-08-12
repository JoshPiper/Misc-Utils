-- ULX Module: Vote Slaying
-- Made For: RelentlessRP
-- Made By: Dr. Internet
-- Version: 1.0
-- Author Contact: Steam.
-- Description: ULX Module with various functions for use with chat.
-- Includes:
--		Voteslay
--		#Votegag
--		#Votemute

local CATEGORY_NAME = "Voting"

local function voteslayDone2( t, target, time, ply, reason )
	local shouldslay = false
	if t.results[ 1 ] and t.results [ 1 ] > 0 then
		shouldslay = true
		if reason then
			ulx.fancyLogAdmin( ply, "#A approved the voteslay against #T (Reason: #s)", target, reason )
		else
			ulx.fancyLogAdmin( ply, "#A approved the voteslay against #T", target )
		end
	else
		ulx.fancyLogAdmin( ply,  "#A denied the voteslay against #T", target )
	end
	if shouldslay then
			target:Kill()
	end
end

local function voteslayDone(data, target, time, ply, reason)
	local results = data.results
	local winner
	local winnernum = 0
	for id, numvotes in pairs( results ) do
		if numvotes > winnernum then
			winner = id
			winnernum = numvotes
		end
	end
	
	local ratioNeeded = GetConVarNumber( "ulx_voteslaySuccessratio" )
	local minVotes = GetConVarNumber( "ulx_voteslayMinvotes" )
	local message
	if winner ~= 1 or winnernum < minVotes or winnernum / data.voters < ratioNeeded then
		message = "Vote results: User will not be slayed. (" .. (results[ 1 ] or "0") .. "/" .. data.voters .. ")"
	else
		message = "Vote results: User will now be slayed, pending approval. (" .. winnernum.."/"..data.voters..")"
		ulx.doVote("Accept result and slay "..target:Nick().."?", {"Yes", "No"}, voteslayDone2, 30000, {ply}, true, target, time, ply, reason)
	end
	
	ULib.tsay( _, str )
	ulx.logString( str )
	if game.IsDedicated() then Msg( str .. "\n" ) end
end

function ulx.voteslay(calling_ply, target_ply, reason)
	if voteInProgress then
		ULib.tsayError( calling_ply, "There is already a vote in progress. Please wait for the current one to end.", true )
		return
	end
	local voteMessage = "Slay "..target_ply:Nick().."?"
	if reason and reason ~= "" then
		voteMessage = voteMessage.." ("..reason..")"
	end
	ulx.doVote(voteMessage, { "Yes", "No" }, voteslayDone, _, _, _, target_ply, time, calling_ply, reason)
	ulx.fancyLogAdmin(calling_ply, "#A started a voteslay against #T", target_ply)
end

local voteslay = ulx.command( CATEGORY_NAME, "ulx voteslay", ulx.voteslay, "!voteslay" )
voteslay:addParam{ type=ULib.cmds.PlayerArg }
voteslay:addParam{ type=ULib.cmds.StringArg, hint="reason", ULib.cmds.optional, ULib.cmds.takeRestOfLine}
voteslay:defaultAccess( ULib.ACCESS_ADMIN )
voteslay:help( "Starts a public slay vote against target." )

if SERVER then ulx.convar( "voteslaySuccessratio", "0.6", _, ULib.ACCESS_ADMIN ) end -- The ratio needed for a voteslay to succeed
if SERVER then ulx.convar( "voteslayMinvotes", "1", _, ULib.ACCESS_ADMIN ) end -- Minimum votes needed for voteslay