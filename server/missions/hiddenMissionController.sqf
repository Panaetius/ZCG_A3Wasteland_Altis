//	@file Version: 1.1
//	@file Name: hiddenMissionController.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, Sanjo, AgentRev
//	@file Created: 08/12/2012 15:19

if (!isServer) exitWith {};
#include "hiddenMissions\hiddenMissionDefines.sqf";

private ["_hiddenMissions", "_hiddenMissionsOdds", "_missionType", "_nextMission", "_missionRunning", "_hint"];
// private ["_mission", "_notPlayedhiddenMissions", "_nextMissionIndex"];

diag_log "WASTELAND SERVER - Started Side Mission State";

_hiddenMissions =
[			// increase the number behind the mission (weight) to increase the chance of the mission to be selected
	["mission_HostileHelicopter",0.5], 
	["mission_MiniConvoy", 1], 
	["mission_SunkenSupplys", 1],
	["mission_AirWreck", 1.5],
	["mission_WepCache", 1.5],
	["mission_Truck", 1]
]; 

// _notPlayedhiddenMissions = +_hiddenMissions;

_hiddenMissionsOdds = [];
{
	_hiddenMissionsOdds set [_forEachIndex, if (count _x > 1) then { _x select 1 } else { 1 }];
	
	// Attempt to compile every mission for early bug detection
	compile preprocessFileLineNumbers format ["server\missions\hiddenMissions\%1.sqf", _x select 0];
} forEach _hiddenMissions;

while {true} do
{
	_nextMission = [_hiddenMissions, _hiddenMissionsOdds] call fn_selectRandomWeighted;
    _missionType = _nextMission select 0;
	
	/*
		_nextMissionIndex = floor random count _notPlayedhiddenMissions;
		_mission = _notPlayedhiddenMissions select _nextMissionIndex select 0;
		_missionType = _notPlayedhiddenMissions select _nextMissionIndex select 1;
		
		if (count _notPlayedhiddenMissions > 1) then {
			_notPlayedhiddenMissions set [_nextMissionIndex, -1];
			_notPlayedhiddenMissions = _notPlayedhiddenMissions - [-1];
		} else {
			_notPlayedhiddenMissions = +_hiddenMissions;
		};
	*/
    
	_missionRunning = execVM format ["server\missions\hiddenMissions\%1.sqf", _missionType];
	
    diag_log format["WASTELAND SERVER - Execute New Side Mission: %1",_missionType];
    _hint = parseText format ["<t align='center' color='%2' shadow='2' size='1.75'>Side Objective</t><br/><t align='center' color='%2'>------------------------------</t><br/><t color='%3' size='1.0'>Starting in %1 Minutes</t>", hiddenMissionDelayTime / 60, hiddenMissionColor, subTextColor];
	[_hint] call hintBroadcast;
	waitUntil{sleep 0.1; scriptDone _missionRunning};
    sleep 5;
};
