local addonName,ZygorGuidesViewer = ...

ZygorGuidesViewer = LibStub("AceAddon-3.0"):NewAddon(ZygorGuidesViewer,addonName, "AceConsole-3.0","AceEvent-3.0","AceTimer-3.0")

if _G['ZGV'] then  RaidNotice_AddMessage(RaidWarningFrame,"Two ZygorGuideViewers loaded!\nWe're doomed!",ChatTypeInfo.YELL)  return  end

local ZGV=ZygorGuidesViewer
--global exports
_G['ZygorGuidesViewer']=ZygorGuidesViewer
_G['ZGV']=ZGV

ZGV.L = ZygorGuidesViewer_L("Main")
ZGV.LS = ZygorGuidesViewer_L("G_string")

local L = ZGV.L
local LI = ZGV.LI
local LC = ZGV.LC
local LQ = ZGV.LQ
local LS = ZGV.LS

--ZGV.name = L['name_plain']

ZGV.registeredguides = {}
ZGV.registeredmapspotsets = {}
ZGV.guidesets = {}

local DIR = "Interface\\AddOns\\"..addonName
ZGV.DIR = DIR
local SKINDIR = ""

ZYGORGUIDESVIEWER_COMMAND = "zygor"

ZYGORGUIDESVIEWERFRAME_TITLE = "ZygorGuidesViewer"

BINDING_HEADER_ZYGORGUIDES = L["name_plain"]
BINDING_NAME_ZYGORGUIDES_OPENGUIDE = L["binding_togglewindow"]
BINDING_NAME_ZYGORGUIDES_PREV = L["binding_prev"]
BINDING_NAME_ZYGORGUIDES_NEXT = L["binding_next"]

local numkalzones = select("#",GetMapZones(1))
ZGV.Expansion_WOTLK = (numkalzones==24)
ZGV.Expansion_Cata = (numkalzones==28)

local BZ = LibStub("LibBabble-Zone-3.0")
local BZL = BZ:GetUnstrictLookupTable()
local BZR = BZ:GetReverseLookupTable()
ZGV.BZL = BZL
ZGV.BZR = BZR
local BF = LibStub("LibBabble-Faction-3.0")
local BFL = BF:GetUnstrictLookupTable()
local BFR = BF:GetReverseLookupTable()
ZGV.BFL = BFL
ZGV.BFR = BFR

local _G,assert,table,string,tinsert,tonumber,tostring,type,ipairs,pairs,setmetatable,math = _G,assert,table,string,tinsert,tonumber,tostring,type,ipairs,pairs,setmetatable,math
local yield=coroutine.yield

--local Dewdrop = AceLibrary("Dewdrop-2.0")

ZGV.LibTaxi = LibStub("LibTaxi-1.0")


ZGV.CartographerDatabase = { }


ZGV.startups = {}

ZGV.StepLimit = 20
ZGV.stepframes = {}
ZGV.spotframes = {}

ZGV.mentionedQuests = {}

local STEP_LINE_SPACING = 2
local MIN_HEIGHT=80
local ICON_INDENT=17
ZGV.ICON_INDENT = ICON_INDENT  -- so that other files can access it; silly, I know
local STEP_SPACING = 2
ZGV.STEP_SPACING=STEP_SPACING
ZGV.STEPMARGIN_X=3
ZGV.STEPMARGIN_Y=3

ZGV.MIN_STEP_HEIGHT=12
ZGV.MIN_SPOT_HEIGHT=40

local MIN_WIDTH = 260
local TOP_HEIGHT = 65

--local FONT = STANDARD_TEXT_FONT
local FONT = DIR.."\\Skins\\SegoeUI.TTF"
--local FONT = "Fonts\\ArialN.TTF"
--ZGV.BUTTONS_INLINE=true


local math_modf=math.modf
math.round=function(n) local x,y=math_modf(n) return n>0 and (y>=0.5 and x+1 or x) or (y<=-0.5 and x-1 or x) end
local round=math.round


StaticPopupDialogs['ZYGORGUIDESVIEWER_HELP'] = {
	text = L['static_help'],
	button1 = OKAY,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

StaticPopupDialogs['ZYGORGUIDESVIEWER_SIS'] = {
	text = L['static_sis'],
	button1 = OKAY,
	button2 = CANCEL,
	OnAccept = function(self) ZGV:SIS_Activate() end,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
}

function ZGV:OnInitialize() 
	--print("zgv oninit")
	--if not CHECK then CHECK = 3 end

--	if not ZygorGuidesViewerMiniFrame then error("Zygor Guide Viewer step frame not loaded.") end
	self.db = LibStub("AceDB-3.0"):New("ZygorGuidesViewerSettings")

	self:Debug ("Initializing...")

	self:Options_RegisterDefaults()
	
	--self.db:SetProfile("char/"..UnitName("player").." - "..GetRealmName())

	self:Options_DefineOptions()

	self.optionsprofile = LibStub("AceDBOptions-3.0"):GetOptionsTable(self.db)

	if IsShiftKeyDown() then
		self.db.char.maint_startguides = false
		self.db.char.maint_queryquests = false
		self.db.char.maint_fetchquestdata = false
		self.db.char.maint_fetchitemdata = false
		ZygorGuidesViewerMaintenanceFrame_StartGuides:SetChecked(self.db.char.maint_startguides)
		ZygorGuidesViewerMaintenanceFrame_QueryQuests:SetChecked(self.db.char.maint_queryquests)
		ZygorGuidesViewerMaintenanceFrame_FetchQuestData:SetChecked(self.db.char.maint_fetchquestdata)
		ZygorGuidesViewerMaintenanceFrame_FetchItemData:SetChecked(self.db.char.maint_fetchitemdata)

		ZygorGuidesViewerMaintenanceFrame:Show()
	else
		self.db.char.maint_startguides = true
		self.db.char.maint_queryquests = true
		self.db.char.maint_fetchquestdata = true
		self.db.char.maint_fetchitemdata = true
	end

	self.db.char.completedQuests=nil --wipe and flush

	self.CurrentStepNum = self.db.char.step
	self.CurrentGuideName = self.db.char.guidename and self.db.char.guidename:gsub("ataclsym","ataclysm")  -- TODO: remove after a while. Ugly fix.

	self.briefstepexpansionlines = {}
	self.briefstepexpansionspeedlines = {}

	self.QuestCacheTime = 0
	self.QuestCacheUndertimeRepeats = 0
	self.StepCompletion = {}
	self.recentlyAcceptedQuests = {}
	self.recentlyLostQuests = {}
	--self.recentlyCompletedQuests = {}
	self.LastSkip = 1

	self.instantQuests = {}
	self.dailyQuests = self.dailyQuests or {}

	self.completionelapsed = 0
	self.completionintervallong = 1.0
	self.completionintervalmin = 0.01
	self.completioninterval = self.completionintervallong

	self:ClearRecentActivities() -- just to make sure they're not nils

	--self.AutoskipTemp = true

	self:SetSkin(self.db.profile.skin,self.db.profile.skinstyle)
	if not self.Frame then
		self:Print("Cannot initialize skin: "..self.db.profile.skin.."... Resetting skin.")
		self:SetSkin()
		assert(self.Frame,"Cannot initialize any skin, sorry")
	end
	ZygorGuidesViewerFrame = self.Frame
	
	self.frameNeedsResizing = 0

	self.Frame:SetScale(self.db.profile.framescale)
	self.Frame:AlignFrame()
	self:UpdateLocking()
	self:ReanchorFrame()

	self.TomTomWaypoints = {}

	self.quests = {}
	self.questsbyid = {}
	self.reputations = {}

	self.bandwidth = 0

	--LibSimpleOptions.AddOptionsPanel("Zygor's Guide",function(self) MakeOptionsControls(self,ZGV.options,ZGV) end)
	--LibSimpleOptions.AddSuboptionsPanel("Zygor's Guide",ZGV.options.args.map.name, function(self) MakeOptionsControls(self,ZGV.options.args.map,ZGV) end)
	--LibSimpleOptions.AddSuboptionsPanel("Zygor's Guide",ZGV.options.args.addons.name, function(self) MakeOptionsControls(self,ZGV.options.args.addons,ZGV) end)
	--LibSimpleOptions.AddSlashCommand("Zygor's Guide","/zygoropt")

	self:Options_SetupConfig()
	self:Options_SetupBlizConfig()

--	self:Echo(L["initialized"])
	self:Debug ("Initialized.")


	if self.LibTaxi then
		if not self.db.char.taxis then self.db.char.taxis = {} end
		self.LibTaxi:Startup(self.db.char.taxis)
	end

	if self.Pointer then self.Pointer:Startup() end
	if self.Foglight then self.Foglight:Startup() end

	if ZygorTalentAdvisor and ZygorTalentAdvisor.revision > self.revision then
		self.revision = ZygorTalentAdvisor.revision
		self.version = ZygorTalentAdvisor.version
		self.date = ZygorTalentAdvisor.date
	end

	if self.LocaleFont then FONT=self.LocaleFont end
	
	-- home detection, fire-and-forget style.
	hooksecurefunc("ConfirmBinder",function() ZygorGuidesViewer.recentlyHomeChanged=true end)

	if addonName:find("DEV") then self.DEV=true end
end

function ZGV:OnEnable()
	self:Debug("enabling")

	if self.db.profile["visible"] then self:ToggleFrame() end

	ZygorGuidesViewerMapIcon:Show()

	self:UpdateMapButton()
	self:UpdateSkin()

	self:Debug("enabled")

	self:AddEvent("UNIT_INVENTORY_CHANGED")

	-- combat detection for hiding in combat
	self:AddEvent("PLAYER_REGEN_DISABLED")
	self:AddEvent("PLAYER_REGEN_ENABLED")

	self:AddEvent("SPELL_UPDATE_COOLDOWN")

	self:AddEvent("PLAYER_CONTROL_GAINED")  -- try to force current zone updates; should prevent GoTo lines from locking up after a taxi flight

	self:AddEvent("QUEST_LOG_UPDATE")

	self:AddEvent("PLAYER_ENTERING_WORLD")  -- cache current map id
	self:AddEvent("ZONE_CHANGED")
	self:AddEvent("ZONE_CHANGED_INDOORS")
	self:AddEvent("ZONE_CHANGED_NEW_AREA")

	-- startup 'modules'
	for i,startup in ipairs(self.startups) do
		startup(self)
	end

	self:SetWaypointAddon(self.db.profile.waypointaddon)

	self.Localizers:PruneNPCs()

	self.Log.entries = self.db.char.debuglog
	self.Log:Add("Viewer started. ---------------------------")

	self.Parser.ConditionEnv:_Setup()

	-- waiting for QUEST_LOG_UPDATE for true initialization...
	--self:QueryQuests()

	if ZGV_DEV then ZGV_DEV() end

	self.loading=""
end

function ZGV:OnDisable()
--	self:UnregisterAllEvents()
	UnsetWaypointAddon()

	ZygorGuidesViewerMapIcon:Hide()
	self.Frame:Hide()
end



-- my event handling. Multiple handlers allowed, just for the heck of it.

local meta_newtables = {__index = function(tbl, key) tbl[key] = {} return tbl[key] end}
ZGV.Events=setmetatable({},meta_newtables)
function ZGV:AddEvent(event,func)
	tinsert(self.Events[event],func or true)
	if #self.Events[event]==1 then self:RegisterEvent(event,"EventHandler") end
end
function ZGV:EventHandler(event,...)
	for i,hand in ipairs(self.Events[event]) do
		local func
		if type(hand)=="function" then
			func=hand
		elseif type(hand)=="string" then
			func=self[hand]
			assert(func,"No function "..hand.." in event handler!")
		elseif hand==true then
			func=self[event]
			assert(func,"No function "..event.." in event handler!")
		end
		func(self,event,...)
	end
end




function ZGV:OnFirstQuestLogUpdate()
	if not self.guidesloaded then return end -- let the OnGuidesLoaded func call us.
	if self.questLogInitialized then return end

	--if self.db.char["starting"] then
	if ZGV.db.char.maint_startguides then
		self:SetGuide(self.db.char.guidename,self.db.char.step)

		if not self.CurrentGuide then
			self:Print("Finding proper starter section.")
			local gs = self:FindSuggestedGuides()
			if #gs==0 then
				self:Print("Cannot find a proper section for you! What are you..??")
				return
			elseif #gs==1 then
				local g=gs[1]
				self:SetGuide(g)
			else
				-- no auto-choice
			end
			self.Frame:Show()
			--self.db.char["starting"] = false
		end
	end

	self.frameNeedsResizing = 1
	self:AlignFrame()
	self:UpdateFrame(true)
	self.questLogInitialized = true
end

function ZGV:GetGuideByTitle(title)
	for i,v in ipairs(self.registeredguides) do
		if v.title==title then return v end
	end
end

function ZGV:SetGuide(name,step)
	if not name then return end
	if not step then step=1 end
	--self:Debug("SetGuide "..name.." ("..tostring(step)..")")

	local guide
	if type(name)=="number" then
		local num = name
		if self.registeredguides[num] then
			guide = self.registeredguides[num]
		else
			self:Print("Cannot find guide number: "..num)
			--return false
		end
	elseif type(name)=="string" then
		guide = self:GetGuideByTitle(name)
		if not guide then
			self:Print("Cannot find guide: "..name)
			self:Debug("Cannot find guide: "..name)
			return false
		end
	else
		guide=name  --omg, object
	end

	--if guide.is_stored then guide = self.db.global.storedguides[name] end

	local err

	if guide then
		local status,msg = guide:GetStatus()
		if status=="INVALID" and not ZGV.db.char.goodbadguides[guide.title] then
			local popup = StaticPopup_Show("ZYGORGUIDESVIEWER_BADGUIDE",guide.title_short,msg or "")
			popup.guide = guide
			popup.step = step
			return "BAD"
		end

		if self.CurrentGuide then self.CurrentGuide:Unload() end

		guide:Parse(true)

		if guide.steps then
			--self.MapNotes = _G["ZygorGuides_"..faction.."Mapnotes"]
			local name = guide.title

			self.CurrentGuide = guide
			self.CurrentGuideName = name
			self.db.char.guidename = name

			if #self.CurrentGuide.steps<step then
				step = 1
			end

			--self:QuestTracking_ResetDailies(true)

			self:Print(L["message_loadedguide"]:format(name))
			self:Debug("Guide loaded: "..name)

			self:SendMessage("ZYGORGV_GUIDE_LOADED",name)
			
			self:FocusStep(step)

			ZygorGuidesViewerFrame_Border_Guides_GuideButton:UnlockHighlight()
		else
			err = "Guide not parsed"
		end
	else
		err = L["message_missingguide"]:format(name)
	end

	if err then
		self:Print(err)
		self.db.char['guide'] = nil
		self.db.char['step'] = nil
		self.CurrentGuide = nil
		self.CurrentStep = nil
	end

	self:UpdateFrame(true)
end

function ZGV:FindSuggestedGuides()
	local suggested={}
	for i,guide in ipairs(self.registeredguides) do
		if guide:GetStatus()=="SUGGESTED" then
			if guide.condition_suggested_exclusive then
				return {guide}
				-- suggest-exclusive guides force their suggestion, if suggested.
			else
				tinsert(suggested,guide)
			end
		end
	end
	return suggested
end

function ZGV:GetGuideFolderInfo(folder)
	local suggest
	for i,guide in ipairs(folder.guides) do
		if guide:GetStatus()=="SUGGESTED" then suggest=true end
	end
	if not suggest then
		for i,group in ipairs(folder.groups) do
			if self:GetGuideFolderInfo(group) then suggest=true end
		end
	end
	return suggest
end

-- function ZGV:SearchForCompleteableGoal() --removed

function ZGV:ClearRecentActivities()
	self.recentlyVisitedCoords = {}
	self.recentlyCompletedGoals = {}
	self.recentlyAcceptedQuests = {}
	self.recentlyStickiedGoals = {}
	self.recentGoalProgress = {}
	self.recentCooldownsPulsing = {}
	self.recentCooldownsStarted = {}
	self.recentlyHomeChanged = false
	self.recentlyDiscoveredFlightpath = false
	self.recentlyLearnedRecipes = {}
	self.recentKills = {}
	-- self.completedQuestTitles = {} -- let's not use this anymore, with GetQuestID available
end

function ZGV:FocusStep(num,quiet)
	if type(num)=="string" and self.CurrentGuide.steplabels then num=self.CurrentGuide.steplabels[num] end
	if not num or num<=0 then return end
	if not self.CurrentGuide then return end
	if not self.CurrentGuide.steps then return end
	if num>#self.CurrentGuide.steps then return end

	self:Debug("FocusStep "..num..(quiet and " (quiet)" or ""))

	self.CurrentStepNum = num
	self.db.char.step = num
	self.CurrentStep = self.CurrentGuide.steps[num]
	self.CurrentGuide.CurrentStepNum = num

	self:ClearRecentActivities()

	-- Whoa whoa. The step might load a different guide at this point! Play safe.
	local cs=self.CurrentStep
	local cg=self.CurrentGuide
	self.CurrentStep:PrepareCompletion()
	if (cs~=self.CurrentStep) or (cg~=self.CurrentGuide) then self:Debug("FocusStep: guide changed! bailing.") return end

	self.stepchanged = true

	for i,goal in ipairs(self.CurrentStep.goals) do
		if goal:IsComplete() then self.recentlyCompletedGoals[goal]=true end
	end

	local stepcomplete,steppossible = self.CurrentStep:IsComplete()
	if self.pause then
		if (self.db.profile.skipimpossible and not steppossible)
		or (self.db.profile.skipobsolete and self.CurrentStep:IsObsolete())
		or (self.db.profile.skipauxsteps and self.CurrentStep:IsAuxiliarySkippable()) then
			stepcomplete=true
			--self.pause=nil
		end
		self.LastSkip=1
		if not stepcomplete then
			self:Debug("unpausing")
			self.pause=nil
		end
	end
	--and self.LastSkip~=0) then self.AutoskipTemp=false else self.AutoskipTemp=true end

	-- add to last-guides history
	local history = self.db.char.guides_history
	local found
	for i,g in ipairs(history) do
		if g[1]==self.CurrentGuide.title then
			-- move to front
			tremove(history,i)
			tinsert(history,1,{self.CurrentGuide.title,self.CurrentStepNum})
			found=true
			break
		end
	end
	if not found then
		tinsert(history,1,{self.CurrentGuide.title,self.CurrentStepNum})
		if #history>self.db.profile.guidesinhistory then tremove(history) end
	end

	self:SendMessage("ZYGORGV_STEP_CHANGED",num)

	if not quiet then
		self:FocusStepUnquiet()
	end

	if self.TryToDisplayCreature then self:TryToDisplayCreature() end
	--self:UpdateMinimapArrow(true)

	--self:AnimateGears()
