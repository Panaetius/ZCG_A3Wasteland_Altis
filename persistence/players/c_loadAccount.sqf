private["_donation","_UID"];
sleep 3;
player globalchat "Loading player account...";

//Requests info from server in order to download stats
_UID = getPlayerUID player;


[_UID, _UID, "dataValues", "STRING", player] call sendToServer;

waitUntil {!isNil "dataLoaded"};




//===========================================================================

//END
statsLoaded = 1;
titleText ["","BLACK IN",4];

//fixes the issue with saved player being GOD when they log back on the server!
player allowDamage true;

// Remove unrealistic blur effects
ppEffectDestroy BIS_fnc_feedback_fatigueBlur;
ppEffectDestroy BIS_fnc_feedback_damageBlur;

player globalchat "Player account loaded!";

deletePlayer = (getPlayerUID player);
publicVariableServer "deletePlayer";
