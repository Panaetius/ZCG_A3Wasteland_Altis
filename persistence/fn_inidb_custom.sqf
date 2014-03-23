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

PDB_databaseNameCompiler = {
	_return = "";
	_name = _this;
	_prefix = PDB_ServerID;
	_return = format["%1%2", _prefix, _name];
	_return;
};

iniDB_version = {
	private["_data"];
	_player = "Arma2Net.Unmanaged" callExtension "Arma2NETMySQLCommand ['players', 'SELECT Count(*) FROM Player']";
	_data = "iniDB" callExtension "version";
	_data
};

iniDB_HashFunction = {
	private["_mode", "_data"];
	_mode = _this select 0;
	_data = _this select 1;
	
	if((typeName _data) == "STRING") then {	
		_data = "iniDB" callExtension format["%1;%2", _mode, _data];
		_cdata = call compile _data;

		if((_cdata select 0)) then {
			_cdata select 1
		} else {
			nil
		};
	} else {
		nil
	};
};

iniDB_CRC32 = {
	_this = ["crc", _this] call iniDB_HashFunction;
	_this
};

iniDB_MD5 = {
	_this = ["md5", _this] call iniDB_HashFunction;
	_this
};

iniDB_Base64Encode = {
	_this = ["b64_enc", _this] call iniDB_HashFunction;
	_this
};

iniDB_Base64Decode = {
	_this = ["b64_dec", _this] call iniDB_HashFunction;
	_this
};

