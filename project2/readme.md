# Remarques sur le rendu

Dans [truffleVote](./truffleVote) l'ensemble du project avec truffle : 

```sh 
cd truffleVote
npm install
truffle test
```

Dans [hardhatVote](./truffleVote) l'ensemble du project réinjectée dans hardhat (pour pouvoir vérifier la couverture) : 

```sh 
cd hardhatVote
npm install
npx hardhat test
```


## Organisation du fichier de test

- La premier partie regroupe les tests qui vérifier les droits d'accès sur les méthodes du smart contract et les évènements émis associés à un cas d'utilisation réussie.

- La seconde s'attarde sur les éléments de stockage et vérifie les changements en mémoire d'un appel réussit de chaque méthode.

- La suivante décrit quelques cas limites pour tester au moins une fois ces cas d'erreurs particuliers.

- La quatrième vérifie la cohérence en terme de workflowStatus des opérations: toutes sont interdites dans un mauvais status. 
Il serait préférable de retirer les ’unspecified’ et de renforcer ces tests avec les véritables messages d'erreur.

## Détails des tests
### Authorized adresses and events
- addVoter
	 - Not Owner cannot add 
	 - Owner can add, VoterRegistered is emitted
- startProposalsRegistering
	 - Not Owner cannot start Proposals Registering
	 - Owner can start proposals registering, WorkflowStatusChange is emitted
- addProposal
	 - Not Voter cannot propose
	 - Voter can propose, ProposalRegistered is emitted
- endProposalsRegistering
	 - Not Owner cannot end Proposals Registering
	 - Owner can end endProposalsRegistering, WorkflowStatusChange is emitted
- startVotingSession
	 - Not Owner cannot start Proposals Registering
	 - Owner can start start the voting session, WorkflowStatusChange is emitted
- setVote
	 - Not Voter cannot vote
	 - Voter can vote, Voted is emitted
- endVotingSession
	 - Not Owner cannot endVotingSession
	 - Owner can start endVotingSession, WorkflowStatusChange is emitted
- tallyVotes
	 - not owner cannot tally votes
	 - Owner can tally votes, WorkflowStatusChange is emitted
### Storages
- addVoter
	 - voter is stored
- startProposalsRegistering
	 - workflowStatus is updated
- addProposal
	 - proposal is stored
- endProposalsRegistering
	 - workflowStatus is updated
- startVotingSession
	 - workflowStatus is updated
- setVote
	 - vote is updated in the proposal
	 - voter is updated
- endVotingSession
	 - workflowStatus is updated
- tallyVotes
	 - winningProposalID is updated
### Bad input Cases
- Only register adresses once
- Reject empty propositions 
- Vote for existing proposition
- Vote only once     
### Workflow
-  Test methods in all the bad workflowStatus
### More Realistic Example




