pragma solidity ^0.4.20;

contract Ownable
{
    address public owner;
    
    event OwnerTransferPropose(address indexed _from, address indexed _to);
    
    modifier onlyOwner
    {
        require(msg.sender == owner);
        _;
    }
    
    function Ownable() public 
    {
        owner = msg.sender;
    }
    
    function transferOwnership(address _to) onlyOwner public
    {
        require(_to != owner);
        require(_to != address(0x0));
        
        owner = _to;
        
        OwnerTransferPropose(owner, _to);
    }
}
