//	@file Version: 1.1
//	@file Name: spawnOnBeacons.sqf
//	@file Author: [404] Costlyy, [GoT] JoSchaap, MercyfulFate, AgentRev
//	@file Created: 08/12/2012 18:30
//	@file Args: 

private ["_pos", "_owner"];
_pos = _this select 0;
_owner = _this select 1;

_beacons = nearestObjects [_pos, ["Land_TentDome_F"], 5];

if (not(isNil "_beacons") && count _beacons > 0 && (_beacons select 0) getVariable ["haloJump", false]) then 
{
	_pos = [_pos select 0, _pos select 1, 1500];
	waitUntil {sleep 0.1; preloadCamera _pos};
	player setPos _pos;

	[player, 1500, false, true, true] spawn fn_haloJump;
}
else
{
	_R3F_attachPoint = objNull;
	
	if (isNull _R3F_attachPoint && !isNil "R3F_LOG_PUBVAR_point_attache") then
	{
		_R3F_attachPoint = R3F_LOG_PUBVAR_point_attache;
	};
	
	_R3F_attachPoint spawn fn_vehicleManager; //call vehicle manager to enable simulation on all close vehicles
	
	waitUntil {sleep 0.1; preloadCamera _pos};
	player setPos _pos;
};

respawnDialogActive = false;
closeDialog 0;
[format ["You have spawned on %1's beacon", _owner], 5] call mf_notify_client;

sleep 5;

_hour = date select 3;
_mins = date select 4;
["Wasteland", "Spawn Beacon", format ["%1:%3%2", _hour, _mins, if (_mins < 10) then {"0"} else {""}]] spawn BIS_fnc_infoText;
