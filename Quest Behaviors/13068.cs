<!--
/*
* Quest Behavior Name: StationaryCannonFireDynamic
* QuestID: 13086
* Purpose: Fire a cannon at multiple npcs using 2 buttons
* Variables: 
*  MobId: MobId1="30575" MobId2="30593"
*  QuestId: 13086
*  VehicleId: 30236 (while outside and inside of vehicle)
*  Range: 50 for button 2, 50 for button 1
*  TargetLocation: dynamic - hotspot xyz
<Hotspot X="6086.82" Y="64.65286" Z="372.287" />
<Hotspot X="6134.414" Y="141.6585" Z="370.9435" />
<Hotspot X="6218.427" Y="142.7927" Z="378.7379" />
<Hotspot X="6293.809" Y="138.8607" Z="387.0916" />
<Hotspot X="6340.031" Y="104.4044" Z="391.1608" />
<Hotspot X="6335.647" Y="39.72147" Z="389.0946" />



*  VehicleLocation: 4 turrets - if you get kicked from your current one, move to next in line - if avail, mount it... if not, proceed to next (logic)
<Hotspot X="6256.144" Y="91.78842" Z="410.8367" />
<Hotspot X="6297.239" Y="53.59477" Z="410.778" />
<Hotspot X="6218.974" Y="59.17393" Z="400.2893" />
<Hotspot X="6162.534" Y="60.20402" Z="400.1804" />

*  KillCount: obj2 - kill 3 drakes (30575); obj1 - kill 100 spiders (30593)
* Extra-Variables:
*  dunno?
* 
* Description: #DESC# (If Not In Vehicle, Go to VehicleLocation, Enter Vehicle, move turret to npc location and shoot #1 10 times, then #2; if npc is not dead of course.  if it is, move turrent point to new npc(s)
* Face() Target, Use VehicleButton1 x10 (gcd 1000ms), VehicleButton2 (GCD 1000ms - but requires vehicle to have 1000 mana - which is 5 button pushes for #1 button), Cooldown: (GCD, 10sec, etc). Do Until KillCount.
*/		
-->
