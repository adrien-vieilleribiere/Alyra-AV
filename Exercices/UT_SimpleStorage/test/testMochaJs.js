const SimpleStorage = artifacts.require("./Storage.sol");

contract("SimpleStorage", accounts => {
    it("...should store the value 89.", async () => {
        const simpleStorageInstance = await SimpleStorage.deployed();

        // Set value of 89
        await simpleStorageInstance.store(89, { from: accounts[0] });

        // Get stored value
        const storedData = await simpleStorageInstance.retrieve.call();

        assert.equal(storedData, 89, "The value 89 was not stored.");
    });
});
