// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title BaseDonationTransfer
 * @notice Baseチェーン向けの寄付付き送金コントラクト（教育用・デモ用）
 * @dev Ownable(msg.sender) 継承、複数寄付先対応、送金イベント記録
 */
contract BaseDonationTransfer is Ownable {
    uint256 public donationRate; // 100分率（例：100 = 1%）
    mapping(address => bool) public isDonationWallet; // 複数寄付先対応

    event TransferWithDonation(
        address indexed from,
        address indexed to,
        uint256 sentAmount,
        uint256 donatedAmount,
        address donationWallet
    );
    event DonationRateUpdated(uint256 oldRate, uint256 newRate);
    event DonationWalletAdded(address wallet);
    event DonationWalletRemoved(address wallet);

    /**
     * @param initialWallet 初期寄付先アドレス
     * @param initialRate 初期寄付率（10000 = 100%）
     */
    constructor(address initialWallet, uint256 initialRate) Ownable(msg.sender) {
        require(block.chainid == 8453, "Must deploy on Base chain");
        require(initialRate <= 10000, "Rate too high"); // 最大100%
        donationRate = initialRate;
        isDonationWallet[initialWallet] = true;
        emit DonationWalletAdded(initialWallet);
    }

    // オーナーが寄付率を更新可能
    function setDonationRate(uint256 newRate) external onlyOwner {
        require(newRate <= 10000, "Rate too high");
        emit DonationRateUpdated(donationRate, newRate);
        donationRate = newRate;
    }

    // 寄付先を追加
    function addDonationWallet(address wallet) external onlyOwner {
        require(!isDonationWallet[wallet], "Already added");
        isDonationWallet[wallet] = true;
        emit DonationWalletAdded(wallet);
    }

    // 寄付先を削除
    function removeDonationWallet(address wallet) external onlyOwner {
        require(isDonationWallet[wallet], "Not exist");
        isDonationWallet[wallet] = false;
        emit DonationWalletRemoved(wallet);
    }

    /**
     * @notice ETHを送金し、寄付先にも一定割合送金
     * @param _to 受取アドレス
     * @param donationIndex isDonationWalletの中でどの寄付先に送るか（配列順）
     */
    function sendWithDonation(address payable _to, uint256 donationIndex) external payable {
        require(msg.value > 0, "No ETH sent");
        address[] memory wallets = _getActiveWallets();
        require(donationIndex < wallets.length, "Invalid donation index");

        uint256 donated = (msg.value * donationRate) / 10000;
        uint256 sendAmount = msg.value - donated;

        // 受取先送金
        (bool s1, ) = _to.call{value: sendAmount}("");
        require(s1, "Send failed");

        // 寄付送金
        (bool s2, ) = payable(wallets[donationIndex]).call{value: donated}("");
        require(s2, "Donation failed");

        emit TransferWithDonation(msg.sender, _to, sendAmount, donated, wallets[donationIndex]);
    }

    // 現在有効な寄付先一覧取得（内部用）
    function _getActiveWallets() internal view returns (address[] memory) {
        uint256 count;
        for (uint256 i = 0; i < 256; i++) {
            if (isDonationWallet[address(uint160(i))]) count++;
        }
        address[] memory wallets = new address[](count);
        uint256 idx;
        for (uint256 i = 0; i < 256; i++) {
            address wallet = address(uint160(i));
            if (isDonationWallet[wallet]) wallets[idx++] = wallet;
        }
        return wallets;
    }
}
