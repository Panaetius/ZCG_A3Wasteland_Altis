// WARNING! This is a modified version for use with the GoT Wasteland v2 missionfile!
// This is NOT a default persistantdb script!
// changes by: JoSchaap (GoT2DayZ.nl)
diag_log "oLoad started";
sleep 10;
call sqlite_deleteUncommitedObjects;
_objectscount = call sqlite_countObjects;
diag_log text format ["Loading %1 objects", _objectscount];
if (isNil "_objectscount" || _objectscount == 0) exitWith {isLoadingObjects = false;};

isLoadingObjects = true;

_vehicles = +civilianVehicles + +lightMilitaryVehicles + +mediumMilitaryVehicles + +staticHeliList;

_stepSize = 15;

for "_i" from 0 to (_objectscount) step _stepSize do
{
	_objects = [_i, _stepSize] call sqlite_loadBaseObjects;
	
	{
		_class = _x select 1;
		_pos = call compile (_x select 2);
		_dir = call compile (_x select 3);
		_supplyleft = parseNumber (_x select 4);
		_weapons = call compile (_x select 5);
		_magazines = call compile (_x select 6);
		_items = call compile (_x select 7);
		_isVehicle = parseNumber (_x select 8);
		_generationCount = parseNumber (_x select 11);
		
		if (!isNil "_class" && !isNil "_pos" && !isNil "_dir" && !isNil "_supplyleft") then 
		{
			_type = "NONE";
			_placement = 10;
			
			if(!isNil "_isVehicle" && _isVehicle == 0) then
			{
				_type = "CAN COLLIDE";
				_placement = 0;
			};
			
			_obj = createVehicle [_class, _pos, [], _placement, _type];
			_obj setPosASL _pos;
			_obj setVectorDirAndUp _dir;
			_obj setDamage 0;

			if (_class == "Land_Sacks_goods_F") then 
			{
				_obj setVariable["food",_supplyleft,true];
			};

			if (_class == "Land_BarrelWater_F") then 
			{
				_obj setVariable["water",_supplyleft,true];
			};

			clearWeaponCargoGlobal _obj;
			clearMagazineCargoGlobal _obj;
			clearItemCargoGlobal _obj;

			// disabled because i dont want to load contents just base parts
			for [{_ii = 0}, {_ii < (count (_weapons select 0))}, {_ii = _ii + 1}] do {
				_obj addWeaponCargoGlobal [(_weapons select 0) select _ii, (_weapons select 1) select _ii];				
			};

			for [{_ii = 0}, {_ii < (count (_magazines select 0))}, {_ii = _ii + 1}] do {
				_obj addMagazineCargoGlobal [(_magazines select 0) select _ii, (_magazines select 1) select _ii];
			};
			
			for [{_ii = 0}, {_ii < (count (_items select 0))}, {_ii = _ii + 1}] do {
				_obj addItemCargoGlobal [(_items select 0) select _ii, (_items select 1) select _ii];
			};
			
			_obj setVariable ["objectLocked", true, true]; //force lock
			_obj setVariable ["generationCount", _generationCount + 1, true];
			
			if (_isVehicle == 0) then {
				[_class, _pos] call sqlite_unsaveBasePart;
				
				_classname = typeOf _obj;
				
				_pos = getPosASL _obj;
				_dir = [vectorDir _obj] + [vectorUp _obj];

				_supplyleft = 0;

				switch (true) do
				{
					case (_obj isKindOf "Land_Sacks_goods_F"):
					{
						_supplyleft = _obj getVariable ["food", 20];
					};
					case (_obj isKindOf "Land_BarrelWater_F"):
					{ 
						_supplyleft = _obj getVariable ["water", 20];
					};
				};

				// Save weapons & ammo
				_weapons = getWeaponCargo _obj;
				_magazines = getMagazineCargo _obj;
				_items = getItemCargo _obj;
				_isVehicle = 0;
				
				_query = [_classname, _pos, format ["%1, ''%2'', ''%3'', ''%4'', %5, ''%6'', ''%7'', ''%8'', %9, 1, %10", 0, _classname, _pos, _dir, _supplyleft, _weapons, _magazines, _items, _isvehicle, _object getVariable ["generationCount", 0]]];
				_query call sqlite_saveBasePart;
			};
			
			diag_log text format ["Loaded %1", _class];
		};
	} forEach _objects;
};

isLoadingObjects = false;

diag_log format["GoT Wasteland - baseSaving loaded %1 parts from DB", _objectscount];
