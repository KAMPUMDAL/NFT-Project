
NFT Smart Contract Portfolio

A production-ready ERC721 NFT smart contract implementation built with Solidity and Foundry, demonstrating professional blockchain development practices and comprehensive testing methodologies.

Table of Contents

Overview
Features
Technical Stack
Getting Started
Smart Contract API
Testing
Deployment
Project Structure
Security Considerations
Gas Optimization
License
Author


Overview
This project implements a complete ERC721 Non-Fungible Token (NFT) smart contract with advanced features including configurable minting, owner controls, and comprehensive security measures. The contract is built using Solidity 0.8.20 and developed with the Foundry framework, following industry best practices and security standards.
Key Highlights

Full ERC721 standard compliance
Comprehensive test coverage with 40+ test cases
Gas-optimized implementation
Security-focused design patterns
Production-ready deployment scripts
Well-documented codebase


Features
Core Functionality
Token Management

ERC721 standard implementation
Unique token minting with payment
Token burning capability
Metadata management with IPFS compatibility

Minting Controls

Public minting with configurable pricing
Owner-privileged minting (free)
Batch minting for efficiency
Per-address mint limits
Maximum supply enforcement
Automatic refund for excess payments

Administrative Features

Toggle public minting on/off
Dynamic price adjustments
Base URI updates for metadata
Secure fund withdrawal mechanism
Ownership transfer capability

Security Features

Reentrancy protection through OpenZeppelin
Integer overflow/underflow protection (Solidity 0.8+)
Comprehensive input validation
Access control for privileged operations
Event logging for transparency


Technical Stack

Smart Contract Language: Solidity ^0.8.20
Development Framework: Foundry
Testing Framework: Forge
Smart Contract Libraries: OpenZeppelin Contracts v5.0.0
Token Standard: ERC721
Networks: Ethereum-compatible chains (Sepolia testnet ready)


Getting Started
Prerequisites
Ensure you have the following installed:

Git
Foundry

Installation
Clone the repository and install dependencies:
bashgit clone https://github.com/KAMPUMDAL/NFT-Project.git
cd NFT-Project
forge install
Build
Compile the smart contracts:
bashforge build
Test
Run the test suite:
bashforge test
For detailed test output:
bashforge test -vvv

Smart Contract API
Public Functions
mint()
solidityfunction mint() external payable
Mints a new NFT to the caller. Requires payment of the current mint price. Automatically refunds excess payment.
Requirements:

Public minting must be enabled
Caller must not exceed per-address mint limit
Total supply must not exceed maximum
Sufficient payment must be provided

burn(uint256 tokenId)
solidityfunction burn(uint256 tokenId) external
Burns (permanently destroys) the specified token.
Requirements:

Caller must own the token or be approved

tokenURI(uint256 tokenId)
solidityfunction tokenURI(uint256 tokenId) public view returns (string memory)
Returns the metadata URI for the specified token.
Parameters:

tokenId: The ID of the token to query

Returns:

String containing the complete URI for the token metadata

Owner-Only Functions
ownerMint(address to)
solidityfunction ownerMint(address to) external onlyOwner
Mints a new NFT to the specified address without payment requirement.
Parameters:

to: The address to receive the minted token

ownerBatchMint(address to, uint256 quantity)
solidityfunction ownerBatchMint(address to, uint256 quantity) external onlyOwner
Mints multiple NFTs to the specified address in a single transaction.
Parameters:

to: The address to receive the minted tokens
quantity: The number of tokens to mint

setPublicMintEnabled(bool enabled)
solidityfunction setPublicMintEnabled(bool enabled) external onlyOwner
Enables or disables public minting.
Parameters:

enabled: True to enable public minting, false to disable

setMintPrice(uint256 newPrice)
solidityfunction setMintPrice(uint256 newPrice) external onlyOwner
Updates the mint price.
Parameters:

newPrice: The new mint price in wei

setBaseURI(string memory newBaseURI)
solidityfunction setBaseURI(string memory newBaseURI) external onlyOwner
Updates the base URI for token metadata.
Parameters:

newBaseURI: The new base URI string

setMaxMintsPerAddress(uint256 newMax)
solidityfunction setMaxMintsPerAddress(uint256 newMax) external onlyOwner
Updates the maximum number of tokens that can be minted per address.
Parameters:

newMax: The new maximum mint limit per address

withdraw()
solidityfunction withdraw() external onlyOwner
Withdraws all contract funds to the owner's address.
View Functions
totalSupply()
solidityfunction totalSupply() public view returns (uint256)
Returns the current total number of minted tokens.
mintPrice()
solidityfunction mintPrice() public view returns (uint256)
Returns the current mint price in wei.
publicMintEnabled()
solidityfunction publicMintEnabled() public view returns (bool)
Returns whether public minting is currently enabled.

