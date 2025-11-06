// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/NFT.sol";

contract DeployNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);
        
        NFT nft = new NFT(
            "Portfolio NFT",
            "PNFT",
            1000,
            10000000000000000,
            "ipfs://QmYourCIDHere/"
        );
        
        console.log("NFT deployed to:", address(nft));
        console.log("Owner:", nft.owner());
        
        vm.stopBroadcast();
    }
}
