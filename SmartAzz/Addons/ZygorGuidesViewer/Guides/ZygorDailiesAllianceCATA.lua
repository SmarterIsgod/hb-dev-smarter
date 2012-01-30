local ZygorGuidesViewer=ZygorGuidesViewer
if not ZygorGuidesViewer then return end
if UnitFactionGroup("player")~="Alliance" then return end
if ZygorGuidesViewer.guidesets.DailiesAllianceCata then return end
ZygorGuidesViewer.guidesets.DailiesAllianceCata=true



ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Deepholm\\Deepholm Pre-Quests",[[
	description Contains the pre-quests to unlock 
	description the daily quests in Deepholm.
	description 
	description You must be at least level 82 to
	description complete this guide section.
	author support@zygorguides.com
	step //1
		goto Stormwind City,62.9,71.6
		.' Click the Hero's Call Board |tip It's a big white stone hanging board with a gold lion head on it.
		..accept 27727
	step //2
		goto 74.5,19.0
		.talk 45226
		..turnin 27727
		..accept 27203
	step //3
		goto 74.5,18.4
		.' Click the Portal to the Maelstrom |tip It looks like a swirling green portal.
		.' Teleport to The Maelstrom |goto The Maelstrom |noway |c
	step //4
		goto The Maelstrom,33.4,50.2
		.talk 45042
		..turnin 27203
		..accept 27123
	step //5
		goto 32.5,52.0
		.' Click the Wyvern |tip It looks like a wind rider flying in place.
		.' You will fly into Deepholm |goto Deepholm,49.9,54.7,0.5 |noway |c
	step //6
		goto Deepholm,49.6,53.0
		.talk 43065
		..turnin 27123
		..accept 26245
	step //7
		goto 49.7,52.9
		.talk 43397
		..accept 27136
		..accept 26244
	step //8
		goto 49.5,53.3
		.talk 42573
		..accept 26409
	step //9
		goto 49.2,51.9
		.talk 45300
		.home Temple of Earth
	step //10
		goto 46.5,57.3
		.talk 42574
		..turnin 26409
		..accept 26410
		..accept 27135
	step //11
		goto 45.5,57.9
		.from Rockslice Flayer##42606+
		.get 5 Quartzite Resin |q 26410/1
		.' You can find more Rockslice Flayers around 42.5,55.6
	step //12
		goto 46.5,57.3
		.talk 42574
		..turnin 26410
	step //13
		goto 51.1,61.6
		.' Use your Depleted Totem |use Depleted Totem##60835
		.from Lodestone Elemental##43258+, Energized Geode##43254+ |tip Kill them next to your Depleted Totems.
		.' Energize the Totem 8 Times |q 27136/1
	step //14
		goto 52.0,58.9
		.' Use Goldmine's Fire Totem in the red lava spot |use Goldmines's Fire Totem##60834
		.from Magmatooth##45099
		.get The Burning Heart |q 27135/1
	step //15
		goto 49.7,52.9
		.talk 43397
		..turnin 27136
	step //16
		goto 46.5,57.3
		.talk 42574
		..turnin 27135
		..accept 26411
	step //17
		goto 46.6,57.2
		.' Use your Explosive Bonding Compound on Flint Oremantle |use Explosive Bonding Compound##58502 |tip He's laying on the ground next to Initiate Goldmine.
		.' Apply the Explosive Bonding Compound |q 26411/1
	step //18
		goto 46.5,57.3
		.talk 42574
		..turnin 26411
		..accept 26413
	step //19
		goto 49.5,53.3
		.' Introduce Flint Oremantle to Earthcaller Yevaa |q 26413/1
	step //20
		goto 49.5,53.3
		.talk 42573
		..turnin 26413
		..accept 26484
	step //21
		goto 56.1,74.2
		.' Click the Slain Cannoneer |tip It looks like a dead orc on the deck of the crashed zeppelin, laying next to a pile of cannon balls and a cannon.
		.' Receive the Second Clue |q 26245/2
	step //22
		goto 53.5,73.8
		.' Click Captain Skullshatter |tip He's a dead orc laying on the ground next to a small round table in a side room on the deck of the crashed zeppelin.
		.' Receive the First Clue |q 26245/1
	step //23
		goto 53.6,73.8
		.' Click the Captain's Log |tip It's a gray book laying on the small round table next to Captain Skullshatter.
		..accept 26246
	step //24
		goto 56.7,76.4
		.' Click the Unexploded Artillery Shell |tip It looks like a metal casing, or bullet type of object laying on the ground underneath the crashed zeppelin.  You can get to it by flying in the 3 open side doors on the north side of the crashed zeppelin.
		.' Receive the Third Clue |q 26245/3
	step //25
		goto 55.9,74.9
		.kill 5 Deepstone Elemental |q 26244/1
	step //26
		goto 49.6,52.9
		.talk 43065
		..turnin 26245
		..turnin 26246
	step //27
		goto 49.7,52.9
		.talk 43397
		..turnin 26244
	step //28
		goto 49.6,53.0
		.talk 43065
		..accept 26247
	step //29
		goto 62.4,52.6
		.talk 42684
		..turnin 26247
		..accept 26248
		..accept 26249
	step //30
		'All around on this air ship:
		.' Use your Spirit Totem on Slain Crew Members |use Spirit Totem##58167 |tip They look like dead Alliance soldiers all over this airship.
		.' Receive 6 Slain Crew Member Information |q 26248/1
	step //31
		'Enter the doorway on the main deck of the air ship:
		.talk 43082
		..turnin 26249
		..accept 26427
	step //32
		'Leave through the doorway and immediately turn right:
		.' Click the Bottle of Whiskey |tip It's a yellow bottle sitting on the edge of a small life boat on the side of the airship.
		.get Bottle of Whiskey |q 26427/1
	step //33
		'All around on the deck of the air ship:
		.' Click a Spool of Rope |tip They are coiled up ropes laying all around on the deck of the airship.
		.get Spool of Rope |q 26427/2
	step //34
		'Enter the doorway on the main deck of the air ship:
		.talk 43082
		..turnin 26427
	step //35
		'Go to the very top of the air ship:
		.talk 42684
		..turnin 26248
		..accept 26251
		..accept 26250
	step //36
		'Go onto the main deck of the ship and go down the stairs to the deck below:
		.' Fight Mor'norokk the Hateful until he surrenders |tip He's downstairs in the airship, in the very back of the first level you come to.
		.talk 42801
		.' Subdue Mor'norokk the Hateful |q 26250/1
	step //37
		'All around on this lower deck of the air ship:
		.kill 6 Twilight Saboteur |q 26251/1
	step //38
		'Go to the very top of the air ship:
		.talk 42684
		..turnin 26251
		..turnin 26250
		..accept 26254
	step //39
		Next to Stormcaller Mylra:
		.' Click Stormbeak |tip It's a gryphon flying in place next to the air ship.
		.' Interrogate Mok'norrok |q 26254/1
	step //40
		'When you land on the air ship again:
		.talk 42684
		..turnin 26254
		..accept 26255
	step //41
		'Hearth to Temple of Earth |goto 49.2,51.9,0.5 |use Hearthstone##6948 |noway |c
	step //42
		goto 49.6,53.0
		.talk 43065
		..turnin 26255
		..accept 26258
	step //43
		goto 49.7,52.9
		.talk 43397
		..accept 26259
	step //44
		goto 59.4,58.2
		.' Go to this spot
		.' Reach Deathwing's Fall |q 26258/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 26258
		..accept 26256
	step //45
		goto 61.5,60.6
		.from Twilight Bloodshaper##43218+
		.get Twilight Orders |q 26256/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 26256
		..accept 26261
	step //46
		goto 62.8,59.5
		.' Click the Slavemaster's Coffer |tip It looks like a small wooden chest on the ground inside a red tent.
		.collect Twilight Slaver's Key##60739 |q 26261
	step //47
		goto 61.2,60.1
		.from Living Blood##43123+
		.get 5 Blood of Neltharion |q 26259/1
	step //48
		goto 64.5,65.5
		.' Click Ball and Chains |tip They are attached to the feet of the Enslaved Miners around this area.
		.' Free 6 Enslaved Miners |q 26261/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 26261
		..accept 26260
	step //49
		goto 63.7,55.4
		.' Click the Forgemaster's Log |tip It's a blue-ish book laying on the floor at the very top of this tower.
		..turnin 26260
		..accept 27007
	step //50
		goto 70.6,61.2
		.' Go to this spot
		.' Reach Upper Silvermarsh |q 27007/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27007
		..accept 27010
	step //51
		goto 71.8,64.3
		.' Click the Trogg Crate |tip It's a brown box sitting next to the water.
		.collect Trogg Crate##60809 |q 27010
		.from Murkstone Trogg##44936
		.collect Maziel's Research##60816 |n
		.' Click Maziel's Research in your bags |use Maziel's Research##60816
		..accept 27100
	step //52
		goto 74.9,64.8
		.' Use your Trogg Crate in the water and swim to this spot |use Trogg Crate##60809
		.' Watch the dialogue
		.' Uncover the World Pillar Fragment Clue |q 27010/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27010
		..accept 27061
	step //53
		goto 72.5,65.2
		.from Mercurial Ooze##43158+
		.get 4 Twilight Research Notes |q 27100/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27100
		..accept 27101
	step //54
		goto 67.2,70.2
		.' Click Maziel's Journal |tip It looks like a small black book laying on the ground on this tiny island in a pond, next to a big rock.
		..turnin 27101
		..accept 27102
	step //55
		goto 69.5,68.0 |n
		.' Enter the cave |goto 69.5,68.0,0.5 |noway |c
	step //56
		goto 72.8,62.0
		.kill Maziel |q 27102/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27102
	step //57
		goto 69.5,68.0 |n
		.' Leave the cave |goto 69.5,68.0,0.5 |noway |c	
	step //58
		goto 64.5,82.1
		.talk 44010
		..turnin 27061
		..accept 26766
		..accept 26768
	step //59
		goto 68.2,77.9
		.from Scalesworn Cultist##44221+
		.get Twilight Snare |q 26768/1
	step //60
		goto 64.5,82.1
		.talk 44010
		..turnin 26768
	step //61
		goto 59.9,83.6
		.from Jadecrest Basilisk##43981+
		.' Use Mylra's Knife on Jadefire Basilisk corpses |use Mylra's Knife##60382
		.get 5 Side of Basilisk Meat |q 26766/1 
	step //62
		goto 64.5,82.1
		.talk 44010
		..turnin 26766
		..accept 26771
	step //63
		goto 50.9,85.3
		.' Use your Trapped Basilisk Meat |use Trapped Basilisk Meat##60773
		.kill Stonescale Matriarch |q 26771/1
	step //64
		goto 64.5,82.1
		.talk 44010
		..turnin 26771
		..accept 26857
	step //65
		goto 64.6,82.2
		.talk 44222
		..accept 26861
	step //66
		goto 68.7,75.0
		.' Use your Stormstone next to the swirling blue portal |use Stormstone##60501
		.' Disrupt the Twilight Gate |q 26861/1
	step //67
		goto 71.2,75.1
		.' Use your Stormstone next to the structure with the floating yellow crystal |use Stormstone##60501
		.' Disrupt the Elemental Gate |q 26861/2
	step //68
		goto 69.9,76.7
		.from Scalesworn Cultist##44221+, Twilight Scalesister##43967+, Twilight Dragonspawn##43966+
		.' Defeat 8 Abyssion's Underlings |q 26857/1
	step //69
		goto 64.6,82.2
		.talk 44222
		..turnin 26861
	step //70
		goto 64.5,82.2
		.talk 44010
		..turnin 26857
		..accept 26876
	step //71
		goto 69.9,76.9
		.' Use your Earthen Ring Banner |use Earthen Ring Banner##60810
		.from Abyssion##
		.' Click The First Fragment of the World Pillar |tip It's a floating green rock that appears after you kill Abyssion.
		.get The Upper World Pillar Fragment |q 26876/1
	step //72
		'Hearth to Temple of Earth |goto 49.2,51.9,0.5 |use Hearthstone##6948 |noway |c
	step //73
		goto 49.6,53.0
		.talk 43065
		..turnin 26876
	step //74
		goto 49.7,52.9
		.talk 43397
		..turnin 26259
	step //75
		goto 27.9,68.7
		.talk 43071
		..turnin 26484
		..accept 27931
	step //76
		goto 30.6,77.7
		.talk 47195
		..turnin 27931
		..accept 27932
		..accept 27933
	step //77
		goto 32.2,79.1
		.' Use The Axe of Earthly Sundering on Emerald Colossi |use The Ace of Earthly Sundering##60490 |tip They look like glowing giants that walk around this area.
		.kill 5 Sundered Emerald Colossus |q 27932/1 
		.from Jade Rager##44220+
		.get 6 Elemental Ore |q 27933/1
	step //78
		goto 30.6,77.7
		.talk 47195
		..turnin 27932
		..turnin 27933
		..accept 27934
	step //79
		goto 30.6,77.7
		.talk 47195
		..' Tell him you are ready for the ritual
		.' Complete the One With the Ground Ritual |q 27934/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27934
		..accept 27935
	step //80
		goto 46.9,89.1
		.kill Avalanchion |q 27935/1
	step //81
		goto 43.4,82.0 |n
		.' Leave the cave |goto 43.4,82.0,0.5 |noway |c
	step //82
		goto 27.9,68.7
		.talk 43071
		..turnin 27935
		..accept 26499
	step //83
		goto 28.2,69.6
		.talk 43160
		..accept 26500
	step //84
		goto 29.7,68.8
		kill 12 Stone Trogg Ambusher |q 26500/1
		.' Use Stonefather's Banner next to Stone Hearth Defenders |use Stonefather's Banner##58884 |tip They look like dwarves.  Stonefather's Banner won't work on the Stone Hearth Defenders if they already have the Stonefather's Boon buff.
		.' Grant the Stonefather's Boon 12 times |q 26499/1
	step //85
		goto 28.2,69.6
		.talk 43160
		..turnin 26500
		..accept 26502
	step //86
		goto 27.9,68.7
		.talk 43071
		..turnin 26499
		..accept 26501
	step //87
		goto 27.3,67.8
		.' Use your Rockslide Reagent on the Earthen Geomancer |use Rockslide Reagent##58885 |tip They must be out of combat for it to work, so kill any troggs attacking the Earthen Geomancer.
		.' Seal the Shrine |q 26501/4
	step //88
		goto 26.0,68.8
		.' Use your Rockslide Reagent on the Earthen Geomancer |use Rockslide Reagent##58885 |tip They must be out of combat for it to work, so kill any troggs attacking the Earthen Geomancer.
		.' Seal the Barracks |q 26501/3
	step //89
		goto 26.2,69.8
		.' Use your Rockslide Reagent on the Earthen Geomancer |use Rockslide Reagent##58885 |tip They must be out of combat for it to work, so kill any troggs attacking the Earthen Geomancer.
		.' Seal the Inn |q 26501/2
	step //90
		goto 27.3,70.1
		.' Use your Rockslide Reagent on the Earthen Geomancer |use Rockslide Reagent##58885 |tip They must be out of combat for it to work, so kill any troggs attacking the Earthen Geomancer.
		.' Seal the Armory |q 26501/1
		.' Click Thunder Stones |tip They looks like blue round spiked cannonballs on the ground and in wagons around this area.
		.get 12 Thunder Stone |q 26502/1 
	step //91
		goto 24.5,62.4
		.talk 43168
		..turnin 26501
		..accept 26537
	step //92
		goto 24.8,62.2
		.talk 43169
		..turnin 26502
		..accept 26564
	step //93
		goto 24.6,62.2
		.talk 43319
		..accept 26591
	step //94
		goto 23.9,60.3
		.' Use Deepvein's Patch Kit on Injured Earthens |use Deepvein's Patch Kit##58965 |tip They look like dwarves laying on the ground around this area.
		.' Patch up 10 Injured Earthen |q 26591/1
		.' Click Catapult Parts |tip They look kind of like big metal parts laying on the ground around this area.
		.get 6 Catapult Part |q 26564/1 
		.from Stone Trogg Berserker##43228+, Stone Trogg Geomancer##43234+, Needlerock Rider##43250+
		.kill 12 Fractured Battlefront stone troggs |q 26537/1
		.' You can also look around 23.1,53.9 for more
	step //95
		goto 24.5,62.4
		.talk 43168
		..turnin 26537
	step //96
		goto 24.6,62.2
		.talk 43319
		..turnin 26591
	step //97
		goto 24.8,62.2
		.talk 43169
		..turnin 26564
	step //98
		goto 24.5,62.4
		.talk 43168
		..accept 26625
	step //99
		goto 22.6,56.9
		.from Troggzor the Earthinator##43456
		.get The Earthinator's Cudgel |q 26625/1 
	step //100
		goto 24.5,62.4
		.talk 43168
		..turnin 26625
	step //101
		goto 24.8,62.2
		.talk 43169
		..accept 27126
	step //102
		goto 20.7,61.6
		.talk 45043
		..turnin 27126
		..accept 26632
	step //103
		goto 20.7,61.6
		.talk 45043
		..' Tell him you're ready to escort the catapult
		.' Safely Escort the Earthen Catapult |q 26632/1
	step //104
		goto 22.7,52.0
		.talk 43897
		..turnin 26632
		..accept 26755
	step //105
		goto 22.4,52.0
		.' Click an Earthen Catapult |tip They look like wooden launchers with stone wheels.
		.' Use your Fire Catapult ability on your hotbar on the Stone Trogg and Fungal mobs
		.' Bombarb 30 Reinforcements |q 26755/1
	step //106
		goto 22.7,52.0
		.talk 43897
		..turnin 26755
		..accept 26762
	step //107
		goto 22.8,52.1
		.talk 43898
		..accept 26770
	step //108
		goto 22.6,47.6
		.' Click Deactivated War Construct |tip They look like metal golems around this area.
		.' Reactivate 5 Deactivated War Constructs |q 26762/1
		.kill 5 Needlerock Mystic |q 26770/1
	step //109
		goto 22.8,52.1
		.talk 43898
		..turnin 26770
	step //110
		goto 22.7,52.0
		.talk 43897
		..turnin 26762
		..accept 26834
	step //111
		goto 27.6,44.8
		.talk 44143
		..turnin 26834
		..accept 26791
		..accept 26792
	step //112
		goto 27.6,44.7
		.' Click the War Guardian |tip It looks like a metal golem.
		.' Obtain a War Guardian for the Sprout No More quest |q 26791/1
		.' Obtain a War Guardian for the Fungal Monstrosities quest |q 26792/1
	step //113
		goto 26.8,41.8
		.kill 5 Fungal Monstronsity |q 26792/2
		.' Click Giant Mushrooms |tip They look like huge mushrooms with orange caps around this area.
		.' Destroy 5 Giant Mushrooms |q 26791/2
	step //114
		goto 27.6,44.8
		.talk 44143
		..turnin 26791
		..turnin 26792
		..accept 26835
	step //115
		goto 22.7,52.0
		.talk 43897
		..turnin 26835
		..accept 26836
	step //116
		goto 24.5,31.1
		.from Bouldergut##44151
		.' Rescue Stonefather Oremantle |q 26836/1
	step //117
		goto 22.7,52.0
		.talk 43897
		..turnin 26836
		..accept 27937
	step //118
		goto 28.0,68.6
		.talk 44204
		..turnin 27937
		..accept 27938
	step //119
		goto 28.0,68.7
		.' Click The Stonefather's Safe |tip It looks like a metal vault door with gold circles and symbols on it.
		.get The Middle Fragment of the World Pillar |q 27938/1
	step //120
		'Hearth to Temple of Earth |goto 49.2,51.9,0.5 |use Hearthstone##6948 |noway |c
	step //121
		goto 49.5,53.3
		.talk 42573
		..turnin 27938
	step //122
		goto 49.6,53.0
		.talk 43065
		..accept 26326
	step //123
		goto 46.1,45.6
		.talk 42730
		..turnin 26326
		..accept 26312
		..accept 26314
	step //124
		goto 46.2,45.7
		.talk 42731
		..accept 26313
	step //125
		goto 44.3,43.7
		.from Irestone Rumbler##42780+
		.' Use your Elementium Grapple Line on Servants of Therazane |use Elementium Grapple Line##58169 |tip Run away from the Servants of Therazane to bring them down.
		.' Relieve Stormcaller Mylra |q 26312/2
	step //126
		goto 44.5,41.3
		.from Irestone Rumbler##42780+
		.' Use your Elementium Grapple Line on Servants of Therazane |use Elementium Grapple Line##58169 |tip Run away from the Servants of Therazane to bring them down.
		.' Relieve Tawn Winterbluff |q 26312/1
	step //127
		goto 47.6,42.8
		.from Irestone Rumbler##42780+
		.' Use your Elementium Grapple Line on Servants of Therazane |use Elementium Grapple Line##58169 |tip Run away from the Servants of Therazane to bring them down.
		.' Relieve Hargoth Dimblaze |q 26312/3
	step //128
		goto 46.2,42.2
		.from Irestone Rumbler##42780+
		.get 6 Irestone Core |q 26313/1
		.' Use your Elementium Grapple Line on Servants of Therazane |use Elementium Grapple Line##58169 |tip Run away from the Servants of Therazane to bring them down.
		.' Bring down 3 Servants of Therazane |q 26314/1
	step //129
		goto 46.2,45.7
		.talk 42731
		..turnin 26313
	step //130
		goto 46.1,45.6
		.talk 42730
		..turnin 26312
		..turnin 26314
	step //131
		goto 46.2,45.7
		.talk 42731
		..accept 26315
	step //132
		goto 49.2,40.1
		.' Use your Earthen Ring Proclamation on Boden the Imposing |use Earthen Ring Proclamation##58177 |tip He's a huge rock giant that walks around this area.
		.' Seek Peace with Boden the Imposing |q 26315/1
	step //133
		goto 46.2,45.7
		.talk 42731
		..turnin 26315
		..accept 26328
	step //134
		goto 56.5,42.7
		.talk 42467
		..turnin 26328
		..accept 26376
		..accept 26377
	step //135
		goto 56.5,41.0
		.talk 42899
		..accept 26375
	step //136
		goto 60.2,39.4
		.kill Dragul Giantbutcher |q 26376/1
	step //137
		goto 59.5,41.5
		.' Click Jade Crystal Clusters |tip They look like green glowing rocks sitting on the ground all around this area.
		.collect 6 Jade Crystal Cluster##58500 |q 26377
		.' Use your Delicate Chain Smasher next to Quartz Rocklings |use Delicate Chain Smasher##58254 |tip They look like small rock giants around this area.
		.' Release 6 Quartz Rocklings |q 26375/1
	step //138
		'Use the Jade Crystal Clusters |use Jade Crystal Cluster##58500
		.collect Jade Crystal Composite##58783 |q 26377
	step //139
		goto 59.6,41.4
		.' Use your Jade Crystal Composite |use Jade Crystal Composite##58783
		.' Lure an Agitated Tunneler |q 26377/1
	step //140
		goto 59.3,40.6
		.from Twilight Laborer##42924+, Twilight Priestess##42823+, Twilight Duskwarden##42917+
		.kill 12 Lorthuna's Gate Cultists |q 26376/2 
	step //141
		goto 56.5,41.0
		.talk 42899
		..turnin 26375
	step //142
		goto 56.5,42.7
		.talk 42467
		..turnin 26376
		..turnin 26377
		..accept 26426
	step //143
		goto 51.7,31.6
		.' Get next to Felsen the Enduring |tip He's a big white rock giant.
		.' Find Felsen the Enduring |q 26426/1
	step //144
		goto 58.4,25.7
		.' Fly to the mouth of this cave
		.' Find the entrance to the Crumbling Depths |q 26426/2
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 26426
		..accept 26869
	step //145
		goto 64.5,21.7 |n
		.' Follow the path |goto 64.5,21.7,0.5 |noway |c
	step //146
		goto 65.3,18.4 |n
		.' Follow the path |goto 65.3,18.4,0.5 |noway |c
	step //147
		goto 66.4,20.6
		.' Click the Gigantic Painite Cluster |tip It looks like a green crystal cluster near the mouth of the cave.
		..turnin 26869
		..accept 26871
	step //148
		goto 64.3,23.5
		.' Follow the path to this spot, then jump down |goto 64.3,23.5,0.5 |noway |c
	step //149
		goto 58.3,25.5 |n
		.' Leave the cave |goto 58.3,25.5,0.5 |noway |c
	step //150
		goto 56.5,42.7
		.talk 42467
		..turnin 26871
		..accept 26436
	step //151
		goto 34.3,34.3
		.talk 42469
		..turnin 26436
		..accept 26438
		..accept 26437
	step //152
		goto 34.1,35.2
		.talk 43344
		..accept 26439
	step //153
		goto 30.5,46.8
		.from Jaspertip Borer##42524+, Jaspertip Swarmer##42521+, Jaspertip Ravager##42525+, Jaspertip Crystal-gorger##43171+
		.kill 12 Jaspertip flayers |q 26438/1
		.' Click Chalky Crystal Formations |tip They look like big white blocks on the ground around this area.
		.get 8 Chalky Crystal Formation |q 26437/1 
		.' Click Dormant Stonebound Elementals |tip They look like crumbled rock elementals on the ground around this area.
		.' Reform 6 Stonebound Elementals |q 26439/1
	step //154
		goto 34.3,34.3
		.talk 42469
		..turnin 26438
		..turnin 26437
	step //155
		goto 34.1,35.2
		.talk 43344
		..turnin 26439
	step //156
		goto 34.4,34.4
		.talk 42469
		..accept 28869
	step //157
		'Next to you:
		.talk 43116
		..turnin 28869
		..accept 26440
	step //158
		goto 30.1,47.7
		.' Get next to the huge green crystals
		.' Bring Pebble to the crystal formation |q 26440/1
	step //159
		'Next to you:
		.talk 43116
		..turnin 26440
		..accept 26441
	step //160
		goto 34.3,34.3
		.talk 42469
		..turnin 26441
		..accept 26507
		..accept 26575
	step //161
		goto 47.6,26.8
		.kill Gorgonite |q 26575/1
	step //162
		goto 47.5,26.8
		.' Click Petrified Stone Bats |tip They looks like black stone bats laying on the ground around this area.
		.get 12 Petrified Stone Bat |q 26507/1
	step //163
		'Next to you:
		.talk 43116
		..turnin 26507
	step //164
		goto 34.3,34.3
		.talk 42469
		..turnin 26575
		..accept 26576
		..accept 26577
	step //165
		goto 39.9,19.4
		.talk 42466
		..turnin 26576
		..accept 26656
	step //166
		goto 39.9,19.4
		.talk 42466
		..' Tell him you are ready to escort a group of elementals across the open.
		.' Speak to Terrath the Steady |q 26656/1
	step //167
		goto 51.1,14.7
		.' Go to this spot
		.' Escort 5 Opalescent Guardians to safety |q 26656/2 |tip Run on the ground with your mount, don't fly or you the rock elementals will disappear when you get too far away from them.
	step //168
		goto 39.9,19.4
		.talk 42466
		..turnin 26656
		..accept 26657
		..accept 26658
	step //169
		goto 35.4,22.5
		.from Stone Trogg Beast Tamer##43598 |tip He moves all around this area capturing basilisks, so you may need to look around a bit for him.
		.get Stonework Mallet |q 26658/1
	step //170
		goto 36.5,18.8
		.kill 6 Stone Drake |q 26657/1 |tip They will fall to the ground with half health, so you can kill them, even though they are elite.
	step //171
		goto 40.0,19.4
		.talk 42466
		..turnin 26657
		..turnin 26658
		..accept 26659
	step //172
		goto 32.7,24.3
		.' Use your Stonework Mallet next to the Pale Resonating Crystal |use Stonework Mallet##60266 |tip It's a huge green crystal sitting on the ground.
		.' Strike the Pale Resonating Crystal |q 26659/1
		.from Aeosera##43641 |tip Click the Boulder Platforms to jump from rock to rock while fighting Aeosera.  When she is casting her Breath Fire ability, jump to another rock and attack her while she is breathing fire to the other rock.  Repeat this until she surrenders.
		.' Defeat Aeosera |q 26659/2
	step //173
		goto 33.1,24.1
		.talk 42466
		..turnin 26659
		.' If Terrath the Steady doesn't spawn at the appropriate spot, go to 40.0,19.4
	step //174
		'Hearth to the Temple of Earth |goto 49.2,51.9,0.5 |use Hearthstone##6948 |noway |c
	step //175
		goto 72.2,54.0
		.talk 42472
		..turnin 26577
		..accept 26578
		..accept 26579
		..accept 26580
	step //176
		goto 71.8,47.6
		.talk 43395
		..turnin 26580
		..accept 26581
	step //177
		goto 73.6,40.8
		.kill 8 Fungal Behemoth |q 26579/1
		.from Doomshroom##+ |tip They look like orange mushrooms around this area.
		.' Destroy 10 Doomshrooms |q 26578/1
		.' Gather a sample of the red mist|q 26581/1 |tip There are small clouds of red mist that float around on the ground around this area.  Walk into one of them to gather a sample.
		.' You will be able to find more Fungal Behemoths and Doomshrooms around 76.6,44.4
	step //178
		goto 71.8,47.6
		.talk 43395
		..turnin 26581
		..accept 26582
	step //179
		goto 72.2,54.0
		.talk 42472
		..turnin 26578
		..turnin 26579
		..turnin 26582
		..accept 26584
		..accept 26585
	step //180
		goto 68.5,26.4
		.talk 43442
		..accept 26583
	step //181
		goto 68.6,29.1 |n
		.' Enter the cave |goto 68.6,29.1,0.5 |noway |c
	step //182
		goto 69.8,31.9
		.talk 43503
		..' Tell her you're ready when she is |q 26583/1
		.kill Fungalmancer Glop |q 26583/2 |tip Follow him each time he runs away.  Avoid the mushrooms as you walk, they will give you a debuff.  While fighting Fungalmancer Glop, kill the Boomshrooms he creates.  Don't let them grow too big, they will explode and deal a lot of damage.
	step //183
		goto 70.2,33.8 |n
		.' Follow the path up |goto 70.2,33.8,0.5 |noway |c
	step //184
		goto 68.6,29.1 |n
		.' Leave the cave |goto 68.6,29.1,0.5 |noway |c
	step //185
		goto 68.5,26.3
		.talk 43442
		..turnin 26583
	step //186
		goto 69.4,24.8
		.kill 8 Verlok Pillartumbler |q 26584/1
		.' Click Verlok Miracle-grow |tip They look like gray bags sitting on the ground around this area.
		.get 8 Verlok Miracle-grow |q 26585/1
	step //187
		goto 72.2,54.0
		.talk 42472
		..turnin 26584
		..turnin 26585
		..accept 26750
	step //188
		goto 56.3,12.2
		.talk 42465
		..turnin 26750
		..accept 26752
	step //189
		'Watch the dialogue
		.' Attend the Stonemother's Audience |q 26752/1
	step //190
		goto 56.1,13.5
		.talk 43809
		..turnin 26752
		..accept 26827
	step //191
		'Hearth to the Temple of Earth |goto 49.2,51.9,0.5 |use Hearthstone##6948 |noway |c
	step //192
		goto 47.3,51.4
		.talk 44799
		..accept 27004
	step //193
		goto 47.3,51.4
		.talk 44802
		..accept 27006
	step //194
		goto 39.0,74.2
		.' Go to this spot next to the big white portal
		.' Investigate the Master's Gate |q 27006/1 
	step //195
		goto 40.1,72.2
		.from Twilight Cryptomancer##44855+, Twilight Crusher##44849+, Twilight Armsman##44847+
		.get Masters' Gate Plans |q 27004/1
	step //196
		goto 47.3,51.4
		.talk 44799
		..turnin 27004
	step //197
		goto 47.3,51.4
		.talk 44802
		..turnin 27006
		..accept 27042
	step //198
		goto 47.3,51.4
		.talk 44799
		..accept 27040
	step //199
		goto 40.8,66.3
		.from Bound Water Elemental##44886
		.' Acquire the Water Ward |q 27042/2
	step //200
		goto 36.0,67.4
		.from Bound Fire Elemental##44887
		.' Acquire the Fire Ward |q 27042/1
	step //201
		goto 40.5,72.4
		.from Bound Air Elemental##44885
		.' Acquire the Air Ward |q 27042/3
	step //202
		goto 40.2,67.5
		.' Click One-Time Decryption Engines |tip They look like machines around this area with a circular scroll spinning around them, and yellow cores floating in the middle of the spinning scrolls.
		.' Decrypt 6 Plans |q 27040/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27040
		..accept 27058
	step //203
		goto 39.1,73.9
		.' Click the Waygate Controller |tip It looks like a cylinder stone container with a stone ring on top of it, sitting in front of the huge white portal.
		.' Destroy the Waygate |q 27058/1
	step //204
		goto 39.9,62.2
		.kill Haethen Kaul |q 27042/4 |tip He's up on a huge floating rock.
	step //205
		goto 47.3,51.4
		.talk 44799
		..turnin 27058
		..accept 28292
	step //206
		goto 47.3,51.4
		.talk 44802
		..turnin 27042
	step //207
		goto 48.0,53.7
		.' Talk with Windspeaker Lorvarius, Yuldris Smolderfury, Tawn Winterbluff, Earthcaller Yevaa and Tharm Wildfire at the below locations:
		.' 48.5,50.1
		.' 47.4,50.9
		.' 48.1,49.9
		..' Tell her you are joining an assault on Lorthuna's Gate and she is needed.
		.' Rally 5 Earthen Ring |q 26827/1
	step //208
		goto 49.6,53.0
		.talk 43065
		..turnin 26827
		..accept 26828
	step //209
		goto 63.3,25.0
		.talk 44025
		..turnin 26828
		..accept 26829
		..accept 26832
	step //210
		goto 62.6,26.9
		.talk 44080
		..accept 26831
	step //211
		goto 62.4,31.8
		.from High Priestess Lorthuna##42914 |tip She is in a small room on the top of this building.  She is elite, but you can still kill her.  She will run away when she is almost dead.
		.' Defeat High Priestess Lorthuna |q 26832/2
	step //212
		goto 58.9,32.9
		.from Boldrich Stonerender##42923
		.' Defeat Boldrich Stonerender |q 26832/1
	step //213
		goto 63.1,38.1
		.from Zoltrik Drakebane##42918 |tip You will eventually get on a stone drake and fly after Zoltrik Drakebane.  You can use your Jump ability to jump onto his drake, if you are a melee class.  Either way, you will land on a rock with him and kill him there.
		.' Defeat Zoltrik Drakebane |q 26831/1
	step //214
		goto 64.1,36.9
		.talk 42614
		..turnin 26831
	step //215
		goto 60.3,33.2
		.from Defaced Earthrager##44076+, Twilight Soulreaper##42916+, Twilight Priestess##42823+
		.kill 15 Twilight Precipice Cultists |q 26829/1
	step //216
		goto 63.3,25.0
		.talk 44025
		..turnin 26829
		..turnin 26832
		..accept 26833
	step //217
		goto 49.6,53.0
		.talk 43818
		..turnin 26833
		..accept 26875
	step //218
		goto 50.7,49.6
		.kill 12 Twilight Invaders |q 26875/1
		.kill Desecrated Earthrager |q 26875/2
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 26875
		..accept 26971
	step //219
		goto 49.6,52.9
		.kill High Priestess Lorthuna |q 26971/1 
	step //220
		goto 49.6,52.9
		.talk 43835
		..turnin 26971
	step //221
		goto 49.8,53.4
		.talk 43792
		..accept 26709
	step //222
		goto 56.4,12.1
		.talk 42465
		..turnin 26709
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Deepholm\\Therazane's Throne Dailies",[[
	description Walks you through completing the
	description daily quests in the Therazane's 
	description Throne region of Deepholm.
	author support@zygorguides.com
	daily
	step //1
		'Increasing your Therazane reputation to Revered will unlock more daily quests. |tip Use the THERAZANE guide in the Cataclysm Reputation section to do this.
		.' Skip to the next step in the guide
	step //2
		goto Deepholm,56.1,14.4
		.talk 43805
		..accept 27046 |daily
		..accept 27047 |daily
		..accept 28488 |daily |tip This quest can be offered at random and may not be offered everyday.
	step //3
		goto 56.6,14.1
		.talk 43806
		..accept 28391 |daily |tip This quest can be offered at random if you have at least Revered reputation with Therazane.  However, the quest may not be offered everyday.
		only if rep ('Therazane') >= Revered
	step //4
		goto 57.3,12.5
		.talk 43804
		..accept 27049 |daily
		..accept 27050 |daily
	step //5
		goto 55.4,14.2
		.talk 44945
		..accept 26710 |daily |tip This quest can be offered at random and may not be offered everyday.
	step //6
		goto 59.6,14.0
		.talk 44973
		..accept 27051 |daily
		..accept 28390 |daily |only if rep ('Therazane') >= Revered |tip This quest can be offered at random if you have at least Revered reputation with Therazane.  However, the quest may not be offered everyday.
	step //7
		goto 32.7,24.3
		.' Use your Stonework Mallet next to the Pale Resonating Crystal |use Stonework Mallet##60266 |tip It's a huge green crystal sitting on the ground.
		.' Strike the Pale Resonating Crystal |q 28391/1
		.from Aeosera##43641 |tip Click the Boulder Platforms to jump from rock to rock while fighting Aeosera.  When she is casting her Breath Fire ability, jump to another rock and attack her while she is breathing fire to the other rock.  Repeat this until she surrenders.
		.' Defeat Aeosera |q 28391/2
		only if rep ('Therazane') >= Revered
	step //8
		goto 56.6,14.1
		.talk 43806
		..turnin 28391
		only if rep ('Therazane') >= Revered
	step //9
		goto 58.3,25.6 |n
		.' Enter the cave |goto 58.3,25.6,0.5 |noway |c
	step //10
		goto 61.3,26.2
		.talk 44968
		..accept 27048 |daily |tip This quest can be offered at random and may not be offered everyday.
	step //11
		goto 66.1,28.1
		.' Follow the path inside the cave
		.' Click the Ruby Gemstone Cluster |tip It looks like 3 dark colored spinning rings with a bunch of red crystals spinning above them.
		.from Enormous Gyreworm##48533
		.get Ruby Crystal Cluster |q 28488/1
	step //12
		goto 63.6,23.0
		.' Use Ricket's Tickers next to Deep Alabaster Crystals |use Ricket's Tickers##65514 |tip They look like huge white rocks around this area.
		.get 3 Deep Alabaster Crystal |q 27048/1
	step //13
		goto 62.6,23.9 |n
		.' Follow this path |goto 62.6,23.9,0.5 |noway |c
	step //14
		goto 61.8,19.7
		.' Use Ricket's Tickers next to Deep Celestite Crystals |use Ricket's Tickers##65514 |tip They look like huge blue rocks around this area.
		.get 3 Deep Celestite Crystal |q 27048/2
	step //15
		goto 62.0,18.0 |n
		.' Follow this path |goto 62.0,18.0,0.5 |noway |c
	step //16
		goto 64.4,18.6
		.' Use Ricket's Tickers next to Deep Amethyst Crystals |use Ricket's Tickers##65514 |tip They look like huge purple rocks around this area.
		.get 3 Deep Amethyst Crystal |q 27048/3
	step //17
		goto 65.3,18.4 |n
		.' Follow this path |goto 65.3,18.4,0.5 |noway |c
	step //18
		goto 66.4,20.2
		.' Use Ricket's Tickers next to Deep Garnet Crystals |use Ricket's Tickers##65514 |tip They look like huge red rocks around this area.
		.get 3 Deep Garnet Crystal |q 27048/4	
	step //19
		goto 63.6,23.9
		.' All around inside this cave:
		.from Gorged Gyreworm##42766+, Gyreworm##44257+
		.kill 10 Gyreworm |q 27046/1
		.' Click Painite Shards |tip They look like small green glowing crystals sitting on the ground all around inside this cave.
		.get 10 Painite Mote |q 27047/1
	step //20
		goto 63.1,20.8
		.talk 49956
		..' Tell him to follow you
	step //21
		goto 64.2,17.6 |n
		.' Follow this path |goto 64.2,17.6,0.5 |noway |c
	step //22
		goto 61.3,26.2
		.talk 44968
		..turnin 27048
	step //23
		goto 58.3,25.6 |n
		.' Leave the cave |goto 58.3,25.6,0.5 |noway |c
	step //24
		goto 58.3,25.6
		.' Wait in this spot until Pebble bobbles around appreciatively and then disappears into the distance
		.' Bring Pebble to safety |q 26710/1
	step //25
		goto 74.0,41.2
		.kill 8 Fungal Behemoth |q 27049/1
		.from Verlok Grubthumper##43367+, Verlok Shroomtender##43368+
		.get Bag of Verlok Miracle-Grow |q 27051/1
		.' Click Sprouting Crimson Mushrooms |tip They look like tiny mushrooms on the ground around this area.  Try to only click the solid blue, solid red or white-brown ones.  The blue ones with red spots will explode and hurt you. 
		.' Destroy 10 Freshly Sprouted Mushrooms |q 27050/1
	step //26
		goto 68.6,29.1 |n
		.' Enter the cave |goto 68.6,29.1,0.5 |noway |c
	step //27
		goto 69.8,31.9
		.talk 43503
		..' Tell her you're ready when she is
		.kill Fungalmancer Glop |q 28390/1 |tip Follow him each time he runs away.  Avoid the mushrooms as you walk, they will give you a debuff.  While fighting Fungalmancer Glop, kill the Boomshrooms he creates.  Don't let them grow too big, they will explode and deal a lot of damage.
	step //28
		goto 70.2,33.8 |n
		.' Follow the path up |goto 70.2,33.8,0.5 |noway |c
	step //29
		goto 68.6,29.1 |n
		.' Leave the cave |goto 68.6,29.1,0.5 |noway |c
	step //30
		goto 59.6,14.0
		.talk 44973
		..turnin 27051
		..turnin 28390 |only if rep ('Therazane') >= Revered
	step //31
		goto Deepholm,56.1,14.4
		.talk 43805
		..turnin 27046
		..turnin 27047
		..turnin 28488
	step //32
		goto 55.4,14.2
		.talk 44945
		..turnin 26710
	step //33
		goto 57.3,12.5
		.talk 43804
		..turnin 27049
		..turnin 27050
]])



ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Uldum\\Uldum Pre-Quests",[[
	description Contains the pre-quests to unlock 
	description the daily quests in Uldum.
	description 
	description You must be at least level 83 to
	description complete this guide section.
	author support@zygorguides.com
	step //1
		goto Stormwind City,62.9,71.6
		.' Click the Hero's Call Board |tip It's a big white stone hanging board with a gold lion head on it.
		..accept 28558
	step //2
		goto 22.5,55.8 |n
		.' Ride the boat to Rut'theran Village |goto Teldrassil |noway |c
	step //3
		goto Teldrassil,55.4,88.4
		.talk 3838
		.' Fly to Gunstan's Dig, Tanaris |goto Tanaris,40.1,77.4,0.5 |noway |c
	step //4
		goto Tanaris,30.5,65.5
		.talk 44833
		..turnin 28558
		..accept 27003
	step //5
		goto 30.5,65.7
		.' Click Lady Humps |tip It's a camel.
		.' Watch the cutscenes
		.' Escort the Caravan |q 27003/1
	step //6
		goto Uldum,59.7,71.8
		.talk 46873
		..turnin 27003
	step //7
		goto 59.6,72.0
		.talk 46872
		..accept 27922
	step //8
		goto 61.7,71.1
		.' Click the Neferset Frond |tip It looks like an aloe vera plant with a tall blue flower in the middle of it, sitting in a pot on the ground upstairs in this building.
		.' Watch the cutscene
		.' Uncover the Neferset Secret |q 27922/1
	step //9
		goto 59.6,72.0
		.talk 46872
		..turnin 27922
		..accept 27923
		..accept 28105
	step //10
		goto 59.7,72.0
		.talk 46875
		..accept 27924
	step //11
		goto 60.0,74.0
		.from Kavem the Callous##47567
		.get Neferset Key |q 28105/1
	step //12
		goto 60.8,73.9
		.from Neferset Denizen##48267+
		.' Click Neferset Armor |tip They look like gray metal pieces of armor sitting on tables around this area.
		.get 6 Neferset Armor |q 27924/1
		.' Use your Brazier Torch next to Bales of Hay |use Brazier Torch##63027 |tip They look like bundles of yellow straw sitting on the ground around this area.
		.' Burn 5 Bales of Hay |q 27923/1
	step //13
		goto 59.7,72.0
		.talk 46875
		..turnin 27924
	step //14
		goto 59.6,72.0
		.talk 46872
		..turnin 27923
		..turnin 28105
		..accept 28112
	step //15
		goto 54.9,32.7
		.talk 47684
		..turnin 28112
		..accept 28134
	step //16
		goto 54.7,32.9
		.talk 48886
		.home Ramkahen
	step //17
		goto 56.2,33.6
		.talk 48275
		.fpath Ramkahen
	step //18
		goto 53.0,27.7
		.talk 47715
		..' Tell him you might be able to help
		.' Speak with Sun Priest Asaris |q 28134/2
	step //19
		goto 53.0,27.7
		.talk 47715
		..accept 28141
		..accept 28145
	step //20
		goto 46.3,21.0
		.from Wastewander Outrider##45905+
		.get 4 Relic of the Sun King |q 28141/1
		.from Venomblood Scorpid##45859+
		.' Use your Antidote Vial on Venomblood Scorpid corpses |use Antidote Vial##63086
		.' Drain 8 Venomblood Scorpids |q 28145/1
		.' You can find more Venomblood Scorpid and Wastewander Outriders around 49.9,24.0
	step //21
		goto 53.0,27.7
		.talk 47715
		..turnin 28141
		..turnin 28145
		..accept 28502
	step //22
		goto 45.7,16.2
		.kill Warlord Ihsenn |q 28502/1
	step //23
		goto 53.0,27.7
		.talk 47715
		..turnin 28502
	step //24
		goto 49.7,39.2
		.talk 47930
		..' Tell him the king wishes to be informed about recent Neferset activity
		.' Speak with Asaq |q 28134/3
	step //25
		goto 49.7,39.1
		.talk 47318
		..accept 27993
	step //26
		goto 60.3,38.3
		.talk 46603
		..' Tell him King Phaoris sent you to ask him about Neferset activity
		.' Speak with Nomarch Teneth |q 28134/1
	step //27
		goto 60.3,38.3
		.talk 46603
		..accept 28250
	step //28
		goto 59.1,38.4
		.' Use your Tahret Dynasty Mallet next to stacks of Pygmies |use Tahret Dynasty Mallet##63351 |tip They are sitting on each other's shoulders trying to steal fruit out of trees around this area.
		.' Smash 30 Thieving Pluckers |q 28250/1
	step //29
		goto 60.3,38.3
		.talk 46603
		..turnin 28250
	step //30
		goto 64.4,22.3
		.' Go to this spot
		.' Investigate Khartut's Tomb |q 27993/1
	step //31
		goto 64.4,22.3
		.talk 44860
		..turnin 27993
		..accept 27141
	step //32
		goto 64.3,22.2
		.' Click the Powder Keg |tip It looks like a small explosives barrel sitting on the ground.
		.' Watch the cutscene
		.' Assist Harrison at Khartut's Tomb |q 27141/1
	step //33
		goto 64.6,28.6
		.talk 45180
		..turnin 27141
	step //34
		goto 64.6,28.7
		.talk 45186
		..accept 27179
	step //35
		goto 64.8,29.6
		.' Click the Elaborate Disc |tip It looks like a tiny metal circular object laying on the ground.
		..accept 27176
	step //36
		goto 66.1,29.0
		.from Mangy Hyena##45202
		.' You will accept a quest
		..accept 27187
	step //37
		goto 68.2,31.5
		.from Skarf##45204
		.from Sultan Oogah##45205
		.collect Sultan's Staff##60865 |q 27176
	step //38
		'Use your Elaborate Disc |use Elaborate Disc##60859
		.get Shaft of the Stars |q 27176/1
	step //39
		goto 66.1,29.0
		.from Sand Pygmy##45190+
		.' Click Ornate Tablet Fragments |tip They looks like broken pieces of stone on the ground around this area.
		.get 10 Ornate Tablet Fragment |q 27179/1
		.from Mangy Hyena##45202+
		.' Eradicate 12 Mangy Hyenas |q 27187/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27187
	step //40
		goto 64.6,28.6
		.talk 45180
		..turnin 27179
		..turnin 27176
		..accept 27196
	step //41
		goto 64.6,28.6
		.talk 45180
		..' Tell him you're ready!
		.' Follow Harrison Jones |tip When he jumps down, use your flying mount to go down into the Chamber of Stars.
		.' Accompany Harrison Jones to the Chamber of the Stars |q 27196/1
	step //42
		goto 64.5,28.0
		.talk 45296
		..turnin 27196
		..accept 27511
	step //43
		goto 65.7,25.8
		.' Go to this spot
		.' Examine the Northern Hieroglyphs |q 27511/2
	step //44
		goto 64.4,29.9
		.' Go to this spot
		.' Examine the Ancient Mechanism |q 27511/1
	step //45
		goto 63.4,32.5
		.talk 45874
		..accept 27541
	step //46
		goto 63.4,32.5
		.talk 45874
		..' Take the scout's spectacles.
		.get Broken Spectacles |q 27541/1
	step //47
		goto 63.4,33.9
		.' Go to this spot
		.' Examine the Southern Hieroglyphs |q 27511/3
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27511
	step //48
		goto 64.5,28.0
		.talk 45296
		..turnin 27541
		..accept 27549
		..accept 28602
	step //49
		goto 63.3,28.0
		.' Click Suspended Starlights |tip They look like small orbs of light floating above the ground around this area.
		.get 7 Suspended Starlight |q 27549/1
		.' Walk near the skeletons laying on the ground around this area
		.from Tormented Tomb-Robber##45765+
		.get 6 Piece of Rope |q 28602/1
	step //50
		goto 64.5,28.0
		.talk 45296
		..turnin 27549
	step //51
		goto 64.5,28.0
		.talk 45296
		..turnin 28602
		..accept 27431
	step //52
		goto 64.5,28.0
		.talk 45296
		..' Ask him what you can do to help
		.' Watch the cutscene
		.' Stay Out of Harrison's Way |q 27431/1
	step //53
		goto 64.5,28.0
		.talk 45296
		..turnin 27431
		..accept 27624
	step //54
		goto 64.0,26.4
		.' Click the Watcher Head |tip It's the big head of a broken statue laying on the ground.
		.get Orb of the Morning Star |q 27624/1
	step //55
		goto 66.8,28.1
		.' Click the Watcher Head |tip It's the big head of a broken statue laying on the ground.
		.get Orb of the Evening Star |q 27624/2
	step //56
		goto 65.3,32.6
		.' Click the Watcher Head |tip It's the big head of a broken statue laying on the ground.
		.get Orb of the Shooting Star |q 27624/4
	step //57
		goto 62.5,32.0
		.' Click the Watcher Head |tip It's the big head of a broken statue laying on the ground.
		.get Orb of the North Star |q 27624/3
	step //58
		goto 64.5,28.0
		.talk 45296
		..turnin 27624
		..accept 27669
	step //59
		goto 64.5,28.7
		.' Use your Orbs of the Stars |use Orbs of the Stars##62054
		.' Watch the cutscene
		.' Reactivate the Obelisk of the Stars |q 27669/1
	step //60
		goto 63.9,33.9
		.talk 48034
		..turnin 27669
	step //61
		goto 54.9,32.7
		.talk 47684
		..turnin 28134
		..accept 28135
	step //62
		goto 54.3,35.3
		.talk 47005
		..accept 27899
	step //63
		goto 45.2,38.0
		.talk 45799
		..turnin 28135
		..accept 27520
	step //64
		goto 45.3,37.8
		.talk 45772
		..accept 27519
		..accept 27595
	step //65
		goto 40.0,40.5
		.talk 46003
		..turnin 27595
		..accept 27602
	step //66
		goto 39.6,45.4
		.' Click the Sand-Covered Hieroglyphs |tip It's a small silver plaque on the wall inside this small building.
		..turnin 27602
		..accept 27623
	step //67
		goto 39.6,40.9
		.' Click the Colossus of the Sun |tip It looks like a statue buried in the sand, with only the head and one arm above the sand.
		.from Colossus of the Sun##46041
		.get Stone of the Sun |q 27623/2
	step //68
		goto 41.2,37.6
		.' Click the Colossus of the Moon |tip It looks like a statue buried in the sand, with only the head and one arm above the sand.
		.from Colossus of the Moon##46042
		.get Stone of the Moon |q 27623/1
	step //69
		goto 40.7,40.2
		.kill 6 Scion of Al'Akir |q 27520/1
		.' Click Orsis Survivors |tip They looks like cat men laying in gray smoke on the ground around this area.
		.' Rescue 8 Orsis Survivors |q 27519/1
	step //70
		goto 39.6,45.4
		.' Click the Sand-Covered Hieroglyphs |tip It's a small silver plaque on the wall inside this small building.
		..turnin 27623
		..accept 27706
	step //71
		goto 39.6,45.4
		.' Click the Sacred Receptacle |tip it looks like a half-buried metal box.
		.get The Scepter of Orsis |q 27706/1
	step //72
		goto 44.0,57.1
		.talk 46978
		..turnin 27899
		..accept 27900
		..accept 27901
	step //73
		goto 44.3,58.2
		.from Schnottz Air Officer##46993
		.collect Efficient Excavations##62768 |n
		.' Click the Efficient Excavations in your bags |use Efficient Excavations##62768
		..accept 28132
	step //74
		goto 46.7,58.4
		.from Schnottz Air Trooper##46979+
		.' Slay 10 Schnottz Air Troopers |q 27900/1
		.from Schnottz Air Officer##46993+
		.collect Uldum Chest Key Code##62608 |n
		.' Click Obelisk of the Sun Coffers |tip They look like wooden baskets with a lids on them, sitting on the ground.
		.collect 6 Titan Device Component##62610 |q 27901
	step //75
		'Use your Titan Device Components |use Titan Device Component##62610
		.get Titan Activation Device |q 27901/1
	step //76
		goto 44.0,57.1
		.talk 46978
		..turnin 27900
		..turnin 27901
		..accept 27903
	step //77
		goto 45.2,58.8 |n
		.' Follow the path down |goto 45.2,58.8,0.5 |noway |c
	step //78
		goto 47.1,58.8
		.' Use your Titan Activation Device next to the huge statue |use Titan Activation Device##62611 |tip It looks like a huge statue at the bottom of the Chamber of the Sun, holding a fireball.
		.from Titanic Guardian##47032 |tip While fighting the Titanic Guardian, click the big lava meteors that appear on the ground to do massive to the Titanic Guardian, making him much easier to kill.
		.get Lens of the Sun |q 27903/1
	step //79
		goto 45.6,57.8
		.' Fly up onto the middle platform inside this cave
		.' Click the Titan Mechanism |tip It looks like a big spinning metal machine with a bunch of keys that move up and down.
		..turnin 27903
	step //80
		goto 44.0,57.1
		.talk 46978
		..accept 27905
		.' Use the abilities on your hotbar to shoot down the airplanes that chase you
		.' Escape the Obelisk of the Sun |q 27905/1
	step //81
		goto 54.6,41.8
		.talk 48082
		..turnin 27905
	step //82
		goto 45.2,38.0
		.talk 45799
		..turnin 27520
	step //83
		goto 45.3,37.8
		.talk 45772
		..turnin 27519
		..turnin 27706
	step //84
		goto 45.2,38.0
		.talk 45799
		..accept 27628
	step //85
		'Hearth to Ramhaken |goto 54.7,32.9,0.5 |use Hearthstone##6948 |noway |c
	step //86
		goto 54.9,32.7
		.talk 47684
		..turnin 27628
	step //87
		goto 55.0,34.0
		.talk 47959
		..accept 27630
		..accept 27629
		..accept 27631
	step //88
		goto 52.9,45.3 |n
		.' Enter the dam |goto 52.9,45.3,0.5 |noway |c
	step //89
		goto 54.2,41.9
		.talk 46135
		..turnin 27630
		..accept 27836
		..accept 27837
	step //90
		goto 52.9,45.3 |n
		.' Leave the dam |goto 52.9,45.3,0.5 |noway |c
	step //91
		goto 52.9,40.8
		.kill 8 Stillwater Slitherer |q 27837/1
		.' Click Slitherer Eggs |tip They look like white eggs on the ground underwater around this area.
		.' Destroy 6 Slitherer Eggs |q 27836/1
	step //92
		goto 52.9,45.3 |n
		.' Enter the dam |goto 52.9,45.3,0.5 |noway |c
	step //93
		goto 54.2,41.9
		.talk 46135
		..turnin 27836
		..turnin 27837
		..accept 28611
	step //94
		goto 52.9,45.3 |n
		.' Leave the dam |goto 52.9,45.3,0.5 |noway |c
	step //95
		goto 51.8,40.1 |n
		.' Enter the underwater cave |goto 51.8,40.1,0.5 |noway |c
	step //96
		goto 49.9,40.1
		.from Dark Ritualist Zakahn##49148
		.' Stop the Neferset Ritual |q 28611/1
	step //97
		goto 51.8,40.1 |n
		.' Leave the underwater cave |goto 51.8,40.1,0.5 |noway |c
	step //98
		goto 52.9,45.3 |n
		.' Enter the dam |goto 52.9,45.3,0.5 |noway |c
	step //99
		goto 54.2,41.9
		.talk 46135
		..turnin 28611
		..accept 27838
	step //100
		goto 52.9,45.3 |n
		.' Leave the dam |goto 52.9,45.3,0.5 |noway |c
	step //101
		goto 58.9,46.1
		.talk 46134
		..turnin 27631
		..accept 28198
		..accept 28201
	step //102
		goto 59.0,46.1
		.talk 48012
		..accept 28200
	step //103
		goto 59.6,47.3
		.talk 46883
		..turnin 28198
		..accept 28210
	step //104
		goto 56.3,53.5
		.talk 46136
		..turnin 27629
		..accept 27632
	step //105
		goto 55.6,53.7
		.talk 46333
		.' Recruit 8 Ramkahen Laborers |q 28201/1
	step //106
		goto 56.7,48.5
		.from Riverbed Crocolisk##45321+ |tip They are all along and in this big river.
		.get 20 Hardened Crocolisk Hide |q 28200/1
	step //107
		goto 59.0,46.1
		.talk 48012
		..turnin 28200
	step //108
		goto 58.9,46.1
		.talk 46134
		..turnin 28201
		..accept 27839
	step //109
		goto 60.4,57.5
		.' Use your Horn of Ramkahen |use Horn of Ramkahen##62534
		.' When the cat men run in to attack the smugglers, go to 60.5,58.7
		.' Click the Ancient Tol'vir Weapons |tip They look like 3 white boxes laying on the ground.
		.get Ancient Tol'vir Armaments |q 27839/1
	step //110
		goto 58.1,60.8
		.from Neferset Guard##46340+
		.get Vir'Naal Delta Map |q 27632/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27632
		..accept 27707
	step //111
		goto 55.5,59.5
		.from Bloodsnarl Hyena##45353+
		.' Help Salhet defeat 8 Bloodsnarl Hyenas |q 28210/1
		.' You can find more Bloodsnarl Hyenas around 52.6,56.2
	step //112
		'Next to you:
		.talk 48022
		..turnin 28210
		..accept 28276
	step //113
		goto 56.9,62.4
		.talk 48237
		..turnin 28276
		..accept 28277
	step //114
		goto 56.9,62.4
		.talk 48237
		..' Tell him let's see what he and his lions can do
		.' Use the abilities on your hotbar to use the lions to kill the hyenas
		.kill 30 Bloodsnarl Scavenger |q 28277/1
	step //115
		goto 56.9,62.4
		.talk 48237
		..turnin 28277
		..accept 28291
	step //116
		goto 71.3,73.7
		.talk 46425
		..' Tell him you're looking for Tahet
		.' Fight the enemies that attack
		.' Discover Tahet's Whereabouts |q 27707/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27707
		..accept 27738
	step //117
		goto 58.3,82.9
		.talk 46496
		.from Gorebite##46278
		.from Caimas the Pit Master##46276 |tip Make him chase you.  Run in front of him so that he runs over the big pink Croc Eggs on the ground around this area.  Baby Crocs will damage him and slow his run speed down.  Eventually, he will die.
		.' Free Tahet |q 27738/1
	step //118
		'Hearth to Ramhaken |goto 54.7,32.9,0.5 |use Hearthstone##6948 |noway |c
	step //119
		goto 58.9,14.2
		.kill Scalemother Hevna |q 27838/1 |tip She's a snake underwater.
	step //120
		goto 52.9,45.3 |n
		.' Enter the dam |goto 52.9,45.3,0.5 |noway |c
	step //121
		goto 54.2,41.9
		.talk 46135
		..turnin 27838
	step //122
		goto 52.9,45.3 |n
		.' Leave the dam |goto 52.9,45.3,0.5 |noway |c
	step //123
		goto 58.9,46.1
		.talk 46134
		..turnin 28291
		..turnin 27839
	step //124
		goto 56.3,53.5
		.talk 46136
		..turnin 27738
		..accept 28533
	step //125
		goto 54.9,32.7
		.talk 47684
		..turnin 28533
		.' Watch the cutscene
		..accept 28561
	step //126
		goto 67.2,42.9
		.talk 48761
		..turnin 28561
		..accept 28498
	step //127
		goto 67.3,42.8
		.talk 48501
		..accept 28499
	step //128
		goto 71.7,46.1
		.from Neferset Raider##48626+, Neferset Scryer##48625+, Neferset Looter##48627+
		.kill 10 Neferset intruder |q 28499/1
		.' Click Atulhet's Record Fragments |tip They look like broken stone tablet pieces laying on the ground around this area.
		.get 8 Atulhet's Record Fragment |q 28498/1
		.' You can find more  Atulhet Fragments and Neferset mobs around 75.2,45.7
	step //129
		goto 67.3,42.8
		.talk 48501
		..turnin 28499
	step //130
		goto 67.2,42.9
		.talk 48761
		..turnin 28498
		..accept 28500
	step //131
		goto 78.2,45.7
		.from Raider Lord Havat##49214
		.get The Cypher of Keset |q 28500/1
	step //132
		goto 67.2,42.9
		.talk 48761
		..turnin 28500
		..accept 28501
	step //133
		goto 66.7,41.8
		.talk 49228
		.' Use the abilities on your hotbar to command and heal the troops
		.' Complete the Defense of Nahom |q 28501/1
	step //134
		'Click the red arrow on your hotbar |outvehicle |noway |c |q 28501
	step //135
		goto 67.2,42.9
		.talk 48761
		..turnin 28501
		..accept 28623
	step //136
		goto 67.3,42.8
		.talk 48501
		..accept 27755
	step //137
		goto 69.8,58.9
		.kill Mekgineer Mixeltweed |q 27755/2 |tip He walks around this area in a metal spider-like machine.
		.kill 6 Crazed Digger |q 27755/1
		.collect A.I.D.A. Communicator##62483 |n
		.' Use the A.I.D.A. Communicator |use A.I.D.A. Communicator##62483
		..accept 27760
	step //138
		goto 74.1,64.4
		.' Click the A.I.D.A. Terminal |tip It looks like a box machine with a paper on it with red writing, under a blue and green canopy.
		..turnin 27760
		..accept 27761
		..accept 27777
	step //139
		goto 73.3,72.8
		.' Use your Mech Control Scrambler on Twizzleflux the Insane repeatedly |use Mech Control Scrambler##62542
		.from Twizzleflux the Insane##46587
		.get Core Access Codes |q 27777/1
	step //140
		goto 78.8,62.1
		.' Use your Holographic Projector next to the First Bomb Cluster to distract the enemies |use Holographic Projector##62398
		.' Click the First Bomb Cluster |tip It looks like a metal box with a yellow handle on it sitting on a big pile of red dynamite next to the wall.
		.' Disarm the First Bomb Cluster |q 27761/1
	step //141
		goto 79.0,64.3
		.' Use your Holographic Projector next to the Second Bomb Cluster to distract the enemies |use Holographic Projector##62398
		.' Click the Second Bomb Cluster |tip It looks like a metal box with a yellow handle on it sitting on a big pile of red dynamite in front of some stone stairs.
		.' Disarm the Second Bomb Cluster |q 27761/2
	step //142
		goto 79.0,64.9
		.' Use your Holographic Projector next to the Third Bomb Cluster to distract the enemies |use Holographic Projector##62398
		.' Click the Third Bomb Cluster |tip It looks like a metal box with a yellow handle on it sitting on a big pile of red dynamite next to the wall.
		.' Disarm the Third Bomb Cluster |q 27761/3
	step //143
		goto 79.0,63.6
		.' Use your Holographic Projector next to Unstable Bomb Bots to distract the enemies |use Holographic Projector##62398
		.' Click the Unstable Bomb Bots |tip They look like round walking bombs around this area.
		.' Deactivate 4 Unstable Bomb Bots |q 27761/4
	step //144
		goto 74.1,64.4
		.' Click the A.I.D.A. Terminal |tip It looks like a box machine with a paper on it with red writing, under a blue and green canopy.
		..turnin 27761
		..turnin 27777
		..accept 27778
	step //145
		goto 77.0,62.9
		.' Click the Maintenance Tools |tip It looks like a small wooden tool carrier sitting on the top of this huge metal machine.
		.collect Maintenance Axe##62621 |q 27778
	step //146
		goto 77.0,63.0
		.' Click the Wibson Mainframe |tip It looks like a tall metal box with spinning gears on it.
		.' Hack the Wibson Mainframe |q 27778/1
	step //147
		goto 77.3,63.3
		.talk 46750
		..turnin 27778
		..accept 27779
	step //148
		goto 81.9,58.8
		.' Roll down the hill as the Fusion Core
		.' Run over gnomes all around this area
		.' Obliterate 1000 Crazed Gnomes |q 27779/1
	step //149
		goto 77.6,62.4
		.' Roll back up the hill
		.' Click the red arrow on your hotbar |outvehicle |noway |c |q 27779
	step //150
		goto 77.3,63.3
		.talk 46750
		..turnin 27779
	step //151
		goto 52.0,65.5
		.talk 48564
		..turnin 28623
		..accept 28480
		..accept 28483
	step //152
		goto 52.9,65.5
		.talk 49345
		..accept 28486
	step //153
		goto 54.1,71.2
		.talk 49244
		.' Protect the rangers as they run up the path
		.' Secure Higher Ground |q 28486/1
	step //154
		goto 47.5,77.3
		.kill High Priest Sekhemet |q 28480/2
	step //155
		goto 50.6,87.0
		.kill Scorpion-Lord Namkhare |q 28480/1
	step //156
		goto 48.7,84.9
		.from Neferset Snake Charmer##47738+, Neferset Cursebringer##47760+, Neferset Ritualist##47762+
		.get 10 Neferset Insignia |q 28483/1
	step //157
		goto 52.9,65.5
		.talk 49345
		..turnin 28486
	step //158
		goto 52.0,65.5
		.talk 48564
		..turnin 28480
		..turnin 28483
		..accept 28520
	step //159
		goto 52.0,82.3
		.kill Dark Pharaoh Tekahn |q 28520/1
	step //160
		goto 24.4,64.5
		.talk 47670
		..turnin 28132
		..accept 27926
	step //161
		goto 22.5,63.2
		.talk 47176
		..' Ask him what he thinks of our host
		.' Mingle with Ambassador Laurent |q 27926/1
	step //162
		goto 22.5,63.2
		.talk 47185
		..' Ask him what he knows of our generous host
		.' Mingle with a Refined Gentleman |q 27926/2
	step //163
		goto 22.3,63.2
		.talk 47187
		..' Ask him how he finds the Commander
		.' Mingle with a Budding Artist |q 27926/3
	step //164
		goto 22.2,63.2
		.talk 47189
		..' Ask her how she has been enjoying her time here
		.' Mingle with an Aspiring Starlet |q 27926/4
	step //165
		goto 22.0,64.5
		.talk 49528
		.home Schnottz's Landing
	step //166
		goto 22.3,64.9
		.talk 48273
		.fpath Schnottz's Landing
	step //167
		goto 24.4,64.5
		.talk 47670
		..turnin 27926
		..accept 27928
	step //168
		goto 24.4,64.1
		.talk 47159
		..accept 27939
	step //169
		goto 40.6,68.9
		.from Diseased Vulture##47202
		.' You will accept a quest
		..accept 27940
	step //170
		goto 40.6,68.9
		.from Diseased Vulture##47202+
		.' Slay 8 Diseased Vultures |q 27940/1
		.from Shaggy Desert Coyote##47190+
		.get 5 Desert Coyote Pelt |q 27928/1
		.' Click the Desert Fox |tip It looks like a brown fox that runs all around this area.  It runs around a lot, so you will probably have to search for it to find it.
		.get The Desert Fox |q 27939/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27940
	step //171
		'Hearth to Schnottz's Landing |goto 22.0,64.5,0.5 |use Hearthstone##6948 |noway |c
	step //172
		goto 24.4,64.5
		.talk 47670
		..turnin 27928
		..accept 27941
	step //173
		goto 24.4,64.2
		.talk 47159
		..turnin 27939
		..accept 27942
		..accept 27943
	step //174
		goto 31.2,63.6
		.from Furious Specter##47220+
		.' Use your Licensed Proton Accelerator Cannon on Furioous Spectors once they are at half health |use Licensed Proton Accelerator Cannon##62794
		.get 5 Furious Spectral Essence |q 27943/1
		.' Click Dead Troopers |tip They look like dead humans on the ground around this area.
		.get 10 Trooper Uniform |q 27941/1
		.' Click Well-preserved Idols |tip They look like small purple coyote statues on the ground around this area.
		.get 8 Well-preserved Idol |q 27942/1
	step //175
		goto 24.4,64.5
		.talk 47670
		..turnin 27941
	step //176
		goto 24.4,64.1
		.talk 47159
		..turnin 27942
		..turnin 27943
		..accept 27950
	step //177
		goto 24.4,64.1
		.talk 47159
		..' Tell him the perimeter is secure
		.' Witness Gobbles' Transformation Ritual |q 27950/1
		.' Click the Quest Complete box that displays on the right side of the screen under your minimap
		..turnin 27950
	step //178
		goto 24.4,64.1
		.talk 47159
		..accept 27969
	step //179
		'Use your Refurbished Trooper Uniform |use Refurbished Trooper Uniform##62813
		.' Wear the Uniform |havebuff INTERFACE\ICONS\inv_chest_leather_08 |q 27969
	step //180
		goto 23.2,60.1
		.talk 47292
		..' Tell them they're behind schedule
		.' Motivate 6 Slackers |q 27969/1 |tip You won't motivate all of the Slacking Laborers you talk to.
		.' You can find more Slacking Laborers around 20.5,60.5
	step //181
		goto 24.5,64.2
		.talk 47159
		..turnin 27969
	step //182
		goto 24.4,64.5
		.talk 47670
		..accept 28002
	step //183
		goto 22.5,64.0
		.talk 47707
		..' Ask him if he saw anything
		.' Counsel the Budding Artist |q 28002/4
	step //184
		goto 22.4,63.8
		.talk 47516
		..' Ask him who could have done such a thing
		.' Question the Prolific Writer |q 28002/1
	step //185
		goto 22.2,63.9
		.talk 47519
		..' Ask her if she is alright
		..' Soothe the Privileged Socialite |q 28002/2
	step //186
		goto 22.3,64.1
		.talk 47520
		..' Ask him doesn't he want to know what happened to the man
		.' Chasten the Pretentious Businessman |q 28002/3
	step //187
		goto 24.4,64.5
		.talk 47670
		..turnin 28002
	step //188
		goto 24.4,64.1
		.talk 47159
		..accept 27990
	step //189
		goto 21.3,64.6
		.' Click Schnottz's Siege Tank |tip It looks like a big car with a cannon on top of it.
		.' Ride in Schnottz's Siege Tank
		.' Use the Fire Cannon ability on your hotbar on Decrepit Watchers |tip They are giants fighting all around this area.
		.' Obliterate 7 Decrepit Watchers |q 27990/1
	step //190
		goto 24.4,64.1
		.' Go to this spot
		.' Return to Schnottz |q 27990/2
	step //191
		goto 24.4,64.1
		.talk 47940
		..turnin 27990
		..accept 28187
	step //192
		goto 24.4,64.1
		.talk 47940
		..' Tell him let's move
		.' Follow Commander Schnottz
		.' Accompany Schnottz to Safety |q 28187/1
	step //193
		goto 22.5,63.2
		.talk 47972
		..turnin 28187
		..accept 28193
	step //194
		goto 21.9,64.1
		.' Go to this spot
		.' Visit Schnottz's Guests |q 28193/1
	step //195
		goto 21.9,64.0
		.talk 47967
		..accept 28194
	step //196
		goto 22.5,63.2
		.talk 47972
		..turnin 28193
		..accept 28195
	step //197
		goto 22.3,67.6
		.from Captain Margun##47981 |tip He's standing on the top ship deck, near the ship wheel.
		.' Kill Captain Margun |q 28195/1
	step //198
		goto 24.9,69.0
		.from Captain Cork##47980 |tip He's standing on the top ship deck, near the ship wheel.
		.' Kill Captain Cork |q 28195/2
	step //199
		goto 26.1,68.6
		.from Captain Kronkh##47978 |tip He's standing on the top ship deck, near the ship wheel.
		.' Kill Captain Kronkh |q 28195/3
	step //200
		goto 24.9,68.4
		.from Schnottz Sea Trooper##47982+ |tip Kill them on all 3 of the pirate ships around this area.
		.get 6 Fresh Sailor Uniform |q 28194/1
	step //201
		goto 21.9,64.0
		.talk 47967
		..turnin 28194
	step //202
		goto 22.5,63.2
		.talk 47972
		..turnin 28195
		..accept 28267
	step //203
		goto 22.5,63.2
		.talk 47972
		..' Tell him you suppose you're ready...
		.' Watch the cutscene
		.' Go 'Out Back' With Schnottz |q 28267/1
	step //204
		goto 23.6,60.3
		.talk 48162
		..turnin 28267
		..accept 28269
	step //205
		goto 22.3,64.9
		.talk 48273
		.' Fly to Ramkahen, Uldum |goto 56.3,33.6,0.5 |noway |c
	step //206
		goto 54.9,32.7
		.talk 47684
		..turnin 28520
	step //207
		goto 54.7,32.9
		.talk 48886
		.home Ramkahen
	step //208
		goto 67.3,42.8
		.talk 48501
		..turnin 27755
	step //209
		'Hearth to Ramhaken |goto 54.7,32.9,0.5 |use Hearthstone##6948 |noway |c
	step //210
		goto 27.0,7.5
		.talk 48186
		..turnin 28269
		..accept 28273
	step //211
		goto 26.6,7.2
		.talk 49406
		.home Oasis of Vir'sar
	step //212
		goto 26.6,8.4
		.talk 48274
		.fpath Oasis of Vir'sar	
	step //213
		goto 26.6,8.0
		.talk 48203
		..turnin 28273
		..accept 28274
	step //214
		'Watch the cutscene
		.' Accompany Sullah |q 28274/1
	step //215
		goto 29.6,21.9
		.talk 48431
		..turnin 28274
		..accept 28350
		..accept 28352
		..accept 28351
	step //216
		goto 29.9,38.2
		.from Wild Camel##51193+
		.' Use Sullah's Camel Harness on Wild Camels when they are weakened |use Sullah's Camel Harness##67241 |tip You will see a message flash on your screen telling you to capture the camel.
		.' Capture 3 Wild Camels |q 28352/1
	step //217
		goto 29.9,38.2
		.from Wild Camel##51193+
		.get 5 Meat Scrap |q 28350/1
		.from Cavorting Pygmy##51217+
		.' Use Sullah's Pygmy Pen on Cavorting Pygmies when they are weakened |use Sullah's Pygmy Pen##67232 |tip You will see a message flash on your screen telling you to cage the pygmy.
		.' Capture 5 Sand Pygmies |q 28351/1
	step //218
		goto 29.6,21.8
		.talk 48431
		..turnin 28350
		..turnin 28352
		..turnin 28351
		..accept 28353
	step //219
		'Hearth to Oasis of Vir'sar |goto 26.6,7.2,0.5 |use Hearthstone##6948 |noway |c
	step //220
		goto 27.0,7.5
		.talk 48186
		..turnin 28353
		..accept 28271
		..accept 28272
	step //221
		goto 38.2,21.6
		.from Schnottz Overseer##48205+
		.from Schnottz Excavator##48204+
		.' Kill 15 Schnottz Employees at the Obelisk of the Moon |q 28271/1
		.' Click Pillaged Loot Sacks |tip They look like green and white striped bags sitting on the ground all around this area.
		.get 7 Ancient Copper Scroll |q 28272/1
	step //222
		goto 27.0,7.6
		.talk 48186
		..turnin 28271
		..turnin 28272
		..accept 28363
	step //223
		goto 29.6,21.8
		.talk 48431
		..turnin 28363
		..accept 28367
	step //224
		goto 38.4,22.6
		.' Use your Shroud of the Makers every 2 minutes to stay Cloaked|use Shroud of the Makers##63699 |tip The big dragon that flies around this area can see through your cloaking, so be careful not to get too close to it.
		.' Click Schnottz Powder Kegs |tip They look like explosive wooden barrels on the ground around this area.
		.' Sabotage 7 Powder Kegs |q 28367/1
	step //225
		goto 27.0,7.5
		.talk 48186
		..turnin 28367
		..accept 28402
	step //226
		goto 36.7,20.8 |n
		.' Enter the building |goto 36.7,20.8,0.5 |noway |c
	step //227
		goto 33.5,17.8 |n
		.' Fly down this hole |goto 33.5,17.8,0.5 |noway |c
	step //228
		goto 35.0,19.2
		.from Schnottz Elite Trooper##48668+
		.' Slay 10 Schnottz Elite Troopers |q 28402/1
	step //229
		goto 36.1,20.3
		.talk 48528
		..turnin 28402
		..accept 28403
	step //230
		goto 36.1,20.3
		.talk 48528
		..' Tell him you are ready when he is
		.' Follow Harrison Jones
		.' Upload the Titan Data |q 28403/1
	step //231
		goto 39.0,23.2
		.talk 48558
		..turnin 28403
		..accept 28404
	step //232
		goto 39.6,23.6
		.from Lunar Crystal##48529+ |tip They look like glowing floating spiked crystal balls.
		.' Defeat the Titan Guardian |q 28404/1
	step //233
		goto 39.0,23.2
		.talk 48558
		..turnin 28404
	step //234
		goto 42.2,25.9
		.talk 48621
		..accept 28482
	step //235
		goto 41.4,5.6
		.talk 48698
		..turnin 28482
		..accept 28497
	step //236
		goto 41.4,5.6
		.' Click the Confiscated Artillery |tip It looks like a war catapult car machine.
		.' Use the Designate Target ability on your hotbar on the Schnottz Infantrymen
		.' Slay 100 Schnottz Infantrymen |q 28497/1
	step //237
		goto 41.4,5.6
		.talk 48698
		..turnin 28497
		..accept 28613
	step //238
		goto 36.1,15.8
		.talk 47158
		..turnin 28613
		..accept 27748
		.' Follow Harrison Jones and fight the Obsidian Colossus |tip Occasionally, crates will parachute onto the ground and become treasure chest with glowing jewels floating above them.  Run up next to the treasure chest to gain healing or attack power bonuses.  Avoid the pink shadow runes on the ground when the Obsidian Colossus casts them.  You will see messages pop up on your screen letting you know what to do.
		.from Obsidian Colossus##46646
		.' Defeat the Obsidian Colossus |q 27748/1
	step //239
		goto 33.4,19.7
		.talk 49151
		..turnin 27748
		..accept 28612
		.' Watch the cutscene
		.' Discover the Coffer of Promise |q 28612/1
	step //240
		goto 32.6,30.9
		.talk 49204
		..turnin 28612
		..accept 28621
	step //241
		goto 32.6,30.7
		.talk 49203
		..turnin 28621
		..accept 28622
	step //242
		goto 32.0,29.9
		.' Use Harrison's Signal Flares |use Harrison's Signal Flares##64668
		.' Place the North Signal Flare |q 28622/1
	step //243
		goto 31.4,30.8
		.' Use Harrison's Signal Flares |use Harrison's Signal Flares##64668
		.' Place the West Signal Flare |q 28622/2
	step //244
		goto 32.0,31.6
		.' Use Harrison's Signal Flares |use Harrison's Signal Flares##64668
		.' Place the South Signal Flare |q 28622/3
	step //245
		goto 44.9,67.3
		.talk 49248
		..turnin 28622
		..accept 28633
	step //246
		goto 45.0,67.3
		.' Click the Coffer of Promise |tip It looks like a huge stone box with a golden lid on it.
		.get Titan Discs |q 28633/1
	step //247
		goto 44.9,67.3
		.talk 49351
		..turnin 28633
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Uldum\\Tahret Grounds Dailies",[[
	description Walks you through completing the
	description daily quests in the Ramkahen 
	description region of Uldum.
	author support@zygorguides.com
	daily
	step //1
		goto Uldum,60.3,38.3
		.talk 46603
		..accept 28250 |daily
	step //2
		goto 59.1,38.4
		.' Use your Tahret Dynasty Mallet next to stacks of Pygmies |use Tahret Dynasty Mallet##63351 |tip They are sitting on each other's shoulders trying to steal fruit out of trees around this area.
		.' Smash 30 Thieving Pluckers |q 28250/1
	step //3
		goto 60.3,38.3
		.talk 46603
		..turnin 28250
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Uldum\\Pilgrim's Precipice Dailies",[[
	description Walks you through completing the
	description daily quests in the Pilgrim's 
	description Precipice region of Uldum.
	author support@zygorguides.com
	daily
	step //1
		goto Uldum,41.4,5.5
		.talk 49523
		..accept 28736 |daily
	step //2
		goto 41.4,5.5
		.' Click the Confiscated Artillery |tip It looks like a war catapult car machine.
		.' Use the Designate Target ability on your hotbar on the Infantrymen
		.' Slay 100 Infantrymen |q 28736/1
	step //3
		goto 41.4,5.5
		.talk 49523
		..turnin 28736
]])



ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Twilight Highlands\\Twilight Highlands Pre-Quests",[[
	description Contains the pre-quests to unlock 
	description the daily quests in Twilight Highlands.
	description 
	description You must be at least level 84 to
	description complete this guide section.
	author support@zygorguides.com
	step //1
		goto Stormwind City,62.9,71.6
		.' Click the Hero's Call Board |tip It looks like two white stone pillars with a wooden board hanging between them with papers pinned onto it.
		..accept 28716
	step //2
		goto 85.7,31.8
		.talk 41735
		..turnin 28716
		..accept 26960
	step //3
		goto 85.7,31.6
		.talk 1747
		..' Tell him to come with you
		.' Become Introduced to Anduin |q 26960/1
	step //4
		goto 85.7,31.8
		.talk 41735
		..turnin 26960
		..accept 26975
		..accept 26977
	step //5
		goto 85.1,31.3
		.talk 2439
		..turnin 26977
		..accept 26997
	step //6
		goto 85.8,25.9
		.talk 44238
		..turnin 28292
	step //7
		goto 29.3,26.5
		.talk 29152
		.' Interrogate 6 Dock Workers |q 26997/1
	step //8
		'Next to you:
		.talk 44293
		..turnin 26997
		.' If Anduin Wrynn is not next to you, you can find in Stormwind Keep at 85.7,31.6 |tip Talk to him and tell him to come with you, if you have to go get him again.
	step //9
		goto 33.1,39.4
		.' Go to this spot
		.' Escort Anduin to Supply Sergeant Graves |q 26975/1
	step //10
		goto 33.1,39.5
		.talk 44749
		..turnin 26975
		..accept 27038
	step //11
		'Next to you:
		.talk 44293
		..accept 27044
		.' If Anduin Wrynn is not next to you, you can find in Stormwind Keep at 85.7,31.6 |tip Talk to him and tell him to come with you, if you have to go get him again.
	step //12
		goto 34.6,46.1
		.' Click Missing Parts |tip They look like brown metal buckets with mechanical parts in them on the ground around this area.
		.get 5 Missing Parts |q 27038/1
	step //13
		goto 34.8,38.2
		.talk 44806
		..turnin 27038
	step //14
		'Next to you:
		.talk 44293
		..accept 27064
		.' If Anduin Wrynn is not next to you, you can find in Stormwind Keep at 85.7,31.6 |tip Talk to him and tell him to come with you, if you have to go get him again.
	step //15
		goto 52.0,5.8
		.' Go to this spot
		.' Escort Prince Anduin to Farmer Wollerton |q 27044/1
		.' If Anduin Wrynn is not next to you, you can find in Stormwind Keep at 85.7,31.6 |tip Talk to him and tell him to come with you, if you have to go get him again.
	step //16
		goto 52.1,6.0
		.talk 44807
		..turnin 27044
		..accept 27060
	step //17
		goto 43.8,4.6
		.' Go to this spot
		.' Discover the Crime Scene |q 27060/1
		.from Twilight Striker##44808+
		.' Protect Prince Anduin |q 27060/2
	step //18
		'Next to you:
		.talk 44293
		..turnin 27060
		.' If Anduin Wrynn is not next to you, you can find in Stormwind Keep at 85.7,31.6 |tip Talk to him and tell him to come with you, if you have to go get him again.
	step //19
		goto 80.2,62.1
		.' Go inside this building and up the spiral staircase
		.' Allow Anduin to Examine Samuelson's Papers |q 27064/1
		.' If Anduin Wrynn is not next to you, you can find in Stormwind Keep at 85.7,31.6 |tip Talk to him and tell him to come with you, if you have to go get him again.
	step //20
		'Next to you:
		.talk 44293
		..turnin 27064
		..accept 28807
		.' If Anduin Wrynn is not next to you, you can find in Stormwind Keep at 85.7,31.6 |tip Talk to him and tell him to come with you, if you have to go get him again.
	step //21
		goto 81.3,63.5
		.talk 332
		..turnin 28807
		..accept 27072
	step //22
		goto 39.8,56.8
		.kill 6 Crazed Cultist |q 27072/1
	step //23
		goto 37.2,56.2
		.talk 50049
		..turnin 27072
		..accept 27092
	step //24
		goto 52.9,51.0 |n
		.' Enter the Cathedral |goto 52.9,51.0,0.5 |noway |c
	step //25
		goto 51.3,44.3 |n
		.' Follow the spiral ramp down |goto 51.3,44.3,0.5 |noway |c
	step //26
		goto 53.2,42.6 |n
		.' Follow the stairs down |goto 53.2,42.6,0.5 |noway |c
	step //27
		goto 50.6,42.2
		.kill The Black Bishop |q 27092/1
	step //28
		goto 50.2,42.6
		.' Click the Pile of Explosives
		..turnin 27092
		..accept 27106
	step //29
		goto 85.1,31.0
		.talk 2439
		..' Tell him it's over
		.' Unmask Major Samuelson |q 27106/1
		.kill Major Samuelson |q 27106/2
	step //30
		goto 85.8,31.7
		.talk 41735
		..turnin 27106
		..accept 28238
	step //31
		goto 26.1,47.3
		.talk 44806
		..turnin 28238
		..accept 28832
	step //32
		goto 25.9,47.6
		.' Click Flintlocke's Seaplane |tip It looks like an airplane flying in place above the water.
		.' Ride to Twilight Highlands |goto Twilight Highlands |noway |c
	step //33
		goto Twilight Highlands,81.0,79.4
		.talk 49022
		..turnin 28832
		..accept 28596
	step //34
		goto 81.1,77.3
		.' Click Cannon Powder Barrels |tip They look like wooden barrels on the ground around this area.
		.get 10 Cannon Powder |q 28597/1
		.kill 10 Horde Attackers |q 28596/1
	step //35
		goto 81.0,79.4
		.talk 49022
		..turnin 28596
	step //36
		goto 81.0,79.4
		.talk 49252
		..accept 28597
	step //37
		goto 78.8,76.8
		.talk 49252
		..turnin 28597
		..accept 28598
	step //38
		'You may have to wait for a few minutes, so just stand here and wait
		.' Wait to be launched from Flintlocke's Cannon |q 28598/1
	step //39
		'Go downstairs in the zeppelin
		.' Use Flintlocke's Explosives while downstairs |use Flintlocke's Explosives##64660
		.' Destroy the Skyshredder |q 28598/2
	step //40
		goto 78.9,76.7
		.talk 49252
		..turnin 28598
		..accept 28599
	step //41
		goto 79.1,78.3
		.' Go upstairs in the fort
		.talk 49358
		..turnin 28599
		..accept 27338
	step //42
		goto 79.3,78.5
		.talk 45170
		..accept 27177
		..accept 27178
	step //43
		goto 76.0,80.0
		.talk 45171
		..accept 27200
	step //44
		goto 76.1,79.8
		.from Ophelia##45183
		.' Slay Ophelia and Protect Ephram |q 27200/1
	step //45
		goto 76.0,80.0
		.talk 45171
		..turnin 27200
	step //46
		goto 76.2,83.0
		.' Click Water-Logged Crates |tip They look like wooden boxes on the ground underwater around this area.
		.get 8 Recovered Supplies |q 27177/1
		.from Blackscale Seacaller##45182+, Blackscale Myrmidon##45179+
		.' Slay 10 Blackscale Naga |q 27178/1
	step //47
		goto 79.3,78.5
		.' Go upstairs in the fort
		.talk 45170
		..turnin 27177
		..turnin 27178
	step //48
		goto 76.8,69.8
		.talk 45169
		..turnin 27338
		..accept 27341
		..accept 27366
	step //49
		goto 77.0,69.9
		.talk 49252
		..accept 27433
	step //50
		goto 77.5,65.3
		.' Go to this spot
		.' Scout the Beach Head Control Point |q 27341/1
	step //51
		goto 77.4,67.1
		.kill 12 Axebite Marine |q 27366/1 |tip Be careful and pay attention not to stand too close to the red arrows bouncing above the ground.  Cannon balls land at the arrows a few seconds after the arrows appear, and they will hurt you a lot if they hit you.
	step //52
		goto 74.3,68.0
		.from Diamond-Blade Shredder##45185+
		.get 5 Abused Shredder Parts |q 27433/1
	step //53
		goto 76.8,69.8
		.talk 45169
		..turnin 27341
		..turnin 27366
		..accept 27514
	step //54
		goto 77.0,69.9
		.talk 45168
		..turnin 27433
		..accept 27468
	step //55
		goto 73.4,71.2
		.talk 45524
		..' Tell him you'll cover him while he makes repairs
		.' Speak to a Siege Tank Commander |q 27468/1
		.from Axebite Grunt##45187+
		.' Defend the Siege Tank |q 27468/2
	step //56
		goto 77.0,69.9
		.talk 45168
		..turnin 27468
	step //57
		goto 67.7,66.0
		.talk 45172
		..turnin 27514
		..accept 27515
	step //58
		goto 71.4,66.2
		.' Click Thorny Stankroots |tip They look like gray-ish bumps with green leaves on them on the ground around this area.
		.get 8 Thorny Stankroot |q 27515/1
	step //59
		goto 67.7,66.0
		.talk 45172
		..turnin 27515
		..accept 27516
	step //60
		goto 67.7,66.0
		.talk 45172
		..' Tell him you're ready, let's go!
		.' Fly with Thordun Hammerblow to Highbank |q 27516/1
	step //61
		goto 79.4,78.5
		.talk 49688
		.home Highbank
	step //62
		goto 79.1,78.3
		.' Go upstairs in the fort
		.talk 45167
		..turnin 27516
		..accept 27537
	step //63
		goto 79.2,78.3
		.talk 45172
		..accept 27538
	step //64
		goto 67.7,46.9
		.from Muddied Water Elemental##44011+
		.get 5 Whirlpool Core |q 27537/1
		.' Click Verrall River Muck |tip They look like mounds of swirled gray and white sand on the ground around this area.
		.get 10 Verrall River Muck |q 27538/1
	step //65
		'Hearth to Highbank |goto 79.4,78.5,0.5 |use Hearthstone##6948 |noway |c
	step //66
		goto 79.4,77.6
		.talk 45173
		..turnin 27537
		..turnin 27538
		..accept 27545
	step //67
		goto 79.1,78.3
		.' Go upstairs in the fort
		.talk 45167
		..turnin 27545
	step //68
		goto 79.2,78.3
		.talk 45172
		..accept 27621
	step //69
		goto 60.1,57.9
		.talk 49271
		..turnin 27621
		..accept 27803
		..accept 27804
	step //70
		goto 60.4,58.1
		.talk 49795
		.home Firebeard's Patrol
	step //71
		goto 60.4,58.3
		.talk 49370
		..accept 27805
	step //72
		goto 60.4,57.6
		.talk 47147
		.fpath Firebeard's Patrol
	step //73
		goto 59.8,56.2
		.' Use your Wildhammer Water Bucket next to fires to extinguish them |use Wildhammer Water Bucket##62508
		.' Click Meara's Dried Roses |tip They look like a bushel of dark red roses hanging on the wall inside this burning building.
		.get Meara's Dried Roses |q 27805/1
	step //74
		goto 59.5,55.9
		.' Use your Wildhammer Water Bucket next to fires to extinguish them |use Wildhammer Water Bucket##62508
		.' Click Aprika's Lost Doll |tip It looks like a white teddy bear with crossed out eyes sitting on the ground inside this burning building.
		.get Aprika's Doll |q 27805/3
	step //75
		goto 59.3,56.9
		.' Use your Wildhammer Water Bucket next to fires to extinguish them |use Wildhammer Water Bucket##62508
		.' Click Parlan's Ivory Hammer |tip It looks like a white hammer sitting on the stove inside this burning building.
		.get Parlan's Ivory Hammer |q 27805/2
	step //76
		goto 59.8,56.9
		.' Use your Wildhammer Water Bucket next to fires |use Wildhammer Water Bucket##62508
		.' Extinguish 50 Village Fires |q 27804/1
		.kill 8 Subjugated Firestarter |q 27803/1
	step //77
		goto 60.2,58.0
		.talk 49271
		..turnin 27803
		..turnin 27804
		..accept 27806
	step //78
		goto 60.4,58.3
		.talk 49370
		..turnin 27805
	step //79
		goto 57.5,58.1
		.talk 46805
		..turnin 27806
		..accept 27807
		..accept 27808
		..accept 27809
	step //80
		goto 50.8,60.2
		.talk 46811
		..turnin 27807
		..accept 27810
	step //81
		goto 50.8,60.2
		.talk 46812
		..accept 27811
	step //82
		goto 51.1,59.9
		.talk 46813
		..' Tell him he's not backing out, is he
		.from Mullan Gryphon Rider##46813
		.' Defeat a Mullan Gryphon Rider |q 27810/1
	step //83
		goto 50.8,60.2
		.talk 46811
		..turnin 27810
	step //84
		goto 57.3,67.6
		.talk 46968
		..' Let the gryphons smell the piece of charred highland birch
		.' Find and return 8 Mullan Gryphons |q 27811/1
	step //85
		goto 61.4,67.4
		.talk 47317
		..turnin 27808
		..accept 27999
	step //86
		goto 50.8,60.2
		.talk 46812
		..turnin 27811
	step //87
		goto 50.8,60.3
		.talk 46811
		..accept 27812
	step //88
		goto 57.5,58.1
		.talk 46805
		..turnin 27999
		..turnin 27812
	step //89
		goto 62.5,48.4
		.talk 46850
		..turnin 27809
		..accept 27813
	step //90
		goto 62.6,48.6
		.talk 48046
		..accept 28233
	step //91
		goto 62.6,48.6
		.talk 46806
		..accept 27814
	step //92
		goto 63.1,47.6
		.talk 48053
		..turnin 28233
		..accept 28234
	step //93
		goto 62.3,47.0
		.' Go upstairs in this building
		.from Gorosh the Pant Stealer##48102
		.get Bahrum's Pants |q 28234/1
	step //94
		goto 62.3,46.8
		.talk 47465
		..' Help the orcs up
		.' Defeat 6 Dragonmaw Stragglers |q 27813/1
		.' Click Dragonmaw Weapon Axes |tip The Dragonmaw Stragglers drop them when you help them up.  They look like axes stuck in the ground.
		.' Click Dragonmaw Weapon Racks |tip They look like brown racks with 2 axes on them mounted on walls around this area.
		.get 8 Dragonmaw Weapon |q 27814/1
	step //95
		goto 62.5,48.4
		.talk 46850
		..turnin 27813
	step //96
		goto 62.5,48.4
		.talk 46850
		..accept 27815
	step //97
		goto 62.6,48.6
		.talk 46806
		..turnin 27814
	step //98
		goto 63.2,47.6
		.talk 48172
		..turnin 28234
	step //99
		goto 57.5,58.1
		.talk 46805
		..turnin 27815
		..accept 27816
	step //100
		goto 60.2,57.8
		.talk 46804
		..turnin 27816
		..accept 27817
	step //101
		goto 59.9,57.3
		.' Click a Firebeard Gryphon Mount |tip They look like big eagles standing here.
		.' Ride the Firebeard Gryphon Mount |invehicle |c |q 27817
	step //102
		goto 58.8,53.1
		.' While flying on the Firebeard Gryphon Mount:
		.' Use the abilities on your action bar to kill Twilight Stormbenders on the floating rocks |tip Use your Storm Shield ability when someone casts a lightning attack on you.
		.kill 12 Twilight Stormbender |q 27817/1
	step //103
		goto 58.6,51.7
		.' While flying on the Firebeard Gryphon Mount:
		.' Use the abilities on your action bar to weaken Servias Windterror
		.' Eventually, you will get off the gryphon and fight him regularly
		.kill Servias Windterror |q 27817/2 |tip When he casts his lightning spell on the ground, move away from that spot to avoid damage when it explodes.
	step //104
		goto 60.2,57.9
		.talk 49271
		..turnin 27817
		..accept 27640
		..accept 28001
	step //105
		goto 46.7,66.0 |n
		.' Enter this building |goto 46.7,66.0,0.5 |noway |c
	step //106
		goto 45.9,65.5
		.talk 46177
		..turnin 27640
		..accept 27643
		..accept 27644
		..accept 27645
	step //107
		goto 45.9,65.4
		.talk 46143
		..accept 27641
		..accept 27642
	step //108
		goto 45.8,71.7
		.talk 46174
		..turnin 27645
		..accept 27648
	step //109
		goto 45.8,71.7
		.talk 46174
		..' Tell him yeah... and let's get to it then
		.' Escort Cayden Dunwald
		.' Accompany Cayden through Dunwald Market Row |q 27648/1
		.' Cayden Dunwald can also be at 47.9,74.5
	step //110
		goto 47.9,74.5
		.talk 46174
		..turnin 27648
		.' Cayden Dunwald can also be at 45.8,71.7
	step //111
		goto 52.9,74.3
		.talk 49013
		..turnin 27644
		..accept 27647
	step //112
		goto 52.8,69.8
		.' Click a Sacred Ale Tap |tip They look like 3 wooden kegs built into the wall in the basement of this building.
		.get Sacred Wildhammer Ale |q 27647/1
	step //113
		goto 52.4,70.3
		.talk 46583
		..turnin 27647
		..accept 27649
	step //114
		goto 46.4,59.1
		.talk 46176
		..turnin 27643
		..accept 27646
	step //115
		goto 45.4,60.0
		.' As you walk around doing quests:
		.talk 46609
		.' Click Wildhammer Ale Casks and get them |tip They look like brown barrels sitting on the ground around this area.
		.' Go into the basement of this building
		.' Search the cellar in southern Dunwald Hovel |q 27646/1
	step //116
		goto 46.4,53.8
		.' As you walk around doing quests:
		.talk 46609
		.' Click Wildhammer Ale Casks and get them |tip They look like brown barrels sitting on the ground around this area.
		.' Go into the basement of this building
		.' Search the cellar in northwestern Dunwald Hovel |q 27646/2
	step //117
		goto 48.4,52.6
		.' As you walk around doing quests:
		.talk 46609
		.' Click Wildhammer Ale Casks and get them |tip They look like brown barrels sitting on the ground around this area.
		.' Go to this spot
		.' Search the buildings in eastern Dunwald Hovel |q 27646/3
	step //118
		goto 46.0,58.7
		.talk 46176
		..turnin 27646
		..accept 27650
	step //119
		goto 45.9,54.8
		.from Bloodgorged Ettin##46145+, Twilight Scavenger##46183+, Twilight Pillager##46144+, Twilight Shadeprowler##46526+
		.' Welcome 20 Twilight Guests to Dunwald |q 27641/1
		.talk 46609
		.' Find 12 Dunwald Victims |q 27642/1
		.' Click Wildhammer Ale Casks |tip They look like brown barrels sitting on the ground around this area.
		.get 6 Wildhammer Ale |q 27649/1
		.' You can find more of all these things:
		.' Around 47.0,66.1
		.' Around 46.4,72.6
		.' Around 50.7,69.8
	step //120
		goto 46.7,66.0 |n
		.' Enter this building |goto 46.7,66.0,0.5 |noway |c
	step //121
		goto 46.2,65.6
		.talk 46585
		..turnin 27649
	step //122
		goto 45.9,65.4
		.talk 46143
		..turnin 27641
		..turnin 27642
	step //123
		goto 46.0,65.5
		.talk 49363
		..turnin 27650
		..accept 27651
	step //124
		goto 50.5,70.6
		.talk 46628
		..' Tell him you're in
		.kill Darunga |q 27651/1
	step //125
		goto 50.5,70.6
		.talk 46628
		..turnin 27651
	step //126
		goto 49.0,29.8
		.talk 46591
		..turnin 28001
		..accept 27754
		..accept 28369
	step //127
		goto 49.8,29.2
		.talk 48010
		..accept 27752
	step //128
		goto 49.8,29.3
		.talk 48013
		..turnin 28369
		..accept 27753
	step //129
		goto 49.5,30.4
		.talk 49591
		.home Thundermar
	step //130
		goto 48.5,28.1
		.talk 47154
		.fpath Thundermar
	step //131
		goto 46.2,37.4
		.from Dragonmaw Marauder##46310+
		.get 8 Dragonmaw Insignia |q 27754/1
		.' Click Thundermar Ale Kegs |tip They look like wooden barrels on the ground around this area.
		.get 10 Wildhammer Keg |q 27752/1
		.' Click Wildhammer Food Stores |tip They look like hanging fish, sliced bread, and legs of meat on the ground around this area.
		.get 15 Wildhammer Food Stores |q 27753/1
		.' You can find more around 49.1,37.3
	step //132
		goto 49.0,29.8
		.talk 46591
		..turnin 27754
	step //133
		goto 49.8,29.2
		.talk 48010
		..turnin 27752
	step //134
		goto 49.8,29.3
		.talk 48013
		..turnin 27753
	step //135
		goto 49.8,29.2
		.talk 48010
		..accept 28241
	step //136
		goto 49.1,29.4
		.talk 48174
		..accept 28211
		..accept 28212
		..accept 28215
	step //137
		goto 49.0,29.7
		.talk 49273
		..accept 28216
	step //138
		goto 57.9,33.5
		.' Click the Eye of Twilight |tip It's a purple orb above a spinning metal machine.
		..turnin 28241
		..accept 28242
	step //139
		goto 58.0,32.6
		.kill 10 Shaman of the Black |q 28242/1
		.from Obsidian Stoneslave##47226+
		.get 10 Twisted Elementium Loop |q 28215/1
	step //140
		goto 57.9,33.5
		.' Click the Eye of Twilight |tip It's a purple orb above a spinning metal machine.
		..turnin 28242
		..accept 28243
	step //141
		goto 49.1,29.4
		.talk 48174
		..turnin 28215
	step //142
		goto 49.7,29.2
		.talk 48175
		..turnin 28243
		..accept 28244
	step //143
		goto 49.8,29.1
		.' Click the Eye of Twilight |tip It's a spinning purple orb in a metal stand.
		.' Watch the cutscene
		.' Peered into the Eye |q 28244/1
	step //144
		goto 49.7,29.2
		.talk 48175
		..turnin 28244
	step //145
		goto 42.5,23.5
		.from Magmalord Falthazar##48015
		.get Magmalord Falthazar's Head |q 28216/1
	step //146
		goto 42.2,24.3
		.from Unbound Emberfiend##48016+
		.get 5 Molten Fury |q 28212/1
		.' Click Tempered Spears |tip They look like spears with their points sticking out of the ground around this area.
		.get 8 Tempered Spear |q 28211/1
	step //147
		goto 49.0,29.7
		.talk 49273
		..turnin 28216
	step //148
		goto 49.1,29.4
		.talk 48174
		..turnin 28211
		..turnin 28212
		..accept 28280
	step //149
		goto 49.2,29.8
		.' Use your Shoulder-Mounted Drake-Dropper on Dragonmaw Black Drakes |use Shoulder-Mounted Drake-Dropper##63393 |tip They are flying in the sky around this area.
		.kill 8 Dragonmaw Black Drake |q 28280/1
	step //150
		goto 49.1,29.4
		.talk 48174
		..turnin 28280
	step //151
		goto 49.0,29.7
		.talk 48173
		..accept 28281
	step //152
		goto 48.1,30.0
		.kill 8 Dragonmaw Skyclaw |q 28281/1
	step //153
		goto 49.0,29.7
		.talk 48173
		..turnin 28281
		..accept 28282
	step //154
		goto 49.0,29.7
		.talk 48173
		..' Tell him you're ready to fight him!
		.kill Narkrall Rakeclaw |q 28282/1
	step //155
		goto 49.0,29.7
		.talk 48173
		..turnin 28282
		..accept 28294
	step //156
		goto 54.6,18.0
		.talk 49574
		.home Kirthaven
	step //157
		goto 54.3,16.7
		 .talk 48367
		..turnin 28294
	step //158
		goto 54.9,17.2
		.talk 48365
		..accept 28346
	step //159
		goto 54.4,16.8
		.talk 48364
		..turnin 28346
		..accept 28377
	step //160
		goto 56.8,15.1
		.talk 47155
		.fpath Kirthaven
	step //161
		goto 38.1,34.5
		.talk 48472
		..turnin 28377
		..accept 28378
		..accept 28379
	step //162
		goto 37.6,33.4 |n
		.' Enter the cave |goto 37.6,33.4,0.5 |noway |c
	step //163
		goto 35.0,31.1
		.' Go to this spot inside the cave
		.' Rescue Fanny Thundermar |q 28378/1
	step //164
		goto 37.6,33.4 |n
		.' Leave the cave |goto 37.6,33.4,0.5 |noway |c
	step //165
		goto 38.7,30.9
		.from Glopgut Pounder##48474+, Glopgut Hurler##48475+
		.' Slay 10 Glopgut Ogres |q 28379/1
	step //166
		goto 38.1,34.5
		.talk 48472
		..turnin 28378
		..turnin 28379
		..accept 28407
	step //167
		'Hearth to Kirthaven |goto 54.6,18.0,0.5 |use Hearthstone##6948 |noway |c
	step //168
		goto 54.7,17.9
		.talk 48530
		..turnin 28407
	step //169
		goto 54.6,17.5
		.talk 48366
		..accept 28413
	step //170
		goto 54.6,17.5
		.talk 48366
		..' Tell him you're ready, let's write a song
		.' Create a song |q 28413/1
	step //171
		goto 54.6,17.5
		.talk 48366
		..turnin 28413
	step //172
		goto 54.3,16.7
		.talk 49374
		..accept 28408
		..accept 28409
		..accept 28410
		..accept 28411
	step //173
		goto 53.4,24.5
		.from Highland Elk##46970+, Highland Doe##46971+
		.get 8 Fresh Venison |q 28411/1
		.from Highland Worg##46153+
		.get 5 Worg Rib |q 28411/2
	step //174
		goto 56.8,21.9
		.from Tawny Owl##46162+
		.' Click Pristine Owl Feathers |tip They look like blue feathers on the ground around this mountainous area.
		.get 12 Pristine Owl Feather |q 28408/1
	step //175
		goto 64.4,22.6
		.talk 48758
		..' Tell him you're here to escort a delivery to Kirthaven
		.' Follow the dwarves
		.from Dragonmaw Skirmisher##48799+
		.' Escort the Supply Caravan |q 28409/1
	step //176
		goto 75.1,33.8
		.' Find a zeppelin flying north or south along this coast between Dragonmaw Port and The Krazzworks
		.' Fly onto the zeppelin and land on it
		.' Go downstairs on the zeppelin
		.' Click a Crate of Fine Cloth |tip They look like yellow metal boxes downstairs in the zeppelin.
		.get Fine Dark Cloth |q 28410/1
	step //177
		'Hearth to Kirthaven |goto 54.6,18.0,0.5 |use Hearthstone##6948 |noway |c
	step //178
		goto 54.3,16.7
		.talk 49374
		..turnin 28408
		..turnin 28409
		..turnin 28410
		..turnin 28411
	step //179
		goto 54.3,16.8
		.talk 48368
		..accept 28655
	step //180
		goto 54.3,16.8
		.talk 48368
		..' Tell him to let the wedding commence!
		.' Watch the cutscene
		.from The Beast Unleashed##49234
		.' Complete the Nuptuals |q 28655/1
	step //181
		goto 55.3,17.3
		.talk 49358
		..turnin 28655
	step //182
		goto 55.2,17.3
		.talk 49374
		..accept 27374
	step //183
		goto 44.0,10.6
		.talk 43901
		..turnin 27374
		..accept 27299
	step //184
		goto 41.8,11.4
		.kill 3 Tentacle of Iso'rath |q 27299/1
	step //185
		goto 44.0,10.6
		.talk 45332
		..turnin 27299
		..accept 27300
	step //186
		goto 44.0,11.3
		.talk 45391
		..accept 27301
	step //187
		goto 44.4,11.6
		.talk 45432
		..accept 27302
	step //188
		goto 44.2,18.1
		.talk 45362
		..turnin 27301
		..accept 27303
	step //189
		goto 42.3,17.2
		.from Twilight Captivator##45359+, Twilight Bonebreaker##45334+
		.kill 12 Drakgor cultists |q 27300/1
		.from Bound Fleshburner##45358+
		.get 5 Fleshburner Heart |q 27303/1
		.' Click Barrels of Pyreburn Oil |tip They look like wooden kegs on the ground around this area.
		.get 10 Pyreburn Oil |q 27302/1
	step //190
		goto 44.4,11.6
		.talk 45432
		..turnin 27302
	step //191
		goto 43.8,11.3
		.talk 45386
		..turnin 27303
	step //192
		goto 44.0,10.6
		.talk 45332
		..turnin 27300
		..accept 27376
	step //193
		goto 44.5,10.6
		.' Click an Earthen Ring Gryphon |tip They look like big eagles standing in this spot.
		.' Join the assault on Iso'rath |q 27376/1
	step //194
		goto 48.4,14.6
		.talk 47991
		..turnin 27376
		..accept 27377
	step //195
		'Fight the oozes that attack
		.' Try to fight as long as you can
		.' Survive Iso'rath's defenses |q 27377/1
		.' Click the Quest Complete box that pops up
		..turnin 27377
		..accept 27378
	step //196
		'Deathwing will attack you and Thrall
		.' Aid Thrall in battling Deathwing |q 27378/1
		.' Click the Quest Complete box that pops up
		..turnin 27378
		..accept 27379
	step //197
		goto 49.6,15.8
		.' Stand in the yellow bubbles on the ground around this area to heal |tip Watch the Digestive Acids bar near the bottom oof your screen.  Don't let it get full.  Go into the yellow bubbles to lower it.
		.from Tentacle of Iso'rath##48790
		.' Save Stormcaller Jalara |q 27379/2
	step //198
		goto 49.1,13.1
		.' Stand in the yellow bubbles on the ground around this area to heal |tip Watch the Digestive Acids bar near the bottom oof your screen.  Don't let it get full.  Go into the yellow bubbles to lower it.
		.from Tentacle of Iso'rath##48790
		.' Save Earthmender Duarn |q 27379/3
	step //199
		goto 47.0,13.1
		.' Stand in the yellow bubbles on the ground around this area to heal |tip Watch the Digestive Acids bar near the bottom oof your screen.  Don't let it get full.  Go into the yellow bubbles to lower it.
		.from Tentacle of Iso'rath##48790
		.' Save Hargoth Dimblaze |q 27379/1
	step //200
		goto 47.5,15.6
		.' Stand in the yellow bubbles on the ground around this area to heal |tip Watch the Digestive Acids bar near the bottom oof your screen.  Don't let it get full.  Go into the yellow bubbles to lower it.
		.from Tentacle of Iso'rath##48790
		.' Save Stormcaller Mylra |q 27379/4
	step //201
		goto 48.7,16.6
		.talk 48059
		..turnin 27379
		..accept 27380
	step //202
		goto 48.8,14.9
		.' Stand in the yellow bubbles on the ground around this area to heal |tip Watch the Digestive Acids bar near the bottom oof your screen.  Don't let it get full.  Go into the yellow bubbles to lower it.
		.from Brain of Iso'rath##47960
		.' Kill Iso'rath |q 27380/1
	step //203
		goto 44.0,10.6
		.talk 45332
		..turnin 27380
	step //204
		goto 44.1,10.5
		.talk 48265
		..accept 27485	
	step //205
		goto 27.6,21.4
		.' You will get captured by a red dragon
		.' Meet with Lirastrasza |q 27485/1
	step //206
		goto 29.3,25.9
		.talk 45528
		..turnin 27485
		..accept 27504
	step //207
		goto 29.9,31.3
		.talk 45522
		..turnin 27504
		..accept 27505
	step //208
		goto 29.8,31.4
		.talk 45562
		..accept 27506
	step //209
		goto 29.7,33.1
		.' Protect the Vermillion Menders while they heal Celastrasza to full health
		.' Defend 5 Vermillion Menders |q 27505/1
		.from Twilight Wyrmkiller##45748+
		.' Use your Ruby Seeds on Twilight Wyrmkiller and Vermillion Mender corpses |use Ruby Seeds##61323
		.' Reclaim 6 Dragonkin corpses |q 27506/1
	step //210
		goto 29.9,31.3
		.talk 45522
		..turnin 27505
	step //211
		goto 29.8,31.4
		.talk 45562
		..turnin 27506
	step //212
		goto 29.9,31.3
		.talk 45522
		..accept 27564
	step //213
		goto 29.3,25.9
		.talk 45528
		..turnin 27564
		..accept 27507
		..accept 27509
	step //214
		goto 29.3,26.0
		.talk 45518
		..accept 27508
	step //215
		goto 28.6,24.9
		.talk 47121
		.fpath Vermillion Redoubt
	step //216
		goto 18.4,16.7 |n
		.' Enter the cave |goto 18.4,16.7,0.5 |noway |c
	step //217
		goto 18.0,16.9
		.' Use your Flashgrowth Mote next to the Twilight Portal |use Flashgrowth Mote##61385 |tip It looks like a blue and pink swirled portal in a metal case.
		.' Destroy the Twilight Portal |q 27509/1
	step //218
		goto 20.9,15.7
		.from Twilight Abductor##45642+, Twilight Flamequencher##45618+
		.kill 12 Twilight invaders |q 27507/1
		.' Click Vermillion Eggs |tip They look like brown spiked eggs on the ground around this area.
		.get 6 Vermillion Egg |q 27508/1
	step //219
		goto 29.3,26.0
		.talk 45528
		..turnin 27507
		..turnin 27509
	step //220
		goto 29.3,26.0
		.talk 45518
		..turnin 27508
	step //221
		goto 29.3,26.0
		.talk 45528
		..accept 28101
	step //222
		goto 26.0,38.8
		.talk 47592
		..turnin 28101
		..accept 28103
		..accept 28104
	step //223
		goto 25.6,37.9
		.from Twilight Spearwarder##47490+
		.get Twilight Caravan Cargo Key |q 28104/1
		.' Click a Twilight Caravan Chest |tip They look like boxes with a big purple jewel on top of them, sitting in wagons around this area.
		.get Twilight's Hammer Gatestone |q 28104/2
		.kill 8 Twilight Spearwarder |q 28103/1
	step //224
		goto 26.0,38.8
		.talk 47592
		..turnin 28103
		..turnin 28104
		..accept 28108
	step //225
		'Next to you:
		.talk 47592
		..accept 28107
	step //226
		goto 29.5,51.7
		.' Go to this spot
		.' Open the Dragonmaw Gate |q 28108/1
	step //227
		'Next to you:
		.talk 47592
		..turnin 28108
		..accept 28109
	step //228
		goto 27.5,54.6
		.from Twilight Sentinel##47406+, Twilight Guardsman##47394+, Twilight Stalker##47401+
		.' Kill 30 Wyrm's Bend Cultists |q 28107/1
	step //229
		'Next to you:
		.talk 47592
		..turnin 28107
	step //230
		goto 22.8,56.1
		.' Go to this spot
		.' Secure the Entrance to Grim Batol |q 28109/1
	step //231
		goto 22.1,56.6
		.talk 47605
		..turnin 28109
	step //232
		goto 21.8,57.0
		.talk 47603
		..accept 28712
	step //233
		goto 14.9,16.3
		.talk 49417
		..turnin 28712
	step //234
		goto 14.1,15.4
		.talk 49810
		..accept 28758
	step //235
		goto 14.1,15.1
		.' Click the Vermillion Vanguard |tip It's a red dragon.
		.' Use the abilities on your hotbar on Twilight Shadowdrakes |tip They are blue dragons that fly around in the air in the area you fly to.
		.kill 8 Twilight Shadowdrake |q 28758/1
	step //236
		goto 22.1,56.6
		.talk 47605
		..turnin 28758
		..accept 28171
	step //237
		goto 59.1,69.8
		.talk 47902
		..turnin 28171
		..accept 28191
		..accept 28173
	step //238
		goto 59.0,69.8
		.talk 47904
		..accept 28175
	step //239
		goto 63.9,78.0
		.' Use Alexstrasza's Tear in the small cave beneath this huge tree |use Alexstrasza's Tear##63139
		.' Plant Alexstrasza's Tear |q 28175/1
	step //240
		goto 62.7,76.2
		.from Obsidian Viletongue##47796+, Obsidian Charscale##47797+
		.kill 10 Obsidian Dragonkin |q 28191/1
		.' Use your Wyrmhunter Hooks on Obsidian Pyrewings |use Wyrmhunter Hooks##63092 |tip They are red dragons that fly in the sky around this area.  You will get a message on your screen when the Obsidian Pyrewing is almost dead.  When you see that message, use your Wyrmhunter Hooks on another Obsidian Pyrewing to jump to it.  If you fall, it can hurt you a lot.
		.kill 8 Obsidian Pyrewing |q 28173/1
	step //241
		goto 59.1,69.8
		.talk 47902
		..turnin 28191
		..turnin 28173
	step //242
		goto 59.0,69.8
		.talk 47904
		..turnin 28175
	step //243
		goto 59.1,69.8
		.talk 47902
		..accept 28176
	step //244
		goto 59.3,82.5
		.' Use your Mother's Flame next to the big blue spikes eggs |use Mother's Flame##63126
		.' Hatch the Obsidian Whelps |q 28176/1
	step //245
		goto 55.4,83.5 |n
		.' Enter the cave |goto 55.4,83.5,0.5 |noway |c
	step //246
		goto 49.8,85.8
		.' Go to this spot
		.' Infiltrate the Obsidian Lair |q 28176/2
	step //247
		goto 44.9,91.0
		.talk 47905
		..turnin 28176
		..accept 28247
		.from Obsidia##47929
		.' Defeat Obsidia |q 28247/1
	step //248
		goto 55.4,83.5 |n
		.' Leave the cave |goto 55.4,83.5,0.5 |noway |c
	step //249
		goto 59.1,69.8
		.talk 47902
		..turnin 28247
		..accept 28248
	step //250
		goto 43.4,57.4
		.talk 45668
		..turnin 28248
		..accept 27492
	step //251
		goto 43.4,57.3
		.talk 45669
		..accept 27496
		..accept 27490
	step //252
		goto 43.6,57.2
		.talk 49599
		.home Victor's Point
	step //253
		goto 43.9,57.3
		.talk 47118
		.fpath Victor's Point
	step //254
		goto 43.8,57.2
		.talk 45904
		..' Tell him you're here to lead the Wildhammer squad and drop off the SI:7 agents
		.' Get your Wildhammer Squad |q 27490/1
	step //255
		goto 39.2,64.5
		.' Go to this spot and land on the flashing blue X on the ground
		.' Drop off the SI:7 |q 27490/2
	step //256
		goto 38.8,64.3
		.' Use your Artillery Flare |use Artillery Flare##61363
		.' Target the Northern Building |q 27496/1
	step //257
		goto 40.0,64.4
		.' Use your Artillery Flare |use Artillery Flare##61363
		.' Target the Northeastern Building |q 27496/2
	step //258
		goto 40.4,69.2
		.' Use your Artillery Flare |use Artillery Flare##61363
		.' Target the Southwestern Building |q 27496/3
	step //259
		goto 41.4,71.2
		.' Use your Artillery Flare |use Artillery Flare##61363
		.' Target the Southern Building |q 27496/4
	step //260
		goto 41.1,69.8
		.from Bloodeye Magelord##45795+, Bloodeye Brute##45787+, Twilight Ettin##45838+
		.kill 10 Bloodeye Clan ogres & ettins |q 27492/1
	step //261
		goto 43.4,57.3
		.talk 45669
		..turnin 27496
		..turnin 27490
	step //262
		goto 43.4,57.4
		.talk 45668
		..turnin 27492
		..accept 27494
	step //263
		goto 38.1,66.2
		.' Click the Hidden Explosives |tip It looks like a wooden crate sitting up on this hill.
		.' Detonate the Hidden Explosives |q 27494/1
		.' Click the Quest Complete box that pops up
		..turnin 27494
		..accept 27498
	step //264
		goto 40.5,62.3
		.' Use your Attack Signal at the top of this tower |use Attack Signal##61511
		.' Signal the Attack |q 27498/1
		.' Click the Quest Complete box that pops up
		..turnin 27498
		..accept 27500
	step //265
		goto 39.8,71.3 |n
		.' Enter the cave |goto 39.8,71.3,0.5 |noway |c
	step //266
		goto 37.6,71.3
		.from Za'brox##46017
		.get Za's Head |q 27500/1
		.get Brox's Head |q 27500/4
	step //267
		goto 38.7,70.2
		.from Beeble'phod##46018
		.get Phod's Head |q 27500/2
		.get Beeble's Head |q 27500/3
	step //268
		'Hearth to Victor's Point |goto 43.6,57.3,0.5 |use Hearthstone##6948 |noway |c
	step //269
		goto 43.4,57.3
		.talk 45669
		..turnin 27500
		..accept 27502
	step //270
		goto 38.9,64.0
		.talk 46076
		..' Tell him you're ready
		.' Speak to the Squad commander |q 27502/1
	step //271
		'Follow the SI:7 Squad Commander and the SI:7 Agents up the path
		.' Escort the SI:7 |q 27502/2
		.' Click the Quest Complete box that pops up
		..turnin 27502
		..accept 27636
	step //272
		goto 36.4,66.0
		.talk 45796
		..turnin 27636
		..accept 27652
		..accept 27654
		..accept 27657
	step //273
		goto 37.5,88.7
		.talk 46242
		..turnin 27657
		..accept 27659
		..accept 27660
	step //274
		goto 37.6,88.7
		.talk 46243
		..accept 27662
	step //275
		goto 44.1,81.4
		.' Click the Air Portal Controller |tip It looks like metal canister sitting on the ground up on this floating island.
		.kill Debilitated Aetharon |q 27659/2
	step //276
		goto 38.0,80.2
		.' Click the Earth Portal Controller |tip It looks like metal canister sitting on the ground.
		.kill Debilitated Apexar |q 27659/1
	step //277
		goto 33.2,62.4
		.' Click the Water Portal Controller |tip It looks like metal canister sitting on the ground.
		.kill Debilitated Edemantus |q 27659/3
	step //278
		goto 27.6,63.9
		.talk 46413
		..turnin 27660
		..accept 27661
	step //279
		goto 35.2,67.4
		.from Corrupted Elementalist##46204+, Citadel Veteran##46205+, Twilight Vindicator##46203+
		.kill 10 Twilight Citadel cultists |q 27654/1
		.from Dark Assassin##46202+ |tip They look like black shades that wander around this whole area.  They are much less common than the other enemies, so you will probably have to fly around this whole area and look for them.
		.get 5 Dark Assassin's Pendant |q 27652/1
		.from Enslaved Tempest##46328+, Enslaved Waterspout##46329+, Enslaved Inferno##46327+
		.' Free 10 Enslaved Elementals |q 27662/1
	step //280
		goto 40.8,79.0
		.kill Lord Cannon |q 27661/1
	step //281
		goto 37.6,88.7
		.talk 46243
		..turnin 27662
	step //282
		goto 37.5,88.7
		.talk 46242
		..turnin 27659
	step //283
		goto 36.4,66.0
		.talk 45796
		..turnin 27652
		..turnin 27654
		..accept 27688
		..accept 27695
	step //284
		goto 27.6,63.9
		.talk 46413
		..turnin 27661
		..accept 27719
	step //285
		goto 35.1,61.1
		.' Use your Water of Life next to the Corpse of Forgemaster Finlay |use Water of Life##62503 |tip He's chained to an ancor, drowned underwater.
		.' Extract Artifact Information |q 27719/1
	step //286
		goto 36.4,66.0
		.talk 45796
		..turnin 27719
	step //287
		goto 36.1,70.7
		.kill Master Klem |q 27688/2 |tip Mathias Shaw will come and kill him for you after you've fought him for a little bit.
	step //288
		goto 40.2,84.0
		.from Blindeye the Guardian##46399
		.get The Elementium Axe |q 27695/1
	step //289
		goto 42.3,83.5
		.kill Mia the Rose |q 27688/3 |tip She's in a small room at the top of this big building.  Mathias Shaw will come and kill her for you after you've fought her for a little bit.
	step //290
		goto 43.4,88.5
		.kill Dame Alys Finnsson |q 27688/1 |tip Mathias Shaw will come and kill her for you after you've fought her for a little bit.
	step //291
		goto 36.4,66.0
		.talk 45796
		..turnin 27688
		..turnin 27695
		..accept 27700
	step //292
		goto 32.4,68.7
		.' Use The Elementium Axe |use The Elementium Axe##62248
		.' Free Lirastrasza |q 27700/1
	step //293
		goto 36.4,66.0
		.talk 45796
		..turnin 27700
		..accept 27702
	step //294
		goto 37.5,75.4
		.from Twilight Skyterror##46416+ |tip They look like blue dragons laying on the ground all around this area.  You will need to fly around and search for them, as there aren't many of them at one time.  Watch Lirastrasza in the sky and you will see the blue dragons fall, so you can immediately fly to them to make it easier.
		.' Deliver 5 Coup de Graces |q 27702/1
	step //295
		goto 36.4,66.0
		.talk 45796
		..turnin 27702
		..accept 27711
	step //296
		goto 37.5,88.7
		.talk 46243
		..turnin 27711
		..accept 27720
	step //297
		goto 37.5,88.7
		.talk 46243
		..' Tell him you're ready for that wild ride
		.' Ride the Mine Cart to the End of the Line |q 27720/2
	step //298
		'Next to you:
		.talk 46513
		..turnin 27720
		..accept 27742
		..accept 27743
	step //299
		goto 37.4,93.2
		.' Click Elementium Shards and get them as you walk |tip They look like small piles of flat rocks on the ground inside this cave.
		.' Click the Twilight Rune of Earth |tip It looks like a pink symbol on the ground.
		..accept 27744
	step //300
		goto 35.2,90.4
		.' Click Elementium Shards and get them as you walk |tip They look like small piles of flat rocks on the ground inside this cave.
		.' Click the Twilight Rune of Water |tip It looks like a pink symbol on the ground.
		.' Destroy the Rune of Water |q 27744/2
	step //301
		goto 33.5,88.4
		.' Click Elementium Shards and get them as you walk |tip They look like small piles of flat rocks on the ground inside this cave.
		.' Click the Twilight Rune of Air |tip It looks like a pink symbol on the ground.
		.' Destroy the Rune of Air |q 27744/3
	step //302
		goto 34.3,86.6
		.' Click Elementium Shards and get them as you walk |tip They look like small piles of flat rocks on the ground inside this cave.
		.' Click the Twilight Rune of Fire |tip It looks like a pink symbol on the ground.
		.' Destroy the Rune of Fire |q 27744/4
	step //303
		goto 34.5,86.3
		.from Twilight Miner##46610+, Depths Overseer##46579+
		.kill 12 Elementium Depths cultists |q 27743/1
		.' Click Elementium Shards |tip They look like small piles of flat rocks on the ground inside this cave.  You can also kill Elementium Spinner to get Elementium Shards.
		.get 6 Elementium Shard |q 27742/1
	step //304
		'Next to you:
		.talk 46513
		..turnin 27742
		..turnin 27743
		..turnin 27744
		..accept 27745
	step //305
		goto 36.4,83.8
		.from Magmatooth##46611
		.get Fire Portal Controller |q 27745/2
		.' Use your Fire Portal Controller |use Fire Portal Controller##62394
		.' Use the Fire Portal Controller at the Fire Portal |q 27745/1
	step //306
		goto 37.5,88.7
		.talk 46243
		..turnin 27745
		..accept 27782
	step //307
		goto 36.4,66.0
		.talk 45796
		..turnin 27782
		..accept 27784
	step //308
		goto 45.4,88.0
		.' Click The Hammer of Twilight |tip It's a huge hammer floating in a beam of blue light on this high platform.
		..turnin 27784
		..accept 27787
		.' Watch the cutscene
		.' Survive Skullcrusher's Backhand |q 27787/1
	step //309
		goto 45.4,87.9
		.kill Skullcrusher the Mountain |q 27787/2 |tip Follow the instructions that pop up on your screen.  Click the altars surrounding the fight, you will gain buffs from them to help you fight.  The altars are stone blocks with candles on them.  Click Warlord Zaela when she becomes unconscious.  You will see a green arrow bouncing above her when you need to click her.  Eventually, she will fall to the ground near the end of the fight.  Click her body to play the drums she drops to call reinforcements to help finish the fight.
	step //310
		'Hearth to Victor's Point |goto 43.6,57.3,0.5 |use Hearthstone##6948 |noway |c
	step //311
		goto 43.4,57.4
		.talk 45668
		..turnin 27787
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Twilight Highlands\\Thundermar Dailies",[[
	description Walks you through completing the
	description daily quests in the Thundermar 
	description region of Twilight Highlands.
	author support@zygorguides.com
	daily
	step //1
		goto Twilight Highlands,48.6,30.7
		.talk 49386
		..accept 28863 |daily |tip This is a 2-person group quest.
	step //2
		goto 49.0,29.8
		.talk 46591
		..accept 28860 |daily
		..accept 28864 |daily
	step //3
		goto 49.8,29.2
		.talk 48010
		..accept 28861 |daily
		..accept 28862 |daily
	step //4
		goto 46.2,37.4
		.from Dragonmaw Marauder##46310+
		.get 8 Dragonmaw Insignia |q 28860/1
		.' Click Thundermar Ale Kegs |tip They look like wooden barrels on the ground around this area.
		.get 10 Wildhammer Keg |q 28861/1
		.' Click Wildhammer Food Stores |tip They look like hanging fish, sliced bread, and legs of meat on the ground around this area.
		.get 10 Wildhammer Food Stores |q 28862/1
		.' You can find more around 49.1,37.3
	step //5
		goto 49.0,37.3
		.kill Warlord Halthar |q 28863/1 |tip He flies around on a red drake in the sky, but he lands in this spot to start fighting.  He is elite, and this is marked as a 2-person group quest, so you may need help killing him.
	step //6
		goto 64.4,22.6
		.talk 48758
		..' Tell him you're here to escort a delivery to Kirthaven
		.' Follow the dwarves
		.from Dragonmaw Skirmisher##48799+
		.' Escort the Supply Caravan |q 28864/1
	step //7
		goto 49.8,29.2
		.talk 48010
		..turnin 28861
		..turnin 28862
	step //8
		goto 49.0,29.8
		.talk 46591
		..turnin 28860
		..turnin 28864
	step //9
		goto 48.6,30.7
		.talk 49386
		..turnin 28863
]])



ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Tol Barad Peninsula\\Baradin Base Camp Dailies",[[
	description Walks you through completing the
	description daily quests in the Baradin Base
	description Camp region of Tol Barad Peninsula.
	author support@zygorguides.com
	daily
	step //1
		goto Stormwind City,73.2,18.4
		.' Click the Portal to Tol Barad |tip It looks like a small white glowing portal.
		.' Teleport to Tol Barad |goto Tol Barad Peninsula |noway |c
	step //2
		'You will only be able to accept a total of 6 quests in the following guide steps.
		.' Skip to the next step in the guide
	step //3
		goto Tol Barad Peninsula,72.9,60.9
		.talk 48254
		..accept 28275 |daily
		..accept 27987 |daily
		..accept 27978 |daily
		..accept 27991 |daily
		..accept 27975 |daily
		..accept 27973 |daily
	step //4
		goto 73.4,59.2
		.talk 47240
		..accept 28059 |daily
		..accept 28063 |daily
		..accept 28130 |daily
		..accept 28137 |daily
		..accept 28065 |daily
	step //5
		goto 73.7,57.6
		.talk 48255
		..accept 27948 |daily
		..accept 27972 |daily
		..accept 27970 |daily
		..accept 27971 |daily
		..accept 28050 |daily
		..accept 27944 |daily
	step //6
		goto 74.8,59.6
		.talk 48250
		..accept 28046 |daily
		..accept 27967 |daily
		..accept 27992 |daily
		..accept 27966 |daily
		..accept 27949 |daily
	step //7
		goto 74.3,42.8 |n
		.' Follow the path up |goto 74.3,42.8,0.5 |noway |c
	step //8
		goto 78.6,42.0
		.kill Commander Largo |q 27991/1 |tip He's at the top of the tower.
	step //9
		goto 78.2,49.0
		.from Overlook Spectre##47182+, Ghastly Worker##47183+, Overlook Spirit##47181+, Cursed Stallion##46645+
		.' Slay 14 Largo's Overlook Ghosts |q 27978/1
		.' Click Stacks of Cannonballs |tip They look like piles of cannonballs shaped like pyramids on the ground around this area.
		.get 4 Stack of Cannonballs |q 27987/1
	step //10
		goto 69.3,23.1
		.' Click Strings of Fish |tip They look like small fish hanging from simple wooden structures on the docks around this area.
		.get 22 Rustberg Seabass |q 28137/1
	step //11
		goto 67.6,37.1
		.from Suspicious Villager##47657+, Apprehensive Worker##47659+, Rustberg Bandit##47627+
		.kill 14 Rustberg Village Residents |q 28130/1
	step //12
		goto 54.2,47.0
		.kill 12 Darkwood Lurker |q 27944/1
		.from Darkwood Broodmother##46507+
		.get 4 Sticky Silk Gland |q 27948/1
	step //13
		goto 47.9,8.1
		.kill Captain P. Harris |q 27970/1 |tip He's walking around on this broken boat.
	step //14
		goto 49.4,19.8
		.kill Tank |q 28050/1 |tip He's an elite shark that swims in the water around this area.  This is a group quest, so you will probably need help.
		.' Click Barrels of Southsea Rum |tip They look like barrels underwater around this area.
		.get 6 Barrel of Southsea Rum |q 27972/1
	step //15
		goto 49.0,29.4
		.kill 8 Shipwrecked Sailor |q 27971/1
	step //16
		goto 36.1,27.3
		.kill Keep Lord Farson |q 28059/1 |tip He's upstairs in the fort.
	step //17
		goto 37.8,29.1
		.talk 48308
		..' Tell you're here to help him escape
		.' Escort the Farson Prisoner |q 28065/1 |tip Follow the Farson Hold Prisoner and protect him.
	step //18
		goto 41.2,35.8
		.' Click Racks of Rifles |tip They look like wooden stands with guns on them around this area.
		.get 12 Rusty Rifle |q 28063/1
	step //19
		goto 27.2,47.7
		.kill Foreman Wellson |q 27975/1
	step //20
		goto 22.2,36.3
		.' Click a Cannon |tip They look like black cannons on this small dock.
		.' Shoot the boats
		.' Destroy 10 Wellson Supply Boats |q 28275/1
	step //21
		goto 30.1,43.9
		.from Ghastly Dockhand##46641+, Accursed Longshoreman##46630+, Accursed Shipbuilder##46643+
		.get 15 Shipyard Lumber |q 27973/1
	step //22
		goto 40.2,57.9
		.kill 5 Restless Infantry |q 28046/1
		.' Use your Magnatized Scrap Collector |use Magnatized Scrap Collector##62829
		.' Click Siege Scraps |tip They look like metal objects on the ground that appear after your use your Magnatized Scrap Collector.
		.get 7 Siege Engine Scrap |q 27992/1
	step //23
		goto 38.4,77.6
		.kill First Lieutenant Connor |q 27967/1 |tip He's a big skeleton that walks around this area, so you may need to search for him.
	step //24
		goto 38.1,71.5
		.from Wandering Soul##46586+, Forgotten Ghoul##46569+
		.get 9 Cursed Femur |q 27966/1
		.' Click Forgotten Soldier's Tombstones |tip They look like taller and slimmer gravestones around this area.
		.' Release 6 Tortured Souls |q 27949/1
	step //25
		goto 72.9,60.9
		.talk 48254
		..turnin 28275
		..turnin 27987
		..turnin 27978
		..turnin 27991
		..turnin 27975
		..turnin 27973
	step //26
		goto 73.4,59.2
		.talk 47240
		..turnin 28059
		..turnin 28063
		..turnin 28130
		..turnin 28137
		..turnin 28065
	step //27
		goto 73.7,57.6
		.talk 48255
		..turnin 27948
		..turnin 27972
		..turnin 27970
		..turnin 27971
		..turnin 28050
		..turnin 27944
	step //28
		goto 74.8,59.6
		.talk 48250
		..turnin 28046
		..turnin 27967
		..turnin 27992
		..turnin 27966
		..turnin 27949
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Tol Barad \\Baradin Hold Dailies",[[
	description Walks you through completing the
	description daily quests in the Baradin Hold
	description region of Tol Barad.
	author support@zygorguides.com
	daily
	step //1
		'These daily quests will only be available if the Alliance faction currently controls Tol Barad.
		.' Skip to the next step in the guide
	step //2
		'You will only be able to accept a total of 6 quests in the following guide steps.
		.' Skip to the next step in the guide
	step //3
		goto Tol Barad,50.9,49.7
		.talk 48066
		..accept 28122 |daily
		..accept 28162 |daily
		..accept 28163 |daily
	step //4
		goto 51.4,49.6
		.talk 48061
		..accept 28165 |daily
		..accept 28185 |daily
		..accept 28186 |daily
	step //5
		goto 51.5,49.5
		.talk 48039
		..accept 28117 |daily
		..accept 28120 |daily
		..accept 28118 |daily
	step //6
		goto 51.5,49.6
		.talk 48074
		..accept 28232 |daily
		..accept 28188 |daily
		..accept 28223 |daily
	step //7
		goto 42.7,39.1 |n
		.' Enter the underground jail |goto 42.7,39.1,0.5 |noway |c
	step //8
		goto 48.3,30.7
		.from Svarnos##47544+
		.get Svarnos' Cursed Collar |q 28185/1
	step //9
		goto 44.4,30.5
		.from Imprisoned Imp##47549+, Cell Watcher##47542+, Shivan Destroyer##47540+, Jailed Wrathguard##47548+
		.' Slay 10 Demons |q 28165/1
		.' Click Cursed Shackles |tip They look like gray metal ball and chains laying on the ground all around this area.
		.get 8 Cursed Shackles |q 28186/1
	step //10
		goto 42.1,41.8
		.from Baradin Crocolisk##47591+
		.get 8 Crocolisk Hide |q 28162/1
	step //11
		goto 44.0,69.2 |n
		.' Enter the underground jail |goto 44.0,69.2,0.5 |noway |c
	step //12
		goto 37.5,71.7
		.from Warden Silva##48036
		.get Warden's Keys |q 28223/1
	step //13
		goto 40.9,78.2
		.from Imprisoned Worker##47550+, Exiled Mage##47552+
		.' Slay 10 Prisoners |q 28188/1
		.' Click Crates of Cellblock Rations |tip They look like slim square wooden boxes on the ground around this area.
		.get 12 Cellblock Ration |q 28232/1
	step //14
		goto 60.8,50.1 |n
		.' Enter the underground jail |goto 60.8,50.1,0.5 |noway |c
	step //15
		goto 56.8,54.8
		.from Archmage Galus##47537
		.get Archmage Galus' Staff |q 28118/1
	step //16
		goto 51.4, 49.5
		.from Captive Spirit##47531+, Ghastly Convict##47590+
		.' Slay 9 Ghosts |q 28117/1
		.' Click Dusty Prison Journals |tip They are books laying on the ground around this area.
		.get 4 Dusty Prison Journal |q 28120/1
	step //17
		goto 51.1,29.7
		.from Horde Mage Infantry##47608+, Horde Shaman Infantry##47610+, Horde Rogue Infantry##47609+, Horde Druid Infantry##47607+
		.kill 12 Horde Infantry |q 28163/1
	step //18
		goto 52.8,36.7
		.kill Problim |q 28122/1 |tip He's a tall ogre that walks along the road that surrounds Baradin Hold, so you may need to search for him.  He's elite, and the quest is a group quest, so you may need help killing him.
	step //19
		goto Tol Barad,50.9,49.7
		.talk 48066
		..turnin 28122
		..turnin 28162
		..turnin 28163
	step //20
		goto 51.4,49.6
		.talk 48061
		..turnin 28165
		..turnin 28185
		..turnin 28186
	step //21
		goto 51.5,49.5
		.talk 48039
		..turnin 28117
		..turnin 28120
		..turnin 28118
	step //22
		goto 51.5,49.6
		.talk 48074
		..turnin 28232
		..turnin 28188
		..turnin 28223
]])



ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Reputation\\Guardians of Hyjal",[[
	description Walks you through the process
	description of obtaining Exalted reputation
	description with the Guardians of Hyjal 
	description faction.
	author support@zygorguides.com
	step //1
		map Mount Hyjal
		'To gain reputation with the Guardians of Hyjal faction:
		.' Complete all quests in the Mount Hyjal zone
		.' Once you earn Friendly reputation with the Guardians of Hyjal faction, you can buy the Tabard of the Guardians of Hyjal. |tip Wear the Tabard of the Guardians of Hyjal and use the Dungeon Finder tool to complete random Cataclysm Heroics.  You will gain reputation with the Guardians of Hyjal faction for each mob you kill inside the dungeon, so you can gain reputation very quickly doing this.
		..' You can buy the Tabard of the Guardians of Hyjal by talking to Provisioner Whitecloud in Mount Hyjal at 62.8,23.9
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Reputation\\The Earthen Ring",[[
	description Walks you through the process
	description of obtaining Exalted reputation
	description with The Earthen Ring faction.
	author support@zygorguides.com
	step //1
		map Shimmering Expanse
		'To gain reputation with The Earthen Ring faction:
		.' Complete all quests in the Vashj'ir zone
		.' Complete the Deepholm Pre-Quests guide in the Deepholm section.
		.' Complete the Twilight Highlands Pre-Quests guide in the Twilight Highlands section.
		.' Once you earn Friendly reputation with The Earthen Ring faction, you can buy the Tabard of the Earthen Ring. |tip Wear the Tabard of the Earthen Ring and use the Dungeon Finder tool to complete random Cataclysm Heroics.  You will gain reputation with The Earthen Ring faction for each mob you kill inside the dungeon, so you can gain reputation very quickly doing this.
		..' You can buy the Tabard of the Earthen Ring by talking to Provisioner Arok in the Shimmering Expanse at 49.1,42.2
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Reputation\\Therazane",[[
	description Walks you through the process
	description of obtaining Exalted reputation
	description with the Therazane faction.
	author support@zygorguides.com
	step //1
		map Deepholm
		'To gain reputation with the Therazane faction:
		.' Complete the Deepholm Pre-Quests guide in the Deepholm section.
		.' Complete the Therazane's Throne Dailies guide section in the Deepholm section. |tip Do this daily, if you'd like.
		.' Once you earn Friendly reputation with the Therazane faction, you can buy the Tabard of Therazane. |tip Wear the Tabard of Therazane and use the Dungeon Finder tool to complete random Cataclysm Heroics.  You will gain reputation with the Therazane faction for each mob you kill inside the dungeon, so you can gain reputation very quickly doing this.
		..' You can buy the Tabard of Therazane by talking to D'lom the Collector in Deepholm at 54.1,33.3
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Reputation\\Ramkahen",[[
	description Walks you through the process
	description of obtaining Exalted reputation
	description with the Ramkahen faction.
	author support@zygorguides.com
	step //1
		map Uldum
		'To gain reputation with the Ramkahen faction:
		.' Complete the Uldum Pre-Quests guide in the Uldum section.
		.' Complete the Tahret Grounds Dailies guide in the Uldum section. |tip Do this daily, if you'd like.
		.' Once you earn Friendly reputation with the Ramkahen faction, you can buy the Tabard of Ramkahen. |tip Wear the Tabard of Ramkahen and use the Dungeon Finder tool to complete random Cataclysm Heroics.  You will gain reputation with the Ramkahen faction for each mob you kill inside the dungeon, so you can gain reputation very quickly doing this.
		..' You can buy the Tabard of Ramkahen by talking to Blacksmith Abasi in Uldum at 54.1,33.3
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Reputation\\Wildhammer Clan",[[
	description Walks you through the process
	description of obtaining Exalted reputation
	description with the Wildhammer Clan faction.
	author support@zygorguides.com
	step //1
		map Twilight Highlands
		'To gain reputation with the Wildhammer Clan faction:
		.' Complete the Twilight Highlands Pre-Quests guide in the Twilight Highlands section.
		.' Complete the Thundermar Dailies guide in the Twilight Highlands section. |tip Do this daily, if you'd like.
		.' Once you earn Friendly reputation with the Wildhammer Clan faction, you can buy the Tabard of the Wildhammer Clan. |tip Wear the Tabard of the Wildhammer Clan and use the Dungeon Finder tool to complete random Cataclysm Heroics.  You will gain reputation with the Wildhammer Clan faction for each mob you kill inside the dungeon, so you can gain reputation very quickly doing this.
		..' You can buy the Tabard of the Wildhammer Clan by talking to Craw MacGraw in Twilight Highlands at 48.6,30.7
]])
ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Reputation\\Baradin's Wardens",[[
	description Walks you through the process
	description of obtaining Exalted reputation
	description with the Baradin's Wardens faction.
	author support@zygorguides.com
	step //1
		map Tol Barad Peninsula
		'To gain reputation with the Baradin's Wardens faction:
		.' Complete the Baradin Base Camp Dailies guide in the Tol Barad Peninsula section. |tip Do this daily, if you'd like.
		.' Complete the Baradin Hold Dailies guide in the Tol Barad section. |tip Do this daily, if you'd like.  The daily quests in this section will only be available if the Alliance faction currently controls Tol Barad.
		.' Once you earn Friendly reputation with the Baradin's Wardens faction, you can buy Baradin's Wardens Commendations from Quartermaster Brazie at 72.4,63.2 |tip They cost 10 Tol Barad Commendations each and you can use the Baradin's Wardens Commendations to increase your Baradin's Wardens reputation by 250.
]])



