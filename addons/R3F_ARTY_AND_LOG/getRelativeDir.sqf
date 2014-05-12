private ["_sourceObj", "_targetObj", "_angle", "_v1", "_v2"];
_v1 = _this select 0;
_v2 = _this select 1;
_sourceVector = _this select 2;

fn_crossProduct = {
	private ["_v1", "_v2", "_result"];
	_v1 = _this select 0;
	_v2 = _this select 1;
	_result = [((_v1 select 1)*(_v2 select 2)) - ((_v1 select 2)*(_v2 select 1)),
		((_v1 select 2)*(_v2 select 0)) - ((_v1 select 0)*(_v2 select 2)),
		((_v1 select 0)*(_v2 select 1)) - ((_v1 select 1)*(_v2 select 0))];
	_result;
};

fn_dotProduct = {
	private ["_v1", "_v2", "_result"];
	_v1 = _this select 0;
	_v2 = _this select 1;
	
	_result = ((_v1 select 0) * (_v2 select 0)) + ((_v1 select 1) * (_v2 select 1)) + ((_v1 select 2) * (_v2 select 2));
	_result;
};

fn_vectorLength = {
	private ["_v1",  "_result"];
	_v1 = _this;
	_result = sqrt((_v1 select 0)^2 + (_v1 select 1)^2 + (_v1 select 2)^2);
	_result;
};

fn_normalizeVector = {
	private ["_len", "_v" , "_result"];
	_v = _this;
	_len = _v call fn_vectorLength;
	_result = [ (_v select 0) / _len, (_v select 1) / _len, (_v select 2) / _len];
	_result;
};

_v1 = _v1 call fn_normalizeVector;
_v2 = _v2 call fn_normalizeVector;

_angle = acos([_v1, _v2] call fn_dotProduct);

if (_angle < 0.5) exitWith {_sourceVector};

_crossP = [_v1, _v2] call fn_crossProduct;
_crossP = _crossP call fn_normalizeVector;

_qx = (_crossP select 0) * (sin (_angle / 2));
_qy = (_crossP select 1) * (sin (_angle / 2));
_qz = (_crossP select 2) * (sin (_angle / 2));
_qw = cos (_angle / 2);

_len = sqrt((_qx^2) + (_qy^2) + (_qz^2) + (_qw^2));

_qx = _qx / _len;
_qy = _qy / _len;
_qz = _qz / _len;
_qw = _qw / _len;

_matrix = [
	[(1 - (2 * _qy * _qy) - (2 * _qz * _qz)), ((2*_qx*_qy) - (2*_qz*_qw)), ((2*_qx*_qz) + (2*_qy*_qw))],
	[((2*_qx*_qy) + (2*_qz*_qw)), (1 - (2*_qx*_qx) - (2*_qz*_qz)), ((2*_qy*_qz) - (2*_qx*_qw))],
	[((2*_qx*_qz) - (2*_qy*_qw)), ((2*_qy*_qz) + (2*_qx*_qw)), ( 1 - (2*_qx*_qx) - (2*_qy*_qy))]
];

_result = [
	(((_matrix select 0 select 0)) * (_sourceVector select 0) + ((_matrix select 0 select 1) * (_sourceVector select 1)) + ((_matrix select 0 select 2) * (_sourceVector select 2))),
	(((_matrix select 1 select 0)) * (_sourceVector select 0) + ((_matrix select 1 select 1) * (_sourceVector select 1)) + ((_matrix select 1 select 2) * (_sourceVector select 2))),
	(((_matrix select 2 select 0)) * (_sourceVector select 0) + ((_matrix select 2 select 1) * (_sourceVector select 1)) + ((_matrix select 2 select 2) * (_sourceVector select 2)))
];

_result = _result call fn_normalizeVector;

_result;

