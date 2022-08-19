pragma solidity ^0.8.4;

// Used when you need to locally deploy/test a non-sourced contract.


contract evmSetup {

    address payable public challengeAddress;
    constructor() payable {
        // gather creation code through .bin file
        bytes memory initcode = hex"6080604052000000"; // ..... this is creationCode
        address _addr;
        assembly {
            _addr := create(0, add(initcode, 0x20), mload(initcode))
        }

        /* version with constructor args:
        bytes memory initcode = hex"6080604052000000";
        bytes memory args1 = hex"0000000000000000000000000000000000000000000000000000000000000001";
        bytes memory args2 = hex"0000000000000000000000000000000000000000000000000000000000000002";
        bytes memory initcode_w_args = abi.encodePacked(initcode, args1, args2);
        address _addr;
        assembly {
            _addr := create(0, add(initcode_w_args, 0x20), mload(initcode_w_args))
        }
        */
        challengeAddress = payable(_addr);
    }

    function isSolved() public view returns (bool) {
        return challengeAddress.balance == 0;
    }
}