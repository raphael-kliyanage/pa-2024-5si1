#!/bin/bash
### please modify the following parameters before launching
### the script

# database's info to connect to wordpress
ip_dbms="10.0.2.1"

# updating system packages
apt update && apt dist-upgrade -y

# removing package installed by the attacker
apt purge netcat-* -y && apt autopurge -y

# removing sudo access to vim to enable privilege escalation via 'sudo vim -c ':!/bin/bash''
sed -i '/www-data ALL=(ALL) NOPASSWD: \/usr\/bin\/vim/d' /etc/sudoers

# inserting the database's password to avoid storing password in plain text
# on the source code for security reasons
read -p "Insert the database's password:   " db_passwd

### removing the old vulnerable webpage
rm /var/www/wordpress/login.php
rm /var/www/wordpress/error.php
rm /var/www/wordpress/index.php
rm /var/www/wordpress/about-me.php
rm /var/www/wordpress/parameters.php
rm /var/www/wordpress/sign-up.php

# removing persistance
crontab -u root -r

### Configuring OpenSSH server to only accept identity file authenticaiton
# Allowing identify file authentication for ssh by removing the comment
sed -i "s/#PubkeyAuthentication yes/PubkeyAuthentication yes/g" /etc/ssh/sshd_config

# Forbidding ssh password authentication
sed -i "s/#PasswordAuthentication yes/PasswordAuthentication no/g" /etc/ssh/sshd_config

# Setting the location of authorized_keys for ssh
sed -i "s/#AuthorizedKeysFile/#AuthorizedKeysFile/g" /etc/ssh/sshd_config

# RECOMMENDED by ANSSI (R21)! Forbidding root login
sed -i "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config

# Restarting sshd service
systemctl restart ssh

### updating the custom vulnerable
# login page
cat << EOF | tee -a /var/www/wordpress/login.php
<?php
	session_start();
	# initialisations des variables
	\$erreurs = array();
	
	# connexion à la base de donnée
	\$db = mysqli_connect('$ip_dbms:3306', 'wordpress_user', '$db_passwd', 'shop') or die("Impossible de se connecter à la base de donnée!");
	
	if(isset(\$_POST['connexion'])) {
		# \$email = mysqli_real_escape_string(\$db, \$_POST['id']);
		# \$mot_de_passe = mysqli_real_escape_string(\$db, \$_POST['mdp']);
		\$email = trim(\$_POST['id']);
		\$mot_de_passe = trim(\$_POST['mdp']);
	
		# verification des informations
		if(empty(\$email)) {array_push(\$erreurs, "Veuillez entrer votre adresse électronique!");};
		if(empty(\$mot_de_passe)) {array_push(\$erreurs, "Veuillez entrer votre mot de passe!");};
		
		# this bit of code is an input validation, to identify whether or not the the input looks like an email
		# by adding this, we are protecting the form from SQLi
		\$modele = "#^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,4}\$#";
		if(!preg_match(\$modele, \$email)) {array_push(\$erreurs, "Veuillez renseigner une adresse email valide!");};
		
		if(count(\$erreurs) == 0) {		
			\$requete = "SELECT * FROM compte WHERE email='\$email'";
			\$resultat = mysqli_query(\$db, \$requete);
			\$nb_col = mysqli_num_rows(\$resultat);
			
			if(\$nb_col == 1) {
				# \$hash = mysqli_fetch_array(\$resultat);
				# \$hash = \$hash[0]['mot_de_passe'];
				# \$hash = mysqli_real_escape_string(\$db, \$hash);
				# \$hash = \$resultat->fetch();
				\$resultat = mysqli_fetch_assoc(\$resultat);
				\$hash = \$resultat['mot_de_passe'];
				
				if(password_verify(\$mot_de_passe, \$hash)) {
					# echo "<script type=text/javascript> window.alert('Mot de passe correct!')";
					\$_SESSION = \$resultat;
					\$_SESSION['email'] = \$email;
					\$_SESSION['success'] = "Vous vous êtes connectés à votre compte!";
					header("location: index.php");	
				} else {
					array_push(\$erreurs, "Mot de passe incorrect. Veuillez réessayez!");
					#echo "<script type=text/javascript> window.alert('Mauvais email/mot de passe. Veuillez réessayez!')</script>";
				}
			} else {
				array_push(\$erreurs, "Compte inexistant, veuillez vous inscrire.");
				# echo "<script type=text/javascript> window.alert('Compte inexistant, veuillez vous incrire.')</script>";
			}
		}
	}
