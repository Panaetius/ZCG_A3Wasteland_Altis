diag_log "oLoadBeacons started";
sleep 10;
_beaconCount = call sqlite_countBeacons;
diag_log text format ["Loading %1 objects", _beaconCount];
if (isNil "_beaconCount" || _beaconCount == 0) exitWith {};


_stepSize = 50;

for "_i" from 0 to (_beaconCount) step _stepSize do
{
	_beacons = [_i, _stepSize] call sqlite_loadBeacons;
	
	{
		_id = _x select 0;
		_side = _x select 1;
		_ownerName = _x select 2;
		_ownerId = _x select 3;
		_dir = call compile (_x select 7);
		_pos = call compile (_x select 6);
		_groupOnly = parseNumber (_x select 4);
		_generationCount = parseNumber (_x select 5);
		
		if (!isNil "_pos" && !isNil "_dir") then 
		{
			_type = "CAN COLLIDE";
			_placement = 0;
			
			_beacon = createVehicle ["Land_TentDome_F", _pos, [], _placement, _type];
			_beacon setPosATL _pos;
			_beacon setVectorDirAndUp _dir;
			_beacon setDamage 0;
			
			//Fix position for more accurate positioning
			_posX = (_pos select 0);
			_posY = (_pos select 1);
			_posZ = (_pos select 2);
			
			_currentPos = getPosATL _beacon;
			
			_fixX = (_currentPos select 0) - _posX;
			_fixY = (_currentPos select 1) - _posY;
			_fixZ = (_currentPos select 2) - _posZ;
			
			_beacon setPosATL [(_posX - _fixX), (_posY - _fixY), (_posZ - _fixZ)];
			
			switch(_side) do
			{
				case "WEST":
				{
					_beacon setVariable ['side', west, true];
				};
				case "EAST":
				{
					_beacon setVariable ['side', east, true];
				};
				case "GUER":
				{
					_beacon setVariable ['side', independent, true];
				};
			};
			
			_beacon setVariable ["R3F_LOG_disabled", true, true];
			_beacon setVariable ["allowDamage", true, true];
			_beacon setVariable ["a3w_spawnBeacon", true, true];
			_beacon setVariable ["ownerName", _ownerName, true];
			_beacon setVariable ["ownerUID", _ownerId, true];
			_beacon setVariable ["packing", false, true];
			_beacon setVariable ["groupOnly", _groupOnly == 1, true];
			_beacon setVariable ["GenerationCount", _generationCount, true];
			
			_beacon setVariable ["Id", _id, true];
			
			[pvar_spawn_beacons, _beacon] call BIS_fnc_arrayPush;
			publicVariable "pvar_spawn_beacons";
		};
	} forEach _beacons;
};

diag_log format["GoT Wasteland - beacons loaded %1 parts from DB", _beaconCount];
