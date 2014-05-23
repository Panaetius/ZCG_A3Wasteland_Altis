//	@file Version: 1.1
//	@file Name: spawnInPermanentBase.sqf
//	@file Author: Panaetius
//	@file Created: 14.05.2014
//	@file Args: 

private ["_marker", "_pos", "_baseName"];
_index = _this;

_pos = nil;
_baseName = "";

switch (_index) do 
{
	case 3:
	{
		_pos = getMarkerPos "Permanent_Blufor_Base";
		_baseName = "Main Blufor Base";
	};
	case 4:
	{
		_pos = getMarkerPos "Permanent_Opfor_Base";
		_baseName = "Main Opfor Base";
	};
};

_pos = [_pos,5,50,1,0,0,0] call findSafePos;
_pos = [_pos select 0, _pos select 1, 1500];
waitUntil {sleep 0.1; preloadCamera _pos};
player setPos _pos;
[player, 1500, false, true, true] spawn fn_haloJump;

respawnDialogActive = false;
closeDialog 0;

sleep 5;

_hour = date select 3;
_mins = date select 4;
["Wasteland", _baseName, format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