end

function ZGV:FocusStepQuiet(num)
	return self:FocusStep(num,true)
end

function ZGV:FocusStepUnquiet()
	self:StopFlashAnimation()
	self.frameNeedsResizing = self.frameNeedsResizing + 1
	self:UpdateFrame(true)
	self:ScrollToCurrentStep()
	self:UpdateCooldowns()

	--self:UpdateCartographerExport()  -- moved to Waypoints where it belongs.
	self:SetWaypoint()
end

--- A quest is 'interesting' if any follow-ups to it appear anywhere in the guides and they're not gray.
-- As of 3.1, no follow-ups are tracked.

--[[
local followupcache={}
function ZGV:GetMentionedFollowups(questid)
	if followupcache[questid] then return followupcache[questid] end
	local q,f
	local live = {questid}
	local fups = {}
	local lev
	--self:Debug("Caching mentioned followups of "..questid)
	local cycles=0
	while #live>0 do
		cycles=cycles+1
		assert(cycles<1000,"Quest "..questid.." has infinitely resolving live followups: "..table.concat(live,","))

		q = tremove(live,1)
		lev = self.mentionedQuests[q]
		if lev then tinsert(fups,{q,lev}) end

		f = self.RevChains[q]
		if f then
			for i=1,#f do
				-- make sure there are no circular references
				if f[i]==questid then break end
				local found
				-- don't add stuff that's already in the live group
				for l=1,#live do if live[l]==f[i] or live[l]==questid then found=true break end end
				-- and don't add stuff that's already in followups
				if not found then for l=1,#fups do if fups[l][1]==f[i] then found=true break end end end
				if found then break end
				tinsert(live,f[i])

				--error("Circular quest reference: "..q.." requires "..f[i]..", already required by "..questid)  -- screw it, they MAY require old quests, just not in circles. Fix circles quietly.
			end
		end
		assert(#live<1000,"Quest "..questid.." has live followups > 1000: "..table.concat(live,","))
	end
	followupcache[questid]=fups
	return fups
end

-- A quest's "maximum chained level" can be safely cached, I guess.
-- MAY YIELD.
function ZGV:CacheMentionedFollowups()
	local f,maxlev
	self.maxQuestLevels = {}
	local count=0
	for qid,lev in pairs(self.mentionedQuests) do
		--self.loadprogress=count/30000
		count=count+1
		if count>100 then count=0 yield() end
		f=ZGV:GetMentionedFollowups(qid)
		for i=1,#f do
			if f[i][2]>lev then lev=f[i][2] end
		end
		self.maxQuestLevels[qid]=lev
	end
end
--]]

--- Attempt to complete current step.
-- 09-09-24: 
local lastcompletion=0
local lastnextsuggested
function ZGV:TryToCompleteStep(force)
	if not self.CurrentStep or not self.CurrentGuide then return end

	if self.BUTTONS_INLINE then
		if self.actionsvisible and InCombatLockdown() then return end
	end

	-- prevent overtime checks
	local t=GetTime()
	local elapsed=t-lastcompletion
	lastcompletion=t

	local interval=self.completioninterval
	self.completionelapsed=self.completionelapsed+elapsed

	if self.completionelapsed<interval and not force then
		-- what the hell was this for?
		--[[
		if self.db.profile.displaymode then
			self:UpdateFrame()
		end
		--]]
		return
	end
	self.completionelapsed = 0

	-- frame hidden? bail.
	if not self.Frame:IsVisible() or self.Frame:GetAlpha()<0.1 then return end

	local stepcomplete,steppossible = self.CurrentStep:IsComplete()

	local completing = stepcomplete

	-- smart skipping: treat impossible or skippable as completed
	if (self.db.profile.skipimpossible and not steppossible)
	or (self.db.profile.skipobsolete and self.CurrentStep:IsObsolete())
	or (self.db.profile.skipauxsteps and self.CurrentStep:IsAuxiliarySkippable()) then
		completing=true
		--self.pause=nil
	end

	if not completing then
		interval = self.completionintervallong
		self.pause=nil
	end

	if self.pause then
		interval = self.completionintervallong
		self.LastSkip = 1
	else
		if completing then
			--self.recentlyCompletedQuests = {} -- forget it! We're skipping the step, already.
			self:Debug("Skipping step: "..self.CurrentStepNum.." ("..(stepcomplete and "complete" or (steppossible and "possible?" or "impossible"))..")")
			for gn,goal in ipairs(self.CurrentStep.goals) do self:Debug(goal:GetText().." "..goal.status) end

			if self.lasttriedstep and self.lasttriedstep==self.CurrentStep and not self.lastwascompleted then
				--newly completed!
				PlaySound(self.db.profile.completesound)
				if self.db.profile.flashborder then
					self.delayFlash=1
				end
			end

			self:SkipStep(self.LastSkip,true)
			self.fastforward=true

			interval = interval * 0.8
			if interval<self.completionintervalmin then interval=self.completionintervalmin end
			--skipped=skipped+1
			--if skipped>100 then break end

			--self:UpdateFrame()
			--updated=true

			--self.completioninterval = self.completionshortinterval


			--ZygorGuidesViewerFrame_CoverFlash_blink:Play()

			--stepcomplete = self.CurrentStep:IsComplete()
		else
			interval = self.completionintervallong
			self.pause=nil
			self.fastforward=nil
			self.LastSkip = 1
			--self.completioninterval = self.completionlonginterval
		end

		--[[
		if updated and not self.db.profile.showallsteps then
			self.stepframes[1].slideup:Play()
		end
		--]]

		--if not stepcomplete then self.AutoskipTemp=true end

		--if not updated then self:UpdateFrame() end
	end

	-- And now check if the next guide is up for suggesting.
	local nextguide = self.CurrentGuide.next
	if nextguide then
		nextguide = self:GetGuideByTitle(nextguide)
		if nextguide then
			local nextsuggested = (nextguide:GetStatus()=="SUGGESTED")
			ZGV.suggesting = nextsuggested
			if not lastnextsuggested and nextsuggested and self.db.profile.suggestionpopup then
				nextguide:AdvertiseWithPopup()
			end
			lastnextsuggested = nextsuggested
		end
	end

	self:UpdateFrame()

	self.lasttriedstep = self.CurrentStep
	self.lastwascompleted = stepcomplete

	self.completioninterval = interval
end



function ZGV:InitializeDropDown(frame)
	if not self.guidesloaded then return end

	local guides = ZygorGuidesViewer.registeredguides
	
	if not guides then return end
	
	for i,guide in ipairs(guides) do

--		ChatFrame1:AddMessage(section)
		local info = {}
		info.text = guide.title
		info.value = guide.title
		info.func = ZGVFSectionDropDown_Func
		if (self.CurrentGuideName == guide.title) then
			info.checked = 1
		else
			info.checked = nil
		end
		info.button = 1
--		if (i == 1) then
--			info.isTitle = 1
--		end
		UIDropDownMenu_AddButton(info)
	end
	UIDropDownMenu_SetText(frame, self.CurrentGuideName)
end


function ZGV:UpdateLocking()
	self.Frame:UpdateLocking()
end

function ZGV:StopFlashAnimation()
	if not self.stepframes[20] or not self.stepframes[20].lines[20] then return end
	for s=1,20 do
		for l=1,20 do
			local anim_w2g = self.stepframes[s].lines[l].anim_w2g
			if not anim_w2g then break end
			anim_w2g:Stop()
		end
	end
end

--[[
function ZGV:HideCooldown(arg)
	arg.cooldown:Hide()
	self.recentCooldownsPulsing[goal] = 2
end
--]]

function ZGV:UpdateCooldowns()
	--self:Debug("UpdateCooldowns")
	if not self.CurrentStep then return end
	local stepframe = self.stepframes[self.CurrentStepframeNum]
	if not stepframe then return end
	for i=1,20,1 do
		local cooldown = self.actionbuttons[i].cd
		if not cooldown then return end
		local goal = stepframe.lines[i].goal
		if goal and goal:IsActionable() then
			--cooldown:Show()
			--self:Debug("goal "..i.." actionable")
			if goal.castspell or goal.castspellid then
				local start,dur,en = GetSpellCooldown(goal.castspellid or goal.castspell)
				CooldownFrame_SetTimer(cooldown, start, dur, en)
				if start>0 then cooldown:Show() else cooldown:Hide() end
				--self:Debug(("spell: %d,%d,%d"):format(start,dur,en))
			elseif goal.useitemid then
				local start,dur,en = GetItemCooldown(goal.useitemid)
				CooldownFrame_SetTimer(cooldown, start, dur, en)
				if start>0 then cooldown:Show() else cooldown:Hide() end
				--self:Debug(("item: %d,%d,%d"):format(start,dur,en))
			elseif goal.petaction then
				local num,name,x,tex
				if type(goal.petaction)=="number" then
					num = goal.petaction
				else
					num,name,x,tex = FindPetActionInfo(goal.petaction)
				end
				local start,dur,en = GetPetActionCooldown(num)
				CooldownFrame_SetTimer(cooldown, start, dur, en)
				if start>0 then cooldown:Show() else cooldown:Hide() end
			end
		else
			cooldown:Hide()
		end
	end
end

local function gradient(a,b,p)
	return a+(b-a)*p
end

local function fromRGBA(ob)
	return ob.r,ob.g,ob.b,ob.a
end

local function fromRGB_a(ob,a)
	return ob.r,ob.g,ob.b,a
end

local function fromRGBmul_a(ob,mul,a)
	return ob.r*mul,ob.g*mul,ob.b*mul,a
end

local function fromRGB(ob)
	return ob.r,ob.g,ob.b
end

--local function gradientRGBA(f,t,p)  --removed

function ZGV:SetDisplayMode(mode)
	self.db.profile.displaymode=mode
	self:UpdateFrame(true)
end

local Tpi=6.2832
local cardinals = {"N","NW","W","SW","S","SE","E","NE","N"}
local function GetCardinalDirName(angle)
	for i=1,9 do
		if Tpi*((i*2)-1)/16>angle then return cardinals[i] end
	end
end
function GetCardinalDirNum(angle)
	while angle<0 do angle=angle+Tpi end
	while angle>Tpi do angle=angle-Tpi end
	local ret=1
	for i=1,16 do
		if Tpi*((i*2)-1)/32>angle then ret=i break end
	end
	return ret
end

local itemsources={"vendor","drop","ore","herb","skin"}

local gold_ox,gold_oy=0,0

local actionicon={
	["accept"]=5,
	["turnin"]=6,
	["kill"]=7,
	["get"]=8,
	["collect"]=8,
	["buy"]=8,
	["goal"]=9,
	["home"]=10,
	["fpath"]=11,
	["goto"]=12,
	["talk"]=13
}
setmetatable(actionicon,{__index=function() return 2 end})

function ZGV:UpdateFrame(full,onupdate)
	if full then self.stepchanged=true end

	if not self.Frame or not self.Frame:IsVisible() then return end

	--if InCombatLockdown() then return end
	--[[
	--		self.Frame:SetAlpha(0.5)
		return
	else
	--		self.Frame:SetAlpha(1.0)
	end
	--]]

	--self:Debug("updatemini")

	--if ZygorGuidesViewerMiniFrame_bdflash:IsPlaying() and not ZygorGuidesViewerMiniFrame_bdflash:IsDone() then return end

	self.db.profile.displaymode="guide"

	local minh = 0

	local Scroll = ZygorGuidesViewerFrame_Scroll

	local tabh = ZygorGuidesViewerFrame_Border_TabBack:GetHeight()

	if self.loading then

		ZygorGuidesViewerFrame_Border_Guides_SectionTitle:SetText(self.loading:format((self.loadprogress or 0)*100))

	elseif self.db.profile.displaymode=="guide" then

		local showbriefsteps = self.db.profile.showbriefsteps-- and self.db.profile.minimode

		self.Frame.Border.Guides:Show()
		self.Frame.Border.Gold:Hide()

		if self.CurrentGuide and self.CurrentGuide.steps then

			-- hide spot frames, if visible
			if self.spotframes[1] and self.spotframes[1]:IsVisible() then for i,spotframe in ipairs(self.spotframes) do spotframe:Hide() end end

			local showallsteps = (self.db.profile.showcountsteps==0)
			if showallsteps then
				if ZygorGuidesViewerFrame_ScrollScrollBar:GetValue()<1 then ZygorGuidesViewerFrame_ScrollScrollBar:SetValue(self.CurrentStepNum) end
				ZygorGuidesViewerFrame_ScrollScrollBar:Show()
			else
				ZygorGuidesViewerFrame_ScrollScrollBar:Hide()
			end

			if full then
				ZygorGuidesViewerFrame_ScrollScrollBar:SetMinMaxValues(1,#self.CurrentGuide.steps>0 and #self.CurrentGuide.steps or 1)
				ZygorGuidesViewerFrame_Border_Guides_StepNum.Step:SetText(self.CurrentStepNum)
				ZygorGuidesViewerFrame_Border_Guides_SectionTitle:SetText(self.CurrentGuide.title_short)
			end

			Scroll:Show()
			--ZygorGuidesViewerFrame_MissingText:Hide()

			local totalheight = 0

			local frame
			local stepnum,stepdata

			local firststep = showallsteps and math.floor(ZygorGuidesViewerFrame_ScrollScrollBar:GetValue()) or self.CurrentStepNum
			if firststep<1 then firststep=1 end
			local laststep = showallsteps and #self.CurrentGuide.steps or self.CurrentStepNum+self.db.profile.showcountsteps-1

			--self:Debug("first step "..firststep..", last step "..laststep)
			-- run through buttons and assign steps for them

			local nomoredisplayed=false

			local icon_indent = self.db.profile.goalicons and ICON_INDENT or 0
			
			for stepbuttonnum = 1,self.StepLimit do repeat
				--frame = _G['ZygorGuidesViewerFrame_Step'..stepbuttonnum]
				frame = self.stepframes[stepbuttonnum]
				
				stepnum = firststep + stepbuttonnum - 1
				
				-- show this button at all?
				if stepnum>=firststep and stepnum<=laststep and stepnum<=#self.CurrentGuide.steps then
					local stepdata = self.CurrentGuide.steps[stepnum]
					assert(stepdata,"UpdateFrame: No data for step "..stepnum)

					if nomoredisplayed then
						frame:Hide()
						break --continue
					end

					--[[
					if not self.stepchanged and not stepdata:NeedsUpdating() or (nomoredisplayed and not frame:IsVisible()) then
						break --continue
					end
					--]]
					--print("Displaying step "..stepnum)

					frame.stepnum = stepnum
					frame.step = stepdata

					--#### position step frame

					frame:SetWidth(showallsteps and ZygorGuidesViewerFrame_ScrollChild:GetWidth() or Scroll:GetWidth()) -- this is needed so the text lines below can access proper widths

					-- out of screen space? bail.
					-- but only in all steps mode!
					local top=frame:GetTop()
					local bottom=Scroll:GetBottom()
					if showallsteps and top and bottom and top<bottom then
						frame:Hide()
						nomoredisplayed=true
						break --continue!
					end

					--#### fill it with text

					local changed,dirty = stepdata:Translate()
					if dirty then
						self.frameNeedsUpdating=true
						self:SetWaypoint()
					end

					local line=1

					frame.lines[line].label:ClearAllPoints()

					if (stepdata.requirement or self.db.profile.stepnumbers) then
						local numbertext = self.db.profile.stepnumbers and L['step_num']:format(stepnum)
						local reqtext = stepdata.requirement and ((stepdata:AreRequirementsMet() and "|cff44aa44" or "|cffbb0000") .. "(" .. (table.concat(stepdata.requirement,L["stepreqor"])):gsub("!([a-zA-Z ]+)",L["req_not"]:format("%1")) .. ")")
						local leveltext = (stepdata.level and stepdata.level>0 and self.db.profile.stepnumbers) and L['step_level']:format(stepdata.level or "?")

						if showbriefsteps and not reqtext then
							frame.lines[line].briefhidden = true
						end

						if (numbertext or leveltext or reqtext) then
							frame.lines[line].label:SetPoint("TOPLEFT")
							frame.lines[line].label:SetPoint("TOPRIGHT")
							frame.lines[line].label:SetText((numbertext or "")..(leveltext or "")..(reqtext or ""))
							--frame.lines[line].label:SetMultilineIndent(1)
							frame.lines[line].goal = nil
							frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsecsize))
							line=line+1

						else
							frame.lines[line].label:SetPoint("TOPLEFT",frame.lines[line],"TOPLEFT",icon_indent+1,0)
							frame.lines[line].label:SetPoint("TOPRIGHT")
							frame.lines[line].label:SetFont(FONT,self.db.profile.fontsize)
						end
					else
						frame.lines[line].label:SetPoint("TOPLEFT",frame.lines[line],"TOPLEFT",icon_indent+2,0)
						frame.lines[line].label:SetPoint("TOPRIGHT")
						frame.lines[line].label:SetFont(FONT,self.db.profile.fontsize)
					end

					if (stepdata:AreRequirementsMet() or self.db.profile.showwrongsteps) then
						--#### insert goals

						for i,goal in ipairs(stepdata.goals) do

							if full then goal.dirtytext = true end

							if goal:GetStatus()~="hidden" then
								local briefhidden = showbriefsteps
									and (
										not goal:IsCompleteable() 
										or (self.db.profile.hidecompletedinbrief and goal:GetStatus()=="complete" and not stepdata:IsComplete())
									)
									and not goal.showinbrief
								--steptext = steptext .. ("  "):rep(goal.indent or 0) .. goal:GetText() .. "|n"
								local indent = ("  "):rep(showbriefsteps and 0 or (goal.indent or 0))
								--local goaltxt = goal:GetText(stepnum>=self.CurrentStepNum)
								--local goaltxt = goal:GetText(true,self.db.profile.showbriefsteps and (self.briefstepexpansion<=0.1 --[[or stepdata~=self.briefstepexpanded--]]))
								local goaltxt = goal:GetText(true,showbriefsteps and ((self.briefstepexpansionlines[stepbuttonnum] or 0)<=0.1 --[[or stepdata~=self.briefstepexpanded--]]))

								if goaltxt~="?" then
									local link = ((goal.tooltip and not self.db.profile.tooltipsbelow) or (goal.x and not self.db.profile.windowlocked) or goal.image) and " |cffdd44ff*|r" or ""
									frame.lines[line].label:SetFont(FONT,round(goal.action~="info" and self.db.profile.fontsize or self.db.profile.fontsecsize))
									frame.lines[line].label:SetText(indent..goaltxt..link)
									frame.lines[line].goal = goal
									frame.lines[line].briefhidden = briefhidden

									line=line+1
									--frame.lines[line].label:SetMultilineIndent(1)

									if self.db.profile.tooltipsbelow and goal.tooltip then
										frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsecsize))
										frame.lines[line].label:SetText(indent.."|cffeeeecc"..goal.tooltip.."|r")
										--frame.lines[line].label:SetMultilineIndent(1)
										frame.lines[line].goal = nil
										frame.lines[line].briefhidden = true
										line=line+1
									end
								end
							end
						end

					end

					-- ALL collapsed? come on...
					local allcoll=true
					for l=1,line-1 do
						if not frame.lines[l].briefhidden or not showbriefsteps then
							allcoll=false
							break
						end
					end
					if allcoll then
						frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsecsize))
						frame.lines[line].label:SetText("|cffaaaaaa"..L['stepcollapsed'].."|r")
						--frame.lines[line].label:SetMultilineIndent(1)
						frame.lines[line].goal = nil
						frame.lines[line].briefhidden = false
						line=line+1
					end


					local TMP_TRUNCATE = true
					local heightleft = 400
					if showallsteps and TMP_TRUNCATE then
						if stepbuttonnum>1 then
							local stepbottom = self.stepframes[stepbuttonnum-1]:GetBottom()
							local scrollbottom = Scroll:GetBottom()
							if stepbottom and scrollbottom then
								heightleft = stepbottom-scrollbottom - 2*self.STEPMARGIN_Y - 5
							else
								heightleft = 0
								--self:Debug("Error in step height calculation! step "..stepbuttonnum.." stepbottom="..tostring(stepbottom).." scrollbottom="..tostring(scrollbottom)..", forcing update")
								self.frameNeedsUpdating=true
							end
						end
					
						if heightleft<self.MIN_STEP_HEIGHT then
							frame:Hide()
							nomoredisplayed=true
							break --continue
						end
					end

					local height=0
					--frame.goallines={}
					local textheight
					frame.truncated=nil
					local abort
					for l=1,20 do
						local lineframe = frame.lines[l]
						local text = lineframe.label
						local lineheight
						if l<line and not frame.truncated then
							text:SetWidth(frame:GetWidth()-icon_indent-2*ZGV.STEPMARGIN_X)

							textheight = text:GetHeight()
							lineheight = textheight + STEP_LINE_SPACING

							if lineframe.briefhidden and showbriefsteps --[[and stepdata==self.CurrentStep--]] then
								--lineheight = lineheight * self.briefstepexpansion
								lineheight = lineheight * (self.briefstepexpansionlines[stepbuttonnum] or 0)

								--lineframe:SetAlpha(self.briefstepexpansion)
								lineframe:SetAlpha(self.briefstepexpansionlines[stepbuttonnum] or 0)
							else
								lineframe:SetAlpha(1)
							end

							height = height + lineheight

							--text:SetWidth(ZygorGuidesViewerFrameScroll:GetWidth()-30)

							if TMP_TRUNCATE and showallsteps and height>heightleft then
								lineframe.goal=nil
								if l<=2 then
									abort=true
									break
								else
									frame.truncated=true
									frame.lines[l-1].label:SetText("   . . .")
									frame.lines[l-1].goal=nil
									lineframe:Hide()
									height=height-lineheight
								end
							else
								lineframe:Show()
								--if lineframe.goal then frame.goallines[lineframe.goal.num]=lineframe end
							end

							lineframe:SetHeight(lineheight)
						else
							lineframe:Hide()
							lineframe.goal = nil
						end
					end

					if abort then
						frame:Hide()
						nomoredisplayed=true
						break --continue
					end


					--#### display it all properly

					--[[
					if height<self.MIN_STEP_HEIGHT then
						frame.lines[1]:SetPoint("TOPLEFT",frame,ZGV.STEPMARGIN_X,-4)
						frame.lines[1]:SetPoint("TOPRIGHT",frame,-ZGV.STEPMARGIN_X,-4)
						height=self.MIN_STEP_HEIGHT
					else
						frame.lines[1]:SetPoint("TOPLEFT",frame,ZGV.STEPMARGIN_X,-4)
						frame.lines[1]:SetPoint("TOPRIGHT",frame,-ZGV.STEPMARGIN_X,-4)
					end
					-- how about NO special cases
					--]]

					frame.lines[1]:SetPoint("TOPLEFT",frame,self.STEPMARGIN_X,-self.STEPMARGIN_Y)
					frame.lines[1]:SetPoint("TOPRIGHT",frame,-self.STEPMARGIN_X,-self.STEPMARGIN_Y)

					--self:Debug("step "..stepbuttonnum.." height "..height)

					if not frame.truncated or not TMP_TRUNCATE then
						frame:SetHeight(height + 2*self.STEPMARGIN_Y)
					else
						frame:SetHeight(heightleft + 2*self.STEPMARGIN_Y)
					end

					--end

					if stepbuttonnum>1 then totalheight = totalheight + STEP_SPACING end
					totalheight = totalheight + frame:GetHeight()



					if stepdata==self.CurrentStep and showallsteps then
						frame.border:Show()
					else
						frame.border:Hide()
					end

					--[[
					if self.db.profile.showallsteps and totalheight>ZygorGuidesViewerFrameScroll:GetHeight() then
						nomoredisplayed=true
						frame:Hide()
						break --continue
					end
					--]]

					if showallsteps and frame.truncated then
						nomoredisplayed=true
					end


					--oookay, frame is visible, let's fill it for real
					frame:Show()

					-- ICONS and status for ALL steps. Why not.
					for l=1,20 do

						line = frame.lines[l]
						if not line then break end

						local icon = line.icon
						local back = line.back
						
						local goal = line.goal

						if goal then

							local label = line.label
							local clicker = line.clicker
							local anim_w2g = line.anim_w2g
							local anim_w2r = line.anim_w2r

							local status,progress = goal:GetStatus()
							progress = tonumber(progress) or 0
							
							-- prepare completion effects

							-- set justCompleted only once per completion
							local justCompleted = false
							if status=="complete" and not self.recentlyCompletedGoals[goal] then
								self.recentlyCompletedGoals[goal] = true
								justCompleted = true
							end

							-- ICONS

							if self.db.profile.goalicons then
								label:SetPoint("TOPLEFT",line,"TOPLEFT",icon_indent+2,0)
								icon:SetSize(self.db.profile.fontsize*1.4,self.db.profile.fontsize*1.4)
								icon:Show()

								if status=="passive" then

									if goal.action=="talk" then
										icon:SetIcon(actionicon[goal.action])
									else
										icon:SetIcon(1)
									end
									icon:SetDesaturated(false)

								elseif status=="incomplete" then

									icon:SetIcon(actionicon[goal.action])
									icon:SetDesaturated(false)

								elseif status=="complete" then

									icon:SetIcon(3)
									icon:SetDesaturated(false)

								elseif status=="impossible" then

									icon:SetIcon(actionicon[goal.action])
									icon:SetDesaturated(true)

								elseif status=="obsolete" then
								
									--icon:SetIcon(actionicon[goal.action])
									--icon:SetDesaturated(false)
									icon:SetIcon(actionicon[goal.action])
									icon:SetDesaturated(true)

								end
							else
								label:SetPoint("TOPLEFT",line,"TOPLEFT",0,0)
								icon:Hide()
							end


							-- BACKGROUNDS

							if self.db.profile.goalbackgrounds then

								back:Show()

								-- COLORS

								local r,g,b,a=0,0,0,0

								if status=="passive" then

									r,g,b,a = 0,0,0,0

								elseif status=="incomplete" then
								
									local inc=self.db.profile.goalbackincomplete
									local pro=self.db.profile.goalbackprogressing
									local com=self.db.profile.goalbackcomplete
									r,g,b = self.gradient3(self.db.profile.goalbackprogress and progress*0.7 or 0,  inc.r,inc.g,inc.b, pro.r,pro.g,pro.b, com.r,com.g,com.b, 0.5)
									a = self.db.profile.goalbackincomplete.a

									--local r,g,b,a = gradientRGBA(self.db.profile.goalbackincomplete,self.db.profile.goalbackcomplete,self.db.profile.goalbackprogress and progress*0.7 or 0)

								elseif status=="complete" then

									r,g,b,a = fromRGBA(self.db.profile.goalbackcomplete)

								elseif status=="impossible" then

									r,g,b,a = fromRGBA(self.db.profile.goalbackimpossible)

								elseif status=="obsolete" then  -- TODO: remove?
									
									r,g,b,a = fromRGBA(self.db.profile.goalbackobsolete)

								elseif status=="warning" then
									
									r,g,b,a = fromRGBA(self.db.profile.goalbackwarning)
								end

								-- FLASHES

								if status=="incomplete" and goal.action~="goto" and self.db.profile.goalupdateflash and progress>(self.recentGoalProgress[goal] or 1) and self.frameNeedsResizing==0 and stepdata==self.CurrentStep then

									anim_w2r.r,anim_w2r.g,anim_w2r.b,anim_w2r.a = r,g,b,a
									anim_w2r:Play()
									self:Debug("Animating progress: "..goal:GetText())

									-- self.completionelapsed = 0  -- experimental delay

								elseif status=="complete" and justCompleted and self.db.profile.goalcompletionflash and self.frameNeedsResizing==0 then

									anim_w2g:Play()
									self:Debug("Animating completion.")

									-- self.completionelapsed = 0  -- experimental delay

								end

								if (anim_w2r:IsDone() or not anim_w2r:IsPlaying()) and (anim_w2g:IsDone() or not anim_w2g:IsPlaying()) then
									back:SetBackdropColor(r,g,b,a)
									back:SetBackdropBorderColor(r,g,b,a)
								end

							else
								back:Hide()
							end


							if self.recentGoalProgress[goal]~=progress then
								goal.dirtytext=true
							end

							self.recentGoalProgress[goal] = progress
							
							-- unpause when completing a goal

							if justCompleted and stepdata==self.CurrentStep then
								self.pause=nil
							end

						else
							-- no goal? ah, subtitle.
							icon:Hide()
							back:Hide()
						end
					end

					if showallsteps then
						frame:SetAlpha((stepnum<self.CurrentStepNum and 0.3) or (stepnum==self.CurrentStepNum and 1.0) or 0.8)
					else
						if stepbuttonnum==1 then
							frame:SetAlpha(1.0)
						else
							frame:SetAlpha(0.8-0.4*((stepbuttonnum-1)/(self.db.profile.showcountsteps-1)))
						end
					end

					--[[
					if stepnum==self.CurrentStepNum then
						--frame:EnableMouse(0)
						--frame:SetScript("OnClick",nil)
					else
						--frame:EnableMouse(1)
					end
					--]]

					--[[
					if stepnum==self.CurrentStepNum then
						frame:SetBackdrop({ edgeFile = ZGV.DIR.."\\Skins\\default\\midnight\\border", edgeSize = 12,  })
					else
						frame:SetBackdrop({ edgeFile = ZGV.DIR.."\\Skins\\default\\midnight\\border", edgeSize = 12 })
					end
					--]]

					if stepdata:AreRequirementsMet() then
						if stepdata:IsComplete() then
							frame:SetBackdropColor(fromRGBmul_a(self.db.profile.goalbackcomplete,0.5,self.db.profile.stepbackalpha))
							frame:SetBackdropBorderColor(fromRGBmul_a(self.db.profile.goalbackcomplete,0.5,self.db.profile.stepbackalpha))
							--frame:SetBackdropColor(0,0.7,0,0.5)
						elseif (self.db.profile.skipobsolete and stepdata:IsObsolete()) then
							frame:SetBackdropColor(fromRGBmul_a(self.db.profile.goalbackobsolete,0.5,self.db.profile.stepbackalpha))
							frame:SetBackdropBorderColor(fromRGBmul_a(self.db.profile.goalbackobsolete,0.5,self.db.profile.stepbackalpha))
						elseif (self.db.profile.skipauxsteps and stepdata:IsAuxiliarySkippable()) then
							frame:SetBackdropColor(fromRGBmul_a(self.db.profile.goalbackaux,0.5,self.db.profile.stepbackalpha))
							frame:SetBackdropBorderColor(fromRGBmul_a(self.db.profile.goalbackaux,0.5,self.db.profile.stepbackalpha))
						else
							frame:SetBackdropColor(0.0,0.0,0.0,self.db.profile.stepbackalpha)
							frame:SetBackdropBorderColor(0,0,0,self.db.profile.stepbackalpha)
						end
					else
						frame:SetBackdropColor(0.5,0.0,0.0,self.db.profile.stepbackalpha)
						frame:SetBackdropBorderColor(0.5,0.0,0.0,self.db.profile.stepbackalpha)
					end

					if not self.db.profile.showstepborders then
						frame:SetBackdropColor(0,0,0,0)
						frame:SetBackdropBorderColor(0,0,0,0)
					end

					--text:Show()

				else	-- not showing this one

					if frame then
						frame:Hide()
					end
				end
			until true end

			self.stepchanged=false

			-- set minimum frame size to one step
			minh = self.stepframes[1]:GetHeight() + TOP_HEIGHT + ZygorGuidesViewerFrame_Border_TabBack:GetHeight()

			self:UpdateFrameCurrent()

			--self:HighlightCurrentStep()

			-- steps displayed, clear the remaining slots

		else -- no current guide?

			local guides = self:GetGuides()
			if #guides>0 then
				ZygorGuidesViewerFrame_Border_Guides_SectionTitle:SetText(L["guide_notselected"])
			else
				ZygorGuidesViewerFrame_Border_Guides_SectionTitle:SetText(L["guide_notloaded"])
			end
		end

	elseif self.db.profile.displaymode=="gold" then

		self.Frame.Border.Gold:Show()
		self.Frame.Border.Guides:Hide()

		local x,y = GetPlayerMapPosition("player")
		local d = GetPlayerFacing()
		if x==gold_ox and y==gold_oy and d==gold_od and not full then return end
		gold_ox,gold_oy,gold_od = x,y,d

		-- get rid of tooltips, before they get messed up
		if ZGV.hasTooltipOverSpotLink then GameTooltip:Hide() ZGV.hasTooltipOverSpotLink=nil end

		-- hide step frames, if visible
		if self.stepframes[1]:IsVisible() then for i,stepframe in ipairs(self.stepframes) do stepframe:Hide() end end

		local spots
		if self.db.profile.golddistmode==1 then spots = ZGV:GetMapSpotsInRange()
		elseif self.db.profile.golddistmode==2 then spots = ZGV:GetMapSpotsInZone()
		else spots = ZGV:GetAllMapSpots()
		end

		if #spots>0 then
			if full then
				Scroll:Show()
				--ZygorGuidesViewerFrame_MissingText:Hide()
				if ZygorGuidesViewerFrame_ScrollScrollBar:GetValue()<1 then ZygorGuidesViewerFrame_ScrollScrollBar:SetValue(1) end
				ZygorGuidesViewerFrame_ScrollScrollBar:Show()
				ZygorGuidesViewerFrame_ScrollScrollBar:SetMinMaxValues(1,#spots)
				ZygorGuidesViewerFrame_Border_Guides_SectionTitle:SetText("Gold Spots")
			end

		else -- no gold guides or no spots in range
			Scroll:Hide()
			--ZygorGuidesViewerFrame_MissingText:Show()

			if #self.registeredmapspotsets>0 then
				ZygorGuidesViewerFrame_MissingText:SetText(L['gold_missing_nospotsinrange'])
			else
				ZygorGuidesViewerFrame_MissingText:SetText(L['gold_missing_noguidesloaded'])
			end
		end

		local totalheight = 0

		local frame
		local spotnum

		local firstspot = math.floor(ZygorGuidesViewerFrame_ScrollScrollBar:GetValue())
		if firstspot<1 then firstspot=1 end
		local lastspot = #spots

		--self:Debug("first step "..firststep..", last step "..laststep)
		-- run through buttons and assign steps for them

		local nomoredisplayed=false
		
		for spotbuttonnum = 1,self.StepLimit do repeat
			--frame = _G['ZygorGuidesViewerFrame_Step'..stepbuttonnum]
			frame = self.spotframes[spotbuttonnum]
			assert(frame,"Out of spot frames at "..spotbuttonnum)
			
			spotnum = firstspot + spotbuttonnum - 1
			
			-- show this button at all?
			if spotnum>=firstspot and spotnum<=lastspot and spotnum<=#spots then
				local spotdata = spots[spotnum]
				assert(spotdata,"UpdateFrame: No data for spot "..spotnum)

				if nomoredisplayed then
					frame:Hide()
					break --continue
				end

				frame.spotnum = spotnum
				frame.spot = spotdata

				--#### position step frame

				frame:SetWidth(ZygorGuidesViewerFrame_ScrollChild:GetWidth()) -- this is needed so the text lines below can access proper widths

				-- out of screen space? bail.
				-- but only in all steps mode!
				local top=frame:GetTop()
				local bottom=ZygorGuidesViewerFrame_Scroll:GetBottom()
				if top and bottom and top<bottom then
					frame:Hide()
					nomoredisplayed=true
					break --continue!
				end

				--#### fill it with text

				-- no translation here
				--[[
				local changed,dirty = stepdata:Translate()
				if dirty then self.frameNeedsUpdating=true end
				--]]

				local line=1

				assert(frame.lines[line],"Out of lines ("..line..") in spot frame "..spotbuttonnum)

				frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsize))
				
				-- cardinal names
				--frame.lines[line].label:SetText(("|cffffbb00%s|r (%s %s)"):format(spotdata.title or "?",ZGV.FormatDistance(spotdata.waypoint.minimapFrame.dist),GetCardinalDirName(Astrolabe:GetDirectionToIcon(spotdata.waypoint.minimapFrame))))

				-- icons

				--local dirnum=GetCardinalDirNum(-Astrolabe:GetDirectionToIcon(spotdata.waypoint.minimapFrame) + GetPlayerFacing())-1 --:30:30:0:0:32:32:0:0:0:0
				--local dirnum2=dirnum>8 and 16-dirnum or dirnum
				--local arrow = ("|Tinterface\\addons\\ZygorGuidesViewer____\\skins\\arrow-mini-multi:20:20:0:0:32:512:%d:%d:%d:%d|t"):format(dirnum>8 and 32 or 0,dirnum>8 and 0 or 32,dirnum2*32,(dirnum2+1)*32)
				--frame.lines[line].label:SetText(("%s |cffffbb00%s|r (%s)"):format(arrow, spotdata.title or "?",ZGV.FormatDistance(spotdata.waypoint.minimapFrame.dist)))

				local angle = Astrolabe:GetDirectionToIcon(spotdata.waypoint.minimapFrame) + GetPlayerFacing()
				local sin,cos = math.sin(angle)*0.71, math.cos(angle) * 0.71
				frame.arrow:SetTexCoord(0.5-sin, 0.5+cos, 0.5+cos, 0.5+sin, 0.5-cos, 0.5-sin, 0.5+sin, 0.5-cos)
				frame.arrowdist:SetText(ZGV.FormatDistance(spotdata.waypoint.minimapFrame.dist):gsub(" ","|n"))
				
				frame.lines[line].label:SetText(("|cffffbb00%s|r"):format(spotdata.title or "?"))
				line=line+1

				--[[
				frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsize))
				frame.lines[line].label:SetText(("|cffffff00%s %s,%s|r"):format(spotdata.map,spotdata.x,spotdata.y))
				line=line+1
				--]]

				if (spotdata.desc) then
					frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsize))
					frame.lines[line].label:SetText(("%s"):format(spotdata.desc))
					line=line+1
				end


				if spotdata.objects then
					for s,source in ipairs(itemsources) do
						local objs = spotdata:GetObjectsOfType(source,true)
						if objs then
							local mobs = source=="drop" and spotdata.mobs
							local mobtext
							if mobs then
								mobtext = ""
								for i,mob in ipairs(spotdata.mobs) do
									if #mobtext>0 then mobtext = mobtext .. ", " end
									mobtext = mobtext .. mob.name
								end
							elseif spotdata.vendorid then
								mobtext = spotdata.vendor
							end
							
							--[[
							-- all in one line; tidy but impractical
							local header = L['gold_header_'..source]:format(mobtext or "mob")
							local str=""
							for o,obj in ipairs(objs) do
								if not obj.hidden then
									if obj.item.id then
										str = str .. "|Hitem:"..obj.item.id.."|h"..(obj.icon or "item").."|h "
									else
										str = str .. " ["..obj.item.name.."]"
									end
								end
							end

							if #str>0 then
								frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsize))
								--frame.lines[line].label:SetText("<html><body><p>"..("|cffdddd66%s |r%s"):format(header,str).."</p></body></html>")
								frame.lines[line].label:SetText(("|cffdddd66%s |r%s"):format(header,str))
								line=line+1
							end
							--]]

							local goodobjs = {}
							for o,obj in ipairs(objs) do
								if not obj.hidden then
									tinsert(goodobjs,obj)
								end
							end

							if #goodobjs then
								frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsize))
								--frame.lines[line].label:SetText("<html><body><p>"..("|cffdddd66%s |r%s"):format(header,str).."</p></body></html>")
								frame.lines[line].label:SetText(("|cffdddd66%s|r"):format(L['gold_header_'..source]:format(mobtext or "mob")))
								line=line+1

								for o,obj in ipairs(goodobjs) do
									local str
									if obj.item.id then
										str = "|Hitem:"..obj.item.id.."|h"..(obj.icon or "item").." "..(obj.string or "?").."|h "
									else
										str = obj.item.name
									end

									if obj.toohard then str = "|cffff0000"..str.."|r" end

									frame.lines[line].label:SetFont(FONT,round(self.db.profile.fontsize*1.0))
									frame.lines[line].label:SetText(str)
									frame.lines[line].label:SetHyperlinksEnabled(false)
									frame.lines[line].label.reenableHyperlinks=true
									line=line+1

								end
							end
						end
					end
				end

				local TMP_TRUNCATE = true
				local heightleft = 400
				if TMP_TRUNCATE then
					if spotbuttonnum>1 then
						local spotbottom = self.spotframes[spotbuttonnum-1]:GetBottom()
						local scrollbottom = ZygorGuidesViewerFrame_Scroll:GetBottom()
						if spotbottom and scrollbottom then
							heightleft = spotbottom-scrollbottom - 2*self.STEPMARGIN_Y - 5
						else
							heightleft = 0
							self:Debug("Error in spot height calculation! spot "..spotbuttonnum.." spotbottom="..tostring(spotbottom).." scrollbottom="..tostring(scrollbottom)..", forcing update")
							--self.frameNeedsUpdating=true
						end
					end
				
					if heightleft<self.MIN_STEP_HEIGHT then
						frame:Hide()
						nomoredisplayed=true
						break --continue
					end
				end

				local height=0
				--frame.goallines={}
				local textheight
				frame.truncated=nil
				local abort

				for l=1,20 do
					local lineframe = frame.lines[l]
					local text = lineframe.label
					if l<line and not frame.truncated then
						text:SetWidth(frame:GetWidth()-icon_indent-2*ZGV.STEPMARGIN_X)
						
						-- old non-HTML stuff
						if text:GetRegions() then
							textheight = text:GetRegions():GetHeight()
						else
							textheight = text:GetHeight()
						end
						text:SetHeight(textheight)

						height = height + (height>0 and STEP_LINE_SPACING or 0) + textheight
						--text:SetWidth(ZygorGuidesViewerFrameScroll:GetWidth()-30)

						if TMP_TRUNCATE and height>heightleft then
							if l<=2 then
								abort=true
								break
							else
								frame.truncated=true
								frame.lines[l-1].label:SetText("   . . .")
								lineframe:Hide()
								height=height-textheight-STEP_LINE_SPACING
							end
						else
							lineframe:Show()
							--if lineframe.goal then frame.goallines[lineframe.goal.num]=lineframe end
							lineframe:SetHeight(textheight+STEP_LINE_SPACING)
						end

					else
						lineframe:Hide()
					end
				end

				if abort then
					frame:Hide()
					nomoredisplayed=true
					break --continue
				end

				--self:Print(("spot %d, height %s"):format(spotbuttonnum,height))

				--#### display it properly

				if height<self.MIN_SPOT_HEIGHT then
					frame.lines[1]:SetPoint("TOPLEFT",frame.arrow:GetWidth()+ZGV.STEPMARGIN_X,-(self.MIN_SPOT_HEIGHT-height)/2-0.6)
					frame.lines[1]:SetPoint("TOPRIGHT",-ZGV.STEPMARGIN_X,-(self.MIN_SPOT_HEIGHT-height)/2-0.6)
					height=self.MIN_SPOT_HEIGHT
				else
					frame.lines[1]:SetPoint("TOPLEFT",frame,frame.arrow:GetWidth()+ZGV.STEPMARGIN_X,-ZGV.STEPMARGIN_Y)
					frame.lines[1]:SetPoint("TOPRIGHT",frame,-ZGV.STEPMARGIN_X,-ZGV.STEPMARGIN_Y)
				end

				if not frame.truncated or not TMP_TRUNCATE then
					frame:SetHeight(height + 3*self.STEPMARGIN_Y)
				else
					frame:SetHeight(heightleft + 2*self.STEPMARGIN_Y)
				end

				--end

				if spotbuttonnum>1 then totalheight = totalheight + STEP_SPACING end
				totalheight = totalheight + frame:GetHeight()


				if frame.truncated then
					nomoredisplayed=true
				end

				--oookay, frame is visible, let's fill it for real
				frame:Show()

				if self.db.profile.showstepborders then
					frame:SetBackdropColor(0,0,0,self.db.profile.stepbackalpha)
					frame:SetBackdropBorderColor(0,0,0,self.db.profile.stepbackalpha)
				else
					frame:SetBackdropColor(0,0,0,0)
					frame:SetBackdropBorderColor(0,0,0,0)
				end

				--text:Show()

			else	-- not showing this one

				if frame then
					frame:Hide()
					--[[
					local prename = "ZygorGuidesViewerFrame_Step"..stepnum.."_Text"
					for line=1,10 do
						local text = _G[prename..line]
						text:SetHeight(0.1)
					end
					--]]
					--[[
					frame:SetHeight(0)
					frame:ClearAllPoints()
					frame:SetPoint("TOPLEFT")
					--]]
				end
			end
		until true end

		self.stepchanged=false

		-- set minimum frame size to one step
		minh = self.spotframes[1]:GetHeight() + TOP_HEIGHT + tabh

		--self:HighlightCurrentStep()

		-- steps displayed, clear the remaining slots
		
		
		--ZygorGuidesViewerFrame_Border_TitleBar_PrevButton:Show()
		--ZygorGuidesViewerFrame_Border_TitleBar_NextButton:Show()
		--ZygorGuidesViewerFrame_Border_TitleBar_Step:Show()
		--ZygorGuidesViewerFrame_Border_TitleBar_StepText:SetText(self.CurrentStepNum)
		--ZygorGuidesViewerFrame_Border_TitleBar_StepText:Show()

	end

	if minh<MIN_HEIGHT+tabh then minh=MIN_HEIGHT+tabh end
	self.Frame:SetMinResize(MIN_WIDTH,minh)
	if self.Frame:GetHeight()<minh-0.01 then self.Frame:SetHeight(minh) end

	self:ResizeFrame()

	if self.delayFlash and self.delayFlash>0 then
		self.delayFlash=2 --ready to flash!
		--ZygorGuidesViewerFrame_bdflash:StartRGB(1,1,1,1,0,1,0,1)
	end
