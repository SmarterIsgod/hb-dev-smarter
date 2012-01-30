local me = ZygorGuidesViewer

local L = me.L
local LM = me.LM
local LI = me.LI
local LC = me.LC
local LQ = me.LQ
local LS = me.LS
local DL = me.DL

function me:Options_RegisterDefaults()
	self.db:RegisterDefaults({
		char = {
			starting = true,
			section = 1,
			step = 1,
			completedQuests = {},
			--permaCompletedDailies = {}, -- deprecating this, let's see if it works.
			completedDailies = {},
			debuglog = {},

			maint_startguides = true,
			maint_queryquests = true,

			guides_history = {},

			RecipesKnown = {},
			goodbadguides = {}
		},
		global = {
			storedguides = { },
			-- instantDailies = {}, -- let's not use this anymore, with GetQuestID available
		},
		profile = {
			debug = false,
			--autosizemini = true,
			--minimode = false,
			visible = true,

			showmapbutton = true,
			hideincombat = false,

			-- convenience
			autoaccept = false,
			autoturnin = false,
			fixblizzardautoaccept = false,
			analyzereps = false,


			skin = "midnight",
			skinstyle = "black",
			hideborder = false, --hidden anyway
			nevershowborder = false,
			showstepborders = true,
			showallsteps = false,
			showcountsteps = 1,
			showbriefsteps = false,
			hidecompletedinbrief = true,
			framescale = 1.0,
			fontsize = 12,
			fontsecsize = 11,

			--backcolor = {r=0.18,g=0.05,b=0.23,a=0.56},
			backopacity = 0.3,
			opacitymain = 1.0,

			goaltotals = true,

			stepbackalpha = 0.5,
			goalicons = true,
			goalbackgrounds = true,
			goalcolorize = false,
			goalbackincomplete = {r=0.6,g=0.0,b=0.0,a=0.7},
			goalbackprogressing= {r=0.6,g=0.7,b=0.0,a=0.7},
			goalbackcomplete   = {r=0.2,g=0.7,b=0.0,a=0.7},
			goalbackimpossible = {r=0.3,g=0.3,b=0.3,a=0.7},
			goalbackwarning    = {r=0.5,g=0.0,b=0.8,a=0.7},
			goalbackaux        = {r=0.0,g=0.5,b=0.8,a=0.5},
			goalbackprogress = true,
			
			goalupdateflash = true,
			goalcompletionflash = true,
			flashborder = true,

			tooltipsbelow = true,

			trackchains = true,

			skipimpossible = true,
			skipauxsteps = true,
			suggestionpopup = true,
			--goalbackobsolete   = {r=0.0,g=0.5,b=0.8,a=0.5},
			--skipobsolete = true,
			--levelsahead = 0,
			--chainskip = true,
			--chainskipcount = 5,

			hidearrowwithguide = true,
			iconAlpha = 1,
			iconScale = .5,
			minicons = true,
			filternotes = true,
			minimapnotedesc = true,

			stepnumbers = true,

			guidesinhistory = 5,

			waypointaddon = "internal",

			golddetectiondist = 400,
			goldreqmode = 3, -- current
			golddistmode = 1, -- in range

			arrowshow = true,
			arrowskin = "midnight",
			arrowmeters = false,
			arrowfreeze = false,
			--arrowcam = false,
			arrowcolordist = false,
			arrowalpha = 1.0,
			arrowscale = 1.0,
			arrowfontsize = 10,
			minimapzoom = false,
			foglight = true,
			pointeraudio = true,

			corpsearrow = true,
			corpsearrowjokes = true,

			fullheight = 400,

			completesound = "MapPing",
			flipsounds = true,

			briefopentime = 0.5,
			briefclosetime = 1.0,

			--colorborder = true,

			-- hidden

			displaymode = "guide",

			dispmodepri = true,
			dispprimary = {showcountsteps=1,hideborder=false,nevershowborder=false,showbriefsteps=false},
			dispsecondary = {showcountsteps=1,hideborder=true,nevershowborder=true,showbriefsteps=true,hidecompletedinbrief=true},

			badguidewarning = true,
		}
	})
end

function me:Options_SetFromMode()
	self.db.profile.dispmode = self.db.profile.dispmodepri and self.db.profile.dispprimary or self.db.profile.dispsecondary
	for k,kv in pairs(self.db.profile.dispmode) do self.db.profile[k]=kv end

	if self.db.profile.showcountsteps==0 then ZygorGuidesViewerFrame:SetHeight(self.db.profile.fullheight) end

	local hide = self.db.profile.hideborder
	self.borderfadedout = self.Frame.Border:GetAlpha()<0.1
	self.Frame.leftCount = hide and 999 or 0
	self.Frame.mouseCount = hide and 0 or 999

	self:UpdateFrame(true)
	self:AlignFrame()
	self:UpdateLocking()
	self:ScrollToCurrentStep()
end

