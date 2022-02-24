<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'suspicionTransactionDetailsTable';
		compassDatatable.construct(tableClass, "Suspicion Transaction Details", false);
		compassTopFrame.init(id, tableClass, 'dd/mm/yy');
		
	$("#addTransactionsToRS").click(function(){
		$("#compassCaseWorkFlowGenericModal").modal("show");
		$("#compassCaseWorkFlowGenericModal-title").html("Add Suspicious Transaction");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/findSuspiciousTransaction?alertCode="+id,
			cache:	false,
			type: "POST",
			success: function(response){
				$("#compassCaseWorkFlowGenericModal-body").html(response);
			} 
		});
	});
	
	$("#reportingOn").on("change", function(){
		if($(this).val() == "non-customer"){
			$("#nonCustomerFields").css("display", "table-row");
			$("#customerFields").css("display", "none");
		}
		else{
			$("#nonCustomerFields").css("display", "none");
			$("#customerFields").css("display", "table-row");
		}
	});
	
	$("#repeatSAR").on("change", function(){
		//alert($(this).val());
		if($(this).val() == "YES"){
			$("#repeatSARRemarksField").css("display", "table-row");
		}
		else{
			$("#repeatSARRemarksField").css("display", "none");
			$("#repeatSARRemarks").val('');
		}
	});
	
	$("#submitRaiseSuspicionForm"+id).click(function(){
		var reportingOn = $("#reportingOn").val();
		var branchCode = $("#branchCode").val();
		var accountOrPersonName = $("#accountOrPersonName").val();
		var alertRating = $("#alertRating").val();
		var accountNo = $("#accountNo").val();
		var customerId = $("#customerId").val();
		var address1 = $("#address1").val(); 
		var address2 = $("#address2").val();	
		var typeOfSuspicion = $("#typeOfSuspicion").val();
		var reasonForSuspicion = $("#reasonForSuspicion").val();
		var referenceCaseNo = $("#referenceCaseNo").val();
		var referenceCaseDate = $("#referenceCaseDate").val();
		var repeatSAR = $("#repeatSAR").val();
		var repeatSARRemarks = $("#repeatSARRemarks").val();
		var sourceOfInternalSAR = $("#sourceOfInternalSAR").val();
		
	    if(!checkDate(referenceCaseDate)){
			  return false;
	    }	
	    
	    /* if(repeatSARRemarks != null || repeatSARRemarks != ""){
	    	if(repeatSAR == "" || repeatSAR == null){
	    	alert(repeatSAR);
	    	alert(repeatSARRemarks);
	    	alert("Please select an option in Repeat SAR.");
	    	}
	    	return false;
	    }else{
	    	return true;
	    } */
	    
	    if(!checkRepeatSARRemarks(repeatSAR, repeatSARRemarks)){
	    	return false;
	    }
	    
	    /*
	    if(!checkRepeatSAR(repeatSAR, repeatSARRemarks)){
	    	return false;
	    }
	     */
	     
		if(reportingOn == 'customer'){
			var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
						   "&alertRating="+alertRating+"&accountNo="+accountNo+"&customerId="+customerId+"&typeOfSuspicion="+typeOfSuspicion+
						   "&reasonForSuspicion="+reasonForSuspicion+"&referenceCaseNo="+referenceCaseNo+"&referenceCaseDate="+referenceCaseDate+
						   "&repeatSAR="+repeatSAR+"&repeatSARRemarks="+repeatSARRemarks+"&sourceOfInternalSAR="+sourceOfInternalSAR;
				if(reportingOn != "" && branchCode != "" && alertRating != "" && accountNo != "" && typeOfSuspicion != "" && 
					reasonForSuspicion != "" && sourceOfInternalSAR != ""){
	
					alert(fullData);
					$.ajax({
						url: "${pageContext.request.contextPath}/common/submitReportOfSuspicion?alertNo="+id,
						data : fullData,
				    	cache:	false,
						type: "POST",
						success: function(response){
							alert(response);
							$("#clearRaiseSuspicionForm"+id).click();
						}, 
						error: function(a,b,c){
							alert(a+b+c);
						}				
					});
				}
				else{
					alert("Please fill the form before submitting.");
				}
			}
		else if(reportingOn == 'non-customer'){
			var fullData = "reportingOn="+reportingOn+"&branchCode="+branchCode+"&accountOrPersonName="+accountOrPersonName+
			   			   "&alertRating="+alertRating+"&address1="+address1+"&address2="+address2+"&typeOfSuspicion="+typeOfSuspicion+ 
			   			   "&reasonForSuspicion="+reasonForSuspicion+"&referenceCaseNo="+referenceCaseNo+"&referenceCaseDate="+referenceCaseDate+
			   			   "&repeatSAR="+repeatSAR+"&repeatSARRemarks="+repeatSARRemarks+"&sourceOfInternalSAR="+sourceOfInternalSAR;
				if(reportingOn != "" && branchCode != "" && accountOrPersonName != "" && alertRating != "" &&
					address1 != "" && address2 != "" && typeOfSuspicion != "" && reasonForSuspicion != "" && sourceOfInternalSAR != ""){
					alert(fullData);
					$.ajax({
						url: "${pageContext.request.contextPath}/common/submitReportOfSuspicion?alertNo="+id,
						data : fullData,
				    	cache:	false,
						type: "POST",
						success: function(response){
							alert(response);
							$("#clearRaiseSuspicionForm"+id).click();
						}, 
						error: function(a,b,c){
							alert(a+b+c);
						}				
					});
				}
				else{
					alert("Please fill the form before submitting.");
				}
			}
	});
	
	$("#attachViewEvidence"+id).click(function(){
		compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}","5678","0","Y","Y",id);
	});
	
	$(".compassrow"+id).find("select").select2();
});


