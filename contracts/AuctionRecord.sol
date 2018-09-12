pragma solidity ^0.4.22;
// pragma experimental ABIEncoderV2;

contract AuctionRecord {

    enum AuctionStatus {Active, End}
    enum AuctionResult {Sold, Unsold, Pending}

    struct Auction {
        uint8 auctionId;
        string assetName;
        uint8 assetId;
        string assetOwner; //userEmail
        uint8 basePrice;
        uint256 auctionExpiry;
        uint8 currentBid; //in amount
        string currentBidder; //Owner and Biider will not be same

        AuctionStatus status;
        AuctionResult result;
    }
    
    uint8 id;
    mapping (uint8 => Auction) public auctions;
    
    constructor () public {
        id = 0;
    }
    
    modifier auctionActive (uint8 _auctionId) {
        require (now <= auctions[_auctionId].auctionExpiry );
        _;
    }
    
    modifier highestBid (uint8 _auctionId, uint8 _bid) {
        require (_bid > auctions[_auctionId].currentBid);
        _;
    }
    
    function createAuction 
    ( uint8 _assetId, string _assetName, string _assetOwner, uint8 _basePrice , uint256 _auctionExpiry) 
    public payable returns (uint8 _auctionID) {
        uint8 _auctionId = ++id;
        auctions[_auctionId].auctionId = _auctionId;
        auctions[_auctionId].assetId = _assetId;
        auctions[_auctionId].assetName = _assetName;
        auctions[_auctionId].assetOwner = _assetOwner;//owners email;
        auctions[_auctionId].basePrice = _basePrice;
        auctions[_auctionId].auctionExpiry = now + _auctionExpiry * 60;//in mins;
        auctions[_auctionId].result = AuctionResult.Pending;
        auctions[_auctionId].status = AuctionStatus.Active;
        return _auctionId;
    }
    
    function placeBid (uint8 _auctionId, uint8 _bid, string _bidder)
    auctionActive(_auctionId) highestBid(_auctionId, _bid) public payable returns (bool _bidPlaced){
        auctions[_auctionId].currentBid = _bid;
        auctions[_auctionId].currentBidder = _bidder;
        return true;
    }
    
    function getAuctionID () public view returns (uint8 _auctionId){
        return id;
    }

    function getAssetID (uint8 _auctionId) public view returns (uint8 _assetId){
        return auctions[_auctionId].assetId;
    }

    function getOwner (uint8 _auctionId) public view returns (string _assetOwner) {
        return auctions[_auctionId].assetOwner;
    }
    
    function getAssetName (uint8 _auctionId) public view returns (string _assetName) {
        return auctions[_auctionId].assetName;
    }
    
    function getCurrentBid (uint8 _auctionId) public view returns (uint8 _currentBid) {
        return auctions[_auctionId].currentBid;
    }
    
    function getBasePrice (uint8 _auctionId) public view returns (uint8 _basePrice) {
        return auctions[_auctionId].basePrice;
    }
    
    function getAuctionExipiry (uint8 _auctionId) public view returns (uint256 _auctionExpiry) {
        return auctions[_auctionId].auctionExpiry;
    }
    
    function getCurrentBidder (uint8 _auctionId) public view returns (string _currentBidder) {
        return auctions[_auctionId].currentBidder;
    }
    
    function getAuctionStatus (uint8 _auctionId) public view returns (AuctionStatus _auctionStatus) {
        return auctions[_auctionId].status;
    }
    
    function getAuctionResult (uint8 _auctionId) public view returns (AuctionResult _auctionResult) {
        return auctions[_auctionId].result;
    }
    
    function getAuction(uint8 _auctionId) public view returns 
    (uint8 _assetId, string _assetName, string _assetOwner, uint8 _basePrice,uint8 _currentBid, string _currentBidder, uint256 _auctionExpiry) {
        Auction memory a = auctions[_auctionId];
        return (_auctionId, a.assetName, a.assetOwner, a.basePrice, a.currentBid, a.currentBidder, a.auctionExpiry);
    }
}