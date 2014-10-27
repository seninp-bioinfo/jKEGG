-- MySQL dump 10.13  Distrib 5.1.71, for redhat-linux-gnu (x86_64)
--
-- ------------------------------------------------------
-- Server version	5.1.73-log

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
-- Table structure for table `blast_hits`
--

DROP TABLE IF EXISTS `blast_hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blast_hits` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(9) NOT NULL,
  `query_id` varchar(128) NOT NULL,
  `subject_id` varchar(128) NOT NULL,
  `alignment_length` int(11) DEFAULT NULL,
  `matches` int(11) DEFAULT NULL,
  `gaps` int(11) DEFAULT NULL,
  `e_value` double DEFAULT NULL,
  `bit_score` double DEFAULT NULL,
  `percent_identity` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=104677 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `blast_hits_integrase`
--

DROP TABLE IF EXISTS `blast_hits_integrase`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `blast_hits_integrase` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tag` varchar(9) NOT NULL,
  `query_id` varchar(128) NOT NULL,
  `subject_id` varchar(128) NOT NULL,
  `alignment_length` int(11) DEFAULT NULL,
  `matches` int(11) DEFAULT NULL,
  `gaps` int(11) DEFAULT NULL,
  `e_value` double DEFAULT NULL,
  `bit_score` double DEFAULT NULL,
  `percent_identity` double DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM AUTO_INCREMENT=112442 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bright_ko`
--

