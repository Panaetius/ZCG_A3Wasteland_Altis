#include "dialog\bountyBoardDefines.sqf";
disableSerialization;
private ["_switch", "_dialog", "_itemlist", "_itemlisttext", "_itemDesc", "_showPicture", "_itemsArray", "_playerSideNum", "_parentCfg", "_weapon", "_picture", "_listIndex", "_showItem", "_factionCfg", "_faction", "_isUniform", "_sideCfg", "_side"];
_switch = _this select 0;

fn_sortArray = 
{
	private ["_list", "_selectSortValue", "_n", "_cols", "_j", "_k", "_h", "_t"];

	_list = +(_this select 0);

	// shell sort
	_n = count _list;
	// we take the increment sequence (3 * h + 1), which has been shown
	// empirically to do well... 
	_cols = [3501671, 1355339, 543749, 213331, 84801, 27901, 11969, 4711, 1968, 815, 271, 111, 41, 13, 4, 1];

	for "_k" from 0 to ((count _cols) - 1) do
	{
	   _h = _cols select _k;
	   for [{_i = _h}, {_i < _n}, {_i = _i + 1}] do
	   {
		  _t = _list select _i;
		  _j = _i;

		  while {(_j >= _h)} do
		  {
			 if (!(((_list select (_j - _h)) select 1) < 
				   (_t select 1))) exitWith {};
			 _list set [_j, (_list select (_j - _h))];
			 _j = _j - _h;
		  };
		  
		  
		  _list set [_j, _t];
	   };
	};

	_list
};

// Grab access to the controls
_dialog = findDisplay bountyBoard_DIALOG;
_itemlist = _dialog displayCtrl bountyBoard_item_list;
_itemlisttext = _dialog displayCtrl bountyBoard_item_TEXT;
_itemDesc = _dialog displayCtrl bountyBoard_item_desc;

//Clear the list
lbClear _itemlist;
_itemlist lbSetCurSel -1;
_itemlisttext ctrlSetText "";
_itemDesc ctrlSetText "";

_showPicture = true;

_itemsArray = [pvar_bountyBoard, 
	"_x select 1"] call fn_sortArray;
	
_onlinePlayers = [];

{ if (isPlayer _x) then { _onlinePlayers set [count _onlinePlayers, getPlayerUID _x];}; } forEach playableUnits;

{
	_entry = _x;
	
	if ( (_x select 1) > 1000 && {{(_entry select 0) == _x } count _onlinePlayers > 0} ) then
	{
		_listIndex = _itemlist lbAdd format ["%1: %2$", _x select 2, _x select 1];
		_itemlist lbSetData [_listIndex, _x select 0];
	};
} forEach _itemsArray;
