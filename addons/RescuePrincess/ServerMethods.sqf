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
	(group _player) setFormation "COLUMN";
	
	FreedPrincessHandlerClient = [_princess, _player];
	publicVariable "FreedPrincessHandlerClient";
	
	while {alive _player && ((_princess getVariable ["Master", nil]) == _player)} do {
		[_princess] doFollow _player;
		
		if (vehicle _player != _player ) then {
			if (vehicle _princess != vehicle _player) then {
				_princess moveInCargo (vehicle _player);
				_princess assignAsCargo (vehicle _player);
			};
		};
		
		if (vehicle _player == _player && vehicle _princess != _princess) then {
			_princess action ["eject", vehicle _princess];
		};
		
		sleep 2;
	};
};