function updateProfile() {
    var name, balance, assets;
    userRecordContract.getUserName(loggedInUser, function(err, res) {
        hideSpinner();
        if (err) {
            setStatus("There is something went wrong: " + err, "error");
        } else if (res) {
            name = res;
            // console.log(name);
            userRecordContract.getBalance(getBytes(loggedInUser), function(err, res) {
                hideSpinner();
                if (err) {
                    setStatus("There is something went wrong: " + err, "error");
                } else if (res) {
                    balance = res['c'][0];
                    // console.log(balance);
                    userRecordContract.getAssets(getBytes(loggedInUser), function(err, res) {
                        hideSpinner();
                        if (err) {
                            setStatus("There is something went wrong: " + err, "error");
                        } else if (res) {
                            assets = res;
                            setStatus("Profile Loaded Successfully", "success");
                            updateInfoPanel(name, balance, assets);
                            watchEvents();
                        } else {
                            setStatus("Fetch Error", "warning");
                        }
                    });
                } else {
                    setStatus("Fetch Error", "warning");
                }
            });
        } else {
            setStatus("Fetch Error", "warning");
        }
    });
}

function updateInfoPanel(name, balance, assets) {
    console.log("updating proile")
    var profileHtml = document.getElementById("profileName");
    html = "Hi! " + name;
    profileHtml.innerHTML = html;

    var balanceHtml = document.getElementById("totalBalance");
    balanceHtml.innerHTML = balance;

    var assetHtml = document.getElementById("assets");
    html = assets.length <= 0 ? "You Don't Own Any Asset" : "You Owns " + assets.length + " Assests."
    assetHtml.innerHTML = html;
}

function createAsset(assetName, callback) {
    var filter = web3.eth.filter("latest");
    filter.watch(function(err, block) {
        // Call get block number on every block
        // updateBlockNumber();
    });
    assetRecordContract.createAsset(getBytes(assetName), getBytes(loggedInUser), { from: account }, function(err, res) {
        if (err != null) {
            setStatus("There is something went wrong: " + err.message, "error");
        } else {
            assetRecordContract.getAssetID(function(err, res) {
                if (err != null) {
                    setStatus("There is something went wrong: " + err.message, "error");
                } else {
                    assetid = res['c'][0] + 1;
                    userRecordContract.addAsset(getBytes(loggedInUser), assetid, { from: account }, function(err, res) {
                        if (err != null) {
                            callback(err, res);
                        } else {
                            callback(err, assetid);
                            updateProfile();
                        }
                    });
                }
            });
        }
    });
}

function addBalance() {
    var balance = 100;
    setStatus("Updating your balance.. (please wait)", "warning");
    showSpinner();
    userRecordContract.addBalance(getBytes(loggedInUser), balance, { from: account }, function(err, res) {
        hideSpinner();
        if (err) {
            setStatus("There is something went wrong: " + err, "error");
        } else if (res) {
            setStatus("Balance Added Successfully", "success");
            updateProfile();
        } else {
            setStatus("Fetch Error", "warning");
        }
    });
}

function watchEvents() {
    var filter = web3.eth.filter("latest");
    filter.watch(function(err, block) {
        // Call get block number on every block
        if (!err) {
            console.log("filter : " + block);
        }
    });

    var eventsAllUser = userRecordContract.allEvents({ fromBlock: 'latest' });

    eventsAllUser.watch(function(err, res) {
        if (err) {
            console.log("Error: " + err);
        } else {
            //TODO: need to change to events based Balance and Asset update for user
            console.log("Got an event: " + res);
        }
    });

    var eventsAllAssets = assetRecordContract.allEvents({ fromBlock: 'latest' });

    eventsAllAssets.watch(function(err, res) {
        if (err) {
            console.log("Error: " + err);
        } else {
            //TODO: need to change to events based Aset handling
            console.log("Got an event: " + res);
        }
    });
}