(function () {
    'use strict';

    // Shortcuts
    var C = CryptoJS;
    var C_lib = C.lib;
    var BlockCipherMode = C_lib.BlockCipherMode;
    var C_mode = C.mode;

    C_mode.ECB = (function () {
        var ECB = BlockCipherMode.extend();

        ECB.Encryptor = ECB.extend({
            processBlock: function (words, offset) {
                this._cipher.encryptBlock(words, offset);
            }
        });

        ECB.Decryptor = ECB.extend({
            processBlock: function (words, offset) {
                this._cipher.decryptBlock(words, offset);
            }
        });

        return ECB;
    }());
}());

function encryptByDES(message) {
	
}

function loginCheck(){
	var isValid = false;
	var uname = $("#username").val();
	var pwd = $("#password").val();

	if(uname.length > 0 && pwd.length > 0){
		$.ajax({
			url : "getHashtoken",
			type : "POST",
			cache : false,
			async : false,
			success : function(resData){				
				var keyHex = CryptoJS.enc.Utf8.parse(resData);
			    var encryptedUname = CryptoJS.DES.encrypt(uname, keyHex, {
			        mode: CryptoJS.mode.ECB,
			        padding: CryptoJS.pad.Pkcs7
			    });
			    var encryptedPwd = CryptoJS.DES.encrypt(pwd, keyHex, {
			        mode: CryptoJS.mode.ECB,
			        padding: CryptoJS.pad.Pkcs7
			    });
			    $("#username").val(encryptedUname);
				$("#password").val(encryptedPwd);
				isValid = true;
			},
			error : function(jqXHR, textStatus , errorThrown){
				if(jqXHR.status == '405'){
					alert('An error occured. Please try again');
					window.location.reload();
				}
			}
		});
	}
	/*if(uname.length > 0 && pwd.length > 0){
		$.ajax({
			url : "getHashtoken",
			type : "POST",
			cache : false,
			async : false,
			success : function(resData){				
				var keyHex = CryptoJS.enc.Utf8.parse(resData);
			    var encrypted = CryptoJS.DES.encrypt(pwd, keyHex, {
			        mode: CryptoJS.mode.ECB,
			        padding: CryptoJS.pad.Pkcs7
			    });
				$("#password").val(encrypted);
				isValid = true;
			},
			error : function(jqXHR, textStatus , errorThrown){
				if(jqXHR.status == '405'){
					alert('An error occured. Please try again');
					window.location.reload();
				}
			}
		});
	}
	return isValid;*/
}

function resetPassword(){
	var newpassword = $("#newpassword").val();
	var confirmpassword = $("#confirmpassword").val();
	if(newpassword.length > 0 && confirmpassword.length > 0 && newpassword == confirmpassword){
		var keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
		var encNewPass = CryptoJS.DES.encrypt(newpassword, keyHex, {
		    mode: CryptoJS.mode.ECB,
		    padding: CryptoJS.pad.Pkcs7
		});
		keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
		var encCnfPass = CryptoJS.DES.encrypt(confirmpassword, keyHex, {
		    mode: CryptoJS.mode.ECB,
		    padding: CryptoJS.pad.Pkcs7
		});
		$("#newpassword").val(encNewPass);
		$("#confirmpassword").val(encCnfPass);
		return true;
	}else{
		alert("Enter New Password, Confirm again and these should match");
		return false;
	}
}

function changepassword(button){
	var oldPass = $("#oldPassword").val();
	var newPass = $("#newPassword").val();
	var cnfPass = $("#confirmPassword").val();
	if(oldPass.length > 0){
		if(newPass.length > 0 && cnfPass.length > 0 && newPass == cnfPass){
	    	$(button).html("Updating...");
	    	$(button).attr("disabled","disabled");
	    					
			var keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
			var encOldPass = CryptoJS.DES.encrypt(oldPass, keyHex, {
				mode: CryptoJS.mode.ECB,
				padding: CryptoJS.pad.Pkcs7
			});
			keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
			var encNewPass = CryptoJS.DES.encrypt(newPass, keyHex, {
			    mode: CryptoJS.mode.ECB,
			    padding: CryptoJS.pad.Pkcs7
			});
			
			$.ajax({
				url : "../changePassword",
				type : "POST",
				data : "encOldPassword="+encOldPass+"&encNewPass="+encNewPass+"&oldCheck=Y",
				cache : false,
				success : function(resData){
					alert(resData);
					$("#oldPassword").val("");
					$("#newPassword").val("");
					$("#confirmPassword").val("");
					$(button).html("Update");
					$(button).removeAttr("disabled");
				}
			});
		}else{
			alert("Enter New Password, Confirm again and these should match");
		}
	}else{
		alert("Enter current Password");
	}
}