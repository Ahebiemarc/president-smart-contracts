// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IVoting {
    // Déclaration d'événements pour signaler certaines actions sur le contrat
    event CandidateAdded(uint256 candidateId, string cin);
    event Voted(address voter, uint256 candidateId);
    event VotingClosed();

    // Fonction pour ajouter des candidats
    function addCandidate(string memory cin) external;

    // Fonction pour voter pour un candidat spécifique
    function vote(uint256 candidateId, string memory hashedElectorID) external;

    // Fonction pour fermer le scrutin
    function closeVoting() external;

    // Fonction pour obtenir le gagnant
    function getWinner() external view returns (uint256, string memory, uint256);

    // Fonction pour obtenir le nombre total de votes
    function getTotalVotes() external view returns (uint256);

    // Fonction pour obtenir les détails d'un candidat
    function getCandidate(uint256 candidateId) external view returns (string memory, uint256);

    // Fonction pour obtenir le statut du vote
    function isVotingOpen() external view returns (bool);
}
