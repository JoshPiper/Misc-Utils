if SERVER then
	resource.AddFile( "resource/fonts/Lato-Light.ttf" )
	resource.AddFile( "resource/fonts/Montserrat-Bold.ttf" )
	resource.AddFile( "resource/fonts/Montserrat-Regular.ttf" )
	resource.AddFile( "materials/bleur_scoreboard/mute.png" )
	return 
end

surface.CreateFont( "bleur_scoreboard48bold", {
	font = "Montserrat", 
	size = 48, 
	weight = 700, 
	antialias = true, 
	additive = true,
})

surface.CreateFont( "bleur_scoreboard14bold", {
	font = "Montserrat", 
	size = 14, 
	weight = 700, 
	antialias = true, 
	additive = true,
})

surface.CreateFont( "bleur_scoreboard12", {
	font = "Montserrat", 
	size = 12, 
	weight = 100, 
	antialias = true, 
	additive = true,
})
/*---------------------------------------------------------------------------
	CONFIG
---------------------------------------------------------------------------*/
local config = {}
config.width = 1000				--if you want this one to scale with resolution (not advised), set this to ScrW() - distance_from_edges
config.height = ScrH() - 100	--height
config.header = "RuthlessRP"	--text on top of scoreboard
config.footer = "Keep on trucking"	--text in the bottom of the scoreboard
config.defaultSortingTab = 1	--number of tab to sort by default
config.updateDelay = 0.5 		--update delay in seconds
config.showPlayerNum = true		--Whether to show or not player count

local groups = {}
groups["owner" ] = "Owner"
groups["superadmin"] = "Supervising Administrator"
groups["admin"] = "Administrator"
groups["moderator"] = "Moderator"
groups["donator"] = "Donator"
groups["user"] = "User"

groups["sysadmin"] = "Systems Administrator"


local theme = {}
theme.top 		= Color( 30, 30, 30, 255 )
theme.bottom 	= Color( 30, 30, 30, 255 )
theme.tab	 	= Color( 230, 230, 230, 255 )
theme.footer 	= Color( 200, 245, 100 )
theme.header 	= Color( 255, 125, 125 )
--[[/*---------------------------------------------------------------------------
	TABS
	
	Explanation:
	name - 	self-explanatory
	size - 	fraction of tab area that it should take, number between 0 and 1
			where 1 means whole tab area and 0 means none 
	fetch -	this is just a function that returns what to put in certain tab,
			very useful if you want developers to add a tab for their addon to
			the scoreboard
	liveUpdate 	- 	set to true if you want values to update for the tab while
					scoreboard is open
	fetchColor 	-	this function fetches for color, useful for different
					rank colors and whatnot
---------------------------------------------------------------------------*/

/*---------------------------------------------------------------------------
	Below you can find 2 packs of premade tabs
	1# - DarkRP
	2# - TTT
	Uncomment the ones you want to use, don't use both!
---------------------------------------------------------------------------*/]]--
local tabs = {}
tabs[ 0 ] = { name = "Steam Name (RP Name)", 		size = 0.25,	liveUpdate = false,		fetch = function( ply ) local retVal = ply:SteamName().." ("..ply:Nick()..")" return retVal end }
tabs[ 1 ] = { name = "Job",			size = 0.25,	liveUpdate = false,		fetch = function( ply ) return ply:getJobTable().name end }
tabs[ 2 ] = { name = "Hours",		size = 0.1,		liveUpdate = false,		fetch = function( ply ) return math.floor(ply:GetUTimeTotalTime()/3600) end }
tabs[ 3 ] = { name = "Rank",		size = 0.1,		liveUpdate = false,		fetch = function( ply ) return groups[ ply:GetUserGroup() ] or ply:GetUserGroup() end }
tabs[ 4 ] = { name = "Kills", 		size = 0.1,		liveUpdate = false,		fetch = function( ply ) return ply:Frags() end }
tabs[ 5 ] = { name = "Deaths", 		size = 0.1,		liveUpdate = false,		fetch = function( ply ) return ply:Deaths() end }
tabs[ 6 ] = { name = "Ping", 		size = 0.1,		liveUpdate = true, 		fetch = function( ply ) return ply:Ping() end }

