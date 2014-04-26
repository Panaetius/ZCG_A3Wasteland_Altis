//	@file Version: 1.1
//	@file Name: serverVars.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [404] Pulse, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Created: 20/11/2012 05:19
//	@file Args:

if (!isServer) exitWith {};

diag_log "WASTELAND SERVER - Initializing Server Vars";

pvar_teamSwitchList = [];
publicVariable "pvar_teamSwitchList";
pvar_teamKillList = [];
publicVariable "pvar_teamKillList";
pvar_spawn_beacons = [];
publicVariable "pvar_spawn_beacons";
clientMissionMarkers = [];
publicVariable "clientMissionMarkers";
clientRadarMarkers = [];
publicVariable "clientRadarMarkers";
currentDate = [];
publicVariable "currentDate";
currentInvites = [];
publicVariable "currentInvites";

"PlayerCDeath" addPublicVariableEventHandler { [_this select 1] spawn server_playerDied };

currentStaticHelis = []; // Storage for the heli marker numbers so that we don't spawn wrecks on top of live helis

//Civilian Vehicle List - Random Spawns
civilianVehicles =
[
	"C_Quadbike_01_F",
	"C_Hatchback_01_F",
	"C_Hatchback_01_sport_F",
	"C_SUV_01_F",
	"C_Offroad_01_F",
	"I_G_Offroad_01_F",
	"C_Van_01_box_F"
];

//Light Military Vehicle List - Random Spawns
lightMilitaryVehicles =
[
	"B_Quadbike_01_F",
	"O_Quadbike_01_F",
	"I_Quadbike_01_F",
	"I_G_Quadbike_01_F",
	"O_Truck_02_covered_F",
	"I_Truck_02_covered_F",
	"O_Truck_02_transport_F",
	"I_Truck_02_transport_F",
	"I_Truck_02_Fuel_F",
	"O_Truck_02_Fuel_F",
	"I_Truck_02_medical_F",
	"O_Truck_02_medical_F",
	"O_Truck_03_fuel_F",
	"O_Truck_03_ammo_F",
	"O_Truck_03_medical_F"
];

//Medium Military Vehicle List - Random Spawns
mediumMilitaryVehicles = 
[
	"I_G_Offroad_01_armed_F",
	"B_MRAP_01_F",
	"O_MRAP_02_F",
	"I_MRAP_03_F"
];

//Water Vehicles - Random Spawns
waterVehicles =
[
//	"B_Lifeboat",
//	"O_Lifeboat",
//	"C_Rubberboat",
//	"B_SDV_01_F",
//	"O_SDV_01_F",
//	"I_SDV_01_F",
//	"B_Boat_Transport_01_F",
//	"O_Boat_Transport_01_F",
//	"I_Boat_Transport_01_F",
//	"I_G_Boat_Transport_01_F",
	"B_Boat_Armed_01_minigun_F",
	"O_Boat_Armed_01_hmg_F",
	"I_Boat_Armed_01_minigun_F",
	"C_Boat_Civil_01_F",
	"C_Boat_Civil_01_police_F",
	"C_Boat_Civil_01_rescue_F"
];

//Object List - Random Spawns.
objectList =
[
	"Box_NATO_Wps_F",
	"Box_NATO_WpsLaunch_F",
	"Box_NATO_WpsSpecial_F",
	"B_supplyCrate_F",
	"Box_NATO_Support_F",
	"Box_IND_Wps_F",
	"Box_IND_WpsLaunch_F",
	"Box_IND_WpsSpecial_F",
	"I_supplyCrate_F",
	"Box_IND_Support_F", 
	"Box_EAST_Wps_F",
	"Box_EAST_WpsLaunch_F",
	"Box_EAST_WpsSpecial_F",
	"O_supplyCrate_F",
	"Box_EAST_Support_F",
	"CamoNet_INDP_open_F",
	"CamoNet_INDP_big_F",
	"Land_BagBunker_Large_F",
	"Land_BagBunker_Large_F",
	"Land_BagBunker_Small_F",
	"Land_BagBunker_Small_F",
	"Land_BagBunker_Tower_F",
	"Land_BagBunker_Tower_F",
	"Land_BarGate_F",
	"Land_Canal_Wall_Stairs_F",
	"Land_Canal_WallSmall_10m_F",
	"Land_Canal_WallSmall_10m_F",
	"Land_CncBarrierMedium4_F",
	"Land_CncShelter_F",
	"Land_CncWall4_F",
	"Land_HBarrier_1_F",
	"Land_HBarrier_3_F",
	"Land_HBarrier_5_F",
	"Land_HBarrier_5_F",
	"Land_HBarrier_5_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierBig_F",
	"Land_HBarrierTower_F",
	"Land_HBarrierWall4_F",
	"Land_HBarrierWall4_F",
	"Land_HBarrierWall6_F",
	"Land_HBarrierWall6_F",
	"Land_MetalBarrel_F",
	"Land_Mil_ConcreteWall_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Mil_WallBig_4m_F",
	"Land_Pipes_large_F",
	"Land_RampConcrete_F",
	"Land_RampConcreteHigh_F",
	"Land_Sacks_goods_F",
	"Land_Shoot_House_Wall_F",
	"Land_BarrelWater_F"
];

