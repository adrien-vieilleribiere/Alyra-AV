const MyToken = artifacts.require("./MyToken.sol");
const { BN, expectRevert, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');


contract("MyToken", accounts => {
    const _name = "Alyra"
    const _symbol = "ALY"
    const _initialSupply = new BN(10000);
    const _approveAmount = new BN(42);
    const _transfertFromAmount = new BN(10);
    const _owner = accounts[0];
    const _user1 = accounts[1];
    const _user2 = accounts[2];
    const _decimal = new BN(18);

    let MyTokenInstance;

    beforeEach(async function () {
        MyTokenInstance = await MyToken.new(_initialSupply, { from: _owner });
    });

    it("has a name", async () => {
        expect(await MyTokenInstance.name()).to.equal(_name);
    });

    it("has a symbol", async () => {
        expect(await MyTokenInstance.symbol()).to.equal(_symbol);
    });

    it("has a decimal", async () => {
        expect(await MyTokenInstance.decimals()).to.be.bignumber.equal(_decimal);
    });

    it("check first balance", async () => {
        expect(await MyTokenInstance.balanceOf(_owner)).to.be.bignumber.equal(_initialSupply);
    });

    it("check balance after transfer", async () => {
        let amount = new BN(100);
        let balanceOwnerBeforeTransfer = await MyTokenInstance.balanceOf(_owner);
        let balanceRecipientBeforeTransfer = await MyTokenInstance.balanceOf(_user1)

        expect(balanceRecipientBeforeTransfer).to.be.bignumber.equal(new BN(0));

        await MyTokenInstance.transfer(_user1, new BN(100), { from: _owner });

        let balanceOwnerAfterTransfer = await MyTokenInstance.balanceOf(_owner);
        let balanceRecipientAfterTransfer = await MyTokenInstance.balanceOf(_user1)

        expect(balanceOwnerAfterTransfer).to.be.bignumber.equal(balanceOwnerBeforeTransfer.sub(amount));
        expect(balanceRecipientAfterTransfer).to.be.bignumber.equal(balanceRecipientBeforeTransfer.add(amount));


    });

    it("approve", async () => {
        let allowanceBeforeApprove = await MyTokenInstance.allowance(_owner, _user1);
        expect(allowanceBeforeApprove).to.be.bignumber.equal(new BN(0));
        let approvalBoolResult = await MyTokenInstance.approve(_user1, new BN(_approveAmount), { from: _owner });
        let allowanceAfterApprove = await MyTokenInstance.allowance(_owner, _user1);
        expect(approvalBoolResult);
        expect(allowanceAfterApprove).to.be.bignumber.equal(_approveAmount);
    });

    it("transferFrom", async () => {
        let approvalBoolResult = await MyTokenInstance.approve(_user1, new BN(_approveAmount), { from: _owner });
        expect(approvalBoolResult);
        let allowanceBeforeTransferFrom = await MyTokenInstance.allowance(_owner, _user1);
        //console.log("allowanceBeforeTransferFrom:", allowanceBeforeTransferFrom.toString());
        await MyTokenInstance.transferFrom(_owner, _user2, new BN(_transfertFromAmount), { from: _user1 });
        let allowance1AfterTransferFrom = await MyTokenInstance.allowance(_owner, _user1);
        console.log("allowance1AfterTransferFrom", allowance1AfterTransferFrom.toString());
        expect(allowance1AfterTransferFrom).to.be.bignumber.equal(new BN(_approveAmount - _transfertFromAmount));
        console.log("o1 ", await MyTokenInstance.allowance(_owner, _user1));
        let balanceUser2AfterTransfer = await MyTokenInstance.balanceOf(_user2);
        console.log("balance2", balanceUser2AfterTransfer.toString());
        expect(balanceUser2AfterTransfer).to.be.bignumber.equal(_transfertFromAmount);
    });


});
