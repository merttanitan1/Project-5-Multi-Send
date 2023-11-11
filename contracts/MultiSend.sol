//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract MultiSend{
    using SafeERC20 for IERC20;
    IERC20 public token;

    mapping(address => uint256) balance;

    constructor(address _tokenAddress){
        token = IERC20(_tokenAddress);
    }

    function deposit(uint256 _amount) public{
        require(token.balanceOf(msg.sender) >= _amount, "Insufficcient funds.");
        token.safeTransferFrom(msg.sender, address(this), _amount);

        balance[msg.sender] += _amount;
    }

    function withdraw(uint256 _amount) public{
        require(balance[msg.sender] <= _amount, "Not enough token.");
        token.safeTransfer(msg.sender, _amount);

        balance[msg.sender] -= _amount;
    }

    function sendToken(address[] memory _adrs, uint256 _amount) public {
        uint256 total = _amount * _adrs.length;
        require(balance[msg.sender] >= total, "Not enough token.");
        for(uint256 i; i < _adrs.length; i++){
            token.safeTransferFrom(msg.sender, _adrs[i], _amount);
            balance[_adrs[i]] += _amount;
        }
        balance[msg.sender] -= total;
    }

    function getBalance(address _adr) public view returns(uint256){
        return balance[_adr];
    }
}