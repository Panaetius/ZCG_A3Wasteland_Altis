
if (!isNil "storePurchaseHandle" && {typeName storePurchaseHandle == "SCRIPT"} && {!scriptDone storePurchaseHandle}) exitWith {hint "Please wait, your previous purchase is being processed"};

disableSerialization;
#include "dialog\bountyboardDefines.sqf";

_locationSelection = [];

switch (_this select 0) do
{
	case 1:
	{
		_locationSelection = [5000, 500];
	};
	case 2:
	{
		_locationSelection = [10000, 200];
	};
	default
	{
		_locationSelection = [1000, 1000];
	};
};

//Initialize Values
_playerMoney = player getVariable ["cmoney", 0];
_successHint = true;

// Grab access to the controls
_dialog = findDisplay  bountyBoard_DIALOG;
_itemlist = _dialog displayCtrl  bountyBoard_item_list;
_totalText = _dialog displayCtrl  bountyBoard_total;
_playerMoneyText = _dialog displayCtrl  bountyBoard_money;

_itemIndex = lbCurSel  bountyBoard_item_list;
_itemText = _itemlist lbText _itemIndex;
_itemData = _itemlist lbData _itemIndex;

if (_locationSelection select 0 > _playerMoney) exitWith
{
	hint "Not enough money to find location";
	playSound "FD_CP_Not_Clear_F";
};

_selectedPlayer = objNull;

{ 
	if (isPlayer _x && {getPlayerUID _x == _itemData}) then 
	{ 
		_selectedPlayer = _x;
	}; 
} forEach playableUnits;

if( isNull _selectedPlayer) exitWith
{
	hint "The selected player is not online";
	playSound "FD_CP_Not_Clear_F";
};

_playerPos = getPos _selectedPlayer;
_distance = (_locationSelection select 1);
_minError = _distance / 2;
_radius = random _minError;
_playerPos = [_playerPos, [[_minError + _radius, 0], random 360] call BIS_fnc_rotateVector2D] call BIS_fnc_vectorAdd;

player setVariable ["cmoney", _playerMoney - (_locationSelection select 0), true];
[] spawn fn_deletePlayerData;
_playerMoneyText ctrlSetText format ["Cash: $%1", player getVariable "cmoney"];

hint parseText format ["Spy satellites are searching for the location of %1", name _selectedPlayer];

sleep 30;

_markerName = format["bountyHunterMarker_%1",_itemData];
deleteMarkerLocal _markerName;
_marker = createMarkerLocal [_markerName, _playerPos];
_markerName setMarkerShapeLocal "ICON";
_markerName setMarkerTypeLocal "mil_destroy";
_markerName setMarkerColorLocal "ColorOrange";
_markerName setMarkerSizeLocal [1,1];
_markerName setMarkerTextLocal (format ["Bounty Position: %1", name _selectedPlayer]);

hint "The players location has been marked on your map. Good luck hunting!";
playSound "FD_Finish_F";