Testing
The project includes a comprehensive test suite covering all major functionality and edge cases.
Run All Tests
bashforge test
Run Tests with Verbosity
bashforge test -vv    # Show test names and results
forge test -vvv   # Show test names, results, and gas usage
forge test -vvvv  
Generate Gas Report
bashforge test --gas-report
Check Code Coverage
bashforge coverage
Run Specific Tests
bashforge test --match-test test_FunctionName
forge test --match-contract ContractName
Test Categories
The test suite covers:

Constructor and initialization
Public minting functionality
Owner minting privileges
Access control mechanisms
Payment handling and refunds
Supply limits and constraints
Edge cases and error conditions
Gas optimization verification


Deployment
Environment Setup
Create a .env file in the project root:
bashALCHEMY_API_KEY=your_alchemy_api_key
ETHERSCAN_API_KEY=your_etherscan_api_key
PRIVATE_KEY=your_private_key
Note: Never commit your .env file to version control.
Deploy to Sepolia Testnet
bashforge script script/DeployPortfolioNFT.s.sol:DeployPortfolioNFT \
  --rpc-url https://eth-sepolia.g.alchemy.com/v2/${ALCHEMY_API_KEY} \
  --private-key ${PRIVATE_KEY} \
  --broadcast \
  --verify
Deploy to Mainnet
Before mainnet deployment, ensure:

Complete security audit has been performed
All tests pass on mainnet fork
Deployment parameters are reviewed
Sufficient ETH for gas fees is available

bashforge script script/DeployPortfolioNFT.s.sol:DeployPortfolioNFT \
  --rpc-url https://eth-mainnet.g.alchemy.com/v2/${ALCHEMY_API_KEY} \
  --private-key ${PRIVATE_KEY} \
  --broadcast \
  --verify
Verify Contract on Etherscan
If automatic verification fails:
bashforge verify-contract \
  --chain-id 11155111 \
  --etherscan-api-key ${ETHERSCAN_API_KEY} \
  <CONTRACT_ADDRESS> \
  src/NFT.sol:NFT

Project Structure
NFT-Project/
├── src/
│   └── NFT.sol                      # Main NFT smart contract
├── test/
│   └── NFTtest.t.sol                # Comprehensive test suite
├── script/
│   ├── DeployPortfolioNFT.s.sol     # Deployment script
│   └── InteractPortfolioNFT.s.sol   # Interaction script
├── lib/
│   ├── forge-std/                    # Forge standard library
│   └── openzeppelin-contracts/       # OpenZeppelin contracts
├── foundry.toml                      # Foundry configuration
├── remappings.txt                    # Import remappings
├── .gitignore                        # Git ignore rules
├── .env.example                      # Environment template
├── LICENSE                           # MIT License
└── README.md                         # This file

Security Considerations
Implemented Security Measures
Reentrancy Protection

Inherited from OpenZeppelin's battle-tested implementations
Follows Checks-Effects-Interactions pattern

Integer Overflow Protection

Automatic overflow/underflow checks in Solidity 0.8+
No unsafe arithmetic operations

Access Control

Owner-only functions properly restricted
Ownable pattern from OpenZeppelin

Input Validation

Comprehensive require statements
Clear error messages
Validation of all user inputs

Payment Handling

Safe transfer mechanisms
Automatic refund for excess payments
No external call vulnerabilities

Best Practices

All state changes occur before external calls
Events emitted for all significant state changes
No floating pragma versions
Minimal external dependencies
Comprehensive testing coverage

Audit Recommendations
Before production deployment:

Conduct professional security audit
Test extensively on testnet
Perform mainnet fork testing
Review all deployment parameters
Implement monitoring and alerting


Gas Optimization
Optimization Techniques
Storage Optimization

Use of uint256 for gas efficiency
Minimal storage operations
Efficient variable packing where applicable

Function Optimization

Efficient loop implementations
Optimized batch operations
Minimal external calls

ERC721 Implementation

Gas-efficient OpenZeppelin base
Streamlined minting process
Optimized token tracking

Gas Cost Estimates
Estimated gas costs at 30 gwei (prices are approximate):
OperationGas UsageETH CostUSD (at $2000 ETH)Deploy Contract~3,000,0000.09 ETH$180Owner Mint~100,0000.003 ETH$6Public Mint~120,0000.0036 ETH$7.20Transfer~50,0000.0015 ETH$3Burn~30,0000.0009 ETH$1.80

License
This project is licensed under the MIT License - see the LICENSE file for details.

Author
KAMPUMDAL

GitHub: @KAMPUMDAL
Repository: NFT-Project


Contributing
Contributions are welcome. Please follow these guidelines:

Fork the repository
Create a feature branch
Write tests for new features
Ensure all tests pass
Format code with forge fmt
Submit a pull request


Acknowledgments

OpenZeppelin - Secure smart contract libraries
Foundry - Ethereum development toolkit
Ethereum - Decentralized platform


Last Updated: November 2025
