const { ethers } = require("hardhat");
const { assert, expect } = require("chai")

function encodePackedKeccak256(value) {
    const bytes = ethers.utils.arrayify(value);
    const hash = ethers.utils.keccak256(bytes);
    const hex = ethers.utils.hexlify(hash);
    return hex;
}


describe("MerkleTreeSigning", function() {
    let signingFactory, contract;
    beforeEach(async function() {
        signingFactory = await ethers.getContractFactory("MerkleTreeSigning");
        contract = await signingFactory.deploy("0x9d056892c96040c8ffac7a8510e528347fb4d6c7b809d6e99a179da7c2eca2fe");
    })

    it("Verify leaf testing", async function() {

        var leaf = encodePackedKeccak256("0xC698B4c2Db01F0FdE01B832409F9B68D0c7d6a1C");
        var proofs = [
            "0x32ed2a931aa55673cdcfda2e33701530a451358a9e209f4d8df92d89fbc15f72",
            "0x5b8597601812618b1c5bc4c91884245b983156c2a616a7578a0113e72ec5b376",
            "0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0"
        ];
        const expectedResult = true;
        var result = await contract.verifyLeaf(leaf,proofs);
        assert.equal(expectedResult, result);
    });

    // it("signProposal testing", async function() {
    //     var proofs = [
    //         "0x32ed2a931aa55673cdcfda2e33701530a451358a9e209f4d8df92d89fbc15f72",
    //         "0x5b8597601812618b1c5bc4c91884245b983156c2a616a7578a0113e72ec5b376",
    //         "0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0"
    //     ];
    //     const success = "Success, welcome to SOLYANKA!";

    //     var check = await contract.signProposal(proofs);
    //     assert.equal(check, success);
    // })


});