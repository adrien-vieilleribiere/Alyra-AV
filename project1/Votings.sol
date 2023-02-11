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

contract Votings is Ownable {
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
        uint256[] hasVoted;
        uint256[] votedProposalId;
    }
    struct Proposal {
        string description;
        uint256 voteCount;
    }
    // the current steps
    mapping(uint256 => WorkflowStatus) public workflowStatus;
    // all the proposals
    mapping(uint256 => mapping(uint256 => Proposal)) public proposals;
    mapping(uint256 => uint256) public proposalsSizes;

    // the current proposal with the lagest voteCount
    mapping(uint256 => Proposal) public winningProposals;
    // the id (index in the proposals array) of the winningProposals
    mapping(uint256 => uint256) public winningProposalIds;

    string public test;
    uint256 public votesNumber;

    mapping(uint256 => mapping(address => bool)) private _whitelist;
    mapping(address => Voter) private _voters;

    event VoterRegistered(address _voterAddress);
    event WorkflowStatusChange(
        uint256 _voteId,
        WorkflowStatus _previousStatus,
        WorkflowStatus _newStatus
    );
    event ProposalRegistered(uint256 _voteId, uint256 _proposalId);
    event Voted(address _voter, uint256 _voteId, uint256 _proposalId);

    modifier onlyWhitelist(uint256 _voteId) {
        require(_whitelist[_voteId][msg.sender], "E0_1");
        _;
    }

    modifier onlyReadableVotes(uint256 _voteId) {
        require(uint256(workflowStatus[_voteId]) >= 4, "E1_4");
        _;
    }

    constructor(bool whitelistOwner) {
        if (whitelistOwner) {
            whitelist(msg.sender, 0);
        }
    }

    // Authorize an address to participate in a vote
    function whitelist(address _address, uint256 _voteId) public onlyOwner {
        require(uint256(workflowStatus[_voteId]) == 0, "E1_0");
        // check if the adress is already whitelisted
        require(!_whitelist[_voteId][_address], "E2_1");
        _whitelist[_voteId][_address] = true;
        /*mapping(uint => string) memory hasVoted;
        mapping(uint => uint) memory votedProposalId;*/
        _voters[_address] = Voter(true, new uint256[](0), new uint256[](0));
        emit VoterRegistered(_address);
    }

    function isWhitelisted(address _address, uint256 _voteId)
        external
        view
        onlyWhitelist(_voteId)
        returns (bool)
    {
        return _whitelist[_voteId][_address];
    }

    function getWorkflowStatus(uint256 _voteId)
        external
        view
        onlyWhitelist(_voteId)
        returns (uint256)
    {
        return uint256(workflowStatus[_voteId]);
    }

    // go to the next step of the vote _voteId
    function increaseWorkflowStatus(uint256 _voteId) external onlyOwner {
        require(uint256(workflowStatus[_voteId]) < 5, "E2_4");
        workflowStatus[_voteId] = WorkflowStatus(
            uint256(workflowStatus[_voteId]) + 1
        );
        emit WorkflowStatusChange(
            _voteId,
            WorkflowStatus(uint256(workflowStatus[_voteId]) - 1),
            workflowStatus[_voteId]
        );
    }

    // add a new proposal if it is a new one
    function addProposal(uint256 _voteId, string memory _proposalText)
        external
        onlyWhitelist(_voteId)
    {
        require(uint256(workflowStatus[_voteId]) == 1, "E1_1");
        //require(bytes(_proposalText).length > 0, "E2_5");
        bool proposalExists = false;
        if (proposalsSizes[_voteId] == 0) {
            winningProposals[_voteId] = Proposal(_proposalText, 0);
            winningProposalIds[_voteId] = 0;
        }
        for (uint256 i = 0; i < proposalsSizes[_voteId]; i++) {
            if (
                Strings.equal(proposals[_voteId][i].description, _proposalText)
            ) {
                proposalExists = true;
            }
        }
        require(!proposalExists, "E2_2");
        proposals[_voteId][(proposalsSizes[_voteId])] = Proposal(
            _proposalText,
            0
        );

        proposalsSizes[_voteId]++;
        emit ProposalRegistered(_voteId, proposalsSizes[_voteId] - 1);
    }

    function vote(uint256 _voteId, uint256 _proposalId)
        external
        onlyWhitelist(_voteId)
    {
        // we must be in the step 'VotingSessionStarted'
        //require(uint256(workflowStatus[_voteId]) == 3, "E1_3");
        // an address cannot vote more than once by vote_id
        bool alreadyVoted = false;
        for (uint256 i = 0; i < _voters[msg.sender].hasVoted.length; i++) {
            if (_voters[msg.sender].hasVoted[i] == _voteId) {
                alreadyVoted = true;
            }
        }
        require(alreadyVoted == false, "E2_6");

        // the proposal must exists
        require(_proposalId < proposalsSizes[_voteId], "E2_3");
        proposals[_voteId][_proposalId].voteCount++;
        _voters[msg.sender].hasVoted.push(_voteId);
        _voters[msg.sender].votedProposalId.push(_proposalId);
        // update the proposal with maximal votes if necessary
        if (
            proposals[_voteId][_proposalId].voteCount >
            winningProposals[_voteId].voteCount
        ) {
            winningProposals[_voteId] = proposals[_voteId][_proposalId];
            winningProposalIds[_voteId] = _proposalId;
        }
        emit Voted(msg.sender, _voteId, _proposalId);
    }

    // get the id of the winning proposal
    function getWinner(uint256 _voteId)
        public
        view
        onlyWhitelist(_voteId)
        returns (uint256)
    {
        require(uint256(workflowStatus[_voteId]) == 5, "E1_5");
        return winningProposalIds[_voteId];
    }
}
