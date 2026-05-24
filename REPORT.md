# Comment exécuter le projet ?

## Préliminaire

Voici la commande à lancer afin de pouvoir lancer les tests lié à fibonacci : 

`dune exec -- ono concrete test/cram/concrete/fibonacci.t/fibonnaci.wat`

Voici la commande à lancer afin de pouvoir lancer les tets lié au fichier pour calculer le carré d'un nombre (ici 10) :

`dune exec -- ono concrete test/cram/concrete/square.t/square.wat`

Nous pouvons aussi tester les résultats de ces fonctions en exécutant la commande `dune runtest` afin de voir si cela correspond bien au résultat attendu.

## Jeu de la vie en WASM 

Pour exécuter cette partie, il y a différentes options. 

### Les options : 
- Le jeu de la vie nécessite un tableau sur lequel les cellules vivantes et mortes se trouvent. Pour cela, il faut des dimensions pour la largeur du plateau et pour la longueur du plateau. Nous avons choisi pour cela de demander à l'utilisateur les dimensions du plateau. Cela se passe directement via la ligne de commande et uniquement si aucune configuration préalable n'est fourni (car les dimensions sont déjà fourni dans le .json).

    `dune exec -- ono concrete test/cram/concrete/game.t/game.wat`

    Cette commande permettra d'exécuter le jeu de la vie dans une configuration totalement aléatoire avec les dimensions souhaitées.

- Étant donné que nous pouvons faire un nombre infini d'étapes, nous avons spécifier une option nommé `steps` qui permet tout simplement de limiter le nombre d'itération. Attention, si le jeu de la vie se trouve dans une phase stable après n itération et que nous en demandons strictement moins de n, alors nous ne verrons pas la grille se "stabiliser".

    `dune exec -- ono concrete test/cram/concrete/game.t/game.wat --steps 10`

- Le problème vient aussi dans le sens inverse, étant donné que nous pouvons avoir de très grande instance du jeu de la vie, voir le résultat final (jusqu'à un moment stable comme dans le cas des glider par exemple) est difficile (car long). Nous avons donc introduit une nouvelle options permettant de spécifier les n dernières itérations que nous voulons afficher du jeu de la vie. Attention, ceci n'est valable que quand nous avons l'option `--steps` car sans cette dernière, cela n'aurait aucun sens étant donné que nous avons un nombre d'itérations infini et donc qu'il n'y a pas de fin à proprement parlé.

    `dune exec -- ono concrete test/cram/concrete/game.t/game.wat --steps 10 --last 3`

- De plus, afin d'avoir des cram tests cohérent et étant donné la gestion aléatoire des configurations du jeu de la vie par notre moteur, nous devons introduire une option afin de contrôler la graîne qui génère les nombres aléatoires afin de toujours avoir une configuration similaire et donc de vérifier les crams tests.

    `dune exec -- ono concrete test/cram/concrete/game.t/game.wat --seed 42` 

- Nous pouvons aussi préciser une configuration par défaut si nous connaissons certains schéma intéressant du jeu de la vie comme des gliders ou autre structure récurrente.
Nos fichiers de configurations se trouve dans le répertoire de `config`, ainsi une commande valide serait : 
    
    `dune exec -- ono concrete test/cram/concrete/game.t/game.wat --config config/glider.json` 

- Une des principales fonctionnalitée était de réaliser un jeu de la vie en graphique, nous avons pour cela du utiliser une option supplémentaire afin de spécifier si nous voulons lancer la fenêtre graphique ou non. Bien-sûr, les options précédentes sont toujours compatibles avec la version graphique.

    `dune exec -- ono concrete test/cram/concrete/game.t/game.wat --graphical`

- La dernière partie du projet portant sur l'exécution symbolique, il fallait une option permettant d'exécutant le résultat des configurations généré par le moteur d'exécution symbolique. Nous devons seulement spécifier le fichier json et un parseur prendra la main (le parseur est bien-sûr différent de celui utilisé pour les configurations classique). Pour cette étape, nous utilisons 2 fichiers json, 1 ou nous insérons les dimensions de la grille que l'utilisateur à rentré lors de sa saisie `symbolic_dimension.json` et un second qui représente le résultat du solveur qui est `symbolic_config.json`. Les fichiers de configuration json pour la partie symbolique sont dans le même répertoir que pour les configurations classiques. Une commande pour exécuter cette partie serait donc : 

    `dune exec -- ono concrete test/cram/concrete/game.t/game.wat --symbolic_config config/symbolic_config.json`

- Concernant cette même partie mais via la commande symbolic maintenant, nous avons une options permettant de préciser le numéro de contrainte que nous voulons. Les numéros et leur descriptions sont reférencé plus bas.
    `dune exec -- ono symbolic test/cram/symbolic/config.t/config.wat --constraint {0..13}`

### Les numéros de contrainte

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
- Générer toutes les configurations possible en une seule exécution 
- Gestion des erreurs dans les options (entiers négatifs...)
- Gestion des anomalies dans les solutions des polynomes du au type utilisé (avec i32 > n solutions pour un polynome de degré n)

# Points subtiles

Convertion des fichiers json en une configuration du jeu de la vie

interface graphique : affichage des cellules sur une fenetre graphique + zoom dézoom (touche du clavier 'P' : Zomm , touche du clavier 'O' : Dézoom)

symbolique : 
- remplacement des if par des opérations arithmétique afin d'optimiser.

wasm :
- gestion de la mémoire linéaire

# Difficulté rencontrées

Compréhension du moteur symbolique et de son exécution 

## Ce que le projet nous a apporté

Ce projet nous a permis d’effectuer un véritable travail de recherche et de réflexion autour de concepts complexes, notamment la programmation par contraintes, l’exécution symbolique et le fonctionnement du WebAssembly. Il nous a également donné l’opportunité de découvrir et d’utiliser des outils comme OWI dans un contexte concret de développement et d’analyse.

Au-delà des aspects techniques, ce projet nous a apporté une expérience enrichissante sur le plan humain et professionnel : travail en équipe, gestion du temps, organisation des tâches et gestion du stress face aux difficultés rencontrées.