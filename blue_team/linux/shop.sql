-- replacing the shop database to start from scratch
DROP DATABASE IF EXISTS shop;
CREATE DATABASE shop;

-- selecting the shop database created
USE shop;

--
-- Table structure for table `compte`
--
CREATE TABLE `compte` (
  `id_client` mediumint(8) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `sexe` enum('Masculin','Féminin','Autre') NOT NULL,
  `nom` varchar(50) NOT NULL,
  `prenom` varchar(50) NOT NULL,
  `age` date DEFAULT NULL COMMENT 'Indique aussi l''âge',
  `adresse` varchar(100) NOT NULL,
  `ville` varchar(50) NOT NULL,
  `code_postal` mediumint(5) NOT NULL,
  `email` varchar(255) NOT NULL COMMENT 'Utilisé comme identifiant.',
  `mot_de_passe` varchar(255) NOT NULL COMMENT 'à chiffrer',
  `numero_telephone` varchar(10) NOT NULL COMMENT 'Mobile',
  `date_creation` date NOT NULL DEFAULT current_timestamp() COMMENT 'Date de la création du compte.',
  `newsletter` enum('oui','non') NOT NULL COMMENT 'Accepte de s''inscrire à la newsletter'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Informations des clients lors de l''ouverture d''un compte sur le site internet.' ROW_FORMAT=COMPACT;

--
-- Dumping data for table `compte`
--

INSERT INTO `compte` (`id_client`, `sexe`, `nom`, `prenom`, `age`, `adresse`, `ville`, `code_postal`, `email`, `mot_de_passe`, `numero_telephone`, `date_creation`, `newsletter`) VALUES
(00000001, 'Masculin', 'Duvar', 'Baptiste', '1976-08-15', '87 avenue Foch', 'Paris', 75116, 'b.duvar@gmail.com', '$2y$10$I40pYtf8TXdqXoOtP.90OOwXsKXV/36mFYoT1cvJl3ePg/IgwKFY.', '0612345678', '2020-10-06', 'non'),
(00000002, 'Féminin', 'Bergère', 'Manon', '1990-04-19', '159 allée des Vandres', 'Rouen', 76100, 'm.bergere@gmail.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6', '0649849449', '2020-10-06', 'oui'),
(00000003, 'Masculin', 'Clodo', 'Bastien', '2020-10-05', 'ça dépend', 'ça dpend', 0, 'societe.generale@scg.fr', '$2y$10$1i3KSVZD/Hby5L3be9Eh0.ijBuEBk9igZB5AlZ0/CaC8F8nnGcoGa', '0000000000', '2020-10-07', 'oui'),
(00000004, 'Autre', 'Mike', 'Hunt', '0069-04-20', 'huto live', 'khuntland', 66666, '2stupid2haveanemail@stupid.com', '$2y$10$UyhtMH4w43jo0Qom/kxaP.ZdN9FWm5lM2LWkDhU5QsF/Ev7J1C2Bi', '6666666666', '2020-10-07', 'oui'),
(00000005, 'Féminin', 'Secure', 'Secure', '1998-04-04', '4949 zadazd 944', 'afafaf4', 49498, 'secure@mail.com', '$2y$10$1DE0x2xxbYwsrk/7zUE4iOmF90LtFucZ.7pzwmVrVLZYB0qRNdeaO', '0519849984', '2020-10-07', 'non'),
(00000006, 'Masculin', 'Batix', 'Baptiste', '1996-10-08', '549 rue des Châteaux-Rouges', 'Montreuil', 93210, 'batix_pro95@gmail.com', '$2y$10$RAkfRViLCSvWYfhSjj/YQO4k3AyuVKgdAfb1Hs90on9dmnUDPFK8u', '0698798494', '2020-10-08', 'oui'),
(00000007, 'Masculin', 'Gurbatchev', 'Vladimir', '1982-11-15', '159 cyka Blyat', 'Stalingrad', 12984, 'cyka_blyat1943csgo@gopnik.ru', '$2y$10$QRWq.QI6ddQbB15OK.6r2evKCfqPIL5vTRyMtFYaYXkzbGml4YShS', '0674897979', '2020-10-08', 'oui'),
(00000008, 'Masculin', 'Chang', 'Ben', '1985-03-09', '897 street Greendale', 'Colorado Springs', 77010, 'b.chang@yahoo.com', '$2y$10$fkgrWNWGIoEDb3RsR81Ig.CnGlfeDYdNhUnZCuZD3YLYAm.Vdcunq', '0798494845', '2020-10-09', 'non'),
(00000009, 'Autre', 'Nom', 'Prénom', '2000-12-09', '798 adresse', 'Ville', 49874, 'email@gmail.com', '$2y$10$v5pCudLeD2JiZt.SRttIAuQJrzP7XsSWBzsoQGY6SZtKcdOvla.4K', '0674987497', '2020-10-09', 'oui'),
(00000010, 'Féminin', 'Girl', 'You go', '1998-04-09', '89 rue des Bastilles', 'Ville', 74979, 'yougogirl@gmail.com', '$2y$10$OBv.igyyUfdm/SkvuAEtA.ZP16NJ7SNfaF8QOWFQ8z2P/5E.ASF7i', '0798441498', '2020-10-09', 'non');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `id` int(4) NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Creating users to be able to log in to the webpage
--
INSERT INTO `user` (`id`, `email`, `password`) VALUES
(1, 'b.duvar@gmail.com', '$2y$10$I40pYtf8TXdqXoOtP.90OOwXsKXV/36mFYoT1cvJl3ePg/IgwKFY.'),
(2, 'm.bergere@gmail.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(3, 'societe.generale@scg.fr', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(4, '2stupid2haveanemail@stupid.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(5, 'secure@mail.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(6, 'batix_pro95@gmail.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(7, 'cyka_blyat1943csgo@gopnik.ru', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(8, 'b.chang@yahoo.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(9, 'email@gmail.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');
(10, 'yougogirl@gmail.com', '$2y$10$WTmt.K9SPx50I57utPPo5.WjAqq3VaABtQgUAKpzNaA6Ks0ndeso6');

-- Starting the autoincrement at 11
ALTER TABLE `compte`
  MODIFY `id_client` mediumint(8) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

-- Starting the autoincrement at 11
ALTER TABLE `user`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;