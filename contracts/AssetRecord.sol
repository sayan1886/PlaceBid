pragma solidity ^0.4.22;

contract AssetRecord {

    enum AssetCategory {Owned, Earned, Unsold}
    
    struct Asset {
        uint8 assetId;
        bytes assetName;
        bytes ownedBy;
        AssetCategory category;
    }

    uint8 id;
    mapping (uint8 => Asset) assets;

    //Events
    event AssetCreated(uint8 assetId, bytes assetName, bytes ownedBy, AssetCategory category);
    event AssetOwnerChnaged(uint8 assetId, bytes owner, bytes newOwner, AssetCategory category);
    event AssetUnsold(uint8 assetId, bytes owner, AssetCategory category);

    constructor () public {
        id = 0;
    }
    
    modifier validAsset(uint8 _assetId) {
        require(assets[_assetId].assetName.length != 0);
        _;
    }

    function createAsset (bytes _assetName, bytes _ownedBy) public payable {
        require(bytes(assets[_assetId].assetName).length == 0);
        uint8 _assetId = ++id;
        assets[_assetId].assetId = _assetId;
        assets[_assetId].assetName = _assetName;
        assets[_assetId].ownedBy = _ownedBy;//owners email;
        assets[_assetId].category = AssetCategory.Owned;
        emit AssetCreated(_assetId, _assetName, _ownedBy, AssetCategory.Owned);
    }

    function setOwner(uint8 _assetId, bytes _newOwner) validAsset(_assetId) public payable {
        require(_assetId <= id && _assetId != 0);
        assets[_assetId].ownedBy = _newOwner;
        assets[_assetId].category = AssetCategory.Earned;
        emit AssetOwnerChnaged(_assetId, assets[_assetId].ownedBy, _newOwner, AssetCategory.Earned);
    }

    function setAssetUnsold(uint8 _assetId) validAsset(_assetId) public payable {
        require(_assetId <= id && _assetId != 0);
        assets[_assetId].category = AssetCategory.Unsold;
        emit AssetUnsold(_assetId, assets[_assetId].ownedBy, AssetCategory.Unsold);
    }

    function getAssetID () public view returns (uint8 _assetId){
        return id;
    }

    function getAssetName (uint8 _assetId) validAsset(_assetId) public view returns (bytes _commaSeparatedAsset){
        require(_assetId <= id && _assetId != 0);
        return assets[_assetId].assetName;
    }

    function getOwner(uint8 _assetId) validAsset(_assetId) public view returns (bytes _ownedBy) {
        require(_assetId <= id && _assetId != 0);
        return assets[_assetId].ownedBy;
    }
}