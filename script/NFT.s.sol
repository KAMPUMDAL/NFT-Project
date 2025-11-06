// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Script.sol";
import "../src/NFT.sol";

contract DeployNFT is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("0x57edeafaa8f0865cffc2600e496e2ff380fd0832ac1939637d708b26ea5ad33d");
        
        string memory name = "MyNFT";
        string memory symbol = "MNFT";
        uint256 maxSupply = 1000;
        uint256 mintPrice = 0.01 ether;
        string memory baseURI = "ipfs://QmYourCIDHere/";
        
        vm.startBroadcast(deployerPrivateKey);
        
        NFT nft = new NFT(
            name,
            symbol,
            maxSupply,
            mintPrice,
            baseURI
        );
        
        console.log("NFT deployed to:", address(nft));
        
        vm.stopBroadcast();
    }
}