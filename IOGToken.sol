pragma solidity ^0.4.21;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./StandardToken.sol";

contract IOGToken is StandardToken, Ownable {

    // events
    event Burn(address indexed burner, uint256 amount);
    event AddressLocked(address indexed _owner, uint256 _expiry);

    // ERC20 constants
    string public constant name = "IIOToken";
    string public constant symbol = "IIO";
    uint8 public constant decimals = 18;
    uint256 public constant TOTAL_SUPPLY = 120 * 1000 * (10 ** uint256(decimals));

    // lock
    mapping (address => uint256) public addressLocks;

    // constructor
    function IOGToken() public {
        totalSupply_ = TOTAL_SUPPLY;
        balances[msg.sender] = TOTAL_SUPPLY;
        emit Transfer(0x0, msg.sender, TOTAL_SUPPLY);

        // distribution
        initialPoolDistribution();
    }

    // distribution
    function initialPoolDistribution() onlyOwner internal {
        // early inverstors pool (locked)
        uint256 earlyInverstorPoolToken = 7777 * (10 ** uint256(decimals));
        address earlyInverstorPoolWallet = 0xC0531e14a0B2E91C2ca646a35f5b619184339A53;
        addressLocks[earlyInverstorPoolWallet] = now + 10 minutes;
        transfer(earlyInverstorPoolWallet, earlyInverstorPoolToken);        
        emit AddressLocked(earlyInverstorPoolWallet, earlyInverstorPoolToken);

        // private sale pool
        uint256 privateSalePoolToken = 88888 * (10 ** uint256(decimals));
        address privateSalePoollWallet = 0xEcA254594c5bBCCEBc321e9252cc886cE37Be914;
        transfer(privateSalePoollWallet, privateSalePoolToken);

        // team reserved pool (locked)

        // playgroundz ecosystem pool
    }

    // lock
    modifier canTransfer(address _sender) {
        require(_sender != address(0));
        require(canTransferIfLocked(_sender));

        _;
    }

    function canTransferIfLocked(address _sender) internal view returns(bool) {
        if (0 == addressLocks[_sender])
            return true;

        return (now >= addressLocks[_sender]);
    }

    // transfer
    function transfer(address _to, uint256 _value) canTransfer(msg.sender) public returns (bool success) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) public returns (bool success) {
        return super.transferFrom(_from, _to, _value);
    }

    // burn
    function burn(uint256 _value) onlyOwner public {
        _burn(msg.sender, _value);
    }

    function _burn(address _who, uint256 _value) internal {
        require(_value <= balances[_who]);

        balances[_who] = balances[_who].sub(_value);
        totalSupply_ = totalSupply_.sub(_value);

        emit Burn(_who, _value);
        emit Transfer(_who, address(0), _value);
    }
}
