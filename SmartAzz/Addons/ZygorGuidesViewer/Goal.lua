local Goal = { }

local ZGV = ZygorGuidesViewer
if not ZGV then return end
local L = ZGV.L

local table,string,tonumber,ipairs,pairs,setmetatable = table,string,tonumber,ipairs,pairs,setmetatable

ZGV.GoalProto = Goal
ZGV.GoalProto_mt = { __index=Goal }

Goal.indent=0

function Goal:GetStatus()
	if not self:IsVisible() then return "hidden" end
	if not self:IsCompleteable() then return "passive" end
	local complete,possible,progress,warn = self:IsComplete()
	if complete then return "complete" end
	-- FIRST impossible (gray), THEN obsolete (blue).
	if warn then return "warning" end
	if not possible then return "impossible" end
	if ZGV.db.profile.skipobsolete and not self.parentStep.parentGuide.noobsolete and self:IsObsolete() then return "obsolete" end
	-- only possible and progressing is left.
	return "incomplete",progress
end

function Goal:UpdateStatus()
	self.status = self:GetStatus()
end

function Goal:IsVisible()
	if not self:IsFitting() then return false end
	if self.condition_visible then return self.condition_visible() end
	return true
end

function Goal:IsCompleteable()
	--if type(goal)=="number" then goal=self.CurrentStep.goals[goal] end
	if self.force_nocomplete then return false end

	if self.questid --[[and self.objnum--]] then return true end
	
	if self.action=="from"
	or self.action==""
	then return false end

	if self.action=="goal"
	or self.action=="kill"
	or self.action=="get"
	or self.action=="accept"
	or self.action=="turnin"
	or self.action=="collect"
	or self.action=="buy"
	or self.action=="fpath"
	or self.action=="home"
	or self.action=="ding"
	or self.action=="havebuff"
	or self.action=="nobuff"
	or self.action=="invehicle"
	or self.action=="outvehicle"
	or self.action=="equipped"
	or self.action=="rep"
	or self.action=="condition"
	or self.action=="achieve"
	or self.action=="skill"
	or self.action=="skillmax"
	or self.action=="learn"
	or self.action=="click"
	 then return true end
	if self.action=="goto" then
		-- this one is tricky.
		-- by default - completeable only if only 'goto' goals are present.
		local all_gotos=true
		for i,goal in ipairs(self.parentStep.goals) do
			if goal.action~="goto" then
				all_gotos=false
				break
			end
		end
		return (self.force_complete or all_gotos)
	end
	return false
end

local goalstring_slain=QUEST_MONSTERS_KILLED:gsub(": .*","")

