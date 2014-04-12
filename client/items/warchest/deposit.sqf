#include "defines.sqf"
#define ERR_NOT_ENOUGH_FUNDS "You dont have enough money."
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
[false] execVM "persistence\players\c_savePlayerToServer.sqf";
axeDiagLog = format ["%1 deposited %2 money", player, _amount];
publicVariableServer "axeDiagLog";

_warchestObj = [] call mf_items_warchest_nearest;
_warchestObj setVariable ["money", (_warchestObj getVariable ["money",0]) + _amount, true];

updateWarchest = [_warchestObj getVariable ["Id",0], _warchestObj getVariable ["money",0]];
publicVariableServer "updateWarchest";

call mf_items_warchest_refresh;

closeDialog 0;