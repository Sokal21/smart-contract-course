// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

import "./PriceConverter.sol";

contract FundMe {
    using PriceConverter for uint256;

    uint256 public constant minimunUsdFundingAmount = 50 * 1e18;

    address[] public funders;
    struct Donation {
        uint256 ethOriginalAmount;
        uint256 usdAmountAt;
        bool withdrawed;
    }
    mapping(address => Donation) public addressToAmountFunded;
    mapping(address => bool) public addressThatFounded;
    address public immutable owner;

    constructor() {
        owner = msg.sender;
    }

    function getFunderDonation(
        address founderAddress
    ) public view returns (uint256 ethOriginalAmount, uint256 usdAmountAt) {
        Donation memory donation = addressToAmountFunded[founderAddress];

        return (donation.ethOriginalAmount, donation.usdAmountAt);
    }

    function fund() public payable {
        uint256 usdAmount = msg.value.getEthUsdConversionRate();
        require(usdAmount >= minimunUsdFundingAmount, "Didn't send enough!");

        bool alreadyFound = addressThatFounded[msg.sender];

        if (alreadyFound) {
            Donation memory donation = addressToAmountFunded[msg.sender];

            donation.ethOriginalAmount += msg.value;
            donation.usdAmountAt += usdAmount;

            addressToAmountFunded[msg.sender] = donation;
        } else {
            funders.push(msg.sender);
            Donation memory donation = Donation({
                ethOriginalAmount: msg.value,
                usdAmountAt: usdAmount,
                withdrawed: false
            });

            addressToAmountFunded[msg.sender] = donation;
            addressThatFounded[msg.sender] = true;
        }
    }

    function withdrawFunds() public ownerOnly {
        for (uint256 index = 0; index < funders.length; index++) {
            Donation memory donation = addressToAmountFunded[funders[index]];

            donation.withdrawed = true;
        }

        funders = new address[](0);

        (bool successTransfer, ) = payable(msg.sender).call{
            value: address(this).balance
        }("");
        require(successTransfer, "Transfer failed");
    }

    modifier ownerOnly() {
        require(msg.sender == owner, "You are not the owner!");
        _;
    }
}
