const { expect } = require("chai");
const { Signer } = require("ethers");
const { ethers } = require("hardhat");

describe("LendNft", function () {

  let lending;
  let nftm; 

  beforeEach(async() => {
    const Lending = await ethers.getContractFactory("LendNft");
    const Nftm = await ethers.getContractFactory("NFTMint");
    
    nftm = await Nftm.deploy();
    lending = await Lending.deploy();

    
    // await lending.deployed();
    console.log(lending.address);
  });
  it("Should be able to receive NFTs", async function () {
    // expect(await lending.NFTMint()).to.equal("0x0B5B16b8BCEC942BB943825F47Dd449a571485A2");
    
    await nftm.safeMint(lending.address, 1);
    // Send NFT - get balance 
    expect(await nftm.balanceOf(lending.address)).to.equal(1);

  });

  it("Should be create a loan offer", async function () {
    // (address _nft, uint _id, address _lender, uint _fee, uint _collateral, uint _length, uint _expiry)
    await lending.createLoanOffer('0x0B5B16b8BCEC942BB943825F47Dd449a571485A2', 1, '0x0B5B16b8BCEC942BB943825F47Dd449a571485A2',1,10, 20, 100);
    // console.log(await lending.loanOffers(1))
    await lending.createLoanOffer('0x0B5B16b8BCEC942BB943825F47Dd449a571485A2', 1, '0x0B5B16b8BCEC942BB943825F47Dd449a571485A2',1,10, 20, 100);
    
    await lending.updateActiveOffers();
    offers=await lending.getActiveOffers();
    
    console.log(offers);

    //await lending.createLoanOffer('0x0B5B16b8BCEC942BB943825F47Dd449a571485A2', 1, '0x0B5B16b8BCEC942BB943825F47Dd449a571485A2',1,10, 20, 100);
    // const loans = await lending.loanOffers()
    //console.log(await lending.getActiveOffers());
    
  });
    

});
