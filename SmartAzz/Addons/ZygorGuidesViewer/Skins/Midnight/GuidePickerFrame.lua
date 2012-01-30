local ZGV = ZygorGuidesViewer
if not ZGV then return end

local GP = {}
ZGV.GuidePicker = GP
ZGV.GP = GP

local L = ZGV.L

local FR

local CHAIN = ZGV.ChainCall

local function ZGV_GP_Scroll_Update(scroll)
	GP:Refresh()
end

local function SetTextureBlock(tex,nh,nv,h,v)
	tex:SetTexCoord((nh-1)/h,nh/h,(nv-1)/v,nv/v)
	tex:SetTexCoord((nh-1)/h,nh/h,(nv-1)/v,nv/v)
end

local function SetIcon(self,nh,nv,h,v,sec)
	local icon = sec and self.iconover or self.icon
	if nh>0 then icon:Show() else icon:Hide() end
	SetTextureBlock(icon,nh,nv,h,v)
end

local function AssignButtonTexture(obj,tx,num,total, disable4)
	obj:SetNormalTexture(tx) SetTextureBlock(obj:GetNormalTexture(),num,1,total,4)
	obj:SetPushedTexture(tx) SetTextureBlock(obj:GetPushedTexture(),num,2,total,4)
	obj:SetHighlightTexture(tx) SetTextureBlock(obj:GetHighlightTexture(),num,3,total,4)
	obj:SetDisabledTexture(tx) SetTextureBlock(obj:GetDisabledTexture(),num,disable4 and 4 or 1,total,4)
end

