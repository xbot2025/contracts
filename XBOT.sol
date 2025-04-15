// File: contracts/libs/IBEP20.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

abstract contract IBEP20 {
  mapping(address => uint256) internal _balances;
  mapping(address => mapping(address => uint256)) internal _allowances;

  uint256 public _totalSupply;
  uint8 public _decimals;
  string public _symbol;
  string public _name;

  /**
   * @dev Returns the amount of tokens in existence.
   */
  function totalSupply() external view virtual returns (uint256);

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view virtual returns (uint8);

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view virtual returns (string memory);

  /**
   * @dev Returns the token name.
   */
  function name() external view virtual returns (string memory);

  /**
   * @dev Returns the amount of tokens owned by `account`.
   */
  function balanceOf(address account) external view virtual returns (uint256);

  /**
   * @dev Moves `amount` tokens from the caller's account to `recipient`.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transfer(
    address recipient,
    uint256 amount
  ) external virtual returns (bool);

  /**
   * @dev Returns the remaining number of tokens that `spender` will be
   * allowed to spend on behalf of `owner` through {transferFrom}. This is
   * zero by default.
   *
   * This value changes when {approve} or {transferFrom} are called.
   */
  function allowance(
    address _owner,
    address spender
  ) external view virtual returns (uint256);

  /**
   * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * IMPORTANT: Beware that changing an allowance with this method brings the risk
   * that someone may use both the old and the new allowance by unfortunate
   * transaction ordering. One possible solution to mitigate this race
   * condition is to first reduce the spender's allowance to 0 and set the
   * desired value afterwards:
   * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
   *
   * Emits an {Approval} event.
   */
  function approve(
    address spender,
    uint256 amount
  ) external virtual returns (bool);

  /**
   * @dev Moves `amount` tokens from `sender` to `recipient` using the
   * allowance mechanism. `amount` is then deducted from the caller's
   * allowance.
   *
   * Returns a boolean value indicating whether the operation succeeded.
   *
   * Emits a {Transfer} event.
   */
  function transferFrom(
    address sender,
    address recipient,
    uint256 amount
  ) external virtual returns (bool);

  /**
   * @dev Emitted when `value` tokens are moved from one account (`from`) to
   * another (`to`).
   *
   * Note that `value` may be zero.
   */
  event Transfer(address indexed from, address indexed to, uint256 value);

  /**
   * @dev Emitted when the allowance of a `spender` for an `owner` is set by
   * a call to {approve}. `value` is the new allowance.
   */
  event Approval(address indexed owner, address indexed spender, uint256 value);
}

// File: contracts/libs/Context.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
  function _msgSender() internal view returns (address payable) {
    return payable(msg.sender);
  }

  function _msgData() internal view virtual returns (bytes memory) {
    this;
    return msg.data;
  }
}

// File: contracts/libs/Ownable.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * By default, the owner account will be the one that deploys the contract. This
 * can later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
  address internal _owner;
  event OwnershipTransferred(
    address indexed previousOwner,
    address indexed newOwner
  );
  event SetAdmin(address indexed uid, bool indexed is_admin);

  /**
   * @dev Initializes the contract setting the deployer as the initial owner.
   */
  constructor() {
    address msgSender = _msgSender();
    _owner = msgSender;
    emit OwnershipTransferred(address(0), msgSender);
  }

  /**
   * @dev Returns the address of the current owner.
   */
  function owner() public view returns (address) {
    return _owner;
  }

  /**
   * @dev Throws if called by any account other than the owner.
   */
  modifier onlyOwner() {
    require(_owner == _msgSender(), "Ownable: caller is not the owner");
    _;
  }

  /**
   * @dev Leaves the contract without owner. It will not be possible to call
   * `onlyOwner` functions anymore. Can only be called by the current owner.
   *
   * NOTE: Renouncing ownership will leave the contract without an owner,
   * thereby removing any functionality that is only available to the owner.
   */
  function renounceOwnership() public onlyOwner {
    emit OwnershipTransferred(_owner, address(0));
    _owner = address(0);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Can only be called by the current owner.
   */
  function transferOwnership(address newOwner) public onlyOwner {
    require(newOwner != address(0), "Ownable: new owner is the zero address");
    _transferOwnership(newOwner);
  }

  /**
   * @dev Transfers ownership of the contract to a new account (`newOwner`).
   * Internal function without access restriction.
   */
  function _transferOwnership(address newOwner) internal {
    address oldOwner = _owner;
    _owner = newOwner;
    emit OwnershipTransferred(oldOwner, newOwner);
  }


}

