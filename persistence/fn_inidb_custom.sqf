//Persistent Scripts by ZA-Gamers. www.za-gamers.co.za
//Author: {ZAG}Ed!
//Email: edwin(at)vodamail(dot)co(dot)za
//Date: 26/03/2013
//Thanx to iniDB's author SicSemperTyrannis! May you have many wives and children!

// WARNING! This is a modified version for use with the A3W missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap & Bewilderbeest @ http://a3wasteland.com/

#define __DEBUG_INIDB_CALLS__ 0

if(!isServer) exitWith {};

sqlite_savePlayer = {
	private ["_array", "_uid", "_varValue", "_res", "_query"];
	_array = _this;	
	_uid = _array select 1;
	
	_varValue = _array select 3;
	
	//delete stuff
	_query = format ["START TRANSACTION;Delete FROM Player WHERE Id=''%1'';Delete FROM Item WHERE PlayerId=''%1'';", _uid];
	// save values
	_query = _query + format ["INSERT INTO Player (Id,Health,Side,AccountName, Money, Vest, Uniform, Backpack, Goggles, HeadGear,Position, Direction, PrimaryWeapon, SecondaryWeapon, HandgunWeapon) VALUES (''%1'', %2, ''%3'', ''%4'', %5, ''%6'', ''%7'', ''%8'', ''%9'', ''%10'', ''%11'', %12, ''%13'', ''%14'', ''%15'');", 
		_uid, 
		_varValue select 0, 
		_varValue select 1, 
		_varValue select 2,
		_varValue select 3,
		_varValue select 4,
		_varValue select 5,
		_varValue select 6,
		_varValue select 7,
		_varValue select 8,
		_varValue select 9,
		_varValue select 10,
		_varValue select 11,
		_varValue select 12,
		_varValue select 13
		];
	
	_query = _query + "INSERT INTO Item (PlayerId, Type, Name) Values ";
	
	{
		_query = _query + format ["('%1', '%2', ''%3''),", _uid, _x select 0, _x select 1];
	}forEach (_varValue select 14);
		
	_query = [_query, ([_query] call KRON_StrLen) - 1] call KRON_StrLeft;
	
	_query = _query + ";COMMIT;";
	
	_res = nil;
	while {isNil("_res")} do {
		_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
		if (_res == "") then {
                _res = nil;
        };
        sleep 0.5;
	};
};

sqlite_readPlayer = {
	private ["_array", "_uid", "_data", "_player", "_query", "_items"];
	_array = _this;
	_uid = _array select 1;
	
	_query = format ["SELECT * FROM Player WHERE Id=''%1'' LIMIT 1", _uid];
	_player = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
	
	_query = format ["SELECT * FROM Item WHERE PlayerId=''%1''", _uid];
	_items = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
	
	_data = ((call compile _player) select 0) select 0;
	_data set [count _data, (call compile _items) select 0];
	
	_data
};

sqlite_deletePlayer = {
	private "_res";
	diag_log "delete called";
	_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', 'Delete FROM Player WHERE Id=''%1'';Delete FROM Item WHERE PlayerId=''%1'';']", _this];
	
	true
};

sqlite_exists = {
	private ["_player", "_query"];
	_query = format ["SELECT Id FROM Player WHERE Id=''%1'' LIMIT 1", _this];
	_player = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
	
	if (count ((call compile _player) select 0) > 0 ) then 
	{
		true
	} else {
		false
	};
};

sqlite_deleteBaseObjects = {
		_res = "Arma2Net.Unmanaged" callExtension "Arma2NETMySQLCommand ['players', 'DELETE FROM Objects;']";
};

sqlite_saveBaseObjects = {
	private ["_query", "_res"];
	_query = _this;
	_query = [_query, ([_query] call KRON_StrLen) - 1] call KRON_StrLeft;
	_query = "START TRANSACTION;" + _query + ";COMMIT;";
	_res = nil;
	while {isNil("_res")} do {
		_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommandAsync ['players', '%1']", _query];
		if (_res == "") then {
                _res = nil;
        };
        sleep 0.5;
	};
};

