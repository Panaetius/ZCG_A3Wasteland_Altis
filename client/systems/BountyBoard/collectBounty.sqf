_corpse = _this select 0;

if (_corpse getVariable ["BountyCollectionActive", false]) exitWith
{
	hint "Bounty is already being collected. Better luck next time!";
};

_corpse setVariable ["BountyCollectionActive", true, true];

playerCollectBounty = _this;
publicVariableServer "playerCollectBounty";

hint parseText format ["Collected %1$ Bounty!", _this select 3];