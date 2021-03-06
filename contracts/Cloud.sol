//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Ownable.sol";
import "./AddressCloud.sol";

contract Cloud is Ownable {

    constructor() Ownable(msg.sender, address(this)) {

    }
    
    mapping(address => address) public ownerToContract;

    function createAddressCloud () public payable returns (address) {
        AddressCloud addressCloud = new AddressCloud(address(this));
        address contractAddress = address(addressCloud);
        ownerToContract[msg.sender] = contractAddress;

        (bool success,) = contractAddress.call{value: msg.value}(
            abi.encodeWithSignature("transferOwnership(address)", msg.sender)
        );

        return contractAddress;
    }

    error CloudAddressNotFound(address sender);

    function getOwnerAddressCloud () public view returns (address) {
        return ownerToContract[msg.sender];
    }

    function transferOwnership (address newOwner) public payable returns (bool){
        address ownerContract = ownerToContract[msg.sender];

        ownerToContract[msg.sender] = address(0);

        (bool success,) = ownerContract.call{value: msg.value}(
            abi.encodeWithSignature("transferOwnership(address)", newOwner)
        );

        return success;
    }

}
