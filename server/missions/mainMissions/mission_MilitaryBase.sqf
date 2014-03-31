//	@file Version: 1.0
//	@file Name: mission_Outpost.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 03:25
//	@file Args:

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";

private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos","_randomIndex","_vehicleClass","_base","_veh","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_basetodelete", "_baseLocations", "_marker", "_group1Alive", "_group2Alive", "_group3Alive"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "MilitaryBase_Marker";
_missionType = "Enemy Military Base";
_startTime = floor(time);
_baseLocations = [[12812,16671.8],
	[23541.8,21117],
	[25318.3,21837.7],
	[20950.1,19265.7],
	[12299.4,8875.46],
	[8303.31,10087.1],
	[4545.97,15429.3],
	[16081,17018.7],
	[12441.9,15204.2]];

diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];

//Get Mission Location
_pos = (_baseLocations select (_baseLocations call BIS_fnc_randomIndex));
_randomPos = createMarker ["military_base", _pos];
_randomPos2 = createMarker ["military_base2", [(_pos select 0) - 1, (_pos select 1) + 2] ];
_randomPos3 = createMarker ["military_base3", [(_pos select 0) - 1, (_pos select 1) - 2] ];

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
//[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

[_missionMarkerName,(getMarkerPos _randomPos),_missionType] call createClientMarker;

_veh = ["JoSchaap01","JoSchaap02","JoSchaap03"] call BIS_fnc_selectRandom;

_vehicleName = "outpost";
_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>An <t color='%3'>enemy Military Base</t> with special weapons and 7000$ has been spotted near the marker, go capture it.</t>", _missionType, _vehicleName, mainMissionColor, subTextColor];
[_hint] call hintBroadcast;

_CivGrpM1 = createGroup civilian;
[_CivGrpM1,(getMarkerPos _randomPos)] spawn createMidGroup;
[_CivGrpM1,(getMarkerPos _randomPos)] call BIS_fnc_taskDefend;
_CivGrpM1 setCombatMode "YELLOW";
_CivGrpM1 setBehaviour "AWARE";
_CivGrpM1 setFormation "STAG COLUMN";
_CivGrpM1 setSpeedMode "NORMAL";

_CivGrpM2 = createGroup civilian;
[_CivGrpM2,(getMarkerPos _randomPos2)] spawn createMidGroup;
[_CivGrpM2,(getMarkerPos _randomPos2)] call BIS_fnc_taskDefend;
_CivGrpM2 setCombatMode "YELLOW";
_CivGrpM2 setBehaviour "AWARE";
_CivGrpM2 setFormation "STAG COLUMN";
_CivGrpM2 setSpeedMode "NORMAL";

_CivGrpM3 = createGroup civilian;
[_CivGrpM3,(getMarkerPos _randomPos3)] spawn createMidGroup;
[_CivGrpM3,(getMarkerPos _randomPos3)] call BIS_fnc_taskDefend;
_CivGrpM3 setCombatMode "YELLOW";
_CivGrpM3 setBehaviour "AWARE";
_CivGrpM3 setFormation "STAG COLUMN";
_CivGrpM3 setSpeedMode "NORMAL";

_marker = createMarker [_missionMarkerName, position leader _CivGrpM1];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Military Base";

_box = createVehicle ["Box_East_Wps_F",[((getMarkerPos _randomPos) select 0), ((getMarkerPos _randomPos) select 1),0],[], 0, "NONE"];
[_box,"mission_USLaunchers"] call fn_refillbox;
_box allowDamage false;
_box setVariable ["R3F_LOG_disabled", true, true];

_box2 = createVehicle ["Box_NATO_Wps_F",[((getMarkerPos _randomPos) select 0), ((getMarkerPos _randomPos) select 1) - 10,0],[], 0, "NONE"];
[_box2,"mission_USSpecial"] call fn_refillbox;
_box2 allowDamage false;
_box2 setVariable ["R3F_LOG_disabled", true, true];

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);
waitUntil
{
    sleep 1; 
	
	_group1Alive = ({alive _x} count units _CivGrpM1);
	_group2Alive = ({alive _x} count units _CivGrpM2);
	_group3Alive = ({alive _x} count units _CivGrpM3);
	
	if (_group1Alive > 0) then {
		_marker setMarkerPos (position leader _CivGrpM1);
	}else {
		if (_group2Alive > 0) then {
			_marker setMarkerPos (position leader _CivGrpM2);
		} else {
			_marker setMarkerPos (position leader _CivGrpM3);
		};
	};
	
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= mainMissionTimeout) then {_result = 1;};
    _unitsAlive =  _group1Alive + _group2Alive + _group3Alive;
    (_result == 1) OR (_unitsAlive < 1)
};

_box setVariable ["R3F_LOG_disabled", false, true];
_box2 setVariable ["R3F_LOG_disabled", false, true];

if(_result == 1) then
{
	//Mission Failed.
	if (!isNil "_box") then { deleteVehicle _box };
    if (!isNil "_box2") then { deleteVehicle _box2 };
	
    {deleteVehicle _x }forEach units _CivGrpM1;
    deleteGroup _CivGrpM1;
	{deleteVehicle _x }forEach units _CivGrpM2;
    deleteGroup _CivGrpM2;
	{deleteVehicle _x }forEach units _CivGrpM3;
    deleteGroup _CivGrpM3;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed, better luck next time.</t>", _missionType, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
	for "_x" from 1 to 7 do
	{
		_cash = "Land_Money_F" createVehicle markerPos _randomPos;
		_cash setPos ([markerPos _randomPos, [[2 + random 2,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_cash setDir random 360;
		_cash setVariable["cmoney",1000,true];
		_cash setVariable["owner","world",true];
	};
	
    deleteGroup _CivGrpM1;
	deleteGroup _CivGrpM2;
	deleteGroup _CivGrpM3;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The military base has been captured, good work.</t>", _missionType, _vehicleName, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};

//Reset Mission Spot.
[_missionMarkerName] call deleteClientMarker;
deleteMarker _marker;