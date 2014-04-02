//	@file Version: 1.0
//	@file Name: mission_RoadBlock.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 03:25
//	@file Args:

if (!isServer) exitwith {};
#include "hiddenMissionDefines.sqf";

private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos","_randomIndex","_vehicleClass","_base","_veh","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_basetodelete"];

//Mission Initialization.
_missionMarkers = ["RoadBlock_1","RoadBlock_2","RoadBlock_3","RoadBlock_4","RoadBlock_5","RoadBlock_6","RoadBlock_7","RoadBlock_8","RoadBlock_9","RoadBlock_10","RoadBlock_11"];
_result = 0;
_missionMarkerName = "RoadBlock_Marker";
_missionType = "Enemy RoadBlock";
_startTime = floor(time);

diag_log format["WASTELAND SERVER - Hidden Mission Started: %1",_missionType];

//Get Mission Location
_missionMarker = _missionMarkers select (_missionMarkers call BIS_fnc_randomIndex);
_randomPos = getMarkerPos _missionMarker;
_markerDir = markerDir _missionMarker;

//delete existing base parts at location
_baseToDelete = nearestObjects [_randomPos, ["All"], 25];
{ deleteVehicle _x } forEach _baseToDelete; 

diag_log format["WASTELAND SERVER - Hidden Mission Waiting to run: %1",_missionType];
[hiddenMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Hidden Mission Resumed: %1",_missionType];

//[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_veh = ["JoSchaap01","JoSchaap02","JoSchaap03"] call BIS_fnc_selectRandom;


_vehicleName = "RoadBlock";
_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Hidden Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>An <t color='%3'>%2</t> with special weapons has been spotted near the marker, go capture it.</t>", _missionType, _vehicleName, hiddenMissionColor, subTextColor];
//[_hint] call hintBroadcast;

_bargate = createVehicle ["Land_BarGate_F", _randomPos, [], 0, "NONE"];
_bargate setDir _markerDir;
_bunker1 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [6.5,-2,-4.5], [], 0, "NONE"];
_bunker1 setDir _markerDir;
_bunker2 = createVehicle ["Land_BagBunker_Small_F", _bargate modelToWorld [-8,-2,-4.5], [], 0, "NONE"];
_bunker2 setDir _markerDir;

_CivGrpM = createGroup civilian;
[_CivGrpM,_randomPos] spawn createMidGroup;
_CivGrpM setCombatMode "YELLOW";

diag_log format["WASTELAND SERVER - Hidden Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);
waitUntil
{
    sleep 1; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= hiddenMissionTimeout) then {_result = 1;};
    _unitsAlive = ({alive _x} count units _CivGrpM);
    (_result == 1) OR (_unitsAlive < 1)
};

if(_result == 1) then
{
	//Mission Failed. 
	deleteVehicle _barGate;
	deleteVehicle _bunker1;
	deleteVehicle _bunker2;
	
    {deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed, better luck next time.</t>", _missionType, _vehicleName, failMissionColor, subTextColor];
	//[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Hidden Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
	_ammobox = "Box_NATO_Wps_F" createVehicle (position leader _CivGrpM);
    [_ammobox,"mission_USSpecial"] call fn_refillbox;
	_ammobox allowDamage false;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The Roadblock has been captured, good work.</t>", _missionType, _vehicleName, successMissionColor, subTextColor];
	//[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Hidden Mission Success: %1",_missionType];
};

//Reset Mission Spot.
//[_missionMarkerName] call deleteClientMarker;
