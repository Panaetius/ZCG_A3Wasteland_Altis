//	@file Version: 1.0
//	@file Name: serverPlayerDied.sqf
//	@file Author: [404] Pulse, AgentRev
//	@file Created: 20/11/2012 05:19

if (!isServer) exitWith {};

private ["_corpse", "_backpack"];

_corpse = _this select 0;
_corpse setVariable ["processedDeath", diag_tickTime];

// Remove any persistent info about the player on death
_uid = getPlayerUID _corpse;

// Remove any persistent info about the player on death
if (["config_player_saving_enabled", 0] call getPublicVar == 1 && {!isNil "_uid"} && {_uid != ''}) then {
	(getPlayerUID _corpse) call sqlite_deletePlayer;
};

_backpack = unitBackpack _corpse;

if (!isNull _backpack) then
{
	_backpack setVariable ["processedDeath", diag_tickTime];
};

// Eject corpse from vehicle once stopped
if (vehicle _corpse != _corpse) then
{
	_corpse spawn
	{
		waitUntil {sleep 0.1; _veh = vehicle _this; (isTouchingGround _veh || {!alive _veh && (getPos _veh) select 2 < 10}) && {(velocity _veh) distance [0,0,0] < 0.1}};
		_this setPos getPosATL _this; // ejects dead bodies
	};
};

if(!isNil "_corpse" && !isNull _corpse) then {
	_nearEntites =  nearestObjects [_corpse, "All", 20];

	if(!isNil "_nearEntites" && {count _nearEntites > 0}) then
	{
		{
			if (owner _x == owner _corpse && {!isNil {_x getVariable "mf_item_id"}}) then
			{
				_x setVariable ["processedDeath", diag_tickTime];
			};
		} forEach (_nearEntites);
	};
};

if (goggles _corpse != "G_Diving") then { removeGoggles _corpse };
