function watchEvents() {
    var events = auctionRecordContract.allEvents();

    events.watch(function(err, msg) {
        if (err) {
            console.log("Error: " + err);
        } else {
            console.log("Got an event: " + msg.event);
        }
    });
}

window.onload = function() {
    retriveFromLocal();
    //need to check for auctions
}

function createAuction() {

    var assetName = document.getElementById("assetName").value;
    var assetPrice = document.getElementById("assetPrice").value;
    var expiration = document.getElementById("expiration").value;

    assetPrice = Math.ceil(assetPrice);
    expiration = Math.ceil(expiration);

    if (assetName.length <= 1) {
        setStatus("Criteria Mismatch For Asset Name", "error");
    } else if (assetPrice <= 0) {
        setStatus("Criteria Mismatch For Base Price", "error");
    } else if (expiration < 10) {
        setStatus("Criteria Mismatch For Auction Expiry", "error");
    } else {
        setStatus("Initiating Auction... (please wait)", "warning");
        showSpinner();
        createAsset(assetName, function(err, res) {
            if (err != null) {
                setStatus("There is something went wrong: " + err.message, "error");
                hideSpinner();
            } else {
                assetId = res['c'][0];
                auctionRecordContract.createAuction(assetId, assetName, loggedInUser, assetPrice, expiration, { from: account }, function(err, res) {
                    if (err != null) {
                        setStatus("There is something went wrong: " + err.message, "error");
                        hideSpinner();
                    } else {
                        auctionRecordContract.getAuctionID(function(err, res) {
                            if (err != null) {
                                setStatus("There is something went wrong: " + err.message, "error");
                                hideSpinner();
                            } else {
                                setStatus("Succesfully Connected to Ethereum Node.", "success");
                                hideSpinner();
                                auctionId = res['c'][0];
                                updateAuctionTable(auctionId);
                            }
                        });
                    }
                });
            }
        });
    }
}

function getAssetName(auctionId, callback) {
    auctionRecordContract.getOwnerfunction(auctionId, function(err, res) {
        callback(err, res);
    });
}

function getOwner(auctionId, callback) {
    auctionRecordContract.getOwnerfunction(auctionId, function(err, res) {
        callback(err, res);
    });
}

function getBasePrice(auctionId, callback) {
    auctionRecordContract.getOwnerfunction(auctionId, function(err, res) {
        callback(err, res);
    });
}

function getCurrentBid(auctionId, callback) {
    auctionRecordContract.getOwnerfunction(auctionId, function(err, res) {
        callback(err, res);
    });
}

function getCurrentBidder(auctionId, callback) {
    auctionRecordContract.getOwnerfunction(auctionId, function(err, res) {
        callback(err, res);
    });
}

// function getCurrentBidder(auctionId, callback) {
//     auctionRecordContract.getOwnerfunction(auctionId, function(err, res) {
//         callback(err, res);
//     });
// }

function isOwner(owner) {
    return loggedInUser.toUpperCase() === owner.toUpperCase();
}

function getRow(row, callback) {
    var auction = [];
    auction.push({ "#": auctionId });
    getAssetName(row, function(err, res) {
        if (err != null) {
            setStatus("There is something went wrong: " + err.message, "error");
            hideSpinner();
        } else {
            auction.push({ "Asset": res });
            getOwner(row, function(err, res) {
                if (err != null) {
                    setStatus("There is something went wrong: " + err.message, "error");
                    hideSpinner();
                } else {
                    auction.push({ "Seller": res });
                    getBasePrice(row, function(err, res) {
                        if (err != null) {
                            setStatus("There is something went wrong: " + err.message, "error");
                            hideSpinner();
                        } else {
                            auction.push({ "Base Price": res[c][0] });
                            getCurrentBid(row, function(err, res) {
                                if (err != null) {
                                    setStatus("There is something went wrong: " + err.message, "error");
                                    hideSpinner();
                                } else {
                                    auction.push({ "Current Bid": res[c][0] });
                                    getCurrentBidder(row, function(err, res) {
                                        if (err != null) {
                                            setStatus("There is something went wrong: " + err.message, "error");
                                            hideSpinner();
                                        } else {
                                            auction.push({ "Bidder": res });
                                            // getCurrentBidder(auctionId, function(err, res) {
                                            //     if (err != null) {
                                            //         setStatus("There is something went wrong: " + err.message, "error");
                                            //         hideSpinner();
                                            //     } else {
                                            //         auction.push({ "Bidder": res });
                                            //     }
                                            // });
                                            auctions.push(auction);
                                            callback(auction);
                                        }
                                    });
                                }
                            });
                        }
                    });
                }
            });
        }
    });
}

function updateAuctionTable(auctionId) {
    console.log(auctionId);
    setStatus("Updating Auction Table ... (please wait)", "warning");
    auctions.push();
    showSpinner();
    var rows = [];
    //TODO:check here
    for (var i = 0; i <= auctionId; auctionId++) {
        rows.push(i);
    }
    rows.forEach(function(item, idx) {
        getRow(item, function(auction) {
            auctions.push(auction);
            if (idx == (rows.length - 1)) {
                setStatus("Auction Table updation comeplete.", "success");
                hideSpinner();
            }
        })
    });

}