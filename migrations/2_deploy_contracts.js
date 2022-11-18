const AuthWallet = artifacts.require("AuthWallet");
const AuthVerifier = artifacts.require("AuthVerifier");

module.exports = async function (deployer) {

  //deploy auth
  await deployer.deploy(AuthWallet);
  await deployer.deploy(AuthVerifier);
};