?>
<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
		<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
		<title>Connexion | FREE PORTAGE</title>
	</head>
	
	<style>
		* {
			/*background-color: rgba(55, 140, 251, 0.2);*/
			/*vertical-align: middle;*/
    	/*background: linear-gradient(to right, rgba(177, 0, 51, 0.6), rgba(0, 0, 0, 0.6)), url('images/business.jpg');
    	/*background-repeat: no-repeat;
    	background-position: top center;*/
    	/*background-size: cover;*/
    	margin: auto;
    	margin-top: 50px;
   		width: 290px;
   		font-family: 'Montserrat', sans-serif;
		}
		
		#titre {
			text-align: center;
			font-size: 24px;
		}
		/*
		.formulaire {
			margin-left: 10%;
			margin-right: 10%;
		}*/
		
		.msg_erreur {
			width: 320px;
			text-align: center;
			color: red;
			vertical-align: baseline;
			display: table-cell;
		}
		
		.centrer {
			width: 320px;
			display: table-cell;
			background-color: white;
   		text-align: center;
   		vertical-align: baseline;
		}
		
		/*.bouton {
			background: #0a66c2;
			border-radius: 22px;
			border: none;
			color: white;
			padding: 8px;
			width: 150px;
		}*/
		
		.bouton {
			background: #0a66c2;
			border-radius: 22px;
			border: none;
			color: white;
			padding: 8px;
			width: 50%;
			margin: auto;
			margin-left: 0%;
		}
		
		.bouton:hover {
			background: #05407a;
		}
		
	</style>
	
	<body>
		<div class="centrer">
			<?php
			echo "<form action=\"".\$_SERVER['PHP_SELF']."\" method=\"post\" enctype=\"application/x-www-form-urlencoded\">";
			?>
				<fieldset>
					<legend id="titre"><b>CONNEXION</b></legend>
						<div class="msg_erreur">
							<?php
								# affichage des erreurs
								if(count(\$erreurs) > 0) {
									foreach(\$erreurs as \$erreur)
										echo "<b>\$erreur</b>";
								}
							?>
						</div>
						<!--
						<div style="margin-bottom: 30px;">
							<img src="https://pbs.twimg.com/profile_images/1240343317377884164/BBGvWw1i_400x400.png" height="200" width="100" alt="Logo FREE PORTAGE">
						</div>
						-->
						<div style="text-align: center;">
							<!--
							<table class="formulaire">
								<tr><td style="text-align: right;">E-mail :</td><td><input type="text" name="id" maxlength="255" placeholder="b.duvar@gmail.com"></td></tr>
								<tr><td style="text-align: right;">Mot de passe :</td><td><input type="password" name="mdp"></td></tr>
							
								<tr><td><input type="submit" name="connexion" value="Se connecter"></td></tr>
							</table>
							-->
							<input type="text" name="id" maxlength="255" autofocus placeholder="E-mail" required><br><br>
							<input type="password" name="mdp" placeholder="Mot de passe" required>
							<br>
							<br>
							<input type="submit" name="connexion" value="Se connecter" class="bouton">
						</div>
				</fieldset>
			</form>
			<div style="margin-top: 50px;">
			<p style="text-align: center;">
				Vous n'avez pas encore de compte ?<br>
				<a href="sign-up.php">Inscrivez-vous gratuitement.</a>
		</p>
		</div>
		</div>
		
	</body>
</html>
EOF

# custom error page
cat << EOF | tee -a /var/www/wordpress/error.php
<?php
	if(count(\$erreurs) > 0) {
		echo "<div>";
			foreach(\$erreurs as \$erreur)
				echo "<script type=text/javascript>window.alert('Inscription : \$erreur')</script>";
		echo "</div>";
	}
	
		if(count(\$erreurs_login) > 0) {
		echo "<div>";
			foreach(\$erreurs_login as \$erreur)
				echo "<script type=text/javascript>window.alert('Connexion : \$erreur')</script>";
		echo "</div>";
	}
 ?>
EOF

