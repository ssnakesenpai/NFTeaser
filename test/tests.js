const { expect } = require("chai");
const { Signer } = require("ethers");
const { ethers } = require("hardhat");

describe("LendNft", function () {

  let lending;
  let nftm; 
  let nftid;
  let acc_add;
  let acc_other;
  let loansactive=[];

  beforeEach(async() => {
    const Lending = await ethers.getContractFactory("LendNft");
    const Nftm = await ethers.getContractFactory("NFTMint");
    
    nftm = await Nftm.deploy();
    lending = await Lending.deploy();

    //acc_add='0x34Ad68800452563374f800932148433e83632fee';
    nftid=1;
    
    [deployer, acc_other] = await ethers.getSigners();
    acc_add=deployer.address;
    acc_other=acc_other.address;

  console.log("Deploying contracts with the account:", deployer.address);
  });
  it("Should be able to receive NFTs", async function () {
    
    await nftm.safeMint(lending.address, 0);
    // Send NFT - get balance 
    console.log()
    expect(await nftm.balanceOf(lending.address)).to.equal(1);
  });

  it("Should be able to create and cancel a loan offer", async function () {
    //Mint + Approve
    await nftm.safeMint(acc_add, nftid);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    


    //Lend out NFT
    await nftm.approve(lending.address, nftid);
    await lending.createLoanOffer(nftm.address, nftid,10, 20, 100);    
    
    expect(await nftm.ownerOf(nftid)).to.equal(lending.address);
    console.log('NFT Owner:' + await nftm.ownerOf(nftid));
    console.log('Contract Address:' + lending.address);
    
    //Cancel the offer
    await lending.cancelLoanOffer(0);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT Owner:' + await nftm.ownerOf(nftid));
    console.log('Contract Address:' + lending.address);

  });

  it("Should be able to create and cancel a loan offer", async function () {
    //Mint + Approve
    await nftm.safeMint(acc_add, nftid);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT Minted and Owner should be account' + await nftm.ownerOf(nftid));
    
    //Lend out NFT
    await nftm.approve(lending.address, nftid);
    await lending.createLoanOffer(nftm.address, nftid,10, 20, 100);    
    expect(await nftm.ownerOf(nftid)).to.equal(lending.address);
    console.log('NFT lent out and owner should be ' + await nftm.ownerOf(nftid));

  });

  it("Should be able to borrow", async function () {
    //Mint + Approve
    await nftm.safeMint(acc_add, nftid);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT Minted and Owner should be account' + await nftm.ownerOf(nftid));
    
    //Lend out NFT
    await nftm.approve(lending.address, nftid);
    await lending.createLoanOffer(nftm.address, nftid,10, 20, 100);    
    expect(await nftm.ownerOf(nftid)).to.equal(lending.address);
    console.log('NFT lent to protocol and owner should be ' + await nftm.ownerOf(nftid));

        
  });

  it("Should be able to match the loan offer", async function () {
    //Mint + Approve
    await nftm.safeMint(acc_add, nftid);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT Minted and Owner should be account' + await nftm.ownerOf(nftid));
    
    //Lend out NFT
    await nftm.approve(lending.address, nftid);
    await lending.createLoanOffer(nftm.address, nftid,10, 20, 100);    
    await lending.takeLoan(0, {value: 30});
    

        
  });

  // it("Should be able to match the loan offer", async function () {
  //   //Mint + Approve
  //   for(let i=0; i<10; i++) { 
  //   await nftm.safeMint(acc_add, nftid);
  //   expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
  //   console.log('NFT Minted and Owner should be account' + await nftm.ownerOf(nftid));
    
  //   //Lend out NFT
  //   await nftm.approve(lending.address, nftid);
  //   await lending.createLoanOffer(nftm.address, nftid,10, 20, 100);    
  //   await lending.takeLoan(i, {value: 30});
  //   nftid++;
  // }

  // loansactive=[]
  // for(let i=1; i<10; i++) {
  //   x=await lending.loans(i)  
  //   loansactive.push(x.active);
  // }

  // console.log(loansactive);
  // await lending.liquidateLoan();
  // await new Promise(r => setTimeout(r, 2000));
  
  // loansactive=[]
  // for(let i=1; i<10; i++) {
  //   x=await lending.loans(i) 
    
  //   loansactive.push(x.active);
  // }

  // console.log(loansactive);
        
  // });

  it("Should be able to repay the loan offer", async function () {
    //Mint + Approve
    await nftm.safeMint(acc_add, nftid);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT Minted and Owner should be account' + await nftm.ownerOf(nftid));
    
    //Lend out NFT
    await nftm.approve(lending.address, nftid);
    await lending.createLoanOffer(nftm.address, nftid,10, 20, 100);    

    console.log('NFT loaned and should be contract' + await nftm.ownerOf(nftid));
    await lending.takeLoan(0, {value: 30});
    console.log('NFT borrowed and should be account' + await nftm.ownerOf(nftid));

    await nftm.approve(lending.address, nftid);
    await lending.repayLoan(0);
    console.log('NFT repaid and should be account' + await nftm.ownerOf(nftid));

        
  });

});
