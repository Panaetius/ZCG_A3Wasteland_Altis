//	@file Version: 1.0
//	@file Name: mission_ThereCanBeOnlyOne.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 03:25
//	@file Args:

if (!isServer) exitwith {};
#include "mainMissionDefines.sqf";
_timeout = 60*60;

private ["_result","_missionMarkerName","_missionType","_startTime","_returnData","_randomPos","_randomIndex","_vehicleClass","_base","_veh","_picture","_vehicleName","_hint","_currTime","_playerPresent","_unitsAlive","_basetodelete", "_baseLocations", "_marker", "_group1Alive", "_group2Alive", "_group3Alive"];

//Mission Initialization.
_result = 0;
_missionType = "There can be only One!";
_startTime = floor(time);
_missionIndex = floor (random 12) + 1;

diag_log format["WASTELAND SERVER - Main Mission Started: %1",_missionType];

diag_log format["WASTELAND SERVER - Main Mission Waiting to run: %1",_missionType];
[mainMissionDelayTime] call createWaitCondition;
diag_log format["WASTELAND SERVER - Main Mission Resumed: %1",_missionType];

relicArray = [];

_playerCount = {alive _x} count playableUnits;

_relicCount = 4 + (ceil (_playerCount/4));//minimum of 5, maximum of 15 relics, depending on amount of players

for "_i" from 1 to _relicCount do
{
	_index = ceil random 3;
	_circle = format ["ThereCanBeOnlyOne_%1", _index];
	_pos = [getMarkerPos _circle, 0, (getMarkerSize _circle) select 0, 10, 0, 60*(pi/180), 0, "Sign_Arrow_Large_Yellow_F"] call findSafePos;
	
	_object = createVehicle ["Sign_Arrow_Large_Yellow_F", _pos, [], 0, "NONE"];
	_object setPos _pos;
	
	_marker = createMarker [format ["ThereCanBeOnlyOneObject_%1", _i], _pos];
	_marker setMarkerType "mil_destroy";
	_marker setMarkerSize [1.25, 1.25];
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText "Ancient Relic";
	
	relicArray set [count relicArray, [_object, _marker]];
	sleep 0.1;
};

_hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Main Objective</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'><t color='%3'>Magical Tokens of Ancient Greek Power</t> have been located on the map. Get them all!</t>", _missionType, "", mainMissionColor, subTextColor];
[_hint] call hintBroadcast;

diag_log format["WASTELAND SERVER - Main Mission Waiting to be Finished: %1",_missionType];
_startTime = floor(time);

_playerMarkers = [];

_done = false;

_winner = objNull;

waitUntil
{
    sleep 10; 
	_currTime = floor(time);
    if(_currTime - _startTime >= mainMissionTimeout) then {_result = 1;};
    	
	_newRelicArray = [];
	
	_count = 0;
	
	{
		_object = _x select 0;
		_marker = _x select 1;
		
		_count = _count + 1;
		
		deleteMarker _marker;
		
		if( !isNull _object) then {
			_marker = createMarker [format ["ThereCanBeOnlyOneObject_%1", _count], getPos _object];
			_marker setMarkerType "mil_destroy";
			_marker setMarkerSize [1.25, 1.25];
			_marker setMarkerColor "ColorRed";
			_marker setMarkerText "Ancient Relic";
	
			_newRelicArray set [count _newRelicArray, [_object, _marker]];
		};
	} forEach relicArray;
	
	relicArray = _newRelicArray;
	
	_currentRelicCount = count relicArray;
	
	{
		deleteMarker _x;
	} forEach _playerMarkers;
	
	_playerMarkers = [];
	
	{
		if ((isPlayer _x) && (alive _x) && _x getVariable ["RelicCount", 0] > 0) then {
			_marker = createMarker [format ["ThereCanBeOnlyOneObject_%1", getPlayerUID _x], getPos _x];
			_marker setMarkerType "mil_destroy";
			_marker setMarkerSize [1.25, 1.25];
			_marker setMarkerColor "ColorRed";
			_marker setMarkerText "Ancient Relic";
			
			_playerMarkers set [count _playerMarkers, _marker];
			
			_currentRelicCount = _currentRelicCount + (_x getVariable ["RelicCount", 0]);
			
			if (_x getVariable ["RelicCount", 0] == _relicCount) then
			{
				_done = true;
				_winner = _x;
			};
		};
	} forEach playableUnits;
	
	if (_currentRelicCount < _relicCount) then {
		for "_i" from (_currentRelicCount + 1) to _relicCount do
		{
			_index = ceil random 3;
			_circle = format ["ThereCanBeOnlyOne_%1", _index];
			_pos = [getMarkerPos _circle, 0, (getMarkerSize _circle) select 0, 10, 0, 60*(pi/180), 0, "Sign_Arrow_Large_Yellow_F"] call findSafePos;
			
			_object = createVehicle ["Sign_Arrow_Large_Yellow_F", _pos, [], 0, "NONE"];
			_object setPos _pos;
			
			_marker = createMarker [format ["ThereCanBeOnlyOneObject_%1", _i], _pos];
			_marker setMarkerType "mil_destroy";
			_marker setMarkerSize [1.25, 1.25];
			_marker setMarkerColor "ColorRed";
			_marker setMarkerText "Ancient Relic";
			
			relicArray set [count relicArray, [_object, _marker]];
			sleep 0.1;
		};
	};
	
    (_result == 1) OR _done
};

