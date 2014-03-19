//	@file Version: 1.0
//	@file Name: largeGroup.sqf
//	@file Author: [404] Deadbeat, [404] Costlyy
//	@file Created: 08/12/2012 21:58
//	@file Args:

if (!isServer) exitWith {};

private ["_group","_pos","_leader","_man2","_man3","_man4","_man5","_man6","_man7","_man8","_man9","_man10"];

_group = _this select 0;
_pos = _this select 1;

//Anti Air no weapon
_leader = _group createunit ["C_man_polo_1_F", [(_pos select 0) + 30, _pos select 1, 0], [], 0.5, "Form"];removeAllAssignedItems _leader;
_leader addUniform "U_B_CombatUniform_mcam";
_leader addVest "V_PlateCarrier1_rgr";
_leader addMagazine "7Rnd_408_Mag";
_leader addWeapon "srifle_LRR_SOS_F";
_leader addMagazine "7Rnd_408_Mag";
_leader addMagazine "7Rnd_408_Mag";
_leader addMagazine "RPG32_HE_F";
_leader addWeapon "launch_RPG32_F";
_leader addMagazine "RPG32_HE_F";
//Support
_man2 = _group createunit ["C_man_polo_2_F", [(_pos select 0) - 30, _pos select 1, 0], [], 0.5, "Form"];
removeAllAssignedItems _man2;
_man2 addUniform "U_B_CombatUniform_mcam_vest";
_man2 addVest "V_PlateCarrier1_rgr";
_man2 addMagazine "7Rnd_408_Mag";
_man2 addWeapon "srifle_LRR_SOS_F";
_man2 addMagazine "7Rnd_408_Mag";
_man2 addMagazine "7Rnd_408_Mag";
//Rifle_man
_man3 = _group createunit ["C_man_polo_3_F", [_pos select 0, (_pos select 1) + 30, 0], [], 0.5, "Form"];
removeAllAssignedItems _man3;
_man3 addUniform "U_B_CombatUniform_mcam_vest";
_man3 addVest "V_PlateCarrier1_rgr";
_man3 addMagazine "20Rnd_762x51_Mag";
_man3 addWeapon "srifle_EBR_ARCO_pointer_F";
_man3 addMagazine "20Rnd_762x51_Mag";
_man3 addMagazine "20Rnd_762x51_Mag";
//Rifle_man
_man4 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 40, 0], [], 0.5, "Form"];
removeAllAssignedItems _man4;
_man4 addUniform "U_B_CombatUniform_mcam_vest";
_man4 addVest "V_PlateCarrier1_rgr";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addWeapon "srifle_EBR_ARCO_pointer_F";
_man4 addMagazine "20Rnd_762x51_Mag";
_man4 addMagazine "20Rnd_762x51_Mag";

//Sniper
_man5 = _group createunit ["C_man_polo_5_F", [_pos select 0, (_pos select 1) - 30, 0], [], 0.5, "Form"];
removeAllAssignedItems _man5;
_man5 addUniform "U_B_CombatUniform_mcam_vest";
_man5 addVest "V_PlateCarrier1_rgr";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addWeapon "srifle_EBR_ARCO_pointer_F";
_man5 addMagazine "20Rnd_762x51_Mag";
_man5 addMagazine "20Rnd_762x51_Mag";

//Grenadier
_man6 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 40, 0], [], 0.5, "Form"];
removeAllAssignedItems _man6;
_man6 addUniform "U_B_CombatUniform_mcam_vest";
_man6 addVest "V_PlateCarrier1_rgr";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addWeapon "srifle_EBR_ARCO_pointer_F";
_man6 addMagazine "20Rnd_762x51_Mag";
_man6 addMagazine "20Rnd_762x51_Mag";

//Support
_man7 = _group createunit ["C_man_polo_4_F", [(_pos select 0) - 40, _pos select 1, 0], [], 0.5, "Form"];
removeAllAssignedItems _man7;
_man7 addUniform "U_B_CombatUniform_mcam_tshirt";
_man7 addVest "V_PlateCarrier1_rgr";
_man7 addMagazine "20Rnd_762x51_Mag";
_man7 addWeapon "arifle_TRG21_GL_F";
_man7 addMagazine "20Rnd_762x51_Mag";
_man7 addMagazine "20Rnd_762x51_Mag";
_man7 addMagazine "1Rnd_HE_Grenade_shell";
_man7 addMagazine "1Rnd_HE_Grenade_shell";
_man7 addMagazine "1Rnd_HE_Grenade_shell";

//Grenadier
_man8 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 50, 0], [], 0.5, "Form"];
removeAllAssignedItems _man8;
_man8 addUniform "U_B_CombatUniform_mcam_vest";
_man8 addVest "V_PlateCarrier1_rgr";
_man8 addMagazine "20Rnd_762x51_Mag";
_man8 addWeapon "srifle_EBR_ARCO_pointer_F";
_man8 addMagazine "20Rnd_762x51_Mag";
_man8 addMagazine "20Rnd_762x51_Mag";

//Sniper
_man9 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) - 50, 0], [], 0.5, "Form"];
removeAllAssignedItems _man9;
_man9 addUniform "U_B_CombatUniform_mcam_vest";
_man9 addVest "V_PlateCarrier1_rgr";
_man9 addMagazine "20Rnd_762x51_Mag";
_man9 addWeapon "srifle_EBR_ARCO_pointer_F";
_man9 addMagazine "20Rnd_762x51_Mag";
_man9 addMagazine "20Rnd_762x51_Mag";

//Rifle_man
_man10 = _group createunit ["C_man_polo_4_F", [_pos select 0, (_pos select 1) + 30, 0], [], 0.5, "Form"];
removeAllAssignedItems _man10;
_man10 addUniform "U_B_CombatUniform_mcam_vest";
_man10 addVest "V_PlateCarrier1_rgr";
_man10 addMagazine "20Rnd_762x51_Mag";
_man10 addWeapon "srifle_EBR_ARCO_pointer_F";
_man10 addMagazine "20Rnd_762x51_Mag";
_man10 addMagazine "20Rnd_762x51_Mag";

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