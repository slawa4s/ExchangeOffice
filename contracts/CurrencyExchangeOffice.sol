// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.7.3;

contract CurrencyExchangeOffice {
    address public owner;
    uint256 public exchangeRate;
    mapping(address => uint256) public balances;

    constructor(uint256 _exchangeRate) {
        owner = msg.sender;
        exchangeRate = _exchangeRate;
    }

    /// @dev Retrieves office's balance
    function getOfficeBalance() public view returns (uint256) {
        require(msg.sender == owner, "Only the owner can know real balance.");
        return balances[address(this)];
    }

    /// @dev Fetches user's balance
    function getFakeBalance() public view returns (uint256) {
        return balances[msg.sender];
    }

    /// @dev Adds fake tokens to office
    /// @param amount The amount of fake tokens for refill
    function refill(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can refill.");
        // We have free fake tokens
        balances[address(this)] += amount;
    }

    /// @dev Buy Fake Tokens for ETH
    function purchaseFakeToken() public payable {
        uint amount = msg.value / exchangeRate;
        require(balances[address(this)] >= amount, "You can not buy so much tokens");

        balances[address(this)] -= amount;
        balances[msg.sender] += amount;
    }

    /// @dev Sells Fake Tokens for ETH
    /// @param amount The amount of fake tokens the user wants to sell
    function sellFakeToken(uint256 amount) public {
        require(balances[msg.sender] >= amount, "Low token balance");

        uint256 ethAmount = amount * exchangeRate;
        require(address(this).balance >= ethAmount, "Exchange Office currently unavailable ;)");

        balances[msg.sender] -= amount;
        balances[address(this)] += amount;

        payable(msg.sender).transfer(ethAmount);
    }

    /// @dev Withdraw Fake Tokens for ETH
    /// @param amount The amount of ETH the owner wants to withdraw
    function withdrawFakeToken(uint256 amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");
        require(address(this).balance >= amount, "Not enough token for withdraw");
        payable(owner).transfer(amount);
    }
}