{
	deleteMarker _x;
} forEach _playerMarkers;

if(_result == 1) then
{
	//Mission Failed.  
	{
		_playerRelicCount = _x getVariable ["RelicCount", 0];
		if (_playerRelicCount > 0) then
		{
			player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + (200 * _playerRelicCount), true];
		};
		_x setVariable ["RelicCount", nil, true];
	} forEach playableUnits;
	
	{
		deleteVehicle (_x select 0);
		deleteMarker (_x select 1);
	} forEach relicArray;
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Failed</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>Objective failed, better luck next time. You got 200$ for each artifact as a consolation price</t>", _missionType, '', failMissionColor, subTextColor];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Failed: %1",_missionType];
} else {
	//Mission Complete.
    {
		deleteMarker (_x select 1);
	} forEach relicArray;
	
	{
		_x setVariable ["RelicCount", nil, true];
	} forEach playableUnits;
	
	_randomPos = getPos _winner;
	
	_box = createVehicle ["Box_East_Wps_F",[(_randomPos select 0), (_randomPos select 1),0],[], 0, "NONE"];
	[_box,"mission_USLaunchers"] call fn_refillbox;
	_box allowDamage false;
	_box setVariable ["R3F_LOG_disabled", false, true];

	_box2 = createVehicle ["Box_NATO_Wps_F",[(_randomPos select 0), (_randomPos select 1) - 10,0],[], 0, "NONE"];
	[_box2,"mission_USSpecial"] call fn_refillbox;
	_box2 allowDamage false;
	_box2 setVariable ["R3F_LOG_disabled", false, true];
	
	_box3 = createVehicle ["Box_NATO_WpsLaunch_F",[(_randomPos select 0), (_randomPos select 1) + 10,0],[], 0, "NONE"];
	[_box3,"mission_USSpecial2"] call fn_refillbox;
	_box3 allowDamage false;
	_box3 setVariable ["R3F_LOG_disabled", false, true];

	_box4 = createVehicle ["Box_NATO_WpsSpecial_F",[(_randomPos select 0) + 10, (_randomPos select 1) - 10,0],[], 0, "NONE"];
	[_box4,"mission_Main_A3snipers"] call fn_refillbox;
	_box4 allowDamage false;
	_box4 setVariable ["R3F_LOG_disabled", false, true];
	
	for "_x" from 1 to 5 do
	{
		_cash = "Land_Money_F" createVehicle _randomPos;
		_cash setPos ([_randomPos, [[2 + random 2,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd);
		_cash setDir random 360;
		_cash setVariable["cmoney",1000,true];
		_cash setVariable["owner","world",true];
	};
	
	for "_x" from 1 to 10 do
	{
		_randomPos = getPos _winner;
		
		_save = false;
		_pos = objNull;
		while {!_save} do {
			_pos = [_randomPos, [[30,0,0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd;
			
			_objects = nearestObjects [_pos, ["All"], 3];
			
			if (count _objects == 0) then {//make sure nothing is hit by the lightning
				_save = true;
			};
		};
		_center = createCenter sideLogic;
		_group = createGroup _center;  
		_zlb = _group createUnit ["ModuleLightning_F",_pos,[],0,"FORM"];
		sleep 0.5;
		deleteVehicle _zlb;
		deleteGroup _group;
	};
	
    _hint = parseText format ["<t align='center' color='%3' shadow='2' size='1.75'>Objective Complete</t><br/><t align='center' color='%3'>------------------------------</t><br/><t align='center' color='%4' size='1.25'>%1</t><br/><t align='center' color='%4'>All the relics have been gathered, %5 is the One!</t>", _missionType, '', successMissionColor, subTextColor, name _winner];
	[_hint] call hintBroadcast;
    diag_log format["WASTELAND SERVER - Main Mission Success: %1",_missionType];
};