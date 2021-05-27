pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {

    constructor(
        uint rate, // rate in TKNbits
        address payable wallet, // sale beneficiary
        PupperCoin token,
        uint goal,
        uint open_time,
        uint close_time// the ArcadeToken itself that the ArcadeTokenSale will work with// @TODO: Fill in the constructor parameters!
    )
        Crowdsale(rate, wallet, token)// @TODO: Pass the constructor parameters to the crowdsale contracts.
        CappedCrowdsale(goal)
        TimedCrowdsale(open_time, close_time)
        RefundableCrowdsale(goal)
        public
    {
        // constructor can stay empty
    }
}

contract PupperCoinSaleDeployer {

    address public puppercoin_sale_address;
    address public puppercoin_address;

    constructor(
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal// this address will receive all Ether raised by the sale// @TODO: Fill in the constructor parameters!
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
        PupperCoin token = new PupperCoin(name, symbol, 0);
        puppercoin_address = address(token);
        // @TODO: create the PupperCoinSale and tell it about the token, set the goal, and set the open and close times to now and now + 24 weeks.
        PupperCoinSale puppercoin_sale = new PupperCoinSale(1, wallet, token, goal, now, now+15 minutes);
        puppercoin_sale_address = address(puppercoin_sale);

        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(puppercoin_sale_address);
        token.renounceMinter();
    }
}
