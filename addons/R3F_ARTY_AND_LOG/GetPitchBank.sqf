/************************************************************
Get Pitch and Bank
By General Barron ([EMAIL=aw_barron@hotmail.com]aw_barron@hotmail.com[/EMAIL]) and vektorboson

Parameters: object
Returns: [pitch, bank]

Returns the pitch and bank of an object, in degrees.

Yaw can be found using the getdir command.

Pitch is 0 when the object is level; 90 when pointing straight
up; and -90 when pointing straight down.

Bank is 0 when level; 90 when the object is rolled to the right,
-90 when rolled to the left, and 180 when rolled upside down.
************************************************************/


//extract parameters
private ["_obj","_pitch","_bank","_yaw","_vdir","_vup","_sign", "_rotate"];

_obj = _this;


//find the yaw (direction) of the object
//note that map compass directions go CW, while coordinate (vector) directions go CCW
//so when we rotate vectors by this much (below), we are actually adjusting the vector as though the object were pointing north
_yaw = getdir _obj;


//----------------------------
//function to rotate a 2d vector around the origin
//----------------------------

_rotate =
{
private ["_v","_d","_x","_y"];

//extract parameters
_v = +(_this select 0); //we don't want to modify the originally passed vector
_d = _this select 1;

//extract old x/y values
_x = _v select 0;
_y = _v select 1;

//if vector is 3d, we don't want to mess up the last element
_v set [0, (cos _d)*_x - (sin _d)*_y];
_v set [1, (sin _d)*_x + (cos _d)*_y];

//return new vector
_v
};


//----------------------------
//find pitch
//----------------------------

//get vector dir (pitch)
_vdir = vectordir _obj;

//rotate X & Y around the origin according to the object's yaw (direction)
//we will then be left with the objects vectordir if it were facing north
_vdir = [_vdir, _yaw] call _rotate;

//if we reverse the process we used to set pitch when facing north, we can now get pitch
if ((_vdir select 1) != 0) then
{
_pitch = atan ((_vdir select 2) / (_vdir select 1));
}
else
{
//we need a fail-safe here to prevent divide-by-zero errors
//if X is zero, that means pitch is +/-90, we just need to figure out which one
if ((_vdir select 2) >= 0) then {_pitch = 90} else {_pitch = -90};
};


//----------------------------
//find bank
//----------------------------

//get vector up (bank)
_vup = vectorup _obj;


//rotate X & Y around the origin according to the object's yaw (direction)
//we will then be left with the objects vectorup if it were facing north
_vup = [_vup, _yaw] call _rotate;


//rotate Y & Z around according to the object's pitch
_vup = [_vup select 0] + ([[_vup select 1, _vup select 2], 360-_pitch] call _rotate);

//if we reverse the process we used to set bank when facing north, we can now get bank
if ((_vup select 2) != 0) then
{
_bank = atan ((_vup select 0) / (_vup select 2));
}
else
{
//we need a fail-safe here to prevent divide-by-zero errors
//if Z is zero, that means bank is +/-90, we just need to figure out which one
if ((_vdir select 2) >= 0) then {_bank = 90} else {_bank = -90};
};

//if we are rolled over (abs bank > 90), we need to adjust our result
if((_vup select 2) < 0) then
{
_sign = [1,-1] select (_bank < 0);
_bank = _bank - _sign*180;
};


//----------------------------
//return value
//----------------------------

[_pitch, _bank];