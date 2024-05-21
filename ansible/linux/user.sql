-- phpMyAdmin SQL Dump
-- version 5.2.1deb3
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: May 21, 2024 at 07:54 PM
-- Server version: 10.11.7-MariaDB-4
-- PHP Version: 8.2.18

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `shop`
--

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE DATABASE IF NOT EXISTS shop;

SLEEP 5;

CREATE TABLE `user` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `first_name` text NOT NULL,
  `phone` text NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(1, 'DURADA', 'Ivica', '0614749658', 'adm0001', 'OhUnePaire4&4');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(2, 'LUKA', 'Jadranka', '0615749679', '000001', 'OhUneDoublePaire5A*');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(3, 'BOZIDAR', 'Bojana', '0715840679', '000002', 'YesUneSuiteA2345%');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(4, 'VASO', 'Slavomir', '0785840079', '000003', 'pffHauteur9-');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(5, 'NIKICA', 'Nadezda', '0785840079', '000004', 'Hauteur7?Jmecouche');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(6, 'ADRIJANA', 'Djuro', '0614749658', '000005', 'OhUnePaire7&7');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(7, 'STEVO', 'Bojan', '0615749679', 'adm0006', 'ThreeOfAKind8&');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(8, 'DARKO', 'Dusana', '0715840679', '000007', 'Four0faKindJJJJ(');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(9, 'RADOJKA', 'Dusanka', '0785840079', '000008', 'Raise200$:PaireDeRoi');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(10, 'DRAZA', 'Veljko', '0785840079', '000009', 'OhUnePaireA#A');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(11, 'JELA', 'Obrad', '0614749658', '000010', 'ImAll-in:AA99');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(12, 'RADE', 'Teodora', '0615749679', '000011', 'StraightFlushJ10987:)');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(13, 'BELLIC', 'Niko', '0715840679', '000012', 'RoyalFlushCousinAKQJ10(%');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(14, 'MAJA', 'Teodora', '0785840079', '000013', '333JJFullHouse(Paslasérie)');
INSERT INTO `user` (`id`, `name`, `first_name`, `phone`, `username`, `password`) VALUES
(15, 'NEVENKA', 'Gavrilo', '0785840079', '000014', 'OhUneDoublePaireA&K');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
