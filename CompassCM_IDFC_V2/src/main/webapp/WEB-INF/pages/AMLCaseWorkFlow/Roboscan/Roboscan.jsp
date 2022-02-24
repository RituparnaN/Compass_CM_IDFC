<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>Roboscan</title>
<jsp:include page="../../tags/staticFiles.jsp"/>
<%-- <jsp:include page="../../common/template/template.jsp"/> --%>

<%-- <script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/metisMenu.min.js"></script>
 --%>
 
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
	
<script type="text/javascript">
	
	$(document).ready(function(){
		var id = '${UNQID}';
		var roboscanCaseNo = '${CaseNos}';
		//var screeningReferenceNo = '${SECTION3RTSCAN[RTSCAN_SCREENINGREFERENCENO]}';
			
		var transactionDetailsTableClass = 'transactionDetails${UNQID}';
		var alertDetailsTableClass = 'alertDetails${UNQID}';
		var customerCaseHistoryTableClass = 'customerCaseHistory${UNQID}';
		
		compassDatatable.construct(transactionDetailsTableClass, "Tansaction Details", true);
		compassDatatable.construct(alertDetailsTableClass, "Alert Details", true);
		compassDatatable.construct(customerCaseHistoryTableClass, "Customer Case History Details", true);
		
		function openAlertTransactions(elm){
		var alertNo = $(elm).parent("tr").children("td:nth-child(2)").html();
		$("#compassGenericModal").modal("show");
		$("#compassGenericModal-title").html("Linked Transactions");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getLinkedTransactionsForAlerts",
			cache: false,
			type: "POST",
			data: "alertNo="+alertNo,
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
		}

		$(".datepicker").datepicker({
		 	dateFormat : "dd/mm/yy",
		 	changeMonth: true,
	     	changeYear: true
		 });
		 
		 //for changing size of text box ....
	  	$(".custom_textbox").each(function(){
		    var value = $(this).val();
		    var size  = value.length+3;
		    $(this).attr('size',size);
		}); 
		
		/* $(".custom_textbox").load(function(){
			    var value = $(this).val();
			    var size  = value.length;
			  
			    $(this).attr('size',size);
		}); */
		  
		 //for collapse and collapse-in for all div together 
		 $("#collapseAll").click(function(){
			 
			 if($(this).attr("rel") == "collapse-in")
			 {
				 $(".collapsible").removeClass('fa-chevron-down');
				 $(".collapsible").addClass('fa-chevron-up');
				 $(this).attr("rel","collapse-out");
				 $(this).html("  Expand <span class='fa fa-chevron-up'></span>");
				$(".collapsible-div").addClass("collapsed")
				 $(".collapse").removeClass('in');
				 $(".collapse").attr("aria-expanded",false);
				 
			}	
			 else if($(this).attr("rel") == "collapse-out")
		     {
				 $(".collapsible").removeClass('fa-chevron-up');
				 $(".collapsible").addClass('fa-chevron-down');
				 $(this).attr("rel","collapse-in");
				/*  $(this).find( "span" ).removeClass('fa-chevron-down');
				 $(this).find( "span" ).addClass('fa-chevron-up'); */
				 $(this).html("Collapse <span class='fa fa-chevron-down'></span>");
				 
				 $(".collapsible-div").removeClass("collapsed")
				$(".collapse").addClass("in");
				$(".collapse").attr("aria-expanded",true);
				
			}
		 });
		 
		 //for changing icon when collapse div 
		 $(".section-heading").click(function(){
			 
			 if($(this).find( "i" ).hasClass( "fa-chevron-up" ))
			{
				 $(this).find( "i" ).removeClass('fa-chevron-up');
				 $(this).find( "i" ).addClass('fa-chevron-down'); 
			}
			else{
				$(this).find( "i" ).removeClass('fa-chevron-down');
				$(this).find( "i" ).addClass('fa-chevron-up'); 
			}
		});
		 
		 $("#realTimeScanDetails"+id).click(function(){
			var scanName1 = $("#RTSCAN_NAME"+id).val();
			var scanName2 = $("#RTSCAN_OTHERNAMES"+id).val();
			var scanName3 = $("#RTSCAN_TAXID"+id).val();
			var scanName4 = $("#RTSCAN_NATIONALID"+id).val();
			var scanName5 = $("#RTSCAN_VOTERID"+id).val();
			var scanDOB = $("#RTSCAN_DOB"+id).val();
			var scanPassportNo = $("#RTSCAN_PASSPORTNO"+id).val();
			var scanPanNo = $("#RTSCAN_PANNO"+id).val();
			var scanAccountNo = $("#RTSCAN_ACCOUNTNO"+id).val();
			var scanCustomerId = $("#RTSCAN_CUSTOMERID"+id).val();
			/* var blackList = "N";
			if($("#blackList").prop("checked")) */
				blackList = "Y";
			
			/* var rejectList = "N";
			if($("#rejectList").prop("checked")) */
				rejectList = "Y";
			
			/* var customerDatabase = "N";
			if($("#customerDatabase").prop("checked")) */
				customerDatabase = "Y";
			//alert(roboscanCaseNo);
			var employeeDatabase = "N";
			/* if($("#employeeDatabase").prop("checked"))
				employeeDatabase = "Y"; */
			
			/* if(blackList == "N" && rejectList == "N" && customerDatabase == "N" && employeeDatabase == "N")
				alert("Select a list list from Checklist Form");
			else{ */
				if(scanName1 == "" && scanName2 == "" && scanName3 == "" && scanName4 == "" && scanName5 == "" && 
						scanDOB == "" && scanPassportNo == "" && scanPanNo == "" && scanAccountNo == "" && scanCustomerId == ""){
					alert("Enter details at least one field ")
				}else{
					var fullData = "NAME1="+scanName1+"&NAME2="+scanName2+"&NAME3="+scanName3+"&NAME4="+scanName4+"&NAME5="+scanName5+"&DATEOFBIRTH="+scanDOB+
					   //"&PASSPORTNO="+scanPassportNo+"&PANNO="+scanPanNo+"&ACCOUNTNO="+scanAccountNo+"&CUSTOMERID="+scanCustomerId+"&userCode=NA&BlackListCheck="+blackList+
					   "&PASSPORTNO="+scanPassportNo+"&PANNO="+scanPanNo+"&ACCOUNTNO="+scanAccountNo+"&CUSTOMERID="+scanCustomerId+"&userCode=NA&BlackListCheck="+blackList+"&SelectedBlackListCheck=Y"+
					   "&CustomerDataBaseCheck="+customerDatabase+"&RejectedListCheck="+rejectList+"&EmployeeDataBaseCheck="+employeeDatabase+"&ROBOSCANCASENO="+roboscanCaseNo;
						
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
			/* } */
		}); 
		 
		 $("#pointOnMapScanDetails"+id).click(function(){
			 	var scanName1 = $("#RTSCAN_NAME"+id).val();
				var scanName2 = $("#RTSCAN_OTHERNAMES"+id).val();
				var scanName3 = $("#RTSCAN_TAXID"+id).val();
				var scanName4 = $("#RTSCAN_NATIONALID"+id).val();
				var scanName5 = $("#RTSCAN_VOTERID"+id).val();
				var scanDOB = $("#RTSCAN_DOB"+id).val();
				var scanPassportNo = $("#RTSCAN_PASSPORTNO"+id).val();
				var scanPanNo = $("#RTSCAN_PANNO"+id).val();
				var scanAccountNo = $("#RTSCAN_ACCOUNTNO"+id).val();
				var scanCustomerId = $("#RTSCAN_CUSTOMERID"+id).val();
				var scanAddress = $("#RTSCAN_ADDRESS"+id).val();
				
				if(scanName1 == "" && scanAddress != "")
					scanName1 = scanAddress;	
				
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
				
				/*if(blackList == "N" && rejectList == "N" && customerDatabase == "N" && employeeDatabase == "N")
					alert("Select a list list from Checklist Form");
				else{*/
					if(scanName1 == "" && scanName2 == "" && scanName3 == "" && scanName4 == "" && scanName5 == "" && 
							scanDOB == "" && scanPassportNo == "" && scanPanNo == "" && scanAccountNo == "" && scanCustomerId == ""){
						alert("Enter details at least one field ")
					}else{
						var fullData = "NAME1="+scanName1+"&NAME2="+scanName2+"&NAME3="+scanName3+"&NAME4="+scanName4+"&NAME5="+scanName5+"&DATEOFBIRTH="+scanDOB+
						   "&PASSPORTNO="+scanPassportNo+"&PANNO="+scanPanNo+"&ACCOUNTNO="+scanAccountNo+"&CUSTOMERID="+scanCustomerId+"&ADDRESS="+scanAddress+"&userCode=NA&BlackListCheck="+blackList+
						   "&CustomerDataBaseCheck="+customerDatabase+"&RejectedListCheck="+rejectList+"&EmployeeDataBaseCheck="+employeeDatabase;
						//alert(fullData);
						window.open('${pageContext.request.contextPath}/common/pointOnMapScanDetails?'+fullData);
						
						/*$("#compassRTScanningModal").modal("show");
						$("#compassRTScanningModal-title").html("Real Time Scanning");
						$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
						
						$("#openRTModalInWindow").attr("url-attr", "/common/pointOnMapScanDetails");
						$("#openRTModalInWindow").attr("data-attr", fullData);
						
						$.ajax({
					 		url : '${pageContext.request.contextPath}/common/pointOnMapScanDetails',
					 		cache : true,
					 		type : 'GET',
					 		data : fullData,
					 		success : function(resData){
					 			$("#compassRTScanningModal-body").html(resData);
					 		}
					 	});*/
					}
				/* } */
			}); 
		 
		 $("#roboscanViewMatch"+id).click(function(){
			 getScanningDetails(roboscanCaseNo, function() {
					screeningReferenceNo = document.roboScan.screeningReferenceNo.value;
					scannedViewMatches(screeningReferenceNo);
				});
		 });
		 
		$("#searchEntityLink"+id).click(function(){
			var fromDate = $("#LINK_FROMDATE"+id).val();
			var toDate = $("#LINK_TODATE"+id).val();
			var accountNo = $("#LINK_ACCOUNTNO"+id).val();
			var levelCount = $("#LINK_LEVELCOUNT"+id).val();
			var transactionLink = "";
			if($("#LINK_TRANSACTION_LINK"+id).prop("checked")){
				transactionLink = $("#LINK_TRANSACTION_LINK"+id).val();
			}
			var staticLink = "";
			if($("#LINK_STATIC_LINK"+id).prop("checked")){
				staticLink = $("#LINK_STATIC_LINK"+id).val();
			}
			if(fromDate!= null && toDate != null && accountNo != null && levelCount != null ){
				var fullData = "fromDate="+fromDate+"&toDate="+toDate+"&accountNo="+accountNo+"&levelCount="+levelCount+"&transactionLink="+transactionLink+"&staticLink="+staticLink;
				//alert(fromDate+", "+toDate+", "+accountNo+", "+levelCount+", "+transactionLink+", "+staticLink);

				$("#compassGenericModal").modal("show");
				$("#compassGenericModal-title").html("Entity Link Tracer Result");
				$("#compassGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			
				$("#openRTModalInWindow").attr("url-attr", "/amlCaseWorkFlow/getEntityLinkedDetails");
				$("#openRTModalInWindow").attr("data-attr", fullData);
				
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/getEntityLinkedDetails",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res) {
						$("#compassGenericModal-body").html(res);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}else{
				alert("Enter account number, from date, to date and level count.");
			}
		}); 
		
		$("#searchEntityLinkHorizontalGraph"+id).click(function(){
			var fromDate = $("#LINK_FROMDATE"+id).val();
			var toDate = $("#LINK_TODATE"+id).val();
			var accountNo = $("#LINK_ACCOUNTNO"+id).val();
			var levelCount = $("#LINK_LEVELCOUNT"+id).val();
			var transactionLink = "";
			if($("#LINK_TRANSACTION_LINK"+id).prop("checked")){
				transactionLink = $("#LINK_TRANSACTION_LINK"+id).val();
			}
			var staticLink = "";
			if($("#LINK_STATIC_LINK"+id).prop("checked")){
				staticLink = $("#LINK_STATIC_LINK"+id).val();
			}
			if(fromDate!= null && toDate != null && accountNo != null && levelCount != null ){
				var fullData = "fromDate="+fromDate+"&toDate="+toDate+"&accountNo="+accountNo+"&levelCount="+levelCount+"&transactionLink="+transactionLink+"&staticLink="+staticLink;
				//alert(fromDate+", "+toDate+", "+accountNo+", "+levelCount+", "+transactionLink+", "+staticLink);

				$("#compassGenericModal").modal("show");
				$("#compassGenericModal-title").html("Entity Link Horizontal Graph View");
				$("#compassGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/getEntityLinkedHorizontalGraph",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res) {
						$("#compassGenericModal-body").html(res);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}else{
				alert("Enter account number, from date, to date and level count.");
			}
		}); 
		
		$("#searchEntityLinkVerticalGraph"+id).click(function(){
			var fromDate = $("#LINK_FROMDATE"+id).val();
			var toDate = $("#LINK_TODATE"+id).val();
			var accountNo = $("#LINK_ACCOUNTNO"+id).val();
			var levelCount = $("#LINK_LEVELCOUNT"+id).val();
			var transactionLink = "";
			if($("#LINK_TRANSACTION_LINK"+id).prop("checked")){
				transactionLink = $("#LINK_TRANSACTION_LINK"+id).val();
			}
			var staticLink = "";
			if($("#LINK_STATIC_LINK"+id).prop("checked")){
				staticLink = $("#LINK_STATIC_LINK"+id).val();
			}
			if(fromDate!= null && toDate != null && accountNo != null && levelCount != null ){
				var fullData = "fromDate="+fromDate+"&toDate="+toDate+"&accountNo="+accountNo+"&levelCount="+levelCount+"&transactionLink="+transactionLink+"&staticLink="+staticLink;
				//alert(fromDate+", "+toDate+", "+accountNo+", "+levelCount+", "+transactionLink+", "+staticLink);

				$("#compassGenericModal").modal("show");
				$("#compassGenericModal-title").html("Entity Link Vertical Graph View");
				$("#compassGenericModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/getEntityLinkedVerticalGraph",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res) {
						$("#compassGenericModal-body").html(res);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}else{
				alert("Enter account number, from date, to date and level count.");
			}
		});
		
		$("#emailExchange"+id).click(function(){
			var caseNo = '${CaseNos}';
			if(caseNo == ""){
				alert("Select a record");
			}else{
				compassEmailExchange.openEmail('${pageContext.request.contextPath}', caseNo, '', 'INBOX');
			}
		});
		
		function getScanningDetails(roboscanCaseNo, callback) {
			$.ajax({
				url: "${pageContext.request.contextPath}/amlCaseWorkFlow/getRoboscanScreeningDetails",
				cache: false,
				type: "GET",
				data: "roboscanCaseNo="+roboscanCaseNo,
				success: function(res) {
					document.roboScan.screeningReferenceNo.value = res['RTSCAN_SCREENINGREFERENCENO'];
				},
				complete: function(){
					callback();
				},
				error: function(a,b,c) {
					console.log();
				}
			});
			//alert("bellow alert");
		}
		
		 
		 function scannedViewMatches(screeningReferenceNo){
			$("#compassRTScanningModal").modal("show");
			$("#compassRTScanningModal-title").html("Real Time Scanning");
			$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			//alert(document.roboScan.screeningReferenceNo.value);
			
			var fullData = "counter=0&filename="+screeningReferenceNo+"&FileImport=N&UserCode=ALL&RecordStatus=ALL&ScanningFromDate=&ScanningToDate=&ProcessingFromDate=&ProcessingToDate=";
			$("#openRTModalInWindow").attr("url-attr", "/common/fileMatches");
			$("#openRTModalInWindow").attr("data-attr", fullData);
			$.ajax({
		 		url : '${pageContext.request.contextPath}/common/fileMatches',
		 		cache : true,
		 		type : 'POST',
		 		data : fullData,
		 		success : function(resData){
		 			$("#compassRTScanningModal-body").html(resData);
		 		}
		 	});
		} 
		 
		 $("#sendAsEmail"+id).click(function(){
			var caseNo = '${CaseNos}';
				compassEmailExchange.openEmail('${pageContext.request.contextPath}', caseNo, '', 'INBOX');
		 });
		 
		 $("#closeForm"+id).click(function(){
			 window.close();
		 });
	});	
	
	/* function printRoboscan(divName){
		var domClone = document.getElementById(divName).cloneNode(true);
	
		var $printSection = document.createElement("div");
	    $printSection.id = "roboscanForm";
	    document.body.appendChild($printSection);
	    $printSection.appendChild(domClone);
		window.print();
		w.close();
	 } */
	
</script>

<style>
	
.datepicker{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	
.section-heading{
   background: #337ab7;
   padding:5px;
   cursor: pointer;
   border-radius: 5px 5px 0 0;
}

.collapse{
	border:1px solid #337ab7;
}

.section-heading h4,p{
color:white;
padding-left:5px;
}

.collapse-icon{
	padding-top:10px;
	padding-right:5px;
	color: white;
}
		
#topheader {
	/* background-color: #e5e6e5;
	border: 1px solid black; */
}

.custom_p p{
	line-height: 2.3;
	color:black;
}

.no-border th,.no-border td{
	 border-top: none !important; 
}

.withOutLineTable th, .withOutLineTable td {
	 border-top: none !important; 
}

 .withOutLineTable tr th:first-child, .withOutLineTable tr td:first-child {
	width:15%;
}

.withOutLineTable tr th:nth-child(3), .withOutLineTable tr td:nth-child(3){
	padding-left:30px;
	width:15%;
}

.inner-border tr td:last-child, tr th:last-child {
	border-right: none !important;
}

 textarea {
    resize: vertical;
} 
/* textarea {
    max-width: 100px; 
    max-height: 100px;
} */

/* .inner-border tr td:first-child, tr th:first-child
	 {
	text-align: left;
} */

.inner-border td, th {
	text-align: left;
	color: black;
	border-top: none !important;
	border-right: 1px solid #909090;
} 

.horizontalLine{
	height: 1px; 
	border: none;
	background-color: #C0C0C0;
	color: #C0C0C0;
	margin-top: 8px; 
	margin-bottom: 8px;
}

.divBorder{
	border:1px solid #337ab7;
	border-radius: 5px 5px 0 0;
}	

/* .nonSelectedPart{
	display: none;
}

.selectedPart{
	display: block;
} */

.sectionStyle{
	margin-top: 20px;
}

readonly{
	cursor: not-drop;
}
.custom_textbox{
	padding-left: 5px;
	padding-right: 5px;
}

#roboScan{
	display: flex; 
	flex-direction: column;
	align-items: center;
}

body {
    font-family: "Helvetica Neue", Helvetica, Arial, sans-serif;
    line-height: 1.42857143;
    color: #333;
}

.sectionHeadingAlignment{
	margin-top: 2px;
    margin-bottom: -5px;
}

.collapse-icon {
    margin-top: -35px;
}
</style>
	
</head>
<body>
<div id="roboscanForm">
<form name = "roboScan" id = "roboScan" onsubmit = "return false" >
	<!-- Top Header Start -->
	<div class=" col-sm-offset-1 col-sm-10" id="topheader">		
			<table class="table" style="margin-bottom: 0;margin-top: 10px;" >
				<tr>
					<!-- <td><h3>RoboScan - Intelligent Case Summary</h3></td> -->
					<td width="95%">
						<img src="${pageContext.request.contextPath}/includes/images/roboscan_banner.jpg" style="margin-top:5px;max-width: 100% "  alt="RoboScan"> 
					</td>
					<td width="5%" style="padding-top: 50px;">
						<%-- <input type="image" src="${pageContext.request.contextPath}/includes/images/collapse_icon.png" style="height:60px;width:180px; margin-top:5px;background-color: white; cursor: pointer;"
										 id="collapseAll" rel="collapse-in" value="Collapse Out" alt="Collapse/Expand" > --%>
						<button type="button" class="btn btn-default btn-lg btn-block" style="width:120px; margin-top:5px;" data-toggle="collapse" data-target=".multi-collapse" aria-expanded="false" aria-controls="SECTION1 SECTION2 SECTION3 SECTION4 SECTION5 SECTION6 SECTION7 SECTION8 SECTION9 SECTION10 SECTION11 SECTION12 options" id="collapseAll" rel="collapse-in" >
          					Collapse <span class="fa fa-chevron-down collapseAllIcon"></span> 
        				</button>
						
					</td>
				</tr>
			</table>
			<!-- <div class="pull-right"><input type='button' class="btn btn-success"  value="Collapse Out" id="collapseAll" rel=collapse-in /></div> -->
	</div>
<!-- Top Header End -->
<!-- Executive Summary: start -->
<div class=" col-sm-offset-1 col-sm-10  custom_div" >
<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
		<div class = "divBorder">
			<table class="table no-border form-inline custom_p" >
				<tr>
					<td>
						<p>
							The 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_ALERTNAME${UNQID}" name="HEADER_ALERTNAME" value="${HEADER['HEADER_ALERTNAME']}" disabled="disabled"/> 
							scenario was breached for 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_CUSTOMER_NAME${UNQID}" name="HEADER_CUSTOMER_NAME" value="${HEADER['HEADER_CUSTOMER_NAME']}" disabled="disabled"/>. 
							The account number on which the alert breached is 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_ACCOUNTNO${UNQID}" name="HEADER_ACCOUNTNO" value="${HEADER['HEADER_ACCOUNTNO']}" disabled="disabled"/>. 
							A total of 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_ALERTSCOUNT${UNQID}" name="HEADER_ALERTSCOUNT" value="${HEADER['HEADER_ALERTSCOUNT']}" disabled="disabled"/> 
							alert(s) were involved in this breach. Total of 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_CASEALERTSCOUNT${UNQID}" name="HEADER_CASEALERTSCOUNT" value="${HEADER['HEADER_CASEALERTSCOUNT']}" disabled="disabled"/> 
							alert(s) have been combined to form this case. This customer 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_HASANYOLDCASES${UNQID}" name="HEADER_HASANYOLDCASES" value="${HEADER['HEADER_HASANYOLDCASES']}" disabled="disabled"/> 
							historical STR cases with the bank. The risk rating of the breached alert is: 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_CASE_RATING${UNQID}" name="HEADER_CASE_RATING" value="${HEADER['HEADER_CASE_RATING']}" disabled="disabled"/>.
						</p>
						<%-- <p>
							The 
								<input type="text" class="form-control input-sm custom_textbox" onKeyUp="adjustWidth(this);" id="HEADER_ALERTNAME${UNQID}" name="HEADER_ALERTNAME" value="${HEADER['HEADER_ALERTNAME']}" disabled="disabled"/> 
							alert was breached for 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_CUSTOMER_NAME${UNQID}" name="HEADER_CUSTOMER_NAME" value="${HEADER['HEADER_CUSTOMER_NAME']}" disabled="disabled"/>. 
							The account on which the alert breached is 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_ACCOUNTNO${UNQID}" name="HEADER_ACCOUNTNO" value="${HEADER['HEADER_ACCOUNTNO']}" disabled="disabled"/>. 
							A total of 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_ALERTSCOUNT${UNQID}" name="HEADER_ALERTSCOUNT" value="${HEADER['HEADER_ALERTSCOUNT']}" disabled="disabled"/> 
							were involved in this breach. Total of 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_CASEALERTSCOUNT${UNQID}" name="HEADER_CASEALERTSCOUNT" value="${HEADER['HEADER_CASEALERTSCOUNT']}" disabled="disabled"/> 
							alerts have been combined to form this case. This customer 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_HASANYOLDCASES${UNQID}" name="HEADER_HASANYOLDCASES" value="${HEADER['HEADER_HASANYOLDCASES']}" disabled="disabled"/> 
							historical STR cases with the bank. The risk rating of the breached alert is: 
								<input type="text" class="form-control input-sm custom_textbox" id="HEADER_CASE_RATING${UNQID}" name="HEADER_CASE_RATING" value="${HEADER['HEADER_CASE_RATING']}" disabled="disabled"/>.
						</p> --%>
					</td>
				</tr>
			</table>
			<hr class="horizontalLine" style="margin-left: 10px; margin-right: 10px;">
			<b style="margin-left:8px;">Executive Summary:</b>
			
			<table class="table withOutLineTable" >
				<tr>
					<td width="20%">Compass Case No</td>
					<td width="20%">
						<input type="text" class="form-control input-sm" id="HEADER_CASE_ID${UNQID}" name="HEADER_CASE_ID" value="${HEADER['HEADER_CASE_ID']}" disabled="disabled"/>
					</td>
					<td width="20%" align="right">Scenario(s) Breached</td>
					<td width="20%">
						<input type="text" class="form-control input-sm" id="HEADER_ALERTS_BREACHED${UNQID}" name="HEADER_ALERTS_BREACHED" value="${HEADER['HEADER_ALERTS_BREACHED']}" disabled="disabled"/>
					</td>
				</tr>

				<tr>
					<td>Description of Breached Scenario(s):</td>
					<td colspan="3">
						<textarea class="form-control input-sm" rows="6" id="HEADER_DESCRIPTION${UNQID}" name="HEADER_DESCRIPTION" disabled="disabled">${HEADER["HEADER_DESCRIPTION"]}</textarea>
					</td>
				</tr>
				<tr>
					<td>Is Bank Employee:</td>
					<td colspan="3" >
						<table width="100%">
							<tr>
								<td width="10%">
									<input type="radio" id="HEADER_ISBANK_EMPLOYEE${UNQID}" name="HEADER_ISBANK_EMPLOYEE"  disabled="disabled"
									<c:if test="${HEADER['HEADER_ISBANK_EMPLOYEE'] eq 'Y'}">checked="checked"</c:if>> Yes
								</td>
								<td width="10%">
									<input type="radio" id="HEADER_ISBANK_EMPLOYEE${UNQID}" name="HEADER_ISBANK_EMPLOYEE" disabled="disabled"
									<c:if test="${HEADER['HEADER_ISBANK_EMPLOYEE'] eq 'N'}">checked="checked"</c:if>> No
								</td>
								<td width="80%">
									<input type="radio" id="HEADER_ISBANK_EMPLOYEE${UNQID}" name="HEADER_ISBANK_EMPLOYEE" disabled="disabled"
									<c:if test="${HEADER['HEADER_ISBANK_EMPLOYEE'] eq 'UNKNOWN'}">checked="checked"</c:if>> Unknown
								</td>
							</tr>
						</table>
				</tr>
			</table>
	</div>
</div>
<!-- Executive Summary: End -->
	
<!-- SECTION 1 - Alert Details Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION1')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION1">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#alertDetails">
				<div class="col-sm-6 sectionHeadingAlignment">
					<h4><b>SECTION 1 - Alert Details </b></h4>
				</div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
		
		<div class="col-sm-12 collapse show in multi-collapse" id="alertDetails" style="padding-top:10px; padding-bottom:10px;">
				<table class="table table-bordered table-striped searchResultGenericTable alertDetails${UNQID}" >
					<thead>
						<tr>
							<c:forEach var="TH" items="${SECTION1ALERTDETAILS['HEADER']}">
								<c:set var="colArray" value="${f:split(TH, '.')}" />
								<c:set var="colArrayCnt" value="${f:length(colArray)}" />
								<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
							</c:forEach>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="RECORD" items="${SECTION1ALERTDETAILS['DATA']}">
							<tr>
								<c:forEach var="TD" items="${RECORD}">
									<c:choose>
										<c:when test="${TD ne ' ' and TD ne ''}">
											<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
										</c:when>
										<c:otherwise>
											<td>${TD}</td>
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</tr>
						</c:forEach>
					</tbody>
				</table>
		</div>	
	</div>
</c:if>
	
<!-- SECTION 1 - Alert Details End -->
	
<!-- SECTION 2 - Customer Details (KYC) Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION2')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION1">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#customerDetails">
				<div class="col-sm-6 sectionHeadingAlignment">
					<h4><b>SECTION 2 - Customer Details (KYC)</b></h4>
				</div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
		
		<div class="col-sm-12 collapse show in multi-collapse" id="customerDetails" style="padding-top:10px;">
				<table class="table  withOutLineTable">
					<tr>
						<td width="30%">Customer Name:</td>
						<td width="20%">
							<input type="text" class="form-control input-sm" id="KYC_CUSTOMER_NAME${UNQID}" name="KYC_CUSTOMER_NAME" value="${SECTION2KYC['KYC_CUSTOMER_NAME']}" disabled="disabled"/>
						</td>
						<td width="30%">Father's Name:</td>
						<td width="20%">
							<input type="text" class="form-control input-sm" id="KYC_FATHER_NAME${UNQID}" name="KYC_FATHER_NAME" value="${SECTION2KYC['KYC_FATHER_NAME']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Mother's Name:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_MOTHER_NAME${UNQID}" name="KYC_MOTHER_NAME" value="${SECTION2KYC['KYC_MOTHER_NAME']}" disabled="disabled"/>
						</td>
						<td>Account number:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_ACCOUNT_NO${UNQID}" name="KYC_ACCOUNT_NO" value="${SECTION2KYC['KYC_ACCOUNT_NO']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Associated Accounts: (If Any)</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_ASSOCIATED_ACC_NOS${UNQID}" name="KYC_ASSOCIATED_ACC_NOS" value="${SECTION2KYC['KYC_ASSOCIATED_ACC_NOS']}" disabled="disabled"/>
						</td>
						<td>Base Branch:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_BRANCH_NAME${UNQID}" name="KYC_BRANCH_NAME" value="${SECTION2KYC['KYC_BRANCH_NAMES']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Type of Account:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_ACCOUNT_TYPE${UNQID}" name="KYC_ACCOUNT_TYPE" value="${SECTION2KYC['KYC_ACCOUNT_TYPE']}" disabled="disabled"/>
						</td>
						<td>Risk Rating of Customer:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_CUST_RISKRATING${UNQID}" name="KYC_CUST_RISKRATING" value="${SECTION2KYC['KYC_CUST_RISKRATING']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Risk Rating of Account:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_ACC_RISKRATING${UNQID}" name="KYC_ACC_RISKRATING" value="${SECTION2KYC['KYC_ACC_RISKRATING']}" disabled="disabled"/>
						</td>
						<td>Risk Rating of related parties:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_RELPARTY_RISKRATING${UNQID}" name="KYC_RELPARTY_RISKRATING" value="${SECTION2KYC['KYC_RELPARTY_RISKRATING']}" disabled="disabled"/>
						</td>
					</tr>

					<tr>
						<td>KYC Last update date:</td>
						<td>
							<input type="text" class="form-control input-sm datepicker" id="KYC_LAST_UPDATE${UNQID}" name="KYC_LAST_UPDATE" value="${SECTION2KYC['KYC_LAST_UPDATE']}" disabled="disabled"/>
						</td>
						<td>KYC Last change date:</td>
						<td>
							<input type="text" class="form-control input-sm datepicker" id="KYC_LAST_CHANGE${UNQID}" name="KYC_LAST_CHANGE" value="${SECTION2KYC['KYC_LAST_CHANGE']}"  disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Guardian:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_GURDIAN${UNQID}" name="KYC_GURDIAN" value="${SECTION2KYC['KYC_GURDIAN']}" disabled="disabled"/>
						</td>
						<td>Nominee:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_NOMINEE${UNQID}" name="KYC_NOMINEE" value="${SECTION2KYC['KYC_NOMINEE']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Other Relationships:</td>
						<td>
							<input type="text" class="form-control input-sm" id="KYC_OTHER_RELATIONSHIP${UNQID}" name="KYC_OTHER_RELATIONSHIP" value="${SECTION2KYC['KYC_OTHER_RELATIONSHIP']}" disabled="disabled"/>
						</td>
						<td colspan="2">&nbsp;</td>
					</tr>
				</table>
		</div>	
	</div>
</c:if>

<!-- SECTION 2 - Customer Details (KYC) End -->
	
<!-- SECTION 3 - Real Time Screening Details Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION3')}">		
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION2">
<!--	<div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading"  data-toggle="collapse" data-target="#realTimeScreening">
				<div class="col-sm-6 sectionHeadingAlignment">
					<h4><b>SECTION 3 - Real-Time Screening</b></h4>
				</div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
		
		<div class="col-sm-12 collapse show in multi-collapse" id="realTimeScreening" style="padding-top:10px;">
			<table class="table withOutLineTable">
				<tr>
					<td width="30%">Last static data update date:</td>
					<td width="20%">
						<input type="text" class="form-control input-sm datepicker" id="RTSCAN_STATICDATA_UPDATEDATE${UNQID}" name="RTSCAN_STATICDATA_UPDATEDATE" value="${SECTION3RTSCAN['RTSCAN_STATICDATA_UPDATEDATE']}"/>
					</td>
					<td width="30%">Last transaction update date:</td>
					<td width="20%">
						<input type="text" class="form-control input-sm datepicker" id="RTSCAN_TXNDATA_UPDATEDATE${UNQID}" name="RTSCAN_TXNDATA_UPDATEDATE" value="${SECTION3RTSCAN['RTSCAN_TXNDATA_UPDATEDATE']}"/>
					</td>
				</tr>
			</table>
			<div >
				<div class="col-sm-6">
					<h4 style="margin-left: -7px;"><b>Real Time Screening Search Details:</b></h4>
				</div>
				<!-- <hr class="whitehr col-sm-12" size="2"> -->
				<div class="col-sm-12" style="padding-left: 8px;padding-right: 8px;">
					<hr class="horizontalLine" >
				</div>
				<table class="table withOutLineTable " width="100%">
					<tr>
						<td width="30%">Name</td>
						<td width="20%">
							<input type="text" class="form-control input-sm" id="RTSCAN_NAME${UNQID}" name="RTSCAN_NAME" value="${SECTION3RTSCAN['RTSCAN_NAME']}"/>
						</td>
						<td width="30%">Other Names</td>
						<td width="20%">
							<input type="text" class="form-control input-sm" id="RTSCAN_OTHERNAMES${UNQID}" name="RTSCAN_OTHERNAMES" value="${SECTION3RTSCAN['RTSCAN_OTHERNAMES']}"/>
						</td>
					</tr>

					<tr>
						<td>Date of Birth</td>
						<td>
							<input type="text" class="form-control input-sm datepicker" id="RTSCAN_DOB${UNQID}" name="RTSCAN_DOB" value="${SECTION3RTSCAN['RTSCAN_DOB']}"/>
						</td>
						<td>Account Number</td>
						<td>
							<input type="text" class="form-control input-sm" id="RTSCAN_ACCOUNTNO${UNQID}" name="RTSCAN_ACCOUNTNO" value="${SECTION3RTSCAN['RTSCAN_ACCOUNTNO']}"/>
						</td>
					</tr>

					<tr>
						<td>Customer ID</td>
						<td>
							<input type="text" class="form-control input-sm" id="RTSCAN_CUSTOMERID${UNQID}" name="RTSCAN_CUSTOMERID" value="${SECTION3RTSCAN['RTSCAN_CUSTOMERID']}"/>
						</td>
						<td>Passport Number</td>
						<td>
							<input type="text" class="form-control input-sm" id="RTSCAN_PASSPORTNO${UNQID}" name="RTSCAN_PASSPORTNO" value="${SECTION3RTSCAN['RTSCAN_PASSPORTNO']}"/>
						</td>
					</tr>

					<tr>
						<td>Tax ID Number</td>
						<td>
							<input type="text" class="form-control input-sm" id="RTSCAN_TAXID${UNQID}" name="RTSCAN_TAXID" value="${SECTION3RTSCAN['RTSCAN_TAXID']}"/>
						</td>
						<%-- <td>National ID Number</td>--%>
						<td>Aadhaar Number</td>
						<td>
							<input type="text" class="form-control input-sm" id="RTSCAN_NATIONALID${UNQID}" name="RTSCAN_NATIONALID" value="${SECTION3RTSCAN['RTSCAN_NATIONALID']}"/>
						</td> 
					</tr>
					<tr>
						<td>Voter ID Number</td>
						<td>
							<input type="text" class="form-control input-sm" id="RTSCAN_VOTERID${UNQID}" name="RTSCAN_VOTERID" value="${SECTION3RTSCAN['RTSCAN_VOTERID']}"/>
						</td>
						<td>PAN Number</td>
						<td>
							<input type="text" class="form-control input-sm" id="RTSCAN_PANNO${UNQID}" name="RTSCAN_PANNO" value="${SECTION3RTSCAN['RTSCAN_PANNO']}"/>
						</td> 
					</tr>
					<tr>
						<td>Address</td>
						<td colspan="3">
							<input type="text" class="form-control input-sm" id="RTSCAN_ADDRESS${UNQID}" name="RTSCAN_ADDRESS" value="${SECTION3RTSCAN['RTSCAN_ADDRESS']}"/>
					</tr>
					<tr>
						<td colspan="4" align="center">
							<button type="button" class="btn btn-sm btn-warning" id="realTimeScanDetails${UNQID}" name="realTimeScanDetails" value="Scan">Scan</button>
							<%-- <button type="button" class="btn btn-success btn-sm" id="pointOnMapScanDetails${UNQID}">Point On Map</button> --%>
							<%-- <button type="button" class="btn btn-sm btn-info" id="roboscanViewMatch${UNQID}" name="roboscanViewMatch" value="View Match">View Match</button> --%>
							<!-- <input type="hidden" name="screeningReferenceNo" value=""> -->
						</td>	
					</tr>
				</table>

				<%-- <div class="col-sm-12">
					<h4 style="margin-left: -7px;"><b>Real Time Screening Result Details:</b></h4>					
				</div>
				<div class="col-sm-12" style="padding-left: 8px;padding-right: 8px;">
					<hr class="horizontalLine">
				</div>
				<h5 style="margin-left: 7px;">Customer: ${SECTION3RTSCAN['SECTWO_FIRST_CUST_NAME']}</h5>
				<table class="table inner-border">
					<tr>
						<th >List Name</th>
						<th >List Id</th>
						<th >Match Score</th>
						<th >Matched Value</th>
						<th >Match Date</th>
					</tr>
					<tr>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_LISTNAME']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_LISTID']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_MATCHSCORE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_MATCHEDVALUE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_MATCHDATE']}</td>
					</tr>

					<tr>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_LISTNAME']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_LISTID']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_MATCHSCORE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_MATCHEDVALUE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_FIRST_MATCHDATE']}</td>
					</tr>
				</table>
				<div class="col-sm-12" style="padding-left: 8px;padding-right: 8px;">
					<hr class="horizontalLine">
				</div>
				<h5 style="margin-left: 7px;">Counter Party/Beneficiary : ${SECTION3RTSCAN['SECTWO_SECOND_CUST_NAME']}</h5>
				<table class="table inner-border">
					<tr>
						<th >List Name</th>
						<th >List Id</th>
						<th >Match Score</th>
						<th >Matched Value</th>
						<th >Match Date</th>
					</tr>

					<tr>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_LISTNAME']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_LISTID']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_MATCHSCORE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_MATCHEDVALUE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_MATCHDATE']}</td>
					</tr>
					<tr>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_LISTNAME']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_LISTID']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_MATCHSCORE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_MATCHEDVALUE']}</td>
						<td>${SECTION3RTSCAN['SECTWO_SECOND_MATCHDATE']}</td>
					</tr>
				</table>
				<div class="col-sm-offset-5 col-sm-1"
					style="margin-top: 20px; margin-bottom: 20px">
					<button type="button" class="btn btn-success" value="Report">Report</button>
				</div> --%>
			</div>

		<!-- </div> -->
	</div>
	</div>
</c:if>
<!-- SECTION 3 - Real Time Screening Details End -->
	
<!-- SECTION 4 - Transaction Details Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION4')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION4" >
			<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
		<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#transactiondetails">
			<div class="col-sm-6 sectionHeadingAlignment">
				<h4><b>SECTION 4 - Transaction Details</b></h4>
			</div>
			<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
		</div>
		
		<div id="transactiondetails" class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px; padding-bottom:10px;">
			<table class="table table-bordered table-striped searchResultGenericTable transactionDetails${UNQID}" >
				<thead>
					<tr>
						<c:forEach var="TH" items="${SECTION4TXNDETAILS['HEADER']}">
							<c:set var="colArray" value="${f:split(TH, '.')}" />
							<c:set var="colArrayCnt" value="${f:length(colArray)}" />
							<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
						</c:forEach>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="RECORD" items="${SECTION4TXNDETAILS['DATA']}">
						<tr>
							<c:forEach var="TD" items="${RECORD}">
								<c:choose>
									<c:when test="${TD ne ' ' and TD ne ''}">
										<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
									</c:when>
									<c:otherwise>
										<td>${TD}</td>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</tr>
					</c:forEach>
				</tbody>
			</table>

			<%-- <table class="table no-border">
				<tr>
					<td width="20%">Transaction Date:</td>
					<td width="25%">
						<input type="text" class="form-control input-sm datepicker" id="TXNDETAILS_TXN_DATE${UNQID}" name="TXNDETAILS_TXN_DATE" value="${SECTION3TXNDETAILS['TXNDETAILS_TXN_DATE']}" />
					</td>
					<td width="10%">&nbsp;</td>
					<td width="20%">Amount:</td>
					<td width="25%">
						<input type="text" class="form-control input-sm" id="TXNDETAILS_AMOUNT${UNQID}" name="TXNDETAILS_AMOUNT" value="${SECTION3TXNDETAILS['TXNDETAILS_AMOUNT']}" />
					</td>
				</tr>

				<tr>
					<td>Counterparty:</td>
					<td>
						<input type="text" class="form-control input-sm" id="TXNDETAILS_COUNTERPARTY${UNQID}" name="TXNDETAILS_COUNTERPARTY" value="${SECTION3TXNDETAILS['TXNDETAILS_COUNTERPARTY']}" />
					</td>
					<td>&nbsp;</td>
					<td>Type:</td>
					<td>
						<input type="text" class="form-control input-sm" id="TXNDETAILS_TYPEOFTXN${UNQID}" name="TXNDETAILS_TYPEOFTXN" value="${SECTION3TXNDETAILS['TXNDETAILS_TYPEOFTXN']}" />
					</td>
				</tr>

				<tr>
					<td>Product:</td>
					<td>
						<input type="text" class="form-control input-sm" id="TXNDETAILS_PRODUCT${UNQID}" name="TXNDETAILS_PRODUCT" value="${SECTION3TXNDETAILS['TXNDETAILS_PRODUCT']}" />
					</td>
					<td>&nbsp;</td>
					<td>Channel:</td>
					<td>
						<input type="text" class="form-control input-sm" id="TXNDETAILS_CHANNEL${UNQID}" name="TXNDETAILS_CHANNEL" value="${SECTION3TXNDETAILS['TXNDETAILS_CHANNEL']}" />
					</td>
				</tr>

				<tr>
					<td>Reference Amount:</td>
					<td>
						<input type="text" class="form-control input-sm" id="TXNDETAILS_REF_AMOUNT${UNQID}" name="TXNDETAILS_REF_AMOUNT"  value="${SECTION3TXNDETAILS['TXNDETAILS_REF_AMOUNT']}"/>
					</td>
					<td>&nbsp;</td>
					<td>Time:</td>
					<td>
						<input type="text" class="form-control input-sm" id="TXNDETAILS_DATETIME${UNQID}" name="TXNDETAILS_DATETIME" value="${SECTION3TXNDETAILS['TXNDETAILS_DATETIME']}" />
					</td>
				</tr>

				<tr>
					<td>Cross-border:</td>
					<td>
						<table width="100%">
							<tr>
								<td>
									<input type="radio" id="TXNDETAILS_ISCROSSBORDER${UNQID}" name="TXNDETAILS_ISCROSSBORDER" value="Y" disabled="disabled"
									<c:if test="${SECTION3TXNDETAILS['TXNDETAILS_ISCROSSBORDER'] eq 'Y'}">checked="checked"</c:if>> Yes
								</td>
								<td>
									<input type="radio" id="TXNDETAILS_ISCROSSBORDER${UNQID}" name="TXNDETAILS_ISCROSSBORDER" value="N" disabled="disabled"
									<c:if test="${SECTION3TXNDETAILS['TXNDETAILS_ISCROSSBORDER'] eq 'N'}">checked="checked"</c:if>> No
								</td>	
							</tr>
						</table>							
					<td colspan="2">&nbsp;</td>
				</tr>
			</table> --%>
		</div>
	</div>
</c:if>
<!-- SECTION 4 - Transaction Details End -->
	
<!-- SECTION 5 - Account Profile (Past 6 months) Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION5')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION5">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#accountprofile">
				<div class="col-sm-6 sectionHeadingAlignment"><h4><b>SECTION 5 - Account Profile (Past 6 months)</b></h4></div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
			<div id="accountprofile" class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px;">
				<table class="table withOutLineTable">
					<tr>
						<td width="30%">Products Used:</td>
						<td colspan="3">
							<textarea class="form-control input-sm" id="ACCPROFILE_PRODUCT_USED${UNQID}" name="ACCPROFILE_PRODUCT_USED" disabled="disabled">${SECTION5ACCPROFILE['ACCPROFILE_PRODUCT_USED']}</textarea>
						</td>
					</tr>
					<tr>
						<td>Total Debit:</td>
						<td>
							<input type="text" class="form-control input-sm" id="ACCPROFILE_TOTAL_DEBIT${UNQID}" name="ACCPROFILE_TOTAL_DEBIT" value="${SECTION5ACCPROFILE['ACCPROFILE_TOTAL_DEBIT']}" disabled="disabled"/>
						</td>
						<td>Total Debit Count:</td>
						<td>
							<input type="text" class="form-control input-sm" id="ACCPROFILE_TOTAL_DEBIT_COUNT${UNQID}" name="ACCPROFILE_TOTAL_DEBIT_COUNT" value="${SECTION5ACCPROFILE['ACCPROFILE_TOTAL_DEBIT_COUNT']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Total Credit:</td>
						<td>
							<input type="text" class="form-control input-sm" id="ACCPROFILE_TOTAL_CREDIT${UNQID}" name="ACCPROFILE_TOTAL_CREDIT" value="${SECTION5ACCPROFILE['ACCPROFILE_TOTAL_CREDIT']}" disabled="disabled"/>
						</td>
						<td>Total Credit Count:</td>
						<td>
							<input type="text" class="form-control input-sm " id="ACCPROFILE_TOTAL_CREDIT_COUNT${UNQID}" name="ACCPROFILE_TOTAL_CREDIT_COUNT" value="${SECTION5ACCPROFILE['ACCPROFILE_TOTAL_CREDIT_COUNT']}" disabled="disabled"/>
						</td>
					</tr>
					<tr>
						<td>Account Risk:</td>
						<td>
							<input type="text" class="form-control input-sm" id="ACCPROFILE_ACCOUNT_RISKRATING${UNQID}" name="ACCPROFILE_ACCOUNT_RISKRATING" value="${SECTION5ACCPROFILE['ACCPROFILE_ACCOUNT_RISKRATING']}" disabled="disabled"/>
						</td>
						<td>Risk last change date:</td>
						<td>
							<input type="text" class="form-control input-sm datepicker" id="ACCPROFILE_ACCRISK_CHANGEDATE${UNQID}" name="ACCPROFILE_ACCRISK_CHANGEDATE" value="${SECTION5ACCPROFILE['ACCPROFILE_ACCRISK_CHANGEDATE']}" disabled="disabled"/>
						</td>
					</tr>

					<tr>
						<td colspan="1">Last 5 account activities:</td>
						<td colspan="3">
							<textarea class="form-control input-sm" rows="6" id="ACCPROFILE_LAST_5_ACTIVITIES${UNQID}" name="ACCPROFILE_LAST_5_ACTIVITIES" disabled="disabled">${SECTION5ACCPROFILE['ACCPROFILE_LAST_5_ACTIVITIES']}</textarea>
						</td>
					</tr>

					<tr>
						<td colspan="2">Past CTR or SR or other regulatory reports in this account / customer:</td>
						<td colspan="2">
							<table width="100%">
								<tr>
									<td width="50%">
										<input type="radio" id="ACCPROFILE_HASANYOLDREPORT${UNQID}" name="ACCPROFILE_HASANYOLDREPORT" value="Y" disabled="disabled"
										<c:if test="${SECTION5ACCPROFILE['ACCPROFILE_HASANYOLDREPORT'] eq 'Y'}">checked="checked"</c:if>> Yes
									</td>
									<td width="50%">	
										<input type="radio"	id="ACCPROFILE_HASANYOLDREPORT${UNQID}" name="ACCPROFILE_HASANYOLDREPORT" value="N" disabled="disabled"
										<c:if test="${SECTION5ACCPROFILE['ACCPROFILE_HASANYOLDREPORT'] eq 'N'}">checked="checked"</c:if>> No
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>	
						<td colspan="1">If Yes,</td>
						<td colspan="3">
							<table width="100%">
								<tr>
									<td width="5%">
										Count 
									<td width="35%">	
										<input type="text" class="form-control input-sm" id="ACCPROFILE_IFANYREPORT_COUNT${UNQID}" name="ACCPROFILE_IFANYREPORT_COUNT" value="${SECTION5ACCPROFILE['ACCPROFILE_IFANYREPORT_COUNT']}" disabled="disabled"/> 
									</td>
									<td width="5%">
										and Date 
									</td>
									<td width="55%">
										<input type="text" class="form-control input-sm datepicker" id="ACCPROFILE_IFANYREPORT_DATE${UNQID}" name="ACCPROFILE_IFANYREPORT_DATE" value="${SECTION5ACCPROFILE['ACCPROFILE_IFANYREPORT_DATE']}" disabled="disabled"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
		</div>
	</div>
</c:if>
<!-- SECTION 5 - Account Profile (Past 6 months) End -->
	
<!-- Section 6 Links Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION6')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION6">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#links">
				<div class="col-sm-6 sectionHeadingAlignment">
					<h4 >
						<b>SECTION 6 - Links</b>
					</h4>
				</div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
			
			<div id="links"  class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px;">
				<table class="table no-border">
					<tr>
						<td width="20%">From Date</td>
						<td width="25%">
							<input type="text" class="form-control input-sm datepicker" id="LINK_FROMDATE${UNQID}" name="FROMDATE" value="${SECTION6LINK['LINK_FROMDATE']}">
						</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">To Date</td>
						<td width="25%">
							<input type="text" class="form-control input-sm datepicker" id="LINK_TODATE${UNQID}" name="TODATE" value="${SECTION6LINK['LINK_TODATE']}">
						</td>
					</tr>
					<tr>
						<td width="20%">Account No</td>
						<td width="25%">
							<input type="text" class="form-control input-sm" id="LINK_ACCOUNTNO${UNQID}" name="LINK_ACCOUNTNO" value="${SECTION6LINK['LINK_ACCOUNTNO']}"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">Level Count</td>
						<td width="25%">
							<input type="text" class="form-control input-sm" id="LINK_LEVELCOUNT${UNQID}" name="LINK_LEVELCOUNT" value="${SECTION6LINK['LINK_LEVELCOUNT']}"/>
						</td>
					</tr>
					<tr>
						<td width="20%">Transaction Link</td>
						<td width="25%">
							<input type="checkbox" id="LINK_TRANSACTION_LINK${UNQID}" name="LINK_TRANSACTION_LINK" value="Y" 
										<c:if test="${SECTION6LINK['LINK_TRANSACTION_LINK'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="20%">Static Link</td>
						<td width="25%">
							<input type="checkbox" id="LINK_STATIC_LINK${UNQID}" name="LINK_STATIC_LINK" value="Y" 
										<c:if test="${SECTION6LINK['LINK_STATIC_LINK'] eq 'Y'}">checked="checked"</c:if>>
						</td>
					</tr>
					<tr>
						<td colspan="5" align="center">
							<input type="button" class="btn btn-sm btn-info" id="searchEntityLink${UNQID}" name="searchEntityLink" value="TABULAR LINK VIEW"/>
							&nbsp;&nbsp;&nbsp;
							<input type="button" class="btn btn-sm btn-info" id="searchEntityLinkHorizontalGraph${UNQID}" name="searchEntityLinkHorizontalGraph" value="HORIZONTAL GRAPH VIEW"/>
							&nbsp;&nbsp;&nbsp;
							<input type="button" class="btn btn-sm btn-info" id="searchEntityLinkVerticalGraph${UNQID}" name="searchEntityLinkVerticalGraph" value="VERTICAL GRAPH VIEW"/>
						</td>
					</tr>
				</table>
				
				
				<%-- <h4 >
					<b style="margin-left:10px;">Level 1</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th>Total Transactions</th>
						<th>Any alerted TXN</th>
						<th>Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th>Total Debits <br> (Txn count and cumulative value)</th>
						<th>Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L1_TOTAL_CREDITS']}</td>
					</tr>

				</table>
				<hr class="horizontalLine">
				<h4 style="margin-top: 20px;">
					<b style="margin-left:10px;">Level 2</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th  >Total Transactions</th>
						<th  >Any alerted TXN</th>
						<th  >Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th  >Total Debits <br> (Txn count and cumulative value)</th>
						<th >Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L2_TOTAL_CREDITS']}</td>
					</tr>

				</table>
				<hr class="horizontalLine">
				<h4 style="margin-top: 20px;">
					<b style="margin-left:10px;">Level 3</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th  >Total Transactions</th>
						<th  >Any alerted TXN</th>
						<th  >Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th  >Total Debits <br> (Txn count and cumulative value)</th>
						<th >Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L3_TOTAL_CREDITS']}</td>
					</tr>

				</table>
				<hr class="horizontalLine">
				<h4 style="margin-top: 20px;">
					<b style="margin-left:10px;">Level 4</b>
				</h4>
				<table class="table inner-border">
					<tr>
						<th  >Total Transactions</th>
						<th  >Any alerted TXN</th>
						<th  >Total Cumulative Value <br> (Txn count and cumulative value)</th>
						<th  >Total Debits <br> (Txn count and cumulative value)</th>
						<th >Total Credits <br> (Txn count and cumulative value)</th>
					</tr>

					<tr>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTALTRANSACTION']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_ALTEREDTXN']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_VALUE']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_DEBITS']}</td>
						<td  >${SECTION_FIVE['SECFIVE_L4_TOTAL_CREDITS']}</td>
					</tr>
				</table> --%>
			<!-- </div> -->
		</div>
	</div>