function checkDate(dateToCheck){
	if(dateToCheck == '' || dateToCheck == 'null'){
	   alert('Please enter the reference case date.');
	   return false;
	}
	var datePatArr = dateToCheck.split("/");
	if(datePatArr.length == 3){
		var dd = datePatArr[0];
		var mm = datePatArr[1];
		var yy = datePatArr[2];
		if(dd.length == 2 && mm.length == 2 && yy.length == 4 && mm <= 12){
			var date1 = new Date(yy, parseInt(mm-1), dd); //Date((parseInt(mm)+1-1)+"/"+dd+"/"+yy);				
			var dateObj = new Date();
			var date2 = new Date(parseInt(dateObj.getMonth()+1)+"/"+dateObj.getDate()+"/"+dateObj.getFullYear());
			var diffDays = ((date2.getTime() - date1.getTime()));
			if(diffDays >= 0){
				return true;
			}else{
				alert("Date should be less than sysdate.");
				return false;					
			}
		}else{
			alert("Date format is wrong.");
			return false;
		}
	}else{
		alert("Date format is wrong.");
		return false;
	}
}

 function checkRepeatSARRemarks(isRepeat, repeatRemarks){
	if(isRepeat == "YES" && (repeatRemarks == null || repeatRemarks == "")){
		alert("Please input the remarks for Repeat SAR.");
		return false;
	}else{
		return true;
	}
} 

/* function checkRepeatSAR(isRepeat,repeatSARRemarks){
	//alert("isRepeat = '"+isRepeat+"'");
	if(repeatSARRemarks != "" || repeatSARRemarks != null){
		alert("Please select an option for Repeat SAR.");
		return false;
		if(isRepeat == ""){
			
		}
		return false;
	}else{
		return true;
	}
} */

