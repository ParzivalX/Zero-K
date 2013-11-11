function gadget:GetInfo()	return {		name 	= "Shield Link",		desc	= "Nearby shields on the same ally team share charge to and from each other. Working Version",		author	= "lurker",		date	= "2009",		license	= "Public domain",		layer	= 0,		enabled	= true	--	loaded by default?	}endlocal version = 1.16-- CHANGELOG--	2009-5-24: CarRepairer: Added graphic lines to show links of shields (also shows links of enemies' visible shields, can remove if desired).--	2009-5-30: CarRepairer: Lups graphic lines, fix for 0.79.1 compatibility.--	2009-9-15: Licho: added simple fast graph lines----------------------------------------------------------------------------------------------------------------------------------------------------------------local spGetUnitPosition		= Spring.GetUnitPositionlocal spGetUnitViewPosition = Spring.GetUnitViewPositionlocal spGetUnitDefID		= Spring.GetUnitDefIDlocal spGetUnitTeam			= Spring.GetUnitTeamlocal spGetUnitAllyTeam		= Spring.GetUnitAllyTeamlocal spGetUnitIsStunned	= Spring.GetUnitIsStunnedlocal spGetUnitIsActive		= Spring.GetUnitIsActivelocal spGetUnitShieldState	= Spring.GetUnitShieldStatelocal spSetUnitShieldState	= Spring.SetUnitShieldStatelocal spGetTeamInfo			= Spring.GetTeamInfoif gadgetHandler:IsSyncedCode() thenlocal NO_LINK = {}local shieldTeams = {}shieldConnections = {}_G.shieldConnections = shieldConnectionslocal linkFirst_Count = { --set maximum link desired, NIL or empty mean "no limit"	[UnitDefNames["shieldfelon"].id] = 5,	[UnitDefNames["core_spectre"].id] = 5, --aspis	[UnitDefNames["corjamt"].id] = 5, --aegis}local linkFirst_Sequence = { --set which unit to link first, first unit get more link	[1] = UnitDefNames["shieldfelon"].id,	[2] = UnitDefNames["core_spectre"].id, --aspis	[3] = UnitDefNames["corjamt"].id, --aegis}local linkFirstSequenceLen = #linkFirst_Sequencefunction gadget:Initialize()	for _,unitID in ipairs(Spring.GetAllUnits()) do		local teamID = spGetUnitTeam(unitID)		local unitDefID = spGetUnitDefID(unitID)		gadget:UnitCreated(unitID, unitDefID, teamID)	endendfunction gadget:UnitCreated(unitID, unitDefID)	-- only count finished buildings	local stunned_or_inbuild, stunned, inbuild = spGetUnitIsStunned(unitID)	if stunned_or_inbuild ~= nil and inbuild then		return	end	local ud = UnitDefs[unitDefID]	if ud.shieldWeaponDef then		local shieldWep = WeaponDefs[ud.shieldWeaponDef]		--local x,y,z = spGetUnitPosition(unitID)		local allyTeam = spGetUnitAllyTeam(unitID)		shieldTeams[allyTeam] = shieldTeams[allyTeam] or {}		local shieldUnit = {			shieldPower  = shieldWep.shieldPower,			shieldRadius = shieldWep.shieldRadius,			shieldRegen  = shieldWep.shieldPowerRegen,			unitDefID    = unitDefID,			linkFirst	 = linkFirst_Count[unitDefID],			link         = NO_LINK,  --real table is created in each UpdateAllLinks() call			neighbor     = {},			numNeighbors = 0,		}		shieldTeams[allyTeam][unitID] = shieldUnit	endendfunction gadget:UnitFinished(unitID, unitDefID, unitTeam)	gadget:UnitCreated(unitID, unitDefID)endfunction gadget:UnitDestroyed(unitID, unitDefID)	local ud = UnitDefs[unitDefID]	local allyTeam = spGetUnitAllyTeam(unitID)	if ud.shieldWeaponDef and shieldTeams[allyTeam] then		local shieldUnit = shieldTeams[allyTeam][unitID]		shieldTeams[allyTeam][unitID] = nil		if shieldUnit then			shieldUnit.link[unitID] = nil			shieldUnit.link = NO_LINK  --help GC by removing pointer to old table		end	endendfunction gadget:UnitGiven(unitID, unitDefID, unitTeam, oldTeam)	local ud = UnitDefs[unitDefID]	local _,_,_,_,_,oldAllyTeam = spGetTeamInfo(oldTeam)	if ud.shieldWeaponDef then		local shieldUnit		if shieldTeams[oldAllyTeam] and shieldTeams[oldAllyTeam][unitID] then			shieldUnit = shieldTeams[oldAllyTeam][unitID]			shieldTeams[oldAllyTeam][unitID] = nil			shieldUnit.link[unitID] = nil			shieldUnit.link = NO_LINK		end					local allyTeam = spGetUnitAllyTeam(unitID)		shieldTeams[allyTeam] = shieldTeams[allyTeam] or {}		shieldTeams[allyTeam][unitID] = shieldUnit --Note: wont be problem when NIL because is always filled with new value when unit finish (ie: when unit captured before finish) 	endend-- check if working unit so it can be used for shield linklocal function isEnabled(unitID)	local stunned_or_inbuild = spGetUnitIsStunned(unitID)	if stunned_or_inbuild or (Spring.GetUnitRulesParam(unitID, "disarmed") == 1) then		return false	end	local active = spGetUnitIsActive(unitID)	if active ~= nil then		return active	else		return true	endendlocal function AdjustLinks(allyTeam, unitList, updatePrioritized, targetDefID)        local sc = shieldConnections[allyTeam]		local cnt = #sc + 1		for ud1,shieldUnit1 in pairs(unitList) do			repeat --Is clever hax for making "break" behave like "continue"				if updatePrioritized and shieldUnit1.unitDefID~=targetDefID then break end --skip unprioritized/prioritized units				if not shieldUnit1.linkable then break end -- continue to next unit				for ud2,shieldUnit2 in pairs(unitList) do --iterate over all shield unit, find anyone that's in range.					if ((not shieldUnit1.linkFirst) or shieldUnit1.linkFirst > shieldUnit1.numNeighbors)                        and shieldUnit1.link ~= shieldUnit2.link and shieldUnit2.linkable then --if new link isn't existing link, and if this unit is linkable, then: 						local xDiff = shieldUnit1.x - shieldUnit2.x						local zDiff = shieldUnit1.z - shieldUnit2.z						local yDiff = shieldUnit1.y - shieldUnit2.y						local sumRadius = shieldUnit1.shieldRadius + shieldUnit2.shieldRadius						if xDiff <= sumRadius and zDiff <= sumRadius and (xDiff*xDiff + yDiff*yDiff + zDiff*zDiff) < sumRadius*sumRadius then --if this unit is in range of old unit:															sc[cnt]   = ud1                            sc[cnt+1] = ud2							cnt = cnt + 2									shieldUnit1.numNeighbors = shieldUnit1.numNeighbors + 1							shieldUnit2.numNeighbors = shieldUnit2.numNeighbors + 1							shieldUnit1.neighbor[shieldUnit1.numNeighbors] = ud2							shieldUnit2.neighbor[shieldUnit2.numNeighbors] = ud1															for unitID,shieldUnit3 in pairs(shieldUnit2.link) do								shieldUnit1.link[unitID] = shieldUnit3 --copy content from new link to existing link								shieldUnit3.link = shieldUnit1.link --assign existing link to new unit							end						end					end				end -- for ud2			until true --exit repeat		end	-- for ud1endlocal function UpdateAllLinks()	for allyTeam,unitList in pairs(shieldTeams) do		for unitID,shieldUnit in pairs(unitList) do			local x,y,z = spGetUnitPosition(unitID)			local valid = x and y and z			shieldUnit.linkable = valid and isEnabled(unitID)			shieldUnit.enabled  = shieldUnit.linkable			if (shieldUnit.linkable) then				shieldUnit.x = x				shieldUnit.y = y				shieldUnit.z = z				shieldUnit.link = { [unitID] = shieldUnit }			else				shieldUnit.link = NO_LINK			end			shieldUnit.numNeighbors = 0		end        shieldConnections[allyTeam] = {}		for i=1, linkFirstSequenceLen do			local unitDefID = linkFirst_Sequence[i]			AdjustLinks(allyTeam, unitList, true , unitDefID) --unit that is linked first (have most link)        end		AdjustLinks(allyTeam, unitList, false)	endendlocal function UpdateEnabledState()	for allyTeam,unitList in pairs(shieldTeams) do		for unitID,shieldUnit in pairs(unitList) do			shieldUnit.enabled = shieldUnit.linkable and isEnabled(unitID)		end	endendlocal RECHARGE_KOEF = 0.01function gadget:GameFrame(n)	if n%30 == 18 then		UpdateAllLinks() --update every 30 frames at the 18th frame	elseif n%5 == 3 then		UpdateEnabledState()	end	for allyTeam,unitList in pairs(shieldTeams) do		local processedLinks = { [NO_LINK] = true } --DO NOT USE PAIRS ON THIS		for unitID,shieldUnit in pairs(unitList) do			repeat --doesn't do loop but make "break" behave like "continue"				if not processedLinks[shieldUnit.link] then --check if this linked group have been processed before					processedLinks[shieldUnit.link] = true --mark this linked groupd as processed					---[[-- Distribution Method A: distribute to nearest neighbor					for unitID2,shieldUnit2 in pairs(shieldUnit.link) do						local charger_On,charger_charge = spGetUnitShieldState(unitID2, -1)						if (charger_On and shieldUnit2.enabled) then							local charger_capacity = shieldUnit2.shieldPower							for i=1, shieldUnit2.numNeighbors do								local unitID3 = shieldUnit2.neighbor[i]								local shieldUnit3 = shieldUnit.link[unitID3]								if shieldUnit3~= nil then --shield dead? (NOTE! neighbor list is not updated when unit die, its only updated in AdjustLinks(), however "shieldUnit.link[unitID]" is emptied upon death)									local chargee_On,chargee_charge = spGetUnitShieldState(unitID3, -1)									if chargee_On and shieldUnit3.enabled and (charger_charge>chargee_charge) then 										local chargee_capacity = shieldUnit3.shieldPower										local chargee_regen = shieldUnit3.shieldRegen										--charge flow is: based on the absolute difference in charge content,										--charge flow must:										--1)not be more than receiver's capacity, 										--2)not be more than donator's available charge,										--3)leave spaces for receiver to regen,										--charge flow is capable: to reverse flow (IS DISABLED!) when receiver have regen and is full,										local chargeFlow = math.min(RECHARGE_KOEF*(charger_charge-chargee_charge),charger_charge, chargee_capacity-chargee_regen-chargee_charge) --minimize positive flow										chargeFlow = math.max(0, chargeFlow, charger_charge - charger_capacity) --minimize negative flow (DISABLED, max 0 negative flow, prevent corthud from charging core_spectre freely)										charger_charge = charger_charge - chargeFlow --deduct charge										spSetUnitShieldState(unitID3, -1, chargee_charge + chargeFlow)--add charge to receiver									end								end							end							spSetUnitShieldState(unitID2, -1, charger_charge)--deduct charge						end 					end                    --]]-- Distribution Method A - END					--[[-- Distribution Method B: distribute to all linked shield based on total average					local totalCharge =	0					local linkUnits = 0					local udata = {}	-- unit data,	charge and chargeMax					for unitID2,shieldUnit2 in pairs(shieldUnit.link) do						local shieldOn,shieldCharge = spGetUnitShieldState(unitID2, -1)						if (shieldOn) then 							udata[unitID2] = {								charge = shieldCharge,								chargeMax = shieldUnit2.shieldPower							}							totalCharge = totalCharge + shieldCharge							linkUnits = linkUnits + 1						end 					end					local avg = totalCharge / linkUnits	-- calculate average charge of netwrok 					local overflow = 0					local slack = 0 					for uid,d in pairs(udata) do	-- equalize all sheilds to average by 1% of their difference from average 						local newCharge = d.charge + (avg - d.charge) * RECHARGE_KOEF						if (newCharge > d.chargeMax) then 							overflow = overflow + newCharge - d.chargeMax							newCharge = d.chargeMax						else 							slack = slack + d.chargeMax - newCharge						end 						d.charge = newCharge						spSetUnitShieldState(uid, -1, newCharge)					end							if overflow > 0 and slack > 0 then	-- if there was overflow (above max charge) and	there is still some unused space for charge, transfer it there 						for uid,d in pairs(udata) do							if (d.charge < d.chargeMax) then 								local newCharge = d.charge + overflow * (d.chargeMax - d.charge) / slack 								spSetUnitShieldState(uid, -1, newCharge)							end 						end					end 					--]]-- Distribution Method B - END				end			until true --exit repeat		end	endend------------------------------------------------------------------------------------------------------------------------------------------------------------------UNSYNCEDelse----------------------------------------------------------------------------------------------------------------------------------------------------------------local glVertex = gl.Vertexlocal glColor = gl.Colorlocal glBeginEnd = gl.BeginEndlocal glPushAttrib = gl.PushAttriblocal glLineWidth = gl.LineWidthlocal glDepthTest = gl.DepthTestlocal glPopAttrib = gl.PopAttriblocal GL_LINE_BITS = GL.LINE_BITSlocal GL_LINES     = GL.LINESlocal spGetMyAllyTeamID    = Spring.GetMyAllyTeamIDlocal spGetSpectatingState = Spring.GetSpectatingStatelocal spIsUnitInView       = Spring.IsUnitInViewlocal spValidUnitID        = Spring.ValidUnitID----------------------------------------------------------------------------------------------------------------------------------------------------------------function gadget:Initialize()endlocal function DrawFunc()	myAllyID = spGetMyAllyTeamID()	local spec, fullview = spGetSpectatingState()	spec = spec or fullview		for allyID, connections in spairs(SYNCED.shieldConnections) do		local u1, u2		for _,con in sipairs(connections) do  --array contains u1,u2,u1,u2,... 			if (not u1) then				u1 = con			else				u2 = con							local l1				local l2							if (spec or allyID == myAllyID) then					l1 = spIsUnitInView(u1)					l2 = spIsUnitInView(u2)				end					if ((l1 or l2) and (spValidUnitID(u1) and spValidUnitID(u2))) then					local x1, y1, z1 = spGetUnitViewPosition(u1, true)					local x2, y2, z2 = spGetUnitViewPosition(u2, true)					glVertex(x1, y1, z1)					glVertex(x2, y2, z2)				end				u1 = nil			end		end	endend 	function gadget:DrawWorld()	if SYNCED.shieldConnections and snext(SYNCED.shieldConnections) then		glPushAttrib(GL_LINE_BITS)			glDepthTest(true)		glColor(1,0,1,math.random()*0.3+0.2)		glLineWidth(1)		glBeginEnd(GL_LINES, DrawFunc)			glDepthTest(false)		glColor(1,1,1,1)			glPopAttrib()	endend----------------------------------------------------------------------------------------------------------------------------------------------------------------end----------------------------------------------------------------------------------------------------------------------------------------------------------------