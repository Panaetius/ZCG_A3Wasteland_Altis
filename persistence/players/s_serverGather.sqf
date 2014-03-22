private ["_saveToDB","_array","_varName","_varValue","_saveArray","_loadFromDB","_type","_loadArray", "_savePlayerToSqlite","_res"];

_saveToDB =
"
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_varValue = _array select 3;
	_saveArray = [_uid, _uid, _varName, _varValue];
	_saveArray call iniDB_write;
";

saveToDB = compile _saveToDB;

_savePlayerToSqlite =
"
	_this call sqlite_savePlayer;
";

savePlayerToSqlite = compile _savePlayerToSqlite;

_loadFromDB =
"
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_varType = _array select 3;
	
	if ([_uid] call accountExists) then {
		_loadArray = [_uid, _uid, _varName, _varType];
		accountToClient = [_uid,_varName,_loadArray call sqlite_readPlayer];
		publicVariable 'accountToClient';
	} else {
		accountToClient = [_uid, _varName];
		publicVariable 'accountToClient';
	};
";

loadFromDB = compile _loadFromDB;

_accountExists = 
"	
	_uid = _this Select 0;
	_exists = _uid call sqlite_exists;
	_exists
";
accountExists = compile _accountExists;

"accountToServerSave" addPublicVariableEventHandler 
{
	(_this select 1) spawn savePlayerToSqlite;
};

"accountToServerLoad" addPublicVariableEventHandler 
{
	(_this select 1) spawn loadFromDB;
};

