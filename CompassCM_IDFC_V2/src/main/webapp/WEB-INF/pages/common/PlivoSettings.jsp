<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
		$("#updatePlivoSettings"+id).click(function(){
			var authId = $("#plivoAuthId"+id).val();
			var authToken = $("#plivoAuthToken"+id).val();
			var sourceNo = $("#plivoSourceNo"+id).val();
			var destNo = $("#plivoDestNo"+id).val();
			var fullData = "authId="+authId+"&authToken="+authToken+"&sourceNo="+sourceNo+"&destNo="+destNo;
			
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/updatePlivoSettings",
				cache:	false,
				type: "POST",
				data: fullData,
				success: function(response){
					$("#compassCaseWorkFlowGenericModal").modal("hide");
					alert(response);
				}, 
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#plivoTestSMS"+id).click(function(){
			var button = $(this);
			$(button).val("Sending...");
			$(button).attr("disabled",true);
			var plivoTestDestNo = $("#plivoTestDestNo"+id).val();
			var plivoTestMsg = $("#plivoTestMsg"+id).val();
			var fullData = "plivoTestDestNo="+plivoTestDestNo+"&plivoTestMsg="+plivoTestMsg;
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/sendTestMessage",
				cache:	false,
				type: "POST",
				data: fullData,
				success: function(response){
					//$(button).val("Send SMS");
					//$(button).removeAttr("disabled");
					$("#compassCaseWorkFlowGenericModal").modal("hide");
					alert(response);
				}, 
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		/*$(".numberValidator").keyup(function(e){
			if(this.value.length < 3){
				this.value = '+91';
			}else if(this.value.indexOf('+91') !== 0){
				this.value = '+91' + String.fromCharCode(e.which);
			}
		});*/
		
		
		
	});
</script>
<style type="text/css">
	fieldset.plivo{
	border: 1px groove #ddd !important;
    padding: -5px 10px 5px 10px!important;
    margin: 5px 0 0 0 !important;
    -webkit-box-shadow:  0px 0px 0px 0px #000;
            box-shadow:  0px 0px 0px 0px #000;
	}
	legend.plivo {
	text-align: left !important;
	width:inherit; 
    border-bottom:none;
    margin: 0px;
    margin-left: 10px;
    margin-bottom : 5px;
    padding: 0px;
}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_plivoSettings">
			<form id="plivoSettingsForm" >
				<div class="panelSearchForm plivoSettingsForm" style="padding: 0px 5px 5px 5px;">
					<fieldset class="plivo">
						<legend class="plivo" style=" color:red; font-size: 13px; font-weight: bold;" >Settings</legend>			
						<table class="table plivoSettingsTable table-striped" style="margin-bottom: 0px;">
							<tr>
								<td width="15%">Authentication ID</td>
								<td width="30%"><input type="text" class="form-control input-sm" name="plivoAuthId" id="plivoAuthId${UNQID}" value="${PLIVOSETTINGS['AUTHID']}"/></td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Authentication Token</td>
								<td width="30%"><input type="text" class="form-control input-sm" name="plivoAuthToken" id="plivoAuthToken${UNQID}" value="${PLIVOSETTINGS['AUTHTOKEN']}"/></td>
							</tr>
							<tr>	
								<td width="15%">Sender's Number</td>
								<td width="30%"><input type="text" class="form-control input-sm numberValidator" name="plivoSourceNo" id="plivoSourceNo${UNQID}" value="${PLIVOSETTINGS['SOURCENUMBER']}"/></td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Recipients' Numbers</td>
								<td width="30%">
									<textarea rows="3" cols="3" class="form-control input-sm numberValidator" name="plivoDestNo" id="plivoDestNo${UNQID}">${PLIVOSETTINGS['DESTINATIONNUMBER']}</textarea>
								</td>
							</tr>
						</table>
						<div class="card-footer clearfix">
							<div class="pull-${dirR}">
								<input type="button" id="updatePlivoSettings${UNQID}" class="btn btn-success btn-sm" name="updatePlivoSettings" value="Update">							
								<input type="reset" class="btn btn-danger btn-sm" id="clearPlivoSettings${UNQID}" name="clearPlivoSettings" value="Clear"/>
							</div>
						</div>
					</fieldset>
				</div>
			</form>
	
			<form id="plivoTestMsgCallForm" >
				<div class="panelSearchForm plivoTestMsgCallForm" style="padding: 0px 5px 5px 5px;">
					<fieldset class="plivo">
					<legend class="plivo" style=" color:red; font-size: 13px; font-weight: bold;" >Test Message/Call</legend>			
					<table class="table plivoTestMsgCallTable table-striped" style="margin-bottom: 0px;">
						<tr>
							<td width="15%">Recipient Number</td>
							<td width="30%"><input type="text" class="form-control input-sm" name="plivoTestDestNo" id="plivoTestDestNo${UNQID}"/></td>
							<td width="10%">&nbsp;</td>
							<td width="15%">Message</td>
							<td width="30%">
								<textarea rows="3" cols="3" class="form-control input-sm" name="plivoTestMsg" id="plivoTestMsg${UNQID}"></textarea>
							</td>
						</tr>
					</table>
					<div class="card-footer clearfix">
						<div class="pull-${dirR}">
							<input type="button" id="plivoTestSMS${UNQID}" class="btn btn-primary btn-sm" name="testSMS" value="Send SMS">
							<input type="button" id="plivoMakeCall${UNQID}" class="btn btn-success btn-sm" name="makeCall" value="Make Call" disabled="disabled">							
							<input type="reset" class="btn btn-danger btn-sm" id="clearPlivoSettings${UNQID}" name="Clear" value="Clear"/>
						</div>
					</div>
					</fieldset>
				</div>
			</form>		
			</div>
	</div>
</div>