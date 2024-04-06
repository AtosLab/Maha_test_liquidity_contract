import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { CONTRACTS } from "../constants";
import deployAndVerifyContract from "../common/deploy_verify";

const func: DeployFunction = async (hre: HardhatRuntimeEnvironment) => {
  // await deployAndVerifyContract(hre, CONTRACTS.TestLiquidity);
  await deployAndVerifyContract(hre, CONTRACTS.CustomToken, ["ATOS TOKEN", "ATT"]);
};

func.tags = [CONTRACTS.TestLiquidity.deployName];

export default func;
