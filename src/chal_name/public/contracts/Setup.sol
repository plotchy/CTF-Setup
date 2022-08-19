//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
// dummy for no import errors
import './Challenge.sol';
contract Setup {
    Challenge public challenge;
    address payable challengeAddress;
    constructor() payable {
        challenge = new Challenge();
        challengeAddress = payable(address(challenge));
    }

    function isSolved() public view returns(bool) {
        return true;
    }

    fallback() external payable {

    }
}