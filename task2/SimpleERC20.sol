pragma solidity ^0.8.1;

contract SimpleERC20 {
     // 代币名称
     string public name;
    // string 类型：用于存储文本信息
    // public 访问修饰符：自动生成一个同名的 getter 函数，允许外部访问该变量
    // name 变量：存储代币的完整名称（例如 "MyToken"）

     // 代币符号 存储代币的简称/符号（例如 "MTK"），通常用于交易所等场景
     string public symbol;

     // 小数位数
    // uint8 类型：无符号 8 位整数，取值范围 0-255
    // decimals 变量：定义代币的小数位数，用于表示代币的最小单位
    // 默认为 18：这是以太坊生态中最常用的设置，1 个代币 = 10^18 个最小单位
     uint8 public decimals = 18;

     // 总供应量
    // uint256 类型：无符号 256 位整数，能表示极大的数值（最大约 10^78）
    // totalSupply 变量：记录代币的总发行量，所有地址的余额之和应等于该值
     uint256 public totalSupply;

     // 存储每个地址的余额
    // mapping 类型：键值对存储结构，类似字典
    // address => uint256：以地址为键，余额为值
    // balanceOf 映射：记录每个地址持有的代币数量
    // public 修饰符：自动生成 getter 函数，可通过 balanceOf(address) 查询指定地址余额
     mapping(address => uint256) public balanceOf;

     // 存储授权信息 (owner => spender => amount)
    // 嵌套映射：第一层键是代币所有者地址，第二层键是被授权地址
    // 存储的值是所有者允许被授权地址花费的代币数量
    // 例如 allowance[Alice][Bob] = 100 表示 Alice 允许 Bob 花费她的 100 个代币
     mapping (address => mapping (address => uint256)) public allowance;

      // 合约所有者
      // address 类型：用于存储以太坊账户或合约地址（20字节长度）
      // owner 变量：记录合约的拥有者地址，拥有一些特殊权限（如增发代币）
      address public owner;
      // 转账事件
    // event 关键字：声明一个事件，用于记录合约状态变化，可被外部监听
    // indexed 修饰符：标记可索引的参数，方便后续根据该参数过滤事件
    // Transfer 事件：在代币转账时触发，记录转出地址、转入地址和转账数量
      event Transfer(address indexed from, address indexed to, uint256 value);
      // 授权事件在授权操作时触发，记录授权者、被授权者和授权金额
      event Approval(address indexed owner,address indexed spender,uint256 value);
      // 权限控制修饰符
      // modifier 关键字：定义一个修饰符，用于修改函数的行为（通常用于权限控制或条件检查）
      // onlyOwner 修饰符：限制函数只能被合约所有者调用
      modifier onlyOwner() {
        // require 语句：检查条件，如果不满足则回滚交易并抛出错误信息
        // msg.sender：当前调用者的地址
        // 这里检查调用者是否为 owner，否则抛出 "Not owner" 错误
        require(msg.sender == owner,"Not owner");
         // 下划线表示被修饰函数的代码体，修饰符会在函数执行前先执行上面的检查
        _;
      }
    // 构造函数：初始化代币信息
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        // 初始化供应量并分配给部署者
        _mint(msg.sender, _initialSupply);
    }

    // 转账功能
    function transfer(address to,uint256 amount) public returns (bool){
        // function 关键字：定义一个函数
        // transfer 函数：实现代币从调用者地址向 to 地址的转账
        // 参数：to（接收地址）、amount（转账数量）
        // public 修饰符：允许内部和外部调用
        // returns (bool)：声明函数返回一个布尔值，表示操作是否成功
        require(to != address(0), "Transfer to the zero address");
        // 检查接收地址是否为零地址（0x0000000000000000000000000000000000000000）
        // 零地址通常用于销毁代币，这里禁止向零地址转账（可根据需求修改）

        require(balanceOf[msg.sender] >= amount, "Insufficient balance");
        // 检查调用者的余额是否大于等于转账数量，防止余额不足

        balanceOf[msg.sender] -= amount;
        // 从调用者的余额中减去转账数量

        balanceOf[to] += amount;
        // 向接收地址的余额中添加转账数量

        emit Transfer(msg.sender, to, amount);
        // 触发 Transfer 事件，记录转账信息

        return true;
        // 返回 true 表示转账成功
    }


    // 授权功能
    function approve (address spender,uint256 amount) public returns (bool)  {
        // approve 函数：允许调用者授权 spender 地址花费指定数量的代币
        // 参数：spender（被授权地址）、amount（授权数量）
        require(spender != address(0), "Approve to the zero address");
        // 检查被授权地址是否为零地址，避免无效授权

         allowance[msg.sender][spender] = amount;
        // 更新授权记录：调用者（msg.sender）允许 spender 花费 amount 数量的代币

        emit Approval(msg.sender, spender, amount);
        // 触发 Approval 事件，记录授权信息
        
        return true;
        // 返回 true 表示授权成功
    }

    // 授权转账功能
      function transferFrom(address from,address to,uint256 amount) public returns (bool) {
        // transferFrom 函数：允许被授权者从 from 地址向 to 地址转账
        // 通常用于交易所、支付网关等场景，代替用户执行转账
        // 参数：from（转出地址）、to（转入地址）、amount（转账数量）

        require(from != address(0), "Transfer from the zero address");
        // 检查转出地址是否为零地址
        
        require(to != address(0), "Transfer to the zero address");
        // 检查转入地址是否为零地址
        
        require(balanceOf[from] >= amount, "Insufficient balance");
        // 检查转出地址的余额是否充足

        require(allowance[from][msg.sender] >= amount, "Allowance exceeded");
        // 检查调用者（被授权者）的授权额度是否大于等于转账数量

        balanceOf[from] -= amount;
        // 从转出地址的余额中减去转账数量
        
        balanceOf[to] += amount;
        // 向转入地址的余额中添加转账数量

        allowance[from][msg.sender] -= amount;
        // 从调用者的授权额度中减去转账数量（减少已使用的授权）
        emit Transfer(from, to, amount);
        // 触发 Transfer 事件，记录转账信息
        
        return true;
        // 返回 true 表示授权转账成功
    }


    // _mint 函数：内部函数（仅合约内部可调用），实现代币增发的核心逻辑
    // internal 修饰符：允许当前合约和继承它的合约调用
    function _mint(address to,uint256 amount) internal {
         // 将增发数量添加到总供应量中
        totalSupply +=amount;
         // 将增发的代币分配给 to 地址
        balanceOf[to] += amount;
        // 触发 Transfer 事件，从地址 0（通常表示代币的"源头"）向 to 地址转账
        // 这是 ERC20 标准中约定的增发代币的事件触发方式
        emit Transfer(address(0),to,amount);
    }

    // 增发代币（仅所有者）
    function mint(address to,uint256 amount) public onlyOwner {
        // mint 函数：增加代币的总供应量，并将新增的代币分配给 to 地址
        // onlyOwner 修饰符：限制只有合约所有者可以调用该函数
        require(to != address(0), "Mint to the zero address");
        // 检查接收增发代币的地址是否为零地址
        _mint(to, amount);
        // 调用内部函数 _mint 执行实际的增发操作
    }
}
