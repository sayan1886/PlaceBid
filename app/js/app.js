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

}

window.onbeforeunload = function() {
    saveToLocal();
}

function saveToLocal() {
    //Save
    localStorage.setItem("account", account);
    localStorage.setItem("loggedInUser", loggedInUser);
}

function retriveFromLocal() {
    // Retrieve
    account = localStorage.getItem("account", account);
    loggedInUser = localStorage.getItem("loggedInUser", loggedInUser);
}