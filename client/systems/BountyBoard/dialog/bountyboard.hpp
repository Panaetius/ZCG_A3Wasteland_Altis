#include "bountyBoardDefines.sqf"

class bountyboardd {

	idd = bountyBoard_DIALOG;
	movingEnable = true;
	enableSimulation = true;
	onLoad = "[0] execVM 'client\systems\BountyBoard\populateBountyBoard.sqf'";

	class controlsBackground {
		
		class MainBackground: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
		    colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0,0,0,0.6)";
			moving = true;
			x = 0.1875 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.65 * safezoneH;
		};

		class TopBar: w_RscPicture
		{
			idc = -1;
			colorText[] = {1, 1, 1, 1};
			colorBackground[] = {0,0,0,0};
			text = "#(argb,8,8,3)color(0.25,0.51,0.96,0.8)";

			x = 0.1875 * safezoneW + safezoneX;
			y = 0.15 * safezoneH + safezoneY;
			w = 0.55 * safezoneW;
			h = 0.05 * safezoneH;
		};

		class DialogTitleText: w_RscText
		{
			idc = -1;
			text = "Bounty Board Menu";
			font = "PuristaMedium";
			sizeEx = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			x = 0.20 * safezoneW + safezoneX;
			y = 0.155 * safezoneH + safezoneY;
			w = 0.19 * safezoneW;
			h = 0.0448148 * safezoneH;
		};

		class PlayerMoneyText: w_RscText
		{
			idc = bountyBoard_money;
			text = "Cash:";
			font = "PuristaMedium";
			sizeEx = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			x = 0.640 * safezoneW + safezoneX;
			y = 0.155 * safezoneH + safezoneY;
			w = 0.0844792 * safezoneW;
			h = 0.0448148 * safezoneH;
		};
	};
	
	class controls {
		
		class SelectionList: w_RscList
		{
			idc = bountyBoard_item_list;
			onLBSelChanged = "";
			font = "PuristaMedium";
			sizeEx = "((((safezoneW / safezoneH) min 1.2) / 1.2) / 25)";
			x = 0.20 * safezoneW + safezoneX;
			y = 0.225 * safezoneH + safezoneY;
			w = 0.507 * safezoneW;
			h = 0.430 * safezoneH;
		};
		
		class InaccuratePosition: w_RscButton
		{
			idc = -1;
			onButtonClick = "[0] execVM 'client\systems\BountyBoard\getBountyLocation.sqf'";
			text = "Position (Inaccurate, 1000$)";

			x = 0.293 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.120 * safezoneW;
			h = 0.040 * safezoneH;
		};
		
		class MediocrePosition: w_RscButton
		{
			idc = -1;
			onButtonClick = "[1] execVM 'client\systems\BountyBoard\getBountyLocation.sqf'";
			text = "Position (Mediocre, 5000$)";
			x = 0.418 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.120 * safezoneW;
			h = 0.040 * safezoneH;
		};

        class AccuratePosition: w_RscButton
		{
			idc = -1;
			onButtonClick = "[2] execVM 'client\systems\BountyBoard\getBountyLocation.sqf'";
			text = "Position (Accurate, 10'000$)";

			x = 0.543 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.120 * safezoneW;
			h = 0.040 * safezoneH;
		};

		class CancelButton : w_RscButton {
			
			idc = -1;
			text = "Cancel";
			onButtonClick = "closeDialog 0;";

			x = 0.20 * safezoneW + safezoneX;
			y = 0.740 * safezoneH + safezoneY;
			w = 0.088 * safezoneW;
			h = 0.040 * safezoneH;
		};
	};
};

