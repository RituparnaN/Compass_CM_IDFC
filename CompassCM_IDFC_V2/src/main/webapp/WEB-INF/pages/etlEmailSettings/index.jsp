<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/tripledes.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/core-min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/enc-base64-min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
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
	
	var sendOnFail = "${EMAILSETTINGS['SENDEMAILONFAIL']}";
	var sendOnCancel = "${EMAILSETTINGS['SENDEMAILONCANCEL']}";
	if(sendOnFail == 'Y' || sendOnCancel == 'Y'){
		$("#successFailSame").removeAttr("disabled");
	}else{
		$("#successFailSame").attr("disabled", "disabled");
		$("#successFailSame").prop("checked",false);
	}
	
	var successFailSame = $("#successFailSame").is(":checked");
	if(successFailSame){
		$("#failETLEmailIDS").hide();
	}else{
		if($("#emailSendOnCancel").is(":checked") || $("#emailSendOnFail").is(":checked"))
			$("#failETLEmailIDS").show();
	}
	
	$("#successFailSame").change(function(){
		var successFailSame = $(this).is(":checked");
		if(successFailSame){
			$("#failETLEmailIDS").hide();
		}else{
			$("#failETLEmailIDS").show();
		}
	});
	
	$("#emailSendOnFail").change(function(){
		var emailSendOnFail = $(this).is(":checked");
		var emailSendOnCancel = $("#emailSendOnCancel").is(":checked");
		$("#successFailSame").prop("checked",false).change();
		if(emailSendOnFail || emailSendOnCancel){
			$("#successFailSame").removeAttr("disabled");
			$("#failETLEmailIDS").show();
		}else{
			$("#successFailSame").attr("disabled", "disabled");
			$("#failETLEmailIDS").hide();
		}
	});
	
	$("#emailSendOnCancel").change(function(){
		var emailSendOnCancel = $(this).is(":checked");
		var emailSendOnFail = $("#emailSendOnFail").is(":checked");
		$("#successFailSame").prop("checked",false).change();
		if(emailSendOnFail || emailSendOnCancel){
			$("#successFailSame").removeAttr("disabled");
			$("#failETLEmailIDS").show();
		}else{
			$("#successFailSame").attr("disabled", "disabled");
			$("#failETLEmailIDS").hide();
		}
	});
	
	$("#saveETLEmailSettings").click(function(){
		var emailPassword = $("#ETLEMAILPASSWORD").val();
		var keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
		var encEmailPassword = CryptoJS.DES.encrypt(emailPassword, keyHex, {
		    mode: CryptoJS.mode.ECB,
		    padding: CryptoJS.pad.Pkcs7
		});
		encEmailPassword = escape(encEmailPassword);
		var successRecepIdsTO = $("#SUCCESSRECIPIENTSTO").val();
		var successRecepIdsCC = $("#SUCCESSRECIPIENTSCC").val();
		var failRecepIdsTO = $("#FAILCANCELRECIPIENTSTO").val();
		var failRecepIdsCC = $("#FAILCANCELRECIPIENTSCC").val();
		
		var emailSendOnCancel = "";
		var emailSendOnFail = "";
		var successFailSame = "";
		if($("#emailSendOnCancel").is(":checked")){
			emailSendOnCancel = "Y";
		}else{
			emailSendOnCancel = "N";
		}
		if($("#emailSendOnFail").is(":checked")){
			emailSendOnFail = "Y";
		}else{
			emailSendOnFail = "N";
		}
		if($("#successFailSame").is(":checked")){
			successFailSame = "Y";
			failRecepIdsTO = "";
			failRecepIdsCC = "";
		}else{
			successFailSame = "N";
		}
		var isValid = true;
		if(($("#emailSendOnCancel").is(":checked") || $("#emailSendOnFail").is(":checked")) && !$("#successFailSame").is(":checked")){
			if(failRecepIdsTO.trim().length == 0){
				alert("Enter Recipients TO for fail or cancel event");
				isValid = false;
			}
		}
		
		var fullDate = "SUCCESSRECIPIENTSTO="+escape(successRecepIdsTO)+"&SUCCESSRECIPIENTSCC="+escape(successRecepIdsCC)+
						"&FAILCANCELRECIPIENTSTO="+escape(failRecepIdsTO)+"&FAILCANCELRECIPIENTSCC="+escape(failRecepIdsCC)+
						"&SENDEMAILONFAIL="+escape(emailSendOnFail)+"&SENDEMAILONCANCEL="+escape(emailSendOnCancel)+"&SUCCESSFAILIDSSAME="+escape(successFailSame);
		if(emailPassword != "" && emailPassword.trim().length > 0){
			fullDate = fullDate+"&ETLEMAILPASSWORD="+encEmailPassword;
		}
		if(isValid){
			var button = $(this);
			$(button).attr("disabled","disabled");
			$(button).html("Saving...");
			$.ajax({
				url : 'saveETLEmailSettings',
				cache : false,
				data : fullDate,
				type : 'POST',
				success : function(resData){
					alert(resData);
					$(button).html("Save");
					$(button).removeAttr("disabled");
	    	    	$("#ETLEMAILPASSWORD").val("");
				}
			});
		}	
	});
	
	$("#sendETLTestMail").click(function(){
		var emailPassword = $("#ETLEMAILPASSWORD").val();
		var keyHex = CryptoJS.enc.Utf8.parse("QDECOMPASS");
		var encEmailPassword = CryptoJS.DES.encrypt(emailPassword, keyHex, {
		    mode: CryptoJS.mode.ECB,
		    padding: CryptoJS.pad.Pkcs7
		});
		if(emailPassword.trim().length > 0){
			emailPassword = encEmailPassword
		}
		var button = $(this);
		var actualValue = $(button).html();
		$(button).attr("disabled","disabled");
		$(button).html("Sending...");
		$.ajax({
			url : 'sendETLTestEmail?password='+escape(emailPassword),
			cache : false,
			type : 'POST',
			success : function(resData){
				alert(resData);
				$(button).html(actualValue);
				$(button).removeAttr("disabled");
			}
		});
	});
});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-default">
			<div class="card-body">
	    		<table class="table table-bordered table-striped formSearchTable">
	    			<tbody>
	    				<tr>
	    					<td width="18%">Authentication ID</td>
	    					<td width="30%">${EMAILSETTINGS['AUTHID']}</td>
	    					<td width="4%">&nbsp;</td>
	    					<td width="18%">Email ID</td>
	    					<td width="30%">${EMAILSETTINGS['FROMID']}</td>
	    				</tr>
	    				<tr>
	    					<td>Email Password</td>
	    					<td>
	    						<input type="password" class="form-control input-sm" id="ETLEMAILPASSWORD" name="ETLEMAILPASSWORD"/>
	    					</td>
	    					<td colspan="3">&nbsp;</td>
	    				</tr>
	    				<tr>
	    					<td>RecipientsID TO</td>
	    					<td>
	    						<textarea class="form-control input-sm" id="SUCCESSRECIPIENTSTO" name="SUCCESSRECIPIENTSTO">${EMAILSETTINGS['SUCCESSRECIPIENTSTO']}</textarea>
	    					</td>
	    					<td >&nbsp;</td>
	    					<td>RecipientsID CC</td>
	    					<td>
	    						<textarea class="form-control input-sm" id="SUCCESSRECIPIENTSCC" name="SUCCESSRECIPIENTSCC">${EMAILSETTINGS['SUCCESSRECIPIENTSCC']}</textarea>
	    					</td>
	    				</tr>
	    				<tr>
	    					<td colspan="2">
	    						<label class="btn btn-default btn-sm" for="emailSendOnFail">
	    							<input type="checkbox" id="emailSendOnFail" <c:if test="${EMAILSETTINGS['SENDEMAILONFAIL'] == 'Y'}">checked="checked"</c:if>>
	    							Auto email send on any failure in ETL 
	    						</label>
	    						<label class="btn btn-default btn-sm" for="emailSendOnCancel">
	    							<input type="checkbox" id="emailSendOnCancel" <c:if test="${EMAILSETTINGS['SENDEMAILONCANCEL'] == 'Y'}">checked="checked"</c:if>>
	    							Auto email send on process manual termination in ETL 
	    						</label>
	    					</td>
	    					<td>&nbsp;</td>
	    					<td colspan="2">
	    						<label class="btn btn-default btn-sm" for="successFailSame">
	    							<input type="checkbox" id="successFailSame" <c:if test="${EMAILSETTINGS['SUCCESSFAILIDSSAME'] == 'Y'}">checked="checked"</c:if>>
	    							Use same TO and CC email ids on fail ETL or cancel ETL or both   
	    						</label>
	    					</td>
	    				</tr>
	    				<tr id="failETLEmailIDS" style="display: none;">
	    					<td>RecipientsID TO (when fail or cancel)&#x200E;</td>
	    					<td>
	    						<textarea class="form-control input-sm" id="FAILCANCELRECIPIENTSTO" name="FAILCANCELRECIPIENTSTO">${EMAILSETTINGS['FAILCANCELRECIPIENTSTO']}</textarea>
	    					</td>
	    					<td >&nbsp;</td>
	    					<td>RecipientsID CC (when fail or cancel)&#x200E;</td>
	    					<td>
	    						<textarea class="form-control input-sm" id="FAILCANCELRECIPIENTSCC" name="FAILCANCELRECIPIENTSCC">${EMAILSETTINGS['FAILCANCELRECIPIENTSCC']}</textarea>
	    					</td>
	    				</tr>
	    			</tbody>
	    		</table>
	    	</div>
	    	<div class="card-footer clearfix">
		        <div class="pull-right">
		            <a href="javascript:void(0)" id="saveETLEmailSettings" class="btn btn-success btn-sm">Save</a>
		            <a href="javascript:void(0)" id="sendETLTestMail" class="btn btn-primary btn-sm">Send Test Mail</a>
		        </div>
	    	</div>
		</div>
	</div>
</div>