</c:if>	
<!-- Section 6 Links End -->
	
<!-- SECTION 7 - Past History Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION7')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION7">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#pasthistory">
				<div class="col-sm-6 sectionHeadingAlignment"> <h4><b>SECTION 7 - Past History</b></h4></div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
			
			<div id="pasthistory" class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px;">
				<table class="table form-inline no-border" >
					<tr>
						<td width="100%">
							This customer had:&nbsp;&nbsp;
								<input type="text" class="form-control input-sm" style="width: 5%;" id="PASTHISTORY_ALERTCOUNT_6MNTHS${UNQID}" name="PASTHISTORY_ALERTCOUNT_6MNTHS" value="${SECTION7PASTHISTORY['PASTHISTORY_ALERTCOUNT_6MNTHS']}" disabled="disabled"/> 
							&nbsp;&nbsp;alerts in the last 6 months and&nbsp;&nbsp;
								<input type="text"class="form-control input-sm" style="width: 5%;" id="PASTHISTORY_ALERTCOUNT_1YEAR${UNQID}" name="PASTHISTORY_ALERTCOUNT_1YEAR" value="${SECTION7PASTHISTORY['PASTHISTORY_ALERTCOUNT_1YEAR']}" disabled="disabled"/> 
							&nbsp;&nbsp;alerts in the last 1 year.
						</td>
					</tr>
				</table>
				<table class="table form-inline no-border">
					<tr>
						<td width="100%">
							This transaction is the same as above alerts:&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" id="PASTHISTORY_SAMETXN_AS_PREV${UNQID}" name="PASTHISTORY_SAMETXN_AS_PREV" value="Y" disabled="disabled"
										<c:if test="${SECTION7PASTHISTORY['PASTHISTORY_SAMETXN_AS_PREV'] eq 'Y'}">checked="checked"</c:if>> Yes
								&nbsp;&nbsp;&nbsp;&nbsp;
								<input type="radio" id="PASTHISTORY_SAMETXN_AS_PREV${UNQID}" name="PASTHISTORY_SAMETXN_AS_PREV" value="N" disabled="disabled"
										<c:if test="${SECTION7PASTHISTORY['PASTHISTORY_SAMETXN_AS_PREV'] eq 'N'}">checked="checked"</c:if>> No
						</td>
					</tr>
				</table>
			<!-- </div> -->
		</div>
	</div>
