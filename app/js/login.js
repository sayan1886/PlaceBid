var delay = 3000;

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

function doLogin() {
    var email = document.getElementById("email").value;
    var pass = document.getElementById("password").value;

    console.log(email + "," + pass);

    setStatus("Initiating Authentication... (please wait)", "warning");
    showSpinner();

    userRecordContract.isValidPassword.call(email, pass, function(err, res) {
        hideSpinner();
        if (err) {
            setStatus("There is something went wrong: " + err, "error");
        } else if (res) {
            setStatus("Authentication Successfull", "success");
            loggedInUser = email;
            saveToLocal();
            setTimeout(function() {
                window.location.href = "./home.html"; //will redirect to your blog page (an ex: blog.html)
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

        userRecordContract.createUser(name, email, pass, { from: account }, function(err, txnId) {
            console.log("Transaction id is : " + txnId);
            hideSpinner();
            if (txnId.length > 0) {

                userRecordContract.getUserName.call(email, function(err, res) {
                    if (res === name) {
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