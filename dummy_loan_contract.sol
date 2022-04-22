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
        uint loanLength
        enum loanStatus {"offered","loanedOut","loanSettled"};
        uint loanExpiry;
    }

    // struct for LoanInitiate

    mapping(uint => loan) loans;

    function createLoan(address lender, uint _colat, uint _loanAmount, uint maxLoanLength) public payable {
        loanOffer memory loan = loanOffer(_nft)

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