</c:if>	
<!-- SECTION 7 - Past History End -->

<!-- SECTION 8 - Related Parties Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION8')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION8">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#relatedparties">
				<div class="col-sm-6 sectionHeadingAlignment"><h4><b>SECTION 8 - Related Parties</b></h4>
				</div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
			
			<div id="relatedparties" class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px;">
				<b style="margin-left:10px;">The below relationships were discovered for this customer and account:</b>
				<table class="table no-border form-inline">
					<tr>
						<td width="33%">Joint Holder:</td>
						<td width="10%">
							<input type="radio" id="RLTDPARTY_ISJOINTHOLDER${UNQID}"  name="RLTDPARTY_ISJOINTHOLDER" value="Y" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_ISJOINTHOLDER'] eq 'Y'}">checked="checked"</c:if>> Yes
						</td>
						<td width="7%">
							<input type="radio" id="RLTDPARTY_ISJOINTHOLDER${UNQID}" name="RLTDPARTY_ISJOINTHOLDER" value="N" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_ISJOINTHOLDER'] eq 'N'}">checked="checked"</c:if>> No
						</td>
						<td width="33%">Customer has other accounts:</td>
						<td width="10%">
							<input type="radio" id="RLTDPARTY_ANY_OTRACCOUNTS${UNQID}" name="RLTDPARTY_ANY_OTRACCOUNTS" value="Y" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_ANY_OTRACCOUNTS'] eq 'Y'}">checked="checked"</c:if>> Yes
						</td>
						<td width="7%">
							<input type="radio" id="RLTDPARTY_ANY_OTRACCOUNTS${UNQID}" name="RLTDPARTY_ANY_OTRACCOUNTS" value="N" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_ANY_OTRACCOUNTS'] eq 'N'}">checked="checked"</c:if>> No
						</td>
					</tr>
					<tr>
						<td width="33%">Customer's relatives have other accounts:</td>
						<td width="10%">
							<input type="radio" id="RLTDPARTY_CUSTRELTV_OTRACCS${UNQID}" name="RLTDPARTY_CUSTRELTV_OTRACCS" value="Y" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_CUSTRELTV_OTRACCS'] eq 'Y'}">checked="checked"</c:if>> Yes
						</td>
						<td width="7%">
							<input type="radio" id="RLTDPARTY_CUSTRELTV_OTRACCS${UNQID}" name="RLTDPARTY_CUSTRELTV_OTRACCS" value="N" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_CUSTRELTV_OTRACCS'] eq 'N'}">checked="checked"</c:if>> No
						</td>
						<td width="33%">Customer is beneficiary of other accounts:</td>
						<td width="10%">
							<input type="radio" id="RLTDPARTY_ISBENEFICIARY${UNQID}" name="RLTDPARTY_ISBENEFICIARY" value="Y" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_ISBENEFICIARY'] eq 'Y'}">checked="checked"</c:if>> Yes
						</td>
						<td width="7%">
							<input type="radio" id="RLTDPARTY_ISBENEFICIARY${UNQID}" name="RLTDPARTY_ISBENEFICIARY" value="N" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_ISBENEFICIARY'] eq 'N'}">checked="checked"</c:if>>No
						</td>
					</tr>
					<tr>
						<td width="33%">Customer is signing authority of Corporate Entity Account:</td>
						<td width="10%">
							<input type="radio" id="RLTDPARTY_HAVE_CORPENTITY_ACC${UNQID}" name="RLTDPARTY_HAVE_CORPENTITY_ACC" value="Y" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_HAVE_CORPENTITY_ACC'] eq 'Y'}">checked="checked"</c:if>> Yes
						</td>
						<td width="7%">
							<input type="radio" id="RLTDPARTY_HAVE_CORPENTITY_ACC${UNQID}" name="RLTDPARTY_HAVE_CORPENTITY_ACC" value="N" disabled="disabled"
										<c:if test="${SECTION8RLTDPARTY['RLTDPARTY_HAVE_CORPENTITY_ACC'] eq 'N'}">checked="checked"</c:if>> No 
						</td>
					</tr>
				</table>
		</div>
	</div>
