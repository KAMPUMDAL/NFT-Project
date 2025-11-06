// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    uint256 public maxSupply;
    uint256 public mintPrice;
    string public baseTokenURI;
    bool public publicMintEnabled;
    
    mapping(address => uint256) public mintedPerAddress;
    uint256 public maxMintsPerAddress;

    event NFTMinted(address indexed minter, uint256 indexed tokenId);
    event BaseURIUpdated(string newBaseURI);
    event MintPriceUpdated(uint256 newPrice);
    event PublicMintToggled(bool enabled);

    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _maxSupply,
        uint256 _mintPrice,
        string memory initialBaseURI)
    
    ERC721(_name, _symbol) Ownable(msg.sender) {
        maxSupply = _maxSupply;
        mintPrice = _mintPrice;
        baseTokenURI = initialBaseURI;
        publicMintEnabled = false;
        maxMintsPerAddress = 5;
        _nextTokenId = 0;
    }

    function mint() external payable {
        require(publicMintEnabled, "Public minting is not enabled");
        require(msg.value >= mintPrice, "Insufficient payment");
        require(_nextTokenId < maxSupply, "Max supply reached");
        require(
            mintedPerAddress[msg.sender] < maxMintsPerAddress,
            "Max mints per address reached"
        );

        uint256 tokenId = _nextTokenId;
        _nextTokenId++;
        mintedPerAddress[msg.sender]++;

        _safeMint(msg.sender, tokenId);
        emit NFTMinted(msg.sender, tokenId);

        if (msg.value > mintPrice) {
            (bool success, ) = msg.sender.call{value: msg.value - mintPrice}("");
            require(success, "Refund failed");
        }
    }

    function ownerMint(address to) external onlyOwner {
        require(_nextTokenId < maxSupply, "Max supply reached");
        uint256 tokenId = _nextTokenId;
        _nextTokenId++;
        _safeMint(to, tokenId);
        emit NFTMinted(to, tokenId);
    }

    function ownerBatchMint(address to, uint256 quantity) external onlyOwner {
        require(_nextTokenId + quantity <= maxSupply, "Would exceed max supply");

        for (uint256 i = 0; i < quantity; i++) {
            uint256 tokenId = _nextTokenId;
            _nextTokenId++;
            _safeMint(to, tokenId);
            emit NFTMinted(to, tokenId);
        }
    }

    function setPublicMintEnabled(bool enabled) external onlyOwner {
        publicMintEnabled = enabled;
        emit PublicMintToggled(enabled);
    }

    function setMintPrice(uint256 newPrice) external onlyOwner {
        mintPrice = newPrice;
        emit MintPriceUpdated(newPrice);
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseTokenURI = newBaseURI;
        emit BaseURIUpdated(newBaseURI);
    }

    function setMaxMintsPerAddress(uint256 newMax) external onlyOwner {
        maxMintsPerAddress = newMax;
    }

    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");
        
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Withdrawal failed");
    }

    function totalSupply() external view returns (uint256) {
        return _nextTokenId;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}