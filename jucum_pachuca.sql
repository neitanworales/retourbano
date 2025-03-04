/*
Navicat MySQL Data Transfer

Source Server         : LOCALHOST
Source Server Version : 50505
Source Host           : localhost:3306
Source Database       : jucum_pachuca

Target Server Type    : MYSQL
Target Server Version : 50505
File Encoding         : 65001

Date: 2023-02-14 11:37:00
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for bitacora_cambios
-- ----------------------------
DROP TABLE IF EXISTS `bitacora_cambios`;
CREATE TABLE `bitacora_cambios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guerrero_id` int(11) DEFAULT NULL,
  `tabla` varchar(255) DEFAULT NULL,
  `old_value` varchar(8000) DEFAULT NULL,
  `new_value` varchar(8000) DEFAULT NULL,
  `fecha` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of bitacora_cambios
-- ----------------------------

-- ----------------------------
-- Table structure for campamentos
-- ----------------------------
DROP TABLE IF EXISTS `campamentos`;
CREATE TABLE `campamentos` (
  `id_campamento` int(11) DEFAULT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `activo` tinyint(4) DEFAULT NULL,
  `maximo_inscr` int(11) DEFAULT NULL,
  `umbral` int(11) DEFAULT NULL,
  `fecha_maxima` datetime DEFAULT NULL,
  `fecha_apertura` datetime DEFAULT NULL,
  KEY `id_campamento` (`id_campamento`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of campamentos
-- ----------------------------
INSERT INTO `campamentos` VALUES ('2022', 'Obediencia Radical Volumen II', '1', '107', '20', '2022-07-08 23:59:59', '2022-05-01 00:00:00');
INSERT INTO `campamentos` VALUES ('2021', 'Campamento 2021', '0', '150', '20', '2021-07-08 23:59:59', '2021-05-01 00:00:00');

-- ----------------------------
-- Table structure for campamento_guerreros
-- ----------------------------
DROP TABLE IF EXISTS `campamento_guerreros`;
CREATE TABLE `campamento_guerreros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `id_campamento` int(11) DEFAULT NULL,
  `id_guerrero` int(11) DEFAULT NULL,
  `status` varchar(1) DEFAULT NULL,
  `confirmado` tinyint(1) DEFAULT 0,
  `asistencia` tinyint(1) DEFAULT 0,
  `staff` tinyint(1) DEFAULT 0,
  `admin` tinyint(1) DEFAULT 0,
  `seguimiento` tinyint(1) DEFAULT 0,
  `email_enviado` tinyint(1) DEFAULT NULL,
  `email_confirmado` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `campamento` (`id_campamento`),
  KEY `guerreros` (`id_guerrero`),
  CONSTRAINT `campamento` FOREIGN KEY (`id_campamento`) REFERENCES `campamentos` (`id_campamento`),
  CONSTRAINT `guerreros` FOREIGN KEY (`id_guerrero`) REFERENCES `guerreros` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=131 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of campamento_guerreros
-- ----------------------------
INSERT INTO `campamento_guerreros` VALUES ('1', '2022', '68', 'B', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('2', '2022', '76', 'B', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('3', '2022', '165', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('4', '2022', '166', 'B', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('5', '2022', '174', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('6', '2022', '177', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('7', '2022', '178', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('8', '2022', '192', 'A', '0', '0', '1', '1', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('9', '2022', '196', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('10', '2022', '202', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('11', '2022', '216', 'A', '0', '0', '1', '1', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('12', '2022', '223', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('13', '2022', '237', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('14', '2022', '262', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('15', '2022', '264', 'B', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('16', '2022', '278', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('17', '2022', '279', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('18', '2022', '297', 'B', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('19', '2022', '298', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('20', '2022', '299', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('21', '2022', '300', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('22', '2022', '301', 'A', '0', '0', '1', '1', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('23', '2022', '1001', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('24', '2022', '1002', 'A', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('25', '2022', '1003', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('26', '2022', '1004', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('27', '2022', '1005', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('28', '2022', '1006', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('29', '2022', '1007', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('30', '2022', '1008', 'A', '1', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('31', '2022', '1009', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('32', '2022', '1010', 'A', '0', '0', '1', '1', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('33', '2022', '1011', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('34', '2022', '1012', 'A', '0', '0', '1', '1', '0', '1', '1');
INSERT INTO `campamento_guerreros` VALUES ('35', '2022', '1013', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('36', '2022', '1014', 'B', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('37', '2022', '1015', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('38', '2022', '1016', 'A', '0', '0', '1', '1', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('39', '2022', '1017', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('40', '2022', '1018', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('41', '2022', '1019', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('42', '2022', '1020', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('43', '2022', '1021', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('44', '2022', '1022', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('45', '2022', '1023', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('46', '2022', '1024', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('47', '2022', '1025', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('48', '2022', '1026', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('49', '2022', '1027', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('50', '2022', '1028', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('51', '2022', '1029', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('52', '2022', '1030', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('53', '2022', '1031', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('54', '2022', '1032', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('55', '2022', '1033', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('56', '2022', '1034', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('57', '2022', '1035', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('58', '2022', '1036', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('59', '2022', '1037', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('60', '2022', '1038', 'A', '1', '0', '0', '0', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('61', '2022', '1039', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('62', '2022', '1040', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('63', '2022', '1041', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('64', '2022', '1042', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('65', '2022', '1043', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('66', '2022', '1044', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('67', '2022', '1045', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('68', '2022', '1046', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('69', '2022', '1047', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('70', '2022', '1048', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('71', '2022', '1049', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('72', '2022', '1050', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('73', '2022', '1051', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('74', '2022', '1052', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('75', '2022', '1053', 'A', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('76', '2022', '1054', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('77', '2022', '1055', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('78', '2022', '1056', 'B', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('79', '2022', '1057', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('80', '2022', '1058', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('81', '2022', '1059', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('82', '2022', '1060', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('83', '2022', '1061', 'A', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('84', '2022', '1062', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('85', '2022', '1063', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('86', '2022', '1064', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('87', '2022', '1065', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('88', '2022', '1066', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('89', '2022', '1067', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('90', '2022', '1068', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('91', '2022', '1069', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('92', '2022', '1070', 'A', '1', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('93', '2022', '1071', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('94', '2022', '1072', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('95', '2022', '1073', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('96', '2022', '1074', 'A', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('97', '2022', '1075', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('98', '2022', '1076', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('99', '2022', '1077', 'A', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('100', '2022', '1078', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('101', '2022', '1079', 'A', '0', '0', '0', '0', '1', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('102', '2022', '1080', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('103', '2022', '1081', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('104', '2022', '1082', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('105', '2022', '1083', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('106', '2022', '1084', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('107', '2022', '1085', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('108', '2022', '1086', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('109', '2022', '1087', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('110', '2022', '1088', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('111', '2022', '1089', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('112', '2022', '1090', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('113', '2022', '1091', 'A', '0', '0', '1', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('128', '2022', '1092', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('129', '2022', '1093', 'A', '0', '0', '0', '0', '0', '0', '0');
INSERT INTO `campamento_guerreros` VALUES ('130', '2022', '1094', 'A', '0', '0', '0', '0', '0', '0', '0');

-- ----------------------------
-- Table structure for guerreros
-- ----------------------------
DROP TABLE IF EXISTS `guerreros`;
CREATE TABLE `guerreros` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `fechanac` date DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `talla` varchar(3) DEFAULT NULL,
  `vienede` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(12) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `alergias` varchar(255) DEFAULT NULL,
  `razones` varchar(255) DEFAULT NULL,
  `contacto_tutor` varchar(12) DEFAULT NULL,
  `iglesia` varchar(50) DEFAULT NULL,
  `fechahora_registro` datetime DEFAULT NULL,
  `tutor_nombre` varchar(50) DEFAULT NULL,
  `facebook` varchar(50) DEFAULT NULL,
  `instagram` varchar(50) DEFAULT NULL,
  `politicas` bit(1) DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=1095 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros
-- ----------------------------
INSERT INTO `guerreros` VALUES ('68', 'maria yelen bello hernandez ', 'yelen bello ', null, null, 'F', 'S', 'pachuca ', '7711724682', 'yelenbellohernandez@gmail.com', 'ninguna ', 'por que es una experiencia increible y me gusta mucho ', '7711501548', ' activando ', '2021-05-11 16:57:06', 'Gisela Hernández Reyes ', 'myelen bello ', '@yelenbello ', '', 'asdf2828segu1');
INSERT INTO `guerreros` VALUES ('76', 'Carlos Yereth Bello Hernández ', 'Yereth', '2004-06-02', '16', 'M', 'M', 'Pachuca ', '7712177459', 'yerethbello@gmail.com', 'No', 'Por querer acercarme mucho más a Dios ', '7711501548', 'Activando Generaciones ', '2021-05-11 19:36:54', 'Juana Gisela Hernández Reyes ', 'Yereth Bello ', 'yereth_710', '', 'retoU2476asdf');
INSERT INTO `guerreros` VALUES ('165', 'Gonzalez Brito Zabdi Joshua', 'Zabdi', '2022-01-28', '0', 'M', 'M', 'CDMX', '5526631582', 'zabdi.gonzalez15@gmail.com', 'Ninguna', 'Para conocer más a Dios y vivir una experiencia inolvidable', '5526666763', 'Jesucristo Redentor Perfecto', '2021-05-19 09:00:21', 'Carmen Brito Valeras', 'Zabdi himiko', 'Zabdi_ brito', '', 'saxofon6335auto');
INSERT INTO `guerreros` VALUES ('166', 'Angel Eduardo', 'Angel', '2003-01-02', '18', 'M', 'S', 'Pachuca, hgo', '7714247361', 'angel20primeroc@gmail.com', 'Ninguna', 'Saber mas de Dios y resolver dudas', '7714260389', 'PIB Pachuca', '2021-05-19 11:51:49', 'Silvia', 'Angel Eduardo', 'eduardo18_02', '', 'nota5286musik');
INSERT INTO `guerreros` VALUES ('174', 'Chantal Reneé', 'Shanty', '2004-03-04', '17', 'F', 'S', 'Las Américas', '5583908537', 'santalsosa11@gmail.com', 'Ninguna', 'Fui al seguimiento desde el 2019 y empezó la pandemia.', '5524046055', 'SUPRA', '2021-05-25 18:23:35', 'Judith Mancha', 'Shantal Sosa', 'Shantal Sosa', '', 'frase5985segu1');
INSERT INTO `guerreros` VALUES ('177', 'Erick Sebastián', 'Sosa (Sosita)', '2002-05-02', '18', 'M', 'XL', 'Las Américas', '5613284566', 'avestruzerick@gmail.com', 'Mormones (Ninguna)', 'Fui al seguimiento desde 2019, y comenzó la pandemia.', '5529202161', 'SUPRA', '2021-05-25 18:36:10', 'Sergio Sosa', 'Sebastián Sosa', '@erick.sm_06', '', 'asdf6382zxcv');
INSERT INTO `guerreros` VALUES ('178', 'Daniela Quiroz', 'Danielle', '2003-10-26', '17', 'F', 'S', 'Ciudad de México', '5539639002', 'daniela.quiroz7u7@gmail.com', 'Gatos, polvo', 'Para tener una comunión más cercana con Dios, aprender y disfrutar', '5554034494', 'Jesucristo Redentor Perfecto', '2021-05-28 01:18:16', 'Marisol Vera Garrido', 'Danielle Quiroz', 'dxnielle._', '', 'daniela2563');
INSERT INTO `guerreros` VALUES ('192', 'Berenice Lozano', 'Bere', '0000-00-00', '27', 'F', 'S', 'Mi casa ', '7711506403', 'berenicelozano2@gmail.com', 'No', 'Staff', '7712388715', '', '2021-06-03 12:06:16', 'Luz', '', '', '', 'saxofon4800frase');
INSERT INTO `guerreros` VALUES ('196', 'Daniela Rergis ', 'Danny', '1999-10-05', '21', 'F', 'X', 'Cdmx', '5545762580', 'dannyrergis@hotmail.com', 'Sulfas ', 'Staff', '5543652979', 'Hope and anchor', '2021-06-05 15:36:35', 'Verónica Pérez Gallardo Pérez ', 'Danny Rergis ', 'Dannyrergispg', '', 'mexico3722asdf');
INSERT INTO `guerreros` VALUES ('202', 'Dan Giovanni Medina Camacho', 'Gio', '2000-12-22', '20', 'M', 'M', 'Tula de Allende, Hgo', '5532756461', 'camacho3.dan@gmail.com', 'Ninguna ', 'Conocer más De Dios ', '7732195832', 'Nueva Vida', '2021-06-07 09:48:58', 'Carolina Camacho Alvarez ', 'Dan Giovanni Medina Camacho ', '@dangio12', '', 'volta3365mexico');
INSERT INTO `guerreros` VALUES ('216', 'Ricardo Hernandez', 'Richz Volta', null, '0', 'M', 'M', 'Jucumlandia', '7712088634', 'richjucum@gmail.com', 'A los gatos', 'Por que si', '7712088634', 'Conerstone', '2021-06-14 09:19:12', 'Citlali ', 'Richz Volta', 'Richzvolta', '', 'musik2310nota');
INSERT INTO `guerreros` VALUES ('223', 'Isaac Levi Reyes Cisneros', 'Reyes ', '2000-01-01', '21', 'M', 'M', 'Estado de México ', '5616499020', 'isaacreyesc14@gmail.com', 'Ninguna ', 'Recomendación ', ' 5517543328', '', '2021-06-16 23:05:43', 'Sergio Luis Reyes Vázquez', 'Isaac Reyes ', '', '', 'saxofon6962segu1');
INSERT INTO `guerreros` VALUES ('237', 'Regina Rergis ', 'Regis', '2007-02-01', '14', 'F', 'M', 'Cdmx', '5545762580', 'regisrergis@gmail.com', 'Ninguna ', 'Mi prima me trajo ', '5587773575', '', '2021-06-21 11:12:06', 'Blanca Oliva', 'Regina Rergis ', 'Regisrergis ', '', 'segu17054nota');
INSERT INTO `guerreros` VALUES ('262', 'Jorge Takami', 'Jorge ', '1999-03-05', '22', 'M', 'X', 'Cdmx', '5563190576', 'jorge.takamigue@gmail.com', 'N/a', 'Mi novia me trajo ', '5591972095', '', '2021-06-30 16:36:45', 'Dulce guerrero ', 'Jorge Guerrero ', 'jorge_grs', '', 'zxcv1830musik');
INSERT INTO `guerreros` VALUES ('264', 'Zabdi Asaph Flores Cobos ', 'Asaph ', '0000-00-00', '16', 'M', 'M', 'Estado de México ', '5565102061', 'asaph1801@gmail.com', 'Polvo ', 'Porque quiero retomar mi relación con Dios ', '55 6208 2765', 'Casa de adoración ', '2021-06-30 22:28:45', 'Marco A. Flores López ', 'Asaph Flores ', 'asaphflores', '', 'musik2939mexico');
INSERT INTO `guerreros` VALUES ('278', 'Marian', 'Sánchez Tenorio', '1999-11-06', '21', 'F', 'M', 'Estado de México ', '5535256212', 'mariansanchezt@gmail.com', 'Sulfas medicamento ', 'Adoro reto ??', '5537347908', 'Comunidad FARO', '2021-07-11 17:44:19', 'Martha Sanchez', 'Marian ST', 'Marian_sanchezt', '', 'auto1649frase');
INSERT INTO `guerreros` VALUES ('279', 'Gamaliel', 'Jiménez Talonia', '1999-03-04', '22', 'M', 'X', 'CDMX', '5573601833', 'gamatalonia99@gmail.com', 'Nada', 'Me gusta ser retado ', '5573388179', 'Comunidad FARO', '2021-07-11 17:55:43', 'Carlos Jiménez ', 'Gamaliel Jiménez Talonia', 'gama_talonia', '', 'retoU4281volta');
INSERT INTO `guerreros` VALUES ('297', 'Jonathan García  Gómez', 'John', '2001-05-04', '20', 'M', 'M', 'Estado de México', '5513171956 ', 'johngg345@gmail.com', 'Rinitis Alérgica', 'Continuar con el seguimiento de Reto', '5544524294', 'Nueva Vida Parques', '2021-10-11 11:02:05', 'Carmen Ignacia Gómez Juárez', 'Jonathan García', 'jonthn.grc', '', 'volta2334qwer');
INSERT INTO `guerreros` VALUES ('298', 'Valeria Ramírez Arias', null, '2022-07-06', '1', 'F', 'S', 'asd', '11111', 'valeramirezarias@gmail.com', 'a', 's', '11111', 'a', '2022-07-06 13:05:07', 'a', 'a', 'a', '', 'nota5155retoU');
INSERT INTO `guerreros` VALUES ('299', 'Natalia Ramírez Arias', 'Natalia', '2022-07-06', '1', 'F', 'S', 'asd', '11111', 'nramireza2004@gmail.com', 'a', 's', '11111', 'a', '2022-07-06 13:05:10', 'a', 'a', 'a', '', 'saxofon1478pachuca');
INSERT INTO `guerreros` VALUES ('300', 'Surisadai García Sánchez', 'Surisadai', '2022-07-06', '1', 'F', 'S', 'asd', '11111', 'surisadai0992@gmail.com', 'a', 's', '11111', 'a', '2022-07-06 13:05:13', 'a', 'a', 'a', '', 'retoU2356zxcv');
INSERT INTO `guerreros` VALUES ('301', 'Natán Morales', 'Neitan', '1987-10-29', '34', 'M', 'XL', 'CDMX', '5624242759', 'neitan.morales@gmail.com', 'No', 'El rich me obliga', '111111111', 'FARO', '2022-06-28 11:30:22', 'Sheila', 'Neitan Worales', 'Neitan_Worales', '', 'natancito1');
INSERT INTO `guerreros` VALUES ('1001', 'Aron García Escalona', 'Arón', '2007-06-03', '15', 'M', 'M', 'Ecatepec', '5612743800', 'aron.escalona0306@gmail.com', 'No', 'Por qué quiero aumentar mi comunión con Dios', '5519616364', 'Capitolio', '2022-05-03 23:51:04', 'Vanessa Sarath Escalona Carballo', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1002', 'Elizabeth García Escalona', 'Eli', '2005-08-03', '17', 'F', 'M', 'Ecatepec', '55348866548', 'mirandamiamor743@gmail.com', 'No', 'Cercania con Dios y servicio', '5519616364', 'Capitolio', '2022-05-03 23:53:37', 'Vanessa Sarath Escalona Carballo', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1003', 'Abner Omar Tellez Ponce', 'Abner', '2005-05-28', '17', 'M', 'XXL', 'Pachuca', '7711302475', 'neitor.p27@gmail.com', null, 'Por que me gusto mucho la experiencia del año pasado y quiero tener encuentro con Dios.', '7713597832', 'Cielos Abiertos', '2022-05-04 17:25:50', 'Juan Omar Tellez Perez', 'Abner Ponce', null, '', null);
INSERT INTO `guerreros` VALUES ('1004', 'Dara Belen Tellez Ponce', 'Dara', '2004-02-28', '17', 'F', 'X', 'Pachuca', '7717487331', 'daraponce.009@gmail.com', 'A los embutidos', 'Para acercarme más a Dios', '7713597832', 'Cielos Abiertos', '2022-05-04 17:31:17', 'Juan Omar Tellez Ponce', 'Dara Ponce', 'Dara Ponce', '', null);
INSERT INTO `guerreros` VALUES ('1005', 'Tenoch Arriaga Delgadillo ', 'Tenoch ', '2005-06-28', '17', 'M', 'M', 'Cancún ', '9981085682', 'yeshuaimcancun@gmail.com', 'No', 'Para conocer más de Dios ', '9981085682', null, '2022-05-15 20:53:55', 'Susana Arriaga ', 'Cudi', null, '', null);
INSERT INTO `guerreros` VALUES ('1006', 'Layla Romina Garcia Arriaga ', 'Romina ', '2002-08-30', '20', 'F', 'M', 'Del estado de México ', '9985257512', 'romina30.lrga@gmail.com', 'Si a la penicilina ', 'Por que  mi mamá me dijo y por que tengo depresión ', '9984951146', 'No voy a ninguna iglesia ', '2022-05-18 20:02:22', 'Ana Rebeca Arriaga Delgadillo ', 'Romii Garcia ', 'romi_sg_', '', null);
INSERT INTO `guerreros` VALUES ('1007', 'José Luis Cabrera Barrientos', 'Barrientos', '2000-07-31', '22', 'M', 'M', 'De Pachuca', '7713182813', 'cabrerabarrientosjoseluis3@gmail.com', 'Ninguna ', 'Quiero ser de la generación que se levanta como Juan el Bautista ', '7752288001', 'Nuevo Amanecer', '2022-05-24 11:06:23', 'Mama', 'José Luis Barrientos', 'Jlbarricab31', '', null);
INSERT INTO `guerreros` VALUES ('1008', 'Rebeca Castro Zamudio ', 'Becca', '2003-09-11', '19', 'F', 'M', 'Puebla ', '2212139818', 'rebecacastrozamudio@gmail.com', 'Plátano y orégano ', 'Staff', '2211656062', 'Vida Cristiana ', '2022-06-01 23:34:21', 'Jamin Zamudio Coronado ', 'Rebeca Castro ', 'becca_czam', '', null);
INSERT INTO `guerreros` VALUES ('1009', 'Estela Aholibama Rodríguez Rod', 'Aholi Rodríguez ', '1990-10-14', '32', 'F', 'XL', 'Durango ', '6182089981', 'arodriguez@jucumanalco.com', 'Al sol , a la papaya.', 'Staff ', '6181894028', 'Iglesia de Dios de la Profecía ', '2022-06-03 20:06:22', 'Mercedes Bustamante', 'Aholi Rodríguez ', null, '', null);
INSERT INTO `guerreros` VALUES ('1010', 'Karla Nohemi reyes Solis ', 'Karla', '2000-05-03', '22', 'F', 'M', 'Pachuca ', '7715251135', 'solisreyes114@gmail.com', 'No', 'Invitación ', '7715251135', 'PIB', '2022-06-06 09:55:34', 'Karla', 'Reyes Karla ', 'Reyes_karls', '', 'karlaReyes123');
INSERT INTO `guerreros` VALUES ('1011', 'Aradia Escalona Luengas', 'Anel Aradia Escalona Luengas ', '2002-01-02', '19', 'F', 'X', 'Pachuca', '5584840593', 'aradiaescalonaluengas1B1@gmail.com', 'no', 'Soy Staff ', '5532301276', 'Capitolio', '2022-06-06 10:08:10', 'Elsa Luengas Benitez', 'A Anel Escalona ', '_anelfungus', '', 'cAzul2022');
INSERT INTO `guerreros` VALUES ('1012', 'Karen Gómez ', 'Karen ', '1996-01-06', '25', 'F', 'M', 'Pachuca', '7714044654', 'klogm96@gmail.com', 'No', 'Servir ', '7714044654', 'PIB Pachuca', '2022-06-06 10:22:57', 'Lorena Grande', 'Karen L Gómez ', 'klogm', '', 'ruben1324');
INSERT INTO `guerreros` VALUES ('1013', 'Yosef yael Castañón cruz ', 'Yosef cas ', '2003-01-05', '18', 'M', 'X', 'Tamazunchale SLP', '4831120506', 'yosefyaelcascru@gmail.com', 'Penicilina ', 'Staf', '483100109', 'Hogar Cristino Abba ', '2022-06-06 21:42:21', 'Gabriel Castañón cruz ', 'Yosef cas ', 'Yosef cas ', '', null);
INSERT INTO `guerreros` VALUES ('1014', 'Jose Antonio Rubio Gonzalez', 'Jose ', '2002-05-17', '20', 'M', 'M', 'Tizayuca Hidalgo', '5533925646', 'jr717531@gmail.com', null, 'Por qué es el mejor campamento del mundo ???????????', '5584046396', 'MOSAIC CDMX', '2022-06-07 11:07:27', 'Claudia Gonzalez Moreno', 'Jose RG', 'josssrg_', '', null);
INSERT INTO `guerreros` VALUES ('1015', 'Diana mota fernandez ', 'Diana ', '2002-08-03', '20', 'F', 'M', 'Pachuca ', '7713337434', 'dianamota0320@gmail.com', null, 'Staff', '7713014449', 'SAMA ', '2022-06-07 13:56:05', 'Viridiana Fernandez ', 'Diana Mota ', 'diana_mota_fernandez', '', null);
INSERT INTO `guerreros` VALUES ('1016', 'RUBÉN CALDERÓN  ANDRADE ', 'RUBÉN C.', '1993-06-11', '29', 'M', 'S', 'Pachuca ', '7713723583', 'calderonruben432@gmail.com', 'No', 'Staff ', '7714044654', 'PIB', '2022-06-07 19:16:53', 'KAREN LORENA ', 'Rubén Calderón ', 'rcalderon_93', '', 'karen1324');
INSERT INTO `guerreros` VALUES ('1017', 'Linette Roldán Martínez ', 'Linette', '1997-03-22', '24', 'F', 'M', 'Estado de México ', '5535924475', 'linette.yazmin@gmail.com', 'Sulfas y gatos', '(:', '5529676404', 'CRA Espíritu Santo ', '2022-06-07 19:39:47', 'Raúl Roldán ', 'Linette Roldán ', '@liyrm', '', null);
INSERT INTO `guerreros` VALUES ('1018', 'sara aceves ', 'sara ', '2006-08-16', '16', 'F', 'XS', 'cdmx', '5525040875', 'sara.aceves16@gmail.com', 'no', 'aprender más ', '5518001291', 'cra espíritu santo', '2022-06-07 20:52:54', 'eduardo aceves ', 'sara aceves ', 'saraacevesss', '', null);
INSERT INTO `guerreros` VALUES ('1019', 'Daniel Aldair Moreno Arriaga', 'Daniel', '2008-01-12', '13', 'M', 'X', 'Ciudad de México', '5548244577', 'anahara890103@gmail.com', 'No', 'Porque quiero que conozca y encuentro el camino de Dios', '5548244577', null, '2022-06-07 21:50:43', 'Anahara Arriaga delgadillo', 'Recomendación', null, '', null);
INSERT INTO `guerreros` VALUES ('1020', 'Lizbeth Espinoza', 'Lizbeth', '1987-09-30', '35', 'F', 'M', 'Los Angeles', '+13234043668', 'lizbethe09@yahoo.com', 'No', 'Key Speaker / Fashion Production ', '+13234043668', null, '2022-06-07 22:50:29', 'Consuelo Maldonado ', null, '@lizbethspnoza', '', null);
INSERT INTO `guerreros` VALUES ('1021', 'Daniel Aldair Moreno Arriaga', 'Daniel ', '2008-01-12', '13', 'M', 'X', 'Del estado de México ', '5548244577', 'quetzalli16.qrga@gmail.com', 'No ninguna ', 'Para conocer la palabra de dios. ', '5548244577', 'No voy a ninguna ', '2022-06-08 18:27:19', 'Anahara Arriaga delgadillo', 'Ananahara delgadillo', null, '', null);
INSERT INTO `guerreros` VALUES ('1022', 'Elena Gabriela Bustos Hernánde', 'Elenita', '2004-10-22', '18', 'F', 'X', 'Pachuca Hidalgo', '5529498802', 'brillantetita@gmail.com', 'Ninguna ', 'Por qué soy bien chida como Staff', '5529498802', null, '2022-06-09 12:33:10', 'Taurino Bustos Ramírez ', 'Elenita Gabriela ', 'elena_gabrielahdz', '', null);
INSERT INTO `guerreros` VALUES ('1023', 'Citlali Pérez Martínez ', 'Citlali ', '1980-05-13', '42', 'F', 'M', 'Pachuca', '7717221473', 'citlalijucum@gmail.com', 'No', 'Soy Líder ????', '7712088634', 'Cornerstone ', '2022-06-09 16:09:31', 'Rich’s ', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1024', 'Libni Sinai Garcia Sanchez ', 'Libni', '2002-11-20', '20', 'F', 'M', 'Puebla ', '2223639055', 'libni9022@gmail.com', 'No', 'Soy Staff ', '2221142121', 'Vida Cristiana ', '2022-06-09 21:38:02', 'Jeanett Sánchez Hernández ', 'Sinai garci', 'Libni_sinai_gs', '', null);
INSERT INTO `guerreros` VALUES ('1025', 'Andrea Spohn Bustamante', 'Andrea Spohn', '2007-11-27', '15', 'F', 'XS', 'Durango Dgo', '6172245125', 'andreaspobus2711@gmail.com', 'Ninguna', 'Para conocer más acerca de Dios', '6181343936', 'Bethel sur', '2022-06-10 21:21:41', 'Andreas spohn', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1026', 'Jonathan Josué García Gómez ', 'John', '2001-05-04', '21', 'M', 'M', 'Estado de México ', '5513171956', 'jonthn.grc89@icloud.com', 'No', 'Porque anhelo tener intimidad con Dios y conocerle más ', '5544524294', 'Vida Nueva Parques', '2022-06-11 11:57:55', 'Carmen Gomez ', 'Jonathan García', 'jonthn.gr', '', null);
INSERT INTO `guerreros` VALUES ('1027', 'Stephany Tolentino', 'Stephany Tolentino', '1992-12-17', '30', 'F', 'X', 'Durango ', '+52 618 283 ', 'stolentino@jucumanalco.org', 'No', 'Staff ', '5512563962', 'Bethel', '2022-06-14 17:21:07', 'Reyna Torres ', 'Stephany Tolentino', 'Stephany_Tolentin', '', null);
INSERT INTO `guerreros` VALUES ('1028', 'Sara Fuentes Navarrete', 'Sara', '2005-07-15', '17', 'F', 'M', 'CDMX', '5573814742', 'safuna05@gmail.com', 'No', 'Conocer más a Dios y conocer gente nueva', '5513439100', 'Ammi', '2022-06-15 09:45:12', 'Magdiel Navarrete Manzanares', 'No tengo', 'No tengo', '', null);
INSERT INTO `guerreros` VALUES ('1029', 'Zabdi Asaph Flores Cobos ', 'Asaph ', '2005-01-18', '16', 'M', 'M', 'Estado de México ', '5565102061', 'zabdiasaph@gmail.com', 'A los gatos', 'Para aprender más a servir y crecer tanto física tanto espiritual (Staff)', '5562082765', 'Casa de adoración', '2022-06-15 20:28:28', 'Marco A. Flores López ', 'Asaph Flores ', 'asaphflores', '', null);
INSERT INTO `guerreros` VALUES ('1030', 'Lluvia De Abril Nava Sámano ', 'Lluvi ', '2006-02-09', '15', 'F', 'M', 'Cancún, Quintana Roo.', '9988429924', 'lluviadeabrilnava@gmail.com', null, 'Me encanto cuando fui, pude tener una mejor relación con Dios. Quiero volver a tener esa experiencia, sentir a Dios tan cerca.', '9981313510', null, '2022-06-19 20:17:28', 'Deyanira Sámano ', null, 'abril_samano', '', null);
INSERT INTO `guerreros` VALUES ('1031', 'Jony Buendía Pitalua ', 'Buendía ', '1988-11-08', '34', 'M', 'S', 'Pachuca', '7712196807', 'jbpitalua@gmail.com', 'Ninguna ', 'Porque no tengo otra opción jajaja ', 'No tiene ', 'PIB', '2022-06-21 08:59:36', 'Ricardo ', 'Jony Buendía ', 'jbuendiap', '', null);
INSERT INTO `guerreros` VALUES ('1032', 'Test', 'Test', '2002-06-09', '20', 'M', 'S', 'CDMX', '5624242759', 'test@neitan.com', null, 'test razones', '213123123', null, '2022-06-22 11:17:49', 'Test', 'Neitan Worlaes', 'Neitan Worales', '', null);
INSERT INTO `guerreros` VALUES ('1033', 'davidnahumromeroflores', 'Nahum', '2002-05-15', '20', 'M', 'M', 'Pachuca', '7711684886', 'dr707379@gmail.com', 'Alós gatos ', 'Por qué me gusta ', '7711303217', 'Bip', '2022-06-22 22:00:10', 'Rocío flores ', 'David romero', null, '', null);
INSERT INTO `guerreros` VALUES ('1034', 'Yareli campero Hernández ', 'Yare campero ', '2004-12-25', '18', 'F', 'M', 'Pachuca Hidalgo ', '7712672009', 'yarecampero74@gmail.com', null, 'Me yamo la atención y PZ ya quería ir desde el año pasado ', '7714167435', null, '2022-06-23 12:25:04', 'Ricardo ', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1035', 'Briana Lisset Hernandez Perrez', 'Bri', '2008-07-30', '14', 'F', 'X', 'Pachuca', '55 74071762', 'hernandezperezbrianna@gmail.com', 'No', 'Para aprender de Dios y ser más servicial', '7712088634', 'Cornerstone pachuca', '2022-06-24 14:16:43', 'Ricardo Hernandez', 'No tengo :(', 'lissibri_oficialmusic', '', null);
INSERT INTO `guerreros` VALUES ('1036', 'Jorge Armando Takami Guerrero', 'Jorge', '1999-04-23', '22', 'M', 'X', 'CDMX', '5563190576', 'jorga_takami@outlook.com', 'No', 'Explorar', '5591972095', null, '2022-06-24 15:30:25', 'Dulce María guerrero zepeda', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1037', 'Obed Granados Solis', 'Obed ', '2005-05-15', '17', 'M', 'M', 'Calnali', '771112929', 'gaseergs@gmail.com', 'Ninguna ', 'Servir a Dios ', '7711889869', 'Iglesia Nuevo Amanacer ', '2022-06-26 10:16:20', 'Ricardo Granados Solis ', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1038', 'Alfredo Camargo Montiel ', 'Fredy', '2000-05-25', '22', 'M', 'X', 'Tecámac estado de México ', '5611809191', 'alfredo_montiel10@outlook.com', 'No', 'En 2018 tuve la experiencia de ir a reto urbano y me cambió la vida, y me he alejado de Dios un poco y quisiera volver a encontrarme con el a través de ustedes ', '5626903010', null, '2022-06-27 17:41:16', 'María Guadalupe Montiel Martinez', 'Alfredo Camargo ', 'fredybarber_mx', '', null);
INSERT INTO `guerreros` VALUES ('1039', 'Daniela Danae Wong López ', 'Dana Wong ', '1998-03-09', '23', 'F', 'X', 'Estado de México ', '3329666043', 'dani_wong98@hotmail.com', 'Guayaba ', 'A servir a mis generaciones y a Dios ????', '5514247543', 'Centro Cristiano Ciudad de México ', '2022-06-28 09:31:49', 'Alejandra López López ', 'Dana Wongl', '@danawong_l ', '', null);
INSERT INTO `guerreros` VALUES ('1040', 'Sheila Bonilla Ruiz ', 'Sheila ', '1993-09-19', '29', 'F', 'XL', 'CDMX ', '5518359606', 'borush.sb@gmail.com', 'Polvo', 'Para apoyar', '5624242759', 'FARO', '2022-06-28 10:08:03', 'Pedro Natan Morales Hernández ', 'Sheila Borush ', 'Sheila Borush ', '', null);
INSERT INTO `guerreros` VALUES ('1041', 'Carlos Yereth Bello Hernández ', 'Yereth ', '2004-07-20', '18', 'M', 'M', 'Pachuca de Soto Hidalgo ', '7712177459 ', 'yerethsandragneel@gmail.com', 'No', 'Conocer aún más de Dios ', '7711501548', 'Cornerstone Tierra Fértil Tulancingo ', '2022-06-28 10:11:05', 'Juana Gisela Hernández Reyes ', 'Yereth Bello ', 'yereth_710', '', null);
INSERT INTO `guerreros` VALUES ('1042', 'Yelen bello hernandez ', 'Yelen bello ', '2004-07-20', '18', 'F', 'XS', 'Pachuca ', '7711724682', 'yelenbellohernadez@gmail.com', 'Ninguno ', 'Para aprender cosas nuevas ', '7711501548', 'Corneston Tulancingo ', '2022-06-28 10:12:55', 'Gisela hernandez reyes ', 'Myelenbello', '@yelenbello', '', null);
INSERT INTO `guerreros` VALUES ('1043', 'David Muñoz Palacios ', 'David', '2004-07-20', '18', 'F', 'S', 'Pachuca Hidalgo ', '775 105 0097', 'shirokiryuu3@gmail.com', 'No', 'Recibir de Dios ', '7751457841 ', 'Cornerstone Tierra Fértil Tulancingo ', '2022-06-28 12:33:50', 'Sandra Palacios ', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1044', 'Nahomi Janeth Rodriguez  Bacio', 'Nahomi', '2008-07-06', '14', 'F', 'M', 'Durango mexico', '6182242493', 'SANTURRONN@HOTMAIL.COM', 'No', 'Porque quiero viajar a algún lado', '6182037512', 'Iglesia Calvario Durango ', '2022-06-28 20:16:00', 'Noel Rodriguez Rodriguez ', null, 'nahomi_rguez', '', null);
INSERT INTO `guerreros` VALUES ('1045', 'Jaasiel David Wong López ', 'JD Wong ', '2002-11-12', '20', 'M', 'X', 'Estado de México ', '5541293813 ', 'davidwongjd29@gmail.com', 'No', 'Para pasar un buen rato aprendiendo mas de la palabra y divirtiendome con jóvenes de mi mismo sentir ', '5514247543', 'Centro cristiano CDMX Misiones transmundiales ', '2022-06-29 00:22:27', 'Alejandra Wong ', 'JD Wong ', 'Jdwong_music', '', null);
INSERT INTO `guerreros` VALUES ('1046', 'Moisés Hernández Flores', 'Moisés', '2000-08-05', '22', 'M', 'M', 'Tamazunchale, S.L.P', '4831035558', 'moises.hf05@gmail.com', null, 'staff', '4831271267', 'Hogar Cristiano ABBA', '2022-06-29 00:47:38', 'Esmirna Hernández Flores', 'Moises Hernandez Flores', null, '', null);
INSERT INTO `guerreros` VALUES ('1047', 'Uriel Vela Soto', 'Uriel', '1998-03-02', '23', 'M', 'S', 'Estado de México', '5533556426', 'velhost22@gmail.com', 'No', 'Obediencia Radical 1.0 fue memorable para mi', '55 7072 7572', null, '2022-06-29 07:15:04', 'Álvaro Vela Bello', 'Uriel Vela', 'grickle202', '', null);
INSERT INTO `guerreros` VALUES ('1048', 'Ruben Calderón', 'Rubén', '1993-06-11', '29', 'M', 'S', 'Pachuca', '7713723583', 'pachus_93@hotmail.es', 'No', 'Staff', '7714044654', 'PIB ', '2022-06-29 10:05:44', 'Karen Gómez', 'Ruben Calderon', 'rcalderon', '', null);
INSERT INTO `guerreros` VALUES ('1049', 'Benjamin Syverson ', 'El Guapi ', '2004-04-21', '17', 'M', 'X', 'Pachuca Hidalgo ', '771 726 4443', 'benjasy2004@gmail.com', 'Lácteos ', 'Quiero conocer mas a Dios ', '771 113 9495', 'La Viña ', '2022-06-29 10:28:36', 'Vicki Syverson ', null, 'Benjas Su', '', null);
INSERT INTO `guerreros` VALUES ('1050', 'Dámaris Ortiz Rodríguez', 'Damaris', '1989-10-18', '33', 'F', 'S', 'Tijuana ', '13234043668', 'lizbethespinoza.co@gmail.com', 'No', 'Parte De She Glams Her Heart', '13234043668', null, '2022-06-29 12:24:34', 'Manuel ', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1051', 'Addie Alderson', 'Addie', '1998-02-25', '23', 'F', 'S', 'Texas', '13234043668', 'sheglamsherheart@gmail.com', 'No', 'Parte de she glams her heart', '13234043668', null, '2022-06-29 12:27:26', 'Liz', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1052', 'Saúl Josadac Jiménez Sánchez ', 'Josadac ', '2002-06-18', '20', 'M', 'M', 'Atizapán de Zaragoza ', '5634351897', 'ojosadac1@gmail.com', 'No', 'Porque a cambiado mi vida ', '5512861780', 'Centro Cristiano Calacoaya ', '2022-06-29 12:49:46', 'Bertha Sanchez Mayen', 'Josadac Jiménez ', 'Josadac Jiménez ', '', null);
INSERT INTO `guerreros` VALUES ('1053', 'Javier Antonio Medrano Yañez ', 'Javi Medrano ', '2003-11-05', '19', 'M', 'S', 'CDMX ', '5550436614', 'antoniomedrano051103@gmail.com', 'Camarón fresco', 'Para conocerme y encontrar la paz.', '5510269690', 'Iglesia Universal ', '2022-06-29 22:29:49', 'Reyna Patricia Yañez López ', 'Javi Medrano ', 'Javier Medrano Official', '', null);
INSERT INTO `guerreros` VALUES ('1054', 'Alfredo del Ángel Castillo Juá', 'Ángel', '2000-08-26', '22', 'M', 'XL', 'Tlanchinol, Hgo ', '7712976962', 'kingchampion100@gmail.com', 'No', 'Quiero una relación más profunda con Dios ', '7711608740', 'Torre Fuerte ', '2022-06-30 09:40:03', 'Alfredo Antonio Castillo Martínez ', 'Angel Castillo ', null, '', null);
INSERT INTO `guerreros` VALUES ('1055', 'Samanta García Navarrete', 'Sam', '2006-02-12', '15', 'F', 'S', 'CDMX', '5587686706', 'sg3274821@gmail.com', 'No', 'Porque quiero conocer mas personas, tambien porque quiero saber de que forma DIOS me puede hablar para servirle.', '5587350550', 'Iglesia Ammi', '2022-06-30 11:26:04', 'Belén Navarrete Manzanares', 'No tengo', 'No tengo', '', null);
INSERT INTO `guerreros` VALUES ('1056', 'Belana Mireya Itzá Rodríguez', 'Bela', '2004-01-24', '17', 'F', 'M', 'Pachuca', '7714145889', 'itzabelana426787@gmail.com', null, 'Me gustaria tener mayor convivencia con mis herman@s cristianos, poder divertirme de manera sana y fortalecerme espiritualmente.', '7717478091', 'Primera Iglesia Bautista', '2022-06-30 14:37:46', 'Erika Elizabeth Rodríguez Torres', 'Bela Rodríguez', 'itzabelana', '', null);
INSERT INTO `guerreros` VALUES ('1057', 'Axel González Angeles ', 'Axel', '2007-07-14', '15', 'M', 'M', 'Tlanchinol Hidalgo ', '771 1926292', 'gatitoperrito2014@gmail.com', 'Intolerante a la lactosa ', 'Porque nos invitaron ', '7712180860', 'Torre Fuerte ', '2022-06-30 19:22:15', 'Sonia Angeles Granados ', 'Axel Angas', 'a_k0714', '', null);
INSERT INTO `guerreros` VALUES ('1058', 'Micah Kemp', 'Micah', '2004-03-16', '17', 'M', 'S', 'Ensenada', '16192073230', 'tym.kemp@ywamsdb.org', 'No', 'Para conocer más de Dios y servir a los demás', '16192073230', 'YWAM Ensenada', '2022-06-30 22:04:50', 'Tym Kemp', null, '@kemp.micah', '', null);
INSERT INTO `guerreros` VALUES ('1059', 'Noah Kemp', 'Noah', '2004-07-23', '18', 'M', 'M', 'Ensenada', '+52646227636', 'tym@thekemps.me.uk', 'No Pero Soy vegetariana', 'servir', '16192073230', null, '2022-06-30 22:09:43', 'Tym Kemp', 'facebook.com/noahmkemp', '@noahmkemp', '', null);
INSERT INTO `guerreros` VALUES ('1060', 'Rafael Mavil Peña', 'Rafa', '2002-09-19', '20', 'F', 'X', 'cdmx ', '55 3419 7104', 'Rafaelmavilpena@gmail.com', 'no', 'me invitaron ', '5539639002', null, '2022-06-30 23:19:54', 'Liliana Irene Peña Rosales ', 'Rafa Peña ', null, '', null);
INSERT INTO `guerreros` VALUES ('1061', 'Raymundo Santiago', 'Ray', '2003-10-27', '19', 'M', 'M', 'Ciudad de México', '5530088348', 'santiago271003@gmail.com', 'Sulfas', 'Invitación de una persona y mayor preparación ', '5555068383', 'Centro Cristiano Ciudad de México ', '2022-06-30 23:40:29', 'Raymundo Gómez ', 'Santiago Gomez Díaz ', 'santig_ray', '', null);
INSERT INTO `guerreros` VALUES ('1062', 'Sarahi Gonzalez Cruz ', 'Sarahi', '2001-01-15', '20', 'F', 'S', 'Durango, Dgo. México ', '6182401951 ', 'sarahigonzalez89922@gmail.com', 'No', 'Para servir ', '6181248302', 'Casa de vida y paz ', '2022-07-01 09:45:35', 'Alonso Gonzalez ', 'Sarahi Gonzalez ', 'sarahi_g_c', '', null);
INSERT INTO `guerreros` VALUES ('1063', 'Magdiel Navarrete Manzanares', 'Mag', '1984-08-08', '38', 'F', 'M', 'CDMX', '5513439100', 'magdielsl@hotmail.com', 'No', 'Apoyar en lo que pueda y aprender', '5584248136', 'Iglesia Ammi', '2022-07-01 12:59:48', 'Jose Luis Navarrete Vivas', 'Magdiel Navarrete Manzanares', 'Magdiel Navarrete Manzanares', '', null);
INSERT INTO `guerreros` VALUES ('1064', 'Cynthia Elvira Gómez Díaz ', 'Cynthia ', '2002-12-15', '20', 'F', 'M', 'Pachuca ', '7714434704', 'dalmtastich98@outlook.com', 'No ', 'Nueva experiencia ', '7712149188 ', 'La villita ', '2022-07-01 15:06:16', 'Delia Lizbeth Gómez Díaz ', 'Cynthia Gómez Díaz ', null, '', null);
INSERT INTO `guerreros` VALUES ('1065', 'Isi Benoni Romero Templos', 'Isi', '1991-03-30', '30', 'F', 'XS', 'Pachuca', '7713571372', 'isiromero_templos@hotmail.com', 'No', 'Me gusta servir ', '7713546907', 'PIB ', '2022-07-01 15:38:16', 'Martha Templos', 'IsiRomero1 ', null, '', null);
INSERT INTO `guerreros` VALUES ('1066', 'Israel Gómez Castelazo', 'Israel', '2005-01-30', '16', 'M', 'M', 'Chiapas', '9613368339', 'IsraelGC.30@hotmail.com', 'No', 'Porque es un lugar que ya ha bendecido mi vida anteriormente y quiero volver a ser parte de este campamento', '9617091125', 'Tempro Auditorio Solo Cristo Salva', '2022-07-01 16:17:16', 'Deborah', 'Israel Gomez Castelazo', 'Isragc10', '', null);
INSERT INTO `guerreros` VALUES ('1067', 'Karla Camila Gómez Diaz ', 'Camila Gómez ', '2005-10-27', '17', 'F', 'S', 'CDMX', '5525609538', 'camilagd193@gmail.com', 'No', 'Me invitaron ', '5525609538', 'Centro Cristiano Ciudad de México ', '2022-07-01 19:51:46', 'Dora Luz Díaz Hernandez ', 'Camila GD', '_camila.gd_', '', null);
INSERT INTO `guerreros` VALUES ('1068', 'María Fernanda Vera Miranda ', 'Fernanda Vera', '2002-12-10', '20', 'F', 'M', 'Los héroes tecamac ', '5549298564', 'fervera1012@gmail.com', null, 'Para conocer más sobre el reto', '5514699717', null, '2022-07-01 22:58:54', 'Lorena Miranda Casco', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1069', 'Ernesto Díaz de Castro Granado', 'Neto ', '1984-03-17', '37', 'M', 'M', 'Puebla', '222766372', 'diazdern@gmail.com', 'No', 'Participar y apoyar en el campamento ', '221 436 1518', 'Trono de gracia ', '2022-07-03 09:25:57', 'Leopoldo Díaz de Castro ', 'Neto dideka', 'Neto dideka ', '', null);
INSERT INTO `guerreros` VALUES ('1070', 'Emmanuel', 'EMMANUEL LEON', '2002-03-18', '19', 'M', 'M', 'Ecatepec ', '5525780883', 'santinibele@gmail.com', 'no', 'por qué vengo saliendo de una rehabilitación ', '5525780883', 'Emmanuel leon', '2022-07-03 13:24:54', 'belen santin morteo', 'Emmanuel leon', null, '', 'frase2951pachuca');
INSERT INTO `guerreros` VALUES ('1071', 'Andrea Estrada Garrido', 'Andy', '2005-05-12', '16', 'F', 'M', 'Estado de mexico', '5531403659', 'garridoandrea34@gmail.com', 'No', 'Es mi segunda vez que acudo, y la verdad fue muy buena la experiencia', '5520307910', 'Manada Pequeña', '2022-07-03 15:51:31', 'Michel Garrido Estrada', 'Andrea Estrada', 'garrido_a', '', null);
INSERT INTO `guerreros` VALUES ('1072', 'María Fernanda Iniesta Vázquez', 'Mafer Iniesta ', '2003-04-10', '18', 'F', 'X', 'Ciudad de México ', '5525757176', 'marifer.iniesta@gmail.com', 'Nada ', 'Fui invitada ', '5611123244', 'Centro Cristiano Ciudad de México ', '2022-07-03 16:25:49', 'Ruth Vázquez Torres ', 'Mafer Iniesta ', 'Mafer.in', '', null);
INSERT INTO `guerreros` VALUES ('1073', 'Jose Antonio Rubio Gonzalez', 'J o s e', '2002-05-17', '19', 'M', 'X', 'Tizayuca Hidalgo', '5533925646', 'jr717531@gmail.com', 'Al pelo de los animales ', 'Por que es el campamento más top ????????????', '5584046396', 'MOSAIC', '2022-07-03 18:15:10', 'Claudia Gonzale', 'Jose RG', 'josss_rg', '', null);
INSERT INTO `guerreros` VALUES ('1074', 'Roberto Reyes', 'Roberto', '2008-06-07', '14', 'M', 'S', 'Puebla', '4441057175', 'eus.lvmx@gmail.com', 'no', 'invitación', '4441057175', 'no', '2022-07-04 22:03:41', 'Margot Meneses Ulin', 'no ', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1075', 'Belen Claudio', 'Belen', '2007-05-03', '14', 'F', 'X', 'Puebla', '4441057175', 'margottita5@gmail.com', 'no', 'invitacion', '4441057175', 'no', '2022-07-04 22:06:57', 'margot meneses ulin', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1076', 'Martha Quiroz', 'martha', '2006-06-29', '16', 'F', 'S', 'Puebla', '4441057175', 'margottita5@hotmail.com', 'no', 'invitacion', '4441057175', 'NO', '2022-07-04 22:11:00', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1077', 'Yolanda Quiroz', 'Yolanda', '2006-06-29', '16', 'F', 'S', 'puebla', '4441057175', 'santosliraricardo@gmail.com', 'no', 'invitacion', '4441057175', 'NO', '2022-07-04 22:13:21', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1078', 'Joel Morales', 'Joel', '2007-04-29', '14', 'M', 'S', 'PUEBLA', '4441057175', 'peliculasrichard@gmail.com', 'NO', 'INVITADO', '4441057175', 'NO', '2022-07-04 22:16:18', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1079', 'BLANCA SANTIAGO', 'BLANCA', '2005-10-16', '17', 'F', 'S', 'PUEBLA', '4441057175', 'sistemas_microtec@hotmail.com', 'NO', 'INVITADO', '4441057175', 'NO', '2022-07-04 22:18:25', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1080', 'NOHEMI HERNANDEZ', 'NOHEMI', '2005-05-04', '16', 'F', 'M', 'PUEBLA', '4441057175', 'richardtablet92@gmail.com', 'NO', 'INVITADO', '4441057175', 'NO', '2022-07-04 22:20:53', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1081', 'MACRINA MORALES', 'MARISOL', '2004-05-24', '17', 'F', 'S', 'PUEBLA', '4441057175', '2032047@upt.edu.mx', 'SI NO PUEDO EXPONERME AL SOL PROBLEMA DE PIEL', 'INVITADO', '4441057175', 'NO', '2022-07-04 22:23:43', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1082', 'MATILDE MORALES', 'MATILDE', '2004-05-24', '17', 'F', 'M', 'PUEBLA', '4441057175', 'programas.mfh@gmail.com', 'NO', 'INVITADO', '4441057175', null, '2022-07-04 22:26:40', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1083', 'Braulio Vazquez', 'Braulio', '2000-03-27', '21', 'M', 'M', 'puebla', '4441057175', 'brauliovg27@gmail.com', 'no', 'invitado', '4441057175', 'NO', '2022-07-04 22:36:17', 'MARGOT MENESES ULIN', 'no', 'no', '', null);
INSERT INTO `guerreros` VALUES ('1084', 'Joanna Lara Melchor ', 'Lara', '2003-10-21', '19', 'F', 'M', 'CDMX ', '5569030340', 'joannalaramelchor9@gmail.com', 'Ninguna ', 'Pertenecía a un grupo que se llama Movimiento de Juventudes Cristianas, quiero volver a  encontrarme como persona, quiero acercarme de nuevo a Dios y seguirle sirviendo. ', '(1) 771 189 ', 'Parroquia de San Agustín de las Cuevas', '2022-07-04 23:08:52', 'Doris Chino Lara ', 'Joanna Lara', 'annajo.mx', '', null);
INSERT INTO `guerreros` VALUES ('1085', 'Emiliano Pérez Sánchez ', 'Emiliano ', '2005-12-08', '17', 'M', 'X', 'Estado de México ', '5580930734', 'emilianoperezsanchez15@gmail.com', 'No', 'La idea de un campamento cristiano me encanta y y el hecho de asistir para principalmente para poder salir a otro lado a predicar del señor es algo que me apasiona ', '56 1181 9547', 'Centro cristiano ciudad de México ', '2022-07-05 05:14:23', 'Gerardo Fernández ', 'No tengo :(', 'No tengo :(', '', 'musik1920segu1');
INSERT INTO `guerreros` VALUES ('1086', 'Carlos Fabricio Bautista Herná', 'Charly ', '2005-06-06', '17', 'M', 'M', 'Hidalgo México ', '7712105967', 'elsonrixx515@gmail.com', 'No', 'Por que desde hace mucho he querido entrar ', '771434868', 'PIB pachuca', '2022-07-05 12:23:42', 'Mirna rizzel Hernández Barron ', 'Fabricio Bautista ', 'Carlos_bh_10', '', null);
INSERT INTO `guerreros` VALUES ('1087', 'Oscar Miguel Martínez Barrera', 'Miguel', '2001-12-01', '21', 'M', 'M', 'Pachuca Hidalgo', '7713598224', 'evan-omartp@hotmail.com', 'No', 'Para acercarme más a Dios y conocerlo', '7721643789', 'Cielos Abiertos', '2022-07-05 13:29:32', 'David Camargo Gomez', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1088', 'Josué Yael Vázquez Guzmán ', 'Josue', '2004-03-16', '17', 'M', 'S', 'Pachuca ', '2212617102', 'yayeljosuevaz2004@gmail.com', null, 'Es una buena oportunidad para conocer más sobre Dios ', '7713253793', 'PIB Pachuca ', '2022-07-05 15:11:06', 'Ana Nallely Guzmán Rojas', 'Yael Vázquez ', 'Iamjosueyael', '', null);
INSERT INTO `guerreros` VALUES ('1089', 'Yahir Abimelec López Hernández', 'Abi ', '2003-04-18', '18', 'M', 'M', 'Iztapalapa ', '5630087452', 'yahirabimelecjairo@gmail.com', 'No', 'Me invitaron y me agrado la idea de aprender de la palabra y ser creativo ', '5519378631', 'Centro Cristiano CDMX', '2022-07-05 17:18:22', 'Angel Arturo López Hernández ', 'Yahir Hernández ', 'Yahirhernann', '', null);
INSERT INTO `guerreros` VALUES ('1090', 'Sebastian Castro Zamudio', 'Sebas_Zam', '2005-05-24', '16', 'M', 'X', 'Puebla ', '2211003894', 'sebaszam2405@icloud.com', 'No ', 'Porque me gustaría ir gracias a los amigos que cuentan que ha sido de mucha bendición ', '221 165 6062', 'Vida Cristiana ', '2022-07-05 21:14:38', 'Jamin', 'Sebastián Zamudio ', '_sebas_zam', '', null);
INSERT INTO `guerreros` VALUES ('1091', 'Santiago Martínez Maceda ', 'Santi JB', '2002-08-04', '20', 'M', 'M', 'Tehuacán Puebla ', '2381154078', 'santy.mtzm@gmail.com', 'No', 'Para aprender mucho.', '2384011637', 'Getsemani Tehuacán ', '2022-07-06 11:33:07', 'Elizabeth Maceda Macario ', 'Santi Mtz ', 'Santi.m.t.z', '', null);
INSERT INTO `guerreros` VALUES ('1092', 'David', 'David', '2006-08-12', '16', 'M', 'M', 'CDMX', '5514704587', 'uripamela@gmail.com', 'No', 'Invitado ', '5514704587', null, '2022-07-06 16:21:36', 'Pamela', null, null, '', null);
INSERT INTO `guerreros` VALUES ('1093', 'Laura Abigail Mendoza Noeller ', 'Cello', '2000-02-25', '21', 'F', 'M', 'Pachuca, Hidalgo ', '55 5188 0129', 'cnm.mendozanoellerlauraabigail@gmail.com', 'A los mariscos ', 'Dios me ha hecho mucho en mi vida, ha hecho grandes cambios y es mi deseo acercarme más a él y experimentar el poder de tener una relación íntima y perdurable.', '7711967778', 'PIB', '2022-07-06 20:36:40', 'Laura Vanessa Noeller Sandoval ', 'Laura Abigail Mendoza Noeller ', null, '', null);
INSERT INTO `guerreros` VALUES ('1094', 'Misael Reyes Juárez ', 'Misa', '2003-06-02', '19', 'M', 'XS', 'Ciudad de México ', '5630216968', 'misaelbatako21@gmail.com', 'No', 'Experiencia', '5565551416', 'Centro Cristiano Ciudad de México ', '2022-07-07 13:23:56', 'Rosalia Juárez ', 'Misael Leonel ', 'Misael Leonel ', '', null);

-- ----------------------------
-- Table structure for guerreros2015
-- ----------------------------
DROP TABLE IF EXISTS `guerreros2015`;
CREATE TABLE `guerreros2015` (
  `id` tinyint(4) NOT NULL DEFAULT 0,
  `nombre` varchar(50) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `edad` tinyint(4) DEFAULT NULL,
  `talla` varchar(10) DEFAULT NULL,
  `lugar` varchar(100) DEFAULT NULL,
  `whats` varchar(50) DEFAULT NULL,
  `fb` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `cuetanos` varchar(1000) DEFAULT NULL,
  `staff` tinyint(1) DEFAULT 0
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros2015
-- ----------------------------
INSERT INTO `guerreros2015` VALUES ('5', 'Alejandra Gonzalez Castañeda', 'M', '22', 'M', '', '7717769890', 'Ale Castañeda', 'ale.go.on@hotmail.com', '', '0');
INSERT INTO `guerreros2015` VALUES ('6', 'Israel Negrete Del Rio', 'H', '26', 'X', 'México D.F   Agua de vida', '5545696405', 'Jake Dirus', 'israel.negrete.delrio@gmail.com', 'Por que vivo para servir. ', '1');
INSERT INTO `guerreros2015` VALUES ('7', 'Jocelyn Grimaldo', 'M', '18', 'M', 'Amistad Cristiana', '5543693368', 'Joyce Griim', 'j-griim@outlook.com', 'Escuche de JUCUM a través de una amiga! Pero realmente quiero ir porque quiero aprender a obedecer a Dios de una manera totalmente diferente a como lo he hecho! Y estoy segura de que Dios tiene mucho que hablarme!', '0');
INSERT INTO `guerreros2015` VALUES ('8', 'Zurisadai Varela Rivera', 'M', '16', 'M', 'Amistad Cristiana Izcalli', '0445534885854', 'Zurisadai Varela Rivera', 'zurivarelarivera@gmail.com', 'Unos amigos que son organizadores del evento me invitaron :D, quiero asistir a Reto Urbano para aprender y crecer aún mas en la palabra de Dios y relacionarme con chicos que tengan el mismo deseo que yo.', '0');
INSERT INTO `guerreros2015` VALUES ('9', 'Samuel Arturo Rojas Niebla', 'H', '16', 'M', 'Amistad Cristiana Izcalli', '5519044015', 'Sam Rojas', 'cor.neta-@hotmail.com', 'Me invitaron al evento :) y comentan que es de gran edificación para mi vida, quiero vivir la experiencia y aprender mucho más de Dios.', '0');
INSERT INTO `guerreros2015` VALUES ('11', 'DANIEL URBANO NEGRETE', 'H', '17', 'XXL', 'AMISTAD DE PACHUCA ', '7711158740', 'DANIEL URBANO NEGRETE', 'RAMONURBANO2803@GMAIL.COM', 'ES EL MOMENTO DE DAR UN PASO MAS ', '0');
INSERT INTO `guerreros2015` VALUES ('13', 'Stephany Merary Ruiz Ramírez', 'M', '20', 'M', 'Semilla de Mostaza México', '5523110840', 'May Ruiz ', 'mayruiz.r@gmail.com', 'Me encantaría poder asistir a Reto Urbano y conocer un poco más a cerca de mi Señor Jesús. ', '0');
INSERT INTO `guerreros2015` VALUES ('14', 'Janny Ailin Aguilar Flores', 'M', '16', 'CH', 'Amistad Cristiana Pachuca', '7711099166', 'Ailin Flores ', 'janny_ailin@hotmail.com', 'Para tener mas intimidad con DIOS \r\nConocerlo mas ', '0');
INSERT INTO `guerreros2015` VALUES ('15', 'Jonathan Puckett', 'H', '39', 'XL', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Pckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('16', 'Melissa Garett', 'M', '39', 'CH', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('17', 'Ethan Garett', 'H', '16', 'CH', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('18', 'Forest Goodyear-Brown', 'M', '39', 'X', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('19', 'Paris Goodyear-Brown', 'M', '39', 'M', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('20', 'Sam Goodyear-Brown', 'H', '14', 'M', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('21', 'Madison Goodyear-Brown', 'M', '10', 'CH', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('22', 'Nicholas Goodyear-Brown', 'H', '7', 'CH', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('23', 'Tiffany Puckett', 'M', '39', 'X', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('24', 'Hailey Puckett', 'M', '14', 'X', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('25', 'Jack Puckett', 'H', '10', 'CH', 'The Gate Community Church Nashville, TN', '615-496-1075', 'Jonathan Puckett', 'jonathanlpuckett@gmail.com', 'M', '0');
INSERT INTO `guerreros2015` VALUES ('26', 'Luis Gerardo Mendoza Castro', 'H', '16', 'CH', 'Atizapan de Zaragoza Estado de México ', '55534662096', '', 'bobluis2007@hotmail.com', '', '0');
INSERT INTO `guerreros2015` VALUES ('28', 'Mariana García Tenorio', 'M', '22', 'CH', 'Atizapan de Zaragoza Edo. México', '5541339516', 'Maii García', 'mariana_pelona@hotmail.com', 'Me gusta participar ', '0');
INSERT INTO `guerreros2015` VALUES ('29', 'Ana Lucía Moctezuma M.', 'M', '26', 'X', 'Amistad La Paz Puebla', '2227913652', 'Ana Lucía Moctezuma', 'akikosakuraenelplanetatierra@gmail.com', 'Para apoyar en lo que necesiten :)', '1');
INSERT INTO `guerreros2015` VALUES ('30', 'Mariana Sánchez Vásquez ', 'M', '20', 'CH', 'Puebla/Iglesia El Buen Pastor', '2224944780', 'www.facebook.com/tamaldemanci', 'ihate.frogs@hotmail.com', 'Porque creo que es un medio que Dios ha puesto para seguir Su llamado. Quiero conocer más gente que tenga el anhelo de servir.  Y el título de \"obediencia radical\" aunque suena difícil es motivador, porque es lo que Dios quiere... y yo quiero seguir ese camino.', '0');
INSERT INTO `guerreros2015` VALUES ('31', 'Uriel Vela', 'H', '17', 'X', 'Amistad Cristiana Ecatepec', '5561111679', 'Uriel Vela', 'velhost22@gmail.com', 'Quiero ir más profundo en mi relación con Dios, conocerlo aún más y experimentar mejor el darlo a conocer.', '1');
INSERT INTO `guerreros2015` VALUES ('32', 'José Antonio García Martínez', 'H', '26', 'CH', 'Iglesia Cristiana Nueva Vida', '7712421462', 'José Antonio García', 'jagm_mutr-wu@hotmail.com', 'Porque quiero aprender mas, creo que hay mas que ir los domingos a la iglesia y/o participar en actividades \"cristianas\", quiero retarme a vivir de una manera radical y ser cada día mas como Jesús y menos como yo.', '1');
INSERT INTO `guerreros2015` VALUES ('33', 'Sergio Daniel Ugalde Rodriguez', 'H', '18', 'M', 'Nueva Vida ', '5529600398', 'Sergio Ugalde', 'sugalde.horrnk3rllaz@gmail.com', 'Porque quiero conocerle más, tener una experiencia con el y ayudar.', '0');
INSERT INTO `guerreros2015` VALUES ('34', 'Marian Valeria Sánchez Tenorio', 'M', '15', 'M', 'El buen samaritano  satélite ', '5535256212', 'Marian ST', 'marianstarz@hotmail.com', 'Siempre he querido ser misionera o trabajar en el reino de dios y siento que necesito un encuentro con dios y este reto me ayudara mucho. ', '0');
INSERT INTO `guerreros2015` VALUES ('36', 'Jessica Fernanda Ugalde Rodríguez ', 'M', '16', 'M', 'Nueva Vida Atlanta.', '20646893 . whatsapp: 5548758622', 'Jessica Ugalde ', 'hola.jessugalde@gmail.com', 'Por que necesito alejarme del ambiente en el que siempre convivo, además de que quiero aprender y conocer de Dios ', '1');
INSERT INTO `guerreros2015` VALUES ('37', 'Miriam YeralyRamos', 'M', '16', 'M', 'tamazunchale', '4831126350', 'Miriam Yeraly', 'miriam.yeraly@icloud.com', '', '0');
INSERT INTO `guerreros2015` VALUES ('38', 'David ', 'H', '23', 'CH', 'Nueva vida pachuca', '7711139232', 'David zuniga', 'dave_jewarrior@hotmail.com', 'Love  Jesus', '1');
INSERT INTO `guerreros2015` VALUES ('39', 'Lilian Vela', 'M', '20', 'M', 'Amistad Cristiana Los Pinos', '5514634216', 'Lili Vela', 'lili.artvela@gmail.com', 'Porque anteriormente estuve ahí y pude tener un verdadero encuentro con Dios, vivirlo, sentirlo y compartirlo.', '1');
INSERT INTO `guerreros2015` VALUES ('40', 'Edith Idali Lara Ayala', 'M', '27', 'M', 'Tultepec', '5547934770', 'Edith Idali LA', 'edith.idali.8@gmail.com', 'Conocer y tener un crecimiento con Dios', '0');
INSERT INTO `guerreros2015` VALUES ('41', 'Elizabeth Medrano Lliver', 'M', '21', 'M', 'Centro cristiano Calacoaya', '5535577632', 'Eli Medrano', 'elimedrano_2006@hotmail.com', 'Me gustaría aprender el área de evangelismo, también conocer mas de Dios', '0');
INSERT INTO `guerreros2015` VALUES ('42', 'Pereira Romero Jahaziel ', 'H', '17', 'X', 'Ecatepec/ Amistad cristiana ', '5549963498', 'Jahaziel Y P.  Romero ', 'jahazielpereira@outlook.es', 'Me gusta el campo misionero ', '0');
INSERT INTO `guerreros2015` VALUES ('43', 'Karen ', 'M', '14', 'M', 'Amistad Cristiana Los Pinos ', '', '', 'ga_karen@hotmail.com', 'Para tener un encuentro con Dios ', '0');
INSERT INTO `guerreros2015` VALUES ('44', 'Carlos Sebastian Romero Avalos', 'H', '16', 'X', 'D.F. ', '5520416561', 'Sebastian Avalos', 'sebastianavalos2011@hotmail.com', 'Fui el año pasado eh experimente cosas maravillosas en la presencia de Dios y lo quiero volver a experimentar ', '1');
INSERT INTO `guerreros2015` VALUES ('45', 'Juan Pablo', 'H', '15', 'X', 'Amistad Cristiana Los Pinos ', '5555084841', 'Juan P Villanueva C', 'juancoreo1@hotmail.com', 'Porque quiero conocer más a Jesus y acercarme más a él.', '0');
INSERT INTO `guerreros2015` VALUES ('46', 'Pepe Ten ', 'H', '28', 'CH', 'Mexico, JUCUM Tijuana', '5540443008', 'pepe ten', 'pepe_ten@hotmail.com', 'Llevo 2 meses de vuelta en la ciudad preparándome para meterme por tiempo completo a las misiones, ha sido una temporada de muchas luchas y trabajo en mi en cuestión a cerrar ciclos, relaciones y dar pasos de obediencia firmes, aun estoy en lucha con mucho de esto y siento que esta temática y visión del reto puede ayudarme mucho a ser objetivo y dar pasos con extrema seguridad ', '0');
INSERT INTO `guerreros2015` VALUES ('47', 'Rocio González  Sánchez ', 'M', '21', 'M', 'COMUNIDAD F.A.R.O', '5517435282', 'Rocio Glaz Sanchez ', 'onaychi@hotmail.com', 'PORQUE QUIERO SEGUIR CONOCIENDO A DIOS Y SEGUIR FORTALECIENDO MI RELACIÓN CON EL MAS ÍNTIMAMENTE  , FORJAR EL CARÁCTER DE DIOS  Y CONOCER MIS DONES QUE DIOS ME A DADO ', '0');
INSERT INTO `guerreros2015` VALUES ('48', 'Richz Volta', 'H', '40', 'CH', 'Amistan Cristiana', '7712088634', 'richz volta', 'director@ywampachuca.org', 'Porque quiero', '1');
INSERT INTO `guerreros2015` VALUES ('49', 'Citlali Perez M', 'M', '35', 'CH', 'jucum pachuca', '7717221473', 'Citlali Pmz', 'director@ywampachuca.org', 'staff', '1');
INSERT INTO `guerreros2015` VALUES ('50', 'Eleazar Antonio Hernandez', 'H', '59', 'M', 'SEMILLA DE MOSTAZA', '5539371019', 'Eleazar Antonio hernandez', 'ele@gmail.com', 'nos estara ayudando como chofer', '1');
INSERT INTO `guerreros2015` VALUES ('51', 'Delia Hernandez', 'M', '59', 'M', 'SEMILLA DE MOSTAZA', '7712088634', 'delia hernandez', 'director@ywampachuca.org', 'sera la cocinera estrella', '1');
INSERT INTO `guerreros2015` VALUES ('52', 'Angel de jesus Jiménez González ', 'H', '19', 'XL', 'Cornerstone', '7717090730', 'Ángel jimenez González ', 'chuchi-n96@hotmail.com', 'Porque quiero aprender cada ves mas de Dios y porque me gusta aprender de el creo que estoy en una edad donde servirle a Dios y dar mi vida para servicio de el es esencial asi que estoy ansioso ', '1');
INSERT INTO `guerreros2015` VALUES ('53', 'Jony Buendia Pitalua', 'H', '26', 'CH', 'Colombia, misionero en Jucum Pachuca', '3046725876', 'Johnny Buendía Pitalua', 'jbpitalua@gmail.com', 'Soy staff', '1');
INSERT INTO `guerreros2015` VALUES ('55', 'Ana Elena Lopez Carmona', 'M', '23', 'CH', 'Casa de Oración, SFR', '4761015340 no tengo wa', 'Anelena LC', 'anelena-@hotmail.com', 'Quiero servir a los jóvenes que asistan y las personas que visitaremos. También deseo aprender del equipo Reto Urbano para equipar a los jóvenes de mi iglesia.', '0');
INSERT INTO `guerreros2015` VALUES ('56', 'Linda Kang', 'M', '27', 'CH', 'Los Angelese', '818-489-9293', 'https://www.facebook.com/kang.linda', 'kang.linda@gmail.com', 'To know God more in His Heart for people, to serve.', '0');
INSERT INTO `guerreros2015` VALUES ('57', 'Ginna Shin', 'M', '28', 'M', 'Los Angeles', '818-205-5116', 'https://www.facebook.com/ginna.shin?fref=ts', 'ginnashin@gmail.com', 'To Know God in a deeper way and to shine his face more brightly in our world.', '0');
INSERT INTO `guerreros2015` VALUES ('58', 'Seunghyun Olyvia Baek', 'M', '15', 'M', 'Los Angeles', '818-856-5888', 'https://www.facebook.com/olyvia.baek?fref=ts', '2605skt@gmail.com', 'I have been a part of the program for the last two years, and i have experience God through many ways. I would like to outreach to others in a different environment.', '0');
INSERT INTO `guerreros2015` VALUES ('59', 'Nathen Shin', 'H', '15', 'M', 'Los Angelese', '818-438-5432', 'https://www.facebook.com/profile.php?id=100004907236724&fref=ts', 'nshinnay@gmail.com', 'I wish to experience God in a different way, and get to know Him a little more. I just want to grow more in Him, so I wish to participate in this Urban Challenge', '0');
INSERT INTO `guerreros2015` VALUES ('60', 'Paul Choi', 'H', '17', 'CH', 'Los Angeles', '818-916-3018', 'Not available', 'pchoi867@gmail.com', 'To strengthen my relationship with God and to get closer to my church. I would also want to push myself to do more and make the best of my time.', '0');
INSERT INTO `guerreros2015` VALUES ('61', 'Matthew Yang', 'H', '27', 'M', 'Los Angeles', '661-220-2112', 'https://www.facebook.com/mattyangg', 'matttyangg@gmail.com', 'I would like to grow in my relationship with YWAM Pachuca, my church, and the people of Mexico.', '0');
INSERT INTO `guerreros2015` VALUES ('62', 'Rubén Calderón Andrade', 'H', '22', 'M', 'Amistad de Pachuca', '7711752457', 'Rubén Calderon', 'pachus_93@hotmail.es', 'Es una oportunidad para aprender mas de Dios, siempre es bueno aceptar los retos.', '1');
INSERT INTO `guerreros2015` VALUES ('63', 'Karen Lorena Gomez Grande', 'M', '19', 'M', 'Amistad de Pachuca', '7712075624', 'Karen Gomez', 'karen.gm96@hotmail.com', '', '1');
INSERT INTO `guerreros2015` VALUES ('64', 'Jessica Stephany Bermúdez Cervantes', 'M', '28', 'X', 'Centro Cristiano Calacoaya', '0445555033280', 'Jess Bermudez', 'jestephatito@hotmail.com', 'Sirvo actualmente en el área de evangelismo y me gustaría aparender más acerca de esto y poner por obra todo lo aprendido aquí además de tener el privilegio de estar 1 semana conociendo mas de Dios, alabándole, adorándole, y buscándolo! Realmente quiero vivir este encuentro con el.', '0');
INSERT INTO `guerreros2015` VALUES ('65', 'Efrain Andrade ', 'H', '16', 'M', 'Bethel   Orizatlan  Hidalgo', '7712088634', 'no tengo', 'director@ywampachuca.org', 'Invitado de Papa Ele', '1');
INSERT INTO `guerreros2015` VALUES ('66', 'Jose Juan Urbina', 'H', '45', 'M', 'Amistad Xoco', '5518337078', 'Jose juan Urbina', 'jurbisam@hotmail.com', 'Chofer para Reto Urbano.', '0');
INSERT INTO `guerreros2015` VALUES ('67', 'Gamaliel Tolentino ', 'H', '17', 'X', 'Amistad Cristiana Tecamac', 'luego', 'gamaliel Tolentino', 'director@ywampachuca.org', 'Hermano de Stefani', '0');
INSERT INTO `guerreros2015` VALUES ('68', 'Mariana  Portillo Santos', 'M', '39', 'CH', 'Naciones por Herencia', '7713141749', 'Mariana Portillo Santos', 'Mariana@hotmail.com', 'Maestra para monisterio de ninos!!', '0');
INSERT INTO `guerreros2015` VALUES ('69', 'Aholibama Rodriguez', 'M', '24', 'X', 'Bethel   Norte Durango', '6182176676', '', 'aholirod@hotail.com', 'Lider para Reto :)', '1');
INSERT INTO `guerreros2015` VALUES ('70', 'Elijah Johnson', 'H', '18', 'M', 'Church of the Good Shepard', '104', 'Elijah Johnson', 'guitarfreak.johnson@gmail.com', 'Missions Work.', '1');
INSERT INTO `guerreros2015` VALUES ('71', 'Monica Julieta Mares Reyes', 'M', '22', 'M', 'Conquistando Fronteras', '5545795258', 'Julieta Mares', 'monijulimr@hotmail.com', 'Para seguir conociendo a Papá en el servicio, dar fruto y ayudar a los más pequeños', '1');
INSERT INTO `guerreros2015` VALUES ('72', 'Ana Citlali Franco Ascencio', 'M', '16', 'CH', 'Iglesia Cristiana Nueva Vida, Pachuca, Hgo.', '7712154579', 'Anna Frs', 'anaa.fr@hotmail.com', 'Es mi 4to año en reto urbano y es una experiencia muy agradable. ', '0');
INSERT INTO `guerreros2015` VALUES ('73', 'Joyce Chae', 'M', '17', 'M', 'Los Angeles', 'Not Available', 'https://www.facebook.com/joyce.chae?fref=ts', 'joyfuljoyce12@gmail.com', 'to love God.', '0');
INSERT INTO `guerreros2015` VALUES ('74', 'Paola Joana Montesinos Puga', null, '14', 'CH', 'Amistad Cristiana Izcalli', '5567418957', '', 'paolabalucomegalletas@hotmail.com', '', '0');
INSERT INTO `guerreros2015` VALUES ('75', 'Luis Adrián Valdés Ruiz', null, '20', 'CH', 'Alcance León, León de los Aldama, Guanajuato, Mexico.', '4771419374', 'https://www.facebook.com/servelink1101001001011', 'pollo.1995@hotmail.com', 'Cada situacion que te pueda acercar mas a la ejecucion de los planes que tiene Dios para Ti en este mundo, quiero intentar estar en ella.', '0');
INSERT INTO `guerreros2015` VALUES ('76', 'Joselina Sevilla Palafox', null, '16', 'M', 'n/a', 'n/a', 'n/a', 'n/a@k', '....', '0');
INSERT INTO `guerreros2015` VALUES ('77', 'Maria Jose Sevilla Palafox ', null, '13', 'CH', 'no', 'no', 'no', 'n@o', '...', '0');

-- ----------------------------
-- Table structure for guerreros2016
-- ----------------------------
DROP TABLE IF EXISTS `guerreros2016`;
CREATE TABLE `guerreros2016` (
  `id` tinyint(4) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `edad` tinyint(4) DEFAULT NULL,
  `talla` varchar(10) DEFAULT NULL,
  `lugar` varchar(100) DEFAULT NULL,
  `whats` varchar(50) DEFAULT NULL,
  `fb` varchar(100) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `cuetanos` varchar(1000) DEFAULT NULL,
  `staff` tinyint(1) DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=112 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros2016
-- ----------------------------
INSERT INTO `guerreros2016` VALUES ('2', 'Isaac Templos Enríquez', 'M', '28', 'M', 'Betania, Real del Monte', '5549324115', 'Isaac Templos Enríquez', 'isaac.templos@gmail.com', 'Quiero cerrar mi año de seguimiento para iniciar mi EDE :)', '1');
INSERT INTO `guerreros2016` VALUES ('3', 'Ana Elena López', 'F', '24', 'CH', 'Casa de Oración, SFR', '4761015340', 'Anelena LC', 'anelena-@hotmail.com', 'Quiero ir a Reto Urbano porque me emociona servir a mi generación y ser testigo del mover de Dios entre ellos. La edición anterior de Reto disfruté de una comunidad hermosa y aprendí mucho, ¡sé que aún hay más!', '1');
INSERT INTO `guerreros2016` VALUES ('4', 'Linette Yazmin Roldán Martínez ', 'F', '19', 'M', 'El Buen Samaritano ', '5534707573', '', 'linette.yazmin@hotmail.com', 'Deseo el servirle a Dios cada día mejor, el obedecerle radicalmente y poder vivir un encuentro con el diferente, predicar de su palabra teniendo las herramientas necesarias y poder conocer los retos que Él tiene para mi. ', '0');
INSERT INTO `guerreros2016` VALUES ('5', 'Rodrigo Roldán Martínez ', 'M', '20', 'M', 'El Buen Samaritano ', '5539186572', 'Rood Martinez', 'satchrodrigo@hotmail.com', 'Creo que Dios nos da oportunidades como esta,para darnos las herramientas necesarias para ser cada día más parecidos a Él, quiero tomar este reto, y aprender a obedecerle.', '0');
INSERT INTO `guerreros2016` VALUES ('7', 'Rubèn Templos Meneses ', 'M', '19', 'M ', 'BETANIA ', '7713514043', 'Ruben Templos', 'templos4.5@hotmail.com', 'porque soy parte del seguimiento de reto urbano ', '1');
INSERT INTO `guerreros2016` VALUES ('8', 'Ernesto Díaz de Castro Granados ', 'M', '33', 'M ', 'Puebla, Mex.', '2227663722 ', 'Neto dideka ', 'diazdern@hotmail.com', 'Por que quiero conocer más de Dios y poder servirle ', '1');
INSERT INTO `guerreros2016` VALUES ('9', 'Zurisadai Azarela Templos Cortes', 'F', '20', 'CH', 'Bethania', '5543724072', 'Azarela Vans T', 'ZurisadaiRox15_Templos@hotmail.com', 'pues alluda a cada chico a sentrarse en las cosas de dios a buscarle a un mas y crecer espiritualmente, y pues me gusta por que e aprendido muchas cosas nuevas que llo nunca avia echo , a conocer a ciervos de dios que le sirven, pues aprender un poco el ingles je,\r\ny el año pasado me encanto porque comvivimos todos y pues isimos juegos y toda la cosa pero tambien alabar a dios nuestro padre celestial \r\n', '1');
INSERT INTO `guerreros2016` VALUES ('10', 'Martha Deyra Romero Templos', 'F', '27', 'M ', 'Iglesia Bethania', '7711541230', 'Dey Romero Templos', 'martharomero_templos@hotmail.com', ' Para tener un encuentro con Dios pero de manera conjunta con muchos jóvenes con hambre de Dios, que quieren buscar una relación mas intima con Él, compartiendo experiencias y aprendiendo unos de otros, las enseñanzas son muy buenas, la convivencia y como experiencia también es algo muy lindo (aunque no solo queda en eso) Porque haber estado en el reto pasado fue una gran bendición tanto personal como familiar y a nivel congregacional, hubo un despertar en nosotros como jóvenes que desde ese momento no hemos parado, si bien a habido situaciones dificiles pero siempre con el anhelo de seguir adelante, creciendo, preparándonos para atraer a los demás a los pies de Dios.', '1');
INSERT INTO `guerreros2016` VALUES ('11', 'Isi Benoni Romero Templos', 'F', '25', 'CH', 'Pachuca', '7717741716', 'Isi Romero Templos', 'isiromero_templos@hotmal', 'L a experiencia de ser parte de este proyecto a traído un despertar a muchas áreas de mi vida, el experimentar las diferentes formas en las Dios nos sigue hablando....  Y el seguir desarrollandome dentro del ministerio,  y descubrir q hay habilidades que no sabia q tenia,  el q te reten a hacer cosas diferentes y salir de la comodidad,  bendice y satisface mi vida. ', '1');
INSERT INTO `guerreros2016` VALUES ('12', 'Mariana Garcia Tenorio', 'F', '22', 'CH', 'atizapan, centro cristiano calacoaya ', '5541339516', 'Mariana Garte ', 'mgarciat@centro.edu.mx', 'por que quiero  cortar con mi novio y no tengo la valentía ', '1');
INSERT INTO `guerreros2016` VALUES ('13', 'Elizabeth Medrano Oliver ', 'F', '22', 'M', 'CENTRO CRISTIANO CALACOAYA ', '5535577632', 'Eli Medrano', 'elimedrano_2006@hotmail.com', 'soy staff ', '1');
INSERT INTO `guerreros2016` VALUES ('15', 'Marian Valeria Sanchez Tenorio ', 'F', '16', 'M', 'el buen  samaritano ', '5535256212', 'Marian ST', 'marianstarz@hotmail.com', 'reto cambio mi vida ', '1');
INSERT INTO `guerreros2016` VALUES ('16', 'Rubi Templos Meneses', 'F', '15', 'M', 'Real del Monte  iglesia Betania', '7713004814', 'Rubi Templos', 'rubitemplos123@hotmail.com', 'porque el año pasado fue una experiencia muy agradable donde conoci mas de Dios y en este año quiero experimentar cosas nuevas y buscar mas aDios', '1');
INSERT INTO `guerreros2016` VALUES ('17', 'Joel Templos Arellano', 'M', '20', 'CH', 'Betania', '7711406444', 'Joel Templos Arellano', 'templos_13@hotmail.com', 'Este sería mi segundo y que quiero superar lo que Dios me dio del año pasado.', '0');
INSERT INTO `guerreros2016` VALUES ('19', 'Delmar Camas Jaimes', 'F', '22', 'M', 'Centro Cristiano Calacoaya', '5512967569', 'DêLagüa Camas', 'delaguacj182@gmail.com', 'Conocer más', '0');
INSERT INTO `guerreros2016` VALUES ('20', 'Mary Ann Templos Enríquez', 'F', '23', 'CH', 'Betania ', '5523300595', 'Mary Ann Templos', 'marytemplos.17@gmail.com', 'Para seguir teniendo experiencias del poder de Dios', '0');
INSERT INTO `guerreros2016` VALUES ('21', 'Aline ocampo', 'F', '19', 'X', 'Ninguna ', '4626538574', 'Aline O\'campo', 'lapolona@gmail.com', 'Hacealgunos años fui y cambio mi vida. Es tiempo de regresar ', '0');
INSERT INTO `guerreros2016` VALUES ('22', 'Angel de Jesus Jimenez Gonzalez', 'M', '20', 'XXL', 'cornerstone ', '7717090730 ', 'Angel Jimenez Gonzalez', 'chuch-n96@hotmail.com', 'porque siempre que voy puedo aprender algo nuevo y conocer mas a Dios ', '0');
INSERT INTO `guerreros2016` VALUES ('25', 'SAMUEL ARTURO ROJAS NIEBLA', 'M', '17', 'M', 'AMISTAD CRISTIANA IZCALLI', '5519227404', 'Sam Rojas', 'bonit.nie@hotmail.com', 'POR QUE QUIERO UN ENCUENTRO CON DIOS Y ADEMAS  EL AÑO PASADO QUE FUI APRENDÍ COSAS BUENAS PARA MISIONES Y ES AGRADABLE', '0');
INSERT INTO `guerreros2016` VALUES ('26', 'JOSÉ ANDRES ROJAS NIEBLA', 'M', '13', 'CH', 'AMISTAD CRISTIANA IZCALLI', '5519227404', 'Andres Rojas', 'bonit.nie@hotmail.com', 'Ppo que me interesa conocer acerca de las misiones y saberv la experiencia de hacerlo', '0');
INSERT INTO `guerreros2016` VALUES ('27', 'Alfredo Camargo Montiel', 'M', '16', 'X', 'No soy congregante', '5529915231', 'Fredy montiel', 'sailenser2000@hotmail.com', 'Por invitación...', '0');
INSERT INTO `guerreros2016` VALUES ('28', 'Norma Itzel Roldan Perez', 'F', '17', 'M', 'Centro de Fé esperanza y amor Tacuba', '5560068668', 'Itzuu Roldan Ro', 'soytotalmenteyo@live.com.mx', '<3', '0');
INSERT INTO `guerreros2016` VALUES ('29', 'Charly Whitman ', 'M', '21', 'XL', 'Seattle, WA', '12533557311', 'Facebook.com/charlyjoy', 'charlybringingjoy@gmail.com', 'I went to the Community Development School in Tijuana with a specific plan in place, but God\'s are so much different than our own. He has called me to help in Pachuca rather than stay in Tijuana for the month of July and part of August to build different skills that I have and gain new experiences with different ministries. I am so excited to see what all God has for me to learn and teach in this time!', '1');
INSERT INTO `guerreros2016` VALUES ('32', 'Oscar Corona Contreras ', 'M', '16', 'M', 'Amistad Cristiana Las Americas ', '5560318704', 'Oscar Corona', 'oscar.roger@outlook.com', 'Porque a mi me gustaria ser misionero ????', '0');
INSERT INTO `guerreros2016` VALUES ('33', 'Eduardo Lagos Mercado', 'M', '15', 'CH', 'Tecamac', '?+52 1 55 6335 8826?', 'Eduardo Lagos', 'pepetenbr@gmail.com', 'Porque quiero seguir aprendiendo más de Dios ', '0');
INSERT INTO `guerreros2016` VALUES ('35', 'Pepe Ten', 'M', '29', 'M', 'CCC', '5540443008', 'Felipe Ten ', 'pepetenbr@gmail.com', 'Porque fui al año pasado y fue un parte aguas en mi vida y estoy emocionado por continuar viendo y siendo parte de esto ', '1');
INSERT INTO `guerreros2016` VALUES ('36', 'Abraham Aarón Templos Enríquez', 'M', '19', 'M', 'Betania', '5510099006', 'Aarón Templos Enríquez', 'aaron8.templos@gmail.com', 'Asistí el año pasado y me gusto ', '0');
INSERT INTO `guerreros2016` VALUES ('37', 'Sergio Enrique Fernández Cuevas', 'M', '24', 'M', 'centro cristiano calacoaya', '5532776670', 'cheko fernández ', 'sergio.chekofer@gmail.com', 'Tengo amigos que sirven y me dijeron que es una muy buena experiencia.', '0');
INSERT INTO `guerreros2016` VALUES ('38', 'Jocelyn Miranda Hernandez', 'F', '16', 'M', 'Betania real del monte ', '7712412962', 'Jocelyn hrdz', 'mjocelyn491@gmail.com', 'Porque me han contado que es una experiencia muy bonita y quiero conocerás a Dios en este tiempo ', '0');
INSERT INTO `guerreros2016` VALUES ('39', 'Samantha Dionisio Romero ', 'F', '20', 'M', 'Amistad Cristiana Las Americas ', '5559916259', 'Samantha Dionisio Romero ', 'zprsamy@hotmail.com', 'En definitiva mi propósito es seguir la voluntad de Cristo para mi vida, ser su espejo, es por esto que quiero conocer más de Él y poder servir en todo lo que pueda. Veo Reto una gran oportunidad de aprendizaje, en muchos aspectos, como evangelizar que es por lo que también estamos aquí. ', '0');
INSERT INTO `guerreros2016` VALUES ('40', 'Maciel Salas Romero ', 'F', '14', 'M', 'Amistad Cristiana Las Americas ', '5568868064 ', 'Maciel Romero ', 'vero.romero.salas@hotmail.com', 'Quiero estar mas preparada,quiero aprender mas y servirle al señor.\r\n', '0');
INSERT INTO `guerreros2016` VALUES ('41', 'Uriel Vela Soto', 'M', '18', 'X', 'Amistad Cristiana Ecatepec', '5561111679', 'Uriel Vela', 'velhost22@gmail.com', 'Quiero seguir creciendo en Dios, su palabra y vivir muchos de los Retos que Él tenga preparados en esa semana.', '1');
INSERT INTO `guerreros2016` VALUES ('42', 'Richz Volta', 'M', '41', 'CH', 'Comunidad El Faro', '7712088634', 'richz volta', 'director@ywampachuca.org', 'Porque es lo maximo en entrenamientos para adolecentes', '1');
INSERT INTO `guerreros2016` VALUES ('43', 'Citlali Perez M', 'F', '35', 'CH', 'faro', 'na', 'Citlali Pmz', 'lalyshine@yahoo.com', 'porque Richz Volta es mi novio', '1');
INSERT INTO `guerreros2016` VALUES ('44', 'Hailey Puckett', 'F', '15', 'M', 'The Gate Community Church', 'na', 'Hailey Puckett', 'jonathanlpuckett@gmail.com', 'N/A', '0');
INSERT INTO `guerreros2016` VALUES ('45', 'Eleanna Weaver', 'F', '14', 'M', 'The Gate Community Church', 'na', 'na', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('46', 'Ethan Garrett', 'M', '17', 'L', 'The Gate Community Church', 'na', 'no tengo', 'jonathanlpuckett@gmail.com', 'NA', '0');
INSERT INTO `guerreros2016` VALUES ('47', 'Nate Garrett', 'M', '18', 'L', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'NA', '0');
INSERT INTO `guerreros2016` VALUES ('48', 'Sam Goodyear', 'M', '15', 'M', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('49', 'Noah Phillips', 'M', '15', 'M', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('50', 'Francesca Bruinsma', 'F', '14', 'CH', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('51', 'Jonathan Puckett', 'M', '41', 'XXL', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'NA', '0');
INSERT INTO `guerreros2016` VALUES ('52', 'Tiffany Puckett', 'F', '35', 'M', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('53', 'Connor Puckett', 'M', '17', 'L', 'The Gate Community Church', 'na', 'na', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('54', 'Jack Puckett', 'M', '11', 'CH', 'The Gate Community Church', 'na', 'na', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('55', 'Gabe Puckett', 'M', '30', 'L', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'NA', '0');
INSERT INTO `guerreros2016` VALUES ('56', 'Karen Puckett', 'M', '50', 'M', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('57', 'Milissa Garrett', 'F', '41', 'M', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('58', 'Steve Garrett', 'M', '41', 'L', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'NA', '0');
INSERT INTO `guerreros2016` VALUES ('59', 'Heather Messick', 'M', '40', 'L', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('60', 'Paris Goodyear', 'F', '35', 'M', 'The Gate Community Church', 'na', 'na', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('61', 'Amy Philips', 'F', '35', 'M', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('62', 'Deanna Bruinsma', 'F', '41', 'M', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('63', 'Cameron Fry', 'F', '21', 'L', 'The Gate Community Church', 'na', 'MI NOMBRE', 'jonathanlpuckett@gmail.com', 'na', '0');
INSERT INTO `guerreros2016` VALUES ('64', 'Mariana Pallares Prado', 'F', '27', 'M', 'santa fe', '5519396631', 'Mariana Pallares Prado', 'blueberrymariana@gmail.com', 'Es una gran oportunidad de tener una nueva experiencia en mi vida , estar mas cerca de Dios , poder ayudar a otras personas ', '0');
INSERT INTO `guerreros2016` VALUES ('65', 'Rubem Calderón Andrade  ', 'M', '23', 'M', 'Amistad Cristiana Pachuca', '7711752457', 'Ruben Calderon ', 'pachus_93@hotmailes', '.', '1');
INSERT INTO `guerreros2016` VALUES ('66', 'karen Lorena Gomez', 'F', '20', 'M', 'Amistad Cristiana Pachuca', '7711564089', 'karen Gomez', 'karen.gm96@hotmail.com', '.', '1');
INSERT INTO `guerreros2016` VALUES ('67', 'Ana Lucía Moctezuma Malacara', 'F', '27', 'CH', 'Puebla', '2227587157', 'Ana Lucía Moctezuma', 'moktelux@gmail.com', 'Para ver y ser parte de lo que Dios va a hacer este año en las vidas de todos ahí.', '1');
INSERT INTO `guerreros2016` VALUES ('69', 'Benjamin Reyes Gonzalez', 'M', '21', 'M', 'Centro Cristiano Philadelphia - Puebla México', '2221157014', 'Benjamin Reyes', 'benireyes.youth@gmail.com', 'Para tener un tiempo de crecimiento y comunión con Dios. Aprender cosas nuevas y amar más a las personas compartiendo todo lo que pueda. Buscar la dirección de Dios y escucharlo con una atención especial.', '0');
INSERT INTO `guerreros2016` VALUES ('70', 'Paola Urbina ', 'F', '21', 'CH', 'Soy personal de Pachuca ', '5571731507', 'Paola Urbina ', 'urbipao20@gmail.com', 'Participare apoyando :) ', '1');
INSERT INTO `guerreros2016` VALUES ('71', 'Portia Ameyalli García Cruz', 'F', '20', 'CH', 'Puebla', '2228655407', '', 'portiaameyalli@hot', '', '0');
INSERT INTO `guerreros2016` VALUES ('73', 'Mariana Sanchez Vasquez', 'F', '21', 'CH', 'Puebla/El buen pastor', '2227339177', 'Mariana Demanci', 'ihate.frogs@hotmail.com', 'Por Elijah LOL', '1');
INSERT INTO `guerreros2016` VALUES ('74', 'Lucero Martinez Castañeda', 'F', '25', 'X', 'Casa de Adonai', '7717722130', 'Lucero Castañeda', 'castaneda_lucero@hotmail.com', 'Para ser de apoyo en todo lo que pueda, y de nuevo vivir esta hermosa experiencia', '1');
INSERT INTO `guerreros2016` VALUES ('75', 'Jony Buendìa', 'M', '27', 'CH ', 'Staff', '771 219 6807', 'Johnny Buendìa', '.', '.', '1');
INSERT INTO `guerreros2016` VALUES ('76', 'Edwin Michel Acosta Acosta', 'M', '18', 'CH', 'Amistad Cristiana Los Pinos', '5566157439', 'Reeyseek Acosta B|', '', '', '0');
INSERT INTO `guerreros2016` VALUES ('77', 'Jairo Fernando Hernández López', 'M', '17', 'M', 'Amistad Cristiana Los Pinos', '', '', '', '', '0');
INSERT INTO `guerreros2016` VALUES ('78', 'Álvaro Vela Bello', 'M', '14', 'X', 'Amistad Cristiana Los Pinos', '5529323808', 'Álvaro Vela', 'alvaritonik@hotmail.com', 'Para ir más lejos en mi relación con Jesús y mejorar así en el ministerio.', '0');
INSERT INTO `guerreros2016` VALUES ('79', 'Lilian Vela Soto', 'F', '21', 'CH ', 'Amistad Cristiana Los Pinos', '5514634216', 'Lili Vela', 'lili.artvela@gmail.com', 'Quiero aprender y aplicar lo que la palabra.', '0');
INSERT INTO `guerreros2016` VALUES ('80', 'Vanessa  Pérez Cisneros ', 'F', '17', 'M', 'CDO en San Francisco del rinco guanjuato ', '477 638 8524', 'Vane  López ', 'lopezvane1716@gmail.com', 'Por quiero conoser muchos más de Dios  y siento que dios me llamo esta oportunidad  y también  quiero vivir un encuentro con dios  .', '0');
INSERT INTO `guerreros2016` VALUES ('81', 'Jose Juan Urbina Samperio', 'M', '55', '38', 'lugar secreto', '521 55 18 33 70 78', '', 'jurbisam@hotmail.com', 'Como servicio a mi Señor Jesucristo', '0');
INSERT INTO `guerreros2016` VALUES ('82', 'Nelly Monserrath Olvera Hernandez ', 'F', '15', 'CH', 'Iglesia Cristiana Nueva Vida', '7711243186', 'Nelly Olvera', 'nellyolverahernandez@gmail.com', 'Tengo 3 años en reto urbano,  ha sido de las mejores experiencias de mi vida ,  y gracias a a ello he tenido una mejor relación con Dios. ?', '0');
INSERT INTO `guerreros2016` VALUES ('83', 'Sheila Bonilla Ruiz', 'F', '22', 'X', 'IGLESIA BAUTISTA DE VILLAS DE LA HACIENDA', '5518359606', 'SHEILA BONILLA RUIZ', 'borush.sb@gmail.com', 'Porque dos de mis mejores amigas me invitan a ser parte de esta increible experiencia y no me gustaría perderme la oportunidad de vivirla.', '0');
INSERT INTO `guerreros2016` VALUES ('84', 'Luis Gerardo Mendoza Castro ', 'M', '17', 'CH', 'Atizapán ', '5534662096', '', 'gerardo.mendoza01@cfe.gob.mx', 'Un cambio de vida', '0');
INSERT INTO `guerreros2016` VALUES ('85', 'Ruth Priscila López Navarrete ', 'F', '17', 'M', 'san Francisco del rincon, Casa de oración ', '4761004704', 'Ruth López ', 'navarrete_priscila@hotmail.com', 'Quiero conocer mas de Jesús y de lo que el puede hacer ', '0');
INSERT INTO `guerreros2016` VALUES ('87', 'Christian Olivan Salas', 'M', '34', 'CH', 'Jucum Pachuca ', '7712989634', 'Christian Olivan ', 'salas.christian1@gmail.com', 'participamos en talleres ', '1');
INSERT INTO `guerreros2016` VALUES ('88', 'Betsabe Molina Martinez', 'F', '33', 'CH', 'ywam pachuca ', '3338097440', 'Betsabe Molina', 'mol.bets@gmail.com', 'parte de los lideres y taller', '1');
INSERT INTO `guerreros2016` VALUES ('89', 'Eric Enoc Templos Arellano ', 'M', '15', 'CH', 'Real del Monte  iglesia Betania', '7712109570', 'eric templos', 'eric.templos@yahoo.com', 'Para acercarme mas a Dios :(', '0');
INSERT INTO `guerreros2016` VALUES ('90', 'CHRISTOPHER ADDI MANCILLA RODRIGUEZ', 'M', '13', 'X', 'JESUCRISTO REDENTOR PERFECTO', '5516313517', 'CHRISTOPHER MANCILLA RODRIGUEZ', 'ahinoam.rodca@gmail.com', 'Para conocer nuevas personas y aprender', '0');
INSERT INTO `guerreros2016` VALUES ('91', 'Aranza Hernandez Cadena', 'F', '15', 'CH', 'Centro Cristiano Calacoaya', '5529443492', 'Alexa Herca', 'aranzacadena6@gmail.com', 'porque me llamo la atención el enfoque', '0');
INSERT INTO `guerreros2016` VALUES ('92', 'Naomi Isabel De León Hernández', 'F', '16', 'M', 'Las Americas', '5521042624', 'Naomi De León', 'isabel.naomi.deleon@gmail.com', 'Porque amo a Dios y quiero tener una relación fuerte con él.', '0');
INSERT INTO `guerreros2016` VALUES ('93', 'Jael Abril De León Hernández', 'F', '13', 'CH', 'Las Américas', '5510520459', 'Jael De León', 'isabel.naomi.deleon@gmail.com', 'Porque mi hermana fue el año anterior y quiero vivir la misma experiencia ', '0');
INSERT INTO `guerreros2016` VALUES ('94', 'Karla Ximena De León Hernández', 'F', '22', 'CH', 'Amistad Cristiana Las Américas', '5519612033', 'Karla Ximena Dlh', 'xdeleonmakeup@gmail.com', 'Por que el año pasado mis amigos y hermana tuvieron la oportunidad de ir, yo no pude, pero me han motivado demasiado y sé que será de gran bendición.', '0');
INSERT INTO `guerreros2016` VALUES ('95', 'Fernanda Aquetzalli Juarez Flores', 'F', '16', 'M', 'Las Americas', '5567831847', '', 'aquetzalli.juarez.26@gmail.com', 'Quiero ir porque pienso que es una buena opción para darme cuenta de lo que es la preparación para hacer misiones y una oportunidad de acercarme un poco más a el ambiente de la evangelización ', '0');
INSERT INTO `guerreros2016` VALUES ('96', 'Ari Isai García Sánchez ', 'M', '13', 'MED', 'Amistad Cristiana Las Americas', '5543582613', 'Sánchez Isai', 'gaael74@gmail.com', 'Por amor y servir a Dios ', '0');
INSERT INTO `guerreros2016` VALUES ('97', 'Asiel Arciniega Sánchez ', 'M', '19', 'X', 'Amistad Cristiana Las Americas', '5567067659', 'Asiel As', 'gaael74@gmail.com', 'Por conocer más a Dios y vivir nuevamente esa experiencia ', '0');
INSERT INTO `guerreros2016` VALUES ('99', 'Zurisadai Varela Rivera', 'F', '17', 'M', 'Amistad Cristiana Izcalli', '5585793998', 'Zurisadai Varela Rivera', 'zurivarelarivera@gmail.com', 'Para servir, tener un tiempo, un encuentro con Dios, ser una herramienta útil y escuchar la voz de Dios durante este tiempo', '0');
INSERT INTO `guerreros2016` VALUES ('100', 'Viridiana Gonzáles Luna', 'F', '32', 'CH', 'Amistad Cristiana Izcalli', '5541399644', 'Viry Luna', 'gonzalezvl08@yahoo.com.mx', 'Para tener un encuentro profundo con Dios, un avivamiento  nuevo en mi vida, para servir y ser útil en las manos de Dios.', '0');
INSERT INTO `guerreros2016` VALUES ('101', 'Sandra González Luna', 'F', '30', 'CH', 'Amistad Cristiana Izcalli', '5529402779', 'Sandysam Luna', 'san_dy_sam@hotmail.com', 'Fortalecer mi relación con Dios, tener un tiempo de capacitación y reflexión de mi propósito en Dios a través de la palabra.', '0');
INSERT INTO `guerreros2016` VALUES ('103', 'Yirel Pereira Romero ', 'F', '16', 'CH ', 'Amistad cristianos Ecatepec ', '5540345567', 'Yirel Yiyos Pereira Romero ', 'yirel_yiyos1D@hotmail.com', 'Una oportunidad única de mostrar el amor de Dios a otras personas a través de un esquipo que te prepara para cumplir con el propósito de Dios para nuestras vidas ', '0');
INSERT INTO `guerreros2016` VALUES ('104', 'Berenice Salas Castañeda', 'F', '20', 'M', 'Cire', '7711809313', 'Bere SC', 'salasberecas@gmail.com', 'Vivir una nueva experiencia con Dios', '0');
INSERT INTO `guerreros2016` VALUES ('106', 'Jose Antonio Rubio González ', 'M', '14', 'M', 'Las Americas', '5532667837', 'Jose Arg', 'socorro.notwithstanding@gmail.com', 'Quiero seguir creciendo en el Señor. Quiero ver la oportunidad de ir a Jucum Tijuana. Tengo familia.\r\n', '0');
INSERT INTO `guerreros2016` VALUES ('107', 'Yibran Merino Martinez ', 'M', '14', 'M', 'Las Américas', '46061826', 'Yibran Merino ', 'normamgmm@hotmail.com', 'Por obediencia a Dios y a mis papás y que el Señor me muestre mi ministerio el cual tengo que seguir.', '0');
INSERT INTO `guerreros2016` VALUES ('108', 'Carlos Enrique Sánchez Rubio', 'M', '13', 'X', 'Casa de Oración, San Francisco del Rincón Gto.', '4765435487', 'Carlos Sánchez', 'tacosquique@icloud.com', 'Quiero vivir esta experiencia de conocer más a Dios.', '0');
INSERT INTO `guerreros2016` VALUES ('109', 'Roberto Adrian Bonilla Ruíz', 'M', '14', 'M', 'SAntuario de Ntro Sr Juan Diego', null, null, null, null, '0');
INSERT INTO `guerreros2016` VALUES ('110', 'Luz Alejandra Mendoza Camacho', 'F', '14', 'M', null, null, null, null, null, '0');
INSERT INTO `guerreros2016` VALUES ('111', 'Dulce maria Mendoza Camacho', 'F', '18', 'M', null, null, null, null, null, '0');

-- ----------------------------
-- Table structure for guerreros2017
-- ----------------------------
DROP TABLE IF EXISTS `guerreros2017`;
CREATE TABLE `guerreros2017` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `talla` varchar(3) DEFAULT NULL,
  `vienede` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(12) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `razones` varchar(255) DEFAULT NULL,
  `staff` bit(1) DEFAULT NULL,
  `confima_pago` bit(1) DEFAULT NULL,
  `nomero_ticket` varchar(50) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT 1550,
  `status` varchar(1) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=197 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros2017
-- ----------------------------
INSERT INTO `guerreros2017` VALUES ('1', 'Vanessa Pérez Cisneros', '18', 'C', 'San Francisco  del rincón guanajuato ', '477 638 8524', 'lopezvane1716@gmail.com', 'Para vivir una hermosa experiencias con Dios y saber y  pretende más de dios y para saber que propósito  Dios tiene para mi ', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('2', 'Jose Antonio Rubio Gonzalez', '15', 'G', 'Amistad Crisitiana Las Americas', '5520043333', 'JoseRG38@outlook.com', 'Por Que un Anhelo de Mi corazón servirle a el señor', '\0', '', '', '0', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('3', 'Oscar Rogelio Corona Contreras', '17', 'G', 'Las Américas ', '5577864918', 'oscar.roger@outlook.com', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('4', 'Dulce Maria Mendoza Camacho', '18', 'C', 'Estado de mexico', '5578666817', 'Alexydulcehm@outlook.es', 'Un encuentro con Dios y servirle ', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('5', 'Luz Alejandra Mendoza Camacho', '18', 'C', 'Estado de Mexico', '5578766817', 'alejandramendozac@outlook.com', 'Anhelooo conocer aun más a Dios, Quiero servir a Dios y ayudar a mas chicos a que conozcan de El y a que realmente tengan un encuntro personal con Dios, Dios por medio de Reto Urbano me cambio totalmente la vida.', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('6', 'Luis Angel Mendoza Camacho', '15', 'C', 'Mexico atizapan', '5578766817', 'mendozacamacholuis_20@outlook.com', 'Alabar a Dios', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('7', 'Arnold Rodriguez Campuzano', '21', 'M', 'Toluca', '7228374418', 'jahsaves7@hotmail.com', 'Por una experiencia inolvidable con Dios y desarollar todos los dones y talentos que el ha depositado en mi, para usarlos para su Gloria y nombre para que el evangelio llege a todos los confines de la tierra y servirle de esa manera', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('8', 'Samuel Arturo Rojas Niebla', '18', 'M', 'Cautitlán Izcalli, Edo. de Méx.', '5519227404', 'sambulvoos@gmail.com', 'Estaré ahí para tener una relación con Dios más a fondo y crecer aún más. También voy para apoyar a lo que se necesite.', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('9', 'Charly Whitman', '22', 'M', 'JUCUM PACHUCA', '771-124-0840', 'charlybringingjoy@gmail.com', 'Soy staff, y me encanta', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('10', 'Rubèn Calderón ', '23', 'C', 'Pachuca', '7711752457', 'pachus_93@hotmail.es', 'Por que soy fan de Neitan ', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('11', 'Karen Gòmez', '21', 'M', 'Pachuca', '7711564089', 'karen.gm96@hotmail.com', 'Somos fans de TermiNeitan', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('12', 'Samantha Dionisio ', '21', 'M', 'Amistad Cristiana Las Americas ', '5567627638', 'sadiro1810@gmail.com', 'Para aprender más de mi Padre, en definitiva querer morir y poder ser un reflejo de Él.', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('13', 'Karla Ximena De León Hernández', '23', 'C', 'Ecatepec', '5578079339', 'xdeleonmakeup@gmail.com', 'Amor a Dios y a las personas.', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('14', 'Naomi Isabel De León Hernández', '17', 'C', 'Ecatepec', '5576085248', 'isabel.naomi.deleon@gmail.com', '', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('16', 'Yetzel Denisse Linares Reyes', '17', 'M', 'Ecatepec', '5512118843', '', 'Para conocer más a Dios.\r\nOlvidamos el correo electrónico, pero pueden encontrarnos en ese número.\r\n', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('17', 'Valeria Juárez Tabares', '14', 'C', 'Ecatepec', '5532820626', 'pal_edgartavares@hotmail.com', 'Porque en su congregación ( Amistad Cristiana Las Américas) le recomendaron mucho asistir a este campamento.', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('18', 'Desiree Mayorga', '19', 'C', 'Estado de Mexico', '63471285', 'dess.mayorga@gmail.com', 'Quiero conecer mas a Dios, el deseo de mi corazón es servirle y hacer cada día su voluntad para que El cumpla su propósito en mi vida. ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('19', 'Kehila Ilean Mayorga Duran', '15', 'C', 'Estado de México ', '5540198683', 'kehila_ilean@hotmail.com', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('20', 'Armando Arath Lara Suarez', '15', 'M', 'Las Americas, Ecatepec de morelos', '', 'arath-lara@outlook.es', 'Aprender a compartir la palabra de Dios', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('21', 'Braulio Aaron Lara Suarez', '14', 'G', 'Las Americas, Ecatepec de morelos', '5527591377', 'braulio-larasuarez@hotmail.com', 'Aprender y compartir de la palabra de Dios\r\n', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('23', 'Maciel salas Romero', '15', 'G', 'Ecatepec', '', 'vero.romero.salas@hotmail.com', 'Siento que es una gran bendicion poder ir.\r\nEl año pasado no pude por algunos problemas pero espere este año para poder ir.\r\nEn verdad es un anhelo que tengo en mi corazon,quiero conocer mas de el y quiero prepararme para los planes que el tiene para mi.', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('24', 'RAQUEL HERRERA ROBLES', '25', 'C', 'Pachuca de Sotos ', '7711234787', 'cat_que@hotmail.com', 'Conocer mas de Dios aprender de El, y así poder ayudar a otros que conozcan su palabra y poder ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('25', 'Muñoz Moreno Maria Fernanda ', '16', 'M', 'Estado de mexico ', '55 43223372 ', 'mafemunozmoreno@yahoo.com.mx', 'He estado esperando muchísimo por regresar, (por que me perdí el reto pasado) en mi primer reto, tuve un encuentro magnifico con Dios, y   en realidad quiero mantenerme en constante aprendizaje y entrenamiento para servirle como se merece ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('26', 'Marian Valeria Sanchez Tenorio', '17', 'M', 'México ', '5535256212 ', 'marianstarz@hotmail.com', 'Por que si ', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('27', 'Kevin Isúi Jiménez López', '18', 'M', 'estado de mexico', '7227023411', 'kevin_jimenez190@hotmail.com', 'fui invitado por un amigo llamado Arnold y me agrado mucha la idea de ir a aprender mas sobre el ministerio de evangelismo. Quiero ser sorprendido por Dios.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('28', 'Nahum Enrique Ordoñez Enriquez', '18', 'M', 'Toluca, Edo Mex', '7227027304', 'nahord104@gmail.com', 'Un amigo me invito', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('29', 'Samuel Sánchez Hernández', '14', 'C', 'Ecatepec de Morelos, Estado de México', '', 'pasesito22@hotmail.com', 'Me gusta salir de mi casa, conocer nuevas personas, divertirme, escuchar la palabra de Dios, y proponerme retos como este, evangelizar.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('30', 'Janeth Montaño Padrón.', '0', 'M', 'Del Estado de México ', '5567531761', 'janethmp98@live.com', 'Porque quiero hablar sobre la palabra de Dios, ayudar a quienes necesitan de él... ser su fiel herramienta para hablar sobre el amor que nos tiene. ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('32', 'Jazmin Montaño Padrón ', '0', 'M', 'Estado de México ', '5560925372', 'janethmp98@live.com', 'Porque quiero saber más sobre la palabra de Dios, quiero enamorarme más de el.??', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('35', 'Ana Maricela Romero Juárez.', '0', 'M', 'Estado de México.', '5531176986', 'paulina.juarez1608@gmail.com', 'Porque quiero conocer y aprender más sobre la palabra de Dios. \r\nQue es un hermoso camino,ya que es nuestra guía. \r\nY estar más afondo con el. ????', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('36', 'Bryan Alesei Mendoza Ruiz', '19', 'G', 'Tuxtla Gutiérrez Chiapas', '9612870457', 'aleseibryan@gmail.com', 'Hola qué tal \r\nLa razón por la que voy es porque quiero capacitarme más, aprender cosas nuevas, para poder impartilas con el fin evangelístico.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('40', 'Denisse Guadiana Alcántara ', '18', 'G', 'México ', '5549423561', 'denigu99@hotmail.com', 'Me recomendaron el campamento y me dio curiosidad ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('41', 'Sandra Anahi Barcenas Ruiz', '20', 'M', 'México ', '5573683187', 'sanndy.br@hotmail.com', 'Me lo recomendaron', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('43', 'Zurisadai Varela Rivera', '18', 'M', 'Amistad Cristiana Izcalli', '5585793998', 'zurivarelarivera@gmail.com', 'Crecer y ayudar a crecer el propósito de Dios en México y el mundo, ayudar en la visión que Dios nos ha dado como Reto.', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('44', 'Martínez Vidal Keila', '18', 'C', 'Calacoaya', '5546827109', 'takethebestmoment.98@gmail.com', 'Quiero un cambio radical en mi vida, quiero conocer a Dios en todas sus fases y servirle. ', '\0', '\0', null, '1550', 'I', 'F');
INSERT INTO `guerreros2017` VALUES ('45', 'Jose Andres Rojas Niebla ', '14', 'C', 'Cautitlán Izcalli, Edo. de Méx.', '5519227404', 'andres180820@hotmail.com', 'Me interesa saber más de lo que hay allá porque me invitaron y me interesó :v ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('47', 'Giovanna Michelle Bernal Ojeda', '15', 'G', 'Naucalpan, Estado de México ', '5560598765', 'status@att.net.mx', 'Me invitaron unas amigas y deseo tener un encuentro con Dios y crecer más espiritualmente ', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('48', 'Víctor Allan Jaen Reyes', '14', 'M', 'Ecatepec, Estado de México', '5583495349', 'allan.jaenhotmail.com', 'Para seguir conociendo de Dios.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('49', 'Miguel Andre Moedano Ponce', '16', 'M', 'Las Americas', '5543565791', 'moedanoandre@gmail.com', 'para tener mas conocimiento de la palabra y tener un encuentro conmigo y con Dios ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('50', 'Abraham de Jesús Morales  Hdz', '22', 'G', 'Cautitlán Izcalli, Edo. de Méx.', '', 'amorale9510@gmail.com', 'Quiero asistir para reconocer mis fuerzas, para participar en el movimiento y corresponder a mi llamado.', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('51', 'Angelica Berenice Torres Torre', '24', 'C', 'Cautitlán Izcalli, Edo. de Méx.', '5585041496', 'angelita-betsaida@hotmail.com', 'Para conocimiento más profundo del servicio de evangelismo y además por invitación.', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('52', 'Gabriela Pedraza Lara ', '22', 'M', 'Cautitlán Izcalli, Edo. de Méx.', '5531692139', 'gabydmoreno0702@gmail.com', 'Para seguir desarrollando talentos y seguir creciendo en las cosas de Dios.', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('53', 'Esdras Gadiel Resendiz Ortiz', '14', 'M', 'Cautitlán Izcalli, Edo. de Méx.', '5539125894', 'flakita793190@gmail.com', 'Porque quiero evangelizar, conocer gente y compartir el amor de Dios.', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('54', 'Bryan Michel Moreno Carbajal ', '20', 'M', 'Cautitlán Izcalli, Edo. de Méx.', '5531692139', 'bryanmp10702@gmail.com', 'desarrollar mis dones y crecer en el camino de Dios ', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('55', 'Josué Gabriel Morales Hdz', '18', 'M', 'Cautitlán Izcalli, Edo. de Méx.', '5582052782', 'cocon_osito@outlook.es', 'aprender más acerca de Dios ', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('56', 'Erika Paola Espitia Morales', '13', 'C', 'Cuautitlán Izcalli, Edo. de Méx.', '5546193283', 'erikaloopsy@hotmailcom', 'Porque es una razón de acercarme a Dios, y poder aprender de manera dinámica.', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('57', 'Eduardo Emanuel Rodriguez Reza', '13', 'C', 'Cuautitlán Izcalli, Edo. de Méx.', '5532116768', 'luci151086@hotmail.com', 'Porque quiero aprender más cosas de Dios \r\n', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('58', 'Martha Laura Espitia Morales ', '16', 'C', 'Cuautitlán Izcalli, Edo. de Méx.', '5546193283', 'martylauris@live.com', 'Porque me agrada mucho la idea de compartir la palabra de Dios y conocer gente de todos lados.\r\nQUIERO QUE MI STAFF SEA ZURY!! <3 ', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('59', 'Brayan Eduardo Trejo Gonzalez ', '13', 'C', 'Cuautitlán Izcalli, Edo. de Méx.', '63066775', 'brayaneduardo194@gmail.com', 'Para aprender y divertirme :D', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('60', 'Paola Joana Montesinos Puga', '15', 'M', 'Cuautitlan Izcalli ', '5525630425', 'paola_Montesinos01@hotmail.com', 'Volver a encontrar la comunión con Dios y aprender de su palabra ', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('62', 'Sheila Bonilla.Ruiz', '23', 'M', 'Mas vida CDMX', '5518359606', 'borush.sb@gmail.com', 'Asistí el año pasado y descubrí una nueva manera de conectar con Dios, esta experiencia fue un parteaguas en mi vida y desde entonces solo.quiero aprender, amar, compartir y madurar más y más en él y para él.', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('63', 'Fatima Curiel', '17', 'M', 'Amistad Cristiana Las Americas', '445521081116', 'fatigol99@hotmail.com', 'Porque quiero aprender más sobre Dios y tener una vida en cristo', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('64', 'Juan de dios Rangel flores ', '13', 'M', 'san francisco del rincón gto', '4761236799', '', 'para vivir la experiencia de dios y conocer mas de su palabra', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('66', 'Citlalli Cortes Ortega', '14', 'C', 'Estado de México Ecatepec de Morelos', '5536319244', 'famicortes@yahoo.com.mx', 'Para conocer mas de mi padre Jesús, para aprender a servir con amor a los demás , para divertirme , para conocer a nuevas personas , para  ayudar a las personas con lo que aprendí . Y para no olvidarme de que Jesús siempre ha estado y  va ha estar conmigo', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('67', 'YIBRAN MERINO MARTINEZ', '15', 'M', 'ECATEPEC DE MORELOS , ESTADO DEMEXICO', '5520675724', 'yibran-08@hotmail.com', 'PARA TENER UN ENCUENTRO MAS CERCA CON LO QUE DIOS ME HABLA Y AL CUAL NECESITO ENCONTRAR UNA COMUNION MAS CON EL SEÑOR EL CUAL SE QUE YA ES TIEMPO DE HACER A DONDE ME LLAME EL SEÑOR.', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('68', 'Eduardo Lagos Mercado ', '0', 'M', '', '5523709647', '', 'Recomendarme.con Jesús y Dios ', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('69', 'Daniela Rergis Pérez Gallardo ', '17', 'G', 'Cd Mx', '5545762580', 'dannyrergis@hotmail.com', 'Quiero volver a encontrar el camino en Cristo, y tener una vida para el. ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('70', 'Saraí Guevara Solís', '18', 'C', 'San Francisco del Rincón, Gto', '4761459256', 'disney_529@hotmail.com', 'Una gran amiga me invito y decidí después de platicar con mis padres que es algo bueno para crecer como persona y para conocer mas de Dios.', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('71', 'Hugo Edrey Valadez Concha', '13', 'C', 'Ecatepec, Estado de México', '5523141959', 'miss.adrireyes@hotmail.com', 'Para conocer de Dios', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('72', 'Esdras Gadiel Resendiz Ortiz', '14', 'M', 'Cuautitlán Izcalli, Edo. de Méx.', '5539125894', 'flakita7931ao@gmail.com', 'porque quiero evangelizar, conocer gente, compartir del amor de Dios.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('73', 'Angelica Berenice TorresTorres', '24', 'C', 'Cuautitlán Izcalli, Edo. de Méx.', '5585041496', 'angelita_betsaida@hotmail.com', 'Para conocimiento más profundo del servicio, evangelismo y además por invitación.\r\n', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('74', 'Ariel Barrientos Esquivel', '18', 'M', 'Amistad Cristiana las Américas ', '+52557466851', 'aribe2699@gmail.com', 'Quiero llevar el mensaje de Dios a todas las naciones y así mismo aprender más de él para seguir su camino y tener palabra para predicar.', '\0', '\0', null, '1550', 'I', 'F');
INSERT INTO `guerreros2017` VALUES ('75', 'Adrián Bonilla Ruiz', '15', 'C', 'CDMX', '5514747749', 'boruroad@hotmail.com', 'Vine el año pasado y la experiencia fue muy padre \r\nMe gustaría repetir la ocasión', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('76', 'Jocelyn A. Grimaldo Alvarado', '20', 'M', 'Ciudad de Mexico', '5543693368', 'j-griim@outlook.com', 'Porque quiero seguir conociendo mas de Dios y sus planes. Y deseo pasar ese tiempo oyendo su voz.', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('79', 'Jose guadalupe ramirez ramirez', '17', 'M', 'Pachuca (PIB) ', '7713029020 ', 'josejr211@hotmail', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('80', 'Maria Solange Pardo Yañes ', '15', 'M', 'Mexico ', '5578469248', 'sol2092@gmail.com', 'Me interesa conocer mas de Dios ', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('81', 'Denisse Guadiana Alcantara ', '18', 'M', 'Mexico ', '5549423561', 'denigu99@hotmail.com', 'Me recomendaron el campamento ', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('82', 'Cristina Mitchel Mojica Ramire', '15', 'XG', 'San Francisco del Rincon Guanajuato', '4761356745', 'cristymora29@hotmail.com', 'Quiero descubrir cual es el proposito de Dios en mi vida.\r\nQuiero ser capas de decir y proclamar el nombre de Jesus como mi salvador.\r\nY conocer mas personas apacionadas por Jesus', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('83', 'JAEL ABRIL DE LEON HERNANDEZ', '14', 'C', 'AMISTAD CRISTIANA LAS AMERICAS', '5510520459', 'socorro.notwithstanding@gmail.com', 'Ya he ido y no me lo quiero perder. Aprendo mucho de Dios.', '\0', '\0', null, '1550', 'I', 'F');
INSERT INTO `guerreros2017` VALUES ('85', 'Benjamin J.Sanchez Aparicio', '16', 'G', 'acolmam estado d mexico', '5530110031', 'blancaestelaaparicio@gomail.com', 'quiero q conozca mas a dios... ya q su papa y yo tenemos muchos problemas y estoy conciente q solo nuestro padre celestial lo puede ayudar ,,, y no cuento con los recursos pero,,,, solo dios sabe como le balla hacer para juntar,,,,,', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('86', 'Eric Enoc Templos Arellano', '16', 'C', 'Real del Monte', '7713299127', 'eric.templos@yahoo.com', 'Quiero crecer mas en el ámbito espiritual?', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('87', 'Mariana Jamel Navarro Rangel', '15', 'C', 'San Francisco del Rincón Gto.', '4777545818', 'mariana.jam24@gmail.com', 'Es un campamento super padre, me encanto absolutamente todo, fui el año pasado y ha sido la mejor experiencia que he tenido en mi caminar con Cristo?\r\nY quiero volver a repetirlo, sé que será más inolvidable que la primer vez.', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('88', 'Benjamin Isaac godinez coss', '14', 'C', 'Guadalaja', '33 103 23 38', 'carmen.coss@enlaceoccidente.edu.mx', 'Quiero conocer más de Dios', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('89', 'Elijah Mark Johnson', '20', 'G', 'YWAM Pachuca', '228-342-9279', 'guitarfreak.johnson@gmail.com', 'STAFF DE JUCUM PACHUCA', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('90', 'Linette Yazmin Roldán Martínez', '2', 'C', 'Edo México ', '5538700200', 'linette.yazmin@hotmail.com', '¿por qué no? ????', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('91', 'Monica Zaldivar', '0', 'C', '', '', '', 'Buena noche\r\nTengo 3 hijos en edad de sistir al campamemto,  ellos están interesados; la información me la acaba de pasar una amiga y me interesa saber si habria opcion de un precio mas accesible para ver si puedo enviar a mis hijos.\r\nSon de 13, 16 y 18 a', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('92', 'Diana Negrete Calderón ', '13', 'C', 'Pachuca', '7712297949', 'ana.ale.green@gmail.com', 'aprender mas sobre Dios', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('93', 'Montserrat Quezada Fragoso', '15', 'C', 'Pachuca ', '7712186604', 'quezadamontse@gmail.com', 'Conocer más de Dios, ser un seguidor, y orar por las personas, disfrutar de la convivencia', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('94', 'Diana Sanchez Jimenez ', '20', 'XG', 'Mexico Ecatepec ', '', 'mari_15_rock@hotmail.com', 'entre a jucum en el 2014 o 2015 y tube un encuentro muy sercano con dios pero de un tiempo para aca tube una lejania y siento un bacio que me llama a volver a el , entonces mi regreso a jucum es plenamente para reconciliarme con mi Dios ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('95', 'Christopher Mancilla ', '14', 'C', 'Ciudad de México', '5538295443', 'chadmaro19@gmail.com', 'Me gustó al primer campamento de reto urbano e iré otra vez?????????', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('96', 'ANA LAURA PARRA CASTAÑEDA', '16', 'C', 'San Fransico del Rincon Guanaguato ', '4761272956', 'parra_anita@outlook.com', 'Conocer mas sobre Dios, llevar la palabra a la gente que no a conocido sobre el amor de dios y aprende nuevas consas ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('97', 'Daniela Angany Quiroz Vera', '13', 'M', 'Ciudad de mexico', '5554034494', 'solvera2110@gmail.com', 'Quiero un encuentro con  Dios quieto fortalecer mi fe y quiero caminar en caminos correctos y perdone mis faltas', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('98', 'Emmy Kim', '18', 'C', 'San Diego KUMC', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('99', 'Shinu Kang', '18', 'M', 'San Diego KUMC', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('100', 'Daniel Lee', '16', 'M', 'San Diego KUMC', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('101', 'Ryan Park', '16', 'M', 'San Diego KUMC', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('102', 'Curtis Huh', '16', 'M', 'San Diego KUMC', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('103', 'Raymond Kim', '23', 'M', 'San Diego KUMC', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('104', 'Pastor Dan Kim', '29', 'M', 'San Diego KUMC', '', '', '', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('105', 'Esther Kim', '18', 'C', 'San Diego KUMC', '', '', 'Tal vez no viene, es registrada, pero no sabemos si viene.', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('106', 'Pastor Matthew Kang', '29', 'M', 'Los Angeles, California -- Estados Unidos', '', '', '', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('108', 'Linda Kang (Lider)', '29', 'M', 'Los Angeles, California -- Estados Unidos', '', '', '', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('109', 'Shirley Lew', '18', 'C', 'Los Angeles, California -- Estados Unidos', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('110', 'Olivia Baek', '17', 'C', 'Los Angeles, California -- Estados Unidos', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('111', 'Julie Koh', '18', 'M', 'Los Angeles, California -- Estados Unidos', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('112', 'Justin Kim', '17', 'M', 'Los Angeles, California -- Estados Unidos', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('113', 'Daniel Baek', '15', 'M', 'Los Angeles, California -- Estados Unidos', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('114', 'Anna Caffey', '18', 'C', 'Church of the Good Shepherd, Mississippi ', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('115', 'Jordan Bennett', '3', 'M', 'Church of the Good Shepherd, Mississippi ', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('116', 'Lauren Stanford', '16', 'C', 'Church of the Good Shepherd, Mississippi ', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('117', 'Ian Cobb', '15', 'M', 'Church of the Good Shepherd, Mississippi ', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('118', 'Adam Johnson (lider)', '31', 'G', 'Church of the Good Shepherd, Mississippi ', '', '', '', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('119', 'Elizabeth Young', '22', 'G', 'Church of the Good Shepherd, Mississippi ', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('120', 'Michael Cassagne (lider)', '38', 'XG', 'Church of the Good Shepherd, Mississippi ', '', '', '', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('121', 'Benjamin Johnson', '16', 'M', 'Church of the Good Shepherd, Mississippi ', '', '', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('122', 'Bethany Johnson', '18', 'M', 'Church of the Good Shepherd, Mississippi ', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('123', 'Meghan Dineen', '33', 'M', '', '6691025959', 'meghan@ywammazatlan.com', 'Staff. :) (que la playera sea corte de hombre, talla M por fa.)', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('124', 'Uriel Vela Soto', '19', 'M', 'Tecámac, Estado de México', '5561111679', 'velhost22@gmail.com', 'Para encontrar más profundamente a Dios, su amor por mi y cómo vivir completamente para él.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('125', 'Benjamín Reyes González', '22', 'M', 'Puebla, México', '2221157014', 'benireyes.youth@gmail.com', 'Para conocer el corazón de Dios para mi durante este tiempo, aprender y compartir su amor con todos. ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('126', 'Nancy Gabriela González flores', '15', 'C', 'Ecatepec las americas', '5549569401', '', 'Porque quiero vivir una nueva experiencia y conocer mas de Dios ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('127', 'Aquetzalli Juárez Flores', '17', 'M', 'Mexico Ecatepec ', '5567831847', 'aquetzalli.juarez@gmail.com', 'Hola! Porque quiero volver a vivir la experiencia,el  RETO pasado me ayudo mucho a acercame mas a Dios y pues me gustaria volver a ir y seguir aprendido mas de Dios y seguir enamorándome de el ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('128', 'Israel (JAKE) Negrete Del Rio', '28', 'G', 'Ciudad de mexico', '5540738253', 'israel.negrete.delrio@gmail.com', 'Vuelvo a casa, a servir. Staff.', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('129', 'Mariel Solís Ortiz ', '16', 'G', 'Pachuca ', '771 3644174', 'duqueza_2009@hotmail.com', 'Mi llamado es misiones. Y quiero prepararme de la mejor manera posible para poder servirle! ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('130', 'Ricardo Nolasco Rebollo', '13', 'G', 'Cuautitlán Izcalli', '55 4320 3804', 'laverorebollo@hotmail.com', 'Para crecer primeramente con Dios, divertirme y ser mejor cada día.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('131', 'Ana Lucía Moctezuma Malacara', '28', 'M', 'Puebla', '2227587156', 'moktelux@gmail.com', ':3 Dios, Jesús. E.S.', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('133', 'Mariana Garte', '23', 'C', 'Estado de México', '5541339516', 'mgarciat@centro.edu.mx', 'Los años anteriores Dios ha trabajado profundamente en mi vida, lo he conocido más y este año sé que será igual. Y porque las relaciones que he establecido en reto han sido de total bendicion a mi vida. ', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('134', 'David Jorge Gómez González', '26', 'M', 'Mexido', '5518379492', 'david.isc.escom@gmail.com', 'Para dejar que crezca más a Dios en mi.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('135', 'Ana Gabriela García Guerrero', '26', 'C', 'Ciudad de México', '5554946662', 'ananorge1553@gmail.com', 'Estuve en reto de 2012 y 2013 cómo estudiante y en el 2014 fui staff. Este año quisiera servir como staff de nuevo. ', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('136', 'Aída Quintanar Vivanco', '23', 'C', 'Ciudad de México ', '5522587421', 'aida.quintanar@hotmail.com', 'Porque quiero conocer más de Dios, entregarme cada día más a ÉL', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('137', 'Marco Antonio Burbano Reyes', '22', 'C', 'Ciudad de México ', '5517560981', 'burbano_mrb@hotmail.com', 'Porque quiero conocer más a Dios, depender cada día más de ÉL', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('138', 'Ana Gabriela Chapa Quiroz', '14', 'M', 'Pachuca, Hidalgo', '771 1874977', 'gabrielachapa90@gmail.com', 'Compartir el Evangelio en las calles', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('139', 'pamela ceja unzaga', '18', 'G', 'mexico', '55 45370865', 'pamelacejau0904@gmail.com', 'para seguir mi proposito que Dios me dio en esta vida y completarlo y ayudar a muchas personas que nesesitan el espiritu de paternidad y el espiritu de adopcion que tenemos todos para glorificar el reino de Dios ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('140', 'Lucero Martinez Castañeda', '26', 'M', 'Pacguca', '7717722130', 'castaneda_lucero@hotmail.com', 'Esta bien chido ????', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('141', 'Jose Eugenio Herrera Gonzalez ', '28', 'M', 'Pachuca ', '7713433770', 'castaneda_lucero@hotmail.com', 'Para servir y aprender mas de Dios', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('142', 'Jony Buendía Pitalua', '28', 'M', 'Colombia', '771 219 6807', 'jony.buendia@ywampachuca.org', 'Soy Staff y me obligaron :v Jajajajaja ', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('143', 'Leslie Nicole De Los Santos Ov', '20', 'M', 'México, Puebla.', '2226093603', 'santosoviedoleslie@gmail.com', 'Por una invitación en mi iglesia, y porque quiero conocer la voluntad de Dios para mi vida. ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('144', 'Lexica Dayana López Pérez ', '19', 'G', 'Pachuca Hidalgo', '7713303084', 'pumas_ricardo_@hotmail.com', 'Poder obtener un encuntro con Dios y talvez si el lo permite encontrar mi proposito, poder aprender poder seguirlo y poder ayudar a quien lo necesita.\r\n', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('145', 'Efrain Fonseca Andrade', '18', 'M', 'Iglesia Bethel Orizatlan Hidalgo ', '', '', 'Invitado', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('146', 'Josue Olvera García ', '24', 'M', 'Iglesia Bethel  Huitzi', '', 'richjucum@gmail.com', 'Inv', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('147', 'Citlali Perez Martinez', '37', 'C', 'Jucum Pachuca ', '', 'citlalijucum@gmail.com', 'Staff', '', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('148', 'Richz Volta', '42', 'M', 'Europa', '', 'richjucum@gmail.com', 'Siervo ', '', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('149', 'MARÍA PAOLA LIÑAN LANDEROS ', '15', 'C', 'SAN PANCHO ', '4775201866', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('150', 'Keila Sarai Mendoza Rivera', '21', 'C', 'Primera Iglesia Bautista Pachuca', '7711405331', 'keimr95@gmail.com', 'Prepararme para servir en la obra de Dios', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('151', 'Ricardo Mendoza Rivera', '20', 'C', 'Primera Iglesia Bautista Pachuca', '7712322858', 'pumas_ricardo_@hotmail.com', 'para servir al Reino de Dios', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('152', 'Evan Daniel Hernández Perez', '12', 'C', 'Pachuca', '777 444 8213', 'evannet099@gmail.com', 'Quiero aprender más de Dios y divertirme\r\nMÁS DE EL MENOS DE MI!!! ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('153', 'Karla Montiel Solis', '20', 'C', 'Pachuca PIB', '7711841763', 'karla.montiel@hotmail.es', 'Porque me gustaría aprender herramientas para evangelizar en la ciudad ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('154', 'Edwin Michel Acosta Acosta', '17', 'M', 'Edo. de Méx.', '', 'reyseka@gmail.com', 'Asisti hace un año, y quiero volver a vivirlo!!! SENTIR A DIOS EN MI <3', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('155', 'joel templos', '21', 'C', 'pachuca hgo ', '7711406444', 'templos_13@hotmail.com', 'para fortalecer mi relación con Dios con ayuda de lideres ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('156', 'Pereira Romero Jahaziel Yamil ', '19', 'G', 'Ecatepec de Morelos ', '', 'jahazielypr@gmail.com', '', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('157', 'Juan Carlos Ordaz Díaz ', '27', 'M', 'Pachuca (PIB Pachuca)', '7712398182', 'juancarlos.ordazdiaz@yahoo.com.mx', 'Porque quiero impactar a mi generación. ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('158', 'Angel Eduardo ', '14', 'G', 'PIB', '', 'angel20primeroc@gmail.com', 'Me gusta conocer más a Dios ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('159', 'Elias Solis Ortiz', '15', 'XG', 'Pachuca,Hidalgo', '771-356-1345', 'eliashatake02@gmail.com', 'Quiero hacer un impacto en mi ciudad con la palabra de Dios y quiero corresponder a algo que Jesús manda en su palabra\r\n', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('160', 'Rubi Templos Meneses ', '16', 'M', 'Pib Pachuca ', '7713484569', 'rubi_templos_123@hotmail.com', 'Para aprender aun más de Dios \r\nY mejorar mi relación con el ', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('161', 'JOSUÉ JUÁREZ SANJUÁN', '28', 'C', 'Pachuca de Soto, Hgo  (PIB PACHUCA)', '7717008848', 'jos_19cri@hotmail.com', 'Conocer más de Dios, para servirle y obedecerle. ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('162', 'Daniel Lugo Cepeda', '17', 'G', 'Pachuca Hidalgo', '7712412141', 'daniellugocepeda@outlook.es', 'Para conocer mas de Dios', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('163', 'Israel Hernández Gonzáles', '13', 'M', 'Estado de México', '5562258022', 'eric.templos@yahoo.com', 'Soy recomendado.', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('164', 'Israel Hernández Gonzáles', '13', 'M', 'Estado de México', '5562258022', 'eric.templos@yahoo.com', 'Soy recomendado.', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('165', 'Martha Deyra Romero Templos', '28', 'C', 'Pachuca', '7711541230', 'martharomero_templos@hotmail.com', 'A apoyar como staff, ayudar en lo que se necesite...\r\n\r\nEscuchar lo que Dios hablara a mi vida, a través no solo de las enseñanzas sino también de los chavos que asistan, convivir con gente con la misma fe.', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('166', 'JOSUE CHAVEZ BARRERA', '18', 'M', 'PACHUCA', '7713484061', 'joshy.gear61@gmail.com', 'Porque mi mama quiere que me  acerque a dios y que lo conozca y dicen que es chido este campamento.', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('167', 'Seni Guadalupe Castillo Guerre', '12', 'G', 'Estado de México', '5520666421', 'castilloguerrero@gmail.com', 'Voy porque quiero conocer más de Dios y soltar todas mis cargas, quiero poder sanar mi corazón y seguir adelante, quiero ayudar a otras personas. ', '\0', '\0', null, '1550', 'F', 'F');
INSERT INTO `guerreros2017` VALUES ('168', 'Ruben Templos Meneses ', '20', 'M', 'Real del Monte (Hidalgo. Mexico )', '7713260254', 'templos4.5@hotmail.com', 'Porque desde que vine la primera ves Dios cambio el rumbo de mi vida para siempre. Es un lugar donde literal puedes vivir una semana hombro a hombro con Dios aparte de ser una experiencia única ya que no solo cambia sino transformas el medio que te rodea ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('169', 'Emily Kim', '17', 'C', 'Los Angeles, California -- Estados Unidos', '', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('170', 'YIREL PEREIRA', '17', 'C', '', '5540346755', '', 'MEXICO', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('172', 'Luis Becerra alatorre', '19', 'C', 'México ', '7641032339', 'alatorreluis16@icloud.com', 'Diversión y conocer nuevas personas ', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('173', 'David Guagiqna Alcantara', '12', 'M', 'Mexico', '', 'marisol692391@gmail.com.mx', 'Me lo recomendaron mucho', '\0', '\0', null, '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('175', 'María Fernanda liñan landeros ', '15', 'C', 'SAN PANCHO ', '4775201875', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('176', 'María milagros liñan landeros ', '15', 'M', 'San pancho ', '4775201841', '', '', '\0', '\0', null, '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('177', 'Rodrigo Cortés Ortega ', '17', 'G', 'Mexico', '5566656433', 'rodrigo.corort@hotmail.com', 'Conocer más de la palabra, aprender a compartir y a tener una mejor comunión con el Señor ', '\0', '\0', null, '1550', 'B', 'M');
INSERT INTO `guerreros2017` VALUES ('178', 'Citlalli Cortés Ortega ', '14', 'C', 'Mexico', '5536319244', 'citlalli.cortesortega@gmail.com', 'Quiero acercarme más a la presencia del Señor , quiero servir a los demás  y tener más fe y confianza en el ', '\0', '\0', null, '1550', 'B', 'F');
INSERT INTO `guerreros2017` VALUES ('182', 'Diego Miguel Brito García ', '21', 'XG', 'Ecatepec', '5644945008', 'diegobg52@gmail.com', 'Aprender más sobre Dios y sobre evangelizmo ', '\0', '\0', '', '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('183', 'Josué baruc Correa Meléndez ', '19', 'XXG', '', '', 'Josuebarucc6@gmail.com', 'Por que quiero servirle al señor Jesús quiero partisipar \r\n', '\0', '\0', '', '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('184', 'Christopher Mancilla Rodríguez', '14', 'C', 'Ciudad de México', '5538295443', 'chadmaro15@gmail.com', '', '\0', '\0', '', '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('185', 'Eriday Cordova Vidals', '39', 'C', 'Puebla', '2222161975', '', '', '\0', '\0', '', '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('186', 'Justo Varela Osorio', '38', 'XG', 'Puebla', '', '', '', '\0', '\0', '', '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('187', 'MARÍA PAOLA LIÑAN LANDEROS ', '15', 'C', 'SAN FRANCISCO DEL RINCÓN ', '4775201866', '', '', '\0', '\0', '', '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('188', 'Michelle  Paulina Zubillaga ', '17', 'M', 'Mexico', '', '', '', '\0', '\0', '', '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('189', 'Ximena Danaé Jaén Moeno', '15', 'C', 'Pachuca Hidalgo (PIB)', '7711900993', 'Benleon7@gmail.com', 'Porque quiero conocer más de cristo', '\0', '\0', '', '1550', 'A', 'F');
INSERT INTO `guerreros2017` VALUES ('190', '', '0', '', '', '', '', '', '\0', '\0', '', '1550', 'A', '');
INSERT INTO `guerreros2017` VALUES ('191', '', '0', '', '', '', '', '', '\0', '\0', '', '1550', 'A', '');
INSERT INTO `guerreros2017` VALUES ('192', '', '0', '', '', '', '', '', '\0', '\0', '', '1550', 'A', '');
INSERT INTO `guerreros2017` VALUES ('193', 'Joel Manuel Jaén Moreno ', '18', 'G', 'Pachuca ', '', '', '', '\0', '\0', '', '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('194', 'Joel Manuel Jaén Moreno ', '18', 'G', 'Pachuca Hidalgo (PIB)', '7712291221', 'jaenmorenojoelmanuel4@gmail.com', 'Mi iglesia es cede.', '\0', '\0', '', '1550', 'A', 'M');
INSERT INTO `guerreros2017` VALUES ('195', '', '0', '', '', '', '', '', '\0', '\0', '', '1550', 'A', '');
INSERT INTO `guerreros2017` VALUES ('196', '', '0', '', '', '', '', '', '\0', '\0', '', '1550', 'A', '');

-- ----------------------------
-- Table structure for guerreros2018
-- ----------------------------
DROP TABLE IF EXISTS `guerreros2018`;
CREATE TABLE `guerreros2018` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `talla` varchar(3) DEFAULT NULL,
  `vienede` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(12) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `razones` varchar(255) DEFAULT NULL,
  `staff` bit(1) DEFAULT NULL,
  `confima_pago` bit(1) DEFAULT NULL,
  `nomero_ticket` varchar(50) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT 1550,
  `status` varchar(1) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `alergias` varchar(255) DEFAULT NULL,
  `fechanac` date DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=254 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros2018
-- ----------------------------
INSERT INTO `guerreros2018` VALUES ('4', 'Luz Alejandra Mendoza Camacho', '19', 'C', 'Estado de Mexico', '5540783508', 'alejandramendozac@outlook.com', 'Amo Reto Urbanooo y estoy emocionada por que llegue el campamento Dios es tan bueno que me da la oportunidad de estar un año mas en El Campamento Reto Urbano????', '', '\0', '', '1550', 'A', 'F', 'Ale Mendoza', 'Ninguna ', '1999-03-31');
INSERT INTO `guerreros2018` VALUES ('5', 'Steve Garrett', null, 'G', 'Nashville TN ', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', 'Steve Garrett', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('6', 'Milissa Garrett', null, 'C', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'F', 'Milissa Garrett', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('7', 'Ethan Garrett', '19', 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', 'Ethan Garrett', '', '1999-01-01');
INSERT INTO `guerreros2018` VALUES ('8', 'Gabriel Garrett', '15', 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '2003-01-01');
INSERT INTO `guerreros2018` VALUES ('9', 'Abigail Garrett', '10', 'C', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'F', '', '', '2008-01-01');
INSERT INTO `guerreros2018` VALUES ('10', 'Sophia Garrett', '10', 'C', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'F', '', '', '2008-01-01');
INSERT INTO `guerreros2018` VALUES ('11', 'Jonathan Puckett', null, 'XG', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('12', 'Tiffany Puckett', null, 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'B', 'F', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('13', 'Hailey Puckett', '16', 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'B', 'F', '', '', '2001-06-14');
INSERT INTO `guerreros2018` VALUES ('14', 'Jack Puckett', '13', 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '2005-04-09');
INSERT INTO `guerreros2018` VALUES ('15', 'Ben Womer', null, 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('16', 'Landyn Stolzfus', '15', 'G', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '2003-01-01');
INSERT INTO `guerreros2018` VALUES ('17', 'Joey Stolzfus', null, 'G', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('18', 'Joanna Fowler', null, 'G', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'F', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('19', 'Noah Phillips', '17', 'G', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '2001-01-01');
INSERT INTO `guerreros2018` VALUES ('20', 'Amy Phillips', null, 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'F', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('21', 'Garrett Watkins', '15', 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'M', '', '', '2003-01-01');
INSERT INTO `guerreros2018` VALUES ('22', 'Joyelle Watkins', '17', 'C', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'B', 'F', '', '', '2001-01-01');
INSERT INTO `guerreros2018` VALUES ('23', 'Eleanna Weaver', '15', 'M', 'Nashville TN', '615-496-1075', 'jonathanlpuckett@gmail.com', 'A', '\0', '\0', '', '1550', 'A', 'F', '', '', '2003-01-01');
INSERT INTO `guerreros2018` VALUES ('24', 'Jocelyn Abigail Grimaldo Alvar', '21', 'C', 'Ciudad de México', '5543693368', 'j-griim@outlook.com', 'Quiero tomar el Reto, descubrir lo que Dios tiene para hablarme y mostrarme.', '\0', '\0', '', '1550', 'B', 'F', 'Abigail', 'Alergias al polvo y al estambre, pero ninguna es muy fuerte o requiere medicamento especial. ', '1997-03-22');
INSERT INTO `guerreros2018` VALUES ('25', 'Erika I. Pérez Gallardo S.', '26', 'G', 'México', '5551737136', 'epgs_sk@hotmail.com', 'Quiero profundizar en mi relación personal con Dios por medio del aprendizaje de nuevas formas/técnicas para poder hacerlo.', '\0', '\0', '', '1550', 'B', 'F', 'Erika', 'Asma, alergias', '1991-07-04');
INSERT INTO `guerreros2018` VALUES ('26', 'Dan Kim', '30', 'M', 'San Diego KUMC', '5712363831', 'dankim06@gmail.com', 'We came last year and we will be bringing another team from San Diego KUMC. ', '\0', '\0', '', '1550', 'A', 'M', 'Pastor Dan ', 'None', '1987-11-11');
INSERT INTO `guerreros2018` VALUES ('27', 'Fernanda Montserrat Martïnez C', '15', 'C', 'Pachuca, Hidalgo', '7712142319', 'fernandacanto02@gmail.com', 'Para poder conocer a Dios de una forma nueva y mucho más profunda. ', '', '\0', '', '1550', 'A', 'F', 'Fernanda ', '', '2003-02-05');
INSERT INTO `guerreros2018` VALUES ('28', 'Saúl Josadac Jiménez Sánchez', '15', 'XG', 'Estado de México', '5566239617 ', 'ojosadac1@gmail.com', 'Me llama la atención la ayuda comunitaria y conocer personas de diferentes países.', '\0', '\0', '', '1550', 'A', 'M', 'Josadac', 'Sin alergias', '2002-06-18');
INSERT INTO `guerreros2018` VALUES ('29', 'Karen Gomez', '22', 'C', 'Pachuca', '7711564089', 'karen.gm96@hotmail.com', 'por que tengo un contrato xD', '', '\0', '', '1550', 'A', 'F', 'Mamá Karen', 'Ño', '1996-01-06');
INSERT INTO `guerreros2018` VALUES ('30', 'Dulce Mariana  Garcia Trinidad', '18', 'M', 'Estado de México', '5577232285', 'jessy1860@hotmail.com', 'Conocer a DIOS', '\0', '\0', '', '1550', 'B', 'F', 'Mariana', 'negadas', '1999-08-16');
INSERT INTO `guerreros2018` VALUES ('31', 'Karla Marymar Garcia Trinidad', '15', 'C', 'Estado de México', '5577532879', 'jessy1860@hotmail.com', 'Vivir una experiencia mas con DIOS', '\0', '\0', '', '1550', 'B', 'F', 'Marymar', 'penicilina', '2002-07-07');
INSERT INTO `guerreros2018` VALUES ('32', 'Mariana Jamel Navarro Rangel', '16', 'C', 'San Francisco del Rincón Guanajuato ', '4775804325', 'mariana.jam24@gmail.com', 'Es un campamento increíble, quiero seguir creciendo mucho más en Jesús, por lo cual creo que RU es el indicado para hacerlo ya que las veces que he ido realmente ha transformado mucho de mí?? Además de que es un tiempo donde Dios te habla mucho.', '\0', '\0', '', '1550', 'A', 'F', 'Mariana Jamel', 'Ninguna!!', '2001-09-24');
INSERT INTO `guerreros2018` VALUES ('33', 'Carlos caudillo baños', '20', 'M', 'CDMX', '7228555123', 'charlicaudillob@gmail.com', 'Para tener una experiencia única con Dios ', '', '\0', '', '1550', 'A', 'M', '', '', '1998-01-16');
INSERT INTO `guerreros2018` VALUES ('34', 'pamela ceja unzaga', '19', 'XG', 'cuidad de mex ', '5545370865', 'pamelacejau0904@gmail.com', 'Para conocer mas intimamente a dios y tener una relacion con dios y darlo a conocer ', '', '\0', '', '1550', 'A', 'F', 'pame?', 'Penicilina (alerjia)\r\nMedicamento\r\nvalproato de magnecio de 200\r\nQueitipina de 25', '1999-04-09');
INSERT INTO `guerreros2018` VALUES ('35', 'Saraí Guevara Solís', '19', 'C', 'San Francisco del Rincón, Gto.', '4767380710', 'disney_529@hotmail.com', 'Aprender mas de Dios, convivir con personas que les gusta saber de Dios', '\0', '\0', '', '1550', 'A', 'F', 'Sara', '', '1998-12-22');
INSERT INTO `guerreros2018` VALUES ('36', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('37', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('38', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('39', 'Benjamin Johnson', '16', 'M', 'Missippi, USA', '2283632689', 'zeph.three.seventeen@gmail.com', 'I am looking forward to returning this year because I loved Mexico the last time I attended Reto in 2017.  ', '\0', '\0', '', '1550', 'A', 'M', 'Benjamin Johnson', 'N/A', '2001-05-23');
INSERT INTO `guerreros2018` VALUES ('40', 'NOE samuel Galloso Hernandez ', '21', 'M', 'Pachuca', '7713022849', 'clasic.14sam@hotmail.com', 'Quiero saber el llamado de Dios ami vida, quiero estar presente y llevar el mensaje de amor al mundo, ', '\0', '\0', '', '1550', 'B', 'M', 'Samy Galloso ', 'Alergia al polen y al gluten ', '1997-02-06');
INSERT INTO `guerreros2018` VALUES ('41', 'Armando Arath Lara Suarez', '16', 'G', 'Las Americas, Ecatepec de Morelos.', '5510484805', 'arath-lara@outlook.es', 'El año pasado fui y me gusto. \r\nYo creo que es importante aprender formas de Evangelizar ya que te ayudan en otras ocasiones como cuando sales a la calle con tu iglesia.\r\ny creo que es necesario tener una relación con Dios.', '\0', '\0', '', '1550', 'A', 'M', 'Arath Lara', '', '2001-08-15');
INSERT INTO `guerreros2018` VALUES ('42', 'Carlos Alejandro Juárez Moreno', '23', 'XG', 'Pachuca ', '7711392692', 'cajuarez0806@hotmail.com', 'Conocer nueva gente y hacer nuevos amigos ', '\0', '\0', '', '1550', 'B', 'M', 'Alejandro Juárez Moreno ', '', '1994-08-06');
INSERT INTO `guerreros2018` VALUES ('43', 'Luis Ángel Ortiz Rodríguez', '19', 'M', 'Estado de México', '5576061779', 'orttiz46@gmail.com', 'Para conocer', '\0', '\0', '', '1550', 'A', 'M', 'Luis', 'Ninguna', '1999-04-22');
INSERT INTO `guerreros2018` VALUES ('44', 'Rachael Hyun', '16', 'G', 'San Diego', '8582761674', 'hyun.rachael@gmail.com', 'For Mexico mission trip.', '\0', '\0', '', '1550', 'A', 'F', 'Rachael Hyun', 'None', '2001-07-08');
INSERT INTO `guerreros2018` VALUES ('45', 'Curtis Huh', '16', 'M', 'San Diego', '858-212-4891', 'curtishuh@gmail.com', 'For mexico missions', '\0', '\0', '', '1550', 'A', 'M', 'Curtis Huh', 'Gatos', '2001-08-13');
INSERT INTO `guerreros2018` VALUES ('46', 'Raymond Lee', '24', 'M', 'San Diego', '8584446160', 'raymoondo10@gmail.com', 'I want to serve in Mexico as a long term missionary.  I came to reto last year and I want to go again this year.  Also I want some dank tortas.', '\0', '\0', '', '1550', 'A', 'M', 'Raymond Lee', 'none', '1994-02-01');
INSERT INTO `guerreros2018` VALUES ('47', 'Samantha Dionisio Romero ', '22', 'C', 'La Ciudad de México ', '5567627638', 'zprsamy@hotmail.com', 'Seguir aprendiendo de Dios\r\nY servirle de corazón!! ', '', '\0', '', '1550', 'A', 'F', 'Sam ', 'Sulfametoxazol', '1996-03-16');
INSERT INTO `guerreros2018` VALUES ('48', 'Maciel salas romero', '16', 'C', 'Ecatepec estado de México ', '5525264159', 'vero.romero.salas@hotmail.com', 'Para servir a Dios ', '\0', '\0', '', '1550', 'A', 'F', 'Maci', '', '2001-12-31');
INSERT INTO `guerreros2018` VALUES ('49', 'Isaac Moises Epinosa Gonzalez', '20', 'G', 'CDMX', '5581323680', 'isaac.espinosa151197@gmail.com', 'Invitacion y ademas regresar a Dios y hacer su voluntad de una vez por todas.', '\0', '\0', '', '1550', 'B', 'F', 'Momoy', '', '1997-11-15');
INSERT INTO `guerreros2018` VALUES ('50', 'Corina Garcia de Grosso', '41', 'M', 'Ensenada, BC', '6192073251', 'corigarcia@gmail.com', 'JuCUM Pachuca y el Reto Urbano ocupan gran parte de mi corazon y creo firmemente que Dios ha levantado a grandes lideres en este programa.  Quiero seguir siendo parte de lo que Dios esta haciendo en Pachuca!!  Tambien para re conectar con viejos amigos. ', '', '\0', '', '1550', 'A', 'F', 'Cori', 'Ninguna', '1976-09-03');
INSERT INTO `guerreros2018` VALUES ('51', 'Neil Grosso', '34', 'XG', 'Ensenada, BC', '6192073251', 'neil.grosso@ywamsdb.org', 'Helping to co lead the kids from Ensenada. Excited to see those kids grow closer to God and have an impact in another city not their own. ', '', '\0', '', '1550', 'A', 'M', 'Neil', 'None', '1983-08-05');
INSERT INTO `guerreros2018` VALUES ('52', 'Oscar Carrasco Ortega', '36', 'G', 'Ensenada, BC', '6192073247', 'oscar.carrasco@ywamsdb.org', 'Para crecer en Dios y conocer diferentes ministerios, e ir a una base nueva para mi. ', '\0', '\0', '', '1550', 'A', 'M', 'Oscar', 'Ninguna', '1981-11-21');
INSERT INTO `guerreros2018` VALUES ('53', 'Kirsten Ann Hill', '31', 'G', 'Ensenada, BC', '6462384633', 'oscarandkirsty@hotmail.com', 'Para crecer en mi relación con Dios y compartir su esperanza con otros.', '\0', '\0', '', '1550', 'A', 'F', 'Kirsty', 'Gatos y perros.  ', '1986-06-26');
INSERT INTO `guerreros2018` VALUES ('54', 'Brandon Kaleta', '16', 'XG', 'San Diego, California', 'none', 'brandino111@gmail.com', 'To get closer to God through mission trip', '\0', '\0', '', '1550', 'A', 'M', 'Brandon', 'None', '2001-12-01');
INSERT INTO `guerreros2018` VALUES ('55', 'Ana Laura Parra Castañeda', '17', 'C', 'Guanajuato ', '4761252648', 'Anita108_parra@outlook.com', 'Para aprender más de las cosas de Dios,su propósito que tiene en cada una de las personas y para tener más comunicación con Dios', '\0', '\0', '', '1550', 'A', 'F', 'Anita Parra ', 'Carne de puerco ', '2001-04-18');
INSERT INTO `guerreros2018` VALUES ('56', 'Jose Antonio Rubio Gonzalez', '16', 'M', 'Las americas Ecatepec , Edo  de Mexico', '5532667837', 'jr717531@gmail.com', 'Por Amor y Obediencia a Dios y por cumplir su propósito en mi vida', '', '\0', '', '1550', 'A', 'M', 'Toño', 'Ninguna', '2002-05-17');
INSERT INTO `guerreros2018` VALUES ('57', 'Edwin Michel Acosta Acosta', '18', 'M', 'Estado De México', '5566881574', 'reyseka@gmail.com', 'Darme un descanso y que mas mejor pleno en Dios.', '\0', '\0', '', '1550', 'A', 'M', 'Edwin Acosta', 'Ninguna...', '1999-09-09');
INSERT INTO `guerreros2018` VALUES ('58', 'Rachel Sunyoung Maile Kim', '17', 'G', 'Carlsbad, California', '7602745274', 'mailekim15@gmail.com', 'I want to attend RU because I want to build relationships with other people in God\'s kingdom, and to share His love with others! Also, my sister and other church members went last year, and hearing about their experiences really touched me.', '\0', '\0', '', '1550', 'A', 'F', 'Maile Kim', 'none', '2001-03-15');
INSERT INTO `guerreros2018` VALUES ('59', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('60', 'Neitan Morales', '30', 'XG', 'CDMX', '7712072048', 'neitan.morales@gmail.com', 'pus nomás', '', '\0', '', '1550', 'A', 'F', 'Excelentisimo Teofilo', 'las mentiras de mi ex...', '1987-10-29');
INSERT INTO `guerreros2018` VALUES ('61', 'Ana Elena López Carmona', '26', 'C', 'San Francisco del R., Gto.', '4761015340', 'anelena@cdoiglesia.com', 'Para mí, Reto es un espacio de refrigerio, edificación y encuentro con personas extraordinarias, que considero parte de mi familia espiritual. Deseo además animar a los chicos de mi ciudad a que me acompañen y vivan esta experiencia.', '', '\0', '', '1550', 'A', 'F', 'Anelena', 'Ninguna identificada.', '1991-12-15');
INSERT INTO `guerreros2018` VALUES ('62', 'CAROLINA ROSAS AGUILAR', '27', 'G', 'PACHUCA', '7711784114', 'carolinarosas30@gmail.com', 'para alejarme del bullicio de la ciudad', '', '\0', '', '1550', 'A', 'F', 'CARO', 'Un hijo...', '1991-04-30');
INSERT INTO `guerreros2018` VALUES ('63', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('64', 'Alejandra Pimentel Gracida', '16', 'M', 'Ensenada, BC', '6462559822', 'alepimentelgra@gmail.com', 'Porque quiero conocer más acerca de Dios y ser una influencia también para ellos de lo que Dios puede hacer en sus vidas', '\0', '\0', '', '1550', 'A', 'F', 'Hannah', 'Ataques epilépticos/ Atemperator ', '2002-01-03');
INSERT INTO `guerreros2018` VALUES ('65', 'María Guadalupe Santiago balan', '14', 'C', 'Ensenada, BC', 'n/a', 'kirsty.carrasco@ywamsdb.org', 'Yo voy a reto urbano por que quiero tener una mejor relación con Dios y conocer más de el', '\0', '\0', '', '1550', 'A', 'F', 'Lupita', 'Ninguna alergia, estoy tomando naproxeno', '2004-01-02');
INSERT INTO `guerreros2018` VALUES ('66', 'Carlos Balanzar Loreto', '16', 'M', 'Ensenada, BC', '6462384736', 'carlosbalanzar2@gmail.com', 'Para conocer más a Dios', '\0', '\0', '', '1550', 'A', 'M', 'Carlos', 'Ninguno', '2001-11-04');
INSERT INTO `guerreros2018` VALUES ('67', 'Carlos Balanzar Loreto', '16', 'M', 'Ensenada, BC', '6462384736', 'carlosbalanzar2@gmail.com', 'Para conocer más a Dios', '\0', '\0', '', '1550', 'B', 'M', 'Carlos', 'Ninguno', '2001-11-04');
INSERT INTO `guerreros2018` VALUES ('68', 'Maria Fernanda Pimentel Gracid', '17', 'G', 'Ensenada, BC', 'n/a', 'fp21355591@gmail.com', 'Por que quiero saber y compartir lo poco o lo mucho que se de dios y poder hay usar a otras personas.', '\0', '\0', '', '1550', 'A', 'F', 'Fernanda', 'Alergias: carne de puerco', '2000-06-04');
INSERT INTO `guerreros2018` VALUES ('69', 'Zuli Madai Ramirez Jimenez ', '14', 'C', 'Ensenada, BC', '6461626763', 'kirsty.carrasco@ywamsdb.org', 'Por que es la forma que creo que lo poco que yo se puedo compartir y me pueden enseñar a cambiar más y más Y se que puedo ir mejorando cada vez más.', '\0', '\0', '', '1550', 'A', 'F', 'Zuli', 'Ninguna', '2004-04-23');
INSERT INTO `guerreros2018` VALUES ('70', 'Braulio Aarón Lara Suárez.', '15', 'M', 'Amistad Cristiana Las Americas.', '5527591377', 'braulara712@gmail.com', 'Para seguir conociendo a Dios, y el proposito que tiene para mi. ', '\0', '\0', '', '1550', 'A', 'M', 'Brau', 'Ninguno.', '2002-10-30');
INSERT INTO `guerreros2018` VALUES ('71', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('72', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('73', 'Victor Allan Jaen Reyes', '15', 'C', 'México, ecatepec de modelos ', '5558956910', 'allanjaen0@gmail.con', 'Conocer mas a Dios y para servirle ', '', '\0', '', '1550', 'A', 'M', 'Allan', 'No', '2002-07-08');
INSERT INTO `guerreros2018` VALUES ('74', 'Luis Angel Mendoza Camacho', '16', 'M', 'México ', '5512428193', 'mendozacamacholuis_20@outlook.com', 'aprender y servir a Dios', '', '\0', '', '1550', 'A', 'M', 'Luis ', '', '2001-12-20');
INSERT INTO `guerreros2018` VALUES ('75', 'Ángel Eduardo Granados Perez', '15', 'G', 'Pachuca', '7712797263', 'angel20primeroc@gmail.com', 'Para conocer más sobre la palabra y poner todo\r\nEn la manos de Dios', '', '\0', '', '1550', 'A', 'M', 'Ángel', 'Alergia al polvo\r\nY Gracias a Dios nada más????', '2003-02-18');
INSERT INTO `guerreros2018` VALUES ('76', 'Marian Valeria Sánchez Tenorio', '18', 'M', 'México ', '5535256212', 'mariansanchezt@gmail.com', 'Soy lider y amor reto', '', '\0', '', '1550', 'A', 'F', 'Marian ST', 'Sulfas', '1999-12-18');
INSERT INTO `guerreros2018` VALUES ('77', 'Cinthya Escamilla', '17', 'M', 'Ciudad de México', '5530779309', 'cinthyaescamilla00@gmail.com', 'Una amiga me recomendo esto como una forma de conectarme conmigo misma y Dios y encontrar un propósito.', '\0', '\0', '', '1550', 'B', 'F', 'Cinthya Escamilla', 'Gentamicina y amicacina.', '2000-11-14');
INSERT INTO `guerreros2018` VALUES ('78', 'Salma Isabel Martínez Calderón', '16', 'M', 'Pachuca', '7713435446', 'salma.marca@gmail.com', 'Desde que tengo memoria uno de los sueños más intensos que ha puesto Dios en mi vida es el de ser misionera y llevar su palabra a otros lugares, tengo algunos amigos misioneros que me han platicado de sus experiencias y me han animado a seguirme preparand', '\0', '\0', '', '1550', 'A', 'F', 'Salma', '', '2001-12-24');
INSERT INTO `guerreros2018` VALUES ('79', 'Adrián Bonilla Ruiz', '16', 'C', 'Edo. Mex', '5568654025 ', 'boruroad@hotmail.com', 'Porque quiero crecer aun más en Dios \r\nY porque va a estar muy bueno todo c:', '', '\0', '', '1550', 'A', 'M', 'Adrián ', 'Nope', '2001-11-26');
INSERT INTO `guerreros2018` VALUES ('80', 'Sara Betsabe Vázquez Olivares ', '16', 'M', 'CDMX', '5534550186', 'vazsar18@gmail.com', 'Aprender, enseñar, conocer ', '\0', '\0', '', '1550', 'A', 'F', 'Betsabe ', 'Ningún problema ', '2001-06-18');
INSERT INTO `guerreros2018` VALUES ('81', 'Fatima Curiel Armenta', '18', 'M', 'Amistad Cristiana Las Americas', '445521081116', 'fatigol99@hotmail.com', 'Quiero seguir aprendiendo de Dios y lo que seguirá mostrando a mi vida.Ademas quiero ver  lo que Dios tiene para este campamento.', '', '\0', '', '1550', 'A', 'F', 'Curi ', '', '1999-09-03');
INSERT INTO `guerreros2018` VALUES ('82', 'De León Hernández Jael Abril ', '15', 'C', 'Las Américas, México ', '5584177730', 'jael_decorazon10@hotmail.con', 'Porque amo a Dios y quiero sevirle. ', '', '\0', '', '1550', 'A', 'F', 'Jael De León ', 'Paracetamol y Naproxeno ', '2002-10-23');
INSERT INTO `guerreros2018` VALUES ('83', ' Jahaziel Yami Pereira Romero ', '20', 'XG', 'Ecatepec de Morelos ', '5583046771', 'jahazielypr@gmail.com', 'Aprender y ser mejor ', '', '\0', '', '1550', 'A', 'M', 'Jahaziel Pereira ', '', '1997-10-20');
INSERT INTO `guerreros2018` VALUES ('84', 'Kerri Ann Mathews', '20', 'C', 'YWAM Ensenada', 'N/A', 'Kerrimathews7@gmail.com', 'I want to be a part of what God is gonna do in these students lives.', '\0', '\0', '', '1550', 'A', 'F', 'Kerri ', 'None', '1997-11-07');
INSERT INTO `guerreros2018` VALUES ('85', 'César Pérez Balanzar ', '17', 'G', 'Ensenada, BC', '6461464852', 'cesarperes13@hotmail.com', 'Para conocer más De Dios y conocer a otras personas y otros lugares ', '\0', '\0', '', '1550', 'A', 'M', 'César', 'Ninguna', '2000-08-16');
INSERT INTO `guerreros2018` VALUES ('86', 'Elena Gabriela Bustos Hernande', '13', 'C', 'Tizayuca, Hgo', '7751557295', 'brillantetita@hotmail.com', 'Dar otro paso, es tiempo de cumplir la gran comisión y aprender más de Dios.', '\0', '\0', '', '1550', 'A', 'F', 'Elenita', 'Ninguno', '2004-10-22');
INSERT INTO `guerreros2018` VALUES ('87', 'Gabriela Lizzet Flores Montes', '16', 'C', 'Ciudad de Mexico', '5544228319', 'floressgabs@gmail.com', 'quiero conocer mas de dios ', '\0', '\0', '', '1550', 'A', 'F', 'Lizz Flores', 'ninguna', '2002-04-01');
INSERT INTO `guerreros2018` VALUES ('88', 'Charlotte Joy Allison', '23', 'M', 'Seattle, Washington', '7711240840', 'charly.joy.w@gmail.com', 'SOY STAFF!', '', '\0', '', '1550', 'A', 'F', 'Charly', 'Astma, alergica a piña cruda, coco, mango, jitomate crudo, y niquel.', '1995-01-30');
INSERT INTO `guerreros2018` VALUES ('89', 'Hilaria Martínez De Jesús', '20', 'M', 'México', '5574467248', 'Hirarymart39@gmail.com', 'Siento que últimamente eh estado muy alejada de dios, pero también quiero estar un tiempo alejada de todos para pensar en mi futuro, en mi sobre todo y nada mejor que acercarme a dios.', '\0', '\0', '', '1550', 'A', 'F', 'Hilaria', 'Ninguna', '1997-09-20');
INSERT INTO `guerreros2018` VALUES ('90', 'Karla Ximena De León Hernández', '24', 'C', 'Las Américas!!!! Ecatepunk!', '5578079339', 'xdeleonmakeup@gmail.com', 'Por que va a estar súper chido, Dios siempre me sorprende ? y ya los quiero ver a todos.\r\n\r\nP.d.Karen, si estás leyendo esto espero que este año si me llames ????????????????????aún no supero que el primer año no me pelaste?? jaja te quiero.', '', '\0', '', '1550', 'A', 'F', 'Xime', '', '1994-04-03');
INSERT INTO `guerreros2018` VALUES ('91', '', null, '', '', '', '', '', '\0', '\0', '', '1550', 'B', '', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('92', 'Karla Nohemi Reyes Solis', '18', 'C', 'Tulancingo', '7711240840', 'solisreyes114@gmail.com', 'Me invitaron, soy chida. Punto. (-Charly lo escribió)????', '\0', '\0', '', '1550', 'A', 'F', 'Mimi', 'No tengo, adios.', '2000-05-03');
INSERT INTO `guerreros2018` VALUES ('93', 'Dulce Maria Mendoza Camacho', '19', 'C', 'Estado de Mexico', '5584835382', 'alejandramendozac@outlook.com', 'Amo Reto Urbano es el mejor campamento, y es un tiempo con Dios increible <3', '', '\0', '', '1550', 'A', 'F', 'Dulce', 'ninguna', '1999-03-31');
INSERT INTO `guerreros2018` VALUES ('94', 'Jazmi Montaño Padrón.', '14', 'M', 'México. ', '5560925372', 'jazminmontao@yahoo.com', 'Quiero ir porque estoy súper emocionada de las cosas que Dios hará con cada uno de nosotros, si en lo personal conmigo jaja, sé que me va a retar a muchas cosas (bueno ya lo hace jaja), ¿RETO QUE SOMOS? GUERREROS UH!', '', '\0', '', '1550', 'A', 'F', 'Jaz.??', 'Ninguna.', '2003-10-17');
INSERT INTO `guerreros2018` VALUES ('95', 'Gerson Muñoz', '18', 'M', 'Costa Rica ', '+50687332468', 'munozgerson992@gmail.com', 'Capacitarme para el llamado de Dios y para lo que ÉL tenga en su voluntad en mi futuro. ', '\0', '\0', '', '1550', 'A', 'M', 'Gerson ', '', '1999-07-11');
INSERT INTO `guerreros2018` VALUES ('96', 'raquel herrera corrales', '21', 'M', 'costa rica', '+50660978145', 'raquelhc15@gmail.com', 'Para aprender', '\0', '\0', '', '1550', 'A', 'F', 'raque', 'Ninguna ', '1996-08-15');
INSERT INTO `guerreros2018` VALUES ('97', 'Pablo Antonio Razó Morgan ', null, 'G', 'México DF', '5538391514', 'morganpablorazo@gmail.com', 'Staff', '', '\0', '', '1550', 'A', 'M', 'Pablo', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('98', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('99', 'Víctor Leví Reyes Suárez', '17', 'M', 'Las Américas', '5572810808', 'lvrs17@gmail.com', 'Quiero ir a reto porque desde que me hablaron de él, he tenido ese anhelo en mi corazón de ir, siento que Dios tiene algo para mí ahí. Estar más cerca de Dios y servirle con todo lo que tengo, gracias a Él, es mi mayor deseo y pues amarlo sobre todas las ', '\0', '\0', '', '1550', 'A', 'M', 'Leví', '', '2000-07-21');
INSERT INTO `guerreros2018` VALUES ('100', 'Diego', '22', 'XXG', 'Las américas Ecatepec', '5544945008', 'diegobg52@gmail.com', 'Retarme a mi en algunas partes de mi vida ', '\0', '\0', '', '1550', 'B', 'M', 'Diego Miguel ', 'Ninguna', '1995-11-20');
INSERT INTO `guerreros2018` VALUES ('101', 'Fernanda Aquetzalli Juarez Flo', '18', 'C', 'Ecatepec las americas estado de mexico', '5574084449', 'aquetzalli.juarez@gmail.com', 'Porque Dios me ah sorprendido enormemente en loa dos retos pasados y confio en que este reto sera una oportunidad para acercarme y conocerlo de una manera especiam', '\0', '\0', '', '1550', 'A', 'F', 'Aquetzalli ', 'Soy alergica a la cefalexina, a las hormigas ', '1999-10-26');
INSERT INTO `guerreros2018` VALUES ('102', 'Ana Sofía V. Martínez', '15', 'M', 'Pachuca', '7711577902', 'florysol2011@gmail.com', 'Quiero intenar acercarme más a Dios por medio de esta actividad', '\0', '\0', '', '1550', 'B', 'F', 'Sofía', '', '2003-04-28');
INSERT INTO `guerreros2018` VALUES ('103', 'Regina V. Martínez', '13', 'C', 'Pachuca', '2226740895', 'reginichis@gmail.com', 'Sería bueno para mi ir y acercarme a Dios', '\0', '\0', '', '1550', 'B', 'F', 'Regi', 'No crema de maní ', '2004-11-18');
INSERT INTO `guerreros2018` VALUES ('104', 'Ana Gabriela García Guerrero', '27', 'C', 'Ciudad de México', '5554946662', 'ananorge1553@gmail.com', 'Para ser staff y apoyar en lo que sea necesario.', '', '\0', '', '1550', 'A', 'F', 'Ana', 'No alergias.', '1991-02-18');
INSERT INTO `guerreros2018` VALUES ('105', 'Citlali Pérez Martínez ', '38', 'C', 'Pachuca', '7717221473', 'citlalijucum@gmail.com', 'Soy staff ', '', '\0', '', '1550', 'A', 'F', 'Citlali ', 'Ninguno ', '1980-05-13');
INSERT INTO `guerreros2018` VALUES ('106', 'Ricardo Hernanadez Hernanadez ', '43', 'M', 'Pachuca', '7712088634', 'richjucum@gmail.com', 'Soy Lider', '', '\0', '', '1550', 'A', 'M', 'Richs ', 'Ninguno', '1975-01-18');
INSERT INTO `guerreros2018` VALUES ('107', 'Luis Humberto gil gerardo', '28', 'XXG', 'Jucum Pachuca ', '5575557976', 'luishgg15@gmail.com', 'Soy staff ', '', '\0', '', '1550', 'A', 'M', 'Luis Gil ', 'Sandia\r\n', '1990-06-15');
INSERT INTO `guerreros2018` VALUES ('108', 'José Alfredo Guevara', '18', 'G', 'Tyler Tx', '7717221473', 'richjucum@gmail.com', 'Invitado ', '\0', '\0', '', '1550', 'A', 'M', 'José ', '', '2000-03-17');
INSERT INTO `guerreros2018` VALUES ('109', 'EVELYN SARAI GIRON TIRADO', '27', 'C', 'JUCUM MONTERREY', '6691160672', 'evelynsarai19@gmail.com', 'EQUIPO DE CONSEJERIA JUCUM MONTERREY', '', '\0', '', '1550', 'A', 'F', 'EVELYN GIRON', 'NO', '1991-01-16');
INSERT INTO `guerreros2018` VALUES ('110', 'BETEL SARAI PEREZ HERNANDEZ', '21', 'M', 'JUCUM MONTERREY', '6461460886', 'btlsarai13marzo@hotmail.com', 'Equipo de consejería  de Jucum monterrey', '', '\0', '', '1550', 'A', 'F', 'BETEL PEREZ', 'ninguna', '1997-03-13');
INSERT INTO `guerreros2018` VALUES ('111', 'stephany tolentino torres', '25', 'M', 'jucum monterrey', '5513413806', 'stephany.tolentino@ywammonterrey.org', 'equipo de consejería jucum monterrey', '', '\0', '', '1550', 'A', 'F', 'stephany', 'no', '1992-12-17');
INSERT INTO `guerreros2018` VALUES ('112', 'francisco froylan mondragon', '32', 'C', 'jucum monterrey', '3111508981', 'froylan18@gmail.com', 'equipo de consejería jucum monterrey', '', '\0', '', '1550', 'A', 'M', 'froylan', 'humedad', '1985-07-29');
INSERT INTO `guerreros2018` VALUES ('113', 'Marcio Roberto Scarabel', '37', 'G', 'Omnibus', '9932236248', 'misioneromarcio@gmail.com', 'Equipo de Consejeria Jucum Monterrey', '', '\0', '', '1550', 'A', 'M', 'Marcio Scarabel', 'Amoxelina', '1981-05-10');
INSERT INTO `guerreros2018` VALUES ('114', 'César Curiel', '26', 'C', 'Tijuaj', '(664)3081187', 'rami.curiel@gmail.com', 'Equipo de Consejería JUCUM Monterrey', '', '\0', '', '1550', 'A', 'M', '', 'Ninguno', '1991-12-09');
INSERT INTO `guerreros2018` VALUES ('115', 'Mauricio Casillas Contreras ', '19', 'M', 'Toluca ', 'N/A', 'mau.casillas.ca@gmail.com', 'Aprendizaje ', '\0', '\0', '', '1550', 'A', 'M', 'Casillas ', 'No tengo. ', '1999-04-12');
INSERT INTO `guerreros2018` VALUES ('116', 'Damaris Malpica de Riddle', null, 'C', 'Cancun', '9983239815', 'damamalpica@gmail.com', 'Equipo de Consejería Jucum Monterrey', '', '\0', '', '1550', 'A', 'F', 'Damaris', 'intolerante a la lactosa', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('117', 'Chad David Riddle', '27', 'G', 'Washington state', '9983239815', 'chad.lindley@hotmail.com', 'Biblical Counselling School YWAM Monterrey', '', '\0', '', '1550', 'A', 'M', 'Chad', 'zithromax', '1990-12-04');
INSERT INTO `guerreros2018` VALUES ('118', 'Ana Lucía Moctezuma ', '29', 'G', 'Puebla', '044222758715', 'moktelux@gmail.com', 'Servir :D estar en familia, un tiempo especial con Dios.', '', '\0', '', '1550', 'A', 'F', 'Ana Lu', '-', '1988-07-27');
INSERT INTO `guerreros2018` VALUES ('119', '', null, '', '', '', '', '', '\0', '\0', '', '1550', 'B', '', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('120', 'Evan Daniel Hernandez Perez', '13', 'C', 'Pachuca Hgo', '777 444 8213', 'evannet099@gmail.com', 'Aprender mas de Dios', '', '\0', '', '1550', 'A', 'M', 'Evan', 'no, ninguna', '2004-09-02');
INSERT INTO `guerreros2018` VALUES ('121', 'Lizzet Flores', '15', 'C', 'Ciudad de México ', '5563587464', 'floressgabs@gmail.com', 'Conocer más de dios', '\0', '\0', '', '1550', 'B', 'F', 'Lizz Flores', '', '2003-04-01');
INSERT INTO `guerreros2018` VALUES ('122', 'Oscar Rogelio Corona Contreras', '18', 'M', 'Ecatepec Las Américas ', '3313010592', 'oscar.roger@icloud.com', 'Para seguir aprendiendo más sobre Dios ', '\0', '\0', '', '1550', 'A', 'M', 'Roger', '', '2000-06-14');
INSERT INTO `guerreros2018` VALUES ('123', 'Yechan Choi', '18', 'XG', 'San Diego', 'N/A', 'yechanchoi28@gmail.com', 'Participating with my church youth group as a part of a missions trip. ', '\0', '\0', '', '1550', 'A', 'M', '', 'None', '2000-04-28');
INSERT INTO `guerreros2018` VALUES ('124', 'Micah Hangil Park', '17', 'G', 'San Diego, California ', '858-883-8601', 'mpark2001@gmail.com', 'I am part of a mission team with my church and I want to do more at my church. I thought that doing this would help me be more if a leader and learn more about God', '\0', '\0', '', '1550', 'A', 'M', 'Micah H Park', 'None', '2001-01-17');
INSERT INTO `guerreros2018` VALUES ('125', 'Hayoung Patk', '18', 'M', 'San Diego', 'n/a', 'hayoung.mathews@gmail.com', 'Participating in my church’s (KUMC) missions. ', '\0', '\0', '', '1550', 'A', 'F', '', 'none', '2000-05-20');
INSERT INTO `guerreros2018` VALUES ('126', '', null, '', '', '', '', '', '\0', '\0', '', '1550', 'B', '', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('127', 'Rodrigo Cortes Ortega', '18', 'G', 'México ', '5566656433', 'rodrigo.corort@hotmail.com', 'Poder acercarme a la palabra de dios, conocer más de mi padre celestial y poder mejorar mi inglés ', '\0', '\0', '', '1550', 'A', 'M', 'Rodrigo', 'Alérgico a los mariscos', '2000-01-18');
INSERT INTO `guerreros2018` VALUES ('128', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('129', 'Mariel Solis Ortiz', '17', 'M', 'Pachuca ', '7713644174', 'solormary@hotmail.com', 'Asistí el año pasado, quiero ver a mis amigos otra vez y realmente es un entrenamiento para mi, por que es parte de mi llamado.? ', '\0', '\0', '', '1550', 'A', 'F', 'Mary', 'No :)', '2000-10-18');
INSERT INTO `guerreros2018` VALUES ('130', 'Elijah Mark Johnson', '21', 'M', 'Mississippi', '7711240840', 'guitarfreak.johnson@gmail.com', 'Soy staff de JUCUM Pachuca', '', '\0', '', '1550', 'A', 'M', '', '', '1997-05-18');
INSERT INTO `guerreros2018` VALUES ('131', 'Mariana Garte', '24', 'C', 'Estado de México', '5541339516', 'maiigarte@hotmail.com', 'Amo reto y cada año es clave el pasar ese tiempo buscando una palabra de Dios para mi vida y lo que siga en ese año.', '', '\0', '', '1550', 'A', 'F', 'Mariana Garte', 'No como pescado jajaja', '1993-12-22');
INSERT INTO `guerreros2018` VALUES ('132', 'Vanessa', '19', 'C', 'Centro', '477 638 8524', 'lopezvane1716@gmail.com', 'Para poder ver el amor de  DIOS HACIA LOS demas y las maravillas que va hacer Dios este año', '', '\0', '', '1550', 'B', 'F', 'Vane', '', '1999-04-17');
INSERT INTO `guerreros2018` VALUES ('133', 'vanessa ', '19', 'C', 'San Francisco del Rincón', '477 638 8524', 'lopezvane1716@gmail.com', 'Para ver lo maravillo  que Dios va hacer con la gente que vamos que se va evangelizar ', '', '\0', '', '1550', 'A', 'F', 'Vane', '', '1999-04-17');
INSERT INTO `guerreros2018` VALUES ('134', 'Timothy Hyun', '16', 'M', 'San Diego', '8582761674', 'hyun.timothy1234@gmail.com', 'To spread God\'s truth..', '\0', '\0', '', '1550', 'A', 'M', 'Timothy Hyun', 'None.', '2001-07-08');
INSERT INTO `guerreros2018` VALUES ('135', 'Claudia zuleica lara meneses', '16', 'M', 'Cuautitlan izcalli edo mexico', '5531963786', 'isameneses_3@hotmail.com', 'Pq empeze a tomar y a ingerir droga y salir con personas q hacen lo mismo e intente suicidarme', '\0', '\0', '', '1550', 'A', 'F', 'Clau', 'Penicilina y cefalosporina', '2002-04-04');
INSERT INTO `guerreros2018` VALUES ('136', 'María Fernanda Pacheco Aguilar', '15', 'M', 'Centro Cristiano Calacoaya', '5567495363', 'ivettepas@yahoo.com.mx', 'Quiero conocer más al Señor Jesús y aprender a relacionarme con él y las personas.', '\0', '\0', '', '1550', 'A', 'F', 'Marifer', 'Ninguna', '2003-03-19');
INSERT INTO `guerreros2018` VALUES ('137', 'María Fernanda Pacheco Aguilar', '15', 'M', 'Centro Cristiano Calacoaya', '5567495363', 'ivettepas@yahoo.com.mx', 'Quiero conocer más al Señor Jesús y aprender a relacionarme con él y las personas.', '\0', '\0', '', '1550', 'B', 'F', 'Marifer', 'Ninguna', '2003-03-19');
INSERT INTO `guerreros2018` VALUES ('138', 'Luis Jesús García Navarro ', '22', 'M', 'Ciudad de México', '5519022484', 'luiscfnv@gmail.com', 'Porque quiero aprender como predicar y hacer otras actividades para poder llegar a la gente de una manera en la que estén interesados en conocer a Dios.', '\0', '\0', '', '1550', 'A', 'M', 'Luis G. N.', '', '1995-10-12');
INSERT INTO `guerreros2018` VALUES ('139', 'Isaac Emanuel García Navarro ', '18', 'G', 'Ciudad de México', '5587218174', 'isaacegn000@gmail.com', 'porque siento que me hace falta.', '\0', '\0', '', '1550', 'A', 'M', 'Emanuel ', '', '2000-03-26');
INSERT INTO `guerreros2018` VALUES ('140', 'Miguel Ángel García Navarro ', '19', 'M', 'Ciudad de México', '5544618067', 'miguel.angnav@hotmail.com', 'Porque amo a Dios.', '\0', '\0', '', '1550', 'A', 'M', 'Angel G. N.', '', '1998-09-12');
INSERT INTO `guerreros2018` VALUES ('141', 'Miriam Vanessa Robledo Contrer', '17', 'M', 'Edo. De México ', '5564076613', 'vanne211627@gmail.com', 'Ya estuve en HR pero por motivos mayores no pude seguir, sin embargo ahora siento que Dios me esta retando a cambiar HR por Reto. ', '\0', '\0', '', '1550', 'B', 'F', 'Vane', '', '2000-10-27');
INSERT INTO `guerreros2018` VALUES ('142', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('143', 'Lizzet Flores Montes', '16', 'M', 'Ciudad de México ', '5563587464', 'floressgabs@gmail.com', 'Aprender más de Dios ', '\0', '\0', '', '1550', 'B', 'F', 'Lizz Flores', '', '2002-04-01');
INSERT INTO `guerreros2018` VALUES ('144', 'Yail Chávez Aleman ', '14', 'M', 'Tecamac centro', '5544803200', 'chinoy51@yahoo.com.mx', 'Para meditar las cosas de la biblia y divertirme ', '\0', '\0', '', '1550', 'A', 'M', 'Yail ', 'Dexesametazona ', '2003-10-06');
INSERT INTO `guerreros2018` VALUES ('145', 'Chantal Reneé Sosa Mancha', '14', 'M', 'Amistad Cristiana Las Americas', '5537916995', 'renesos15@gmail.com', 'Para  acercarme más a Dios por medio de mis dones y habilidades para servirle', '\0', '\0', '', '1550', 'A', 'F', 'Shantal', 'Ninguna', '2004-04-15');
INSERT INTO `guerreros2018` VALUES ('146', 'Erick Sebastián Sosa Mancha', '16', 'G', 'Amistad Cristiana Las Americas', '5529202161', 'avestruzerick@gmail.com', 'Para conocer a mi Padre de los cielos de una manera divertida y gozosa de su nombre, más que nada para servirle.', '\0', '\0', '', '1550', 'A', 'M', 'Sebastián Sosa', 'Ninguno', '2002-06-25');
INSERT INTO `guerreros2018` VALUES ('147', 'Vania Uribe D lucio', '29', 'C', 'Ecatepec, estado de México ', '5591941814', 'frailheart@gmail.com', 'Porque mi hermana me dijo que ahí encontraré respuestas para saber como regresar a casa de Dios', '\0', '\0', '', '1550', 'A', 'F', 'Vania', 'Ninguna', '1989-04-18');
INSERT INTO `guerreros2018` VALUES ('148', 'Pamela Uribe D  lucio', '31', 'C', 'Ecatepec, Estado de Mexico', '87168657', 'uripamela@gmail.com', 'Afianzar mi relación con Dios', '\0', '\0', '', '1550', 'A', 'F', 'PAME', 'Ninguna. NOTA: El teléfono es número local ', '1986-09-26');
INSERT INTO `guerreros2018` VALUES ('149', 'Citlalli Cortes Ortega', '15', 'M', 'México ', '5536319244', 'citlallicortesortega@gmail.com', 'Para conocer más a Jesucristo ', '\0', '\0', '', '1550', 'A', 'F', 'Citlalli', '', '2003-01-31');
INSERT INTO `guerreros2018` VALUES ('150', 'Daniela Danae Wong Lopez', '20', 'G', 'Tecamac', '5573234220 ', 'alecadensa@hotmail.com', 'Siempre he querido evangelizar y viajar. ', '\0', '\0', '', '1550', 'A', 'F', 'Dana ', 'Cortisona ', '1998-03-09');
INSERT INTO `guerreros2018` VALUES ('151', 'Jaasiel David Wong Lopez', '17', 'M', 'Tecamac', '5573234220 ', 'alecadensa@hotmail.com', 'Quiero aprender como ganar almas para Cristo', '\0', '\0', '', '1550', 'A', 'M', 'Jaasiel', 'Bada', '2000-11-12');
INSERT INTO `guerreros2018` VALUES ('152', 'Jaasiel David Wong Lopez', '17', 'M', 'Tecamac', '5573234220 ', 'alecadensa@hotmail.com', 'Quiero aprender como ganar almas para Cristo', '\0', '\0', '', '1550', 'B', 'M', 'Jaasiel', 'Bada', '2000-11-12');
INSERT INTO `guerreros2018` VALUES ('153', 'Yetzel Denisse Linares Reyes', '18', 'C', 'Ecatepec, Estado de México', '5510062814', 'yetzelpumasgoya@hotmail.com', 'Quiero vivir la experiencia', '\0', '\0', '', '1550', 'A', 'F', 'Denisse', '', '1999-08-23');
INSERT INTO `guerreros2018` VALUES ('154', 'Arnold Campuzano', '23', 'C', 'Toluca', '7228374418', 'jahsaves7@hotmail.com', 'Porque Reto urbano es la onda xD!! ', '', '\0', '', '1550', 'A', 'M', 'Arny', '', '1995-05-13');
INSERT INTO `guerreros2018` VALUES ('155', 'Alfredo Camargo Montiel ', '18', 'G', 'Tecamac San Francisco ', '5583660593', 'sailenser2000@hotmail.com', 'Por qué quiero ver de qué se trata y mi prima Paola me invitó ', '\0', '\0', '', '1550', 'A', 'M', 'Alfredo ', '', '2000-03-25');
INSERT INTO `guerreros2018` VALUES ('156', 'Linette Yazmin Roldan Martinez', '21', 'C', 'ESTADO DE MÉXICO, ATIZAPÁN', '5578300200', 'linette.yazmin@gmail.com', '¿y por qué no?', '', '\0', '', '1550', 'A', 'F', 'Linette ', 'No (:', '1997-03-22');
INSERT INTO `guerreros2018` VALUES ('157', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('158', 'María Fernanda Pacheco Aguilar', '15', 'M', 'Centro Cristiano Calacoaya', '5567495363', 'ivettepas@yahoo.com.mx', 'Quiero conocer a Dios y servirle', '\0', '\0', '', '1550', 'A', 'F', 'Fer', 'Ninguna', '2003-03-19');
INSERT INTO `guerreros2018` VALUES ('159', 'Daniela Quiroz Vera', '14', 'C', 'Ciudad de México ', '5567773039 ', 'daniela.quiroz7u7@gmail.com', 'El año pasado asistí & me gustó demasiado, seguiré yendo los siguientes años', '\0', '\0', '', '1550', 'A', 'F', 'Dany Quiroz', 'Erge 2do grado\r\nCrisis asmáticas/(salbutamol)', '2003-10-26');
INSERT INTO `guerreros2018` VALUES ('160', 'Edgar Antonio Juárez Tabares ', '24', 'M', 'Las Américas!!!! Ecatepunk!', '5561849083', 'pal_edgartavares@hotmail.com', 'Fui retado con la fe.', '\0', '\0', '', '1550', 'A', 'M', 'Edgar', 'Aspirina', '1994-04-19');
INSERT INTO `guerreros2018` VALUES ('161', 'Sofia Thanh Godinez Fama', '12', 'C', 'Pachuca Hidalgo', '7713828869', 'mariogodinez78@gmail.com', 'Para acercar a Dios', '\0', '\0', '', '1550', 'A', 'F', 'Sofia Thanh', '', '2006-05-30');
INSERT INTO `guerreros2018` VALUES ('162', 'Maddox Minh Godinez Fama', '13', 'C', 'Pachuca Hidalgo', '7713828869', 'mariogodinez78@gmail.com', 'Para acercar a Dios', '\0', '\0', '', '1550', 'A', 'M', '', '', '2005-04-21');
INSERT INTO `guerreros2018` VALUES ('163', 'Ariel Barrientos Esquivel', '19', 'M', 'Amistad Cristiana Las Américas', '5574668513', 'aribe2601@gmail.com', 'Quiero tener un encuentro con Dios y acercarme más a Él, reafirmando mi fe.', '\0', '\0', '', '1550', 'A', 'F', 'Ary ', 'Ninguna', '1999-01-26');
INSERT INTO `guerreros2018` VALUES ('164', 'Aixa Denisse Talavera Romero ', '14', 'C', 'Axcapotzalco ciudad de maxico', '5562212585', 'denissetromero@gmail.com', 'Porque quiero conocer ', '\0', '\0', '', '1550', 'A', 'F', 'Denisse', 'Piquetes de insectos', '2004-04-09');
INSERT INTO `guerreros2018` VALUES ('165', 'DANIEL SAED TALAVERA ROMERO ', '17', 'XG', 'Azcapotzalco CDMX', '5535288444', 'saedd1581@gmail.com', 'Me invitaron', '\0', '\0', '', '1550', 'A', 'M', 'Saed', '', '2000-08-31');
INSERT INTO `guerreros2018` VALUES ('166', 'Lilian Aline López Romero', '18', 'M', 'Ecatepec', '5529211568', 'lilianaline1303@gmail.com', 'Mejorar todo en mí', '\0', '\0', '', '1550', 'A', 'F', 'Lilian', '', '2000-03-13');
INSERT INTO `guerreros2018` VALUES ('167', 'Valeria Gpe Juárez Tabares', '15', 'C', 'Las Américas, Ecatepec. ', '5519384127', 'valery-24@hotmail.com', 'Quiero aprender a amar como Dios me ha amado', '\0', '\0', '', '1550', 'A', 'F', 'Vale ', 'Piquete de insectos. ', '2003-06-24');
INSERT INTO `guerreros2018` VALUES ('168', 'Nadia Tavares López', '23', 'M', 'Las Américas Ecatepec', '5573915325', 'nanii.flakita@gmail.com', 'Quiero conocer el amor de Dios. Y llenar mi vida de Él', '\0', '\0', '', '1550', 'A', 'F', 'Nadia', 'Polvo', '1994-12-27');
INSERT INTO `guerreros2018` VALUES ('169', 'Jessica Fernanda Ugalde Rodríg', '18', 'M', 'Estado de México', '5548758622', 'jess.ugr@gmail.com', 'Quiero seguir conociendo quien es Dios y tengo una invitación para ser staff. ', '', '\0', '', '1550', 'A', 'F', 'Jess', '', '1999-07-13');
INSERT INTO `guerreros2018` VALUES ('170', 'Uriel Vela Soto', '20', 'G', 'Estado de México', '5510446318', 'velhost22@gmail.com', 'Porque es bueno siempre tener un tiempo completamente enfocado en el crecimiento en Jesús, y porque estaré acompañando al equipo que invité de una Iglesia.', '\0', '\0', '', '1550', 'A', 'M', 'Uriel Vela', '', '1998-03-02');
INSERT INTO `guerreros2018` VALUES ('171', 'Eunice Martinez Lopez', '23', 'G', 'Ecatepec Estado de México', '55 42373816', 'Eunice_Martinez_Lopez@outlook.com', 'Me invitó un amigo, pero he escuchado mucho acerca de ustedes y me gusto lo que oí. ', '\0', '\0', '', '1550', 'A', 'F', 'Eunice', '', '1994-12-24');
INSERT INTO `guerreros2018` VALUES ('172', 'Fernanda Ojeda Gómez Humarán', '18', 'M', 'Estado de México ', '(55)51366938', 'fer_ojedagomezh@hormail.com', 'Mi mejor amiga danny rergis me contó que estaba muy padre, y que era una buena forma de acercarme a Dios pues es lo que yo quiero ', '\0', '\0', '', '1550', 'A', 'F', 'Fer Ojeda ', '', '1999-09-21');
INSERT INTO `guerreros2018` VALUES ('173', 'Alberto atzin', '14', 'M', 'San Isidro ', '5540411280', 'pao21urbi@gmail.com', 'Me gustaría divertirme y mi prima Paola me invitó ', '\0', '\0', '', '1550', 'A', 'M', 'Atzin', '', '2004-03-01');
INSERT INTO `guerreros2018` VALUES ('174', 'Lucero Martinez Castañeda', '27', 'M', 'Pachuca', '7717722130', 'castaneda_lucero@hotmail.com', 'Me encanta!!!', '', '\0', '', '1550', 'A', 'F', 'Lucero', '', '1991-03-05');
INSERT INTO `guerreros2018` VALUES ('175', 'Eugenio Herrera Gonzalez', '29', 'C', 'Pachuca', '7713433770', 'jeugeherrera@gmail.com', 'Es chido!', '', '\0', '', '1550', 'A', 'M', 'Euge', '', '1988-07-30');
INSERT INTO `guerreros2018` VALUES ('176', 'Oscar rai martinez romero ', '23', 'C', 'Mexico ', '2381877006', 'ocarin_777@hotmail.com', 'Por un llamado de Dios', '\0', '\0', '', '1550', 'A', 'M', 'Oscar ', 'Ninguna ', '1995-03-24');
INSERT INTO `guerreros2018` VALUES ('177', 'Marlene ivonne Gamero Rosales ', '23', 'C', 'Estado de México ', '55 44549188', 'marlene26gamero@gmail.com', 'Para conocer y aprender más de Dios ', '\0', '\0', '', '1550', 'A', 'F', 'Ivonne ', 'Ninguna ', '1995-06-26');
INSERT INTO `guerreros2018` VALUES ('178', 'Eduardo Hernández Trujillo ', '27', 'G', 'Estado de México ', '5581103602 ', 'thesinful1@hotmail.com', 'Para tener  crecimiento como líder y avivar el fuego del don de Dios ques ha puesto en mi. ', '\0', '\0', '', '1550', 'A', 'M', 'EduardoPortavoz ', 'Penicilina ', '1990-07-17');
INSERT INTO `guerreros2018` VALUES ('179', 'Sergio Daniel Ugalde Rodriguez', '21', 'M', 'Estado de México', '5529600398', 'sugalde.horrnk3rllaz@gmail.com', 'Me invitaron y quiero ayudar a las personas.', '\0', '\0', '', '1550', 'A', 'M', 'Sergio', '', '1996-08-24');
INSERT INTO `guerreros2018` VALUES ('180', 'Ana camila maldonado mejia', '14', 'C', 'Acolman, Estado De México', '5582418400', 'anacamilamaldonado012704@gmail.com', 'Me llama la atención como es que dan a conocer a dios a los jovenes.', '\0', '\0', '', '1550', 'A', 'F', 'Ana', 'A la piña.\r\nNinguna condición medica.', '2004-01-27');
INSERT INTO `guerreros2018` VALUES ('181', 'Valentina Martinez López', '14', 'M', 'My fathers house', '7712088664', 'richscitlali@hotmail.com', 'MY FATHERS HOUSE', '\0', '\0', '', '1550', 'A', 'F', '', '', '2004-03-04');
INSERT INTO `guerreros2018` VALUES ('182', 'Eliana edith Gomez', '13', 'C', 'MY FATHERS HOUSE ', '7712088664', 'richscitlali@hotmail.com', 'MY FATHERS HOUSE', '\0', '\0', '', '1550', 'A', 'F', '', '', '2005-04-02');
INSERT INTO `guerreros2018` VALUES ('183', 'Naomi Mote Aguilar', '12', 'C', 'MY FATHERS HOUSE ', '7712088664', 'richscitlali@hotmail.com', 'INVITACIÓN', '\0', '\0', '', '1550', 'B', 'F', '', '-', '2005-08-03');
INSERT INTO `guerreros2018` VALUES ('184', 'Guadalupe García Reza', '14', 'M', 'MY FATHERS HOUSE ', '7712088664', 'richscitlali@hotmail.com', 'INVITACIÓN', '\0', '\0', '', '1550', 'A', 'F', '', '-', '2004-07-08');
INSERT INTO `guerreros2018` VALUES ('185', 'Yazmín Cerón Navarez', '13', 'M', 'MY FATHERS HOUSE ', '7712088664', 'richscitlali@hotmail.com', 'INVITACIÓN', '\0', '\0', '', '1550', 'A', 'F', '', '-', '2005-06-01');
INSERT INTO `guerreros2018` VALUES ('186', 'David alejandro madonado gutie', '25', 'M', ' Ecatepec.', '5523476749', 'anacamilamaldonado012704@gmail.com', 'Superación personal.', '\0', '\0', '', '1550', 'A', 'M', 'Ale', '', '1993-06-30');
INSERT INTO `guerreros2018` VALUES ('187', 'David alejandro madonado gutie', '25', 'M', ' Ecatepec.', '5523476749', 'anacamilamaldonado012704@gmail.com', 'Superación personal.', '', '\0', '', '1550', 'B', 'M', 'Ale', '', '1993-06-30');
INSERT INTO `guerreros2018` VALUES ('188', 'Jean Carlo Ojeda Gutiérrez', '13', 'G', 'Estado de México', '5554028790', 'lorenamakeup@hotmail.com', 'Para que con viva con mas niños cristianos y se divierta mucho', '\0', '\0', '', '1550', 'A', 'M', 'Jean Carlo Ojeda Gtz', 'Solo tópica ', '2004-12-26');
INSERT INTO `guerreros2018` VALUES ('189', 'Karla Montiel Solis', '21', 'M', 'Pachuca', '7711841763', 'karla.montiel@hotmail.com', 'Porque me gusto mucho Reto urbano 2017', '\0', '\0', '', '1550', 'A', 'F', 'Karla', 'Medicamentos antes de dormir (olanzapinza,valpruato y clonazepam)  y tés de herbolaria en el transcurso del día', '1996-10-26');
INSERT INTO `guerreros2018` VALUES ('190', 'YOSEF YAEL CASTAÑON CRUZ', '14', 'C', 'TAMAZUNCHALE S.L.P.', '4831064108', 'thegibson_2782@outlook.com', 'Invitación por Ricardo Hernández al campamento', '\0', '\0', '', '1550', 'A', 'M', 'YOSEF', 'Penicilina', '2004-01-05');
INSERT INTO `guerreros2018` VALUES ('191', 'GABRIEL CASTAÑON ZUÑIGA', '35', 'G', 'Tamazunchale S.L.P.', '4831118074', 'thegibson_2782@outlook.com', 'Invitación a formar parte de el estaf Juegos organizados', '', '\0', '', '1550', 'A', 'M', 'GABE', 'Penicilina', '1982-09-27');
INSERT INTO `guerreros2018` VALUES ('192', 'MIRIAM ISABEL CRUZ JONGUITUD', '35', 'M', 'Tamazunchale S.L.P.', '4831182400', 'cieloazul192@yahoo.com', 'Invitación por parte de Ricardo Hernández para formar parte del estaf de RU', '', '\0', '', '1550', 'A', 'F', 'Miriam', 'Antibióticos', '1982-08-31');
INSERT INTO `guerreros2018` VALUES ('193', 'Ximena Cabrera López ', '17', 'M', 'San Francisco, Guanajuato ', '4761458729', 'cabreraX10@hotmail.com', 'Quiero aprender, conocer y disfrutar de Dios con personas que tengamos en común una meta que es dar a conocer al mundo el amor de Dios. ', '\0', '\0', '', '1550', 'A', 'F', 'Ximena ', 'Nunguna', '2000-09-10');
INSERT INTO `guerreros2018` VALUES ('194', 'Valeria Ramírez Arias', '15', 'C', 'Pachuca', '7711982299 ', 'valeramirezarias@gmail.com', 'Encontrarme con Dios y conocer más personas jóvenes que amen a Dios', '\0', '\0', '', '1550', 'A', 'F', 'Vale', 'NO', '2003-06-10');
INSERT INTO `guerreros2018` VALUES ('195', 'Natalia Ramírez Arias', '13', 'C', 'Pachuca', '7712196709', 'nramireza2004@gmail.com', 'Para conocer más jóvenes que amen a Dios y para tener un encuentro con Dios', '\0', '\0', '', '1550', 'A', 'F', 'Naty', 'NO', '2004-09-03');
INSERT INTO `guerreros2018` VALUES ('196', 'Ana Bertha Reyes Guerrero ', '20', 'C', 'Guanajuato ', '476 113 0131', 'ana_reyesgro@outlook.com', 'Me invitaron ', '\0', '\0', '', '1550', 'A', 'F', 'Anii Reyes ', 'Ninguna', '1998-05-12');
INSERT INTO `guerreros2018` VALUES ('197', 'Miriam G. Ibarra Sánchez', '23', 'M', 'San Francisco del Rincón, Gto.', '4771387138', '25mmgis@gmail.com', 'Porque he recibido muy buenas recomendaciones sobre este campamento y me encantaría poder ser parte.', '\0', '\0', '', '1550', 'A', 'F', 'Miriam', 'Ninguna', '1994-10-25');
INSERT INTO `guerreros2018` VALUES ('198', 'Luis Edgar Oropeza Canales', '22', 'G', 'Amistad Cristiana Guadiana', '5541794661', 'goubzds@gmail.com', 'Quiero convertir mi fé en verdadera convicción, salir de la congregación y vivir mi propia realidad en Cristo.', '\0', '\0', '', '1550', 'B', 'M', 'Luis Oropeza ', 'Ninguno ', '1996-07-14');
INSERT INTO `guerreros2018` VALUES ('199', 'Juan antonio González Murillo ', '15', 'M', 'San Francisco del rincón ', '4761320003', 'tontoby26@gmail.com', 'Para aprender, convivir, crecer ', '\0', '\0', '', '1550', 'A', 'M', 'TONY', 'Ninguna', '2002-10-26');
INSERT INTO `guerreros2018` VALUES ('200', 'Ana Maricela Romero Juarez', '16', 'M', 'Del estado de mexico', '5531176986', 'paulina.juarez1608@gmail.com', 'Me encanta servir a mi padre, el conocerlo.', '', '\0', '', '1550', 'A', 'F', 'Mary Juarez. ', 'Penicilina ', '2002-06-16');
INSERT INTO `guerreros2018` VALUES ('201', 'Adrian Bonilla Ruiz', '16', 'C', 'Edo Mex', '5568654025', 'boruroad@hotmail.com', 'Me gustaria como es Todo c:', '', '\0', '', '1550', 'B', 'M', 'Adrián', 'Nope:', '2001-11-26');
INSERT INTO `guerreros2018` VALUES ('202', 'David Guadiana Alcantara', '13', 'G', 'Lunes 16 de julio 2018', '5543584375', 'marisol692391@gmail.com', 'Buscar la presencia de Dios y así reflejarlo.', '\0', '\0', '', '1550', 'A', 'M', 'David', '', '2005-02-17');
INSERT INTO `guerreros2018` VALUES ('203', 'Daniel Lee', '18', 'M', 'San Diego', 'N/A', 'dannydreams.lee@gmail.com', 'I am coming to serve with my youth ministry team from KUMC (Korean United Methodist Church) and to grow in my walk with Christ.', '\0', '\0', '', '1550', 'A', 'M', 'Daniel Lee', 'cat and food coloring', '2000-03-28');
INSERT INTO `guerreros2018` VALUES ('204', 'César Francisco Acosta Acosta', null, 'M', 'Estado de México', '5586824349', 'safrontrahs51@gmail.com', 'Invitación de mi congregación', '\0', '\0', '', '1550', 'A', 'M', 'César', 'Ninguna', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('205', 'Ana Elizabeth García Escalona', '12', 'C', 'centro de fe esperanza y amor', '5534866548', 'vane.van.roy@gmail.com', 'Para conocer más personas que amén a Jesús y sobre todo quiero aprender a hablar le a la gente del amor de Dios y saber cuál es mi llamado', '\0', '\0', '', '1550', 'A', 'F', 'Eli Escalona', 'Sin alergias, tipo de sangre A+', '2005-08-03');
INSERT INTO `guerreros2018` VALUES ('206', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('207', 'Alvaro Vela Soto', '16', 'XG', 'Tecamac ', '5529323808', 'alvaritonik@hotmail.com', 'Para disfrutar de un ratote con Dios ', '\0', '\0', '', '1550', 'A', 'M', 'Álvaro', 'Lácteos', '2002-05-08');
INSERT INTO `guerreros2018` VALUES ('208', 'Pablo Pereira Romero ', '23', 'C', 'Ecatepec ', '5540276411', 'pablo777581@gmail.com', 'Aprender, ir a más en Dios, recibir de Dios ', '\0', '\0', '', '1550', 'A', 'M', 'Pablo Pereira', '', '1995-03-22');
INSERT INTO `guerreros2018` VALUES ('209', 'Valería Valentina Ramirez Vert', '13', 'M', ' Ecatepec.', '5570065891', 'anacamilamaldonado012704@gmail.com', 'Por que mi prima me hablo sobre esto y ne intereso mucho.', '\0', '\0', '', '1550', 'A', 'F', 'Vale', 'Ninguno', '2004-10-06');
INSERT INTO `guerreros2018` VALUES ('210', 'Pamela Ferrer Olín', '17', 'G', 'México', '044556979374', 'pamelu1611@live.com.mx', 'Amigos me habían invitado y me llamo la atención ', '\0', '\0', '', '1550', 'A', 'F', 'Pame', 'ninguno', '2000-11-16');
INSERT INTO `guerreros2018` VALUES ('211', 'Marssel Fabricio González Rese', '19', 'M', 'Estado de México ', '5541574435', 'fabrit_gr@live.com', 'Conocer más a Dios ', '\0', '\0', '', '1550', 'A', 'M', 'Fabricio ', '', '1998-07-24');
INSERT INTO `guerreros2018` VALUES ('212', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'B', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('213', 'Eduardo Lagos Mercado', '17', 'M', 'Tecamac , Estado de Mexico', '5578014374', 'lagosmercadoeduardo@gmail.com', 'Mejorar mi relacion con Dios.', '\0', '\0', '', '1550', 'B', 'M', 'Lalito', 'Ninguna', '2001-06-27');
INSERT INTO `guerreros2018` VALUES ('214', 'Abraham Alexis Esparza Lezama', '14', 'C', 'De Ecatepec Morelos.', '5529453636', 'esparzalonginus@hotmail.com', 'Para nuevas experiencias', '\0', '\0', '', '1550', 'A', 'M', 'Alexis', 'NO', '2003-09-24');
INSERT INTO `guerreros2018` VALUES ('215', 'Elias Solis Ortiz ', '16', 'XG', 'Pachuca ', '7713555400', 'eliashatake02@gmail.com', 'Fui el año pasado y fue un tiempo de gran aprendizaje y desafío. Estoy expectante en este año y listo para ser sorprendido y sacudido por la voz de Dios. De igual manera me encantó el evangelismo y quiero seguir impactando!', '\0', '\0', '', '1550', 'A', 'M', 'Elias S', 'No', '2002-03-01');
INSERT INTO `guerreros2018` VALUES ('216', 'Raúl López Resendiz ', '20', 'XG', 'Estado de México ', '5583687018', 'raullopez801@gmail.com', 'Conocer a Dios ', '\0', '\0', '', '1550', 'A', 'M', 'Raúl ', 'Ninguna ', '1998-05-20');
INSERT INTO `guerreros2018` VALUES ('217', 'Yechan Choi', '18', 'G', 'San Diego, California', 'N/A', 'yechanchoi28@gmail.com', 'To experience God’s love with new people in a new environment while with my church. ', '\0', '\0', '', '1550', 'A', 'M', 'Yechan Choi', 'None', '2000-04-28');
INSERT INTO `guerreros2018` VALUES ('218', 'Luz Berenice Torres Salazar', '17', 'C', 'NUEVA VIDA', '7712072048', 'neitan.morales@gmail.com', 'nueva vida', '\0', '\0', '', '1550', 'A', 'F', 'Luz Berenice', 'no', '2000-07-28');
INSERT INTO `guerreros2018` VALUES ('219', 'KAREN ANAHÍ PEREZ ZAPATA', '17', 'C', 'NUEVA VIDA', '7712072048', 'neitan.morales@gmail.com', 'NUEVA VIDA', '\0', '\0', '', '1550', 'A', 'F', 'KAREN ANAHÍ', 'V', '2000-09-20');
INSERT INTO `guerreros2018` VALUES ('220', 'Zabdi Asaph Flores Cobos', '13', 'M', 'Pachuca', ' 7713869844', 'markafloz@gmail.com', 'Aprender ', '\0', '\0', '', '1550', 'A', 'M', 'Asaph', '', '2005-01-18');
INSERT INTO `guerreros2018` VALUES ('221', 'Estefanía Cisneros García', '12', 'C', '1', '1', 'neitan.morales@gmail.com', '1', '\0', '\0', '', '1550', 'A', 'F', '1', '1', '2006-01-01');
INSERT INTO `guerreros2018` VALUES ('222', 'Luis Alberto Cisneros Malacara', '24', 'M', '1', '1', 'neitan.morales@gmail.com', '1', '', '\0', '', '1550', 'A', 'M', '1', '1', '1994-01-01');
INSERT INTO `guerreros2018` VALUES ('223', 'Alejandra Rivera Agis', '18', 'M', '1', '1', 'neitan.morales@gmail.com', '1', '\0', '\0', '', '1550', 'A', 'F', '1', '1', '2000-01-01');
INSERT INTO `guerreros2018` VALUES ('224', 'Carolina', '13', 'C', '1', '1', 'neitan.morales@gmail.com', '1', '\0', '\0', '', '1550', 'A', 'F', '1', '1', '2005-01-01');
INSERT INTO `guerreros2018` VALUES ('225', 'Saraí Perez', '16', 'C', '1', '1', '1', '1', '\0', '\0', ' ', '1550', 'A', 'F', 'Sarí', '1', '2005-01-01');
INSERT INTO `guerreros2018` VALUES ('226', 'Diana Mota Fernández ', '16', 'M', '1', '1', '1', '1', '\0', '\0', ' ', '1550', 'A', 'F', ' ', '1', '2012-01-01');
INSERT INTO `guerreros2018` VALUES ('227', 'Denisse Guadiana Alcantara', '19', 'C', 'Estado de Mexici', '5549423561', 'denigu99@hotmail.com', 'Invitación ', '\0', '\0', '', '1550', 'A', 'F', 'Deni', 'No', '1998-08-31');
INSERT INTO `guerreros2018` VALUES ('228', 'Gabi Chapa', '15', 'C', 'pib', 'pib', 'neitan.morales@gmail.com', 'pin', '\0', '\0', ' ', '1550', 'A', 'F', 'Gabi', 'no', '2003-01-01');
INSERT INTO `guerreros2018` VALUES ('229', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'A', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('230', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'A', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('231', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'A', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('232', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'A', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('233', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'A', 'v', '1', '1', '0000-00-01');
INSERT INTO `guerreros2018` VALUES ('234', '', null, '', '', '', '', '', '\0', '\0', '', '1550', 'A', '', '', '', '0000-00-00');
INSERT INTO `guerreros2018` VALUES ('235', 'urupididusuy', null, 'M', '', '139', 'owejucome@saxmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'urupididusuy', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('236', 'ilimpobuco', null, 'XG', '', '7844', 'umieguom@ejmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'ilimpobuco', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('237', 'uxeomjalaux', null, 'XG', '', '7550', 'arejif@inemail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'uxeomjalaux', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('238', 'adeyimunufoqu', null, 'XXG', '', '7382', 'idazuq@saxmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'adeyimunufoqu', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('239', 'onleqoqiraeku', null, 'M', '', '1900', 'igiazqu@ejmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'onleqoqiraeku', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('240', 'auwumijwipe', null, 'M', '', '7817', 'uzoxupie@apimail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'auwumijwipe', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('241', 'eyupovuven', null, 'M', '', '6877', 'oyimfaqeb@saxmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'eyupovuven', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('242', 'osasabema', null, 'XG', '', '964', 'uwamimofu@eajmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'osasabema', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('243', 'uzeninikin', null, 'XG', '', '5781', 'oraped@icemail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'uzeninikin', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('244', 'ekoworad', null, 'XXG', '', '5869', 'ohagav@edomail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'ekoworad', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('245', 'ujurosaa', null, 'XG', '', '9015', 'donibige@saxmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'ujurosaa', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('246', 'anaeorer', null, 'XG', '', '6870', 'ebeconube@apimail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'anaeorer', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('247', 'hexulvbutezi', null, 'M', '', '4631', 'ocajeba@eajmail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'hexulvbutezi', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('248', 'ojawemugo', null, 'M', '', '1792', 'otiwig@icemail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'ojawemugo', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('249', 'euhaojabaxiye', null, 'M', '', '9032', 'ubatudux@civimail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'euhaojabaxiye', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('250', 'usteaeqi', null, 'M', '', '7606', 'ojaderik@civimail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'usteaeqi', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('251', 'aehipozada', null, 'XG', '', '9221', 'ovabevafe@axumail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'aehipozada', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('252', 'ikazaraheano', null, 'M', '', '9845', 'uyewiyore@axumail.com', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', '\0', '\0', '', '1550', 'A', 'M', 'ikazaraheano', 'http://doxycycline-cheapbuy.site/ - doxycycline-cheapbuy.site.ankor <a href=\"http://onlinebuycytotec.site/\">onlinebuycytotec.site.ankor</a>', null);
INSERT INTO `guerreros2018` VALUES ('253', '1', null, 'val', '1', '1', '1', '1', '\0', '\0', '', '1550', 'A', 'v', '1', '1', '0000-00-01');

-- ----------------------------
-- Table structure for guerreros2019
-- ----------------------------
DROP TABLE IF EXISTS `guerreros2019`;
CREATE TABLE `guerreros2019` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `fechanac` date DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `talla` varchar(3) DEFAULT NULL,
  `vienede` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(12) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `alergias` varchar(255) DEFAULT NULL,
  `razones` varchar(255) DEFAULT NULL,
  `staff` smallint(1) DEFAULT NULL,
  `confima_pago` smallint(1) DEFAULT NULL,
  `nomero_ticket` varchar(50) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT 1550,
  `status` varchar(1) DEFAULT NULL,
  `contacto_tutor` varchar(12) DEFAULT NULL,
  `iglesia` varchar(50) DEFAULT NULL,
  `fechahora_registro` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros2019
-- ----------------------------
INSERT INTO `guerreros2019` VALUES ('1', 'VICTO ALLAN JAEN REYES', 'ALLAN', '2002-07-08', '17', 'M', 'CH', 'ECATEPEC', '5558956910', 'allanjaen0@gmail.com', 'NINGUNA', 'SOY STAFF', '1', '0', '', '0', 'A', '5576833129', 'LAS AMERICAS ', '2019-04-21 09:33:53');
INSERT INTO `guerreros2019` VALUES ('2', 'CAROLINA ROSAS AGUILAR', 'CARO', '1991-04-30', '28', 'F', 'G', 'PACHUCA', '7711784114', 'carolinarosas30@gmail.com ', 'NINGUNA', ':) ', '1', '0', '', '0', 'A', '7712367386', 'AMISTAD CRISTIANA', '2019-04-21 09:33:59');
INSERT INTO `guerreros2019` VALUES ('3', 'JOSELINA SEVILLA PALAFOX', 'LINA PALAFOX ', '1998-04-04', '21', 'F', 'CH', 'ESTADO DE MEXICO', '5543591868', 'joselina100@gmail.com', 'NINGUNA ', 'RETO URBANO ', '1', '0', '', '0', 'A', '5586721831', 'CASA DE ORACION', '2019-04-21 09:34:06');
INSERT INTO `guerreros2019` VALUES ('4', 'JOSE ANTONIO RUBIO GONZALEZ', 'JOSE', '2002-05-17', '17', 'M', 'M', 'LAS AMERICAS ECATEPEC', '55 3392 5646', 'jr717531@gmail.com', 'JAMON ', 'SERVIDOR', '1', '0', '', '0', 'A', '5584046396', 'AMISTAD CRISTIANA LAS AMERICAS', '2019-04-21 09:34:46');
INSERT INTO `guerreros2019` VALUES ('5', 'EVAN DANIEL HERNANDEZ PEREZ', 'EVAN', '2004-09-02', '15', 'M', 'XC', 'PACHUCA', '619 874 2524', 'evannet099@gmail.com', 'NINGUNA', 'APRENDER MAS DE DIOS ', '1', '0', '', '0', 'A', '7712088634', 'SAMA', '2019-04-21 09:35:29');
INSERT INTO `guerreros2019` VALUES ('6', 'ANA REYES GUERRERO ', 'ANII ', '1998-05-12', '21', 'F', 'XC', 'GUANAJUATO ', '476 113 0131', 'ana_reyesgro@outlook.com ', 'NINGUNA', 'STAFF', '1', '0', '', '0', 'A', '477 244 3589', 'LA GRAN COMISIÓN ', '2019-04-21 09:35:34');
INSERT INTO `guerreros2019` VALUES ('7', 'LINETTE ROLDAN MARTINEZ ', 'LINETTE', '1997-03-22', '22', 'F', 'CH', 'PACHUCA', '5535924475', 'linette.yazmin@gmail.com', 'GLUTEN, SUFULAS', 'POR QUE NO? ????????', '1', '0', '', '0', 'A', '5529676404', 'CORNERSTONE ', '2019-04-21 09:35:38');
INSERT INTO `guerreros2019` VALUES ('8', 'JAZMIN', 'JAZ.??', '2003-10-17', '16', 'F', 'CH', 'ECATEPEC', '55 1700 5613', 'jazminlamejor1517@outlook.es', 'NO', 'PORQUE SOY STAFF Y QUIERO SERVIRLE A DIOS.????', '1', '0', '', '0', 'A', '(55) 3731 59', 'AMISTAD CRISTIANA LAS AMERICAS', '2019-04-21 09:36:09');
INSERT INTO `guerreros2019` VALUES ('9', 'ARMANDO ARATH LARA SUÁREZ ', 'ARATH LARA', '2001-08-15', '18', 'M', 'M', 'ECATEPEC ', '5510484805', 'arath-lara@outlook.es ', 'NINGUNA', 'SERVIR ', '1', '0', '', '0', 'A', '5510484805', 'LAS AMÉRICAS ', '2019-04-21 09:37:07');
INSERT INTO `guerreros2019` VALUES ('10', 'CAROLINA ITZEL HERNANDEZ GUERR', 'CARO ', '2005-06-12', '14', 'F', 'XC', 'HIDALGO', '7712330446', 'carolinaparker317@gmail.com', 'NINGUNA', 'COMUNION CON DIOS Y ESTABLECER AMOR CON LOS DEMAS', '1', '0', '', '0', 'A', '7711747711', 'SAMA', '2019-04-21 09:37:08');
INSERT INTO `guerreros2019` VALUES ('11', 'ROMERO JUAREZ ', 'MARY', '2002-06-16', '17', 'F', 'M', 'ECATEPEC DE MORELOD', '5531176986', 'mary. rj@hotmail.com', 'PENICILINA ', 'AMO RETO. BAI', '1', '0', '', '0', 'A', '5548396278', 'AMISTAD CRISTIANA LAS AMERICA\'S ECATEPEC', '2019-04-21 09:37:43');
INSERT INTO `guerreros2019` VALUES ('12', 'RICHZ VOLTA', 'RICHZ', '1975-01-18', '44', 'M', 'CH', 'PACHUCA ', '7712088634', 'richjucum@gmail.com', 'NINGUNA', 'SOY EL VOLTA ', '1', '0', '', '0', 'A', '7712088634', 'FARO PACHUCA', '2019-04-21 09:37:58');
INSERT INTO `guerreros2019` VALUES ('13', 'MARIJOSE SEVILLA PALAFOX', 'MAJO ', '2003-05-24', '16', 'F', 'XC', 'ESTADO DE MEXICO', '5567565906', 'sevillapalafox@gmail.com', 'NINGUNA', 'POR AMOR ', '1', '0', '', '0', 'A', '5586721831', 'CASA DE ORACION ', '2019-04-21 09:38:08');
INSERT INTO `guerreros2019` VALUES ('14', 'VÍCTOR LEVÍ REYES SUAREZ', 'LEVÍ', '2000-07-21', '19', 'M', 'M', 'ECATEPEC', '5572810808', 'lvrs17@gmail.com', 'NINGUNA ', 'SERVICIO, AMOR, RETO DE DIOS', '1', '0', '', '0', 'A', '5540243493', 'AMISTAD CRISTIANA LAS AMÉRICAS', '2019-04-21 09:38:24');
INSERT INTO `guerreros2019` VALUES ('15', 'BRAULIO AARON LARA SUAREZ', 'BRAU ', '2002-10-30', '17', 'M', 'M', 'LAS AMERICAS', '5527591377', 'braulara712@gmail.com', 'NADA', 'SERVIDOR ', '1', '0', '', '0', 'A', '5563518800', 'AMISTAD CRISTIANA LAS AMERICAS', '2019-04-21 09:38:32');
INSERT INTO `guerreros2019` VALUES ('16', 'URIEL VELA SOTO', 'URIEL VELA', '1998-03-02', '21', 'M', 'M', 'TECAMAC, EDO. DE MEX.', '5510446318', 'velhost22@gmail.com', 'GATOS', 'PARA AYUDAR A OTROS A CONOCER A DIOS, ESCUCHAR SU VOZ, Y DAR EL SIGUIENTE PASO CON ÉL', '1', '0', '', '0', 'B', '5543622411', 'AMISTAD CRISTIANA LOS PINOS', '2019-04-21 09:39:10');
INSERT INTO `guerreros2019` VALUES ('17', 'FATIMA CURIEL ARMENTA', 'CURI', '1999-09-03', '20', 'F', 'M', 'ESTADO DE MEXICO', '5521081116', 'fatigol99@hotmail.com', 'NINGUNA', 'SERVIR A DIOS ', '1', '0', '', '0', 'A', '5529431237', 'AMISTAD CRISTIANA LAS AMERICAS', '2019-04-21 09:39:11');
INSERT INTO `guerreros2019` VALUES ('18', 'ELENA GABRIELA BUSTOS HDEZ', 'ELENITA', '2004-10-22', '15', 'F', 'CH', 'DE PACHUCA HIDALGO', '5529498802', 'brillantetita@gmail.com', 'NINGUNA', 'PARA SEGUIR MEJORANDO EN DIOS Y MOSTRAS SU AMOR Y FELICIDAD??', '1', '0', '', '0', 'A', '7751557295', 'DE SAMA', '2019-04-21 09:39:22');
INSERT INTO `guerreros2019` VALUES ('19', 'JESUS MAURICIO ZARATE DIAZ', 'MAURICIO ', '1998-09-19', '21', 'M', 'M', 'PUEBLA', '2211491921', 'take69888@gmail.com', 'POLVO', 'PARA SERVIR A DIOS CON MINISTERIOS ', '1', '0', '', '0', 'A', '2221129492', 'COMUNIDAD CRISTIANA DE PUEBLA', '2019-04-21 09:39:51');
INSERT INTO `guerreros2019` VALUES ('20', 'SARAI GUEVARA', 'SARAI', '1998-12-22', '21', 'F', 'XC', 'GUANAJUATO', '4767380710', 'saraig980@gmail.com', 'conjuntivitis', 'STAFF', '1', '0', '', '0', 'A', '4761042106', 'CDO (CASA DE ORACION)', '2019-04-21 09:40:39');
INSERT INTO `guerreros2019` VALUES ('21', 'EMILIO ESTEBAN GONZALEZ MARTIN', 'EMI', '1997-12-13', '22', 'M', 'CH', 'ESTADO DE MEXICO', '5532216785', 'esgm97@hotmail.com', 'PLATANO Y MANZANA', 'QUIERO TENER UNA SEMANA DE INTIMIDAD CON DIOS', '0', '0', '', '0', 'B', '5518801801', 'CASA DE ORACION ', '2019-04-21 09:42:14');
INSERT INTO `guerreros2019` VALUES ('22', 'ANA GABRIELA GARCIA GUERRERO ', 'BANANA ', '1991-02-18', '28', 'F', 'XC', 'PACHUCA', '5554946662', 'ananorge1553@gmail.com', 'NINGUNA', 'A SERVIR ESE', '1', '0', '', '0', 'A', '69957496', 'CORNESTONE', '2019-04-21 09:43:10');
INSERT INTO `guerreros2019` VALUES ('23', 'CHARI CAUDILLO BAÑOS', 'CHARLOTTE', '1998-01-16', '0', 'M', 'G', 'CDMX', '7228555123', 'charlicaudillob@gmail.com', 'NINGUNA', 'A SERVIR ', '1', '0', '', '0', 'A', '7715254206', 'PIB PACHUCA ', '2019-04-21 09:43:44');
INSERT INTO `guerreros2019` VALUES ('24', 'SALMA ISABEL MARTÍNEZ CALDERÓN', 'SALMI', '2001-12-24', '18', 'F', 'M', 'PACHUCA', '7713960050', 'salma.marca@gmail.com ', 'JABÓN EN POLVO ', 'SOY Staff y en el campamento anterior Dios me habló de una manera impresionante, siento que él tiene algo grande preparado para mí en esta ocasión ', '1', '0', '', '0', 'A', '7712025045', 'TIERRA DESEABLE', '2019-04-21 09:43:50');
INSERT INTO `guerreros2019` VALUES ('25', 'LUIS MIGUEL MARTINEZ ALMAGUER', 'MIGUEL', '2000-06-09', '19', 'M', 'CH', 'ESTADO DE MÉXICO', '5545752813', 'luishardy2000@live.com', 'NINGUNA ', 'INVITACION, CONOCER MAS DE DIOS Y TENER MAS INTIMIDAD CON CRISTO', '0', '0', '', '0', 'B', '5527553341', 'CASA DE ORACIÓN', '2019-04-21 09:49:49');
INSERT INTO `guerreros2019` VALUES ('26', 'JAHAZIEL PEREIRA', 'JAHAZIEL', '1997-10-20', '22', 'M', 'G', 'PACHUCA', '5583046771', 'jahazielypr@gmail.com', 'NO', 'LO AMO', '1', '0', '', '0', 'A', '5513530776', 'JUCUM', '2019-04-21 09:53:35');
INSERT INTO `guerreros2019` VALUES ('27', 'CITLALI PEREZ MARTINEZ ', 'CITLALI', '1980-05-13', '39', 'F', 'CH', 'PACHUCA', '7717221473', 'citlalijucum@gmail.com', 'NINGUNA', 'SOY LIDER Y AMO A ESTOS CHAMACOS ', '1', '0', '', '0', 'A', '7717221473', 'JUCUM', '2019-04-21 09:53:36');
INSERT INTO `guerreros2019` VALUES ('28', 'PAMELA URIBE D LUCIO', 'PAME', '1986-09-26', '33', 'F', 'CH', 'CIUDAD DE MEXICO', '5534014625', 'uripamela@gmail.com', 'NINGUNA', 'DESEO DE SERVIR A LOS ADOLESCENTES Y JOVENES DE MI PAIS', '1', '0', '', '0', 'B', '5541780044', 'AMISTAD CRISTIANA', '2019-04-21 21:14:50');
INSERT INTO `guerreros2019` VALUES ('29', 'LILIAN ALINE LOPEZ ROMERO', 'LILY', '2000-03-13', '19', 'F', 'CH', 'ECATEPEC', '5529211568', 'lilianlr09@hotmail.com', 'NINGUNA', 'APRENDER SOBRE EL SERVICIO PARA DIOS', '1', '0', '', '0', 'A', '5570589818', 'AMITAD CRISTIANA', '2019-04-21 21:53:01');
INSERT INTO `guerreros2019` VALUES ('31', 'MACIEL SALAS MACIEL', 'MACI', '2001-12-31', '18', 'F', 'CH', 'ECATEPEC', '5525264159', 'vero.romero.salas@hotmail.com', 'NO', 'PORQUE NECESITO DE DIOS', '0', '0', '', '0', 'B', '5513061465', 'AMISTAD CRISTIANA LAS AMERICAS', '2019-04-22 14:20:10');
INSERT INTO `guerreros2019` VALUES ('32', 'MARIANA JAMEL NAVARRO RANGEL', 'JAMEL', '2002-09-24', '17', 'M', 'CH', 'SAN FRANCISCO DEL RINCON GTO', '4766566188', 'mariana.jam24@gmail.com', 'NINGUNA.', 'ES UN CAMPAMENTO ICREIBLE, QUIERO APRENDER MAS DE DIOS Y CRECER EN EL, TENIENDO UN TIEMPO APARTADO SOLO PARA EL Y PARA MI.', '0', '0', '', '0', 'A', '7432732', 'CASA DE ORACION', '2019-04-22 15:01:11');
INSERT INTO `guerreros2019` VALUES ('33', 'PAMELA CEJA UNZAGA', 'PAME', '1999-04-09', '20', 'F', 'M', 'MEXICO', '5545370865', 'pamelacejau0904@gmail.com', 'PENICILINA', 'PARA CONOCER MAS DE DIOS Y DARLO A CONOCER ', '0', '0', '', '0', 'B', '5527114150', 'PALABRA DE FE', '2019-04-22 16:08:03');
INSERT INTO `guerreros2019` VALUES ('34', 'ALAN ISAI MENDEZ MORENO', 'ALAN ', '2005-06-02', '14', 'M', 'M', 'CDMX', '5513601893', 'acilegna.x@hotmail.com', 'NINGUNA', 'RECOMENDADO', '0', '0', '', '0', 'A', '5513601893', 'AMISTAD CRISTIANA', '2019-04-22 16:32:31');
INSERT INTO `guerreros2019` VALUES ('35', 'ANGEL EDUARDO GRANADOS PERES', 'ANGEL', '2003-02-18', '16', 'M', 'M', 'DE PACHUCA', '7712797263', 'angel20primeroc@gmail.com', 'NINGUNA', 'PARA APRENDER MAS DE LA PALABRA DE DIOS Y QUE DIOS PUES TRASTORNAR EN MI VIDA????', '0', '0', '', '0', 'A', '7711124927', 'PIB', '2019-04-22 20:59:02');
INSERT INTO `guerreros2019` VALUES ('36', 'KARLA FABIOLA OLIVARES RAMIREZ', 'KARLA', '2004-03-20', '15', 'F', 'CH', 'GUANAJUATO ', '4761368791 ', 'ana_reyesgro@outlook.com ', 'PENICILINA ', 'INVITADA DE ANII REYES ', '0', '0', '', '0', 'A', '4761456666', 'LA GRAN COMISIÓN ', '2019-04-22 21:04:40');
INSERT INTO `guerreros2019` VALUES ('37', 'JORGE ANTONIO ESPINOSA TORRES ', 'JORGE ', '2004-03-16', '15', 'M', 'CH', 'GUANAJUATO ', '4761574238', 'ana_reyesgro@outlook.com ', 'NINGUNA ', 'INVITADO DE ANII REYES ', '0', '0', '', '0', 'A', '4761167384', 'LA GRAN COMISIÓN ', '2019-04-22 21:09:36');
INSERT INTO `guerreros2019` VALUES ('38', 'ZARET SINAI REYES SANTOS ', 'SINAI ', '2001-10-15', '18', 'F', 'M', 'GUANAJUATO ', '4761299644', 'ana_reyesgro@outlook.com ', 'NINGUNA ', 'INVITADA DE ANII REYES ', '0', '0', '', '0', 'B', '4767063185', 'LA GRAN COMISIÓN ', '2019-04-23 10:11:32');
INSERT INTO `guerreros2019` VALUES ('39', 'LUZ ALEJANDRA MENDOZA CAMACHO', 'ale', '1999-03-31', '20', 'F', 'CH', 'Estado de México', '5540783508', 'alemendozac@outlook.com', 'NO', '\nJUCUM PACHUCA HA SIDO LA BENDICIÓN MÀS GRANDE Y HERMOSA DE MI VIDA ,DESDE LA PRIMERA VEZ QUE LLEGUE A MI PRIMER CAMPAMENTO EN RETO URBANO DIOS CAMBIO TOTALMENTE MI VIDA Y LA FORMA DE VER A LAS PERSONAS QUE ME RODEAN Y MI RELACIÓN CON DIOS ', '1', '0', '', '0', 'A', '5516469106', 'Centro de Restauración y Avivamiento', '2019-04-23 16:17:52');
INSERT INTO `guerreros2019` VALUES ('40', 'YAIL CHAVEZ ALEMAN ', 'YAIL', '2003-10-06', '16', 'M', 'M', 'TECAMAC ESTADO DE MEXICO ', '5544803200', 'chinoy51@yahoo.com.mx', 'NINGUNA', 'PARA CONOCER MAS DE DIOS ', '0', '0', '', '0', 'A', '5543633356', 'CASA DE ADORACION ', '2019-04-29 15:01:47');
INSERT INTO `guerreros2019` VALUES ('41', 'MARCOS DANIEL ARISTA GUTIÉRREZ', 'DANY', '2004-07-20', '15', 'M', 'M', 'TLALNEPANTLA EDO MÉX. ', '5539277000', 'masterista@gmail.com', 'NINGUNA', 'POR RECOMENDACIÓN Y POR QUE TENGA UNA EXPERIENCIA A ESTA EDAD CON DIOS Y CON PARTE DE SU PUEBLO. REGALO DE CUMPLEAÑOS MUCHAS GRACIAS', '0', '0', '', '0', 'A', '5539277000', 'CENTRO CRISTIANO CALACOAYA', '2019-05-04 22:04:06');
INSERT INTO `guerreros2019` VALUES ('42', 'SAUL JOSADAC JIMENEZ SANCHEZ', 'JOSADAC JIMENEZ', '2002-06-18', '17', 'M', 'XXL', 'ESTADO DE MEXICO', '5512861780', 'ojosadac1@gmail.com', 'BAÑARME', 'ME ENCANTO EL AMBIENTE Y LAS PERSONAS', '1', '0', '', '0', 'A', '5512861780', 'CENTRO CRISTIANO CALACOAYA', '2019-05-13 11:10:22');
INSERT INTO `guerreros2019` VALUES ('43', 'CARMEN RAQUEL GUEVARA SUÁREZ', 'RAQUEL', '2000-02-11', '19', 'F', 'M', 'PACHUCA HIDALGO', '7713007327', 'car-101@hotmail.com', 'SULFAS Y NUECES', 'UNA AMIGA ME RECOMENDO INSCRIBIRME Y ME GUSTARIA CONOCER REALMENTE A DIOS ', '0', '0', '', '0', 'A', '1071277', 'TIERRA DESEABLE ', '2019-05-13 15:32:58');
INSERT INTO `guerreros2019` VALUES ('44', 'CESAR ULISES HUERTA OCHOA ', 'CESAR HUERTA ', '1996-03-24', '23', 'M', 'M', 'ESTADO DE MÉXICO ', '5531502171', 'madona_zet@hotmail.com', 'PERROS', 'PARA ESTAR MAS CERCAS DE DIOS Y REGRESAR A SU CAMINO ', '0', '0', '', '0', 'B', '20642585', 'PAN DE VIDA CUAUTITLAN ', '2019-05-16 08:36:34');
INSERT INTO `guerreros2019` VALUES ('45', 'VELEZ REGINA', 'REGINA', '2004-11-18', '15', 'F', 'XC', 'PUEBLA ', '2224741218', 'valeria.martínez.mtz@gmail.com', 'NO', 'CONOCER MÁS A DIOS', '0', '0', '', '0', 'B', '012226635657', 'EL PUENTE', '2019-05-16 20:42:35');
INSERT INTO `guerreros2019` VALUES ('46', 'IVONNE GAMERO', 'BON ', '1995-06-26', '24', 'F', 'XC', 'ECATEPEC', '5522709896', 'ivon26gamero@gmail.com', 'NINGUNA', ' RETO URBANO HA  CAMBIADO MI VIDA, LA DE MI FAMILIA Y LA FORMA DE VER A DIOS, QUIERO IR MAS PROFUNDO CON EL', '1', '0', '', '0', 'A', '54426947', 'AMISTAD CRISTIANA ', '2019-05-16 23:07:49');
INSERT INTO `guerreros2019` VALUES ('47', 'MARIAN SANCHEZ', 'MARIAN ST', '1999-12-18', '20', 'F', 'M', 'ESTADO DE MEX ', '5535256212', 'mariansanchezt@gmail.com', 'SULFAS', 'AMO RU ??????', '0', '0', '', '0', 'B', '5537347908', 'NO TENGO ', '2019-05-17 06:03:51');
INSERT INTO `guerreros2019` VALUES ('48', 'MARIAN SANCHEZ', 'MARIAN ST', '1999-12-18', '20', 'F', 'M', 'ESTADO DE MEX ', '5535256212', 'mariansanchezt@gmail.com', 'SULFAS', 'AMO RU ??????', '1', '0', '', '0', 'A', '5537347908', 'NO TENGO ', '2019-05-17 06:03:52');
INSERT INTO `guerreros2019` VALUES ('49', 'BENJAMIN ISAAC GODINEZ COSS', 'ISAAC', '2002-12-16', '17', 'M', 'M', 'GUADALAJARA', '3312051504', 'carmen.coss@enlaceoccidente.edu.mx', 'NO', 'CONVIVENCIA', '1', '0', '', '0', 'A', '3331571478', 'ORIGEN', '2019-05-17 16:22:37');
INSERT INTO `guerreros2019` VALUES ('50', 'CHRISTOPHER MANCILLA RODRIGUEZ', 'CHRIS', '2002-11-09', '17', 'M', 'M', 'PACHUCA HIDALGO', '5530518303', 'ahinoam.rodca@gmail.com', 'NINGUNA', 'DESEO VIVIR UNA CONEXIÓN CON DIOS Y ENCONTRAR SU PROPÓSITO', '0', '0', '', '0', 'A', '5516313517', 'CORNERSTONE', '2019-05-17 22:43:05');
INSERT INTO `guerreros2019` VALUES ('51', 'RAQUEL HERRERA CORRALES', 'RAQUEL', '1996-08-15', '23', 'F', 'M', 'COSTA RICA', '+50660978145', 'Raquelhc15@gmail.com', 'NO', 'Acercarme mas a Dios', '0', '0', '', '0', 'B', '+50686796086', 'LA HERMOSA ESPERANZA', '2019-05-18 22:41:45');
INSERT INTO `guerreros2019` VALUES ('52', 'MARIBEL PÉREZ LÓPEZ', 'MARIBEL', '2003-09-17', '16', 'F', 'CH', 'SAN FRANCISCO DEL RINCON, GTO', '4761460931', 'perezlopezm831@gmail.com', 'NINGUNA', 'QUIERO VIVIR ESA EXPERIENCIA', '0', '0', '', '0', 'A', '4761040628', 'CASA DE ORACIÓN', '2019-05-20 12:03:30');
INSERT INTO `guerreros2019` VALUES ('53', 'JUAN ANTONIO? GONZÁLEZ? MURILL', 'TONY', '2002-10-26', '17', 'M', 'M', 'SAN FRANCISCO? DEL? RINCÓN? GTO', '4761326023', 'tontoby@gmail.com', 'NINGUNA ', 'PARA? APRENDER? MAS DE DIOS? QUE? ME? RECUERDE QUIEN SOY REALMENTE?. SABER CUÁL? ES EL PROPÓSITO?QUE EL TIENE? PARA? MI VIDA?. QUIERO? RECUPERAR? TODO? LO QUE PERDÍ', '0', '0', '', '0', 'A', '4761358079', 'CASA DE ORACIÓN?', '2019-05-20 17:26:31');
INSERT INTO `guerreros2019` VALUES ('54', 'JOSÉ PABLO BRENES BOGANTES', 'PABLO', '1989-08-20', '30', 'M', 'CH', 'COSTA RICA', '+50686120017', 'jbrenes20@gmail.com', 'SI', 'TIEMPO CON DIOS ', '0', '0', '', '0', 'A', '+50624513130', 'LA HERMOSA ESPERANZA', '2019-05-22 21:19:37');
INSERT INTO `guerreros2019` VALUES ('55', 'Dulce Maria Mendoza Camacho', 'DULCE', '1999-03-31', '20', 'F', 'XC', 'Estado de Mexico', '5584835382', 'Dulcemendozac@outlook.es', 'NINGUNA', 'Es el mejor campamento', '1', '0', '', '0', 'A', '5516469106', 'CRA Espiritu Santo', '2019-05-23 21:17:26');
INSERT INTO `guerreros2019` VALUES ('56', 'CARRIE EVELYN GAMERO ROSALES', 'CARRIE', '1994-07-14', '25', 'F', 'CH', 'CIUDAD DE MEXICO', '5516086100', 'carriecarriehernandez@outlook.com', 'NINGUNA', 'ME GUSTARÍA REALMENTE CONOCER A DIOS COMO PADRE, HE ESTADO BUSCANDO TENER UN ENCUENTRO PROFUNDO CON EL.', '0', '0', '', '0', 'A', '54426947', 'AMISTAD CRISTIANA ECATEPEC', '2019-05-24 20:55:14');
INSERT INTO `guerreros2019` VALUES ('57', 'SEBASTIAN CEDRIC MORALES ABREU', 'SEBASTIAN', '2003-12-22', '16', 'M', 'CH', 'CIUDAD DE MEXICO', '5564319257', 'susanabreu@live.com', 'NINGUNA', 'PARA AMPLIAR MI RELACION CON DIOS', '0', '0', '', '0', 'A', '5528429330', 'SELAH', '2019-05-25 17:20:21');
INSERT INTO `guerreros2019` VALUES ('58', 'FRIDA DANIELA MORALES ABREU', 'DANY', '2001-11-23', '18', 'F', 'XC', 'CIUDAD DE MEXICO', '5528429330', 'susanabreu@live.com', 'NINGUNA', 'QUE LOS PROPOSITOS DE DIOS SE CUMPLAN EN MI VIDA', '0', '0', '', '0', 'A', '5528429330', 'SELAH', '2019-05-25 19:03:53');
INSERT INTO `guerreros2019` VALUES ('59', 'MELISSA GUADALUPE MORALES HERN', 'MELI ', '2005-04-26', '14', 'F', 'M', 'HIDALGO PACHUCA', '5523256511', 'melissamhkss06@gmail.com', 'NADA', 'QUIERO AUN MÁS ACEPTAR A DIOS COMO MI PADRE Y SE QUE ESTE CAMPAMENTO ME AYUDARA DEMASIADO ,CONOCER AUN MAS DE EL MEDIO PERSONAS QUE ME ENSEÑEN PARA DESPUES PODER HABLAR DE LA PALABRA DE DIOS A LOS DEMAS ', '0', '0', '', '0', 'B', '7712067605', 'NINGUNA', '2019-05-29 15:27:47');
INSERT INTO `guerreros2019` VALUES ('60', 'LUISA FERNANDA SANCHEZ HERNAND', 'LUISAFER', '2004-05-18', '15', 'F', 'M', 'SAN FRANCISCO DEL RINCON ', '4761443466', 'soyluisafernanda1818@outlook.com', 'NO', 'TENER UNA EXPERIENCIA INOLVIDABLE ', '0', '0', '', '0', 'A', '4761067917', 'CDO ', '2019-05-30 22:12:02');
INSERT INTO `guerreros2019` VALUES ('61', 'DAVID GARCIA SOLACHE', 'DAVID', '2000-07-19', '19', 'M', 'M', 'ESTADO DE MÉXICO', '5566965431', 'thealchimist20@gmail.com', 'NINGUNA', 'PARA CONOCER MAS A DIOS ', '0', '0', '', '0', 'A', '5611678881', 'CENTRO CRISTIANO CALACUAYA', '2019-06-02 09:12:00');
INSERT INTO `guerreros2019` VALUES ('62', 'STEVE GARRETT', 'STEVE', '1963-08-04', '56', 'M', 'G', 'NASHVILLE ', '4154165', '9849848', 'NINGUNA', 'SERVIR ', '0', '0', '', '0', 'A', '754184', 'ESTADOS UNIDOS', '2019-06-04 14:48:52');
INSERT INTO `guerreros2019` VALUES ('63', 'MILISSA GARRETT', 'MILISSA', '1970-03-05', '49', 'F', 'M', 'NASHVILLE', '516515', '+54894', 'NINGUNA', 'SERVIR', '0', '0', '', '0', 'A', '651561', 'ESTADOS UNIDOS', '2019-06-04 14:52:30');
INSERT INTO `guerreros2019` VALUES ('64', 'GABRIEL GARRETT', 'GABRIEL', '2004-02-07', '15', 'M', 'M', 'NASHVILLE ', '545484', '5168486', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '546848', 'ESTADOS UNIDOS', '2019-06-04 14:55:28');
INSERT INTO `guerreros2019` VALUES ('65', 'ABIGAIL GARRET', 'ABIGAIL', '2004-09-16', '15', 'F', 'CH', 'NASHVILLE', '547984684', '84984', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '848478', 'ESTADOS UNIDOS', '2019-06-04 14:58:33');
INSERT INTO `guerreros2019` VALUES ('66', 'SOPHIA GARRETT', 'SOPHIA ', '2004-02-02', '15', 'F', 'CH', 'NASHVILLE', '65465848', '654684', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '545684', 'ESTADOS UNIDOS', '2019-06-04 15:00:04');
INSERT INTO `guerreros2019` VALUES ('67', 'JONATHAN PUCKETT', 'JONATHAN', '1996-11-13', '23', 'M', 'XL', 'NASHVILLE', '6546584', '684684', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '654684', 'ETADOS UNIDOS ', '2019-06-04 15:02:11');
INSERT INTO `guerreros2019` VALUES ('68', 'TIFFANY PUCKET', 'TIFFANY', '1978-11-14', '41', 'F', 'M', 'NASHVILLE', '6557781', '5176181', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '54181681', 'ESTADOS UNIDOS', '2019-06-04 15:04:04');
INSERT INTO `guerreros2019` VALUES ('69', 'HAILEY PUCKETT', 'HAILEY', '1973-03-03', '46', 'F', 'M', 'NASHVILLE ', '65684861', '65165181', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'B', '51518', 'ESTADOS UNIDOS ', '2019-06-04 15:06:15');
INSERT INTO `guerreros2019` VALUES ('70', 'JACK PUCKETT', 'JACK', '2003-08-10', '16', 'M', 'M', 'NASHVILLE', '6548618818', '651681681', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '6518181', 'ESTADOS UNIDOS', '2019-06-04 15:07:51');
INSERT INTO `guerreros2019` VALUES ('71', 'CONNER PUCKETT', 'CONNER', '1974-09-12', '45', 'M', 'G', 'NASHVILLE', '5651681', '9848487', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '6548481', 'ESTADOS UNIDOS', '2019-06-04 15:09:34');
INSERT INTO `guerreros2019` VALUES ('72', 'BEN WOMER', 'BEN', '1975-07-14', '44', 'M', 'M', 'NASHVILLE ', '541778181', '81818918', 'NBINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '516781871', 'ETADOS UNIDOS', '2019-06-04 15:10:56');
INSERT INTO `guerreros2019` VALUES ('73', 'KIRTEN BULMER ', 'KIRSTEN', '1976-03-05', '43', 'F', 'CH', 'NASHVILLE', '5168181', '8778171', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '541681861', 'ESTADOS UNIDOS', '2019-06-04 15:12:32');
INSERT INTO `guerreros2019` VALUES ('74', 'LANDYN STOLZFUS', 'LANDYN', '1974-02-04', '45', 'M', 'G', 'NASHVILLE', '6516168168', '6568891/8', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '5416848618', 'ESTADOS UNIDOS ', '2019-06-04 15:14:04');
INSERT INTO `guerreros2019` VALUES ('75', 'ADRIANNA STOLZFUS ', 'ADRIANNA ', '1974-10-12', '45', 'F', 'M', 'NASHVILLE', '651651681', '651681681', 'NINGUNA ', 'APRENDER\n\n', '0', '0', '', '0', 'A', '56168187', 'ESTADOS UNIDOS', '2019-06-04 15:16:43');
INSERT INTO `guerreros2019` VALUES ('76', 'NOAH PHILLIPS', 'NOAH', '1969-07-11', '50', 'M', 'G', 'NASHVILLE', '618181', '5468484', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '54186181', 'ESTADOS UNIDOS', '2019-06-04 15:19:15');
INSERT INTO `guerreros2019` VALUES ('77', 'GARRETT WATKINS', 'GARRETT', '1973-08-13', '46', 'M', 'M', 'NASHVILLE', '1681681', '84681861', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '681681681', 'ESTADOS UNIDOS', '2019-06-04 15:20:41');
INSERT INTO `guerreros2019` VALUES ('78', 'GARRETT WATKINS', 'GARRETT', '1973-08-13', '46', 'M', 'M', 'NASHVILLE', '1681681', '84681861', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'B', '681681681', 'ESTADOS UNIDOS', '2019-06-04 15:20:41');
INSERT INTO `guerreros2019` VALUES ('79', 'GARRETT WATKINS', 'GARRETT', '1973-08-13', '46', 'M', 'M', 'NASHVILLE', '1681681', '84681861', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'B', '681681681', 'ESTADOS UNIDOS', '2019-06-04 15:20:41');
INSERT INTO `guerreros2019` VALUES ('80', 'MADISON GOODYEAR', 'MADISON', '1974-07-16', '45', 'F', 'M', 'NASHVILLE', '5416818', '51882115255', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '6861681', 'ESTADOS UNIDOS', '2019-06-04 15:22:06');
INSERT INTO `guerreros2019` VALUES ('81', 'FOREST GOODYEAR', 'FOREST', '1974-07-15', '45', 'M', 'M', 'NASHVILLE', '581681681678', '981681681', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '6516181', 'ESTADOS UNIDOS', '2019-06-04 15:24:10');
INSERT INTO `guerreros2019` VALUES ('82', 'ABIGAIL  CREW', 'ABIGAIL', '1973-09-15', '46', 'F', 'M', 'NASHVILLE', '54168168', '68168168', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '812681818', 'ESTADOS UNIDOS', '2019-06-04 15:25:19');
INSERT INTO `guerreros2019` VALUES ('83', 'FRANCESCA BUINSMA', 'FRANCESCA', '1963-03-04', '56', 'F', 'M', 'NASHVILLE', '65816871681', '6516818187', 'NINGUNA ', 'APRENDER', '0', '0', '', '0', 'A', '816816', 'ESTADOS UNIDOS', '2019-06-04 15:26:39');
INSERT INTO `guerreros2019` VALUES ('84', 'BRYCE MUNDY', 'BRYCE', '1969-03-02', '50', 'F', 'M', 'NASHVILLE', '984984981', '65168168168', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '19818', 'ESTADOS UNIDOS', '2019-06-04 15:27:53');
INSERT INTO `guerreros2019` VALUES ('85', 'HAILEY PUCKETT', 'HAILEY', '1973-05-13', '46', 'F', 'M', 'NASHVILLE ', '454681681', '6581681681', 'GLUTEN', 'APRENDER', '0', '0', '', '0', 'A', '54168168181', 'ESTADOS UNIDOS', '2019-06-04 15:29:50');
INSERT INTO `guerreros2019` VALUES ('86', 'MICAH PARK ', 'MICAH', '2001-01-01', '18', 'M', 'G', 'SAN DIEGO', '54165151', '95841984', 'NINGUNA', 'APRENDER', '0', '0', '', '0', 'A', '658468546', 'ESTADOS UNIDOS', '2019-06-05 10:50:34');
INSERT INTO `guerreros2019` VALUES ('87', 'DAN JANGHYUN KIM', 'DAN', '1988-01-01', '31', 'M', 'M', 'SAN DIEGO', '123456789', 'abcdefghijkl', 'NO', ':)', '0', '0', '', '0', 'A', '1234567989', 'ESTADOS UNIDOS', '2019-06-05 11:24:19');
INSERT INTO `guerreros2019` VALUES ('88', 'OSCAR RAI ', 'OSCAR ', '1995-03-24', '24', 'M', 'CH', 'PUEBLA ', '2381877006', 'ocarin_777@hotmail.com', 'NO', 'ENCONTRARME CON DIOS OTRA VEZ ', '0', '0', '', '0', 'A', '2381877006', 'IGLESIA DE DIOS ', '2019-06-05 20:05:38');
INSERT INTO `guerreros2019` VALUES ('89', 'VALERIA RAMÍREZ ARIAS ', 'VALE ', '2003-06-10', '16', 'F', 'XC', 'PACHUCA', '7711982299', 'valeramirezarias@gmail.com', 'NINGUNA', 'EL AÑO PASADO MW GUSTÓ MUCHO', '1', '0', '', '0', 'A', '7717263203', 'VIENTO RECIO PACHUCA ', '2019-06-06 06:10:45');
INSERT INTO `guerreros2019` VALUES ('90', 'ERNERNESTO DÍAZ DE CASTRO GRAN', 'NETO', '1984-03-17', '35', 'M', 'M', 'PUEBLA', '2227663722', 'diazdern@hotmail.com ', 'NINGÚN ', 'ESTAR EN LOS 10 AÑOS DE RETO', '0', '0', '', '0', 'A', '2227663722', 'AMISTAD DE PUEBLA ', '2019-06-07 19:28:19');
INSERT INTO `guerreros2019` VALUES ('91', 'VEGA ALCÁNTARA ABRAHAM ISRAEL', 'VEGA', '1997-03-29', '22', 'M', 'M', 'COLONONIA LOS ANGELES IZTAPALAPA', '5510743470', 'isra-dan@hotmail.com', 'SEPTREAPSONA', 'QUIERO APRENDER MAS DE DIOS Y SERVIRLE', '0', '0', '', '0', 'A', 'ABRAHAM ISRA', 'MONTE SION ', '2019-06-07 21:07:42');
INSERT INTO `guerreros2019` VALUES ('92', 'FERNANDA LEE HERNÁNDEZ MARTÍNE', 'LEE', '2004-02-06', '15', 'F', 'G', 'HIDALGO ', '5562909854', 'fernandaleehernandezmartinez@gmail.com', 'NO', 'ES LA PRIMERA VEZ QUE ASISTO Y QUIERO SABER MAS', '0', '0', '', '0', 'A', '5544825240', 'CORNERSTONE', '2019-06-08 19:07:56');
INSERT INTO `guerreros2019` VALUES ('93', 'DANIELA ANGANY QUIROZ VERA', 'QUIROZ', '2003-10-26', '16', 'F', 'CH', 'CIUDAD DE MÉXICO', '5567773039', 'daniela.quiroz7u7@gmail.com', 'NINGUNA', 'POR QUE ES MI SEGUNDA VEZ, & ME GUSTO LA EXPERIENCIA & QUIERO SABER MÁS DIOS', '0', '0', '', '0', 'A', '5554034494', 'IGLESIA JESUCRISTO REDENTOR PERFECTO', '2019-06-09 12:32:05');
INSERT INTO `guerreros2019` VALUES ('94', 'DANIELA ANGANY QUIROZ VERA', 'QUIROZ', '2003-10-26', '16', 'F', 'CH', 'CIUDAD DE MÉXICO', '5567773039', 'daniela.quiroz7u7@gmail.com', 'NINGUNA', 'POR QUE ES MI SEGUNDA VEZ, & ME GUSTO LA EXPERIENCIA & QUIERO SABER MÁS DIOS', '0', '0', '', '0', 'B', '5554034494', 'IGLESIA JESUCRISTO REDENTOR PERFECTO', '2019-06-09 12:32:06');
INSERT INTO `guerreros2019` VALUES ('95', 'SAMANTHA DIONISIO ROMERO ', 'SAM', '1996-03-16', '23', 'F', 'CH', 'ECATEPEC ', '7712181962', 'sadiro1810@gmail.com ', 'SULFAS ', 'SEGUIR EN LA AVENTURA ', '0', '0', '', '0', 'B', '5513061465', 'AMISTAD CRISTIANA LAS AMÉRICAS ', '2019-06-10 10:21:22');
INSERT INTO `guerreros2019` VALUES ('96', 'RAYMOND LEE', 'RAYMOND', '1994-01-01', '25', 'M', 'M', 'SAN DIEGO', '123456789', 'lokijuyhtglolo', 'NINGUNA', '(:', '0', '0', '', '0', 'A', '9874563321', 'ABUNDANT LIFE COMMUNITY', '2019-06-10 11:59:55');
INSERT INTO `guerreros2019` VALUES ('97', 'JORGE OLGUIN CASTILLA', 'JORGE', '1997-11-16', '22', 'M', 'G', 'AZCAPOTZALCO ', '5548473694', 'ras.jorgeolg@gmail.com', 'NO', 'CONOCER DE DIOS, APRENDER A ESCUCHAR Y OBEDECER', '0', '0', '', '0', 'A', '53193434', 'FARO', '2019-06-10 20:43:00');
INSERT INTO `guerreros2019` VALUES ('99', 'ANDREA MIRANDA SANCHEZ ', 'ANDY ', '2002-09-14', '17', 'F', 'CH', 'ESTADO DE MEXICO ', '5516178745', 'andreamirandasanchez11@gmail.com', 'A NADA ', 'QUIERO APRENDER COSAS NUEVAS Y TENER UNA NUEVA EXPERIENCIA ', '0', '0', '', '0', 'A', '5591688073', 'CENTRO CRISTIANO CALACOAYA', '2019-06-13 15:55:40');
INSERT INTO `guerreros2019` VALUES ('100', 'XIMENA MIRANDA SANCHEZ', 'XIME', '2004-09-24', '15', 'F', 'CH', 'ESTADO DE MEXICO', '5527478804', 'sanchezmenax09@gmail.com', 'NINGUNA', 'ME INVITARON Y ME PALTICARON Y ME AGRADO Y QUIERO EXPERIMENTAR ', '0', '0', '', '0', 'A', '5591688073', 'CENTRO CRISTIANO CALACOAYA', '2019-06-13 16:00:33');
INSERT INTO `guerreros2019` VALUES ('101', 'ISAAC SANCHEZ MIRANDA', 'ISAAC', '2000-02-01', '19', 'M', 'M', 'ESTADO DE MEXICO', '5554031766', 'snchezmiranda.isaac@yahoo.com', 'NINGUNA', 'INVITACIÓN', '0', '0', '', '0', 'A', '5528921944', 'CENTRO DE RESTAURACIÓN Y AVIVAMIENTO ESPÍRITU SANT', '2019-06-17 17:46:55');
INSERT INTO `guerreros2019` VALUES ('102', 'ISRAEL SANCHEZ MIRANDA', 'ISRAEL', '2001-02-20', '18', 'M', 'M', 'ESTADO DE MÉXICO', '5536767108', 'israelsanchez0109@outlook.com', 'FRÍO Y PELO DE PERRO', 'INVITACIÓN', '0', '0', '', '0', 'A', '5528921944', 'CENTRO DE RESTAURACIÓN Y AVIVAMIENTO ESPÍRITU SANT', '2019-06-17 18:36:04');
INSERT INTO `guerreros2019` VALUES ('103', 'JAASIEL DAVID WONG LÓPEZ ', 'JD WONG ', '2002-11-12', '17', 'M', 'M', 'TECÁMAC, ESTADO DE MÉXICO ', '5541293813 ', 'davidwongjd29@gmail.com', 'NINGUNA ', 'QUIERO TERMINAR MI SEGUIMIENTO Y QUISIERA TOMAR MI LUGAR COMO MISIONERO ', '1', '0', '', '0', 'A', '5514247543', 'AMISTAD CRISTIANA ', '2019-06-18 21:36:28');
INSERT INTO `guerreros2019` VALUES ('104', 'JONATHAN JOSUÉ GARCÍA GÓMEZ', 'JONATHAN', '2001-05-04', '18', 'M', 'M', 'CUAUTITLAN IZCALLI, EDO MEXICO ', '5513171956', 'davidtercero3@gmail.com', 'POLVO', 'MI ANHELO MÁS GRANDE ES CONOCER EN INTIMIDAD MÁS EL CORAZÓN DE MI PADRE, SER ALGUIEN AGRADABLE DELANTE DE SUS OJOS Y PODER GLORIFICARLO EN LO QUE PIENSO, LO QUE DIGO Y LO QUE HAGO. \nHE PROBADO LA GENUINA GRACIA DE PAPÁ Y HE QUEDADO MARCADO POR ELLA. ', '0', '0', '', '0', 'A', '5541269061', 'NUEVA VIDA PARQUES CASA DE ORACION', '2019-06-19 10:30:18');
INSERT INTO `guerreros2019` VALUES ('105', 'PAMELA CASTILLO SAUCEDO', 'PAMELA', '2002-04-27', '17', 'F', 'M', 'CUAUTITLAN IZCALLI, EDO MEXICO ', '5572250586', 'davidtercero3@gmail.com', 'NINGUNA', 'PARA MÍ ES DE GRAN BENDICIÓN EL IR A JUCUM PUES SE QUE ME AYUDARÁ A MI FORMACIÓN TANTO ESPIRITUAL COMO PERSONAL, PUES PODRÉ AÚN DESARROLLAR LOS TALENTOS QUE DIOS ME A DADO Y USARLOS PRINCIPALMENTE PARA SU SERVICIO; TAMBIÉN PODER CRECER EN ÁREAS DE MI VIDA', '0', '0', '', '0', 'A', '5524150373', 'NUEVA VIDA PARQUES CASA DE ORACION', '2019-06-19 10:34:34');
INSERT INTO `guerreros2019` VALUES ('106', 'SAMUEL ISAÍAS GARCIA PAVELLO ', 'SAMUEL', '2002-11-21', '17', 'M', 'G', 'CUAUTITLAN IZCALLI, EDO MEXICO ', '5571685554', 'davidtercero3@gmail.com', 'NINGUNA', 'BUENO LA RAZON POR LA CUAL DESEO PARTICIPAR EN RETO URBANO ES PARA LOGRAR ESTRECHAR Y LLEVAR AUN MAS LEJOS MI RELACION CON DIOS Y LOGRAR SER CAPAZ DE COMPARTIR SU AMOR A DIFERENTES PERSONAS SER UNA VIVA MUESTRA DEL AMOR DE DIOS HACIA LAS PERSONAS', '0', '0', '', '0', 'A', '5523607696', 'NUEVA VIDA PARQUES CASA DE ORACION', '2019-06-19 10:37:53');
INSERT INTO `guerreros2019` VALUES ('107', 'ERIC ENOC TEMPLOS ARELLANO', 'TEMPLOS', '2001-02-20', '18', 'M', 'CH', 'REAL DEL MONTE', '7713299127', 'ericenoctemplos@gmail.com ', 'NINGUNA', 'PORQUE YA EH IDO AÑOS ANTERIORES Y AMO REENCONTRARME CON DIOS MEDIANTE UN RETO. Y SIENTO QUE NECESITO VOLVER A EL', '0', '0', '', '0', 'A', '7711743508', 'BETHANIA', '2019-06-19 11:47:02');
INSERT INTO `guerreros2019` VALUES ('108', 'DANIELA DANAE WONG LÓPEZ ', 'DANA WONG ', '1998-03-09', '21', 'F', 'M', 'ESTADO DE MÉXICO ', '5539465325 ', 'dani_wong98@hotmail.com ', 'NINGUNA ', 'PARA SERVIR Y PONER EN PRÁCTICA LO QUE APRENDÍ EN SEGUIMIENTO ', '0', '0', '', '0', 'A', '22211513', 'AMISTAD CRISTIANA LAS AMÉRICAS ', '2019-06-19 16:42:41');
INSERT INTO `guerreros2019` VALUES ('109', 'JASSIEL YIREH HERNÁNDEZ FERNÁN', 'JASSIEL', '2004-12-08', '15', 'M', 'G', 'CUAUTITLAN IZCALLI, EDO MEXICO ', '5574880712', 'davidtercero3@gmail.com', 'POLVO, MALEZA, PIRUL, OLIVO', 'Y ME GUSTARÍA IR PORQUE QUISIERA SERVIR A DIOS DE UNA MANERA DISTINTA A LA QUE YO LE SIRVO Y TAMBIÉN PARA CONOCER A PERSONAS CON EL MISMO CORAZÓN Y LAS MISMAS INTENCIONES DE SERVIR A DIOS', '0', '0', '', '0', 'A', '5543549326', 'NUEVA VIDA PARQUES CASA DE ORACION', '2019-06-19 19:51:29');
INSERT INTO `guerreros2019` VALUES ('110', 'ALAN EMMANUEL RÍOS GÓMEZ ', 'EMMANUEL', '2002-05-16', '17', 'M', 'M', 'CUAUTITLAN IZCALLI, EDO MEXICO ', '55 8487 7155', 'davidtercero3@gmail.com', 'NINGUNA', 'PRIMERAMENTE PORQUE HE SENTIDO HASTA LA FECHA UN LLAMADO QUE DIOS ME ESTÁ HACIENDO Y SE QUÉ ESE PROGRAMA ME VA A AYUDAR A EXPERIMENTAR EL TIPO DE COSAS Y PROPÓSITOS QUE DIOS TIENE PARA MI VIDA', '0', '0', '', '0', 'A', '+52 15614180', 'NUEVA VIDA PARQUES CASA DE ORACION', '2019-06-19 21:23:50');
INSERT INTO `guerreros2019` VALUES ('111', 'ALAN EMMANUEL RÍOS GÓMEZ ', 'EMMANUEL', '2002-05-16', '17', 'M', 'M', 'CUAUTITLAN IZCALLI, EDO MEXICO ', '55 8487 7155', 'davidtercero3@gmail.com', 'NINGUNA', 'PRIMERAMENTE PORQUE HE SENTIDO HASTA LA FECHA UN LLAMADO QUE DIOS ME ESTÁ HACIENDO Y SE QUÉ ESE PROGRAMA ME VA A AYUDAR A EXPERIMENTAR EL TIPO DE COSAS Y PROPÓSITOS QUE DIOS TIENE PARA MI VIDA', '0', '0', '', '0', 'B', '+52 15614180', 'NUEVA VIDA PARQUES CASA DE ORACION', '2019-06-19 21:23:50');
INSERT INTO `guerreros2019` VALUES ('112', 'TERESA DE JESUS HERNANDEZ ABAD', 'TERE', '1968-04-29', '51', 'F', 'XL', 'ESCUELA DE CONSEJERIA', '6691419343', 'terehernandezabad@gmail.com', 'NININGUNA', 'CINSEJERA DEL CAMPAMENTO', '1', '0', '', '0', 'A', '5565407639', 'ESCUELA DE CONSEJERIA', '2019-06-20 18:13:49');
INSERT INTO `guerreros2019` VALUES ('113', 'SHIRLEY YEUNG', 'SHIR YEUNG', '1993-01-16', '26', 'F', 'G', 'ESCUELA DE CONSEJERIA', '584123275224', 'shiir.yeung@gmail.com ', 'A LAS PICADAS ', 'CONSEJERA ', '1', '0', '', '0', 'A', '15544632423', 'ESCUELA DE CONSEJERIA ', '2019-06-20 21:21:26');
INSERT INTO `guerreros2019` VALUES ('114', 'ARANTXA CASTELLANOS MEJIA', 'ARI', '2000-02-17', '19', 'F', 'CH', 'LAS AMERICAS ', '5532186748', 'arandano_17@hotmail.com', 'NO', 'ME INVITARON', '0', '0', '', '0', 'B', '5532049166', 'AMISTAD CRISTIANA LAS AMERICAS ', '2019-06-21 12:59:59');
INSERT INTO `guerreros2019` VALUES ('115', 'NATALIA RAMÍREZ ARIAS', 'NATY', '2004-09-20', '15', 'F', 'XC', 'PACHUCA, HIDALGO', '7712196709', 'nramireza2004@gmail.com', 'NINGUNA', 'EXPERIENCIAS Y ACERCAMIENTO CON DIOS QUE TUVE EL AÑO PASADO', '1', '0', '', '0', 'A', '7717263203', 'VIENTO RECIO', '2019-06-22 06:09:49');
INSERT INTO `guerreros2019` VALUES ('116', 'EVELYN NATALIA MORA VELAZQIEZ', 'EVELYN', '2002-06-02', '17', 'F', 'G', 'CDMX', '5545197467', 'moyadnat@yahoo.com.mx', 'NINGUNA AL PARECER', 'TENER LA EXPERIENCIA PARA CONOCER LA RELIGIÓN CRISTIANA, CONOCER OTROS PUNTOS DE VISTA Y SABER AYUDAR A OTROS. GRACIAS', '0', '0', '', '0', 'A', '5527559212', 'PUERTA DE SALVACION', '2019-06-25 14:36:28');
INSERT INTO `guerreros2019` VALUES ('117', 'EDUARDO HERNÁNDEZ TRUJILLO ', 'PORTAVOZ ', '1990-07-17', '29', 'M', 'G', 'ECATEPEC EDO.DE MÉX. ', '5510789881 ', 'thesinful1@hotmail.com', 'PENICILINA ', 'FUI INVITADO', '0', '0', '', '0', 'B', '51266656', 'AMISTA CRISTIANA ECATEPEC ', '2019-06-26 20:25:43');
INSERT INTO `guerreros2019` VALUES ('118', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'A', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:18');
INSERT INTO `guerreros2019` VALUES ('119', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:18');
INSERT INTO `guerreros2019` VALUES ('120', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:18');
INSERT INTO `guerreros2019` VALUES ('121', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:19');
INSERT INTO `guerreros2019` VALUES ('122', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:19');
INSERT INTO `guerreros2019` VALUES ('123', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:19');
INSERT INTO `guerreros2019` VALUES ('124', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:20');
INSERT INTO `guerreros2019` VALUES ('125', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:22');
INSERT INTO `guerreros2019` VALUES ('126', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:22');
INSERT INTO `guerreros2019` VALUES ('127', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:22');
INSERT INTO `guerreros2019` VALUES ('128', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:23');
INSERT INTO `guerreros2019` VALUES ('129', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:23');
INSERT INTO `guerreros2019` VALUES ('130', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:23');
INSERT INTO `guerreros2019` VALUES ('131', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:24');
INSERT INTO `guerreros2019` VALUES ('132', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:24');
INSERT INTO `guerreros2019` VALUES ('133', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:24');
INSERT INTO `guerreros2019` VALUES ('134', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:25');
INSERT INTO `guerreros2019` VALUES ('135', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:26');
INSERT INTO `guerreros2019` VALUES ('136', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:26');
INSERT INTO `guerreros2019` VALUES ('137', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:26');
INSERT INTO `guerreros2019` VALUES ('138', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:27');
INSERT INTO `guerreros2019` VALUES ('139', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:28');
INSERT INTO `guerreros2019` VALUES ('140', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:28');
INSERT INTO `guerreros2019` VALUES ('141', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:29');
INSERT INTO `guerreros2019` VALUES ('142', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:29');
INSERT INTO `guerreros2019` VALUES ('143', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:30');
INSERT INTO `guerreros2019` VALUES ('144', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:31');
INSERT INTO `guerreros2019` VALUES ('145', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:32');
INSERT INTO `guerreros2019` VALUES ('146', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:32');
INSERT INTO `guerreros2019` VALUES ('147', 'BAYOLET FABIOLA DIAZ', 'BAYOLET ', '2005-04-06', '14', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '4771252062', 'erikajacinto075@gmail.com', 'NINGUNA', 'POR QUE QUIERO ASERCARME MAS A JESUS', '0', '0', '', '0', 'B', '4761358079', 'CASA DE ORACION', '2019-06-30 17:23:35');
INSERT INTO `guerreros2019` VALUES ('148', 'ESTEBAN PALACIOS', 'ESTEBAN', '1990-03-14', '29', 'M', 'G', 'JUCUM FMC', '×52155654076', 'estebanpalacios77@hotmail.com', 'NO', 'ESTAFF', '1', '0', '', '0', 'A', '5544632423', 'JUCUM FMC', '2019-07-02 22:34:55');
INSERT INTO `guerreros2019` VALUES ('149', 'ESTELA AVILA', 'ITA', '1973-11-03', '46', 'F', 'M', 'JUCUM FMC', '+52155446324', 'aire7311@hotmail.com', 'NO', 'ESTAFF', '1', '0', '', '0', 'A', '5565407639', 'JUCUMFMC', '2019-07-02 22:37:28');
INSERT INTO `guerreros2019` VALUES ('150', 'DAVID SHIN', 'DAVID', '1995-01-01', '24', 'M', 'M', 'LOS ANGELES ', '55555555', 'matttyangg@gmail.com', 'NO', ':) ', '0', '0', '', '0', 'A', '55555555', 'KOREAN CHURCH', '2019-07-04 10:48:53');
INSERT INTO `guerreros2019` VALUES ('151', 'SUSAN CHO', 'SUSAN', '1990-01-01', '29', 'F', 'M', 'LOS ANGELES', '55555555', 'matttyangg@gmail.com', 'NO', ':)', '0', '0', '', '0', 'A', '55555555', 'KOREAN CHURCH', '2019-07-04 10:51:02');
INSERT INTO `guerreros2019` VALUES ('152', 'MATTHEW YANG ', 'MATT', '1988-01-01', '31', 'M', 'M', 'LOS ANGELES', '555555555', 'matttyangg@gmail.com', 'NO', ':) ', '0', '0', '', '0', 'A', '555555555', 'KOREAN CHURCH', '2019-07-04 10:52:50');
INSERT INTO `guerreros2019` VALUES ('153', 'OLIVIA BEAK', 'OLI', '2000-01-01', '19', 'F', 'M', 'LOS ANGELES ', '555555555', 'matttyangg@gmail.com', 'NO', ':)', '0', '0', '', '0', 'A', '55555555', 'KOREAN CHURCH', '2019-07-04 10:55:22');
INSERT INTO `guerreros2019` VALUES ('154', 'SHIRLEY LEW', 'SHIRLEY', '2000-01-01', '19', 'F', 'M', 'LOS ANGELES', '555555555', 'matttyangg@gmail.com', 'NO', ':) ', '0', '0', '', '0', 'A', '555555555', 'KOREAN CHURCH', '2019-07-04 10:58:21');
INSERT INTO `guerreros2019` VALUES ('155', 'NATHANAEL CHOE', 'NATH', '2003-01-01', '16', 'M', 'M', 'LOS ANGELES', '5555555', 'matttyangg@gmail.com', 'NO', ':)', '0', '0', '', '0', 'A', '5555555', 'KOREAN CHURCH', '2019-07-04 11:01:22');
INSERT INTO `guerreros2019` VALUES ('156', 'RACHEL HUR', 'RACHEL', '2003-01-01', '16', 'F', 'M', 'LOS ANGELES ', '555555555', 'matttyangg@gmail.com', 'NO', ':) ', '0', '0', '', '0', 'A', '555555555', 'KOREAN CHURCH', '2019-07-04 11:04:26');
INSERT INTO `guerreros2019` VALUES ('157', 'JONY BUENDIA PITALUA', 'JONY GOODDAY', '1988-11-08', '31', 'M', 'CH', 'JUCUM PACHUCA', '7712196807', 'jbpitalua@gmail.com', 'NINGUNA', 'SOY STAFF', '1', '0', '', '0', 'A', '7712196807', 'JUCUM PACHUCA', '2019-07-04 11:20:41');
INSERT INTO `guerreros2019` VALUES ('158', 'J. ABIGAIL GRIMALDO ALVARADO', 'ABY', '1997-03-22', '22', 'F', 'CH', 'CDMX', '5536667536', 'j-griim@outlook.com', '-', 'PAASAR UN TIEMPO CON DIOS, CONOCIENDOLO Y APRENDIENDO MAZ', '0', '0', '', '0', 'A', '5535664988', 'VIDA NUEVA ', '2019-07-06 12:11:14');
INSERT INTO `guerreros2019` VALUES ('159', 'ARADIA ESCALONA LUENGAS', 'ARADIA ESESCONA', '2002-01-02', '17', 'F', 'M', 'GUSTAVO A. MADERO', '5584840593', 'aradiaescalonaluengas1b1@gmail.com', 'NINGUNA', 'QUIERO TENER UN ACERCAMIENTO CON DIOS', '0', '0', '', '0', 'A', '68382496', 'ATMÓSFERA', '2019-07-07 15:11:47');
INSERT INTO `guerreros2019` VALUES ('160', 'ANA ELIZABETH GARCÍA ESCALONA', ' BETH ESCALONA', '2005-08-03', '14', 'F', 'CH', 'ECATEPEC DE MORELOS', '5534866548', 'vane.van.roy@gmail.com', 'NINGUNA', 'PORQUE QUIERO ACERCRME MAS A DIOS ^_^', '1', '0', '', '0', 'A', '5519616364', 'ATMÓSFERA', '2019-07-07 15:22:31');
INSERT INTO `guerreros2019` VALUES ('161', 'YESICA FERNANDA MARTINEZ HERNA', 'YESI FER ', '2003-11-07', '16', 'F', 'CH', 'ATIZAPAN ', '55 394144 59', 'lic.karen17@hotmail.com ', 'NO', 'APRENDER', '0', '0', '', '0', 'A', '55 2998 0779', 'CENTRO DE RESTAURACION AVIVAMIENTO', '2019-07-08 13:14:53');
INSERT INTO `guerreros2019` VALUES ('162', 'REBECA VALENTINA VÁZQUEZ MONTE', 'BEKA', '2004-09-06', '15', 'F', 'M', 'CDMX ', '553890030', 'angelesmob@gmail.com ', 'NINGUNA', 'APRENDER MAS DEL SEÑOR', '0', '0', '', '0', 'A', '5538900303', 'INP PUERTA DE SALVACION', '2019-07-08 21:35:09');
INSERT INTO `guerreros2019` VALUES ('163', 'SARAH CAMERER', 'SARAH', '1998-02-12', '21', 'F', 'G', 'JUCUM CDMX', '+55524070347', 'sbcamerer@comcast.net', 'NADA', 'VENGO COMO STAFF CON LA ESCUELA DE CONSEJERÍA ', '1', '0', '', '0', 'A', 'NO SÉ', 'LA PALABRA QUE SE GUARDA', '2019-07-08 21:36:00');
INSERT INTO `guerreros2019` VALUES ('164', 'DIEGO DODAMIN', 'DIEGO', '1998-05-02', '21', 'M', 'M', 'SAN LUIS POTOSI', '76856', 'nsjka bkjbvfsk', 'NINGUNA', 'CONOCER DE DIOS', '0', '0', '', '0', 'A', '875864674', 'LIASHDJH', '2019-07-09 11:34:08');
INSERT INTO `guerreros2019` VALUES ('165', 'LUISA LUDMILA', 'LUISA', '1999-08-08', '20', 'F', 'CH', 'SAN LUIS POTOSI', '098807986986', 'jhkbkgbsa', 'NADA ', ':)', '0', '0', '', '0', 'A', '986765567', 'JGIUGIU', '2019-07-09 11:38:04');
INSERT INTO `guerreros2019` VALUES ('166', 'YELEN BELLO HERNANDEZ ', 'YELEN', '2004-01-01', '15', 'F', 'CH', 'PACHUCA', '123456789', 'lkjhgfdsa', 'NINGUNA', '(:', '1', '0', '', '0', 'A', '123456789', 'CORNESTONE', '2019-07-09 11:52:32');
INSERT INTO `guerreros2019` VALUES ('167', 'ANDREA ESTRADA GARRIDO', 'ANDY', '2005-05-12', '14', 'F', 'XC', 'ESTADO DE MÉXICO', '5542413058', 'michelge82@gmail.com', 'NINGUNA', 'PORQUE ME GUSTARÍA HACER COSAS DIFERENTES EN MIS VACACIONES', '0', '0', '', '0', 'A', '5520307910', 'TECAMAC', '2019-07-14 14:39:06');
INSERT INTO `guerreros2019` VALUES ('168', 'JANETH MONTAÑO PADRON ', 'JANETH ', '1998-09-22', '21', 'F', 'CH', 'ECATEPEC DE MORELOS', '5527394616', 'janethmp98@live.com', 'NO', 'MUESTRA DE AMOR, HONOR Y AGRADECIMIENTO A RICH Y CITLA. A SERVIR MIENTRAS APRENDO Y CREZCO TAMBIEN. ', '0', '0', '', '0', 'A', '5611578735', 'COMUNIDAD FARO ', '2019-07-14 23:15:07');
INSERT INTO `guerreros2019` VALUES ('169', 'DAMARIS KASSANDRA TORRES HERNA', 'DAMARIS', '1982-08-08', '37', 'F', 'M', 'SAN LUIS POTOSI', '65156165', '658181', 'NADA', 'CONOCER A DIOS', '0', '0', '', '0', 'A', '6511859', 'JNSAIUBNDF', '2019-07-15 10:18:59');
INSERT INTO `guerreros2019` VALUES ('170', 'LUIS RICARDO TORRES HERNANDEZ', 'LUIS', '1998-09-15', '21', 'M', 'G', 'SAN LUIS POTOSI', '58468544', '146851dsibyhbd', 'NADA', 'COCNOCER A DIOS \n', '0', '0', '', '0', 'A', '1985181518', 'JNSDOJNF', '2019-07-15 10:22:15');
INSERT INTO `guerreros2019` VALUES ('171', 'NICOLLE DESSIRE SANABRIA ROMAN', 'NIKY', '2003-05-01', '16', 'F', 'M', 'SAN FRANCISCO DEL RINCON GTO', '476 1465299 ', 'viryguty07@gmail.com', 'NADA', 'ACERCARME MAS A MI DIOS Y VIVIR LA MEJOR EXPERIENCIA ', '0', '0', '', '0', 'A', '4761313804', 'CDO CASA DE ORACION', '2019-07-15 11:50:45');
INSERT INTO `guerreros2019` VALUES ('172', 'REAGAN HOLLENBAUGH', 'REAGAN', '2000-01-01', '19', 'M', 'M', 'PENSILVANIA', '123456789', 'abcdefghijklmn', 'NO', '(:', '0', '0', '', '0', 'A', '789456321', 'CD JUAREZ', '2019-07-15 19:40:19');
INSERT INTO `guerreros2019` VALUES ('173', 'CAROLYN KEEN', 'CAROLYN', '2002-08-14', '17', 'F', 'CH', 'PENSILVANIA', '95841981', 'nkiugvjtcht', 'NINGUNA', ':)', '0', '0', '', '0', 'A', '6591816185', 'HYIGVKUG', '2019-07-15 19:42:24');
INSERT INTO `guerreros2019` VALUES ('174', 'JOY LANDIS', 'JOY', '1999-06-03', '20', 'F', 'CH', 'PENSILVANIA', '651681685', 'jhvhxjvkhcjg', 'NINGUNA', ':)', '0', '0', '', '0', 'A', '+652165151', 'UGVFUGVGUTV', '2019-07-15 19:44:35');
INSERT INTO `guerreros2019` VALUES ('175', 'JONAH LEE', 'JONAH', '2000-06-14', '19', 'M', 'M', 'PENSILVANIA', '515863185', 'kjfjyckvkytxdrkf', 'NINGUNA', '(:', '0', '0', '', '0', 'A', '516515651', 'UTFUYFUYTF', '2019-07-15 19:46:52');
INSERT INTO `guerreros2019` VALUES ('176', 'SALLY STAUFFER', 'SALLY', '2000-08-12', '19', 'F', 'CH', 'PENSILVANIA', '545441545165', 'bfskbjadhbfka', 'NINGUNA', '(:', '0', '0', '', '0', 'A', '151818161', 'HADBFHD', '2019-07-15 19:48:57');
INSERT INTO `guerreros2019` VALUES ('177', 'LAUREN CLARK', 'LAUREN', '2000-03-16', '19', 'F', 'G', 'PENSILVANIA', '165818168', 'sdvjbkusdusdnjk', 'NINGUNA', '(:', '0', '0', '', '0', 'A', '1518168132', 'DGSGHSFHS', '2019-07-15 19:51:37');
INSERT INTO `guerreros2019` VALUES ('178', 'EDWIN ROSARIO', 'EDWIN', '2000-07-18', '19', 'M', 'XL', 'PENSILVANIA', '511685135', 'jsdbfbakufgyasf', 'NINGUNA', '(:', '0', '0', '', '0', 'A', '5181351352', 'GSGSGSGS', '2019-07-15 19:53:22');
INSERT INTO `guerreros2019` VALUES ('179', 'EDUARDO VIELMAS', 'LALO', '1997-08-15', '22', 'M', 'XL', 'PENSILVANIA', '5133581351', 'sjkfkuafukhsf', 'NINGUNA', '(:', '0', '0', '', '0', 'A', '651681616581', 'SFDGDFBUYBFD', '2019-07-15 19:54:51');
INSERT INTO `guerreros2019` VALUES ('180', 'SENI G. CASTILLO GUERRERO', 'SENI', '2005-11-21', '14', 'F', 'M', 'MUNICIPIO DE ATIZAPAN DE ZARAGOZA', '5523661471', 'robertolopaka@gmail.com', 'NO AL PARECER', 'PARA VOLVER A REENCONTRARME CON DIOS, Y SERVIR A TODOS LOS JOVENES QUE DESEEN TENER UNA EXPERIENCIA ESPIRITUAL.', '0', '0', '', '0', 'A', '5566723646', 'CENTRO CRISTIANO CALACOAYA', '2019-07-15 19:57:59');
INSERT INTO `guerreros2019` VALUES ('181', 'Andrea Ramirez Poceros', 'ANDY', '2002-03-26', '17', 'F', 'M', 'CDMX', '5523390719', 'andsram@gmail.com', 'NINGUNA', 'CONOCER PERSONALMENTE LO QUE DIOS HACE A TRAVES DE JUCUM', '0', '0', '', '0', 'B', '5585807271', 'AMISTAD CRISTIANA OBSERVATORIO', '2019-07-15 21:27:58');
INSERT INTO `guerreros2019` VALUES ('182', 'ZABDI JOSHUA GONZALEZ BRITO', 'JOSHUA', '2004-01-28', '15', 'M', 'CH', 'CDMX', '5526631582', 'zabdijoshua123@gmail.com', 'NINGUNA', 'PORQUE QUIERO CRECER ESPIRITUALMENTE', '0', '0', '', '0', 'A', '5526666763', 'JESUCRISTO REDENTOR PERFECTO', '2019-07-15 21:43:45');
INSERT INTO `guerreros2019` VALUES ('183', 'YIREL PEREIRA ROMERO ', 'YIYOS ', '1999-08-27', '20', 'F', 'XC', 'MEXICO ', '5540346755', 'yirel_yiyos@hormail.com', 'NINGUNA ', 'APOYAR ', '1', '0', '', '0', 'A', '551291235', 'AMISTAD CRISTIANA ', '2019-07-16 10:46:32');
INSERT INTO `guerreros2019` VALUES ('184', 'CHANTAL RENEÉ SOSA MANCHA', 'SHANTAL SOSA', '2004-04-15', '15', 'F', 'CH', 'ECATEPEC LAS AMERICAS', '5585934256', 'santalsosa11@gmail.com', 'NINGUNAS', 'PARA HACER LA MISIÓN DE JESÚS DESPUÉS DE UN AÑO DE PREPARACIÓN', '1', '0', '', '0', 'A', '5529202161', 'AMISTAD CRISTIANA LAS AMERICAS ', '2019-07-16 16:05:35');
INSERT INTO `guerreros2019` VALUES ('185', 'ERICK SEBASTIÁN SOSA MANCHA', 'EL SOSA', '2002-06-25', '17', 'M', 'XL', 'LAS AMÉRICAS', '5585934256', 'avestruzerick@gmail.com', 'NINGUNA', 'VINE A SEGUIMIENTOS, VOY A SER STAFF CREO JAJA', '1', '0', '', '0', 'A', '5529202161', 'AMISTAD CRISTIANA LAS AMÉRICAS', '2019-07-16 16:21:36');
INSERT INTO `guerreros2019` VALUES ('186', 'LUIS ANGEL MENDOZA CAMACHO', 'LUIS', '2001-12-20', '18', 'M', 'G', 'ATIZAPAN', '5562252663', 'mendozacamacholuis_20@outlook.com', 'NENEL', 'AMOR A DIOS', '1', '0', '', '0', 'A', '5516469106', 'CRCRA', '2019-07-16 18:07:19');
INSERT INTO `guerreros2019` VALUES ('187', 'LUIS HUMBERTO GIL GERARDO', 'FISICOCULTURITA', '1990-06-15', '29', 'M', 'XL', 'MEXICALI', '5575557976', 'luishgg15@gmail.com', 'SANDIA', 'APOYAR AL STAFF', '1', '0', '', '0', 'A', '5575557976', 'CASA DE ORACION', '2019-07-17 08:56:11');
INSERT INTO `guerreros2019` VALUES ('188', 'PABLO DANIEL PAZ CRUZ', 'PABLO', '2000-06-05', '19', 'M', 'M', 'PACHUCA ', '1738374929', 'nmdkd dnd', 'NINGUNA', 'CONOCER DE DIOS', '0', '0', '', '0', 'A', 'NSKXNDKD', 'CORNERSTONE', '2019-07-17 21:12:04');
INSERT INTO `guerreros2019` VALUES ('189', 'ANA ELENA LOPEZ CARMONA', 'ANELENA', '1991-12-15', '28', 'F', 'CH', 'LEÓN, GTO.', '4761009930', 'anelena-@hotmail.com', 'NINGUNA', 'PARA CELEBRAR LOS DIEZ AÑOS DE RETO CON PERSONAS  QUE AMO Y DISFRUTAR DE LA PRESENCIA DE DIOS. ESTARÉ HASTA EL JUEVES 25.', '0', '0', '', '0', 'A', '4767435109', 'COMUNIDAD FAST', '2019-07-18 09:32:45');
INSERT INTO `guerreros2019` VALUES ('190', 'NATALY ALEJANDRA OLGUIN HERNA', 'ALE', '2005-03-10', '14', 'F', 'CH', 'PACHUCA', '9848013171', 'laloolguinmorales@gmail.com', 'NINGUNA', 'ME INVITO UNA AMIGA', '0', '0', '', '0', 'A', '4521071007', 'NINGUNA', '2019-07-18 14:39:20');
INSERT INTO `guerreros2019` VALUES ('191', 'DIANA MOTA', 'DIANA', '2000-01-01', '19', 'F', 'CH', 'PACHUCA', '555555555', '555555555', 'NO', 'A SERVIR ', '0', '0', '', '0', 'A', '55555555', 'SAMA', '2019-07-18 21:37:33');
INSERT INTO `guerreros2019` VALUES ('192', 'REGINA VELEZ MARTINEZ', 'REGI', '2004-11-18', '15', 'F', 'CH', 'PUEBLA', '2224741218', 'reginichis@gmail.com', 'NINGUNA', 'PARA CONOCER MAS DE DIOS , TENER UNA RELACION MAS CERCANA CON EL Y DIVERTIRME', '0', '0', '', '0', 'A', '2226635657', 'EL PUENTE', '2019-07-18 22:24:55');
INSERT INTO `guerreros2019` VALUES ('193', 'ANA SOFIA VELEZ MARTINEZ', 'SOF', '2003-04-28', '16', 'F', 'M', 'PUEBLA', '222 126 1140', 'velezmartinezsofia@gmail.com', 'NINGUNA', 'POR CURIOSIDAD', '0', '0', '', '0', 'A', '222 663 5657', 'EL PUENTE', '2019-07-18 23:11:33');
INSERT INTO `guerreros2019` VALUES ('194', 'BRYCE SLAMA ', 'BRYCE', '1993-11-12', '26', 'M', 'XL', 'JUCUM ESCUELA DE CONSEJERIA', '+17202202417', 'slamabryce@gmail.com', 'MUCHO POLVO', 'PARA SERVIR Y VER VIDAS RESTAURADAS', '1', '0', '', '0', 'A', '5565407639', 'JUCUM CONSEJERIA', '2019-07-19 07:34:33');
INSERT INTO `guerreros2019` VALUES ('195', 'ANGELICA BETZABE RIVAS GONZALE', 'ANGIE ', '1993-10-01', '0', 'F', 'G', 'CIUDAD DE MEXICO', '6692274268', 'betzy_10@live.com.mx', 'NO ', 'COMO STAFF DE CONSEJERIA ', '1', '0', '', '0', 'A', '5544632324', 'JUCUM CDMX CONSEJERIA ', '2019-07-19 07:44:05');
INSERT INTO `guerreros2019` VALUES ('196', 'VALERIA BARRIOS GODINEZ ', 'VALERIA', '2004-01-01', '15', 'F', 'G', 'LLLLLLLL', '123456', '123456', 'NO', '(:', '0', '0', '', '0', 'A', '123456', 'CASA DE ORACION', '2019-07-20 10:51:44');
INSERT INTO `guerreros2019` VALUES ('197', 'YAZMIN ARIAS RUIZ', 'YAZMIN', '2000-01-01', '19', 'F', 'M', '....', '1233456', 'mnbvcx', 'NO', '(:', '0', '0', '', '0', 'A', '123456', '....', '2019-07-20 11:01:16');

-- ----------------------------
-- Table structure for guerreros2020
-- ----------------------------
DROP TABLE IF EXISTS `guerreros2020`;
CREATE TABLE `guerreros2020` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `fechanac` date DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `talla` varchar(3) DEFAULT NULL,
  `vienede` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(12) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `alergias` varchar(255) DEFAULT NULL,
  `razones` varchar(255) DEFAULT NULL,
  `staff` smallint(1) DEFAULT NULL,
  `confima_pago` smallint(1) DEFAULT NULL,
  `nomero_ticket` varchar(50) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT 1550,
  `status` varchar(1) DEFAULT NULL,
  `contacto_tutor` varchar(12) DEFAULT NULL,
  `iglesia` varchar(50) DEFAULT NULL,
  `fechahora_registro` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros2020
-- ----------------------------
INSERT INTO `guerreros2020` VALUES ('1', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-03-27 16:32:46');
INSERT INTO `guerreros2020` VALUES ('2', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-03-28 16:33:48');
INSERT INTO `guerreros2020` VALUES ('3', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-03-31 16:32:13');
INSERT INTO `guerreros2020` VALUES ('4', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-01 16:41:40');
INSERT INTO `guerreros2020` VALUES ('5', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-06 16:35:35');
INSERT INTO `guerreros2020` VALUES ('6', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-09 16:35:35');
INSERT INTO `guerreros2020` VALUES ('7', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-10 16:36:49');
INSERT INTO `guerreros2020` VALUES ('8', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-12 16:42:17');
INSERT INTO `guerreros2020` VALUES ('9', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-15 16:32:08');
INSERT INTO `guerreros2020` VALUES ('10', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-16 16:44:18');
INSERT INTO `guerreros2020` VALUES ('11', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-17 16:37:18');
INSERT INTO `guerreros2020` VALUES ('12', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-18 16:36:39');
INSERT INTO `guerreros2020` VALUES ('13', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-19 16:33:40');
INSERT INTO `guerreros2020` VALUES ('14', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-20 16:31:49');
INSERT INTO `guerreros2020` VALUES ('15', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-21 16:43:16');
INSERT INTO `guerreros2020` VALUES ('16', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-24 16:37:58');
INSERT INTO `guerreros2020` VALUES ('17', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-25 16:39:15');
INSERT INTO `guerreros2020` VALUES ('18', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-27 16:35:41');
INSERT INTO `guerreros2020` VALUES ('19', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-04-28 16:43:50');
INSERT INTO `guerreros2020` VALUES ('20', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-05-01 16:38:13');
INSERT INTO `guerreros2020` VALUES ('21', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-05-04 16:37:26');
INSERT INTO `guerreros2020` VALUES ('22', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-05-06 16:40:55');
INSERT INTO `guerreros2020` VALUES ('23', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-05-07 16:44:11');
INSERT INTO `guerreros2020` VALUES ('24', '1', '1', '0000-00-00', '1', '1', '1', '1', '1', '1', '1', '1', '0', '0', '', '0', 'A', '1', '1', '2020-05-08 16:40:59');

-- ----------------------------
-- Table structure for guerreros2021
-- ----------------------------
DROP TABLE IF EXISTS `guerreros2021`;
CREATE TABLE `guerreros2021` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(30) DEFAULT NULL,
  `nick` varchar(50) DEFAULT NULL,
  `fechanac` date DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `talla` varchar(3) DEFAULT NULL,
  `vienede` varchar(50) DEFAULT NULL,
  `whatsapp` varchar(12) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `alergias` varchar(255) DEFAULT NULL,
  `razones` varchar(255) DEFAULT NULL,
  `staff` smallint(1) DEFAULT NULL,
  `cantidad` decimal(10,0) DEFAULT 1550,
  `status` varchar(1) DEFAULT NULL,
  `contacto_tutor` varchar(12) DEFAULT NULL,
  `iglesia` varchar(50) DEFAULT NULL,
  `fechahora_registro` datetime DEFAULT NULL,
  `tutor_nombre` varchar(50) DEFAULT NULL,
  `facebook` varchar(50) DEFAULT NULL,
  `instagram` varchar(50) DEFAULT NULL,
  `politicas` bit(1) DEFAULT NULL,
  `password` varchar(20) DEFAULT NULL,
  `admin` bit(1) DEFAULT b'0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=302 DEFAULT CHARSET=latin1;

-- ----------------------------
-- Records of guerreros2021
-- ----------------------------
INSERT INTO `guerreros2021` VALUES ('20', 'Arón García Escalona', 'Aron CAGE', '0000-00-00', null, 'M', 'M', 'Ecatepec', '5612743800', 'vane.van.roy@gmail.com', 'Ninguna', 'Crecer espiritualmente', '0', '0', 'A', '5519616364', 'Capitolio', '2021-05-04 08:51:04', 'Vanessa Escalona', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('21', 'Elizabeth García Escalona', 'Eli', '2005-07-03', '15', 'F', 'X', 'staff', '5534866548', 'vane.van.roy@gmail.com', 'Ninguna', 'Amor a servir', '0', '0', 'A', '5519616364', 'Capitolio', '2021-05-04 08:53:49', 'Vanessa Escalona', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('33', 'NELLY MERITH MARTINEZ GONZALEZ', 'MERITH', '2002-02-03', '19', 'F', 'S', 'CDMX', '5516514371', 'mayoebc@yahoo.com', 'NINGUNA', 'PARA CONOCER MAS SOBRE EL MINISTERIO ', '0', '0', 'A', '5533345519', 'RHEMA CAMPUS COYOACAN', '2021-05-04 09:51:14', 'ANTONIO MARTINEZ MAYO', 'Merith Martinez', 'merith_martinez', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('57', 'Dara Belen Tellez Ponce', 'Dara Ponce', null, null, 'F', 'X', 'pachuca', '771 7487331', 'daraponce.009@gmail.com', 'ninguna alergia', 'Porque me gustan las cosas de Dios', '0', '0', 'A', '7713597832', 'si, Cielos Abiertos', '2021-05-04 10:20:43', 'Juan Omar Tellez Perez', 'dara ponce', 'ponce_h.y._dara', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('58', 'José Antonio Rubio Gonzalez', 'Jose', '2002-07-05', '0', 'M', 'X', 'De Ensenada ;) ', '5533925646', 'jr717531@gmail.com', 'A los perros , gatos y a la reacción del jamón al calor', 'Por que amo el ministerio y quiero seguir sirviendo en este lugar :)', '1', '0', 'A', '5584046396', 'Por ahora no ', '2021-05-04 12:33:23', 'Claudia González Moreno', 'Jose RG', '@joseeerg', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('59', 'Jaasiel David Wong López ', 'JD Wong ', '2002-10-02', '18', 'M', 'M', 'Tecámac Estado de México ', '5541293813', 'alecadensa@hotmail.com', 'No', 'Me gusta y me identificó con la misión que se cumple durante el campamento', '0', '0', 'B', '5514247543', 'Gente Nueva ', '2021-05-09 18:52:06', 'Alejandra López López ', 'JD Wong ', 'jdwong_music', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('66', 'Abner Omar Tellez Ponce', 'Abner Ponce', '2005-04-06', '16', 'M', 'X', 'pachuca', '7711504964', 'neitor.p27@gmail.com', 'ninguna alergia', 'Porque me gustan las cosas de Dios', '0', '0', 'A', '7713597832', 'si, Cielos Abiertos', '2021-05-11 16:21:46', 'Juan Omar Tellez Perez', 'Abner Ponce', 'elabneitoratp', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('68', 'maria yelen bello hernandez ', 'yelen bello ', null, null, 'F', 'S', 'pachuca ', '7711724682', 'yelenbellohernandez@gmail.com', 'ninguna ', 'por que es una experiencia increible y me gusta mucho ', '0', '0', 'A', '7711501548', ' activando ', '2021-05-11 16:57:06', 'Gisela Hernández Reyes ', 'myelen bello ', '@yelenbello ', '', 'asdf2828segu1', '\0');
INSERT INTO `guerreros2021` VALUES ('76', 'Carlos Yereth Bello Hernández ', 'Yereth', '2004-06-02', '16', 'M', 'M', 'Pachuca ', '7712177459', 'yerethbello@gmail.com', 'No', 'Por querer acercarme mucho más a Dios ', '0', '0', 'A', '7711501548', 'Activando Generaciones ', '2021-05-11 19:36:54', 'Juana Gisela Hernández Reyes ', 'Yereth Bello ', 'yereth_710', '', 'retoU2476asdf', '\0');
INSERT INTO `guerreros2021` VALUES ('106', 'Natalia Contreras Alvarado', 'Naty', null, null, 'F', 'M', 'Ciudad de México', '5538385704', 'nat.c0205@gmail.com', 'Ninguna', 'Para conocer de Dios', '0', '0', 'B', '5535244239', 'Ninguna ', '2021-05-12 19:47:08', 'Fabiola Contreras Alvarado', 'Natalia Contreras ', 'natt_.contreras', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('108', 'Stephanee Michelle Muñoz Solar', 'Steophanee Muñoz', '2004-04-26', '17', 'F', 'XS', 'pachuca', '7714046241', 'stephaneemunoz4@gmail.com', 'ninguna alergia', 'Porque me gustan las cosas de Dios', '0', '0', 'B', '5518145797', 'no', '2021-05-14 21:48:22', 'Martha Leyda Solarte Solarte', 'Stephanee Muñoz', 'stephanee_munoz96', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('162', 'Alana Hernández Franco', 'Alana', '2006-06-06', '14', 'F', 'X', 'Guadalajara', '3321764491', 'mexicoamanda@gmail.com', 'Nada', 'Crecimiento', '0', '0', 'A', '3321764491', 'Sozo', '2021-05-18 09:27:05', 'Amanda Seyer', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('163', 'Carmen Sarahí Hernández Tovar', 'Sarahí ', '2006-03-04', '15', 'F', 'S', 'Xilitla, SLP', '4831006008', 'helioshiram@outlook.com', 'Ninguna ', 'Conocer y aprender más de Dios', '0', '0', 'A', '4891153814', 'Piedras Vivas Tamazunchale', '2021-05-18 20:02:20', 'Helios Hiram Hernández Hernández ', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('164', 'Amalia Besanilla Hernández ', 'Mayita', '2006-05-04', '14', 'F', 'M', 'Tamazunchale, SLP', '4831006008', 'hergo.perla@gmail.com', 'Ninguna', 'Para aprender más sobre la palabra de Dios.', '0', '0', 'A', '4833600062', 'Piedras Vivas Tamazunchale', '2021-05-18 20:06:21', 'Bertha Patricia Hernández Sánchez ', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('165', 'Gonzalez Brito Zabdi Joshua', 'Zabdi', '2022-01-28', '0', 'M', 'M', 'CDMX', '5526631582', 'zabdi.gonzalez15@gmail.com', 'Ninguna', 'Para conocer más a Dios y vivir una experiencia inolvidable', '1', '0', 'A', '5526666763', 'Jesucristo Redentor Perfecto', '2021-05-19 09:00:21', 'Carmen Brito Valeras', 'Zabdi himiko', 'Zabdi_ brito', '', 'saxofon6335auto', '\0');
INSERT INTO `guerreros2021` VALUES ('166', 'Angel Eduardo', 'Angel', '2003-01-02', '18', 'M', 'S', 'Pachuca, hgo', '7714247361', 'angel20primeroc@gmail.com', 'Ninguna', 'Saber mas de Dios y resolver dudas', '0', '0', 'A', '7714260389', 'PIB Pachuca', '2021-05-19 11:51:49', 'Silvia', 'Angel Eduardo', 'eduardo18_02', '', 'nota5286musik', '\0');
INSERT INTO `guerreros2021` VALUES ('169', 'Juan Antonio González Murillo', 'Tony murillo', null, '0', 'M', 'M', 'San Francisco del rincon gto', '4761126063', 'tontoby26@gmail.com', 'Ninguna', 'A aprender hacer a del amor de Dios y tener un encuentro más cercano con el ', '0', '0', 'A', '4761126063', 'Casa de oración', '2021-05-22 15:33:10', 'Maria de Jesús Gómez Ruiz', 'Tony murillo', 'JuanAntoniogonzalezmurillo ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('170', 'Ximena Orta Guerrero', 'Xime', null, '0', 'F', 'M', 'Cdmx', '5510298470', 'xime.ortag@gmail.com', 'Ninguna', 'Para conocer y aprender más de Dios', '0', '0', 'B', 'Mayor de eda', 'Ninguna', '2021-05-23 16:26:27', 'Mayor de edad', 'Ximena orta', 'xime__orta', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('171', 'Dulcr María Mendoza Camacho', 'Dulce', '1999-02-03', '22', 'F', 'S', 'Estado de Mexico', '5516469106', 'dulcemendozac@outlook.es', 'Ninguna', 'Tener un tiempo de aprendizaje y crecimiento con Dios', '0', '0', 'A', '5516469106', 'Centro de Restauracion y avivamiento', '2021-05-24 12:00:52', 'Ángeles Camacho', 'Dulce Caramelo', 'Dulce3637', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('174', 'Chantal Reneé', 'Shanty', '2004-03-04', '17', 'F', 'S', 'Las Américas', '5583908537', 'santalsosa11@gmail.com', 'Ninguna', 'Fui al seguimiento desde el 2019 y empezó la pandemia.', '0', '0', 'A', '5524046055', 'SUPRA', '2021-05-25 18:23:35', 'Judith Mancha', 'Shantal Sosa', 'Shantal Sosa', '', 'frase5985segu1', '\0');
INSERT INTO `guerreros2021` VALUES ('177', 'Erick Sebastián', 'Sosa (Sosita)', '2002-05-02', '18', 'M', 'XL', 'Las Américas', '5613284566', 'avestruzerick@gmail.com', 'Mormones (Ninguna)', 'Fui al seguimiento desde 2019, y comenzó la pandemia.', '0', '0', 'A', '5529202161', 'SUPRA', '2021-05-25 18:36:10', 'Sergio Sosa', 'Sebastián Sosa', '@erick.sm_06', '', 'asdf6382zxcv', '\0');
INSERT INTO `guerreros2021` VALUES ('178', 'Daniela Quiroz', 'Danielle', '2003-10-26', '17', 'F', 'S', 'Ciudad de México', '5539639002', 'daniela.quiroz7u7@gmail.com', 'Gatos, polvo', 'Para tener una comunión más cercana con Dios, aprender y disfrutar', '1', '0', 'A', '5554034494', 'Jesucristo Redentor Perfecto', '2021-05-28 01:18:16', 'Marisol Vera Garrido', 'Danielle Quiroz', 'dxnielle._', '', 'daniela2563', '\0');
INSERT INTO `guerreros2021` VALUES ('179', 'Gustavo Maceda Macario', 'Gustavo', '2000-01-02', '21', 'M', 'X', 'Tehuacán, Puebla', '23814499953', 'gustavomac556@gmail.com', 'Ninguna', 'Para conocer más a Dios', '0', '0', 'A', '2222774397', '', '2021-05-29 21:06:30', 'Violeta Maceda Macario', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('180', 'Eduardo Maceda Macario', 'Eduardo', '2004-03-03', '17', 'M', 'XL', 'Tehuacán, Puebla', '2382759810', 'correodetareasetc13@gmail.com', 'Ninguna', 'Para despejarme', '0', '0', 'A', '2222774397', '', '2021-05-29 21:29:08', 'Violeta Maceda Macario', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('181', 'Moisés Venegas Maceda', 'Moisés', '0000-00-00', '13', 'M', 'S', 'Tehuacán, Puebla', '2222774397', 'vmaceda29@gmail.com', 'Ninguna', 'Para aprender algo nuevo', '0', '0', 'A', '2222774397', '', '2021-05-29 22:26:33', 'Violeta Maceda Macario', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('182', 'Santiago Martínez Maceda', 'Santiago', '0000-00-00', '18', 'M', 'X', 'Tehuacán', '2381154078', 'santy.mtzm@gmail.com', 'Ninguna', 'Para conocer más a Dios', '0', '0', 'A', '2222774397', '', '2021-05-30 13:56:40', 'Violeta Maceda Macario', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('183', 'Javier Martínez Maceda', 'Javier', '0000-00-00', '13', 'M', 'S', 'Tehuacán', '2222774397', 'vmaceda29@gmail.com', 'Ninguna', 'Para conocer más a Dios', '0', '0', 'A', '2222774397', '', '2021-05-30 14:01:11', 'Violeta Maceda Macario', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('184', 'Violeta Maceda Macario', 'Vio', '0000-00-00', '33', 'F', 'S', 'Tehuacán, Puebla', '2222774397', 'vmaceda29@gmail.com', 'Ninguna', 'Que mi familia tenga un encuentro con Dios', '1', '0', 'A', '2222774397', '', '2021-06-01 09:46:13', 'Violeta Maceda Macario', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('185', 'karla reyes', 'karla ', null, '0', 'F', 'XS', 'pachuca', '7715251135', 'solisreyes114@gmail.com', 'ninguna', 'quiero servir, y seguir desarrollando mi liderazgo', '1', '0', 'A', '4441057175', 'PIB', '2021-06-01 11:34:25', 'Margot', 'Reyes Karla', 'Reyes_Karls', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('186', 'Jony Buendia Pitalua', 'Buendía ', null, '0', 'M', 'S', 'Pachuca', '7712196807', 'jbpitalua@gmail.com', 'Ninguna ', 'Staff', '1', '0', 'A', '7712196807', 'Jucum Pachuca', '2021-06-01 11:39:02', 'Jony Buendia Pitalua', 'Jony Buendia', 'jbuendiap', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('187', 'Evan ', 'Minty', '2004-08-04', '16', 'M', 'XS', 'Hidalgo', '7717080182', 'evannet099@gmail.com', 'Ninguna', 'Conocer más a Dios y aprender su palabra ', '1', '0', 'A', '7712088634', 'Cornestone', '2021-06-01 14:17:38', 'Ricardo', 'Evan Hernández ', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('188', 'Hilaria Martínez ', 'Hilaria ', '1997-08-06', '23', 'F', 'S', 'CDMX ', '7713402023', 'hilarymart39@gmail.com', 'Nada', 'A servir ', '1', '0', 'A', '7713402023', 'Fuente de vida', '2021-06-01 23:42:03', 'Hilaria ', 'Hilaria Gil ', 'Hilariagil8', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('189', 'Yirel Pereira Romero ', 'Yiyos ', '1999-07-05', '21', 'F', 'XS', 'Estado de México ', '5540346755', 'yirelyiyos@icloud.com', 'No ', 'Servicio ', '1', '0', 'A', '55 4996 3498', '', '2021-06-02 12:22:48', 'Pablo Pereira Romero ', 'Yirel Yiyos pereira Romero ', 'Yirel yiyos pereira romero ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('190', 'Jahaziel Yamil Pereira Romero', 'JAHZIEL PEREIRA', null, '0', 'M', 'X', 'Ecatepec de Morelos', '5583046771', 'jahazielypr@gmail.com', 'Muejeres ', 'Para servir a otros ', '1', '0', 'A', '5549963498', 'Amistad cristiana Ecatepec', '2021-06-02 12:24:20', 'PABLO PEREIRA', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('192', 'Berenice Lozano', 'Bere', '0000-00-00', '27', 'F', 'S', 'Mi casa ', '7711506403', 'berenicelozano2@gmail.com', 'No', 'Staff', '1', '0', 'A', '7712388715', '', '2021-06-03 12:06:16', 'Luz', '', '', '', 'saxofon4800frase', '\0');
INSERT INTO `guerreros2021` VALUES ('193', 'Aradia Escalona Luengas', 'Anel Aradia', '0000-00-00', '19', 'F', 'M', 'Pachuca', '5584840593', 'aradiaescalonaluengas1B1@gmail.com', 'Ninguna', 'Staff', '1', '0', 'A', '5532301276', 'Capitolio', '2021-06-03 14:30:20', 'Elsa Luengas Benítez', 'A Anel Escalona', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('194', 'Elena Gabriela', 'Elenita', '2004-09-05', '16', 'F', 'M', 'YWAM Pachuca ', '5529498802', 'brillantetita@gmail.con', 'Ninguna', 'Quiero apoyar el ministerio ', '1', '0', 'A', '7751557295', 'Cornerstone ', '2021-06-03 21:05:35', 'Delia Alicia Hernández Hernández ', 'Elenita Gabriela ', 'itsgabrielahz ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('195', 'Diana mota ', 'Diana M', '2002-02-05', '19', 'F', 'M', 'Pachuca ', '7713337434', 'dianamota0320@gmail.com', 'Ninguna ', 'Staff ', '1', '0', 'A', '7713014449', 'Shalom', '2021-06-05 10:09:20', 'Viridiana ', 'Diana mota ', 'Diana_mota', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('196', 'Daniela Rergis ', 'Danny', '1999-10-05', '21', 'F', 'X', 'Cdmx', '5545762580', 'dannyrergis@hotmail.com', 'Sulfas ', 'Staff', '1', '0', 'A', '5543652979', 'Hope and anchor', '2021-06-05 15:36:35', 'Verónica Pérez Gallardo Pérez ', 'Danny Rergis ', 'Dannyrergispg', '', 'mexico3722asdf', '\0');
INSERT INTO `guerreros2021` VALUES ('197', 'Ernesto Díaz', 'Neto', '1984-02-06', '37', 'M', 'M', 'Puebla', '2227663722', 'diazdern@gmail.com', 'ninguna', 'apoyo como staff', '1', '0', 'A', '2214361518', 'Amistad de Puebla', '2021-06-05 18:39:20', 'Leopoldo Diaz', 'neto dideka', 'neto dideka', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('199', 'Citlali Pérez Martínez ', 'Citlali', '1980-04-02', '41', 'F', 'S', 'Pachuca ', '7717221473', 'citlalijucum@gmail.com', 'Ninguna ', 'Staff ', '1', '0', 'A', '7717221473', '', '2021-06-05 19:20:24', 'Citlali Pérez Martínez ', 'Citlali PMtz', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('200', 'Uriel Vela Soto', 'Uriel Vela', '1998-02-01', '23', 'M', 'M', 'Estado de México', '5533556426', 'velhost22@gmail.com', 'None', 'Servir a Dios y a los campistas en el ministerio RU', '1', '0', 'A', '5570727572', '', '2021-06-06 10:15:05', 'Alvaro Vela Bello', 'Uriel Vela', '@grickle202', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('201', 'Nelly Monserrath Olvera Hernan', 'Nelly Olvera ', null, '0', 'F', 'S', 'Pachuca de Soto ', '7713531839', 'nellyolverahernandez@gmail.com', 'Ninguna ', 'Servir a Dios ', '1', '0', 'A', '7713441396', 'Iglesia Cristiana Nueva Semilla', '2021-06-06 14:44:24', 'Linda Hernandez ', 'Nelly Olvera', 'nellyolvera_', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('202', 'Dan Giovanni Medina Camacho', 'Gio', '2000-12-22', '20', 'M', 'M', 'Tula de Allende, Hgo', '5532756461', 'camacho3.dan@gmail.com', 'Ninguna ', 'Conocer más De Dios ', '0', '0', 'A', '7732195832', 'Nueva Vida', '2021-06-07 09:48:58', 'Carolina Camacho Alvarez ', 'Dan Giovanni Medina Camacho ', '@dangio12', '', 'volta3365mexico', '\0');
INSERT INTO `guerreros2021` VALUES ('203', 'Wendy Alaní Esparza Maceda', 'Wendy', '0000-00-00', '17', 'F', 'M', 'Tehuacán Puebla México', '2382253950', 'w.alani.esparza@gmail.com', 'Penisilina', 'Aprender y conocer más de Dios', '0', '0', 'A', '2222774397', '', '2021-06-11 18:21:51', 'Violeta Maceda Macario', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('211', 'Fatima Curiel', 'Fatima', '1999-08-05', '21', 'F', 'X', 'Las Américas', '5584031939', 'faticuriel3@gmail.com', 'Ninguna', 'Invitación de Rich, además amo reto y me encanta servir a Dios aquí.', '1', '0', 'A', '5584031839', 'Amistad cristiana \"Las Américas\"', '2021-06-12 12:28:56', 'Fatima Curiel', 'Fatima Curiel', 'fa.curiel', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('212', 'Allison Perez', 'Allison', '2005-10-02', '15', 'F', 'M', 'Pachuca', '5517439292', 'bane.caro@gmail.com', 'Ninguna', 'Para conocer más de Dios ', '0', '0', 'B', '5517439292', 'Vida Plena ', '2021-06-13 18:08:12', 'Carol Neri', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('213', 'Mireille Lueguer Ortiz ', 'Mireille ', '0000-00-00', '17', 'F', 'XL', 'Pachuca Hgo', '7711231063', 'estebanlueguer@gmail.com', 'Gatos, manzanas ', 'Para poder acercar a otros a Dios ', '0', '0', 'A', '7713533166 ', 'Vida Plena ', '2021-06-13 19:00:45', 'Esteban Ismael Lueguer Villagrán ', 'Mireille Lueguer Ortiz ', 'mireille_ortiz ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('214', 'Auri Lueguer Ortiz ', 'Auri ', '0000-00-00', '15', 'F', 'X', 'Pachuca Hgo', '7711231063', 'estebanlueguer@gmail.com', '0 alergias ', 'Para conocer a mas cristianos de mi edad ', '0', '0', 'A', '7713533166 ', 'Vida Plena ', '2021-06-13 19:05:31', 'Esteban Ismael Lueguer Villagrán ', 'Auri Lueguer Ortiz ', 'L.U.E.G.U.E.R', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('216', 'Ricardo Hernandez', 'Richz Volta', null, '0', 'M', 'M', 'Jucumlandia', '7712088634', 'richjucum@gmail.com', 'A los gatos', 'Por que si', '1', '0', 'A', '7712088634', 'Conerstone', '2021-06-14 09:19:12', 'Citlali ', 'Richz Volta', 'Richzvolta', '', 'musik2310nota', '\0');
INSERT INTO `guerreros2021` VALUES ('217', 'Sylvia Guadalupe Franco Ascenc', 'Syl', '1997-02-01', '24', 'F', 'XS', 'Pachuca', '7711172562', 'sylfrasc@gmail.com', 'ninguna', 'Estuve orando y Dios me reveló algunos recuerdos en RU de 2014, después Nelly me dijo que Dios quería que fuera, (? je', '0', '0', 'B', '7712987478', 'Nueva Semilla', '2021-06-15 12:36:20', 'David Franco', 'Sylvia Franco', 'sylvitabonita', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('218', 'Yesica Fernanda Hernández ', 'Yesi Fer', '2003-10-05', '17', 'F', 'S', 'Atizapan  de zaragoza ', '5539414459', 'lic.karen17@hotmail.com', 'Ninguna ', 'Experimentar ', '0', '0', 'A', '5529980779', '', '2021-06-15 21:34:47', 'Karen Stefany Martínez Hernández ', 'Yesica  Manríquez ', 'Fer_sandoval__ ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('219', 'Daniel Esaú Mejía Márquez ', 'Daniel Márquez ', '2001-09-02', '19', 'M', 'X', 'Pachuca Hidalgo', '7713426938', 'mejiadaniel1816@gmail.com', 'Ninguna', 'Para estar más cerca de Dios', '0', '0', 'B', '7711156795', '', '2021-06-15 21:36:54', 'Celia Márquez Téllez ', 'Daniel Márquez ', 'jolindnerr ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('220', 'Lilian Aline López Romero', 'Lilian', '2000-02-01', '21', 'F', 'S', 'Ecatepec de Morelos', '5529211568', 'lilianlr09@hotmail.com', 'Ninguna', 'Seguir llenandome de Dios', '0', '0', 'A', '5571911369', '', '2021-06-15 22:12:43', 'Sergio López Martínez ', 'Aline López', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('221', 'Yosef yael castañon cruz', 'Yosef', '0000-00-00', '17', 'M', 'X', 'Tamazunchale S.l.P.', '4831120506', 'yosefcascru@gmail.com', 'Penicilina ', 'Por qué Dios me llamo a ir y se que tiene algo que hablarme en ese lugar ', '1', '0', 'A', '4831118074', 'Hogar cristiano ABBA ', '2021-06-16 15:34:55', 'Gabriel Castañón Zuñiga ', 'Yosef cas', 'Yosef cas ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('222', 'Miguel Ángel Carreiro', 'Miguel Carreiro', '2002-03-04', '19', 'M', 'M', 'Atizapán de Zaragoza', '5535157012', 'speedybasher15@outlook.com', 'A nada ', 'Conocer más de Dios ', '0', '0', 'A', '5541775303', '', '2021-06-16 22:19:37', 'Pilar Carreiro', 'Miguel Carreiro', 'Miguel_carreiro0', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('223', 'Isaac Levi Reyes Cisneros', 'Reyes ', '2000-01-01', '21', 'M', 'M', 'Estado de México ', '5616499020', 'isaacreyesc14@gmail.com', 'Ninguna ', 'Recomendación ', '0', '0', 'A', ' 5517543328', '', '2021-06-16 23:05:43', 'Sergio Luis Reyes Vázquez', 'Isaac Reyes ', '', '', 'saxofon6962segu1', '\0');
INSERT INTO `guerreros2021` VALUES ('225', 'Esdras Aarón de la Cruz', 'Esdras', '2007-06-01', '13', 'M', 'S', 'CDMX, México.', '5544368339', 'lilly_sosa@yahoo.com.mx', 'Ninguno', 'Porque quiero aprender a como llevar el evangelio a mas personas', '0', '0', 'A', '5526650667', 'Iglesia cristiana pentecostés \"El Buen Jesús\"', '2021-06-18 12:59:57', 'Aarón de la Cruz', 'Esdras Aarón', '@dlcesdras', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('226', 'Taurino Bustos Ramírez', 'Tau', '1983-03-04', '38', 'M', 'X', 'Pachuca Hidalgo', '5584518866', 'cygnustaurus@gmail.com', 'Ninguna', 'Staff', '1', '0', 'A', '771 208 8634', 'Cornestone Pachuca', '2021-06-18 15:03:21', 'Ricardo Hernández', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('227', 'vanessa martinez hernandez', 'vane', null, '0', 'F', 'M', 'tamazunchale san luis potosi', '4831045490', 'vanemtz777@gmail.com', 'abejas', 'crecimiento espiritual', '0', '0', 'A', '4831043015', 'hogar cristiano abba', '2021-06-19 21:07:55', 'julio cesar aguado elizalde', 'vanessa martinez', 'vane_4884', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('228', 'antonieta estrada castillo', 'nona', null, '0', 'F', 'XL', 'tamazunchale san luis potosi', '4821063776', 'antonietaescas@gmail.com', 'nada', 'crecimiento espiritual', '0', '0', 'A', '4831043015', 'hogar cristiano abba', '2021-06-19 21:15:24', 'julio cesar aguado elizalde', 'Nona Escas', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('229', 'wendy elizondo martinez', 'wendy', null, '0', 'F', 'XL', 'tamazunchale san luis potosi', '4831304740', 'we533989@gmail.com', 'nada', 'crecimiento espiritual', '0', '0', 'A', '4831043015', 'hogar cristiano abba', '2021-06-19 21:18:50', 'julio cesar aguado elizalde', 'wendy elizondo', 'wendyelizondomartinez', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('230', 'Jesús Jahir Martínez Santibáñe', 'Santi', null, '0', 'M', 'M', 'tamazunchale san luis potosi', '4831091108', 'jahir1931@outlook.com', 'camarones ', 'Para aprender mas de Dios', '0', '0', 'A', '4831043015', 'Hogar Cristiano ABBA', '2021-06-19 21:26:51', 'Julio Cesar Aguado Elizalde', 'Jahir Martinez Santibañez ', 'no tengo ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('231', 'Moisés Hernández Flores', 'MOY', null, '0', 'M', 'M', 'tamazunchale san luis potosi', '4831035558', '20181016@uthh.edu.mx', 'nada', 'Para aprender mas de Dios', '0', '0', 'B', '4831043015', 'Hogar Cristiano ABBA', '2021-06-19 21:32:58', 'Julio Cesar Aguado Elizalde', 'Moises Hernandez Florez', 'no tengo ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('233', 'ILEANA ABIGAIL ENRIQUEZ NUÑEZ', 'ILE', null, '0', 'F', 'M', 'tamazunchale san luis potosi', '4831099311', 'ileanaenriquez19@hotmail.com', 'MEDICAMENTO TRIMETROPRIMA Y SULFAMETOXASOL', 'PARA CONOCER MAS DE DIOS Y TENER UN CRECIMIENTO ESPIRITUAL', '0', '0', 'A', '4831043015', 'Hogar Cristiano ABBA', '2021-06-19 21:38:45', 'Julio Cesar Aguado Elizalde', 'Ileana Enriquez', 'Ileana.enriquez1', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('234', 'JULIO CESAR AGUADO ENRIQUEZ', 'JULITO', null, '0', 'M', 'XS', 'tamazunchale san luis potosi', '4831099311', 'ileanaenriquez19@hotmail.com', 'MEDICAMENTO IBUPROFENO', 'PARA CONOCER MAS DE DIOS Y TENER UN CRECIMIENTO ESPIRITUAL', '0', '0', 'A', '4831043015', 'Hogar Cristiano ABBA', '2021-06-19 21:41:12', 'Julio Cesar Aguado Elizalde', 'Ileana Enriquez', 'Ileana.enriquez1', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('236', 'Martha Ilef Echavarria Castill', 'Marthita Echavarría ', '0000-00-00', '16', 'F', 'XS', 'Tamazunchale SLP', '4831143572', 'martha.echavarriaa0@gmail.com', 'Ninguna', 'Aprender y tener una firmeza aún más fuerte en la relación con el Padre ', '0', '0', 'A', '4831043015', 'HOGAR CRISTIANO ABBA', '2021-06-19 21:50:38', 'Julio César Aguado Elizalde ', 'Marthita Echavarria ', 'Martha.echavarrria', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('237', 'Regina Rergis ', 'Regis', '2007-02-01', '14', 'F', 'M', 'Cdmx', '5545762580', 'regisrergis@gmail.com', 'Ninguna ', 'Mi prima me trajo ', '0', '0', 'A', '5587773575', '', '2021-06-21 11:12:06', 'Blanca Oliva', 'Regina Rergis ', 'Regisrergis ', '', 'segu17054nota', '\0');
INSERT INTO `guerreros2021` VALUES ('239', 'Briseida Rodríguez Franco ', 'Bris', null, '0', 'F', 'X', 'Ciudad de México', '5518231186', 'brisbere@gmail.com', 'No', 'Quiero ser voluntaria ', '1', '0', 'A', '5549409221', 'CEFRI', '2021-06-22 16:31:11', 'Irma Franco ', 'Bris Fra ', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('240', 'Addi Aguayo', 'Addi', null, '0', 'F', 'S', 'United States', 'Melody Aguay', 'mjaguayo7080@bellsouth.net', 'no', 'to learn about God', '0', '0', 'A', '615-498-3381', 'Strong tower bible', '2021-06-23 09:11:57', 'Melody Aguayo', 'Melody Aguayo', 'melody aguayo', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('241', 'Karen Puckett- Steenson', 'Karen', null, '0', 'F', 'M', 'United States', 'Melody Aguay', 'mjaguayo7080@bellsouth.net', 'no', 'to learn about God', '1', '0', 'B', '615-498-3381', 'Strong tower bible', '2021-06-23 09:13:11', 'Karen Puckett- STeenson', 'Melody Aguayo', 'melody aguayo', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('242', 'Melody Aguayo', 'Melo', null, '0', 'F', 'X', 'United States', 'Melody Aguay', 'mjaguayo7080@bellsouth.net', 'no', 'to learn about God', '1', '0', 'B', '615-498-3381', 'Strong tower bible', '2021-06-23 09:14:12', 'Melody Aguayo', 'Melody Aguayo', 'melody aguayo', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('243', 'Adrián Bonilla', 'Adrián', '2001-10-01', '19', 'M', 'S', 'CDMX', '55 6865 4025', 'boruroad@hotmail.com', 'Ninguna', 'Apoyo al staff de Reto :))', '1', '0', 'A', '55 1835 9606', 'FARO', '2021-06-23 18:39:31', 'Sheila Bonilla', 'Adrián Bonilla', '@boruroad', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('244', 'Thiara', 'Thi', '0000-00-00', '15', 'F', 'XS', 'Argentina ', '+52998128332', 'marcecastillorosales@gmail.com', 'Ninguna ', 'Conocer mas de Dios', '0', '0', 'A', '+54299620036', 'Vida Life', '2021-06-23 20:11:49', 'Sebastian Dominguez ', 'Thiara Dominguez ', 'Thiaru_dominguez ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('245', 'Carolina Guerrero', 'Carol', '2005-06-02', '15', 'F', 'S', 'Pachuca', '7714206164', 'carolinaparker1211@gmail.com', 'Ninguna', 'Quiero aprender y mejorar mi relación con con Dios', '0', '0', 'A', '7711747711', 'Cornestone', '2021-06-24 21:23:26', 'Rocío Guerrero Jiménez', 'Carolina Parker', 'Carolina Parker 317', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('246', 'Nazly Hernández Hernández', 'Nazly', '2001-06-05', '19', 'F', 'S', 'Tamazunchale, SLP', '4811060897', '27hdz.01@gmail.com', 'Ninguna ', 'Para convivir ', '0', '0', 'A', '4831276577', 'Hogar Cristiano ABBA', '2021-06-26 13:08:32', 'Ruth Hernández Flores', 'Nazly Hernández', 'Nazlyh.27', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('247', 'Luisa Ludmila Torres Hernández', 'Mila ', null, '0', 'F', 'S', 'San Luis Potosí, SLP', '4444195126', 'milaht75@gmail.com', 'Frio ', 'Encontrarme con Dios Nuevamente', '0', '0', 'A', '4444751015', 'El Gran Redentor', '2021-06-26 13:35:42', 'Veronica Hernandez Silos', 'Mila Torres', 'milxht', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('248', 'Luisa Ludmila Torres Hernández', 'Mila ', null, '0', 'F', 'S', 'San Luis Potosí, SLP', '4444195126', 'milaht75@gmail.com', 'Frio ', 'Encontrarme con Dios Nuevamente', '0', '0', 'B', '4444751015', 'El Gran Redentor', '2021-06-26 13:36:01', 'Veronica Hernandez Silos', 'Mila Torres', 'milxht', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('249', 'Geovanna Lizbeth Gonzalez Torr', 'Vanna', '2003-03-03', '18', 'F', 'X', 'San Luis potosi', '4447670225', 'lizbethgonzaleztorres7@gmail.com', 'Arañas', 'Nueva Experiencia y conocer más sobre dios', '0', '0', 'B', '8442055786', '.', '2021-06-26 13:57:23', 'Ludin Torres bonilla ', 'Lizbeth Torres', 'Lizbeth Gonzalez 23', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('250', 'Geovanna Lizbeth Gonzalez Torr', 'Vanna', null, '0', 'F', 'X', 'San Luis potosi', '4447670225', 'lizbethgonzaleztorres7@gmail.com', 'Arañas', 'Nueva Experiencia y conocer más sobre dios', '0', '0', 'B', '8442055786', '.', '2021-06-26 14:02:12', 'Ludin Torres bonilla ', 'Lizbeth Torres', 'Lizbeth Gonzalez 23', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('251', 'Geovanna Lizbeth Gonzalez Torr', 'Vanna', '2003-03-03', '18', 'F', 'X', 'San Luis potosi', '4447670225', 'lizbethgonzaleztorres7@gmail.com', 'Arañas', 'Nueva Experiencia y conocer más sobre dios', '0', '0', 'B', '8442055786', '.', '2021-06-26 14:11:18', 'Ludin Torres bonilla ', 'Lizbeth Torres', 'Lizbeth Gonzalez 23', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('252', 'Elida Martínez De Jesús ', 'Ely', '2004-04-06', '17', 'F', 'XS', 'Campista ', '5547723157', 'em2354041@gmail.com', 'Nada ', 'Conocer a dios ', '0', '0', 'B', '7713402023', 'Fuente de vida ', '2021-06-27 11:57:57', 'Hilaria Martínez ', 'Elida de Jesús gil', 'Elida de Jesús gil', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('253', 'Braulio Aarón Lara Suárez ', 'Braulio', '2002-09-03', '18', 'M', 'M', 'Ecatepec ', '5527591377', 'braulara712@gmail.com', 'Ninguna ', 'Mejorar mi relación con Dios y conocerme mejor en base a eso', '0', '0', 'A', '5563518800', '', '2021-06-28 13:37:34', 'Armando Lara', 'Braulio Lara', 'braulio.318', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('254', 'Israel', 'Israel', '0000-00-00', '16', 'M', 'S', 'Chiapas, Mexico', '9613368339', 'IsraelGC.30@hotmail.com', 'al polvo', 'Aprender y aplicar lo aprendido en el servicio a Dios ', '0', '0', 'A', '5518231186', 'Templo Auditorio Cristiano \"Solo Cristo Salva\"', '2021-06-29 09:32:22', 'Briseida Rodríguez Franco', 'Israel Gomez Castelazo ', 'israelgc01', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('255', 'Gabriel Castañón Zuñiga', 'Gabe', null, '0', 'M', 'XL', 'Tamazunchale SLP.', '4831118074', 'thegibson_2782@outlook.com', 'Penicilina', 'Servir', '1', '0', 'A', '4831098322', 'Hogar Cristiano ABBA', '2021-06-29 17:03:58', 'Miriam', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('256', 'Miriam Isabel Cruz Jonguitud', 'Miriam', null, '0', 'F', 'M', 'Tamazunchale SLP', '4831098322', 'cieloazul192@yahoo.com', 'Penicilina', 'Servicio voluntario', '1', '0', 'A', '4831118074', 'Hogar Cristiano ABBA', '2021-06-29 17:09:14', 'Gabriel Castañón', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('257', 'Jayden Matthew Castañón Cruz', 'Jayden', null, '0', 'M', 'XS', 'Tamazunchale SLP', '4831118074', 'thegibson_2782@outlook.com', 'Penicilina', 'Servicio voluntario', '1', '0', 'A', '4831118074', 'Hogar Cristiano ABBA', '2021-06-29 17:12:59', 'Gabriel Castañón', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('258', 'Gabriel Castañón Zúñiga', 'Gabe', null, '0', 'M', 'XL', 'Tamazunchale SLP', '4831118074', 'thegibson_2782@outlook.com', 'Penicilina', 'Servicio voluntario', '0', '0', 'B', '4831118074', 'Hogar Cristiano ABBA', '2021-06-29 17:14:41', 'Gabriel Castañón', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('259', 'Daniel Estrada', 'Dan', '2002-02-06', '19', 'M', 'XXL', 'Tyler Tx', '9035760245', 'danthegoat54@gmail.com', 'No', 'Vacaciones, divertirme y estar con el Evan', '0', '0', 'A', '+1 903 360 4', 'The Lords House', '2021-06-29 18:26:21', 'Merced Estrada', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('260', 'Saúl Josadac Jiménez Sánchez ', 'Josadac. ', null, '0', 'M', 'S', 'Estado de México ', '5539759144', 'ojosadac1@gmail.com', 'Negadas', 'Porque cambio mi vida y la sigue cambiando. ', '1', '0', 'A', '5512861780', 'Centro Cristiano Calacoaya', '2021-06-29 20:17:38', 'Bertha Sánchez Mayén', 'Josadac Jiménez ', 'Josadac Jiménez ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('261', 'Martín de Jesús Elizondo Resén', 'Chuyin ', null, '0', 'M', 'XL', 'Tamazunchale slp ', '4831043015', 'martindejesuselizondo@gmail.com', 'Ninguna ', 'Para una experiencia nueva con Dios ', '0', '0', 'A', '4831043015', 'Hogar Cristiano ABBA ', '2021-06-29 23:08:52', 'Julio aguado Elizalde ', 'Martin Elizondo ', 'Martin Elizondo ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('262', 'Jorge Takami', 'Jorge ', '1999-03-05', '22', 'M', 'X', 'Cdmx', '5563190576', 'jorge.takamigue@gmail.com', 'N/a', 'Mi novia me trajo ', '0', '0', 'A', '5591972095', '', '2021-06-30 16:36:45', 'Dulce guerrero ', 'Jorge Guerrero ', 'jorge_grs', '', 'zxcv1830musik', '\0');
INSERT INTO `guerreros2021` VALUES ('263', 'Miriam', 'Miriam', '2003-04-01', '18', 'F', 'M', 'Hogar cristiano Abba ', '4831181480', 'miriam.rivera.munoz19@gmail.com', 'Ninguna', 'Nuevas experiencias, conocimiento y aprender mas sobre la palabra de Dios ', '0', '0', 'A', '4831043015', 'Hogar cristiano Abba', '2021-06-30 21:50:36', 'Julio Cesar Aguado Elizalde ', 'https://www.facebook.com/profile.php?id=1000070000', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('264', 'Zabdi Asaph Flores Cobos ', 'Asaph ', '0000-00-00', '16', 'M', 'M', 'Estado de México ', '5565102061', 'asaph1801@gmail.com', 'Polvo ', 'Porque quiero retomar mi relación con Dios ', '0', '0', 'A', '55 6208 2765', 'Casa de adoración ', '2021-06-30 22:28:45', 'Marco A. Flores López ', 'Asaph Flores ', 'asaphflores', '', 'musik2939mexico', '\0');
INSERT INTO `guerreros2021` VALUES ('265', 'Israel Ivan Perez Zapata', 'Ivan', '2003-01-06', '18', 'M', 'X', 'Pachuca', '7714300093', 'bafoonbug@yahoo.com', 'no', 'me interesa seguir una experiencia que mi hermana tuvo y me gustaría tener una experiencia mas profunda con DIOS', '0', '0', 'A', '7711810116', 'Nueva Semilla', '2021-07-02 14:33:06', 'Israel Perez', 'Ivan Zapata', 'Israel_zapata420', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('266', 'Matthew Wayne Syverson Scamble', 'Ivan', '2006-10-01', '14', 'M', 'X', 'Pachuca', '7714044306', 'gregvickisy@yahoo.com', 'no', 'quiero conocer a mas jóvenes y hacer mas amigos y tener un encuentro con Dios', '0', '0', 'A', '7711139495', 'Tierra Fertil', '2021-07-02 14:38:09', 'Vicki Syverson', 'Teo Sy', 'teo_sy_', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('267', 'Angel de Jesús Jiménez Gonzále', 'Angel Jimenez ', '1996-06-03', '24', 'M', 'XXL', 'Cornerstone', '7711774938', 'aj814824@gmail.com', 'No', 'Soy parte del grupo de la alabanza de reto urbano ', '0', '0', 'A', '7711601156', 'Cornerstone', '2021-07-06 16:05:51', 'Florentino Jimenez Pérez ', 'Angel Jimenez Gonzales ', 'angel_jimenez_g', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('268', 'Emmanuel Jaramillo Durán ', 'Emma', '1998-07-03', '22', 'M', 'M', 'Pachuca de Soto', '7714145308', 'jaramilloe08@gmail.com', 'Ninguna', 'Soy musico', '0', '0', 'A', '7717750224', 'Estrella de Belén ', '2021-07-07 11:36:04', 'Leonardo Jaramillo', 'Emmanuel Jaramillo', 'ejaramillomx', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('269', 'Yuritzel Flores Solorzano ', 'Yuri', null, '0', 'F', 'XXL', 'TAMAZUNCHALE, SLO', '4831014450', 'yuritzel_fs@gmail.com', 'No', 'Crecer Espiritualemente', '0', '0', 'B', '4831043015', 'Hogar Cristiano Abba', '2021-07-07 17:51:16', 'Julio Cesar Aguado Elizalde', 'Yuritzel Flores Solorzano ', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('270', 'Yuritzel Flores Solorzano ', 'Yuri', null, '0', 'F', 'XXL', 'Tamazunchale, Slp', '4831014450', 'yuritzelfloressolorzano551@gmail.com', 'No', 'Crecer Espiritualemente', '0', '0', 'A', '4831043015', 'Hogar Cristiano Abba', '2021-07-07 18:00:27', 'Julio Cesar Aguado Elizalde', 'Yuritzel Flores Solorzano ', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('271', 'Yuritzel Flores Solorzano ', 'Yuri', null, '0', 'F', 'XXL', 'Tamazunchale, Slp', '4831014450', 'yuritzelfloressolorzano551@gmail.com', 'No', 'Crecer Espiritualemente', '0', '0', 'B', '4831043015', 'Hogar Cristiano Abba', '2021-07-07 18:00:34', 'Julio Cesar Aguado Elizalde', 'Yuritzel Flores Solorzano ', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('272', 'Yuritzel Flores Solorzano ', 'Yuri', null, '0', 'F', 'XXL', 'Tamazunchale, Slp', '4831014450', 'yuritzel_fs@hotmail.com', 'No', 'Crecer Espiritualemente', '0', '0', 'B', '4831043015', 'Hogar Cristiano Abba', '2021-07-08 11:14:51', 'Julio Cesar Aguado Elizalde', 'Yuritzel Flores Solorzano ', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('273', 'Perla', 'Perla', '1986-08-04', '34', 'F', 'M', 'YWAMQ', '4831006008', 'hergo.perla@gmail.com', 'Cebolla y Ajo', 'Servir ', '1', '0', 'A', '483-1006008', '', '2021-07-08 12:22:43', 'N/A', 'Perla Hergo', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('274', 'Kriz', 'Kriz', '1990-03-06', '31', 'F', 'M', 'YWAMQ', '4811131731', 'krhergo@gmail.com', 'Cebolla y Ajo', 'Servir ', '1', '0', 'A', '4811131731', '', '2021-07-08 12:24:19', 'N/A', 'Kriz Hergo', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('275', 'Lluvia de Abril Samano ', 'lluvia', '2006-01-04', '15', 'F', 'M', 'Cancun', '9988429924', 'Lluviadeabrilnava@gmail.com', 'N/A', 'Conocer mas a Dios', '0', '0', 'A', '99813135010', '', '2021-07-08 21:09:56', 'Deyanira ', 'N/O', 'N/O', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('276', 'Isi Romero', 'Isi ', '1991-02-06', '30', 'F', 'XS', 'Pachuca', '7713571372', 'isiromero_templos@hormail.com', 'Ninguna ', 'Servir', '1', '0', 'A', '7714104887', 'PIB ', '2021-07-10 22:16:17', 'Martha Templos', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('277', 'Martha Deyra Romero Templos', 'Dey', '0000-00-00', '32', 'F', 'M', 'Pachuca', '7713211682', 'martharomero_templos@hotmail.com', 'Ninguna', 'Servir', '1', '0', 'A', '7713211682', 'PIB PACHUCA', '2021-07-11 16:51:29', 'Martha Templos Luna', 'Martha Romero', 'Deyrart', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('278', 'Marian', 'Sánchez Tenorio', '1999-11-06', '21', 'F', 'M', 'Estado de México ', '5535256212', 'mariansanchezt@gmail.com', 'Sulfas medicamento ', 'Adoro reto ??', '1', '0', 'A', '5537347908', 'Comunidad FARO', '2021-07-11 17:44:19', 'Martha Sanchez', 'Marian ST', 'Marian_sanchezt', '', 'auto1649frase', '\0');
INSERT INTO `guerreros2021` VALUES ('279', 'Gamaliel', 'Jiménez Talonia', '1999-03-04', '22', 'M', 'X', 'CDMX', '5573601833', 'gamatalonia99@gmail.com', 'Nada', 'Me gusta ser retado ', '0', '0', 'A', '5573388179', 'Comunidad FARO', '2021-07-11 17:55:43', 'Carlos Jiménez ', 'Gamaliel Jiménez Talonia', 'gama_talonia', '', 'retoU4281volta', '\0');
INSERT INTO `guerreros2021` VALUES ('280', 'Stephanee Michelle Muñoz Solar', 'Stephanee Solarte', '2004-03-01', '17', 'F', 'XS', 'Pachuca Hidalgo ', '7714046241', 'stephaneemunoz4@gmail.com', 'Ninguna', 'Me gustaría aprender más acerca de Dios', '0', '0', 'B', '5518145797', 'Cielos abiertos ', '2021-07-14 07:22:40', 'Martha Leyda Solarte Solarte ', 'Stephanee Muñoz ', 'stephanee_munoz96 ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('281', 'Stephanee Michelle Muñoz Solar', 'Stephanee Solarte', '2004-03-01', '17', 'F', 'XS', 'Pachuca Hidalgo ', '7714046241', 'stephaneemunoz4@gmail.com', 'Ninguna', 'Me gustaría aprender más acerca de Dios', '0', '0', 'A', '5518145797', 'Cielos abiertos ', '2021-07-14 07:22:51', 'Martha Leyda Solarte Solarte ', 'Stephanee Muñoz ', 'stephanee_munoz96 ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('282', 'Eleazar Hernandez', 'Papa Ele', '0000-00-00', '0', 'M', 'M', 'Huitzi', 'sdfqsdg', 'asd@dad.com', 'No', 'Voluntario', '1', '0', 'A', '71717737383', 'Huitzi', '2021-07-15 10:56:06', 'Mayor de edad', 'Sgrret', 'Wert', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('283', 'Delia Hernandez', 'Mama YEYA', '2021-06-01', '0', 'F', 'M', 'HUITZI', 'adfwe', 'yeya@gmail.com', 'NO', 'SERVIR', '1', '0', 'A', '1332524', 'Si', '2021-07-15 10:58:31', 'Adulto', 'Wfw', 'Wr', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('284', 'Johannes Aguado', 'Johannes', '0000-00-00', '1', 'M', 'X', 'Républica Dominicana', '12354', 'joha@gmail.com', 'No', 'Dios', '0', '0', 'A', '1234123255', 'Si', '2021-07-15 11:25:33', 'Dr Melody Aguayo', '24514', '2455', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('285', 'Jose Guevara', 'Jose', '2021-06-03', '0', 'M', 'X', 'Tyler Tx', '12451qwt', 'jose@gmail.com', 'No', 'Dios', '0', '0', 'A', '1235136', 'W45r', '2021-07-15 11:28:46', 'Jose Luis Guevara', '1234', '125', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('286', 'Haniel', 'Haniel', '2003-02-02', '18', 'M', 'M', 'Staff', '2224246315', 'hanielsandoval19@gmail.com', 'No ', 'Me agrada servir', '1', '0', 'A', '2224514757', 'Vida cristiana', '2021-07-15 11:33:32', 'Engelberto sandoval', 'Haniel sandoval', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('287', 'Haniel', 'Haniel', '2003-02-02', '18', 'M', 'M', 'Staff', '2224246315', 'hanielsandoval19@gmail.com', 'No ', 'Me agrada servir', '1', '0', 'B', '2224514757', 'Vida cristiana', '2021-07-15 11:33:59', 'Engelberto sandoval', 'Haniel sandoval', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('288', 'Haniel', 'Haniel', '2003-02-02', '18', 'M', 'M', 'Staff', '2224246315', 'hanielsandoval19@gmail.com', 'No ', 'Me agrada servir', '1', '0', 'B', '2224514757', 'Vida cristiana', '2021-07-15 11:33:59', 'Engelberto sandoval', 'Haniel sandoval', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('289', 'Etni Haniel García Sanchez ', 'Haniel ', null, '0', 'M', 'M', 'Estado de Mexico ', '5574442052', 'etnihanielg@gmail.com', 'Vancomicina', 'Conocer mas de Dios y sanar varias heridas de mi corazon ', '0', '0', 'A', '5544423680', 'Rio central ', '2021-07-15 11:40:03', 'Greta Sanchez Gutierrez ', 'Etni García ', 'Etni García ', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('290', 'David Sanchez Flores', 'David', null, '0', 'M', 'S', 'Puebla', '2213617571', 'dsanchezflores55@gmail.com', 'No', 'Apoyo', '1', '0', 'A', '2221284782', 'Vida Cristiana ', '2021-07-15 11:43:23', 'Isabel Flores Lima', 'David Sanchez Flores', 'im_saintdavid', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('291', 'Karla Flores Navarro', 'Frani', '1991-07-05', '29', 'F', 'XL', 'Tijuana ', '6651375387', 'natsukiailen@gmail.com', 'Harina', 'Papá me envió ', '1', '0', 'A', 'No Aplica', 'Rey de Gloria', '2021-07-15 11:47:43', 'Mayor de edad', 'Karla Frani Flores', 'FraniKya', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('292', 'Francisco Acosta Pacheco', 'Paco', '0000-00-00', '28', 'M', 'M', 'Estado de Mexico', '6692329208', 'paco.acostap17@gmail.com', 'No', 'Servir', '1', '0', 'A', '6692329208', 'Torre fuerte atizapan', '2021-07-15 11:51:42', 'Mayor de edad', 'Pako Acosta', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('293', 'Libni sinai ', 'Garcia Sanchez ', '2021-06-02', '1', 'F', 'M', 'Puebla ', '2223639055', 'libni9022@gmail.com', 'Ninguna ', 'Quiero crecer conforme al carácter de Dios', '0', '0', 'A', '2221142244', 'Vida Cristiana ', '2021-07-15 13:11:22', 'Jerson ', 'Sinai garci ', 'Libni_sinai_gs', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('294', 'Elioth Santiago', 'Elioth', null, '0', 'M', 'M', 'San Luis Potosí', '4831047929', 'cieloazul192@yahoo.com', 'Ninguna', 'Invitacion ', '0', '0', 'A', '4831118074', 'Hogar cristiano ABBA', '2021-07-16 13:28:10', 'Gabriel Castañon', '', '', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('295', 'Jack Puckett', 'Jack', '2021-06-02', '0', 'M', 'X', 'Nashville Tenesse', '84545464646', 'jack@gmail.com', 'Jdkeke', 'Dios', '0', '0', 'A', '3774849393', 'Eufkdkfkfb', '2021-07-16 18:35:48', 'Jonathan Puckett', 'Djifiglxnx', 'Bdjejejdk', '', null, '\0');
INSERT INTO `guerreros2021` VALUES ('297', 'Jonathan García  Gómez', 'John', '2001-05-04', '20', 'M', 'M', 'Estado de México', '5513171956 ', 'johngg345@gmail.com', 'Rinitis Alérgica', 'Continuar con el seguimiento de Reto', '0', '0', 'A', '5544524294', 'Nueva Vida Parques', '2021-10-11 11:02:05', 'Carmen Ignacia Gómez Juárez', 'Jonathan García', 'jonthn.grc', '', 'volta2334qwer', '\0');
INSERT INTO `guerreros2021` VALUES ('298', 'Valeria Ramírez Arias', null, null, null, 'F', null, null, null, 'valeramirezarias@gmail.com', null, null, '0', '1550', 'A', null, null, null, null, null, null, null, 'nota5155retoU', '\0');
INSERT INTO `guerreros2021` VALUES ('299', 'Natalia Ramírez Arias', 'Natalia', null, null, 'F', null, null, null, 'nramireza2004@gmail.com', null, null, '0', '1550', 'A', null, null, null, null, null, null, null, 'saxofon1478pachuca', '\0');
INSERT INTO `guerreros2021` VALUES ('300', 'Surisadai García Sánchez', 'Surisadai', null, null, 'F', null, null, null, 'surisadai0992@gmail.com', null, null, null, '1550', 'A', null, null, null, null, null, null, null, 'retoU2356zxcv', '\0');
INSERT INTO `guerreros2021` VALUES ('301', 'Neitan Worales', 'Nono', null, null, 'M', null, null, null, 'neitan.morales@gmail.com', null, null, null, '1550', 'A', null, null, null, null, null, null, null, 'natancito1', '\0');

-- ----------------------------
-- Table structure for jucum_dat_act
-- ----------------------------
DROP TABLE IF EXISTS `jucum_dat_act`;
CREATE TABLE `jucum_dat_act` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `base` varchar(30) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `tipo_registro` int(11) DEFAULT NULL,
  `conyugue` varchar(50) DEFAULT NULL,
  `hijos` varchar(200) DEFAULT NULL,
  `ninera` bit(1) DEFAULT NULL,
  `menuninos` int(11) DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  `llegada` int(11) DEFAULT NULL,
  `salida` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of jucum_dat_act
-- ----------------------------
INSERT INTO `jucum_dat_act` VALUES ('1', 'Edgar Morales', 'Jucum Durango', '6182067440', 'emorales@jucumdurango.com', '3', 'Amber Morales', 'Josheb 5, Tirzah 3, Coram 1', '', '1', 'M', '1', '3');
INSERT INTO `jucum_dat_act` VALUES ('2', 'Andreas Spohn', 'Durango', '6182245125', 'aspohn@jucumdurango.com', '3', 'Mercedes Bustamante', '2', '\0', '2', 'M', '1', '3');

-- ----------------------------
-- Table structure for pagos
-- ----------------------------
DROP TABLE IF EXISTS `pagos`;
CREATE TABLE `pagos` (
  `id_pago` int(11) NOT NULL AUTO_INCREMENT,
  `id_campamento_guerrero` int(11) DEFAULT NULL,
  `cantidad` decimal(10,2) DEFAULT NULL,
  `descripcion` varchar(30) DEFAULT NULL,
  `divisa` varchar(3) DEFAULT NULL,
  `no_ticket` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_pago`),
  KEY `quien` (`id_campamento_guerrero`),
  CONSTRAINT `quien` FOREIGN KEY (`id_campamento_guerrero`) REFERENCES `campamento_guerreros` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of pagos
-- ----------------------------
INSERT INTO `pagos` VALUES ('6', '27', '1950.00', 'Pago completo', 'MXN', '');
INSERT INTO `pagos` VALUES ('7', '52', '1950.00', 'Pago total', 'MXN', '');
INSERT INTO `pagos` VALUES ('8', '79', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('9', '92', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('10', '25', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('11', '26', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('12', '77', '1000.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('13', '85', '1000.00', 'Anticipo', 'MXN', '');
INSERT INTO `pagos` VALUES ('14', '60', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('15', '88', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('16', '50', '650.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('17', '43', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('18', '30', '600.00', 'Anticipo ', 'MXN', '');
INSERT INTO `pagos` VALUES ('19', '13', '1950.00', 'Pago Reto ', 'MXN', '');

-- ----------------------------
-- Table structure for reconexion
-- ----------------------------
DROP TABLE IF EXISTS `reconexion`;
CREATE TABLE `reconexion` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) DEFAULT NULL,
  `edad` int(11) DEFAULT NULL,
  `telefono` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `vienede` varchar(50) DEFAULT NULL,
  `comentarios` varchar(255) DEFAULT NULL,
  `campamentos` varchar(255) DEFAULT NULL,
  `entrenamientos` varchar(255) DEFAULT NULL,
  `fechahoraregistro` datetime DEFAULT NULL,
  `status` bit(1) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reconexion
-- ----------------------------
INSERT INTO `reconexion` VALUES ('1', 'ZABDI JOSHUA GONZALEZ BRITO', '15', '5526631582', 'zabdijoshua123@gmail.com', 'CIUDAD DE MéXICO', 'HOLAAAA SOY ZABDI ', '2019', '5', '2019-11-25 05:32:23', '');
INSERT INTO `reconexion` VALUES ('2', 'SAúL JOSADAC JIMéNEZ SáNCHEZ ', '17', '5539759144', 'ojosadac1@gmail.com', 'SAN FRANCISCO MAGU', '', '2019,2018', '2,3', '2019-11-25 15:00:44', '');
INSERT INTO `reconexion` VALUES ('3', 'ARADIA ESCALONA LUENGAS', '17', '5584840593', 'aradiaescalonaluengas1b1@gmail.com', 'CIUDAD DE MéXICO', 'NINGUNO', '2019,2018', '4', '2019-11-25 15:04:03', '');
INSERT INTO `reconexion` VALUES ('4', 'JOSE ANTONIO RUBIO GONZáLEZ', '17', '55 3392 5646', 'jr717531@gmail.com', 'LAS AMéRICAS', 'AHí TAMOS!', '2019,2018,2017,2016,2015,2014,2013', '1', '2019-11-25 15:05:17', '');
INSERT INTO `reconexion` VALUES ('5', 'EVELYN NATALIA MORA VELAZQUEZ ', '17', '5545197467', 'natiimorass@gmail.com', 'CDMX', 'NO PUEDO ESPERAR A QUE LLEGUE DICIEMBRE ', '2019', '2', '2019-11-25 15:14:22', '');
INSERT INTO `reconexion` VALUES ('6', 'CAROLINA', '14', '7714206164', 'carolinaparker1211@gmail.com', 'PACHUCA', 'NO TENGO NINGúNO', '2018', '1', '2019-11-25 15:14:32', '');
INSERT INTO `reconexion` VALUES ('7', 'PEDRO OMAR BARRETO OLIVER', '33', '5527684960', 'ptr.barreto@gmail.com', 'STREET HOMIES', 'SALUDOS!', '0', '0', '2019-11-25 15:16:17', '');
INSERT INTO `reconexion` VALUES ('8', 'SANDRA JOCELYN GUTIéRREZ REYNOSO ', '21', '5513190065', 'sandragutierrezreynoso25@gmail.com', 'AZCAPOTZALCO, CDMX', 'QUIERO APRENDER COMO DESARROLLAR MIS HABILIDADES PARA ALCANZAR MáS PERSONAS ♡', '0', '0', '2019-11-25 15:18:46', '');
INSERT INTO `reconexion` VALUES ('9', 'DANIELA ANGANY QUIROZ VERA', '16', '5554034494', 'daniela.quiroz7u7@gmail.com', 'CD DE MéXICO', 'ME GUSTARíA QUEDARME EN HOSPEDARME EN LA BASE POR FAVOR..', '2019,2018', '2,4', '2019-11-25 15:21:29', '');
INSERT INTO `reconexion` VALUES ('10', 'FERNANDA MONTSERRAT MARTíNEZ CANTO', '16', '7712142319', 'fernandacanto02@gmail.com', 'PACHUCA ', 'NO PUDE IR AL CAMPAMENTO DE ESTE AñO', '2018', '5', '2019-11-25 15:43:36', '');
INSERT INTO `reconexion` VALUES ('11', 'YAZMIN ARIAS', '19', '5532092357', 'yezari04@gmail.com', 'CDMX', 'SEGUIMIENTO ', '2019', '2', '2019-11-25 15:47:20', '');
INSERT INTO `reconexion` VALUES ('12', 'BRAULIO AARóN LARA SUáREZ ', '17', '5527591377', 'braulara712@gmail.com', 'LAS AMéRICAS ECATEPEC', 'ME PUEDEN CONFIRMAR SI ME PUEDO QUEDAR EN LA BASE POR FA ☹❤', '2019,2018,2017', '1,4,5', '2019-11-25 15:53:20', '');
INSERT INTO `reconexion` VALUES ('13', 'ARMANDO ARATH LARA SUAREZ', '18', '5510484805', 'arath-lara@outlook.es', 'LAS AMERICAS ECATEPEC', 'ESTA VEZ SI ME DEJAN JAJA, SALUDOS!!\r\nJEJE, SI ME PUEDO QUEDAR EN LA BASE, NO??', '2019,2018,2017', '1,3,4,5', '2019-11-25 15:54:24', '');
INSERT INTO `reconexion` VALUES ('14', 'VEGA ALCáNTARA ABRAHAM ISRAEL ', '22', '5611792260', 'isra-dan@hotmail.com', 'CIUDAD DE MéXICO ', 'ME ENCANTA JUCUM ', '2019', '5', '2019-11-25 16:10:39', '');
INSERT INTO `reconexion` VALUES ('15', 'FERNANDA LEE HERNáNDEZ MARTíNEZ ', '15', '5544825240', 'blanca.leti.mtz.rdz@gmail.com', 'ESTADO DE MéXICO ', 'ME GUSTO MUCHO POR QUE PUDE TENER UN ENCUENTRO CON DIOS.', '2019', '4', '2019-11-25 16:22:05', '');
INSERT INTO `reconexion` VALUES ('16', 'ERICK SEBASTIáN SOSA MANCHA', '17', '5585934256', 'avestruzerick@gmail.com', 'RíO LAS AMéRICAS Y SOY PARTE DEL SEGUIMIENTO', 'HOLA', '2019,2018', '1,2,3,4,5', '2019-11-25 16:31:41', '');
INSERT INTO `reconexion` VALUES ('17', 'CHANTAL RENEé SOSA MANCHA ', '15', '5529202161', 'santalsosa11@gmail.com', 'RIO LAS AMERICAS/ VOY A SEGUIMIENTO', 'NO TENGO NúMERO PERO ES EL DE MI KRNAL', '2018', '1,2,4', '2019-11-25 16:33:11', '');
INSERT INTO `reconexion` VALUES ('18', 'JAZMIN MONTAñO PADRóN ', '16', '5517005613', 'jazminlamejor1517@outlook.es', 'LAS AMERICAS, ECATEPEC.', 'LOS EXTRAñO MUCHO, ESPERO ME DEN PERMISO DE IR, OREN POFAVO.', '2019,2018,2017', '1,4,5', '2019-11-25 16:43:26', '');
INSERT INTO `reconexion` VALUES ('19', 'ANA MARICELA ROMERO JUAREZ', '17', '5531176986', 'maryrj17@hotmail.com', 'ECATEPEC DE MORELOS, FRACC LAS AMéRICAS. ', 'HOLA.! \r\nESPERO ME DEN PERMISO DE IR, LOS EXTRAñO MUCHO, OREN POR QUE ASí SEA PORFI.!!', '2018,2017', '3,5', '2019-11-25 16:43:44', '');
INSERT INTO `reconexion` VALUES ('20', 'YéSICA FERNANDA MARTíNEZ HERNáNDEZ ', '16', '5539414459', 'sandovalyesicafernanda@gmail.col', 'ATIZAPAN DE ZARAGOZA ', 'ME GUSTARíA MUCHO PODER IR ♥️', '2019', '3', '2019-11-25 16:53:01', '');
INSERT INTO `reconexion` VALUES ('21', 'AZUL ZARATE DIAZ', '15', '2215226827', 'zaratediazazul@gmail.com', 'PUEBLA', 'NINGUNO', '0', '1,4', '2019-11-25 17:20:41', '');
INSERT INTO `reconexion` VALUES ('22', 'REBECA', '15', '5574246586', 'rebecavmdo@gmail.com', 'CDMX ', ':)', '2019', '2', '2019-11-25 21:01:05', '');
INSERT INTO `reconexion` VALUES ('24', 'ZURISADAI ', '20', '9711428983', 'sadaialvarez461@gmail.com', 'SALINA CRUZ OAXACA ', 'NINGUNO ', '0', '0', '2019-11-26 21:42:32', '');
INSERT INTO `reconexion` VALUES ('25', 'LUIS ANGEL MENDOZA CAMACHO', '17', '5562252663', 'mendozacamacholuis_20@outlook.com', 'EDO. DE MéXICO', 'SIN COMENTARIOS', '2019,2018,2017,2016', '2', '2019-11-26 22:27:19', '');
INSERT INTO `reconexion` VALUES ('26', 'CARLOS YERETH BELLO HERNáNDEZ ', '15', '7711502962', 'yerethbello@gmail.com', 'PACHUCA ', 'PUES TODO BIEN NO HAY NINGúN PROBLEMA ', '0', '0', '2019-11-28 08:43:37', '');
INSERT INTO `reconexion` VALUES ('27', 'CARLOS YERETH BELLO HERNáNDEZ ', '15', '7711502962', 'yerethbello@gmail.com', 'PACHUCA ', 'PUES TODO BIEN NO HAY NINGúN PROBLEMA ', '0', '0', '2019-11-28 08:43:40', '');
INSERT INTO `reconexion` VALUES ('49', 'ISAAC SáNCHEZ MIRANDA', '19', '5554031766', 'snchezmiranda.isaac@yahoo.com', 'ESTADO DE MéXICO', 'SIN COMENTARIOS', '2019', '2', '2019-12-03 17:34:04', '');
INSERT INTO `reconexion` VALUES ('50', 'ISAAC SáNCHEZ MIRANDA', '19', '5554031766', 'snchezmiranda.isaac@yahoo.com', 'ESTADO DE MéXICO', 'SIN COMENTARIOS', '2019', '2', '2019-12-03 17:35:48', '');
INSERT INTO `reconexion` VALUES ('51', 'ISRAEL SáNCHEZ MIRANDA', '18', '5536767108', 'snchezmiranda.isaac@yahoo.com', 'ESTADO DE MéXICO', 'ESTUVE EN EL TALLER DE ARTES PERO NO APARECE EN LA LISTA', '2019', '0', '2019-12-06 07:45:50', '');
INSERT INTO `reconexion` VALUES ('52', 'DIEGO DODANIM TORRES HERNáNDEZ ', '16', '4442347469', 'Dodaadiction@gmail.com', 'SAN LUIS POTOSI', 'BUSCO MáS INFORMACIóN ', '2019', '4', '2019-12-07 09:53:59', '');
INSERT INTO `reconexion` VALUES ('53', 'PAOLA URBINA ', '24', '+52 (55) 6907 6998', 'pao21@gmail.com', 'TECAMAC ', '', '2009', '1,4,5', '2019-12-07 16:05:15', '');
INSERT INTO `reconexion` VALUES ('54', 'ANDREA ESTRADA GARRIDO', '14', '5520307910', 'michelge82@gmail.com', 'ACOLMAN ESTADO DE MéXICO', 'FUE MUY PADRE LA ESPERIENCIA DE COMO DIOS LLEGó A MI VIDA', '2019', '4', '2019-12-07 16:10:15', '');
INSERT INTO `reconexion` VALUES ('55', 'ALFREDO CAMARGO MONTIEL ', '19', '2584893260', 'sailenser2000@hotmail.com', 'TECAMAC ', ':)', '2018', '3', '2019-12-08 14:18:45', '');
INSERT INTO `reconexion` VALUES ('56', 'TONY ', '17', '4761000708', 'tontoby26@gmail.com', 'LEON GUANAJUATO ', 'YA NO  SOY HUéRFANO SOY LA VOZ QUE CLAMA EN EL DECIERTO ♥️', '2019,2018', '1', '2019-12-09 20:15:24', '');
INSERT INTO `reconexion` VALUES ('57', 'PAOLA ESCUDERO ', '27', '7712024667', 'pao.escudero@hotmail.com', 'PACHUCA', 'REGISTRO RCNX 2019', '0', '0', '2019-12-19 15:15:19', '');

-- ----------------------------
-- Table structure for reto_asistencia
-- ----------------------------
DROP TABLE IF EXISTS `reto_asistencia`;
CREATE TABLE `reto_asistencia` (
  `seguimiento_id` int(11) DEFAULT NULL,
  `estudiante_id` int(11) DEFAULT NULL,
  `confirmacion` tinyint(1) DEFAULT NULL,
  `dia_llegada` varchar(1) DEFAULT NULL,
  `registro` datetime DEFAULT NULL,
  `hora_llegada` varchar(15) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reto_asistencia
-- ----------------------------
INSERT INTO `reto_asistencia` VALUES ('2', '296', '0', 's', '2021-10-07 10:39:58', '7:30 AM');
INSERT INTO `reto_asistencia` VALUES ('2', '216', '1', 'v', '2021-10-09 03:53:51', null);
INSERT INTO `reto_asistencia` VALUES ('2', '165', '1', 'v', '2021-10-09 06:42:04', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('2', '192', '1', 'v', '2021-10-09 18:35:54', '5:00 PM');
INSERT INTO `reto_asistencia` VALUES ('2', '202', '1', 'v', '2021-10-10 14:32:02', null);
INSERT INTO `reto_asistencia` VALUES ('2', '177', '1', 'v', '2021-10-10 22:05:39', '3:00 PM');
INSERT INTO `reto_asistencia` VALUES ('2', '279', '1', 's', '2021-10-11 09:49:11', null);
INSERT INTO `reto_asistencia` VALUES ('2', '223', '1', 's', '2021-10-11 10:16:59', null);
INSERT INTO `reto_asistencia` VALUES ('2', '297', '1', 'v', '2021-10-11 10:22:25', '8:30 PM');
INSERT INTO `reto_asistencia` VALUES ('2', '174', '1', 'v', '2021-10-11 11:11:49', '3:00 PM');
INSERT INTO `reto_asistencia` VALUES ('2', '298', '1', 'v', '2021-10-11 11:15:45', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('1', '165', '1', null, '2021-10-11 11:41:57', null);
INSERT INTO `reto_asistencia` VALUES ('1', '174', '1', null, '2021-10-11 11:41:59', null);
INSERT INTO `reto_asistencia` VALUES ('1', '177', '1', null, '2021-10-11 11:42:00', null);
INSERT INTO `reto_asistencia` VALUES ('1', '202', '1', null, '2021-10-11 11:42:02', null);
INSERT INTO `reto_asistencia` VALUES ('1', '279', '1', null, '2021-10-11 11:42:04', null);
INSERT INTO `reto_asistencia` VALUES ('1', '297', '1', null, '2021-10-11 11:42:06', null);
INSERT INTO `reto_asistencia` VALUES ('1', '298', '1', null, '2021-10-11 11:42:07', null);
INSERT INTO `reto_asistencia` VALUES ('1', '192', '1', null, '2021-10-11 11:44:59', null);
INSERT INTO `reto_asistencia` VALUES ('1', '216', '1', null, '2021-10-11 11:45:00', null);
INSERT INTO `reto_asistencia` VALUES ('2', '166', '1', 'v', '2021-10-11 14:06:49', null);
INSERT INTO `reto_asistencia` VALUES ('2', '196', '1', 's', '2021-10-12 11:31:30', '9:00 AM');
INSERT INTO `reto_asistencia` VALUES ('1', '166', '1', null, '2021-10-12 11:34:32', null);
INSERT INTO `reto_asistencia` VALUES ('2', '278', '1', 's', '2021-10-12 12:25:34', null);
INSERT INTO `reto_asistencia` VALUES ('2', '299', '1', 'v', '2021-10-12 12:30:29', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('1', '296', '1', null, '2021-10-12 14:53:20', null);
INSERT INTO `reto_asistencia` VALUES ('2', '300', '1', 'v', '2021-10-12 21:00:24', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('2', '262', '1', 's', '2021-10-12 21:03:50', '9:00 AM');
INSERT INTO `reto_asistencia` VALUES ('2', '76', '1', 's', '2021-10-13 19:12:23', null);
INSERT INTO `reto_asistencia` VALUES ('1', '76', '1', null, '2021-10-14 10:53:32', null);
INSERT INTO `reto_asistencia` VALUES ('1', '278', '1', null, '2021-10-14 10:53:39', null);
INSERT INTO `reto_asistencia` VALUES ('1', '299', '1', null, '2021-10-14 10:53:43', null);
INSERT INTO `reto_asistencia` VALUES ('1', '300', '1', null, '2021-10-14 10:53:44', null);
INSERT INTO `reto_asistencia` VALUES ('3', '166', '1', 'v', '2021-11-16 15:03:44', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('3', '298', '1', 'v', '2021-11-17 06:10:34', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('3', '192', '1', 'v', '2021-11-17 09:42:16', null);
INSERT INTO `reto_asistencia` VALUES ('3', '174', '1', 'v', '2021-11-17 16:28:27', null);
INSERT INTO `reto_asistencia` VALUES ('3', '177', '1', 'v', '2021-11-17 18:11:40', '3:00 PM');
INSERT INTO `reto_asistencia` VALUES ('3', '279', '1', 's', '2021-11-17 18:11:56', '8:30 AM');
INSERT INTO `reto_asistencia` VALUES ('3', '297', '1', 'v', '2021-11-17 18:13:51', null);
INSERT INTO `reto_asistencia` VALUES ('3', '278', '1', 's', '2021-11-17 18:25:53', null);
INSERT INTO `reto_asistencia` VALUES ('3', '299', '1', 'v', '2021-11-17 19:12:28', null);
INSERT INTO `reto_asistencia` VALUES ('3', '202', '1', 's', '2021-11-17 21:14:05', '9:00 AM');
INSERT INTO `reto_asistencia` VALUES ('3', '178', '1', 'v', '2021-11-17 21:19:20', '8:30 PM');
INSERT INTO `reto_asistencia` VALUES ('3', '76', '1', 'v', '2021-11-18 06:31:37', null);
INSERT INTO `reto_asistencia` VALUES ('3', '264', '1', 'v', '2021-11-18 19:47:38', null);
INSERT INTO `reto_asistencia` VALUES ('3', '68', '1', null, '2022-01-11 10:28:39', null);
INSERT INTO `reto_asistencia` VALUES ('2', '68', '1', null, '2022-01-11 10:29:04', null);
INSERT INTO `reto_asistencia` VALUES ('4', '301', '0', 'v', '2022-01-11 11:09:04', '3:00 PM');
INSERT INTO `reto_asistencia` VALUES ('4', '192', '1', 'v', '2022-01-11 15:14:56', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('4', '165', '1', 's', '2022-01-11 15:15:50', '9:00 AM');
INSERT INTO `reto_asistencia` VALUES ('4', '297', '1', 'v', '2022-01-25 09:43:27', null);
INSERT INTO `reto_asistencia` VALUES ('4', '177', '1', 'v', '2022-01-26 09:16:07', '3:00 PM');
INSERT INTO `reto_asistencia` VALUES ('4', '174', '1', 'v', '2022-01-26 19:30:06', '4:30 PM');
INSERT INTO `reto_asistencia` VALUES ('4', '166', '1', 'v', '2022-01-26 19:33:55', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('4', '76', '1', 'v', '2022-01-27 13:08:29', null);
INSERT INTO `reto_asistencia` VALUES ('4', '178', '1', 'v', '2022-01-27 17:12:30', null);
INSERT INTO `reto_asistencia` VALUES ('4', '202', '1', 's', '2022-01-27 18:50:04', null);
INSERT INTO `reto_asistencia` VALUES ('5', '192', '1', 'v', '2022-02-15 16:13:59', '6:00 PM');
INSERT INTO `reto_asistencia` VALUES ('4', '68', '1', null, '2022-02-17 11:03:20', null);
INSERT INTO `reto_asistencia` VALUES ('4', '216', '1', null, '2022-02-17 11:03:26', null);
INSERT INTO `reto_asistencia` VALUES ('4', '300', '1', null, '2022-02-17 11:03:35', null);
INSERT INTO `reto_asistencia` VALUES ('5', '297', '1', 'v', '2022-02-17 21:14:48', null);
INSERT INTO `reto_asistencia` VALUES ('5', '301', '0', 'v', '2022-04-19 12:02:57', '');
INSERT INTO `reto_asistencia` VALUES ('6', '301', '0', 'v', '2022-08-22 14:09:08', '17:30');

-- ----------------------------
-- Table structure for reto_asistencia_copy
-- ----------------------------
DROP TABLE IF EXISTS `reto_asistencia_copy`;
CREATE TABLE `reto_asistencia_copy` (
  `seguimiento_id` int(11) DEFAULT NULL,
  `estudiante_id` int(11) DEFAULT NULL,
  `confirmacion` tinyint(1) DEFAULT NULL,
  `dia_llegada` varchar(1) DEFAULT NULL,
  `registro` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reto_asistencia_copy
-- ----------------------------
INSERT INTO `reto_asistencia_copy` VALUES ('2', '38', '0', 'v', '2017-12-01 16:54:20');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '45', '0', 'v', '2017-12-01 18:10:43');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '9', '0', 'v', '2017-12-01 18:40:56');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '37', '0', 'v', '2017-12-01 20:03:04');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '35', '0', 'v', '2017-12-01 20:36:50');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '33', '0', 'v', '2017-12-01 20:40:07');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '41', '0', 'v', '2017-12-01 21:47:21');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '24', '0', 'v', '2017-12-01 21:59:50');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '42', '0', 'v', '2017-12-01 22:45:16');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '31', '0', 'v', '2017-12-02 11:13:53');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '25', '0', 'v', '2017-12-02 15:22:28');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '27', '0', 'v', '2017-12-03 10:38:03');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '18', '0', 's', '2017-12-03 12:32:43');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '16', '0', 'v', '2017-12-03 18:50:11');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '20', '0', 'n', '2017-12-03 19:28:43');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '39', '0', 'v', '2017-12-04 10:19:25');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '29', '0', 'v', '2017-12-04 12:52:46');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '22', '0', 'v', '2017-12-04 12:57:26');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '19', '0', 's', '2017-12-04 13:29:17');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '6', '0', 'v', '2017-12-04 16:06:38');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '10', '0', 'v', '2017-12-04 17:00:01');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '4', '0', 'v', '2017-12-04 17:11:18');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '13', '0', 'v', '2017-12-04 18:08:05');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '5', '0', 'v', '2017-12-04 18:56:46');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '28', '0', 'v', '2017-12-04 21:40:46');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '23', '0', 'v', '2017-12-05 04:36:05');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '34', '0', 'v', '2017-12-05 13:06:21');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '12', '0', 'v', '2017-12-06 11:53:36');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '36', '0', 'v', '2017-12-06 21:49:53');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '32', '0', 'v', '2017-12-06 21:57:42');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '8', '0', 'v', '2017-12-06 22:01:59');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '15', '0', 'v', '2017-12-06 23:47:36');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '17', '0', 'v', '2017-12-07 14:21:44');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '40', '0', 'v', '2017-12-07 14:58:00');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '30', '0', 's', '2017-12-08 13:02:56');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '11', '0', 'v', '2017-12-10 05:52:36');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '44', '0', 's', '2017-12-10 20:45:18');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '43', '0', 's', '2017-12-10 20:47:03');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '21', '0', 'v', '2017-12-10 21:54:03');
INSERT INTO `reto_asistencia_copy` VALUES ('2', '14', '0', 'v', '2017-12-14 23:08:53');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '42', '0', 'v', '2018-01-16 21:20:27');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '10', '0', 'v', '2018-01-16 21:58:42');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '47', '0', 'v', '2018-01-16 22:02:23');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '23', '0', 'v', '2018-01-16 22:20:15');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '14', '0', 'v', '2018-01-17 19:53:29');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '9', '0', 'v', '2018-01-17 22:09:07');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '17', '0', 'v', '2018-01-18 21:23:20');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '34', '0', 'v', '2018-01-23 17:32:32');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '28', '0', 'v', '2018-01-23 21:18:06');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '41', '0', 'v', '2018-01-27 08:01:57');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '16', '0', 'v', '2018-01-30 11:31:45');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '13', '0', 'v', '2018-01-30 13:05:22');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '25', '0', 'v', '2018-01-30 16:24:56');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '24', '0', 'v', '2018-01-30 19:36:05');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '15', '0', 'v', '2018-01-30 21:45:21');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '11', '0', 'v', '2018-02-01 22:29:05');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '12', '0', 'v', '2018-02-01 22:29:34');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '5', '0', 'v', '2018-02-01 22:30:31');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '38', '0', 'v', '2018-02-01 23:26:59');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '21', '0', 'v', '2018-02-02 08:54:23');
INSERT INTO `reto_asistencia_copy` VALUES ('3', '6', '0', 'v', '2018-02-04 16:55:11');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '10', '0', 'v', '2018-02-06 21:46:10');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '9', '0', 'v', '2018-02-06 21:55:44');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '20', '0', 'v', '2018-02-06 22:16:40');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '23', '0', 'v', '2018-02-06 22:38:29');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '39', '0', 'v', '2018-02-06 23:14:06');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '13', '0', 'v', '2018-02-07 05:06:52');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '14', '0', 'v', '2018-02-07 09:20:20');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '47', '0', 'v', '2018-02-07 15:09:12');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '38', '0', 'v', '2018-02-07 16:07:35');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '33', '0', 'v', '2018-02-07 21:26:49');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '29', '0', 'v', '2018-02-08 07:46:07');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '25', '0', 'v', '2018-02-08 16:39:35');
INSERT INTO `reto_asistencia_copy` VALUES ('4', '34', '0', 'v', '2018-02-08 18:24:17');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '14', '0', 'v', '2018-03-04 08:28:42');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '10', '0', 'v', '2018-03-04 12:07:39');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '23', '0', 'v', '2018-03-08 11:35:47');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '38', '0', 'v', '2018-03-11 20:40:50');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '13', '0', 'n', '2018-03-11 22:55:50');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '6', '0', 'v', '2018-03-18 16:31:18');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '20', '0', 'v', '2018-03-18 20:25:17');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '18', '0', 's', '2018-03-19 14:57:10');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '21', '0', 'v', '2018-03-20 18:34:58');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '41', '0', 'v', '2018-03-20 19:46:07');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '24', '0', 'v', '2018-03-20 20:56:41');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '27', '0', 'v', '2018-03-20 21:27:30');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '5', '0', 'v', '2018-03-20 23:28:55');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '32', '0', 'v', '2018-03-20 23:29:30');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '11', '0', 'v', '2018-03-21 14:48:16');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '39', '0', 'v', '2018-03-21 21:35:46');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '42', '0', 's', '2018-03-21 21:47:46');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '9', '0', 'v', '2018-03-22 03:08:02');
INSERT INTO `reto_asistencia_copy` VALUES ('5', '34', '0', 'v', '2018-03-22 17:18:29');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '10', '0', 'n', '2018-04-11 23:44:38');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '9', '0', 'v', '2018-04-13 11:08:19');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '42', '0', 's', '2018-04-14 10:31:10');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '48', '0', 'n', '2018-04-14 15:40:39');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '38', '0', 'v', '2018-04-14 19:48:48');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '14', '0', 'v', '2018-04-15 21:10:33');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '32', '0', 'v', '2018-04-17 22:08:00');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '24', '0', 'v', '2018-04-17 22:38:42');
INSERT INTO `reto_asistencia_copy` VALUES ('6', '34', '0', 'n', '2018-04-20 11:19:25');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '10', '0', 's', '2018-05-20 15:38:15');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '9', '0', 's', '2018-05-21 10:20:53');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '27', '0', 'v', '2018-05-21 10:21:36');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '6', '0', 'v', '2018-05-21 14:44:44');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '23', '0', 'v', '2018-05-22 07:41:01');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '11', '0', 'v', '2018-05-22 17:39:11');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '5', '0', 'v', '2018-05-23 06:52:10');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '7', '0', 'v', '2018-05-23 09:26:34');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '48', '0', 'v', '2018-05-24 21:14:09');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '38', '0', 'v', '2018-05-25 09:58:42');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '42', '0', 'v', '2018-06-02 16:11:49');
INSERT INTO `reto_asistencia_copy` VALUES ('7', '14', '0', 'v', '2018-08-13 10:25:28');

-- ----------------------------
-- Table structure for reto_guerreros
-- ----------------------------
DROP TABLE IF EXISTS `reto_guerreros`;
CREATE TABLE `reto_guerreros` (
  `id_estudiante` int(11) NOT NULL AUTO_INCREMENT,
  `ano` int(11) DEFAULT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `apellidos` varchar(50) DEFAULT NULL,
  `alias` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(10) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `staff` tinyint(1) DEFAULT NULL,
  `lider` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  `username` varchar(10) DEFAULT NULL,
  `fecharegistro` datetime DEFAULT NULL,
  `telefono_tutor` varchar(255) DEFAULT NULL,
  `fecha_nac` date DEFAULT NULL,
  `sexo` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`id_estudiante`)
) ENGINE=InnoDB AUTO_INCREMENT=52 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reto_guerreros
-- ----------------------------
INSERT INTO `reto_guerreros` VALUES ('1', '2018', 'Braulio Aarón ', 'Lara Suárez ', '', 'braulio-larasuarez@hotmail.com', 'Braulara00', '5527591377', '0', '0', '1', 'Braulio La', '2018-09-01 23:25:17', '5563518800', '2002-10-30', 'M');
INSERT INTO `reto_guerreros` VALUES ('2', '2018', 'Armando Arath', 'Lara Suárez ', '', 'arath-lara@outlook.es', 'Lasa010815', '5510484805', '0', '0', '1', 'Arathlara1', '2018-09-01 23:26:19', '5563518800', '2001-08-15', 'M');
INSERT INTO `reto_guerreros` VALUES ('3', '2018', 'Jose Antonio ', 'Rubio Gonzalez', '', 'jr717531@gmail.com', 'alexcampos', '5584046396', '0', '0', '1', 'jose@retou', '2018-09-01 23:27:54', '5532667837', '2002-05-17', 'M');
INSERT INTO `reto_guerreros` VALUES ('4', '2018', 'Víctor Leví', 'Reyes Suárez', '', 'lvrs17@gmail.com', 'lvrs2107', '5540243493', '0', '0', '1', 'Leví RS', '2018-09-01 23:34:55', '5572810808', '2000-07-21', 'M');
INSERT INTO `reto_guerreros` VALUES ('6', '2018', 'Ana Bertha ', 'Reyes Guerrero ', '', 'ana_reyesgro@outlook.com', 'jucum715', '4761130131', '0', '0', '1', 'ANII REYES', '2018-09-01 23:57:42', '4761037339', '1998-05-12', 'F');
INSERT INTO `reto_guerreros` VALUES ('7', '2018', 'Gabriela Lizzet', 'Flores Montes', '', 'floressgabs@gmail.com', 'gabrielq', '5563587464', '0', '0', '1', 'LizzFlores', '2018-09-02 00:25:18', '5544228319', '2002-04-01', 'F');
INSERT INTO `reto_guerreros` VALUES ('9', '2018', 'Sarai', 'Guevara Solís', '', 'disney_529@hotmail.com', 'mibebecpqu', '4767380710', '0', '0', '1', 'Sarai G', '2018-09-02 13:06:19', '4761042106', '1998-12-22', 'F');
INSERT INTO `reto_guerreros` VALUES ('10', '2018', 'Victor Allan', 'Jaen Reyes', '', 'allanjaen0@gmail.com', 'boster2002', '5558956910', '0', '0', '1', 'allan211', '2018-09-02 14:23:25', '5576833129', '2002-07-08', 'M');
INSERT INTO `reto_guerreros` VALUES ('11', '2018', 'Daniela Danae', 'Wong López ', '', 'alecadensa@hormail.com', 'jesusesrey', '5514247543', '0', '0', '1', 'Danawong', '2018-09-02 15:49:44', '5514247543', '1998-03-09', 'F');
INSERT INTO `reto_guerreros` VALUES ('12', '2018', 'Jaasiel David ', 'Wong López ', '', 'jaasielwongld29@gmail.com', 'Saetajdld', '5535043805', '0', '0', '1', 'Wongld', '2018-09-02 15:52:19', '5514247543', '2002-11-12', 'M');
INSERT INTO `reto_guerreros` VALUES ('13', '2018', 'Lilian Aline ', 'López Romero', '', 'lilianlr09@hotmail.com', 'moda200013', '5529211568', '0', '0', '1', 'LilianLR', '2018-09-02 16:12:42', '5525407293', '2000-03-13', 'F');
INSERT INTO `reto_guerreros` VALUES ('14', '2018', 'Marijose', 'Sevilla Palafox', '', 'sevillapalafox@gmail.com', 'BAYMARIJOS', '5567565906', '0', '0', '1', 'Marijose24', '2018-09-02 16:43:39', '5586721831', '2003-05-24', 'F');
INSERT INTO `reto_guerreros` VALUES ('16', '2018', 'Luz Alejandra', ' Mendoza Camacho', '', 'alejandramendozac@outlook.com', 'canto123', '5540783508', '0', '0', '1', 'mendozaale', '2018-09-02 17:07:12', '5516469106', '1999-03-31', 'F');
INSERT INTO `reto_guerreros` VALUES ('17', '2018', 'Dulce Maria', ' Mendoza Camacho', '', 'alejandramendozac@outlook.com', 'caramelo12', '5584835382', '0', '0', '1', 'dulce3636', '2018-09-02 17:15:59', '5516469106', '1999-03-31', 'F');
INSERT INTO `reto_guerreros` VALUES ('19', '2018', 'Maciel', 'Salas Romero', '', 'vero.romero.salas@hotmail.com', 'vemasa1810', '5525264159', '0', '0', '1', 'MacielRo', '2018-09-02 17:38:51', '5513061465', '2001-12-31', 'F');
INSERT INTO `reto_guerreros` VALUES ('20', '2018', 'Ana Maricela ', 'Romero Juarez ', '', 'paulina.juarez1608@gmail.com', 'juarez1617', '‭5531176986', '1', '0', '1', 'Maricela', '2018-09-02 19:05:30', '‭554839 6278‬', '2002-06-16', 'F');
INSERT INTO `reto_guerreros` VALUES ('21', '2018', 'Luis Ángel ', 'Mendoza Camacho ', '', 'mendozacamacholuis_20@outlook.com', 'mendozalui', '5512428193', '0', '0', '1', 'Luis Angel', '2018-09-03 08:51:15', '5544940039', '2001-12-20', 'M');
INSERT INTO `reto_guerreros` VALUES ('22', '2018', 'Jazmín ', 'Montaño Padrón ', '', 'paulina.juarez1608@hotmail.com', 'Jazmin123', '5560925372', '0', '0', '1', 'Jazmín ', '2018-09-03 14:40:09', '5548396278', '2003-10-17', 'F');
INSERT INTO `reto_guerreros` VALUES ('23', '2018', 'Joselina', 'Sevilla Palafox', '', 'joselina100@gmail.com', 'Palafox10', '5547735475', '0', '0', '1', 'Joselina__', '2018-09-03 23:40:59', '5586721831', '1998-04-04', 'F');
INSERT INTO `reto_guerreros` VALUES ('24', '2018', 'Fatima', 'Curiel Armenta', '', 'fatigol99@hotmail.com', 'abuetete', '5521081116', '1', '0', '1', 'FatiCuriel', '2018-09-04 12:41:46', '5529431237', '1999-09-03', 'F');
INSERT INTO `reto_guerreros` VALUES ('25', '2018', 'Saúl Josadac', 'Jiménez Sánchez', '', 'ojosadac1@gmail.com', 'popo1234', '5566239617', '0', '0', '1', 'Josadac', '2018-09-04 16:38:01', '5512861780', '2002-06-18', 'M');
INSERT INTO `reto_guerreros` VALUES ('26', '2018', 'Elena Gabriela', 'Bustos Hernández', '', 'brillantetita@hotmail.com', '0422e19g', '5529498802', '0', '0', '1', 'Elena22G', '2018-09-04 16:59:58', '7751557295', '2004-10-22', 'F');
INSERT INTO `reto_guerreros` VALUES ('27', '2018', 'Valeria ', 'Ramirez Arias', '', 'valeramirezarias@gmail.com', 'jopavana37', '7711982299', '0', '0', '1', 'valeriarmz', '2018-09-05 12:22:24', '7717263203', '2003-06-10', 'F');
INSERT INTO `reto_guerreros` VALUES ('28', '2018', 'Valeria Guadalupe', 'Juárez Tabares', '', 'valery-24@hotmail.com', '12345678', '5519384127', '0', '0', '1', 'Valeria JT', '2018-09-07 20:36:38', '5532820626', '2003-06-24', 'F');
INSERT INTO `reto_guerreros` VALUES ('30', '2018', 'Evan ', 'Hernández Perez', '', 'evannet099@gmail.com', 'Evannet02', '7712055128', '0', '0', '1', 'evan02', '2018-09-09 19:15:41', '7742088634', '2004-09-02', 'M');
INSERT INTO `reto_guerreros` VALUES ('31', '2018', 'Asaph', 'Flores Cobos', '', 'asaph1801@gmail.com', 'SONOFGOD', '5565102061', '0', '0', '1', 'Asaph1801', '2018-09-13 19:20:56', '7713841618', '2005-01-18', 'M');
INSERT INTO `reto_guerreros` VALUES ('32', '2018', 'Eliana Edith ', 'Gomez Licea', '', 'programas.mfh@gmail.com', 'c4s4hogar', '4441057175', '0', '0', '1', 'Eliana', '2018-09-14 09:17:48', '4441057175', '2004-12-26', 'F');
INSERT INTO `reto_guerreros` VALUES ('33', '2018', 'Guadalupe', 'Garcia Reza', '', 'programas.mfh@gmail.com', 'c4s4hogar', '4441057175', '0', '0', '1', 'guadalupe', '2018-09-14 09:20:39', '4441057175', '2003-12-11', 'F');
INSERT INTO `reto_guerreros` VALUES ('34', '2018', 'YAZMIN', 'CERON NARVAEZ', '', 'programas.mfh@gmail.com', 'c4s4hogar', '4441057175', '0', '0', '1', 'yazmin', '2018-09-14 09:23:42', '4441057175', '2004-01-07', 'F');
INSERT INTO `reto_guerreros` VALUES ('35', '2018', 'Valentina ', 'Martinez López', '', 'programas.mfh@gmail.com', 'c4s4hogar', '4441057175', '0', '0', '1', 'Valentina', '2018-09-14 09:33:30', '4441057175', '2003-09-15', 'F');
INSERT INTO `reto_guerreros` VALUES ('36', '2018', 'Marlene Ivonne', 'Gamero Rosales', '', 'ivongamero26@gmail.com', '26061995', '5544549188', '1', '0', '1', 'ivone', '2018-09-15 09:14:14', '5531022155', '1995-06-26', 'F');
INSERT INTO `reto_guerreros` VALUES ('37', '2018', 'Chantal Reneé', 'Sosa Mancha', '', 'santalsosa11@gmail.com', 'jesucristo', '5537916995', '0', '0', '1', 'Shanty', '2018-09-16 09:03:46', '5529202161', '2004-04-15', 'F');
INSERT INTO `reto_guerreros` VALUES ('38', '2018', 'Erick Sebastián', 'Sosa Mancha', '', 'avestruzerick@gmail.com', '12345678', '5529202161', '0', '0', '1', 'Sebas Sosa', '2018-09-16 09:30:28', '5529202161', '2002-06-25', 'M');
INSERT INTO `reto_guerreros` VALUES ('39', '2018', 'Carolina Itzel', 'Henandez Guerrero', '', 'carolinaparker317@gmail.com', 'rallitas22', '7712330446', '0', '0', '1', 'Carolina', '2018-09-16 22:57:40', '7711747711', '2005-07-12', 'F');
INSERT INTO `reto_guerreros` VALUES ('40', '2018', 'Diana ', 'Zaragoza Hernandez', '', 'dizahe13@gmail.com', 'pastelito', '7712929390', '0', '0', '1', 'dizahe13', '2018-09-20 19:35:57', '7717746949', '2004-01-08', 'F');
INSERT INTO `reto_guerreros` VALUES ('41', '2018', 'Natalia', 'Ramírez Arias ', '', 'nramireza2004@gmail.com', 'jocavana37', '7712196709', '0', '0', '1', 'natyrmz', '2018-09-20 19:59:26', '7717263203', '2004-09-20', 'F');
INSERT INTO `reto_guerreros` VALUES ('42', '2018', 'Natán', 'Morales', '', 'neitan.morales@gmail.com', 'natancito1', '7712072048', '1', '1', '1', 'neitan', '2018-10-04 04:55:51', '', '1987-10-29', 'M');
INSERT INTO `reto_guerreros` VALUES ('43', '2018', 'Richz', 'Volta', ' ', 'richjucum@gmail.com', 'citlali', '', '1', '1', '1', 'rich', '2018-10-19 00:35:19', ' ', '1987-10-29', 'M');
INSERT INTO `reto_guerreros` VALUES ('44', '2018', 'Ana Elizabeth', 'García Escalon', ' ', 'vane.van.roy@gmail.com', 'miranda201', '5534866548', '0', '0', '1', 'anaeli', '2018-10-19 00:37:40', '5519616364', '2005-08-03', 'F');
INSERT INTO `reto_guerreros` VALUES ('45', '2018', 'Salma Isabel', 'Martínez Calderón', ' ', 'salma.marca@gmail.com', 'Isabel$162', '7713960050', '0', '0', '1', 'McSalmi', '2018-10-20 10:53:39', '7713342721', '2001-12-24', 'F');
INSERT INTO `reto_guerreros` VALUES ('46', '2018', 'Ana Gabriela', 'García Guerrero', ' ', 'ananorge1553@gmail.com', '18021991', '5554946662', '1', '1', '1', 'Foster', '2018-10-20 10:56:06', ' ', null, 'F');
INSERT INTO `reto_guerreros` VALUES ('47', '2018', 'Elías ', 'Johnson', ' ', ' elijahj97.ywampachuca@gmail.com', 'musiC597', ' ', '1', '1', '1', 'eliasjucum', '2018-10-20 11:04:27', ' ', '2018-10-20', 'M');
INSERT INTO `reto_guerreros` VALUES ('48', '2018', 'Diana', 'Mota Fernandez', ' ', 'disnamotafernandez0320@gmail.com', 'motaferna', '7713014449', '0', '0', '1', 'diana', '2018-10-20 11:08:48', ' ', '2002-08-03', 'F');
INSERT INTO `reto_guerreros` VALUES ('49', '2018', 'Pablo', 'Pereira', null, 'neitan.morales@gmail.com', 'pablo123', null, '1', null, '1', 'pablo', '2019-01-17 05:16:14', null, null, 'M');
INSERT INTO `reto_guerreros` VALUES ('50', '2018', 'Citlali ', 'Hernández', 'Citla', 'citla@citla.com', 'ricardo', '7717221473', '1', '1', '1', 'citlali', '2019-02-22 00:00:00', null, '1980-05-13', 'F');
INSERT INTO `reto_guerreros` VALUES ('51', '2018', 'Caro', 'Rosas', 'caro', 'neitan.morales@gmail.com', 'carito', '0', '1', '1', '1', 'caro', '2019-03-21 00:00:00', '0', '2019-04-30', 'F');

-- ----------------------------
-- Table structure for reto_guerreros_copy
-- ----------------------------
DROP TABLE IF EXISTS `reto_guerreros_copy`;
CREATE TABLE `reto_guerreros_copy` (
  `id_estudiante` int(11) NOT NULL AUTO_INCREMENT,
  `ano` int(11) DEFAULT NULL,
  `nombre` varchar(30) DEFAULT NULL,
  `apellidos` varchar(50) DEFAULT NULL,
  `alias` varchar(20) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `password` varchar(10) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `staff` tinyint(1) DEFAULT NULL,
  `lider` int(11) DEFAULT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`id_estudiante`)
) ENGINE=InnoDB AUTO_INCREMENT=49 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reto_guerreros_copy
-- ----------------------------
INSERT INTO `reto_guerreros_copy` VALUES ('4', '2017', 'SENI GUADALUPE CASTILLO', ' ', null, 'seni@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('5', '2017', 'JAZMIN MONTAÑO PADRÓN', ' ', null, 'jazmin@retourbano.org', 'reto5678', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('6', '2017', 'EVAN DANIEL HERNANDEZ PEREZ ', ' ', null, 'evan@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('7', '2017', 'JAEL ABRIL DE LEÓN HERNANDEZ', ' ', null, 'jael@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('8', '2017', 'HUGO EDREY VALADEZ CONCHA ', ' ', null, 'hugo@retourbano.org', 'ugoh777', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('9', '2017', 'ANGEL EDUARDO GRANADOS PEREZ', ' ', null, 'angel@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('10', '2017', 'JOSE ANTONIO RUBIO GONZALEZ', ' ', null, 'jose@retourbano.org', 'alexcampos', null, '1', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('11', '2017', 'ANA MARICELA ROMERO JUAREZ', ' ', null, 'maricela@retourbano.org', 'mari4576', null, '1', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('12', '2017', 'VICTOR ALLAN JAEN REYES', ' ', 'allan211', 'allan.jaen@hotmail.com', 'boster2002', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('13', '2017', 'MACIEL SALAS ROMERO', ' ', null, 'maciel@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('14', '2017', 'ADRIAN BONILLA RUIZ ', ' ', null, 'adrian@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('15', '2017', 'LUIS ANGEL MENDOZA CAMACHO ', ' ', null, 'luis@retourbano.org', 'siulcam3', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('16', '2017', 'MARIA FERNANDA MUÑOZ MORENO ', ' ', null, 'fernanda@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('17', '2017', 'ANDRÉ MOEDANO PONCE', ' ', 'André', 'moedanoandre@gmail.com', 'Mani2010', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('18', '2017', 'DANIELA RERGIS PEREZ GALLARDO ', ' ', null, 'daniela@retourbano.org', 'nani2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('19', '2017', 'MARIAN VALERIA SANCHEZ ', ' ', null, 'marian@retourbano.org', 'marian0987', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('20', '2017', 'PAMELA CEJA MUNZAGA ', ' ', null, 'pamela@retourbano.org', 'pame1234', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('21', '2017', 'FATIMA CURIEL PONCE ARMENDA', ' ', 'Fatima Curiel', 'fatima@retourbano.org', 'abuetete', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('22', '2017', 'JANET MONTAÑO PADRON', ' ', null, 'janet@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('23', '2017', 'ALEJANDRA MENDOZA CAMACHO ', ' ', null, 'ale@retourbano.org', 'ale1324', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('24', '2017', 'DULCE MARIA MENDOZA CAMACHO ', ' ', null, 'dulce@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('25', '2017', 'KEYLA MARTINEZ VIDAL ', ' ', null, 'keyla@retourbano.org', 'keyla555', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('27', '2017', 'CARLOS CAUDILLO BAÑOS', ' ', null, 'carlos@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('28', '2017', 'SAMANTA DIONISIO ROMERO', ' ', null, 'samanta@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('29', '2017', 'SHEILA BONILLA RUIZ ', ' ', null, 'sheila@retourbano.org', 'shei777', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('30', '2017', 'ALEJANDRA ROMERO PEREDA', ' ', null, 'alejandra@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('31', '2017', 'YIREL ROMERO PEREIRA', ' ', null, 'yirel@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('32', '2017', 'JAHAZIEL ROMERO PEREIRA', ' ', null, 'jahaziel@retourbano.org', 'jazz3546', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('33', '2017', 'ANA LAURA PARRA', '', null, 'parra_anita@outlook.com', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('34', '2017', 'YESSICA', ' ', null, 'yessica@retourbano.org', 'reto2314', null, '0', null, '1');
INSERT INTO `reto_guerreros_copy` VALUES ('35', '2017', 'ARNOLD', ' ', null, 'arnold@retourbano.org', 'leader0987', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('36', '2017', 'LINETH', ' ', null, 'lineth@retourbano.org', 'leader0987', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('37', '2017', 'VANE', ' ', null, 'vane@retourbano.org', 'leader0987', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('38', '2017', 'KAREN', ' ', null, 'karen@retourbano.org', 'karen1106', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('39', '2017', 'CARO', ' ', null, 'caro@retourbano.org', 'josua333', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('40', '2017', 'RICH', ' ', null, 'director@ywampachuca.org', 'citlali', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('41', '2017', 'CITLALI', ' ', null, 'citlali@retourbano.org', 'leader0987', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('42', '2017', 'NEITAN', ' ', null, 'neitan.morales@gmail.com', 'natancito1', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('43', '2017', 'EUGENIO', ' ', null, 'eugenio@retourbano.org', 'leader0987', null, '1', '0', '0');
INSERT INTO `reto_guerreros_copy` VALUES ('44', '2017', 'LUCERO', ' ', null, 'lucero@retourbano.org', 'leader0987', null, '1', '0', '0');
INSERT INTO `reto_guerreros_copy` VALUES ('45', '2017', 'CHARLY', ' ', null, 'charly@retourbano.org', 'leader0987', null, '1', '1', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('46', '2017', 'ELIAS', ' ', null, 'elias@retourbano.org', 'leader0987', null, '1', '1', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('47', '2017', 'RUBEN', ' ', null, 'ruben@ruben.com', 'ruben7777', null, '1', '0', '1');
INSERT INTO `reto_guerreros_copy` VALUES ('48', '2017', 'Fernanda', 'Canto', 'fer', 'fernandacanto02@gmail.com', 'fercanto1', null, '0', '0', '1');

-- ----------------------------
-- Table structure for reto_intercambio
-- ----------------------------
DROP TABLE IF EXISTS `reto_intercambio`;
CREATE TABLE `reto_intercambio` (
  `de` int(11) NOT NULL,
  `a` int(11) DEFAULT NULL,
  PRIMARY KEY (`de`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reto_intercambio
-- ----------------------------

-- ----------------------------
-- Table structure for reto_intercambio_copy
-- ----------------------------
DROP TABLE IF EXISTS `reto_intercambio_copy`;
CREATE TABLE `reto_intercambio_copy` (
  `de` int(11) NOT NULL,
  `a` int(11) DEFAULT NULL,
  PRIMARY KEY (`de`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reto_intercambio_copy
-- ----------------------------
INSERT INTO `reto_intercambio_copy` VALUES ('5', '4');
INSERT INTO `reto_intercambio_copy` VALUES ('6', '16');
INSERT INTO `reto_intercambio_copy` VALUES ('7', '22');
INSERT INTO `reto_intercambio_copy` VALUES ('9', '5');
INSERT INTO `reto_intercambio_copy` VALUES ('10', '6');
INSERT INTO `reto_intercambio_copy` VALUES ('12', '21');
INSERT INTO `reto_intercambio_copy` VALUES ('13', '25');
INSERT INTO `reto_intercambio_copy` VALUES ('14', '23');
INSERT INTO `reto_intercambio_copy` VALUES ('15', '39');
INSERT INTO `reto_intercambio_copy` VALUES ('18', '42');
INSERT INTO `reto_intercambio_copy` VALUES ('19', '8');
INSERT INTO `reto_intercambio_copy` VALUES ('20', '18');
INSERT INTO `reto_intercambio_copy` VALUES ('23', '45');
INSERT INTO `reto_intercambio_copy` VALUES ('24', '32');
INSERT INTO `reto_intercambio_copy` VALUES ('25', '30');
INSERT INTO `reto_intercambio_copy` VALUES ('27', '40');
INSERT INTO `reto_intercambio_copy` VALUES ('28', '20');
INSERT INTO `reto_intercambio_copy` VALUES ('29', '7');
INSERT INTO `reto_intercambio_copy` VALUES ('33', '37');
INSERT INTO `reto_intercambio_copy` VALUES ('34', '46');
INSERT INTO `reto_intercambio_copy` VALUES ('38', '17');
INSERT INTO `reto_intercambio_copy` VALUES ('39', '11');
INSERT INTO `reto_intercambio_copy` VALUES ('42', '15');
INSERT INTO `reto_intercambio_copy` VALUES ('47', '41');

-- ----------------------------
-- Table structure for reto_seguimiento
-- ----------------------------
DROP TABLE IF EXISTS `reto_seguimiento`;
CREATE TABLE `reto_seguimiento` (
  `id_seguimiento` int(11) NOT NULL AUTO_INCREMENT,
  `fecha_inicio` date DEFAULT NULL,
  `activo` tinyint(1) DEFAULT NULL,
  `titulo` varchar(255) DEFAULT NULL,
  `texto_fecha` varchar(255) DEFAULT NULL,
  `campamento_id` int(11) DEFAULT NULL,
  PRIMARY KEY (`id_seguimiento`),
  KEY `foreing_campamento` (`campamento_id`),
  CONSTRAINT `foreing_campamento` FOREIGN KEY (`campamento_id`) REFERENCES `campamentos` (`id_campamento`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of reto_seguimiento
-- ----------------------------
INSERT INTO `reto_seguimiento` VALUES ('1', '2021-09-17', '0', 'Septiembre', 'Empezamos', '2021');
INSERT INTO `reto_seguimiento` VALUES ('2', '2021-10-15', '0', 'Octubre', '2do Seguimiento', '2021');
INSERT INTO `reto_seguimiento` VALUES ('3', '2021-11-19', '0', 'Noviembre', '3er Seguimiento', '2021');
INSERT INTO `reto_seguimiento` VALUES ('4', '2022-01-28', '0', 'Enero', '4to Seguimiento', '2021');
INSERT INTO `reto_seguimiento` VALUES ('5', '2022-02-18', '0', 'Febrero', '5to Seguimientoooooo', '2021');
INSERT INTO `reto_seguimiento` VALUES ('6', '2022-09-11', '1', 'EMPEZAMOS', '1er Seguimiento', '2022');

-- ----------------------------
-- Table structure for token
-- ----------------------------
DROP TABLE IF EXISTS `token`;
CREATE TABLE `token` (
  `id_guerrero` int(11) DEFAULT NULL,
  `token` varchar(500) DEFAULT NULL,
  `expires` datetime DEFAULT NULL,
  `created` datetime DEFAULT NULL,
  KEY `guerrero` (`id_guerrero`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ----------------------------
-- Records of token
-- ----------------------------
INSERT INTO `token` VALUES ('301', 'c4fca753bf15c4040095b02cdb6cded2', '2022-07-06 19:22:57', '2022-07-06 19:22:57');

-- ----------------------------
-- View structure for view_asistencias
-- ----------------------------
DROP VIEW IF EXISTS `view_asistencias`;
CREATE VIEW `view_asistencias` AS (select `S`.`id_seguimiento` AS `id_seguimiento`,`S`.`fecha_inicio` AS `fecha_inicio`,`S`.`activo` AS `activo`,`A`.`estudiante_id` AS `estudiante_id`,`A`.`confirmacion` AS `confirmacion`,`A`.`dia_llegada` AS `dia_llegada` from (`RETO_SEGUIMIENTO` `S` left join `RETO_ASISTENCIA` `A` on((`S`.`id_seguimiento` = `A`.`seguimiento_id`)))) ;

-- ----------------------------
-- View structure for vista_asistencias
-- ----------------------------
DROP VIEW IF EXISTS `vista_asistencias`;
CREATE VIEW `vista_asistencias` AS (select `S`.`id_seguimiento` AS `id_seguimiento`,`S`.`fecha_inicio` AS `fecha_inicio`,`S`.`activo` AS `activo`,`A`.`estudiante_id` AS `estudiante_id`,`A`.`confirmacion` AS `confirmacion`,`A`.`dia_llegada` AS `dia_llegada` from (`RETO_SEGUIMIENTO` `S` left join `RETO_ASISTENCIA` `A` on((`S`.`id_seguimiento` = `A`.`seguimiento_id`)))) ;

-- ----------------------------
-- View structure for vista_asistencia_activa
-- ----------------------------
DROP VIEW IF EXISTS `vista_asistencia_activa`;
CREATE VIEW `vista_asistencia_activa` AS (select `S`.`id_seguimiento` AS `id_seguimiento`,`S`.`fecha_inicio` AS `fecha_inicio`,`S`.`activo` AS `activo`,`A`.`estudiante_id` AS `estudiante_id`,`A`.`confirmacion` AS `confirmacion`,`A`.`dia_llegada` AS `dia_llegada` from (`RETO_SEGUIMIENTO` `S` left join `RETO_ASISTENCIA` `A` on((`S`.`id_seguimiento` = `A`.`seguimiento_id`))) where (`S`.`activo` = 1)) ;