</c:if>
<!-- SECTION 8 - Related Parties End -->
	
<!-- SECTION 9 - Ringside View Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION9')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION9">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#ringsideview">
				<div class="col-sm-6 sectionHeadingAlignment"><h4><b>SECTION 9 - Ringside View</b></h4>
				</div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
		
			<div id="ringsideview" class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px;">

				<table class="table form-inline no-border ">
					<tr>
						<td>
							In the last 30 days, this alert was breached a total of 
								<input type="text" class="form-control input-sm" id="RINGSIDEVW_ALERTSBREACHED${UNQID}" name="RINGSIDEVW_ALERTSBREACHED" value="${SECTION9RINGSIDEVIEW['RINGSIDEVW_ALERTSBREACHED']}" disabled="disabled"/> 
							times in the bank and 
								<input type="text" class="form-control input-sm" id="RINGSIDEVW_FOR_CUSTOMER${UNQID}" name="RINGSIDEVW_FOR_CUSTOMER" value="${SECTION9RINGSIDEVIEW['RINGSIDEVW_FOR_CUSTOMER']}" disabled="disabled"/> 
							times for customers of the same profile and 
								<input type="text" class="form-control input-sm" id="RINGSIDEVW_FOR_BRANCH${UNQID}" name="RINGSIDEVW_FOR_BRANCH" value="${SECTION9RINGSIDEVIEW['RINGSIDEVW_FOR_BRANCH']}" disabled="disabled"/> 
							times for the base branch of this account.
						</td>
					</tr>
				</table>
				<table class="table form-inline no-border">
					<tr>
						<td>
							In the last 30 days, transactions from this branch breached a total of 
								<input type="text" class="form-control input-sm" id="RINGSIDEVW_TRANSACTION_BREACH${UNQID}" name="RINGSIDEVW_TRANSACTION_BREACH" value="${SECTION9RINGSIDEVIEW['RINGSIDEVW_TRANSACTION_BREACH']}" disabled="disabled"/> 
							number of alerts for 
								<input type="text" class="form-control input-sm" id="RINGSIDEVW_CUST_TRANS_BREACH${UNQID}" name="RINGSIDEVW_CUST_TRANS_BREACH" value="${SECTION9RINGSIDEVIEW['RINGSIDEVW_CUST_TRANS_BREACH']}" disabled="disabled"/> 
							sets of customers across 
								<input type="text" class="form-control input-sm" id="RINGSIDEVW_BRANCH_TXN_BREACH${UNQID}" name="RINGSIDEVW_BRANCH_TXN_BREACH" value="${SECTION9RINGSIDEVIEW['RINGSIDEVW_BRANCH_TXN_BREACH']}" disabled="disabled"/> 
							sets of account.
						</td>
					</tr>
				</table>
		</div>
	</div>
