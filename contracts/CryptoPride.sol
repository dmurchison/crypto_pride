// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.7;

contract CryptoPride {
    // owner Lion
    address owner;

    constructor(){
        owner = msg.sender;
    }

    // define Cub
    struct Cub {
        address payable walletAddress;
        string firstName;
        string lastName;
        uint releaseTime;
        uint amount;
        bool canWithdraw;
    }

    Cub[] public cubs;

    // add Cub to contract
    // 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2, "Jane", "Doe",  1659115824, 0, false
    // 0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db, "Jim", "Doe",  1659116484, 0, false
    function addCub(address payable walletAddress, string memory firstName, string memory lastName, uint releaseTime, uint amount, bool canWithdraw) public {
        cubs.push(Cub(
            walletAddress,
            firstName,
            lastName,
            releaseTime,
            amount,
            canWithdraw
        ));
    }

    function balanceOf() public view returns(uint) {
        return address(this).balance;
    }

    // deposit funds to contract, specifically to a Cubs account
    function deposit(address walletAddress) payable public {
        addToCubsBalance(walletAddress);
    }

    function addToCubsBalance(address walletAddress) private {
        for(uint i = 0; i < cubs.length; i++) {
            if(cubs[i].walletAddress == walletAddress) {
                cubs[i].amount += msg.value;
            }
        }
    }

    function getIndex(address walletAddress) view private returns(uint) {
        for(uint i = 0; i < cubs.length; i++) {
            if(cubs[i].walletAddress == walletAddress) {
                return i;
            }
        }
        return 100;
    }

    // Cub checks if able to withdraw
    function ableToWithdraw(address walletAddress) public returns(bool) {
        uint i = getIndex(walletAddress);
        if (block.timestamp > cubs[i].releaseTime) {
            cubs[i].canWithdraw = true;
            return true;
        } else {
            return false;
        }
    }

    // withdraw money
    function withdraw(address payable walletAddress) payable public {
        uint i = getIndex(walletAddress);
        cubs[i].walletAddress.transfer(cubs[i].amount);
    }
}
