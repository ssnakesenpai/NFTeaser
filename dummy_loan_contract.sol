// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract LendNft {

    struct loanOffer {
        address nftContract;
        address lender;
        address borrower;
        uint nftID;
        uint loanPrice;
        uint Colat;
        uint maxLoanLength;
        enum loanStatus {"offered","loanedOut","loanSettled"};
        uint loanExpiry;
    }

    // struct for LoanAgreed

    mapping (address => bool) blacklist;

    struct loanAgreed{
        address borrower;
        address lender;
        address nftContract;
        uint nftID;
        uint loanlength;
        uint loanExpiry;
        uint collateralAmount;
        uint loanFee;
    }

    mapping(uint => loan) loans;

    function createLoan(uint _colat, uint _loanPrice, uint _maxLoanLength,) public payable {
        loanOffer storage loan = loanOffer(_nft)
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

    function liquidateLoan() external {
        // close loan
    }

    function repayLoan() payable {
        // mark complete
        // receives the NFT
        // returns collateral
    }


    // can we farm collateral?
    // 

}
    }

    function liquidateLoan() external {
        // close loan
    }

    function repayLoan() payable {
        // mark complete
        // receives the NFT
        // returns collateral
    }

    // can we farm collateral?
    // 

}
