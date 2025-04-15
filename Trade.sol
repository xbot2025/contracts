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

// File: contracts/libs/IUniswapV2Pair.sol

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

// File: contracts/Trade.sol

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;






contract TradeSmartVault {
  using SafeMath for uint256;
  address public _owner;
  IBEP20 public _XBOT;

  modifier onlyOwner() {
    require(_owner == msg.sender, "permission denied");
    _;
  }

  constructor(address _xbot) {
    _owner = msg.sender;
    _XBOT = IBEP20(_xbot);
  }

  function transfer(uint256 amount) public onlyOwner returns (uint256) {
    require(amount > 0, "Amount must be greater than 0");

    uint256 _XBOTBalance = _XBOT.balanceOf(address(this));
    if (_XBOTBalance < amount) {
      amount = _XBOTBalance;
    }
    require(_XBOT.transfer(msg.sender, amount), "Transfer failed");

    return amount;
  }

  function burn() public onlyOwner {
    uint256 _XBOTBalance = _XBOT.balanceOf(address(this));
    if (_XBOTBalance > 0) {
      require(_XBOT.transfer(address(0), _XBOTBalance), "Transfer failed");
    }
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
    // Amount of KR1S tokens invested
    uint256 burn_xbot;
    // Amount of USDT invested
    uint256 burn_usdt;
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
  // Mapping of timestamps to recorded _prices
  mapping(uint256 => uint256) internal _prices;

  // Whitelist for users with unlimited mining power
  mapping(address => bool) internal _nolimit;

  // Mapping of invite codes to user addresses
  mapping(string => address) internal _codes;

  // Base rate for percentage calculations (10000 = 100%)
  uint256 public constant BASE_RATE = 10000;
  // Initial mining rate
  uint256 public constant MINT_RATE = 100;
  // Minimum purchase amount
  uint256 public constant MIN_PURCHASE = 10 * 10 ** 18;
  // Maximum purchase amount
  uint256 public constant MAX_PURCHASE = 1000 * 10 ** 18;
  // Time period after which mining power is halved
  uint256 public constant DECREASE_TIME = 1 hours; // 100 days;
  // Time period between mining cycles
  uint256 public constant MINT_CYCLE = 20 minutes; // 24 hours;
  // Minimum burn Amount
  uint256 public constant MIN_BURN = 100 * 10 ** 18;
  // Initial liquidity addition time and registration purchase restriction time
  uint256 public START_TIME;
  // Address for market allocation (20%)
  address internal _market = 0x6b91a867E777FD59f9cb3610d8D99d58e7b92262;
  // Address for sedimentation pool
  address internal _pool = 0x4322d14a372700525391c573992D342075D4D518;
  // Current mining cycle timestamp
  uint256 internal _time;
  // Total amount of tokens mined across all users
  uint256 public mint_total;

  // Record count of first 100 users who invested >= 1000U
  uint256 internal _invest_1000 = 100;
  uint256 internal _invest_1000_count;

  // KR1S/USDT pair address
  address internal _xbot_pair;

  TradeSmartVault internal _smartVault;

  // Token contract instances
  IBEP20 internal _USDT;
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
  event UpdateTime(uint256 time);
  event UpdatePrice(uint256 price, uint256 time);

  /**
   * @dev Constructor initializes the contract with required parameters
   * @param router DEX router address
   * @param usdt USDT token contract address
   * @param xbot KR1S token contract address
   * @param user Initial admin user address
   * @param time Initial timestamp
   */
  constructor(
    address router,
    IBEP20 usdt,
    IBEP20 xbot,
    address user,
    uint256 time
  ) {
    _v2Router = IUniswapV2Router(router);
    _USDT = usdt;
    _XBOT = xbot;
    _xbot_pair = IUniswapV2Factory(_v2Router.factory()).getPair(
      address(_USDT),
      address(_XBOT)
    );

    _smartVault = new TradeSmartVault(address(_XBOT));

    if (block.chainid == 97) {
      uint256 days_passed = block.timestamp.sub(time).div(MINT_CYCLE);
      _time = time.add(days_passed.mul(MINT_CYCLE));
    } else {
      _time = time;
    }

    START_TIME = _time.add(MINT_CYCLE * 2);

    // Initialize user
    _users[user] = User({
      uid: user,
      pid: address(0),
      invite: 0,
      code: generateCode(),
      burn_usdt: 100 * 10 ** 18,
      burn_xbot: 0,
      power: 100 * 10 ** 18,
      team_reward: 0,
      burn_time: 0,
      mint_rate: MINT_RATE,
      mint_decrease: 0,
      mint_total: 0,
      mint_last: _time,
      time: block.timestamp
    });
    _codes[_users[user].code] = user;
    _all_users.push(user);
  }

  function getSmartVault() public view returns (address) {
    return address(_smartVault);
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

    _users[msg.sender] = User({
      uid: msg.sender,
      pid: _codes[code],
      invite: 0,
      code: inviteCode,
      burn_usdt: 0,
      burn_xbot: 0,
      power: 0,
      team_reward: 0,
      burn_time: 0,
      mint_rate: MINT_RATE,
      mint_decrease: 0,
      mint_total: 0,
      mint_last: _time,
      time: block.timestamp
    });
    _codes[_users[msg.sender].code] = msg.sender;
    _inviters[_codes[code]].push(msg.sender);
    _all_users.push(msg.sender);
    emit Register(msg.sender, _codes[code], block.timestamp);

    if (
      block.timestamp < START_TIME ||
      _inviters[_codes[code]].length - _users[_codes[code]].invite <= 5
    ) {
      _buyXBOTToken(true);
    }
  }

  // get user info
  function getUserInfo(address uid) public view returns (User memory) {
    return _users[uid];
  }

  // get referrer info
  function getReferrer(string memory code) public view returns (User memory) {
    return _users[_codes[code]];
  }

  /**
   * @dev Invest and burn
   * @param token Token address
   * @param amount Token amount
   */
  function burn(address token, uint256 amount) public nonReentrant {
    require(_users[msg.sender].uid != address(0), "User not registered");
    require(_users[msg.sender].power == 0, "User has burned");
    require(
      token == address(_USDT) || token == address(_XBOT),
      "Invalid token"
    );
    if (token == address(_USDT)) {
      require(amount >= MIN_BURN, "Amount must be greater than 100 USDT");
    } else {
      require(
        usdtAmount(amount) >= MIN_BURN,
        "Amount must be greater than 100 USDT"
      );
    }

    updateTime();

    address uid = msg.sender;

    if (token == address(_USDT)) {
      _users[uid].power += amount;
      _users[uid].burn_usdt += amount;
    } else if (token == address(_XBOT)) {
      uint256 power = usdtAmount(amount);
      _users[uid].power += power;
      _users[uid].burn_xbot += amount;
    }

    // Record count of first 100 users who invested >= 1000U
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

    _users[uid].burn_time = _time;
    // First mining time
    _users[uid].mint_decrease = _time.add(DECREASE_TIME).add(MINT_CYCLE);
    // Latest mining time
    _users[uid].mint_last = _time;

    // Transfer
    IBEP20(token).transferFrom(uid, address(this), amount);
    // Allocate to market 18%
    IBEP20(token).transfer(_market, amount.mul(1800).div(BASE_RATE));

    // Give community rewards 22%
    _processCommunityReward(uid, token, amount);

    if (token == address(_USDT)) {
      // Add 10% USDT to liquidity pool
      _addLiquidity(amount.mul(1000).div(BASE_RATE));
      // Buy KR1S and burn
      _buyXBOTToken(false);
      // burn
      _smartVault.burn();
    } else {
      // Burn 60% of KR1S
      _XBOT.transfer(address(0), amount.mul(6000).div(BASE_RATE));
    }

    emit Burn(uid, token, amount, block.timestamp);
  }

  /**
   * @dev Community rewards - if less than 12 levels, proportionally allocate to the sedimentation pool
   * @param uid User address
   * @param token Token address
   * @param amount Token amount
   */
  function _processCommunityReward(
    address uid,
    address token,
    uint256 amount
  ) private {
    address pid = _users[uid].pid;
    uint256 level = 1;
    uint256 rate;
    uint256 _pool_amount = 0;
    do {
      if (level == 1) {
        rate = 800;
      } else if (level == 2) {
        rate = 500;
      } else if (level == 3) {
        rate = 200;
      } else if (level >= 4) {
        rate = 100;
      }

      uint256 reward = (amount * rate) / BASE_RATE;
      if (_users[pid].invite >= level || _nolimit[pid]) {
        // Transfer to upline
        IBEP20(token).transfer(pid, reward);
      } else {
        _pool_amount += reward;
      }

      level++;
      pid = _users[pid].pid;
    } while (level <= 10);

    if (_pool_amount > 0) {
      IBEP20(token).transfer(_pool, _pool_amount);
    }
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
        rate = 200;
      } else if (level >= 4) {
        rate = 100;
      }

      uint256 _XBOTBalance = _XBOT.balanceOf(address(this));
      if (_XBOTBalance == 0) {
        return;
      }

      // Calculating referral rewards
      uint256 reward = (amount * rate) / BASE_RATE;

      if (_XBOTBalance < reward) {
        reward = _XBOTBalance;
      }

      if (_users[pid].invite >= level || _nolimit[pid]) {
        _XBOT.transfer(pid, reward);
        _users[pid].team_reward += reward;
      }

      level++;
      pid = _users[pid].pid;
    } while (level <= 12 && pid != address(0));
  }

  /**
   * @dev Buy XBOT token
   */
  function _buyXBOTToken(bool isBurn) private {
    uint256 balance = _USDT.balanceOf(address(this));
    // Maximum purchase amount is 2% of contract balance
    if (balance == 0) return;

    uint256 price = xbotAmount(1 * 10 ** 18);
    if (price == 0) revert("No liquidity");

    if (block.timestamp >= START_TIME && _prices[_time] > price) {
      uint256 _priceDiff = _prices[_time].sub(price);
      //The price increased by 10%, do not buy
      if (_priceDiff.mul(BASE_RATE).div(_prices[_time]) >= 1000) {
        return;
      }
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

    _buyToken(address(_smartVault), amount);

    if (isBurn) {
      _smartVault.burn();
    }
  }

  function _buyToken(address to, uint256 amount) private {
    if (amount == 0) return;

    address[] memory path = new address[](2);
    path[0] = address(_USDT);
    path[1] = address(_XBOT);

    // Approve
    _USDT.approve(address(_v2Router), amount);
    // Buy Pump and burn
    _v2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
      amount,
      0,
      path,
      to,
      block.timestamp.add(60)
    );
  }

  function getReserves()
    private
    view
    returns (uint256 usdtReserve, uint256 xbotReserve)
  {
    (uint256 reserve0, uint256 reserve1, ) = IUniswapV2Pair(_xbot_pair)
      .getReserves();
    address token0 = IUniswapV2Pair(_xbot_pair).token0();
    if (token0 == address(_USDT)) {
      usdtReserve = reserve0;
      xbotReserve = reserve1;
    } else {
      usdtReserve = reserve1;
      xbotReserve = reserve0;
    }
  }

  /**
   * @dev Add liquidity
   * @param amountA USDT amount
   */
  function _addLiquidity(uint256 amountA) private {
    // Only add liquidity after START_TIME
    if (block.timestamp < START_TIME) {
      return;
    }

    amountA = amountA.div(2);

    _buyToken(address(_smartVault), amountA);

    address tokenA = address(_USDT);
    address tokenB = address(_XBOT);

    (uint256 usdtReserve, uint256 xbotReserve) = getReserves();
    uint256 amountB = amountA.mul(xbotReserve).div(usdtReserve);

    amountB = _smartVault.transfer(amountB);

    uint256 amountADesired = amountA;
    uint256 amountBDesired = amountB;
    uint256 amountAMin = 0;
    uint256 amountBMin = 0;
    uint256 deadline = block.timestamp;
    // Burn LP tokens directly
    address to = address(0);

    _USDT.approve(address(_v2Router), amountA);
    _XBOT.approve(address(_v2Router), amountB);

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
   * @dev Calculate token amount based on USDT amount
   * @param amount USDT amount
   * @return xbotAmount Token amount
   */
  function xbotAmount(uint256 amount) public view returns (uint256) {
    // Create trading path
    address[] memory path = new address[](2);
    path[0] = address(_USDT); // USDT
    path[1] = address(_XBOT); // KR1S

    try _v2Router.getAmountsOut(amount, path) returns (
      uint256[] memory amounts
    ) {
      return amounts[1];
    } catch {
      return 0;
    }
  }

  /**
   * @dev Calculate USDT amount based on token amount
   * @param amount KR1S amount
   * @return usdtAmount USDT amount
   */
  function usdtAmount(uint256 amount) public view returns (uint256) {
    address[] memory path = new address[](2);
    path[0] = address(_XBOT); // KR1S
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
   * @dev Update time
   */
  function updateTime() public returns (bool) {
    uint256 time = _time;
    if (time.add(MINT_CYCLE) > block.timestamp) return true;

    // Calculate complete days passed
    uint256 days_passed = block.timestamp.sub(time).div(MINT_CYCLE);
    time = time.add(days_passed.mul(MINT_CYCLE));
    _time = time;

    emit UpdateTime(time);

    // Update price after updating time
    _updatePrice();
    return true;
  }

  function _updatePrice() private {
    if (_prices[_time] > 0) return;
    // Calculate KR1S amount for 1 USDT
    uint256 price = xbotAmount(1 * 10 ** 18);
    _prices[_time] = price;

    emit UpdatePrice(price, block.timestamp);
  }

  /**
   * @dev Set address list
   * @param uids User address array
   * @param power Mining power
   */
  function setNoLimit(address[] memory uids, uint256 power) public onlyOwner {
    for (uint256 i = 0; i < uids.length; i++) {
      address uid = uids[i];
      require(_users[uid].uid != address(0), "User not registered");
      require(_nolimit[uid] == false, "User already in no limit list");
      _nolimit[uid] = true;
      _users[uid].burn_usdt += power;
      _users[uid].power += power;
      _users[_users[uid].pid].invite += 1;
    }
  }

  /**
   * @dev Calculate mining rate
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
    if (mint_last == time) return amount;

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
      if (mint_last > mint_decrease && !_nolimit[uid]) {
        mint_decrease += DECREASE_TIME;
        rate = rate.mul(BASE_RATE.sub(3500)).div(BASE_RATE);
      }
      price = _prices[mint_last] > 0
        ? _prices[mint_last]
        : xbotAmount(1 * 10 ** 18);
      amount += (power * rate * price) / BASE_RATE / 10 ** 18;
    } while (mint_last < time);

    if (amount > _XBOT.balanceOf(address(this))) {
      amount = _XBOT.balanceOf(address(this));
    }
  }

  /**
   * @dev Mining
   */
  function mint() public nonReentrant {
    // Contract balance
    uint256 balance = _XBOT.balanceOf(address(this));
    uint256 amount = mintAmount(msg.sender);
    require(balance > 0, "Contract has no KR1S");
    require(amount > 0, "User has no mining power");

    // Update time
    updateTime();
    _buyXBOTToken(true);

    // If the mining amount is greater than the contract balance
    // the mining amount will be the contract balance and mining will end.
    if (amount > balance) {
      amount = balance;
    }

    // 1. First update states
    _users[msg.sender].mint_total += amount;
    _users[msg.sender].mint_last = _time;

    mint_total += amount;

    uint256 mint_decrease = _users[msg.sender].mint_decrease;
    // Halve mining power after DECREASE_TIME
    if (_time >= mint_decrease && !_nolimit[msg.sender]) {
      _users[msg.sender].mint_rate = _users[msg.sender]
        .mint_rate
        .mul(BASE_RATE.sub(3500))
        .div(BASE_RATE);

      do {
        _users[msg.sender].mint_decrease += DECREASE_TIME;
      } while (_users[msg.sender].mint_decrease < _time);
    }

    // 2. Then perform transfer operation
    _XBOT.transfer(msg.sender, amount);

    // Distribute mining power to upline
    _processReferralReward(msg.sender, amount);

    if (_XBOT.balanceOf(address(this)) == 0) {
      _buyToken(address(_smartVault), _USDT.balanceOf(address(this)));
      _smartVault.burn();
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

  // Get all users
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

  /**
   * @dev Get contract info
   * @return mintTotal Total mining amount
   * @return price Current price
   * @return priceIndex Current price index
   * @return balance Current balance
   * @return invest_1000 Total limit for first 100 users investing >= 1000U
   * @return invest_1000_count Current count of users investing >= 1000U
   * @return time Current time
   */
  function getInfo()
    public
    view
    returns (
      uint256 mintTotal,
      uint256 price,
      uint256 priceIndex,
      uint256 balance,
      uint256 invest_1000,
      uint256 invest_1000_count,
      uint256 time
    )
  {
    mintTotal = mint_total;
    price = xbotAmount(1 * 10 ** 18);
    priceIndex = _prices[_time];
    balance = _XBOT.balanceOf(address(this));
    invest_1000 = _invest_1000;
    invest_1000_count = _invest_1000_count;
    time = _time;
  }
}
