//	@file Version: 1
//	@file Name: mission_Hostilesquad.sqf
//	@file Author: JoSchaap

if (!isServer) exitwith {};
#include "hiddenMissionDefines.sqf";

private ["_squadpick","_missionMarkerName","_missionType","_picture","_vehicleName","_hint","_waypoint","_waypoints","_CivGrpM","_vehicles","_marker","_failed","_startTime","_numWaypoints","_ammobox","_createVehicle","_leader","_routepoints","_travels","_travelcount"];

_missionMarkerName = "Hostilesquad_Marker";
_missionType = "Hostile squad";

_travels = 20; 						// the ammount of towns the squad should visit before the mission ends
_travelcount = 0;
_waypoints = [];

diag_log format["WASTELAND SERVER - Hidden Mission Started: %1", _missionType];
diag_log format["WASTELAND SERVER - Hidden Mission Waiting to run: %1", _missionType];
[hiddenMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Hidden Mission Resumed: %1", _missionType];

_position = getMarkerPos (((call citylist) call BIS_fnc_selectRandom) select 0);
_CivGrpM = createGroup civilian;

[_CivGrpM,_position] spawn createMidGroup;


_CivGrpM setCombatMode "WHITE";
_CivGrpM setBehaviour "AWARE";
_CivGrpM setFormation "STAG COLUMN";
_CivGrpM setSpeedMode "NORMAL";

_missionMarkerName = "Outpost_Marker";
_missionType = "Hostile Squad";
//[_missionMarkerName,_position,_missionType] call createClientMarker;

// pick random townmarkers from the citylist and use their location as waypoints
while {_travelcount < _travels} do {
	_travelcount = (_travelcount + 1);
	_waypoints set [count _waypoints, getMarkerPos (((call citylist) call BIS_fnc_selectRandom) select 0)];
};

{
    _waypoint = _CivGrpM addWaypoint [_x, 0];
    _waypoint setWaypointType "MOVE";
    _waypoint setWaypointCompletionRadius 55;
    _waypoint setWaypointCombatMode "WHITE"; // Defensiv behaviour
    _waypoint setWaypointBehaviour "AWARE"; // Force convoy to normaly drive on the street.
    _waypoint setWaypointFormation "STAG COLUMN";
	if (A3W_missionsDifficulty == 1) then {
		_waypoint setWaypointSpeed "NORMAL";
	} else {
		_waypoint setWaypointSpeed "LIMITED";
	};
} forEach _waypoints;

_hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t align='center' color='%3' size='1.25'>%1</t><br/><t align='center' color='%3'>A hostile squad has been spotted near the marker.</t>", _missionType,  hiddenMissionColor, subTextColor];
//[_hint] call hintBroadcast;

diag_log format["WASTELAND SERVER - Hidden Mission Waiting to be Finished: %1", _missionType];

_failed = false;
_startTime = floor(time);
_numWaypoints = count waypoints _CivGrpM;
waitUntil
{
    private ["_unitsAlive"];
    
    sleep 10; 
    
    if ((floor time) - _startTime >= hiddenMissionTimeout) then { _failed = true };
    if (currentWaypoint _CivGrpM >= _numWaypoints) then { _failed = true }; // Convoy got successfully to the target location
    _unitsAlive = { alive _x } count units _CivGrpM;
    _unitsAlive == 0 || _failed
};

if(_failed) then
{
    // Mission failed
    if not(isNil "_vehicle") then {deleteVehicle _vehicle;};
	{if (vehicle _x != _x) then { deleteVehicle vehicle _x; }; deleteVehicle _x;}forEach units _CivGrpM;
	{deleteVehicle _x;}forEach units _CivGrpM;
	deleteGroup _CivGrpM; 
    diag_log format["WASTELAND SERVER - Hidden Mission Failed: %1",_missionType];
} else {
	// Mission completed
	// unlock the vehicles incase the player cleared the mission without destroying them
	if (!isNil "_vehicles") then { 
		{
			_x setVehicleLock "UNLOCKED"; 
			_x setVariable ["R3F_LOG_disabled", false, true];
		}forEach _vehicles;
	};
	// give the rewards
    _ammobox = "Box_NATO_Wps_F" createVehicle (position leader _CivGrpM);
    [_ammobox,"mission_USSpecial"] call fn_refillbox;
	_ammobox allowDamage false;
	
	deleteGroup _CivGrpM;
    diag_log format["WASTELAND SERVER - Hidden Mission Success: %1",_missionType];
};

//deleteMarker _marker;
