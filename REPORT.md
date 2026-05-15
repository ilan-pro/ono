# Globalité

# Comment l’exécuter ?

commande générique : `dune exec -- ono concret options`  :

## OPTION CONCRETE/SYMBOLIC

### Obligatoire 

- Chemin du fichier : il faut préciser un chemin vers un fichier `.wat` - [concrete/symbolic]
- Un booléan indiquant si oui ou non nous voulons afficher la fenêtre graphique ou le mode textuelle - [concrete]

### Optionnelle 

- `--config chemin_vers_config_json` : Permet de spécifier une configuration `json` afin de démarrer notre moteur sur une configuration prédéfinie - [concrete]
- `--seed int` : Permet de générer une configuration aléatoire (en spécifiant la même `seed` à chaque exécution, nous aurons les mêmes configurations afin de pouvoir utiliser les cram tests correctement) - [concrete]
- `--last int` : Permet de préciser combien d’itération, à partir de la fin, nous voulons afficher dans le jeu de vie - [concrete]
- `steps int` : À l'inverse de `last`. Le `steps` permet de ne générer que les `n` premières configurations - [concrete]
- `--symbolic_config chemin_vers_json` : Permet de démarrer le moteur de notre jeu sur une configuration générer par un moteur d'exxécution symbolique - [concrete]
- `contrainte int` : Permet de préciser le numéro de la contrainte que nous souhaitons exécuter - [symbolic]

### Les contraintes 

| Numéro | Description                                                                                            |
| -----  | -------------------------------------------------------------------------------------------------------|
| `0`    | Permet de n'avoir aucune cellule vivante au prochain tour (par défaut)                                 |
| `1`    | Permet de demander à l'utilisateur à la case (x,y) qu'une cellule vivante soit présente                |
| `2`    | Permet de demander à l'utilisateur à la case (x,y) qu'une cellule morte soit présente                  |
| `3`    | Au tour suivant, il y a au moins une cellule vivante sur la grille                                     |
| `4`    | Au tour suivant, toutes les cellules sont vivantes                                                     |
| `5`    | Au tour suivant, toutes les cellules sont mortes                                                       |
| `8`    | Au tour suivant, il y a exactement `N` cellules vivantes dans la grille                                |
| `9`    | Au tour suivant, il existe une cellule isolée (i.e. dont toutes les cellules voisines sont mortes)     |
| `10`   | Au tour suivant, il existe une cellule entourée de cellules vivantes                                   |
| `11`   | Au tour suivant, il existe deux cellules vivantes côte à côte                                          |
| `12`   | Au tour suivant, il existe un motif en `L` de trois cellules vivantes                                  |
| `13`   | Au tour suivant, il existe un motif carré de 2*2 cellules vivantes                                     |


# Parties réalisées

- Préliminaires
- Interface textuelle
    les options suivantes
    - steps
    - last
    - seed
- Interface Graphique
- Solveur de polynôme
- Générations de configuration pour le jeu de la vie

# Parties manquantes

- Contraintes (6, 7 , 14, 15, 16, 17)

# Amélioration possibles

- Boutons pour choisir l’itération précédente et suivante du jeu de la vie dans la partie graphique
- Rendre la vue de l’interface proportionnelle à la taille de la fenêtre
- pour la partie  symbolique générer toutes les configurations possibles pas que la 1ère 

# Points subtiles

Convertion des fichiers json en une configuration du jeu de la vie

interface graphique : affichage des cellules sur une fenetre graphique + zoom dézoom (touche du clavier 'P' : Zomm , touche du clavier 'O' : Dézoom)

symbolique : 
- remplacement des if par des opérations arithmétique

wasm :
- gestion de la mémoire linéaire

# Difficulté rencontrées

Compréhension du moteur symbolique et de son exécution 

## Ce que le projet nous a apporté

Ce projet nous a permis d’effectuer un véritable travail de recherche et de réflexion autour de concepts complexes, notamment la programmation par contraintes, l’exécution symbolique et le fonctionnement du WebAssembly. Il nous a également donné l’opportunité de découvrir et d’utiliser des outils comme OWI dans un contexte concret de développement et d’analyse.

Au-delà des aspects techniques, ce projet nous a apporté une expérience enrichissante sur le plan humain et professionnel : travail en équipe, gestion du temps, organisation des tâches et gestion du stress face aux difficultés rencontrées.