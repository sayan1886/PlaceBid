pragma solidity ^0.4.22;

contract UserRecord {
    
    struct User{
        string name;
        string userEmail;
        string password;
        uint8 balance;
        uint8 earnedBalance;
        uint8 [] assets; //asset id
    }

    mapping (string => User) users;

    uint8 stringLimit;

    constructor ( ) public {
        stringLimit = 2;
    }
    
    modifier validUser(string _userEmail) {
        require(bytes(users[_userEmail].name).length != 0);
        _;
    }

    function createUser (string _name, string _userEmail, string _password) public payable returns (bool _creation) {

        require(bytes(_name).length >= stringLimit);
        require(bytes(_userEmail).length >= stringLimit);
        require(bytes(_password).length >= stringLimit);
        require(bytes(users[_userEmail].name).length == 0);

        users[_userEmail].name = _name;
        users[_userEmail].userEmail = _userEmail;
        users[_userEmail].password = _password;
        users[_userEmail].balance = 100;
        return true;
    }
    
    function addAsset (string _userEmail, uint8 _assetId) validUser(_userEmail) public payable returns (bool _success) {
        require(_assetId > 0);
        users[_userEmail].assets.push(_assetId);
        return true;
    }

    function addBalance (string _userEmail, uint8 _balance) validUser(_userEmail) public payable returns (bool _success) {
        require(_balance > 0);
        add(users[_userEmail].balance, _balance);
        return true;
    }

    function addEarnedBalance (string _userEmail, uint8 _earnedBalance) validUser(_userEmail) public payable returns (bool _success) {
        require(_earnedBalance > 0);
        add(users[_userEmail].earnedBalance, _earnedBalance);
        return true;
    }
    
    function getAssets (string _userEmail) validUser(_userEmail) public view returns (uint8[] _assets) {
        return users[_userEmail].assets;
    }

    function getUserName (string _userEmail) validUser(_userEmail) public view returns (string _name) {
        return users[_userEmail].name;
    }

    function getUserPassword (string _userEmail) validUser(_userEmail) public view returns (string _name) {
        return users[_userEmail].password;
    }

    function getBalance (string _userEmail) validUser(_userEmail) public view returns (uint8 _totalBalance) {
        return add(users[_userEmail].balance, users[_userEmail].earnedBalance);
    }
    
    function isValidPassword (string _userEmail, string _password) validUser(_userEmail) public view returns (bool _valid) {
        return hashCompareWithLengthCheck(users[_userEmail].password, _password);
    }

    function hashCompareWithLengthCheck(string a, string b) internal pure returns (bool equal) {
        if(bytes(a).length != bytes(b).length) {
            return false;
        } 
        else {
            return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
        }
    }   

    function add(uint8 _a, uint8 _b) internal pure returns(uint8){
        return _a + _b;
    } 
}