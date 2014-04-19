if (isDedicated) exitWith {};

"AddPrincessHandler" addPublicVariableEventHandler {
	private [  "_cDT", "_princess" ];
	_princess = _this select 1;
	if(isNil "princessActionId") then {
		_princess setName "Princess";
		princessActionId = _princess addAction [ "Free", { call FreePrincess; }, [], 10, false, false ];
	};
};

"DeletePrincessHandler" addPublicVariableEventHandler {
	private [  "_cDT", "_princess" ];
	_princess = _this select 1;
	if(!isNil "princessActionId") then {
		_princess removeAction princessActionId;
		princessActionId = nil;
	};
};

FreePrincess = {
	private [ "_princess", "_caller" ];
	_princess = _this select 0;
	_caller = _this select 1;	
	
	_princess setVariable ["Master", _caller, true];
	
	FreedPrincessHandler = [_princess, _caller];
	publicVariable "FreedPrincessHandler";
	
	waitUntil {(group _princess) == (group _caller)};
	
	(group _caller) setCombatMode "BLUE";
	(group _caller) setBehaviour "CARELESS";
	(group _caller) setFormation "COLUMN";
	
	[_princess] doFollow _caller;
	
	_princess setVariable ["Freed", true, true];
	
	_princess switchmove "";
	
	_princess enableAI 'ANIM';
	_princess enableAI 'AUTOTARGET';
	_princess enableAI 'MOVE';
	
	_princess setUnitPos "up";
	
	_princess groupChat "Hello Handsome! I'm the princess teeheehee";
	sleep 1;
	_princess groupChat "Get me to the extraction site and I will make it worth your while, if you know what I mean! ;)";
	sleep 1;
	_princess groupChat "teeheehee";
	
	while {alive _caller && ((_princess getVariable ["Master", nil]) == _caller) && (group _princess) == (group _caller)} do {
		_princess setUnitPos "up";
		[_princess] doFollow _caller;
		
		if (vehicle _caller != _caller ) then {
			if (vehicle _princess != vehicle _caller) then {
				_princess moveInCargo (vehicle _caller);
				_princess assignAsCargo (vehicle _caller);
			};
		};
		
		if (vehicle _caller == _caller && vehicle _princess != _princess) then {
			_princess action ["eject", vehicle _princess];
		};
		
		sleep 0.5;
	};
};