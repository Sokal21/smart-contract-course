// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;
import {AggregatorV3Interface} from "@chainlink/contracts@1.1.1/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {
    function getVersion() internal view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        return priceFeed.version();
    }

    function getEthUsdPrice() internal view returns (uint256) {
        // ABI
        // Address 0x694AA1769357215DE4FAC081bf1f309aDC325306
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );

        (, int price, , , ) = priceFeed.latestRoundData();

        return uint256(price * 1e10);
    }

    function getEthUsdConversionRate(
        uint256 ethAmount
    ) internal view returns (uint256) {
        uint256 ethUsdPrice = getEthUsdPrice();
        uint256 ethAmountInUsd = (ethUsdPrice * ethAmount) / 1e18;

        return ethAmountInUsd;
    }
}
