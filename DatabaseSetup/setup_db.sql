-- MySQL Administrator dump 1.4
--
-- ------------------------------------------------------
-- Server version	5.6.16


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

--
-- Definition of table `item`
--

DROP TABLE IF EXISTS `item`;
CREATE TABLE `item` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `PlayerId` varchar(100) NOT NULL,
  `Type` text NOT NULL,
  `Name` text NOT NULL,
  PRIMARY KEY (`Id`),
  KEY `Index_2` (`PlayerId`)
) ENGINE=InnoDB AUTO_INCREMENT=268820 DEFAULT CHARSET=utf8;

--
-- Definition of table `objects`
--

DROP TABLE IF EXISTS `objects`;
CREATE TABLE  `objects` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Name` text NOT NULL,
  `Position` text NOT NULL,
  `Direction` text NOT NULL,
  `SupplyLeft` float NOT NULL,
  `Weapons` text NOT NULL,
  `Magazines` text NOT NULL,
  `Items` text NOT NULL,
  `IsVehicle` int(10) unsigned NOT NULL,
  `IsSaved` int(1) unsigned NOT NULL,
  `SequenceNumber` int(10) unsigned NOT NULL,
  `GenerationCount` int(3) unsigned NOT NULL DEFAULT '0',
  `Owner` varchar(100) NOT NULL,
  `Damage` float NOT NULL DEFAULT '0',
  `AllowDamage` int(1) unsigned NOT NULL DEFAULT '1',
  `Texture` varchar(100) NOT NULL,
  `AttachedObjects` varchar(4000) NOT NULL DEFAULT '[]',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=111 DEFAULT CHARSET=utf8;

--
-- Definition of table `player`
--

DROP TABLE IF EXISTS `player`;
CREATE TABLE `player` (
  `Id` varchar(100) NOT NULL,
  `AccountName` text NOT NULL,
  `Money` int(10) unsigned NOT NULL,
  `Side` text NOT NULL,
  `Health` float NOT NULL,
  `Vest` text NOT NULL,
  `Uniform` text NOT NULL,
  `Backpack` text NOT NULL,
  `Goggles` text NOT NULL,
  `HeadGear` text NOT NULL,
  `Position` text NOT NULL,
  `Direction` float NOT NULL,
  `PrimaryWeapon` text NOT NULL,
  `SecondaryWeapon` text NOT NULL,
  `HandgunWeapon` text NOT NULL,
  `Hunger` int(3) unsigned NOT NULL DEFAULT '100',
  `Thirst` int(3) unsigned NOT NULL DEFAULT '100',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

DROP TABLE IF EXISTS `warchest`;
CREATE TABLE  `warchest` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Money` int(10) unsigned NOT NULL,
  `Side` varchar(45) NOT NULL,
  `Direction` varchar(100) NOT NULL,
  `Position` varchar(100) NOT NULL,
  `GenerationCount` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

CREATE TABLE `triggers` (
  `Name` VARCHAR(100) NOT NULL,
  `Condition` INT(1) unsigned NOT NULL,
  PRIMARY KEY (`Name`)
)
ENGINE = InnoDB;

INSERT INTO `triggers` (Name, `Condition`) Values ("DoSave", 1);

DROP TABLE IF EXISTS `beacon`;
CREATE TABLE  `beacon` (
  `Id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Side` varchar(45) NOT NULL,
  `OwnerName` varchar(45) NOT NULL,
  `OwnerId` bigint(50) unsigned NOT NULL,
  `GroupOnly` int(10) unsigned NOT NULL,
  `GenerationCount` int(10) unsigned NOT NULL,
  `Position` varchar(100) NOT NULL,
  `Direction` varchar(100) NOT NULL,
  `HaloJump` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`Id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

CREATE TABLE `donators` (
  `PlayerId` BIGINT(40) UNSIGNED NOT NULL AUTO_INCREMENT,
  `StartingMoney` INTEGER(10) UNSIGNED NOT NULL DEFAULT 0,
  `StartingFood` INTEGER(2) UNSIGNED NOT NULL DEFAULT 0,
  `StartingDrink` INTEGER(2) UNSIGNED NOT NULL DEFAULT 0,
  `StartingRepairKits` INTEGER(2) UNSIGNED NOT NULL DEFAULT 0,
  `Uniform` VARCHAR(100) NOT NULL DEFAULT '',
  `Vest` VARCHAR(100) NOT NULL DEFAULT '',
  `Backpack` VARCHAR(100) NOT NULL DEFAULT '',
  `Helmet` VARCHAR(100) NOT NULL DEFAULT '',
  `Glasses` VARCHAR(100) NOT NULL DEFAULT '',
  `PrimaryWeapon` VARCHAR(100) NOT NULL DEFAULT '',
  `SecondaryWeapon` VARCHAR(100) NOT NULL DEFAULT '',
  `HandgunWeapon` VARCHAR(100) NOT NULL DEFAULT '',
  `InventoryItems` VARCHAR(100) NOT NULL DEFAULT '',
  `HasGPS` INT(1) NOT NULL DEFAULT 0,
  `HasNVG` INT(1) NOT NULL DEFAULT 0,
  `Remarks` VARCHAR(4000) NOT NULL DEFAULT '',
  PRIMARY KEY (`PlayerId`)
)
ENGINE = InnoDB;

----------------------------------------------------------------------------
------------EXAMPLE DONATOR DATA--------------------------------------------
----------------------------------------------------------------------------
INSERT INTO donators VALUES (76561197992571685, 1234, 3, 3, 3, 'U_B_Wetsuit', 'V_TacVestIR_blk', 'B_Carryall_oucamo', 'H_Beret_red', 'G_Diving', 'arifle_Mk20_F', 'launch_NLAW_F', 'hgun_Rook40_F', '["FirstAidKit","FirstAidKit", "30Rnd_556x45_Stanag"]', 1, 1, '')
----------------------------------------------------------------------------
------------END EXAMPLE DONATOR DATA--------------------------------------------
----------------------------------------------------------------------------

CREATE TABLE `players`.`bounties` (
  `PlayerId` BIGINT(40) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Bounty` INTEGER(10) UNSIGNED NOT NULL DEFAULT 0,
  `PlayerName` VARCHAR(45) NOT NULL DEFAULT '',
  PRIMARY KEY (`PlayerId`)
)
ENGINE = InnoDB;

