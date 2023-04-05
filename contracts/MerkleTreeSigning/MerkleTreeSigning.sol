// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

/*
    Hashes:
    keccak256(0xC698B4c2Db01F0FdE01B832409F9B68D0c7d6a1C) = 0x144ef461cbfe5937ebc3265b058784915be5cee25f42a42946666daf95e24578
    keccak256(0x9328e46DcE713aBabe4a7c3e69aAE7a985C58274) = 0x32ed2a931aa55673cdcfda2e33701530a451358a9e209f4d8df92d89fbc15f72
    keccak256(0xDcD6d7D4D3A4967A7EB3A80074588b0641F97d0f) = 0x64df656a5f051b59f07f5ae75254469d5552286e8459dd3bf09e32a31658ae92
    keccak256(0xaEc31e655F5d4522735467C9f7209547EfBA4893) = 0xa9a3431175bae1d7e6196986aae1df2f57e8e8381a26a1230896736a636b3a7b
    keccak256(0xc44a341F2E2f7CEC4486a20234259ad52D5277C0) = 0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0
    
    Merkle Tree:
    0x9d056892c96040c8ffac7a8510e528347fb4d6c7b809d6e99a179da7c2eca2fe
    ├─ 0xb67532e453cca06a18b59b59dfd04ae557037e76ebf721f826399c3cd3b2c5cd
    │  ├─ 0xcc1646c6a30c436d208c59cb6526ae31ec85bcd05a4a7a195799b42e60424a72
    │  │  ├─ 0x144ef461cbfe5937ebc3265b058784915be5cee25f42a42946666daf95e24578
    │  │  └─ 0x32ed2a931aa55673cdcfda2e33701530a451358a9e209f4d8df92d89fbc15f72
    │  └─ 0x5b8597601812618b1c5bc4c91884245b983156c2a616a7578a0113e72ec5b376
    │     ├─ 0x64df656a5f051b59f07f5ae75254469d5552286e8459dd3bf09e32a31658ae92
    │     └─ 0xa9a3431175bae1d7e6196986aae1df2f57e8e8381a26a1230896736a636b3a7b
    └─ 0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0
        └─ 0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0
            └─ 0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0

    Address: 0xC698B4c2Db01F0FdE01B832409F9B68D0c7d6a1C
        Proof:
            [
                "0x32ed2a931aa55673cdcfda2e33701530a451358a9e209f4d8df92d89fbc15f72",
                "0x5b8597601812618b1c5bc4c91884245b983156c2a616a7578a0113e72ec5b376",
                "0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0"
            ]

    Address: 0x9328e46DcE713aBabe4a7c3e69aAE7a985C58274
        Proof:
            [
                "0x144ef461cbfe5937ebc3265b058784915be5cee25f42a42946666daf95e24578",
                "0x5b8597601812618b1c5bc4c91884245b983156c2a616a7578a0113e72ec5b376",
                "0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0"
            ]
    
    Address: 0xDcD6d7D4D3A4967A7EB3A80074588b0641F97d0f
        Proof:
            [
                "0xa9a3431175bae1d7e6196986aae1df2f57e8e8381a26a1230896736a636b3a7b",
                "0xcc1646c6a30c436d208c59cb6526ae31ec85bcd05a4a7a195799b42e60424a72",
                "0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0"
            ]
    Address: 0xaEc31e655F5d4522735467C9f7209547EfBA4893
        Proof:
            [
                "0x64df656a5f051b59f07f5ae75254469d5552286e8459dd3bf09e32a31658ae92",
                "0xcc1646c6a30c436d208c59cb6526ae31ec85bcd05a4a7a195799b42e60424a72",
                "0xf998a8201a24435848f2647ea7fe83cbe793c237571e34f81baf39a57cf563e0"
            ]
    Address: 0xc44a341F2E2f7CEC4486a20234259ad52D5277C0
        Proof:
            [
                "0xb67532e453cca06a18b59b59dfd04ae557037e76ebf721f826399c3cd3b2c5cd"
            ]
*/

contract MerkleTreeSigning is ERC721 {
    bytes32 public merkleRoot;
    uint private currentTokenId;

    string public proposal = "Invitation to SOLYANKA team in zero2hero bootcamp";

    mapping(address => bool) public signed;
    
    constructor(bytes32 _merkleRoot) ERC721("SOLYANKA_nft", "SLKnft") {
        merkleRoot = _merkleRoot;
    }

    function signProposal(bytes32[] calldata _proof) public returns (string memory) {
        require(!signed[msg.sender], "Address has already signed!");

        bytes32 leaf = keccak256(abi.encodePacked(msg.sender));
        require(verifyLeaf(leaf, _proof), "Invalid proof");

        signed[msg.sender] = true;
        _safeMint(msg.sender, currentTokenId);
        currentTokenId++;
        
        return "Success, welcome to SOLYANKA!";
    }

    function verifyLeaf(bytes32 leaf, bytes32[] calldata proof) public view returns (bool) {
        bytes32 hash = leaf;

        for (uint i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];

            if (hash < proofElement) {
                hash = keccak256(abi.encodePacked(hash, proofElement));
            } else {
                hash = keccak256(abi.encodePacked(proofElement, hash));
            }
        }
        return hash == merkleRoot;
    }
}