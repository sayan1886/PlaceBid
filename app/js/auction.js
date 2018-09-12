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

$(document).ready(function() {
    getContractAddress(function(user_addr, asset_addr, auction_addr, error) {
        if (error != null) {
            setStatus("Cannot find network. Please run an Ethereum node or use Metamask.", "error");
            console.log(error);
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

        var filter = web3.eth.filter("latest");
        filter.watch(function(err, block) {
            // Call get block number on every block
            // updateBlockNumber();
        });
        watchEvents();

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
    });
});

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
                                setStatus("Auction Created Successfully", "success");
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

function getAuction(auctionId, callback) {
    auctionRecordContract.getAuction(auctionId, function(err, res) {
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
    auctions = [];
    for (i = 1; i <= auctionId; i++) {
        getAuction(i, function(err, res) {
            if (err == null) {
                auctions.push(res);

                if (auctions.length == auctionId) {
                    setStatus("Succesfully Updated Table.", "success");
                    hideSpinner();
                    prepareTable(auctions);
                }
            } else {
                setStatus("There is something went wrong: " + err.message, "error");
                hideSpinner();
            }
        });
    }
}

function prepareTable(auctions) {
    // rows = [];
    // for (i = 0; i < auctions.length; i++) {
    //     console.log("Row" + i + " : " + auctions[i]);
    //     for (j = 0; j < auctions[i].length; j++) {
    //         console.log("Column" + j + " : " + auctions[i][j]);
    //     }
    // }
    var tableBody = document.getElementById('dynamic_body');

    auctions.forEach(function(rowData) {
        var row = document.createElement('tr');

        rowData.forEach(function(cellData) {
            var cell = document.createElement('td');
            cell.appendChild(document.createTextNode(cellData));
            row.appendChild(cell);
        });

        tableBody.appendChild(row);
    });

    table.appendChild(tableBody);
}