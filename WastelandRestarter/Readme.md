*Arma 3 Wasteland Restarter tool*
=================================

Just an exe you call to restart the server.

What it does:
- Lock the server
- Kick all players
- Turn on base saving
- Wait for base saving to be finished
- Shut down the server (Install Arma3 as a service to automaticall restart once this is done, for instance with <a href="http://www.nssm.cc/">`nssm`</a>, otherwise the server will just be completely stopped)
- If available, copy the Arma 3 wasteland mission PBO from the Arma 3\Deploy\ folder (needs to be created) to the Arma 3\MPMissions folder (creating a backup of the old mission)

Requirements
===============================
- .Net 4.5.1

Setup
===============================
Put it in a folder somewhere.

Edit the `WastelandRestarter.exe.config` file with your database and Battleye RCon settings.

Add a <a href="http://www.ibattle.org/">BEC</a> command to for when you want to restart the server. For instance:
       <job id="15">
               <time>09:00:00</time>
       		<delay>000000</delay>
               <day>1,2,3,4,5,6,7</day>
               <loop>0</loop>
               <cmd>pathToBat\RestartServer.bat</cmd>
               <cmdtype>1</cmdtype>     
           </job> 


with  RestartServer.bat just looking like:
       C:\PathToRestarter\WastelandRestarter.exe