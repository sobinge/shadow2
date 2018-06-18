-- phpMyAdmin SQL Dump
-- version 2.11.9.2
-- http://www.phpmyadmin.net
--
-- 主机: 127.0.0.1:3306
-- 生成日期: 2012 年 11 月 20 日 12:53
-- 服务器版本: 5.1.28
-- PHP 版本: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `xsser`
--

-- --------------------------------------------------------

--
-- 表的结构 `xg_browser`
--

CREATE TABLE IF NOT EXISTS `xg_browser` (
  `bid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `ip` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `os` varchar(20) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `active` int(1) NOT NULL DEFAULT '1' COMMENT '在线',
  `type` varchar(30) NOT NULL COMMENT '浏览器类型',
  `dateline` int(11) NOT NULL COMMENT '上线时间',
  `pid` int(11) NOT NULL,
  PRIMARY KEY (`bid`)
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=6 ;

--
-- 导出表中的数据 `xg_browser`
--


-- --------------------------------------------------------

--
-- 表的结构 `xg_incode`
--

CREATE TABLE IF NOT EXISTS `xg_incode` (
  `iid` int(11) NOT NULL AUTO_INCREMENT,
  `time` int(11) NOT NULL,
  `code` varchar(11) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`iid`),
  UNIQUE KEY `code` (`code`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=6 ;

--
-- 导出表中的数据 `xg_incode`
--


-- --------------------------------------------------------

--
-- 表的结构 `xg_info`
--

CREATE TABLE IF NOT EXISTS `xg_info` (
  `iid` int(11) NOT NULL AUTO_INCREMENT,
  `bid` int(11) NOT NULL,
  `url` text COLLATE utf8_bin,
  `cookie` text COLLATE utf8_bin,
  `location` text COLLATE utf8_bin,
  `referer` text COLLATE utf8_bin,
  `agent` text COLLATE utf8_bin,
  `sk_status` char(100) COLLATE utf8_bin DEFAULT NULL,
  PRIMARY KEY (`iid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=6 ;

--
-- 导出表中的数据 `xg_info`
--


-- --------------------------------------------------------

--
-- 表的结构 `xg_project`
--

CREATE TABLE IF NOT EXISTS `xg_project` (
  `pid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(32) COLLATE utf8_bin NOT NULL,
  `time` int(11) NOT NULL,
  `uid` int(11) NOT NULL,
  `url` varchar(6) COLLATE utf8_bin NOT NULL,
  `iscrsf` int(1) DEFAULT '0',
  `csrfurl` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `crsfs` varchar(255) COLLATE utf8_bin DEFAULT NULL,
  `eamil` varchar(50) COLLATE utf8_bin DEFAULT NULL,
  `sessionkeeper` int(1) DEFAULT '0',
  PRIMARY KEY (`pid`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=7 ;

--
-- 导出表中的数据 `xg_project`
--


-- --------------------------------------------------------

--
-- 表的结构 `xg_user`
--

CREATE TABLE IF NOT EXISTS `xg_user` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(60) COLLATE utf8_bin NOT NULL,
  `pass` varchar(32) COLLATE utf8_bin NOT NULL,
  `key` int(11) NOT NULL,
  `ip` varchar(32) COLLATE utf8_bin NOT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `name` (`name`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_bin AUTO_INCREMENT=31 ;

--
-- 导出表中的数据 `xg_user`
--

