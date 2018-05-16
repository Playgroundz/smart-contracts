pragma solidity ^0.4.20;

contract ERC20Interface
{
    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    function totalSupply() constant public returns (uint256 _supply);
    function balanceOf(address _who) constant public returns (uint256 _value);
    function transfer(address _to, uint256 _value) public returns (bool _success);
    function approve(address _spender, uint256 _value) public returns (bool _success);
    function allowance(address _owner, address _spender) constant public returns (uint256 _allowance);
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool _success);
}
