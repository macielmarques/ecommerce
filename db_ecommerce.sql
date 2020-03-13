-- phpMyAdmin SQL Dump
-- version 5.0.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 13, 2020 at 07:28 PM
-- Server version: 10.4.11-MariaDB
-- PHP Version: 7.4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ecommerce`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_categories_save` (`pidcategory` INT, `pdescategory` VARCHAR(64))  BEGIN
	
	IF pidcategory > 0 THEN
		
		UPDATE tb_categories
        SET descategory = pdescategory
        WHERE idcategory = pidcategory;
        
    ELSE
		
		INSERT INTO tb_categories (descategory) VALUES(pdescategory);
        
        SET pidcategory = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_categories WHERE idcategory = pidcategory;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_products_save` (`pidproduct` INT(11), `pdesproduct` VARCHAR(64), `pvlprice` DECIMAL(10,2), `pvlwidth` DECIMAL(10,2), `pvlheight` DECIMAL(10,2), `pvllength` DECIMAL(10,2), `pvlweight` DECIMAL(10,2), `pdesurl` VARCHAR(128))  BEGIN
	
	IF pidproduct > 0 THEN
		
		UPDATE tb_products
        SET 
			desproduct = pdesproduct,
            vlprice = pvlprice,
            vlwidth = pvlwidth,
            vlheight = pvlheight,
            vllength = pvllength,
            vlweight = pvlweight,
            desurl = pdesurl
        WHERE idproduct = pidproduct;
        
    ELSE
		
		INSERT INTO tb_products (desproduct, vlprice, vlwidth, vlheight, vllength, vlweight, desurl) 
        VALUES(pdesproduct, pvlprice, pvlwidth, pvlheight, pvllength, pvlweight, pdesurl);
        
        SET pidproduct = LAST_INSERT_ID();
        
    END IF;
    
    SELECT * FROM tb_products WHERE idproduct = pidproduct;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_userspasswordsrecoveries_create` (`piduser` INT, `pdesip` VARCHAR(45))  BEGIN
	
	INSERT INTO tb_userspasswordsrecoveries (iduser, desip)
    VALUES(piduser, pdesip);
    
    SELECT * FROM tb_userspasswordsrecoveries
    WHERE idrecovery = LAST_INSERT_ID();
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_usersupdate_save` (`piduser` INT, `pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    UPDATE tb_persons
    SET 
		desperson = pdesperson,
        desemail = pdesemail,
        nrphone = pnrphone
	WHERE idperson = vidperson;
    
    UPDATE tb_users
    SET
		deslogin = pdeslogin,
        despassword = pdespassword,
        inadmin = pinadmin
	WHERE iduser = piduser;
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = piduser;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_delete` (`piduser` INT)  BEGIN
	
    DECLARE vidperson INT;
    
	SELECT idperson INTO vidperson
    FROM tb_users
    WHERE iduser = piduser;
    
    DELETE FROM tb_users WHERE iduser = piduser;
    DELETE FROM tb_persons WHERE idperson = vidperson;
    
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_users_save` (`pdesperson` VARCHAR(64), `pdeslogin` VARCHAR(64), `pdespassword` VARCHAR(256), `pdesemail` VARCHAR(128), `pnrphone` BIGINT, `pinadmin` TINYINT)  BEGIN
	
    DECLARE vidperson INT;
    
	INSERT INTO tb_persons (desperson, desemail, nrphone)
    VALUES(pdesperson, pdesemail, pnrphone);
    
    SET vidperson = LAST_INSERT_ID();
    
    INSERT INTO tb_users (idperson, deslogin, despassword, inadmin)
    VALUES(vidperson, pdeslogin, pdespassword, pinadmin);
    
    SELECT * FROM tb_users a INNER JOIN tb_persons b USING(idperson) WHERE a.iduser = LAST_INSERT_ID();
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tb_addresses`
--

CREATE TABLE `tb_addresses` (
  `idaddress` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `desaddress` varchar(128) NOT NULL,
  `descomplement` varchar(32) DEFAULT NULL,
  `descity` varchar(32) NOT NULL,
  `desstate` varchar(32) NOT NULL,
  `descountry` varchar(32) NOT NULL,
  `nrzipcode` int(11) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tb_carts`
