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
-- Table structure for table `publish_group_service_relation`
--

DROP TABLE IF EXISTS `publish_group_service_relation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `publish_group_service_relation` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `group_pk` int(11) NOT NULL,
  `service_id` varchar(32) NOT NULL,
  `service_key` varchar(32) NOT NULL,
  `version` varchar(20) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=117 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `publish_group_service_relation`
--

LOCK TABLES `publish_group_service_relation` WRITE;
/*!40000 ALTER TABLE `publish_group_service_relation` DISABLE KEYS */;
INSERT INTO `publish_group_service_relation` VALUES (1,1,'','2669c2cec6bc7bf5aab29a0ea2703d66','4.7.4'),(2,1,'','mysql','5.5.46'),(3,2,'','d0a121bcd60d7e59a7e45d8df0f85f46','9.2.5'),(4,2,'','mysql','5.5.46'),(5,2,'','7d0accf2b6bb04d65967bc1f691814db','3.0.7'),(6,3,'','dcd4186bee960816d0f591c00558052f','8.0'),(7,4,'','66ee1676270f74b76e2a431671e8f320','v1.0.6'),(8,5,'','mysql','5.5.46'),(9,5,'','8badea254f6ca5d4e0651bd13e4c9d02','4.7.1'),(10,6,'','ca8e284d593e07b44626a5bbcee99987','lastest'),(11,6,'','c95e34c47956a3f1ec7e0e56b8b8e908','lastest'),(12,6,'','7211c17eb3ef63e3a3f91a938e746a8e','lastest'),(13,6,'','211e48d2a01c3e9302db8ca181a6395d','lastest'),(14,6,'','75a1548d5e1abb807156b5be61ce80b0','lastest'),(15,6,'','c429180c6cf0b1f8de48dfca1406138f','lastest'),(16,6,'','21f8ad4741b77289debd2af636cefdf1','lastest'),(17,6,'','75ef93fe2ef1dba2847faf97375ef8aa','lastest'),(18,6,'','251e79e2e3aac456f6a7c7d83dd8bd60','3-management'),(19,6,'','3f55859608b2daa781728ee795a46b8a','lastest'),(20,6,'','1fac295d6702eec044c564e605a8a4ae','lastest'),(21,6,'','4f9bc7f146e75cab03e68eaf884ae347','lastest'),(22,6,'','71c3b10638d44827ea13bb6adec04f64','lastest'),(23,7,'','9d862211c385d25c11137233b540cdc1','1.0'),(24,8,'','cfec36aa84259d84323c3f877d92c611','lastest'),(25,8,'','f92b60e25822fc60cf551f90adbb7cc9','lastest'),(26,8,'','2c9af832cf06eaed308732e095e863d4','lastest'),(27,8,'','7f50a0d11054e04557773438e3324db8','lastest'),(28,9,'','5cdb7c269ecb3e91fda6b591f76c0adc','latest'),(29,9,'','cab386671419b54298e06d2f1900a955','1.2.4'),(30,9,'','7d26007f9bca9cd6940555d7b24f14e3','latest'),(31,9,'','144dcc37166a6f7bf9767e8b7a9877ca','latest'),(32,9,'','d06ef9f3474be4dcaa6b613463ae361d','1.0'),(33,9,'','13c7e37f45d4682137f156f1bfe5329a','1.0'),(34,9,'','16f3a20b88083a27ac1f47ecbe5a2032','1.0'),(35,9,'','29701527382144be874e5b2fee4360ab','lastest'),(36,9,'','560476c8fabf4c83821fb99aa297c89a','lastest'),(37,9,'','61f32dac47dbaa89283f08ca486925e9','1.1'),(38,9,'','3f853b21f49583197732741efd0b4e36','lastest'),(39,10,'','4b482cefaa9523db1b3c638f9bb2e4fc','latest'),(40,10,'','7d0accf2b6bb04d65967bc1f691814db','3.0.7'),(41,11,'','3c610cf82ad1e62200cfb08ede2e4ad7','V1.0'),(42,11,'','ef82f5fbbb6bc9c4263cf1febb81f887','V1.0'),(43,11,'','dafd5e391ee0a669b68f98706f50057e','x86_64-1.0.0'),(44,11,'','2d0c2675e8851b1f40595f6b23b70535','V1.1'),(45,12,'','58c8134da4e9d272ab4ac92da411e9d1','4.0.2'),(46,13,'','88064c83f0e5a6a5c9b73b57dbb0d6ff','5.7.20'),(47,14,'','2f08bfe1f56c5e5dd47b9dde915af104','3.6.14'),(48,15,'','79a55869bf5f30fda7c99346ab79e3c0','9.6.2'),(49,15,'','mysql','5.5.46'),(50,16,'','mysql','5.5.46'),(51,16,'','a6645330eeeb980decf6b6029a701baa','4.9.1'),(52,17,'','1054114b2053264faab074fdbdec2f4b','4.2.2'),(53,17,'','88064c83f0e5a6a5c9b73b57dbb0d6ff','5.7.20'),(54,18,'','62b5e52287c0cfd175eafcfd79cfa871','10.0.4'),(55,19,'','84779315ad0bf12ac982259d59f6bceb','3.4.11'),(56,19,'','ce82372c52fef23e248563cd6fbb008c','0.11.0.2'),(57,20,'','93bcc19a9b9605e11abcacfc4d30db6b','3.4.11'),(58,21,'','3135872dc558dc9a4be4b88814bd0080','v1.0.0'),(59,22,'','mysql','5.5.46'),(60,22,'','58de558696870bcf80bd0c0b81687677','v1.0.0'),(61,23,'','059b6e24c2594c5d05f15cee77897878','v1.0.0'),(62,24,'','1b348fb0ca51c1c8947fd9a3c2b2086e','v1.0.0'),(63,25,'','47b904af6a19d6d0ecb8e23b40ccae86','v1.0.0'),(64,26,'','8525d5b470a851accb3ccf96411e3925','v1.0.0'),(65,27,'','961ed20f1895a8310a7eb40ad9e573d1','v1.0.0'),(66,28,'','24831bfcf1676a0f316e70f373f4490d','lastest'),(67,29,'','99798383a5e81ba760b7d5d648efa639','lastest'),(68,30,'','64e1800f8d302d0ce166a6b594a84e0e','lastest'),(69,31,'','026248d00ae4efa78002dcd10a4dfb9d','1.13-alpine-demo'),(70,32,'','596c520806f824194d191da8c5593ee2','lastest'),(71,32,'','5ebf8ccbe99957e351f7db1da59e1761','5.7'),(72,33,'','e54f69d3e69fbe9eb4c040fab610f480','2016.06.26'),(73,34,'','mysql','5.5.46'),(74,35,'','761bdbc01b04c020449e0539e78e641b','3.3.1'),(75,36,'','9d862211c385d25c11137233b540cdc1','1.0'),(76,37,'','6f7edb496760bb1965bdce1135883b29','5.6.30'),(77,39,'','72197badacb9b273c34093643306df6f','0.8.0'),(78,40,'','7d0accf2b6bb04d65967bc1f691814db','3.0.7'),(79,41,'','a4677f6ce05c52aea169ae8e6507f81e','4.5.1'),(80,42,'','be5852b5ad85a740ef1fd63af3040f9f','3.1.14'),(81,43,'','5dd46241441badc3062026fd4ead485f','0.0.1'),(82,44,'','915cc8a5cd81f28aa7f0daba314204c2','8.5.1'),(83,45,'','ddd8486ea0976e264a7af1287f538e89','1.6.0'),(84,46,'','844e04058cb069e1bebaca695747223b','1.24.2'),(85,47,'','7368bff81b54b44f196c001a7c6ba056','0.0.1'),(86,48,'','101420900e1d28f9ccb222ff7b58d4a2','2.3.3'),(87,49,'','48079a675bd8f6e226859c61da280a76','3.2.7'),(88,50,'','memcached','1.4.24'),(89,51,'','adccd0a9aa9c60673af4c29a8e0ffb89','2.3.5'),(90,52,'','69421afcf2525f06ffe3cf4da98542c7','1.1.2'),(91,53,'','2f08bfe1f56c5e5dd47b9dde915af104','3.6.14'),(92,54,'','df98c419c98cc6f1488fc83e13e0244a','0.0.1'),(93,55,'','e6efcb057977c2386ddda1ccd75b92a4','6.5.0'),(94,56,'','a5f4ea603a5fb95a92d6c9e9eede5648','0.6.4'),(95,57,'','1da66aa04277b93485c5b6d0561f0762','0.9.141'),(96,58,'','edde97105d55d4301b9cddf15e139981','9.4.8'),(97,59,'','7045a899df1369f30e1adce1cbbeb15b','9.3.13'),(98,60,'','postgresql','9.4.5'),(99,61,'','d405998e402400ef10ddbecaa7ce4ecb','v0.0.2'),(100,62,'','58c8134da4e9d272ab4ac92da411e9d1','4.0.2'),(101,63,'','79c62e50a62a67b3dd5712db44d142b8','2.3.4'),(102,64,'','c4680f24a4e8f17aacdbeee9cbea6605','1.0.0'),(103,65,'','2fc3e63d7df3fe315c6f2b140536728f','1.0'),(104,66,'','c2ff6e658f416bb55c020becd3444646','v0.1.0'),(105,67,'','95b7f9bee4209283a3e696829b641ee3','master'),(106,68,'','48079a675bd8f6e226859c61da280a76','3.2.7'),(107,68,'','d312cb0c35a4e96165ef394a2fd20b81','lastest'),(108,69,'','07e149ee39dd17b6f3307a4cab3633ff','v1.0.0'),(109,69,'','b092297de8bf07c53c3e693e4d864e7f','v1.0.0'),(110,69,'','93203d20b808681b86a74bbecfb20150','v1.0.0'),(111,69,'','207e6441ba2e443a71515c95269df4e1','3.4.10'),(112,70,'','6f7edb496760bb1965bdce1135883b29','5.7.16'),(113,71,'','mongodb','2.6.9_50401'),(114,72,'','redis','2.8.23'),(115,73,'','9fb94987399a916dead514c03278fe92','3.1.9'),(116,73,'','88064c83f0e5a6a5c9b73b57dbb0d6ff','5.7.20');
/*!40000 ALTER TABLE `publish_group_service_relation` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-03-07 17:52:09
