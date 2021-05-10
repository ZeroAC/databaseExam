-- MySQL dump 10.13  Distrib 8.0.19, for Linux (x86_64)
--
-- Host: localhost    Database: jxsk
-- ------------------------------------------------------
-- Server version	8.0.19-0ubuntu5

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
-- Table structure for table `c`
--

DROP TABLE IF EXISTS `c`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `c` (
  `cno` varchar(10) NOT NULL COMMENT '课程号',
  `cn` varchar(20) NOT NULL COMMENT '课程名',
  `time` tinyint unsigned DEFAULT NULL COMMENT ' 课时数',
  `credit` tinyint unsigned DEFAULT NULL COMMENT '学分',
  `prevCno` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`cno`),
  UNIQUE KEY `cn` (`cn`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `c`
--

LOCK TABLES `c` WRITE;
/*!40000 ALTER TABLE `c` DISABLE KEYS */;
INSERT INTO `c` VALUES ('c1','程序设计',60,3,NULL),('c2','微机原理',60,3,'c1'),('c3','数据库',90,4,'c1'),('c5','高等数学',80,4,NULL);
/*!40000 ALTER TABLE `c` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `s`
--

DROP TABLE IF EXISTS `s`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `s` (
  `sno` varchar(20) NOT NULL COMMENT '学号',
  `sn` varchar(10) NOT NULL COMMENT '学生名',
  `sex` enum('男','女') NOT NULL,
  `birthday` date DEFAULT '2000-01-01' COMMENT '出生日期',
  `dept` varchar(10) DEFAULT NULL COMMENT '所在系名',
  PRIMARY KEY (`sno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `s`
--

LOCK TABLES `s` WRITE;
/*!40000 ALTER TABLE `s` DISABLE KEYS */;
INSERT INTO `s` VALUES ('s1','赵亦','女','1995-01-01','计算机'),('s2','钱尔','男','1996-01-10','信息'),('s3','张小明','男','1995-12-10','信息'),('s4','李思','男','1995-06-01','自动化'),('s5','周武','男','2002-12-01','信息');
/*!40000 ALTER TABLE `s` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sc`
--

DROP TABLE IF EXISTS `sc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `sc` (
  `sno` varchar(20) NOT NULL COMMENT '学生的学号',
  `cno` varchar(20) NOT NULL COMMENT '该学生选定课程号',
  `score` tinyint unsigned DEFAULT '0' COMMENT '该学生该门课的成绩',
  PRIMARY KEY (`sno`,`cno`) COMMENT '组合主键 不允许全部相同'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sc`
--

LOCK TABLES `sc` WRITE;
/*!40000 ALTER TABLE `sc` DISABLE KEYS */;
INSERT INTO `sc` VALUES ('1','1',32),('1','2',33),('2','2',34);
/*!40000 ALTER TABLE `sc` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t`
--

DROP TABLE IF EXISTS `t`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t` (
  `tno` varchar(20) NOT NULL COMMENT '教师号 ',
  `tn` varchar(10) NOT NULL COMMENT '教师名',
  `sex` enum('男','女') NOT NULL,
  `age` tinyint DEFAULT NULL COMMENT 'tingint为0~255 符合年龄要求',
  `prof` varchar(10) DEFAULT NULL COMMENT '教师职称',
  `sal` int DEFAULT NULL COMMENT '工资',
  `comm` int DEFAULT NULL COMMENT '岗位津贴',
  `dept` varchar(10) DEFAULT NULL COMMENT '所在系名',
  PRIMARY KEY (`tno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t`
--

LOCK TABLES `t` WRITE;
/*!40000 ALTER TABLE `t` DISABLE KEYS */;
INSERT INTO `t` VALUES ('t1','李力','男',47,'教授',1500,3000,'计算机'),('t2','王平','男',28,'副教授',1900,2200,'信息'),('t3','刘伟','男',30,'讲师',900,1200,'计算机'),('t4','张雪','女',51,'教授',1600,3000,'自动化'),('t5','张兰','女',39,'副教授',1300,2000,'信息');
/*!40000 ALTER TABLE `t` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tc`
--

DROP TABLE IF EXISTS `tc`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `tc` (
  `tno` varchar(20) NOT NULL COMMENT '教师编号',
  `cno` varchar(20) NOT NULL COMMENT '课程编号',
  `weekday` tinyint unsigned DEFAULT NULL COMMENT '周几上课',
  `preriod` tinyint unsigned DEFAULT NULL COMMENT '节次',
  `room` varchar(20) DEFAULT NULL COMMENT '教室',
  `eval` varchar(100) DEFAULT NULL COMMENT '评价',
  PRIMARY KEY (`tno`,`cno`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tc`
--

LOCK TABLES `tc` WRITE;
/*!40000 ALTER TABLE `tc` DISABLE KEYS */;
/*!40000 ALTER TABLE `tc` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2021-04-21 11:16:18
