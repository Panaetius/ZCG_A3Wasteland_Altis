//===========================================================================
applyPlayerDBValues =
{
	private ["_array","_varName","_varValue","_i","_in","_exe","_backpack","_sendToServer","_uid", "_items"];
	diag_log format["applyPlayerDBValues called with %1", _this];
	_array = _this;
	_uid = _array select 0;
	_varName = _array select 1;
	
	if (count _array == 3) then {
		_varValue = _array select 2;
	} else {
		 //diag_log format["applyPlayerDBValues failed to get a value for %1", _varName];
	};

	// Donation error catch
	if(((getPlayerUID player) != _uid) AND ((getPlayerUID player) + "_donation" != _uid)) exitWith {};

	//if there is not a value for items we care about exit early
	if(isNil '_varValue') exitWith 	
	{
		dataLoaded = 1;
	};
	
		// if(_varName == 'DonationMoney') then {player setVariable["donationMoney",_varValue,true]; donationMoneyLoaded = 1;};
	
	removeUniform player; 
	player addUniform (_varValue select 6);
	removeVest player; 
	player addVest (_varValue select 5);
	removeBackpack player; 
	player addBackpack (_varValue select 7);
	removeHeadgear player; 
	player addHeadgear (_varValue select 9);
	player addGoggles (_varValue select 8);
	
	_items = _varValue select 15;

	// Inventory item section. Use mf_inventory_all as set up by the mf_inv system
	{
		if ((_x select 2 )== "inventoryItem") then {
			_entry = call compile (_x select 3); 
			[_entry select 0, _entry select 1, true] call mf_inventory_add;
		};
	} forEach _items;

	player setDamage (parseNumber (_varValue select 4));

	{
		if( (_x select 2 )== "magWithAmmo") then {
			_entry = call compile (_x select 3);
			_className = _entry select 0; // eg. 30Rnd_65x39_caseless_mag

			if ([player, _className] call fn_fitsInventory) then
			{
				player addMagazine _entry;
			};
		};
	} forEach _items;
	
	{
		if( (_x select 2 )== "Items") then {
			_name = (_x select 3);
			_backpack = unitBackpack player;
			_inCfgWeapons = isClass (configFile >> "cfgWeapons" >> _name);

			// Optics seems to denote an 'item' if 1 or 'weapon' is 0
			_cfgOptics = getNumber (configFile >> "cfgWeapons" >> _name >> "optics");

			if (_inCfgWeapons && _cfgOptics == 0 && (!isNil '_backpack')) then {_backpack addWeaponCargoGlobal [_name,1];}
			else
			{
				if ([player, _name] call fn_fitsInventory) then
				{
					player addItem _name;
				};
			};
		};
	} forEach _items;	
	
	player addWeapon (_varValue select 12);
	player addWeapon (_varValue select 14);
	player addWeapon (_varValue select 13);

	{
		if( (_x select 2 )== "PrimaryWeaponItem") then {
			_name = (_x select 3);
			diag_log _name;
			if (_name != "") then
			{
				player addPrimaryWeaponItem _name;
			};
		};
	} forEach _items;
		
	{
		if( (_x select 2 )== "SecondaryWeaponItem") then {
			_name = (_x select 3);
			if (_name != "") then
			{
				player addSecondaryWeaponItem _name;
			};
		};
	} forEach _items;
	
	{
		if( (_x select 2 )== "HandgunWeaponItem") then {
			_name = (_x select 3);
			if (_name != "") then
			{
				player addHandgunItem _name;
			};
		};
	} forEach _items;
	
	{
		if( (_x select 2 )== "AssignedItem") then {
			_name = (_x select 3);
			_inCfgWeapons = isClass (configFile >> "cfgWeapons" >> _name);
			if (_inCfgWeapons) then {
				// Its a 'weapon'
				player addWeapon _name;
			} else {
				player linkItem _name;
			};
		};
	} forEach _items;
	
	player setPos (call compile (_varValue select 10));
	player setVariable["playerWasMoved",1,true];
	positionLoaded = 1;
	
	player setDir (parseNumber (_varValue select 11));
	player setVariable ["cmoney", parseNumber (_varValue select 2), true];	
	
	dataLoaded = 1;
};

//===========================================================================
_sendToServer =
"
	accountToServerLoad = _this;
	publicVariableServer 'accountToServerLoad';
";

sendToServer = compile _sendToServer;
//===========================================================================
"accountToClient" addPublicVariableEventHandler 
{
	(_this select 1) spawn applyPlayerDBValues;
};
//===========================================================================

statFunctionsLoaded = 1;
