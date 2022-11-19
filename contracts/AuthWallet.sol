// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;


contract AuthWallet{

    struct Wallet{
        address owner;
        string personalDetails;
        string[] approvedBanks;
        string[] rejectedBanks;
        bool digitalIdCreated;
        string currentVerifier;

    }
    
    mapping (address => bool) public isCreated; // lookup table of wallets
    mapping (address => Wallet) public wallet_list;

    modifier onlyOwner {
        require(isCreated[msg.sender], "User does not exist"); 
        require(wallet_list[msg.sender].owner == msg.sender, "Access denied");  //normally this condition can never be rejected
        _;
    }

    modifier withDigitalId {
        require(wallet_list[msg.sender].digitalIdCreated , "No digital ID");  
        _;
    }

    function createWallet () external{

        
        require(!isCreated[msg.sender], "User already exist");

        isCreated[msg.sender] = true ;
        wallet_list[msg.sender].owner =  msg.sender;

    }


    function setPersonalDetails(string memory _personalDetails) external onlyOwner{


        wallet_list[msg.sender].personalDetails = _personalDetails;
        wallet_list[msg.sender].digitalIdCreated = true ;

    }

    function approveBank (string memory _bankId) external onlyOwner withDigitalId{
             
        wallet_list[msg.sender].approvedBanks.push(_bankId);
        wallet_list[msg.sender].currentVerifier = _bankId;
        
    }

    function rejectBank (string memory _bankId) external onlyOwner withDigitalId{
             
        wallet_list[msg.sender].rejectedBanks.push(_bankId);
        
    }

    function sendCreadentials() external view onlyOwner withDigitalId returns(string memory){
        return  wallet_list[msg.sender].personalDetails;    
    }

    
    function proceedVerification(address wallet_owner,string memory _bankId, string memory _authHash) external returns(bool){
        if(keccak256(abi.encodePacked(wallet_list[wallet_owner].currentVerifier)) == keccak256(abi.encodePacked(_bankId))){
             wallet_list[msg.sender].currentVerifier = "";
            return keccak256(abi.encodePacked(wallet_list[wallet_owner].personalDetails)) == keccak256(abi.encodePacked(_authHash));

        }else{
            return false;
        }
    }


}