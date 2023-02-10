pragma solidity 0.8.18;
// SPDX-License-Identifier: GPL-3.0
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

/* ERRORS CODES:
    E0_0 = "Restricted to admin privileges";
    E0_1 = "Recticted to whitelisted adresses";
    E0_2 = "Restricted to Registered"

    E1_0 = "The registration is closed";
    E1_1 = "The proposal registration is closed";
    E1_3 = "The vote is closed";
    E1_4 = "The vote reveal is closed";
    E1_5 = "The winner view is closed";

    E2_1 = "The adress is already whitelisted"
    E2_2 = "The proposal already exists"
    E2_3 = "The proposal is not known"
    E2_4 = "No next step available";
    E2_5 = "The parameter _proposalText is required"
    E2_6 = "The vote is only available once, and already done"
 */

contract Voting is Ownable {
    // the possible steps of the vote
    enum WorkflowStatus {
        RegisteringVoters,
        ProposalsRegistrationStarted,
        ProposalsRegistrationEnded,
        VotingSessionStarted,
        VotingSessionEnded,
        VotesTallied
    }
    struct Voter {
        bool isRegistered;
        bool hasVoted;
        uint256 votedProposalId;
    }
    struct Proposal {
        string description;
        uint256 voteCount;
    }
    // the current step
    WorkflowStatus public workflowStatus;
    // all the proposals
    Proposal[] public proposals;
    // the current proposal with the lagest voteCount
    Proposal private winningProposal;
    // the id (index in the proposals array) of the winningProposal
    uint256 private winningProposalId;

    mapping(address => bool) private _whitelist;
    mapping(address => Voter) private _voters;

    event VoterRegistered(address _voterAddress);
    event WorkflowStatusChange(
        WorkflowStatus _previousStatus,
        WorkflowStatus _newStatus
    );
    event ProposalRegistered(uint256 _proposalId);
    event Voted(address _voter, uint256 _proposalId);

    modifier onlyWhitelist() {
        require(_whitelist[msg.sender], "E0_1");
        _;
    }

    modifier onlyReadableVotes() {
        require(uint256(workflowStatus) >= 4, "E1_4");
        _;
    }

    constructor(bool whitelistOwner, bool withBlank) {
        if (whitelistOwner) {
            whitelist(msg.sender);
        }
        if (withBlank) {
            proposals.push(Proposal("", 0));
        }
    }

    // Authorize an address to participate in the vote
    function whitelist(address _address) public onlyOwner {
        require(uint256(workflowStatus) == 0, "E1_0");
        // check if the adress is already whitelisted
        require(!_whitelist[_address], "E2_1");
        _whitelist[_address] = true;
        _voters[_address] = Voter(true, false, 0);
        emit VoterRegistered(_address);
    }

    function isWhitelisted(address _address)
        external
        view
        onlyWhitelist
        returns (bool)
    {
        return _whitelist[_address];
    }

    function getWorkflowStatus() external view onlyWhitelist returns (uint256) {
        return uint256(workflowStatus);
    }

    // go to the next step of the vote
    function increaseWorkflowStatus() external onlyOwner {
        require(uint256(workflowStatus) < 5, "E2_4");
        workflowStatus = WorkflowStatus(uint256(workflowStatus) + 1);
        emit WorkflowStatusChange(
            WorkflowStatus(uint256(workflowStatus) - 1),
            workflowStatus
        );
    }

    // add a new proposal if it is a new one
    function addProposal(string memory _proposalText) external onlyWhitelist {
        require(uint256(workflowStatus) == 1, "E1_1");
        require(bytes(_proposalText).length > 0, "E2_5");
        bool proposalExists = false;
        for (uint256 i = 0; i < proposals.length; i++) {
            if (Strings.equal(proposals[i].description, _proposalText)) {
                proposalExists = true;
            }
        }
        require(!proposalExists, "E2_2");
        proposals.push(Proposal(_proposalText, 0));
        emit ProposalRegistered(proposals.length);
    }

    function vote(uint256 _proposalId) external onlyWhitelist {
        // we must be in the step 'VotingSessionStarted'
        require(uint256(workflowStatus) == 3, "E1_3");
        // redoundancy whith onlyWhitelist but more robustness if "unRegister" whithout unWhitelist is possible
        require(_voters[msg.sender].isRegistered, "E0_2");
        // an address cannot vote more than once
        require(
            _voters[msg.sender].hasVoted == false &&
                _voters[msg.sender].votedProposalId == 0,
            "E2_6"
        );
        // the proposal must exists
        require(_proposalId < proposals.length, "E2_3");
        proposals[_proposalId].voteCount++;
        _voters[msg.sender].hasVoted = true;
        _voters[msg.sender].votedProposalId = _proposalId;
        // update the proposal with maximal votes if necessary
        if (proposals[_proposalId].voteCount > winningProposal.voteCount) {
            winningProposal = proposals[_proposalId];
            winningProposalId = _proposalId;
        }
        emit Voted(msg.sender, _proposalId);
    }

    // show the vote of an adress
    function getVote(address _address)
        external
        view
        onlyWhitelist
        onlyReadableVotes
        returns (uint256)
    {
        return _voters[_address].votedProposalId;
    }

    // get the all voter (clearer distinction between "voted for the proposition 0" and "didn't vote")
    function getVoter(address _address)
        external
        view
        onlyWhitelist
        onlyReadableVotes
        returns (Voter memory)
    {
        return _voters[_address];
    }

    // get the id of the winning proposal
    function getWinner() public view onlyWhitelist returns (uint256) {
        require(uint256(workflowStatus) == 5, "E1_5");
        return winningProposalId;
    }
}
