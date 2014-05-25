//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Basesaving script

if (!isServer) exitWith {};

diag_log "oSaveBounties started";

countStrChars = {
	count (toArray _this);
} call mf_compile;

call sqlite_deleteBountyBoard;

_baseQuery = "INSERT INTO bounties (PlayerId, Bounty, PlayerName) VALUES ";
		
_saveQuery = _baseQuery;

{
	_entry = _x;	
	
	_addQuery = format ["(''%1'', %2, ''%3''),", _entry select 0, _entry select 1, _entry select 2];
	
	//Save in batches so we don't hit the max 4000 char arma2net string length limit
	if ((_saveQuery call countStrChars) + (_addQuery call countStrChars) > 4000) then { 
		_saveQuery call sqlite_saveBountyBoard;
		
		_saveQuery = _baseQuery;
	};
	
	_saveQuery = _saveQuery + _addQuery;
}forEach pvar_bountyBoard;

if ((_saveQuery call countStrChars) > (_baseQuery call countStrChars)) then {
	_saveQuery call sqlite_saveBountyBoard;
};
