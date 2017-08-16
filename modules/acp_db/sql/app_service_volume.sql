-- MySQL dump 10.13  Distrib 5.5.46-37.5, for debian-linux-gnu (x86_64)
--
-- Host: 127.0.0.1    Database: goodrain
-- ------------------------------------------------------
-- Server version	5.5.46-37.5-log

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
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=252 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `app_service_volume`
--

LOCK TABLES `app_service_volume` WRITE;
/*!40000 ALTER TABLE `app_service_volume` DISABLE KEYS */;
INSERT INTO `app_service_volume` VALUES (4,'edde97105d55d4301b9cddf15e139981','9.4.8','application','/var/lib/postgresql'),(28,'7045a899df1369f30e1adce1cbbeb15b','9.3.13','application','/var/lib/postgresql'),(29,'d6334f6cdc27ec1688c6e553df9e976a','3.5.0','application','/data'),(32,'e54f69d3e69fbe9eb4c040fab610f480','2016.06.26','application','/data'),(36,'fd6f713ac0fddaedfb81d834b575aaed','0.9.0.1','application','/data'),(44,'d261fa2e90c84131df33644ad0b6e5c5','1.1.0','application','/data'),(101,'e14de9d6d28b9afe2b530ce38cba506f','2.2.17','application','/data'),(106,'9b3d6254f6369c0820c5c8ddd0a3d5e8','1.2.5','application','/data'),(130,'1e1a3f8f9bc1dc2f14f99b80dac2ca74','1.5.4','application','/opt/discourse/public/assets'),(131,'1e1a3f8f9bc1dc2f14f99b80dac2ca74','1.5.4','application','/opt/discourse/public/uploads'),(132,'1e1a3f8f9bc1dc2f14f99b80dac2ca74','1.5.4','application','/opt/discourse/plugins'),(133,'1e1a3f8f9bc1dc2f14f99b80dac2ca74','1.5.4','application','/opt/discourse/tmp'),(134,'1e1a3f8f9bc1dc2f14f99b80dac2ca74','1.5.4','application','/opt/discourse/public/backups'),(135,'1e1a3f8f9bc1dc2f14f99b80dac2ca74','1.5.4','application','/opt/discourse/public/tombstone'),(136,'1e1a3f8f9bc1dc2f14f99b80dac2ca74','1.5.4','application','/data'),(137,'101420900e1d28f9ccb222ff7b58d4a2','2.3.3','application','/data'),(138,'915cc8a5cd81f28aa7f0daba314204c2','8.5.1','application','/data'),(140,'45081d62105d2f18a487f06dabf9de6a','5.1.3','application','/data'),(144,'197a1f6513faddd4f593d75b357b73af','0.41.0','application','/data'),(147,'6b14c90e9bd2032f8cc382d69b2e5848','3.7.0','application','/data'),(150,'6b14c90e9bd2032f8cc382d69b2e5848','3.7','application','/data'),(153,'15fd24116420e1c628782a71b2439b49','8.9.5','application','/data'),(154,'0b2be9edf667706148ceb1e9713330d8','2.5.3','application','/data'),(155,'f94f40367a09633d055df8a610348dcd','2.5.3','application','/data'),(156,'28e8cc3648a435f2a78eece2bfc7d9ef','0.9.97','application','/data'),(159,'844e04058cb069e1bebaca695747223b','1.24.2','application','/data'),(160,'4667dd42c276ea3d91a915d966561ba0','3.2','application','/data'),(163,'69421afcf2525f06ffe3cf4da98542c7','1.1.2','application','/data'),(165,'77c7ca0b7361d1967fe016e5c0d8470e','7.51','application','/data'),(166,'761bdbc01b04c020449e0539e78e641b','3.3.1','application','/data'),(168,'2da879adab14f747f2c7212fc10ae596','7.51','application','/data'),(171,'e6efcb057977c2386ddda1ccd75b92a4','6.5.0','application','/opt/splunk/etc'),(172,'e6efcb057977c2386ddda1ccd75b92a4','6.5.0','application','/opt/splunk/var'),(173,'2c3e8a21f1ce9258627b999e7a353285','1.0.1','application','/app/images'),(187,'751d85cc03e6cf381671c7abe1a6c15f','7.2.4','application','/data'),(188,'3299c740fc0ab6957b9e6f0076cfe01f','6.0.1','application','/data'),(198,'2e633c10c5af87552c386e00a72e9eee','8.3.1','application','/data'),(199,'6f7edb496760bb1965bdce1135883b29','5.7.16','application','/data'),(200,'2e633c10c5af87552c386e00a72e9eee','8.4','application','/data'),(204,'d57f18e9de902016c914a70740a5d734','9.1.0','application','/data'),(206,'b065e3a31964ba1c8f16bf9f4f22f4eb','0.01','application','/app/ppt/'),(209,'d17e0eed60dd1bfdbdb27823a911e4c1','3.2.6','application','/data'),(212,'df98c419c98cc6f1488fc83e13e0244a','0.0.1','application','/data'),(213,'c54675939604335999a6912282504aa5','1.0.1','application','/data'),(214,'6f7edb496760bb1965bdce1135883b29','5.6.35','application','/data'),(219,'6f7edb496760bb1965bdce1135883b29','5.6.36.1','application','/data'),(220,'6f7edb496760bb1965bdce1135883b29','5.6.36','application','/data'),(222,'1da66aa04277b93485c5b6d0561f0762','0.9.97','application','/data'),(224,'1da66aa04277b93485c5b6d0561f0762','0.9.141','application','/data'),(225,'c4680f24a4e8f17aacdbeee9cbea6605','1.0.0','application','/app/var/www'),(228,'e18aef89702a2dfc3e14ab290c60004f','1.1.1','application','/app/DATA/'),(235,'48079a675bd8f6e226859c61da280a76','3.2.7','application','/data'),(238,'d3b1cff084ddb23841f2c1b02f1cf2d6','v8.9.5.1','application','/data'),(239,'484a8b96c1da021200196cb476838fce','1.0','application','/app//data'),(241,'7bbdf58fe948721169252c9bada4eeda','v3.1.6','application','/app/etcd-data'),(242,'2669c2cec6bc7bf5aab29a0ea2703d66','4.7.4','application','/var/www/html'),(243,'f6456128a3c890ebc93dc0a87c37efe2','3.3.3','application','/app/data'),(244,'d0a121bcd60d7e59a7e45d8df0f85f46','9.2.5','application','/home/git/data'),(245,'d0a121bcd60d7e59a7e45d8df0f85f46','9.2.5','application','/var/log/gitlab'),(247,'92e8626c905dd244f656ecb709d556ed','3.5.0','application','/var/opt/jfrog/artifactory'),(249,'3e99f372954e640f04d2170942b116f9','3.0.13','application','/var/lib/cassandra'),(250,'207e6441ba2e443a71515c95269df4e1','3.4.10','application','/data'),(251,'207e6441ba2e443a71515c95269df4e1','3.4.10','application','/datalog');
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

-- Dump completed on 2017-08-02 17:12:55