end


function ZGV:ClearFrameCurrent()
	if InCombatLockdown() then return end
	for i=1,20 do
		self.actionbuttons[i]:Hide()
		self.petactionbuttons[i]:Hide()
		self.actionbuttons[i].cd:Hide()
	end
end


function ZGV:UpdateFrameCurrent()
	-- current step!

	if self.CurrentStep then	-- hey, it may be missing, if the whole guide is for another class

		--local mapped = self.CurrentStep.x

		--[[
		ZygorGuidesViewerFrame_ActiveStep:SetBackdrop({bgFile = "Interface/Tooltips/UI-Tooltip-Background", 
							    edgeFile = "Interface/Tooltips/UI-Tooltip-Border", 
							    tile = true, tileSize = 16, edgeSize = 16, 
							    insets = { left = 4, right = 4, top = 4, bottom = 4 }})
		--]]
		
		--[[
		if self.CurrentStep.requirement then
			ZygorGuidesViewerFrame_ActiveStep_Line0:SetText((self.CurrentStep:AreRequirementsMet() and "|cff88cc88" or "|cffbb0000") .. "(" .. table.concat(self.CurrentStep.requirement,L["stepreqor"]) .. ")")
			height = height + ZygorGuidesViewerFrame_ActiveStep_Line0:GetHeight()+STEP_LINE_SPACING
			ZygorGuidesViewerFrame_ActiveStep_Line1:ClearAllPoints()
			ZygorGuidesViewerFrame_ActiveStep_Line1:SetPoint("TOPLEFT",ZygorGuidesViewerFrame_ActiveStep_Line0,"BOTTOMLEFT",-ICON_INDENT,-STEP_LINE_SPACING)
			ZygorGuidesViewerFrame_ActiveStep_Line1:SetPoint("TOPRIGHT",ZygorGuidesViewerFrame_ActiveStep_Line0,"BOTTOMRIGHT",0,-STEP_LINE_SPACING)
			ZygorGuidesViewerFrame_ActiveStep_Line0:Show()
		else
			ZygorGuidesViewerFrame_ActiveStep_Line1:ClearAllPoints()
			ZygorGuidesViewerFrame_ActiveStep_Line1:SetPoint("TOPLEFT",ZygorGuidesViewerFrame_ActiveStep)
			ZygorGuidesViewerFrame_ActiveStep_Line1:SetPoint("TOPRIGHT",ZygorGuidesViewerFrame_ActiveStep)
			ZygorGuidesViewerFrame_ActiveStep_Line0:Hide()
		end
		--]]

		local name, line,label,icon,back,clicker,anim_w2g,anim_w2r,action,petaction,cooldown, lastlabel
		local height = 0

		if not self.stepframes[1].stepnum then return end

		local framenum = (self.CurrentStepNum - self.stepframes[1].stepnum + 1)
		if framenum<1 or framenum>self.StepLimit then
			self.CurrentStepframeNum = nil
			return self:ClearFrameCurrent()
		else
			self.CurrentStepframeNum = framenum
		end

		local stepframe = self.stepframes[framenum]
		if not stepframe.lines[1].icon then
			ZygorGuidesViewerFrame_Step_Setup(framenum)
		end

		if not stepframe:IsVisible() then
			return self:ClearFrameCurrent()
		end

		--textline(1):ClearAllPoints()
		--textline(1):SetPoint("TOPLEFT",stepframe,"TOPLEFT",0,self.CurrentStep.requirement and -textline(1):GetHeight()-STEP_LINE_SPACING or 0)
		--textline(1):SetPoint("TOPRIGHT",stepframe,"TOPRIGHT",0,self.CurrentStep.requirement and -textline(1):GetHeight()-STEP_LINE_SPACING or 0)

		if self.BUTTONS_INLINE then
			if not InCombatLockdown() then self.actionsvisible = false end
		end

		for i=1,20,1 do  -- update all lines
			--local linenum = (self.CurrentStep.requirement and i+1 or i)

			line = stepframe.lines[i]
			if not line then break end
			label = line.label
			icon = line.icon
			back = line.back
			clicker = line.clicker
			anim_w2g = line.anim_w2g
			anim_w2r = line.anim_w2r

			-- don't even touch this in combat.
			action = self.actionbuttons[i]
			petaction = self.petactionbuttons[i]

			local goal = line.goal
			
			if goal then

				lastlabel = label

				--steptext = ("  "):rep(goal.indent or 0)
				--if i==1 then steptext = steptext .. self.CurrentStepNum .. ". " end
				--steptext = steptext .. goal:GetText(true)

				--steptext = string.gsub(steptext,"\t([a-z]+\. )","\t|cffffff88%1|r")
				--steptext = string.gsub(steptext,"\t",">")

				-- ACTION BUTTONS
				-- all non-action code: get the hell out.

				if not InCombatLockdown() and not stepframe.slideup:IsPlaying() then
					if goal:IsActionable() then
						--	cooldown:Show()
						--self:Debug("showing cooldown "..i)
						local vis

						if not self.BUTTONS_INLINE then
							action:Raise() --SetFrameLevel(ZygorGuidesViewerFrame:GetFrameLevel()+10)
							petaction:Raise() --petaction:Raise()--SetFrameLevel(ZygorGuidesViewerFrame:GetFrameLevel()+10)
						end

						if goal.castspell and goal.castspellid then
							action:SetAttribute("type1","spell")
							action:SetAttribute("spell1",goal.castspell)
							action.spellid = goal.castspellid
							action.tex:SetTexture(select(3, GetSpellInfo(goal.castspellid or goal.castspell)) or "Interface\\Icons\\Spell_Nature_FaerieFire")
							--action:SetScript("OnClick",function(self) PetActionButton_OnClick(self,"LeftButton") end)
							vis=true
							--	local start,dur,en = GetSpellCooldown(goal.castspellid or goal.castspell)
							--DoCooldown(cooldown,start,dur,en)

						elseif goal.useitem or goal.useitemid then
							action:SetAttribute("type1","item")
							action:SetAttribute("item1",goal.useitemid and "item:"..goal.useitemid  or  goal.useitem)
							action.tex:SetTexture(select(10, GetItemInfo(goal.useitemid or goal.useitem)) or "Interface\\Icons\\INV_Misc_Bag_08")
							vis=true
							--local start,dur,en = GetItemCooldown(goal.useitemid or goal.useitem)
							--DoCooldown(cooldown,start,dur,en)

						elseif goal.macro then
							action:SetAttribute("type1","macro")
							action:SetAttribute("macro","ZygorGuidesMacro"..goal.num)
							action.tex:SetTexture(select(2,GetMacroInfo(goal.macro)))
							vis=true

						elseif goal.petaction then
							local num,name,subtext,tex = FindPetActionInfo(goal.petaction)
							if num then
								petaction:SetID(num)
								petaction.tooltipName=name
								petaction.tooltipSubtext=subtext
								--action:SetScript("OnClick",function(self) PetActionButton_OnClick(self,"LeftButton") end)
								petaction.icon:SetTexture(tex)
								petaction:Show()
								petaction:ClearAllPoints()
								petaction:SetPoint("CENTER",UIParent,"BOTTOMLEFT",icon:GetLeft()+8,icon:GetBottom()+8)
								petaction:SetScale(self.db.profile.framescale)
							else
								petaction:Hide()
							end
						else
							error("IsActionable but no item/spell!")
							--[[
							if not InCombatLockdown() then
								action:Hide()
							end
							cooldown:Hide()
							--]]
						end

						if vis then
							action:Show()
							action:SetScale(self.db.profile.framescale)
							if self.BUTTONS_INLINE then
								action:SetParent(clicker)
								action:ClearAllPoints()
								action:SetPoint("CENTER",clicker,"LEFT",8,0)
								self.actionsvisible = true
							else
								action:ClearAllPoints()
								action:SetPoint("CENTER",UIParent,"BOTTOMLEFT",(icon:GetLeft() or 0) +8,(icon:GetBottom() or 0)+8)
							end
						end

						--cooldown:Show()
					else
						action:Hide()
						petaction:Hide()
					end

					-- cooldown flasher
					--[[
					local DoCooldown = function (cooldown,start,dur,en)
						CooldownFrame_SetTimer(cooldown, start, dur, en)

						-- is this useless or what
						if not InCombatLockdown() then
							if dur>0 then
								--cooldown:Show()
								--self.recentCooldownsPulsing[goal] = nil
								--self.recentCooldownsStarted[goal] = 1
								--self:Debug("pulse: showing")
							else
								--[ [
								if not self.recentCooldownsPulsed[goal] and not self.recentCooldownsPulsed[goal] then
									self.recentCooldownPulses[goal] = self:ScheduleTimer("HideCooldown",1.0,{goal=goal,cooldown=cooldown})
									self:Debug("pulse: not pulsed, pulsing now and delaying")
								end

								if self.recentCooldownsStarted[goal] and self.recentCooldownsPulsing[goal] and self.recentCooldownsPulsing[goal]==1 then
									cooldown:Show()
									self:Debug("pulse: showing, awaiting delayed hiding")
								else
									cooldown:Hide()
								end
								--] ]
							end
						else
							--cooldown:Show()
						end
					end
					--]]
				end

				-- ICON stuff moved to all steps handler

				if self.BUTTONS_INLINE then
					if action:IsShown() then icon:Hide() end
				end
				
				--clicker:Show()

				--height = height + line:GetHeight()
			else
				if not InCombatLockdown() then action:Hide() petaction:Hide() end
				action.cd:Hide()
				--label:SetText("")
				--label:SetHeight(0)
				
				--line:SetHeight(0)  -- NO. This breaks stuff.
				-- but... it's necessary..!
				
				--line:SetHeight(0)
				--cooldown:Hide()
			end
		end

		if lastlabel then
			--ZygorGuidesViewerFrame_Divider2:SetPoint("TOPLEFT",lastlabel,"BOTTOMLEFT",-15,-4)
		end

		--ZygorGuidesViewerFrame_TextTitle:SetText(self.CurrentStep.title or "")
		--if ZygorGuidesViewerFrame_TextTitle:GetRight() then ZygorGuidesViewerFrame_TextTitle:SetWidth(ZygorGuidesViewerFrame_TextTitle:GetRight()-ZygorGuidesViewerFrame_TextTitle:GetLeft()) end

		--[[
		ZygorGuidesViewerFrame_TextInfo:SetText(self.CurrentStep.info or "")
		if ZygorGuidesViewerFrame_TextInfo:GetRight() then ZygorGuidesViewerFrame_TextInfo:SetWidth(ZygorGuidesViewerFrame_TextInfo:GetRight()-ZygorGuidesViewerFrame_TextInfo:GetLeft()) end
		--ZygorGuidesViewerFrame_TextInfo:SetPoint("TOPLEFT",self.CurrentStep.title and ZygorGuidesViewerFrame_TextTitle or ZygorGuidesViewerFrame_Divider2,"BOTTOMLEFT",0,-2)
		ZygorGuidesViewerFrame_TextInfo:SetPoint("TOPLEFT",ZygorGuidesViewerFrame_Divider2,"BOTTOMLEFT",0,-2)

		ZygorGuidesViewerFrame_TextInfo2:SetText(self.CurrentStep.info2 or "")
		if ZygorGuidesViewerFrame_TextInfo2:GetRight() then ZygorGuidesViewerFrame_TextInfo2:SetWidth(ZygorGuidesViewerFrame_TextInfo2:GetRight()-ZygorGuidesViewerFrame_TextInfo2:GetLeft()) end
		--ZygorGuidesViewerFrame_TextInfo2:SetPoint("TOPLEFT",self.CurrentStep.info and ZygorGuidesViewerFrame_TextInfo or (self.CurrentStep.title and ZygorGuidesViewerFrame_TextTitle or ZygorGuidesViewerFrame_Divider2),"BOTTOMLEFT",0,-2)
		ZygorGuidesViewerFrame_TextInfo2:SetPoint("TOPLEFT",self.CurrentStep.info and ZygorGuidesViewerFrame_TextInfo or ZygorGuidesViewerFrame_Divider2,"BOTTOMLEFT",0,-2)

		height = height + ZygorGuidesViewerFrame_TextInfo:GetHeight() + ZygorGuidesViewerFrame_TextInfo2:GetHeight()
		--]]

		-- aaand anchor it.


		--ZygorGuidesViewerFrame_ActiveStep:SetHeight(height)

		--ZygorGuidesViewerFrame_ActiveStep:ClearAllPoints()

		--local t = getglobal("ZygorGuidesViewerFrame_Step"..(self.CurrentStepNum))
		--ZygorGuidesViewerFrame_ActiveStep:SetPoint("TOPLEFT",t,"TOPLEFT")
		--ZygorGuidesViewerFrame_ActiveStep:SetPoint("BOTTOMRIGHT",t,"BOTTOMRIGHT")

		--[[
		if self.db.profile.showallsteps then
			if self.CurrentStepNum==1 then
				ZygorGuidesViewerFrame_ActiveStep:SetPoint("TOPLEFT",ZygorGuidesViewerFrameScrollChild,"TOPLEFT",0,-STEP_SPACING)
				ZygorGuidesViewerFrame_ActiveStep:SetPoint("TOPRIGHT",ZygorGuidesViewerFrameScrollChild,"TOPRIGHT",0,-STEP_SPACING)
			else
				local t = getglobal("ZygorGuidesViewerFrame_Step"..(self.CurrentStepNum-1))
				ZygorGuidesViewerFrame_ActiveStep:SetPoint("TOPLEFT",t,"BOTTOMLEFT",0,-STEP_SPACING)
				ZygorGuidesViewerFrame_ActiveStep:SetPoint("TOPRIGHT",t,"BOTTOMRIGHT",0,-STEP_SPACING)
			end
		else
			-- it's all alone
			ZygorGuidesViewerFrame_ActiveStep:SetPoint("TOPLEFT",ZygorGuidesViewerFrameScrollChild,"TOPLEFT",0,-STEP_SPACING)
			ZygorGuidesViewerFrame_ActiveStep:SetPoint("TOPRIGHT",ZygorGuidesViewerFrameScrollChild,"TOPRIGHT",0,-STEP_SPACING)
		end
		--]]
	end
