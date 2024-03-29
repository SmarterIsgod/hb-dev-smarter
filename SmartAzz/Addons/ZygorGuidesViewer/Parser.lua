local ZGV = ZygorGuidesViewer
if not ZGV then return end

ZGV.Parser = {}
local Parser = ZGV.Parser

local L = ZygorGuidesViewer_L("Main")

local BZL=ZGV.BZL

local table,string,tonumber,ipairs,pairs,setmetatable,tinsert = table,string,tonumber,ipairs,pairs,setmetatable,tinsert

--[[
local function split (s,t)
	local l = {n=0}
	local f = function (s)
		l.n = l.n + 1
		l[l.n] = s
	end
	local p = "%s*(.-)%s*"..t.."%s*"
	s = string.gsub(s,"^%s+","")
	s = string.gsub(s,"%s+$","")
	s = string.gsub(s,p,f)
	l.n = l.n + 1
	l[l.n] = string.gsub(s,"(%s%s*)$","")
	return l
end
--]]

ZGV.actionmeta = {
	goto = { skippable = true },
	fpath = { skippable = true },
	home = { skippable = true },
	hearth = { skippable = true },
}

local function split(str,sep)
	local fields = {}
	str = str..sep
	local tinsert=tinsert
	str:gsub("(.-)"..sep, function(c) tinsert(fields, c) end)
	return fields
end

local function ParseMapXYDist(text)
	local map,x,y,dist,_
	_,_,map,x,y,dist = string.find(text,"^(.+),([0-9%.]+),([0-9%.]+),([0-9%.]+)$")
	if not _ then _,_,x,y,dist = string.find(text,"^([0-9%.]+),([0-9%.]+),(-?[0-9%.]+)$") end
	if not _ then _,_,map,x,y = string.find(text,"^(.+),([0-9%.]+),([0-9%.]+)$") end
	if not _ then _,_,x,y = string.find(text,"^([0-9%.]+),([0-9%.]+)$") end
	if not _ then _,_,dist = string.find(text,"^(-?[0-9%.]+)$") end
	if not _ then map = text end
	
	x = tonumber(x)
	y = tonumber(y)
--	if x then x=x/100 end
--	if y then y=y/100 end
--	if dist then dist=dist/100 or 0.2 end
	--if not dist then dist=0.2 end
	if map and #map<5 then map=nil end
	if dist then dist=tonumber(dist) end

	return map,x,y,dist
end

local function ParseID(str)
	local name,id,nid,obj
	name,id = str:match("(.*)##([0-9/]*)")
	if not name then id = str:match("^([0-9/]*)$") end
	if id then
		nid,obj = id:match("([0-9]*)/([0-9]*)")
		if nid then
			id=nid
		end
	end
	if id then id = tonumber(id) end
	if obj then obj = tonumber(obj) end
	if not name and not id then name=str end
	return name, id, obj
end

