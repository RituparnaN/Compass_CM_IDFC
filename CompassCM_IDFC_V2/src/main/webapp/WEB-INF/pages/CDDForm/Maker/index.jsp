<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
		$("#scanDetails").click(function(){
			var scanName1 = $("#scanName1").val();
			var scanName2 = $("#scanName2").val();
			var scanName3 = $("#scanName3").val();
			var scanName4 = $("#scanName4").val();
			var scanName5 = $("#scanName5").val();
			var scanDOB = $("#scanDOB").val();
			var scanPassportNo = $("#scanPassportNo").val();
			var scanPanNo = $("#scanPanNo").val();
			var scanAccountNo = $("#scanAccountNo").val();
			var scanCustomerId = $("#scanCustomerId").val();
			var blackList = "N";
			if($("#blackList").prop("checked"))
				blackList = "Y";
			
			var rejectList = "N";
			if($("#rejectList").prop("checked"))
				rejectList = "Y";
			
			var customerDatabase = "N";
			if($("#customerDatabase").prop("checked"))
				customerDatabase = "Y";
			
			var employeeDatabase = "N";
			if($("#employeeDatabase").prop("checked"))
				employeeDatabase = "Y";

			var selectedBlackList = "N";
			if($("#selectedBlackList").prop("checked"))
				selectedBlackList = "Y";
			
			
			if(blackList == "N" && rejectList == "N" && customerDatabase == "N" && employeeDatabase == "N" && selectedBlackList == "N")
				alert("Select a list list from Checklist Form");
			else{
				if(scanName1 == "" && scanName2 == "" && scanName3 == "" && scanName4 == "" && scanName5 == "" && 
						scanDOB == "" && scanPassportNo == "" && scanPanNo == "" && scanAccountNo == "" && scanCustomerId == ""){
					alert("Enter details at least one field ")
				}else{
					var fullData = "NAME1="+scanName1+"&NAME2="+scanName2+"&NAME3="+scanName3+"&NAME4="+scanName4+"&NAME5="+scanName5+"&DATEOFBIRTH="+scanDOB+
					   "&PASSPORTNO="+scanPassportNo+"&PANNO="+scanPanNo+"&ACCOUNTNO="+scanAccountNo+"&CUSTOMERID="+scanCustomerId+"&userCode=NA&BlackListCheck="+blackList+
					   "&CustomerDataBaseCheck="+customerDatabase+"&RejectedListCheck="+rejectList+"&EmployeeDataBaseCheck="+employeeDatabase+"&SelectedBlackListCheck="+selectedBlackList;

					// window.open('${pageContext.request.contextPath}/common/dataEntryFormScanning?'+fullData);
					$("#compassRTScanningModal").modal("show");
					$("#compassRTScanningModal-title").html("Real Time Scanning");
					$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
					
					$("#openRTModalInWindow").attr("url-attr", "/common/dataEntryFormScanning");
					$("#openRTModalInWindow").attr("data-attr", fullData);
					
					$.ajax({
				 		url : '${pageContext.request.contextPath}/common/dataEntryFormScanning',
				 		cache : true,
				 		type : 'POST',
				 		data : fullData,
				 		success : function(resData){
				 			$("#compassRTScanningModal-body").html(resData);
				 		}
				 	});
				}
			}
		});
		
		$("#onlineScanningFileImport").click(function(){
			var button = $("#onlineScanningFileImport");
			var buttonText = $(button).html();
			var fileObj = $("#bulkScanningFile")[0].files[0];
			var bulkScanningImportType = $("#bulkScanningImportType").val();
			var bulkScanningTemplateId = $("#bulkScanningTemplateId").val();
			var bulkScanningFileDelimiter = $("#bulkScanningFileDelimiter").val();
			
			var blackList = "N";
			if($("#blackList").prop("checked"))
				blackList = "Y";
			
			var rejectList = "N";
			if($("#rejectList").prop("checked"))
				rejectList = "Y";
			
			var customerDatabase = "N";
			if($("#customerDatabase").prop("checked"))
				customerDatabase = "Y";
			
			var employeeDatabase = "N";
			if($("#employeeDatabase").prop("checked"))
				employeeDatabase = "Y";

			var selectedBlackList = "N";
			if($("#selectedBlackList").prop("checked"))
				selectedBlackList = "Y";
			
			if(blackList == "N" && rejectList == "N" && customerDatabase == "N" && employeeDatabase == "N" && selectedBlackList == "N")
				alert("Select a list list from Checklist Form");
			else{
				if(fileObj == undefined){
					alert("Select a file")
				}else if(bulkScanningImportType == ""){
					alert("Select a Import Type");
				}else if(bulkScanningFileDelimiter == ""){
					alert("Select Delimiter")
				}else{
					$(button).attr("disabled", true);
					var form = new FormData(); 
					form.append("file", fileObj);
					form.append("templateid", bulkScanningTemplateId);
					form.append("reportid", bulkScanningImportType);
					form.append("delimiter", bulkScanningFileDelimiter);
					form.append("BlackListCheck", blackList);
					form.append("CustomerDataBaseCheck", rejectList);
					form.append("RejectedListCheck", customerDatabase);
					form.append("EmployeeDataBaseCheck", employeeDatabase);
					form.append("SelectedBlackListCheck", selectedBlackList);
					
					var jqXHR=$.ajax({
				    	xhr: function() {
				    		var xhrobj = $.ajaxSettings.xhr();
				    		if (xhrobj.upload) {
				    			xhrobj.upload.addEventListener('progress', function(event) {
				            		var percent = 0;
				                    var position = event.loaded || event.position;
				                    var total = event.total;
				                    if (event.lengthComputable) {
				                    	percent = Math.ceil(position / total * 100);
				                    }
				                    if(percent < 100){
				                    	$(button).html("Importing : "+percent+"%");
				                    }else{
				                    	$(button).html(buttonText);
				                    }
				    			}, false);
				    		}
				        return xhrobj;
				    	},
				        url: "${pageContext.request.contextPath}/common/onlineScanningFileImportNew",
				        type: "POST",
				        contentType:false,
				        processData: false,
				        enctype : "multipart/form-data",
				        cache: false,
				        data: form,
				        success: function(data){
				        	$(button).html(buttonText);
				        	$(button).removeAttr("disabled");
				        	//alert(data);
				        },
				        error : function(a,b,c){
				        	alert(a.status+" "+b+" "+c);
				        }
				    }); 
				}
			}
		});
		
		$("#onlineScanningViewMatch").click(function(){
			$("#compassRTScanningModal").modal("show");
			$("#compassRTScanningModal-title").html("Real Time File Scanning");
			$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			
			$("#openRTModalInWindow").attr("url-attr", "/common/showViewMatchForm");
			$("#openRTModalInWindow").attr("data-attr", "");
			
			$.ajax({
		 		url : '${pageContext.request.contextPath}/common/showViewMatchForm',
		 		cache : true,
		 		type : 'POST',
		 		success : function(resData){
		 			$("#compassRTScanningModal-body").html(resData);
		 		}
		 	});
		});
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary" id="realTimeScanningSearchWith${UNQID}">
			<div class="card-header panelSlidingRealTimeScanning${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Checklist Form</h6>
			</div>
			<div class="panelSearchForm">
				<table class="table table-bordered table-striped" style="text-align: center; margin-bottom: 0px;">
					<tr>
						<td width="20%">
							<label for="blackList">
								<input checked="checked" type="checkbox" id="blackList" style="vertical-align: middle; position: relative; bottom: 2px">
								Black List
							</label>
						</td>
						<td width="20%">
							<label for="selectedBlackList">
								<input checked="checked" type="checkbox" id="selectedBlackList" style="vertical-align: middle; position: relative; bottom: 2px">
								Selected Black List
							</label>
						</td>
						<td width="20%">
							<input checked="checked" type="checkbox" id="rejectList" style="vertical-align: middle; position: relative; bottom: 2px">
							<label for="rejectList">Reject List</label>
						</td>
						<td width="20%">
							<input checked="checked" type="checkbox" id="customerDatabase" style="vertical-align: middle; position: relative; bottom: 2px">
							<label for="customerDatabase">Customer Database</label>
						</td>
						<td width="20%">
							<input disabled="disabled" type="checkbox" id="employeeDatabase" style="vertical-align: middle; position: relative; bottom: 2px">
							<label for="employeeDatabase">Employee Database</label>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="card card-primary" id="realTimeScanningFileAttachPanel${UNQID}">
			<div class="card-header panelSlidingRealTimeScanning${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Bulk Screening</h6>
			</div>
			<div class="panelSearchForm">
				<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Select File</td>
						<td width="30%">
							<input type="file" class="form-control input-sm" id="bulkScanningFile">
						</td>
						<td width="10%"></td>
						<td width="15%">Import Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="bulkScanningImportType">
								<option value="">Select One</option>
								<option value="48">WHITE LIST</option>
								<option value="199">NON CUSTOMER</option>
							</select>
						</td>
					</tr>
					<tr>
						<td width="15%">Template Id</td>
						<td width="30%">
							<select class="form-control input-sm" id="bulkScanningTemplateId">
								<option value="">Select One</option>
							</select>
						</td>
						<td width="10%"></td>
						<td width="15%">File Delimiter</td>
						<td width="30%">
							<select class="form-control input-sm" id="bulkScanningFileDelimiter">
								<option value="">Select One</option>
								<option value="~">~</option>
								<option value=";">;</option>
								<option value="|">|</option>
							</select>
						</td>
					</tr>
					<tr>
						<td colspan="5" style="text-align: center;">
							<button class="btn btn-success btn-sm" id="onlineScanningFileImport">Import</button>
							<button class="btn btn-primary btn-sm" id="onlineScanningViewMatch">View Match</button>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<div class="card card-primary" id="realTimeScanningFileAttachPanel${UNQID}">
			<div class="card-header panelSlidingRealTimeScanning${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">DataEntry Form</h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Name 1</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanName1" >
						</td>
						<td width="10%"></td>
						<td width="15%">Name 2</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanName2">
						</td>
					</tr>
					<tr>
						<td width="15%">Name 3</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanName3">
						</td>
						<td width="10%"></td>
						<td width="15%">Name 4</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanName4">
						</td>
					</tr>
					<tr>
						<td width="15%">Name 5</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanName5">
						</td>
						<td width="10%"></td>
						<td width="15%">Date of Birth</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanDOB">
						</td>
					</tr>
					<tr>
						<td width="15%">Passport No</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanPassportNo">
						</td>
						<td width="10%"></td>
						<td width="15%">Pan No</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanPanNo">
						</td>
					</tr>
					<tr>
						<td width="15%">Account No</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanAccountNo">
						</td>
						<td width="10%"></td>
						<td width="15%">Customer Id</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="scanCustomerId">
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div style="text-align: center;">
						<input type="button" class="btn btn-success btn-sm" id="scanDetails" value="Scan">
						<input type="reset" class="btn btn-danger btn-sm" id="clearDetails" value="Clear">
					</div>
				</div>
				</form>
			</div>
		</div>
	</div>
</div>