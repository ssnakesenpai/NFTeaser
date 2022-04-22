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
    }

    // struct for LoanInit




    mapping(uint => loan) loans;

    function createLoan(address lender, uint _colat, uint _loanAmount, uint maxLoanLength) public payable {

    }

    function loanOut() payable {
        require(msg.value >= _colat + _loanAmount,"not enough colateral");
        // require requested loanlength < max loan length
        // record loan details
        // transfer the NFT
        // start timer
    

    }

}
