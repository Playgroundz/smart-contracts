pragma solidity ^0.4.20;

library SafeMath
{
    function mul(uint256 a, uint256 b) internal pure returns (uint256)
    {
        uint256 c = a * b;
        assert(a == 0 || c / a == b);
        
        return c;
    }
    
    function div(uint256 a, uint256 b) internal pure returns (uint256)
    {
        uint256 c = a / b;
        
        return c;
    }
    
    function sub(uint256 a, uint256 b) internal pure returns (uint256)
    {
        assert(b <= a);
        
        return a - b;
    }
    
    function add(uint256 a, uint256 b) internal pure returns (uint256)
    {
        uint256 c = a + b;
        assert(c >= a);
        
        return c;
    }
}

contract ERC20Interface
{
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    
    function totalSupply() constant public returns (uint _supply);
    function balanceOf(address _who) constant public returns (uint _value);
    function transfer(address _to, uint _value) public returns (bool _success);
    function approve(address _spender, uint _value) public returns (bool _success);
    function allowance(address _owner, address _spender) constant public returns (uint _allowance);
    function transferFrom(address _from, address _to, uint _value) public returns (bool _success);
}

contract PMSTToken is ERC20Interface
{
    using SafeMath for uint;
    
    address public owner;
    
    string public name;
    uint public decimals;
    string public symbol;
    uint public totalSupply;
    
    uint constant private E18 = 1000000000000000000;
    uint constant public maxSupply = 99999 * E18;
    
    
    mapping (address => uint) public balanceOf;
    mapping (address => mapping(address => uint)) public approvals;
    
    function PMSTToken() public
    {
        name = "PMSToken";
        decimals = 18;
        symbol = "PMST";
        totalSupply = maxSupply;
        owner = msg.sender;
        
        balanceOf[msg.sender] = totalSupply;
    }
    
    function totalSupply() constant public returns (uint)
    {
        return totalSupply;
    }
    
    function balanceOf(address _who) constant public returns (uint)
    {
        return balanceOf[_who];
    }
    
    function transfer(address _to, uint _value) public returns (bool)
    {
        require(balanceOf[msg.sender] >= _value);
        
        balanceOf[msg.sender] = balanceOf[msg.sender].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        
        Transfer(msg.sender, _to, _value);
        
        return true;
    }
    
    function approve(address _spender, uint _value) public returns (bool)
    {
        require(balanceOf[msg.sender] >= _value);
        
        approvals[msg.sender][_spender] = _value;
        
        Approval(msg.sender, _spender, _value);
        
        return true;
    }
    
    function allowance(address _owner, address _spender) constant public returns (uint _allowance)
    {
        return approvals[_owner] [_spender];
    }
    
    function transferFrom(address _from, address _to, uint _value) public returns (bool _success)
    {
        require(balanceOf[_from] >= _value);
        require(approvals[_from][msg.sender] >= _value);
        
        approvals[_from][msg.sender] = approvals[_from][msg.sender].sub(_value);
        balanceOf[_from] = balanceOf[_from].sub(_value);
        balanceOf[_to] = balanceOf[_to].add(_value);
        
        Transfer(_from, _to, _value);
        
        return true;
    }
}