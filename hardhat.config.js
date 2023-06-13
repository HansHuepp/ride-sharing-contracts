/**
* @type import('hardhat/config').HardhatUserConfig
*/


require("@nomiclabs/hardhat-ethers");

module.exports = {
   solidity: "0.8.18",
   defaultNetwork: "goerli",
   networks: {
      hardhat: {},
      goerli: {
         url: "https://eth-goerli.g.alchemy.com/v2/D2v9l7fEW75FXl16QZg-Wmz2asLmqcp4",
         accounts: [`0x${"a9a723a54494ff96a302ce42a907141447f58be79f1cac6816537668372900c1"}`]
      }
   },
}