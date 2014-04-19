//	@file Version: 1.0
//	@file Name: setMissionSkill.sqf
//	@file Author: AgentRev
//	@file Created: 21/10/2013 19:14
//	@file Args:

if (!isServer) exitWith {};

private ["_unit", "_skill", "_accuracy"];
_unit = _this;

_skill = if (["A3W_missionsDifficulty", 0] call getPublicVar > 0) then { 0.85 } else { 0.85 };
_accuracy = if (["A3W_missionsDifficulty", 0] call getPublicVar > 0) then { 0.85 } else { 0.85 };

_unit allowFleeing 0;
_unit setSkill _skill;
_unit setSkill ["aimingAccuracy", _accuracy];
_unit setSkill ["courage", 1];
_unit setSkill ["spotDistance", 1];
_unit setSkill ["spotTime", 1];