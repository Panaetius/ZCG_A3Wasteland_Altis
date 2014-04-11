_unit = _this select 0;
_killtime = _this select 1;
_killchance = _this select 2;
_mindamage = _this select 3;
_usesalute = _this select 4;

waitUntil {(_unit getVariable ["zod_stakedown_killtime", -5]) > -1};
sleep 0.1;
_unit setVariable["zod_stakedown_killtime", _killtime];
_unit setVariable["zod_stakedown_killchance", _killchance];
_unit setVariable["zod_stakedown_mindamage", _mindamage];
_unit setVariable["zod_stakedown_usesalute", _usesalute];