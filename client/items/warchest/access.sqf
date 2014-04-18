#include "defines.sqf"
disableSerialization;
_warchest = [] call mf_items_warchest_nearest;
_warchest setVariable ["InUse", true, true];
if (isNull findDisplay IDD_WARCHEST) then { createDialog DIALOG_WARCHEST; };
call mf_items_warchest_refresh;
waitUntil{sleep 0.5;!dialog};
_warchest setVariable ["InUse", false, true];