DROP TABLE IF EXISTS `bright_ko`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `bright_ko` (
  `bright_id` char(10) DEFAULT NULL,
  `ko_id` char(9) DEFAULT NULL,
  KEY `br_idx` (`bright_id`),
  KEY `ko_idx` (`ko_id`),
  FULLTEXT KEY `br_full` (`bright_id`),
  FULLTEXT KEY `ko_full` (`ko_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cog_definition`
--

DROP TABLE IF EXISTS `cog_definition`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cog_definition` (
  `cog_id` char(14) DEFAULT NULL,
  `cog_class` char(5) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  KEY `kog_class` (`cog_class`),
  KEY `kog_idx` (`cog_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `cog_groups`
--

DROP TABLE IF EXISTS `cog_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cog_groups` (
  `group_id` char(1) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `genes_description`
--

DROP TABLE IF EXISTS `genes_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genes_description` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gene_id` varchar(23) NOT NULL,
  `organism_idx` int(11) NOT NULL,
  `description` varchar(556) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `gene_key` (`gene_id`),
  UNIQUE KEY `organism_gene_key` (`organism_idx`,`gene_id`),
  UNIQUE KEY `organism_id_key` (`id`,`organism_idx`),
  KEY `desc` (`description`),
  KEY `organism_idx_key` (`organism_idx`),
  FULLTEXT KEY `desc_full` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=12248187 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `genes_ko`
--

DROP TABLE IF EXISTS `genes_ko`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genes_ko` (
  `gene_id` varchar(23) NOT NULL,
  `ko_id` char(9) NOT NULL,
  `ko_idx` int(11) NOT NULL,
  `gene_idx` int(11) DEFAULT NULL,
  KEY `ko_name_idx` (`ko_id`),
  KEY `ko_key_idx` (`ko_idx`),
  KEY `gene_key_idx` (`gene_idx`),
  KEY `gene_name_idx` (`gene_id`),
  KEY `gene_ko_idx` (`gene_idx`,`ko_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `genes_pathway`
--

DROP TABLE IF EXISTS `genes_pathway`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genes_pathway` (
  `gene_id` varchar(23) DEFAULT NULL,
  `path_id` char(14) DEFAULT NULL,
  UNIQUE KEY `gene_pathway` (`gene_id`,`path_id`),
  KEY `gene_idx` (`gene_id`),
  KEY `path_idx` (`path_id`),
  FULLTEXT KEY `gene_full` (`gene_id`),
  FULLTEXT KEY `path_full` (`path_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hcgA`
--

DROP TABLE IF EXISTS `hcgA`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hcgA` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name_key` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=92 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hcgA_hits`
--

DROP TABLE IF EXISTS `hcgA_hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hcgA_hits` (
  `tag` varchar(9) NOT NULL,
  `query_id` varchar(256) NOT NULL,
  `subject_id` varchar(256) NOT NULL,
  `identity` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `hit_tags`
--

DROP TABLE IF EXISTS `hit_tags`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `hit_tags` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `tag_description` char(8) DEFAULT NULL,
  `raw_reads` int(11) NOT NULL,
  `aligned_R1` int(11) NOT NULL,
  `aligned_R2` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `description` (`tag_description`)
) ENGINE=MyISAM AUTO_INCREMENT=80 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `integrases`
--

DROP TABLE IF EXISTS `integrases`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `integrases` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `name_key` (`name`)
) ENGINE=MyISAM AUTO_INCREMENT=980 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `integrases_hits`
--

DROP TABLE IF EXISTS `integrases_hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `integrases_hits` (
  `tag` varchar(9) NOT NULL,
  `query_id` varchar(256) NOT NULL,
  `subject_id` varchar(256) NOT NULL,
  `identity` int(11) DEFAULT NULL,
  `score` int(11) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kegg_hits`
--

DROP TABLE IF EXISTS `kegg_hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kegg_hits` (
  `tag` tinyint(4) NOT NULL,
  `hit_id` varchar(23) DEFAULT NULL,
  `organism_idx` int(11) DEFAULT NULL,
  `gene_idx` int(11) DEFAULT NULL,
  `identity` smallint(6) NOT NULL,
  `score` smallint(6) NOT NULL,
  KEY `tag` (`tag`),
  KEY `organism_idx` (`organism_idx`),
  KEY `hit_ids` (`hit_id`),
  KEY `gene_idx_key` (`gene_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `kegg_hits_backup`
--

DROP TABLE IF EXISTS `kegg_hits_backup`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `kegg_hits_backup` (
  `tag` tinyint(4) NOT NULL,
  `hit_id` varchar(23) DEFAULT NULL,
  `organism_idx` int(11) DEFAULT NULL,
  `gene_idx` int(11) DEFAULT NULL,
  `identity` smallint(6) NOT NULL,
  `score` smallint(6) NOT NULL,
  KEY `tag_key` (`tag`),
  KEY `organism_key` (`organism_idx`),
  KEY `gene_key` (`gene_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ko_cog`
--

DROP TABLE IF EXISTS `ko_cog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ko_cog` (
  `ko_id` varchar(9) DEFAULT NULL,
  `cog_id` char(12) DEFAULT NULL,
  UNIQUE KEY `ko_map` (`ko_id`,`cog_id`),
  KEY `cog_idx` (`cog_id`),
  KEY `ko_idx` (`ko_id`),
  FULLTEXT KEY `cog_full` (`cog_id`),
  FULLTEXT KEY `ko_full` (`ko_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ko_description`
--

DROP TABLE IF EXISTS `ko_description`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ko_description` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ko_id` char(9) DEFAULT NULL,
  `description` varchar(232) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `ko_idx` (`ko_id`),
  FULLTEXT KEY `ko_full` (`ko_id`),
  FULLTEXT KEY `desc_full` (`description`)
) ENGINE=MyISAM AUTO_INCREMENT=134396 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ko_map`
--

DROP TABLE IF EXISTS `ko_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ko_map` (
  `ko_id` varchar(6) NOT NULL,
  `map_id` char(5) NOT NULL,
  `ko_idx` int(11) DEFAULT NULL,
  `map_idx` int(11) NOT NULL,
  KEY `ko_index` (`ko_idx`),
  KEY `map_index` (`map_idx`),
  KEY `map_ind` (`map_id`),
  KEY `ko_ind` (`ko_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `ko_of_interest`
--

DROP TABLE IF EXISTS `ko_of_interest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `ko_of_interest` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ko_idx` int(11) DEFAULT NULL,
  `ko_id` char(9) NOT NULL,
  `tag` char(20) NOT NULL,
  `description` varchar(256) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `ko_key` (`ko_idx`),
  KEY `ko_id_idx` (`ko_id`),
  KEY `tag_key` (`tag`),
  FULLTEXT KEY `tag_full` (`tag`)
) ENGINE=MyISAM AUTO_INCREMENT=19 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `map_title`
--

DROP TABLE IF EXISTS `map_title`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `map_title` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `map_id` char(5) NOT NULL DEFAULT '',
  `title` varchar(512) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `title` (`title`),
  KEY `map_id_idx` (`map_id`),
  FULLTEXT KEY `title_full` (`title`)
) ENGINE=MyISAM AUTO_INCREMENT=460 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organisms`
--

DROP TABLE IF EXISTS `organisms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organisms` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `code` char(4) DEFAULT NULL,
  `tnum` char(6) DEFAULT NULL,
  `name` varchar(75) DEFAULT NULL,
  `lineage` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `organism_key` (`code`,`tnum`,`name`),
  UNIQUE KEY `code_idx` (`code`),
  UNIQUE KEY `tnum_idx` (`tnum`),
  KEY `name_idx` (`name`),
  FULLTEXT KEY `name_full` (`name`),
  FULLTEXT KEY `code_full` (`code`)
) ENGINE=MyISAM AUTO_INCREMENT=3048 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `organisms_of_interest`
--

DROP TABLE IF EXISTS `organisms_of_interest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `organisms_of_interest` (
  `tag` varchar(20) NOT NULL,
  `code` char(4) DEFAULT NULL,
  `tnum` char(6) DEFAULT NULL,
  `organism_idx` int(11) NOT NULL,
  `name` varchar(75) DEFAULT NULL,
  `lineage` varchar(1024) DEFAULT NULL,
  UNIQUE KEY `org_tag_idx` (`tag`,`organism_idx`),
  KEY `tag_idx` (`tag`),
  KEY `org_idx` (`organism_idx`),
  FULLTEXT KEY `code_full` (`code`),
  FULLTEXT KEY `tnum_full` (`tnum`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `so_hits`
--

DROP TABLE IF EXISTS `so_hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `so_hits` (
  `tag` tinyint(4) NOT NULL,
  `hit_id` varchar(23) DEFAULT NULL,
  `organism_idx` int(11) DEFAULT NULL,
  `gene_idx` int(11) DEFAULT NULL,
  `identity` smallint(6) NOT NULL,
  `score` smallint(6) NOT NULL,
  KEY `tag` (`tag`),
  KEY `organism_idx` (`organism_idx`),
  KEY `hit_ids` (`hit_id`),
  KEY `gene_idx_key` (`gene_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sr_hits`
--

DROP TABLE IF EXISTS `sr_hits`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sr_hits` (
  `tag` tinyint(4) NOT NULL,
  `hit_id` varchar(23) DEFAULT NULL,
  `organism_idx` int(11) DEFAULT NULL,
  `gene_idx` int(11) DEFAULT NULL,
  `identity` smallint(6) NOT NULL,
  `score` smallint(6) NOT NULL,
  KEY `tag` (`tag`),
  KEY `organism_idx` (`organism_idx`),
  KEY `hit_ids` (`hit_id`),
  KEY `gene_idx_key` (`gene_idx`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `sulfate_reducers`
--

DROP TABLE IF EXISTS `sulfate_reducers`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sulfate_reducers` (
  `organism_idx` int(11) NOT NULL DEFAULT '0',
  `tag` char(3) NOT NULL,
  `full_name` varchar(128) NOT NULL,
  PRIMARY KEY (`organism_idx`),
  UNIQUE KEY `tag_key` (`tag`),
  FULLTEXT KEY `name_full` (`full_name`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-10-27 11:23:53
