const { ethers } = require("hardhat"); // Importer ethers depuis Hardhat


async function main(){
    // Obtenir la factory du contrat 'Voting'
    const Voting = await ethers.getContractFactory('Voting');

    // Déployer le contrat
    const voting = await Voting.deploy();

    // Attendre que le contrat soit déployé
    await voting.waitForDeployment();

    // Utiliser un délai explicite comme alternative à .deployed()
    //const delay = (ms) => new Promise((resolve) => setTimeout(resolve, ms));
    //await delay(5000); // Attendre 5 secondes (ajustez si nécessaire)

    // Obtenir l'adresse du contrat déployé
    const address = await voting.getAddress();
    console.log("Voting deployed to: ", address);

}

// Exécuter le script de déploiement
main()
 .then(() => process.exit(0)) // Quitter avec succès
 .catch((error) => { 
    console.error("Error deploying contract:", error);
    process.exit(1); // Quitter avec un code d'erreur
});