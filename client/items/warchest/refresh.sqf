#include "defines.sqf"
disableSerialization;
private ["_warchest", "_funds", "_text"];
_warchest = findDisplay IDD_WARCHEST;
if (isNull _warchest) exitWith {};

_warchestObj = [] call mf_items_warchest_nearest;

_funds = -1;
switch (playerSide) do {
    case east : {_funds = pvar_warchest_funds_east};
    case west : {_funds = pvar_warchest_funds_west};
	case resistance : {_funds = _warchestObj getVariable ["money",0]};
    default {hint "WarchestRefrest - This Shouldnt Happen"};
};

_text = _warchest displayCtrl IDC_FUNDS;
_text ctrlSetText format ["$%1", _funds];