// File: contracts/libs/SafeMath.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
  /**
   * @dev Returns the addition of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `+` operator.
   *
   * Requirements:
   * - Addition cannot overflow.
   */
  function add(uint256 a, uint256 b) internal pure returns (uint256) {
    uint256 c = a + b;
    require(c >= a, "SafeMath: addition overflow");

    return c;
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b) internal pure returns (uint256) {
    return sub(a, b, "SafeMath: subtraction overflow");
  }

  /**
   * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
   * overflow (when the result is negative).
   *
   * Counterpart to Solidity's `-` operator.
   *
   * Requirements:
   * - Subtraction cannot overflow.
   */
  function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b <= a, errorMessage);
    uint256 c = a - b;

    return c;
  }

  /**
   * @dev Returns the multiplication of two unsigned integers, reverting on
   * overflow.
   *
   * Counterpart to Solidity's `*` operator.
   *
   * Requirements:
   * - Multiplication cannot overflow.
   */
  function mul(uint256 a, uint256 b) internal pure returns (uint256) {
    // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
    // benefit is lost if 'b' is also tested.
    // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
    if (a == 0) {
      return 0;
    }

    uint256 c = a * b;
    require(c / a == b, "SafeMath: multiplication overflow");

    return c;
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b) internal pure returns (uint256) {
    return div(a, b, "SafeMath: division by zero");
  }

  /**
   * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
   * division by zero. The result is rounded towards zero.
   *
   * Counterpart to Solidity's `/` operator. Note: this function uses a
   * `revert` opcode (which leaves remaining gas untouched) while Solidity
   * uses an invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    // Solidity only automatically asserts when dividing by 0
    require(b > 0, errorMessage);
    uint256 c = a / b;
    // assert(a == b * c + a % b); // There is no case in which this doesn't hold

    return c;
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b) internal pure returns (uint256) {
    return mod(a, b, "SafeMath: modulo by zero");
  }

  /**
   * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
   * Reverts with custom message when dividing by zero.
   *
   * Counterpart to Solidity's `%` operator. This function uses a `revert`
   * opcode (which leaves remaining gas untouched) while Solidity uses an
   * invalid opcode to revert (consuming all remaining gas).
   *
   * Requirements:
   * - The divisor cannot be zero.
   */
  function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
    require(b != 0, errorMessage);
    return a % b;
  }
}

// File: contracts/libs/IUniswapV2Factory.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IUniswapV2Factory {
  event PairCreated(
    address indexed token0,
    address indexed token1,
    address pair,
    uint256
  );

  function getPair(address _tokenA, address _tokenB)
    external
    view
    returns (address pair);

  function allPairs(uint256) external view returns (address pair);

  function allPairsLength() external view returns (uint256);

  function createPair(address _tokenA, address _tokenB)
    external
    returns (address pair);

  function setFeeToSetter(address) external;
}

// File: contracts/libs/IUniswapV2Router.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IUniswapV2Router {
  function factory() external pure returns (address);
  function WETH() external pure returns (address);

  function getAmountsOut(
    uint256 amountIn,
    address[] calldata path
  ) external view returns (uint256[] memory amounts);

  function addLiquidity(
    address tokenA,
    address tokenB,
    uint256 amountADesired,
    uint256 amountBDesired,
    uint256 amountAMin,
    uint256 amountBMin,
    address to,
    uint256 deadline
  ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

  function swapExactTokensForTokensSupportingFeeOnTransferTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external;

  function swapExactTokensForTokens(
    uint256 amountIn,
    uint256 amountOutMin,
    address[] calldata path,
    address to,
    uint256 deadline
  ) external returns (uint256[] memory amounts);
}

// File: contracts/libs/ITrade.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ITrade {
  function getSmartVault() external view returns (address);
  function updateTime() external;
}

// File: contracts/XBOT.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;






