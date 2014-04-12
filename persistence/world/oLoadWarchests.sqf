diag_log "oLoadWarchests started";
sleep 10;
_warchestCount = call sqlite_countWarchests;
diag_log text format ["Loading %1 objects", _warchestCount];
if (isNil "_warchestCount" || _warchestCount == 0) exitWith {};


_stepSize = 50;

for "_i" from 0 to (_warchestCount) step _stepSize do
{
	_warchests = [_i, _stepSize] call sqlite_loadWarchests;
	
	{
		_id = _x select 0;
		_money = parseNumber (_x select 1);
		_side = call compile (_x select 2);
		_dir = call compile (_x select 3);
		_pos = call compile (_x select 4);
		_generationCount = parseNumber (_x select 5);
		
		if (!isNil "_pos" && !isNil "_dir") then 
		{
			_type = "CAN COLLIDE";
			_placement = 0;
			
			_warchest = createVehicle ["Land_CashDesk_F", _pos, [], _placement, _type];
			_warchest setPosASL _pos;
			_warchest setVectorDirAndUp _dir;
			_warchest setDamage 0;
			
			_warchest setVariable ['side', _side, true];
			_warchest setVariable ["R3F_LOG_disabled", true, true];
			_warchest setVariable ["a3w_warchest", true, true];
			
			_warchest setVariable ["money", _money, true];
			
			_warchest setVariable ["Id", _id, true];
		};
	} forEach _warchests;
};

diag_log format["GoT Wasteland - warchests loaded %1 parts from DB", _warchestCount];