</c:if>	
<!-- SECTION 9 - Ringside View End -->

<!-- SECTION 10 - Customer Case History Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION10')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION10" >
			<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
		<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#customerCaseHistory">
			<div class="col-sm-6 sectionHeadingAlignment">
				<h4><b>SECTION 10 - Customer Case History </b></h4>
			</div>
			<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
		</div>
		
		<div id="customerCaseHistory" class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px; padding-bottom:10px;">
			<table class="table table-bordered table-striped searchResultGenericTable customerCaseHistory${UNQID}" >
				<thead>
					<tr>
						<c:forEach var="TH" items="${SECTION10CUSTCASEHISTORY['HEADER']}">
							<c:set var="colArray" value="${f:split(TH, '.')}" />
							<c:set var="colArrayCnt" value="${f:length(colArray)}" />
							<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
						</c:forEach>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="RECORD" items="${SECTION10CUSTCASEHISTORY['DATA']}">
						<tr>
							<c:forEach var="TD" items="${RECORD}">
								<c:choose>
									<c:when test="${TD ne ' ' and TD ne ''}">
										<td data-toggle="tooltip" data-placement="auto"  title="${TD}" data-container="body">${TD}</td>
									</c:when>
									<c:otherwise>
										<td>${TD}</td>
									</c:otherwise>
								</c:choose>
							</c:forEach>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</c:if>
