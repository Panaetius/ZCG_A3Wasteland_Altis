//	@file Version: 1.2
//	@file Name: oSave.sqf
//	@file Author: [GoT] JoSchaap, AgentRev
//	@file Description: Vehicle saving script

if (!isServer) exitWith {};

diag_log "oSave started";

// Copy objectList array
_saveableObjects = +R3F_LOG_CFG_objets_lockablevehicles;

while {true} do {
	diag_log "sleeping!";
	sleep 60;
	
	waitUntil {!isLoadingObjects};
	
	_PersistentDB_ObjCount = 1;
	
	_saveQuery = "INSERT INTO Objects (SequenceNumber, Name, Position, Direction, SupplyLeft, Weapons, Magazines, Items, IsVehicle, IsSaved, GenerationCount) VALUES ";
	
	{
		_object = _x;
		
		if (_object getVariable ["objectLocked", false] && {alive _object}) then
		{
			_classname = typeOf _object;
			
			_pos = getPosASL _object;
			_dir = [vectorDir _object] + [vectorUp _object];

			_supplyleft = 0;

			// Save weapons & ammo
			_weapons = getWeaponCargo _object;
			_magazines = getMagazineCargo _object;
			_items = getItemCargo _object;
			_isVehicle = 0;
			
			_isVehicle = 1;
			
			_saveQuery = _saveQuery + format ["(%1, ''%2'', ''%3'', ''%4'', %5, ''%6'', ''%7'', ''%8'', %9, 0, %10),", _PersistentDB_ObjCount, _classname, _pos, _dir, _supplyleft, _weapons, _magazines, _items, _isvehicle, _object getVariable ["generationCount", 0]];
			
			_PersistentDB_ObjCount = _PersistentDB_ObjCount + 1;
			
			//Save in batches so we don't hit the max 4000 char arma2net string length limit
			if ((_PersistentDB_ObjCount % 15) == 0) then { 
				_saveQuery call sqlite_saveBaseObjects;
				
				_saveQuery = "INSERT INTO Objects (SequenceNumber, Name, Position, Direction, SupplyLeft, Weapons, Magazines, Items, IsVehicle, IsSaved, GenerationCount) VALUES ";
			};
		};
	}forEach vehicles;
	
	if ((_PersistentDB_ObjCount > 1) && ((_PersistentDB_ObjCount % 15) != 0)) then {
		_saveQuery call sqlite_saveBaseObjects;
		
		diag_log format["A3W - %1 parts have been saved with DB", _PersistentDB_ObjCount];
	};
	
	call sqlite_commitBaseObject;
	
	sleep 120;
};
