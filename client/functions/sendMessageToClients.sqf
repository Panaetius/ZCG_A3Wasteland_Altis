"SendMessageToClients" addPublicVariableEventHandler { 
	if (isServer) exitWith{};
	systemChat [_this select 1];
};