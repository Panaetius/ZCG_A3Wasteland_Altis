//	@file Version: 1.0
//	@file Name: mission_Outpost.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 03:25
//	@file Args:

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos","_randomIndex","_vehicleClass","_base","_veh","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_basetodelete"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "Hostage_Rescue";
_missionType = "Rescue Princess";
_startTime = floor(time);

diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];

_randomIndex = HostageRescueMarkers call BIS_fnc_randomIndex;
_randomPos = [];

//If the index of the mission markers array is false then break the loop and finish up doing the mission
if (!((HostageRescueMarkers select _randomIndex) select 1)) then 
{
	_selectedMarker = HostageRescueMarkers select _randomIndex select 0;
	_randomPos = getMarkerPos _selectedMarker;
	_returnData = [_randomPos, _randomIndex];
	HostageRescueMarkers select _randomIndex set [1, true];
};

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
//[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_hostageGroup = createGroup sideLogic;
_princess = _hostageGroup createUnit ["C_man_polo_1_F_afro", _randomPos, [], 0, "FORM"] ;
_princess setName "Princess";
_princess setVariable ["IsMission", true, true];
sleep 0.1;
_princess switchMove 'AmovPercMstpSnonWnonDnon_Ease';
sleep 0.1;
_princess disableAI 'MOVE';
_princess disableAI 'AUTOTARGET';
_princess disableAI 'ANIM';


_vehicleName = "princess";
_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Rescue the <t color='%3'>%2</t> from the castle! Kill the terrorists protecting her!</t>", _missionType, _vehicleName, mainMissionColor, subTextColor];
[_hint] call hintBroadcast;

_selectedMarker = HostageTerroristMarkers select _randomIndex select 0;
_randomPos = getMarkerPos _selectedMarker;
_returnData = [_randomPos, _randomIndex];

_CivGrpM = createGroup civilian;
[_CivGrpM,_randomPos] spawn createMidGroup;

_wp = _CivGrpM addWaypoint [getPos _princess, 0];
_wp setWaypointType "HOLD";

_marker = createMarker ["Terrorists", position leader _CivGrpM];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Terrorist";

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);
waitUntil
{
    sleep 1; 
	_marker setMarkerPos (position leader _CivGrpM);
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= mainMissionTimeout || !(alive _princess)) then {_result = 1;};
    _unitsAlive = ({alive _x} count units _CivGrpM);
    (_result == 1) OR (_unitsAlive < 1)
};

deleteMarker _marker;

AddPrincessHandler = _princess;
publicVariable "AddPrincessHandler";

 _princess setVariable [ "Freed", false, true ];
 
 HostageRescueMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;

_selectedMarker = HostageExtractionMarkers select _randomIndex select 0;
_randomPos = getMarkerPos _selectedMarker;
_returnData = [_randomPos, _randomIndex];
_missionMarkerName = "Hostage_Extraction";
[_missionMarkerName,_randomPos,"Extraction Point"] call createClientMarker;

_heli = createVehicle ["B_Heli_Transport_01_camo_F", _randomPos, [], 0, "FLY"];
_heli allowDamage false;

_pilotGrp = createGroup sideLogic;
_pilot = _pilotGrp createUnit ["C_man_pilot_F", _randomPos, [], 0, "FORM"] ;
_pilot allowDamage false;

_pilot moveInDriver _heli;

_heli flyinheight 0;

_pilotGrp setCombatMode "BLUE";
_pilotGrp setBehaviour "CARELESS";
_pilotGrp setFormation "STAG COLUMN";

sleep 0.5;

_heli setVehicleLock "LOCKED";

_pilot disableAI 'MOVE';
_pilot disableAI 'AUTOTARGET';
_pilot disableAI 'ANIM';

 
 _marker = createMarker ["Princess", position leader _CivGrpM];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Princess";
if (_result == 0) then {
	_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The terrorists have been killed! Move the princess to the extraction point!</t>", _missionType, _vehicleName, mainMissionColor, subTextColor];
	[_hint] call hintBroadcast;
};

waitUntil
{
    sleep 5; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= mainMissionTimeout || !(alive _princess)) then {_result = 1;};
	
	AddPrincessHandler = _princess;
	publicVariable "AddPrincessHandler";
	
	_marker setMarkerPos (position _princess);
	
    (_result == 1) OR (_princess getVariable [ "Freed", false ])
};

_princess enableAI 'ANIM';
_princess enableAI 'AUTOTARGET';
_princess enableAI 'MOVE';
_princess switchMove "";
sleep 2;

if (_result == 0) then {
	_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The princess is on her way to the extraction point!</t>", _missionType, _vehicleName, mainMissionColor, subTextColor];
	[_hint] call hintBroadcast;
};


waitUntil
{
    sleep 5; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= mainMissionTimeout || !(alive _princess)) then {_result = 1;};
	
	if (!( alive (leader (group _princess)))) then {
		[_princess] join grpNull;
	};
	
	_marker setMarkerPos (position _princess);
	
	AddPrincessHandler = _princess;
	publicVariable "AddPrincessHandler";
	
	_distance = _princess distance _heli;
	
	diag_log _distance;
	
    (_result == 1) OR (_distance < 20)
};

DeletePrincessHandler = _princess;
publicVariable "DeletePrincessHandler";

if(_result == 1) then
{
	//Mission Failed.
	{deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
	deleteVehicle _princess;
	deleteVehicle _pilot;
	deleteVehicle _heli;
	
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed, the princess is in another castle. Better luck next time!</t>", _missionType, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The princess has been rescued, good work.</t>", _missionType, _vehicleName, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
	
	_pilot enableAI 'MOVE';
	_pilot enableAI 'AUTOTARGET';
	_pilot enableAI 'ANIM';
	
	_princess joinSilent _pilotGrp;
	
	_heli setVehicleLock "UNLOCKED";
	_princess moveInCargo _heli;
	_heli setVehicleLock "LOCKED";
	
	
	_pilotGrp selectLeader _pilot;
	
	_heli flyinheight 100;
	
	_pilotGrp addWaypoint [0, 0];
	
	sleep 4;
	
	_box = createVehicle ["Box_East_Wps_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
	[_box,"mission_USLaunchers"] call fn_refillbox;
	_box allowDamage false;
	_box setVariable ["R3F_LOG_disabled", true, true];

	_box2 = createVehicle ["Box_NATO_Wps_F",[(_randomPos select 0), (_randomPos select 1) - 10,0],[], 0, "NONE"];
	[_box2,"mission_USSpecial"] call fn_refillbox;
	_box2 allowDamage false;
	_box2 setVariable ["R3F_LOG_disabled", true, true];
	
	_box3 = createVehicle ["Box_NATO_WpsLaunch_F",[(_randomPos select 0), (_randomPos select 1) + 10,0],[], 0, "NONE"];
	[_box3,"mission_USSpecial2"] call fn_refillbox;
	_box3 allowDamage false;
	_box3 setVariable ["R3F_LOG_disabled", true, true];

	_box4 = createVehicle ["Box_NATO_WpsSpecial_F",[(_randomPos select 0) + 10, (_randomPos select 1) - 10,0],[], 0, "NONE"];
	[_box4,"mission_Main_A3snipers"] call fn_refillbox;
	_box4 allowDamage false;
	_box4 setVariable ["R3F_LOG_disabled", true, true];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;

deleteMarker _marker;

if (_result == 0) then {
	sleep 120;
	deleteVehicle _princess;
	deleteVehicle _pilot;
	deleteVehicle _heli;
};