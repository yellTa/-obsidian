-- MySQL dump 10.13  Distrib 8.0.33, for Win64 (x86_64)
--
-- Host: localhost    Database: burgerputproto
-- ------------------------------------------------------
-- Server version	8.0.33

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accounts`
--

DROP TABLE IF EXISTS `accounts`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accounts` (
  `num` int NOT NULL AUTO_INCREMENT,
  `zenput_id` varchar(255) DEFAULT NULL,
  `rbi_pw` varchar(255) DEFAULT NULL,
  `rbi_id` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`num`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accounts`
--

LOCK TABLES `accounts` WRITE;
/*!40000 ALTER TABLE `accounts` DISABLE KEYS */;
INSERT INTO `accounts` VALUES (1,'rgm21490@rest.whopper.com','Axjalsjf123456','다이강000001');
/*!40000 ALTER TABLE `accounts` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_food`
--

DROP TABLE IF EXISTS `custom_food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_food` (
  `num` bigint NOT NULL AUTO_INCREMENT,
  `id` int NOT NULL,
  PRIMARY KEY (`num`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_food`
--

LOCK TABLES `custom_food` WRITE;
/*!40000 ALTER TABLE `custom_food` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `custom_machine`
--

DROP TABLE IF EXISTS `custom_machine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `custom_machine` (
  `num` bigint NOT NULL AUTO_INCREMENT,
  `id` int NOT NULL,
  PRIMARY KEY (`num`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `custom_machine`
--

LOCK TABLES `custom_machine` WRITE;
/*!40000 ALTER TABLE `custom_machine` DISABLE KEYS */;
/*!40000 ALTER TABLE `custom_machine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `food`
--

DROP TABLE IF EXISTS `food`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `food` (
  `num` bigint NOT NULL AUTO_INCREMENT,
  `id` int NOT NULL,
  `max` int NOT NULL,
  `min` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `food`
--

LOCK TABLES `food` WRITE;
/*!40000 ALTER TABLE `food` DISABLE KEYS */;
/*!40000 ALTER TABLE `food` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `machine`
--

DROP TABLE IF EXISTS `machine`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `machine` (
  `num` bigint NOT NULL AUTO_INCREMENT,
  `id` int NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `min` int NOT NULL,
  `max` int NOT NULL,
  PRIMARY KEY (`num`)
) ENGINE=InnoDB AUTO_INCREMENT=36 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `machine`
--

LOCK TABLES `machine` WRITE;
/*!40000 ALTER TABLE `machine` DISABLE KEYS */;
INSERT INTO `machine` VALUES (1,2,'온도계(탐침1)',31,33),(2,54,'온도계(탐침2)',31,33),(3,56,'온도계(표면1)',31,33),(4,4,'워크인쿨러',34,40),(5,95,'리치인쿨러1',34,40),(6,97,'리치인쿨러2',34,40),(7,103,'리치인쿨러3',34,40),(8,117,'워크인프리저',-10,0),(9,12,'리치인프리저1',-10,0),(10,14,'리치인프리저2',-10,0),(11,10,'리치인프리저3',-10,0),(12,18,'미트프리저',-10,0),(13,20,'스페셜티프리저1',-10,0),(14,22,'스페셜티프리저2',-10,0),(15,58,'냉장유닛(콜라냉장고)',34,40),(16,60,'아이스크림(호퍼)',34,40),(17,26,'메인프라이어1',345,355),(18,28,'메인프라이어2',345,355),(19,32,'멀티프라이어1',355,365),(20,62,'멀티프라이어2',355,365),(21,39,'3조싱크칸(세척온수)',120,135),(22,66,'3조싱크칸(소독수온수)',69,120),(23,64,'핸드싱크(온수)',100,135),(24,44,'PHU내제품온도1',140,185),(25,46,'PHU내제품온도2',140,185),(26,48,'PHU내제품온도3',140,185),(27,50,'PHU내제품온도4',140,185),(28,68,'힛보드1',110,120),(29,70,'힛보드2',110,120),(30,76,'리세스힛슈트(구형)1',165,185),(31,78,'리세스힛슈트(구형)2',165,185),(32,80,'힛슈트(신형)1',190,210),(33,82,'힛슈트(신형)2',190,210),(34,72,'딜리버리픽업스테이션1',165,185),(35,74,'딜리버리픽업스테이션2',165,185);
/*!40000 ALTER TABLE `machine` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `mgrlist`
--

DROP TABLE IF EXISTS `mgrlist`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `mgrlist` (
  `id` int NOT NULL AUTO_INCREMENT,
  `mgr_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `mgrlist`
--

LOCK TABLES `mgrlist` WRITE;
/*!40000 ALTER TABLE `mgrlist` DISABLE KEYS */;
INSERT INTO `mgrlist` VALUES (3,'천상연'),(4,'신호준'),(6,'유예지');
/*!40000 ALTER TABLE `mgrlist` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-29 19:15:48