function GP:CreateFrame()
	if FR then return FR end

	FR = CHAIN(CreateFrame("Frame", "ZygorGuidesViewer_GuidePicker", UIParent, ""))
	 :SetSize(500,500) :SetPoint("CENTER")
	 :SetBackdrop({bgFile=ZGV.DIR.."\\Skins\\white",edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\border-08", tile = true, edgeSize=20, tileSize = 128, insets = { left = 20, right = 20, top = 20, bottom = 20 }})
	 :SetBackdropColor(0,0,0,0.72) :SetBackdropBorderColor(0,0,0)
	 :SetFrameStrata("DIALOG")
	 :Hide()
	 .__END
	self.Frame = FR

	-- Scaling animation SUCKS when backdrops are concerned. Sucky suckage of suckness, really.

	--[[
		local size=0.95
		local s = FR.showanimgr:CreateAnimation("Scale")
		s:SetScale(1/size,1/size)
		s:SetDuration(0.2)
		s:SetSmoothing("OUT")

		FR.showanimgr = FR:CreateAnimationGroup()
		local s = FR.showanimgr:CreateAnimation("Animation")
		s:SetScript("OnUpdate",function(self)  print("a") FR:SetScale(size+(1-size)*self:GetSmoothProgress())  FR:SetAlpha(self:GetSmoothProgress()) end)
		s:SetDuration(0.2)
		s:SetSmoothing("OUT")
		FR.showanimgr:SetScript("OnPlay",function(self)  FR:Show()  FR:SetAlpha(0)  FR:SetScale(size)  end)
		FR.showanimgr:SetScript("OnFinished",function(self)  FR:SetAlpha(1)  FR:SetScale(1) end)

		local s = FR.hideanimgr:CreateAnimation("Scale")
		s:SetScale(size,size)
		s:SetDuration(0.2)
		s:SetSmoothing("OUT")
	--]]

	FR.showanimgr = FR:CreateAnimationGroup()
	local a = CHAIN(FR.showanimgr:CreateAnimation("Alpha")) :SetChange(1) :SetDuration(0.2) :SetSmoothing("OUT") .__END

	FR.showanimgr:SetScript("OnPlay",function(self)  FR:Show()  FR:SetAlpha(0)  end)
	FR.showanimgr:SetScript("OnFinished",function(self)  FR:SetAlpha(1)  end)

	FR.hideanimgr = FR:CreateAnimationGroup()
	local a = CHAIN(FR.hideanimgr:CreateAnimation("Alpha")) :SetChange(-1) :SetDuration(0.2) :SetSmoothing("OUT") .__END

	FR.hideanimgr:SetScript("OnPlay",function(self)  local p = FR  p:SetAlpha(1)  end)
	FR.hideanimgr:SetScript("OnFinished",function(self)  local p = FR  p:Hide()  end)


	FR.Logo = CHAIN(FR:CreateTexture()) :SetTexture(ZGV.DIR.."\\Skins\\zygorlogo") :SetSize(120,120/4) :SetPoint("TOP",FR,"TOP",0,0)
	--FR.Caption = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Huge1")) :SetPoint("TOP",FR.Logo,"BOTTOM",0,0) :SetJustifyH("LEFT") :SetJustifyV("TOP")  :SetHeight(50)  :SetFont(STANDARD_TEXT_FONT,15)  :SetText("Select a guide")

	FR.TitleBarSep = CHAIN(FR:CreateTexture()) :SetTexture(0,0,0,0.5) :SetPoint("TOPLEFT",FR,"TOPLEFT",2,-26) :SetPoint("BOTTOMRIGHT",FR,"TOPRIGHT",-2,-28)


	FR.CloseButton = CHAIN(CreateFrame("Button", nil, FR, nil)) :SetPoint("TOPRIGHT",FR,"TOPRIGHT",-5,-5) :SetSize(20,20) :SetScript("OnClick",function() GP:Hide() end) .__END
	AssignButtonTexture(FR.CloseButton,ZGV.SkinDir.."titlebuttons",6,16)


	FR.GuidesButton = CHAIN(CreateFrame("Button", "ZGV_GP_Guides", FR, "ZygorGuidesViewer_Midnight_Button")) :SetPoint("TOPLEFT",FR,"TOPLEFT",10,-30)	:SetSize(60,20)
	 :SetBackdrop({bgFile=nil,edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\border-glow", tile = true, edgeSize=10, tileSize = 10, insets = { left = 10, right = 10, top = 10, bottom = 10 }})  :SetBackdropBorderColor(1,1,1,0)
	 :SetText(L['guidepicker_button_guides'])
	 :SetAttribute("tooltip",L['guidepicker_button_guides_desc'])
	 :SetScript("OnClick",function() GP:NavigateTo() end)
	 .__END

	FR.RecentButton = CHAIN(CreateFrame("Button", "ZGV_GP_Recent", FR, "ZygorGuidesViewer_Midnight_Button")) :SetPoint("LEFT",FR.GuidesButton,"RIGHT",5,0)	:SetSize(60,20)
	 :SetBackdrop({bgFile=nil,edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\border-glow", tile = true, edgeSize=10, tileSize = 10, insets = { left = 10, right = 10, top = 10, bottom = 10 }})  :SetBackdropBorderColor(1,1,1,0)
	 :SetText(L['guidepicker_button_recent'])
	 :SetAttribute("tooltip",L['guidepicker_button_recent_desc'])
	 :SetScript("OnClick",function() GP:NavigateTo("RECENT") end)
	 .__END

	FR.SuggestButton = CHAIN(CreateFrame("Button", "ZGV_GP_Suggest", FR, "ZygorGuidesViewer_Midnight_Button")) :SetPoint("LEFT",FR.RecentButton,"RIGHT",5,0)	:SetSize(60,20)
	 :SetBackdrop({bgFile=nil,edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\border-glow", tile = true, edgeSize=10, tileSize = 10, insets = { left = 10, right = 10, top = 10, bottom = 10 }})  :SetBackdropBorderColor(1,1,1,0)
	 :SetText(L['guidepicker_button_suggest'])
	 :SetAttribute("tooltip",L['guidepicker_button_suggest_desc'])
	 :SetScript("OnClick",function() GP:NavigateTo("SUGGESTED") end)
	 .__END



	FR.BackButton = CHAIN(CreateFrame("Button", nil, FR)) :SetPoint("CENTER",FR,"TOPLEFT",22,-69) :SetSize(32,32)
	 :SetNormalTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Up")
	 :SetPushedTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Down")
	 :SetDisabledTexture("Interface\\Buttons\\UI-SpellbookIcon-PrevPage-Disabled")
	 :SetHighlightTexture("Interface\\Buttons\\UI-Common-MouseHilight")
	 :SetScript("OnClick",function() GP:NavigateBack() end)
	 .__END

	FR.PathIcon = CHAIN(FR:CreateTexture())
	 :SetSize(30,30) :SetPoint("CENTER",FR,"TOPLEFT",52,-69)
	 :SetTexture(ZGV.DIR.."\\Skins\\guideicons-big")
	 :Hide()
	 .__END

	FR.Path1 = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Med1"))
	 :SetPoint("TOPLEFT",FR,"TOPLEFT",71,-52) :SetPoint("TOPRIGHT",FR,"TOPRIGHT",-45,-52)
	 :SetJustifyH("LEFT") :SetJustifyV("CENTER") :SetHeight(30)
	 :SetFont(STANDARD_TEXT_FONT,16) :Show()
	 .__END

	--[[
	FR.Path2 = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Med1"))
	 :SetPoint("TOPLEFT",FR.Path1,"TOPRIGHT",0,0) :SetPoint("RIGHT",FR,"RIGHT",-45,0) 
	 :SetJustifyH("LEFT") :SetJustifyV("TOP") :SetHeight(50)
	 :SetFont(STANDARD_TEXT_FONT,14)
	 .__END

	FR.Path3 = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Med1"))
	 :SetPoint("TOPLEFT",FR,"TOPLEFT",45,-65) :SetPoint("TOPRIGHT",FR,"TOPRIGHT",-45,-65)
	 :SetJustifyH("LEFT") :SetJustifyV("TOP") :SetHeight(50)
	 :SetFont(STANDARD_TEXT_FONT,15)
	 .__END
	--]]


	local s=12
	FR.GuidesBox = CHAIN(CreateFrame("FRAME", nil, FR)) :SetFrameStrata("DIALOG") :SetPoint("TOPLEFT",FR,"TOPLEFT",10,-85) :SetPoint("BOTTOMRIGHT",FR,"TOPRIGHT",-10,-295)
	 :SetBackdrop({bgFile=ZGV.DIR.."\\Skins\\white",edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\roundcorners",tileSize=s,edgeSize=s,insets={top=s,bottom=s,left=s,right=s}}) :SetBackdropColor(0,0,0,0.50) :SetBackdropBorderColor(0,0,0,0.5)
	 :SetScript("OnMouseUp",function(this,but) if but=="RightButton" then GP:NavigateBack() end end)
	.__END

	-- main categories:

	FR.LabelsBig={}
	local rows,cols=6,1
	for i=1,rows do
		local but
		but = CHAIN(CreateFrame("Button", nil, FR))
		 :SetSize(310,60) :SetPoint("TOPLEFT",FR,"TOPLEFT",30+math.floor((i-1)/cols)*330,-90-((i-1)%cols)*65)
		 :SetHighlightTexture("Interface\\BUTTONS\\UI-Listbox-Highlight2")
		 :SetScript("OnClick",ZGV_GP_Button_OnClick)
		 :SetFrameLevel(5)
		 :Enable()
		 .__END
		but:GetHighlightTexture():SetAlpha(0.2)
		FR.LabelsBig[i] = but

		but.icon = CHAIN(but:CreateTexture()) :SetPoint("LEFT") :SetSize(50,50)
		 :SetTexture(ZGV.DIR.."\\Skins\\guideicons-big")
		 .__END

		but.label = CHAIN(but:CreateFontString()) :SetPoint("LEFT",but.icon,"RIGHT",10,0) :SetPoint("RIGHT")
		 :SetJustifyH("LEFT") :SetJustifyV("CENTER")
		 :SetFont(STANDARD_TEXT_FONT,22)
		 :SetTextColor(1.0,0.8,0.0)
		 :SetText("blablabla "..i)
		 .__END
		but:SetFontString(FR.LabelsBig[i].label)
		but.SetIcon=SetIcon
		--but:SetNormalFontObject(GameFontNormalSmall)
		--but:SetHighlightFontObject(GameFontHighlightSmall)
	end

	FR.LabelsSmall={}
	for i=1,10 do
		local but
		but = CHAIN(CreateFrame("Button", nil, FR)) :SetPoint("TOPLEFT",FR,"TOPLEFT",30,-90-(i-1)*20) :SetPoint("TOPRIGHT",FR,"TOPRIGHT",-40,-90-(i-1)*20)
		 :SetHeight(16)
		 :SetHighlightTexture("Interface\\BUTTONS\\UI-Listbox-Highlight2")
		 :SetScript("OnClick",ZGV_GP_Button_OnClick)
		 :RegisterForClicks("AnyUp")
		 :SetFrameLevel(5)
		 :Enable()
		 .__END
		but:GetHighlightTexture():SetAlpha(0.2)
		FR.LabelsSmall[i]=but

		but.icon = CHAIN(but:CreateTexture()) :SetPoint("LEFT") :SetSize(17,17) :SetDrawLayer("ARTWORK",0)
		 :SetTexture(ZGV.DIR.."\\Skins\\guideicons-small")
		 .__END

		but.iconover = CHAIN(but:CreateTexture()) :SetPoint("CENTER",but.icon,"CENTER",3,-3) :SetSize(17,17) :SetDrawLayer("ARTWORK",1)
		 :SetTexture(ZGV.DIR.."\\Skins\\guideicons-small")
		 .__END

		but.iconover.anim = CHAIN(but.iconover:CreateAnimationGroup()) :SetLooping("REPEAT") .__END
		CHAIN(but.iconover.anim:CreateAnimation("SCALE")) :SetScale(1.4,1.4) :SetDuration(0.5) :SetSmoothing("OUT")
		CHAIN(but.iconover.anim:CreateAnimation("SCALE")) :SetScale(0.7143,0.7143) :SetDuration(0.5) :SetSmoothing("IN")

		but.label = CHAIN(but:CreateFontString()) :SetPoint("TOPLEFT",but,"TOPLEFT",22,2) :SetPoint("BOTTOMRIGHT") :SetDrawLayer("ARTWORK")
		 :SetJustifyH("LEFT") :SetJustifyV("CENTER")
		 :SetFont(STANDARD_TEXT_FONT,12)
		 :SetTextColor(1.0,0.8,0.0)
		 :SetText("blablabla tereferekuku blorpft"..i)
		 .__END
		but:SetFontString(but.label)

		but.SetIcon=SetIcon

		but.back = CHAIN(but:CreateTexture()) :SetAllPoints() :SetDrawLayer("BACKGROUND")
		 :SetTexture("Interface\\BUTTONS\\UI-Listbox-Highlight2")
		 --:SetBlendMode("ADD")
		 :Hide()
		 .__END
		--but:SetNormalFontObject(GameFontNormalSmall)
		--but:SetHighlightFontObject(GameFontHighlightSmall)
		--but:GetFontString():SetPoint("LEFT",but,"LEFT",22,1)
	end

	FR.Scroll = CHAIN(CreateFrame("ScrollFrame",FR:GetName().."_Scroll",FR,"FauxScrollFrameTemplate"))
	 :SetPoint("TOPLEFT",FR,"TOPLEFT",25,-90) :SetPoint("BOTTOMRIGHT",FR,"TOPRIGHT",-35,-290)
	 :EnableMouseWheel()
	 :SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self, offset, 10, ZGV_GP_Scroll_Update) end)
	 :SetScript("OnMousewheel",ZGV_GP_OnMousewheel)
	 .__END
	ZGV.ChainCall(FR.Scroll.ScrollBar:CreateTexture("BACKGROUND")) :SetTexture(0,0,0,0.4) :SetPoint("TOPLEFT",FR.Scroll.ScrollBar,"TOPLEFT") :SetPoint("BOTTOMRIGHT",FR.Scroll.ScrollBar,"BOTTOMRIGHT")
	local n=FR.Scroll:GetName()
	_G[n.."ScrollBarThumbTexture"]:SetSize(12,30)
	_G[n.."ScrollBarThumbTexture"]:SetTexture(SKINDIR.."scrollbutton")
	_G[n.."ScrollBarScrollUpButton"]:SetSize(16,16) -- they're 18x16 by default now, the silly things.
	_G[n.."ScrollBarScrollDownButton"]:SetSize(16,16)
	AssignButtonTexture(_G[n.."ScrollBarScrollUpButton"],ZGV.SkinDir.."titlebuttons",7,16)
	AssignButtonTexture(_G[n.."ScrollBarScrollDownButton"],ZGV.SkinDir.."titlebuttons",8,16)

	FR.GuideTitlePre = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Small"))
	 :SetPoint("TOPLEFT",FR,"TOPLEFT",15,-305) :SetPoint("TOPRIGHT",FR,"TOPRIGHT",-115,-305)
	 :SetJustifyH("LEFT") :SetJustifyV("TOP") :SetHeight(13)
	 :SetText("Selected Guide:") :SetTextColor(0.8,0.8,0.7)
	 .__END

	FR.GuideTitle = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Med1"))
	 :SetPoint("TOPLEFT",FR.GuideTitlePre,"BOTTOMLEFT",0,-1) :SetPoint("TOPRIGHT",FR.GuideTitlePre,"BOTTOMRIGHT",0,-1)
	 :SetJustifyH("LEFT") :SetJustifyV("CENTER") :SetHeight(16)
	 :SetFont(STANDARD_TEXT_FONT,14)
	 .__END

	FR.GuideTitleBack = CHAIN(CreateFrame("Frame",nil,FR))
	 :SetPoint("TOPLEFT",FR.GuideTitle,"TOPLEFT",-5,2) :SetPoint("BOTTOMRIGHT",FR.GuideTitle,"BOTTOMRIGHT",5,0)
	 :SetBackdrop({bgFile=ZGV.DIR.."\\Skins\\white",edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\roundcorners",tileSize=8,edgeSize=8,insets={top=8,bottom=8,left=8,right=8}}) :SetBackdropColor(0,0,0,0.50) :SetBackdropBorderColor(0,0,0,0.5)
	 :SetFrameLevel(1)
	 .__END

	
	FR.GuideStatusPre = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Small"))
	 :SetPoint("TOPLEFT",FR,"TOPRIGHT",-95,-305) :SetPoint("TOPRIGHT",FR,"TOPRIGHT",-15,-305)
	 :SetJustifyH("LEFT") :SetJustifyV("TOP") :SetHeight(13)
	 :SetText("Status:") :SetTextColor(0.8,0.8,0.7)
	 .__END

	FR.GuideStatus = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Med1"))
	 :SetPoint("TOPLEFT",FR.GuideStatusPre,"BOTTOMLEFT",0,-1) :SetPoint("TOPRIGHT",FR.GuideStatusPre,"BOTTOMRIGHT",0,-1)
	 :SetJustifyH("LEFT") :SetJustifyV("CENTER") :SetHeight(16)
	 .__END

	FR.GuideStatusBack = CHAIN(CreateFrame("Frame",nil,FR))
	 :SetPoint("TOPLEFT",FR.GuideStatus,"TOPLEFT",-5,2) :SetPoint("BOTTOMRIGHT",FR.GuideStatus,"BOTTOMRIGHT",5,0)
	 :SetBackdrop({bgFile=ZGV.DIR.."\\Skins\\white",edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\roundcorners",tileSize=8,edgeSize=8,insets={top=8,bottom=8,left=8,right=8}}) :SetBackdropColor(0,0,0,0.50) :SetBackdropBorderColor(0,0,0,0.5)
	 :SetFrameLevel(1)
	 :SetScript("OnEnter",function(self)
		if not FR.GuideStatus.tip then return end
		GameTooltip:SetOwner(self,"ANCHOR_BOTTOM")
		GameTooltip:ClearLines()
		GameTooltip:SetText(FR.GuideStatus.tip)
		GameTooltip:Show()
	  end)
	 :SetScript("OnLeave",function(self) GameTooltip:Hide() end)
	 .__END


	FR.GuideDataPre = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Small"))
	 :SetPoint("TOPLEFT",FR.GuideTitle,"BOTTOMLEFT",0,-5) :SetPoint("TOPRIGHT",FR.GuideTitle,"BOTTOMRIGHT",0,-5)
	 :SetJustifyH("LEFT") :SetJustifyV("TOP") :SetHeight(13)
	 :SetText("Guide Details:") :SetTextColor(0.8,0.8,0.7)
	 .__END

	--[[
	FR.GuideData = CHAIN(FR:CreateFontString(nil,nil,"SystemFont_Shadow_Med1"))
	 :SetPoint("TOPLEFT",FR.GuideDataHeader,"BOTTOMLEFT") :SetPoint("TOPRIGHT",FR.GuideDataHeader,"BOTTOMRIGHT")
	 :SetJustifyH("LEFT") :SetJustifyV("TOP") :SetHeight(150)
	 :SetFont(STANDARD_TEXT_FONT,12)
	 .__END
	--]]

	FR.GuideScroll = CHAIN(CreateFrame("ScrollFrame",FR:GetName().."_GuideScroll",FR,"UIPanelScrollFrameTemplate"))
	 :SetPoint("TOPLEFT",FR.GuideDataPre,"BOTTOMLEFT",0,-3) :SetPoint("BOTTOMRIGHT",FR,"BOTTOMRIGHT",-35,40)
	 --:EnableMouseWheel()
	 --:SetScript("OnVerticalScroll",function(self,offset) FauxScrollFrame_OnVerticalScroll(self, offset, 10, ZGV_GP_Scroll_Update) end)
	 --:SetScript("OnMousewheel",ZGV_GP_OnMousewheel)
	 .__END
	ZGV.ChainCall(FR.GuideScroll.ScrollBar:CreateTexture("BACKGROUND")) :SetTexture(0,0,0,0.4) :SetPoint("TOPLEFT",FR.GuideScroll.ScrollBar,"TOPLEFT") :SetPoint("BOTTOMRIGHT",FR.GuideScroll.ScrollBar,"BOTTOMRIGHT")
	local n=FR.GuideScroll:GetName()
	_G[n.."ScrollBarThumbTexture"]:SetSize(12,30)
	_G[n.."ScrollBarThumbTexture"]:SetTexture(SKINDIR.."scrollbutton")
	_G[n.."ScrollBarScrollUpButton"]:SetSize(16,16) -- they're 18x16 by default now, the silly things.
	_G[n.."ScrollBarScrollDownButton"]:SetSize(16,16)
	AssignButtonTexture(_G[n.."ScrollBarScrollUpButton"],ZGV.SkinDir.."titlebuttons",7,16)
	AssignButtonTexture(_G[n.."ScrollBarScrollDownButton"],ZGV.SkinDir.."titlebuttons",8,16)

	FR.GuideScroll.Child = CHAIN(CreateFrame("Frame",FR.GuideScroll:GetName().."_Child"))
	 :SetAllPoints()
	 .__END
	FR.GuideScroll:SetScrollChild(FR.GuideScroll.Child)

	FR.GuideData = CHAIN(FR.GuideScroll.Child:CreateFontString(nil,nil,"SystemFont_Shadow_Med1"))
	 --:SetPoint("TOPLEFT",FR.GuideDataHeader,"BOTTOMLEFT") :SetPoint("TOPRIGHT",FR.GuideDataHeader,"BOTTOMRIGHT")
	 :SetPoint("TOPLEFT") :SetPoint("TOPRIGHT")
	 :SetJustifyH("LEFT") :SetJustifyV("TOP") :SetWidth(150)
	 :SetFont(STANDARD_TEXT_FONT,12)
	 .__END

	FR.GuideDataBack = CHAIN(CreateFrame("Frame",nil,FR))
	 :SetPoint("TOPLEFT",FR.GuideScroll,"TOPLEFT",-5,5) :SetPoint("BOTTOMRIGHT",FR.GuideScroll,"BOTTOMRIGHT",25,-3)
	 :SetBackdrop({bgFile=ZGV.DIR.."\\Skins\\white",edgeFile=ZGV.DIR.."\\Skins\\midnight\\black\\roundcorners",tileSize=8,edgeSize=8,insets={top=8,bottom=8,left=8,right=8}}) :SetBackdropColor(0,0,0,0.50) :SetBackdropBorderColor(0,0,0,0.5)
	 :SetFrameLevel(1)
	 .__END



	FR.ViewInFolderButton = CHAIN(CreateFrame("Button", nil, FR, "ZygorGuidesViewer_Midnight_Button"))
	 :SetPoint("BOTTOMLEFT",FR,"BOTTOMLEFT",10,10)
	 :SetSize(110,20)
	 :SetText(L['guidepicker_button_viewinfolder'])
	 :SetAttribute("tooltip",L['guidepicker_button_viewinfolder_desc'])
	 :SetScript("OnClick",function(self) GP:NavigateToGuide(GP.selectedguide.title) end)
	 :Disable()
	 .__END

	FR.OKButton = CHAIN(CreateFrame("Button", nil, FR, "ZygorGuidesViewer_Midnight_Button"))
	 :SetPoint("BOTTOMRIGHT",FR,"BOTTOMRIGHT",-10,10)
	 :SetSize(80,20)
	 :SetText(ACCEPT)
	 :SetAttribute("tooltip",L['guidepicker_button_ok_desc'])
	 :SetScript("OnClick",ZGV_GP_OKButton_OnClick)
	 .__END

	return FR
end

local function sanitize_path(p)
	return p:gsub("Zygor's (.-) (.- Guides)","%2")
end

function GP:Show(path)
	if not FR then self:CreateFrame() end
	if type(path)=="table" and path.title then
		self:NavigateToGuide(path.title)
	elseif path then
		self:NavigateTo(path)
	else
		self:NavigateToGuide(ZGV.CurrentGuideName)
	end
	if not FR:IsVisible() then
		FR:Show()
		FR.showanimgr:Play()
	end
end

function GP:Hide()
	FR.hideanimgr:Play()
end

function GP:NavigateTo(path)
	if path=="" then path=nil end
	self.path = path
	if path=="RECENT" then
		self.flatgroup = ZGV:GetGuidesHistory()
	elseif path=="SUGGESTED" then
		local sugg = ZGV:FindSuggestedGuides()
		if #sugg==1 and automatically_navigate_to_single_suggestion__OFF then
			return self:NavigateToGuide(sugg[1].title)
		else
			self.flatgroup = sugg
		end
	else
		if path then
			self.group = ZGV:FindGroup(ZGV.registered_groups,path)
		else
			self.group = ZGV.registered_groups
		end

		self.flatgroup = {}
		for gi,g in ipairs(self.group.groups) do
			tinsert(self.flatgroup,g)
		end
		for gi,g in ipairs(self.group.guides) do
			tinsert(self.flatgroup,g)
		end
	end
	FR.Scroll.ScrollBar:SetValue(0)

	FR.GuidesButton:SetBackdropBorderColor(1,1,1,((self.path~="RECENT") and (self.path~="SUGGESTED")) and 1 or 0)
	FR.RecentButton:SetBackdropBorderColor(1,1,1,(self.path=="RECENT") and 1 or 0)
	FR.SuggestButton:SetBackdropBorderColor(1,1,1,(self.path=="SUGGESTED") and 1 or 0)

	self:SelectGuide()
	
	self:Refresh()
end

function GP:NavigateToGuide(guidepath)
	if type(guidepath)=="table" and guidepath.title then guidepath=guidepath.title end  --allow guide objects
	if not guidepath then
		self:NavigateTo()
	else
		local pre,post = guidepath:match("^(.+)\\(.-)$")
		self:NavigateTo(pre)
		self:SelectGuide(guidepath)
		self:ScrollIntoView()
	end
end

function GP:NavigateBack()
	if self.path then
		local pre,post = self.path:match("^(.+)\\(.-)$")
		self:NavigateTo(pre)
	else
		self:NavigateTo()
	end
end

local function get_icon(path)
	if path:find("Leveling") then return 1,1
	elseif path:find("Dailies") then return 3,1
	elseif path:find("Event") then return 2,1
	elseif path:find("Loremaster") then return 4,1
	end
end

local specialpaths = {["SUGGESTED"]=L['guidepicker_suggested'],["RECENT"]=L['guidepicker_recent']}
setmetatable(specialpaths,{__index=function(self,ind) return ind end})

function GP:Refresh()
	if self.path then
		local path = sanitize_path(self.path)

		local folders = {strsplit("\\",path)}
		local txt=""
		for i=1,#folders-1,1 do
			txt=txt .. "|TInterface\\CHATFRAME\\ChatFrameExpandArrow:0|t " .. folders[i]
		end
		-- do something with txt

		--FR.Path2 :SetPoint("TOPLEFT",FR.Path1,"TOPLEFT",FR.Path1:GetWidth()+10,0)

		--FR.Path2:SetText(txt)
		FR.Path1:SetText(specialpaths[folders[#folders]])
		--FR.Path:SetText(sanitize_path(self.path):gsub("\\"," |TInterface\\CHATFRAME\\ChatFrameExpandArrow:0|t "))

		local x,y = get_icon(folders[1])
		if x then SetTextureBlock(FR.PathIcon,x,y,4,2) FR.PathIcon:Show() else FR.PathIcon:Hide() end
	else
		--FR.Path:SetText("")
		FR.PathIcon:Hide()
		FR.Path1:SetText("")
	end

	local offset = FauxScrollFrame_GetOffset(FR.Scroll)

	if self.flatgroup then
		local buts,otherbuts
		if self.path then
			buts=FR.LabelsSmall
			otherbuts=FR.LabelsBig
		else
			buts=FR.LabelsBig
			otherbuts=FR.LabelsSmall
			local yspan=65
			for i=1,6 do buts[i]:ClearAllPoints() end
			if #self.flatgroup<=10 then
				for i=1,6 do
					yspan = (#self.flatgroup<=3 and 65 or 190/#self.flatgroup)
					if i<=#self.flatgroup then
						buts[i]:SetPoint("TOP",FR,"TOP",0,-90-(i-1)*yspan)
						buts[i]:SetHeight(yspan)
						buts[i].label:SetFont(STANDARD_TEXT_FONT,yspan * 0.6)
						buts[i].icon:SetSize(yspan*0.9,yspan*0.9)
						buts[i]:Show()
						buts[i]:SetWidth(400)
					else
						buts[i]:Hide()
					end
				end
			else
				for i=1,6 do
					buts[i]:SetPoint("TOP",FR,"TOP",130 * (math.floor((i-1)/3)*2-1),-90-((i-1)%3)*yspan)
					buts[i]:SetWidth(260)
					buts[i]:Show()
				end
			end
		end
		for i=1,10 do
			local g = self.flatgroup[offset+i]
			if buts[i] then
				-- groups have names. guides have titles. go figure.
				if g and g.name then
					-- group
					buts[i]:SetText(sanitize_path(g.name))
					buts[i].target = (self.path and self.path.."\\" or "")..g.name
					buts[i].isguide=nil
					if buts==FR.LabelsBig then
						local x,y = get_icon(g.name)
						if x then buts[i]:SetIcon(x,y,4,2) end
					else
						buts[i]:SetIcon(1,1,2,2)
						local suggest = ZGV:GetGuideFolderInfo(g)
						if suggest then
							buts[i]:SetIcon(1,2,2,2,true)
							buts[i].iconover.anim:Play()
						else
							buts[i]:SetIcon(0,0,2,2,true)
						end
					end
					--buts[i]:GetFontString():SetTextColor(1,0.8,0)
					buts[i]:Show()
				elseif g and g.title then
					if self.path=="RECENT" then
						buts[i]:SetText(("%s, step %d"):format(g.title_short or "",g.CurrentStepNum or 1))
					else
						buts[i]:SetText(g.title_short or "")
					end
					buts[i].target = g.title or ""
					buts[i].isguide=true
					buts[i]:SetIcon(2,1,2,2)
					local status = g.GetStatus and g:GetStatus()
					if status=="SUGGESTED" then
						buts[i]:SetIcon(1,2,2,2,true)
						buts[i].iconover.anim:Play()
					else
						buts[i]:SetIcon(0,0,2,2,true)
					end
					buts[i]:Show()
					--buts[i]:GetFontString():SetTextColor(1,1,1)
				else
					buts[i]:Hide()
				end
			end
			if otherbuts[i] then otherbuts[i]:Hide() end
		end
	else
		for i=1,6 do FR.LabelsBig[i]:Hide() end
		for i=1,10 do FR.LabelsSmall[i]:Hide() end
	end

	FR.Scroll:ShowIf(self.path)
	--FR.Scroll:EnableIf(#self.flatgroup>10)
	FauxScrollFrame_Update(FR.Scroll, #self.flatgroup, 10, 10);

	FR.BackButton:EnableIf(self.path)

	self:RefreshGuide()
end

local GuideStatusColor = {}
GuideStatusColor["SUGGESTED"]	= { r = 1.00, g = 0.80, b = 0.25,	font = GameFontNormalLeftYellow }
GuideStatusColor["VALID"]		= { r = 0.25, g = 0.75, b = 0.25,	font = GameFontNormalLeftLightGreen }
GuideStatusColor["COMPLETE"]	= { r = 0.50, g = 0.50, b = 0.50,	font = GameFontNormalLeftGrey }
--GuideStatusColor["OLD"]		= { r = 0.50, g = 0.50, b = 0.50,	font = GameFontNormalLeftGrey }
GuideStatusColor["INVALID"]	= { r = 0.90, g = 0.00, b = 0.00,	font = GameFontNormalLeftRed }
GuideStatusColor["HEADER"]	= { r = 1.00, g = 1.00, b = 1.00,	font = GameFontHighlightLeft }

function GP:ScrollIntoView()
	if self.selectedguide then
		local selectedpos
		for i,gi in ipairs(self.flatgroup) do
			if gi==self.selectedguide then  selectedpos=i  break  end
		end
		--print(selectedpos,offset)
		if selectedpos and selectedpos>10 then
			return self:UpdateScroll(selectedpos-5)
		end
	end
end

function GP:RefreshGuide()
	if self.selectedguide then
		local g = self.selectedguide
		FR.GuideTitle:SetText(g.title_short)

		local status,msg = self.selectedguide:GetStatus()
		local color = GuideStatusColor[status]
		FR.GuideStatus:SetText(L['guidepicker_status_'..status])
		FR.GuideStatus:SetTextColor(color.r,color.g,color.b)
		FR.GuideStatus.tip = msg

		local s=""
		if g.startlevel then s = s .. "Required level: ".. ZGV.FormatLevel(g.startlevel) .."\n" end
		if g.endlevel then s = s .. "Ending level: ".. ZGV.FormatLevel(g.endlevel) .."\n" end
		if g.next then s = s .. "Next guide: ".. g.next:match(".+\\(.-)$") .."\n" end

		s = s .. (self.selectedguide.description or "")
		CHAIN(FR.GuideData) :SetText(s) :ClearAllPoints() :SetPoint("TOPLEFT",FR.GuideScroll) :SetPoint("TOPRIGHT",FR.GuideScroll)
		FR.GuideScroll.Child:SetSize(FR.GuideData:GetWidth(),FR.GuideData:GetHeight())
		FR.GuideScroll:SetVerticalScroll(0)
		FR.GuideScroll:Show()
		FR.OKButton:Enable()
	else
		FR.GuideTitle:SetText("")
		FR.GuideStatus:SetText("")
		FR.GuideStatus.tip=nil
		FR.GuideData:SetText("")
		FR.OKButton:Disable()
		FR.GuideScroll:Hide()
	end

	for i,but in ipairs(FR.LabelsSmall) do
		local gtype
		local guide,status
		if but.isguide then
			guide = ZGV:GetGuideByTitle(but.target)
			status = guide and guide:GetStatus() or "INVALID"
			gtype = GuideStatusColor[status]
		else
			gtype = GuideStatusColor["HEADER"]
		end

		if self.selectedguide and but.target==self.selectedguide.title then
			but.back:Show()
			but.back:SetVertexColor(gtype.r,gtype.g,gtype.b)
			but.label:SetTextColor(1,1,1)
			--but:SetNormalFontObject(GameFontHighlightLeft)
			--but:SetHighlightFontObject(GameFontHighlightLeft)
		else
			but.back:Hide()
			but.label:SetTextColor(gtype.r,gtype.g,gtype.b)
			--but:SetNormalFontObject(gtype.font)
			--but:SetHighlightFontObject(GameFontHighlightLeft)
		end
	end

	FR.ViewInFolderButton:EnableIf(self.path=="SUGGESTED" or self.path=="RECENT")
end

local DOUBLECLICK_TIME = 0.5
local lastclick = 0

function ZGV_GP_Button_OnClick(but,button)
	if button=="LeftButton" then
		if not but.target then return end
		if but.isguide then
			if GetTime()-lastclick<DOUBLECLICK_TIME and GP.selectedguide.title==but.target then
				ZGV_GP_OKButton_OnClick(but)
			else
				lastclick = GetTime()
				GP:SelectGuide(but.target)
			end
		else
			GP:NavigateTo(but.target)
		end
	else
		GP:NavigateBack()
	end
end

function ZGV_GP_OnMousewheel(self,delta)
	local offset = FauxScrollFrame_GetOffset(FR.Scroll)
	GP:UpdateScroll(offset-delta)
end

function GP:UpdateScroll(offset)
	if not offset then offset=FauxScrollFrame_GetOffset(FR.Scroll) end
	if offset>#self.flatgroup-10 then offset=#self.flatgroup-10 end
	if offset<0 then offset=0 end
	ZGV.GP.Frame.Scroll.ScrollBar:SetValue(offset*10)
end

function GP:SelectGuide(path)
	if type(path)=="table" and path.title then
		GP.selectedguide=path
	else
		GP.selectedguide=path and ZGV:GetGuideByTitle(path) or nil
	end
	GP:RefreshGuide()
end

function ZGV_GP_OKButton_OnClick(but)
	if GP.selectedguide then
		local ret = ZGV:SetGuide(GP.selectedguide.title,GP.path=="RECENT" and GP.selectedguide.CurrentStepNum or 1)
		GP:Hide()
	end
end
