//	@file Version: 1.0
//	@file Name: smallGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy, AgentRev
//	@file Created: 08/12/2012 21:58
//	@file Args:

if (!isServer) exitWith {};

private ["_group", "_pos", "_leader", "_man2", "_man3", "_man4"];

_group = _this select 0;
_pos = _this select 1;

// Leader
_leader = _group createUnit ["C_man_polo_1_F", [(_pos select 0) + 10, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _leader;
_leader addUniform "U_B_CombatUniform_mcam";
_leader addVest "V_PlateCarrier1_rgr";
_leader addMagazine "150Rnd_762x51_Box_Tracer";
_leader addWeapon "LMG_Zafir_pointer_F";
_leader addMagazine "150Rnd_762x51_Box_Tracer";
_leader addMagazine "150Rnd_762x51_Box_Tracer";
_leader addMagazine "RPG32_HE_F";
_leader addWeapon "launch_RPG32_F";
_leader addMagazine "RPG32_HE_F";

// Rifleman
_man2 = _group createUnit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 1, "Form"];
removeAllAssignedItems _man2;
_man2 addUniform "U_B_CombatUniform_mcam_vest";
_man2 addVest "V_PlateCarrier1_rgr";
_man2 addMagazine "30Rnd_65x39_caseless_mag_Tracer";
_man2 addWeapon "arifle_MX_ACO_pointer_F";
_man2 addMagazine "30Rnd_65x39_caseless_mag_Tracer";
_man2 addMagazine "30Rnd_65x39_caseless_mag_Tracer";

// Rifleman
_man3 = _group createUnit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 1, "Form"];
removeAllAssignedItems _man3;
_man3 addUniform "U_B_CombatUniform_mcam_vest";
_man3 addVest "V_PlateCarrier1_rgr";
_man3 addMagazine "30Rnd_65x39_caseless_mag_Tracer";
_man3 addWeapon "arifle_MX_ACO_pointer_F";
_man3 addMagazine "30Rnd_65x39_caseless_mag_Tracer";
_man3 addMagazine "30Rnd_65x39_caseless_mag_Tracer";

// Rifleman
_man4 = _group createUnit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 30, 0], [], 1, "Form"];
removeAllAssignedItems _man4;
_man4 addUniform "U_B_CombatUniform_mcam_vest";
_man4 addVest "V_PlateCarrier1_rgr";
_man4 addMagazine "30Rnd_65x39_caseless_mag_Tracer";
_man4 addWeapon "arifle_MX_ACO_pointer_F";
_man4 addMagazine "30Rnd_65x39_caseless_mag_Tracer";
_man4 addMagazine "30Rnd_65x39_caseless_mag_Tracer";

_leader = leader _group;

_group setCombatMode "WHITE";

{
	_x spawn refillPrimaryAmmo;
	_x spawn addMilCap;
	_x call setMissionSkill;
	_x addRating 9999999;
	_x addEventHandler ["Killed", {_this call server_playerDied; (_this select 1) call removeNegativeScore}];
} forEach units _group;

[_group, _pos] call defendArea;
