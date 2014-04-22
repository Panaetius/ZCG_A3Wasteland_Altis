*A3Wasteland.Altis* by ZCG!
===================

ArmA 3 Wasteland is a harsh survival sandbox mission where 2 teams and independent players fight for survival.


The mission is not ready yet, so for now it's just a placeholder :)

All development is done in the <a href="https://github.com/Panaetius/ZCG_A3Wasteland_Altis/tree/master">`master`</a> branch.

Installation
============

- Follow the instructions to install <a href="http://arma2netmysqlplugin.readthedocs.org/en/latest/">`Arma2NETMySql</a>
- Use the setup_db.sql in the DatabaseSetup folder to set up your MySQL Database
If you only want base saving to activate before a server restart (for performance reasons), use the batch files in the DatabaseSetup to set the "DoSave" flag to one before a restart (scheduled task or BEC command is fine) and set it back to 0 right before the restart
- Use the BinPBO tools and the make_pbo.bat file (you need to edit this file) to compile the mission PBO file
- Deploy the PBO on your server
- To trigger base and vehicle saving, set the DoSave flag in the triggers table to 1, do disable it set it to 0. Once saving is done, the flag is set to 0 automatically (this is so you can externally start saving on restart, for instance, lock server -> kick all player -> start saving -> wait for flag to be 0 -> restart server


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
		Bitcoin: 1HjXChksfAWJQnMQ8ncbQgfxKxJRNCsWcN
		Litecoin: LdhLdbbQLmdFXVguWB2LwPtSJENRrakvg3
		Paypal: <form action="https://www.paypal.com/cgi-bin/webscr" method="post" target="_top">
				<input type="hidden" name="cmd" value="_s-xclick">
				<input type="hidden" name="hosted_button_id" value="DV2HPQNHZTSRG">
				<input type="image" src="https://www.paypalobjects.com/de_DE/CH/i/btn/btn_donateCC_LG.gif" border="0" name="submit" alt="Jetzt einfach, schnell und sicher online bezahlen – mit PayPal.">
				<img alt="" border="0" src="https://www.paypalobjects.com/de_DE/i/scr/pixel.gif" width="1" height="1">
				</form>


