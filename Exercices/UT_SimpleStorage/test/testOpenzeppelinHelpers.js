const SimpleStorage = artifacts.require("./Storage.sol");
const { BN, expectRevert, expectEvent } = require('@openzeppelin/test-helpers');
const { expect } = require('chai');
const constants = require('@openzeppelin/test-helpers/src/constants');

contract("SimpleStorage", accounts => {

    let owner = accounts[0]
    let user1 = accounts[1]

    it("...the expect case.", async () => {
        console.log("gogogo first test");
        expect("tam".length).to.equal(3, "la taille du mot n'est pas 3");
    });
    it("...a stronger expect case with type test.", async () => {
        const simpleStorageInstance = await SimpleStorage.deployed();
        await simpleStorageInstance.store(21, { from: user1 });
        const testRetrieve = await simpleStorageInstance.retrieve();
        expect(testRetrieve).to.be.bignumber.equal(new BN(21));
    });
    it("...the expectRevert case.", async () => {
        const simpleStorageInstance = await SimpleStorage.deployed();
        await expectRevert(simpleStorageInstance.failIfNot42(33, { from: user1 }), "it must be 42");
    });
    it("...the expectEvent case.", async () => {
        const simpleStorageInstance = await SimpleStorage.deployed();
        const myResult = await simpleStorageInstance.emitFakeEvent(4, { from: user1 });
        await expectEvent(myResult, 'NormalEvent', { eventParamValue: new BN(14) });
    });

});


