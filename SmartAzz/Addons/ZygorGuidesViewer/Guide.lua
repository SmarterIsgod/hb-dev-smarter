local Guide = { }

local ZGV = ZygorGuidesViewer
if not ZGV then return end

local L = ZGV.L

local table,string,tonumber,ipairs,pairs,setmetatable = table,string,tonumber,ipairs,pairs,setmetatable

ZGV.GuideProto_mt = { __index=Guide }

function Guide:DoCond(which,...)
	if which=="valid" and not self.condition_valid then
		if self.startlevel then
			return ZGV:GetPlayerPreciseLevel()>=self.startlevel,"Level "..ZGV.FormatLevel(self.startlevel).." or higher is required."
		else
			return true
		end
	end
		
	if which=="suggested" and not self.condition_suggested and self.startlevel then return ZGV:GetPlayerPreciseLevel()>=self.startlevel end
	if which=="end" and not self.condition_end and self.endlevel then return ZGV:GetPlayerPreciseLevel()>=self.endlevel,"Level "..ZGV.FormatLevel(self.endlevel).." reached." end
	if which and self['condition_'..which] then
		return self['condition_'..which](self,...),self['condition_'..which..'_msg']
	end
end

function Guide:GetStatus()
	local ret,msg

	ret,msg = self:DoCond("invalid")
	if ret then return "INVALID",msg end

	ret,msg = self:DoCond("valid")
	if ret then
		ret,msg = self:DoCond("end")
		if ret then return "COMPLETE",msg end

		if self.type=="leveling" then
			ret,msg = self:DoCond("suggested")
			if ret then return "SUGGESTED" end
		end

		return "VALID",msg
	else
		return "INVALID",msg
	end

end

function Guide:Load(step)
	ZGV:SetGuide(self,step)
end

function Guide:Unload()
	self.steps=nil
	collectgarbage("step",100)
end

function Guide:Parse(fully)
	if self.rawdata and not self.steps then
		--self:Debug("Parsing guide: "..guide.title) yield(1)
		local success,parsed,err,line,linedata = coroutine_safe_pcall(function() return ZGV.Parser:ParseEntry(self,fully) end)
		if success then
			if parsed then
				for k,v in pairs(parsed) do self[k]=v end
			else
				if err then
					ZGV:Print(L["message_errorloading_full"]:format(self.title,line or 0,linedata or "???",err))
				else
					ZGV:Print(L["message_errorloading_brief"]:format(self.title))
				end
			end
		else
			local err = parsed
			ZGV:Print(L["message_errorloading_critical"]:format(self.title,err,ZGV.Parser.lastparsedlinenum,ZGV.Parser.lastparsedlinedata))
		end
		--if full_load then self.rawdata=nil end
		--self:Debug("Parsed: "..guide.title)
	end
end

function Guide:GetQuests()
	self:Parse(true)
	local tab={}
	for si,step in ipairs(self.steps) do
		for gi,goal in ipairs(step.goals) do
			if goal.questid then tab[goal.questid]=si end
		end
	end
	return tab
end

------- hello popup

StaticPopupDialogs['ZYGORGUIDESVIEWER_NEXTGUIDE'] = {
	text = L['static_caption']..L['static_nextguide'],
	button1 = ACCEPT,
	button2 = CANCEL,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
	OnAccept = function(self) ZGV:SetGuide(self.guide) end,
}

StaticPopupDialogs['ZYGORGUIDESVIEWER_BADGUIDE'] = {
	text = L['static_caption']..L['static_badguide'],
	button1 = YES,
	button2 = NO,
	hideOnEscape = 1,
	timeout = 0,
	whileDead = 1,
	OnAccept = function(self)  ZGV.db.char.goodbadguides[self.guide.title]=true  ZGV:SetGuide(self.guide,self.step)  end,
	OnCancel = function(self)  ZGV.GP:Show(self.guide)  end,
}

function Guide:AdvertiseWithPopup(nodelay)
	local delay = true
	if nodelay then delay=false end
	if delay and ZGV:IsPlayerInCombat() then
		ZGV.call_after_combat = function() self:AdvertiseWithPopup(true) end
		ZGV:Print("Next guide is ready. Just finish your combat.")
	else
		local dialog = StaticPopup_Show('ZYGORGUIDESVIEWER_NEXTGUIDE',self.title_short)
		dialog.guide=self
	end
end
