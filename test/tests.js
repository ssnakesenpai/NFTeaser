const { expect } = require("chai");
const { Signer } = require("ethers");
const { ethers } = require("hardhat");

describe("LendNft", function () {

  let lending;
  let nftm; 
  let nftid;
  let acc_add;

  beforeEach(async() => {
    const Lending = await ethers.getContractFactory("LendNft");
    const Nftm = await ethers.getContractFactory("NFTMint");
    
    nftm = await Nftm.deploy();
    lending = await Lending.deploy();

    acc_add='0x34Ad68800452563374f800932148433e83632fee';
    nftid=1;
    // await lending.deployed();
    console.log(lending.address);

    const [deployer] = await ethers.getSigners();
    acc_add=deployer.address;

  console.log("Deploying contracts with the account:", deployer.address);
  });
  it("Should be able to receive NFTs", async function () {
    
    await nftm.safeMint(lending.address, 0);
    // Send NFT - get balance 
    expect(await nftm.balanceOf(lending.address)).to.equal(1);
  });

  it("Should be able to create and cancel a loan offer", async function () {
    //Mint + Approve
    await nftm.safeMint(acc_add, nftid);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT Minted and Owner should be account' + await nftm.ownerOf(nftid));
    
    //Lend out NFT
    await nftm.approve(lending.address, nftid);
    await lending.createLoanOffer(nftm.address, nftid, acc_add,1,10, 20, 100);    
    expect(await nftm.ownerOf(nftid)).to.equal(lending.address);
    console.log('NFT lent out and owner should be ' + await nftm.ownerOf(nftid));
    
    //Cancel the offer
    await lending.cancelLoanOffer(0);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT lend out cancelled and now NFT should be returned ' + await nftm.ownerOf(nftid));

  });

  it("Should be able to create and cancel a loan offer", async function () {
    //Mint + Approve
    await nftm.safeMint(acc_add, nftid);
    expect(await nftm.ownerOf(nftid)).to.equal(acc_add);
    console.log('NFT Minted and Owner should be account' + await nftm.ownerOf(nftid));
    
    //Lend out NFT
    await nftm.approve(lending.address, nftid);
    await lending.createLoanOffer(nftm.address, nftid, acc_add,1,10, 20, 100);    
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
    await lending.createLoanOffer(nftm.address, nftid, acc_add,1,10, 20, 100);    
    expect(await nftm.ownerOf(nftid)).to.equal(lending.address);
    console.log('NFT lent to protocol and owner should be ' + await nftm.ownerOf(nftid));


  });

});