--- parse just the header, until the first 'step' tag. No chunking, just header data extraction.
function Parser:ParseHeader(text)
	if not text then return {} end
	local guides = {}
	local index = 1

	text = text .. "\n"

	local linecount=0

	local header = {}

	while (index<#text) do
		local st,en,line=string.find(text,"(.-)\n",index)
		if not en then break end
		index = en + 1

		linecount=linecount+1
		if linecount>100000 then
			return nil,linecount,"More than 100000 lines!?"
		end

		line = line:gsub("^[%s	]+","")
		line = line:gsub("[%s	]+$","")
		line = line:gsub("//.*$","")
		line = line:gsub("||","|")

		local cmd,params = line:match("([^%s]*)%s?(.*)")

		if cmd then
			if cmd=="step" then
				break
			else
				header[cmd]=params
			end
		end
	end

	if header['guide'] then
		header['title']=header['guide']
		header['guide']=nil
	end

	return header
end

local ConditionEnv = {
	_G = _G,
	-- variables needing update
	level=1,
	ZGV=ZGV,

	_Update = function()
		Parser.ConditionEnv.level = ZGV:GetPlayerPreciseLevel()
		if ZGV.db.char.fakelevel and ZGV.db.char.fakelevel>0 then Parser.ConditionEnv.level=ZGV.db.char.fakelevel end
	end,

	_Setup = function()
		-- reputation 'constants'
		for standing,num in pairs(ZGV.StandingNamesEngRev) do Parser.ConditionEnv[standing]=num end
	end,

	-- independent data feeds
	rep = function(faction)
		return ZGV:GetReputation(faction).standing
	end,
	skill = function(skill)
		return ZGV:GetSkill(skill).level
	end,
	raceclass = function(raceclass)
		return ZGV:RaceClassMatch(raceclass,true)
	end,
	completedq = function(id)
		return ZGV.completedQuests[id]
	end,
}
Parser.ConditionEnv=ConditionEnv  --DEBUG

local function MakeCondition(cond,forcebool)
	local s
	if forcebool then s = ("_Update()  return not not (%s)"):format(cond)
		     else s = ("_Update()  return (%s)"):format(cond)
		     end
	local fun,err = loadstring(s)
	if fun then setfenv(fun,ConditionEnv) end
	return fun,err
end
--local yield=coroutine.yield

--- parse ONE guide section into usable arrays.
function Parser:ParseEntry(guide,fully_parse)
	local text = guide.rawdata
	self.lastparsedlinenum=-1
	self.lastparsedlinedata="(none)"
	if not text then return nil,"No text!",0 end
	local index = 1

	local step

	local prevmap
	local prevlevel = 0

	text = text .. "\n"

	local linecount=0

	local noobsoletequests = {}
	local dailyquests = ZGV.dailyQuests

	local function COLOR_LOC(s) return "|cffffee77"..s.."|r" end

	local _

	local strfind = string.find

	if fully_parse and not guide.steps then guide.steps={} end

	-- guess guide type
	if guide.title:match("^Zygor's %a+ Leveling") then guide.type="leveling"
	elseif guide.title:match("^Zygor's %a+ Dailies") then guide.type="daily"
	elseif guide.title:match("^Zygor's %a+ Loremaster") then guide.type="loremaster"
	elseif guide.title:match("^Zygor's %a+ Event") then guide.type="event"
	end

	-- clear some fields before reparsing
	guide.description=nil

	--local debug
	--if text:find("goto The Exodar,44.9,24.2") then debug=true end

	local breakout

	while (index<#text) do
		local st,en,line=strfind(text,"%s*(.-)%s*\n",index)
		--if debug then print(line) end
		if not en then break end
		index = en + 1

		linecount=linecount+1
		if linecount>100000 then
			return nil,linecount,"More than 100000 lines!?"
		end

		--line = line:gsub("^[%s	]+","")
		--line = line:gsub("[%s	]+$","") --done in the find

		--st,en = strfind(line,"//",1,true)
		--if st then line=line:sub(1,st-1) end
		-- not really faster
		self.lastparsedlinenum=linecount
		self.lastparsedlinedata=line

		if guide.crapt then
			--line,guide.crapt=__uncrapt(line,guide.crapt)
		end
		line = line:gsub("//.*$","")

		local indent
		indent,line = line:match("^(%.*)(.*)")

		line = line .. "|"
		local goal={}

		local chunkcount=1

		local had_asterisk=nil
		if line:find("^%s*%*") then
			line=line:gsub("^%s*%*","")
			had_asterisk=true
		end

		--if linecount%50==0 then yield() end
		
		for chunk in line:gmatch("%s*(.-)%s*|+") do
			chunk = chunk:gsub("^'%s*","' ")
			--chunk = chunk:gsub("^turn in ","turnin ")
			chunk = chunk:gsub("^@(%S)","@ %1")
			--chunk = chunk:gsub("^%s+","")
			--chunk = chunk:gsub("[%s	]+$","")

			local cmd,params = chunk:match("([^%s]*)%s?(.*)")

			-- guide parameters
			if cmd=="defaultfor" then
				local cond = "raceclass('"..params.."',true) and " .. (params=="DeathKnight" and "level<59" or "level<15")
				guide.condition_suggested = MakeCondition(cond)
				guide.condition_suggested_raw = cond
			elseif cmd=="next" then
				guide[cmd]=params:gsub("\\\\","\\")
			elseif cmd=="author" then
				guide[cmd]=params
			elseif cmd=="description" then
				guide[cmd]=(guide[cmd] and (guide[cmd].."\n") or "") .. params
			--elseif cmd=="faction" then --unused
			--	guide[cmd]=params
			elseif cmd=="startlevel" then
				guide[cmd]=tonumber(params)
				if not guide[cmd] then return nil,"bad level number",linecount,chunk end
				prevlevel=math.floor(guide[cmd])

			elseif cmd=="endlevel" then
				guide[cmd]=tonumber(params)
				if not guide[cmd] then return nil,"bad level number",linecount,chunk end

			elseif cmd=="crapt" then
				guide[cmd]=params
			elseif cmd=="dynamic" then
				guide[cmd]=(params~="off")

			elseif cmd=="step" then

				if not fully_parse then
					guide.steps=nil

					-- THIS SUCKS. Find the last ding to find the last level.
					while st do
						local lev
						st,en,lev = text:find("%sding ([0-9]+)%s",en+1)
						if lev then prevlevel = tonumber(lev) end
					end
					breakout=true
					break
				end

				step = { goals = {}, map = prevmap, level = prevlevel, num = #guide.steps+1, parentGuide=guide }
				guide.steps[#guide.steps+1] = step

				setmetatable(step,ZGV.StepProto_mt)

			elseif cmd=="label" then
				if not guide.steplabels then guide.steplabels={} end
				guide.steplabels[params]=#guide.steps

			-- step parameters
			elseif cmd=="level" then
				step[cmd]=params
				prevlevel=tonumber(params)
			elseif cmd=="title" then
				step[cmd]=params
				if chunkcount>1 then goal[cmd]=params end
			elseif cmd=="map" then
				prevmap = params
				if step then
					step.map = prevmap
				end
	--[[
			elseif cmd=="@" then
				local map,x,y
				map,x,y = params:match("(.+),([0-9.]+),([0-9.]+)")
				if not map then
					x,y = params:match("([0-9.]+),([0-9.]+)")
				end
				if not x then
					map = params
				end
				if not map then
					map = prevmap
				end
				step['map']=map
				prevmap=map
				if x or y then
					step['x']=x
					step['y']=y
				end
	--]]
			-- goal commands
			elseif cmd=="accept" or cmd=="turnin" then
				goal.action = goal.action or cmd
				if not params then return nil,"no quest parameter",linecount,chunk end
				goal.quest,goal.questid = ParseID(params)
				if goal.quest then
					local q,qp = goal.quest:match("^(.-)%s-%((%d+)%)$")
					if q then goal.quest,goal.questpart=q,qp end
				end
				if not goal.quest and not goal.questid then return nil,"no quest parameter",linecount,chunk end

				if goal.questid then
					if not step.level then return nil,"Missing step level information",linecount,chunk end
					local lev = ZGV.mentionedQuests[goal.questid]
					if guide.dynamic then
						if not lev or lev<step.level then lev=step.level end
					else
						if not lev then lev=-1 end
					end
					ZGV.mentionedQuests[goal.questid] = lev
				end

			elseif cmd=="talk" then
				goal.action = goal.action or cmd
				if not params then return nil,"no npc",linecount,chunk end
				goal.npc,goal.npcid = ParseID(params)
				if not goal.npc and not goal.npcid then return nil,"no npc",linecount,chunk end
			elseif cmd=="goto" or cmd=="at" then
				goal.action = goal.action or cmd
				local map,x,y,dist = ParseMapXYDist(params)

				goal.map = map or goal.map or step.map or prevmap
				step.map = goal.map
				prevmap = step.map

				goal.x = x or goal.x
				goal.y = y or goal.y
				goal.dist = dist or goal.dist

				if (goal.action=="accept" or goal.action=="turnin" 	or goal.action=="kill" 	or goal.action=="get" 	or goal.action=="talk" 	or goal.action=="goal" 	or goal.action=="use") then
					goal.autotitle = goal.param or goal.target or goal.quest
				end

				if not goal.map then
					return nil,"'"..cmd.."' has no map parameter, neither has one been given before.",linecount,chunk
				end

			elseif cmd=="kill" or cmd=="get" or cmd=="collect" or cmd=="goal" or cmd=="buy" then
				goal.action = goal.action or cmd

				-- first, extract the count
				local count,excl,object = params:match("^([0-9]+)(!?) (.*)")
				if not object then object=params end
				goal.count = tonumber(count) or 1
				if excl=="!" then goal.exact = 1 end

				-- check for plural
				local name,plural = object:match("^(.+)(%+)$")
				if plural then
					goal.plural=true
					object=name
				end

				-- now object##id
				goal.target,goal.targetid = ParseID(object)

				-- finally, assume buys are futureproof
				if cmd=="buy" then goal.future=true end

				-- something missing?
				if not goal.targetid and not goal.target then return nil,"no parameter",linecount,chunk end
				--[[
				if goal.target:match("%+%+") then
					if goal.target:match("%+%+$") then
						goal.target = goal.target:gsub("%+%+","")
						goal.targets = goal.target
					else
						local sing,pl = goal.target:match("(.+)%+%+%+(.+)")
						if not sing or not pl then
							sing = goal.target:gsub("([^%s%+]+)++([^%s%+]+)","%1")
							pl = goal.target:gsub("([^%s%+]+)++([^%s%+]+)","%2")
						end
						goal.target = sing
						goal.targets = pl
					end
				end
				--]]

			elseif cmd=="create" then
				goal.action = goal.action or cmd

				local spell,skill,level = params:match("(.+),(.-),([0-9]+)")
				if spell then
					goal.spell,goal.spellid = ParseID(spell)
					goal.skill = skill
					goal.level = tonumber(level)
				else
					local num,item = params:match("([0-9]+) (.+)")
					goal.count = tonumber(num)
					goal.item,goal.itemid = ParseID(item)
				end

			elseif cmd=="from" then
				goal.action = goal.action or cmd
				params=params:gsub([[\,]],"!!comma!!")
				params=params:gsub(",%s+",",")
				goal.mobsraw = params
				local mobs = split(params,",")

				goal.mobs = {}
				for i,mob in ipairs(mobs) do
					mobs[i]=mob:gsub("!!comma!!",",")
					local name,plural = mob:match("^(.+)(%+)$")
					if not plural then name=mob end

					local nm,id = ParseID(name)
					
					tinsert(goal.mobs,{name=nm,id=id,pl=plural and true or false})
				end
				goal.mobspre = mobs
			elseif cmd=="complete" then --unused
				goal.action = goal.action or cmd
				goal.quest,goal.questid,goal.objnum = ParseID(params)
				if not goal.quest and not goal.questid then return nil,"no quest parameter",linecount,chunk end
			elseif cmd=="ding" then
				goal.action = goal.action or cmd
				goal.level = tonumber(params)
				if not goal.level then return nil,"'ding': invalid level value",linecount,chunk end
				prevlevel = tonumber(params)
			elseif cmd=="equipped" then
				goal.action = goal.action or cmd
				local slot,item = params:match("^([a-zA-Z]+) (.*)")
				slot,_ = GetInventorySlotInfo(slot)
				if not slot then return nil,"equipped needs proper slot" end
				if not item then return nil,"equipped needs item" end
				goal.slot=slot
				goal.item=item
			elseif cmd=="hearth" then
				goal.action = goal.action or cmd
				goal.useitem = "Hearthstone"
				goal.useitemid = 6948
				goal.param = BZL[params]
				goal.force_noway = true
			elseif cmd=="rep" then
				goal.action = goal.action or cmd
				goal.faction,goal.rep = params:match("(.*),(.*)")
				if type(goal.rep)=="string" then goal.rep=ZGV.StandingNamesEngRev[goal.rep] end
				if ZGV.BFL[goal.faction] then goal.faction=ZGV.BFL[goal.faction] end
			elseif cmd=="achieve" then
				goal.action = goal.action or cmd
				_,goal.achieveid,goal.achievesub = ParseID(params)
			elseif cmd=="skill" or cmd=="skillmax" then
				goal.action = goal.action or cmd
				goal.skill,goal.skilllevel = params:match("^(.+),([0-9]+)$")
				goal.skilllevel = tonumber(goal.skilllevel)
				if not goal.skill then return nil,"'skill*': no skill found",linecount,chunk end
			elseif cmd=="learn" then
				goal.action = goal.action or cmd
				goal.recipe,goal.recipeid = ParseID(params)
				if not goal.recipeid then return nil,"'learn': no recipe found",linecount,chunk end
				
			elseif cmd=="fpath" or cmd=="home" then
				goal.action = goal.action or cmd
				goal.param = params
				if not goal.param then return nil,"no parameter",linecount,chunk end
			elseif cmd=="havebuff" then
				goal.action = goal.action or cmd
				goal.buff = params
				if not goal.buff then return nil,"no parameter",linecount,chunk end
			elseif cmd=="nobuff" then
				goal.action = goal.action or cmd
				goal.buff = params
				if not goal.buff then return nil,"no parameter",linecount,chunk end
			elseif cmd=="invehicle" then
				goal.action = goal.action or cmd
			elseif cmd=="outvehicle" then
				goal.action = goal.action or cmd
			elseif cmd=="condition" then	-- new in 3.1: supersede the "startlevel" eventually.
				if not step then
					local case,cond = params:match("(.-) (.+)$")
					if (case=="suggested" or case=="valid" or case=="invalid" or case=="end") and not step then
						local cond2,msg = cond:match("(.+)!!(.+)")
						if cond2 then cond=cond2 end
						if cond:sub(1,1)=="!" then
							-- special condition tag
							cond=cond:sub(2)
							local tag,data = cond:match("(.-) (.+)")
							data=data or true
							tag=tag or cond
							guide['condition_'..case..'_'..cond]=data
						else
							local fun,err = MakeCondition(cond,true)
							if not fun then return nil,err,linecount,chunk end
							guide['condition_'..case..'_raw']=cond
							guide['condition_'..case]=fun
							guide['condition_'..case..'_msg']=msg
						end
					else
						return nil,"wrong condition type (not suggested/valid/invalid/end) or rogue guide condition in steps",linecount,chunk
					end
				else
					goal.action = goal.action or cmd
					local fun,err = MakeCondition(params,false)
					if not fun then return nil,err,linecount,chunk end
					goal.condition_complete_raw=params
					goal.condition_complete = fun
				end

			elseif cmd=="click" then
				goal.action = goal.action or cmd

			elseif cmd=="info" then
				goal.action = goal.action or cmd
				goal.info = params


			-- clickable icon displayers

			elseif cmd=="cast" then
				goal.action = goal.action or cmd
				goal.castspell,goal.castspellid = ParseID(params)
				if not goal.castspell and not goal.castspellid then return nil,"no parameter",linecount,chunk end
			elseif cmd=="petaction" then
				goal.action = goal.action or cmd
				goal.petaction = tonumber(params)
				if not goal.petaction then goal.petaction = params end
				if not goal.petaction then return nil,"petaction needs an action number",linecount,chunk end
			elseif cmd=="use" then
				goal.action = goal.action or cmd
				goal.useitem,goal.useitemid = ParseID(params)
				if not goal.useitem and not goal.useitemid then return nil,"no parameter",linecount,chunk end
			elseif cmd=="script" then
				goal.script = params

			-- conditions

			elseif cmd=="only" then
				local cond = params:match("^if%s+(.*)$")
				if cond then
					-- condition match
					local subject = goal  if chunkcount==1 then subject=step end

					local fun,err = MakeCondition(cond,true)
					if not fun then return nil,err,linecount,chunk end

					subject.condition_visible_raw=cond
					subject.condition_visible=fun
				else
					-- race/class match
					if goal.action or goal.text or chunkcount>1 then
						if not ZGV:RaceClassMatch(split(params,",")) then
							goal={}
							break
						end -- skip goal line altogether
					else
						step.requirement=split(params,",")
					end
				end

			-- extra tags

			elseif cmd=="autoscript" then
				goal.autoscript = params
			elseif cmd=="n" then
				goal.force_nocomplete = true
			elseif cmd=="c" then
				goal.force_complete = true
			elseif cmd=="noway" then
				goal.force_noway = true
			elseif cmd=="sticky" then
				goal.force_sticky = true
			elseif cmd=="important" then
				had_asterisk = true
			elseif cmd=="future" then
				goal.future = true  -- if quest-related, then don't worry if the quest isn't in the log.
			elseif cmd=="noobsolete" then
				if goal then
					goal.noobsolete = true
					if goal.questid then noobsoletequests[goal.questid] = true end
				else
					guide.noobsolete = true
				end
			elseif cmd=="travelfor" then
				step.travelfor = tonumber(params)

			elseif cmd=="daily" then
				if goal and goal.questid then dailyquests[goal.questid] = true end
				if not guide.steps or #guide.steps==0 then guide.daily=true end

			elseif cmd=="tip" then
				goal.tooltip = params
			elseif cmd=="image" then
				goal.image = params
			elseif cmd=="quest" or cmd=="q" then
				local first=params:match("^(.-),")
				if first then params=first end
				goal.quest,goal.questid,goal.objnum = ParseID(params)
				if not goal.questid then return nil,"no questid in parameter",linecount,chunk end
			elseif cmd=="or" then
				goal.orlogic = params and tonumber(params) or 1
			elseif cmd=="instant" then  -- when we HAVE to use the title, for instant-complete quests.
				if goal.questid then ZGV.instantQuests[goal.questid]=true end
				goal.usetitle=true
			elseif cmd=="killcount" then  -- use killcounter for non-quest mobs
				goal.usekillcount=true

			elseif cmd=="simulate" then
				goal.simulate = params

			elseif #chunk>1 then -- text
				-- snag coordinates for waypointing, with distance
				local st,en,x,y,d

				st,en,x,y,d = params:find("([0-9%.]+),([0-9%.]+)(,(-?[0-9%.]+))?")
				if not d then
					-- without distance, perhaps?
					st,en,x,y = params:find("([0-9%.]+),([0-9%.]+)",en)
				end

				if x and y then
					x = tonumber(x)
					y = tonumber(y)
					if not x or not y then return nil,"Cannot parse these coordinates",linecount,chunk end
					params = params:sub(1,st-1) .. COLOR_LOC(L['coords']:format(x,y)) .. params:sub(en+1)
					goal.dist = tonumber(d)
					goal.x = x
					goal.y = y
				end

				if goal.x then goal.map = prevmap end

				goal.text=(cmd=="'") and params or chunk
			end

			chunkcount=chunkcount+1
			if chunkcount>20 then
				return nil,"More than 20 chunks in line",linecount,line
			end
		end

		if #TableKeys(goal)>0 then
			if not step then return nil,"What? Unknown data before first 'step' tag, or what?",linecount,line end

			-- so there's something to record? go ahead.

			setmetatable(goal,ZGV.GoalProto_mt)

			if not goal.action then
				if (goal.x or goal.map) then
					goal.action = "goto"
				elseif goal.text then
					goal.action = "text"
				end
			end

			if goal.questid and noobsoletequests[goal.questid] then
				goal.noobsolete = true
			end


			goal.parentStep = step
			goal.num = #step.goals+1

			if goal.dist and math.abs(goal.dist)<5 then goal.dist=goal.dist*20 end

			goal.showinbrief = had_asterisk

			step.goals[#step.goals+1] = goal

			if (goal.action=="get" or goal.action=="kill" or goal.action=="goal") and not goal.questid and not goal.objnum and not goal.force_nocomplete then
				return nil,"Objective has no quest ID / obj num!",linecount,line
			end
		end

		if goal then goal.indent = #indent end

		if breakout then break end
	end

	--[[
	if prevlevel and not guide.condition_end then
		guide.endlevel = prevlevel
		guide.endlevel_implicit = true
		local cond = "level>=self.endlevel"
		guide['condition_end']=MakeCondition(cond)
		guide['condition_end_raw']=cond
		guide['condition_end_msg']=("You've reached level %.1f"):format(prevlevel)
	end
	--]]

	return guide
end

local s=string local c=string.char
local h="" for i=33,127 do h=h .. c(i) end
function __uncrapt(text,q)

end