//Object List - Random Spawns.
staticWeaponsList = 
[
	"B_Mortar_01_F",
	"O_Mortar_01_F",
	"I_Mortar_01_F",
	"I_G_Mortar_01_F",
	"B_HMG_01_F",
	"B_HMG_01_high_F",
	"B_HMG_01_A_F",
	"B_GMG_01_F",
	"B_GMG_01_high_F",
	"B_static_AA_F",
	"B_static_AT_F"
];

//Object List - Random Helis.
staticHeliList = 
[
	"B_Heli_Light_01_F",
	"O_Heli_Light_02_unarmed_F",
	"I_Heli_Transport_02_F",
	"B_Heli_Transport_01_F"
];

//Object List - Random Planes.
staticPlaneList = 
[
	"I_Plane_Fighter_03_CAS_F",
	"B_Plane_CAS_01_F",
	"O_Plane_CAS_02_F", 
	"I_Plane_Fighter_03_AA_F"
];

//Random Weapon List - Change this to what you want to spawn in cars.
vehicleWeapons =
[
//	"hgun_P07_F",
//	"hgun_Rook40_F",
//	"hgun_ACPC2_F",
//	"arifle_SDAR_F",
	"SMG_01_F",	// Vermin .45 ACP
	"SMG_02_F",	// Sting 9mm
	"hgun_PDW2000_F",
	"arifle_TRG20_F",
	"arifle_TRG21_F",
	"arifle_TRG21_GL_F",
	"arifle_Mk20C_F",
	"arifle_Mk20_F",
	"arifle_Mk20_GL_F",
	"arifle_Katiba_F",
	"arifle_Katiba_C_F",
	"arifle_Katiba_GL_F",
	"arifle_MXC_F",
	"arifle_MX_F",
	"arifle_MX_GL_F",
	"arifle_MX_SW_F",
	"arifle_MXM_F",
//	"srifle_EBR_F",
	"LMG_Mk200_F",
	"LMG_Zafir_F"
];

vehicleAddition =
[
	"muzzle_snds_L", // 9mm
	"muzzle_snds_M", // 5.56mm
	"muzzle_snds_H", // 6.5mm
	"muzzle_snds_H_MG", // 6.5mm LMG
	"muzzle_snds_B", // 7.62mm
	"muzzle_snds_acp", // .45 ACP
	"optic_Arco",
	"optic_SOS",
	"optic_Hamr",
	"optic_Aco",
	"optic_ACO_grn",
	"optic_aco_smg",
	"optic_Holosight",
	"optic_Holosight_smg",
	"acc_flashlight",
	"acc_pointer_IR",
	"Medikit",
	"Medikit",
	"FirstAidKit",
	"ToolKit"
];

vehicleAddition2 =
[
	"Chemlight_blue",
	"Chemlight_green",
	"Chemlight_yellow",
	"Chemlight_red"
];

MissionSpawnMarkers = [];
HostageRescueMarkers = [];
HostageExtractionMarkers=[];
HostageTerroristMarkers=[];
{
	if (["Mission_", _x] call fn_findString == 0) then
	{
		MissionSpawnMarkers set [count MissionSpawnMarkers, [_x, false]];
	};
	if (["Rescue_", _x] call fn_findString == 0) then
	{
		HostageRescueMarkers set [count HostageRescueMarkers, [_x, false]];
	};
	if (["Extraction_", _x] call fn_findString == 0) then
	{
		HostageExtractionMarkers set [count HostageExtractionMarkers, [_x, false]];
	};
	if (["Terrorists_", _x] call fn_findString == 0) then
	{
		HostageTerroristMarkers set [count HostageTerroristMarkers, [_x, false]];
	};
} forEach allMapMarkers;
