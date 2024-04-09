// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.25;

interface YourToken {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address who) external view returns (uint256);
    function allowance(address owner, address spender) external view returns (uint256);
}

contract CurrencyExchangeOffice {
    address public owner;
    address public yourTokenAddress; 
    uint256 public exchangeRate;

    constructor(address _yourTokenAddress, uint256 _exchangeRate) {
        owner = msg.sender;
        yourTokenAddress = _yourTokenAddress;
        exchangeRate = _exchangeRate;
    }

    function refill(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can refill.");
        YourToken(yourTokenAddress).transferFrom(msg.sender, address(this), amount);
    }

    function purchaseWithEther(uint256 amount) public payable {
        require(msg.value >= amount * exchangeRate, "Insufficient Ether provided for the requested token amount");
        YourToken(yourTokenAddress).transfer(msg.sender, amount);
    }

    function sellForEther(uint256 amount) public {
        uint256 tokenBalance = YourToken(yourTokenAddress).balanceOf(msg.sender);
        require(tokenBalance >= amount, "Insufficient token balance");
        
        uint256 ethAmount = amount / exchangeRate;
        require(address(this).balance >= ethAmount, "Insufficient Ether balance in the contract");
        
        YourToken(yourTokenAddress).transferFrom(msg.sender, address(this), amount);

        payable(msg.sender).transfer(ethAmount);
    }

    function withdrawEther(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can withdraw Ether");
        require(address(this).balance >= amount, "Insufficient contract balance");
        payable(owner).transfer(amount);
    }
}
