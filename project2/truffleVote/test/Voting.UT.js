
const { BN, expectRevert, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const constants = require('@openzeppelin/test-helpers/src/constants');

let MyVoting = artifacts.require("./Voting.sol");

contract("MyVoting", async accounts => {

    const _owner = accounts[0];
    const _voter1 = accounts[1];
    const _voter2 = accounts[2];
    const _prop1id = new BN(1);
    const _prop1desc = "description 1"
    const _prop2id = new BN(2);
    const _prop2desc = "description 2"
    let votingInstance;
    let maxPropositions;
    let winningPid;
    let winningCount;
    let randomProp;

    describe("Authorized adresses and events", async () => {

        before(async function () {
            votingInstance = await MyVoting.new();
        });

        context("addVoter", async () => {
            it("Not Owner cannot add", async () => {
                await expectRevert(votingInstance.addVoter(_voter1, { from: _voter1 }), "Ownable: caller is not the owner");
            });
            it("Owner can add, VoterRegistered is emitted", async () => {
                const adVoter1 = await votingInstance.addVoter(_voter1, { from: _owner });
                await expectEvent(adVoter1, 'VoterRegistered', { voterAddress: _voter1 });
            });
        });

        context("startProposalsRegistering", async () => {
            it("Not Owner cannot start Proposals Registering", async () => {
                await expectRevert(votingInstance.startProposalsRegistering({ from: _voter1 }), "Ownable: caller is not the owner");
            });
            it("Owner can start proposals registering, WorkflowStatusChange is emitted", async () => {
                const startProposalsRegistering = await votingInstance.startProposalsRegistering({ from: _owner });
                await expectEvent(startProposalsRegistering, 'WorkflowStatusChange', {
                    previousStatus: new BN(0),
                    newStatus: new BN(1)
                });
            });
        });

        context("addProposal", async () => {
            it("Not Voter cannot propose", async () => {
                await expectRevert(votingInstance.addProposal(_prop1desc, { from: _owner }), "You're not a voter");
            });
            it("Voter can propose, ProposalRegistered is emitted", async () => {
                const addPropososal = await votingInstance.addProposal(_prop1desc, { from: _voter1 });
                await expectEvent(addPropososal, 'ProposalRegistered', { proposalId: _prop1id });
            });

        });

        context("endProposalsRegistering", async () => {
            it("Not Owner cannot end Proposals Registering", async () => {
                await expectRevert(votingInstance.endProposalsRegistering({ from: _voter1 }), "Ownable: caller is not the owner");
            });
            it("Owner can end endProposalsRegistering, WorkflowStatusChange is emitted", async () => {
                const startProposalsRegistering = await votingInstance.endProposalsRegistering({ from: _owner });
                await expectEvent(startProposalsRegistering, 'WorkflowStatusChange', {
                    previousStatus: new BN(1),
                    newStatus: new BN(2)
                });
            });
        });

        context("startVotingSession", async () => {
            it("Not Owner cannot start Proposals Registering", async () => {
                await expectRevert(votingInstance.startVotingSession({ from: _voter1 }), "Ownable: caller is not the owner");
            });
            it("Owner can start start the voting session, WorkflowStatusChange is emitted", async () => {
                const startVotingSession = await votingInstance.startVotingSession({ from: _owner });
                await expectEvent(startVotingSession, 'WorkflowStatusChange', {
                    previousStatus: new BN(2),
                    newStatus: new BN(3)
                });
            });
        });

        context("setVote", async () => {
            it("Not Voter cannot vote", async () => {
                await expectRevert(votingInstance.setVote(_prop1id, { from: _owner }), "You're not a voter");
            });
            it("Voter can vote, Voted is emitted", async () => {
                const vote1 = await votingInstance.setVote(_prop1id, { from: _voter1 });
                await expectEvent(vote1, 'Voted', { voter: _voter1, proposalId: _prop1id });
            });
        });

        context("getVoter", async () => {
            it("Not Voter cannot getVoter", async () => {
                await expectRevert(votingInstance.getVoter(_voter1, { from: _owner }), "You're not a voter");
            });
        });

        context("getOneProposal", async () => {
            it("Not Voter cannot getOneProposal", async () => {
                await expectRevert(votingInstance.getOneProposal(_prop1id, { from: _owner }), "You're not a voter");
            });
        });

        context("endVotingSession", async () => {
            it("Not Owner cannot endVotingSession", async () => {
                await expectRevert(votingInstance.endVotingSession({ from: _voter1 }), "Ownable: caller is not the owner");
            });
            it("Owner can start endVotingSession, WorkflowStatusChange is emitted", async () => {
                const startProposalsRegistering = await votingInstance.endVotingSession({ from: _owner });
                await expectEvent(startProposalsRegistering, 'WorkflowStatusChange', {
                    previousStatus: new BN(3),
                    newStatus: new BN(4)
                });
            });
        });

        context("tallyVotes", async () => {
            it("not owner cannot tally votes", async () => {
                await expectRevert(votingInstance.tallyVotes({ from: _voter1 }), "Ownable: caller is not the owner");
            });
            it("Owner can tally votes, WorkflowStatusChange is emitted", async () => {
                const tallyVote = await (votingInstance.tallyVotes({ from: _owner })); //_winningProposalId
                await expectEvent(tallyVote, 'WorkflowStatusChange', {
                    previousStatus: new BN(4),
                    newStatus: new BN(5)
                });
            });
        });
    });

    describe("Storages", async () => {

        before(async function () {
            votingInstance = await MyVoting.new();
        });

        context("addVoter", async () => {

            it("voter is stored", async () => {
                const adVoter1 = await votingInstance.addVoter(_voter1);
                const voter1registered = await votingInstance.getVoter(_voter1, { from: _voter1 });
                expect(voter1registered.isRegistered).to.equal(true);
                expect(voter1registered.hasVoted).to.equal(false);
            });
        });

        context("startProposalsRegistering", async () => {

            it("workflowStatus is updated", async () => {
                await votingInstance.startProposalsRegistering({ from: _owner });
                const prop0 = await (votingInstance.getOneProposal(BN(0), { from: _voter1 }));
                await expect(prop0.description).to.equal("GENESIS");
                await expect(BN(prop0.voteCount)).to.bignumber.equal(BN(0)); // arevoir
                expect(await votingInstance.workflowStatus.call()).to.bignumber.equal(new BN(1));
            });
        });
        context("addProposal", async () => {
            it("proposal is stored", async () => {
                addPropososal = await votingInstance.addProposal(_prop1desc, { from: _voter1 });
                const prop1 = await (votingInstance.getOneProposal(_prop1id, { from: _voter1 }));
                await expect(prop1.description).to.equal(_prop1desc);
                addPropososal2 = await votingInstance.addProposal(_prop2desc, { from: _voter1 });
            });
        });
        context("endProposalsRegistering", async () => {

            it("workflowStatus is updated", async () => {
                await votingInstance.endProposalsRegistering({ from: _owner });
                const newState = await votingInstance.workflowStatus.call()
                expect(newState).to.bignumber.equal(new BN(2));
            });
        });

        context("startVotingSession", async () => {

            it("workflowStatus is updated", async () => {
                await votingInstance.startVotingSession({ from: _owner });
                expect(await votingInstance.workflowStatus.call()).to.bignumber.equal(new BN(3));
            });
        });

        context("setVote", async () => {
            before(async function () {
                const vote1 = await votingInstance.setVote(_prop2id, { from: _voter1 });
            });
            it("vote is updated in the proposal", async () => {
                const prop2 = await (votingInstance.getOneProposal(_prop2id, { from: _voter1 })); // .call() ?
                await expect(prop2.voteCount).to.bignumber.equal(new BN(1));
                const voter1 = await votingInstance.getVoter(_voter1, { from: _voter1 });
            });
            it("voter is updated", async () => {
                const voter1 = await votingInstance.getVoter(_voter1, { from: _voter1 });
                expect(voter1.hasVoted).to.be.true;
            });
        });

        context("endVotingSession", async () => {

            it("workflowStatus is updated", async () => {
                await votingInstance.endVotingSession({ from: _owner });
                const newState = await votingInstance.workflowStatus.call()
                expect(newState).to.bignumber.equal(new BN(4));
            });
        });

        context("tallyVotes", async () => {

            it("winningProposalID is updated", async () => {
                const winningProposalID = await votingInstance.winningProposalID();
                expect(winningProposalID).to.bignumber.equal(BN(0));
                const tallyVote = await (votingInstance.tallyVotes({ from: _owner }));
                const newWinningProposalID = await votingInstance.winningProposalID();
                expect(newWinningProposalID).to.bignumber.equal(_prop2id);
            });
        });
    });



    describe("Workflow", async () => {

        before(async function () {
            votingInstance = await MyVoting.new();

        });

        it("Test methods in all the bad satus", async () => {
            for (var i = 0; i <= 5; i++) {
                // tests in workflowStatus = i
                for (var j = 0; j <= 5; j++) {
                    // test the operations adapted to the workflowStatus j
                    if (i !== j) {
                        switch (j) {
                            case 0:
                                await expectRevert.unspecified(votingInstance.addVoter(_voter2, { from: _owner }));
                                await expectRevert.unspecified(votingInstance.startProposalsRegistering({ from: _owner }));
                                break;
                            case 1:
                                await expectRevert.unspecified(votingInstance.addProposal(_prop1desc, { from: _voter1 }));
                                await expectRevert.unspecified(votingInstance.endProposalsRegistering({ from: _owner }));
                                break;
                            case 2:
                                await expectRevert.unspecified(votingInstance.startVotingSession({ from: _owner }));
                                break;
                            case 3:
                                await expectRevert.unspecified(votingInstance.setVote(_prop1id, { from: _owner }));
                                await expectRevert.unspecified(votingInstance.endVotingSession({ from: _owner }));
                                break;
                            case 4:
                                await expectRevert.unspecified(votingInstance.tallyVotes({ from: _owner }));
                                await expectRevert.unspecified(votingInstance.setVote(_prop1id, { from: _voter1 }));
                                break;
                        }
                    }
                }
                switch (i) {
                    case 0:
                        await votingInstance.addVoter(_voter1, { from: _owner });
                        await votingInstance.startProposalsRegistering({ from: _owner });
                        break;
                    case 1:
                        await votingInstance.endProposalsRegistering({ from: _owner });
                        break;
                    case 2:
                        await votingInstance.startVotingSession({ from: _owner });
                        break;
                    case 3:
                        await votingInstance.endVotingSession({ from: _owner });
                        break;
                    case 4:
                        await votingInstance.tallyVotes({ from: _owner });
                        break;
                    // case 5:
                    //     await expectRevert.unspecified(votingInstance.addVoter(_voter2, { from: _owner }));
                    //     await expectRevert.unspecified(votingInstance.startProposalsRegistering({ from: _owner }));
                    //     await expectRevert.unspecified(votingInstance.addProposal(_prop1desc, { from: _voter1 }));
                    //     await expectRevert.unspecified(votingInstance.endProposalsRegistering({ from: _owner }));
                    //     await expectRevert.unspecified(votingInstance.startVotingSession({ from: _owner }));
                    //     await expectRevert.unspecified(votingInstance.setVote(_prop1id, { from: _owner }));
                    //     await expectRevert.unspecified(votingInstance.endVotingSession({ from: _owner }));
                    //     await expectRevert.unspecified(votingInstance.tallyVotes({ from: _owner }));
                    //     break;
                }

            }
        });

    });

    describe("Bad input Cases", async () => {

        before(async function () {
            votingInstance = await MyVoting.new();
        });

        it("Only register adresses once", async () => {
            const adVoter1 = await votingInstance.addVoter(_voter1);
            await expectRevert(votingInstance.addVoter(_voter1), "Already registered");
            await votingInstance.startProposalsRegistering();
        });

        it("Reject empty propositions", async () => {
            const addPropososal = await votingInstance.addProposal(_prop1desc, { from: _voter1 });
            await expectRevert(votingInstance.addProposal("", { from: _voter1 }), "Vous ne pouvez pas ne rien proposer");
            await votingInstance.endProposalsRegistering();
            await votingInstance.startVotingSession({ from: _owner });
        });

        it("Vote for existing proposition", async () => {
            await expectRevert(votingInstance.setVote(new BN(421), { from: _voter1 }), "Proposal not found");
        });

        it("Vote only once", async () => {
            const vote1 = await votingInstance.setVote(_prop1id, { from: _voter1 });
            await expectRevert(votingInstance.setVote(_prop1id, { from: _voter1 }), "You have already voted");

        });
    });

    describe.skip("A more realistic case", async () => {

        before(async () => {
            votingInstance = await MyVoting.new();
            const maxVoters = 9;
            maxPropositions = 300;
            for (var i = 1; i <= maxVoters; i++) {
                await votingInstance.addVoter(accounts[i], { from: _owner });
            }
            await votingInstance.startProposalsRegistering({ from: _owner });
            for (var j = 0; j < maxPropositions; j++) {
                await votingInstance.addProposal("Proposition " + j,
                    { from: accounts[1 + Math.floor(Math.random() * maxVoters)] });
            }

            await votingInstance.endProposalsRegistering({ from: _owner });
            await votingInstance.startVotingSession({ from: _owner });
            for (var i = 1; i <= maxVoters; i++) {
                await votingInstance.setVote(
                    Math.floor(Math.random() * maxPropositions),
                    { from: accounts[i] }
                );
            }
            await votingInstance.endVotingSession({ from: _owner });
            await votingInstance.tallyVotes({ from: _owner });
            winningPid = await votingInstance.winningProposalID();
            const prop1 = await (votingInstance.getOneProposal(winningPid, { from: _voter1 }));
            winningCount = parseInt(prop1.voteCount);
            randomProp = await votingInstance.getOneProposal(new BN(Math.floor(Math.random() * maxPropositions)), { from: _voter1 });
        });
        it("the winning id corresponds to a proposition ", async () => {
            expect(parseInt(winningPid)).to.be.at.most(maxPropositions - 1);
        });
        it("the winning id has votes ", async () => {
            expect(winningCount).to.be.at.least(1);
        });

        it("Another proposition has less votes ", async () => {
            expect(parseInt(randomProp.voteCount)).to.be.at.most(winningCount);
        });

    });

});
