#! /usr/bin/env bash

# Make this file executable:
# chmod +x copy_challenge.sh
# Use this file as so:
# ./copy_challenge.sh NewChallengeName

# Change to your absolute ctf directory
preamble=/home/plotchy/code/ctf/CTF-Setup

cp $preamble/test/TestTemplate.t.sol $preamble/test/$1.t.sol
cp $preamble/script/ScriptTemplate.s.sol $preamble/script/$1.s.sol

mkdir -p $preamble/src/$1/public/contracts
cp -r $preamble/src/chal_name/public/contracts/Exploit.sol $preamble/src/$1/public/contracts/Exploit.sol

sed -i "s/chal_name/$1/g" $preamble/test/$1.t.sol
sed -i "s/TestTemplate/$1/g" $preamble/test/$1.t.sol
sed -i "s/ScriptTemplate/$1/g" $preamble/test/$1.t.sol

sed -i "s/chal_name/$1/g" $preamble/script/$1.s.sol
sed -i "s/TestTemplate/$1/g" $preamble/script/$1.s.sol
sed -i "s/ScriptTemplate/$1/g" $preamble/script/$1.s.sol

sed -i "s/chal_name/$1/g" $preamble/src/$1/public/contracts/Exploit.sol