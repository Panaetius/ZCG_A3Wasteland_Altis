ZOD_STAKEDOWN v1.3
-- Note - Big changes from V1 -> Read setup for advanced options


To use:
In game - Use saulte key to attempt a silent melee attack. You need to be looking directly at the enemy and be within 3m to do the attack. You need to maintain the enemy in the middle of your screen for the duration of the attack (default - 1.5 seconds)



Installation:
1. Unzip to your mission folder so it contains mission.sqm, scripts folder and readme.txt.

---- Instant setup ----

Place the following in any unit/object init:

nul = [] execVM "scripts\zod_stakedown_init.sqf"


---- (Slightly) more advanced setup ----

1. Create a trigger based on who you want to be vulnerable to silent takedowns
eg1 - OPFOR in a set area: create a trigger over that area and set it to OPFOR, PRESENT
eg2 - All units - Create a trigger that covers your whole mission area, set to ANYBODY, PRESENT

2. Place following in on activation:
nul = [thislist] execVM "scripts\zod_stakedown_init.sqf"


---- Advanced setup for individual units ----
1. As above

2. In individual unit init lines put:
nul = [this, time, probability, minimum damage, use salute?] execVM "scripts\zod_stakedown_init_specific.sqf";
this - the unit you are configuring (if in init, use 'this' otherwise use unit name)
time - Time it takes for the unit to complete the melee attack (default 1.5)
probability - Liklihood of a lethal attack (0 will never occur, 1 will always be lethal) eg. 70% lethal probability = 0.7 (default 1)
minimum damage - The damage done if an attack is unsuccessful (default 0.5)
use salute? - true/false - if the 'Salute' animation is played to simulate the attack animation. If false, no animation is played to simulate the attack animation (default true)

--- "Killed by" hint ---
Place down the following anywhere (ideally just after your zod_stakedown_init initial call):
zod_stakedown_showhint = true;

This does not need to be called prior to your zod_stakedown init line 
This can also be definited in your init.sqf

--- Hint text ----
You can disable the addaction text that appears in the middle of the screen using the same method as for the "Killed by" hint using the following:
zod_stakedown_showtext = false;

NB: Ensure you call this PRIOR to the zod_stakedown init line for reliability
This can also be definited in your init.sqf

---- Issues -----

MP testing complete without major issues.
The hint shown when a unit is killed by this script doesnt always show up the first time.

As always: Use at your own risk!
Feedback welcome to Zodd at BI/Armaholic forums

Thanks to aclaw4u and the blokes at the Midnight Crew Reddit Wasteland for testing!

V1.3 as at 31 Mar 13


---
Changelog
1.3
Removed ability to target friendly soldiers with takedown
Added ability to disable the hint text

1.2
Reworked script. Instead of silent takedown actions on the target, all individuals that are able to attempt the takedown are assigned the ability through an addaction. 
Added MP compatibility (respawn with action)
Added extra variables and individual unit customisation
Added 'killed by' hint to show melee kills

1.1
Amended script - doesnt remove addaction now when dead. Initial MP compatability attempts