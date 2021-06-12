// SPDX-License-Identifier: Apache-2.0

/**
 * @author Spyridon Ninos, 3232020022
 * 
 * this contract models an e-voting system, specifically a referendum,
 * to which we can vote yes or no
 */
pragma solidity ^0.8.4;

contract Referendum {
    
    /**
     * models a voter
     */
    struct VoterDetails {
        string firstName;
        string lastName;
        uint pNo; // priority number, is the special weight of the voter's vote
        address voterAddress;
        bool hasVoted;
    }
    
    address owner;
    
    /*
     * the following 3 variables are made public only for demonstration purposes,
     * i.e. in order to examine their values during execution
     */
    address[] public applicants;
    address[] public registeredVoterAddresses;
    mapping(address => VoterDetails) public registeredVoters;
    
    /*
     * the following counters hold the current status of the referendum (i.e. how
     * many people have registered, how many votes were given to yes etc)
     * they are publicly accessible
     */
    uint public yes;
    uint public no;
    uint public totalVoters;
    
    
    constructor() {
        owner = msg.sender;
        yes = 0;
        no = 0;
        totalVoters = 0;
    }
    
    
    /**
     * registers a voter to the referendum
     * before a voter can vote, the registration should be approved
     * by the referendum's owner
     */
    function register() public {
        if (alreadyRegistered(msg.sender) == true) {
            return;
        }
        
        applicants.push(msg.sender);
    }
    
    
    /**
     * registers a vote
     * 
     * _value: true or false
     */
    function vote(bool _value) public {

        /*
         * don't allow a non-registered person to vote
         */
        if (alreadyRegistered(msg.sender) == false) {
            return;
        }
        
        /*
         * don't allow a voter to vote more than once
         */
        if (registeredVoters[msg.sender].hasVoted == true) {
            return;
        }
        
        if (_value == true) {
            yes += registeredVoters[msg.sender].pNo;
        } else {
            no += registeredVoters[msg.sender].pNo;
        }
        
        registeredVoters[msg.sender].hasVoted = true;
    }
    
    
    /**
     * approves the registraion application made by an applicant
     * the approval also requires the priority number to be set for the specific applicant
     * 
     * _pNo: an integer >= 0 (basically, 0 has no meaning, but we allow it for simplicity)
     * 
     * @dev NOTE: only the owner of the referendum should be able to approve registration applications
     */
    function approveRegistration(address _applicantAddress, uint _pNo) public ownerOnly {
        
        // don't re-register voters
        if (alreadyRegistered(_applicantAddress) == true) {
            return;
        }
        
        // delete the voter from the applicants' array
        for (uint i=0; i<applicants.length; i++) {
            if (applicants[i] == _applicantAddress) {
                delete applicants[i];
            }
        }
        
        // populate the voter's details
        VoterDetails memory details = VoterDetails({
            firstName: Voter(_applicantAddress).firstName(), 
            lastName: Voter(_applicantAddress).lastName(), 
            pNo: _pNo, 
            voterAddress: _applicantAddress, 
            hasVoted: false
        });
        
        // store the approved voter and set the proper counters accordingly
        registeredVoterAddresses.push(_applicantAddress);
        registeredVoters[_applicantAddress] = details;
        totalVoters++;
    }
    
    
    /**
     * classic modifier checking for owner only functionality
     */
    modifier ownerOnly() {
        require(msg.sender == owner, "Not Authorized");
        _;
    }
    
    
    /**
     * checks for an address if it's already registered with the referendum
     */
    function alreadyRegistered(address _voterAddress) private view returns(bool) {
        for (uint i=0; i<registeredVoterAddresses.length; i++) {
            if (registeredVoterAddresses[i] == _voterAddress) {
                return true;
            }
        }
        return false;
    }
    
}

/**
 * required for the Referendum contract to get each voter's first and last names
 */
contract Voter {
    function firstName() public view returns(string memory) {}
    function lastName() public view returns(string memory) {}
}
