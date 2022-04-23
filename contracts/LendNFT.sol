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
    uint loanOfferID;
    _loanOffer loanOffer;
    address borrower;
    uint borrowTime;
    uint returnTime;
    }

    // loanOfferID and loanID that starts at 0. ++ each time a new offer is put up
    uint public _loanOfferID;
    uint public _loanID;

    // Mappings from loanOfferID to respective loan
    mapping(uint => _loanOffer) public loanOffers;
    mapping(uint => _loan) public loans;
    
    // Array of activeOffers - getter function will return an array of activeOfferIDs. 
    // Getter function is getActiveOffers(). Needs to updated with updateActiveOffers()
    uint[] public activeOffers;

    function createLoanOffer(address _nft, uint _id, address _lender, uint _fee, uint _collateral, uint _length, uint _expiry) public payable { 
        loanOffers[_loanOfferID]=loanOffer(true, _nft, _id,_lender, _fee, _collateral, _length, _expiry, now); 
        //receive NFT 
        _loanOfferID++;
    }

    // Function to update the activeOffers array that returns the loanIDs
    function updateActiveOffers() public { 
        delete activeOffers;
        for(uint i=0; i<_loanOfferID; i++) { 
            require(loanOffers[i].active==true); 
            activeOffers.push(i);
        }
    }

    // Getter function for active offers
    function getActiveOffers() public view returns(uint[] memory) { 
        return activeOffers;
    }

     function InitLoan() payable {
        require(msg.value >= _colat + _loanAmount,"not enough colateral");
        // require requested loanlength < max loan length
        // record loan details
        // transfer the NFT
        // start timer
        // takes cut from LoanFee
        // pay remainder LoanFee to lender
    }

    // function createLoan(address lender, uint _colat, uint _loanAmount, uint maxLoanLength) public payable {
    //     loanOffer memory loan = loanOffer(_nft)
    // }



    // function liquidateLoan() external {
    //     // close loan
    // }

    // function repayLoan() payable {
    //     // mark complete
    //     // receives the NFT
    //     // returns collateral
    // }

    // // can we farm collateral?
    // // 

    
    // Receive ERC721 
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }

}