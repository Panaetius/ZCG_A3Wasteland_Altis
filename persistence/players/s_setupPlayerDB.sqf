//	@file Name: s_setupPlayerDB.sqf
//	@file Author: AgentRev

if (!isServer) exitWith {};

doSavePlayerData = {
	_array = _this select 1;
	
	_handle = _array spawn sqlite_savePlayer;	
	_clientId = owner (_array select 2);
	_sendResponse = _array select 3;
	
	waitUntil {sleep 0.1; scriptDone _handle};
	confirmSave = _sendResponse;
	_clientId publicVariableClient 'confirmSave';
} call mf_compile;

"savePlayerData" addPublicVariableEventHandler
{
	_this spawn doSavePlayerData; //need to call this with spawn otherwise the waitUntil wouldn't work
};

"requestPlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;
	_UID = getPlayerUID _player;
	
	if (_UID call sqlite_exists) then
	{
		applyPlayerData = _UID call sqlite_readPlayer;
	}
	else
	{
		applyPlayerData = [];
	};

	(owner _player) publicVariableClient "applyPlayerData";
};

"requestDonatorData" addPublicVariableEventHandler
{
	_player = _this select 1;
	_UID = getPlayerUID _player;
	
	if (_UID call sqlite_donatorExists) then
	{
		applyDonatorData = _UID call sqlite_readDonator;
	}
	else
	{
		applyDonatorData = [];
	};

	(owner _player) publicVariableClient "applyDonatorData";
};

"deletePlayerData" addPublicVariableEventHandler
{
	_player = _this select 1;
	_UID = getPlayerUID _player;
	
	_UID call sqlite_deletePlayer;
};


_createWarchestToDB =
"
	_this call sqlite_createWarchest;
";

createWarchestToDB = compile _createWarchestToDB;

_updateWarchestToDB =
"
	_this call sqlite_saveWarchest;
";

updateWarchestToDB = compile _updateWarchestToDB;

_deleteWarchestFromDB =
"
	_this call sqlite_deleteWarchest;
";

deleteWarchestFromDB = compile _deleteWarchestFromDB;

_saveBeaconToDB =
"
	_this call sqlite_saveBeacon;
";
saveBeaconToDB = compile _saveBeaconToDB;

_updateBeaconToDB =
"
	_this call sqlite_updateBeacon;
";

updateBeaconToDB = compile _updateBeaconToDB;

_deleteBeaconFromDB =
"
	_this call sqlite_deleteBeacon;
";

deleteBeaconFromDB = compile _deleteBeaconFromDB;

"createWarchest" addPublicVariableEventHandler {
	(_this select 1) spawn createWarchestToDB;
};

"updateWarchest" addPublicVariableEventHandler {
	(_this select 1) spawn updateWarchestToDB;
};

"deleteWarchest" addPublicVariableEventHandler {
	(_this select 1) spawn deleteWarchestFromDB;
};

"saveBeacon" addPublicVariableEventHandler {
	(_this select 1) spawn saveBeaconToDB;
};
"updateBeacon" addPublicVariableEventHandler {
	(_this select 1) spawn updateBeaconToDB;
};

"deleteBeacon" addPublicVariableEventHandler {
	(_this select 1) spawn deleteBeaconFromDB;
};
