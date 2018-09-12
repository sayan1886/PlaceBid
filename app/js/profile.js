function updateProfile() {
    var name, balance, assets;
    userRecordContract.getUserName.call(loggedInUser, function(err, res) {
        hideSpinner();
        if (err) {
            setStatus("There is something went wrong: " + err, "error");
        } else if (res) {
            name = res;
            // console.log(name);
            userRecordContract.getBalance.call(loggedInUser, function(err, res) {
                hideSpinner();
                if (err) {
                    setStatus("There is something went wrong: " + err, "error");
                } else if (res) {
                    balance = res['c'][0];
                    // console.log(balance);
                    userRecordContract.getAssets.call(loggedInUser, function(err, res) {
                        hideSpinner();
                        if (err) {
                            setStatus("There is something went wrong: " + err, "error");
                        } else if (res) {
                            assets = res;
                            console.log("assets : " + assets);
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
    assetRecordContract.createAsset(assetName, loggedInUser, { from: account }, function(err, res) {
        if (err != null) {
            setStatus("There is something went wrong: " + err.message, "error");
        } else {
            assetRecordContract.getAssetID(function(err, res) {
                if (err != null) {
                    setStatus("There is something went wrong: " + err.message, "error");
                } else {
                    assetid = res['c'][0];
                    result = res;
                    userRecordContract.addAsset(loggedInUser, assetid, { from: account }, function(err, res) {
                        if (err != null) {
                            callback(err, res);
                        } else {
                            callback(err, result);
                            updateProfile();
                        }
                    });
                }
            });
        }
    });
}

function watchEvents() {
    var events = assetRecordContract.allEvents();

    events.watch(function(err, msg) {
        if (err) {
            console.log("Error: " + err);
        } else {
            console.log("Got an event: " + msg.event);
        }
    });
}