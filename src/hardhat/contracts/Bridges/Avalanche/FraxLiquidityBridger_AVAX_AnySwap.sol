// SPDX-License-Identifier: GPL-2.0-or-later
pragma solidity >=0.8.0;
pragma experimental ABIEncoderV2;

import "../FraxLiquidityBridger.sol";

contract FraxLiquidityBridger_AVAX_AnySwap is FraxLiquidityBridger {
    constructor (
        address _owner,
        address _timelock_address,
        address _amo_minter_address,
        address[3] memory _bridge_addresses,
        address _destination_address_override,
        string memory _non_evm_destination_address,
        string memory _name
    ) 
    FraxLiquidityBridger(_owner, _timelock_address, _amo_minter_address, _bridge_addresses, _destination_address_override, _non_evm_destination_address, _name)
    {}

    // Override with logic specific to this chain
    function _bridgingLogic(uint256 token_type, address address_to_send_to, uint256 token_amount) internal override {
        // [Avalanche]
        if (token_type == 0){
            // L1 FRAX -> anyFRAX
            // Simple dump in / CREATE2
            // AnySwap Bridge
            TransferHelper.safeTransfer(address(FRAX), bridge_addresses[0], token_amount);
        }
        else if (token_type == 1) {
            // L1 FXS -> anyFXS
            // Simple dump in / CREATE2
            // AnySwap Bridge
            TransferHelper.safeTransfer(address(FXS), bridge_addresses[1], token_amount);
        }
        else {
            // L1 USDC -> USDC.e
            // Simple dump in / CREATE2
            // AEB / Official Avalanche Bridge
            TransferHelper.safeTransfer(address(collateral_token), bridge_addresses[2], token_amount);
        }
    }

}