<!-- SECTION 10 - Customer Case History Start -->
	
<!-- SECTION 11 - User Comments and Notes Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION11')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION11">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#comments">
				<div class="col-sm-6 sectionHeadingAlignment"><h4><b><p>SECTION 11 - User Comments and Notes</p></b></h4></div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
			
			<div id="comments" class="col-sm-12  collapse in" style="padding:10px 24px 10px 24px;">
				<textarea class="form-control input-sm" rows="5" id="USERCOMMENTS_COMMENT${UNQID}" name="USERCOMMENTS_COMMENT" disabled="disabled">${SECTION11USERCOMMENTS['USERCOMMENTS_COMMENT']}</textarea>
			</div>
		<!-- </div> -->
	</div>
</c:if>
<!-- SECTION 11 - User Comments and Notes End -->
	
<!-- SECTION 12 - Action Items Start -->
<c:if test="${f:contains(ROBOSCAN_CONFIG,'SECTION12')}">
	<div class=" col-sm-offset-1 col-sm-10 sectionStyle" id="SECTION12">
		<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
			<div class="col-sm-12 section-heading" data-toggle="collapse" data-target="#actionitem">
				<div class="col-sm-6 sectionHeadingAlignment"><h4><b><p>SECTION 12 - Action Items Start</p></b></h4></div>
				<span class="pull-right collapse-icon"><i class="collapsible fa fa-chevron-down"></i></span>
			</div>
			
			<div id="actionitem" class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px;">
				<table  class="table no-border">
					<tr>
						<td>Escalate</td>
						<td>
							<input type="checkbox" id="ACTION_IS_CASE_ESCALATED${UNQID}" name="ACTION_IS_CASE_ESCALATED" value="Y" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_CASE_ESCALATED'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td>Add To Watch</td>
						<td>
							<input type="checkbox" id="ACTION_IS_ADDED_TO_WATCHLIST${UNQID}" name="ACTION_IS_ADDED_TO_WATCHLIST" value="Y" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_ADDED_TO_WATCHLIST'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td>Mark as High Risk</td>
						<td>
							<input type="checkbox" id="ACTION_IS_MARKED_HIGH_RISK${UNQID}" name="ACTION_IS_MARKED_HIGH_RISK" value="Y" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_MARKED_HIGH_RISK'] eq 'Y'}">checked="checked"</c:if>>
						</td>
					</tr>
					<tr>
						<td>Further Investigate</td>
						<td>
							<input type="checkbox" id="ACTION_IS_INVESTIGATION_DONE${UNQID}" name="ACTION_IS_INVESTIGATION_DONE" value="Y" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_INVESTIGATION_DONE'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td>Raise CDD request to branch</td>
						<td>
							<input type="checkbox" id="ACTION_IS_CDD_REQ_TO_BRANCH${UNQID}" name="ACTION_IS_CDD_REQ_TO_BRANCH" value="Y" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_CDD_REQ_TO_BRANCH'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td>Close without a case</td>
						<td>
							<input type="checkbox" id="SECTEN_CLOSE_WITHOUTCASE${UNQID}" name="SECTEN_CLOSE_WITHOUTCASE" value="Y" 
										<c:if test="${SECTION12ACTIONS['SECTEN_CLOSE_WITHOUTCASE'] eq 'Y'}">checked="checked"</c:if>>
						</td>
					</tr>

					<tr>
						<td>Mark as false positive</td>
						<td>
							<input type="checkbox" id="ACTION_ISMARKED_FALSEPOSITIVE${UNQID}" name="ACTION_ISMARKED_FALSEPOSITIVE" value="MARKED_FALSEPOSITIVE" 
										<c:if test="${SECTION12ACTIONS['ACTION_ISMARKED_FALSEPOSITIVE'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td>Mark for Follow up</td>
						<td>
							<input type="checkbox" id="ACTION_IS_MARKED_FOR_FOLLOWUP${UNQID}" name="ACTION_IS_MARKED_FOR_FOLLOWUP" value="MARKED_FOR_FOLLOWUP" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_MARKED_FOR_FOLLOWUP'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td>Desktop Closure</td>
						<td>
							<input type="checkbox" id="ACTION_IS_DESKTOP_CLOSED${UNQID}" name="ACTION_IS_DESKTOP_CLOSED" value="DESKTOP_CLOSED" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_DESKTOP_CLOSED'] eq 'Y'}">checked="checked"</c:if>>
						</td>
					</tr>
					<tr>
						<td>Investigated</td>
						<td>
							<input type="checkbox" id="ACTION_IS_INVESTIGATED${UNQID}" name="ACTION_IS_INVESTIGATED" value="INVESTIGATED" 
										<c:if test="${SECTION12ACTIONS['ACTION_IS_INVESTIGATED'] eq 'Y'}">checked="checked"</c:if>>
						</td>
						<td colspan="4">&nbsp;</td>
					</tr>
				</table>
			<!-- </div> -->
		</div>
	</div>
