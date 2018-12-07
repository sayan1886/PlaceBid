var delay = 1000;

$(function() {

    $('#login-form-link').click(function(e) {
        $("#login-form").delay(100).fadeIn(100);
        $("#register-form").fadeOut(100);
        $('#register-form-link').removeClass('active');
        $(this).addClass('active');
        e.preventDefault();
    });
    $('#register-form-link').click(function(e) {
        $("#register-form").delay(100).fadeIn(100);
        $("#login-form").fadeOut(100);
        $('#login-form-link').removeClass('active');
        $(this).addClass('active');
        e.preventDefault();
    });
});

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

function doLogin() {
    var email = document.getElementById("email").value;
    var pass = document.getElementById("password").value;

    console.log(email + "," + pass);

    setStatus("Initiating Authentication... (please wait)", "warning");
    showSpinner();

    userRecordContract.isValidPassword.call(getBytes(email), getBytes(pass), function(err, res) {
        hideSpinner();
        if (err) {
            setStatus("There is something went wrong: " + err, "error");
        } else if (res) {
            setStatus("Authentication Successfull", "success");
            loggedInUser = email;
            saveToLocal();
            setTimeout(function() {
                window.location.href = "./home.html"; //will redirect to home page
            }, delay);
        } else {
            setStatus("Authentication Unsuccessfull", "warning");
        }
    });
}

function doRegistration() {
    var name = document.getElementById("name").value;
    var email = document.getElementById("email2").value;
    var pass = document.getElementById("password2").value;
    var pass2 = document.getElementById("password3").value;
    if (name.length <= 4) {
        setStatus("Criteria Mismatch For Name", "error");
    } else if (ValidateEmail(email)) {
        setStatus("Criteria Mismatch For Email", "error");
    } else if (pass.length <= 4 || (pass != pass2)) {
        setStatus("Criteria Mismatch For Password", "error");
    } else {

        // console.log(name + "," + email + "," + pass + "," + pass);

        setStatus("Initiating Registration... (please wait)", "warning");
        showSpinner();

        userRecordContract.createUser(getBytes(name), getBytes(email), getBytes(pass), { from: account }, function(err, txnId) {
            console.log("Transaction id is : " + txnId);
            hideSpinner();
            if (txnId.length > 0) {

                userRecordContract.getUserName.call(getBytes(email), function(err, res) {
                    if (res === getBytes(name) {
                        setStatus("Registration Succesfull with Transaction Id: " + txnId, "success");
                        loggedInUser = email;
                        saveToLocal();
                        setTimeout(function() {
                            window.location.href = "./home.html"; //will redirect to your blog page (an ex: blog.html)
                        }, delay);
                    } else {
                        setStatus("There is something went wrong: " + err.message, "error");
                    }
                });
            } else {
                setStatus("There is something went wrong: " + err.message, "error");
            }
        });
    }
}

function ValidateEmail(mail) {
    var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    return re.test(email);
}

function watchEvents() {
    var filter = web3.eth.filter("latest");
    filter.watch(function(err, block) {
        // Call get block number on every block
        if (!err) {
            console.log("filter : " + block);
        }
    });

    var eventsAll = userRecordContract.allEvents({ fromBlock: 'latest' });

    eventsAll.watch(function(err, res) {
        if (err) {
            console.log("Error: " + err);
        } else {
            //TODO: need to change to events based login and registration
            console.log("Got an event: " + res);
        }
    });
}