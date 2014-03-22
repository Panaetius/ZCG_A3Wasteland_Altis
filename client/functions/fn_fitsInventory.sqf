//	@file Version: 2.0
//	@file Name: fn_fitsInventory.sqf
//	@file Author: AgentRev
//	@file Created: 05/05/2013 00:22
//	@file Args: _player, _item

private ["_player", "_item","_allowedContainers", "_return", "_allowVest", "_allowUniform", "_allowBackpack"];

_player = _this select 0;
_item = _this select 1;
_return = false;
_allowVest = false;
_allowUniform = false;
_allowBackpack = false;

if (count _this > 2) then
{
	_allowedContainers = _this select 2;
}
else
{
	_allowedContainers = ["uniform", "vest", "backpack"];
};

if (typeName _allowedContainers != "ARRAY") then
{
	_allowedContainers = [_allowedContainers];
};

{
	switch (toLower _x) do
	{
		case "uniform":  { _allowUniform = _player canAddItemToUniform _item };
		case "vest":     { _allowVest = _player canAddItemToVest _item };
		case "backpack": { _allowBackpack = _player canAddItemToBackpack _item };
	};
} forEach _allowedContainers;

if (!isNil "_allowUniform") then {
	_return = _allowUniform;
};

if (!isNil "_allowVest") then
{
	_return = _return || _allowVest;
};

if (!isNil "_allowBackpack") then
{
	_return = _return || _allowBackpack;
};

_return
