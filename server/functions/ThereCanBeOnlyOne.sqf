if (!isDedicated) exitWith {};

"AddRelicsToPlayer" addPublicVariableEventHandler
{
	_array = _this select 1;
	_killer = _array select 0;
	_killed = _array select 1;
	
	_pos = getPos _killed;
	_pos spawn spawnLightning;
	
	_killer setVariable ["RelicCount", (_killer getVariable ["RelicCount", 0]) + (_killed getVariable ["RelicCount", 0]), true];
	
	_killed setVariable ["RelicCount", 0, true];
};

"SpawnDroppedRelic" addPublicVariableEventHandler
{
	_unit = (_this select 1) select 0;
	_showLightning = (_this select 1) select 1;
	
	_amount = _unit getVariable ["RelicCount", 0];
	_pos = getPos _unit;
	
	if (_showLightning) then 
	{
		_pos spawn spawnLightning;
	};
	
	_object = createVehicle ["Sign_Arrow_Large_Yellow_F", _pos, [], 0, "NONE"];
	_object setPosATL _pos;
	_object setVariable ["RelicCount", _amount, true];
	
	_marker = createMarker [format ["ThereCanBeOnlyOneObject_%1", (count relicArray) + 1], _pos];
	_marker setMarkerType "mil_destroy";
	_marker setMarkerSize [1.25, 1.25];
	_marker setMarkerColor "ColorRed";
	_marker setMarkerText "Ancient Object";
	
	relicArray set [count relicArray, [_object, _marker]];
	
	_unit setVariable ["RelicCount", 0, true];
};

spawnLightning = 
{
	private ["_pos", "_center", "_group", "_zlb"];
	_pos = _this;
	_center = createCenter sideLogic;
	_group = createGroup _center;  
	
	_zlb = _group createUnit ["ModuleLightning_F",_pos,[],0,"FORM"];
	sleep 1;
	deleteVehicle _zlb;
	deleteGroup _group;
};