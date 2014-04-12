private ["_save"];
_save =
"
	accountToServerSave = _this;
	publicVariableServer 'accountToServerSave';
";

fn_SaveToServer = compile _save;
"confirmSave" addPublicVariableEventHandler 
{
	if( _this select 1) then {
		player globalChat "Player saved!";
	};
	player setVariable ["IsSaving", false, true];
};