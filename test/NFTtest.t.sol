
//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/NFT.sol";

contract NFTTest is Test {
    NFT public nft;
    address public owner;
    address public user1;
    
    function setUp() public {
        owner = address(this);
        user1 = address(0x1);
        
        nft = new NFT(
            "Portfolio NFT",
            "PNFT",
            100,              
            0.01 ether,       
            "ipfs://QmExample/"
        );
        
        vm.deal(user1, 10 ether);
    }
    function test_Constructor() public view {
    assertEq(nft.name(), "Portfolio NFT");
    assertEq(nft.symbol(), "PNFT");
    assertEq(nft.maxSupply(), 100);
    assertEq(nft.mintPrice(), 0.01 ether);
    assertEq(nft.publicMintEnabled(), false);
}
function test_OwnerMint() public {
    nft.ownerMint(user1);
    
    assertEq(nft.ownerOf(0), user1);
    assertEq(nft.totalSupply(), 1);
}
function test_PublicMint_RevertsWithInsufficientPayment() public {
    nft.setPublicMintEnabled(true);
    
    vm.prank(user1);
    vm.expectRevert("Insufficient payment");
    nft.mint{value: 0.005 ether}();
}
function test_PublicMint_RefundsExcessPayment() public {
    nft.setPublicMintEnabled(true);
    
    uint256 balanceBefore = user1.balance;
    
    vm.prank(user1);
    nft.mint{value: 0.02 ether}();
    
    assertEq(balanceBefore - user1.balance, 0.01 ether);
}
function test_PublicMint_RevertsAtMaxSupply() public {
    nft.setPublicMintEnabled(true);
    nft.ownerBatchMint(user1, 100);  
    
    vm.prank(user1);
    vm.expectRevert("Max supply reached");
    nft.mint{value: 0.01 ether}();
}
function test_PublicMint_RevertsAtMaxMintsPerAddress() public {
    nft.setPublicMintEnabled(true);
    
    vm.startPrank(user1);
    for (uint256 i = 0; i < 5; i++) {
        nft.mint{value: 0.01 ether}();
    }
    
    vm.expectRevert("Max mints per address reached");
    nft.mint{value: 0.01 ether}();
    vm.stopPrank();
}
function test_Withdraw() public {
    nft.setPublicMintEnabled(true);
    
    vm.prank(user1);
    nft.mint{value: 0.01 ether}();
    
    uint256 ownerBalanceBefore = owner.balance;
    nft.withdraw();
    
    assertEq(owner.balance, ownerBalanceBefore + 0.01 ether);
    assertEq(address(nft).balance, 0);
}
function test_OwnerMint_RevertsWhenNotOwner() public {
    vm.prank(user1);
    vm.expectRevert();
    nft.ownerMint(user1);
}
function testFuzz_PublicMint(uint256 payment) public {
    vm.assume(payment >= 0.01 ether && payment <= 100 ether);
    
    nft.setPublicMintEnabled(true);
    vm.deal(user1, payment);
    
    vm.prank(user1);
    nft.mint{value: payment}();
    
    assertEq(nft.ownerOf(0), user1);
}
}