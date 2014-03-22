private["_donation","_UID"];
sleep 3;
player globalchat "Loading player account...";

//Requests info from server in order to download stats
_UID = getPlayerUID player;

diag_log text format ["%1: PerfLog1", diag_tickTime];

if ((call config_player_donations_enabled) == 1) then {
	// Get any donation info they might have made
	_donation = _UID + "_donation";
	[_donation, _donation, "DonationMoney", "NUMBER"] call sendToServer;
};

diag_log text format ["%1: PerfLog2", diag_tickTime];

// Player location + health
[_UID, _UID, "Health", "NUMBER"] call sendToServer;
[_UID, _UID, "Position", "ARRAY"] call sendToServer;
[_UID, _UID, "Direction", "NUMBER"] call sendToServer;
[_UID, _UID, "Money", "NUMBER"] call sendToServer;

diag_log text format ["%1: PerfLog3", diag_tickTime];

// Survival + wasteland inventory
{
	_keyName = _x select 0;
	diag_log format["calling sendToServer with %1", _keyName];
	[_UID, _UID, _keyName, "NUMBER"] call sendToServer;
} forEach call mf_inventory_all;

diag_log text format ["%1: PerfLog4", diag_tickTime];

// Player inventory
[_UID, _UID, "Uniform", "STRING"] call sendToServer;
[_UID, _UID, "Vest", "STRING"] call sendToServer;
[_UID, _UID, "Backpack", "STRING"] call sendToServer;

diag_log text format ["%1: PerfLog5", diag_tickTime];

// Wait on these as we need them present to fit in everything they had on them
waitUntil {!isNil "uniformLoaded"};		
waitUntil {!isNil "vestLoaded"};
waitUntil {!isNil "backpackLoaded"};

diag_log text format ["%1: PerfLog6", diag_tickTime];

[_UID, _UID, "AssignedItems", "ARRAY"] call sendToServer;
[_UID, _UID, "MagazinesWithAmmoCount", "ARRAY"] call sendToServer;

//wait until everything has loaded in to add items

diag_log text format ["%1: PerfLog7", diag_tickTime];

[_UID, _UID, "Items", "ARRAY"] call sendToServer;
waitUntil {!isNil "itemsLoaded"};

diag_log text format ["%1: PerfLog11", diag_tickTime];

[_UID, _UID, "PrimaryWeapon", "STRING"] call sendToServer;
[_UID, _UID, "SecondaryWeapon", "STRING"] call sendToServer;
[_UID, _UID, "HandgunWeapon", "STRING"] call sendToServer;
waitUntil {!isNil "primaryLoaded"};
diag_log text format ["%1: PerfLog12", diag_tickTime];
waitUntil {!isNil "secondaryLoaded"};
diag_log text format ["%1: PerfLog13", diag_tickTime];
waitUntil {!isNil "handgunLoaded"};

diag_log text format ["%1: PerfLog8", diag_tickTime];

[_UID, _UID, "PrimaryWeaponItems", "ARRAY"] call sendToServer;
[_UID, _UID, "SecondaryWeaponItems", "ARRAY"] call sendToServer;
[_UID, _UID, "HandgunItems", "ARRAY"] call sendToServer;

//[_UID, _UID, "PrimaryMagazine", "ARRAY"] call sendToServer;
//[_UID, _UID, "SecondaryMagazine", "ARRAY"] call sendToServer;
//[_UID, _UID, "HandgunMagazine", "ARRAY"] call sendToServer;

[_UID, _UID, "HeadGear", "STRING"] call sendToServer;
[_UID, _UID, "Goggles", "STRING"] call sendToServer;

diag_log text format ["%1: PerfLog9", diag_tickTime];


//===========================================================================

//END
statsLoaded = 1;
titleText ["","BLACK IN",4];

//fixes the issue with saved player being GOD when they log back on the server!
player allowDamage true;

diag_log text format ["%1: PerfLog10", diag_tickTime];

// Remove unrealistic blur effects
ppEffectDestroy BIS_fnc_feedback_fatigueBlur;
ppEffectDestroy BIS_fnc_feedback_damageBlur;

player globalchat "Player account loaded!";
