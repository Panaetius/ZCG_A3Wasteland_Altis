/*
	@file Author: [404] Costlyy
	@file Version: 1.0
   	@file Date:	20/11/2012	
	@file Description: Rotates an object by x degrees depending on args
	@file Args: [rotation amount(int)]
*/

private ["_currDirection", "_targetDirection", "_raiseAmount"];

_raiseAmount = _this select 3;

if (R3F_LOG_mutex_local_verrou) then {
	player globalChat STR_R3F_LOG_mutex_action_en_cours; // French crap
} else {
	_relPos = player worldToModel (getPos R3F_LOG_joueur_deplace_objet);
	_newPos = [_relPos select 0, _relPos select 1, (_relPos select 2) + _raiseAmount];
	
	R3F_LOG_joueur_deplace_objet attachTo [player, _newPos];
	_posX = (_newPos select 0);
	_posY = (_newPos select 1);
	_posZ = (_newPos select 2);
	
	_currentPos = player worldToModel (getPos R3F_LOG_joueur_deplace_objet);
	
	_fixX = (_currentPos select 0) - _posX;
	_fixY = (_currentPos select 1) - _posY;
	_fixZ = (_currentPos select 2) - _posZ;
	
	R3F_LOG_joueur_deplace_objet attachTo [player, [(_posX - _fixX), (_posY - _fixY), (_posZ - _fixZ)]];
	
	R3F_LOG_mutex_local_verrou = false;
};





