/**
 * Charger l'objet déplacé par le joueur dans un transporteur
 * 
 * Copyright (C) 2010 madbull ~R3F~
 * 
 * This program is free software under the terms of the GNU General Public License version 3.
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

if (R3F_LOG_mutex_local_verrou) then
{
	player globalChat STR_R3F_LOG_mutex_action_en_cours;
}
else
{
	R3F_LOG_mutex_local_verrou = true;
	
	private ["_objet", "_classes_transporteurs", "_transporteur", "_i"];
	
	_objet = R3F_LOG_joueur_deplace_objet;
	
	_transporteur = nearestObjects [_objet, R3F_LOG_classes_transporteurs, 22];
	// Parce que le transporteur peut être un objet transportable
	_transporteur = _transporteur - [_objet];
	
	if (count _transporteur > 0) then
	{
		_transporteur = _transporteur select 0;
		
		if (alive _transporteur && ((velocity _transporteur) call BIS_fnc_magnitude < 6) && (getPos _transporteur select 2 < 2) && !(_transporteur getVariable "R3F_LOG_disabled")) then
		{
			private ["_objets_charges", "_chargement_actuel", "_cout_capacite_objet", "_chargement_maxi"];
			
			_objets_charges = _transporteur getVariable "R3F_LOG_objets_charges";
			
			// Calcul du chargement actuel
			_chargement_actuel = 0;
			{
				for [{_i = 0}, {_i < count R3F_LOG_CFG_objets_transportables}, {_i = _i + 1}] do
				{
					if (_x isKindOf (R3F_LOG_CFG_objets_transportables select _i select 0)) exitWith
					{
						_chargement_actuel = _chargement_actuel + (R3F_LOG_CFG_objets_transportables select _i select 1);
					};
				};
			} forEach _objets_charges;
			
			// Recherche de la capacité de l'objet
			_cout_capacite_objet = 99999;
			for [{_i = 0}, {_i < count R3F_LOG_CFG_objets_transportables}, {_i = _i + 1}] do
			{
				if (_objet isKindOf (R3F_LOG_CFG_objets_transportables select _i select 0)) exitWith
				{
					_cout_capacite_objet = (R3F_LOG_CFG_objets_transportables select _i select 1);
				};
			};
			
			// Recherche de la capacité maximale du transporteur
			_chargement_maxi = 0;
			for [{_i = 0}, {_i < count R3F_LOG_CFG_transporteurs}, {_i = _i + 1}] do
			{
				if (_transporteur isKindOf (R3F_LOG_CFG_transporteurs select _i select 0)) exitWith
				{
					_chargement_maxi = (R3F_LOG_CFG_transporteurs select _i select 1);
				};
			};
			
			// Si l'objet loge dans le véhicule
			if (_chargement_actuel + _cout_capacite_objet <= _chargement_maxi) then
			{
				_bbr = boundingBox _transporteur; 
				_p1 = _bbr select 0; 
				_p2 = _bbr select 1; 
				_relPos = _transporteur worldToModel (getPosATL _objet);
				
				_bbObj = boundingBox _objet;
				_p1Obj = _bbObj select 0;
				_p2Obj = _bbObj select 1;
				
				_width = (_p2Obj select 0) - (_p1Obj select 0);
				_depth = (_p2Obj select 1) - (_p1Obj select 1);
				_height = ((_p2Obj select 2) - (_p1Obj select 2)) / 2;
				
				_offset = (_width min _depth) / 2;
				
				if ((_objet distance _transporteur <= 10) 
					&& (_relPos select 0) > (_p1 select 0) - _offset && (_relPos select 0) < (_p2 select 0) + _offset //check stuff is in bounding box 
					&& (_relPos select 1) > (_p1 select 1) - _offset && (_relPos select 1) < (_p2 select 1) + _offset 
					&& (_relPos select 2) > (_p1 select 2) - _height && (_relPos select 2) < (_p2 select 2) + _height ) then
				{
					// On mémorise sur le réseau le nouveau contenu du véhicule
					_objets_charges = _objets_charges + [_objet];
					_transporteur setVariable ["R3F_LOG_objets_charges", _objets_charges, true];
					_objet setVariable ["R3F_LOG_est_transporte_par", _transporteur, true];					
					
					// //don't question this part, doing coordinate transformations between 3 coordinate systems (up is relative to dir and dir of attached object is relative to system of the object it's attached to...)
					 _dir = ([ vectorDir _transporteur, vectorDir _objet, [0,1,0]] call fn_getRelativeDir);
					
					player globalChat STR_R3F_LOG_action_charger_deplace_en_cours;
					
					// Faire relacher l'objet au joueur (si il l'a dans "les mains")
					_objet disableCollisionWith _transporteur;
					R3F_LOG_joueur_deplace_objet = objNull;
					R3F_LOG_is_attach = true;
					sleep 1;
					
					_transporteur enableSimulationGlobal true;
					_objet enableSimulationGlobal true;
					detach _objet;
					_objet setPos (getPos _objet);
					sleep 0.1;
					_objet attachTo [_transporteur, _relPos];
					sleep 0.1;
					_posX = (_relPos select 0);
					_posY = (_relPos select 1);
					_posZ = (_relPos select 2);
					
					_currentPos = _transporteur worldToModel (getPosATL _objet);
					
					_fixX = (_currentPos select 0) - _posX;
					_fixY = (_currentPos select 1) - _posY;
					_fixZ = (_currentPos select 2) - _posZ;
					
					_relPos = [(_posX - _fixX), (_posY - _fixY), (_posZ - _fixZ)];
					detach _objet;
					_objet attachto [_transporteur, _relPos];
					sleep 0.1;
					
					R3F_ARTY_AND_LOG_PUBVAR_setVectorDir = [_objet, _dir];
					if (isServer) then
					{
						["R3F_ARTY_AND_LOG_PUBVAR_setVectorDir", R3F_ARTY_AND_LOG_PUBVAR_setVectorDir] spawn R3F_ARTY_AND_LOG_FNCT_PUBVAR_setVectorDir;
					}
					else
					{
						publicVariable "R3F_ARTY_AND_LOG_PUBVAR_setVectorDir";
					};
					sleep 0.1;
					
					_actionId = _objet addAction [("<img image='client\icons\r3f_loadin.paa' color='#06ef00'/> <t color='#06ef00'>" + STR_R3F_LOG_action_detach_selection + "</t>"), "addons\R3F_ARTY_AND_LOG\R3F_LOG\transporteur\detach.sqf", nil, 6, true, true, "isNull R3F_LOG_joueur_deplace_objet && vehicle player == player"];
					_objet setVariable ["AttachActionId", _actionId, true];
					_objet setVariable ["AttachDirection", _dir, true];
					
					player globalChat format [STR_R3F_LOG_action_charger_deplace_fait, getText (configFile >> "CfgVehicles" >> (typeOf _transporteur) >> "displayName")];
				}
				else
				{
					player globalChat format [STR_R3F_LOG_action_charger_selection_trop_loin, getText (configFile >> "CfgVehicles" >> (typeOf _objet) >> "displayName")];
				};
			}
			else
			{
				player globalChat STR_R3F_LOG_action_charger_deplace_pas_assez_de_place;
			};
		};
	};
	
	R3F_LOG_mutex_local_verrou = false;
};

