//	@file Name: c_applyPlayerData.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};

private ["_varValue", "_i", "_in", "_exe", "_backpack", "_sendToServer", "_uid", "_items"];
diag_log format["applyPlayerDonatorValues called with %1", _this];
_varValue = _this;
_uid = _varValue select 0;

// Donation error catch
if(((getPlayerUID player) != _uid) AND ((getPlayerUID player) + "_donation" != _uid)) exitWith {};

//if there is not a value for items we care about exit early
if (isNil '_varValue') exitWith {};
sleep 0.1;

_money = parseNumber (_varValue select 1);
if (_money > 0) then {
	player setVariable ["cmoney", _money, true];
};

_food = parseNumber (_varValue select 2);
if (_food > 0) then {
	[MF_ITEMS_CANNED_FOOD, _food] call mf_inventory_add;
};

_drink = parseNumber (_varValue select 3);
if (_drink > 0) then {
	[MF_ITEMS_WATER, _drink] call mf_inventory_add;
};

_repairs = parseNumber (_varValue select 4);
if (_repairs > 0) then {
	[MF_ITEMS_REPAIR_KIT, _repairs] call mf_inventory_add;
};

_uniform = (_varValue select 5);
if (_uniform != "") then {
	removeUniform player;
	player addUniform _uniform;
};

_vest = (_varValue select 6);
if (_vest != "") then {
	removeVest player;
	player addVest _vest;
};

_backpack = (_varValue select 7);
if (_backpack != "") then {
	removeBackpack player;
	player addBackpack _backpack;
};

_headgear = (_varValue select 8);
if (_headgear != "") then {
	removeHeadgear player; 
	player addHeadgear _headgear;
};

_goggles = (_varValue select 9);
if( _goggles != "") then {
	removeGoggles player;
	player addGoggles _goggles;
};

_inventory = call compile (_varValue select 13);
if( (!isNil "_inventory") && {count _inventory > 0}) then {
	{
		_name = _x;
		if (isClass (configFile >> "CFGMagazines" >> _name)) then {
			player addMagazine _name;
		}
		else
		{
			player addItem _name;
		};
	} forEach _inventory;
};

_primary = (_varValue select 10);
if( _primary != "") then {
	if (primaryWeapon player != "") then 
	{
		player removeWeapon (primaryWeapon player);
	};
	player addWeapon _primary;
};

_secondary = (_varValue select 11);
if( _secondary != "") then {
	if (secondaryWeapon player != "") then 
	{
		player removeWeapon (secondaryWeapon player);
	};
	player addWeapon _secondary;
};

_handgun = (_varValue select 12);
if( _handgun != "") then {
	if (handgunWeapon player != "") then 
	{
		player removeWeapon (handgunWeapon player);
	};
	player addWeapon _handgun;
};

_hasGPS = parseNumber (_varValue select 14);
if( _hasGPS > 0) then {
	player linkItem "ItemGPS";
};

_hasNVG = parseNumber (_varValue select 15);
if( _hasNVG > 0) then {
	player linkItem "NVGoggles";
};