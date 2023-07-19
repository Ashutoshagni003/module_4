// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface ERC20 {
    function getSupply() external view returns (uint256);
    function getBalance(address account) external view returns (uint256);
    function sendTokens(address recipient, uint256 amount) external returns (bool);
    function grantApproval(address spender, uint256 amount) external returns (bool);
    function transferFromAccount(address sender, address recipient, uint256 amount) external returns (bool);
    
    event TokensTransferred(address indexed from, address indexed to, uint256 value);
    event ApprovalGranted(address indexed owner, address indexed spender, uint256 value);
}

contract DegenGamingTokenV2 is ERC20 {
    string private constant _tokenName = "Degen";
    string private constant _tokenSymbol = "DGN";
    uint256 private _totalTokenSupply;
    address private _tokenOwner;
    mapping(address => uint256) private _accountBalances;
    mapping(address => mapping(address => uint256)) private _accountAllowances;

    modifier onlyOwner() {
        require(msg.sender == _tokenOwner, "Restricted to the token owner.");
        _;
    }

    constructor(uint256 initialSupply) {
        _tokenOwner = msg.sender;
        _totalTokenSupply = initialSupply * 10;
        _accountBalances[_tokenOwner] = _totalTokenSupply;
        emit TokensTransferred(address(0), _tokenOwner, _totalTokenSupply);
    }

    function getSupply() external view override returns (uint256) {
        return _totalTokenSupply;
    }

    function getBalance(address account) external view override returns (uint256) {
        return _accountBalances[account];
    }

    function sendTokens(address recipient, uint256 amount) external override returns (bool) {
        _transferTokens(msg.sender, recipient, amount);
        return true;
    }

    function transferFromAccount(address sender, address recipient, uint256 amount) external override returns (bool) {
        uint256 currentAllowance = _accountAllowances[sender][msg.sender];
        require(currentAllowance >= amount, "Transfer amount exceeds allowance");
        _transferTokens(sender, recipient, amount);
        _approveAccount(sender, msg.sender, currentAllowance - amount);
        return true;
    }

    function grantApproval(address spender, uint256 amount) external override returns (bool) {
        _approveAccount(msg.sender, spender, amount);
        return true;
    }

    function getApproval(address owner, address spender) external view  returns (uint256) {
        return _accountAllowances[owner][spender];
    }

    function burnTokens(uint256 amount) external returns (bool) {
        _burnTokens(msg.sender, amount);
        return true;
    }

    function burnFromAccount(address account, uint256 amount) external returns (bool) {
        uint256 currentAllowance = _accountAllowances[account][msg.sender];
        require(currentAllowance >= amount, "Burn amount exceeds allowance");
        _burnTokens(account, amount);
        _approveAccount(account, msg.sender, currentAllowance - amount);
        return true;
    }

    function _mintTokens(address account, uint256 amount) external onlyOwner {
        require(account != address(0), "Mint to zero address");
        _totalTokenSupply += amount;
        _accountBalances[account] += amount;
        emit TokensTransferred(address(0), account, amount);
    }

    function redeemTokens(uint256 amount) external returns (bool) {
        require(_accountBalances[msg.sender] >= amount, "Insufficient balance to redeem tokens");
        _burnTokens(msg.sender, amount);
        return true;
    }

    function _transferTokens(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "Transfer from zero address");
        require(recipient != address(0), "Transfer to zero address");
        require(_accountBalances[sender] >= amount, "Insufficient balance");

        _accountBalances[sender] -= amount;
        _accountBalances[recipient] += amount;
        emit TokensTransferred(sender, recipient, amount);
    }

    function _approveAccount(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "Approve from zero address");
        require(spender != address(0), "Approve to zero address");

        _accountAllowances[owner][spender] = amount;
        emit ApprovalGranted(owner, spender, amount);
    }

    function _burnTokens(address account, uint256 amount) internal {
        require(account != address(0), "Burn from zero address");
        require(_accountBalances[account] >= amount, "Insufficient balance to burn");

        _accountBalances[account] -= amount;
        _totalTokenSupply -= amount;
        emit TokensTransferred(account, address(0), amount);
    }

    
}
