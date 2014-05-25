private ["_npc", "_type", "_num", "_npcName"];

_board = _this select 0;
_index = _this select 1;

_board addAction ["Check Bounty Board", "client\systems\BountyBoard\loadBountyBoard.sqf", [], 1, false, false, "", "_this distance _target < 3"];
_board allowDamage false;

_boardPos = getPos _board; 
_markerName = format["title_%1", _index];
deleteMarker _markerName;
_marker = createMarker [_markerName, _boardPos];
_markerName setMarkerShape "ICON";
_markerName setMarkerType "mil_dot";
_markerName setMarkerColor "ColorBlue";
_markerName setMarkerSize [1,1];
_markerName setMarkerText "BountyBoard";
