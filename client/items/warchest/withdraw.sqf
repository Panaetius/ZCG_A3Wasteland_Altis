#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "There is not enough funds in the warchest."
disableSerialization;
private ["_warchest", "_amount", "_money"];
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};
_amount = round(parseNumber(ctrlText IDC_AMOUNT));

_warchestObj = [] call mf_items_warchest_nearest;
if (_warchestObj getVariable ["money",0] < _amount) exitWith {
	[ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
};
_warchestObj setVariable ["money", (_warchestObj getVariable ["money",0]) - _amount, true];
_money = player getVariable ["cmoney", 0];
player setVariable["cmoney",(_money + _amount),true];

updateWarchest = [_warchestObj getVariable ["Id",0], _warchestObj getVariable ["money",0]];
publicVariableServer "updateWarchest";

axeDiagLog = format ["%1 withdrew %2 money", player, _amount];
publicVariableServer "axeDiagLog";
call mf_items_warchest_refresh;
closeDialog 0;
