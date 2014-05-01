#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "You don't have enough money."
private ["_warchest", "_amount", "_money"];
disableSerialization;
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};

_amount = round (parseNumber (ctrlText IDC_AMOUNT));
_money = player getVariable ["cmoney", 0];

if (_money < _amount) exitWith {
    [ERR_NOT_ENOUGH_FUNDS, 5] call mf_notify_client;
};
player setVariable["cmoney",(_money - _amount),true];
[] spawn fn_deletePlayerData;

_warchestObj = [] call mf_items_warchest_nearest;
_warchestObj setVariable ["money", (_warchestObj getVariable ["money",0]) + _amount, true];

axeDiagLog = format ["%1 deposited %2 money to warchest %3", player, _amount, _warchestObj getVariable ["Id",0]];
publicVariableServer "axeDiagLog";

updateWarchest = [_warchestObj getVariable ["Id",0], _warchestObj getVariable ["money",0]];
publicVariableServer "updateWarchest";

call mf_items_warchest_refresh;

closeDialog 0;
