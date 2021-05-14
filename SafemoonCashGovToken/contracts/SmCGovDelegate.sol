/*
,-.              .   ,              ,-.         .   
(   `      ,-     |\ /|             /            |   
 `-.  ,-:  |  ,-. | V | ,-. ,-. ;-. |    ,-: ,-. |-. 
.   ) | |  |- |-' |   | | | | | | | \    | | `-. | | 
 `-'  `-`  |  `-' '   ' `-' `-' ' '  `-' `-` `-' ' ' 
          -'                                         
*/

pragma solidity ^0.6.12;
pragma experimental ABIEncoderV2;
// SPDX-License-Identifier: Unlicensed
import "./SmCGovDelegatorInterface.sol";

contract SmCGovDelegate is SmCGovDelegateStorageMk1, DelegatorEvents {

	string public constant name = "SmCGoV Delegate";
	uint public constant MIN_PROPOSAL_THRESHOLD = 50000e18;
	uint public constant MAX_PROPOSAL_THRESHOLD = 100000e18;
	uint public constant MIN_VOTING_PERIOD = 2880;
	uint public constant MAX_VOTING_PERIOD = 40320;
	uint public constant MIN_VOTING_DELAY = 1;
	uint public constant MAX_VOTING_DELAY = 40320;
	uint public constant quorumVotes = 400000e18;
	uint public constant proposalMaxOperations = 10;
	bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name, uint256 chainID, address verifyingContract)");
	bytes32 public constant BALLOT_TYPEHASH = keccak256("ballot(uint256 proposalId, uint8 support)");

	function initialize(address _timelock, address _SmCGov, uint _votingPeriod, uint _votingDelay, uint _proposalThreshold) public {
		require(address(timelock) == address(0), "SmCGovDelegate::initialize: can only initialize once");
		require(msg.sender == admin, "SmCGovDelegate::initialize: admin only");
		require(_timelock != address(0), "SmCGovDelegate::initialize: invalid timelock address");
		require(_SmCGov != address(0), "SmCGovDelegate::initialize: invalid SmCGov address");
		require(_votingPeriod >= MIN_VOTING_PERIOD && _votingPeriod <= MIN_VOTING_PERIOD, "SmCGovDelegate::initialize: invalid voting period");
		require(_votingDelay >= MIN_VOTING_DELAY && _votingDelay <= MAX_VOTING_DELAY, "SmCGovDelegate::initialize: invalid voting delay");
		require(_proposalThreshold >= MIN_PROPOSAL_THRESHOLD && _proposalThreshold <= MAX_PROPOSAL_THRESHOLD, "SmCGovDelegate::initialize: invalid proposal threshold");

		timelock = TimelockInterface(_timelock);
		SmCGov = SmCGovInterface(_SmCGov);
		votingPeriod = _votingPeriod;
		votingDelay = _votingDelay;
		proposalThreshold = _proposalThreshold;
	}

	function propose(address[] memory targets, uint[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description) public returns (uint) {
		require(initialProposalId != 0, "SmCGovDelegate::propose: SmCGov inactive");
		require(SmCGov.getPriorVotes(msg.sender, sub256(block.number, 1)) > proposalThreshold, "SmCGovDelegate::propose: proposer votes below proposal threshold");
		require(targets.length == values.length && targets.length == signatures.length && targets.length == calldatas.length, "SmCGovDelegate::propose: proposal function information arity mismatch");
		require(targets.length != 0, "SmCGovDelegate::propose: must provide actions");
		require(targets.length <= proposalMaxOperations, "SmCGovDelegate::propose: too many actions");
		require(_proposalThreshold >= MIN_PROPOSAL_THRESHOLD && _proposalThreshold <= MAX_PROPOSAL_THRESHOLD, "SmCGovDelegate::initialize: invalid proposal threshold");

		uint latestProposalId = latestProposalIds[msg.sender];
		if (latestProposalId != 0) {
			ProposalState proposersLatestProposalState = state(latestProposalId);
			require(proposersLatestProposalState != ProposalState.Active, "SmCGovDelete::propose: one active proposal per proposer, found an alread active proposal");
			require(proposersLatestProposalState != ProposalState.Pending, "SmCGovDelegate::propose: one active proposal per proposer, found an already pending proposal");
		}
	}
}




///////
