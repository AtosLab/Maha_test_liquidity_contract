//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DummyToken is ERC20, Ownable {
    mapping(address => bool) public minters;

    constructor(string memory name_, string memory symbol_) ERC20(name_, symbol_) {}

    function mint(address _account, uint256 _amount) external {
        require(minters[msg.sender], "Invalid minter");
        _mint(_account, _amount);
    }

    function burn(address _account, uint256 _amount) external {
        require(minters[msg.sender], "Invalid minter");
        _burn(_account, _amount);
    }

    function setMinter(address _account, bool _isMinter) external onlyOwner {
        minters[_account] = _isMinter;
    }
}