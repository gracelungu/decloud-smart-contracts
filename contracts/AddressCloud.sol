//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./Ownable.sol";

contract AddressCloud is Ownable {
    
    struct File {
        string name;
        string uri;
        string fileType;
        uint timestamp;
    }

    string[] private types;
    mapping(string => string[]) private typesToFileNames;
    mapping(string => mapping(string => File)) private typesToFiles;

    constructor(address cloudAddress) Ownable(msg.sender, cloudAddress) {
        types = ["photo", "video", "contact"];
    }

    function transferOwnership (address newOwner) public {
        Ownable._transferOwnership(newOwner);
    }

    error InvalidValue(string value);

    modifier hasValue(string memory value){
        if(bytes(value).length < 1){
            revert InvalidValue(value);
        }
        _;
    }

    function createFileType(string memory fileType) public onlyOwner hasValue(fileType) returns (string memory) {
        types.push(fileType);
        return fileType;
    }

    function getFileTypes() public onlyOwner view returns (string[] memory) {
        return types;
    }

    error InvalidType(string fileType);

    modifier typeExists(string memory fileType, bool shouldExists){
        bool exists = false;
        for(uint i = 0; i < types.length; i++){
            if(keccak256(abi.encodePacked((types[i])))  ==  keccak256(abi.encodePacked((fileType)))){
                exists = true;
            }
        }
        if(!exists && shouldExists){
            revert InvalidType(fileType);
        }

        if(exists && !shouldExists){
            revert InvalidType(fileType);
        }

        _;
    }

    function getFiles(string memory fileType) public view onlyOwner typeExists(fileType, true) returns (File[] memory) {
        File[] memory files = new File[](typesToFileNames[fileType].length);
        for(uint i = 0; i < typesToFileNames[fileType].length; i++){
            files[i] = typesToFiles[fileType][typesToFileNames[fileType][i]];
        }

        return files;
    }

    function createFiles (string memory fileType, File[] memory files) public onlyOwner typeExists(fileType, true) returns (uint) {
        for(uint i = 0; i < files.length; i++){
            files[i].timestamp = block.timestamp;
            typesToFiles[fileType][files[i].name] = files[i];
            typesToFileNames[fileType].push(files[i].name);
        }

        return files.length;
    }

    function createTypeAndFiles (string memory fileType, File[] memory files) public onlyOwner typeExists(fileType, false) returns (uint) {
        types.push(fileType);
        createFiles(fileType, files);
        return files.length;
    }

    function deleteFiles(string memory fileType, File[] memory files) public onlyOwner typeExists(fileType, true) {
        for(uint i = 0; i < files.length; i++){
            if(keccak256(abi.encodePacked((typesToFileNames[fileType][i])))  == keccak256(abi.encodePacked((files[i].name))) ){
                delete typesToFileNames[fileType][i];
            }
        }
    }

    function deleteType(string memory fileType) public onlyOwner typeExists(fileType, true) {
        for(uint i; i< types.length; i++){
            if(keccak256(abi.encodePacked((types[i])))  ==  keccak256(abi.encodePacked((fileType)))){
                delete types[i];
            }
        }
    }

}
