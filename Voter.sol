// SPDX-License-Identifier: Apache-2.0

/**
 * @author Spyridon Ninos, 3232020022
 * 
 * this contract models a voter for the e-voting system implemented
 * by the Referendum contract
 */
pragma solidity ^0.8.4;

contract Voter {
    // made public so that the getters are defined implicitly
    string public firstName;
    string public lastName;
    
    // reference to the Referendum deployed contract
    Referendum referendum;
    
    constructor(string memory _firstName, string memory _lastName) {
        firstName = _firstName;
        lastName = _lastName;
    }
    
    
    /**
     * registers the voter to the provided referendum
     * 
     * _referendumAddress: the address of the deployed referendum contract
     */
    function register(address _referendumAddress) public {
        referendum = Referendum(_referendumAddress);
        referendum.register();
    }
    
    
    /**
     * utility method that votes yes to the referendum
     */
    function voteYes() public {
        referendum.vote(true);
    }
    
    
    /**
     * utility method that votes no to the referendum
     */
    function voteNo() public {
        referendum.vote(false);
    }
}

/**
 * required by the Voter contract in order to register and vote
 */
contract Referendum {
    function register() public {}
    function vote(bool _value) public {}
}
