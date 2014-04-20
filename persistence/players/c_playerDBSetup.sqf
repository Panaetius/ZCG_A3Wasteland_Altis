//===========================================================================
applyPlayerDBValues =
{
	private ["_array", "_varName", "_varValue", "_i", "_in", "_exe", "_backpack", "_sendToServer", "_uid", "_items"];
	diag_log format["applyPlayerDBValues called with %1", _this];
	_array = _this;
	_uid = _array select 0;
	_varName = _array select 1;
	
	if (count _array == 3) then
	{
		_varValue = _array select 2;
	}
	else
	{
		 //diag_log format["applyPlayerDBValues failed to get a value for %1", _varName];
	};

	// Donation error catch
	if(((getPlayerUID player) != _uid) AND ((getPlayerUID player) + "_donation" != _uid)) exitWith {};

	//if there is not a value for items we care about exit early
	if (isNil '_varValue') exitWith 	
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
		if ((_x select 2 ) == "inventoryItem") then {
			_entry = call compile (_x select 3); 
			[_entry select 0, _entry select 1, true] call mf_inventory_add;
		};
	} forEach _items;

	if (_varName == 'Health') then {player setDamage _varValue};
	{
		if( (_x select 2 )== "Vest") then {
			_name = (_x select 3);
			
			player addItemToVest _name;
		};
	} forEach _items;
	
	{
		if( (_x select 2 ) == "Backpack") then {
			_name = (_x select 3);
			
			player addItemToBackpack _name;
		};
	} forEach _items;

	//if (_varName == 'Magazines') then {{player addMagazine _x}foreach _varValue};
	if (_varName == 'MagazinesWithAmmoCount') then
	{
			_ammoCounts = _x select 1; // Different ammo counts for current magazine
			
			if (typeName _ammoCounts != "ARRAY") then
				_ammoCounts = [_ammoCounts]; // for compatibility with previous saves
			
			{
				if ([player, _className] call fn_fitsInventory) then
				{
					player addMagazine [_className, _x];
				};
			} forEach _ammoCounts;
	{
		if( (_x select 2 )== "Items") then {
			_name = (_x select 3);
			player addItemToUniform _name;
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
			
			if (_inCfgWeapons) then
			{
				// Its a 'weapon'
				player addWeapon _name;
			}
			else
			{
				player linkItem _name;
			};
		};
	} forEach _items;
	
	player setPos (call compile (_varValue select 10));
	player setVariable["playerWasMoved",1,true];
	positionLoaded = 1;
	
	player setDir (parseNumber (_varValue select 11));
	player setVariable ["cmoney", parseNumber (_varValue select 2), true];
	player setDamage (parseNumber (_varValue select 4));
	
	dataLoaded = 1;
};

//===========================================================================

loadFromServer = compileFinal "accountToServerLoad = _this; publicVariableServer 'accountToServerLoad'";
saveToServer = compileFinal = "accountToServerSave = _this; publicVariableServer 'accountToServerSave'";
"confirmSave" addPublicVariableEventHandler 
{
	if( _this select 1) then {
		player globalChat "Player saved!";
	};
	player setVariable ["IsSaving", false, true];
};
//===========================================================================
"accountToClient" addPublicVariableEventHandler 
{
	(_this select 1) spawn applyPlayerDBValues;
};
//===========================================================================

statFunctionsLoaded = 1;
