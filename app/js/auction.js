auctions = [];


function watchEvents() {
    var filter = web3.eth.filter("latest");
    filter.watch(function(err, block) {
        // Call get block number on every block
        if (!err) {
            console.log("filter : " + block);
        }
    });

    var eventsAll = auctionRecordContract.allEvents({ fromBlock: 'latest' });

    eventsAll.watch(function(err, res) {
        if (err) {
            console.log("Error: " + err);
        } else {
            console.log("Got an event: " + res);
            if (res.event == "AuctionBidPlaced") {
                previousBidder = getString(res.args["previousBidder"]);
                currentBidder = getString(res.args["currentBidder"]);
                previousBid = getString(res.args["previousBid"]['c'][0]);
                currentBid = getString(res.args["currentBid"]['c'][0]);
                assetName = getString(res.args["assetName"]);
                userRecordContract.deductBalance(getBytes(currentBidder), currentBid, { from: account }, function(err, res) {
                    if (err != null) {
                        setStatus("There is something went wrong: " + err.message, "error");
                    } else {
                        if (previousBidder.length > 0) {
                            userRecordContract.deductBalance(getBytes(previousBidder), previousBid, { from: account }, function(err, res) {
                                if (err != null) {
                                    setStatus("There is something went wrong: " + err.message, "error");
                                } else {
                                    updateProfile();
                                    setStatus("Succesfully uppdated balances.", "success");
                                }
                            });
                            if (loggedInUser == previousBidder && customElements > previousBid) {
                                showOutBidded(assetName);
                            }
                        }
                    }
                });
            } else if (res.event == "AuctionClosed") {
                console.log("Auction Closed for : " + res.args["auctionId"]['c'][0]);
            }
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
}

$(document).ready(function() {
    setInterval(function() { checkAuctionForExpiry() }, 10 * 1000); //check every minutes
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
    for (i = 0; i < auctionId; i++) {
        timdiff = new Date(auctions[i][6]["c"][0] * 1000) - new Date().getTime();
        if (timdiff <= 0) {
            aid = i + 1; //auction starts from 1
            getAuctionStatus(aid, function(err, res) {
                if (err == null) {
                    if (res['c'][0] == 0) { //Active
                        auctionRecordContract.closeAuction(aid, { from: account }, function(err, res) {
                            if (err) {
                                setStatus("There is something went wrong: " + err.message, "error");
                            }
                        });
                    }
                }
            });
        }
    }
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
    } else if (expiration < 1) {
        setStatus("Criteria Mismatch For Auction Expiry", "error");
    } else {
        setStatus("Initiating Auction... (please wait)", "warning");
        showSpinner();
        document.getElementById("auction-form").reset();
        createAsset(getBytes(assetName), function(err, res) {
            if (err != null) {
                setStatus("There is something went wrong: " + err.message, "error");
                hideSpinner();
            } else {
                auctionRecordContract.createAuction(res, getBytes(assetName), getBytes(loggedInUser), assetPrice, expiration, { from: account }, function(err, res) {
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
    auctionRecordContract.getAuction(auctionId, function(err, res) {
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

// function updateAuctionTable(auctionId) {
//     setStatus("Updating Auction... (please wait)", "warning");
//     showSpinner();
//     auctionStatus = [];
//     for (i = 1; i <= auctionId; i++) {
//         getAuctionStatus(i, function(err, res) {
//             if (err == null) {
//                 auctionStatus.push(res['c'][0]);
//                 if (auctionStatus.length == auctionId) {
//                     getAuctions(auctionId, auctionStatus);
//                 }
//             } else {
//                 setStatus("There is something went wrong: " + err.message, "error");
//                 hideSpinner();
//             }
//         });
//         // getAuctions(auctionId, auctionStatus);
//     }
// }

function createBid(auctionid, itemPrice, itemName) {
    setStatus("Placing Bid for You...(please wait).", "warning");
    showSpinner();
    userRecordContract.getBalance(getBytes(loggedInUser), function(err, res) {
        if (err) {
            hideSpinner();
            setStatus("There is something went wrong: " + err, "error");
        } else if (res) {
            balance = res['c'][0];
            if (balance <= itemPrice) {
                hideSpinner();
                setStatus("Insufficuent Balance for this Bid: ", "error");
                showInsufficientBalanceAlert(balance, itemPrice, itemName)
            } else {
                auctionRecordContract.placeBid(auctionid, itemPrice, getBytes(loggedInUser), { from: account }, function(err, res) {
                    hideSpinner();
                    if (err) {
                        setStatus("There is something went wrong: ", "error");
                    } else if (res) {
                        setStatus("Bid Placed Succesfully: ", "success");
                    }
                });
            }
        }
    });
}


function getAuctions(auctionId) {
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

function updateAuctionTable(auctionId) {
    setStatus("Updating Auction... (please wait)", "warning");
    showSpinner();
    getAuctions(auctionId);
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
            if (j == 0 || j == 3 || j == 4) { //Id , and prices
                cellData = cellData['c'][0];
                cell.appendChild(document.createTextNode(cellData));
            } else if (j == 6) { // Date
                date = new Date(cellData['c'][0] * 1000).toLocaleString();
                cell.appendChild(document.createTextNode(date));
            } else if (j == 7) { //Status
                cellData = cellData['c'][0];
                if (cellData == 0) cellData = "Sold"
                else if (cellData == 1) cellData = "Unsold"
                else cellData = "Pending"
                cell.appendChild(document.createTextNode(cellData));
            } else if (j == 8) {
                cellData = cellData['c'][0];
                if (cellData == 1) {
                    row.style.color = "rgb(247, 7, 7)"; //Red
                    cellData = "";
                    cell.appendChild(document.createTextNode(cellData));
                } else if (loggedInUser == rowData[2] || loggedInUser == rowData[5]) { //Owner || //Current Bidder
                    row.style.color = "rgb(230, 146, 50)"; //Yellow
                    cellData = "";
                    cell.appendChild(document.createTextNode(cellData));
                } else {
                    row.style.color = "rgb(57, 80, 214)"; //Blue
                    var button = document.createElement('input');
                    button.type = "button";
                    button.className = "btn btn-primary";
                    button.value = "Place Bid";
                    button.id = "place-auction-" + (i + 1);
                    button.addEventListener("click", function(sender) {
                        placeBid(sender);
                    });
                    cell.appendChild(button);
                    // buttonId = "place-auction-" + (i + 1);
                    // cell.innerHTML = cellButton(buttonId);
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

function placeBid(sender) {
    // console.log("Placing Bid  for " + sender.toElement.id);
    buttonid = sender.target.id;
    auctionid = buttonid.split('-')[2];
    itemDetails = auctions[auctionid - 1];
    itemName = itemDetails[1];
    itemPrice = itemDetails[3]['c'][0] + 10;
    if (itemDetails[5].length > 0) {
        itemPrice = itemDetails[4]['c'][0] + 10;
    }
    BootstrapDialog.show({
        title: 'Information!',
        message: "You are going to submit a bid for " + itemName + " . This will cost you " + itemPrice + ". Are sure to continue? ",
        buttons: [{
            label: 'Proceed',
            action: function(dialog) {
                dialog.close();
                createBid(auctionid, itemPrice, itemName);
            }
        }, {
            label: 'Fallback',
            action: function(dialog) {
                dialog.close();
            }
        }]
    });
    return false;
}

function showInsufficientBalanceAlert(balance, itemPrice, itemName) {
    BootstrapDialog.alert('You have insuffiecient balance. Please add balance to continue.');
}

function showOutBidded(assetName) {
    BootstrapDialog.show({
        message: 'You are outbidded for ' + assetName + ". Please place New Bid!"
    });
}