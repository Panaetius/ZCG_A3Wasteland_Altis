private["_uid", "_showMessage", "_playerData"];

_showMessage = true;

_showMessage = _this select 0;




if(isNil "_showMessage" || typeName _showMessage != "BOOL") then {
	_showMessage = _this select 3;
};

if (player getVariable ["IsSaving", false]) exitWith {
	if (isNil "_showMessage" || _showMessage) then {
		player globalChat "Can't save right now. Wait a couple of seconds and try again.";
	};
};

player setVariable ["IsSaving", true, true];


diag_log text format ["SavePlayer: %1 %2", _this, _showMessage];

if (playerSetupComplete) then
{	
	_uid = getPlayerUID player;
	
	_items = [];
		
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
	
	_magsAmmo = [];
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
		_elem = ['Vest', _class];
		_items set [count _items, _elem];
	} forEach (vestItems player);
	
	{
		_class = _x;
		_elem = ['Backpack', _class];
		_items set [count _items, _elem];
	} forEach (backpackItems player);
	
	{
		_class = _x;
		_elem = ['Items', _class];
		_items set [count _items, _elem];
	} forEach (uniformItems player);
	
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
	
	[_uid, _uid, "PlayerData", _playerData, player, _showMessage] call fn_SaveToServer;
	
	if (isNil "_showMessage" || _showMessage) then {
		player globalChat "Saving Player (this may take a couple of seconds)";
	};
};

// Possible new methods