-- returns: true = complete, false = incomplete
-- second return: true = completable, false = incompletable
function Goal:IsComplete()

	if (self.force_sticky and ZGV.recentlyCompletedGoals[self]) or ZGV.recentlyStickiedGoals[self] then
		return true,true,true
	end

	if self.force_nocomplete then return end

	if self.action=="accept" then
		--[[
		-- Check for "turn in, accept" pair of the same quest - a workaround for "turn in part 1, accept part 2" steps
		--  Deprecated by introduction of questacceptedid
		if ZGV.questIndicesByTitle[self.questaccepted] and goalIndex>1 then
			local i
			for i = goalIndex-1, 1, -1 do
				if ZGV.StepCompletion[i].questturnedin==self.questaccepted and not ZGV:IsStepGoalComplete(i) then return false,true end
			end
		end
		--]]
		--local possible = (not self.parentStep.level  or  self.parentStep.level-UnitLevel("player")<=5)

		local quest = ZGV.questsbyid[self.questid]
		local complete = ZGV.completedQuests[self.questid]
		    or (quest and quest.inlog)
		    -- or ZGV.instantQuests[self.questid]  -- and ZGV.completedQuestTitles[self.quest])  -- let's not use this anymore, with GetQuestID available
		    -- or (not ZGV.CurrentGuide.daily and ZGV.db.char.permaCompletedDailies[self.questid])  -- deprecating this, let's see if this works.
		
		return complete, complete or ZGV:IsQuestPossible(self.questid)     --[[or ZGV.recentlyAcceptedQuests[id] --]]

	elseif self.action=="turnin" then
			--[[ Completion sequence:
									ZGV.completedQuests[id]		ZGV.questsbyid[id]
			 1. CHAT_MSG_SYSTEM "<quest> completed."	nil				{...}
			     - ZGV.completedQuests[id] = true		true				{...}
			 2. QUEST_LOG_UPDATE, quest gone from log.	true				nil

			--]]

			-- Completed if it's in the completed bin, but NOT in the log.
			-- If it's in the log, it couldn't be completed; this fixes some weird multiple-completion quests, like #348 Stranglethorn Fever.
			-- completeable if it's in the log and complete or non-goaled.
		local quest = ZGV.questsbyid[self.questid]
		local turned = ZGV.completedQuests[self.questid]
			-- or (not ZGV.CurrentGuide.daily and ZGV.db.char.permaCompletedDailies[self.questid])
		
		return turned, turned or (quest and quest.inlog and (quest.complete or #quest.goals==0)), 0, not turned and quest and quest.inlog and not quest.complete and #quest.goals>0
	end

	
	if self.achieveid then
		-- oh gods. The below, redux.
		local completed
		if self.achievesub then
			local description, ctype
			description, ctype, completed = GetAchievementCriteriaInfo(self.achieveid, self.achievesub)
		else
			local id, name, points
			id, name, points, completed = GetAchievementInfo(self.achieveid)
		end

		if completed then
			return true,true
		end
		-- else fall-through
	end

	-- Quest-related? Handle appropriately.

	if self.questid then

		-- NEW: if it's a goddamn instant daily, try to reset it.
		--if ZGV.instantQuests[self.questid] and ZGV.dailyQuests[self.questid] then ZGV:QuestTracking_ResetDailyByTitle(self.quest) end

		-- if the quest was done, the goal is done and over with. Bye.
		if ZGV.completedQuests[self.questid]
		-- or (ZGV.instantQuests[self.questid] and self.quest and ZGV.completedQuestTitles[self.quest]) -- let's not use this anymore, with GetQuestID available
		then return true,true end

		-- if the quest cannot be completed, and we're not a futureproof goal, bail.
		--if not ZGV:IsQuestPossible(self.questid) and not self.future then return false,false end

		-- okay, so the quest may yet be possible. Is it in the log?
		local quest = ZGV.questsbyid[self.questid]
		if quest and quest.inlog then
		
			-- Now if it is goalbound, complete it as the goal would.

			if self.objnum then
				local questGoalData = quest.goals[self.objnum]

				if questGoalData then
					if questGoalData.complete then
						return true, true
					else
						local count = self.count or questGoalData.needed or 1
						if questGoalData.num>=count then
							return true, true
						else
							--ZGV:Debug("Not yet completed: "..questself.num.."/"..questgoal.needed)
							return false, true, questGoalData.num/count
						end
					end
				else
					--ZGV:Debug("No goal "..goal)
					ZGV:Print("WARNING: quest has no such goal! Step "..self.parentStep.num..", line "..(self.num)..", quest "..(self.questid or (self.quest and self.quest.title))..", goal "..(self.objnum or -1))
					return false, true
				end
			else
				if not self.action or self.action=="" then
					-- okay, this is a simple "complete the quest" check
					return quest.complete,true
				end
				-- pure questbound? complete if the whole quest is complete...
				-- or not. Just drop.
				
				--[[
				if questInLog.complete or #questInLog.goals==0 then
					return true,true
				else
					-- otherwise drop through, let it complete on its own.
				end
				--]]
			end
		else
			-- if quest is not in log, then it usually means screw its links as well.
			-- Unless we're a future-proof goal, which drops through.
			if not self.future then
				return false,false
			end
		end
	end


	if self.action=="ding" then
		local percent
		local level = ZGV:GetPlayerPreciseLevel()
		percent = (level<self.level-1) and 0 or (level>=self.level) and 1.0 or UnitXP("player")/UnitXPMax("player")

		return level>=tonumber(self.level), level>=tonumber(self.level)-1, percent
	elseif self.action=="goto" then
		local zone = ZGV.CurrentMap
		local map = self.mapL or self.map
		if map and zone~=map then return self.dist and self.dist<0,true end
		if ZGV.recentlyVisitedCoords[self] then return true, true end

		if self.x then
			local c,z=GetCurrentMapContinentAndZone()
			local px,py = GetPlayerMapPosition("player")
			local gx,gy,dist = self.x/100,self.y/100,self.dist or 30
			local realdist=Astrolabe:ComputeDistance(c,z,px,py,c,z,gx,gy)
			if (dist>0 and realdist<=dist) or (dist<0 and realdist>=-dist) then
				--ZGV.recentlyVisitedCoords[self] = true
				return true, true
			else
				local prog
				if dist>0 then prog = 1-((realdist-dist)/500) else prog = realdist/(-dist+0.1) end
				if prog<0 then prog=0 end
				if prog>1 then prog=1 end
				return false, true, prog
			end
		else
			return not self.dist or self.dist>0,true
		end
	elseif self.action=="hearth" then
		return GetZoneText()==self.param or GetMinimapZoneText()==self.param or GetSubZoneText()==self.param, true
	elseif self.action=="home" then
		--return GetBindLocation("player")==self.home, true  -- didn't work well
		return ZGV.recentlyHomeChanged, true
	elseif self.action=="fpath" then
		return (ZGV.db.char.taxis[ZGV.LibTaxi.TaxiNames_English[self.param]] --[[or ZGV.recentlyDiscoveredFlightpath--]]), true
	elseif self.action=="collect" or self.action=="buy" then
		local got = GetItemCount(self.targetid)
		local progress = got/self.count
		if self.exact then
			return got==self.count, true, got<=self.count and progress or 0
		else
			return got>=self.count, true, progress>1 and 1 or progress
		end
	elseif self.action=="havebuff" then
		for i=1,30 do
			local name,_,tex = UnitBuff("player",i)
			if name and (tex:find(self.buff) or name:find(self.buff)) then return true,true end
			local name,_,tex = UnitDebuff("player",i)
			if name and (tex:find(self.buff) or name:find(self.buff)) then return true,true end
		end
		return false,true
	elseif self.action=="nobuff" then
		for i=1,30 do
			local name,_,tex = UnitBuff("player",i)
			if name and (tex:find(self.buff) or name:find(self.buff)) then return false,true end
			local name,_,tex = UnitDebuff("player",i)
			if name and (tex:find(self.buff) or name:find(self.buff)) then return false,true end
		end
		return true,true
	elseif self.action=="invehicle" then
		return UnitInVehicle("player"),true
	elseif self.action=="outvehicle" then
		return not UnitInVehicle("player"),true
	elseif self.action=="equipped" then
		local link = GetInventoryItemLink("player",self.slot)
		local name
		if link then name = link:match("|Hitem:.-%[(.-)%]") end
		return name and name==self.item , GetItemCount(self.item)>0
	elseif self.action=="rep" then
		local rep = ZGV:GetReputation(self.faction)
		if rep then
			return rep.standing>=self.rep, true, 1-(rep:CalcTo(self.rep)/(rep.max-rep.min)) or 0
		else
			return nil,nil,nil
		end
	elseif self.action=="condition" then
		return self:condition_complete()
	elseif self.action=="achieve" then
		if self.achieveid then
			if self.achievesub then
				-- partial achievement
				local desc,ctype,completed,quantity,required = GetAchievementCriteriaInfo(self.achieveid,self.achievesub)
				if not required or required==0 then required=1 end
				if not quantity then quantity = 0 end
				if quantity>required then quantity=required end
				return not not completed, true, quantity/required
			else
				-- full achievement
				local id, name, points, completed = GetAchievementInfo(self.achieveid)
				local numcrit = GetAchievementNumCriteria(self.achieveid)
				local completenum = 0
				for i=1,numcrit do
					local desc,ctype,completed,quantity,required = GetAchievementCriteriaInfo(self.achieveid,i)
					if not required or required==0 then required=1 end
					if not quantity then quantity = 0 end
					if quantity>required then quantity=required end
					completenum=completenum+quantity/required
				end
				return not not completed, true, numcrit>0 and completenum/numcrit or 0
			end
		else
			return nil,nil,nil
		end
	elseif self.action=="skill" then
		local skill = ZGV:GetSkill(self.skill)
		return skill.level>=self.skilllevel,skill.max>=self.skilllevel
	elseif self.action=="skillmax" then
		return ZGV:GetSkill(self.skill).max>=self.skilllevel,true
	elseif self.action=="learn" then
		return ZGV.db.char.RecipesKnown[self.recipeid] or (self.recipe and ZGV.recentlyLearnedRecipes[self.recipe]), true
	elseif self.action=="kill" and self.usekillcount then --killcount version
		local count = ZGV.recentKills[self.target]
		return count and count>=self.count, true
	elseif self.action=="click" then --killcount version
		return false,true
	end

	return false,false
end

function FindPetActionInfo(action)
	if type(action)==number then return action,GetPetActionInfo(action) end
	for i=1,12 do
		local name,x,tex = GetPetActionInfo(i)
		if name and (name:find(action) or tex:find(action)) then return i,name,x,tex end
	end
end

function Goal:IsActionable()
	return ((self.useitemid or self.useitem) and GetItemCount(self.useitemid or self.useitem)>0)
	    or (self.castspell and IsUsableSpell(self.castspell))
	    or (self.petaction and FindPetActionInfo(self.petaction))
	    or (self.script)
end

local function plural(s,i)
	if not i or i==1 then return s else return ZygorGuidesViewer_L("Specials")["plural"](s) end
end

function Goal:IsFitting()
	if self.wrong then return nil end
	if not self.requirement then return true end
	self.wrong = not ZygorGuidesViewer:RaceClassMatch(self.requirement)
	return not wrong
end

function Goal:NeedsTranslation()
	--return GetLocale()~="enUS" and not self.L
	return type(self.L)=="number" or not self.L
end

local retries=100
function Goal:AutoTranslate()
	local oldL=self.L
	if self.L==true then return false end
	if not self:IsFitting() then
		-- ignore wrong goals
		self.L=true
	end

	self.L = true  -- assume we're translating right

	if self.action=="fpath" and ZGV.LibTaxi then
		if ZGV.LibTaxi.TaxiNames_Local then
			self.param = ZGV.LibTaxi.TaxiNames_Local[self.param] or self.param
		end
	end
	if self.questid then
		local q = ZGV.Localizers:GetQuestData(self.questid)
		if q then
			self.quest=q
			if (self.action=='get' or self.action=='kill' or self.action=='goal')
			and not self.targetid then
				if q.objs then
					local obj=qobjs[self.objnum]
					if obj and #obj>2 then
						self.target=obj.item
						--self.L=true
					else
						self.Lretries = (self.Lretries or retries) - 1
						self.L=nil -- WHOA.
					end
				else
					--self.L=true --sorry...
				end
			--elseif self.action=='accept' or self.action=='turnin' then
				--self.L = true  -- quest title is enough
				--ZGV:Debug("Translated: accept/turnin "..self.quest.." ("..(self.Lretries or 'all').." retries left)")
			--else
				--self.L = true
				--ZGV:Debug("Translated: '"..tostring(self.action).."' "..tostring(self.quest).." ("..(self.Lretries or 'all').." retries left)")
			end

			-- translated a quest - if it's an instant-daily, put it in a special bag
			-- it's used to remove titles from ZGV.db.char.completedQuests if removing the daily ID from completedDailies
			-- ... Not used anymore?
			--[[
			if ZGV.instantQuests[self.questid] and ZGV.dailyQuests[self.questid] then
				ZGV.db.global.instantDailies[self.questid] = qt
			end
			--]]
		else
			self.Lretries = (self.Lretries or retries) - 1
			self.L=nil -- WHOA.
		end
	end
	if self.targetid then
		--[[if QuestInfo_Name then
			local target=QuestInfo_Name[self.targetid]
			if target then
				self.target=target
			end
		--]]
		if self.action=="kill" then
			if ZygorGuidesNPCs then
				local target,tooltip=ZGV.Localizers:GetTranslatedNPC(self.targetid)
				if target then
					self.target,self.tooltip=target,tooltip
				end
			end
			--self.L=true
			--ZGV:Debug("Translated: '"..tostring(self.action).."' "..tostring(self.target).." ("..(self.Lretries or 'all').." retries left)")
		elseif self.action=="collect" or self.action=="get" or self.action=="buy" or self.action=="use" then
			local item = GetItemInfo(self.targetid)
			if item then
				self.target=item
				--self.L=true
				--ZGV:Debug("Translated: '"..tostring(self.action).."' "..tostring(self.target).." ("..(self.Lretries or 'all').." retries left)")
			else
				self.Lretries = (self.Lretries or retries) - 1
				self.L=nil -- WHOA.
			end
		end
	end
	if self.useitemid then
		local item = GetItemInfo(self.useitemid)
		if item then
			self.useitem = item
		else
			self.Lretries = (self.Lretries or retries) - 1
			self.L=nil -- WHOA.
		end
	end

	if self.npcid then
		local npc,tooltip=ZGV.Localizers:GetTranslatedNPC(self.npcid)
		if npc then
			--self.npc,self.tooltip=npc,tooltip
			self.tooltip=tooltip
		end
		--self.npc = self.npc or "?"
		-- NPC will self-translate.
	end

	if self.map and GetLocale()~="enUS" then
		self.mapL = ZGV.BZL[self.map]
	end

	if self.L then
		-- translated? whee.
		if (retries-(self.Lretries or retries) > 0) then ZGV:Debug(("Translating step %d goal %d, try %d - success"):format(self.parentStep.num,self.num,retries-(self.Lretries or retries))) end
		ZGV.frameNeedsUpdating=true
		self.Lretries=nil
	else
		-- not yet?
		-- do we have retries left?

		if self.Lretries and self.Lretries>0 then
			-- let it retry
			--ZGV:Debug(("Translating step %d goal %d, try %d..."):format(self.parentStep.num,self.num,retries-(self.Lretries or retries)))
		else
			-- if many translation attempts fail, just leave it.
			ZGV:Debug(("Translating step %d goal %d, tried %d times - failed"):format(self.parentStep.num,self.num,retries-(self.Lretries or retries)))
			self.L=true  --sorry.
			self.Lretries=nil
		end
	end

	return oldL~=self.L
end

local function COLOR_LOC(s) return "|cffffee77"..tostring(s).."|r" end
local function COLOR_COUNT(s) return "|cffffffcc"..tostring(s).."|r" end
local function COLOR_ITEM(s) return "|cffaaeeff"..tostring(s).."|r" end
local function COLOR_QUEST(s) return "|cffddaaff"..tostring(s).."|r" end
local function COLOR_NPC(s) return "|cffaaffaa"..tostring(s).."|r" end
local function COLOR_MONSTER(s) return "|cffffaaaa"..tostring(s).."|r" end
local function COLOR_GOAL(s) return "|cffffcccc"..tostring(s).."|r" end


local function GenericText(brief,goaltype,colorfunc,count,target,nocount,isplural,_done)
	if nocount then
		local formattxt = brief and "%s" or L["stepgoal_"..goaltype.._done]
		return formattxt:format(colorfunc(plural(target,isplural and 2 or 1)))
	else
		local formattxt = brief and "%s %s" or L["stepgoal_"..goaltype.." #".._done]
		return formattxt:format((count and count>0) and count or "?",colorfunc(plural(target,count)))
	end
end

local simulquest = {
	['goals']={
		{ type="monster",monster="Two Monsters",leaderboard="Monster slain: 0/2",needed=2,num=0 },
		{ type="monster",monster="Two Monsters Again",leaderboard="Two Monsters Again slain: 1/2",needed=2,num=1 },
		{ type="monster",monster="Three Dead Monsters",leaderboard="Three Dead Monsters slain: 3/3",needed=3,num=3 }
	}
			
}

local unknownquest = {
	title="?"
}


local skillspells = {	--	apprentice	journeyman	expert		artisan		master		grand master	illustrious
	Alchemy = {		[75]=2275,	[150]=2280,	[225]=3465,	[300]=11612,	[375]=28597,	[450]=51303,	[525]=65281,	},
	Archaeology = {		[75]=95553,	[150]=95554,	[225]=95555,	[300]=95556,	[375]=95557,	[450]=95558,	[525]=95546,	},
	Blacksmithing = {	[75]=2020,	[150]=2021,	[225]=3539,	[300]=9786,	[375]=29845,	[450]=51298,	[525]=65282,	},
	Cooking = {		[75]=2551,	[150]=3412,	[225]=19886,	[300]=19887,	[375]=33361,	[450]=51295,	[525]=65291,	},
	Enchanting = {		[75]=7414,	[150]=7415,	[225]=7416,	[300]=13921,	[375]=28030,	[450]=51312,	[525]=65285,	},
	Engineering = {		[75]=4039,	[150]=4040,	[225]=4041,	[300]=12657,	[375]=30351,	[450]=51305,	[525]=61464,	},
	['First Aid'] = {	[75]=3279,	[150]=3280,	[225]=19903,	[300]=19902,	[375]=27029,	[450]=50299,	[525]=65292,	},
	Fishing = {		[75]=7733,	[150]=7734,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Herbalism = {		[75]=2372,	[150]=2373,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Inscription = {		[75]=45375,	[150]=45376,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Jewelcrafting = {	[75]=25245,	[150]=25246,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Leatherworking = {	[75]=2155,	[150]=2154,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Mining = {		[75]=2581,	[150]=2582,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Riding = {		[75]=33389,	[150]=33392,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Skinning = {		[75]=8615,	[150]=8619,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
	Tailoring = {		[75]=3911,	[150]=3912,	[225]=0,	[300]=0,	[375]=0,	[450]=0,	[525]=0,	},
}

local function picktext(goal,goaltext)
	if ZGV.db.profile.usegenericgoals then
		goal.text = goaltext or goal.text or "?"
	else
		goal.text = goal.text or goaltext or "?"
	end
end
-- This is a HUGE mess.

function Goal:GetText(showcompleteness,brief)
	--if type(goal)=="number" then goal=self.CurrentStep.goals[goal] end

	-- prepare for progress
	local questdata,goaldata,goalcount,goalmaxcount,remaining
	if self.force_nocomplete and self.action~="collect" and self.action~="buy" then showcompleteness=false end
	if showcompleteness and self.questid then
		questdata=ZGV.questsbyid[self.questid]
		if questdata and questdata.inlog and self.objnum then
			-- quest-goal completion display; lame 0/5
			goaldata = questdata.goals[self.objnum]
			if goaldata then
				goalcount = self.count or goaldata.needed
				remaining = goalcount-goaldata.num
				if remaining<=0 then remaining=goalcount end
			end
		end
	end

	local complete,ext = self:IsComplete()

	local _done = complete and "_done" or ""

	local text="?"
	local progtext

	if self.text then text = self.text

	elseif self.action=='accept' then
		text = (brief and "%s" or L["stepgoal_accept".._done]):format(COLOR_QUEST((self.questpart and L['questtitle_part'] or L['questtitle']):format(self.quest and self.quest.title or "...quest...",self.questpart)))
	
	elseif self.action=='turnin' then
		text = (brief and "%s" or L["stepgoal_turn in".._done]):format(COLOR_QUEST((self.questpart and L['questtitle_part'] or L['questtitle']):format(self.quest and self.quest.title or "...quest...",self.questpart)))
	
	elseif self.action=='talk' then
		text = (brief and "%s" or L["stepgoal_talk to".._done]):format(COLOR_NPC(ZGV.Localizers:GetTranslatedNPC(self.npcid)))
	
	elseif self.action=='get' then
		--if self.test==1 then goalcount=nil elseif self.test==2 then 
		text = GenericText(brief,self.action,COLOR_ITEM,remaining or self.count,self.target,not self.count or self.count==1,self.plural,_done)

	elseif self.action=='kill' then
		text = GenericText(brief,self.action,COLOR_MONSTER,remaining or self.count,self.target,not self.count or self.count==1,self.plural,_done)
		if self.usekillcount then goalcount=ZGV.recentKills[self.target] end
	
	elseif self.action=='collect' then
		text = GenericText(brief,self.action,COLOR_ITEM,remaining or self.count,self.target,not self.count or self.count==1,self.count and self.count>1,_done)
		goalcount = GetItemCount(self.target)
		goalmaxcount = self.count
	
	elseif self.action=='buy' then
		text = GenericText(brief,self.action,COLOR_ITEM,remaining or self.count,self.target,false,false,_done)
		goalcount = GetItemCount(self.target)
		goalmaxcount = self.count
	
	elseif self.action=='goal' then
		text = GenericText(brief,self.action,COLOR_GOAL,remaining or self.count,self.target,not self.count or self.count==1,false,_done)
	
	elseif self.action=='from' then
		-- no text overriding; don't want the kill-list? don't use it.
		for i,mob in ipairs(self.mobs) do
			local mobname
			if mob.id then mobname=ZGV.Localizers:GetTranslatedNPC(mob.id) end
			if mobname then
				mob.name = mobname
			elseif not self.knownmissing then
				ZGV:Debug("Missing from NPC database: "..mob.name.." #"..(mob.id or "?"))
				self.knownmissing=true
			end
		end
		if #self.mobs>1 then
			-- contraction
			ZGV.db.profile.contractmobs = true
			
			if ZGV.db.profile.contractmobs and ZygorGuidesViewer_L("Specials")['contract_mobs'] then
				local contr = ZygorGuidesViewer_L("Specials")['contract_mobs'](self.mobs)

				if contr then
					text = COLOR_MONSTER(contr)
				end
			end
			if not text or text=="?" then
				-- regular listing
				text = ""
				for i,mob in ipairs(self.mobs) do
					if #text>0 then text = text .. ", " end
					text = text .. COLOR_MONSTER(plural(mob.name,nil,mob.pl and 2 or 1))
				end
			end
		else
			text = COLOR_MONSTER(plural(self.mobs[1].name,self.mobs[1].pl and 2 or 1))
		end
		text = L['stepgoal_kill']:format(text)

	elseif self.action=='ding' then
		text = (brief and L["stepgoal_ding_brief"] or L["stepgoal_ding"]):format(COLOR_NPC(self.level))
		if showcompleteness then
			local percent
			local level = ZGV:GetPlayerPreciseLevel()
			percent = (level<self.level-1) and 0 or (level>=self.level) and 100 or floor(UnitXP("player")/UnitXPMax("player") * 100)
			progtext = L["completion_ding"]:format(percent)
		end

	elseif self.action=='fpath' then text = L["stepgoal_fpath"]:format(COLOR_LOC(self.param))
	elseif self.action=='home' then text = L["stepgoal_home"]:format(COLOR_LOC(self.param))
	elseif self.action=='use' then text = L["stepgoal_use"]:format(COLOR_ITEM(self.useitem or "#"..self.useitemid))
	elseif self.action=='cast' then text = L["stepgoal_cast"]:format(COLOR_ITEM(self.castspell or "#"..self.castspellid))
	elseif self.action=='petaction' then text = L["stepgoal_petaction"]:format(self.petaction)
	elseif self.action=='havebuff' then text = L["stepgoal_havebuff"]:format(COLOR_ITEM(self.buff))
	elseif self.action=='nobuff' then text = L["stepgoal_nobuff"]:format(COLOR_ITEM(self.buff))
	elseif self.action=='invehicle' then text = L["stepgoal_invehicle"]
	elseif self.action=='outvehicle' then text = L["stepgoal_outvehicle"]
	elseif self.action=='equipped' then text = L["stepgoal_equipped"]:format(self.item,self.slot)
	elseif self.action=='hearth' then text = L["stepgoal_hearth to"]:format(COLOR_LOC(self.param))
	elseif self.action=='rep' then
		text = L["stepgoal_rep"]:format(ZGV.StandingNames[self.rep],self.faction)
		if showcompleteness then
			progtext = L["completion_rep"]:format(ZGV:GetReputation(self.faction):Going())
		end
	elseif self.action=='goto' then
		--if self.CurrentGuide.steps[self.CurrentStepNum-1] and self.CurrentGuide.steps[self.CurrentStepNum-1].map~=goal.map then
		local map=self.mapL or self.map
		if map and ZGV.CurrentMap ~= map then
		-- different map
			if self.x then
				-- and coords
				text = COLOR_LOC(L['map_coords']:format(map,self.x,self.y))
			else
				-- just the map
				text = COLOR_LOC(("%s"):format(map))
			end
		else
			-- same map
			text = COLOR_LOC(L['coords']:format(self.x or 0,self.y or 0))
		end
		text = (brief and "%s" or L["stepgoal_go to"]):format( text )
	elseif self.action=="achieve" then
		local id, name, points, completed = GetAchievementInfo(self.achieveid)
		if self.achievesub then
			local desc,ctype,completed,quantity,required = GetAchievementCriteriaInfo(self.achieveid,self.achievesub)
			text = L["stepgoal_achievesub"]:format(COLOR_QUEST(desc),COLOR_ITEM(name))
		else
			text = L["stepgoal_achieve"]:format(COLOR_ITEM(name))
		end
		if showcompleteness then
			if self.achievesub then
				-- partial achievement
				local desc,ctype,completed,quantity,required = GetAchievementCriteriaInfo(self.achieveid,self.achievesub)
				progtext = L["completion_goal"]:format(quantity,required)
			else
				-- full achievement
				local id, name, points, completed = GetAchievementInfo(self.achieveid)
				local numcrit = GetAchievementNumCriteria(self.achieveid)
				local completenum = 0
				for i=1,numcrit do
					local desc,ctype,completed,quantity,required = GetAchievementCriteriaInfo(self.achieveid,i)
					if completed then completenum=completenum+1 end
				end
				progtext = L["completion_goal"]:format(completenum,numcrit)
			end
		end
	elseif self.action=="skill" then
		text = L["stepgoal_skill"]:format(COLOR_ITEM(ZGV.LocaleSkills[self.skill]),self.skilllevel)
	elseif self.action=="skillmax" then
		local spell = skillspells[self.skill] and skillspells[self.skill][self.skilllevel]
		if spell and spell>0 then
			text = L["stepgoal_skillmax2"]:format(COLOR_ITEM(GetSpellInfo(spell)))
		else
			text = L["stepgoal_skillmax"]:format(COLOR_ITEM(ZGV.LocaleSkills[self.skill]),self.skilllevel)
		end
	elseif self.action=="learn" then
		text = L["stepgoal_learn"]:format(COLOR_ITEM(self.recipe))

	elseif self.action=="create" then
		if self.skill then
			-- new syntax

			local errortype

			local skill = ZGV:GetSkill(self.skill)
			local skill_loc = ZGV.LocaleSkills[self.skill]
			local spellname = GetSpellInfo(self.spellid) or "..."

			local cur_skill = GetTradeSkillLine()
			
			local modifier=1
			local remaining=self.level - skill.level
			local remaining_avg=0

			if skill.level>=self.level then
				self.recipedata=nil
				errortype = "done"
			elseif self.level>skill.max then
				self.recipedata=nil
				errortype = "over max"
			else
				if cur_skill==ZGV.LocaleSkills[self.skill] then
					if not self.recipedata or self.recipedata.lastskill~=skill then
						local skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps
						for i=1,500 do
							local link = GetTradeSkillRecipeLink(i)
							if link then
								local spellid = link:match(":([0-9]+)|h%[")
								if tonumber(spellid)==self.spellid then
									skillName, skillType, numAvailable, isExpanded, serviceType, numSkillUps = GetTradeSkillInfo(i)
									break
								end
							end
						end
						if skillName then
							self.recipedata = {avail=numAvailable,type=skillType,numup=numSkillUps or 1, lastskill=skill}
						end
					end
				else
					self.recipedata=nil
				end

				if self.recipedata then
					if self.recipedata.type then
						if self.recipedata.type=="optimal" then modifier = 1
						elseif self.recipedata.type=="medium" then modifier = 1.5
						elseif self.recipedata.type=="easy" then modifier = 3
						elseif self.recipedata.type=="trivial" and remaining>0 then errortype="trivial"
						else errortype = "wtf" end
				
						if modifier>0 then remaining_avg = math.ceil(remaining / self.recipedata.numup * modifier) end
					end
				else
					errortype = errortype or "no data"
				end
			end

			-- important info to display:
			-- skill_loc
			-- self.item == item name
			-- remaining == avg items to produce

			text = ("Perform %s to skill %s to %d"):format(spellname, skill_loc, self.level)
		
			if errortype or remaining<1 then
				progtext = errortype
			elseif remaining_avg>remaining then
				progtext = ("(about %d needed, min. %d)"):format(remaining_avg,remaining)
			else
				progtext = ("(%d needed)"):format(remaining)
			end
		
		else
			-- old create syntax
			text = GenericText(brief,"create",COLOR_ITEM,self.count,GetItemInfo(self.itemid),not self.count or self.count==1,self.count and self.count>1,_done)
		end

	elseif self.action=="click" then
		text = L["stepgoal_click"]

	elseif self.action=="info" then
		text = "|cffeeeecc"..(self.infoL or self.info).."|r"
	end

	
	-- trickiness: coordinates.

	if self.x -- if there's a coordinate
	and not (self.action=="goto" and not self.text) -- but it's not a plain goto
	and not (self.text and self.text:find("[0-9%.]-,[0-9%.]-")) -- and it's not a coord-in-text
	and not self.force_noway then
		text = text .. L['stepgoal_at_suff']:format(COLOR_LOC(L['coords']:format(self.x,self.y)))
	end




	-- apply the (2/4) totals now, or not

	if ZGV.db.profile.goaltotals then
		if goalcount and (goaldata or goalmaxcount) then progtext=L["completion_goal"]:format(goalmaxcount or goaldata.num,goalcount) end

		if progtext then
			local col1,col2=""
			if complete then col1,col2=" ",""
			elseif ext then col1,col2=" |cffffbbbb","|r"
			else col1,col2=" |cffaaaaaa","|r"
			end
			
			text = text .. col1 .. progtext .. col2
		end
	end

	return text
end

function Goal:GetString()
	if self.action=="get" then
		return self.target
	elseif self.action=="goal" then
		return self.target
	elseif self.action=="kill" then
		--return goalstring_slain:format(self.target)
		return self.target
	end
end

function Goal:Prepare()
	if self.castspell or self.castspellid and (not self.castspell or not self.castspellid) then
		local link = GetSpellLink(self.castspellid or self.castspell)
		if link then
			self.castspellid,self.castspell = link:match("spell:([0-9]+).-%[(.-)%]")
			self.castspellid = tonumber(self.castspellid)
		end
	end
	if self.action=="goal" or self.action=="kill" or self.action=="get" then
		if self.questid and self.objnum then
			local questData = ZGV.questsbyid[self.questid]

			if questData and questData.inlog and questData.index>0 then
				local questGoalData = questData.goals[self.objnum]
				if questGoalData and questGoalData.needed and not self.exact and (not self.count or self.count==0 or self.count>questGoalData.needed) then
					self.count=questGoalData.needed
				end
			end
			if not self.count then self.count=1 end
		end
	end

	-- wipe completed quests by title, if they're instant
	--[[ moved to core code, to be done on ClearRecentActivities
	if self.action=="accept" or self.action=="turnin" then
		if self.questid then
			if ZGV.instantQuests[self.questid] and ZGV.completedQuestTitles[self.quest] then
				ZGV.completedQuestTitles[self.quest] = nil
			end
		end
	end
	--]]

	if not InCombatLockdown() then
		if self.script then
			local macroname = "ZygorGuidesMacro" .. self.num
			local macro = GetMacroIndexByName(macroname)
			if macro==0 then
				macro = CreateMacro(macroname,1,"/run "..self.script,1)
			end
			self.macro = macro
		end
	end

	if self.autoscript then
		local func,err=loadstring(self.autoscript)
		if err then
			ZGV:Print("Error in step autoscript: '"..self.autoscript.."' error: '"..err.."'")
		else
			func()
		end
	end
end

--- Is this goal obsolete?
-- A goal is obsolete when it belongs below the player's level and doesn't lead to any non-obsolete follow-ups.
-- For example, for a level 31 player, most quests belonging in the guide levels 1-30 are obsolete and can safely be omitted.
function Goal:IsObsolete()
	do return false end --obsoletion is by section now
	--[[
	if not self.questid then return end  -- not belonging to any quest
	if not ZGV.CurrentGuide.dynamic then return end
	if self.noobsolete then return end
	if self.parentStep.parentGuide.daily or not self.parentStep.level or self.parentStep.level==0 then return nil end

	--local fups = ZGV:GetMentionedFollowups(self.questid)
	local maxlevel = ZGV.maxQuestLevels[self.questid] or 99
	--assert(#fups>0,"Quest mentioned in guide "..ZGV.CurrentGuideName.." step "..ZGV.CurrentStepNum.." but nowhere else..?")
	local level = ZGV:GetPlayerPreciseLevel()
	
	--local maxlevel=0
	--for i=1,#fups do if fups[i][2]>maxlevel then maxlevel=fups[i][2] end end

	--if #fups>0 and maxlevel<level-ZGV.db.profile.levelsahead and not ZGV.questsbyid[self.questid] then

	-- if maxlevel<level-ZGV.db.profile.levelsahead and not ZGV.questsbyid[self.questid] then
	if maxlevel<level-(ZGV.db.profile.levelsahead or 0) and not ZGV.questsbyid[self.questid] then
		-- Okay, level-wise we'd be ready to skip, but what about the quest chain..?
		if ZGV.db.profile.chainskip then
			local skipcount = ZGV.db.profile.chainskipcount
			if skipcount==21 then return nil end
			local remaining = ZGV:GetQuestRemainingInChain(self.questid)
			if remaining then
				return remaining>ZGV.db.profile.chainskipcount
			else
				return true
			end
		else
			return true
		end
	end
	
	return false
	--]]
end

function Goal:IsAuxiliary()
	if (self.questid
	or self.action=="accept"
	or self.action=="turnin"
	or self.action=="kill"
	or self.action=="get"
	or self.action=="goal"
	or self.action=="ding") and not self.force_nocomplete
	then
		return false
	elseif self.action=="fpath" then
		local isc = self:IsComplete()
		-- it's true or false if LibTaxi is sure of its data.
		if isc~=nil then return isc end
		-- if it's not... guess.
		local step=self.parentStep
		for i=1,5 do
			step=step:GetNextStep()
			if not step then return false end
			while (step.requirement) do
				step=step:GetNextStep()
				if not step then return false end
			end
			--print("complete? "..tostring(step:IsComplete()))
			if step:IsComplete() then return true end
		end
		return false
	else
		return true
	end
end