end

function ZGV:SetFrameScale(scale)
	scale = self.db.profile.framescale
	frame:SetScale(scale)
end

function ZGV:ReanchorFrame()
	local frame = self.Frame
	local framemaster = frame:GetParent()
	local upsideup = not self.db.profile.resizeup


	local tabbar_height = 2
	if #ZGV.registeredmapspotsets>0 then
		tabbar_height = 20
	end


	frame:ClearAllPoints()
	local tabh = ZygorGuidesViewerFrame_Border_TabBack:GetHeight()

	if frame.sizedleft then
		local q,w,e,x,y = framemaster:GetPoint()
		framemaster:ClearAllPoints()
		framemaster:SetPoint(q,w,e,x+frame:GetLeft()-frame.sizedleft,y)
		frame.sizedleft=nil
	end

	if upsideup then
		--frame:SetPoint("TOP",nil,"TOP",(left+right)/2-(uiwidth/2/scale),top-uiheight/scale)
		--frame:SetPoint("TOP",frame:GetParent(),"BOTTOMLEFT",left+width/2,top)
		frame:SetPoint("TOPLEFT",framemaster,"TOPLEFT",0,0)
		frame:SetClampRectInsets(0,0,-48-tabh,0)
	else
		--frame:SetPoint("BOTTOM",nil,"BOTTOM",(left+right)/2-(uiwidth/2/scale),bottom)
		--frame:SetPoint("BOTTOM",frame:GetParent(),"BOTTOMLEFT",left+width/2,bottom)
		frame:SetPoint("BOTTOMLEFT",framemaster,"BOTTOMLEFT",0,0)
		frame:SetClampRectInsets(0,0,0,48+tabh)
	end

	--frame:UpdateMiniMode()