--local tabs = {}
--tabs[ 0 ] = { name = "Name", 		size = 0.3,		liveUpdate = false, 	fetch = function( ply ) return ply:Nick() end }
--tabs[ 1 ] = { name = "Score",		size = 0.1,		liveUpdate = false, 	fetch = function( ply ) return ply:Frags() end }
--tabs[ 2 ] = { name = "Rank",		size = 0.2,		liveUpdate = false, 	fetch = function( ply ) return groups[ ply:GetUserGroup() ] or ply:GetUserGroup() end }
--tabs[ 3 ] = { name = "Deaths", 	size = 0.125,	liveUpdate = false, 	fetch = function( ply ) return ply:Deaths() end }
--tabs[ 4 ] = { name = "Karma", 	size = 0.125,	liveUpdate = false, 	fetch = function( ply ) return math.floor( ply:GetBaseKarma() ) end }
--tabs[ 5 ] = { name = "Ping", 		size = 0.125,	liveUpdate = true, 		fetch = function( ply ) return ply:Ping() end }

if not tabs then
	error( "Bleur Scoreboard: You haven't enabled ANY tabs! Open bleur_scoreboard.lua and remove comment lines to enable certain tabs", 0 )
	return false
end

local ulxFuncs = {} 
ulxFuncs[ 'Fun' ] = 
{
	'slap',
	'whip',
	'slay',
	'sslay',
	'ignite',
	'freeze',
	'god',
	'hp',
	'armor',
	'cloak',
	'blind',
	'jail',
	'jailtp',
	'ragdoll',
	'maul',
	'strip',
	'unfreeze',
}
	
ulxFuncs[ 'User Management' ] = 
{
	'adduser',
	'removeuser',
	'userallow',
	'userdeny',
}
	
ulxFuncs[ 'Utility' ] = 
{
	'kick',
	'ban',
	'noclip',
	'spectate',
}
	
ulxFuncs[ 'Chat' ] = 
{
	'gimp',
	'mute',
	'gag',
}
	
ulxFuncs[ 'Teleport' ] = 
{
	'bring',
	'goto',
	'send',
	'teleport',
}
/*---------------------------------------------------------------------------
	END OF CONFIG, DON'T TOUCH ANYTHING BELOW
---------------------------------------------------------------------------*/
local tabArea = config.width - 35 -- preserve 35px from left edge for avatar
tabArea = tabArea - 30 -- preserve 30px from right edge for mute button
for i, tab in pairs( tabs ) do
	local prev = tabs[ i - 1 ] or { pos = 0, size = 0 }
	tabs[ i ].pos = prev.pos + prev.size
	tabs[ i ].size = tabArea * tab.size
end

local function fetchRowColor( ply )
	if engine.ActiveGamemode() == "terrortown" then
		if ply:IsTraitor() then
			return Color( 255, 0, 0 )
		elseif ply:IsDetective() then
			return Color( 0, 0, 255 )
		else
			return Color( 0, 190, 0 )
		end
	else
		return team.GetColor( ply:Team() )
	end
end
/*---------------------------------------------------------------------------
	VISUALS
---------------------------------------------------------------------------*/
local blur = Material( "pp/blurscreen" )
local function drawBlur( x, y, w, h, layers, density, alpha )
	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, layers do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		render.SetScissorRect( x, y, x + w, y + h, true )
			surface.DrawTexturedRect( 0, 0, ScrW(), ScrH() )
		render.SetScissorRect( 0, 0, 0, 0, false )
	end
end

local function drawPanelBlur( panel, layers, density, alpha )
	local x, y = panel:LocalToScreen(0, 0)

	surface.SetDrawColor( 255, 255, 255, alpha )
	surface.SetMaterial( blur )

	for i = 1, 3 do
		blur:SetFloat( "$blur", ( i / layers ) * density )
		blur:Recompute()

		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect( -x, -y, ScrW(), ScrH() )
	end
end

local function drawLine( startPos, endPos, color )
	surface.SetDrawColor( color )
	surface.DrawLine( startPos[1], startPos[2], endPos[1], endPos[2] )
end

local function drawRectOutline( x, y, w, h, color )
	surface.SetDrawColor( color )
	surface.DrawOutlinedRect( x, y, w, h )
end
/*---------------------------------------------------------------------------
	PANEL
---------------------------------------------------------------------------*/
local PANEL = {}
function PANEL:Init()
	self:SetSize( 100, 50 )
	self:Center()
	self.color = Color( 0, 0, 0, 200 )
	self.ply = nil
end

