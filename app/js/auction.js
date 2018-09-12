auctions = [];


function watchEvents() {
    var eventsAll = auctionRecordContract.allEvents();

    eventsAll.watch(function(err, res) {
        if (err) {
            console.log("Error: " + err);
        } else {
            console.log("Got an event: " + res);
            auctionRecordContract.getAuctionID(function(err, res) {
                if (err != null) {
                    setStatus("There is something went wrong: " + err.message, "error");
                    hideSpinner();
                } else {
                    setStatus("Succesfully Connected to Ethereum Node.", "success");
                    hideSpinner();
                    auctionId = res['c'][0];
                    auctionStatus = [];
                    auctions = [];
                    updateAuctionTable(auctionId);
                }
            });
        }
    });

    var auctionCloseEvent = auctionRecordContract.AuctionClosed({ fromBlock: 0, toBlock: 'latest' });
    auctionCloseEvent.watch(function(err, res) {
        //TODO: Transfer asset ownership
        if (err) {
            console.log("Error: " + err);
        } else {
            console.log("Got an event: " + res);
        }
    });

    var auctionNewBidEvent = auctionRecordContract.AuctionBidPlaced({ fromBlock: 0, toBlock: 'latest' });
    auctionNewBidEvent.watch(function(err, res) {
        //TODO: Transfer balnce to old owner
        if (err) {
            console.log("Error: " + err);
        } else {
            console.log("Got an event: " + res);
        }
    });
}

$(document).ready(function() {
    setInterval(function() { checkAuctionForExpiry() }, 60 * 1000); //check every minutes
    getContractAddress(function(user_addr, asset_addr, auction_addr, err) {
        if (err != null) {
            setStatus("Cannot find network. Please run an Ethereum node or use Metamask.", "error");
            console.log(err);
            throw "Cannot load contract address";
        }
        setStatus("Succesfully Connected to Ethereum Node.", "success");

        web3.eth.getAccounts(function(err, accs) {
            if (err != null) {
                alert("There was an error fetching your accounts.");
                return;
            }
            accounts = accs;
            account = accounts[0];
        });

        userRecordContract = UserRecord.at(user_contract_addr);
        assetRecordContract = AssetRecord.at(asset_contract_addr);
        auctionRecordContract = AuctionRecord.at(auction_contract_addr);

        watchEvents();

        auctionRecordContract.getAuctionID(function(err, res) {
            if (err != null) {
                setStatus("There is something went wrong: " + err.message, "error");
                hideSpinner();
            } else {
                setStatus("Succesfully Connected to Ethereum Node.", "success");
                hideSpinner();
                auctionId = res['c'][0];
                auctionStatus = [];
                auctions = [];
                updateAuctionTable(auctionId);
            }
        });
    });
});

function checkAuctionForExpiry() {

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
        document.getElementById("auction-form").reset();
        createAsset(assetName, function(err, res) {
            if (err != null) {
                setStatus("There is something went wrong: " + err.message, "error");
                hideSpinner();
            } else {
                auctionRecordContract.createAuction(res, assetName, loggedInUser, assetPrice, expiration, { from: account }, function(err, res) {
                    if (err != null) {
                        setStatus("There is something went wrong: " + err.message, "error");
                        hideSpinner();
                    } else {
                        auctionRecordContract.getAuctionID(function(err, res) {
                            if (err != null) {
                                setStatus("There is something went wrong: " + err.message, "error");
                                hideSpinner();
                            } else {
                                setStatus("Auction Created Successfully", "success");
                                hideSpinner();
                                //Hack id will take some time to get update??
                                auctionId = res['c'][0] + 1;
                                auctionStatus = [];
                                auctions = [];
                                updateAuctionTable(auctionId);
                            }
                        });
                    }
                });
            }
        });
    }
}

function getAuction(auctionId, callback) {
    auctionRecordContract.getAuction(auctionId, loggedInUser, function(err, res) {
        if (err == null) {
            callback(err, res);
        }
    });
}

function getAuctionStatus(auctionId, callback) {
    auctionRecordContract.getAuctionStatus(auctionId, function(err, res) {
        if (err == null) {
            callback(err, res);
        }
    });
}

function isOwner(owner) {
    return loggedInUser.toUpperCase() === owner.toUpperCase();
}

function updateAuctionTable(auctionId) {
    setStatus("Updating Auction... (please wait)", "warning");
    showSpinner();
    auctionStatus = [];
    for (i = 1; i <= auctionId; i++) {
        getAuctionStatus(i, function(err, res) {
            if (err == null) {
                auctionStatus.push(res['c'][0]);
                if (auctionStatus.length == auctionId) {
                    getAuctions(auctionId, auctionStatus);
                }
            } else {
                setStatus("There is something went wrong: " + err.message, "error");
                hideSpinner();
            }
        });
        getAuctions(auctionId, auctionStatus);
    }
}

function getAuctions(auctionId, auctionStatus) {
    for (i = 1; i <= auctionId; i++) {
        getAuction(i, function(err, res) {
            if (err == null) {
                auctions.push(res);

                if (auctions.length == auctionId) {
                    setStatus("Succesfully Updated Table.", "success");
                    hideSpinner();
                    prepareTable(auctions, auctionStatus);
                }
            } else {
                setStatus("There is something went wrong: " + err.message, "error");
                hideSpinner();
            }
        });
    }
}

function prepareTable(auctions, auctionStatus) {
    var tableBody = document.getElementById('dynamicBody');
    tableBody.innerHTML = '';
    var i = 0;
    auctions.forEach(function(rowData) {
        var row = document.createElement('tr');
        var j = 0;
        rowData.forEach(function(cellData) {
            var cell = document.createElement('td');
            auctionClosed = (auctionStatus[i] == 2);
            if (j == 0 || j == 3 || j == 4) {
                cellData = cellData['c'][0];
                cell.appendChild(document.createTextNode(cellData));
            } else if (j == 6) {
                date = new Date(cellData['c'][0] * 1000).toLocaleString();
                cell.appendChild(document.createTextNode(date));
            } else if (j == 7) {
                if (auctionClosed) {
                    row.style.color = "rgb(247, 7, 7)"; //Red
                    cellData = "";
                    cell.appendChild(document.createTextNode(cellData));
                } else if (cellData) {
                    row.style.color = "rgb(57, 80, 214)"; //Blue
                    var button = document.createElement('input');
                    button.type = "button";
                    button.className = "form-control btn btn-login";
                    button.value = "Place Bid";
                    button.id = "place-auction-" + (i + 1);
                    button.addEventListener("click", function() {
                        placeBid();
                    });
                    cell.appendChild(button);
                } else {
                    row.style.color = "rgb(230, 146, 50)"; //Yellow
                    cellData = "";
                    cell.appendChild(document.createTextNode(cellData));
                }
            } else {
                cell.appendChild(document.createTextNode(cellData));
            }
            row.appendChild(cell);
            j++;
        });
        i++;
        tableBody.appendChild(row);
    });

    // table.appendChild(tableBody);
}

function placeBid() {
    console.log("Placing Bid");
}