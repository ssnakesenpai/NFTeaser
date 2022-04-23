
//SPDX-License-Identifier: Unlicense
pragma solidity 0.8.1;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";

contract LendNft is IERC721Receiver {
    // Contract will be defined by two different structures: 
    // loanOffer  defines parameters that the lender sets with respective NFT info
    // loan defines the loan that's taken along with it's state
    // loanOffer and loan both accessed through a mapping from loanOfferId and loanID  
    // Structure for Loan Offer
    event loanCreated(address _loanCreator, address _nftAddress, uint NftID, uint _loanFee, uint _colateralAmount,  uint _lengthInDays);
    
    address owner;
    mapping(uint => bool) loanActive;

    struct _loanOffer {
        bool active;
        address nftContract;
        uint nftID;
        address lender;
        uint loanFee;
        uint loanCollateral;
        uint loanLength;
        uint loanExpiry;
        uint offerTime;
        }
    

    struct _loan {
        bool active;
        uint loanOfferID;
        _loanOffer loanOffer;
        address borrower;
        uint borrowTime;
        uint returnTime;
        address _lender;
        uint loanCollateral;
    }

    constructor() {
        owner = msg.sender;
    }

    // loanOfferID and loanID that starts at 0. ++ each time a new offer is put up
    uint public loanOfferID;
    uint public loanID;

    uint public timeMultiplier=1;

    // Mappings from loanOfferID to respective loan
    mapping(uint => _loanOffer) public loanOffers;
    mapping(uint => _loan) public loans;
    
    // Array of activeOffers - getter function will return an array of activeOfferIDs. 
    // Getter function is getActiveOffers(). Needs to updated with updateActiveOffers()
    uint[] public activeOffers;
    
    function createLoanOffer(address _nft, uint _id, uint _fee, uint _collateral, uint _lengthInDays ) public payable { 
        //Requires NFT approval
        IERC721(_nft).transferFrom(msg.sender, address(this), _id);
        loanOffers[loanOfferID]=_loanOffer(true, _nft, _id, msg.sender , _fee, _collateral, _lengthInDays, block.timestamp + (_lengthInDays * timeMultiplier) , block.timestamp);
        
        emit loanCreated(msg.sender,_nft,_id,_fee,_collateral,_lengthInDays);
        
        //receive NFT 
        loanOfferID++;
    }



    function cancelLoanOffer(uint _loanOfferID) public payable { 
        //Needs that the sender is loanoffer owner and that it's still active
        require(loanOffers[_loanOfferID].lender==msg.sender,"not owner of loan");
        require(loanOffers[_loanOfferID].active==true,"loan not active");
        //Transfer NFT from contract address to message sender
        loanOffers[_loanOfferID].active=false;
        IERC721(loanOffers[_loanOfferID].nftContract).transferFrom(address(this),msg.sender, loanOffers[_loanOfferID].nftID);
    }



    function takeLoan(uint _loanOfferID) public payable { 
        require(msg.value == loanOffers[_loanOfferID].loanCollateral + loanOffers[_loanOfferID].loanFee,"Did not send enough Colat+fee");
        require(loanActive[loanID] == false,"loan already Active!");
        //Send NFT 
        IERC721(loanOffers[_loanOfferID].nftContract).transferFrom(address(this),msg.sender, loanOffers[_loanOfferID].nftID);
        //Make loanOffer active = F 
        loanOffers[loanID].active=false;

        //Add active loan
        loanActive[loanID] = true;
        loans[loanID]=_loan(true, _loanOfferID, loanOffers[_loanOfferID], msg.sender, block.timestamp, block.timestamp + (loanOffers[_loanOfferID].loanLength * timeMultiplier),loanOffers[loanID].lender, loanOffers[loanID].loanCollateral);
        loanID++;

    }


    function liquidateLoan() external payable {
        for(uint i; i<loanID; i++) { 
            //require(msg.sender == owner,"not owner"); < Do we need owner here? 
            require(loanActive[i] == true,"loan not active");
            require(block.timestamp > loans[i].returnTime,"not time to liquidate");
            loanActive[i] = false;
            loans[i].active=false;
            payable(loans[i]._lender).transfer(loans[i].loanCollateral);
        }
    }

    function repayLoan(uint _loanID) public payable {
       require(loans[_loanID].active==true);
       require(loans[_loanID].borrower==msg.sender);
       //Receive NFT from msg sender
       IERC721(loans[_loanID].loanOffer.nftContract).transferFrom(msg.sender, address(this), loans[_loanID].loanOffer.nftID);
       
       //Repay the collateral
       payable(loans[_loanID]._lender).transfer(loans[_loanID].loanCollateral);

       //Send NFT back to owner
       IERC721(loans[_loanID].loanOffer.nftContract).transferFrom(address(this), loanOffers[_loanID].lender , loans[_loanID].loanOffer.nftID);
    }

    
    // Receive ERC721 
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

}