-- MySQL dump 10.16  Distrib 10.1.29-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: console
-- ------------------------------------------------------
-- Server version	10.1.29-MariaDB-1~jessie

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
-- Table structure for table `app_service_volume`
--

DROP TABLE IF EXISTS `app_service_volume`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `app_service_volume` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `service_key` varchar(32) NOT NULL,
  `app_version` varchar(20) NOT NULL,
  `category` varchar(50) DEFAULT NULL,
  `volume_path` varchar(400) NOT NULL,
  `volume_name` varchar(100) DEFAULT NULL,
  `volume_type` varchar(30) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=70 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_service_volume`
--

LOCK TABLES `app_service_volume` WRITE;
/*!40000 ALTER TABLE `app_service_volume` DISABLE KEYS */;
INSERT INTO `app_service_volume` VALUES (37,'2669c2cec6bc7bf5aab29a0ea2703d66','4.7.4','application','/var/www/html',NULL,NULL),(38,'d0a121bcd60d7e59a7e45d8df0f85f46','9.2.5','application','/home/git/data',NULL,NULL),(39,'d0a121bcd60d7e59a7e45d8df0f85f46','9.2.5','application','/var/log/gitlab',NULL,NULL),(40,'dcd4186bee960816d0f591c00558052f','8.0','application','/usr/local/tomcat/webapps/FineReport/WEB-INF',NULL,NULL),(41,'58c8134da4e9d272ab4ac92da411e9d1','4.0.2','application','/usr/local/FineBI/webapps/WebReport/WEB-INF',NULL,NULL),(43,'2f08bfe1f56c5e5dd47b9dde915af104','3.6.14','application','/var/lib/rabbitmq',NULL,NULL),(44,'79a55869bf5f30fda7c99346ab79e3c0','9.6.2','application','/data',NULL,NULL),(45,'66ee1676270f74b76e2a431671e8f320','v1.0.6','application','/cockroach/cockroach-data',NULL,NULL),(46,'1054114b2053264faab074fdbdec2f4b','4.2.2','application','/data',NULL,NULL),(48,'62b5e52287c0cfd175eafcfd79cfa871','10.0.4','application','/data',NULL,NULL),(49,'84779315ad0bf12ac982259d59f6bceb','3.4.11','application','/zk/zkdata',NULL,NULL),(50,'93bcc19a9b9605e11abcacfc4d30db6b','3.4.11','application','/zk/zkdata',NULL,NULL),(51,'e54f69d3e69fbe9eb4c040fab610f480','2016.06.26','application','/data',NULL,NULL),(52,'761bdbc01b04c020449e0539e78e641b','3.3.1','application','/data',NULL,NULL),(53,'6f7edb496760bb1965bdce1135883b29','5.7.16','application','/data',NULL,NULL),(54,'915cc8a5cd81f28aa7f0daba314204c2','8.5.1','application','/data',NULL,NULL),(55,'844e04058cb069e1bebaca695747223b','1.24.2','application','/data',NULL,NULL),(56,'101420900e1d28f9ccb222ff7b58d4a2','2.3.3','application','/data',NULL,NULL),(58,'69421afcf2525f06ffe3cf4da98542c7','1.1.2','application','/data',NULL,NULL),(59,'df98c419c98cc6f1488fc83e13e0244a','0.0.1','application','/data',NULL,NULL),(60,'e6efcb057977c2386ddda1ccd75b92a4','6.5.0','application','/opt/splunk/etc',NULL,NULL),(61,'e6efcb057977c2386ddda1ccd75b92a4','6.5.0','application','/opt/splunk/var',NULL,NULL),(62,'1da66aa04277b93485c5b6d0561f0762','0.9.141','application','/data',NULL,NULL),(63,'edde97105d55d4301b9cddf15e139981','9.4.8','application','/var/lib/postgresql',NULL,NULL),(64,'7045a899df1369f30e1adce1cbbeb15b','9.3.13','application','/var/lib/postgresql',NULL,NULL),(65,'c4680f24a4e8f17aacdbeee9cbea6605','1.0.0','application','/app/var/www',NULL,NULL),(66,'48079a675bd8f6e226859c61da280a76','3.2.7','application','/data',NULL,NULL),(67,'207e6441ba2e443a71515c95269df4e1','3.4.10','application','/data',NULL,NULL),(68,'207e6441ba2e443a71515c95269df4e1','3.4.10','application','/datalog',NULL,NULL),(69,'88064c83f0e5a6a5c9b73b57dbb0d6ff','5.7.20','application','/data',NULL,NULL);
/*!40000 ALTER TABLE `app_service_volume` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-07 17:51:59
