#include "dialog\bountyboardDefines.sqf";
disableSerialization;

private ["_genshopDialog", "_Dialog", "_playerMoney", "_money", "_owner"];
_bountyBoardDialog = createDialog "bountyboardd";

_Dialog = findDisplay  bountyBoard_DIALOG;
_playerMoney = _Dialog displayCtrl  bountyBoard_money;
_money = player getVariable "cmoney";
_playerMoney ctrlSetText format["Cash: $%1", _money];
