/*
=======================================================================================================================

	downloadData - script to download data from a laptop and because of this complete a task (as example)

	File:		downloadData.sqf
	Author:		T-800a

=======================================================================================================================
*/

T8_varFileSize = 131072;  								// Filesize ... smaller files will take shorter time to download!

T8_varTLine01 = "Download cancelled!";				// download aborted
T8_varTLine02 = "Download already in progress by someone else!";			// download already in progress by someone else
T8_varTLine03 = "Download started!";					// download started
T8_varTLine04 = "Download finished!";				// download finished
T8_varTLine05 = "##  Download Bank Account Data  ##";				// line for the addaction

T8_varDiagAbort = false;
T8_varDownSucce = false;

downloadActionId = nil;



////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

T8_fnc_abortActionLaptop =
{
	if ( T8_varDownSucce ) then 
	{
		// hint "DEBUG - DONE";
		T8_varDiagAbort = false;
		T8_varDownSucce = false;		
	
	} else { 
		player sideChat T8_varTLine01; 
		T8_varDiagAbort = true; 
		T8_varDownSucce = false; 
	};
};


T8_fnc_addActionLaptop =
{
	private [  "_cDT" ];
		_cDT = _this getVariable [ "Done", false ];
		if ( _cDT ) exitWith {};
		if(isNil "downloadActionId") then {
			downloadActionId = _this addAction [ T8_varTLine05, { call T8_fnc_ActionLaptop; }, [], 10, false, false ];
		};
};


T8_fnc_removeActionLaptop =
{
	_laptop = _this select 0;
	_id = _this select 1;
	_laptop removeAction _id;
};


T8_fnc_ActionLaptop =
{
	private [ "_laptop", "_caller", "_id", "_cIU" ];
	_laptop = _this select 0;
	_caller = _this select 1;
	_id = _this select 2;
	
	
	_cIU = _laptop getVariable [ "InUse", false ];
	if ( _cIU ) exitWith { player sideChat T8_varTLine02; };
	
	player sideChat T8_varTLine03;
	
	_laptop setVariable [ "InUse", true, true ];
		
	[ _laptop, _id] spawn 
	{
		private [ "_laptop", "_id", "_newFile", "_dlRate" ];
		
		_laptop		= _this select 0;
		_id			= _this select 1;
		
		_newFile = 0;
		
		createDialog "T8_DataDownloadDialog";
		
		sleep 0.5;
		ctrlSetText [ 8001, "Connecting ..." ];
		sleep 0.5;
		ctrlSetText [ 8001, "Connected:" ];		
		ctrlSetText [ 8003, format [ "%1 kb", T8_varFileSize ] ];		
		ctrlSetText [ 8004, format [ "%1 kb", _newFile ] ];		
		
		while { !T8_varDiagAbort } do
		{
			_dlRate = 200 + random 80;
			_newFile = _newFile + _dlRate;

			if ( _newFile > T8_varFileSize ) then 
			{
				_dlRate = 0;		
				_newFile = T8_varFileSize;
				ctrlSetText [ 8001, "Download finished!" ];	
				T8_varDiagAbort = true;
				player sideChat T8_varTLine04;
				T8_varDownSucce = true;
				
				_laptop setVariable [ "Done", true, true ];
				
				player setVariable ["cmoney", (player getVariable ["cmoney", 0]) + 2500, true];
				
				closeDialog 0;
				
				downloadActionId = nil;

				[ [ _laptop, _id ], "T8_fnc_removeActionLaptop", true, true ] spawn BIS_fnc_MP;
			};
			
			ctrlSetText [ 8002, format [ "%1 kb/s", _dlRate ] ];		
			ctrlSetText [ 8004, format [ "%1 kb", _newFile ] ];				
			
			sleep 0.2;
		};
		
		T8_varDiagAbort = false;

		_laptop setVariable [ "InUse", false, false];	
	};
};

downloadDataDONE = true;