contract SmartVault {
  address public _owner;
  IBEP20 public _USDT;

  // 50%
  address public receiver1 = 0x1D6F0ab70AFB0F9480076228D38B0a7686a19797;
  // 25%
  address public receiver2 = 0x5D8C93656bFE2874e9D80cddc55aADd33DEFBdDd;
  // 25%
  address public receiver3 = 0xe645603F3f64E600f5Bf4F773Db777173b9DD623;

  constructor(address _usdt) {
    _owner = msg.sender;
    _USDT = IBEP20(_usdt);
  }

  function distribute() public {
    require(_owner == msg.sender, "permission denied");

    uint256 balance = _USDT.balanceOf(address(this));
    require(balance > 0, "No USDT to distribute");

    uint256 amount_1 = (balance * 50) / 100;
    uint256 amount_2 = (balance * 25) / 100;
    uint256 amount_3 = (balance * 25) / 100;

    require(
      _USDT.transfer(receiver1, amount_1),
      "Transfer to receiver1 failed"
    );
    require(
      _USDT.transfer(receiver2, amount_2),
      "Transfer to receiver2 failed"
    );
    require(
      _USDT.transfer(receiver3, amount_3),
      "Transfer to receiver3 failed"
    );
  }
}

contract XBOT is IBEP20, Ownable {
  using SafeMath for uint256;

  IUniswapV2Router internal _v2Router;
  SmartVault internal _smartVault; // USDT receiver contract address

  mapping(address => bool) internal _v2Pairs;

  // Trade contract
  ITrade internal _trade;
  address internal _usdtAddress;

  // Fee rates (using basis points: 100 = 1%, 10000 = 100%)
  uint256 public constant BASE_RATE = 10000;
  // Purchase restriction time
  uint256 public LIMIT_TIME = block.timestamp + 365 days * 5;
  // Fee
  uint256 public swapFeeRate = 200; // Default 2% (200/10000)
  // Transaction fee
  uint256 public swapFee;

  // Burn total
  uint256 public burnTotal;

  event SetTrade(address indexed trade, uint256 timestamp);

  constructor(address router, address usdt, address receiver) {
    _v2Router = IUniswapV2Router(router);
    address _v2Pair = IUniswapV2Factory(_v2Router.factory()).createPair(
      usdt,
      address(this)
    );
    _v2Pairs[_v2Pair] = true;

    _usdtAddress = usdt;
    _smartVault = new SmartVault(usdt);

    _name = "XBOT Token";
    _symbol = "XBOT";
    _decimals = 18;

    _totalSupply = 100000000 * 10 ** uint256(_decimals);

    _balances[receiver] = _totalSupply;
    emit Transfer(address(0), receiver, _totalSupply);
  }

  /**
   * @dev Returns the token decimals.
   */
  function decimals() external view override returns (uint8) {
    return _decimals;
  }

  /**
   * @dev Returns the token symbol.
   */
  function symbol() external view override returns (string memory) {
    return _symbol;
  }

  /**
   * @dev Returns the token name.
   */
  function name() external view override returns (string memory) {
    return _name;
  }

  /**
   * @dev Get total supply
   * @return totalSupply Total supply
   */
  function totalSupply() external view override returns (uint256) {
    return _totalSupply;
  }

  /**
   * @dev Get balance
   * @param owner Target address
   * @return balance Balance amount
   */
  function balanceOf(address owner) external view override returns (uint256) {
    return _balances[owner];
  }

  /**
   * @dev External transfer function
   * @param to Receiver address
   * @param amount Transfer amount
   * @return success Whether successful
   */
  function transfer(
    address to,
    uint256 amount
  ) external override returns (bool) {
    _transfer(msg.sender, to, amount);
    return true;
  }

  /**
   * @dev Get allowance amount
   * @param owner Owner address
   * @param spender Spender address
   * @return allowance Allowance amount
   */
  function allowance(
    address owner,
    address spender
  ) external view override returns (uint256) {
    return _allowances[owner][spender];
  }

  /**
   * @dev Internal approve function
   * @param owner Owner address
   * @param spender Spender address
   * @param amount Approval amount
   */
  function _approve(address owner, address spender, uint256 amount) internal {
    require(owner != address(0), "BEP20: approve from the zero address");
    require(spender != address(0), "BEP20: approve to the zero address");

    _allowances[owner][spender] = amount;
    emit Approval(owner, spender, amount);
  }

  /**
   * @dev Approve spending
   * @param spender Spender address
   * @param amount Approval amount
   * @return success Whether successful
   */
  function approve(
    address spender,
    uint256 amount
  ) external override returns (bool) {
    _approve(msg.sender, spender, amount);
    return true;
  }

  /**
   * @dev Transfer tokens
   * @param from Sender address
   * @param to Receiver address
   * @param amount Transfer amount
   * @return success Whether successful
   */
  function transferFrom(
    address from,
    address to,
    uint256 amount
  ) external override returns (bool) {
    _transfer(from, to, amount);
    _approve(from, msg.sender, _allowances[from][msg.sender].sub(amount));
    return true;
  }

  /**
   * @dev Increase allowance
   * @param spender Spender address
   * @param addedValue Amount to add
   * @return success Whether successful
   */
  function increaseAllowance(
    address spender,
    uint256 addedValue
  ) public returns (bool) {
    _approve(
      msg.sender,
      spender,
      _allowances[msg.sender][spender].add(addedValue)
    );
    return true;
  }

  /**
   * @dev Decrease allowance
   * @param spender Spender address
   * @param subtractedValue Amount to subtract
   * @return success Whether successful
   */
  function decreaseAllowance(
    address spender,
    uint256 subtractedValue
  ) public returns (bool) {
    _approve(
      msg.sender,
      spender,
      _allowances[msg.sender][spender].sub(subtractedValue)
    );
    return true;
  }

  /**
   * @dev Internal transfer function
   * @param from Sender address
   * @param to Receiver address
   * @param amount Transfer amount
   * @return success Whether successful
   */
  function _transfer(
    address from,
    address to,
    uint256 amount
  ) internal returns (bool) {
    // Call updateTime function of Trade contract
    _trade.updateTime();

    if ((_v2Pairs[from] || _v2Pairs[to]) && from != address(this)) {
      bool isBuy = _v2Pairs[from];
      bool isSell = _v2Pairs[to];

      address _tradeSmartVault = _trade.getSmartVault();

      // Can only purchase through Dapp within 180 days, free trading after 180 days
      if (isBuy && block.timestamp < LIMIT_TIME && to != _tradeSmartVault) {
        revert("Not allowed");
      }

      // Fee
      uint256 feeAmount = amount.mul(swapFeeRate).div(BASE_RATE);
      _balances[address(this)] = _balances[address(this)].add(feeAmount);

      swapFee = swapFee.add(feeAmount);

      if (
        // 仅在出售时
        isSell &&
        // 添加池子不出售
        msg.sender != address(_v2Router) &&
        // 避免死循环
        from != address(this)
      ) {
        _sellTokens(swapFee);
        swapFee = 0;
      }

      _balances[from] = _balances[from].sub(amount);
      _balances[to] = _balances[to].add(amount.sub(feeAmount));

      emit Transfer(from, address(this), feeAmount);
      emit Transfer(from, to, amount.sub(feeAmount));

      // Check if 'to' is zero address, if yes, reduce the total supply
      if (to == address(0)) {
        _totalSupply = _totalSupply.sub(amount.sub(feeAmount));
        burnTotal += amount;
      }

      return true;
    }

    _balances[from] = _balances[from].sub(amount);
    _balances[to] = _balances[to].add(amount);

    emit Transfer(from, to, amount);

    // Check if 'to' is zero address, if yes, reduce the total supply
    if (to == address(0)) {
      _totalSupply = _totalSupply.sub(amount);
      burnTotal += amount;
    }

    return true;
  }

  /**
   * @dev Swap specified amount of tokens for USDT and transfer to specified address
   * @param tokenAmount Amount of tokens to swap
   */
  function _sellTokens(uint256 tokenAmount) private {
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = _usdtAddress;

    // Ensure sufficient authorization
    _approve(address(this), address(_v2Router), tokenAmount);

    try
      _v2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
        tokenAmount,
        0,
        path,
        address(_smartVault),
        block.timestamp
      )
    {
      // Call distribution after successful swap
      _smartVault.distribute();
    } catch Error(string memory reason) {
      revert(string(abi.encodePacked("Swap failed: ", reason)));
    }
  }

  function setTrade(address trade) external onlyOwner {
    require(trade != address(0), "Invalid trade address");
    _trade = ITrade(trade);
    emit SetTrade(trade, block.timestamp);
  }
}
