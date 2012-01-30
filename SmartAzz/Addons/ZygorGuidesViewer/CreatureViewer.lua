local ZGV = ZygorGuidesViewer
if not ZGV then return end

local CV = {}
ZGV.CreatureViewer = CV

tinsert(ZGV.startups,function(self)
	CV:CreateFrame()
	CV.Frame:Hide()
	self:ScheduleRepeatingTimer("TryToDisplayCreature", 1)
end)

function ZGV:TryToDisplayCreature()
	if self.db.profile.viewcreature and self.CurrentStep then
		for i,goal in ipairs(self.CurrentStep.goals) do
			local id = goal.npcid or (goal.mobs and goal.mobs[1] and goal.mobs[1].id) or goal.targetid
			if id then
				local name = self.Localizers:GetTranslatedNPC(id) or goal.npc or goal.target or (goal.mobs[1] and goal.mobs[1].name) or ""
				CV:ShowCreature(id,name)
				return
			end
		end
	end
	-- else...
	CV.Frame:Hide()
end

function CV:CreateFrame()
	if CV.Frame then return end
	CV.Frame = CreateFrame("FRAME","ZygorGuidesViewer_CreatureViewer",ZGV.Frame)
	CV.Frame:SetSize(100,150)
	CV.Frame:SetBackdrop({bgFile=ZGV.DIR.."\\Skins\\white",edgeFile=ZGV.SkinDir.."border",tile = true, edgeSize=20, tileSize = 20, insets = { left = 20, right = 20, top = 20, bottom = 20 }})
	CV.Frame:SetBackdropColor(0,0,0,0.50)
	CV.Frame:SetBackdropBorderColor(0,0,0,1)
	CV.Frame:EnableMouse(true)

	CV.Frame.model = CreateFrame("PlayerModel",nil,CV.Frame)
	CV.Frame.model:SetPoint("TOPLEFT",CV.Frame)
	CV.Frame.model:SetPoint("BOTTOMRIGHT",CV.Frame,"BOTTOMRIGHT",0,0)
	
	CV.Frame.title = CV.Frame:CreateFontString(CV.Frame:GetName().."_Title","ARTWORK","GameFontNormalSmall")
	CV.Frame.title:SetPoint("BOTTOM",CV.Frame)
	CV.Frame.title:SetSize(300,25)
	CV.Frame.title:SetJustifyH("CENTER")

	CV.Frame.close = CreateFrame("Button","ZygorGuidesViewer_CreatureViewer_Close",CV.Frame,"UIPanelCloseButton")
	CV.Frame.close:SetSize(20,20)
	CV.Frame.close:SetPoint("TOPRIGHT",CV.Frame,"TOPRIGHT",-5,-5)
	CV.Frame.close:SetScript("OnClick",function() CV.Frame:Hide() ZGV.db.profile.viewcreature=false end)

	CV.Frame.titleregion = CV.Frame:CreateTitleRegion()
	AssignButtonTexture(CV.Frame.close,ZGV.SkinDir.."titlebuttons",6,16)

	CV:AlignFrame()
end

function CV:AlignFrame()
	if ZGV.Frame.Border:GetAlpha()>0.01 then
		CV.Frame:SetPoint("TOPRIGHT",ZGV.Frame,"TOPLEFT")
	else
		CV.Frame:SetPoint("TOPRIGHT",ZGV.Frame.Border.Guides,"TOPLEFT",4,-22)
	end
end

function CV:ShowCreature(id,name)
	if not CV.Frame then CV:CreateFrame() end
	CV.Frame:Show()
	if (CV.creature_id~=id) or (not id) then
		CV.Frame.model:ClearModel()
		if id then CV.Frame.model:SetCreature(id) end
	end
	local model_check = CV.Frame.model:GetModel()
	if type(model_check)=="string" then
		CV.creature_id = id
		CV.Frame.title:SetText(name)
		CV:AlignFrame()
		CV.failed=nil
	else
		CV.Frame:Hide()
		CV.failed=true
	end
end
