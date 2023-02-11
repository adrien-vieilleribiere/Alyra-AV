# Remarques sur le rendu

- `proposals`, l'ensemble des propositions, a été modélisé comme tableau, l'index servant d'identifiant naturel en gardant la structure `Proposal` de l'énoncé. 
- le choix du mapping pour les votes est un choix d'économie de gaz, il est suffisant pour ce cas car on peut éviter d'avoir à itérer sur l'ensemble des votes, mais sera limitant dès qu'on voudra une visualisation plus riche de l'ensemble des votes.
- dans le constructeur
    - `whitelistOwner` : mettre à vrai pour que l'admin soit automatiquement ajouté comme votant
    - `withBlank` : mettre à vrai pour qu'une proposition vide soit automatiquement crée
- Codes d'erreurs: juste des identifiants (clé de tradiuction) au niveau du code : à retravailler côté doc/app avec des explications (multi-lingue) mieux écrites.
- redondance `_whitelist` et `_voters` : optimisable en un seul mapping, mais potentiellement intéressant d'avoir deux notions distinctes (surtout dans le cas de votes multiples)
- `increaseWorkflowStatus`: seule manière de faire progresser l'étape actuelle du vote, aurrait pu être plus souple (une étape cible en paramètre par exemple) tant qu'on vérifie que l'indexe progresse.

## Vote simple
Implémenté dans [Voting.sol](./Voting.sol).

Les choix de visibilité publique (des proposals et de l'étape) permettent de bénéficier naturellement des getters associés mais devraient être privés avec des getter conditionnés (`onlyWhitelist`).
Il faudrait également ajouter quelques functions pour simplifier la présentation/pagination des propositions du coté dapp: accès au nombre total de propositions, récupérer le tableau d'un index à un autre...

## Vote multiple
Une exploration d'une version permettant de gérer un nombre arbitraire de votes en parallèle à été ébeauchée Implémenté dans [Votings.sol](./Votings.sol).. Un nouvel entier sert alors d'identifiant à chaque vote. Le nettoyage de code, les visibilités beaucoup trop ouvertes (car encore en test) et autres économies de stokage seraient à finaliser ultérieurement.

