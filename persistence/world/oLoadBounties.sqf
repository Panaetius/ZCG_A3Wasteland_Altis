diag_log "oLoadBountyBoards started";
_bountyBoardCount = call sqlite_countBountyBoard;
diag_log text format ["Loading %1 bounties", _bountyBoardCount];
if (isNil "_bountyBoardCount" || _bountyBoardCount == 0) exitWith {};


_stepSize = 50;

_bounties = [];

for "_i" from 0 to (_bountyBoardCount) step _stepSize do
{
	_bountyBoards = [_i, _stepSize] call sqlite_loadBountyBoard;
	
	{
		_id = _x select 0;
		_money = parseNumber (_x select 1);
		_playerName = _x select 2;
		
		_bounties set [count _bounties, [_id, _money, _playerName]];
	} forEach _bountyBoards;
};

pvar_bountyBoard = _bounties;
publicVariable "pvar_bountyBoard";

diag_log format["GoT Wasteland - bountyBoards loaded %1 entries from DB", _bountyBoardCount];
