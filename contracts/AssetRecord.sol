pragma solidity ^0.4.22;

contract AssetRecord {

    enum AssetCategory {Owned, Earned, Unsold}
    
    struct Asset {
        uint8 assetId;
        string assetName;
        string ownedBy;
        AssetCategory category;
    }

    uint8 id;
    mapping (uint8 => Asset) assets;

    //Events
    event AssetCreated(uint8 assetId, string assetName, string ownedBy, AssetCategory category);
    event AssetOwnerChnaged(uint8 assetId, string owner, string newObwer, AssetCategory category);
    event AssetUnsold(uint8 assetId, string owner, AssetCategory category);

    constructor () public {

    }
    
    modifier validAsset(uint8 _assetId) {
        require(bytes(assets[_assetId].assetName).length != 0);
        _;
    }

    function createAsset (string _assetName, string _ownedBy) public payable returns (uint8 _assetID) {
        require(bytes(assets[_assetId].assetName).length == 0);
        uint8 _assetId = ++id;
        assets[_assetId].assetId = _assetId;
        assets[_assetId].assetName = _assetName;
        assets[_assetId].ownedBy = _ownedBy;//owners email;
        assets[_assetId].category = AssetCategory.Owned;
        emit AssetCreated(_assetId, _assetName, _ownedBy, AssetCategory.Owned);
        return _assetId;
    }

    function setOwner(uint8 _assetId, string _newOwner) validAsset(_assetId) public payable returns (bool _success) {
        require(_assetId <= id && _assetId != 0);
        assets[_assetId].ownedBy = _newOwner;
        assets[_assetId].category = AssetCategory.Earned;
        emit AssetOwnerChnaged(_assetId, assets[_assetId].ownedBy, _newOwner, AssetCategory.Earned);
        return true;
    }

    function setAssetUnsold(uint8 _assetId) validAsset(_assetId) public payable returns (bool _success) {
        require(_assetId <= id && _assetId != 0);
        assets[_assetId].category = AssetCategory.Unsold;
        emit AssetUnsold(_assetId, assets[_assetId].ownedBy, AssetCategory.Unsold);
        return true;
    }

    function getAssetID () public view returns (uint8 _assetId){
        return id;
    }

    function getAssetName (uint8 _assetId) validAsset(_assetId) public view returns (string _commaSeparatedAsset){
        require(_assetId <= id && _assetId != 0);
        return assets[_assetId].assetName;
    }

    function getOwner(uint8 _assetId) validAsset(_assetId) public view returns (string _ownedBy) {
        require(_assetId <= id && _assetId != 0);
        return assets[_assetId].ownedBy;
    }
}