function me:Options_DefineOptions()
	local Getter_Simple = function(info)
		return self.db.profile[info[#info]]
	end
	local Setter_Simple = function(info,value)
		self.db.profile[info[#info]] = value
	end
	local Setter_Update = function(info,value)
		Setter_Simple(info,value)
		self:UpdateFrame()
	end
	local Getter_Sub = function(var,info)
		return self.db.profile[var][info[#info]]
	end
	local Setter_Sub = function(var,info,value)
		self.db.profile[var][info[#info]] = value
		self:Options_SetFromMode()
	end

	self.options = {
		type='group',
		name = L["name"],
		desc = L["desc"],
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["desc"]:format(self.version),
			},
			desc2 = {
				order = 1.1,
				type = "header",
				name = L["opt_guide"]:format(self.version),
			},
			guided = {
				order = 2.1,
				type = "description",
				name = "Guide: "
			},
			guidet = {
				order = 2.2,
				type = "description",
				name = function() return ZGV.CurrentGuide and ZGV.CurrentGuide.title_short or "-none-" end,
			},
			guidel = {
				order = 2.3,
				type = "execute",
				name = "Load",
				func = function() InterfaceOptionsFrame:Hide()  ZGV:OpenGuideMenu() end,
			},
			--[[
			guide = {
				order = 2,
				type = "select",
				name = "",
				values = function() return ZGV:GetGuides() end,
				get = "GetCurrentGuideNum",
				set = function(info,i) self:SetGuide(i) self:FocusStep(1) end,
				width = "double",
			},
			--]]
			steps = {
				order=3.1,
				type = "description",
				name = function() if not ZGV.CurrentGuide then return "" end  return L["opt_guide_steps"]:format(#ZGV.CurrentGuide.steps) end,
			},
			author = {
				order=3.2,
				type = "description",
				name = function() if not ZGV.CurrentGuide or not ZGV.CurrentGuide.author then return "" end  return L["opt_guide_author"]:format(ZGV.CurrentGuide.author) end,
			},
			next = {
				order=3.3,
				type = "description",
				name = function() if not ZGV.CurrentGuide or not ZGV.CurrentGuide.next then return "" end  return L["opt_guide_next"]:format(ZGV.CurrentGuide.next) end,
			},
			show = {
				name = L["opt_visible"],
				desc = L["opt_visible_desc"],
				type = 'toggle',
				get = "IsVisible",
				set = "SetVisible",
				width = "full",
				order = 4.1,
			},
			showmapbutton = {
				name = L["opt_mapbutton"],
				desc = L["opt_mapbutton_desc"],
				type = 'toggle',
				get = Getter_Simple,
				set = function(i,v) Setter_Simple(i,v)  self:UpdateMapButton()  end,
				width = "full",
				order = 4.2,
			},
			sep1 = {
				type="description", name=" |n |n |n", order=98
			},
			report = {
				name = L["opt_report"],
				desc = L["opt_report_desc"],
				type = 'execute',
				func = function() ZGV:BugReport() end,
				order = 99,
			},
			debug = {
				hidden = true,
				name = L["opt_debug"],
				desc = L["opt_debug_desc"],
				type = 'toggle',
				get = function() return self.db.profile.debug end,
				set = function() self.db.profile.debug = not self.db.profile.debug  ZGV:Print("Debugging: "..(self.db.profile.debug and "|cff00ff88ON|r" or "|cffff0055OFF|r")) end,
				order=-10,
			},
		}
	}

	self.optionsdisplay = {
		type='group',
		name = L["opt_group_display"],
		desc = L["opt_group_display_desc"],
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			desc = {
				name = L["opt_group_display_desc"],
				type = "description",
				order = 1,
			},
			skin = {
				name = L["opt_skin"],
				desc = L["opt_skin_desc"],
				type = "select",
				values = function()
					local t={}
					for id,skin in pairs(self.Skins) do
						t[id]=skin.name
					end
					return t
				end,
				set = function(_,n)
					self:SetSkin(n)
					self:UpdateSkin()
					self:AlignFrame()
					self:UpdateLocking()
					self:ScrollToCurrentStep()
				      end,
				order=1.1,
			},
			skinstyle = {
				name = L["opt_skinstyle"],
				desc = L["opt_skinstyle_desc"],
				type = "select",
				values = function()
					if not self.CurrentSkin then return {} end
					local t={}
					for id,style in pairs(self.CurrentSkin.styles) do
						t[id]=style.name
					end
					return t
				end,
				set = function(_,n)
					self:SetSkin(self.db.profile.skin,n)
					self:UpdateSkin()
					self:AlignFrame()
					self:UpdateLocking()
					self:ScrollToCurrentStep()
				      end,
				hidden = function() return not self.CurrentSkin or not self.CurrentSkin.styles or not next(self.CurrentSkin.styles,next(self.CurrentSkin.styles)) end,
				order=1.2,
			},
			sep2 = {type="description",name="",order=2},
			opacitymain = {
				name = L["opt_opacitymain"],
				desc = L["opt_opacitymain_desc"],
				type = 'range',
				set = function(i,v) Setter_Simple(i,v)  self:AlignFrame() end,
				min = 0,
				max = 1.0,
				isPercent = true,
				step = 0.01,
				bigStep = 0.1,
				--stepBasis = 0,
				--width="double",
				order=2.1,
			},
			framescale = {
				name = L["opt_framescale"],
				desc = L["opt_framescale_desc"],
				type = 'range',
				set = function(i,v) Setter_Simple(i,v) 	self.Frame:SetScale(ZGV.db.profile.framescale)  end,
				min = 0.5,
				max = 2.0,
				step = 0.1,
				bigStep = 0.1,
				order=2.2,
				isPercent = true,
			},
			sep2b = {type="description",name="",order=2},
			fontsize = {
				name = L["opt_fontsize"],
				desc = L["opt_fontsize_desc"],
				type = 'range',
				set = function(i,v) Setter_Simple(i,v)  self:AlignFrame()  self:UpdateFrame()  end,
				min = 7,
				max = 16,
				step = 1,
				bigStep = 1,
				order=2.3,
			},
			fontsecsize = {
				name = L["opt_fontsecsize"],
				desc = L["opt_fontsecsize_desc"],
				type = 'range',
				set = function(i,v) Setter_Simple(i,v)  self:AlignFrame()  self:UpdateFrame()  end,
				min = 5,
				max = 14,
				step = 1,
				bigStep = 1,
				order=2.4,
			},
			dispmodepri = {
				name = L["opt_dispmode"],
				desc = L["opt_dispmode_desc"],
				type = 'toggle',
				hidden=true,
				set = function(i,v)
					self.db.profile.dispmodepri = v
					self:Options_SetFromMode()
				      end,
				order=2.5,
			},
			--[[
			backcolor = {
				name = L["opt_backcolor"],
				desc = L["opt_backcolor_desc"],
				type = 'color',
				hasAlpha = true,
				get = function()  return self.db.profile.backcolor.r,self.db.profile.backcolor.g,self.db.profile.backcolor.b,self.db.profile.backcolor.a  end,
				set = function(_,r,g,b,a)  self.db.profile.backcolor = {['r']=r,['g']=g,['b']=b,['a']=a}  self:UpdateSkin()  end,
				order = 2.2,
			},
			backopacity = {
				name = L["opt_backopacity"],
				desc = L["opt_backopacity_desc"],
				type = 'range',
				set = function(i,v) Setter_Simple(i,v)  self:UpdateSkin()  end,
				min=0.0,
				max=1.0,
				isPercent = true,
				step = 0.01,
				bigStep = 0.1,
				order = 2.2,
			},
			--]]
			sep3 = {type="description",name="",order=3},
			windowlocked = {
				name = L['opt_windowlocked'],
				desc = L['opt_windowlocked_desc'],
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v)  self:UpdateLocking()  end,
				order=3.2,
			},
			resizeup = {
				name = L["opt_miniresizeup"],
				desc = L["opt_miniresizeup_desc"],
				type = 'toggle',
				set = function(i,v)
					Setter_Simple(i,v)
					self:ReanchorFrame()
					self:Debug("size up? "..tostring(self.db.profile.resizeup))
					--self.frameNeedsResizing = self.frameNeedsResizing + 1
					self:AlignFrame()
					-- THIS SUCKS.
				      end,
				order=3.3,
			},
			hideincombat = {
				name = L["opt_hideincombat"],
				desc = L["opt_hideincombat_desc"],
				type = 'toggle',
				order = 3.4,
				get = Getter_Simple,
				set = Setter_Simple,
			},
			sep4 = {type="description",name="",order=4},
			modes = {
				name = L["opt_prisecmodes"],
				desc = "modes desc",
				type = "group",
				childGroups = "tab",
				order=4.1,
				inline=true,
				args = {
					sep4 = {type="description",name=L['opt_modes_desc'],order=0.1},
					primary = {
						name = L["opt_modepri"],
						type = "group",
						order=1,
						width="single",
						get=function(info) return Getter_Sub("dispprimary",info) end,
						set=function(info,value) Setter_Sub("dispprimary",info,value) end,
						args = {
							active = {
								name = "Active",
								desc = "",
								type = "toggle",
								get = function() return self.db.profile.dispmodepri end,
								set = function(i,v) if not v then return end self.db.profile.dispmodepri=v self:Options_SetFromMode() end,
								order=0.1,
							},
							sep0 = {type="description",name="",order=0.2},
							showcountsteps = {
								name = L["opt_showcountsteps"],
								desc = L["opt_showcountsteps_desc"],
								type = "select",
								values = {
									[0]=L["opt_showcountsteps_all"],
									[1]="1 (default)",
									[2]="2",[3]="3",[4]="4",[5]="5"
								},
								order=1.1,
							},
							sep1 = {type="description",name="",order=1.2},
							showbriefsteps = {
								name = L["opt_showbriefsteps"],
								desc = L["opt_showbriefsteps_desc"],
								type = 'toggle',
								set=function(info,value) if not value then self.db.profile.dispprimary.hidecompletedinbrief=false end  Setter_Sub("dispprimary",info,value) end,
								order=1.51,
							},
							hideborder = {
								name = L["opt_hideborder"],
								desc = L["opt_hideborder_desc"],
								type = 'toggle',
								set=function(info,value) if not value then self.db.profile.dispprimary.nevershowborder=false end  Setter_Sub("dispprimary",info,value) end,
								order=1.52,
							},
							sep2 = {type="description",name="",order=2},
							hidecompletedinbrief = {
								name = L["opt_hidecompletedinbrief"],
								desc = L["opt_hidecompletedinbrief_desc"],
								type = 'toggle',
								disabled = function() return not self.db.profile.dispprimary.showbriefsteps end,
								get = function(i) return self.db.profile.dispprimary.showbriefsteps and Getter_Sub("dispprimary",i) end,
								order=3.0,
							},
							nevershowborder = {
								name = L["opt_nevershowborder"],
								desc = L["opt_nevershowborder_desc"],
								type = 'toggle',
								disabled = function() return not self.db.profile.dispprimary.hideborder end,
								get = function(i) return self.db.profile.dispprimary.hideborder and Getter_Sub("dispprimary",i) end,
								order=3.1,
							},
						},
					},
					secondary = {
						name = L["opt_modesec"],
						type = "group",
						order=2,
						width="single",
						get=function(info) return Getter_Sub("dispsecondary",info) end,
						set=function(info,value) Setter_Sub("dispsecondary",info,value) end,
						args = {
							active = {
								name = "Active",
								desc = "",
								type = "toggle",
								get = function() return not self.db.profile.dispmodepri end,
								set = function(i,v) if not v then return end self.db.profile.dispmodepri=not v self:Options_SetFromMode() end,
								order=0.1,
							},
							sep0 = {type="description",name="",order=0.2},
							showcountsteps = {
								name = L["opt_showcountsteps"],
								desc = L["opt_showcountsteps_desc"],
								type = "select",
								values = {
									[0]=L["opt_showcountsteps_all"],
									[1]="1 (default)",
									[2]="2",[3]="3",[4]="4",[5]="5"
								},
								order=1.1,
							},
							sep1 = {type="description",name="",order=1.2},
							showbriefsteps = {
								name = L["opt_showbriefsteps"],
								desc = L["opt_showbriefsteps_desc"],
								type = 'toggle',
								set=function(info,value) if not value then self.db.profile.dispsecondary.hidecompletedinbrief=false end  Setter_Sub("dispsecondary",info,value) end,
								order=1.51,
							},
							hideborder = {
								name = L["opt_hideborder"],
								desc = L["opt_hideborder_desc"],
								type = 'toggle',
								set=function(info,value) if not value then self.db.profile.dispsecondary.nevershowborder=false end  Setter_Sub("dispsecondary",info,value) end,
								order=1.52,
							},
							sep2 = {type="description",name="",order=2},
							hidecompletedinbrief = {
								name = L["opt_hidecompletedinbrief"],
								desc = L["opt_hidecompletedinbrief_desc"],
								type = 'toggle',
								disabled = function() return not self.db.profile.dispsecondary.showbriefsteps end,
								get = function(i) return self.db.profile.dispsecondary.showbriefsteps and Getter_Sub("dispsecondary",i) end,
								order=3.0,
							},
							nevershowborder = {
								name = L["opt_nevershowborder"],
								desc = L["opt_nevershowborder_desc"],
								type = 'toggle',
								disabled = function() return not self.db.profile.dispsecondary.hideborder end,
								get = function(i) return self.db.profile.dispsecondary.hideborder and Getter_Sub("dispsecondary",i) end,
								order=3.1,
							},
						},
					},
				},
			},
			briefopentime = {
				name = L["opt_briefopentime"],
				desc = L["opt_briefopentime_desc"],
				type = 'range',
				min = 0.1,
				max = 2,
				step = 0.1,
				bigStep = 0.1,
				order=5.1
			},
			briefclosetime = {
				name = L["opt_briefclosetime"],
				desc = L["opt_briefclosetime_desc"],
				type = 'range',
				min = 0.1,
				max = 5,
				step = 0.1,
				bigStep = 0.1,
				order=5.2
			},
			sep21 = {type="description",name="",order=6},
			guidesinhistory = {
				name = L["opt_guidesinhistory"],
				desc = L["opt_guidesinhistory_desc"],
				type = 'range',
				min = 3,
				max = 15,
				set = function(i,v) Setter_Simple(i,v)  while (#self.db.char.guides_history>v) do tremove(self.db.char.guides_history) end   end,
				step = 1,
				bigStep = 1,
				order=6.1
			},

			sep1 = {type="description",name="",order=99},

			resetwindow = {
				name = L["opt_resetwindow"],
				desc = L["opt_resetwindow_desc"],
				type = 'execute',
				func = function()
					self.Frame:GetParent():ClearAllPoints()
					self.Frame:GetParent():SetPoint("CENTER")
					self:SetOption("Display","dispmodepri on")
					ZygorGuidesViewerMapIcon:ClearAllPoints()
					ZygorGuidesViewerMapIcon:SetPoint("CENTER",Minimap,"BOTTOMLEFT",16,16)
					UpdateFrame(true)
				end,
				order = 99.1,
			},
			--[[
			-- no longer an option
			trackchains = {
				name = L["opt_trackchains"],
				desc = L["opt_trackchains_desc"],
				type = 'toggle',
				width = "full",
				order = 101,
			},
			mapicons = {
				name = "Show map icons",
				desc = "Show icons on the world map",
				type = 'toggle',
				set = "ToggleShowingMapIcons",
				get = "IsShowingMapIcons",
				order = 1,
			},
			]]--
		},
	}

	local function rgb2list (rgba)
		if not rgba then rgba={r=0,g=1,b=0,a=1} end
		return rgba.r,rgba.g,rgba.b,rgba.a
	end

	self.optionsstep = {
		name = L["opt_group_step"],
		desc = L["opt_group_step_desc"],
		type = "group",
		handler = self,
		get = Getter_Simple,
		set = Setter_Update,
		inline=true,
		args = {
			desc = {
				name = L["opt_group_step_desc"],
				type = "description",
				order = 1,
			},

			--desc_mp = { type="header", name=L["opt_modepri"], desc=L["opt_modes_desc"], order=1.01 },
			showstepborders = {
				name = L["opt_showstepborders"],
				desc = L["opt_showstepborders_desc"],
				type = 'toggle',
				order = 2.1,
			},
			stepbackalpha = {
				name = L["opt_stepbackopacity"],
				desc = L["opt_stepbackopacity_desc"],
				type = 'range',
				min=0.0,
				max=1.0,
				isPercent = true,
				step = 0.1,
				bigStep = 0.1,
				disabled = function() return not self.db.profile.showstepborders end,
				order = 2.2,
			},
			sep3 = {type="description",name="",order=3},

			stepnumbers = {
				name = L["opt_stepnumber"],
				desc = L["opt_stepnumber_desc"],
				type = 'toggle',
				order = 3.1,
			},
			goalicons = {
				name = L["opt_goalicons"],
				desc = L["opt_goalicons_desc"],
				type = 'toggle',
				order = 3.2,
			},
			tooltipsbelow = {
				name = L["opt_tooltipsbelow"],
				desc = L["opt_tooltipsbelow_desc"],
				type = 'toggle',
				width = "double",
				order = 3.3,
			},
			goaltotals = {
				name = L["opt_goaltotals"],
				desc = L["opt_goaltotals_desc"],
				type = 'toggle',
				order = 3.4,
			},
			--[[
			goalcolorize = {
				name = L["opt_goalcolorize"],
				desc = L["opt_goalcolorize_desc"],
				type = 'toggle',
				order = 3.4,
				width = "double",
			},
			--]]


			desc1 = { type="header", name=L["opt_goalbackcolor_desc"], order=10.1 },
			goalbackgrounds = {
				name = L["opt_goalbackgrounds"],
				desc = L["opt_goalbackgrounds_desc"],
				type = 'toggle',
				order = 10.11,
			},
			goalbackprogress = {
				name = L["opt_goalbackprogress"],
				desc = L["opt_goalbackprogress_desc"],
				type = 'toggle',
				disabled = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return self.db.profile.goalbackprogress  end,
				order = 10.12,
			},

			desc11 = { type="description", name="", order=10.19 },
			goalbackincomplete = {
				name = L["opt_goalbackincomplete"],
				desc = L["opt_goalbackincomplete_desc"],
				type = 'color',
				disabled = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return rgb2list(self.db.profile.goalbackincomplete)  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackincomplete = {r=r,g=g,b=b,a=a}  self:UpdateFrame()  end,
				order = 10.21,
				hasAlpha = true,
			},
			goalbackprogressing = {
				name = L["opt_goalbackprogressing"],
				desc = L["opt_goalbackprogressing_desc"],
				type = 'color',
				disabled = function()  return not self.db.profile.goalbackgrounds or not self.db.profile.goalbackprogress  end,
				get = function()  return rgb2list(self.db.profile.goalbackprogressing)  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackprogressing = {r=r,g=g,b=b,a=a}  self:UpdateFrame()  end,
				order = 10.22,
				hasAlpha = true,
			},
			goalbackcomplete = {
				name = L["opt_goalbackcomplete"],
				desc = L["opt_goalbackcomplete_desc"],
				type = 'color',
				disabled = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return rgb2list(self.db.profile.goalbackcomplete)  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackcomplete = {r=r,g=g,b=b,a=a}  self:UpdateFrame()  end,
				order = 10.23,
				hasAlpha = true,
			},
			goalbackimpossible = {
				name = L["opt_goalbackimpossible"],
				desc = L["opt_goalbackimpossible_desc"],
				type = 'color',
				disabled = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return rgb2list(self.db.profile.goalbackimpossible)  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackimpossible = {r=r,g=g,b=b,a=a}  self:UpdateFrame()  end,
				order = 10.24,
				hasAlpha = true,
			},
			goalbackwarning = {
				name = L["opt_goalbackwarning"],
				desc = L["opt_goalbackwarning_desc"],
				type = 'color',
				disabled = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return rgb2list(self.db.profile.goalbackwarning)  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackwarning = {r=r,g=g,b=b,a=a}  self:UpdateFrame()  end,
				order = 10.25,
				hasAlpha = true,
			},
			goalbackaux = {
				name = L["opt_goalbackaux"],
				desc = L["opt_goalbackaux_desc"],
				type = 'color',
				hidden = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return self.db.profile.goalbackaux.r,self.db.profile.goalbackaux.g,self.db.profile.goalbackaux.b,self.db.profile.goalbackaux.a  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackaux = {['r']=r,['g']=g,['b']=b,['a']=a}  self:UpdateFrame()  end,
				order = 12.26,
				hasAlpha = true,
			},
			sep4 = { type="description", name="", order=13.1 },

			desc2 = { type="header", name=L["opt_flash_desc"], order=13.2 },

			goalupdateflash = {
				name = L["opt_goalupdateflash"],
				desc = L["opt_goalupdateflash_desc"],
				type = 'toggle',
				disabled = function()  return not self.db.profile.goalbackgrounds  end,
				set = function(_,v)  Setter_Simple(_,v)  if v then self.db.profile.goalcompletionflash=true end  end,
				width = "full",
				order = 14.1,
			},
			goalcompletionflash = {
				name = L["opt_goalcompletionflash"],
				desc = L["opt_goalcompletionflash_desc"],
				type = 'toggle',
				--hidden = function()  return not self.db.profile.goalbackgrounds  end,
				disabled = function()  return not self.db.profile.goalbackgrounds end,
				get = function()  return self.db.profile.goalcompletionflash --[[or self.db.profile.goalupdateflash--]]  end,
				set = function(_,v)  Setter_Simple(_,v)  if not v then self.db.profile.goalupdateflash=false end  end,
				width = "full",
				order = 14.2,
			},
			flashborder = {
				name = L["opt_flashborder"],
				desc = L["opt_flashborder_desc"],
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v) if (v) then self.delayFlash=1 end end, 
				width = "full",
				order = 14.3,
			},

			--[[
			colorborder = {
				name = L["opt_colorborder"],
				desc = L["opt_colorborder_desc"],
				type = 'toggle',
				get = "IsColorBorder",
				set = "ToggleColorBorder",
				order = 14.1,
				width="double",
			},
			--]]
		},
	}

	-- bye dynamic progress for now
	--[[
	self.optionsprogress = {
		name = L["opt_group_progress"],
		desc = L["opt_group_progress_desc"],
		type = 'group',
		order = 3,
		--hidden = true,
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L['opt_group_progress_desc'],
			},
			skipobsolete = {
				name = L["opt_skipobsolete"],
				desc = L["opt_skipobsolete_desc"],
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v)  self:UpdateFrame()  end,
				width = "full",
				order = 2,
			},
			skipimpossible = {
				name = L["opt_skipimpossible"],
				desc = L["opt_skipimpossible_desc"],
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v)  self:UpdateFrame()  end,
				width = "full",
				order = 3.4,
			},
			skipauxsteps = {
				name = L["opt_skipauxsteps"],
				desc = L["opt_skipauxsteps_desc"],
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v)  self:UpdateFrame()  end,
				width = "full",
				order = 3.5,
			},
			levelsahead = {
				name = function() return L['opt_levelsahead']:format(self.db.profile.levelsahead) end,
				desc = L['opt_levelsahead_desc'],
				disabled = function()  return not self.db.profile.skipobsolete  end,
				type = 'range',
				min = 0,
				max = 80,
				step = 1,
				bigStep = 1,
				width="single",
				order = 4
			},
			chainskip = {
				name = function ()
					if self.db.profile.chainskip then
						if self.db.profile.chainskipcount==21 then
							return L['opt_chainskip']:format(L['opt_chainskip_compl'])
						else
							return L['opt_chainskip']:format(L['opt_chainskip_count']:format(self.db.profile.chainskipcount))
						end
					else
						return L['opt_chainskip']:format("")
					end
				       end,
				desc = L['opt_chainskip_desc'],
				set = function(i,v)
					Setter_Simple(i,v)
					self:UpdateFrame()

					-- TODO: make this work.
					--self.optionpanels.progress.obj.children[1].children[7].lowtext:SetText("Early")
					--self.optionpanels.progress.obj.children[1].children[7].hightext:SetText("Never")
				      end,
				disabled = function()  return not self.db.profile.skipobsolete  end,
				type = 'toggle',
				width="full",
				order = 5.1
			},
			chainskipcount = {
				name = L['opt_chainskipcount'],
				desc = L['opt_chainskipcount_desc'],
				type = 'range',
				min = 1,
				max = 21,
				step = 1,
				bigStep = 1,
				disabled = function()  return not self.db.profile.chainskip or not self.db.profile.skipobsolete  end,
				width="single",
				order = 5.2
			},

			desc1 = { type="header", name=L["opt_progressbackcolor_desc"], order=11 },
			goalbackaux = {
				name = L["opt_goalbackaux"],
				desc = L["opt_goalbackaux_desc"],
				type = 'color',
				hidden = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return self.db.profile.goalbackaux.r,self.db.profile.goalbackaux.g,self.db.profile.goalbackaux.b,self.db.profile.goalbackaux.a  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackaux = {['r']=r,['g']=g,['b']=b,['a']=a}  self:UpdateFrame()  end,
				order = 12.1,
				hasAlpha = true,
			},
			goalbackobsolete = {
				name = L["opt_goalbackobsolete"],
				desc = L["opt_goalbackobsolete_desc"],
				type = 'color',
				hidden = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return self.db.profile.goalbackobsolete.r,self.db.profile.goalbackobsolete.g,self.db.profile.goalbackobsolete.b,self.db.profile.goalbackobsolete.a  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackobsolete = {['r']=r,['g']=g,['b']=b,['a']=a}  self:UpdateFrame()  end,
				order = 12.2,
				hasAlpha = true,
			},
			desc2 = { type="description", name="", order=13 },
			desc3 = {
				type = "description",
				name = L['opt_group_progress_bottomdesc'],
				order = 99,
			},
		}
	}
	--]]

	self.optionsprogress = {
		name = L["opt_group_progress"],
		desc = L["opt_group_progress_desc"],
		type = 'group',
		order = 3,
		--hidden = true,
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L['opt_group_progress_desc'],
			},
			skipimpossible = {
				name = L["opt_skipimpossible"],
				desc = L["opt_skipimpossible_desc"],
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v)  self:UpdateFrame()  end,
				width = "full",
				order = 3.4,
			},
			suggestionpopup = {
				name = L["opt_suggestionpopup"],
				desc = L["opt_suggestionpopup_desc"],
				type = 'toggle',
				width = "full",
				order = 3.5,
			},
			--[[
			skipauxsteps = {
				name = L["opt_skipauxsteps"],
				desc = L["opt_skipauxsteps_desc"],
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v)  self:UpdateFrame()  end,
				width = "full",
				order = 3.5,
			},
			levelsahead = {
				name = function() return L['opt_levelsahead']:format(self.db.profile.levelsahead) end,
				desc = L['opt_levelsahead_desc'],
				disabled = function()  return not self.db.profile.skipobsolete  end,
				type = 'range',
				min = 0,
				max = 80,
				step = 1,
				bigStep = 1,
				width="single",
				order = 4
			},
			desc1 = { type="header", name=L["opt_progressbackcolor_desc"], order=11 },
			goalbackaux = {
				name = L["opt_goalbackaux"],
				desc = L["opt_goalbackaux_desc"],
				type = 'color',
				hidden = function()  return not self.db.profile.goalbackgrounds  end,
				get = function()  return self.db.profile.goalbackaux.r,self.db.profile.goalbackaux.g,self.db.profile.goalbackaux.b,self.db.profile.goalbackaux.a  end,
				set = function(_,r,g,b,a)  self.db.profile.goalbackaux = {['r']=r,['g']=g,['b']=b,['a']=a}  self:UpdateFrame()  end,
				order = 12.1,
				hasAlpha = true,
			},
			desc2 = { type="description", name="", order=13 },
			desc3 = {
				type = "description",
				name = L['opt_group_progress_bottomdesc'],
				order = 99,
			},
			--]]
		}
	}

	self.optionsgold = {
		name = L['opt_group_gold'],
		desc = L['opt_group_gold_desc'],
		type = 'group',
		order = 4,
		hidden = not ZGV.AllianceGoldInstalled and not ZGV.HordeGoldInstalled,
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L['opt_group_gold_desc'],
			},
			golddetectiondist = {
				name = L['opt_gold_detectiondist'],
				desc = L['opt_gold_detectiondist_desc'],
				type = 'range',
				min = 100,
				max = 3000,
				step = 1,
				bigStep = 1,
				set = function(i,v) Setter_Simple(i,v)  end,
				width = "double",
				order = 2,
			},
			goldreqmode = {
				name = L['opt_gold_reqmode'],
				desc = L['opt_gold_reqmode_desc'],
				type = "select",
				style = "radio",
				values = {
					[1]=L['opt_gold_reqmode_all'],
					[2]=L['opt_gold_reqmode_future'],
					[3]=L['opt_gold_reqmode_current'],
				},
				set = function(i,v) Setter_Simple(i,v)  ZGV:UpdateMapSpotVisibilities()  end,
				width = "double",
				order = 3,
			},
		}
	}
			
	self.optionsconv = {
		name = L["opt_group_convenience"],
		desc = L["opt_group_convenience_desc"],
		type = 'group',
		order = 5,
		--hidden = true,
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L['opt_group_convenience_desc'],
			},
			autoaccept = {
				name = L["opt_autoaccept"],
				desc = L["opt_autoaccept_desc"],
				type = 'toggle',
				width = "full",
				order = 3.4,
			},
			autoturnin = {
				name = L["opt_autoturnin"],
				desc = L["opt_autoturnin_desc"],
				type = 'toggle',
				width = "full",
				order = 3.5,
			},
			fixblizzardautoaccept = {
				name = L["opt_fixblizzardautoaccept"],
				desc = L["opt_fixblizzardautoaccept_desc"],
				type = 'toggle',
				width = "full",
				order = 3.6,
			},
			analyzereps = {
				name = L["opt_analyzereps"],
				desc = L["opt_analyzereps_desc"],
				type = 'toggle',
				width = "full",
				order = 3.7,
			},
			viewcreature = {
				name = L["opt_viewcreature"],
				desc = L["opt_viewcreature_desc"],
				type = 'toggle',
				width = "full",
				order = 3.8,
			}
		}
	}

	local sepn=0
	local sep=function() sepn=sepn+1 return "sep"..sepn end
			
	self.optionsmap = {
		name = L["opt_group_map"],
		desc = L["opt_group_map_desc"],
		type = 'group',
		order = 6,
		--hidden = true,
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["opt_group_map_desc"],
			},
			waypoints = {
				name = L["opt_group_map_waypointing"],
				desc = L["opt_group_map_waypointing_desc"],
				type = 'select',
				values = {
					[1]=L["opt_group_addons_none"],
					[2]=L["opt_group_addons_internal"],
					[3]=(ZGV.WaypointFunctions['cart2']:isready() and "" or "|cff888888") .. L["opt_group_addons_cart2"],
					[4]=(ZGV.WaypointFunctions['carbonite']:isready() and "" or "|cff888888") .. L["opt_group_addons_carbonite"],
					[5]=(ZGV.WaypointFunctions['tomtom']:isready() and "" or "|cff888888") .. L["opt_group_addons_tomtom"],
					--cart3=L["opt_group_addons_cart3"],
					--metamap=L["opt_group_addons_metamap"],
				},
				get = "GetWaypointAddon",
				set = "SetWaypointAddon",
				order = 2,
			},

			[sep()] = { type="description", name="", order=2.01 },

			hidearrowwithguide = {
				name = L["opt_group_map_hidearrowwithguide"],
				desc = L["opt_group_map_hidearrowwithguide_desc"],
				type = 'toggle',
				disabled = function() return self.db.profile.waypointaddon=="none" end,
				order = 2.1,
				width="full",
			},
			[sep()] = { type="description", name="", order=2.01 },

			minicons = {
				name = "Show minimap icons",
				desc = "Show icons on the minimap",
				type = 'toggle',
				get = "IsShowingMinimapIcons",
				set = "ToggleShowingMinimapIcons",
				disabled = function() return self.db.profile.waypointaddon=="none" end,
				order = 3,
				width="single",
			},
			transparency = {
				name = "Icon alpha",
				desc = "Alpha transparency of map note icons",
				type = 'range',
				min = 0.1,
				max = 1,
				step = 0.01,
				bigStep = 0.05,
				isPercent = true,
				get = "GetIconAlpha",
				set = "SetIconAlpha",
				disabled = function() return not self:IsShowingMinimapIcons() or (self.db.profile.waypointaddon~="cart2") end,
				order = 3.1,
			},
			scale = {
				name = "Icon size",
				desc = "Size of the icons on the map",
				type = 'range',
				min = 0.5,
				max = 2,
				step = 0.01,
				bigStep = 0.05,
				isPercent = true,
				get = "GetIconScale",
				set = "SetIconScale",
				disabled = function() return not self:IsShowingMinimapIcons() or (self.db.profile.waypointaddon~="cart2") end,
				order = 3.2,
			},
			
			[sep()] = { type="description", name="", order=3.99 },
			
			corpsearrow = {
				name = L["opt_corpsearrow"],
				desc = L["opt_corpsearrow_desc"],
				type = 'toggle',
				order = 6.1,
				disabled = function() return self.db.profile.waypointaddon=="none" end,
			},
			corpsearrowjokes = {
				name = L["opt_corpsearrowjokes"],
				desc = L["opt_corpsearrowjokes_desc"],
				type = 'toggle',
				order = 6.2,
				disabled = function() return not self.db.profile.corpsearrow or self.db.profile.waypointaddon=="none" end,
			},

			_internal = {
				name = L["opt_group_mapinternal"],
				type = "group",
				inline = true,
				order = 10,
				disabled = function() return self.db.profile.waypointaddon~="internal" end,
				width = double,
				args = {
					arrowskin = {
						name = L["opt_arrowskin"],
						desc = L["opt_arrowskin_desc"],
						type = "select",
						values = function()
							local t={}
							for id,skin in pairs(self.Pointer.ArrowSkins) do
								t[id]=skin.name
							end
							return t
						end,
						set = function(_,n)
							self.Pointer:SetArrowSkin(n)
						      end,
						order=1.00,
					},
					[sep()] = { type="description", name="", order=1.99 },
					arrowshow = {
						name = L["opt_arrowshow"],
						desc = L["opt_arrowshow_desc"],
						type = 'toggle',
						set = function(i,v) Setter_Simple(i,v)  self.Pointer:UpdateArrowVisibility() end,
						order = 10.05,
						width="double",
					},
					arrowfreeze = {
						name = L["opt_arrowfreeze"],
						desc = L["opt_arrowfreeze_desc"],
						type = 'toggle',
						set = function(i,v) Setter_Simple(i,v)  self.Pointer:SetupArrow() end,
						width = "full",
						order = 10.1,
					},
					arrowmeters = {
						name = L["opt_arrowmeters"],
						desc = L["opt_arrowmeters_desc"],
						type = 'toggle',
						width = "full",
						order = 10.15,
					},
					arrowsmooth = {
						name = L["opt_arrowsmooth"],
						desc = L["opt_arrowsmooth_desc"],
						type = 'toggle',
						width = "full",
						order = 10.18,
					},
					--[[
					arrowcam = {
						name = L["opt_arrowcam"],
						desc = L["opt_arrowcam_desc"],
						type = 'toggle',
						set = function(i,v) Setter_Simple(i,v)  self.Pointer:HandleCamRegistration()  end,
						width = "full",
						order = 10.17,
					},
					--]]
					arrowcolordist = {
						name = L["opt_arrowcolordist"],
						desc = L["opt_arrowcolordist_desc"],
						type = 'toggle',
						disabled = function() return not ZGV.Pointer.CurrentArrowSkin.features['colordist'] end,
						width = "full",
						order = 10.2,
					},

					arrowalpha = {
						name = L["opt_arrowalpha"],
						desc = L["opt_arrowalpha_desc"],
						type = 'range',
						set = function(i,v) Setter_Simple(i,v) 	ZGV.Pointer:SetupArrow()  end,
						min = 0.3,
						max = 1.0,
						step = 0.1,
						bigStep = 0.1,
						isPercent = true,
						order = 10.205,
					},
					arrowscale = {
						name = L["opt_arrowscale"],
						desc = L["opt_arrowscale_desc"],
						type = 'range',
						set = function(i,v) Setter_Simple(i,v) 	ZGV.Pointer:SetupArrow()  end,
						min = 0.5,
						max = 2.0,
						step = 0.1,
						bigStep = 0.1,
						isPercent = true,
						order = 10.205,
					},
					arrowfontsize = {
						name = L["opt_arrowfontsize"],
						desc = L["opt_arrowfontsize_desc"],
						type = 'range',
						min = 5,
						max = 15,
						step = 0.5,
						bigStep = 1.0,
						set = function(i,v) Setter_Simple(i,v)  ZGV.Pointer:SetFontSize(v)  end,
						order = 10.21
					},

					desc1 = { type="header", name=L["opt_map_extras"], order=11 },
					foglight = {
						name = L["opt_foglight"],
						desc = L["opt_foglight_desc"],
						type = 'toggle',
						set = function(i,v) Setter_Simple(i,v)  if v then self.Foglight:Startup() else self.Foglight:TurnOff() end end,
						width = "full",
						order = 11.23,
					},
					minimapzoom = {
						name = L["opt_minimapzoom"],
						desc = L["opt_minimapzoom_desc"],
						type = 'toggle',
						set = function(i,v) Setter_Simple(i,v)  self.Pointer:MinimapZoomChanged() end,
						width = "full",
						order = 11.24,
					},
					audiocues = {
						name = L["opt_audiocues"],
						desc = L["opt_audiocues_desc"],
						type = 'toggle',
						width = "full",
						order = 11.25,
					},
					--[[
					mapcoords = {
						name = L["opt_mapcoords"],
						desc = L["opt_mapcoords_desc"],
						type = 'toggle',
						set = function(i,v) Setter_Simple(i,v)  self.MapCoords:HandleWorldmapCoords() end,
						width = "full",
						order = 10.23,
					},
					--]]
				}
			},
			foglightdebug = {
				name = "(Debug) Check foglight",
				desc = "Check foglighting for the current map",
				type = 'execute',
				func = function() ZGV.Foglight:DebugMap() end,
				order = 99,
				hidden = function() return not self.db.profile.debug end
			},
		}
	}
	
	--[[
	self.optionsdata = {
		name = L["opt_group_data"],
		desc = L["opt_group_data_desc"],
		type = 'group',
		order = 1,
		--hidden = true,
		handler = self,
		args = {
			desc = {
				order = 1,
				type = "description",
				name = L["opt_group_data_desc"],
			},
			guide = {
				name = L["opt_group_data_guide"],
				desc = L["opt_group_data_guide_desc"],
				type = 'select',
				values = function() if not self.db.global.storedguides then return {} end  local k,v  local t={}  for k,v in pairs(self.db.global.storedguides) do t[k]=k end  return t  end,
				width = 'full',
				get = "GetFocusGuide",
				set = "SetFocusGuide",
				order = 2,
			},
			delguide = {
				name = L["opt_group_data_del"],
				desc = L["opt_group_data_del_desc"],
				type = 'execute',
				disabled = function() return not (self.db.global.storedguides and self.focusedguidename and self.db.global.storedguides[self.focusedguidename]) end,
				func = "DeleteGuide",
				order = 3,
			},
			editguide = {
				name = L["opt_group_data_edit"],
				desc = L["opt_group_data_edit_desc"],
				type = 'execute',
				disabled = function() return not (self.db.global.storedguides and self.focusedguidename and self.db.global.storedguides[self.focusedguidename]) end,
				func = "EditGuide",
				order = 4,
			},
			entry = {
				name = L["opt_group_data_entry"],
				desc = L["opt_group_data_entry_desc"],
				type = 'input',
				multiline = 15,
				width = 'full',
				get = "GetGuideText",
				set = "SetGuideText",
				order = 5,
			},
		}
	}
	--]]
	
	self.optionsdebug = {
		name = L["opt_debugging"],
		hidden = function() return not self.db.profile.debug end,
		desc = L["opt_debugging_desc"],
		type = 'group',
		order=-9,
		handler = self,
		get = Getter_Simple,
		set = Setter_Simple,
		args = {
			fakelevel = {
				name = "Fake level (0=disable)",
				type = 'range',
				min = 0,
				max = 85,
				step = 0.2,
				bigStep = 0.2,
				get = function(i,v) return self.db.char[i[#i]] end,
				set = function(i,v) self.db.char[i[#i]]=v end,
				width="full",
				order = 1
			},
			fakecombat = {
				name = "Fake combat",
				desc = "Check to simulate combat mode, for testing of 'delay after combat' and similar situations.",
				type = 'toggle',
				set = function(i,v) Setter_Simple(i,v)  if (v and not UnitAffectingCombat("player")) or (not v and UnitAffectingCombat("player")) then self:PLAYER_REGEN_DISABLED() else self:PLAYER_REGEN_ENABLED() end  end,
				order=2,
			},
		},
	}
	
end

function me:Options_SetupConfig()
	local AceConfig = LibStub("AceConfig-3.0")

	AceConfig:RegisterOptionsTable("ZygorGuidesViewer", self.options, ZYGORGUIDESVIEWER_COMMAND );
	AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Display", self.optionsdisplay, "zgdisplay");
	AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Step", self.optionsstep, "zgstep");
	AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Progress", self.optionsprogress, "zgprogress");
	AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Map", self.optionsmap, "zgmap");
	--AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Gold", self.optionsgold, "zggold");
	AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Conv", self.optionsconv, "zgconv");
	AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Debug", self.optionsdebug, "zgdebug");
	--AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Data", self.optionsdata, "--[[#$$#]]");
	AceConfig:RegisterOptionsTable("ZygorGuidesViewer-Profile", self.optionsprofile, "zgprofile");
end

function me:Options_SetupBlizConfig()
	local AceConfigDialog = LibStub("AceConfigDialog-3.0")

	InterfaceOptionsFrame:GetRegions():SetTexture(0,0,0,0.9)
	AceConfigDialog:SetDefaultSize("ZygorGuidesViewer", 600, 400)
	self.optionpanels = {}
	self.optionpanels[''] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer", self.options.name)
	self.optionpanels['display'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Display", self.optionsdisplay.name, self.options.name)
	self.optionpanels['step'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Step", self.optionsstep.name, self.options.name)
	self.optionpanels['progress'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Progress", self.optionsprogress.name, self.options.name);
	self.optionpanels['map'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Map", self.optionsmap.name, self.options.name)
	--self.optionpanels['gold'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Gold", self.optionsgold.name, self.options.name)
	self.optionpanels['conv'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Conv", self.optionsconv.name, self.options.name)
	if (self.db.profile.debug) then
		self.optionpanels['debug'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Debug", self.optionsdebug.name, self.options.name)
	end
	--LibStub("AceConfigDialog-3.0"):AddToBlizOptions("ZygorGuidesViewer-Data", self.optionsdata.name, self.options.name)
	self.optionpanels['profile'] = AceConfigDialog:AddToBlizOptions("ZygorGuidesViewer-Profile", self.optionsprofile.name, self.options.name)

	self.db.profile.skipauxsteps = true
end




--function me:CycleWindowModes()
--end


--[[
-- made obsolete ages ago
function me:IsColorBorder()
	return self.db.profile.colorborder
end
function me:ToggleColorBorder()
	self.db.profile.colorborder = not self.db.profile.colorborder
	self:UpdateFrame()
end
--]]



function me:GetIconScale()
	return self.db.profile.iconScale
end
function me:SetIconScale(info,value)
	self.db.profile.iconScale = value
	if not self:IsWaypointAddonEnabled("cart2") then return end
	Cartographer_Notes:MINIMAP_UPDATE_ZOOM()
	Cartographer_Notes:UpdateMinimapIcons()
end

function me:GetIconAlpha()
	return self.db.profile.iconAlpha
end
function me:SetIconAlpha(info,value)
	self.db.profile.iconAlpha = value
	if not self:IsWaypointAddonEnabled("cart2") then return end
	Cartographer_Notes:MINIMAP_UPDATE_ZOOM()
	Cartographer_Notes:UpdateMinimapIcons()
end

function me:IsShowingMinimapIcons()
	return self.db.profile.minicons
end
function me:ToggleShowingMinimapIcons()
	self.db.profile.minicons = not self.db.profile.minicons
	self:SetWaypoint()
	if not self:IsWaypointAddonEnabled("cart2") then return end
	Cartographer_Notes:MINIMAP_UPDATE_ZOOM()
	Cartographer_Notes:UpdateMinimapIcons()
end

--[[
function me:IsShowingMapIcons()
	return self.db.profile.mapicons
end
function me:ToggleShowingMapIcons()
	self.db.profile.mapicons = not self.db.profile.mapicons
end

function me:GetFocusGuide(info)
	return self.focusedguidename
end

function me:SetFocusGuide(info,value)
	self.focusedguidename = value
end

function me:EditGuide(info)
	if self.db.global.storedguides and self.db.global.storedguides[self.focusedguidename] then
		self.focusedguideediting = 1
	else
		self:Print("'"..self.focusedguidename.."' is not a stored guide.")
	end
end

function me:DeleteGuide(info)
	self:UnregisterGuide(self.focusedguidename)
	self.focusedguidename = nil
end

function me:GetGuideText()
	if self.focusedguideediting and self.db.global.storedguides[self.focusedguidename] then
		self.focusedguideediting = 0
		return "guide "..self.focusedguidename.."\n"..self.db.global.storedguides[self.focusedguidename].."\nend\n"
	else
		return ""
	end
end

function me:SetGuideText(info,value)
	local stored=0
	for title,data in value:gmatch("guide (.-)\n(.-)\nend\n?") do
		self:RegisterGuide(title,data,{is_stored=true})
		self:SetGuide(title)
		stored=true
	end
	if not stored then
		self:Print("No guides were recognized; remember to wrap your stored guides properly, like:|nguide Guide Title goes here|n  steps...|nend")
	end
	self:UpdateFrame()
end
--]]

function me:GetCurrentGuideNum()
	if not self.CurrentGuide then return nil end
	for i,data in ipairs(ZygorGuidesViewer.registeredguides) do
		if data.title==self.CurrentGuide.title then return i end
	end
end



function me:OpenOptions(v)
	--self:OpenConfigMenu()
	InterfaceOptionsFrame_OpenToCategory(self.optionpanels[v or ''])
end


function me:SetOption(cat,cmd)
	LibStub("AceConfigCmd-3.0").HandleCommand(self, "zygor", "ZygorGuidesViewer"..(cat~="" and "-"..cat or ""), cmd)
end
