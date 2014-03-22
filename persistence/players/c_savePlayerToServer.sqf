private["_uid", "_showMessage", "_playerData"];

_showMessage = true;

_showMessage = _this select 0;


if(isNil "_showMessage" || typeName _showMessage != "BOOL") then {
	_showMessage = _this select 3;
};

diag_log text format ["SavePlayer: %1 %2", _this, _showMessage];

if(playerSetupComplete) then
{	
	_uid = getPlayerUID player;
	
	magsWithAmmoCounts = [];
	{
		_class = _x select 0;
		_count = _x select 1;
		_elem = [_class, _count];
		magsWithAmmoCounts set [count magsWithAmmoCounts, _elem];
	} forEach (magazinesAmmoFull player);
	
	inventoryItems = [];
	{
		_keyName = _x select 0;
		_value = _x select 1;
		inventoryItems set [count inventoryItems, [_x select 0, _x select 1]];
	} forEach call mf_inventory_all;
	
	_playerData = [
		damage player, 
		str(side player), 
		name player, 
		player getVariable ["cmoney", 0], 
		vest player, 
		uniform player, 
		backpack player, 
		goggles player, 
		headGear player, 
		getPosATL vehicle player,
		direction vehicle player,
		primaryWeapon player,
		primaryWeaponItems player,
		SecondaryWeapon player,
		secondaryWeaponItems player,
		handgunWeapon player,
		handgunItems player,
		items player,
		assignedItems player,
		magsWithAmmoCounts,
		inventoryItems
	];
	
	[_uid, _uid, "PlayerData", _playerData] call fn_SaveToServer;
	
	if (isNil "_showMessage" || _showMessage) then {
		player globalChat "Player saved!";
	};
};

// Possible new methods

