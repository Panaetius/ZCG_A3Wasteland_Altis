//	@file Version: 1.0
//	@file Name: mission_HackLaptop.sqf
//	@file Author: Panaetius
//	@file Created: 10.04.2014
//	@file Args:

if (!isServer) exitwith {};
#include "moneyMissionDefines.sqf";

private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos","_randomIndex","_vehicleClass","_base","_veh","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_basetodelete"];

//Mission Initialization.
_result = 0;
_missionMarkerName = "Laptop_Marker";
_missionType = "Enemy Laptop";
_startTime = floor(time);


diag_log format["WASTELAND SERVER - Money Mission Started: %1",_missionType];

//Get Mission Location
_returnData = call createMissionLocation;
_randomPos = _returnData select 0;
_randomIndex = _returnData select 1;

diag_log format["WASTELAND SERVER - Money Mission Waiting to run: %1",_missionType];
[moneyMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Money Mission Resumed: %1",_missionType];

[_missionMarkerName,_randomPos,_missionType] call createClientMarker;

_bunker = createVehicle ["Land_BagBunker_Small_F", [_randomPos select 0, _randomPos select 1], [], 0, "CAN COLLIDE"];

_randomPos = getPosASL _bunker;

_laptop = createVehicle ["Land_Laptop_unfolded_F", _randomPos, [], 0, "CAN COLLIDE"];
//Fix position for more accurate positioning
_posX = (_randomPos select 0);
_posY = (_randomPos select 1);
_posZ = (_randomPos select 2);

_currentPos = getPosATL _obj;

_fixX = (_currentPos select 0) - _posX;
_fixY = (_currentPos select 1) - _posY;
_fixZ = (_currentPos select 2) - _posZ;

_laptop setPosASL [(_posX - _fixX), (_posY - _fixY) + 0.5, (_posZ - _fixZ)];

_obj = createVehicle ["B_static_AT_F", _randomPos,[], 10,"None"]; 
_obj setPosASL [_randomPos select 0, (_randomPos select 1) + 2, _randomPos select 2];

AddLaptopHandler = _laptop;
publicVariable "AddLaptopHandler";

 _laptop setVariable [ "Done", false, true ];


_vehicleName = "Laptop";
_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Money Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>A <t color='%3'>%2</t> with enemy bank accounts has been spotted, go hack it.</t>", _missionType, _vehicleName, moneyMissionColor, subTextColor];
[_hint] call hintBroadcast;

_CivGrpM = createGroup civilian;
[_CivGrpM,_randomPos] spawn createMidGroup;

diag_log format["WASTELAND SERVER - Money Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);
waitUntil
{
    sleep 5; 
	_playerPresent = false;
	_currTime = floor(time);
    if(_currTime - _startTime >= moneyMissionTimeout) then {_result = 1;};
    _unitsAlive = ({alive _x} count units _CivGrpM);
	
	AddLaptopHandler = _laptop;
	publicVariable "AddLaptopHandler";
	
    (_result == 1) OR (_laptop getVariable [ "Done", false ])
};
				
RemoveLaptopHandler = _laptop;
publicVariable "RemoveLaptopHandler";

if(_result == 1) then
{
	//Mission Failed.
	deleteVehicle _laptop;
	_baseToDelete = nearestObjects [_randomPos, ["All"], 50];
    { deleteVehicle _x } forEach _baseToDelete;    
    {deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed, better luck next time.</t>", _missionType, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Money Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    {deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
	deleteVehicle _laptop;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>The bank accounts have been hacked, good work.</t>", _missionType, _vehicleName, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Money Mission Success: %1",_missionType];
};

//Reset Mission Spot.
MissionSpawnMarkers select _randomIndex set[1, false];
[_missionMarkerName] call deleteClientMarker;
