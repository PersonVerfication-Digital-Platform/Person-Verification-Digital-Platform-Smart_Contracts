// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract AuthVerifier{

    struct Services{
        address owner;
        bool accountCreation;
        bool bankLaon;
        bool cardRequest;
    }

    mapping (address => bool) public verifierExist;
    address[] public verifiers;
    mapping (address => Services) public eligibleServices;

    modifier eligible {
        require(verifierExist[msg.sender], "Not an Eligible verifier");
        _;
    }

    modifier onlyOwner {
        require(eligibleServices[msg.sender].owner == msg.sender, "Access Denied!");
        _;
    }

    function addVerifier(bool _accountCreation, bool _bankLoan, bool _cardRequest) external {

        require (!verifierExist[msg.sender], "User already exist");
        verifiers.push(msg.sender);
        verifierExist[msg.sender] = true;

        eligibleServices[msg.sender].owner = msg.sender;

        if(_accountCreation){
            eligibleServices[msg.sender].accountCreation = _accountCreation;
        }
        
        if(_bankLoan){
            eligibleServices[msg.sender].bankLaon = _bankLoan;
        }
        
        if(_cardRequest){
             eligibleServices[msg.sender].cardRequest = _cardRequest;
        }
       

    }

    function getVerifierExist() external view returns(bool){
        return verifierExist[msg.sender];
    }   


    function updateServices(bool _accountCreation, bool _bankLoan, bool _cardRequest) external eligible onlyOwner {

        if(eligibleServices[msg.sender].accountCreation != _accountCreation){
            eligibleServices[msg.sender].accountCreation = _accountCreation;
        }

        if(eligibleServices[msg.sender].bankLaon != _bankLoan){
            eligibleServices[msg.sender].bankLaon = _bankLoan;
        }

        if(eligibleServices[msg.sender].cardRequest != _cardRequest){
            eligibleServices[msg.sender].cardRequest = _cardRequest;
        }

        

    }

    function isAccountCreationVerifiable (address _address) view external returns(bool){
        return eligibleServices[_address].accountCreation;
    }

    function isBankLaonVerifiable (address _address) view external returns(bool){
        return eligibleServices[_address].bankLaon;
    }

    function isCardRequestVerifiable (address _address) view external  returns(bool){
        return eligibleServices[_address].cardRequest;
    }


}