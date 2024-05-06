require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: {
    version: "0.8.0", // Version de Solidity utilisée pour compiler les contrats
  },
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545", // Adresse du nœud local Hardhat
      chainId: 31337, // Chain ID par défaut pour Hardhat
    },
  },
};
