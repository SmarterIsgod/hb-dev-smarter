local ZGV = ZygorGuidesViewer
local Pointer = ZGV.Pointer

local arrow = ZGV.Pointer:AddArrowSkin("3dgem","3D Gem")

local arrowframeproto = {}

arrow.features={colordist=false}

arrow.CreateFrame = function(self)
	if not self.frame then
		self.frame = CreateFrame("FRAME","ZygorGuidesViewerPointerArrow_3DGem",ZGV.Pointer.ArrowFrameCtrl,"ZygorGuidesViewerFrame_Arrow_template_3dgem")
		self.frame.style = self.id

		for f,fu in pairs(arrowframeproto) do self.frame[f] = fu end

		self.frame:OnLoad()
	end
	return self.frame
end

-- set textures in a button that has its normal/pushed/hilite textures named ntx,ptx,htx  - this was more useful some time ago...
local function SetNPHtx(but,n,p,h)
	assert(but,"How am I to set textures in a nil!?")
	but.ntx:SetTexture(n)
	but.ptx:SetTexture(p or n)
	but.htx:SetTexture(h or n)
end

local function BetterTexCoord(obj,x,w,y,h)
	obj:SetTexCoord((x-1)/w,x/w,(y-1)/h,y/h)
end

local function CreateTexWithCoordsNum(obj,tx,x,w,y,h)
	return CreateTextureWithCoords(obj,tx,(x-1)/w,x/w-(w/h)*0.0004,(y-1)/h,y/h-(w/h)*0.0004)
end


------------ color
local ar,ag,ab = 0.60,0.60,0.60
local br,bg,bb = 0.95,0.95,0.95
local cr,cg,cb = 1.00,1.00,1.00

local msin,mcos,mabs,mfloor=math.sin,math.cos,math.abs,math.floor

function arrowframeproto:OnLoad()
	local skindir = ZGV.DIR.."\\Arrows\\3D-Gem"
	self.back:SetAlpha(0.8)
	self:Hide()
	self.here:SetTexture(skindir.."\\arrow-here",false)
	self.back:SetTexture(skindir.."\\arrow-back",false)

	self.arrow:SetDisplayInfo(30355)
	self.arrow:SetLight(1,1, 0,-5,7, 1, 0,1,0,10)

	self:SetModel("redgem")
end

local models = {
	redgem = {model=30355,angle=math.pi/2,scale=2,shiftx=0,shifty=0.03,shiftz=0},
	redgem2 = {model=30355,angle=0,scale=0.05,shiftx=0.024,shifty=0.023,shiftz=0,camera=1},
	
	rfog={file=[[SPELLS\RedRadiationFog.m2]],angle=0,scale=0.1,shiftx=0.5,shifty=-0.3,shiftz=0,camera=nil},
}
function arrowframeproto:SetModel(data)
	if type(data)=="number" then data={model=data} end
	if type(data)~="table" then data=models[data] end
	if data and data.model then
		self.arrow:SetDisplayInfo(data.model)
	elseif data and data.file then
		self.arrow:SetModel(data.file)
	else
		self.arrow:SetDisplayInfo(30355)
	end
	if data and data.camera then self.arrow:SetCamera(data.camera) end
	self.basemodelscale=data and data.scale or 1
	self.angleoffset=data and data.angle or 0
	self.arrow:SetModelScale(self.basemodelscale)
	self.arrow:SetPosition(data and data.shiftx or 0,data and data.shifty or 0,data and data.shiftz or 0)
end

function arrowframeproto:OnUpdate (elapsed)
end

function arrowframeproto:ShowArrived()
	self.arrow:Hide()

	self.here:Show()
	self.here.zoomy:Play()
	--self.back.turny:Play()
	self.back:SetTexCoord(0,0,0,1,1,0,1,1)
end

function arrowframeproto:ShowTraveling (elapsed,angle,dist)
	self.here:Hide()
	self.back.turny:Stop()
	self.here.zoomy:Stop()

	self.arrow:Show()
	self.title:Show()

	local profile=ZGV.db.profile

	local perc,tier

	local spangood,spanperf=0.10,0.02
	--if dist<500 then local mul=1-(dist/500)  mul=mul*mul*mul*mul*mul  spangood,spanperf = spangood+spangood*mul,spanperf+spanperf*mul  end

	perc = mabs(1-angle*0.3183)  -- 1/pi  ;  0=target backwards, 1=target ahead
	perc,tier = Pointer.CalculateDirectionTiers(perc,1-spangood,1-spangood+0.02,1-spanperf,1)

	--local r,g,b = ZGV.gradient3(perc, ar,ag,ab, br,bg,bb, cr,cg,cb, 1)
	--self.arrow:SetVertexColor(r,g,b)

	self.arrow:SetModelScale(self.basemodelscale*(1+perc/3))


	------------ rotation of elements

	angle = angle + self.angleoffset
	while angle>6.2831853 do angle=angle-6.2831853 end
	while angle<0 do angle=angle+6.2831853 end
	self.arrow:SetFacing(angle)

	--[[
	local msin,mcos,mabs=msin,mcos,mabs

	local sin,cos = msin(angle + 2.356194)*0.85, mcos(angle + 2.356194)*0.85
	self.arrow:SetTexCoord(0.5-sin, 0.5+cos, 0.5+cos, 0.5+sin, 0.5-cos, 0.5-sin, 0.5+sin, 0.5-cos)
	--]]

end

function arrowframeproto:ShowText (title,dist,eta)
	local etatxt = ""

	local disttxt = dist>9999998  and  select(self.waypoint.c,GetMapContinents())  or  ZGV.FormatDistance(dist)

	if eta and eta<7200 and eta>0 then
		local time=GetTime()
		time=time-mfloor(time)
		local etacolor = (eta<10 and time>0.7) and "ffff7700" or "ffffbb00"
		etatxt = ("  |c"..etacolor.."%01d:%02d|r"):format(eta / 60, eta % 60)
	end

	local distcolor
	if dist<9999998 then
		if not Pointer.initialdist then Pointer.initialdist=dist end
		if Pointer.initialdist>500 then Pointer.initialdist=500 end
		if Pointer.initialdist<100 then Pointer.initialdist=100 end
		local perc=1-(dist/Pointer.initialdist)
		if perc<0 then perc=0 end
		local r,g,b = ZGV.gradient3(perc, 1.0,0.5,0.4, 1.0,0.9,0.5, 0.7,1.0,0.6, 0.7)
		distcolor = ("|cff%02x%02x%02x"):format(r*255,g*255,b*255)
	else
		distcolor = "|cffffff00"
	end

	self.title:SetText( (title and "|cffffffff"..title.."|r\n" or "") .. (disttxt and distcolor..disttxt.."|r" or "") .. etatxt )
end

function arrowframeproto:ShowWarning()
	UIFrameFlash(self.arrow,0.2,0.2,0.2, true,0,0)
end

function arrowframeproto:OnMouseWheel(delta)
	if IsControlKeyDown() then
		ZGV.db.profile.arrowscale = ZGV.db.profile.arrowscale + delta * 0.2
		if ZGV.db.profile.arrowscale<0.4 then ZGV.db.profile.arrowscale=0.4 end
		self:SetScale(ZGV.db.profile.arrowscale)
	end
end