function PANEL:OnMousePressed()
	local ply = self.ply

	self.menu = vgui.Create( "DMenu" )
	self.menu:SetPos( gui.MouseX(), gui.MouseY() )
	self.menu.categories = {}
	for category, cmds in pairs( ulxFuncs ) do
		self.menu.categories[ category ] = self.menu:AddSubMenu( category )
		for i, cmd in pairs ( cmds ) do
			self.menu.categories[ category ]:AddOption( cmd, function()
				local argMenu = vgui.Create( "EditablePanel" )
				argMenu:SetSize( 300, 50 )
				argMenu:Center()
				argMenu:MakePopup()
				argMenu.Paint = function()
					draw.RoundedBox( 0, 0, 0, argMenu:GetWide(), argMenu:GetTall(), Color( theme.top.r, theme.top.g, theme.top.b, 235 ) )
					drawRectOutline( 0, 0, argMenu:GetWide(), argMenu:GetTall(), Color( theme.top.r, theme.top.g, theme.top.b, 235 ) )
					draw.SimpleText( "Specify arguments for command '" .. cmd .. "'", "bleur_scoreboard12", argMenu:GetWide() / 2, 5, Color( theme.header.r, theme.header.g, theme.header.b, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_BOTTOM )
				end

				local argEntry = vgui.Create( "DTextEntry", argMenu )
				argEntry:SetSize( 280, 20 )
				argEntry:AlignBottom( 5 )
				argEntry:CenterHorizontal()
				argEntry.OnEnter = function()
					if ply:IsValid() then
						LocalPlayer():ConCommand( "ulx " .. cmd .. " \"" .. ply:Nick() .. "\" " .. argEntry:GetValue() )
					end
					argMenu:Remove()
				end
			end )
		end
	end
end

function PANEL:Paint( w, h )
	draw.RoundedBox( 0, 0, 0, w, h, Color( self.color.r, self.color.g, self.color.b, 170 ) )
	drawRectOutline( 0, 0, w, h, Color( self.color.r, self.color.g, self.color.b, 180 ) )
end
vgui.Register( "bleur_row", PANEL, "EditablePanel" )

local PANEL = {}
function PANEL:Init()
	self:SetSize( config.width, config.height )
	self:Center()
	self.sortAsc = false

	self.alphaMul = 0

	for i, tab in pairs( tabs ) do
		surface.SetFont( "bleur_scoreboard14bold" )
		local width, height = surface.GetTextSize( tab.name )
		local tabLabel = vgui.Create( "DLabel", self )
		tabLabel:SetFont( "bleur_scoreboard14bold" )
		tabLabel:SetColor( Color( theme.tab.r, theme.tab.g, theme.tab.b, theme.tab.a ) )
		tabLabel:SetText( tab.name )
		tabLabel:SizeToContents()
		tabLabel:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 83 )
		tabLabel:SetMouseInputEnabled( true )
		function tabLabel:DoClick()
			self:GetParent().sortAsc = !self:GetParent().sortAsc
			self:GetParent():populate( tab.name )
		end
	end
end

