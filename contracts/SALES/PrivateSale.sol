// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(address from, address to, uint256 amount) external returns (bool);
}

contract PrivateSale {
    address public SalesToken;
    uint256 public rate = 1000000;
    address public owner;
    event SaleMade(address, uint);

    modifier onlyOwner() {
        require(msg.sender == owner,"Not Allowed");
        _;
    }

    constructor () {
        owner = msg.sender;
        SalesToken = 0x8Ed496bb252EB515116a39286006217fdAE0451F;
    }

    function change_owner(address _owner) onlyOwner public {
        owner = _owner;
      //  emit OwnershipChanged(_owner);
    }
    

    function changeRate(uint256 _newRate) public onlyOwner{
        rate = _newRate;
    }
    function changeToken(address _newToken) public onlyOwner{
        SalesToken = _newToken;
    }

    receive() external payable {
        IERC20 token = IERC20(SalesToken);

        token.transfer(msg.sender, msg.value * rate);
        emit SaleMade(msg.sender, msg.value);
     }

     function sendValueTo(address to_, uint256 value) internal {
        address payable to = payable(to_);
        (bool success, ) = to.call{value: value}("");
        require(success, "Transfer failed.");
    }
     
    function withdrawEth() public onlyOwner {
        sendValueTo(msg.sender, address(this).balance);
    }

     function withdraw_token(address token) public onlyOwner {
        uint256 balance = IERC20(token).balanceOf(address(this));
        if (balance > 0) {
            IERC20(token).transfer( msg.sender, balance);
        }
    } 
}