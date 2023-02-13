# Remarques sur le rendu

- `proposals`, l'ensemble des propositions, a été modélisé comme tableau, l'index servant d'identifiant naturel en gardant la structure `Proposal` de l'énoncé. 
- le choix du mapping pour les votes est un choix d'économie de gaz, il est suffisant pour ce cas car on peut éviter d'avoir à itérer sur l'ensemble des votes, mais sera limitant dès qu'on voudra une visualisation plus riche de l'ensemble des votes.
- dans le constructeur
    - `whitelistOwner` : mettre à vrai pour que l'admin soit automatiquement ajouté comme votant
    - `withBlank` : mettre à vrai pour qu'une proposition vide soit automatiquement crée
- Codes d'erreurs: juste des identifiants (clé de tradiuction) au niveau du code : à retravailler côté doc/app avec des explications (multi-lingue) mieux écrites.
- redondance `_whitelist` et `_voters` : optimisable en un seul mapping, mais potentiellement intéressant d'avoir deux notions distinctes (surtout dans le cas de votes multiples)
- `increaseWorkflowStatus`: seule manière de faire progresser l'étape actuelle du vote, aurrait pu être plus souple (une étape cible en paramètre par exemple) tant qu'on vérifie que l'indexe progresse.
- J'ai choisi de n'ouvrir la visibilité des votes individuels qu'après la fin des votes, adaptable si besoin dans le modifier `onlyReadableVotes`.
- Le renvoi de la proposition gagnante d'un vote pourrait être améliorée : 
    - en la conditionnant par le fait d'avoir au moins un vote pour mieux traiter le cas peu pertinent où aucun vote n'a été effectué.
    - quand plusieurs propositions ont le même nombre de votes, la première ayant atteint ce nombre est renvoyée. Le choix entre plusieurs propositions au même nombre de votes pourrait être retravaillée.

## Vote simple
Implémenté dans [Voting.sol](./Voting.sol).

Les choix de visibilité publique (des proposals et de l'étape) permettent de bénéficier naturellement des getters associés mais devraient être accédés via des getter conditionnés (`onlyWhitelist`).
Il faudrait également ajouter quelques functions pour simplifier la présentation/pagination des propositions du coté dapp: accès au nombre total de propositions, récupérer les propositions d'un index à un autre...

## Vote multiple
Une exploration d'une version permettant de gérer un nombre arbitraire de votes en parallèle à été ébauchée dans [Votings.sol](./Votings.sol). Un nouvel entier sert alors d'identifiant à chaque vote. Le nettoyage de code, les visibilités beaucoup trop ouvertes et autres économies de stokage seraient à finaliser.
