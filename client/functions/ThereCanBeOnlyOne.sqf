if (isDedicated) exitWith {};


fnc_PickUpRelic = 
{
	private ["_relic"];
	_relic = (nearestObjects [player, ["Sign_Arrow_Large_Yellow_F"], 11]) select 0;
	player setVariable ["RelicCount", (player getVariable ["RelicCount", 0]) + (_relic getVariable ["RelicCount", 1]), true];
	
	systemChat format ["You now own %1 relics! Get all of them and prove that you are the One!", player getVariable ["RelicCount", 0]];
	
	deleteVehicle _relic;
};

fnc_DropRelic = 
{
	_amount = player getVariable ["RelicCount", 0];
	
	if ( _amount == 0) exitWith {};
	
	SpawnDroppedRelic = [player, false];
	publicVariableServer "SpawnDroppedRelic";
	
	systemChat "You dropped all your relics";
};