private ["_unit"];
_unit = _this select 1;
removeBackpack _unit; 
_unit addBackpack "b_parachute"; 

unAssignVehicle _unit;
_unit action ["eject", vehicle _unit];
sleep 1;

if(isTouchingGround _unit || (getPos _unit select 2) < 50 && alive _unit) then {
	_unit action ["OpenParachute", _unit];
};
