// File: contracts/IBEP20.sol

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

// File: contracts/Context.sol

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

// File: contracts/Ownable.sol

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

// File: contracts/SafeMath.sol

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

// File: contracts/IUniswapV2Router.sol

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

// File: contracts/IUniswapV2Factory.sol

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

// File: contracts/IUniswapV2Pair.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IUniswapV2Pair {

  function factory() external view returns (address);

  function token0() external view returns (address);

  function token1() external view returns (address);

  function skim(address to) external;

  function sync() external;

  function getReserves()
    external
    view
    returns (
      uint112 reserve0,
      uint112 reserve1,
      uint32 blockTimestampLast
    );

}

// File: contracts/FeeSmartVault.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;


contract FeeSmartVault {
  // Using SafeMath library for secure mathematical operations
  using SafeMath for uint256;

  address public _owner;
  IBEP20 public _TOKEN;

  address public _platform_1 = 0x2c6F0f4142400405B41947B3b0Ca8487fd68e6C7;
  address public _platform_2 = 0x8c8aC599E3aBef270825D1C6fFa02a74Ecc39617;
  address public _platform_3 = 0x55d1293Dfe010ED915dDda763c03e03A342ac4f7;

  address public _dev_1 = 0x42A0Af70de3Af2Dab6B0E3632f0B2E99eB6356Cb;
  address public _dev_2 = 0xB72EB543654DbF4B6B4042e4197f596CC73B01db;

  constructor(address _token) {
    _owner = msg.sender;
    _TOKEN = IBEP20(_token);
  }

  function allocationFee() public {
    require(_owner == msg.sender, "permission denied");

    uint256 _TOKENBalance = _TOKEN.balanceOf(address(this));
    if (_TOKENBalance > 0) {
      uint256 feeAmount = _TOKENBalance.mul(25).div(100);
      uint256 devAmount = feeAmount.div(2);

      _TOKEN.transfer(_platform_1, feeAmount);
      _TOKEN.transfer(_platform_2, feeAmount);
      _TOKEN.transfer(_platform_3, feeAmount);
      _TOKEN.transfer(_dev_1, devAmount);
      _TOKEN.transfer(_dev_2, feeAmount.sub(devAmount));
    }
  }
}

// File: contracts/Trade.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;







contract TradeSmartVault {
  using SafeMath for uint256;
  address public _owner;
  IBEP20 public _XBT;

  modifier onlyOwner() {
    require(_owner == msg.sender, "permission denied");
    _;
  }

  constructor(address _xbt) {
    _owner = msg.sender;
    _XBT = IBEP20(_xbt);
  }

  /**
   * @dev Transfer specified amount of XBT tokens to contract owner
   * @param amount Amount to transfer
   * @return Actual amount transferred
   */
  function transfer(uint256 amount) public onlyOwner returns (uint256) {
    require(amount > 0, "Amount must be greater than 0");

    uint256 _XBTBalance = _XBT.balanceOf(address(this));
    if (_XBTBalance < amount) {
      amount = _XBTBalance;
    }
    require(_XBT.transfer(msg.sender, amount), "Transfer failed");

    return amount;
  }

  /**
   * @dev Burn all XBT tokens in the contract
   */
  function burn() public onlyOwner {
    uint256 _XBTBalance = _XBT.balanceOf(address(this));
    if (_XBTBalance > 0) {
      require(_XBT.transfer(address(0), _XBTBalance), "Transfer failed");
    }
  }
}

contract MarketSmartVault {
  using SafeMath for uint256;
  address public _owner;
  IBEP20 public _USDT;

  modifier onlyOwner() {
    require(_owner == msg.sender, "permission denied");
    _;
  }

  constructor(address _usdt) {
    _owner = msg.sender;
    _USDT = IBEP20(_usdt);
  }

  /**
   * @dev Transfer USDT tokens from the market vault to the owner
   * @param amount Amount of USDT to transfer
   * @return Actual amount transferred (may be less if insufficient balance)
   */
  function transfer(uint256 amount) public onlyOwner returns (uint256) {
    require(amount > 0, "Amount must be greater than 0");

    uint256 _USDTBalance = _USDT.balanceOf(address(this));
    if (_USDTBalance < amount) {
      amount = _USDTBalance;
    }
    require(_USDT.transfer(msg.sender, amount), "Transfer failed");

    return amount;
  }
}