ZygorGuidesViewer:RegisterGuide("Zygor's Alliance Dailies Guides\\Cataclysm (80 - 85)\\Zandalari Menace Quest Line",[[
	description Walks you through completing
	description the Zandalari Menace quest line
	description in Stranglethorn Vale.
	description 
	description You must be level 85 to be
	description able to use this guide.
	author support@zygorguides.com
	startlevel 85
	step //1
		goto Stormwind City,25.9,29.3
		.talk 52654
		..accept 29100
		..accept 29102
	step //2
		goto 70.9,72.5
		.talk 352
		.' Fly to Fort Livingston, Stranglethorn Vale |goto Northern Stranglethorn,52.6,66.3,0.5 |noway |c
	step //3
		goto Northern Stranglethorn,52.8,66.4
		.talk 52281
		..turnin 29102
		..accept 29103
	step //4
		goto 52.0,61.4
		.kill 10 Jungle Serpent |q 29103/1
		.' Click Fort Livingston Adventurers |tip They look like green bodies laying on the ground around this area.
		.' Heal 10 Adventurers |q 29103/2
	step //5
		goto 52.8,66.4
		.talk 52281
		..turnin 29103
	step //6
		'Next to you:
		.talk 52234
		..accept 29104
	step //7
		goto 52.9,66.5
		.' Click the Bonfire |tip It's a big pile of sticks on fire in the middle of Fort Livingston.
		.' Watch the dialogue
		.' Use the Bonfire in Fort Livingston |q 29104/1
	step //8
		'Next to you:
		.talk 52234
		..turnin 29104
	step //9
		goto 52.8,66.4
		.talk 52281
		..accept 29105
	step //10
		goto 44.1,22.9
		.talk 52294
		..turnin 29105
		..accept 29114
	step //11
		goto 50.4,21.7
		.talk 52346
		..turnin 29114
		..accept 29115
	step //12
		goto 64.0,19.6
		.from Mauti?##52349
		.' Bring Grent Direhammer to the body of Mauti |q 29115/1
	step //13
		'Click the Complete Quest box that appears under you minimap
		..turnin 29115
		.' You will automatically accept a new quest:
		..accept 29116
	step //14
		goto 77.7,68.4
		.' Go to this spot
		.' Find Mauti's Lair |q 29116/1
	step //15
		'Next to you:
		.talk 52234
		..turnin 29116
		..accept 29120
	step //16
		goto 77.2,69.0
		.from Mauti##52372
		.' Let Bwemba Inspect the Cat |q 29120/1
	step //17
		'Next to you:
		.talk 52234
		..turnin 29120
		..accept 29213
	step //18
		goto 76.5,67.5 |n
		.' Enter the cave |goto 76.5,67.5,0.5 |noway |c
	step //19
		goto 76.1,66.7
		.talk 52371
		..turnin 29213
		..accept 29121
	step //20
		goto 76.0,66.5
		.' Click Direhammer's Boots |tip They look like a small pair of brown boots sitting on the ground inside this cave.
		.get Direhammer's Boots |q 29121/1
	step //21
		goto 76.1,66.7
		.talk 52371
		..turnin 29121
	step //22
		goto 76.1,66.7
		.talk 52374
		..accept 29267 |instant
	step //23
		'Next to you:
		.talk 52234
		..accept 29124
	step //24
		goto 76.5,67.5 |n
		.' Leave the cave |goto 76.5,67.5,0.5 |noway |c
	step //25
		goto 47.8,12.0
		.talk 52410
		..turnin 29124
		..accept 29131
	step //26
		goto 47.5,11.4
		.from Gurubashi War-Seeker##53165+, Gurubashi Bloodfury##52406+, Gurubashi Soul-Seeker##53166+ |tip Once the bar fills up at the bottom of your screen, you will complete the quest.
		.' Help Defend the Camp |q 29131/1
	step //27
		goto 47.8,12.0
		.talk 52410
		..turnin 29131
	step //28
		goto 47.9,11.9
		.talk 52753
		..accept 29133
	step //29
		goto 47.9,11.9
		.talk 52753
		..' Ask him if one of his gryphons can get you to the Digsite
		.' You will fly to the Explorers' League Digsite
		.' Arrive at the Digsite |q 29133/1
	step //30
		'Next to you:
		.talk 52234
		..turnin 29133
		..accept 29150
	step //31
		goto The Cape of Stranglethorn,54.0,42.6
		.from Digsite Zombie##52604+
		.' Rescue 10 Digsite Survivors |q 29150/1 |tip You may not rescue every zombie you kill.
	step //32
		'Next to you:
		.talk 52234
		..turnin 29150
		..accept 29151
	step //33
		goto 55.0,42.0
		.' Click the Grain Sack |tip It looks like a yellow bag sitting on the ground next to a big pile of barrels and crates.
		.' Watch the dialogue
		.' Search the Supplies |q 29151/1
	step //34
		'Next to you:
		.talk 52234
		..turnin 29151
	step //35
		goto 55.3,42.0
		.talk 52646
		..accept 29152
	step //36
		goto 44.9,65.9 |n
		.' Enter the tunnel |goto 44.9,65.9,0.5 |noway |c
	step //37
		goto 41.0,73.1
		.talk 52767
		..turnin 29152
	step //38
		goto 41.2,73.0
		.' Go to this spot
		.' Watch the dialogue
		.' Help Bwemba Find the Darkspear Emissary |q 29100/1
	step //39
		'Next to you:
		.talk 52234
		..turnin 29100
	step //40
		'To continue with the Zul'Gurub dungeon quest line:
		goto 41.2,73.1
		.talk 2496
		..accept 29153
]])
