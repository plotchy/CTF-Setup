// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;
import "forge-std/Script.sol";
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
contract Scripter is Script {

    Challenge challenge;
    address payable challengeAddress;
    address payable setupAddress;
    address payable exploitAddress;
    function setUp() public {}

    function run() external {
        vm.startBroadcast();

        Setup setup = new Setup{value: 100 ether}();
        setupAddress = payable(address(setup));
        challenge = setup.challenge();
        challengeAddress = payable(address(challenge));
        
        Exploit exploit = new Exploit{value: 100 ether}(setup, challenge);
        exploitAddress = payable(address(exploit));
        exploit.finalize();

        // // alternatively use etk code as exploit
        // bytes memory etkCode = etkLoad();
        // address _addr;
        // assembly {
        //     _addr := create(0, add(initcode, 0x20), mload(initcode))
        // }
        // exploitAddress = address(_addr);

        vm.stopBroadcast();
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
