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
	
	_items = [];
	
	{
		_class = _x select 0;
		_count = _x select 1;
		_elem = ['magWithAmmo', [_class, _count]];
		_items set [count _items, _elem];
	} forEach (magazinesAmmoFull player);
	
	
	{
		_keyName = _x select 0;
		_value = _x select 1;
		_items set [count _items, ['inventoryItem',[_x select 0, _x select 1]]];
	} forEach call mf_inventory_all;
	
	{
		_class = _x;
		_elem = ['PrimaryWeaponItem', _class];
		_items set [count _items, _elem];
	} forEach (primaryWeaponItems player);
	
	{
		_class = _x;
		_elem = ['SecondaryWeaponItem', _class];
		_items set [count _items, _elem];
	} forEach (secondaryWeaponItems player);
		
	{
		_class = _x;
		_elem = ['HandgunWeaponItem', _class];
		_items set [count _items, _elem];
	} forEach (handgunItems player);
	
	{
		_class = _x;
		_elem = ['Items', _class];
		_items set [count _items, _elem];
	} forEach (items player);
	
	{
		_class = _x;
		_elem = ['AssignedItem', _class];
		_items set [count _items, _elem];
	} forEach (assignedItems player);
	
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
		SecondaryWeapon player,
		handgunWeapon player,
		_items
	];
	
	player globalChat "Saving Player (this may take a couple of seconds)";
	
	[_uid, _uid, "PlayerData", _playerData, player, _showMessage] call fn_SaveToServer;
	
	// if (isNil "_showMessage" || _showMessage) then {
		// player globalChat "Player saved!";
	// };
};

// Possible new methods