# index - webpage once you're logged in
cat << EOF | tee -a /var/www/wordpress/index.php
<?php
	session_start();

	if(!isset(\$_SESSION['email'])) {
		echo "<script type=text/javascript>
			window.alert(\"Vous devez d'abords vous connecter pour accéder à cette page!\");
			</script>";
		echo "<script type=text/javascript> window.location.replace(\"login.php\") </script>";
		session_destroy();
	}

	if(isset(\$_GET['logout'])) {
		echo "<script type=text/javascript> window.alert('Vous êtes désormais déconnectés de votre compte !') </script>";
		session_destroy();
		unset(\$_SESSION['email']);
		echo "<script type=text/javascript> window.location.replace(\"login.php\") </script>";
	}
?>
<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
		<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
		<title>Mon compte | FREE PORTAGE</title>
		<style>
			* {
				font-family: 'Montserrat', sans-serif;
			}

			header {
				margin: auto;
  			border: 3px solid;
  			padding: 10px;
  			text-align: center;
  			margin-bottom: 15px;
			}

		</style>
	</head>

	<body>
		<header>
			<tr>
				<p>
					<a href="index.php">Accueil</a>
					 |
					<a href="parameters.php">Paramètres</a>
					 |
					<a href="about-me.php">À propos de moi</a>
					 |
					<a href="index.php?logout='1'">Se déconnecter</a>
				</p>
			</tr>
		</header>

		<h1 style="text-align: center;">Mon compte - Page d'accueil</h1>
		<?php if(isset(\$_SESSION['success'])) : ?>
		<div>
				<?php
					echo "<p style=\"text-align: center;\">". \$_SESSION['success']. "</p>";
					unset(\$_SESSION['success']);
				?>
		</div>
		<?php	endif ?>

		<?php if(isset(\$_SESSION['email'])) : ?>
			<br>
			<h3 style="text-align: center;">Bienvenu <strong><?php echo \$_SESSION['prenom']. " ". \$_SESSION['nom']; ?></strong></h3>
		<?php endif ?>
	</body>
</html>
EOF

# about-me (when you're logged in)
cat << EOF | tee -a /var/www/wordpress/about-me.php
<?php
	session_start();

	if(!isset(\$_SESSION['email'])) {
		echo "<script type=text/javascript>
			window.alert(\"Vous devez d'abords vous connecter pour accéder à cette page!\");
			</script>";
		echo "<script type=text/javascript> window.location.replace(\"login.php\") </script>";
		session_destroy();
	}

	if(isset(\$_GET['logout'])) {
		echo "<script type=text/javascript> window.alert('Vous êtes désormais déconnectés de votre compte !') </script>";
		session_destroy();
		unset(\$_SESSION['email']);
		echo "<script type=text/javascript> window.location.replace(\"login.php\") </script>";
	}
?>
<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
		<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
		<title>Mon compte | FREE PORTAGE</title>
		<style>
			* {
				font-family: 'Montserrat', sans-serif;
			}

			header {
				margin: auto;
  			border: 3px solid;
  			padding: 10px;
  			text-align: center;
  			margin-bottom: 15px;
			}

		</style>
	</head>

	<body>
		<header>
			<tr>
				<p>
					<a href="index.php">Accueil</a>
					 |
					<a href="parameters.php">Paramètres</a>
					 |
					<a href="about-me.php">À propos de moi</a>
					 |
					<a href="index.php?logout='1'">Se déconnecter</a>
				</p>
			</tr>
		</header>

		<h1 style="text-align: center;">Mon compte - Page d'accueil</h1>
		<?php if(isset(\$_SESSION['success'])) : ?>
		<div>
				<?php
					echo "<p style=\"text-align: center;\">". \$_SESSION['success']. "</p>";
					unset(\$_SESSION['success']);
				?>
		</div>
		<?php	endif ?>

		<?php if(isset(\$_SESSION['email'])) : ?>
			<br>
			<h3 style="text-align: center;">Bienvenu <strong><?php echo \$_SESSION['prenom']. " ". \$_SESSION['nom']; ?></strong></h3>
		<?php endif ?>
	</body>
</html>
EOF

# index parameters (when you're logged in)
cat << EOF | tee -a /var/www/wordpress/parameters.php
<?php
	session_start();

	# initialisation des variables
	\$erreurs = array();

	# connexion à la base de donnée
	# remplacer les arguments de la fonction mysqli_connect() par ceux de votre serveur
	\$db = mysqli_connect('$ip_dbms:3306', 'wordpress_user', '$db_passwd', 'shop') or die("Impossible de se connecter à la base de donnée!");

	if(!isset(\$_SESSION['email'])) {
		echo "<script type=text/javascript>
			window.alert(\"Vous devez d'abords vous connecter pour accéder à cette page!\");
			</script>";
		echo "<script type=text/javascript> window.location.replace(\"login.php\") </script>";
		session_destroy();
	}

	if(isset(\$_GET['logout'])) {
		echo "<script type=text/javascript> window.alert('Vous êtes désormais déconnectés de votre compte !') </script>";
		session_destroy();
		unset(\$_SESSION['email']);
		echo "<script type=text/javascript> window.location.replace(\"login.php\") </script>";
	}

	if(isset(\$_POST['modifier'])) {
		# inscription d'un utilisateur
		\$sexe = mysqli_real_escape_string(\$db, \$_POST['sexe']);
		\$nom = mysqli_real_escape_string(\$db, \$_POST['nom']);
		\$prenom = mysqli_real_escape_string(\$db, \$_POST['prenom']);
		\$age = mysqli_real_escape_string(\$db, \$_POST['age']);
		\$adresse = mysqli_real_escape_string(\$db, \$_POST['adresse']);
		\$ville = mysqli_real_escape_string(\$db, \$_POST['ville']);
		\$code_postal = mysqli_real_escape_string(\$db, \$_POST['code_postal']);
		\$email = mysqli_real_escape_string(\$db, \$_POST['email']);
		\$nouveau_email = mysqli_real_escape_string(\$db, \$_POST['nouveau_email']);
		\$telephone = mysqli_real_escape_string(\$db, \$_POST['telephone']);
		\$mdp_actuel = mysqli_real_escape_string(\$db, \$_POST['mdp_actuel']);
		\$nouveau_mdp1 = mysqli_real_escape_string(\$db, \$_POST['nouveau_mdp1']);
		\$nouveau_mdp2 = mysqli_real_escape_string(\$db, \$_POST['nouveau_mdp2']);

		# validation du formulaire
		if(empty(\$sexe)) {array_push(\$erreurs, "Veuillez renseigner votre sexe!");};
		if(empty(\$nom)) {array_push(\$erreurs, "Veuillez renseigner votre nom de famille!");};
		if(empty(\$prenom)) {array_push(\$erreurs, "Veuillez renseigner votre prénom!");};
		if(empty(\$age)) {array_push(\$erreurs, "Veuillez renseigner votre date de naissance!");};
		if(empty(\$adresse)) {array_push(\$erreurs, "Veuillez renseigner votre adresse!");};
		if(empty(\$code_postal)) {array_push(\$erreurs, "Veuillez renseigner votre code postal!");};
		if(empty(\$email)) {array_push(\$erreurs, "Veuillez renseigner votre adresse électronique!");};
		if(empty(\$telephone)) {array_push(\$erreurs, "Veuillez renseigner votre numéro de téléphone!");};
		if(empty(\$mdp_actuel)) {array_push(\$erreurs, "Veuillez renseigner votre mot de passe actuel!");};
		if(\$nouveau_mdp1 != \$nouveau_mdp2) {array_push(\$erreurs, "Vos nouveaux mots de passe sont différents!");};

		# validation des nouvelles données
		if(!empty(\$nouveau_email)) {
			\$modele = "#^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,4}\$#";
			if(!preg_match(\$modele, \$nouveau_email))
				array_push(\$erreurs, "Veuillez renseigner une adresse email valide!");
		}

		\$modele = "/(^[A-Z])+([a-z])([^0-9])/";
		if(!preg_match(\$modele, \$nom)) {array_push(\$erreurs, "Veuillez renseigner un nom valide!");};
		if(!preg_match(\$modele, \$prenom)) {array_push(\$erreurs, "Veuillez renseigner un prénom valide!");};
		\$modele = "#^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,4}\$#";
		if(!preg_match(\$modele, \$email)) {array_push(\$erreurs, "Veuillez renseigner une adresse email valide!");};
		\$modele = "/(^[A-Z])+([a-zA-z])([^0-9])/";
		if(!preg_match(\$modele, \$ville)) {array_push(\$erreurs, "Veuillez renseigner le nom d'une ville valide!");};
		\$modele = "/(^[0-9])([^A-Za-z])/";
		if(!preg_match(\$modele, \$code_postal)) {array_push(\$erreurs, "Veuillez renseigner un code postal valide!");};
		\$modele = "/(^07)|(^06)+([0-9])/";
		if(!preg_match(\$modele, \$telephone)) {array_push(\$erreurs, "Veuillez renseigner un numéro de téléphone valide!");};

		# on récupère "id_client" et le "hash" dans la base de donnée
		\$pre_requete = "SELECT * FROM compte WHERE email='\$email'";
		\$pre_requete = mysqli_query(\$db, \$pre_requete);
		\$pre_requete = mysqli_fetch_assoc(\$pre_requete);
		\$hash = \$pre_requete['mot_de_passe'];
		\$id_client = \$pre_requete['id_client'];

		if(!password_verify(\$mdp_actuel, \$hash))
			array_push(\$erreurs, "Mot de passe incorrect, veuillez réessayez !");

		# Enregistrement du compte si aucune erreur n'a été détectée
		if(count(\$erreurs) == 0 && empty(\$nouveau_email) && empty(\$nouveau_mdp1) && empty(\$nouveau_mdp2)) {
			\$requete = "UPDATE compte SET sexe='\$sexe', nom='\$nom', prenom='\$prenom', age='\$age', adresse='\$adresse', ville='\$ville', code_postal=\$code_postal, email='\$email', numero_telephone='\$telephone'	WHERE id_client=\$id_client";
			mysqli_query(\$db, \$requete);
			\$requete = "SELECT * FROM compte WHERE email='\$email'";
			\$resultat = mysqli_query(\$db, \$requete);
			\$resultat = mysqli_fetch_assoc(\$resultat);
			\$_SESSION = \$resultat;
			\$_SESSION['email'] = \$email;
			\$_SESSION['success'] = "Vous êtes désormais inscrit et connecté à votre compte!";
			header("location: index.php");
		} elseif(count(\$erreurs) == 0 && !empty(\$nouveau_email) && !empty(\$nouveau_mdp1) && !empty(\$nouveau_mdp2)) {
			\$email = \$nouveau_email;
			# protection du mot de passe (avec sel) en utilisant l'algorithme "bcrypt"
			\$mot_de_passe = password_hash(\$nouveau_mdp1, PASSWORD_DEFAULT);
			\$requete = "UPDATE compte SET sexe='\$sexe', nom='\$nom', prenom='\$prenom', age='\$age', adresse='\$adresse', ville='\$ville', code_postal=\$code_postal, email='\$email', numero_telephone='\$telephone', email='\$email', mot_de_passe='\$mot_de_passe'	WHERE id_client=\$id_client";
			mysqli_query(\$db, \$requete);
			\$requete = "SELECT * FROM compte WHERE email='\$email'";
			\$resultat = mysqli_query(\$db, \$requete);
			\$resultat = mysqli_fetch_assoc(\$resultat);
			\$_SESSION = \$resultat;
			\$_SESSION['email'] = \$email;
			\$_SESSION['success'] = "Vous êtes désormais inscrit et connecté à votre compte!";
			header("location: index.php");
		}
	}

	if(isset(\$_POST['supprimer'])) {
		\$email = mysqli_real_escape_string(\$db, \$_POST['email']);
		\$mdp_actuel = mysqli_real_escape_string(\$db, \$_POST['mdp_actuel']);
		# on récupère "id_client" et le "hash" dans la base de donnée
		\$pre_requete = "SELECT * FROM compte WHERE email='\$email'";
		\$pre_requete = mysqli_query(\$db, \$pre_requete);
		\$pre_requete = mysqli_fetch_assoc(\$pre_requete);
		\$id_client = \$pre_requete['id_client'];
		\$hash = \$pre_requete['mot_de_passe'];

		# avant de supprimer, on vérifie que le mot de passe est correct
		if(!password_verify(\$mdp_actuel, \$hash))
			array_push(\$erreurs, "Mot de passe incorrect, veuillez réessayez !");

		if(count(\$erreurs) == 0) {
			\$requete = "DELETE FROM compte WHERE id_client='\$id_client'";
			mysqli_query(\$db, \$requete);
			echo "<script type=\"text/javascript\"> window.alert('Votre compte FREE PORTAGE a été supprimé.') </script>";
			session_destroy();
			unset(\$_SESSION['email']);
			echo "<script type=\"text/javascript\"> window.location.replace(\"login.php\") </script>";
		}
	}
?>
<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
		<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
		<title>Paramètres | FREE PORTAGE</title>
		<style>
			* {
				font-family: 'Montserrat', sans-serif;
			}

			header {
				margin: auto;
  			border: 3px solid;
  			padding: 10px;
  			text-align: center;
  			margin-bottom: 15px;
			}

			.formulaire {
				margin: auto;
				vertical-align: baseline;
				display: block;
				width: 280px;
			}

			.bouton {
				background: #0a66c2;
				border-radius: 22px;
				border: none;
				color: white;
				padding: 8px;
				width: 40%;
				margin: auto;
				margin-left: 28%;
			}

			.bouton:hover {
				background: #05407a;
			}
		</style>
	</head>

	<body>
		<header>
			<tr>
				<p>
					<a href="index.php">Accueil</a>
					 |
					<a href="parameters.php">Paramètres</a>
					 |
					<a href="about-me.php">À propos de moi</a>
					 |
					<a href="index.php?logout='1'">Se déconnecter</a>
				</p>
			</tr>
		</header>

		<h1 style="text-align: center;">Mon compte - Paramètres</h1>
		<?php if(isset(\$_SESSION['success'])) : ?>
		<div>
				<?php
					echo "<p style=\"text-align: center;\">". \$_SESSION['success']. "</p>";
					unset(\$_SESSION['success']);
				?>
		</div>
		<?php	endif ?>

		<?php if(isset(\$_SESSION['email'])) : ?>
			<br>
			<h3 style="text-align: center;">Mes informations actuelles</h3>
			<ul>
				<li>Sexe : <?php echo \$_SESSION['sexe']; ?></li>
				<li>Nom : <?php echo \$_SESSION['nom']; ?></li>
				<li>Prénom : <?php echo \$_SESSION['prenom']; ?></li>
				<li>Date de naissance :  <?php echo \$_SESSION['age']; ?></li>
				<li>Adresse : <?php echo \$_SESSION['adresse']; ?></li>
				<li>Ville : <?php echo \$_SESSION['ville']; ?></li>
				<li>Code postal : <?php echo \$_SESSION['code_postal']; ?></li>
				<li>E-mail : <?php echo \$_SESSION['email']; ?></li>
				<li>N° de téléphone : <?php echo \$_SESSION['numero_telephone']; ?></li>
			</ul>
		<?php	endif ?>
			<h3 style="text-align: center;">Modifications</h3>
			<div class="formulaire">
			<?php
			echo "<form action=\"".\$_SERVER['PHP_SELF']."\" method=\"post\" enctype=\"application/x-www-form-urlencoded\">";
			?>
				<label for="sexe" autofocus>Sexe</label><br>
					<?php
						# detection du sexe sélectionnée précédemment
						if(\$_SESSION['sexe'] == 'Autre') {
							echo "<select id=\"sexe\" name=\"sexe\" style=\"width: 280px;\" required>";
								echo "<option value=\"Autre\" selected>Autre</option>";
								echo "<option value=\"Féminin\">Féminin</option>";
								echo "<option value=\"Masculin\">Masculin</option>";
							echo "</select><br><br>";
						} elseif(\$_SESSION['sexe'] == 'Féminin') {
							echo "<select id=\"sexe\" name=\"sexe\" style=\"width: 280px;\" required>";
								echo "<option value=\"Autre\">Autre</option>";
								echo "<option value=\"Féminin\" selected>Féminin</option>";
								echo "<option value=\"Masculin\">Masculin</option>";
							echo "</select><br><br>";
						} else {
							echo "<select id=\"sexe\" name=\"sexe\" style=\"width: 280px;\" required>";
								echo "<option value=\"Autre\">Autre</option>";
								echo "<option value=\"Féminin\">Féminin</option>";
								echo "<option value=\"Masculin\" selected>Masculin</option>";
							echo "</select><br><br>";
						}
					?>
				<input type="text" name="nom" maxlength="50" value="<?php echo \$_SESSION['nom']?>"  style="width: 280px;" required><br>
				<input type="text" name="prenom" maxlength="50" value="<?php echo \$_SESSION['prenom']?>" style="width: 280px;" required><br><br>
				<label for="age">Date de naissance</label><br>
					<input type="date" name="age" value="<?php echo \$_SESSION['age']?>" style="width: 280px;" required><br><br>
				<input type="text" name="adresse" maxlength="100" value="<?php echo \$_SESSION['adresse']?>" style="width: 280px;" required><br>
				<input type="text" name="ville" maxlength="50" value="<?php echo \$_SESSION['ville']?>" style="width: 280px;" required><br>
				<input type="zip" name="code_postal" maxlength="5" value="<?php echo \$_SESSION['code_postal']?>" style="width: 280px;" required><br>
				<input type="email" name="email" maxlength="255" value="<?php echo \$_SESSION['email']?>" style="width: 280px;" required><br>
				<input type="email" name="nouveau_email" maxlength="255" placeholder="Nouveau E-mail" style="width: 280px;"><br>
				<input type="tel" name="telephone" maxlength="10" value="<?php echo \$_SESSION['numero_telephone']?>" style="width: 280px;" required><br>
				<input type="password" name="mdp_actuel" placeholder="Mot de passe" style="width: 280px;" required><br>
				<input type="password" name="nouveau_mdp1" placeholder="Nouveau mot de passe" style="width: 280px;"><br>
				<input type="password" name="nouveau_mdp2" placeholder="Confirmer nouveau mot de passe" style="width: 280px;"><br>
				<br>
				<input class="bouton" type="submit" name="modifier" value="Modifier"><br><br>
				<input class="bouton" type="submit" name="supprimer" value="Supprimer"><br><br>
			</form>
			<div class="msg_erreur">
				<?php
					# affichage des erreurs
					if(count(\$erreurs) > 0) {
						foreach(\$erreurs as \$erreur)
							echo "<p><b>\$erreur</b></p>";
					}
				?>
			</div>
		</div>
	</body>
</html>
EOF

# sign up webpage to create an account
cat << EOF | tee -a /var/www/wordpress/sign-up.php
<?php
	session_start();
	# initialisation des variables
	\$erreurs = array();

	# connexion à la base de donnée
	# remplacer les arguments de la fonction mysqli_connect() par ceux de votre serveur
	\$db = mysqli_connect('$ip_dbms:3306', 'wordpress_user', '$db_passwd', 'shop') or die("Impossible de se connecter à la base de donnée!");

	if(isset(\$_POST['inscription'])) {
		# inscription d'un utilisateur
		\$sexe = mysqli_real_escape_string(\$db, \$_POST['sexe']);
		\$nom = mysqli_real_escape_string(\$db, \$_POST['nom']);
		\$prenom = mysqli_real_escape_string(\$db, \$_POST['prenom']);
		\$age = mysqli_real_escape_string(\$db, \$_POST['age']);
		\$adresse = mysqli_real_escape_string(\$db, \$_POST['adresse']);
		\$ville = mysqli_real_escape_string(\$db, \$_POST['ville']);
		\$code_postal = mysqli_real_escape_string(\$db, \$_POST['code_postal']);
		\$email = mysqli_real_escape_string(\$db, \$_POST['email']);
		\$telephone = mysqli_real_escape_string(\$db, \$_POST['telephone']);
		\$mot_de_passe_1 = mysqli_real_escape_string(\$db, \$_POST['mot_de_passe_1']);
		\$mot_de_passe_2 = mysqli_real_escape_string(\$db, \$_POST['mot_de_passe_2']);
		\$newsletter = mysqli_real_escape_string(\$db, \$_POST['newsletter']);

		# validation du formulaire
		if(empty(\$sexe)) {array_push(\$erreurs, "Veuillez renseigner votre sexe!");};
		if(empty(\$nom)) {array_push(\$erreurs, "Veuillez renseigner votre nom de famille!");};
		if(empty(\$prenom)) {array_push(\$erreurs, "Veuillez renseigner votre prénom!");};
		if(empty(\$age)) {array_push(\$erreurs, "Veuillez renseigner votre date de naissance!");};
		if(empty(\$adresse)) {array_push(\$erreurs, "Veuillez renseigner votre adresse!");};
		if(empty(\$code_postal)) {array_push(\$erreurs, "Veuillez renseigner votre code postal!");};
		if(empty(\$email)) {array_push(\$erreurs, "Veuillez renseigner votre adresse électronique!");};
		if(empty(\$telephone)) {array_push(\$erreurs, "Veuillez renseigner votre numéro de téléphone!");};
		if(empty(\$mot_de_passe_1)) {array_push(\$erreurs, "Veuillez renseigner votre mot de passe!");};
		if(empty(\$mot_de_passe_2)) {array_push(\$erreurs, "Veuillez confirmer votre mot de passe!");};
		if(empty(\$newsletter)) {\$newsletter = "non";};
		if(\$mot_de_passe_1 != \$mot_de_passe_2) {array_push(\$erreurs, "Vos mots de passe sont différents!");};

		\$modele = "/(^[A-Z])+([a-z])([^0-9])/";
		if(!preg_match(\$modele, \$nom)) {array_push(\$erreurs, "Veuillez renseigner un nom valide!");};
		if(!preg_match(\$modele, \$prenom)) {array_push(\$erreurs, "Veuillez renseigner un prénom valide!");};
		\$modele = "#^[a-z0-9._-]+@[a-z0-9._-]{2,}\.[a-z]{2,4}\$#";
		if(!preg_match(\$modele, \$email)) {array_push(\$erreurs, "Veuillez renseigner une adresse email valide!");};
		\$modele = "/(^[A-Z])+([a-zA-z])([^0-9])/";
		if(!preg_match(\$modele, \$ville)) {array_push(\$erreurs, "Veuillez renseigner le nom d'une ville valide!");};
		\$modele = "/(^[0-9])([^A-Za-z])/";
		if(!preg_match(\$modele, \$code_postal)) {array_push(\$erreurs, "Veuillez renseigner un code postal valide!");};
		\$modele = "/(^07)|(^06)+([0-9])/";
		if(!preg_match(\$modele, \$telephone)) {array_push(\$erreurs, "Veuillez renseigner un numéro de téléphone valide!");};

		# vérification que le email n'est pas déjà répertorié dans la base de donnée
		\$email_check_query = "SELECT * FROM compte WHERE email = '\$email' LIMIT 1";
		\$resultat = mysqli_query(\$db, \$email_check_query);
		\$compte = mysqli_fetch_assoc(\$resultat);

		if(\$compte)
			if(\$compte['email'] === \$email) {array_push(\$erreurs, "Un compte a déjà été ouvert avec cet adresse électronique. Allez vers le champs \"mot de passe oublié\"");};

		# Enregistrement du compte si aucune erreur n'a été détectée
		if(count(\$erreurs) == 0) {
			# protection du mot de passe (avec sel) en utilisant l'algorithme "bcrypt"
			\$mot_de_passe = password_hash(\$mot_de_passe_1, PASSWORD_DEFAULT);
			\$id_client = 0;
			\$date_creation = date("Y/m/d");
			\$requete = "INSERT INTO compte (id_client, sexe, nom, prenom, age, adresse, ville, code_postal, email, mot_de_passe, numero_telephone, date_creation, newsletter) VALUES ('$id_client', '$sexe', '$nom', '$prenom', '$age', '$adresse', '$ville', '$code_postal', '$email', '$mot_de_passe', '$telephone', '$date_creation', '$newsletter')";

			mysqli_query(\$db, \$requete);
			\$requete = "SELECT * FROM compte WHERE email='\$email'";
			\$resultat = mysqli_query(\$db, \$requete);
			\$resultat = mysqli_fetch_assoc(\$resultat);
			\$_SESSION = \$resultat;
			\$_SESSION['email'] = \$email;
			\$_SESSION['success'] = "Vous êtes désormais inscrit et connecté à votre compte!";
			header("location: index.php");
		}
	}
?>

<!DOCTYPE html>
<html lang="fr">
	<head>
		<meta http-equiv="Content-type" content="text/html; charset=utf-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-beta/css/bootstrap.min.css" integrity="sha384-/Y6pD6FV/Vv2HJnA6t+vslU6fwYXjCFtcEpHbNJ0lyAFsXTsjBbfaDjzALeQsN6M" crossorigin="anonymous">
		<link href="https://fonts.googleapis.com/css2?family=Montserrat&display=swap" rel="stylesheet">
		<title>Inscription | FREE PORTAGE</title>
	</head>

	<style>
		* {
			font-family: 'Montserrat', sans-serif;
			margin: auto;
			vertical-align: baseline;
		}

		#titre {
			text-align: center;
			font-size: 24px;
		}

		.formulaire {
			margin: auto;
			vertical-align: baseline;
			display: block;
			width: 280px;
		}

		.msg_erreur {
			margin: auto;
			text-align: center;
			color: red;
		}

		.bouton {
			background: #0a66c2;
			border-radius: 22px;
			border: none;
			color: white;
			padding: 8px;
			width: 40%;
			margin: auto;
			margin-left: 30%;
		}

		.bouton:hover {
			background: #05407a;
		}

		p {
			font-size: 12px;
		}

	</style>

	<body>
		<?php
			echo "<form action=\"".\$_SERVER['PHP_SELF']."\" method=\"post\" enctype=\"application/x-www-form-urlencoded\">";
		?>
			<fieldset>
				<legend id="titre"><b>INSCRIPTION</b></legend>
					<div class="msg_erreur">
						<?php
							# affichage des erreurs
								if(count(\$erreurs) > 0) {
										foreach(\$erreurs as \$erreur)
											echo "<p><b>\$erreur</b></p>";
								}
						?>
					</div>
					<div class="formulaire">
						<label for="sexe" autofocus>Sexe</label><br>
							<select id="sexe" name="sexe" style="width: 280px;" required>
								<option value="Autre">Autre</option>
								<option value="Féminin">Féminin</option>
								<option value="Masculin">Masculin</option>
							</select><br><br>
						<input type="text" name="nom" maxlength="50" placeholder="Nom" style="width: 280px;" required><br>
						<input type="text" name="prenom" maxlength="50" placeholder="Prénom" style="width: 280px;" required><br><br>
						<label for="age">Date de naissance</label><br>
							<input type="date" name="age" style="width: 280px;" required><br><br>
						<input type="text" name="adresse" maxlength="100" placeholder="Adresse" style="width: 280px;" required><br>
						<input type="text" name="ville" maxlength="50" placeholder="Ville" style="width: 280px;" required><br>
						<input type="zip" name="code_postal" size="7" maxlength="5" placeholder="Code postal" style="width: 280px;" required><br>
						<input type="email" name="email" maxlength="255" placeholder="E-mail" style="width: 280px;" required><br>
						<input type="tel" name="telephone" maxlength="10" placeholder="N° téléphone" style="width: 280px;" required><br>
						<input type="password" name="mot_de_passe_1" placeholder="Mot de passe" style="width: 280px;" required><br>
						<input type="password" name="mot_de_passe_2" placeholder="Confirmer mot de passe" style="width: 280px;" required><br>
						<br>
						<p>
							<input type="checkbox" name="termes_conditions" required> J'ai lu et j'accepte les <a href="https://www.freeportages.com/mentions-legales" target="_blank">conditions générales</a><br>
							<input type="checkbox" name="newsletter" value="oui"> J'accepte de recevoir par voie électronique la newsletter de FREE PORTAGE
						</p>
						<input class="bouton" type="submit" name="inscription" value="S'inscrire"><br><br>
					</div>
				</fieldset>
		</form>
		<p style="text-align: center;">Vous avez déjà un compte ? <a href="login.php">Connectez-vous.</a></p>
	</body>
</html>
EOF

# restart apache2 to apply configuration
# enabling the apache2 service at startup
systemctl restart apache2
systemctl enable apache2