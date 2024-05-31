// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IVoting.sol";

contract Voting is IVoting {
    struct Candidate {
        string cin;
        uint256 voteCount;
    }

    mapping(uint256 => Candidate) public candidates;
    mapping(string => bool) public hasVotedByID; //  Suivi des identifiants uniques des électeurs qui ont déjà voté
    mapping(address => bool) public hasVoted; // Suivi des adresses Ethereum qui ont déjà voté
    mapping(string => bool) private uniqueCins; // Pour vérifier l'unicité des cin candidat
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

    modifier onlyOnce(string memory hashedElectorID, address voterAddress) {
        require(!hasVotedByID[hashedElectorID], "This ID has already voted"); // Vérifie que l'ID n'a pas voté
        require(!hasVoted[voterAddress], "You have already voted"); // Vérifie que l'adresse n'a pas voté
        _;
   }

    function addCandidate(string memory cin) public override onlyWhenVotingOpen {
        require(!uniqueCins[cin], "Candidate cin already exists"); // Vérification d'unicité
        candidateCount += 1;
        candidates[candidateCount] = Candidate(cin, 0);
        uniqueCins[cin] = true; // Marque le cin comme utilisé
        emit CandidateAdded(candidateCount, cin);
    }


    function vote(uint256 candidateId, string memory hashedElectorID) public override onlyWhenVotingOpen onlyOnce(hashedElectorID, msg.sender) {
       require(candidateId > 0 && candidateId <= candidateCount, "Invalid candidate");
    
       candidates[candidateId].voteCount += 1;
       hasVotedByID[hashedElectorID] = true; // // Marque l'identifiant unique de l'électeur comme ayant voté
       hasVoted[msg.sender] = true; // Marque l'adresse Ethereum comme ayant voté
       emit Voted(msg.sender, candidateId); // Émettre l'événement de vote
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

    // Implémentez une fonction pour récupérer le nombre total de candidats
    function getCandidateCount() public override view returns (uint256) {
        return candidateCount;
    }
}
