pragma solidity ^0.4.21;

import "./SafeMath.sol";
import "./Ownable.sol";
import "./StandardToken.sol";

contract IOGToken is StandardToken, Ownable, Pausable {

    // events
    event Burn(address indexed burner, uint256 amount);
    event AddressLocked(address indexed _owner, uint256 _expiry);

    // ERC20 constants
    string public constant name = "IOXToken";
    string public constant symbol = "IOX";
    uint8 public constant decimals = 18;
    uint256 public constant TOTAL_SUPPLY = 120 * 1000 * (10 ** uint256(decimals));

    // lock
    mapping (address => uint256) public addressLocks;

    // constructor
    constructor() public {
        totalSupply_ = TOTAL_SUPPLY;
        balances[msg.sender] = TOTAL_SUPPLY;
        emit Transfer(0x0, msg.sender, TOTAL_SUPPLY);
    }

    // distribution
    function distribution() onlyOwner internal {
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

    // ERC20 Methods
    function transfer(address _to, uint256 _value) canTransfer(msg.sender) whenNotPaused public returns (bool success) {
        return super.transfer(_to, _value);
    }

    function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from) whenNotPaused public returns (bool success) {
        return super.transferFrom(_from, _to, _value);
    }
    
    function approve(address _spender, uint256 _value) whenNotPaused public returns (bool) {
        return super.approve(_spender, _value);
    }

    function increaseApproval(address _spender, uint _addedValue) whenNotPaused public returns (bool success) {
        return super.increaseApproval(_spender, _addedValue);
    }

    function decreaseApproval(address _spender, uint _subtractedValue) whenNotPaused public returns (bool success) {
        return super.decreaseApproval(_spender, _subtractedValue);
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
	
	// Token Drain
    function emergencyERC20Drain(ERC20 token, uint256 amount) external onlyOwner {
        // owner can drain tokens that are sent here by mistake
        token.transfer(owner, amount);
    }
}
