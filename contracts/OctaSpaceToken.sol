// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract OctaSpaceToken is Ownable, ERC20 {
    constructor(uint256 initialSupply, address initialOwner) ERC20("OctaCoin", "OCTA") Ownable(initialOwner) {
        _mint(msg.sender, initialSupply * (10 ** uint256(decimals())));
    }
}
