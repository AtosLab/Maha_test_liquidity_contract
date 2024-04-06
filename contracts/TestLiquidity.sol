pragma solidity ^0.8.0;

import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IERC20.sol";

contract TestLiquidity {
    address internal constant UNISWAP_ROUTER_ADDRESS =
        0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;

    IUniswapV2Router02 public uniswapRouter;

    constructor() {
        uniswapRouter = IUniswapV2Router02(UNISWAP_ROUTER_ADDRESS);
    }

    function buyback(address token)
        public
        payable
        returns (uint256 _liquidity)
    {
        uint256 price = msg.value / 2;
        uint256 deadline = block.timestamp + 30;
        uint256[] memory amount = getEstimatedErc20(price, token);
        uniswapRouter.swapETHForExactTokens{value: price}(
            amount[1],
            getPathForErc20(token),
            address(this),
            deadline
        );

        IERC20(token).approve(UNISWAP_ROUTER_ADDRESS, amount[1]);

        (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        ) = uniswapRouter.addLiquidityETH{value: price}(
                token,
                amount[1],
                1,
                1,
                msg.sender,
                deadline
            );

        uint256 restERC20 = amount[1] - amountToken;

        IERC20(token).transfer(msg.sender, restERC20);
        payable(msg.sender).transfer(address(this).balance);
        _liquidity = liquidity;
    }

    function getEstimatedErc20(uint256 price, address token)
        public
        view
        returns (uint256[] memory)
    {
        return uniswapRouter.getAmountsOut(price, getPathForErc20(token));
    }

    function getPathForErc20(address token)
        internal
        view
        returns (address[] memory)
    {
        address[] memory path = new address[](2);
        path[0] = uniswapRouter.WETH();
        path[1] = token;

        return path;
    }
}
