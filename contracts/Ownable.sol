//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Ownable {
    address private _owner;
    address public _cloudAddress;

    constructor(address owner, address cloudAddress) {
        _owner = owner;
        _cloudAddress = cloudAddress;
    }

    event OwnershipTransfer (address indexed newOwner, address indexed oldOwner);

    error Unauthorized(address sender);

    modifier onlyOwner () {
        if(msg.sender == _owner || msg.sender == _cloudAddress) {
            _;
        } else {
            revert Unauthorized(_owner);
        }
    }

    function _transferOwnership (address newOwner) public onlyOwner returns (address){
        address oldOwner = _owner;
        _owner = newOwner;

        emit OwnershipTransfer(msg.sender, oldOwner);

        return newOwner;
    }
}
