_doEject = {
	private ["_unit"];
	_unit = _this select 1;
	diag_log _unit;
	removeBackpack _unit; 
    _unit addBackpack "b_parachute"; 
	
	unAssignVehicle _unit;
	_unit action ["eject", vehicle _unit];
	sleep 1;
	
	waitUntil {isTouchingGround _unit || (getPos _unit select 2) < 1 && alive _unit};
	
	playSound "close_chute";//play chute closing sound
	cutText ["", "BLACK FADED", 999];
	sleep 2;
	cutText ["", "BLACK IN", 2];
};

doEject = compile _doEject;

player addAction ["<t color=""#C90000"">" + "Emergency Eject" + "</t>", {call doEject}, [], 10, true, true, "", ((vehicle player) isKindOf "Air") && (!isTouchingGround _unit || (getPos _unit select 2) > 10)];