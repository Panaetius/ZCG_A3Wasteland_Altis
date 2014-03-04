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

_expaAunit = _unit skillFinal "aimingAccuracy";
_expaSunit = _unit skillFinal "aimingShake";
_expaSpunit = _unit skillFinal "aimingSpeed";
_expEunit = _unit skillFinal "Endurance";
_expsDunit = _unit skillFinal "spotDistance";
_expsTunit = _unit skillFinal "spotTime";
_expCnit = _unit skillFinal "courage";
_exprSunit =_unit skillFinal "reloadSpeed";
_expCounit =_unit skillFinal "commanding";
_expGunit =_unit skillFinal "general";


diag_log format ["unit: %1 aimingAccuracy: %2 aimingShake: %3 aimingSpeed: %4 Endurance: %5 spotDistance: %6 spotTime: %7 courage: %8 reloadSpeed: %9 commanding:%10 general: %11",_unit,_expaAunit,_expaSunit,_expaSpunit,_expEunit,_expsDunit,_expsTunit,_expCnit,_exprSunit,_expCounit,_expGunit];