</c:if>	
<!-- SECTION 12 - Action Items End -->
	
<!-- Section Options Start -->
<div class=" col-sm-offset-1 col-sm-10 " style="margin-top: 20px;margin-bottom:30px;">
	<!-- <div class=" col-sm-offset-1 col-sm-10"> -->
		<div class="col-sm-12 section-heading" style="height: 45px;"data-toggle="collapse" data-target="#options">
			<div class="col-sm-6 sectionHeadingAlignment" ><h4><b><p>Option</p></b></h4></div>
			<span class="pull-right collapse-icon" style="margin-top: -50px"><i class="collapsible fa fa-chevron-down"></i></span>
		</div>
		
		<div id="options"  class="col-sm-12 collapse show in multi-collapse" style="padding-top:10px;">
			<table class="table no-border">
				<tr>
					<td>Save Roboscan report as part of case</td>
					<td>
						<input type="checkbox" id="OPTION_SAVE_ROBOSCAN_WITHCASE${UNQID}" name="OPTION_SAVE_ROBOSCAN_WITHCASE" value="Y" 
									<c:if test="${OPTION['OPTION_SAVE_ROBOSCAN_WITHCASE'] eq 'Y'}">checked="checked"</c:if>>
					</td>
					<td>Flag for internal discussion</td>
					<td>
						<input type="checkbox" id="OPTION_INTRNL_DISCUSSION_FLAG${UNQID}" name="OPTION_INTRNL_DISCUSSION_FLAG" value="Y" 
									<c:if test="${OPTION['OPTION_FLAG_DISCUSSION'] eq 'Y'}">checked="checked"</c:if>>
					</td>
				</tr>
				<tr>
					<td>Remind to review in 3 days</td>
					<td>
						<input type="checkbox" id="OPTION_REMIND_REVIEW_IN_3DAYS${UNQID}" name="OPTION_REMIND_REVIEW_IN_3DAYS" value="Y" 
									<c:if test="${OPTION['OPTION_REMIND_REVIEW_IN_3DAYS'] eq 'Y'}">checked="checked"</c:if>>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="4" style="padding: 0 8px 0 8px;">
						<hr class="horizontalLine">
					</td>
				</tr>
				<tr>
					<%-- <td>Print Roboscan Report</td>
					<td>
						<button type="button" class="btn btn-sm btn-warning" onclick="printRoboscan('roboscanForm')" id="printRoboscanReport${UNQID}" name="printRoboscanReport">Print</button>
					</td> --%>
					<td>Send as Email</td>
					<td>
						<button type="button" class="btn btn-sm btn-warning" id="sendAsEmail${UNQID}" name="sendAsEmail${UNQID}">To Business</button>
					</td>
					<td>Close</td>
					<td>
						<button type="button" class="btn btn-sm btn-danger" id="closeForm${UNQID}" name="closeForm${UNQID}">Close</button>
					</td>
				</tr>
			</table>
		<!-- </div> -->
	</div>
