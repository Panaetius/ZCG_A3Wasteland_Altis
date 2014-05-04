//	@file Name: c_savePlayerData.sqf
//	@file Author: AgentRev

if (isDedicated) exitWith {};
if (!isNil "savePlayerHandle" && {typeName savePlayerHandle == "SCRIPT"} && {!scriptDone savePlayerHandle}) exitWith {};

savePlayerHandle = _this spawn
{
	if(player getVariable ["IsSaving", false]) exitWith {cutText ["\nAlready saving", "PLAIN DOWN", 0.2]};
	if (alive player &&
	   {!isNil "isConfigOn" && {["A3W_playerSaving"] call isConfigOn}} &&
	   {!isNil "playerSetupComplete" && {playerSetupComplete}} &&
	   {!isNil "respawnDialogActive" && {!respawnDialogActive}}) then
	{
		player setVariable ["IsSaving", true, true];
		_uid = getPlayerUID player;
		_manualSave = [_this, 0, false, [false]] call BIS_fnc_param;

		// In case script is triggered via menu action
		if (!_manualSave) then
		{
			_manualSave = [_this, 3, false, [false]] call BIS_fnc_param;
		};
	
		_items = [];
			
		{
			_keyName = _x select 0;
			_value = _x select 1;
			_items set [count _items, ['inventoryItem',[_x select 0, _x select 1]]];
		} forEach call mf_inventory_all;
		
		{
			_class = _x select 0;
			_ammoCount = _x select 1;
			_isLoaded = _x select 2;
			_type = _x select 3;
			_container = _x select 4;
			
			_elem = [];
			
			switch (_type) do {
				case 1://primary weapon mag
				{
					_elem = ['PrimaryWeaponMag', [_class, _ammoCount]];
				};
				case 2://handgun mag
				{
					_elem = ['HandgunMag', [_class, _ammoCount]];
				};
				case 4://secondary weapon mag
				{
					_elem = ['SecondaryWeaponMag', [_class, _ammoCount]];
				};
				default 
				{
					switch (_container) do {
						case "Vest":
						{
							_elem = ['Vest', [_class, _ammoCount]];
						};
						case "Backpack":
						{
							_elem = ['Backpack', [_class, _ammoCount]];
						};
						case "Uniform":
						{
							_elem = ['Items', [_class, _ammoCount]];
						};
					};
				};
			};
			
			if (count _elem > 0) then {
				_items set [count _items, _elem];
			};
		} forEach (magazinesAmmoFull player);
		
		{
			_class = _x;
			if(_class != "") then
			{
				_elem = ['PrimaryWeaponItem', _class];
				_items set [count _items, _elem];
			};
		} forEach (primaryWeaponItems player);
		
		_magsAmmo = [];
		{
			_class = _x;
			if(_class != "") then
			{
				_elem = ['SecondaryWeaponItem', _class];
				_items set [count _items, _elem];
			};
		} forEach (secondaryWeaponItems player);
		{
			_class = _x;
			
			if(_class != "") then
			{
				_elem = ['HandgunWeaponItem', _class];
				_items set [count _items, _elem];
			};
		} forEach (handgunItems player);
		
		{
			if ( !(isClass (configFile >> "CFGMagazines" >> _x))) then {
				_class = _x;
				_elem = ['Vest', _class];
				_items set [count _items, _elem];
			};
		} forEach (vestItems player);
		
		{
			if ( !(isClass (configFile >> "CFGMagazines" >> _x))) then {
				_class = _x;
				_elem = ['Backpack', _class];
				_items set [count _items, _elem];
			};
		} forEach (backpackItems player);
		
		{
			if ( !(isClass (configFile >> "CFGMagazines" >> _x))) then {
				_class = _x;
				_elem = ['Items', _class];
				_items set [count _items, _elem];
			};
		} forEach (uniformItems player);
		
		{
			_class = _x;
			if(_class != "") then
			{
				_elem = ['AssignedItem', _class];
				_items set [count _items, _elem];
			};
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
			_items,
			["hungerLevel", 0] call getPublicVar,
			["thirstLevel", 0] call getPublicVar
		];

		if (alive player) then
		{
			savePlayerData = [_UID, _playerData, player, _manualSave];
			publicVariableServer "savePlayerData";

			if (_manualSave) then
			{
				cutText ["\nSaving Player (this may take a couple of seconds)", "PLAIN DOWN", 0.2];
			};
		};
	};
};

if (typeName savePlayerHandle == "SCRIPT") then
{
	_savePlayerHandle = savePlayerHandle;
	waitUntil {scriptDone _savePlayerHandle};
	savePlayerHandle = nil;
};
