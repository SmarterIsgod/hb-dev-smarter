assert(ZygorTalentAdvisor,"Zygor Talent Advisor failed to load.")
local name,_=...
ZygorTalentAdvisor.revision = tonumber(string.sub("$Revision: 2105 $", 12, -3))
ZygorTalentAdvisor.version = GetAddOnMetadata(name,"version") .. "." .. ZygorTalentAdvisor.revision
ZygorTalentAdvisor.date = string.sub("$Date: 2011-05-04 16:02:05 -0500 (Wed, 04 May 2011) $", 8, 17)
--2011/03/24 15:11:40.92473.7729.97000
  