end

function ZGV:AlignFrame()
	self.Frame:AlignFrame()
end

function ZGV:UpdateSkin()
	self.Frame:UpdateSkin()
end

function ZGV:ResizeFrame()
	--autosize
	--if (self.db.profile.autosize) then
	--print("resize")
	if self.frameNeedsResizing then
		if self.frameNeedsResizing>0 then self.frameNeedsResizing = self.frameNeedsResizing - 1 end
		if self.frameNeedsResizing>0 then return nil end
	end
	if not self.db then return end

	--[[
	if ZygorGuidesViewerFrame_Border_Bottom:GetRect() then
		local xsize = select(3,ZygorGuidesViewerFrame_Border_Bottom:GetRect())/200
		local ysize = select(4,ZygorGuidesViewerFrame_Border_Left:GetRect())/100
		local ysize2 = select(4,ZygorGuidesViewerFrame_Border_Right:GetRect())/100
		ZygorGuidesViewerFrame_Border_Left:SetTexCoord(0.2,0.8,0,1*ysize)
		ZygorGuidesViewerFrame_Border_Right:SetTexCoord(0.2,0.8,0,1*ysize2)
		ZygorGuidesViewerFrame_Border_Bottom:SetTexCoord(0,-xsize,1,-xsize,0,xsize,1,xsize)
	end
	--]]
	
	--ZygorGuidesViewerFrame_Border:SetBackdropColor(self.db.profile.skincolors.back[1],self.db.profile.skincolors.back[2],self.db.profile.skincolors.back[3],self.db.profile.backopacity)


	--self:Debug("resizing from "..tostring(ZygorGuidesViewerFrame:GetHeight()))

	if self.db.profile.showcountsteps==0 or self.db.profile.displaymode=="gold" then
		ZygorGuidesViewerFrame_ScrollScrollBar:Show()
	else
		-- only autoresize when showing ONE step. If we have many steps, the user handles resizing.
		ZygorGuidesViewerFrame_ScrollScrollBar:Hide()
		--if not self.CurrentStepNum or not _G['ZygorGuidesViewerFrame_Step'..self.CurrentStepNum] then return end
		local height = 0
		for i=1,self.db.profile.showcountsteps do
			if i>1 then height = height + STEP_SPACING end
			height = height + self.stepframes[i]:GetHeight()
		end

		local tabh = ZygorGuidesViewerFrame_Border_TabBack:GetHeight()

		height = height + TOP_HEIGHT + tabh
		--self:Debug("Height "..height.."  min "..MIN_HEIGHT)
		if height < MIN_HEIGHT + tabh then height=MIN_HEIGHT + tabh end
		self.Frame:SetHeight(height)
	end


	--self:Debug(("%d %d"):format(left,bottom))
--		ZygorGuidesViewerFrame:SetHeight(ZygorGuidesViewerFrame_Text:GetHeight()+35)
	

--	if ZygorGuidesViewerFrame_ActiveStep_Line1:GetTop() then
		--ZygorGuidesViewerFrame_Resize.max = ZygorGuidesViewerFrame_Line1:GetTop()-ZygorGuidesViewerFrame_TextInfo2:GetBottom()+35
		--ZygorGuidesViewerFrame_Resize:Stop()
		--ZygorGuidesViewerFrame_Resize:Play()

--		ZygorGuidesViewerFrame:SetHeight(ZygorGuidesViewerFrame_ActiveStep_Line1:GetTop()-ZygorGuidesViewerFrame_TextInfo2:GetBottom()+35)
--	end

--	end
end

function ZGV:GoalProgress(goal)
	return "epic fail"
end


function ZGV:ScrollToCurrentStep()
--	if self.ForceScrollToCurrentStep and self.CurrentStep then
--		self.ForceScrollToCurrentStep = false
		if self.CurrentStep and self.db.profile.displaymode=="guide" then

			local height=0
			local step
			if self.db.profile.showcountsteps==0 then
				local topstep = self.stepframes[1].stepnum
				if not topstep then return end
				if self.stepframes[1].stepnum>self.CurrentStepNum --above
				or (topstep+self.StepLimit-1<self.CurrentStepNum) --way below
--				or (ZygorGuidesViewerFrame_Step1:GetTop()-_G['ZygorGuidesViewerFrame_Step'..(self.CurrentStepNum-topstep+1)]:GetBottom()+STEP_SPACING>ZygorGuidesViewerFrameScroll:GetHeight()) --barely offscreen
				or not self.stepframes[self.CurrentStepNum-topstep+1]:IsShown()
				or self.stepframes[self.CurrentStepNum-topstep+1].truncated
				then
					ZygorGuidesViewerFrame_ScrollScrollBar:SetValue(self.CurrentStepNum)
					ZygorGuidesViewerFrame_ScrollScrollBar:Show()
				end
			else
				ZygorGuidesViewerFrame_ScrollScrollBar:Hide()
			end
		end
--	else
--		self.ForceScrollToCurrentStep = true
--	end
end

function ZGV:IsVisible()
	return self.Frame:IsVisible()
end

function ZGV:SetVisible(info,onoff)
	if not onoff and self:IsVisible() then self:ToggleFrame() end
	if onoff and not self:IsVisible() then self:ToggleFrame() end
end

function ZGV:ToggleFrame()
	if self:IsVisible() then
		self.Frame:Hide()
	else
		self.Frame:Show()
	end
end

function ZGV:IsDefaultFitting(default)
	-- deprecated?
	local _,race = UnitRace("player")
	local _,class = UnitClass("player")
	if (class=="DEATHKNIGHT") then race=class end
	default=default:upper()
	race=race:upper()
	class=class:upper()
	return race==default or class==default or race.." "..class==default
end

--- Checks if the player's race/class matches the requirements.
-- @param requirement May be a string or a table of strings (which are then ORed).
-- @return true if matching, false if not.
function ZGV:RaceClassMatch(fit)
	if type(fit)=="table" then
		for i,v in ipairs(fit) do if self:RaceClassMatch(v) then return true end end
		return false --otherwise
	end

	local _,race = UnitRace("player")
	local _,class = UnitClass("player")
	race=race:upper()
	class=class:upper()
	fit=fit:upper()
	local neg=false
	if fit:sub(1,1)=="!" then
		neg=true
		fit=fit:sub(2)
	end
	local ret = (race==fit or class==fit or race.." "..class==fit)
	if neg then return not ret else return ret end
end

function ZGV:RaceClassMatchList(list)
	list=list..","
	local st,en=1
	for fit in list:gmatch("(.-),") do
		if self:RaceClassMatch(fit) then return true end
	end
end

function ZGV:SkipStep(delta,fast)
	if not self.CurrentGuide then return end

	local skipped=0
	local atstart = false

	self.completionelapsed=0
	repeat
		self:Debug("SkipStep "..delta.." "..(fast and 'fast' or ''))
		local i = self.CurrentStepNum+delta
		if i<1 then
			--if self.CurrentGuideName==1 then return end		-- first section? bail.
			atstart=true
			break
			-- no skipping back from a starter section.
			-- ... or ANY section, actually.

			--local default = self:FindDefaultGuide()

			--[[
			--
			-- how about NO skipping back from step 1? now that we've got Prefers and all
			--
			if self.CurrentGuide['prev'] then
				self:SetGuide(self.CurrentGuide['prev'])
			else
				local founddef = false
				for i,v in ipairs(self.registeredguides) do
					if v.next==self.CurrentGuideName and (not v.defaultfor or self:RaceClassMatch(v.defaultfor)) then
						self:SetGuide(i)
						founddef=true
						break
					end
				end
				if not founddef then
					atstart=true
					break
				end
			end
			--]]

			--[[
			if self.CurrentGuide.defaultfor and self.CurrentGuide.defaultfor ~= race then		-- wrong default section? move to ours.
				self:SetGuide(default)
			end
			--]]
			--i=#(self.CurrentGuide["steps"])
		end
		if i>#self.CurrentGuide["steps"] or (delta>0 and self.CurrentStep.finish) then
			if self.CurrentGuide['next'] then
				self:SetGuide(self.CurrentGuide['next'],1)
				i=1
			else
				-- no next? capping
				if self.CurrentStep.finish then
					-- capped
					self.pause=true
					return
				else
					-- cap it
					self.CurrentStep = { num=self.CurrentStepNum+1, parentGuide=self.CurrentStep.parentGuide, finish=true }
					self.CurrentStep.goals={ [1]={ num=1, action="", text="This guide is now complete.", parentStep=self.CurrentStep } }
					setmetatable(self.CurrentStep,ZGV.StepProto_mt)
					setmetatable(self.CurrentStep.goals[1],ZGV.GoalProto_mt)
					tinsert(self.CurrentGuide.steps,self.CurrentStep)
				end
			end
		end
		
		self.pause=not fast
		self.fastforward=fast
		
		self.LastSkip = delta
		self:Debug("LastSkip "..self.LastSkip)

		self:FocusStepQuiet(i) --quiet!
		skipped=skipped+1
		if skipped>10000 then error("Looping on skipping! guide "..self.CurrentGuideName.." step "..i) end
	until self.CurrentStep:AreRequirementsMet()

	if atstart then
		self.pause=true
		self.fastforward=false
	end

	self:FocusStepUnquiet()
end

function ZGV:Print(s,ifdebug)
	ChatFrame1:AddMessage(L['name']..": "..tostring(s))
	if ifdebug then self:Debug(s) end
end


local function dumpquest(quest)
	local s = ("%d. \"%s\" ##%d (lv=%d%s):\n"):format(quest.index,quest.title,quest.id,quest.level,quest.complete and ", complete" or "")
	for i,goal in ipairs(quest.goals) do
		s = s .. ("... %d. \"%s\" (%s, %s/%s%s)\n"):format(i,goal.leaderboard,goal.type,goal.num,goal.needed,goal.complete and ", complete" or "")
	end
	return s
end



function ZGV:UNIT_INVENTORY_CHANGED(event,unit)
	self:UpdateFrame(true)
	if unit=="player" then
		self:TryToCompleteStep(true)
	end
end

function ZGV:QUEST_LOG_UPDATE(event,unit)
	self:UpdateFrame(true)
	if unit=="player" then
		self:TryToCompleteStep(true)
	end
end

