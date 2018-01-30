pragma solidity ^0.4.18;

import "localhost/zeppelin/contracts/token/StandardToken.sol";
import "localhost/zeppelin/contracts/ownership/Ownable.sol";

/**
 * Mintable token
 */

contract MintableToken is StandardToken, Ownable {
    uint public totalSupply = 0;
    address private minter;

    modifier onlyMinter() {
        require(minter == msg.sender);
        _;
    }

    function setMinter(address _minter) public onlyOwner {
        minter = _minter;
    }

    function mint(address _to, uint _amount) public onlyMinter {
        totalSupply = totalSupply.add(_amount);
        balances[_to] = balances[_to].add(_amount);
        Transfer(address(0x0), _to, _amount);
    }
}