</script>
<style type="text/css">
	fieldset.suspicion{
	border: 1px groove #ddd !important;
    padding: -5px 10px 5px 10px!important;
    margin: 5px 0 0 0 !important;
    -webkit-box-shadow:  0px 0px 0px 0px #000;
            box-shadow:  0px 0px 0px 0px #000;
	}
	legend.suspicion {
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
		<div class="card card-primary panel_raiseSuspicion">
			<div class="card-header panelRaiseSuspicionDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Report A Suspicion</h6>
			</div>
			<form id="reportSuspicionForm" >
			<div class="panelSearchForm subjectMatterOfSuspicion" style="padding: 0px 5px 5px 5px;">
			<fieldset class="suspicion">
					<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Subject Matter of Suspicion</legend>
						<table class="table table-striped subjectOfSuspicionTable" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="15%">Reporting On</td>
								<td width="30%">
									<select class="form-control " id="reportingOn" name="reportingOn">
										<option value="customer">Customer</option>
										<option value="non-customer">Non-Customer</option>
									</select>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Branch Code</td>
								<td width="30%">
									<select class="form-control " id="branchCode" name="branchCode">
										<c:forEach var="NAMEVALUE" items="${BRANCHCODES}">
											<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td width="15%">Name of Account/Person
									<!-- <span style="color: red;">*</span> -->
								</td>
								<td width="30%"><input type="text" class="form-control input-sm" id="accountOrPersonName" name="accountOrPersonName"/></td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Alert Rating</td>
								<td width="30%">
									<select class="form-control input-sm" name="alertRating" id="alertRating">
										<option value="1">Low</option>
										<option value="2">Medium</option>
										<option value="3">High</option>
									</select> 
								</td>
							</tr>
							<tr id = "customerFields">
								<td width="15%">Account No
									<span style="color: red;">*</span>
								</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="accountNo" name="accountNo"/>
										<span class="input-group-addon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('accountNo','ACCOUNTNO','VW_ACCOUNTNO_SEARCH','Y','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Customer Id</td>
								<td width="30%">
									<div class="input-group" style="z-index: 1">
										<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="customerId" name="customerId"/>
										<span class="input-group-addon" id="basic-addon" 
											onclick="compassTopFrame.moduleSearch('customerId','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
											<i class="fa fa-search"></i>
										</span>
									</div>	
								</td>
							</tr>
							<tr id = "nonCustomerFields" style="display: none; background-color: #f9f9f9;">
								<td width="15%">Address 1
									<span style="color: red;">*</span>
								</td>
								<td width="30%">
									<textarea  class="form-control input-sm" aria-describedby="basic-addon" id="address1" name="address1"></textarea>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Address 2</td>
								<td width="30%">
									<textarea  class="form-control input-sm" aria-describedby="basic-addon" id="address2" name="address2"></textarea>
								</td>
							</tr>
							<tr  style="background-color: white;">
								<td width="15%">Reference Case No
								</td>
								<td width="30%">
									<input type="text" class="form-control input-sm" aria-describedby="basic-addon" id="referenceCaseNo" name="referenceCaseNo"/>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Reference Case Date
								</td>
								<td width="30%">
									<input type="text" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="referenceCaseDate" name="referenceCaseDate"/>
								</td>
							</tr>
							<tr  style="background-color: #f9f9f9;">
								<td width="15%">Repeat SAR
								</td>
								<td width="30%">
									<select class="form-control " id="repeatSAR" name="repeatSAR">
										<option value="">Select an option</option>
										<option value="YES">Yes</option>
										<option value="NO">No</option>
									</select>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Source of Internal SAR
									<span style="color: red;">*</span>
								</td>
								<td width="30%">
									<textarea class="form-control input-sm " id="sourceOfInternalSAR" name="sourceOfInternalSAR"></textarea>
								</td>
							</tr>
							<tr id = "repeatSARRemarksField" style="display: none; background-color: white;">
								<td width="15%">Repeat SAR Remarks
								</td>
								<td width="30%">
									<textarea class="form-control input-sm " id="repeatSARRemarks" name="repeatSARRemarks"></textarea>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">&nbsp;</td>
								<td width="30%">&nbsp;</td>
							</tr>
						</table>
					</fieldset>
			</div>
			<div class="panelSearchForm reasonForSuspicion" style="padding: 0px 5px 5px 5px;">
			<fieldset class="suspicion">
					<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Reason For Suspicion</legend>
					
						<table class="table reasonForSuspicionTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="25%">Type of Suspicion</td>
								<td width="75%">
									<select class="form-control " id="typeOfSuspicion" name="typeOfSuspicion">
										<c:forEach var="NAMEVALUE" items="${RAISEOFSUSPICION}">
											<option value="${NAMEVALUE.key}">${NAMEVALUE.value}</option>
										</c:forEach>
									</select>
								</td>
							</tr>
							<tr>
								<td width="25%">Reason for Suspicion
									<span style="color: red;">*</span>
								</td>
								<td width="75%"><textarea class="form-control input-sm" id="reasonForSuspicion" name="reasonForSuspicion"></textarea>
								</td>
							</tr>
						</table>
				</fieldset>
			</div>
		<!-- 	
		<div class="panelSearchForm suspicionTransactionDetails" style="padding: 0px 5px 5px 5px;">
			<fieldset class="suspicion">
					<legend class="suspicion" style=" color:red; font-size: 13px; font-weight: bold;" >Suspicion Transaction Details(if any)</legend>
							<p style="margin-left: 10px; font-weight: bold;">
								<a href="javascript:void(0)" id="addTransactionsToRS">Click here to enter suspicious transaction details</a>
							</p>			
					<div id="suspiciousTransactionTable"></div>
			</fieldset>
		</div>
		 -->
		<div class="card-footer clearfix">
				<div class="pull-right">
				<input type="button" class="btn btn-primary btn-sm" id="submitRaiseSuspicionForm${UNQID}" name="Submit" value="Submit"/>
				<input type="button" class="btn btn-success btn-sm" id="attachViewEvidence${UNQID}" name="Attach/View Evidence" value="Attach/View Evidence"/>
				<input type="reset" class="btn btn-danger btn-sm" id="clearRaiseSuspicionForm${UNQID}" name="Clear" value="Clear"/>
				</div>
		</div>
	</form>
	</div>
</div>
</div>	