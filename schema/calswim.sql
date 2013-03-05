-- MySQL dump 10.11
--
-- Host: localhost    Database: calswim
-- ------------------------------------------------------
-- Server version	5.1.53

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `GeoData`
--

DROP TABLE IF EXISTS `GeoData`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GeoData` (
  `gd_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `g_id` int(11) unsigned NOT NULL,
  `organization` varchar(255) NOT NULL,
  `contact` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` bigint(20) unsigned DEFAULT NULL,
  `data_url` varchar(255) NOT NULL,
  `project_name_short` varchar(255) DEFAULT NULL,
  `project_name` text NOT NULL,
  `project_description` text NOT NULL,
  `timeline_start` date NOT NULL,
  `timeline_finish` date DEFAULT NULL,
  `project_funder` varchar(255) DEFAULT NULL,
  `report_url` varchar(255) DEFAULT NULL,
  `data_target` text NOT NULL,
  `location_description` text NOT NULL,
  `site_count` smallint(5) unsigned NOT NULL,
  `data_collector` text NOT NULL,
  `data_type` text NOT NULL,
  `data_format` text NOT NULL,
  `data_policies` text NOT NULL,
  `location` geometry NOT NULL,
  `keyword` text NOT NULL,
  `other` text,
  `shp_file` blob,
  PRIMARY KEY (`gd_id`),
  FULLTEXT KEY `description` (`project_description`),
  FULLTEXT KEY `keyword` (`keyword`),
  FULLTEXT KEY `other` (`other`),
  FULLTEXT KEY `label` (`project_name`),
  FULLTEXT KEY `contact` (`contact`),
  FULLTEXT KEY `other_2` (`other`),
  FULLTEXT KEY `label_2` (`project_name`,`project_description`,`keyword`,`other`),
  FULLTEXT KEY `other_3` (`other`)
) ENGINE=MyISAM AUTO_INCREMENT=280 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `GroupMap`
--

DROP TABLE IF EXISTS `GroupMap`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `GroupMap` (
  `g_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `u_id` int(11) unsigned NOT NULL,
  PRIMARY KEY (`g_id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `User` (
  `u_id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(45) NOT NULL,
  `password` char(32) NOT NULL,
  PRIMARY KEY (`u_id`),
  UNIQUE KEY `name_UNIQUE` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2013-03-05  9:56:33
