function ulx.checkNoclip(calling_ply, desired_state)
	if GetConVar("sbox_noclip"):GetInt() ~= 0 then
		return true
	end
	if ULib.ucl.query(calling_ply, "ulx noclip") then
		return true
	end
	if desired_state == false then
		return true
	end
end

hook.Add("PlayerNoClip", "CheckNoclipULX", ulx.checkNoclip)