//	@file Version: 1.1
//	@file Name: spawnRandom.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, [GoT] JoSchaap, AgentRev

waituntil {!isnil "bis_fnc_init"};

private ["_townName", "_randomLoc", "_pos", "_rad"];

_randomLoc = (call cityList) call BIS_fnc_selectRandom;

_pos = getMarkerPos (_randomLoc select 0);
_rad = _randomLoc select 1;
_townName = _randomLoc select 2;

_pos = [_pos select 0, _pos select 1, 1500];
waitUntil {sleep 0.1; preloadCamera _pos};
player setPos _pos;

[player, 1500, false, true, true] spawn fn_haloJump;

respawnDialogActive = false;
closeDialog 0;

_hour = date select 3;
_mins = date select 4;
["Wasteland", _townName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
