# BaseDonationTransfer
# BaseDonationTransfer Contract (Educational Sample)

## Overview
This contract allows sending ETH with a portion automatically sent to a donation wallet.
It is created for **educational and demonstration purposes** only.

- Contract name: `BaseDonationTransfer.sol`
- Main functions:
  - `sendWithDonation()`: Sends ETH and automatically sends a percentage to the donation wallet
  - `constructor()`: Sets the donation wallet address and initial donation rate
  - `setDonationRate()`: Owner can update donation rate
  - `addDonationWallet()` / `removeDonationWallet()`: Supports multiple donation wallets

---

## Donation Address Notice

- By default, this sample uses the **burn address** (`0x000000000000000000000000000000000000dEaD`).
  - Any ETH sent to this address is **permanently lost** and cannot be retrieved by anyone.
- If you want to use a Base donation address, **verify the official address and replace it in the constructor**.
- Sending funds to the wrong address may result in permanent loss.

---

## Initial Donation Rate

- `initialRate` in the constructor sets the donation percentage per transfer.
- Unit: **basis points / 10000 scale** (1% = 100, 10% = 1000, 100% = 10000)
- Recommended test value: 100 (1%) → safe for demonstration and behavior testing

---

## Usage Warning

- This contract is **for educational and demonstration purposes**.
- Using it on Mainnet is **at your own risk**.
- Only use official donation addresses; do not use unverified addresses.

---

## Deployment Steps (Simple)

1. Open `BaseDonationTransfer.sol` in Remix
2. Select the contract in "Deploy & Run Transactions"
3. Constructor arguments:
   - `initialWallet` (donation address, test with burn address)
   - `initialRate` (donation rate, test with 100 = 1%)
4. Click **Deploy**
5. The deployer address is automatically set as owner

---

## References

- Base Documentation — Network Contracts List: [docs.base.org](https://docs.base.org/base-chain/network-information/base-contracts)
