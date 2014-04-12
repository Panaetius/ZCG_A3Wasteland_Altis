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
_missionMarkerName = "Money_Explosion";
_missionType = "Moneysplosion";
_startTime = floor(time);


diag_log format["WASTELAND SERVER - Money Mission Started: %1",_missionType];

//Get Mission Location
_returnData = call createMissionLocation;
_city = ((call citylist) call BIS_fnc_selectRandom);

diag_log format["WASTELAND SERVER - Money Mission Waiting to run: %1",_missionType];
//[moneyMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Money Mission Resumed: %1",_missionType];

_moneyArray = [];

_lcounter = 0;
_counter = 0;
_pos = getMarkerPos (_city select 0);
_tradius = _city select 1;
diag_log _tradius;
_townname = _city select 2;
_vehammount = 100; //100 * 100$ = 10k
_angleIncr = 360 / _vehammount;
_langle = random _angleIncr;
_minrad = 0;
_maxrad = _tradius / 2;


_CivGrpM = createGroup civilian;
[_CivGrpM,_pos] spawn createMidGroup;

while {_lcounter < _vehammount} do
{
	_lpos = [_pos, [[_maxrad, 0, 0], _langle] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd;
		
	_mindist = 1;
	
	_lpos = [_lpos, _minrad, _maxrad, _mindist, 0, 60*(pi/180), 0, "Land_Money_F"] call findSafePos;
	
	_m = "Land_Money_F" createVehicle _lpos;
	_m setVariable ["cmoney", 100, true];
	_m setVariable ["owner", "world", true];
	_moneyArray set [count _moneyArray, _m];
	
	_langle = _langle + _angleIncr;
	_counter = _counter + 1;
	_lcounter = _lcounter + 1;
	diag_log _counter;
};	

_marker = createMarker [_missionMarkerName, _pos];
_marker setMarkerType "mil_destroy";
_marker setMarkerSize [1.25, 1.25];
_marker setMarkerColor "ColorRed";
_marker setMarkerText "Moneysplosion";

_vehiclename = "Moneysplosion";
_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Money Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>A bank truck was exploded by terrorists. Grab the money!</t>", _missionType, _vehicleName, moneyMissionColor, subTextColor];
[_hint] call hintBroadcast;


diag_log format["WASTELAND SERVER - Money Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);
waitUntil
{
    sleep 5; 
	_currTime = floor(time);
    if(_currTime - _startTime >= moneyMissionTimeout) then {_result = 1;};
    _unitsAlive = ({alive _x} count units _CivGrpM);
	
	_newMoneyArray = [];
	
	{
		if( !isNull _x) then {
			_newMoneyArray set [count _newMoneyArray, _x];
		};
	}forEach _moneyArray;
	
	_moneyArray = _newMoneyArray;
	
	diag_log (_moneyArray select 0);
	diag_log (getPos (_moneyArray select 0));
	
	_marker setMarkerPos (getPos (_moneyArray select 0));
	
    (_result == 1) OR (count _moneyArray == 0)
};

if(_result == 1) then
{
	//Mission Failed.   
	{deleteVehicle _x }forEach _moneyArray;
    {deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed, better luck next time.</t>", _missionType, _vehicleName, failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Money Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    {deleteVehicle _x }forEach units _CivGrpM;
    deleteGroup _CivGrpM;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>All the money has been collected. You can now live like kings!</t>", _missionType, _vehicleName, successMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Money Mission Success: %1",_missionType];
};

//Reset Mission Spot.
deleteMarker _marker;