local blobstate=nil
function ZGV:PLAYER_REGEN_DISABLED()
	--ZygorGuidesViewerFrame_Cover:Show()
	--ZygorGuidesViewerFrame_Cover:EnableMouse(true)
	self:UpdateCooldowns()
	if self.db.profile.hideincombat then
		if self.Frame:IsVisible() then
			UIFrameFadeOut(self.Frame,0.5,ZGV.db.profile.opacitymain,0.0)
			self.hiddenincombat = true
		end
	end

	blobstate = WorldMapBlobFrame:IsShown()
	WorldMapBlobFrame:SetParent(nil)
	--WorldMapBlobFrame:ClearAllPoints()
	WorldMapBlobFrame:Hide()
	WorldMapBlobFrame.Hide = function() blobstate=nil end
	WorldMapBlobFrame.Show = function() blobstate=true end
end

function ZGV:PLAYER_REGEN_ENABLED()
	--ZygorGuidesViewerFrame_Cover:Hide()
	--ZygorGuidesViewerFrame_Cover:EnableMouse(false)
	if self.CurrentStep then self.CurrentStep:PrepareCompletion() end
	self:UpdateFrameCurrent()
	self:UpdateCooldowns()
	
	if self.hiddenincombat then
		UIFrameFadeIn(self.Frame,0.5,0.0,ZGV.db.profile.opacitymain)
		self.hiddenincombat = nil
	end

	self:UpdateLocking()

	WorldMapBlobFrame:SetParent(WorldMapFrame)
	--WorldMapBlobFrame:SetAllPoints(WorldMapDetailFrame)
	WorldMapBlobFrame.Hide = nil
	WorldMapBlobFrame.Show = nil
	if blobstate then WorldMapBlobFrame:Show() end

	if self.call_after_combat then self.call_after_combat() self.call_after_combat=nil end
end

function ZGV:SPELL_UPDATE_COOLDOWN()
	--self:Debug("Updating cooldowns")
	self:UpdateFrameCurrent()
	self:UpdateCooldowns()
end

function ZGV:PLAYER_CONTROL_GAINED()
	GetRealZoneText()
	self:TryToCompleteStep(true)
	self:CacheCurrentMap()
end

function ZGV:PLAYER_ENTERING_WORLD()
	self:CacheCurrentMap()
end

function ZGV:ZONE_CHANGED_INDOORS()
	self:CacheCurrentMap()
end

function ZGV:ZONE_CHANGED()
	self:CacheCurrentMap()
end

function ZGV:ZONE_CHANGED_NEW_AREA()
	self:CacheCurrentMap()
end

function ZGV:CacheCurrentMap()
	local old_id,old_floor = GetCurrentMapAreaID(),GetCurrentMapDungeonLevel()
	SetMapToCurrentZone()
	self.CurrentMap = GetMapNameByID(GetCurrentMapAreaID())
	SetMapByID(old_id)  SetDungeonMapLevel(old_floor)
end

function ZGV:FindData(array,what,data)
	if not (type(array)=="table") then return nil end
	local i,d
	for i,d in pairs(array) do if d[what]==data then return d end end
end



function ZGV:Frame_OnShow()
	PlaySound("igQuestLogOpen")
	--ZygorGuidesViewerFrame_Filter()
	--[[
	if UnitFactionGroup("player")=="Horde" then
		ZygorGuidesViewerFrameTitleAlliance:Hide()
	else
		ZygorGuidesViewerFrameTitleHorde:Hide()
	end
	--]]
	self.db.profile.visible = not not self.Frame:IsVisible()
	self:UpdateFrame(true)
	self:AlignFrame()

	if self.db.profile.hidearrowwithguide then
		self:SetWaypoint()
	end
end

function ZGV:Frame_OnHide()
	PlaySound("igQuestLogClose")
	self.db.profile.visible = not not self.Frame:IsVisible()
	if not InCombatLockdown() then
		for i=1,20,1 do
			ZGV.actionbuttons[i]:Hide()
			ZGV.petactionbuttons[i]:Hide()
		end
	end

	-- this is a HELL ugly hack.
	-- "Do not hide when it's the World Map that hid us".
	if self.db.profile.hidearrowwithguide
	and not WorldMapFrame.blockWorldMapUpdate -- this would mean we're enlarging the small map
	and not debugstack():find("TOGGLEWORLDMAP") -- UGLY hack
	then
		self:Debug("Hiding arrow with guide")
		self:SetWaypoint(false)
	end
end


function ZGV:GoalOnClick(goalframe,button)
	goalframe = goalframe:GetParent()
	local stepframe = goalframe:GetParent()
	local goal = goalframe.goal

	if not goal then return end
	if self.db.profile.showcountsteps>0 and stepframe.step~=self.CurrentStep then return end -- no clicking on non-current steps in compact mode
	--if stepframe:GetScript("OnClick") then stepframe:GetScript("OnClick")(stepframe,button) end

	--local num=goalframe.goalnum
	self:Debug("goal clicked "..tostring(goal.num))
	--local goal = self.CurrentStep.goals[num]
	if button=="LeftButton" then
		if goal.x and not goal.force_noway then
			self:SetWaypoint(goal.num)
		elseif goal.action=="click" then
			self:FakeCompleteGoal(goal,true)
		end
	else
		ZGV:OpenQuickStepMenu(stepframe,goalframe)
	end
end

function ZGV:GoalOnEnter(goalframe)
	local goal = goalframe:GetParent().goal
	if not goal then return end

	local wayline,infoline,image

	if goal.tooltip and not self.db.profile.tooltipsbelow then
		infoline = "|cff00ff00"..goal.tooltip.."|r"
	end
	if goal.x and goal.y and goal.map then
		-- if locked or force_noway, then no clicking, bare info.
		if self.db.profile.windowlocked or goal.force_noway then
			wayline = L['tooltip_waypoint_coords']:format((goal.mapL or goal.map).." "..goal.x..";"..goal.y)
		else
			wayline = L['tooltip_waypoint']:format((goal.mapL or goal.map).." "..goal.x..";"..goal.y)
		end
	end

	if goal.image then
		image = DIR.."\\Images\\"..goal.image..".tga"
	end

	if infoline or wayline or image then
		GameTooltip:SetOwner(goalframe,"ANCHOR_TOPRIGHT")
		GameTooltip:ClearAllPoints()
		GameTooltip:SetPoint("BOTTOM",goalframe,"TOP")
		GameTooltip:SetText(goal:GetText())

		local lines=1
		if infoline then
			GameTooltip:AddLine(infoline,0,1,0)
			if _G['GameTooltipTextLeft'..lines]:GetWidth()>300 then _G['GameTooltipTextLeft'..lines]:SetWidth(300) end
			lines=lines+1
		end
		if wayline then
			GameTooltip:AddLine(wayline,0,1,0)
			if _G['GameTooltipTextLeft'..lines]:GetWidth()>300 then _G['GameTooltipTextLeft'..lines]:SetWidth(300) end
			lines=lines+1
		end
		GameTooltip:Show()
		if image then
			local img

			--[[
			local img = _G['GameTooltipZygorImage']
			if not img then
				img = GameTooltip:CreateTexture("GameTooltipZygorImage","ARTWORK")
			end
			--]]
			img = GameTooltipTexture1
			GameTooltip:AddLine(" ")
			GameTooltip:AddTexture(image)
			img:ClearAllPoints()
			img:SetPoint("TOPLEFT",_G['GameTooltipTextLeft'..lines],"BOTTOMLEFT")
			--img:SetTexture(image)
			img:SetWidth(128)
			img:SetHeight(128)
			img:Show()
			GameTooltip:Show()
			GameTooltip:SetHeight(150 + lines*20)
		end
	end
end

function ZGV:GoalOnLeave(goalframe,num)
	GameTooltip:Hide()
end


local function insert_guides(arr,guides)
	local data
	for i,guide in ipairs(guides) do
		data = ZGV:GetGuideByTitle(guide.full)
		local item = {
			text = guide.step and L['menu_last_entry']:format(guide.short or "?",guide.step) or (guide.short or "?"),
			checked = function() return ZGV.CurrentGuideName==guide.full end,
			func = function()  CloseDropDownMenus()  ZGV:SetGuide(guide.full,guide.step) end,
			tooltipTitle = data and data.description and guide.short,
			tooltipText = data and data.description,
			tooltipOnButton = true,
		}
		tinsert(arr,item)
	end
end

local function group_to_array(group)
	local arr = {}
	for i,group in ipairs(group.groups) do
		local item = {
			text = group.name,
			hasArrow = true,
			menuList = group_to_array(group),
			keepShownOnClick = true,
			func = function(self) _G[self:GetName().."Check"]:Hide() end,
			--notCheckable = true
		}
		--if #item.menuTable>0 then
			tinsert(arr,item)
		--end
	end
	insert_guides(arr,group.guides)
	return arr
end

local function BuildDropDown_GuideMenu(level,value)
	local self=ZGV
	--[[
	local menu = { }

	menu = group_to_array(self.registered_groups)
	EasyMenu(menu,ZGVFMenu,"ZygorGuidesViewerFrame_Border_TitleBar",30,10,"MENU",3)
	--]]
end

function ZGV:GetGuidesHistory()
	local unwrapped={}
	for hi,h in ipairs(self.db.char.guides_history) do
		local g = self:GetGuideByTitle(h[1])
		if g then
			g.CurrentStepNum = h[2]
			tinsert(unwrapped,g)
		end
	end
	return unwrapped
end

function ZGV:OpenGuideMenu(path)
	if self.GuidePicker then self.GuidePicker:Show(path) return end
end

function ZGV:FakeCompleteGoal(goal,docomplete)
	if docomplete==nil then docomplete=not self.recentlyCompletedGoals[goal] end
	if docomplete then
		--self.recentlyCompletedGoals[goal]=true
		self.recentlyStickiedGoals[goal]=true
	else
		self.recentlyCompletedGoals[goal]=false
		self.recentlyStickiedGoals[goal]=false
		self.recentlyVisitedCoords[goal]=false
	end
	self.pause=nil
	self.LastSkip=1
	--self.AutoskipTemp = true
	self:TryToCompleteStep(true)
end

function ZGV:FakeCompleteQuest(questid,docomplete,questtitle)
	self.completedQuests[questtitle]=docomplete
	if questid then self.completedQuests[questid]=docomplete end
	self:Print("Marking quest '"..questtitle.."'"..(questid and " (#"..questid..")" or "").." as "..(docomplete and "completed" or "incomplete"))
	self:TryToCompleteStep(true)
end

function ZGV:OpenMapToQuest(questid)
	if self.questsbyid[questid] and WorldMap_OpenToQuest then -- 3.3.0
		WorldMap_OpenToQuest(questid)
		local done,posX,posY,obj = QuestPOIGetIconInfo(questid)
		if posX or posY then
			local q = self.questsbyid[questid]
			local title
			if q then title=q.title end
			self:Debug("Setting waypoint to POI: "..posX.." "..posY)
			self:SetWaypoint(posX*100,posY*100,title)
		end
	end
end

local lastquestid,lastquesttitle
local showqiretries=0
--[[
function ZGV:ShowQuestInfo(questid,questtitle,indump)
	self:Debug("Showing chains for "..tostring(questid).." '"..tostring(questtitle).."'")
	if not questid then questid=lastquestid questtitle=lastquesttitle else showqiretries=0 end
	lastquestid=questid lastquesttitle=questtitle showqiretries=showqiretries+1

	--if InCombatLockdown() then return end
	local max = self.maxQuestLevels[questid] or -1
	local lev = self.mentionedQuests[questid] or -1
	local col = GetQuestDifficultyColor(lev)
	local s
	if (max>lev) then
		s = ("Quest |cff%02x%02x%02x[|Hquest:%d:%d|h%s|h]|r (#%d) [level %s + chains to %s]"):format(col.r*255,col.g*255,col.b*255,questid,UnitLevel("player"),questtitle,questid,lev>0 and lev or "?",max>0 and max or "?")
	else
		s = ("Quest |cff%02x%02x%02x[|Hquest:%d:%d|h%s|h]|r (#%d) [level %s]"):format(col.r*255,col.g*255,col.b*255,questid,UnitLevel("player"),questtitle,questid,lev>0 and lev or "?")
	end

	local pre = self.Chains[questid]
	if pre then
		if type(pre)=="number" then
			s = s .. "\nPrerequisite:"
			pre={"",pre}
		else
			s = s .. "\nPrerequisites ("..(pre[1]=="AND" and "ALL" or "ANY").."):"
		end
		for i=2,#pre do
			local id = tonumber(pre[i])
			local quest,inlog = self.Localizers:GetQuestData(id)
			lev = self.mentionedQuests[id] or -1
			local caching=nil
			if (quest and not caching) then
				col = GetQuestDifficultyColor(lev)
				s=s..("\n- |cff%02x%02x%02x[|Hquest:%d:%d|h%s|h]|r (#%d) [level %s]"):format(col.r*255,col.g*255,col.b*255,id,UnitLevel("player"),quest.title,id,lev>0 and lev or "?")
			else
				if showqiretries<5 then
					if showqiretries==1 then self:Print("Retrieving quest information, please wait...") end
					self:ScheduleTimer("ShowQuestInfo",1) return
				else
					s=s.."\n- #"..id.." (retrieving quest information, please try again)"
					caching=true
				end
			end
		end
	end
	local mentioned = self:GetMentionedFollowups(questid)
	local q
	if #mentioned>1 then
		q = "Follow-ups:"
		for i=2,#mentioned do
			local id = tonumber(mentioned[i][1])
			local quest = self.Localizers:GetQuestData(id)
			lev = mentioned[i][2]
			local caching=nil
			if (quest and not caching) then
				col = GetQuestDifficultyColor(lev)
				q=q..("\n- |cff%02x%02x%02x[|Hquest:%d:%d|h%s|h]|r (#%d) [level %s]"):format(col.r*255,col.g*255,col.b*255,id,UnitLevel("player"),quest.title,id,lev>0 and lev or "?")
			else
				if showqiretries<5 then
					if showqiretries==1 then self:Print("Retrieving quest information, please wait...") end
					self:ScheduleTimer("ShowQuestInfo",1) return
				else
					q=q.."\n- #"..id.." (retrieving quest information, please try again)"
					caching=true
				end
			end
		end
	else
		q = "No follow-ups."
	end

	local rem=""
	local remaining = self:GetQuestRemainingInChain(questid)
	if remaining then
		rem = "\n\n"..remaining.." quests remain till end of chain."
	end
	
	if indump then
		self:ShowDump(s.."\n"..q..rem,"Quest information",false)
	else
		self:Print("Quest information:")
		local ss = s.."\n"..q..rem
		local sslines = {strsplit("\n",ss)}
		for i,l in ipairs(sslines) do print(l) end
	end
end

function ZGV:ToggleWatchQuest(questid)
end
--]]

