pragma solidity ^0.4.22;
// pragma experimental ABIEncoderV2;

contract AuctionRecord {

    enum AuctionStatus {Active, End} //0,1
    enum AuctionResult {Sold, Unsold, Pending} //0,1,2

    //Events
    event AuctionCreated(uint8 auctionId, bytes assetName, bytes ownedBy, uint8 basePrice, uint256 expiry);
    event AuctionBidPlaced(uint8 auctionId, bytes assetName, bytes owner, uint previousBid, bytes previousBidder, uint currentBid, bytes currentBidder);
    event AuctionClosed(uint8 auctionId, uint8 assetId, bytes owner, uint basePrice, uint currentPrice, bytes currentBidder, AuctionStatus status, AuctionResult result);

    struct Auction {
        uint8 auctionId;
        bytes assetName;
        uint8 assetId;
        bytes assetOwner; //userEmail
        uint8 basePrice;
        uint256 auctionExpiry;
        uint8 currentBid; //in amount
        bytes currentBidder; //Owner and Biider will not be same

        AuctionStatus status;
        AuctionResult result;
    }
    
    uint8 id;
    mapping (uint8 => Auction) public auctions;
    
    constructor () public {
        id = 0;
    }
    
    modifier validAuction (uint8 _auctionId) {
        require (_auctionId <= id);
        _;
    }

    modifier auctionActive (uint8 _auctionId) {
        require (now <= auctions[_auctionId].auctionExpiry && auctions[_auctionId].status == AuctionStatus.Active );
        _;
    }
    
    modifier highestBid (uint8 _auctionId, uint8 _bid) {
        require (_bid > auctions[_auctionId].currentBid);
        _;
    }
    
    function createAuction 
    ( uint8 _assetId, bytes _assetName, bytes _assetOwner, uint8 _basePrice , uint256 _auctionExpiry) 
    public payable {
        uint8 _auctionId = ++id;
        auctions[_auctionId].auctionId = _auctionId;
        auctions[_auctionId].assetId = _assetId;
        auctions[_auctionId].assetName = _assetName;
        auctions[_auctionId].assetOwner = _assetOwner;//owners email;
        auctions[_auctionId].basePrice = _basePrice;
        auctions[_auctionId].auctionExpiry = block.timestamp + _auctionExpiry * 60;//in mins;
        auctions[_auctionId].result = AuctionResult.Pending;
        auctions[_auctionId].status = AuctionStatus.Active;
        emit AuctionCreated(_auctionId, _assetName, _assetOwner, _basePrice, _auctionExpiry);
    }
    
    function closeAuction (uint8 _auctionId) 
    validAuction(_auctionId) auctionActive(_auctionId) 
    public payable {
        auctions[_auctionId].status = AuctionStatus.End;
        if(auctions[_auctionId].currentBid > 0) 
            auctions[_auctionId].result = AuctionResult.Sold; 
        else 
            auctions[_auctionId].result = AuctionResult.Unsold;
        emit AuctionClosed(_auctionId, auctions[_auctionId].assetId, auctions[_auctionId].assetOwner, auctions[_auctionId].basePrice, auctions[_auctionId].currentBid, auctions[_auctionId].currentBidder, auctions[_auctionId].status, auctions[_auctionId].result);
    }
    
    function placeBid (uint8 _auctionId, uint8 _bid, bytes _bidder) 
    validAuction(_auctionId) auctionActive(_auctionId) highestBid(_auctionId, _bid) 
    public payable {
        auctions[_auctionId].currentBid = _bid;
        auctions[_auctionId].currentBidder = _bidder;
        emit AuctionBidPlaced(_auctionId, auctions[_auctionId].assetName, auctions[_auctionId].assetOwner, auctions[_auctionId].currentBid, auctions[_auctionId].currentBidder, _bid, _bidder);
    }
    
    function getAuctionID () public view returns (uint8 _auctionId){
        return id;
    }
    
    function getAuctionStatus (uint8 _auctionId) validAuction(_auctionId) 
    public view returns (AuctionStatus _auctionStatus) {
        return auctions[_auctionId].status;
    }


    function getAuction(uint8 _auctionId) validAuction(_auctionId) public view returns 
    (uint8 _assetId, bytes _assetName, bytes _assetOwner, uint8 _basePrice,uint8 _currentBid, bytes _currentBidder, uint256 _auctionExpiry, AuctionResult _result, AuctionStatus _status) {
        Auction memory a = auctions[_auctionId];
        // bool submitBid = (a.status != AuctionStatus.End && !compareTo(bidder, a.currentBidder) && !compareTo(bidder, a.assetOwner));
        return (_auctionId, a.assetName, a.assetOwner, a.basePrice, a.currentBid, a.currentBidder, a.auctionExpiry, a.result, a.status);
    }

    function compareTo (bytes _base, bytes _value) internal pure  returns (bool) {
        bytes memory _baseBytes = bytes(_base);
        bytes memory _valueBytes = bytes(_value);

        if (_baseBytes.length != _valueBytes.length) {
            return false;
        }

        for(uint i = 0; i < _baseBytes.length; i++) {
            if (_baseBytes[i] != _valueBytes[i]) {
                return false;
            }
        }

        return true;
    }
}