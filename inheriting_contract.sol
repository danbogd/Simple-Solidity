pragma solidity 0.6.0;

contract a{
    
    uint public x;
    
    function setX(uint _x) public returns (uint){
    x = _x*2;
    return x;
    }
    
}

contract b is a {
    
    //uint public x;
    
    function setX(uint _x) override returns (uint){
    x = _x;
    return x;
    }
    
}
