pragma solidity ^0.4.20;

import "./SafeMath.sol";
import "./ERC20Interface.sol";
import "./Pausable.sol";


contract PMSTToken is ERC20Interface, Pausable
{
    using SafeMath for uint256;
    
    event Burn(address indexed burner, uint256 value);
    
    string public constant name = "PMST_Token";
    string public constant symbol = "PM_LOCK";
    uint public constant decimals = 18;
    uint256 public totalSupply = 1200 * 1 ether;
    
    address public testAddr;
    
    bool public globalTokenLock;
    
    mapping (address => uint256) public balanceOf;
    mapping (address => mapping(address => uint256)) public approvals;
    
    function PMSTToken() Ownable() public
    {
        globalTokenLock = true;
        
        balanceOf[msg.sender] = totalSupply;
    }
    
    function totalSupply() constant public returns (uint256)
    {
        return totalSupply;
    }
    
    function balanceOf(address _who) constant public returns (uint256)
    {
        return balanceOf[_who];
    }
    
    function approve(address _spender, uint256 _value) public returns (bool)
    {
        require(balanceOf[msg.sender] >= _value);
        
        approvals[msg.sender][_spender] = _value;
        
        Approval(msg.sender, _spender, _value);
        
        return true;
    }
    
    function allowance(address _owner, address _spender) constant public returns (uint256 _allowance)
    {
        return approvals[_owner] [_spender];
    }
    
    function transfer(address _to, uint256 _value) public returns (bool)
    {
        // global lock
        require(isGlobalTokenLock() == false);
        
        require(_to != address(0));
        require(balanceOf[msg.sender] >= _value);
        require(balanceOf[_to].add(_value) > balanceOf[_to]);
        
        // transfer
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        
        Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success)
    {
        // global lock
        require(isGlobalTokenLock() == false);
        
        require(_to != address(0));
        require(balanceOf[_from] >= _value);
        require(approvals[_from][msg.sender] >= _value);
        require(balanceOf[_to].add(_value) > balanceOf[_to]);
        
        // transfer
        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        
        Transfer(_from, _to, _value);
        
        return true;
    }
    
    function isGlobalTokenLock() public constant returns (bool lock)
    {
        lock = false;
        
        if(globalTokenLock == true)
        {
            lock = true;
        }
    }
    
    function removeGlobalTokenLock() onlyOwner public
    {
        require(globalTokenLock == true);
        
        globalTokenLock = false;
    }
    
    function burn(uint256 _value) onlyOwner public 
    {
        require(_value > 0);

        address burner = msg.sender;
        balanceOf[burner] = balanceOf[burner].sub(_value);
        totalSupply = totalSupply.sub(_value);
        
        Burn(burner, _value);
    }
}
