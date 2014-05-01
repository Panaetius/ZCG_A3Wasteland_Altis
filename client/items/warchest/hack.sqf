#include "mutex.sqf"
#define DURATION MF_ITEMS_WARCHEST_HACK_DURATION
#define ANIMATION "AinvPknlMstpSlayWrflDnon_medic"
#define ERR_IN_VEHICLE "Warchest Hacking Failed! You can't do that in a vehicle."
#define ERR_TOO_FAR_AWAY "Warchest Hacking Failed! You are too far away."
#define ERR_HACKED "Warchest Hacking Failed! Someone else just finished hacking this warchest."
#define ERR_CANCELLED "Warchest Hacking Cancelled"
#define ERR_EMPTY "No Money inside the Warchest"

private ["_warchest", "_error", "_success"];
_warchest = [] call mf_items_warchest_nearest;
_error = [] call mf_items_warchest_can_hack;
if (_error != "") exitWith {[_error, 5] call mf_notify_client};

private "_checks";
_checks = {
	private ["_progress","_warchest","_failed", "_text"];
	_progress = _this select 0;
	_warchest = _this select 1;
	_text = "";
	_failed = true;
	switch (true) do {
		case not(alive player): {}; //player is dead, not need to notify them
		case (vehicle player != player): {_text = ERR_IN_VEHICLE};
		case (player distance _warchest > 3): {_text = ERR_TOO_FAR_AWAY};
		case (_warchest getVariable "side" == playerSide): {_text = ERR_HACKED};
		case ((_warchest getVariable ["money",0]) < 0): {_text = ERR_EMPTY};
		case (doCancelAction): {_text = ERR_CANCELLED; doCancelAction = false;};
		default {
			_text = format["Warchest Hacking %1%2 Complete", round(100 * _progress), "%"];
			_failed = false;
		};
	};
	[_failed, _text];
};

private ["_success", "_amount", "_money"];
MUTEX_LOCK_OR_FAIL;
_success = [DURATION, ANIMATION, _checks, [_warchest]] call a3w_actions_start;
MUTEX_UNLOCK;
if (_success) then {
	_amount = 0;
	
	_amount = round((_warchest getVariable ["money",0])/4);
	_warchest setVariable ["money", (_warchest getVariable ["money",0]) - _amount, true];
	
	_money = (player getVariable ["cmoney", 0]) + _amount;
	player setVariable ["cmoney", _money, true];
	axeDiagLog = format ["%1 hacked %2 money from warchest %3", player, _amount, _warchest getVariable ["Id",0]];
	publicVariableServer "axeDiagLog";
	[format["Warchest Hacking Complete! You stole $%1", _amount], 5] call mf_notify_client;
};
_success;
