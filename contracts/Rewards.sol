// SPDX-License-Identifier: GPL-3.0-or-later
pragma solidity ^0.8.17;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

// viewable at: https://testnets.opensea.io/assets/goerli/CONTRACT_ID/REWARD_ID
contract Rewards is ERC1155 {
  
  // all available rewards as IDs
  uint256 public constant REWARD_FIRST_USE = 1;

  // owner of this contract
  address public owner;

  // create a reward instance
  constructor()
    ERC1155("https://storage.googleapis.com/vapps-public/other-nft/smarty-park/{id}.json") 
    {
      owner = msg.sender;
  }
  modifier _ownerOnly() {
      require(msg.sender == owner);
      _;
  }

  // opensea will use this as the contract's name
  function name() public pure returns (string memory) {
    return "Smarty Park Rewards";
  }

  // award a first time use
  function rewardFirstTimeUse(address _to) public _ownerOnly {
    _mint(_to, REWARD_FIRST_USE, 1, "");
  }
}