iniDB_exists = {
	private["_data"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_exists called with %1", _this]; };
	_data = "iniDB" callExtension format["exists;%1", _this];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_exists returned %1", _data]; };
	_cdata = call compile _data;
	
	if((_cdata select 0) && (_cdata select 1)) then {
		true
	} else {
		false
	};
};


iniDB_delete = {
	_data = "iniDB" callExtension format["delete;%1", _this];
	_cdata = call compile _data;
	
	if((_cdata select 0)) then {
		true
	} else {
		false
	};
};

// =======================================================================

iniDB_readRaw = {
	private["_file", "_sec", "_key", "_data"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_readRaw called with %1", _this]; };
	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = "iniDB" callExtension format["read;%1;%2;%3", _file, _sec, _key];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_readRaw returned '%1'", _data]; };
	_cdata = [false];
	// Better handling of empty strings which don't compile well
	if (_data != "") then {
		_cdata = call compile _data;
	};
	
	if((_cdata select 0)) then {
		_cdata select 1
	} else {
		""
	};
};

iniDB_writeRaw = {
	private["_file", "_sec", "_key", "_val", "_data"];
	if (__DEBUG_INIDB_CALLS__ == 1) then {diag_log format["iniDB_writeRaw called with %1", _this];};

	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_val = _this select 3;
	_data = "iniDB" callExtension format["write;%1;%2;%3;%4", _file, _sec, _key, _val];
	_cdata = call compile _data;

	if((_cdata select 0)) then {
		true
	} else {
		false
	};
};

// =======================================================================

iniDB_Datarizer = {
	private["_string", "_type", "_return"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_Datarizer called with %1", _this]; };
	_string = _this select 0;
	_type = _this select 1;
	
	if(_type == "ARRAY") then {
		_return = call compile _string;
	} else {
		if((_type == "SCALAR") || (_type == "NUMBER")) then { // "NUMBER" is less confusing for new folks
			_return = parseNumber _string;
		} else {
			_return = _string;
		};
	};
	
	_return
};

iniDB_read = {
	private["_file", "_sec", "_key", "_type", "_data"];
	if (__DEBUG_INIDB_CALLS__ == 1) then { diag_log format["iniDB_read called with %1", _this]; };

	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = [_file, _sec, _key] call iniDB_readRaw;
	
	if((count _this) > 2) then {
		_type = _this select 3;
		_data = [_data, _type] call iniDB_Datarizer;
	};
	
	_data
};

iniDB_write = {
	private["_file", "_sec", "_key", "_data"];
	if (__DEBUG_INIDB_CALLS__ == 1) then {diag_log format["iniDB_write called with %1", _this];};

	_file = _this select 0;
	_sec = _this select 1;
	_key = _this select 2;
	_data = _this select 3;
	
	_data = format['"%1"', _data];
	_data = [_file, _sec, _key, _data] call iniDB_writeRaw;
	_data
};

sqlite_savePlayer = {
	private ["_array", "_uid", "_varValue", "_res", "_query"];
	diag_log text format ["%1, %2: PerfLog11", diag_tickTime, _uid];
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
		_varValue select 13,
		_varValue select 15
		];
	
	_query = _query + "INSERT INTO Item (PlayerId, Type, Name) Values ";
	
	{
		_query = _query + format ["('%1', 'PrimaryWeaponItem', ''%2''),", _uid, _x];
	}forEach (_varValue select 12);
	
	{
		_query = _query + format [" ('%1', 'SecondaryWeaponItem', ''%2''),", _uid, _x];
	}forEach (_varValue select 14);
	
	{
		_query = _query + format ["('%1', 'HandgunWeaponItem', ''%2''),", _uid, _x];
	}forEach (_varValue select 16);
	
	{
		_query = _query + format ["('%1', 'Items', ''%2''),", _uid, _x];
	}forEach (_varValue select 17);
	
	{
		_query = _query + format [" ('%1', 'AssignedItem', ''%2''),", _uid, _x];
	}forEach (_varValue select 18);
	
	{
		_query = _query + format [" ('%1', 'magWithAmmo', ''%2''),", _uid, _x];
	}forEach (_varValue select 19);
	
	{
		_query = _query + format ["('%1', 'inventoryItem', ''%2''),", _uid, _x];
	}forEach (_varValue select 20);
	
	_query = [_query, ([_query] call KRON_StrLen) - 1] call KRON_StrLeft;
	
	_query = _query + ";COMMIT;";
	
	_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
	diag_log text format ["%1, %2: PerfLog12", diag_tickTime, _uid];
};

sqlite_readPlayer = {
	private ["_array", "_uid", "_data", "_player", "_query", "_items"];
	_array = _this;
	_uid = _array select 1;
	
	diag_log "perf111";
	
	_query = format ["SELECT * FROM Player WHERE Id=''%1'' LIMIT 1", _uid];
	_player = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
	
	diag_log "perf112";
	
	_query = format ["SELECT * FROM Item WHERE PlayerId=''%1''", _uid];
	_items = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
	
	diag_log "perf113";
	
	_data = ((call compile _player) select 0) select 0;
	_data set [count _data, (call compile _items) select 0];
	
	_data
};

sqlite_deletePlayer = {
	private "_res";
	diag_log "delete called";
	_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', 'Delete FROM Player WHERE Id=''%1''']", _this];
	_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', 'Delete FROM Item WHERE PlayerId=''%1''']", _this];
	
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

sqlite_saveBaseObjects = {
	private ["_query", "_res"];
	_query = _this;
	_query = [_query, ([_query] call KRON_StrLen) - 1] call KRON_StrLeft;
	_query = "START TRANSACTION;DELETE FROM Objects;" + _query + ";COMMIT;";
	_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', '%1']", _query];
};

sqlite_countObjects = {
	_res = "Arma2Net.Unmanaged" callExtension "Arma2NETMySQLCommand ['players', 'SELECT Count(*) FROM Objects']";
	_res = parseNumber ((((call compile _res) select 0) select 0) select 0);
	_res
};

sqlite_loadBaseObjects = {
	private "_res";
	_res = "Arma2Net.Unmanaged" callExtension format ["Arma2NETMySQLCommand ['players', 'SELECT * FROM Objects WHERE Id > %1 ORDER BY Id ASC LIMIT %2']", _this select 0, _this select 1];
	_res = ((call compile _res) select 0);
	_res
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