--

CREATE TABLE `tb_carts` (
  `idcart` int(11) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `iduser` int(11) DEFAULT NULL,
  `idaddress` int(11) DEFAULT NULL,
  `vlfreight` decimal(10,2) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tb_cartsproducts`
--

CREATE TABLE `tb_cartsproducts` (
  `idcartproduct` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL,
  `dtremoved` datetime NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tb_categories`
--

CREATE TABLE `tb_categories` (
  `idcategory` int(11) NOT NULL,
  `descategory` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_categories`
--

INSERT INTO `tb_categories` (`idcategory`, `descategory`, `dtregister`) VALUES
(3, 'Adroid', '2020-03-09 18:23:10'),
(4, 'Apple', '2020-03-09 18:48:19'),
(5, 'Motorola', '2020-03-09 18:48:30'),
(6, 'Sumsung', '2020-03-09 18:48:42');

-- --------------------------------------------------------

--
-- Table structure for table `tb_orders`
--

CREATE TABLE `tb_orders` (
  `idorder` int(11) NOT NULL,
  `idcart` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `idstatus` int(11) NOT NULL,
  `vltotal` decimal(10,2) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tb_ordersstatus`
--

CREATE TABLE `tb_ordersstatus` (
  `idstatus` int(11) NOT NULL,
  `desstatus` varchar(32) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_ordersstatus`
--

INSERT INTO `tb_ordersstatus` (`idstatus`, `desstatus`, `dtregister`) VALUES
(1, 'Em Aberto', '2017-03-13 03:00:00'),
(2, 'Aguardando Pagamento', '2017-03-13 03:00:00'),
(3, 'Pago', '2017-03-13 03:00:00'),
(4, 'Entregue', '2017-03-13 03:00:00');

-- --------------------------------------------------------

--
-- Table structure for table `tb_persons`
--

CREATE TABLE `tb_persons` (
  `idperson` int(11) NOT NULL,
  `desperson` varchar(64) NOT NULL,
  `desemail` varchar(128) DEFAULT NULL,
  `nrphone` bigint(20) DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_persons`
--

INSERT INTO `tb_persons` (`idperson`, `desperson`, `desemail`, `nrphone`, `dtregister`) VALUES
(1, 'admin', 'admin@hcode.com.br', 2147483647, '2017-03-01 03:00:00'),
(7, 'Suporte', 'suporte@hcode.com.br', 1112345678, '2017-03-15 16:10:27'),
(13, 'Maciel', 'macielmrqs@gmail.com', 83981102034, '2020-02-29 01:07:10'),
(16, 'suporteadmin', 'macielsuporte15@gmail.com', 83981102034, '2020-02-29 15:30:10'),
(17, 'suporte', 'macielsuporte15@gmail.com', 83981102034, '2020-02-29 15:38:02');

-- --------------------------------------------------------

--
-- Table structure for table `tb_products`
--

CREATE TABLE `tb_products` (
  `idproduct` int(11) NOT NULL,
  `desproduct` varchar(64) NOT NULL,
  `vlprice` decimal(10,2) NOT NULL,
  `vlwidth` decimal(10,2) NOT NULL,
  `vlheight` decimal(10,2) NOT NULL,
  `vllength` decimal(10,2) NOT NULL,
  `vlweight` decimal(10,2) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_products`
--

INSERT INTO `tb_products` (`idproduct`, `desproduct`, `vlprice`, `vlwidth`, `vlheight`, `vllength`, `vlweight`, `desurl`, `dtregister`) VALUES
(4, 'Ipad Celular 32GB Wi-Fi Tela 9,7\" Câmera 8MP Cinza Espacial - Ap', '2599.95', '0.75', '16.95', '24.50', '0.47', 'ipad-32gb', '2020-03-12 00:57:10'),
(7, 'Smartphone Motorola Moto G5 Plus', '1135.23', '15.20', '7.40', '0.70', '0.16', 'smartphone-motorola-moto-g5-plus', '2020-03-12 23:38:15'),
(8, 'Smartphone Moto Z Play', '1887.78', '14.10', '0.90', '1.16', '0.13', 'smartphone-moto-z-play', '2020-03-12 23:38:15'),
(9, 'Smartphone Samsung Galaxy J5 Pro', '1299.00', '14.60', '7.10', '0.80', '0.16', 'smartphone-samsung-galaxy-j5', '2020-03-12 23:38:15'),
(10, 'Smartphone Samsung Galaxy J7 Prime', '1149.00', '15.10', '7.50', '0.80', '0.16', 'smartphone-samsung-galaxy-j7', '2020-03-12 23:38:15'),
(11, 'Smartphone Samsung Galaxy J3 Dual', '679.90', '14.20', '7.10', '0.70', '0.14', 'smartphone-samsung-galaxy-j3', '2020-03-12 23:38:15');

-- --------------------------------------------------------

--
-- Table structure for table `tb_productscategories`
--

CREATE TABLE `tb_productscategories` (
  `idcategory` int(11) NOT NULL,
  `idproduct` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_productscategories`
--

INSERT INTO `tb_productscategories` (`idcategory`, `idproduct`) VALUES
(3, 7),
(3, 8),
(3, 9),
(3, 10),
(3, 11),
(5, 7);

-- --------------------------------------------------------

--
-- Table structure for table `tb_users`
--

CREATE TABLE `tb_users` (
  `iduser` int(11) NOT NULL,
  `idperson` int(11) NOT NULL,
  `deslogin` varchar(64) NOT NULL,
  `despassword` varchar(256) NOT NULL,
  `inadmin` tinyint(4) NOT NULL DEFAULT 0,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_users`
--

INSERT INTO `tb_users` (`iduser`, `idperson`, `deslogin`, `despassword`, `inadmin`, `dtregister`) VALUES
(1, 1, 'admin', '$2y$12$YlooCyNvyTji8bPRcrfNfOKnVMmZA9ViM2A3IpFjmrpIbp5ovNmga', 1, '2017-03-13 03:00:00'),
(17, 17, 'suporte', '$2y$12$H03MbRb1vc5YKqJcc4tIruFL.7PRVQbItVBHAa5CvQ/mXu4wifr/i', 1, '2020-02-29 15:38:02');

-- --------------------------------------------------------

--
-- Table structure for table `tb_userslogs`
--

CREATE TABLE `tb_userslogs` (
  `idlog` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `deslog` varchar(128) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `desuseragent` varchar(128) NOT NULL,
  `dessessionid` varchar(64) NOT NULL,
  `desurl` varchar(128) NOT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `tb_userspasswordsrecoveries`
--

CREATE TABLE `tb_userspasswordsrecoveries` (
  `idrecovery` int(11) NOT NULL,
  `iduser` int(11) NOT NULL,
  `desip` varchar(45) NOT NULL,
  `dtrecovery` datetime DEFAULT NULL,
  `dtregister` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `tb_userspasswordsrecoveries`
--

INSERT INTO `tb_userspasswordsrecoveries` (`idrecovery`, `iduser`, `desip`, `dtrecovery`, `dtregister`) VALUES
(1, 7, '127.0.0.1', NULL, '2017-03-15 16:10:59'),
(2, 7, '127.0.0.1', '2017-03-15 13:33:45', '2017-03-15 16:11:18'),
(3, 7, '127.0.0.1', '2017-03-15 13:37:35', '2017-03-15 16:37:12'),
(4, 13, '127.0.0.1', NULL, '2020-02-29 01:08:51'),
(5, 13, '127.0.0.1', NULL, '2020-02-29 01:11:54'),
(6, 13, '127.0.0.1', NULL, '2020-02-29 01:12:01'),
(7, 13, '127.0.0.1', NULL, '2020-02-29 01:23:51'),
(8, 13, '127.0.0.1', NULL, '2020-02-29 01:25:48'),
(9, 13, '127.0.0.1', NULL, '2020-02-29 01:27:07'),
(10, 13, '127.0.0.1', NULL, '2020-02-29 01:27:12'),
(11, 13, '127.0.0.1', NULL, '2020-02-29 13:50:23'),
(12, 13, '127.0.0.1', NULL, '2020-02-29 14:20:43'),
(13, 13, '127.0.0.1', NULL, '2020-02-29 14:20:48'),
(14, 13, '127.0.0.1', NULL, '2020-02-29 14:21:12'),
(15, 13, '127.0.0.1', NULL, '2020-02-29 14:22:15'),
(16, 13, '127.0.0.1', NULL, '2020-02-29 14:23:41'),
(17, 13, '127.0.0.1', NULL, '2020-02-29 14:50:30'),
(18, 13, '127.0.0.1', NULL, '2020-02-29 14:50:54'),
(19, 13, '127.0.0.1', NULL, '2020-02-29 15:05:44'),
(20, 13, '127.0.0.1', NULL, '2020-02-29 15:05:48'),
(21, 17, '127.0.0.1', NULL, '2020-02-29 15:40:03'),
(22, 17, '127.0.0.1', NULL, '2020-02-29 16:14:51'),
(23, 17, '127.0.0.1', NULL, '2020-02-29 16:15:06'),
(24, 17, '127.0.0.1', NULL, '2020-02-29 16:15:17'),
(25, 17, '127.0.0.1', NULL, '2020-02-29 17:53:12'),
(26, 17, '127.0.0.1', NULL, '2020-02-29 18:13:41'),
(27, 17, '127.0.0.1', NULL, '2020-02-29 18:14:06'),
(28, 17, '127.0.0.1', NULL, '2020-02-29 18:14:13'),
(29, 17, '127.0.0.1', NULL, '2020-02-29 18:15:23'),
(30, 17, '127.0.0.1', NULL, '2020-02-29 18:15:36'),
(31, 17, '127.0.0.1', NULL, '2020-02-29 18:17:12'),
(32, 17, '127.0.0.1', NULL, '2020-02-29 18:17:51'),
(33, 17, '127.0.0.1', NULL, '2020-02-29 18:21:24'),
(34, 17, '127.0.0.1', NULL, '2020-02-29 18:21:28'),
(35, 17, '127.0.0.1', NULL, '2020-02-29 18:21:37'),
(36, 17, '127.0.0.1', NULL, '2020-02-29 18:28:10'),
(37, 17, '127.0.0.1', NULL, '2020-02-29 18:38:24'),
(38, 17, '127.0.0.1', NULL, '2020-02-29 18:38:45'),
(39, 17, '127.0.0.1', NULL, '2020-03-01 02:19:48'),
(40, 17, '127.0.0.1', NULL, '2020-03-01 02:19:57'),
(41, 17, '127.0.0.1', NULL, '2020-03-01 02:44:29'),
(42, 17, '127.0.0.1', NULL, '2020-03-01 02:45:29'),
(43, 17, '127.0.0.1', NULL, '2020-03-01 02:45:34'),
(44, 17, '127.0.0.1', NULL, '2020-03-01 02:46:29'),
(45, 17, '127.0.0.1', NULL, '2020-03-01 02:48:27'),
(46, 17, '127.0.0.1', NULL, '2020-03-01 02:49:13'),
(47, 17, '127.0.0.1', NULL, '2020-03-01 02:49:24'),
(48, 17, '127.0.0.1', NULL, '2020-03-01 02:51:25'),
(49, 17, '127.0.0.1', NULL, '2020-03-01 02:51:51'),
(50, 17, '127.0.0.1', NULL, '2020-03-01 02:52:03'),
(51, 17, '127.0.0.1', NULL, '2020-03-01 02:53:27'),
(52, 17, '127.0.0.1', NULL, '2020-03-01 02:59:11'),
(53, 17, '127.0.0.1', NULL, '2020-03-01 02:59:16'),
(54, 17, '127.0.0.1', NULL, '2020-03-01 03:15:18'),
(55, 17, '127.0.0.1', NULL, '2020-03-01 03:15:24'),
(56, 17, '127.0.0.1', NULL, '2020-03-01 03:25:47'),
(57, 17, '127.0.0.1', NULL, '2020-03-01 03:25:51'),
(58, 17, '127.0.0.1', NULL, '2020-03-01 03:38:16'),
(59, 17, '127.0.0.1', NULL, '2020-03-01 03:38:20'),
(60, 17, '127.0.0.1', NULL, '2020-03-01 03:38:24'),
(61, 17, '127.0.0.1', NULL, '2020-03-01 03:39:55'),
(62, 17, '127.0.0.1', NULL, '2020-03-01 03:53:44'),
(63, 17, '127.0.0.1', NULL, '2020-03-01 04:01:57'),
(64, 17, '127.0.0.1', NULL, '2020-03-01 04:04:18'),
(65, 17, '127.0.0.1', NULL, '2020-03-01 04:04:21'),
(66, 17, '127.0.0.1', NULL, '2020-03-01 04:04:38'),
(67, 17, '127.0.0.1', NULL, '2020-03-01 04:06:47'),
(68, 17, '127.0.0.1', NULL, '2020-03-01 04:07:26'),
(69, 17, '127.0.0.1', NULL, '2020-03-01 04:07:44'),
(70, 17, '127.0.0.1', NULL, '2020-03-01 04:43:34'),
(71, 17, '127.0.0.1', NULL, '2020-03-01 04:45:41'),
(72, 17, '127.0.0.1', NULL, '2020-03-01 04:47:28'),
(73, 17, '127.0.0.1', NULL, '2020-03-01 04:47:40'),
(74, 17, '127.0.0.1', NULL, '2020-03-01 04:48:24'),
(75, 17, '127.0.0.1', NULL, '2020-03-01 04:49:09'),
(76, 17, '127.0.0.1', NULL, '2020-03-01 04:50:18'),
(77, 17, '127.0.0.1', NULL, '2020-03-01 04:50:22'),
(78, 17, '127.0.0.1', NULL, '2020-03-01 04:53:18'),
(79, 17, '127.0.0.1', NULL, '2020-03-01 04:53:27'),
(80, 17, '127.0.0.1', NULL, '2020-03-01 04:55:32'),
(81, 17, '127.0.0.1', NULL, '2020-03-01 19:13:46'),
(82, 17, '127.0.0.1', NULL, '2020-03-01 19:26:34'),
(83, 17, '127.0.0.1', NULL, '2020-03-01 19:26:43'),
(84, 17, '127.0.0.1', NULL, '2020-03-01 19:34:36'),
(85, 17, '127.0.0.1', NULL, '2020-03-01 19:59:46'),
(86, 17, '127.0.0.1', NULL, '2020-03-01 20:06:47'),
(87, 17, '127.0.0.1', NULL, '2020-03-02 00:11:36'),
(88, 17, '127.0.0.1', NULL, '2020-03-02 00:14:50'),
(89, 17, '127.0.0.1', NULL, '2020-03-02 00:15:09'),
(90, 17, '127.0.0.1', NULL, '2020-03-02 00:17:12'),
(91, 17, '127.0.0.1', NULL, '2020-03-02 00:19:36'),
(92, 17, '127.0.0.1', NULL, '2020-03-02 00:19:43'),
(93, 17, '127.0.0.1', NULL, '2020-03-02 00:21:17'),
(94, 17, '127.0.0.1', NULL, '2020-03-02 00:21:22'),
(95, 17, '127.0.0.1', NULL, '2020-03-02 00:23:55'),
(96, 17, '127.0.0.1', NULL, '2020-03-02 00:24:42'),
(97, 17, '127.0.0.1', NULL, '2020-03-02 00:31:40'),
(98, 17, '127.0.0.1', NULL, '2020-03-02 00:34:35'),
(99, 17, '127.0.0.1', NULL, '2020-03-02 00:38:42'),
(100, 17, '127.0.0.1', NULL, '2020-03-02 00:39:14'),
(101, 17, '127.0.0.1', NULL, '2020-03-02 00:48:58'),
(102, 17, '127.0.0.1', NULL, '2020-03-02 00:52:32'),
(103, 17, '127.0.0.1', NULL, '2020-03-02 00:52:36'),
(104, 17, '127.0.0.1', NULL, '2020-03-02 00:54:05'),
(105, 17, '127.0.0.1', NULL, '2020-03-02 00:57:41'),
(106, 17, '127.0.0.1', NULL, '2020-03-02 00:57:56'),
(107, 17, '127.0.0.1', NULL, '2020-03-02 00:58:11'),
(108, 17, '127.0.0.1', NULL, '2020-03-02 00:59:01'),
(109, 17, '127.0.0.1', NULL, '2020-03-02 00:59:28'),
(110, 17, '127.0.0.1', NULL, '2020-03-02 01:00:51'),
(111, 17, '127.0.0.1', NULL, '2020-03-02 01:01:42'),
(112, 17, '127.0.0.1', NULL, '2020-03-02 01:01:47'),
(113, 17, '127.0.0.1', NULL, '2020-03-02 01:02:32'),
(114, 17, '127.0.0.1', NULL, '2020-03-02 01:02:43'),
(115, 17, '127.0.0.1', NULL, '2020-03-02 01:32:40'),
(116, 17, '127.0.0.1', NULL, '2020-03-02 01:36:06'),
(117, 17, '127.0.0.1', NULL, '2020-03-02 01:37:48'),
(118, 17, '127.0.0.1', NULL, '2020-03-02 01:38:55'),
(119, 17, '127.0.0.1', NULL, '2020-03-02 01:39:15'),
(120, 17, '127.0.0.1', NULL, '2020-03-02 01:40:07'),
(121, 17, '127.0.0.1', NULL, '2020-03-02 01:45:24'),
(122, 17, '127.0.0.1', NULL, '2020-03-02 01:45:29'),
(123, 17, '127.0.0.1', NULL, '2020-03-02 01:45:57'),
(124, 17, '127.0.0.1', NULL, '2020-03-02 01:46:20'),
(125, 17, '127.0.0.1', NULL, '2020-03-02 01:47:22'),
(126, 17, '127.0.0.1', NULL, '2020-03-02 01:47:49'),
(127, 17, '127.0.0.1', NULL, '2020-03-02 01:48:40'),
(128, 17, '127.0.0.1', NULL, '2020-03-02 01:49:13'),
(129, 17, '127.0.0.1', NULL, '2020-03-02 01:49:30'),
(130, 17, '127.0.0.1', NULL, '2020-03-02 01:50:52'),
(131, 17, '127.0.0.1', NULL, '2020-03-02 01:51:51'),
(132, 17, '127.0.0.1', NULL, '2020-03-02 01:52:21'),
(133, 17, '127.0.0.1', NULL, '2020-03-02 01:54:01'),
(134, 17, '127.0.0.1', NULL, '2020-03-02 01:54:51'),
(135, 17, '127.0.0.1', NULL, '2020-03-02 01:55:30'),
(136, 17, '127.0.0.1', NULL, '2020-03-02 01:59:49'),
(137, 17, '127.0.0.1', NULL, '2020-03-02 02:01:02'),
(138, 17, '127.0.0.1', NULL, '2020-03-02 02:01:08'),
(139, 17, '127.0.0.1', NULL, '2020-03-02 02:03:05'),
(140, 17, '127.0.0.1', NULL, '2020-03-02 02:05:16'),
(141, 17, '127.0.0.1', NULL, '2020-03-02 02:06:18'),
(142, 17, '127.0.0.1', NULL, '2020-03-02 02:08:17'),
(143, 17, '127.0.0.1', NULL, '2020-03-02 02:08:31'),
(144, 17, '127.0.0.1', NULL, '2020-03-02 02:10:48'),
(145, 17, '127.0.0.1', NULL, '2020-03-02 02:11:11'),
(146, 17, '127.0.0.1', NULL, '2020-03-08 06:23:46'),
(147, 17, '127.0.0.1', NULL, '2020-03-08 06:28:08'),
(148, 17, '127.0.0.1', NULL, '2020-03-08 06:32:05'),
(149, 17, '127.0.0.1', NULL, '2020-03-08 06:35:10'),
(150, 17, '127.0.0.1', NULL, '2020-03-08 06:41:25'),
(151, 17, '127.0.0.1', NULL, '2020-03-08 06:41:42'),
(152, 17, '127.0.0.1', NULL, '2020-03-08 21:04:21'),
(153, 17, '127.0.0.1', NULL, '2020-03-08 21:17:10'),
(154, 17, '127.0.0.1', NULL, '2020-03-08 21:18:29'),
(155, 17, '127.0.0.1', NULL, '2020-03-08 21:18:34'),
(156, 17, '127.0.0.1', NULL, '2020-03-09 15:42:18'),
(157, 17, '127.0.0.1', NULL, '2020-03-09 15:43:29'),
(158, 17, '127.0.0.1', NULL, '2020-03-09 15:46:19'),
(159, 17, '127.0.0.1', NULL, '2020-03-09 15:47:01'),
(160, 17, '127.0.0.1', NULL, '2020-03-09 15:47:21'),
(161, 17, '127.0.0.1', NULL, '2020-03-09 15:47:52'),
(162, 17, '127.0.0.1', NULL, '2020-03-09 15:48:11'),
(163, 17, '127.0.0.1', NULL, '2020-03-09 15:49:17'),
(164, 17, '127.0.0.1', NULL, '2020-03-09 15:49:42'),
(165, 17, '127.0.0.1', NULL, '2020-03-09 16:11:44'),
(166, 17, '127.0.0.1', NULL, '2020-03-09 16:12:20'),
(167, 17, '127.0.0.1', NULL, '2020-03-09 16:16:17'),
(168, 17, '127.0.0.1', NULL, '2020-03-09 16:16:26'),
(169, 17, '127.0.0.1', NULL, '2020-03-09 16:17:19'),
(170, 17, '127.0.0.1', NULL, '2020-03-09 16:17:33'),
(171, 17, '127.0.0.1', NULL, '2020-03-09 16:19:04'),
(172, 17, '127.0.0.1', NULL, '2020-03-09 16:19:43'),
(173, 17, '127.0.0.1', NULL, '2020-03-09 19:19:41'),
(174, 17, '127.0.0.1', NULL, '2020-03-11 01:32:23'),
(175, 17, '127.0.0.1', NULL, '2020-03-11 01:33:52'),
(176, 17, '127.0.0.1', NULL, '2020-03-11 01:34:01'),
(177, 17, '127.0.0.1', NULL, '2020-03-11 01:34:20'),
(178, 17, '127.0.0.1', NULL, '2020-03-11 01:35:16'),
(179, 17, '127.0.0.1', NULL, '2020-03-11 01:36:02'),
(180, 17, '127.0.0.1', NULL, '2020-03-11 01:36:16'),
(181, 17, '127.0.0.1', NULL, '2020-03-12 17:03:15'),
(182, 17, '127.0.0.1', NULL, '2020-03-12 17:06:39'),
(183, 17, '127.0.0.1', NULL, '2020-03-12 17:10:19'),
(184, 17, '127.0.0.1', NULL, '2020-03-12 17:13:41'),
(185, 17, '127.0.0.1', NULL, '2020-03-12 17:17:10'),
(186, 17, '127.0.0.1', NULL, '2020-03-12 17:23:47');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD PRIMARY KEY (`idaddress`),
  ADD KEY `fk_addresses_persons_idx` (`idperson`);

--
-- Indexes for table `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD PRIMARY KEY (`idcart`),
  ADD KEY `FK_carts_users_idx` (`iduser`),
  ADD KEY `fk_carts_addresses_idx` (`idaddress`);

--
-- Indexes for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD PRIMARY KEY (`idcartproduct`),
  ADD KEY `FK_cartsproducts_carts_idx` (`idcart`),
  ADD KEY `FK_cartsproducts_products_idx` (`idproduct`);

--
-- Indexes for table `tb_categories`
--
ALTER TABLE `tb_categories`
  ADD PRIMARY KEY (`idcategory`);

--
-- Indexes for table `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD PRIMARY KEY (`idorder`),
  ADD KEY `FK_orders_carts_idx` (`idcart`),
  ADD KEY `FK_orders_users_idx` (`iduser`),
  ADD KEY `fk_orders_ordersstatus_idx` (`idstatus`);

--
-- Indexes for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  ADD PRIMARY KEY (`idstatus`);

--
-- Indexes for table `tb_persons`
--
ALTER TABLE `tb_persons`
  ADD PRIMARY KEY (`idperson`);

--
-- Indexes for table `tb_products`
--
ALTER TABLE `tb_products`
  ADD PRIMARY KEY (`idproduct`);

--
-- Indexes for table `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD PRIMARY KEY (`idcategory`,`idproduct`),
  ADD KEY `fk_productscategories_products_idx` (`idproduct`);

--
-- Indexes for table `tb_users`
--
ALTER TABLE `tb_users`
  ADD PRIMARY KEY (`iduser`),
  ADD KEY `FK_users_persons_idx` (`idperson`);

--
-- Indexes for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD PRIMARY KEY (`idlog`),
  ADD KEY `fk_userslogs_users_idx` (`iduser`);

--
-- Indexes for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  ADD PRIMARY KEY (`idrecovery`),
  ADD KEY `fk_userspasswordsrecoveries_users_idx` (`iduser`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  MODIFY `idaddress` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  MODIFY `idcartproduct` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_categories`
--
ALTER TABLE `tb_categories`
  MODIFY `idcategory` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tb_orders`
--
ALTER TABLE `tb_orders`
  MODIFY `idorder` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_ordersstatus`
--
ALTER TABLE `tb_ordersstatus`
  MODIFY `idstatus` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tb_persons`
--
ALTER TABLE `tb_persons`
  MODIFY `idperson` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tb_products`
--
ALTER TABLE `tb_products`
  MODIFY `idproduct` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `tb_users`
--
ALTER TABLE `tb_users`
  MODIFY `iduser` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  MODIFY `idlog` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `tb_userspasswordsrecoveries`
--
ALTER TABLE `tb_userspasswordsrecoveries`
  MODIFY `idrecovery` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=187;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `tb_addresses`
--
ALTER TABLE `tb_addresses`
  ADD CONSTRAINT `fk_addresses_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tb_carts`
--
ALTER TABLE `tb_carts`
  ADD CONSTRAINT `fk_carts_addresses` FOREIGN KEY (`idaddress`) REFERENCES `tb_addresses` (`idaddress`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_carts_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tb_cartsproducts`
--
ALTER TABLE `tb_cartsproducts`
  ADD CONSTRAINT `fk_cartsproducts_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_cartsproducts_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tb_orders`
--
ALTER TABLE `tb_orders`
  ADD CONSTRAINT `fk_orders_carts` FOREIGN KEY (`idcart`) REFERENCES `tb_carts` (`idcart`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_ordersstatus` FOREIGN KEY (`idstatus`) REFERENCES `tb_ordersstatus` (`idstatus`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_orders_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tb_productscategories`
--
ALTER TABLE `tb_productscategories`
  ADD CONSTRAINT `fk_productscategories_categories` FOREIGN KEY (`idcategory`) REFERENCES `tb_categories` (`idcategory`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  ADD CONSTRAINT `fk_productscategories_products` FOREIGN KEY (`idproduct`) REFERENCES `tb_products` (`idproduct`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tb_users`
--
ALTER TABLE `tb_users`
  ADD CONSTRAINT `fk_users_persons` FOREIGN KEY (`idperson`) REFERENCES `tb_persons` (`idperson`) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Constraints for table `tb_userslogs`
--
ALTER TABLE `tb_userslogs`
  ADD CONSTRAINT `fk_userslogs_users` FOREIGN KEY (`iduser`) REFERENCES `tb_users` (`iduser`) ON DELETE NO ACTION ON UPDATE NO ACTION;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
