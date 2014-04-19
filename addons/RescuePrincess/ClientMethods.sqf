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
	};
};

"FreedPrincessHandlerClient" addPublicVariableEventHandler {
	private [  "_princess" ];
	_princess = (_this select 1) select 0;
	
	_princess switchmove "";
	
	_princess enableAI 'ANIM';
	_princess enableAI 'AUTOTARGET';
	_princess enableAI 'MOVE';
	
	_princess setUnitPos "up";
};

FreePrincess = {
	private [ "_princess", "_caller" ];
	_princess = _this select 0;
	_caller = _this select 1;	
	
	FreedPrincessHandler = [_princess, _caller];
	publicVariable "FreedPrincessHandler";
	
	_princess setVariable ["Freed", true, true];
	
	sleep 1;
	
	_princess groupChat "Hello Handsome! I'm the princess teeheehee";
	sleep 1;
	_princess groupChat "Get me to the extraction site and I will make it worth your while, if you know what I mean! ;)";
	sleep 1;
	_princess groupChat "teeheehee";
};