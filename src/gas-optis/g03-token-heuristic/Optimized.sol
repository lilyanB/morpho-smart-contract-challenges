// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {TokenIndicators, GlobalCoefficientsProvider, ITokenHeuristic} from "./Common.sol";

contract TokenHeuristic is ITokenHeuristic {
    uint256 internal _pcPrice;
    uint256 internal _pcVolume;
    uint256 internal _pcVolatility;
    uint256 internal _pcMarketCap;
    uint256 internal _pcHolders;
    uint256 internal _pcTotalTransfers;
    uint256 internal _pcAge;

    GlobalCoefficientsProvider internal _globalCoefficientsProvider;

    function setPersonalCoefficients(
        uint256 pcPrice,
        uint256 pcVolume,
        uint256 pcVolatility,
        uint256 pcMarketCap,
        uint256 pcHolders,
        uint256 pcTotalTransfers,
        uint256 pcAge
    ) external {
        _pcPrice = pcPrice;
        _pcVolume = pcVolume;
        _pcVolatility = pcVolatility;
        _pcMarketCap = pcMarketCap;
        _pcHolders = pcHolders;
        _pcTotalTransfers = pcTotalTransfers;
        _pcAge = pcAge;
    }

    function setGlobalCoefficientsProvider(GlobalCoefficientsProvider globalCoefficientsProvider) external {
        _globalCoefficientsProvider = globalCoefficientsProvider;
    }

    function score(TokenIndicators tokenA, TokenIndicators tokenB) external view returns (uint256) {
        GlobalCoefficientsProvider globalCoefficientsProvider = _globalCoefficientsProvider;
        (uint256 scoreA, uint256 scoreB) = _scores(tokenA, tokenB, globalCoefficientsProvider);
        return (scoreA + scoreB) * 1000 / (scoreA > scoreB ? scoreA - scoreB : scoreB - scoreA);
    }

    function _scores(
        TokenIndicators tokenA,
        TokenIndicators tokenB,
        GlobalCoefficientsProvider globalCoefficientsProvider
    ) internal view returns (uint256 sA, uint256 sB) {
        uint256 price = (_pcPrice + globalCoefficientsProvider.gcPrice());
        uint256 volume = (_pcVolume + globalCoefficientsProvider.gcVolume());
        uint256 volatility = (_pcVolatility + globalCoefficientsProvider.gcVolatility());
        uint256 marketCap = (_pcMarketCap + globalCoefficientsProvider.gcMarketCap());
        uint256 holders = (_pcHolders + globalCoefficientsProvider.gcHolders());
        uint256 totalTransfers = (_pcTotalTransfers + globalCoefficientsProvider.gcTotalTransfers());
        uint256 age = (_pcAge + globalCoefficientsProvider.gcAge());

        sA += price * tokenA.price();
        sA += volume * tokenA.volume();
        sA += volatility * tokenA.volatility();
        sA += marketCap * tokenA.marketCap();
        sA += holders * tokenA.holders();
        sA += totalTransfers * tokenA.totalTransfers();
        sA += age * tokenA.age();
        sB += price * tokenB.price();
        sB += volume * tokenB.volume();
        sB += volatility * tokenB.volatility();
        sB += marketCap * tokenB.marketCap();
        sB += holders * tokenB.holders();
        sB += totalTransfers * tokenB.totalTransfers();
        sB += age * tokenB.age();
    }
}
