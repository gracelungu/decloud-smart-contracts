//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Ownable.sol";
import "./AddressCloud.sol";

contract Cloud is Ownable {

    constructor() Ownable(msg.sender, address(this)) {

    }
    
    mapping(address => address) public ownerToContract;

    function createAddressCloud () public returns (address) {
        AddressCloud addressCloud = new AddressCloud(address(this));
        address contractAddress = address(addressCloud);
        ownerToContract[msg.sender] = contractAddress;

        return contractAddress;
    }

    error CloudAddressNotFound(address sender);

    modifier hasAddressCloud() {
        if(ownerToContract[msg.sender] == address(ownerToContract[msg.sender])) {
            revert CloudAddressNotFound(msg.sender);
        }
        _;
    }

    function getOwnerAddressCloud (address contractAddress) public hasAddressCloud view returns (address) {
        return ownerToContract[contractAddress];
    }

    function transferOwnership (address newOwner) public payable returns (bool){
        address ownerContract = ownerToContract[msg.sender];

        (bool success,) = ownerContract.call{value: msg.value}(
            abi.encodeWithSignature("transferOwnership(address)", newOwner)
        );

        return success;
    }

}
