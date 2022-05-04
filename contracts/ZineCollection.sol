// contracts/MyNFT.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

// contract MyNFT is ERC721PresetMinterPauserAutoId {
//     constructor() ERC721PresetMinterPauserAutoId("ZineCoin", "ZC", "http://localhost:3000/"){}
//      function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
//      return string(abi.encodePacked(super.tokenURI(tokenId),".json"));
//   }
// }

contract ZineCollection is ERC1155 {

  struct Magazine  {
    uint256 id;
    bool isOnSale;
    string title;
    string content;
    uint256 price;
  }

  Magazine[]  public magazines;
  mapping(address => magazines) public magazineById;

  string public name;
  string public symbol;
  uint256 public tokenCount;
  string public baseUri;

  constructor(string memory _name, string memory _symbol, string memory _baseUri) ERC1155(_baseUri){
    name = _name;
    symbol = _symbol;
    _baseUri = _baseUri;
  }

  function mint(uint256 amount) public {
    tokenCount += 1;
    _mint(msg.sender, tokenCount, amount, "");
  }

  function addNewMagazine(
    bool isOnSale, 
    string memory title, 
    string memory content,
    uint256 price
    ) public {
    Magazine memory magazine = Magazine(tokenCount + 1,isOnSale, title, content, price);
    magazineById[msg.sender].push(magazine);
    // magazineById[msg.sender][tokenCount].id = tokenCount;
    // magazineById[msg.sender][tokenCount].isOnSale = isOnSale;
    // magazineById[msg.sender][tokenCount].title = title;
    // magazineById[msg.sender][tokenCount].content = content;
    // magazineById[msg.sender][tokenCount].price = price;
    
  }

  function buyMagazine(uint256 index, address owner) payable public {
    require(magazineById[owner][index].price <= msg.value);
    uint256 id = magazineById[owner][index].id;
    _safeTransferFrom(owner, msg.sender, id, 1, "");
  }

  function setToUnSale(uint256 id) public{
    magazineById[msg.sender][id].isOnSale = false;
  }

  function setToSale(uint256 id) public {
    magazineById[msg.sender][id].isOnSale = true;
  }

  function changePrice(uint256 price, uint256 id) public {
    magazineById[msg.sender][id].price = price;
  }

  function uri(uint256 _tokenId) override public view returns(string memory){
    return string(
      abi.encodePacked(
        baseUri,
        Strings.toString(_tokenId),
        ".json"
      )
    );
  }

  function getMagazines() public view returns(Magazine[] memory){
    return magazines;
  }
}