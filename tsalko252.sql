-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Loomise aeg: Veebr 26, 2026 kell 03:56 PL
-- Serveri versioon: 10.4.32-MariaDB
-- PHP versioon: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Andmebaas: `tsalko25`
--

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `category`
--

CREATE TABLE `category` (
  `idCategory` int(11) NOT NULL,
  `Category_Name` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `customer`
--

CREATE TABLE `customer` (
  `idCustomer` int(11) NOT NULL,
  `Name` varchar(50) NOT NULL,
  `contact` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `product`
--

CREATE TABLE `product` (
  `idProduct` int(11) NOT NULL,
  `Name` varchar(100) DEFAULT NULL,
  `idCategory` int(11) DEFAULT NULL,
  `Price` decimal(10,2) NOT NULL CHECK (`Price` > 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Tabeli struktuur tabelile `sale`
--

CREATE TABLE `sale` (
  `idSale` int(11) NOT NULL,
  `idProduct` int(11) DEFAULT NULL,
  `idCustomer` int(11) DEFAULT NULL,
  `Count_pr` int(11) NOT NULL CHECK (`Count_pr` > 0),
  `Date_of_sale` date DEFAULT curdate(),
  `Units` varchar(20) DEFAULT 'pcs'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Indeksid tõmmistatud tabelitele
--

--
-- Indeksid tabelile `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`idCategory`),
  ADD UNIQUE KEY `Category_Name` (`Category_Name`);

--
-- Indeksid tabelile `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`idCustomer`);

--
-- Indeksid tabelile `product`
--
ALTER TABLE `product`
  ADD PRIMARY KEY (`idProduct`),
  ADD KEY `fk_Product_Category` (`idCategory`);

--
-- Indeksid tabelile `sale`
--
ALTER TABLE `sale`
  ADD PRIMARY KEY (`idSale`),
  ADD KEY `fk_Sale_Product` (`idProduct`),
  ADD KEY `fk_Sale_Customer` (`idCustomer`);

--
-- AUTO_INCREMENT tõmmistatud tabelitele
--

--
-- AUTO_INCREMENT tabelile `category`
--
ALTER TABLE `category`
  MODIFY `idCategory` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT tabelile `customer`
--
ALTER TABLE `customer`
  MODIFY `idCustomer` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT tabelile `product`
--
ALTER TABLE `product`
  MODIFY `idProduct` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT tabelile `sale`
--
ALTER TABLE `sale`
  MODIFY `idSale` int(11) NOT NULL AUTO_INCREMENT;

--
-- Tõmmistatud tabelite piirangud
--

--
-- Piirangud tabelile `sale`
--
ALTER TABLE `sale`
  ADD CONSTRAINT `fk_Sale_Customer` FOREIGN KEY (`idCustomer`) REFERENCES `customer` (`idCustomer`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_Sale_Product` FOREIGN KEY (`idProduct`) REFERENCES `product` (`idProduct`) ON DELETE SET NULL ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
