// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IVoting.sol";

contract Voting is IVoting {
    struct Candidate {
        string cin;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(address => bool) public hasVoted;
    mapping(string => bool) private uniqueCins; // Pour vérifier l'unicité des noms
    uint256 public candidateCount;
    bool public votingOpen;

    constructor() {
        votingOpen = true;
        candidateCount = 0;
    }

    modifier onlyWhenVotingOpen() {
        require(votingOpen, "Voting is closed");
        _;
    }

    modifier onlyOnce() {
        require(!hasVoted[msg.sender], "You have already voted");
        _;
    }

    function addCandidate(string memory cin) public override onlyWhenVotingOpen {
        require(!uniqueCins[cin], "Candidate cin already exists"); // Vérification d'unicité
        candidateCount += 1;
        candidates[candidateCount] = Candidate(cin, 0);
        uniqueCins[cin] = true; // Marque le nom comme utilisé
        emit CandidateAdded(candidateCount, cin);
    }

    function vote(uint256 candidateId) public override onlyWhenVotingOpen onlyOnce {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate");
        candidates[candidateId].voteCount += 1;
        hasVoted[msg.sender] = true;
        emit Voted(msg.sender, candidateId);
    }

    function closeVoting() public override onlyWhenVotingOpen {
        votingOpen = false;
        emit VotingClosed();
    }

    function getWinner() public override view returns (uint256, string memory, uint256) {
        require(!votingOpen, "Voting is still open");
        uint256 maxVotes = 0;
        uint256 winnerId = 0;

        for (uint256 i = 1; i <= candidateCount; i++) {
            if (candidates[i].voteCount > maxVotes) {
                maxVotes = candidates[i].voteCount;
                winnerId = i;
            }
        }

        return (winnerId, candidates[winnerId].cin, candidates[winnerId].voteCount);
    }

    function getTotalVotes() public override view returns (uint256) {
        uint256 total = 0;
        for (uint256 i = 1; i <= candidateCount; i++) {
            total += candidates[i].voteCount;
        }
        return total;
    }

    function getCandidate(uint256 candidateId) public override view returns (string memory, uint256) {
        require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate");
        return (candidates[candidateId].cin, candidates[candidateId].voteCount);
    }

    function isVotingOpen() public override view returns (bool) {
        return votingOpen;
    }
}
