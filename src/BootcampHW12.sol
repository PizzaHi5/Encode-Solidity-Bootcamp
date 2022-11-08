// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.0;

import "./HW12/Ownable.sol";

contract GasContract is Ownable {
    mapping(address => Payment[]) internal payments;
    mapping(address => uint8) public whitelist;
    mapping(address => uint256) private balances;

    address[5] public administrators;

    uint256 private paymentCounter = 0;
    uint256 public totalSupply = 10000; // cannot be updated

    enum PaymentType {
        Unknown,
        BasicPayment,
        Refund,
        Dividend,
        GroupPayment
    }

    struct Payment {
        PaymentType paymentType;
        uint256 paymentID;
        address recipient;
        uint256 amount;
    }

    struct ImportantStruct {
        uint256 valueA; // max 3 digits
        uint256 bigValue;
        uint256 valueB; // max 3 digits
    }

    mapping(address => ImportantStruct) public whiteListStruct;

    event AddedToWhitelist(address userAddress, uint256 tier);

    modifier onlyAdminOrOwner() {
        require (_msgSender() == owner() || checkForAdmin(_msgSender()));
        _;
    }

    event Transfer(address recipient, uint256 amount);
    event PaymentUpdated(
        address admin,
        uint256 ID,
        uint256 amount
    );
    event WhiteListTransfer(address indexed);

    constructor(address[] memory _admins, uint256 _totalSupply) {
        for (uint256 i = 0; i < 5; i++) {
            administrators[i] = _admins[i];
            if (_admins[i] == owner()) {
                balances[owner()] = _totalSupply;
            } else {
                balances[_admins[i]] = 0;
            }
        }
    }

    function checkForAdmin(address _user) public view returns (bool admin_) {
        for (uint256 i = 0; i < 5; i++) {
            if (administrators[i] == _user) {
                admin_ = true;
            }
        }
        admin_ = false;
    }

    function balanceOf(address _user) public view returns (uint256 balance_) {
        balance_ = balances[_user];
    }

    function getTradingMode() public pure returns (bool mode_) {
        mode_ = true;
    }


    function getPayments(address _user)
        public
        view
        returns (Payment[] memory payments_)
    {

        return payments[_user];
    }

    function transfer(
        address _recipient,
        uint256 _amount,
        string calldata _name
    ) public {
        balances[msg.sender] -= _amount;
        balances[_recipient] += _amount;
        emit Transfer(_recipient, _amount);
        payments[msg.sender].push(Payment(PaymentType.BasicPayment, ++paymentCounter, _recipient, _amount));
    }

    function updatePayment(
        address _user,
        uint256 _ID,
        uint256 _amount,
        PaymentType _type
    ) public onlyAdminOrOwner {
        for (uint256 ii = 0; ii < payments[_user].length; ii++) {
            if (payments[_user][ii].paymentID == _ID) {
                payments[_user][ii].paymentType = _type;
                payments[_user][ii].amount = _amount;

                emit PaymentUpdated(
                    msg.sender,
                    _ID,
                    _amount
                );
            }
        }
    }

    function addToWhitelist(address _userAddrs, uint8 _tier)
        public
        onlyAdminOrOwner
    {
        if (_tier > 3) {
            whitelist[_userAddrs] = 3;
        } else {
            whitelist[_userAddrs] = _tier;
        }
        emit AddedToWhitelist(_userAddrs, _tier);
    }

    function whiteTransfer(
        address _recipient,
        uint256 _amount,
        ImportantStruct memory _struct
    ) external {
        uint256 temp = _amount - whitelist[msg.sender];
        balances[msg.sender] -= temp;
        balances[_recipient] += temp;

        whiteListStruct[msg.sender] = ImportantStruct(_struct.valueA, _struct.bigValue, _struct.valueB);
        emit WhiteListTransfer(_recipient);
    }
}