function ZGV:OpenQuickStepMenu(stepframe,goalframe)
	
	ZGVFMenu.stepframe=stepframe
	ZGVFMenu.goalframe=goalframe

	local step = stepframe.step
	local goal = goalframe.goal

	local menu = {
		{
			text = L['qmenu_step']:format(step.num,step.level or "?"),
			isTitle = true,
			notCheckable=true,
		},
		{
			text = L['qmenu_step_skip'],
			tooltipTitle = L['qmenu_step_skip'],
			tooltipText = L["qmenu_step_skip_desc"],
			tooltipOnButton = true,
			func = function() self:SkipStep(1,true) end,
			--icon = ZGV.DIR .. "\\Skins\\minimaparrow-green-dot",
			keepShownOnClick = false,
		}
	}

	if goal:IsCompleteable() or (goal.map and goal.x) then
		tinsert(menu,{
			text = L['qmenu_goal']:format(goal:GetText():gsub("%|r",""):gsub("%|c........","")),
			isTitle = true,
			notCheckable=true,
		})
	end

	if goal.map and goal.x then
		tinsert(menu,{
			text = L['qmenu_goal_waypoint']:format((goal.mapL or goal.map),goal.x,goal.y),
			tooltipTitle = L['qmenu_goal_waypoint']:format((goal.mapL or goal.map),goal.x,goal.y),
			tooltipText = L['qmenu_goal_waypoint_desc'],
			tooltipOnButton = true,
			func = function()  self:SetWaypoint(goal.num)  end,
			isNotRadio=true,
		})
	end

	local id = goal.npcid or (goal.mobs and goal.mobs[1] and goal.mobs[1].id) or goal.targetid
	if id then
		local name = self.Localizers:GetTranslatedNPC(id) or "(creature)"
		tinsert(menu,{
			text = L['qmenu_goal_creature_data']:format(name),
			tooltipTitle = L['qmenu_goal_creature'],
			tooltipTitleText = L['qmenu_goal_creature_desc']:format(name),
			tooltipOnButton = true,
			func = function() self.db.profile.viewcreature=true  self.CreatureViewer:ShowCreature(id,name)  if self.CreatureViewer.failed then self:Print("Creature is not yet available - too far.") end end,
			isNotRadio=true,
		})
	end

	if goal:IsCompleteable() then
		tinsert(menu,{
			text = L['qmenu_goal_complete'],
			tooltipTitle = L['qmenu_goal_complete'],
			tooltipText = L['qmenu_goal_complete_desc'],
			tooltipOnButton = true,
			checked = function()  return goal:IsComplete()  end,
			func = function()  self:FakeCompleteGoal(goal,not self.recentlyCompletedGoals[goal])  end,
			isNotRadio=true,
		})
		if goal.quest then
			local quest,inlog = self.Localizers:GetQuestData(goal.quest.id)
			local title = quest and quest.title or "?"
			tinsert(menu,{
				text = L['qmenu_quest']:format(title),
				isTitle = true,
				notCheckable = true,
			})
			--[[
			-- no quest info anymore
			tinsert(menu,{
				text = L['qmenu_quest_info']:format(title),
				tooltipTitle = L['qmenu_quest_info']:format(title),
				tooltipText = L['qmenu_quest_info_desc'],
				tooltipOnButton = true,
				func = function() self:ShowQuestInfo(goal.quest.id,title,IsShiftKeyDown())  end,
			})
			--]]
			if inlog then
				local ind=goal.quest.index
				tinsert(menu,{
					text = L['qmenu_quest_openlog'],
					tooltipTitle = L['qmenu_quest_openlog'],
					tooltipText = L['qmenu_quest_openlog_desc'],
					tooltipOnButton = true,
					func = function()  ShowUIPanel(QuestLogFrame)  QuestLog_SetSelection(ind) QuestLog_Update() end,
				})
				tinsert(menu,{
					text = L['qmenu_quest_watched'],
					tooltipTitle = L['qmenu_quest_watched'],
					tooltipText = L['qmenu_quest_watched_desc'],
					tooltipOnButton = true,
					checked = function() return IsQuestWatched(ind) end,
					func = function()
						if IsQuestWatched(ind) then
							RemoveQuestWatch(ind)
							WatchFrame_Update()
						else
							if ( GetNumQuestWatches() < MAX_WATCHABLE_QUESTS ) then
								AddQuestWatch(ind)
								WatchFrame_Update()
							end
						end
					end,
					isNotRadio=true,
				})
				if GetQuestWorldMapAreaID(goal.quest.id)>0 then
					tinsert(menu,{
						text = L['qmenu_quest_openmap'],
						tooltipTitle = L['qmenu_quest_openmap'],
						tooltipText = L['qmenu_quest_openmap_desc'],
						tooltipOnButton = true,
						func = function()  WorldMap_OpenToQuest(goal.quest.id,nil)  end,
					})
				end
			end

			-- woo, LightHeaded support!
			if LightHeaded then
				tinsert(menu,{
					text = L['qmenu_quest_lightheaded'],
					tooltipTitle = L['qmenu_quest_lightheaded'],
					tooltipText = L['qmenu_quest_lightheaded_desc'],
					tooltipOnButton = true,
					func = function()
						if IsShiftKeyDown() then
							local s = LightHeaded:GetPageText(goal.quest.id)
							self:ShowDump(s,"Quest info - courtesy of LightHeaded",false)
						else
							ShowUIPanel(QuestLogFrame)
							LightHeaded:UpdateFrame(goal.quest.id, LightHeaded.db.profile.singlepage and -1 or 1)
						end
					end,
				})
			end

			if self.db.profile.debug then
				tinsert(menu,{
					text = "(debug) force quest complete",
					tooltipTitle = self.completedQuests[goal.quest.id] and L['qmenu_quest_complete_tip'] or L['qmenu_quest_complete_in_tip'],
					tooltipText = self.completedQuests[goal.quest.id] and L['qmenu_quest_complete_desc'] or L['qmenu_quest_complete_in_desc'],
					checked = function()  return self.completedQuests[goal.quest.id]  end,
					func = function()  self:FakeCompleteQuest(goal.quest.id,not self.completedQuests[goal.quest.id],goal.quest.title)  end,
					isNotRadio=true,
				})
			end
			--[[
			tinsert(menu,{
				text = L['qmenu_quest_complete'],
				tooltipTitle = self.completedQuests[goal.quest.id] and L['qmenu_quest_complete_tip'] or L['qmenu_quest_complete_in_tip'],
				tooltipText = self.completedQuests[goal.quest.id] and L['qmenu_quest_complete_desc'] or L['qmenu_quest_complete_in_desc'],
				checked = function()  return self.completedQuests[goal.quest.id]  end,
				func = function()  self:FakeCompleteQuest(goal.quest.id,not self.completedQuests[goal.quest.id],goal.quest.title)  end,
				isNotRadio=true,
			})
			--]]
		end
	end
	if self.borderfadedout and not self.db.profile.delayshowborder then
		tinsert(menu,{
			text = L['opt_group_display'],
			isTitle = true,
			notCheckable=true,
		})
		tinsert(menu,{
			text = L['qmenu_border_restore'],
			tooltipTitle = L['qmenu_border_restore'],
			tooltipText = L['qmenu_border_restore_desc'],
			tooltipOnButton = true,
			--checked = function()  return self.db.profile.hideborder  end,
			func = function()  self.borderfadedout=nil  UIFrameFadeIn(self.Frame.Border,0.15,0.0,ZGV.db.profile.opacitymain)  self.Frame.mouseCount=999  self.Frame.leftCount=-3  end,
			isNotRadio=true,
		})
	end
	--[[
		{
			text = L['opt_miniresizeup'],
			tooltipTitle = L['opt_miniresizeup'],
			func = function() self:SetOption("Display","resizeup") end,
			checked = function() return self.db.profile.resizeup end,
			isNotRadio=true,
			keepShownOnClick = true,
		},
		{
			text = L['opt_hideincombat'],
			tooltipTitle = L['opt_hideincombat'],
			tooltipText = L['opt_hideincombat_desc'],
			checked = function()  return self.db.profile.hideincombat  end,
			func = function()  self:SetOption("Display","hideincombat")  end,
			isNotRadio=true,
			keepShownOnClick = true,
		},
		{
			text = L['opt_configuration'],
			tooltipTitle = L['opt_configuration'],
			tooltipText = L['opt_configuration_desc'],
			isNotRadio=true,
			notCheckable=true,
			func = function()  self:OpenOptions()  end,
		},
		{
			name = L['opt_group_step'],
			isTitle = true,
		},
		{
			text = L["opt_do_searchforgoal"],
			notCheckable = true,
			func = function() ZGV:SearchForCompleteableGoal() end
		}
	--]]

	EasyMenu(menu,ZGVFMenu,goalframe:GetName(),0,0,"MENU",3)
end

--[[
function ZGV:OpenQuickSteps()
	local menu = {
		{
			text=L["opt_showcountsteps"],
			isTitle = true,
			notCheckable = true,
		},
		{
			text=L["opt_showbriefsteps"],
			func=function() self:SetOption("Step","showbriefsteps") end,
			checked=function() return self.db.profile.showbriefsteps end,
			isNotRadio = true,
		},
		{
			text=L["opt_showcountsteps_all"],
			func=function() self:SetOption("Step","showcountsteps 0") end,
			checked=function() return self.db.profile.showallsteps end,
		},
		{
			text='1',
			func=function() self:SetOption("Step","showcountsteps 1") end,
			checked=function() return not self.db.profile.showallsteps and self.db.profile.showcountsteps==1 end,
		},
		{
			text='2',
			func=function() self:SetOption("Step","showcountsteps 2") end,
			checked=function() return not self.db.profile.showallsteps and self.db.profile.showcountsteps==2 end,
		},
		{
			text='3',
			func=function() self:SetOption("Step","showcountsteps 3") end,
			checked=function() return not self.db.profile.showallsteps and self.db.profile.showcountsteps==3 end,
		},
		{
			text='4',
			func=function() self:SetOption("Step","showcountsteps 4") end,
			checked=function() return not self.db.profile.showallsteps and self.db.profile.showcountsteps==4 end,
		},
		{
			text='5',
			func=function() self:SetOption("Step","showcountsteps 5") end,
			checked=function() return not self.db.profile.showallsteps and self.db.profile.showcountsteps==5 end,
		},
	}

	ZGVFMenu.onHide = function()
		ZGVFMenu.stepframe=nil
		ZGVFMenu.goalframe=nil
	end

	EasyMenu(menu,ZGVFMenu,"cursor",0,0,"MENU",3)
end
--]]

function ZGV:OpenMapToQuestGoal(questid,goalnum)
end

local function split(str,sep)
	local fields = {}
	str = str..sep
	str:gsub("(.-)"..sep, function(c) tinsert(fields, c) end)
	return fields
end

