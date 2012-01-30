local ZGV=ZygorGuidesViewer
assert(ZGV)

function ZygorGuidesViewerFrameMaster_OnUpdate(self,elapsed)
	if ZGV.loading and ZGV.db and ZGV.db.char.maint_startguides then
		ZGV.master_forceupdate=nil
		local st=GetTime()
		repeat
			ZGV:StartupStep()
			if not ZGV.loading then break end
		until GetTime()-st>0.05  or ZGV.master_forceupdate
		ZGV:UpdateFrame(true)
	end
end