function PANEL:Paint( w, h )
	self.alphaMul = Lerp( 0.1, self.alphaMul, 1 )

	drawPanelBlur( self, 3, 6, 255 )
	draw.RoundedBox( 0, 0, 75, w, h - 100, Color( 0, 0, 0, 150 * self.alphaMul ) )
	drawRectOutline( 0, 0, w, h, Color( 0, 0, 0, 75 * self.alphaMul  ) )
	//Top bar
	draw.RoundedBoxEx( 4, 0, 0, w, 75, Color( theme.top.r, theme.top.g, theme.top.b, theme.top.a * self.alphaMul ), true, true, false, false )
	draw.SimpleText( config.header, "bleur_scoreboard48bold", w / 2, 37.5255, Color( theme.header.r, theme.header.g, theme.header.b, theme.header.a * self.alphaMul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
	if config.showPlayerNum then
		draw.SimpleText( "Players: " .. #player.GetAll() .. "/" .. game.MaxPlayers(), "bleur_scoreboard14bold", 5, 60 )
	end
	//Tabs
	draw.RoundedBox( 0, 0, 76, tabArea + 65, 25, Color( 0, 0, 0, 220 * self.alphaMul ) )
	//Bottom bar
	draw.RoundedBoxEx( 4, 0, h - 25, w, 25, Color( theme.bottom.r, theme.bottom.g, theme.bottom.b, theme.bottom.a * self.alphaMul ), false, false, true, true )
	--draw.SimpleText( config.footer, "bleur_scoreboard12", w / 2, h - 12.5, Color( theme.footer.r, theme.footer.g, theme.footer.b, theme.footer.a * self.alphaMul ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
end


--{ user_id }


function PANEL:populate( sorting )
	self.scrollPanel = vgui.Create( "DScrollPanel", self )
	self.scrollPanel:SetPos( 1, 102 )
	self.scrollPanel:SetSize( self:GetWide() + 18, self:GetTall() - 128 )

	if self.list then
		self.list:Remove()
	end

	self.list = vgui.Create( "DIconLayout", self.scrollPanel )
	self.list:SetSize( self.scrollPanel:GetWide() - 20, self.scrollPanel:GetTall() )
	self.list:SetPos( 1, 0 )
	self.list:SetSpaceY( 1 )

	local players = {}
	for i, ply in pairs( player.GetAll() ) do
		players[ i ] = { ply = ply }
		for _, tab in pairs( tabs ) do
			players[ i ][ tab.name ] = tab.fetch( ply )
		end
	end
	table.SortByMember( players, sorting or tabs[ 0 ].name, self.sortAsc )

	for i, data in pairs( players ) do
		local row = vgui.Create( "bleur_row", self.list )
		row:SetSize( self.list:GetWide() - 2, 30 )
		row.color = fetchRowColor( data.ply )
		row.ply = data.ply

		row.avatar = vgui.Create( "AvatarImage", row )
		row.avatar:SetSize( 26, 26 )
		row.avatar:SetPos( 2, 2 )
		row.avatar:SetPlayer( data.ply, 64 )

		if row.ply ~= LocalPlayer() then
			row.mute = vgui.Create( "DImageButton", row )
			row.mute:SetSize( 16, 16 )
			row.mute:SetPos( row:GetWide()  - 31, 8 )
			row.mute:SetImage( "bleur_scoreboard/mute.png" )
			row.mute:SetColor( Color( 0, 0, 0 ) )
			if row.ply:IsMuted() then
				row.mute:SetColor( Color( 255, 0, 0 ) )
			end

			function row.mute:DoClick()
				local row = self:GetParent()
				row.ply:SetMuted( !row.ply:IsMuted() )

				self:SetColor( Color( 0, 0, 0 ) )
				if row.ply:IsMuted() then
					self:SetColor( Color( 255, 0, 0 ) )
				end
			end
		end

		for i, tab in pairs( tabs ) do
			surface.SetFont( "bleur_scoreboard12" )
			local width, height = surface.GetTextSize( data[ tab.name ] or "" )
			local info = vgui.Create( "DLabel", row )
			info:SetFont( "bleur_scoreboard12" )
			info:SetColor( Color( 255, 255, 255 ) )
			info:SetText( data[ tab.name ] or "ERROR" )
			info:SizeToContents()
			info:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 0 )
			info:CenterVertical()
			if tab.fetchColor then
				info:SetColor( tab.fetchColor( ply ) )
			end

			if tab.liveUpdate then
				function info:Think()
					self.lastThink = self.lastThink or CurTime()
					if self.lastThink + config.updateDelay < CurTime() then
						surface.SetFont( "bleur_scoreboard12" )
						local width, height = surface.GetTextSize( data[ tab.name ] or "" )
						self:SetFont( "bleur_scoreboard12" )
						self:SetColor( Color( 255, 255, 255 ) )
						if row.ply:IsValid() then
							self:SetText( tab.fetch( row.ply ) or "ERROR" )
						else
							self:SetText( "ERROR" )
						end
						self:SizeToContents()
						self:SetPos( 35 + tab.pos + ( tab.size / 2 ) - ( width / 2 ), 0 )
						self:CenterVertical()

						self.lastThink = CurTime()
					end
				end
			end
		end
	end
end
vgui.Register( "bleur_scoreboard", PANEL, "EditablePanel" )
/*---------------------------------------------------------------------------
	FUNCTIONALITY - DON'T TOUCH ANYTHING BELOW!
---------------------------------------------------------------------------*/
timer.Simple( 0.1, function()
	for i, v in pairs( hook.GetTable()["ScoreboardShow"] or {} )do
		hook.Remove( "ScoreboardShow", i)
	end

	for i, v in pairs( hook.GetTable()["ScoreboardHide"] or {} )do
		hook.Remove( "ScoreboardHide", i)
	end

	local scoreboard = nil
	hook.Add( "ScoreboardShow", "bleur_scoreboard_show", function()
		gui.EnableScreenClicker( true )

		scoreboard = vgui.Create( "bleur_scoreboard" )
		scoreboard:populate( tabs[ config.defaultSortingTab ].name )
		return true
	end )

	hook.Add( "ScoreboardHide", "bleur_scoreboard_hide", function()
		gui.EnableScreenClicker( false )

		scoreboard:Remove()
		return true
	end )
end )