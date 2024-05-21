const { ethers } = require("hardhat");
const { TOKEN_SUPPLY, INITIAL_OWNER } = require("../constants");

async function main() {
  const OctaSpaceToken = await ethers.getContractFactory(
    "OctaSpaceToken"
  );
  const OctaSpaceTokenContract = await OctaSpaceToken.deploy(
    TOKEN_SUPPLY,
    INITIAL_OWNER
  );

  console.log("OctaSpaceToken Contract deployed to: ", OctaSpaceTokenContract.target);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