</div>
<!-- Section Options End -->
</form>
</div>
<div class="modal fade bs-example-modal-lg" id="compassGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-xl">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
					<button type="button" class="close"  title="Open in new Window" id="openModalInWindow" url-attr="" data-attr="">
						<span aria-hidden="true" class="fa fa-external-link"></span>
					</button>
					<button type="button" class="close" title="Open in Tab" id="openModalInTab">
						<span aria-hidden="true" class="fa fa-plus"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassGenericModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassGenericModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div> 
<div class="modal fade bs-example-modal-lg" id="compassRTScanningModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-xl">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
					<button type="button" class="close"  title="Open in new Window" id="openRTModalInWindow" url-attr="" data-attr="">
						<span aria-hidden="true" class="fa fa-external-link"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassRTScanningModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassRTScanningModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>
<div class="modal fade bs-example-modal-sm" id="compassMediumGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-xl">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassMediumGenericModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassMediumGenericModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>
<div class="modal fade bs-example-modal-lg" id="compassCaseWorkFlowGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
	<div class="modal-dialog modal-xl">
		<div class="modal-content card-primary">
			<div class="modal-header card-header" style="cursor: move;">
				<div class="modal-button">
					<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
						<span aria-hidden="true" class="fa fa-remove"></span>
					</button>
				</div>
				<h4 class="modal-title" id="compassCaseWorkFlowGenericModal-title">...</h4>					
			</div>
			<div class="modal-body" id="compassCaseWorkFlowGenericModal-body">
			<br/>
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>
<div class="modal fade bs-example-modal-lg" id="compassFileUploadModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-xl">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassFileUploadModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassFileUploadModal-body">
					<div id="compassFileUploadModal-loader">
						<br/>
							<center>
								<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
							</center>
						<br/>
					</div>
					<div id="compassFileUploadModal-process" style="display: none;">
					</div>
					<div class="d-flex">
					<div class="row" id="compassFileUploadModal-upload" style="display: none;">
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Upload File</h6>
								</div>
								<table class="table table-bordered table-striped" style="margin-bottom: 0px;">
									<tr>
										<td colspan="2" style="font-size: 10px;">
											Allowed File Size : <span id="compassFileUploadModal-uploadFileSize"></span><br/>
											Allowed File Type : <span id="compassFileUploadModal-uploadFileAllowedType"></span><br/>
											Block File Type : <span id="compassFileUploadModal-uploadFileBlockedType"></span><br/>
											Maximum File Select Count : <span id="compassFileUploadModal-uploadFileMaxNoSize"></span><br/>
											Upload Enable : <span id="compassFileUploadModal-uploadEnable"></span>
										</td>
									</tr>
									<tr>
										<td width="15%">Select Files</td>
										<td width="85%">
											<input id="fileupload" onchange="compassFileUpload.FileSelected(this); this.value=null; return false;" class="form-control input-sm" type="file" name="files[]"  multiple>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center; font-weight: bold;">Or</td>
									</tr>
									<tr>
										<td>Drop Files</td>
										<td>
											<div id="dragandrophandler">Drag & Drop Files Here</div>
										</td>
									</tr>
									<tr>
										<td>Selected Files</td>
										<td>
											<table class="table table-bordered table-striped" id="upload-files" style="font-size: 12px;">
										        <tr>
										            <th width="25%">File Name</th>
										            <th width="15%">File Size</th>
										            <th width="10%">File Type</th>
										            <th width="25%">Progress</th>
										            <th width="25%">Action / Status</th>
										        </tr>
										    </table>
										</td>
									</tr>
									<tr>
										<td colspan="2" style="text-align: center;">
											<button type="button" class="btn btn-warning btn-sm" id="upload" disabled="disabled" onclick="compassFileUpload.startUpload(this);">Upload</button>
										</td>
									</tr>
								</table>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="card card-info">
								<div class="card-header clearfix">
									<h6 class="card-title">Download File</h6>
								</div>
								<div id="compassFileUploadModal-uploadedFiles">
									
								</div>
							</div>
						</div>
					</div>
					
				</div>
				</div>
			</div>
		</div>
	</div>

</body>
</html>