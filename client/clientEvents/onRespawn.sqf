//	@file Version: 1.0
//	@file Name: onRespawn.sqf
//	@file Author: [404] Deadbeat
//	@file Created: 20/11/2012 05:19
//	@file Args:

private ["_player", "_corpse", "_town", "_spawn", "_temp"];

playerSetupComplete = false;

_player = _this select 0;
_corpse = _this select 1;
axeDiagLog = format ["%1 killed himself", profileName];
publicVariableServer "axeDiagLog";
_corpse removeAction playerMenuId;
{ _corpse removeAction _x } forEach aActionsIDs;
// The actions from mf_player_actions are removed in onKilled.

_bounties = [];

diag_log "Handling bounties";

{
	if ( (_x select 0) == (getPlayerUID _player)) then //add bounty handler and remove bounty from bounty list
	{
		if(_x select 1 > 1000) then {
			_bountyMoney = _x select 1;
			_corpse setVariable ["BountyCollectionActive", false, true];
			[[_corpse, _bountyMoney], "fn_addBountyAction"] spawn BIS_fnc_MP;
		};
	}
	else
	{
		_bounties set [count _bounties, _x ];//add back all other bounty entries
	};
} foreach pvar_bountyBoard;

pvar_bountyBoard = _bounties;
publicVariable "pvar_bountyBoard";

player call playerSetup;

[] execVM "client\clientEvents\onMouseWheel.sqf";

call fn_requestDonatorData;
	
waitUntil {!isNil "donatorData_loaded"};

call playerSpawn;

if (isPlayer pvar_PlayerTeamKiller) then
{
	pDialogTeamkiller = pvar_PlayerTeamKiller;
	pvar_PlayerTeamKiller = objNull;

	[] execVM "client\functions\createTeamKillDialog.sqf";
};
