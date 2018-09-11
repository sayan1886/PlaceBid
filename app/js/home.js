delay = 3000;

window.onload = function() {

    retriveFromLocal();
    setStatus("Fetching Profile... (please wait)", "warning");
    showSpinner();

    getContractAddress(function(user_addr, asset_addr, auction_addr, error) {
        if (error != null) {
            setStatus("Cannot find network. Please run an Ethereum node or use Metamask.", "error");
            console.log(error);
            throw "Cannot load contract address";
        }
        setStatus("Succesfully Connected to Ethereum Node.", "success");
        userRecordContract = UserRecord.at(user_contract_addr);
        assetRecordContract = AssetRecord.at(asset_contract_addr);
        auctionRecordContract = AuctionRecord.at(auction_contract_addr);

        updateProfile();
    });
}