contract Trade is Ownable {
  // Using SafeMath library for secure mathematical operations
  using SafeMath for uint256;

  // Reentrancy lock
  bool private _locked;

  // Reentrancy guard modifier
  modifier nonReentrant() {
    require(!_locked, "ReentrancyGuard: reentrant call");
    _locked = true;
    _;
    _locked = false;
  }

  struct User {
    // User wallet address
    address uid;
    // Referrer wallet address
    address pid;
    // Number of valid referrals
    uint256 invite;
    // Unique invite code for user
    string code;
    // User level
    uint256 level;
    // PV
    uint256 pv;
    // Team PV
    uint256 pv_team;
    // Maximum area PV
    uint256 pv_area_max;
    // Minimum area PV
    uint256 pv_area_min;
    // Amount of USDT invested
    uint256 burn_value;
    // Base mining power from direct investment
    uint256 power;
    // Team rewards
    uint256 team_reward;
    // Timestamp of investment
    uint256 burn_time;
    // Mining rate
    uint256 mint_rate;
    // Total amount mined
    uint256 mint_total;
    // Next decrease timestamp
    uint256 mint_decrease;
    // Last mining timestamp
    uint256 mint_last;
    // User registration timestamp
    uint256 time;
  }

  address[] internal _all_users;
  // Mapping of user addresses to their information
  mapping(address => User) internal _users;
  // Mapping of referrer addresses to their referral list
  mapping(address => address[]) internal _inviters;
  // Mapping of timestamps to recorded prices
  mapping(uint256 => uint256) internal _prices;

  // Mapping of timestamps to recorded burn amount
  mapping(uint256 => uint256) internal _burn_today;

  // Mapping of invite codes to user addresses
  mapping(string => address) internal _codes;

  // Leader reward mapping - tracks accumulated rewards for each user
  mapping(address => uint256) internal _leader_reward;
  // Leader reward time mapping - tracks last reward claim time for each user
  mapping(address => uint256) internal _reward_time;

  // Base rate for percentage calculations (10000 = 100%)
  uint256 public constant BASE_RATE = 10000;
  // Initial mining rate
  uint256 public constant MINT_RATE = 100;
  // Minimum purchase amount
  uint256 public constant MIN_PURCHASE = 10 * 10 ** 18;
  // Maximum purchase amount
  uint256 public constant MAX_PURCHASE = 100 * 10 ** 18;
  // Time period after which mining power is halved
  uint256 public constant DECREASE_TIME = 100 days;
  // Time period between mining cycles
  uint256 public constant MINT_CYCLE = 24 hours;
  // Minimum burn amount
  uint256 public constant MIN_BURN = 100 * 10 ** 18;
  // Time period after which the burn limit is reset
  uint256 public LIMIT_TIME;
  // Address for market allocation (8%)
  address internal _market = 0xb8E5BDBE8db99F909D4B6eAd2EcF0757eAaDc84a;
  // Address for platform allocation (4%) and deposit funds
  address internal _community = 0x05A9BE3Ae4bb53032519485775293150d1748f46;
  // Address for supporter allocation (3%)
  address internal _supporter = 0xEb49B6e773AA6fb808C13331A763ce8effAAb9c3;
  // Current mining cycle timestamp
  uint256 internal _time;
  // Daily burn limit
  uint256 internal _burn_limit;
  // Total amount of tokens mined across all users
  uint256 public mint_total;

  uint256 internal _protecting;
  uint256 internal _protected_time;

  // Maximum count of users eligible for 20% bonus (first 500 users investing >= 1000U)
  uint256 internal _invest_1000 = 500;
  // Current count of users who have invested >= 1000U and received the bonus
  uint256 internal _invest_1000_count;

  // XBT/USDT liquidity pair address from DEX
  address internal _xbt_pair;

  // Burn mix limit time
  uint256 internal _burn_mix_limit_time;

  // Smart vault for managing XBT token operations
  TradeSmartVault internal _tradeSmartVault;
  // Smart vault for managing USDT market operations
  MarketSmartVault internal _marketSmartVault;
  // Smart vault for managing withdraw fee operations
  FeeSmartVault internal _feeSmartVault;

  // Token contract instances
  IBEP20 internal _USDT;
  IBEP20 internal _XBT;
  IBEP20 internal _XBOT;

  // DEX router instance
  IUniswapV2Router internal _v2Router;

  // Events
  event Register(address indexed uid, address indexed pid, uint256 time);
  event Burn(
    address indexed uid,
    address indexed token,
    uint256 amount,
    uint256 time
  );
  event BurnMix(
    address indexed uid,
    uint256 amount1,
    uint256 amount2,
    uint256 time
  );
  event UpdateTime(uint256 time);
  event UpdatePrice(uint256 price, uint256 time);
  event UpdateIndex(uint256 price, uint256 burn_limit, uint256 time);

  /**
   * @dev Constructor initializes the contract with required parameters
   * @param router DEX router address
   * @param usdt USDT token contract address
   * @param xbt XBT token contract address
   * @param user Initial admin user address
   * @param time Initial timestamp
   */
  constructor(
    address router,
    IBEP20 usdt,
    IBEP20 xbt,
    IBEP20 xbot,
    address user,
    uint256 time
  ) {
    _v2Router = IUniswapV2Router(router);
    _USDT = usdt;
    _XBT = xbt;
    _XBOT = xbot;
    _xbt_pair = IUniswapV2Factory(_v2Router.factory()).getPair(
      address(_USDT),
      address(_XBT)
    );

    _tradeSmartVault = new TradeSmartVault(address(_XBT));
    _marketSmartVault = new MarketSmartVault(address(_USDT));
    _feeSmartVault = new FeeSmartVault(address(_XBT));

    if (block.chainid == 97) {
      uint256 days_passed = block.timestamp.sub(time).div(MINT_CYCLE);
      _time = time.add(days_passed.mul(MINT_CYCLE));
    } else {
      _time = time;
    }

    _burn_mix_limit_time = _time.add(10 days);

    // Initialize user
    _users[user] = User({
      uid: user,
      pid: address(0),
      invite: 0,
      code: generateCode(),
      level: 0,
      pv: 0,
      pv_team: 0,
      pv_area_max: 0,
      pv_area_min: 0,
      burn_value: 1000 * 10 ** 18,
      power: 1000 * 10 ** 18,
      team_reward: 0,
      burn_time: 0,
      mint_rate: 100,
      mint_decrease: _time.add(DECREASE_TIME).add(MINT_CYCLE),
      mint_total: 0,
      mint_last: _time,
      time: block.timestamp
    });
    _codes[_users[user].code] = user;
    _all_users.push(user);

    emit Register(user, address(0), block.timestamp);
  }

  /**
   * @dev Get smart vault address
   * @return Smart vault contract address
   */
  function getTradeSmartVault() public view returns (address) {
    return address(_tradeSmartVault);
  }

  /**
   * @dev Get market smart vault address
   * @return Market smart vault contract address
   */
  function getMarketSmartVault() public view returns (address) {
    return address(_marketSmartVault);
  }

  /**
   * @dev Get fee smart vault address
   * @return Fee smart vault contract address
   */
  function getFeeSmartVault() public view returns (address) {
    return address(_feeSmartVault);
  }

  /**
   * @dev Generates a 10-character unique invite code
   * @return A 10-character string combining letters and numbers
   */
  function generateCode() public view returns (string memory) {
    // Create a random hash using address and current block information
    bytes32 hash = keccak256(
      abi.encodePacked(
        msg.sender,
        block.timestamp,
        block.number,
        block.prevrandao,
        blockhash(block.number - 1)
      )
    );

    // Define the characters that can be used in the invite code
    bytes memory charset = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";

    // Create a 10-character string
    bytes memory result = new bytes(10);

    // Fill the result with characters from the charset
    for (uint256 i = 0; i < 10; i++) {
      // Use each 4 bits of the hash to select a character (0-35)
      uint8 charIndex = uint8(uint256(hash) % 36);
      result[i] = charset[charIndex];
      // Shift hash by 4 bits for next iteration
      hash = bytes32(uint256(hash) / 36);
    }

    return string(result);
  }

  /**
   * @dev Register user
   * @param code Invite code
   */
  function register(string memory code) public nonReentrant {
    require(_users[msg.sender].uid == address(0), "User already registered");
    require(_codes[code] != address(0), "Invite code not found");
    require(_users[_codes[code]].power > 0, "The referrer has not invested");

    string memory inviteCode = generateCode();
    require(
      _codes[string(inviteCode)] == address(0),
      "Invite code already exists"
    );

    updateTime();
    _detectAndProtect();

    _users[msg.sender] = User({
      uid: msg.sender,
      pid: _codes[code],
      invite: 0,
      code: inviteCode,
      level: 0,
      pv: 0,
      pv_team: 0,
      pv_area_max: 0,
      pv_area_min: 0,
      burn_value: 0,
      power: 0,
      team_reward: 0,
      burn_time: 0,
      mint_rate: 0,
      mint_decrease: 0,
      mint_total: 0,
      mint_last: _time,
      time: block.timestamp
    });
    _codes[_users[msg.sender].code] = msg.sender;
    _inviters[_codes[code]].push(msg.sender);
    _all_users.push(msg.sender);
    emit Register(msg.sender, _codes[code], block.timestamp);

    _buyXBTToken();
  }

  /**
   * @dev Get user info
   * @param uid User address
   * @return User information struct
   */
  function getUserInfo(address uid) public view returns (User memory) {
    return _users[uid];
  }

  /**
   * @dev Get referrer info
   * @param code Invite code
   * @return Referrer information struct
   */
  function getReferrer(string memory code) public view returns (User memory) {
    return _users[_codes[code]];
  }

  /**
   * @dev Set min and max area PV
   * @param uid User address
   */
  function _setAreaPv(address uid) private {
    uint256 maxAreaPV = 0;
    uint256 totalPV = 0;
    address[] memory inviters = _inviters[uid];
    for (uint256 i = 0; i < inviters.length; i++) {
      uint256 pv = _users[inviters[i]].pv_team + _users[inviters[i]].burn_value;
      if (pv > maxAreaPV) {
        maxAreaPV = pv;
      }
      totalPV += pv;
    }
    _users[uid].pv_area_max = maxAreaPV;
    _users[uid].pv_area_min = totalPV.sub(maxAreaPV);
  }

  /**
   * @dev Upgrade user level
   * @param uid User address to upgrade
   */
  function _upgradeLevel(address uid) private {
    // Is the user already at the highest level?
    if (_users[uid].level >= 5) return;

    // Calculate the minimum area PV for the user
    uint256 minPv = _users[uid].pv_area_min;
    uint256 maxPv = _users[uid].pv_area_max;

    // Upgrade user level based on minimum area PV
    if (minPv >= 400000 * 10 ** 18 && maxPv >= 100000 * 10 ** 18) {
      _users[uid].level = 5;
    } else if (
      minPv >= 200000 * 10 ** 18 &&
      maxPv >= 50000 * 10 ** 18 &&
      _users[uid].level < 4
    ) {
      _users[uid].level = 4;
    } else if (
      minPv >= 100000 * 10 ** 18 &&
      maxPv >= 35000 * 10 ** 18 &&
      _users[uid].level < 3
    ) {
      _users[uid].level = 3;
    } else if (
      minPv >= 50000 * 10 ** 18 &&
      maxPv >= 20000 * 10 ** 18 &&
      _users[uid].level < 2
    ) {
      _users[uid].level = 2;
    } else if (
      minPv >= 25000 * 10 ** 18 &&
      maxPv >= 10000 * 10 ** 18 &&
      _users[uid].level < 1
    ) {
      _users[uid].level = 1;
    }
  }

  /**
   * @dev Set PV (Performance Value) and update user levels in the referral chain
   * This function propagates PV up the referral chain and updates user levels based on minimum area PV
   * @param uid User address whose PV is being added
   * @param pv Performance Value amount to add
   */
  function _setParentPV(address uid, uint256 pv) private {
    address pid = _users[uid].pid;
    if (pid == address(0)) return;
    uint256 level = 1;
    do {
      _users[pid].pv_team += pv;

      _setAreaPv(pid);
      _setAreaPv(_users[pid].pid);

      _upgradeLevel(pid);
      _upgradeLevel(_users[pid].pid);

      pid = _users[pid].pid;
      level++;
    } while (level <= 12 && pid != address(0));
  }

  /**
   * @dev Invest and burn
   * @param token Token address
   * @param amount Token amount
   */
  function burn(address token, uint256 amount) public nonReentrant {
    require(_users[msg.sender].uid != address(0), "User not registered");
    require(_users[msg.sender].power == 0, "User has burned");
    require(token == address(_USDT) || token == address(_XBT), "Invalid token");
    if (token == address(_USDT)) {
      require(amount >= MIN_BURN, "Amount must be greater than 100 USDT");
    } else {
      require(
        usdtAmount(amount, token) >= MIN_BURN,
        "Amount must be greater than 100 USDT"
      );
    }

    updateTime();
    _detectAndProtect();

    if (LIMIT_TIME == 0) {
      LIMIT_TIME = _time.add(MINT_CYCLE);
    }

    address uid = msg.sender;

    uint256 burnAmount = amount;
    if (token == address(_XBT)) {
      burnAmount = usdtAmount(amount, token);
    }

    _users[uid].power = burnAmount;
    _users[uid].burn_value = burnAmount;
    _users[uid].mint_rate = MINT_RATE;

    _users[uid].burn_time = _time;
    // First mining time
    _users[uid].mint_decrease = _time.add(DECREASE_TIME).add(MINT_CYCLE);
    // Latest mining time
    _users[uid].mint_last = _time;

    // Direct performance
    _users[_users[uid].pid].pv += burnAmount;

    _setParentPV(uid, burnAmount);

    // Record count of first 500 users who invested >= 1000U
    if (
      _users[uid].power >= 1000 * 10 ** 18 && _invest_1000_count < _invest_1000
    ) {
      // Reward 20% additional mining power for investments over 1000U
      _users[uid].power = _users[uid].power.mul(120).div(100);
      _invest_1000_count++;
    }

    if (_users[uid].pid != address(0)) {
      _users[_users[uid].pid].invite += 1;
    }

    // Transfer
    IBEP20(token).transferFrom(uid, address(this), amount);

    // Allocate to market 8%
    IBEP20(token).transfer(_market, amount.mul(800).div(BASE_RATE));
    // Allocate to community 4%
    IBEP20(token).transfer(_community, amount.mul(400).div(BASE_RATE));
    // Allocate to supporter 3%
    IBEP20(token).transfer(_supporter, amount.mul(300).div(BASE_RATE));

    if (token == address(_USDT)) {
      // Maintain liquidity 10%
      IBEP20(token).transfer(
        address(_marketSmartVault),
        amount.mul(1000).div(BASE_RATE)
      );

      if (
        _burn_today[_time] >= _burn_limit &&
        _burn_limit > 0 &&
        block.timestamp >= LIMIT_TIME
      ) {
        _addLiquidity(amount.mul(200).div(BASE_RATE));
      } else {
        // Buy XBT and burn
        _buyXBTToken();
      }
    } else {
      // Burn 85% of XBT
      _XBT.transfer(address(0), amount.mul(8500).div(BASE_RATE));
    }

    emit Burn(uid, token, burnAmount, block.timestamp);
  }

  /**
   * @dev Mixed token burn function - allows users to burn a combination of XBOT and USDT tokens
   * @param amountXbot Amount of XBOT tokens to burn
   * @param amountUSDT Amount of USDT tokens to burn
   */
  function burnMix(uint256 amountXbot, uint256 amountUSDT) public nonReentrant {
    require(_users[msg.sender].uid != address(0), "User not registered");
    require(_users[msg.sender].power == 0, "User has burned");
    require(_burn_mix_limit_time > _time, "Burn mix limit time");
    require(amountXbot > 0 && amountUSDT > 0, "Amount must be greater than 0");

    uint256 xbotValue = usdtAmount(amountXbot, address(_XBOT));
    uint256 burnAmount = xbotValue.add(amountUSDT);

    require(burnAmount >= 99 * 10 ** 18, "Amount must be greater than 99 USDT");
    require(
      xbotValue.mul(BASE_RATE).div(burnAmount) <= 2100,
      "XBOT ratio must be less than or equal to 21%"
    );

    updateTime();
    _detectAndProtect();

    if (LIMIT_TIME == 0) {
      LIMIT_TIME = _time.add(MINT_CYCLE);
    }

    address uid = msg.sender;

    _users[uid].power = burnAmount;
    _users[uid].burn_value = burnAmount;
    _users[uid].mint_rate = MINT_RATE;

    _users[uid].burn_time = _time;
    // First mining time
    _users[uid].mint_decrease = _time.add(DECREASE_TIME).add(MINT_CYCLE);
    // Latest mining time
    _users[uid].mint_last = _time;

    // Direct performance
    _users[_users[uid].pid].pv += burnAmount;

    _setParentPV(uid, burnAmount);

    // Record count of first 500 users who invested >= 1000U
    if (
      // Because the portfolio investment has accuracy issues
			// all judgments will be changed to 999 USDT
      _users[uid].power >= 999 * 10 ** 18 && _invest_1000_count < _invest_1000
    ) {
      // Reward 20% additional mining power for investments over 1000U
      _users[uid].power = _users[uid].power.mul(120).div(100);
      _invest_1000_count++;
    }

    if (_users[uid].pid != address(0)) {
      _users[_users[uid].pid].invite += 1;
    }

    // Transfer
    _XBOT.transferFrom(uid, address(this), amountXbot);
    _USDT.transferFrom(uid, address(this), amountUSDT);

    // Maintain liquidity 10%
    _USDT.transfer(
      address(_marketSmartVault),
      amountUSDT.mul(1000).div(BASE_RATE)
    );
    // Allocate to market 8%
    _USDT.transfer(_market, amountUSDT.mul(800).div(BASE_RATE));
    // Allocate to community 4%
    _USDT.transfer(_community, amountUSDT.mul(400).div(BASE_RATE));
    // Allocate to supporter 3%
    _USDT.transfer(_supporter, amountUSDT.mul(300).div(BASE_RATE));

    // Allocate to market 8%
    _XBOT.transfer(_market, amountXbot.mul(800).div(BASE_RATE));
    // Allocate to community 4%
    _XBOT.transfer(_community, amountXbot.mul(400).div(BASE_RATE));
    // Allocate to supporter 3%
    _XBOT.transfer(_supporter, amountXbot.mul(300).div(BASE_RATE));
    // Burn 85% of XBOT
    _XBOT.transfer(address(0), amountXbot.mul(8500).div(BASE_RATE));

    if (
      _burn_today[_time] >= _burn_limit &&
      _burn_limit > 0 &&
      block.timestamp >= LIMIT_TIME
    ) {
      _addLiquidity(amountUSDT.mul(200).div(BASE_RATE));
    } else {
      // Buy XBT and burn
      _buyXBTToken();
    }

    emit BurnMix(uid, amountXbot, amountUSDT, block.timestamp);
  }

  /**
   * @dev Allocate rewards to users within 12 generations of superiors
   * @param uid User address
   * @param amount Token amount
   */
  function _processReferralReward(address uid, uint256 amount) private {
    if (_users[uid].pid == address(0)) return;
    address pid = _users[uid].pid;
    if (pid == address(0)) return;

    uint256 level = 1;
    uint256 rate;
    do {
      if (level == 1) {
        rate = 800;
      } else if (level == 2) {
        rate = 500;
      } else if (level == 3) {
        rate = 300;
      } else if (level >= 4) {
        rate = 100;
      }

      uint256 _XBTBalance = _XBT.balanceOf(address(this));
      if (_XBTBalance == 0) {
        return;
      }

      // Calculating referral rewards
      uint256 reward = (amount * rate) / BASE_RATE;

      if (_XBTBalance < reward) {
        reward = _XBTBalance;
      }

      if (_users[pid].invite >= level) {
        _XBT.transfer(pid, reward);
        _users[pid].team_reward += reward;
        _users[pid].mint_total += reward;
        mint_total += reward;
      }

      level++;
      pid = _users[pid].pid;
    } while (level <= 12 && pid != address(0));
  }

  /**
   * @dev Buy XBT tokens using contract's USDT balance
   * Implements dynamic purchase logic based on burn limits and liquidity conditions
   * Either adds liquidity or burns tokens depending on pool state
   */
  function _buyXBTToken() private {
    uint256 balance = _USDT.balanceOf(address(this));
    // Maximum purchase amount is 3% of contract balance
    if (balance == 0) return;

    uint256 price = xbtAmount(1 * 10 ** 18);
    if (price == 0) revert("No liquidity");

    if (
      block.timestamp >= LIMIT_TIME &&
      _burn_today[_time] >= _burn_limit &&
      _burn_limit > 0
    ) {
      return;
    }

    uint256 amount;
    if (balance > MIN_PURCHASE) {
      amount = balance.mul(30).div(BASE_RATE);
      // Maximum purchase amount
      if (amount >= MAX_PURCHASE) {
        amount = MAX_PURCHASE;
      } else if (amount <= MIN_PURCHASE) {
        amount = MIN_PURCHASE;
      }
    } else {
      amount = balance;
    }

    if (
      block.timestamp >= LIMIT_TIME &&
      _burn_today[_time] + amount > _burn_limit &&
      _burn_limit > 0
    ) {
      amount = _burn_limit - _burn_today[_time];
    }

    _burn_today[_time] += amount;

    uint256 lpXBT = _XBT.balanceOf(_xbt_pair);

    if (lpXBT < 15000 * 10 ** 18) {
      _addLiquidity(amount);
    } else {
      _buyToken(amount);
      _tradeSmartVault.burn();
    }
  }

  /**
   * @dev Buy token
   * @param amount Purchase amount
   */
  function _buyToken(uint256 amount) private {
    if (amount == 0) return;

    address to = address(_tradeSmartVault);

    address[] memory path = new address[](2);
    path[0] = address(_USDT);
    path[1] = address(_XBT);

    // Approve
    _USDT.approve(address(_v2Router), amount);
    // Buy and burn
    _v2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
      amount,
      0,
      path,
      to,
      block.timestamp.add(60)
    );
  }

  /**
   * @dev Get liquidity pool reserves for XBT/USDT pair
   * @return usdtReserve USDT reserve amount in the liquidity pool
   * @return xbtReserve XBT reserve amount in the liquidity pool
   */
  function getReserves()
    private
    view
    returns (uint256 usdtReserve, uint256 xbtReserve)
  {
    (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(_xbt_pair)
      .getReserves();
    address token0 = IUniswapV2Pair(_xbt_pair).token0();
    if (token0 == address(_USDT)) {
      usdtReserve = reserve0;
      xbtReserve = reserve1;
    } else {
      usdtReserve = reserve1;
      xbtReserve = reserve0;
    }
  }

  /**
   * @dev Add liquidity to the XBT/USDT pair and burn LP tokens
   * @param amountA USDT amount to use for adding liquidity
   */
  function _addLiquidity(uint256 amountA) private {
    if (_USDT.balanceOf(address(this)) < amountA) {
      return;
    }

    amountA = amountA.div(2);

    _buyToken(amountA);

    address tokenA = address(_USDT);
    address tokenB = address(_XBT);

    (uint256 usdtReserve, uint256 xbtReserve) = getReserves();
    uint256 amountB = amountA.mul(xbtReserve).div(usdtReserve);

    amountB = _tradeSmartVault.transfer(amountB);

    uint256 amountADesired = amountA;
    uint256 amountBDesired = amountB;
    uint256 amountAMin = 0;
    uint256 amountBMin = 0;
    uint256 deadline = block.timestamp;
    // Burn LP tokens directly
    address to = address(0);

    _USDT.approve(address(_v2Router), amountA);
    _XBT.approve(address(_v2Router), amountB);

    _v2Router.addLiquidity(
      tokenA,
      tokenB,
      amountADesired,
      amountBDesired,
      amountAMin,
      amountBMin,
      to,
      deadline
    );
  }

  /**
   * @dev Calculate XBT token amount that can be obtained with given USDT amount
   * @param amount USDT amount to exchange
   * @return XBT token amount that can be obtained
   */
  function xbtAmount(uint256 amount) public view returns (uint256) {
    // Create trading path
    address[] memory path = new address[](2);
    path[0] = address(_USDT); // USDT
    path[1] = address(_XBT); // XBT

    try _v2Router.getAmountsOut(amount, path) returns (
      uint256[] memory amounts
    ) {
      return amounts[1];
    } catch {
      return 0;
    }
  }

  /**
   * @dev Calculate USDT amount that can be obtained with given token amount
   * @param amount Token amount to exchange
   * @param token Token address (XBT or XBOT)
   * @return USDT amount that can be obtained
   */
  function usdtAmount(
    uint256 amount,
    address token
  ) public view returns (uint256) {
    address[] memory path = new address[](2);
    if (token == address(_XBT)) {
      path[0] = address(_XBT); // XBT
    } else if (token == address(_XBOT)) {
      path[0] = address(_XBOT); // XBOT
    }
    path[1] = address(_USDT); // USDT

    try _v2Router.getAmountsOut(amount, path) returns (
      uint256[] memory amounts
    ) {
      return amounts[1];
    } catch {
      return 0;
    }
  }

  /**
   * @dev Update the current mining cycle time and trigger price/index updates
   * @return Whether the time update was successful
   */
  function updateTime() public returns (bool) {
    uint256 time = _time;

    if (time.add(MINT_CYCLE) > block.timestamp) {
      return true;
    }

    // Calculate complete days passed
    uint256 days_passed = block.timestamp.sub(time).div(MINT_CYCLE);
    time = time.add(days_passed.mul(MINT_CYCLE));
    _time = time;

    emit UpdateTime(time);

    // Update price after updating time
    _updateIndex();
    return true;
  }

  /**
   * @dev Check and protect the price index
   * This function monitors the price of XBT and triggers the price protection mechanism if necessary.
   * If the protection amount (_protecting) is greater than 0, it will use the protection funds to buy and burn tokens in batches.
   * If the price drops to less than 50% of the index price, it will allocate a portion of the market vault's USDT balance to the protection fund for future use.
   */
  function _detectAndProtect() private {
    if (_protecting > 0) {
      if (_protected_time != _time) {
        _protecting = 0;
        return;
      }
      uint256 _once = 100 * 10 ** 18;
      uint256 _amount;
      if (_protecting >= _once) {
        _amount = _once;
        _protecting -= _once;
      } else {
        _amount = _protecting;
        _protecting = 0;
      }

      _amount = _marketSmartVault.transfer(_amount);
      if (_amount == 0) return;
      _buyToken(_amount);
      _tradeSmartVault.burn();
    } else {
      uint256 price = xbtAmount(1 * 10 ** 18);
      if (price >= _prices[_time].mul(2) && _prices[_time] > 0 && _protected_time < _time) {

        uint256 balance = _USDT.balanceOf(address(_marketSmartVault));
        if (balance < 5000 * 10 ** 18) {
          _protecting = balance;
          _protected_time = _time;
        } else {
          _protecting = balance.mul(1000).div(BASE_RATE);
          if (_protecting < 5000 * 10 ** 18) {
            _protecting = 5000 * 10 ** 18;
          }
          _protected_time = _time;
        }
      }
    }
  }

  /**
   * @dev Calculate daily burn limit based on liquidity pool USDT balance
   * This function implements a dynamic burn limit mechanism that adjusts based on the
   * amount of USDT in the XBT/USDT liquidity pool to maintain market stability.
   *
   * The calculation uses a piecewise function:
   * - For pool balance ≤ 100,000 USDT: Linear growth at 5% rate (y = 0.05 * x / 2)
   * - For pool balance > 100,000 USDT: Logarithmic growth with smooth saturation curve
   *   using natural logarithm for gradual increase
   *
   * This design ensures:
   * - Small pools have proportionally smaller burn limits to prevent depletion
   * - Large pools have higher but smoothly capped burn limits to maintain liquidity
   * - Smooth transition using logarithmic function to avoid sudden jumps
   *
   * @param x The USDT balance in the liquidity pool (in wei, 18 decimals)
   * @return The calculated daily burn limit (without decimals, will be multiplied by 10^18)
   */
  function calculateOutput(uint256 x) public pure returns (uint256) {
    uint256 base = 100000; // Threshold at 100,000 USDT

    if (x <= base) {
      // When x <= 100000, y = 0.1 * x / 2
      return (x * 1e17) / 1e18 / 2; // Equivalent to x * 0.05
    } else {
      // When x > 100000, use smooth logarithmic growth
      uint256 deltaX = x - base;
      // Use logarithmic function for smooth growth: y = base_value + scale * ln(1 + delta_x/k)
      uint256 baseValue = (base * 1e17) / 1e18 / 2; // Base value at 100k: 5000

      // Adjust parameters for smoother curve
      uint256 scale = 8000; // Controls growth magnitude, smaller value = slower growth
      uint256 k = 200000; // Controls growth speed, larger value = more gradual growth

      // Use logarithmic approximation: ln(1 + deltaX/k) ≈ deltaX/(deltaX + k)
      // This is a common logarithmic approximation formula to avoid complex logarithmic operations
      uint256 additional = (scale * deltaX) / (deltaX + k);
      return baseValue + additional;
    }
  }

  /**
   * @dev Update price index and burn limit for the current time period
   * Records the current XBT price and calculates daily burn limit based on liquidity pool balance
   */
  function _updateIndex() private {
    if (_prices[_time] > 0) return;

    uint256 price = xbtAmount(1 * 10 ** 18);
    _prices[_time] = price;

    uint256 _lpUSDT = _USDT.balanceOf(_xbt_pair);
    if (_lpUSDT == 0) return;

    _burn_limit = calculateOutput(_lpUSDT / 10 ** 18) * 10 ** 18;
    emit UpdateIndex(price, _burn_limit, block.timestamp);
  }

  /**
   * @dev Calculate the total mining amount available for a user
   * @param uid User address to calculate mining amount for
   * @return amount Total minable XBT amount based on user's power and time elapsed
   */
  function mintAmount(address uid) public view returns (uint256 amount) {
    if (_users[uid].power == 0) return 0;

    uint256 time = _time;

    // Calculate complete days passed
    uint256 days_passed = block.timestamp.sub(time).div(MINT_CYCLE);
    if (days_passed > 1) {
      time += days_passed * MINT_CYCLE;
    }

    // Latest mining time
    uint256 mint_last = _users[uid].mint_last;
    if (mint_last == time) return 0;

    // Mining rate
    uint256 rate = _users[uid].mint_rate;
    // Mining decrease time
    uint256 mint_decrease = _users[uid].mint_decrease;

    uint256 power = _users[uid].power;

    uint256 price = 0;
    uint256 passed = 0;
    do {
      if (passed >= 100) break;
      passed++;

      mint_last = mint_last.add(MINT_CYCLE);

      // Halve mining power after DECREASE_TIME
      if (mint_last > mint_decrease) {
        mint_decrease += DECREASE_TIME;
        rate = rate.mul(BASE_RATE.sub(5000)).div(BASE_RATE);
      }
      price = _prices[mint_last] > 0
        ? _prices[mint_last]
        : xbtAmount(1 * 10 ** 18);
      amount += (power * rate * price) / BASE_RATE / 10 ** 18;
    } while (mint_last < time);

    if (amount > _XBT.balanceOf(address(this))) {
      amount = _XBT.balanceOf(address(this));
    }
  }

  /**
   * @dev Execute mining operation for the caller
   * Calculates and distributes mining rewards based on user's mining power and time elapsed
   * Also processes referral rewards and updates user mining states
   */
  function mint() public nonReentrant {
    // Contract balance
    uint256 balance = _XBT.balanceOf(address(this));
    uint256 amount = mintAmount(msg.sender);
    require(balance > 0, "Contract has no XBT");
    require(amount > 0, "User has no mining power");

    // Update time
    updateTime();
    _detectAndProtect();
    _buyXBTToken();

    // If the mining amount is greater than the contract balance
    // the mining amount will be the contract balance and mining will end.
    if (amount > balance) {
      amount = balance;
    }

    // Step 1: Update user mining states
    _users[msg.sender].mint_total += amount;
    _users[msg.sender].mint_last = _time;

    mint_total += amount;

    uint256 mint_decrease = _users[msg.sender].mint_decrease;
    // Reduce mining rate by 50% after each DECREASE_TIME period
    if (_time >= mint_decrease) {
      _users[msg.sender].mint_rate = _users[msg.sender]
        .mint_rate
        .mul(BASE_RATE.sub(5000))
        .div(BASE_RATE);

      do {
        _users[msg.sender].mint_decrease += DECREASE_TIME;
      } while (_users[msg.sender].mint_decrease < _time);
    }

    // Step 2: Transfer mined tokens to user
    _XBT.transfer(msg.sender, amount);

    // Step 3: Distribute referral rewards to upline users
    _processReferralReward(msg.sender, amount);

    if (_XBT.balanceOf(address(this)) == 0) {
			_marketSmartVault.transfer(_USDT.balanceOf(address(_marketSmartVault)));
      _buyToken(_USDT.balanceOf(address(this)));
      _tradeSmartVault.burn();
    }

    // Step 4: Transfer withdraw fee to fee smart vault
    uint256 fee = amount.mul(500).div(BASE_RATE);
    if (fee > _XBT.balanceOf(address(this))) {
      fee = _XBT.balanceOf(address(this));
    }
    if (fee > 0) {
			mint_total += fee;
      _XBT.transfer(address(_feeSmartVault), fee);
      _feeSmartVault.allocationFee();
    }
  }

  /**
   * @dev Calculate leader reward based on user level
   * Returns daily reward amount and total reward cap for each level
   * @param level User level (0-4)
   * @return num Daily reward amount in XBT tokens
   * @return total Maximum total reward cap for the level
   */
  function _leaderReward(
    uint256 level
  ) private pure returns (uint256 num, uint256 total) {
    if (level == 1) return (1 * 10 ** 18, 100 * 10 ** 18);
    if (level == 2) return (1.5 * 10 ** 18, 225 * 10 ** 18);
    if (level == 3) return (2 * 10 ** 18, 500 * 10 ** 18);
    if (level == 4) return (4 * 10 ** 18, 1000 * 10 ** 18);
    if (level == 5) return (6 * 10 ** 18, 2400 * 10 ** 18);
    return (0, 0);
  }

  /**
   * @dev Claim leader reward based on user level
   * Users can claim daily rewards based on their level, subject to total reward caps
   */
  function leaderReward() public {
    address uid = msg.sender;
    require(_reward_time[uid] < _time, "Already claimed");
    require(_users[uid].level > 0, "User has no level");

    updateTime();
    _detectAndProtect();

    (uint256 num, uint256 total) = _leaderReward(_users[uid].level);

    (bool is_receive, , , , , , , ) = leaderRewardInfo(uid);
    if (!is_receive) revert("Already claimed");

    if (_leader_reward[uid] >= total) {
      revert("Reward cap reached");
    }

		uint256 _XBTBalance = _XBT.balanceOf(address(this));
		if(_XBTBalance == 0) {
			revert("Contract has no XBT");
		}

    _reward_time[uid] = _time;

    _leader_reward[uid] += num;
    _users[uid].mint_total += num;
    mint_total += num;

    if (num > _XBTBalance) {
      num = _XBTBalance;
    }

    _XBT.transfer(uid, num);

  }

  /**
   * @dev Get leader reward info
   * @param uid User address
   * @return is_receive Whether the user has received the reward
   * @return reward_total Total reward amount
   * @return receive_total Received reward amount
   * @return num Daily reward amount
   * @return level User level
	 * @return pv_min Minimum PV
	 * @return pv_max Maximum PV
   * @return last_time Last reward time
   */
  function leaderRewardInfo(
    address uid
  )
    public
    view
    returns (
      bool is_receive,
      uint256 reward_total,
      uint256 receive_total,
      uint256 num,
      uint256 level,
			uint256 pv_min,
			uint256 pv_max,
      uint256 last_time
    )
  {
    level = _users[uid].level;
    (num, reward_total) = _leaderReward(level);
    receive_total = _leader_reward[uid];
    last_time = _reward_time[uid];
    is_receive = _reward_time[uid] < _time;
		pv_max = _users[uid].pv_area_max;
		pv_min = _users[uid].pv_area_min;
    if (!is_receive) {
      num = 0;
    }
  }

  /**
   * @dev Retrieves a paginated list of referrals for a specific user
   * @param uid The user address whose referrals to retrieve
   * @param page Page number (1-based indexing)
   * @param limit Maximum number of items per page
   * @return items Array of User structs containing referral information
   * @return total Total number of referrals for the user
   */
  function inviteList(
    address uid,
    uint256 page,
    uint256 limit
  ) public view returns (User[] memory items, uint256 total) {
    address[] memory list = _inviters[uid];
    uint256 start = (page - 1) * limit;
    uint256 end = start + limit;
    if (end > list.length) {
      end = list.length;
    }

    // Create new array to store slice results
    uint256 resultLength = end - start;
    User[] memory result = new User[](resultLength);

    // Copy elements to new array and get user information
    for (uint256 i = 0; i < resultLength; i++) {
      // Get address
      address inviterAddress = list[start + i];
      // Get User information for this address
      result[i] = _users[inviterAddress];
    }

    return (result, _inviters[uid].length);
  }

  /**
   * @dev Get all users
   * @param page Page number
   * @param limit Page limit
   * @return items User array
   * @return total Total count
   */
  function getAllUsers(
    uint256 page,
    uint256 limit
  ) public view returns (User[] memory items, uint256 total) {
    uint256 start = (page - 1) * limit;
    uint256 end = start + limit;
    if (end > _all_users.length) {
      end = _all_users.length;
    }
    User[] memory result = new User[](end - start);
    for (uint256 i = 0; i < end - start; i++) {
      result[i] = _users[_all_users[start + i]];
    }
    return (result, _all_users.length);
  }

  function getInfo()
    public
    view
    returns (
      uint256 mintTotal,
      uint256 price,
      uint256 priceIndex,
      uint256 burnLimit,
      uint256 balance,
      uint256 invest_1000,
      uint256 invest_1000_count,
      uint256 protecting,
      uint256 time,
      bool hasBurnMix
    )
  {
    mintTotal = mint_total;
    price = xbtAmount(1 * 10 ** 18);
    priceIndex = _prices[_time];
    burnLimit = _burn_limit;
    balance = _XBT.balanceOf(address(this));
    invest_1000 = _invest_1000;
    invest_1000_count = _invest_1000_count;
    time = _time;
    hasBurnMix = _burn_mix_limit_time > _time;
    protecting = _protecting;
  }
}
