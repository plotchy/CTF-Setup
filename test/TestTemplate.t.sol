// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "forge-std/Test.sol";
import "../src/chal_name/public/contracts/Setup.sol";
import "../src/chal_name/public/contracts/Exploit.sol";

bytes constant SIXTY_FOUR_ZEROS = "0000000000000000000000000000000000000000000000000000000000000000"; // ctrlc+v on handcrafted calldata
address constant CREATE2_FACTORY = 0x4e59b44847b379578588920cA78FbF26c0B4956C;
/*
Commands:
# Testing command
forge test --mp ./test/TestTemplate.t.sol --mc Tester --fork-url $ANVIL_URL -vvvvv

# Debug command
forge test --mp ./test/TestTemplate.t.sol --mc Tester --debug <function> --fork-url $ANVIL_URL

# Script command
forge script script/ScriptTemplate.s.sol:Scripter --rpc-url $ANVIL_URL --private-key $PRIVATE_KEY_1 --broadcast -vvvvv

# Debug broadcasted tx:
cast run <TXHASH> -d --rpc-url $ANVIL_URL

# Exploratory
forge inspect <path>:<ContractName> storage --pretty
https://ethervm.io/decompile
https://library.dedaub.com/decompile
panoramix <bytecode>
*/


contract Tester is Test {
    Setup setup;
    address payable setupAddress;
    Challenge challenge;
    address payable challengeAddress;
    Exploit exploit;
    address payable exploitAddress;

    function setUp() public {
        setup = new Setup{value: 50 ether}();
        setupAddress = payable(address(setup));
        challenge = setup.challenge();
        challengeAddress = payable(address(challenge));
    }

    function testIsSolved() public {
        // useful to run at beginning to find storage slots .isSolved() uses
        vm.record();
        setup.isSolved();
        vm.accesses(challengeAddress);
    }

    function testExploit() public {
        console2.log("Bal after setup: setup: %s, challenge: %s", setupAddress.balance, challengeAddress.balance);

        exploit = new Exploit{value: 100 ether}(setup, challenge);
        exploitAddress = payable(address(exploit));

        // // alternatively use etk code as exploit
        // bytes memory etkCode = etkLoad();
        // address _addr;
        // assembly {
        //     _addr := create(0, add(initcode, 0x20), mload(initcode))
        // }
        // exploitAddress = address(_addr);

        console2.log("Bal after exp-deployed: setup: %s, challenge: %s, exploit: %s", setupAddress.balance, challengeAddress.balance, address(exploit).balance);

        exploit.finalize();
        console2.log("Bal post finalize: setup: %s, challenge: %s, exploit: %s", setupAddress.balance, challengeAddress.balance, address(exploit).balance);
        
        console2.log("Solved: %s", exploit.checkSolved());
    }


    function etkLoad() public returns (bytes memory etkCode){
        // Helper function to load handcrafted EVM code from a file.
        // typically used as:
        //    
        //    bytes memory etkCode = etkLoad();
        //    vm.etch(someAddress, etkCode);
        //    someAddress.call(hex"69696969");

        string[] memory inputs = new string[](2);
        // /**
        //  * windows: scripts/compile.bat
        //  * linux  : scripts/compile.sh
        //  */
        inputs[0] = "./script/compile.sh";

        // // path/to/contract.etk
        inputs[1] = "./src/chal_name/public/contracts/exploit.etk";

        etkCode = vm.ffi(inputs);
    }
}
