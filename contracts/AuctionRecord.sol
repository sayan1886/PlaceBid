pragma solidity ^0.4.22;

contract AuctionRecord {

    enum AuctionStatus {Active, End}
    enum AuctionResult {Sold, Unsold, Pending}

    struct Bid {
        string bidder;
        uint8 bid;
    }

    struct Auction {
        uint8 auctionId;
        string auctionHash;

        string assetName;
        uint8 assetId;
        string assetOwner; //userEmail

        uint8 startPrice;
        uint256 auctionExpiry;
        
        uint8 currentBid; //in amount
        string currentBidder; //Owner and Biider will not be same

        AuctionStatus status;
        AuctionResult result;
    }
    
    uint8 id;
    mapping (uint8 => Auction) auctions;
    
    constructor () public {
        
    }
    
    modifier validAuction(uint8 _auctionId) {
        require(bytes(auctions[_auctionId].auctionHash).length != 0);
        _;
    }
    
    modifier auctionActive (uint8 _auctionId) {
        require (now <= auctions[_auctionId].auctionExpiry );
        _;
    }
    
    modifier highestBid (uint8 _auctionId, uint8 _bid) {
        require (_bid > auctions[_auctionId].currentBid);
        _;
    }
    
    function createAuction ( uint8 _assetId, string _assetName, string _assetOwner, uint8 _startPrice , uint256 _auctionExpiry) public payable returns (uint8 _auctionID) {
        require(bytes(auctions[_auctionId].auctionHash).length == 0);
        uint8 _auctionId = ++id;
        auctions[_auctionId].auctionId = _auctionId;
        auctions[_auctionId].assetId = _assetId;
        auctions[_auctionId].assetName = _assetName;
        auctions[_auctionId].assetOwner = _assetOwner;//owners email;
        auctions[_auctionId].startPrice = _startPrice;
        auctions[_auctionId].auctionExpiry = now + _auctionExpiry * 60;//in mins;
        auctions[_auctionId].result = AuctionResult.Pending;
        auctions[_auctionId].status = AuctionStatus.Active;
        return _auctionId;
    }
    
    function placeBid (uint8 _auctionId, uint8 _bid, string _bidder) validAuction(_auctionId) auctionActive(_auctionId) highestBid(_auctionId, _bid) public payable returns (bool _bidPlaced){
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

    function getOwner (uint8 _auctionId) validAuction(_auctionId) public view returns (string _assetOwner) {
        return auctions[_auctionId].assetOwner;
    }
    
    function getAssetName (uint8 _auctionId) validAuction(_auctionId) public view returns (string _assetName) {
        return auctions[_auctionId].assetName;
    }
    
    function getCurrentBid (uint8 _auctionId) validAuction(_auctionId) public view returns (uint8 _currentBid) {
        return auctions[_auctionId].currentBid;
    }
    
    function getCurrentBidder (uint8 _auctionId) validAuction(_auctionId) public view returns (string _currentBidder) {
        return auctions[_auctionId].currentBidder;
    }
    
    function getAuctionStatus (uint8 _auctionId) validAuction (_auctionId) public view returns (AuctionStatus _auctionStatus) {
        return auctions[_auctionId].status;
    }
    
    function getAuctionResult (uint8 _auctionId) validAuction (_auctionId) public view returns (AuctionResult _auctionResult) {
        return auctions[_auctionId].result;
    }
}