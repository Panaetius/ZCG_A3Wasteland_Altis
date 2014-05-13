*A3Wasteland.Altis* by ZCG!
===================

ArmA 3 Wasteland is a harsh survival sandbox mission where 2 teams and independent players fight for survival.


The mission is not ready yet, so for now it's just a placeholder :)

All development is done in the <a href="https://github.com/Panaetius/ZCG_A3Wasteland_Altis/tree/master">`master`</a> branch.

See <a href="https://github.com/Panaetius/ZCG_A3Wasteland_Altis_AdditionalFiles">`ZCG_A3Wasteland_Altis_AdditionalFiles repository`</a> for additional files

Visit our <a href="http://zcgservers.net/">Homepage and Forums</a>

Installation
============

- Follow the instructions to install <a href="http://arma2netmysqlplugin.readthedocs.org/en/latest/">`Arma2NETMySql</a>
- Use the setup_db.sql in the DatabaseSetup folder to set up your MySQL Database. At the moment the database name is hardcoded to "players", so you database has to be called this
- If you only want base saving to activate before a server restart (for performance reasons), use the batch files in the DatabaseSetup to set the "DoSave" flag to one before a restart (scheduled task or BEC command is fine) and set it back to 0 right before the restart
- Use the BinPBO tools and the make_pbo.bat file (you need to edit this file) to compile the mission PBO file
- Deploy the PBO on your server
- To trigger base and vehicle saving, set the DoSave flag in the triggers table to 1, do disable it set it to 0. Once saving is done, the flag is set to 0 automatically (this is so you can externally start saving on restart, for instance by using the WastelandRestarter tool)


*Team Wasteland* collaborators:

       GoT - JoSchaap
       TPG - AgentRev
           - MercyfulFate
       KoS - His_Shadow
       KoS - Bewilderbeest
       404 - Del1te
	   
	   
	   
*ZCG* Collaborators:

		Panaetius

		
Donations:

- Bitcoin: 1HjXChksfAWJQnMQ8ncbQgfxKxJRNCsWcN
- Litecoin: LdhLdbbQLmdFXVguWB2LwPtSJENRrakvg3
- Paypal: <a href="https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=ZVBDQQLY5MGPA">`donate`</a>


