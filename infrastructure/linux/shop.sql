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
(00000001, 'Masculin', 'Duvar', 'Baptiste', '1976-08-15', '87 avenue Foch', 'Paris', 75116, 'admin', '$2y$10$lb/fZnuj0UX8fiV7cpDkCefTr0Zh2nCLhU12uFur8Z28OcJFmQ9Ve', '0612345678', '2020-10-06', 'non'),
(00000002, 'Féminin', 'Bergère', 'Manon', '1990-04-19', '159 allée des Vandres', 'Rouen', 76100, 'm.bergere@gmail.com', '$2y$10$NAp4hYujvT7muTyGaR7MOOFKZvo3ML7jJV00bSUehX2Od6y75oLMq', '0649849449', '2020-10-06', 'oui'),
(00000003, 'Masculin', 'Clodo', 'Bastien', '2020-10-05', 'ça dépend', 'ça dpend', 0, 'societe.generale@scg.fr', '$2y$10$2Aio8ae7P84l0vVyepP84u5maJ9jqMpc8LQghaH.G/qZXjfASYbHG', '0000000000', '2020-10-07', 'oui'),
(00000004, 'Autre', 'Mike', 'Hunt', '0069-04-20', 'huto live', 'khuntland', 66666, '2stupid2haveanemail@stupid.com', '$2y$10$fJ8frUa79pkHJDoAb1UFqOsrfbRprVn87yyP/l1s.JTT0DtyGyj5W', '6666666666', '2020-10-07', 'oui'),
(00000005, 'Féminin', 'Secure', 'Secure', '1998-04-04', '4949 zadazd 944', 'afafaf4', 49498, 'secure@mail.com', '$2y$10$dL0EEeBtrh7EIPlpkJlxS.FdnwNau/8zHZcQ8H5jHGpD6BWSNdk7e', '0519849984', '2020-10-07', 'non'),
(00000006, 'Masculin', 'Batix', 'Baptiste', '1996-10-08', '549 rue des Châteaux-Rouges', 'Montreuil', 93210, 'batix_pro95@gmail.com', '$2y$10$ZpTgZcR7emHN8zbpOG1xqO2ThzY32nFBfkXEtzswUelzVQHopefx.', '0698798494', '2020-10-08', 'oui'),
(00000007, 'Masculin', 'Gurbatchev', 'Vladimir', '1982-11-15', '159 cyka Blyat', 'Stalingrad', 12984, 'cyka_blyat1943csgo@gopnik.ru', '$2y$10$9kRP/nQTzplbWqHZ6fnEweP0hNDfebIoLnRdmRRf.4.x13NFGvT4W', '0674897979', '2020-10-08', 'oui'),
(00000008, 'Masculin', 'Chang', 'Ben', '1985-03-09', '897 street Greendale', 'Colorado Springs', 77010, 'b.chang@yahoo.com', '$2y$10$g0LUL9kEypVj01egloaJHev9/Y/r784iDcRjdh3GfthOfaIwbn/Bm', '0798494845', '2020-10-09', 'non'),
(00000009, 'Autre', 'Nom', 'Prénom', '2000-12-09', '798 adresse', 'Ville', 49874, 'email@gmail.com', '$2y$10$7SzFjrGOqmiSGX0u9bSlVuTwxk.F.HhUvb2Fazlx4svbpHFstMA8O', '0674987497', '2020-10-09', 'oui'),
(00000010, 'Féminin', 'Girl', 'You go', '1998-04-09', '89 rue des Bastilles', 'Ville', 74979, 'yougogirl@gmail.com', '$2y$10$pTk1EMD62D8X8aRYJU1uburoKxksAKJtlVWojDoMzO/fMQDPEES8e', '0798441498', '2020-10-09', 'non');

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
(1, 'admin', '$2y$10$lb/fZnuj0UX8fiV7cpDkCefTr0Zh2nCLhU12uFur8Z28OcJFmQ9Ve'),
(2, 'b.duvar@gmail.com', '$2y$10$R.yMGuJTXhCLXZud.Q7PBOD2nP6wPI6iObEIgeRNP9nru7KTZsdG6');

-- Starting the autoincrement at 11
ALTER TABLE `compte`
  MODIFY `id_client` mediumint(8) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

-- Starting the autoincrement at 11
ALTER TABLE `user`
  MODIFY `id` int(4) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;