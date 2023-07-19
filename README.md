

DegenGamingTokenV2 is a Solidity smart contract that implements the ERC20 token standard. It represents a decentralized gaming token called "Degen" with the symbol "DGN". The contract allows for the creation, transfer, and burning of tokens.

## Features

- **ERC20 Interface**: The contract implements the ERC20 interface, providing standard functions for token transfers, approvals, and balances.
- **Token Metadata**: The contract specifies the token name and symbol as "Degen" and "DGN" respectively.
- **Total Supply**: The contract initializes with an initial token supply, which is multiplied by 10 to account for the token's decimal places.
- **Token Owner**: The contract owner is set to the deployer of the contract.
- **Account Balances**: The contract maintains a mapping of account addresses to their token balances.
- **Account Allowances**: The contract maintains a mapping of account addresses to the addresses they have approved to spend tokens on their behalf.
- **Modifiers**:
  - `onlyOwner`: Restricts access to certain functions to the token owner.

## ERC20 Functions

The contract implements the following functions from the ERC20 interface:

- `getSupply()`: Retrieves the total token supply.
- `getBalance(address account)`: Retrieves the token balance of the specified account.
- `sendTokens(address recipient, uint256 amount)`: Transfers tokens from the caller's account to the specified recipient.
- `transferFromAccount(address sender, address recipient, uint256 amount)`: Transfers tokens from the sender's account to the recipient's account.
- `grantApproval(address spender, uint256 amount)`: Approves the specified spender to spend the caller's tokens up to the specified amount.
- `getApproval(address owner, address spender)`: Retrieves the amount of tokens the spender is allowed to spend on behalf of the owner.
- `burnTokens(uint256 amount)`: Burns tokens from the caller's account.
- `burnFromAccount(address account, uint256 amount)`: Burns tokens from the specified account on behalf of the caller.
- `redeemTokens(uint256 amount)`: Burns tokens from the caller's account as a form of redemption.

## Events

The contract emits the following events:

- `TokensTransferred(address indexed from, address indexed to, uint256 value)`: Indicates a transfer of tokens between two addresses.
- `ApprovalGranted(address indexed owner, address indexed spender, uint256 value)`: Indicates the approval granted by an owner to a spender.

## Deployment

The contract is deployed with an initial supply of tokens, which are assigned to the contract owner's account. The deployment triggers the `TokensTransferred` event to indicate the transfer of tokens from address 0 to the token owner's address.

Note: The contract is licensed under the MIT license.
