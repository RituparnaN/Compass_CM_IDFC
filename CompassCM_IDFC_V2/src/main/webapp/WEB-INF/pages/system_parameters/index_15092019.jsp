<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/tripledes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/core-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/enc-base64-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/init.js"></script>
<c:set var="ROLE" value="${f:substring(ROLE,5,12)}"/>
<script type="text/javascript">
$(document).ready(function(){
	var userRole = '${ROLE}';
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
	
	
	var auth = '${AUTH}';
	if(auth == 'LDAP'){
		$("#capitalLetter").attr("disabled","disabled");
		$("#smallLetter").attr("disabled","disabled");
		$("#numericLetter").attr("disabled","disabled");
		$("#specialCharacter").attr("disabled","disabled");
		$("#passwordLength").attr("disabled","disabled");
		$("#passwordExpiryPeriod").attr("disabled","disabled");
	}
	$.ajax({
		url : 'getSystemParameter',
		cache : false,
		type : 'POST',
		success : function(resData){
			$("#sessionTimeOut").val(resData.SESSIONTIMEOUT);
			if(resData.PASSWORDPATTERN.indexOf("CAP") >= 0){
				$("#capitalLetter").attr("checked","checked");
			}
			if(resData.PASSWORDPATTERN.indexOf("SML") >= 0){
				$("#smallLetter").attr("checked","checked");
			}
			if(resData.PASSWORDPATTERN.indexOf("NUM") >= 0){
				$("#numericLetter").attr("checked","checked");
			}
			if(resData.PASSWORDPATTERN.indexOf("SPL") >= 0){
				$("#specialCharacter").attr("checked","checked");
			}
			$("#passwordLength").val(resData.PASSWORDLENGTH);
			$("#passwordExpiryPeriod").val(resData.PASSWORDEXPIRY);
			$("#dormancyPeriod1").val(resData.DORMANCYPERIOD1);
			$("#dormancyPeriod2").val(resData.DORMANCYPERIOD2);
			$("#lockoutAttempt").val(resData.LOCKOUTATTEMPT);
			
			$("#alertResolutionDays").val(resData.ALERTRESOLUTIONDAYS);
			$("#caseResolutionDays").val(resData.CASEESOLUTIONDAYS);
			$("#ctrFilePath").val(resData.CTRFILEPATH);
			$("#ctrLastNo").val(resData.CTRLASTNO);
			$("#ccrFilePath").val(resData.CCRFILEPATH);
			$("#ccrLastNo").val(resData.CCRLASTNO);
			$("#strFilePath").val(resData.STRFILEPATH);
			$("#strLastNo").val(resData.STRLASTNO);
			$("#ntrFilePath").val(resData.NTRFILEPATH);
			$("#ntrLastNo").val(resData.NTRLASTNO);
			$("#cbwtFilePath").val(resData.CBTWFILEPATH);
			$("#cbwtLastNo").val(resData.CBWTLASTNO);
			
			if(resData.EMAILAUTOREFRESH == 'N'){
				$("#emailAutoRefreshNo").attr("checked","checked");
			}else{
				$("#emailAutoRefreshYes").attr("checked","checked");
			}
			
			$("#lookupDays").val(resData.LOOKUPDAYS);
			
			$("#inboxFolderName").val(resData.INBOXFOLDERNAME);
			if(resData.INBOXFOLDERREFRESH == 'N'){
				$("#inboxRefreshNo").attr("checked","checked");
				$("#inboxFolderName").attr("disabled","disabled");
			}else{
				$("#inboxRefreshYes").attr("checked","checked");
				$("#inboxFolderName").removeAttr("disabled");
			}
			
			$("#sentFolderName").val(resData.SENTFOLDERNAME);
			if(resData.SENTFOLDERREFRESH == 'N'){
				$("#sentRefreshNo").attr("checked","checked");
				$("#sentFolderName").attr("disabled","disabled");
				$("#sentMessageSaveMessage").show();
			}else{
				$("#sentRefreshYes").attr("checked","checked");
				$("#sentFolderName").removeAttr("disabled");
				$("#sentMessageSaveMessage").hide();
			}
			
			$("#emailSearchString").val(resData.CASESEARCHSTRING);
			$("#subjectsToIgnore").val(resData.SUBJECTESCAPESTRING);
			
			$("#senderEmailId").val(resData.SENDEREMAILID);
			$("#emailIdsForAlert").val(resData.EMAILIDSFORALERT);
			$("#emailIdsForCRP").val(resData.EMAILIDSFORCRP);
			
			$("#recommendation_FPOPercentage").val(resData.RECOMMENDATION_FPOPERCENTAGE);
			$("#recommendation_MLIPercentage").val(resData.RECOMMENDATION_MLIPERCENTAGE);

			$("#alertReminder1_InDays").val(resData.ALERTREMINDER1_INDAYS);
			$("#alertReminder2_InDays").val(resData.ALERTREMINDER2_INDAYS);
			$("#alertReminder3_InDays").val(resData.ALERTREMINDER3_INDAYS);
						 
			if(resData.EMAILAUTOREFRESH == 'N'){
				$("#lookupDays").attr("disabled","disabled");
				$("#inboxRefreshYes").attr("disabled","disabled");
				$("#inboxRefreshNo").attr("disabled","disabled");
				$("#inboxFolderName").attr("disabled","disabled");
				$("#sentRefreshYes").attr("disabled","disabled");
				$("#sentRefreshNo").attr("disabled","disabled");
				$("#sentFolderName").attr("disabled","disabled");
				$("#emailSearchString").attr("disabled","disabled");
				$("#subjectsToIgnore").attr("disabled","disabled");
				$("#emailPassword").attr("disabled","disabled");
				$("#senderEmailId").attr("disabled","disabled");
				$("#emailIdsForAlert").attr("disabled","disabled");
				$("#emailIdsForCRP").attr("disabled","disabled");
				$("#recommendation_FPOPercentage").attr("disabled","disabled");
				$("#recommendation_MLIPercentage").attr("disabled","disabled");
				$("#alertReminder1_InDays").attr("disabled","disabled");
				$("#alertReminder2_InDays").attr("disabled","disabled");
				$("#alertReminder3_InDays").attr("disabled","disabled");
			}
			
		}
	});
	
	$("#saveSystemParameter").click(function(){
		var patternCount = 0;
		var isValid = true;
		var button = $(this);

		var sessionTimeOut = "";
		var capitalLetter = "";
		var smallLetter = "";
		var numericLetter = "";
		var specialCharacter = "";
		var passwordPattern = "";
		var passwordLength = "";		
		var passwordExpiryPeriod = "";
		var dormancyPeriod1 = "";
		var dormancyPeriod2 = "";
		var lockoutAttempt = "";
		
		var alertResolutionDays = "";
		var caseResolutionDays = "";
		var ctrFilePath =  "";
		var ctrLastNo = "";
		var ccrFilePath = "";
		var ccrLastNo = "";
		var strFilePath = "";
		var strLastNo = "";
		var ntrFilePath = "";
		var ntrLastNo = "";
		var cbwtFilePath = "";
		var cbwtLastNo = "";
		var emailAutorefresh = "";
		var lookupDays = "";
		var inboxRefreshYes = "";
		var inboxFolderName = "";
		var sentRefreshYes = "";
		var sentFolderName = "";
		var emailSearchString = "";
		var subjectsToIgnore = "";
		var emailPassword = "";
		var senderEmailId = "";
		var emailIdsForAlert = "";
		var emailIdsForCRP = "";
		var recommendation_FPOPercentage = "";
		var recommendation_MLIPercentage = "";
		var alertReminder1_InDays = "";
		var alertReminder2_InDays = "";
		var alertReminder3_InDays = "";
		
		var keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
		var encEmailPassword = CryptoJS.DES.encrypt(emailPassword, keyHex, {
		    mode: CryptoJS.mode.ECB,
		    padding: CryptoJS.pad.Pkcs7
		});
		
		if(userRole == 'MAKER' || userRole == 'CHECKER'){
			sessionTimeOut = $("#sessionTimeOut").val();
			capitalLetter = $("#capitalLetter").is(":checked");
			smallLetter = $("#smallLetter").is(":checked");
			numericLetter = $("#numericLetter").is(":checked");
			specialCharacter = $("#specialCharacter").is(":checked");
			passwordLength = $("#passwordLength").val();		
			passwordExpiryPeriod = $("#passwordExpiryPeriod").val();
			dormancyPeriod1 = $("#dormancyPeriod1").val();
			dormancyPeriod2 = $("#dormancyPeriod2").val();
			lockoutAttempt = $("#lockoutAttempt").val();
			
			if(capitalLetter){
				patternCount++;
				passwordPattern = "CAP,";
			}			
			if(smallLetter){
				patternCount++;
				passwordPattern = passwordPattern+"SML,";
			}			
			if(numericLetter){
				patternCount++;
				passwordPattern = passwordPattern+"NUM,";
			}			
			if(specialCharacter){
				patternCount++;
				passwordPattern = passwordPattern+"SPL,";
			}
			
			if((parseInt(sessionTimeOut) < 60 || parseInt(sessionTimeOut) > 1200) && isValid){
				isValid = false;
				alert("Session Timeout value should be more than 60 and less than 1200");
			}
			
			if(patternCount < 3 && isValid){
				isValid = false;
				alert("Minimum 3 pattern should be selected as standred password pattern");
			}
			
			if(isValid)
				if(passwordLength.indexOf(",") > 0){
					var min = parseInt(passwordLength.split(",")[0]);
					var max = parseInt(passwordLength.split(",")[1]);
					
					if(min < 6 || min > max){
						isValid = false;
						alert("Password minimum length should be more than 0 and less than the max length");
					}
				}else{
					isValid = false;
					alert("Please enter password minimum and maximum length sepetared by comma(,)");
				}
		}else{
			alertResolutionDays = $("#alertResolutionDays").val();
			caseResolutionDays = $("#caseResolutionDays").val();
			ctrFilePath =  $("#ctrFilePath").val();
			ctrLastNo = $("#ctrLastNo").val();
			ccrFilePath = $("#ccrFilePath").val();
			ccrLastNo = $("#ccrLastNo").val();
			strFilePath = $("#strFilePath").val();
			strLastNo = $("#strLastNo").val();
			ntrFilePath = $("#ntrFilePath").val();
			ntrLastNo = $("#ntrLastNo").val();
			cbwtFilePath = $("#cbwtFilePath").val();
			cbwtLastNo = $("#cbwtLastNo").val();
			
			emailAutorefresh = "Y";
			if($("#emailAutoRefreshYes").is(":checked")){
				emailAutorefresh = "Y";
			}else{
				emailAutorefresh = "N";
			}
			
			lookupDays = $("#lookupDays").val();
			
			inboxRefreshYes = "Y";
			if($("#inboxRefreshYes").is(":checked")){
				inboxRefreshYes = "Y";
			}else{
				inboxRefreshYes = "N";
			}
			inboxFolderName = $("#inboxFolderName").val();
			
			sentRefreshYes = "Y";
			if($("#sentRefreshYes").is(":checked")){
				sentRefreshYes = "Y";
			}else{
				sentRefreshYes = "N";
			}
			sentFolderName = $("#sentFolderName").val();
			emailSearchString = $("#emailSearchString").val();
			subjectsToIgnore = $("#subjectsToIgnore").val();
			emailPassword = $("#emailPassword").val();
			
			senderEmailId = $("#senderEmailId").val();
			emailIdsForAlert = $("#emailIdsForAlert").val();
			emailIdsForCRP = $("#emailIdsForCRP").val();
			recommendation_FPOPercentage = $("#recommendation_FPOPercentage").val();
			recommendation_MLIPercentage = $("#recommendation_MLIPercentage").val();
			alertReminder1_InDays = $("#alertReminder1_InDays").val();
			alertReminder2_InDays = $("#alertReminder2_InDays").val();
			alertReminder3_InDays = $("#alertReminder3_InDays").val();
			
			/* keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
			encEmailPassword = CryptoJS.DES.encrypt(emailPassword, keyHex, {
			    mode: CryptoJS.mode.ECB,
			    padding: CryptoJS.pad.Pkcs7
			}); */
		}
		
		if(isValid){
	    	button.html("Updating...");
	    	button.attr("disabled","disabled");
	    	var fullData = "";
			if(userRole == 'MAKER' || userRole == 'CHECKER'){
				fullData = "SESSIONTIMEOUT="+sessionTimeOut+"&PASSWORDPATTERN="+passwordPattern+"&PASSWORDLENGTH="+passwordLength+
						   "&PASSWORDEXPIRY="+passwordExpiryPeriod+"&DORMANCYPERIOD1="+dormancyPeriod1+
						   "&DORMANCYPERIOD2="+dormancyPeriod2+"&LOCKOUTATTEMPT="+lockoutAttempt;
			}else{
				fullData = "&ALERTRESOLUTIONDAYS="+alertResolutionDays+"&CASEESOLUTIONDAYS="+caseResolutionDays+
						   "&CTRFILEPATH="+ctrFilePath+"&CTRLASTNO="+ctrLastNo+"&CCRFILEPATH="+ccrFilePath+"&CCRLASTNO="+ccrLastNo+
						   "&STRFILEPATH="+strFilePath+"&STRLASTNO="+strLastNo+"&NTRFILEPATH="+ntrFilePath+"&NTRLASTNO="+ntrLastNo+
						   "&CBTWFILEPATH="+cbwtFilePath+"&CBWTLASTNO="+cbwtLastNo+"&EMAILAUTOREFRESH="+emailAutorefresh+
						   "&LOOKUPDAYS="+lookupDays+"&INBOXFOLDERREFRESH="+inboxRefreshYes+"&INBOXFOLDERNAME="+inboxFolderName+
						   "&SENTFOLDERREFRESH="+sentRefreshYes+"&SENTFOLDERNAME="+sentFolderName+
						   "&CASESEARCHSTRING="+emailSearchString+"&SUBJECTESCAPESTRING="+subjectsToIgnore+
						   "&SENDEREMAILID="+senderEmailId+"&EMAILIDSFORALERT="+emailIdsForAlert+"&EMAILIDSFORCRP="+emailIdsForCRP+
						   "&RECOMMENDATION_FPOPERCENTAGE="+recommendation_FPOPercentage+"&RECOMMENDATION_MLIPERCENTAGE="+recommendation_MLIPercentage+
						   "&ALERTREMINDER1_INDAYS="+alertReminder1_InDays+"&ALERTREMINDER2_INDAYS="+alertReminder2_InDays+"&ALERTREMINDER3_INDAYS="+alertReminder3_InDays;
			}
			if((emailPassword.trim().length > 0) && (userRole == 'MAKER' || userRole == 'CHECKER')){
				fullData = fullData+"&EMAILPASSSWORD="+encEmailPassword;
			}
			//alert(fullData);
			$.ajax({
				url : 'saveSystemParameter',
				cache : false,
				data : fullData,
				type : 'POST',
				success : function(resData){
					alert(resData);
					button.html("Update");
	    	    	button.removeAttr("disabled");
	    	    	$("#emailPassword").val("");
	    	    	reloadTabContent();
				},
				error : function(a,b,c){
					alert(a,b,c);
				}
			});
		}
	});
	
	$("#emailAutoRefreshYes").change(function(){
		if($(this).is(":checked")){
			$("#lookupDays").removeAttr("disabled");
			$("#inboxRefreshYes").removeAttr("disabled");
			$("#inboxRefreshNo").removeAttr("disabled");
			$("#sentRefreshYes").removeAttr("disabled");
			$("#sentRefreshNo").removeAttr("disabled");
			$("#emailSearchString").removeAttr("disabled");
			$("#subjectsToIgnore").removeAttr("disabled");
			$("#emailPassword").removeAttr("disabled");
			
			if($("#sentRefreshYes").is(":checked")){
				$("#sentFolderName").removeAttr("disabled");
				$("#sentMessageSaveMessage").hide();
			}else{
				$("#sentFolderName").attr("disabled","disabled");
				$("#sentMessageSaveMessage").show();
			}
			
			if($("#inboxRefreshYes").is(":checked")){
				$("#inboxFolderName").removeAttr("disabled");
			}else{
				$("#inboxFolderName").attr("disabled","disabled");
			}
		}
	});
	
	$("#sentRefreshYes").change(function(){
		if($(this).is(":checked")){
			$("#sentFolderName").removeAttr("disabled");
			$("#sentMessageSaveMessage").hide();
		}
	});
	
	$("#sentRefreshNo").change(function(){
		if($(this).is(":checked")){
			$("#sentFolderName").attr("disabled","disabled");
			$("#sentMessageSaveMessage").show();
		}
	});
	
	$("#inboxRefreshYes").change(function(){
		if($(this).is(":checked")){
			$("#inboxFolderName").removeAttr("disabled");
		}
	});
	
	$("#inboxRefreshNo").change(function(){
		if($(this).is(":checked")){
			$("#inboxFolderName").attr("disabled","disabled");
		}
	});
	
	$("#emailAutoRefreshNo").change(function(){
		if($(this).is(":checked")){
			$("#lookupDays").attr("disabled","disabled");
			$("#inboxRefreshYes").attr("disabled","disabled");
			$("#inboxRefreshNo").attr("disabled","disabled");
			$("#inboxFolderName").attr("disabled","disabled");
			$("#sentRefreshYes").attr("disabled","disabled");
			$("#sentRefreshNo").attr("disabled","disabled");
			$("#sentFolderName").attr("disabled","disabled");
			$("#emailSearchString").attr("disabled","disabled");
			$("#subjectsToIgnore").attr("disabled","disabled");
			$("#emailPassword").attr("disabled","disabled");
		}
	});
	
	$("#getFATCASettings").click(function(){
		$("#compassCaseWorkFlowGenericModal").modal("show");
		$("#compassCaseWorkFlowGenericModal-title").html("FATCA Settings");
		$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/fatcaSettings",
			cache: false,
			type: "POST",
			success: function(res) {
				$("#compassCaseWorkFlowGenericModal-body").html(res);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
	});
	
	$("#plivoSettings").click(function(){
		$("#compassCaseWorkFlowGenericModal").modal("show");
		$("#compassCaseWorkFlowGenericModal-title").html("Compass SMS/Call Settings");
		$("#compassCaseWorkFlowGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>");
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getPlivoSettings",
			cache: false,
			type: "POST",
			success: function(res) {
				$("#compassCaseWorkFlowGenericModal-body").html(res);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
	});
});
</script>
<style>
.formSearchTable > tbody > tr > td{
	font-size: small;
}
</style>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-default">
	    	<div class="card-body">
	    		<table class="table table-bordered table-striped formSearchTable">
	    			<tbody>
	    			<c:choose>
	    				<c:when test="${ROLE eq 'MAKER' || ROLE eq 'CHECKER'}">
		    				<tr>
		    					<td width="18%">Session Timeout (second)&#x200E;</td>
		    					<td width="30%">
		    						<input type="text" class="form-control input-sm" id="sessionTimeOut" name="sessionTimeOut" placeholder="Session Timeout"/>
		    					</td>
		    					<td width="4%">&nbsp;</td>
		    					<td width="18%">Password Patterns</td>
		    					<td width="30%">
		    						<label class="btn btn-default btn-sm" for="capitalLetter" style="margin: 3px;">
									    <input type="checkbox" id="capitalLetter">
									    Capital Letter
									</label>
									<label class="btn btn-default btn-sm" for="smallLetter">
									    <input type="checkbox" id="smallLetter">
									    Small Letter
									</label>
									<label class="btn btn-default btn-sm" for="numericLetter">
									    <input type="checkbox" id="numericLetter">
									    Numeric Letter
									</label>
									<label class="btn btn-default btn-sm" for="specialCharacter">
									    <input type="checkbox" id="specialCharacter">
									    Special Character
									</label>
		    					</td>
		    				</tr>
		    				<tr>
		    					<td>Password Length(min,max)&#x200E;</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="passwordLength" name="passwordLength" placeholder="min,max"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Password Expiry Period</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="passwordExpiryPeriod" name="passwordExpiryPeriod" placeholder="Password Expiry Period"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Dormancy Period 1</td>
		    					<td>
		    						<input type="number" class="form-control input-sm" id="dormancyPeriod1" name="dormancyPeriod1" />
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Dormancy Period 2</td>
		    					<td>
		    						<input type="number" class="form-control input-sm" id="dormancyPeriod2" name="dormancyPeriod2" />
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Lock Out Attempt</td>
		    					<td>
		    						<input type="number" class="form-control input-sm" id="lockoutAttempt" name="lockoutAttempt" />
		    					</td>
		    					<td colspan="3">&nbsp;</td>
		    				</tr>
		    			</c:when>	
	    				<c:otherwise>
		    				<tr>
		    					<td>Alert Resolution Days</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="alertResolutionDays" name="alertResolutionDays" placeholder="Alert Resolution Days"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Case Resolution Days</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="caseResolutionDays" name="caseResolutionDays" placeholder="Case Resolution Days"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>CTR File Path</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="ctrFilePath" name="ctrFilePath" placeholder="CTR File Path"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>CTR Last No</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="ctrLastNo" name="ctrLastNo" placeholder="CTR Last No"/>
		    					</td>
		    				</tr>
		    				<tr>
		    					<td>CCR File Path</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="ccrFilePath" name="ccrFilePath" placeholder="CCR File Path"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>CCR Last No</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="ccrLastNo" name="ccrLastNo" placeholder="CCR Last No"/>
		    					</td>
		    				</tr>
		    				<tr>
		    					<td>STR File Path</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="strFilePath" name="strFilePath" placeholder="STR File Path"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>STR Last No</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="strLastNo" name="strLastNo" placeholder="STR Last No"/>
		    					</td>
		    				</tr>
		    				<tr>
		    					<td>NTR File Path</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="ntrFilePath" name="ntrFilePath" placeholder="NTR File Path"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>NTR Last No</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="ntrLastNo" name="ntrLastNo" placeholder="NTR Last No"/>
		    					</td>
		    				</tr>
		    				<tr>
		    					<td>CBWT File Path</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="cbwtFilePath" name="cbwtFilePath" placeholder="CBWT File Path"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>CBWT Last No</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="cbwtLastNo" name="cbwtLastNo" placeholder="CBWT Last No"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Email AutoRefresh</td>
		    					<td>
		    						<label class="btn btn-default btn-sm" for="emailAutoRefreshYes">
									  <input type="radio" name="emailAutoRefresh" id="emailAutoRefreshYes" value="Y"> Yes
									</label>
									<label class="btn btn-default btn-sm" for="emailAutoRefreshNo">
									  <input type="radio" name="emailAutoRefresh" id="emailAutoRefreshNo" value="N"> No
									</label>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Lookup Days</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="lookupDays" name="lookupDays" placeholder="Lookup Days"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Inbox folder refresh</td>
		    					<td>
		    						<label class="btn btn-default btn-sm" for="inboxRefreshYes">
									  <input type="radio" name="inboxRefresh" id="inboxRefreshYes" value="Y"> Yes
									</label>
									<label class="btn btn-default btn-sm" for="inboxRefreshNo">
									  <input type="radio" name="inboxRefresh" id="inboxRefreshNo" value="N"> No
									</label>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Inbox folder name</td>
		    					<td>
		    						<input type="text" class="form-control" id="inboxFolderName" name="inboxFolderName" placeholder="Inbox folder name"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Sent folder refresh</td>
		    					<td>
		    						<label class="btn btn-default btn-sm" for="sentRefreshYes">
									  <input type="radio" name="sentRefresh" id="sentRefreshYes" value="Y"> Yes
									</label>
									<label class="btn btn-default btn-sm" for="sentRefreshNo">
									  <input type="radio" name="sentRefresh" id="sentRefreshNo" value="N"> No
									</label>
									<br/><br/>
									<span id="sentMessageSaveMessage" style="display: none;">
										<em style="color: red; font-size: x-small;">Email will be stored while sending</em>
									</span>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Sent folder name</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="sentFolderName" name="sentFolderName" placeholder="Sent folder name"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Case search string</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="emailSearchString" name="emailSearchString" placeholder="Email search string"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Subjects to ignore as response</td>
		    					<td>
		    						<textarea class="form-control input-sm" rows="3" id="subjectsToIgnore" name="subjectsToIgnore"></textarea>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Sender's Email Id</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="senderEmailId" name="senderEmailId"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Email Password</td>
		    					<td>
		    						<input type="password" class="form-control input-sm" id="emailPassword" name="emailPassword"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>
		    						Email Id's for Alert
		    						<p style="color: red; font-size: x-small;"><em>Delimiter should be <strong>;</strong></em></p>
		    					</td>
		    					<td>
		    						<textarea class="form-control input-sm" rows="3" id="emailIdsForAlert" name="emailIdsForAlert"></textarea>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>
		    						Email Id's for CRP
		    						<p style="color: red; font-size: x-small;"><em>Delimiter should be <strong>;</strong></em></p>
		    					</td>
		    					<td>
		    						<textarea class="form-control input-sm" rows="3" id="emailIdsForCRP" name="emailIdsForCRP"></textarea>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>Recommendation_FPO %</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="recommendation_FPOPercentage" name="recommendation_FPOPercentage"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>Recommendation_MLI %</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="recommendation_MLIPercentage" name="recommendation_MLIPercentage"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>AlertReminder1_InDays</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="alertReminder1_InDays" name="alertReminder1_InDays"/>
		    					</td>
		    					<td>&nbsp;</td>
		    					<td>AlertReminder2_InDays</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="alertReminder2_InDays" name="alertReminder2_InDays"/>
		    					</td>
		    				</tr>
		    				
		    				<tr>
		    					<td>AlertReminder3_InDays</td>
		    					<td>
		    						<input type="text" class="form-control input-sm" id="alertReminder3_InDays" name="alertReminder3_InDays"/>
		    					</td>
		    					<td>&nbsp;</td>
		    				</tr>
		
		
	    				</c:otherwise>
	    			</c:choose>
	    			</tbody>
				</table>
	    	</div> 
	    	<div class="card-footer clearfix">
		        <div class="pull-right">
		            <a href="javascript:void(0)" id="saveSystemParameter" class="btn btn-success btn-sm">Update</a>
		            <!--<a href="javascript:void(0)" id="getFATCASettings" class="btn btn-primary btn-sm">FATCA Settings</a>
		            <a href="javascript:void(0)" id="plivoSettings" class="btn btn-primary btn-sm">Compass SMS Settings</a>-->
		        </div>
	    	</div>
		</div>
	</div>
</div>