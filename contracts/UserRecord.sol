pragma solidity ^0.4.22;

contract UserRecord {
    
    struct User{
        bytes name;
        bytes userEmail;
        bytes password;
        uint8 balance;
        uint8 [] assets; //asset id
    }

    mapping (bytes => User) users;

    uint8 stringLimit;

    //Events
    event UserCreated (bytes userName, bytes userEmail);
    event UserBalnceUpdated (bytes userEmail, uint8 balance);
    event UserAssetsupdated (bytes userEmail, uint assets);

    constructor ( ) public {
        stringLimit = 2;
    }
    
    modifier validUser(bytes _userEmail) {
        require(users[_userEmail].name.length != 0);
        _;
    }

    function createUser (bytes _name, bytes _userEmail, bytes _password) public payable {

        require(_name.length >= stringLimit);
        require(_userEmail.length >= stringLimit);
        require(_password.length >= stringLimit);
        // require(users[_userEmail].name.length == 0);

        users[_userEmail].name = _name;
        users[_userEmail].userEmail = _userEmail;
        users[_userEmail].password = _password;
        users[_userEmail].balance = 100;
        emit UserCreated(_name, _userEmail);
    }
    
    function addAsset (bytes _userEmail, uint8 _assetId) validUser(_userEmail) public payable {
        require(_assetId > 0);
        users[_userEmail].assets.push(_assetId);
        emit UserAssetsupdated(_userEmail, users[_userEmail].assets.length) ;
    }

    function addBalance (bytes _userEmail, uint8 _balance) validUser(_userEmail) public payable {
        require(_balance > 0);
        users[_userEmail].balance += _balance;
        emit UserBalnceUpdated(_userEmail, users[_userEmail].balance) ;
    }

    function deductBalance (bytes _userEmail, uint8 _balance) validUser(_userEmail) public payable {
        require(_balance > 0);
        users[_userEmail].balance -= _balance;
        emit UserBalnceUpdated(_userEmail, users[_userEmail].balance) ;
    }
    
    function getAssets (bytes _userEmail) validUser(_userEmail) public view returns (uint8[] _assets) {
        return users[_userEmail].assets;
    }

    function getUserName (bytes _userEmail) validUser(_userEmail) public view returns (bytes _name) {
        return users[_userEmail].name;
    }

    function getUserPassword (bytes _userEmail) validUser(_userEmail) public view returns (bytes _name) {
        return users[_userEmail].password;
    }

    function getBalance (bytes _userEmail) validUser(_userEmail) public view returns (uint8 _totalBalance) {
        return users[_userEmail].balance;
    }
    
    function isValidPassword (bytes _userEmail, bytes _password) validUser(_userEmail) public view returns (bool _valid) {
        return hashCompareWithLengthCheck(users[_userEmail].password, _password);
    }

    function hashCompareWithLengthCheck(bytes a, bytes b) internal pure returns (bool equal) {
        if(a.length != b.length) {
            return false;
        } 
        else {
            return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
        }
    }   
}