sqlite_commitBaseObject = {
	private ["_res"];
	
	_res = nil;
	while {isNil("_res")} do {
		_res = "Arma2Net.Unmanaged" callExtension "Arma2NETMySQLCommand ['players', 'START TRANSACTION;DELETE FROM Objects WHERE IsSaved=1;COMMIT;START TRANSACTION;UPDATE Objects SET IsSaved=1 WHERE IsSaved=0;COMMIT;START TRANSACTION;DELETE FROM objects WHERE Id IN (SELECT * FROM (SELECT DISTINCT o1.Id FROM objects o1 INNER JOIN objects o2 ON o2.Id < o1.Id AND o2.Position = o1.Position AND o2.Name = o1.Name AND o2.issaved = 1 AND o1.IsSaved = 1) as a);COMMIT;']";
		if (_res == "") then {
                _res = nil;
        };
        sleep 0.5;
	};
};

sqlite_deleteUncommitedObjects = {
	private ["_res"];
	
	_res = "Arma2Net.Unmanaged" callExtension "Arma2NETMySQLCommand ['players', 'DELETE FROM objects WHERE IsSaved=0 OR GenerationCount > 9;']";
};

sqlite_countObjects = {
	_res = "Arma2Net.Unmanaged" callExtension "Arma2NETMySQLCommand ['players', 'SELECT Count(*) FROM Objects']";
	_res = parseNumber ((((call compile _res) select 0) select 0) select 0);
	_res
};

sqlite_loadBaseObjects = {
	private "_res";
	
	_res = nil;
	while {isNil("_res")} do {
		_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', 'SELECT * FROM Objects ORDER BY Id ASC LIMIT %1,%2']", _this select 0, _this select 1];
		if (_res == "") then {
                _res = nil;
        };
        sleep 0.5;
	};
	_res = ((call compile _res) select 0);
	_res
};

sqlite_saveBasePart = {
	private ["_query", "_res"];
	_query = _this;
	_query = format ["START TRANSACTION;DELETE FROM objects WHERE IsVehicle=0 AND Name=''%1'' AND Position=''%2'';INSERT INTO Objects (SequenceNumber, Name, Position, Direction, SupplyLeft, Weapons, Magazines, Items, IsVehicle, IsSaved, GenerationCount) VALUES (%3);COMMIT;", _this select 0, _this select 1, _this select 2];
	_res = nil;
	while {isNil("_res")} do {
		_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommandAsync ['players', '%1']", _query];
		if (_res == "") then {
                _res = nil;
        };
        sleep 0.5;
	};
};

sqlite_unsaveBasePart = {
	private ["_query", "_res"];
	_query = _this;
	_query = format ["START TRANSACTION;DELETE FROM objects WHERE IsVehicle=0 AND Name=''%1'' AND Position=''%2'';COMMIT;", _this select 0, _this select 1];
	_res = nil;
	while {isNil("_res")} do {
		_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommandAsync ['players', '%1']", _query];
		if (_res == "") then {
                _res = nil;
        };
        sleep 0.5;
	};
};

sqlite_getVehicleSaveQuery = {
	_classname = typeOf _this;
			
	_pos = getPosASL _this;
	_dir = [vectorDir _this] + [vectorUp _this];

	_supplyleft = 0;

	// Save weapons & ammo
	_weapons = getWeaponCargo _this;
	_magazines = getMagazineCargo _this;
	_items = getItemCargo _this;
	
	_isVehicle = 1;
	
	_saveQuery = format ["(%1, ''%2'', ''%3'', ''%4'', %5, ''%6'', ''%7'', ''%8'', %9, 0, %10),", _PersistentDB_ObjCount, _classname, _pos, _dir, _supplyleft, _weapons, _magazines, _items, _isvehicle, _this getVariable ["generationCount", 0]];
	
	_saveQuery
};

KRON_StrLeft = {
	private["_in","_len","_arr","_out"];
	_in=_this select 0;
	_len=(_this select 1)-1;
	_arr=[_in] call KRON_StrToArray;
	_out="";
	if (_len>=(count _arr)) then {
		_out=_in;
	} else {
		for "_i" from 0 to _len do {
			_out=_out + (_arr select _i);
		};
	};
	_out
};

KRON_StrLen = {
	private["_in","_arr","_len"];
	_in=_this select 0;
	_arr=[_in] call KRON_StrToArray;
	_len=count (_arr);
	_len
};

KRON_StrToArray = {
	private["_in","_i","_arr","_out"];
	_in=_this select 0;
	_arr = toArray(_in);
	_out=[];
	for "_i" from 0 to (count _arr)-1 do {
		_out=_out+[toString([_arr select _i])];
	};
	_out
};