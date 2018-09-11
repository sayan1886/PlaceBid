var accounts;
var account;

var UserRecord;
var AssetRecord;
var AuctionRecord;

var user_contract_addr;
var asset_contract_addr;
var auction_contract_addr;

var userRecordContract;
var assetRecordContract;
var auctionRecordContract;

var auctions = [];

var loggedInUser;

function setStatus(message, category) {
    var status = document.getElementById("statusMessage");
    status.innerHTML = message;

    var panel = $("#statusPanel");
    panel.removeClass("panel-warning");
    panel.removeClass("panel-danger");
    panel.removeClass("panel-success");

    if (category === "warning") {
        panel.addClass("panel-warning");
    } else if (category === "error") {
        panel.addClass("panel-danger");
    } else {
        panel.addClass("panel-success");
    }
};

function updateInfoBox(html) {
    var infoBox = document.getElementById("infoPanelText");
    infoBox.innerHTML = html;
}

function hideSpinner() {
    $("#spinner").hide();
}

function showSpinner() {
    $("#spinner").show();
}

window.onload = function() {
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
    });
}

window.onbeforeunload = function() {
    saveToLocal();
}

function saveToLocal() {
    //Save
    localStorage.setItem("account", account);
    localStorage.setItem("loggedInUser", loggedInUser);
    localStorage.setItem("auctions", JSON.stringify(auctions));
}

function retriveFromLocal() {
    // Retrieve
    account = localStorage.getItem("account", account);
    loggedInUser = localStorage.getItem("loggedInUser", loggedInUser);
}