function ZGV:FindGroup(self,title)
	local path = split(title,"\\")

	-- create one
	local group=self
	for i=1,#path do
		local found = false
		for n,gr in ipairs(group.groups) do
			if gr.name==path[i] then
				found=true
				group=gr
			end
		end
		if not found then
			local gr = {name=path[i],groups={},guides={},ord=#group.groups+1}
			tinsert(group.groups,gr)
			group=gr
		end
	end
	return group
end

-- Compare two guides or guide groups. Sort wisely according to either registered_sortings or registration order (first-come-first-serve)
local function CompGroups(a,b)
	local sa=ZGV.registered_sortings[a.name or a.short]
	local sb=ZGV.registered_sortings[b.name or b.short]
	if sa and sb then return sa<sb else return a.ord<b.ord end
end

local function SortGroups(group)
	table.sort(group.groups,CompGroups)
	table.sort(group.guides,CompGroups)
	for i,gr in ipairs(group.groups) do
		SortGroups(gr)
	end
end

ZGV.registered_groups = { groups={},guides={}}

function ZGV:RegisterGuide(title,data,extra)
	title = title:gsub([[\\]],[[\]])
	local group,tit = title:match("^(.*)\\+(.-)$")
	if group then
		group = self:FindGroup(self.registered_groups,group)
	else
		group = self.registered_groups
	end

	local guide = {['title']=title,['title_short']=tit or title,['rawdata']=data,['extra']=extra, num=#self.registeredguides+1,ord=#group.guides+1, parsed=0}
	setmetatable(guide,self.GuideProto_mt)

	tinsert(group.guides,guide)
	tinsert(self.registeredguides,guide)
end

ZGV.registered_mapspotset_groups = { groups={},guides={}}

function ZGV:RegisterMapSpots(title,data)
	local group,tit = title:match("^(.*)\\+(.-)$")
	if group then
		group = self:FindGroup(self.registered_mapspotset_groups,group)
	else
		group = self.registered_mapspotset_groups
	end

	local set = self.MapSpotSetProto:NewRaw(title,tit or title,data)

	tinsert(group.guides,{full=title,short=tit or title,num=#self.registeredmapspotsets+1})
	tinsert(self.registeredmapspotsets,set)
end

ZGV.registered_sortings = {}
function ZGV:RegisterGuideSorting(array)
	for i,gr in ipairs(array) do
		self.registered_sortings[gr]=i
	end
end

--[[
function ZGV:UnregisterGuide(name)
	local data
	if type(name)=="number" then
		if self.registeredguides[name] then
			data = self.registeredguides[name].data
			table.remove(self.registeredguides,name)
			self:Print("Unregistered guide number: "..name)
		else
			self:Print("Cannot find guide number: "..name)
			return false
		end
	else
		local i,v
		for i,v in ipairs(self.registeredguides) do
			if v.title==name then
				data = v
				table.remove(self.registeredguides,i)
				self:Print("Unregistered guide: "..name)
			end
		end
		if not data then
			self:Print("Cannot find guide: "..name)
			return false
		end
	end
	if data.is_stored then
		self.db.global.storedguides[name] = nil
		self:Print("Removed stored data for: "..name)
	end
	return true
end
--]]

function coroutine_safe_pcall(f,arg)
	local co = coroutine.create(f)
	while true do
		local status, a,b,c,d,e = coroutine.resume(co,arg)
		if coroutine.status(co) == "suspended" then
			arg = coroutine.yield(a)   -- suspend across `mypcall'
		else
			return status, a,b,c,d,e   -- error or normal return
		end
	end
end


function _StartupThread()
	local self=ZGV
	if not self.db.char.maint_startguides then return end
	self.loading="Loading..."

	if self.ChainsRaw then
		self.loading = L['loading_quests']
		self:Debug("chains start")
		self:ParseQuestChains_yielding()
		self:CreateReverseQuestChains_yielding()
		self.ChainsRaw=nil
		self:Debug("chains stop")
		yield(1)
	end

	self.registeredmapspotsets = {}

	local full_load = false

	if #self.registeredguides>0 then
		self.loading = L['loading_guides']
		for i,guide in ipairs(self.registeredguides) do
			guide:Parse(full_load)
			self.loadprogress = i/#self.registeredguides
			self:SendMessage("ZYGORGV_LOADING")
			yield()
		end

		for i,guide in ipairs(self.registeredguides) do
			if guide.startlevel and not guide.endlevel and guide.next then
				local nextg = self:GetGuideByTitle(guide.next)
				if nextg and nextg.startlevel then
					guide.endlevel = nextg.startlevel
				end
			end
			--[[
			-- too fast for progress, eh?
			self.loadprogress = i/#self.registeredguides
			self:SendMessage("ZYGORGV_LOADING")
			yield()
			--]]
		end
	end

	-- sort guides, according to preset sortings.
	SortGroups(self.registered_groups)
	
	if #self.registeredmapspotsets>0 then
		for i,guide in ipairs(self.registeredmapspotsets) do
			if guide.rawdata then
				local parsedset,err,line,linedata = self.MapSpotSetProto.ParseRaw(guide)
				if parsedset then
					self.loadprogress = i/#self.registeredmapspotsets
					guide:Show()
				else
					if err then
						self:Print(L["message_errorloading_full"]:format(guide.title,line,linedata,err))
					else
						self:Print(L["message_errorloading_brief"]:format(guide.title))
					end
					guide.rawdata=nil
				end
				yield()
			end
			self:SendMessage("ZYGORGV_LOADING")
		end

		local tab1 = self.Frame.Border.Tab1
		--tab1:SetPoint("LEFT",self.Frame.Border,"TOPLEFT",65,-12)
		tab1:SetText("Guides")
		tab1:SetNormalFontObject(ZGVFTabFont)
		--PanelTemplates_TabResize(self.Tab1,0);
		--_G[self.Tab1:GetName().."HighlightTexture"]:SetWidth(self.Tab1:GetTextWidth() + 20);
		tab1:SetScript("OnClick",function() ZGV:SetDisplayMode("guide") end)
		tab1:Show()

		local tab2 = self.Frame.Border.Tab2
		tab2:SetPoint("LEFT",tab1,"RIGHT")
		tab2:SetText("Spots")
		tab2:SetNormalFontObject(ZGVFTabFont)
		--ZGVFrameTab2Text:SetText("Spots")
		--PanelTemplates_TabResize(self.Tab2,0);
		--_G[self.Tab2:GetName().."HighlightTexture"]:SetWidth(self.Tab2:GetTextWidth() + 20);
		tab2:SetScript("OnClick",function() ZGV:SetDisplayMode("gold") end)
		tab2:Show()

		self.Frame:AlignFrame()
	end

	yield(1)

	-- WIPE!
	self.ParseQuestChains=nil
	self.CreateReverseQuestChains=nil
	self.RegisterGuide=nil
	self.RegisterMapSpots=nil

	self:SendMessage("ZYGORGV_LOADING")

	self:Debug("Guides loaded. ---------")

	self:Debug("Querying for quests...")
	self:QueryQuests()

	--[[
	self:Debug("Caching follow-ups...")
	self:CacheMentionedFollowups()
	self:Debug("Cached.")
	yield(1)
	--]]

	self.loading="Cleaning up..."
	collectgarbage("step",10000)
	yield(1)

	self.completiontimer = self:ScheduleRepeatingTimer("TryToCompleteStep", 0.1)
	--self.notetimer = self:ScheduleRepeatingTimer("SetWaypoint", 1)
	--self.dailytimer = self:ScheduleRepeatingTimer("QuestTracking_ResetDailies", 5)

	--self:CancelTimer(self.startuptimer,true)

	self.pause = true
	self.loading=nil

	self:Print(L['welcome_guides']:format(#self.registeredguides))

	self:UpdateFrame(true)

	self.guidesloaded=true
	self:OnFirstQuestLogUpdate()
end

-- This gets called every frame on startup, by MasterFrame. Needs to return true to confirm successful startup.
local thread
function ZGV:StartupStep()
	if not thread then
		thread = coroutine.create(_StartupThread)
	end
	local good,ret = coroutine.resume(thread)

	if not good then self.loading=nil self:Print("ERROR initializing, check the Lua errors and report them, please.") error(tostring(ret).."\nin\n"..debugstack(thread)) end

	if coroutine.status(thread)=="dead" then
		self:Debug("Startup complete.")
		self.loading=nil
	else
		if ret and ret==1 then self.master_forceupdate=true end
	end
end

--[[
function ZGV:RegisterStoredGuides()
	local k,v
	for k,v in pairs(self.db.global.storedguides) do
		table.insert(self.registeredguides,{title=k,data=v,is_stored=true})
		self:Print("Retrieved guide "..k.." from storage.")
	end
end
--]]

function ZGV:UpdateMapButton()
	if self.db.profile.showmapbutton then ZygorGuidesViewerMapIcon:Show() else ZygorGuidesViewerMapIcon:Hide() end
end

function ZGV:GetGuides()
	if not ZygorGuidesViewer or not ZygorGuidesViewer.db or not ZygorGuidesViewer.registeredguides then return {} end
	local t = {}
	for i,data in ipairs(ZygorGuidesViewer.registeredguides) do
		t[i]=data.title
	end
	return t
end

function ZGV.GetGuidesRev()
	if not ZygorGuidesViewer or not ZygorGuidesViewer.db or not ZygorGuidesViewer.registeredguides then return {} end
	local t = {}
	for i,data in ipairs(ZygorGuidesViewer.registeredguides) do
		t[data.title]=i
	end
	return t
end



local function tostr(val)
	if type(val)=="string" then
		return '"'..val..'"'
	elseif type(val)=="number" then
		return tostring(val)
	elseif not val then
		return "nil"
	elseif type(val)=="boolean" then
		return tostring(val).." ["..type(val).."]"
	end
end

local function superconcat(table,glue)
	local s=""
	for i=1,#table do
		if #s>0 then s=s..glue end
		s=s..tostring(table[i])
	end
	return s
end

local function anytostring(s)
	if type(s)=="table" then
		return superconcat(s,",")
	else
		return tostring(s)
	end
end

function ZGV:BugReport(maint)
	local s = ""
	s = ("Zygor Guides Viewer v%s\n"):format(self.version)
	s = s .. "\n"
	s = s .. ("Guide: %s\nStep: %d\n"):format(tostr(self.CurrentGuideName),tostr(self.CurrentStepNum))
	
	if maint then
		s = s .. "\nMAINTENANCE OPTIONS THAT WERE ENABLED PROPERLY: ______________\nMAINTENANCE OPTION THAT CAUSED DISCONNECTION: _______________\n\n"
	end

	local step = self.CurrentStep
	if step then
		for k,v in pairs(step) do
			if k~="goals" and k~="num" and k~="L"
			and k~="isobsolete" and k~="isauxiliary"
			and type(v)~="function" then
				s = s .. ("  %s: %s\n"):format(k,anytostring(v))
			end
		end
		local complete,possible = step:IsComplete()
		s = s .. ("  (complete: %s, auxiliary: %s, obsolete: %s, possible: %s)\n"):format(complete and "YES" or "NO", step:IsAuxiliary() and "YES" or "NO", step:IsObsolete() and "YES" or "NO", possible and "YES" or "NO")

		s = s .. "Goals: \n"

		for i,goal in ipairs(step.goals) do
			s = s .. ("%d. %s %s\n"):format(i,(". "):rep(goal.indent),goal.text and "\""..goal.text.."\"" or "<"..goal:GetText()..">")
			for k,v in pairs(goal) do
				if k~="map" and k~="mapL" and k~="x" and k~="y" and k~="dist" 
				and k~="indent" and k~="text" and k~="parentStep" and k~="num" and k~="status"
				and k~="useitem" and k~="useitemid"
				and k~="castspell" and k~="castspellid"
				and k~="quest" and k~="questid" and k~="questreqs"
				and k~="lasttext" and k~="lastbrief" and k~="lastshowcompleteness"
				and k~="mobs"
				and k~="target" and k~="targetid" and k~="objnum"
				and type(v)~="function" then
					s = s .. ("    %s: %s\n"):format(k,anytostring(v))
				end
			end
			if goal.x or goal.y or goal.action=="goto" then
				s = s .. ("    map: %s %s,%s"):format((goal.mapL and goal.mapL.." (enUS:"..goal.map..")") or goal.map or "unknown",goal.x or "nil",goal.y or "nil")
				if goal.dist then s = s .. ("  +/- %s"):format(goal.dist) end
				s = s .. "\n"
			end
			if goal.useitemid or goal.useitem then
				s = s .. ("   useitem: \"%s\"  ##%s"):format(tostring(goal.useitem),tostring(goal.useitemid))
				if goal.useitemid then
					local a={GetItemInfo(goal.useitemid)}
					s = s .. ("  GetItemInfo(%d) == %s\n"):format(goal.useitemid,superconcat(a,","))
				elseif goal.useitem then
					local a={GetItemInfo(goal.useitem)}
					s = s .. ("  GetItemInfo(\"%s\") == %s\n"):format(goal.useitem,superconcat(a,","))
				end
			end
			if goal.castspellid or goal.castspell then
				s = s .. ("   castspell: \"%s\"  ##%s"):format(tostring(goal.castspell),tostring(goal.castspellid))
				if goal.castspellid then
					local a={GetSpellInfo(goal.castspellid)}
					s = s .. ("  GetSpellInfo(%d) == %s\n"):format(goal.castspellid,superconcat(a,","))
				elseif goal.castspell then
					local a={GetSpellInfo(goal.castspell)}
					s = s .. ("  GetSpellInfo(\"%s\") == %s\n"):format(goal.castspell,superconcat(a,","))
				end
			end
			if goal.questid and goal.quest then
				local questdata,inlog = ZGV.Localizers:GetQuestData(goal.questid)
				s = s .. ("    quest: \"%s\" ##%s"):format(questdata and questdata.title or "?",tostring(goal.questid))
				if goal.questid then
					if goal.objnum then
						if questdata and questdata.goals then
							local goaltext = questdata.goals[goal.objnum].item
							if not goaltext then goaltext="???" end
							s = s .. (" goal %d: \"%s\""):format(goal.objnum,goaltext)
						else
							s = s .. (" goal %d"):format(goal.objnum)
						end
					else
						s = s .. (" (no goal)")
					end
					if inlog then
						s = s .. "  - quest in log "
					else
						s = s .. "  - quest not in log "
					end
					if self.completedQuests[goal.questid] then
						s = s .. "(id: completed)"
					else
						s = s .. "(id: not completed)"

						-- deprecating title storing totally, since GetQuestID is here.
						--[[
						if self.completedQuestTitles[goal.quest] then
							s = s .. " (title: completed)"
						else
							s = s .. " (title: not completed)"
						end
						--]]
					end
				end
				s = s .. "\n"
			end
			if goal.target then
				s = s .. ("    target: \"%s\""):format(goal.target)
				if goal.targetid then
					s = s .. (" ##%d\n"):format(goal.targetid)
				end
				s = s .. "\n"
			end
			if goal.mobs then
				s = s .. "    mobs: "
				for k,v in ipairs(goal.mobs) do
					s = s .. v.name .. "  "
				end
				s = s .. "\n"
			end
			if goal.questreqs and #goal.questreqs>0 then
				s = s .. "    questreqs: "..superconcat(goal.questreqs,",").."\n"
			end
			if goal.condition_visible then
				s = s .. "    visibility condition: "..goal.condition_visible_raw.."\n"
			end

			if goal:IsCompleteable() then
				local comp,poss = goal:IsComplete()
				s = s .. ("    (complete: %s, possible: %s, auxiliary: %s, obsolete: %s)\n"):format(comp and "YES" or "no", poss and "YES" or "no", step:IsAuxiliary() and "YES" or "no", step:IsObsolete() and "YES" or "no")
			else
				s = s .. "    (not completeable)\n"
			end

			s = s .. "    Status: "..goal:GetStatus().."\n"
		end
		s = s .. "\n"
	else
		s = s .. "No current step loaded.\n\n"
	end

	s = s .. "--- Player information ---\n"
	s = s .. ("Race: %s  Class: %s  Level: %d\n"):format(select(2,UnitRace("player")),select(2,UnitClass("player")),UnitLevel("player"))
	local x,y = GetPlayerMapPosition("player")
	s = s .. ("Position: realzone:'%s' x:%g,y:%g (zone:'%s' subzone:'%s' minimapzone:'%s')\n"):format(GetRealZoneText(),x*100,y*100,GetZoneText(),GetSubZoneText(),GetMinimapZoneText())
	if GetLocale()~="enUS" then
		s = s .. ("    enUS: realzone:'%s' zone:'%s' subzone:'%s' minimapzone:'%s')\n"):format(tostring(BZR[GetRealZoneText()]),tostring(BZR[GetZoneText()]),BZR[GetSubZoneText()] or "("..GetSubZoneText()..")",BZR[GetMinimapZoneText()] or "("..GetMinimapZoneText()..")")
		s = s .. ("Locale: %s\n"):format(GetLocale())
	end
	s = s .. "\n"



	s = s .. "-- Cached quest log --\n"
	for index,quest in pairs(self.quests) do
		s = s .. dumpquest(quest)
	end
	s = s .. "\n"

	s = s .. "-- Cached quest log, by ID --\n"
	for id,quest in pairs(self.questsbyid) do
		s = s .. ("#%d: %s\n"):format(id,quest.title)
	end
	s = s .. "\n"

	s = s .. "-- Items --\n"
	local inventory={}
	for bag=-2,4 do
		for slot=1,GetContainerNumSlots(bag) do
			local item = GetContainerItemLink(bag,slot)
			if item then
				local id,name = string.match(item,"item:(.-):.-|h%[(.-)%]")
				local tex,count = GetContainerItemInfo(bag,slot)
				tinsert(inventory,("    %s ##%d x%d\n"):format(name,id,count))
			end
		end
	end
	table.sort(inventory)
	s = s .. table.concat(inventory,"")
	s = s .. "\n"

	s = s .. "-- Buffs/debuffs --\n"
	for i=1,30 do
		local name,_,tex = UnitBuff("player",i)
		if name then s=s..("%s (\"%s\")\n"):format(name,tex) end
	end
	for i=1,30 do
		local name,_,tex = UnitDebuff("player",i)
		if name then s=s..("%s (\"%s\")\n"):format(name,tex) end
	end
	s = s .. "\n"

	s = s .. "-- Pet action bar --\n"
	for i=1,12 do
		local name,_,tex = GetPetActionInfo(i)
		if name then s=s..("%d. %s (\"%s\")\n"):format(i,name,tex) end
	end
	s = s .. "\n"

	s = s .. "-- Flight Paths --\n"
	if self.LibTaxi then
		s = s .. table.concat(TableKeys(self.db.char.taxis)," , ")
	end
	s = s .. "\n\n"

	s = s .. "-- Options --\n"
	s = s .. "Profile:\n"
	for k,v in pairs(self.db.profile) do s = s .. "  "..k.." = "..anytostring(v).."\n" end
	s = s .. "\n"

	--s = s .. self:DumpVal(self.quests,0,4,true)
	--self:Print(s)
	if self.ErrorLogger_GetErrors then
		local errors = self:ErrorLogger_GetErrors()
		if #errors>0 then
			s = s .. "-- Errors --\n"
			for ei,err in ipairs(errors) do s = s .. "----------------\nTime: "..(err.time or "?").."\nCount: "..(err.count or 1).."\nError: \n"..tostring(err.message).."\n----------------\n" end
		end
	end

	s = s .. "-- Log --\n"
	s = s .. self.Log:Dump(100)

	local title = maint and "Zygor Guides Viewer" or (self.CurrentGuideName or L["report_notitle"])
	local author = maint and "zygor@zygorguides.com" or (self.CurrentGuide and self.CurrentGuide.author or L["report_noauthor"])

	title = L["report_title"]:format(title,author)

	self:ShowDump(s,title,true)

end

function ZGV:ShowDump(text,title,editable)
	if not self.dumpFrame then self:CreateDumpFrame() end

	HideUIPanel(InterfaceOptionsFrame)
	HideUIPanel(ZygorGuidesViewerMaintenanceFrame)

	self.dumpFrame.editBox:SetText(text)
	self.dumpFrame.title:SetText(title or "Generic dump:")
	ShowUIPanel(self.dumpFrame)
	if editable then
		self.dumpFrame.editBox:HighlightText(0)
		self.dumpFrame.editBox:SetFocus(true)
	else
		--self.dumpFrame.editBox:Enable(false)
	end
end

function ZGV:DumpVal(val,lev,maxlev,nofun)
	if not lev then lev=1 end
	if not maxlev then maxlev=1 end

	if lev>maxlev then return ("...") end
	local s = ""
	if type(val)=="string" then
		s = ('"%s"'):format(val)
	elseif type(val)=="number" then
		s = ("%s"):format(tostring(val))
	elseif type(val)=="function" then
		s = ("")
	elseif type(val)=="table" then
		s = "\n"
		for k,v in pairs(val) do
			if type(k)~="string" or not k:find("^parent")
			then
				if type(v)~="function" then
					s = s .. ("   "):rep(lev) .. ("%s=%s"):format(k,self:DumpVal(v,lev+1,maxlev,nofun))
				elseif not nofun then
					s = s .. ("   "):rep(lev) .. ("%s(function)\n"):format(k)
				end
			end
		end
	end

	return s.."\n"
end


-- misc:

function ZGV:CreateDumpFrame()
	local name = "ZygorGuidesViewer_DumpFrame"

	local frame = CreateFrame("Frame", name, UIParent)
	self.dumpFrame = frame
	frame:SetBackdrop({
	bgFile = [[Interface\DialogFrame\UI-DialogBox-Background]],
	edgeFile = [[Interface\DialogFrame\UI-DialogBox-Border]],
	tile = true, tileSize = 16, edgeSize = 16,
	insets = { left = 3, right = 3, top = 5, bottom = 3 }
	})
	frame:SetBackdropColor(0,0,0,1)
	frame:SetWidth(500)
	frame:SetHeight(400)
	frame:SetPoint("CENTER", UIParent, "CENTER")
	frame:Hide()
	frame:SetFrameStrata("DIALOG")
	tinsert(UISpecialFrames, name)
	
	local scrollArea = CreateFrame("ScrollFrame", name.."Scroll", frame, "UIPanelScrollFrameTemplate")
	scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -50)
	scrollArea:SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", -30, 8)

	local editBox = CreateFrame("EditBox", nil, frame)
	editBox:SetMultiLine(true)
	editBox:SetMaxLetters(99999)
	editBox:EnableMouse(true)
	editBox:SetAutoFocus(false)
	editBox:SetFontObject(ChatFontSmall)
	editBox:SetWidth(400)
	editBox:SetHeight(270)
	editBox:SetScript("OnEscapePressed", function() frame:Hide() end)
	self.dumpFrame.editBox = editBox
	
	scrollArea:SetScrollChild(editBox)
	
	local close = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
	close:SetPoint("TOPRIGHT", frame, "TOPRIGHT")

	local title = frame:CreateFontString(nil,"OVERLAY","GameFontNormalSmall")
	self.dumpFrame.title = title
	title:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
	title:SetPoint("BOTTOMRIGHT", frame, "TOPRIGHT", -30, -45)
	title:SetJustifyH("CENTER")
	title:SetJustifyV("TOP")

end

local math_floor = math.floor
local function round(num, digits)
	-- banker's rounding
	local mantissa = 10^digits
	local norm = num*mantissa
	norm = norm + 0.5
	local norm_f = math_floor(norm)
	if norm == norm_f and (norm_f % 2) ~= 0 then
		return (norm_f-1)/mantissa
	end
	return norm_f/mantissa
end
function ZGV:Test (arg1,arg2)
	local a={GetMapZones(GetCurrentMapContinent())}
	local x,y = GetPlayerMapPosition("player")
	local id = round(x*10000, 0) + round(y*10000, 0)*10001
	self:Print("You're in "..a[GetCurrentMapZone()].." at Cart2 coords "..id)
end

function ZGV:Echo (s)
	--if not self.db.profile.silent then 
	self:Print(tostring(s))
	--end
end

function ZGV:Debug (s)
	self.Log:Add(s)
	if self and self.db and self.db.profile and self.db.profile.debug then
		self.DebugI = (self.DebugI or 0) + 1
		self:Echo('|cffaaaaaa#' .. self.DebugI .. ': ' .. tostring(s))
	end
end


-- HACKS
function ZGV:ListQuests(from,to)
	local CQI=Cartographer_QuestInfo
	local qlog = ""
	for i=from,to do
		local level = CQI:PeekQuest(i)
		--if not level then level=0 end
		if level then
			local title,_,_,_,nobjs = CQI:GetQuestText(i,level)
			--if not title then title = CQI:GetQuestText(i,level) end -- well, they said to repeat it...
			--self:Print(i..": |cff808080|Hquest:"..i..":"..level.."|h["..tostring(title).."]|h|r "..(type(objs)=="table" and "{"..table.concat(nobjs,",").."}" or ""))
			qlog = qlog .. i..": "..tostring(title)..(type(nobjs)=="table" and " {"..table.concat(nobjs,",").."}" or "") .. "|n"
		end
	end
	if Chatter then
		Chatter:GetModule("Chat Copy").editBox:SetText(qlog)
		Chatter:GetModule("Chat Copy").editBox:HighlightText(0)
		Chatter:GetModule("Chat Copy").frame:Show()
	end
end

function ZGV:ReloadTranslation()
	for i,guide in ipairs(self.registeredguides) do
		for s,step in ipairs(guide.steps) do
			for g,goal in ipairs(step.goals) do
				goal.L=false
			end
		end
	end
end

--[[
function ZGV:SIS_Hello()
	StaticPopup_Show('ZYGORGUIDESVIEWER_SIS')
end

function ZGV:SIS_Activate()
	self.db.profile.skipobsolete = true
	self.db.profile.levelsahead = 0
	self.db.profile.skipauxsteps = true
	self.db.profile.skipimpossible = true

	self.GP:Show()
	self.GP:NavigateTo("SUGGEST")

	self.LastSkip = 1
	self.pause = nil
end
--]]

-- used for steps and goals
--[[
function ZGV.ConditionTrue(subject,case)
	if not subject.conditions then return false end
	local f=subject.conditions[case]
	if type(f)=="function" then
		return f()
	elseif type(f)=="string" then
		f=subject.conditions[f]
		assert(type(f)=="function","What? This step has cross-referencing conditions? wtf.")
		return not f()
	end
end
--]]

function ZGV.gradient3(perc,ar,ag,ab,br,bg,bb,cr,cg,cb, middle)
	if perc == 1 then
		return cr,cg,cb
	elseif perc==0 then
		return ar,ag,ab
	else
		if perc<=middle then
			perc=perc/middle
			return ar+(br-ar)*perc, ag+(bg-ag)*perc, ab+(bb-ab)*perc
		else
			perc=(perc-middle)/(1-middle)
			return br+(cr-br)*perc, bg+(cg-bg)*perc, bb+(cb-bb)*perc
		end
	end
end

--hooksecurefunc("WorldMapFrame_UpdateQuests",function() if not InCombatLockdown() then text=nil end end)
--hooksecurefunc("QuestInfo_Display",function() if not InCombatLockdown() then shownFrame=nil bottomShownFrame=nil end end)



--[[


function FindAch_AchievementFrame_OnShow(self)
	local editbox = AchievementFrame_FindAch_Edit
	if not editbox then
		editbox = CreateFrame("EditBox","AchievementFrame_FindAch_Edit",AchievementFrame,"InputBoxTemplate")
		editbox:SetSize(150,30)
		editbox:SetPoint("TOPLEFT",AchievementFrame,"TOPLEFT",150,15)
		editbox:Show()
		editbox:SetFocus(false)
	end
end

function FindAch_Listen_OnEvent(self,event,...)
	if event=="ADDON_LOADED" and ...=="Blizzard_AchievementUI" then
		AchievementFrame:HookScript("OnShow",FindAch_AchievementFrame_OnShow)
	end
end
local frame=CreateFrame("FRAME","FindAch_Listen")
frame:SetScript("OnEvent",FindAch_Listen_OnEvent)
frame:RegisterEvent("ADDON_LOADED")

--]]

-- encraption.
function ZGV:CraptOnReload(name)
	
end


-- (X) Mobwatch is gone. Tooltip scanning pwns.
--[[
function ZGV:COMBAT_LOG_EVENT_UNFILTERED(event,time,type,id1,name1,_,id2,name2)
	local type1=tonumber(id1:sub(5,5))
	local type2=tonumber(id2:sub(5,5))
	id1=id1 and tonumber(id1:sub(7,10),16)
	id2=id2 and tonumber(id2:sub(7,10),16)
	local id,name
	if type1==3 and self.mobwatch[id1]==1 then
		self.mobwatch[id1]=name1
		self:UpdateFrame(true)
	elseif type2==3 and self.mobwatch[id2]==1 then
		self.mobwatch[id2]=name2
		self:UpdateFrame(true)
	end
end
--]]

SLASH_RE1 = "/re"
function SlashCmdList.RE(text)
	ReloadUI()
end

