// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/**
 *  MerkleAirdrop: A smart contract likely used for distributing tokens to multiple users via a Merkle tree.
    IERC20: Interface for ERC-20 tokens, required by MerkleAirdrop to handle token transfers.
    Script: A utility from Foundry for running deployment scripts.
    BagelToken: Another contract, presumably an ERC-20 token.
    console: A debugging tool to print logs during execution, useful for testing purposes in Foundry.
 */

import { MerkleAirdrop, IERC20 } from "../src/MerkleAirdrop.sol";
import { Script } from "../lib/forge-std/src/Script.sol";
import { BagelToken } from "../src/BagelToken.sol";
import { console } from "../lib/forge-std/src/console.sol";

contract DeployMerkleAirdrop is Script {
    bytes32 public ROOT = 0xaa5d581231e596618465a56aa0f5870ba6e20785fe436d5bfb82b08662ccc7c4; // ROOT: The Merkle root used by the MerkleAirdrop contract. It represents a unique identifier for a group of data, usually the list of eligible airdrop participants.
    // 4 users, 25 Bagel tokens each
    uint256 public AMOUNT_TO_TRANSFER = 4 * (25 * 1e18); // AMOUNT_TO_TRANSFER: Specifies the amount of tokens to transfer to the airdrop contract (4 users, 25 tokens each). The total amount is calculated as 4 * (25 * 1e18), which corresponds to 100 Bagel tokens (assuming 18 decimal places).

    // Deploy the airdrop contract and bagel token contract
    /**
     * vm.startBroadcast() / vm.stopBroadcast(): Foundry commands to start and stop broadcasting transactions on the blockchain. Useful for testing and deployment.
     * 
     */
    function deployMerkleAirdrop() public returns (MerkleAirdrop, BagelToken) {
        vm.startBroadcast();
        BagelToken bagelToken = new BagelToken(); //A new instance of BagelToken (the ERC-20 token) is created.
        MerkleAirdrop airdrop = new MerkleAirdrop(ROOT, IERC20(bagelToken)); //A new instance of MerkleAirdrop is deployed, initialized with the Merkle root (ROOT) and an interface to the BagelToken contract (IERC20(bagelToken)).
        // Send Bagel tokens -> Merkle Air Drop contract
        bagelToken.mint(bagelToken.owner(), AMOUNT_TO_TRANSFER); //BagelToken mints AMOUNT_TO_TRANSFER tokens (100 Bagel tokens) to its owner.
        IERC20(bagelToken).transfer(address(airdrop), AMOUNT_TO_TRANSFER); //These tokens are then transferred to the MerkleAirdrop contract, where the tokens will later be distributed to eligible recipients.
        vm.stopBroadcast();
        return (airdrop, bagelToken);
    }
    //run() is the main function that calls deployMerkleAirdrop() and returns the deployed instances of MerkleAirdrop and BagelToken. It serves as the entry point for executing this script.
    function run() external returns (MerkleAirdrop, BagelToken) {
        return deployMerkleAirdrop();
    }
}
