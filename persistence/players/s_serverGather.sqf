private ["_saveToDB","_array","_varName","_varValue","_saveArray","_loadFromDB","_type","_loadArray", "_savePlayerToSqlite","_res"];

_savePlayerToSqlite =
"
	_this call sqlite_savePlayer;	
	_clientId = owner (_this select 4);
	_sendResponse = _this select 5;
	
	if (_sendResponse) then {
		confirmSave = _this select 0;
		_clientId publicVariableClient 'confirmSave';
	};
";

savePlayerToSqlite = compile _savePlayerToSqlite;

_loadFromDB =
"
	_array = _this;
	_uid = _array select 1;
	_varName = _array select 2;
	_varType = _array select 3;
	_clientId = owner (_array select 4);
	
	if ([_uid] call accountExists) then {
		_loadArray = [_uid, _uid, _varName, _varType];
		accountToClient = [_uid,_varName,_loadArray call sqlite_readPlayer];
		_clientId publicVariableClient 'accountToClient';
	} else {
		accountToClient = [_uid, _varName];
		_clientId publicVariableClient 'accountToClient';
	};
";

loadFromDB = compile _loadFromDB;

_saveBasePart =
"
	_this call sqlite_saveBasePart;
";

saveBasePart = compile _saveBasePart;

_unsaveBasePart =
"
	_this call sqlite_unsaveBasePart;
";

unsaveBasePart = compile _unsaveBasePart;

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

"baseToServerSave" addPublicVariableEventHandler 
{
	(_this select 1) spawn saveBasePart;
};

"baseToServerUnsave" addPublicVariableEventHandler 
{
	(_this select 1) spawn unsaveBasePart;
};

