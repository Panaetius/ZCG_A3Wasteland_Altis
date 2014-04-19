if (!isDedicated) exitWith {};

"FreedPrincessHandler" addPublicVariableEventHandler {
	private [  "_princess" ];
	_princess = (_this select 1) select 0;
	_player = (_this select 1) select 1;
	
	_princess switchmove "";
	
	_princess enableAI 'ANIM';
	_princess enableAI 'AUTOTARGET';
	_princess enableAI 'MOVE';

	if (group _player == grpNull) then {
		_grp = createGroup (side _player);
		[_player] joinSilent _grp;
	};
	
	[_princess] joinSilent _player;
	_princess setUnitPos "up";
	
	(group _player) setCombatMode "BLUE";
	(group _player) setBehaviour "CARELESS";
	(group _player) setFormation "STAG COLUMN";
	
	sleep 1;
	
	_princess doFollow _player;

	FreedPrincessHandlerClient = [_princess, _player];
	publicVariable "FreedPrincessHandlerClient";
};