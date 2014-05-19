private ["_chat", "_chatIndex", "_seconds", "_reset_timer", "_disconnect_me", "_warn_one", "_warn_last", "_reset_timer", "_checkInterval"];
_chatIndex = _this select 0;
_seconds = _this select 1;

_chat = "";

_checkInterval = 0.3;

switch (_chatIndex) do
{
	case 1:
	{
		_chat = localize "str_channel_side";
	};
	case 2:
	{
		_chat = localize "str_channel_command";
	};
	default
	{
		_chat = localize "str_channel_global";
	};
};
disableSerialization;
_DS_really_loud_sounds = {for "_i" from 1 to 10 do {playSound format ["%1",_this select 0];};};
_DS_double_cut = {1 cutText [format ["%1",_this select 0],"PLAIN DOWN"];2 cutText [format ["%1",_this select 0],"PLAIN"];};
_DS_slap_them = {_randomnr = [2,-1] call BIS_fnc_selectRandom;(vehicle player) SetVelocity [_randomnr * random (4) * cos getdir (vehicle player), _randomnr * random (4) * cos getdir (vehicle player), random (4)];};

_voiceBanAction = {
	_chatIndex = _this;
	_uid = getPlayerUID player;
	
	if ( { (_x select 0) == _uid } count pvar_voiceBanPlayerArray == 0) then 
	{
		pvar_voiceBanPlayerArray set [ count pvar_voiceBanPlayerArray, [_uid, 0, 0, 0]];
	};
	
	{
		if ((_x select 0) == _uid ) then
		{
			switch (_chatIndex) do
			{
				case 1:
				{
					_x set [2, (_x select 2) + 1];
				};
				case 2:
				{
					_x set [3, (_x select 3) + 1];
				};
				default
				{
					_x set [1, (_x select 1) + 1];
				};
			};
			
			if(((_x select 1) + (_x select 2) + (_x select 3)) > 1) then //delete player data on second kick and afterwards so it doesn't get abused to 'combatlog'
			{
				[] spawn fn_deletePlayerData;
			};
		};
	} forEach pvar_voiceBanPlayerArray;
	
	publicVariable "pvar_voiceBanPlayerArray";
};

while {true} do {
	waitUntil {
		sleep _checkInterval;
		if (!isNil "_reset_timer") then {
			_reset_timer = _reset_timer + _checkInterval;
			if( _reset_timer > A3W_VoiceKickTimeout) then
			{
				_disconnect_me = nil;
				_warn_one = nil;
				_warn_last = nil;
				_reset_timer = nil;
			};
		};
		((!isNull findDisplay 63) && (!isNull findDisplay 55))
	};
	if (ctrlText ((findDisplay 55) displayCtrl 101) == "\A3\ui_f\data\igui\rscingameui\rscdisplayvoicechat\microphone_ca.paa") then {
		if (ctrlText ((findDisplay 63) displayCtrl 101) == _chat) then {
			if (isNil "reset_timer") then {
				_reset_timer = 0;
			};
			if (isNil "_disconnect_me") then {_disconnect_me = 0;} else {_disconnect_me = _disconnect_me + _checkInterval;};
			if (_disconnect_me == 0) then {
				if (isNil "_warn_one") then {
					_warn_one = true;
					systemChat (format ["Please do not use voice on %1, this is your first and final warning. Switch channel with , and . and create a group to talk with your buddies.", _chat]);
					[] spawn _DS_slap_them;
					["Alarm"] spawn _DS_really_loud_sounds;
					[format ["NO VOICE ON %1", _chat]] spawn _DS_double_cut;
					axeDiagLog = format ["%1 got warned for talking on %2", name player, _chat];
					publicVariable "axeDiagLog";
				};
			};
			if (_disconnect_me >= _seconds) then {//kick after x seconds of talking
				if (isNil "_warn_last") then {
					_warn_last = true;
					_chatIndex call _voiceBanAction;
					axeDiagLog = format ["%1 got kicked for talking on %2", name player, _chat];
					publicVariable "axeDiagLog";
					playMusic ["PitchWhine",0];
					[] spawn _DS_slap_them;
					["Alarm"] spawn _DS_really_loud_sounds;
					["We warned you..."] spawn _DS_double_cut;
					sleep 0.5;
					1 fademusic 10;
					1 fadesound 10;
					endMission (format ["Don't talk in %1!", _chat]);
				};
			};
		};
	};
	sleep _checkInterval;
};