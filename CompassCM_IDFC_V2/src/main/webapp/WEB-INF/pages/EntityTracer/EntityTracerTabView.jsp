<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>    
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String userTypeCode = session.getAttribute("USER_NAME") != null ? (String) session.getAttribute("USER_NAME") : "";
Map<String, Object> EntityTracerData = (Map<String, Object>) request.getAttribute("EntityTracerData");
String fromDate = request.getAttribute("FromDate") != null ? (String) request.getAttribute("FromDate") : "";
String toDate = request.getAttribute("ToDate") != null ? (String) request.getAttribute("ToDate") : "";
String accountNumber = request.getAttribute("AccountNumber") != null ? (String) request.getAttribute("AccountNumber") : "";

String customerId = request.getAttribute("CustomerId") != null ? (String) request.getAttribute("CustomerId") : "";
String customerName = request.getAttribute("CustomerName") != null ? (String) request.getAttribute("CustomerName") : "";
String staticLink = request.getAttribute("StaticLink") != null ? (String) request.getAttribute("StaticLink") : "";
String transactionLink = request.getAttribute("TransactionLink") != null ? (String) request.getAttribute("TransactionLink") : "";

String minLinks = request.getAttribute("MinLinks") != null ? (String) request.getAttribute("MinLinks") : "";
String counterAccountNo = request.getAttribute("CounterAccountNo") != null ? (String) request.getAttribute("CounterAccountNo") : "";
String levelCount = request.getAttribute("LevelCount") != null ? (String) request.getAttribute("LevelCount") : "";
String message = request.getAttribute("Message") != null ? (String) request.getAttribute("Message") : "";

String productCode = request.getAttribute("EXCULDEDPRODUCTCODE") != null ? (String) request.getAttribute("EXCULDEDPRODUCTCODE") : "";
String displayLevelCount = "1";
String displayMinLinks = "0";
if(levelCount != "")
	displayLevelCount = levelCount;
if(minLinks != "")
	displayMinLinks = minLinks;
%>
<script type="text/javascript">
	var id = '${UNQID}';
 	var message = '<%=message%>';
 	if(message != null && message != "")
		alert(message);

	$(document).ready(function(){
		compassTopFrame.init(id, 'entityLinkAnalysis'+id, 'dd/mm/yy');
		
		$('.panelSlidingEntityLinkAnalysis'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'entityLinkAnalysisSerachResultPanel');
	    });
		
		$("#dashBoardTab").tab();
		/*		
		$("#downloadXLS").click(function(){
			var fromDate  = $("#fromDate").val();
			var toDate  = $("#toDate").val();
			var accountNumber = $("#accountNumber").val();

			if(accountNumber != ""){
				var customerId  = $("#CustomerId").val();
				var customerName  = $("#CustomerName").val();
				var staticLink = $("#StaticLink").is(":checked");
				var transactionLink  = $("#TransactionLink").is(":checked");

				if(staticLink == true)
					staticLink = "y";
				else
					staticLink = "n";
				if(transactionLink == true)
					transactionLink = "y";
				else
					transactionLink = "n";

				var counterAccountNo  = $("#CounterAccountNo").val();
				var productCode = $("#ProductCode").val();
				var minLinks  = $("#MinLinks").val();
				var levelCount = $("#LevelCount").val();

				var URL = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsExcel?FromDate="+fromDate+
				"&ToDate="+toDate+"&AccountNumber="+accountNumber+"&CustomerId="+customerId+
				"&CustomerName="+customerName+"&StaticLink="+staticLink+"&TransactionLink="+
				transactionLink+"&MinLinks="+minLinks+"&CounterAccountNo="+counterAccountNo+
				"&LevelCount="+levelCount+"&ProductCode="+productCode;
				$.fileDownload(URL, {
				    httpMethod : "GET",
					successCallback: function (url) {
				    },
				    failCallback: function (html, url) {
				        alert('Failed to download file'+url+"\n"+html);
				    }
				});
				//window.open(URL,'','height=350,width=650,resizable=Yes,scrollable=Yes');
			}else{
				alert("Enter account number");
			}
			
		});
		*/

		$("#downloadXLS").click(function(){
			var fromDate  = $("#fromDate").val();
			var toDate  = $("#toDate").val();
			var accountNumber = $("#accountNumber").val();
			fromDate  = $(".entityLinkAnalysisFromDate"+id).val();
			toDate  = $(".entityLinkAnalysisToDate"+id).val();
			accountNumber = $("#entityLinkAnalysisAccountNo"+id).val();
			
			if(accountNumber != ""){
				$("#FormFromDate").val(fromDate);
				$("#FormToDate").val(toDate);
				$("#FormAccountNumber").val(accountNumber);
				
				var customerId  = $("#CustomerId").val();
				var customerName  = $("#CustomerName").val();
				var staticLink = $("#StaticLink").is(":checked");
				var transactionLink  = $("#TransactionLink").is(":checked");

				if(staticLink == true)
					staticLink = "y";
				else
					staticLink = "n";
				if(transactionLink == true)
					transactionLink = "y";
				else
					transactionLink = "n";

				var counterAccountNo  = $("#CounterAccountNo").val();
				var productCode = $("#ProductCode").val();
				var minLinks  = $("#MinLinks").val();
				var levelCount = $("#LevelCount").val();

				var URL = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsExcel?FromDate="+fromDate+
				"&ToDate="+toDate+"&AccountNumber="+accountNumber+"&CustomerId="+customerId+
				"&CustomerName="+customerName+"&StaticLink="+staticLink+"&TransactionLink="+
				transactionLink+"&MinLinks="+minLinks+"&CounterAccountNo="+counterAccountNo+
				"&LevelCount="+levelCount+"&ProductCode="+productCode;
				/*
				$.fileDownload(URL, {
				    httpMethod : "GET",
					successCallback: function (url) {
				    },
				    failCallback: function (html, url) {
				        alert('Failed to download file'+url+"\n"+html);
				    }
				});
				*/
				window.open(URL,'','height=350,width=650,resizable=Yes,scrollable=Yes');
			}else{
				alert("Enter account number");
			}
			
		});
		
		$("#matrixSearch, #AdvMatrixSearch").click(function(){
			var fromDate  = $(".entityLinkAnalysisFromDate"+id).val();
			var toDate  = $(".entityLinkAnalysisToDate"+id).val();
			var accountNumber = $("#entityLinkAnalysisAccountNo"+id).val();
			if(accountNumber != ""){
				var customerId  = $("#CustomerId").val();
				var customerName  = $("#CustomerName").val();
				var staticLink = $("#StaticLink").is(":checked");
				var transactionLink  = $("#TransactionLink").is(":checked");

				if(staticLink == true)
					staticLink = "y";
				else
					staticLink = "n";
				if(transactionLink == true)
					transactionLink = "y";
				else
					transactionLink = "n";

				var counterAccountNo  = $("#CounterAccountNo").val();
				var productCode = $("#ProductCode").val();
				var minLinks  = $("#MinLinks").val();
				var levelCount = $("#LevelCount").val();

				var URL = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsMatrix?FromDate="+fromDate+
				"&ToDate="+toDate+"&AccountNumber="+accountNumber+"&CustomerId="+customerId+
				"&CustomerName="+customerName+"&StaticLink="+staticLink+"&TransactionLink="+
				transactionLink+"&MinLinks="+minLinks+"&CounterAccountNo="+counterAccountNo+
				"&LevelCount="+levelCount+"&ProductCode="+productCode;
				//window.open(URL);
				window.open(URL,'Entity Matrix','height=650,width=1250,resizable=Yes,scrollable=Yes');
			}else{
				alert("Enter account number");
			}
		});

		$("#linkOnMap").click(function(){
			var fromDate  = $(".entityLinkAnalysisFromDate"+id).val();
			var toDate  = $(".entityLinkAnalysisToDate"+id).val();
			var accountNumber = $("#entityLinkAnalysisAccountNo"+id).val();
			if(accountNumber != ""){
				var customerId  = $("#CustomerId").val();
				var customerName  = $("#CustomerName").val();
				var staticLink = $("#StaticLink").is(":checked");
				var transactionLink  = $("#TransactionLink").is(":checked");

				if(staticLink == true)
					staticLink = "y";
				else
					staticLink = "n";
				if(transactionLink == true)
					transactionLink = "y";
				else
					transactionLink = "n";

				var counterAccountNo  = $("#CounterAccountNo").val();
				var productCode = $("#ProductCode").val();
				var minLinks  = $("#MinLinks").val();
				var levelCount = $("#LevelCount").val();

				var URL = "${pageContext.request.contextPath}/common/getEntityLinkedDetailsMatrix?FromDate="+fromDate+
				"&ToDate="+toDate+"&AccountNumber="+accountNumber+"&CustomerId="+customerId+
				"&CustomerName="+customerName+"&StaticLink="+staticLink+"&TransactionLink="+
				transactionLink+"&MinLinks="+minLinks+"&CounterAccountNo="+counterAccountNo+
				"&LevelCount="+levelCount+"&ProductCode="+productCode;
				//window.open(URL);
				//window.open('${pageContext.request.contextPath}/common/getLinkedCustomerAddressOnMapDetails?customerId='+customerId+"&addressType=COMM_ADDRESSLINE1");
				window.open('${pageContext.request.contextPath}/common/getLinkedCustomerAddressOnMapDetailsTemp?customerId='+customerId+"&addressType=COMM_ADDRESSLINE1");
				
				//window.open(URL,'Entity Matrix','height=650,width=1250,resizable=Yes,scrollable=Yes');
			}else{
				alert("Enter account number");
			}
		});
		
		$("#Search, #AdvSearch").click(function(){
			var button = $(this);
			var buttonText = $(button).html();
			
			var fromDate  = $(".entityLinkAnalysisFromDate"+id).val();
			var toDate  = $(".entityLinkAnalysisToDate"+id).val();
			var accountNumber = $("#entityLinkAnalysisAccountNo"+id).val();
			
			if(accountNumber != ""){
				$("#FormFromDate").val(fromDate);
				$("#FormToDate").val(toDate);
				$("#FormAccountNumber").val(accountNumber);

				var formObj = $("#entityLinkDetailsForm");
				var formData = (formObj).serialize();
				
				$(button).attr("disabled","disabled");
				$(button).html("Searching...");
				$("#entityLinkAnalysisSerachResultPanel"+id).css("display", "block");
				$("#entityLinkTracerModal").modal("hide");
				
				$.ajax({
					url: "${pageContext.request.contextPath}/common/getEntityLinkedDetailsTabView",
					cache: false,
					type: "POST",
					data: formData,
					success: function(res) {
						$(button).removeAttr("disabled");
						$(button).html(buttonText);
						$("#entityLinkAnalysisSerachResult"+id).html(res);
						panelSliding(button);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
				
				
			}else{
				alert("Enter account number");
			}
		});
		
		
		$(".SearchGraph").click(function(){
			var button = $(this);
			var buttonText = $(button).html();
			
			var fromDate  = $(".entityLinkAnalysisFromDate"+id).val();
			var toDate  = $(".entityLinkAnalysisToDate"+id).val();
			var accountNumber = $("#entityLinkAnalysisAccountNo"+id).val();
			var view = $(button).attr("view");
			
			
			if(accountNumber != ""){
				$("#FormFromDate").val(fromDate);
				$("#FormToDate").val(toDate);
				$("#FormAccountNumber").val(accountNumber);

				var formObj = $("#entityLinkDetailsForm");
				var formData = (formObj).serialize();
				formData = formData+"&view="+view;
				
				$(button).attr("disabled","disabled");
				$(button).html("Searching...");
				$("#entityLinkAnalysisSerachResultPanel"+id).css("display", "block");
				$("#entityLinkTracerModal").modal("hide");
				
				$.ajax({
					url: "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphViewPage",
					cache: false,
					type: "POST",
					data: formData,
					success: function(res) {
						$(button).removeAttr("disabled");
						$(button).html(buttonText);
						$("#entityLinkAnalysisSerachResult"+id).html(res);
						panelSliding(button);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
				
				
			}else{
				alert("Enter account number");
			}
		});

		$("#Save").click(function(){
			var fromDate  = $("#fromDate").val();
			var toDate  = $("#toDate").val();
			var accountNumber = $("#accountNumber").val();
			var customerId  = $("#CustomerId").val();
			var customerName  = $("#CustomerName").val();
			var staticLink = $("#StaticLink").is(":checked");
			var transactionLink  = $("#TransactionLink").is(":checked");

			if(staticLink == true)
				staticLink = "y";
			else
				staticLink = "n";
			if(transactionLink == true)
				transactionLink = "y";
			else
				transactionLink = "n";

			var counterAccountNo  = $("#CounterAccountNo").val();
			var productCode = $("#ProductCode").val();
			var minLinks  = $("#MinLinks").val();
			var levelCount = $("#LevelCount").val();

			$("#Save").attr("disabled","disabled");
			$("#Save").html("Saving...");

			var fullData = "fromDate="+fromDate+"&toDate="+toDate+"&accountNumber="+accountNumber+"&customerId="+customerId+			"&customerName="+customerName+"&staticLink="+staticLink+"&transactionLink="+transactionLink+
				"&counterAccountNo="+counterAccountNo+"&productCode="+productCode+"&minLinks="+minLinks+"&levelCount="+levelCount;
			$.ajax({
				url : "${pageContext.request.contextPath}/common/saveEntityTracerConfig",
				data : fullData,
				type : "POST",
				cache : false,	
				success : function(resData){
					alert("Save successful.");
					$("#Save").removeAttr("disabled");
					$("#Save").html("Save");
				},
				error : function(a,b,c){
					alert(a+"\n"+b+"\n"+c);
				}
			});
		});
	});	
</script>

<script>
	function panelSliding(elm){
		var id = '${UNQID}';
		var mainRow = $(elm).parents(".compassrow"+id);
		if($(mainRow).children().find("#entityLinkAnalysisSerachResultPanel"+id).css("display") != "none"){
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			if($(slidingDiv).hasClass("f-collapsed")){
				$(panelBody).slideDown();
				$(slidingDiv).removeClass('card-collapsed');
				$(slidingDiv).find("i.collapsable").removeClass("fa-chevron-down").addClass("fa-chevron-up");
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideUp();
			}else{
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
			}
		}
	}
	
	function entityTracerLevelSearch(linkedAccountNo, level, accLevel){
		var num = /\d+/;
		var levelIndex = accLevel.match(num); 
		var inputSearchBox = $("li#li"+accLevel).parent().parent().children("div.tab-content").children("div#dashBoardTab"+levelIndex).children().children().children().next().children().children().children("input");
		inputSearchBox.val(linkedAccountNo);
		inputSearchBox.focus();

		var e = $.Event("keyup");
		e.wich = 13;


		inputSearchBox.trigger(e);
		$("li#li"+accLevel).children().click();

	}

	function newEntityTracerSearch(customerName, customerId, accountNo){
		if(confirm("Do you want to search with below parameters ? \nCustomer Id: "+
			customerId+"\nCustomer Name: "+customerName+"\n Account No.: "+accountNo)){

			var fromDate  = $("#fromDate").val();
			var toDate  = $("#toDate").val();			  
			$("#FormFromDate").val(fromDate);
			$("#FormToDate").val(toDate);

			$("#accountNumber").val(accountNo);			  
			$("#CustomerId").val(customerId);
			$("#CustomerName").val(customerName);
			$("#FormAccountNumber").val(accountNo);

			var formObj = $("#entityLinkDetailsForm");
			var formData = (formObj).serialize();
			
			$("#Search, #AdvSearch").attr("disabled","disabled");
			$("#Search, #AdvSearch").html("Searching...");
			$("#entityLinkAnalysisSerachResultPanel"+id).css("display", "block");
			$("#entityLinkTracerModal").modal("hide");
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/getEntityLinkedDetailsTabView",
				cache: false,
				type: "POST",
				data: formData,
				success: function(res) {
					$("#entityLinkAnalysisSerachResult"+id).html(res);
					$("#Search, #AdvSearch").removeAttr("disabled");
					$("#Search, #AdvSearch").html("Show Tab View");
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		}
	}
	
	function newGraphycalEntityTracerSearch(customerName, customerId, accountNo){
		if(confirm("Do you want to search with below parameters ? \nCustomer Id: "+
				customerId+"\nCustomer Name: "+customerName+"\n Account No.: "+accountNo)){

				var fromDate  = $("#fromDate").val();
				var toDate  = $("#toDate").val();			  
				$("#FormFromDate").val(fromDate);
				$("#FormToDate").val(toDate);

				$("#accountNumber").val(accountNo);			  
				$("#CustomerId").val(customerId);
				$("#CustomerName").val(customerName);
				$("#FormAccountNumber").val(accountNo);

				var formObj = $("#entityLinkDetailsForm");
				var formData = (formObj).serialize();
				
				$("#SearchGraph").attr("disabled","disabled");
				$("#SearchGraph").html("Searching...");
				$("#entityLinkAnalysisSerachResultPanel"+id).css("display", "block");
				$("#entityLinkTracerModal").modal("hide");
				
				$.ajax({
					url: "${pageContext.request.contextPath}/common/getEntityLinkedDetailsGraphViewPage",
					cache: false,
					type: "POST",
					data: formData,
					success: function(res) {
						$("#entityLinkAnalysisSerachResult"+id).html(res);
						$("#SearchGraph").removeAttr("disabled");
						$("#SearchGraph").html("Show Graph View");
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}
		}

	function saveForceLink(forceLinkElm, accountNo, linkType, linkedAccountNo, linkedCustId, linkCustName){
		var userComments = prompt("Please enter your comments before saving force link \""+forceLinkElm.value+"\" between \nAccount No: "+accountNo+" and \nAccount No: "+linkedAccountNo);
		//if(confirm("Do you want to save force link \""+forceLinkElm.value+"\" between \nAccount No: "+accountNo+" and \nAccount No: "+linkedAccountNo)){
		if(userComments === ""){	
			alert("Please add comments to save.");
			$("#AdvSearch").click();
			return false; 
		}else if(userComments){
			var fullData = "forceLink="+forceLinkElm.value+"&accountNo="+accountNo+"&linkType="+linkType+"&linkedAccountNo="+linkedAccountNo+"&linkedCustId="+linkedCustId+"&linkCustName="+linkCustName+"&userComments="+userComments;
			 $.ajax({
				 url : "${pageContext.request.contextPath}/common/saveEntityForceLink",
				 data : fullData,
				 type : "POST",
				 cache : false,	
				 success : function(resData){
					 alert("Saved successfully.");
					 $("#AdvSearch").click();
				 },
				 error : function(a,b,c){
					 alert(a+"\n"+b+"\n"+c);
				 }
			 }); 
		}
		else{
			$("#AdvSearch").click();
			return false; 
		}
	}

	function openLinkDetails(strAccountNo, strLinkedAcctNo, strLinkedCustId, strLinkedCustName,strLinkedType) {
		var fromDate  = $(".entityLinkAnalysisFromDate"+id).val();
		var toDate  = $(".entityLinkAnalysisToDate"+id).val();
		if(strLinkedType != 'TRANSACTION') {
			alert('Details of only transaction links are available');
			return false;
		}
		var fullData = "l_strAccountNo="+strAccountNo+"&l_strLinkedAcctNo="+strLinkedAcctNo+"&l_strLinkedCustId="+strLinkedCustId+"&l_strLinkedCustName="+strLinkedCustName+"&l_strLinkedType="+strLinkedType+"&l_strFromDate="+fromDate+"&l_strToDate="+toDate;
		
		$("#compassGenericModal").modal("show");
		$("#compassGenericModal-title").html("Linked Transactions");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getLinkedTransactions",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}

function openCustDetails(strval) {
	var RequestType = '';
	if(strval == 'N.A.') {
		alert('details not available');
		return false;
	}
	var detailPageUrl = "KYCModules/CustomerMaster/CustomerDetails";
	openDetails(this, 'Customer Details', strval,'customerMaster', detailPageUrl);
}

function openAcctDetails(strval) { 
	var RequestType = '';
	if(strval == 'N.A.') {
		alert('details not available');
		return false;
	}
	var detailPageUrl = "MasterModules/AccountsMaster/AccountDetails";
	openDetails(this, 'Account Details', strval,'accountsMaster', detailPageUrl);
}

</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_entityLinkAnalysis">
			<div class="card-header panelSlidingEntityLinkAnalysis${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Entity Link Analysis</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<table class="table table-striped entityLinkAnalysis${UNQID}"  style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="15%">
								From Date
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm datepicker entityLinkAnalysisFromDate${UNQID}" id="FROMDATE_${UNQID}" />
							</td>
							<td>&nbsp;</td>
							<td width="15%">
								To Date
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm datepicker entityLinkAnalysisToDate${UNQID}" id="TODATE_${UNQID}" />
							</td>
						</tr>
						<tr>
							<td>Account Number</td>
							<td>
								<div class="input-group" style="z-index: 1">
									<input type="text" class="form-control input-sm" aria-describedby="basic-addon-ela" id="entityLinkAnalysisAccountNo${UNQID}"/>
									<span class="input-group-addon formSearchIcon" id="basic-addon-entityLinkAnalysisAccountNo${UNQID}" 
										onclick="compassTopFrame.moduleSearch('entityLinkAnalysisAccountNo${UNQID}','ACCOUNTNO','VW_ACCOUNTNO_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
									<i class="fa fa-search"></i>
								</span>
								</div>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" class="btn btn-primary btn-sm" id="Search">Show Tab View</button>
					<div class="btn-group dropup" role="group">
						<button type="button" class="btn btn-primary btn-sm dropdown-toggle" data-toggle="dropdown" aria-expanded="false">
							Show Graph View
							<span class="caret"></span>
						</button>
						<ul class="dropdown-menu" role="menu">
							<li><a href="javascript:void(0)" class= "nav-link SearchGraph" view="H">Horizontal View</a></li>
							<li><a href="javascript:void(0)" class= "nav-link SearchGraph" view="HN">New Horizontal View</a></li>
							<li><a href="javascript:void(0)"  class= "nav-link SearchGraph" view="V">Vertical View</a></li>
							<li><a href="javascript:void(0)"  class= "nav-link SearchGraph" view="VN">New Vertical View</a></li>
						</ul>
					</div>
					<!-- <button type="button" class="btn btn-primary btn-sm" id="SearchGraph">Show Graph View</button> -->
					<button type="button" id="advanceSearch" class="btn btn-success btn-sm" data-toggle="modal" data-target="#entityLinkTracerModal">Advance Search</button>
					<button type="button" id="downloadXLS" class="btn btn-warning btn-sm">Download Excel</button>
					<!-- <button type="button" class="btn btn-primary btn-sm" id="matrixSearch">Matrix Search</button> -->
					<!-- <button type="button" class="btn btn-primary btn-sm" id="linkOnMap">Link On Map</button> -->
				</div>
			</div>
		</div>
		<div class="card card-primary" id="entityLinkAnalysisSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingEntityLinkAnalysis${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Entity Link Analysis Result</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="entityLinkAnalysisSerachResult${UNQID}"></div>
		</div>
	</div>
</div>
	
	<div class="modal fade bs-example-modal-lg" id="entityLinkTracerModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="myModalLabel">Advance Entity Tracer Search</h4>
				</div>
			<form id="entityLinkDetailsForm" method="POST" action="javascript:void(0)">
			<input type="hidden" name="FromDate" id="FormFromDate"/> 
			<input type="hidden" name="ToDate" id="FormToDate"/> 
			<input type="hidden" name="AccountNumber" id="FormAccountNumber"/>
			<div class="modal-body" id="saveReportModalDetails" style="max-height: 300px; overflow-y: auto;">
				 <table id='EntityTracerSearchTable' class='table table-striped table-bordered' style="margin-bottom: 0px;">
				 	<tbody>
				 		<tr>
				 			<td width="15%">Customer Id</td>
				 			<td width="30%">
				 				<input type="text" class="form-control input-sm" id="CustomerId" name="CustomerId" value="<%=customerId%>"/>
				 			</td>
				 			<td width="10%">&nbsp;</td>
				 			<td width="15%">Customer Name</td>
				 			<td width="30%">
								<input type="text" class="form-control input-sm" id="CustomerName" name="CustomerName" value="<%=customerName%>"/>
				 			</td>
				 		</tr>
				 		<tr>
				 			<td colspan="2">
				 			<label class="checkbox-inline">
							  <input type="checkbox" id="StaticLink" name="StaticLink" 
							  <%
							  if(staticLink.equalsIgnoreCase("y")){
								  %>checked<%
							  }
							  %>
							  value="y"> <b>&nbsp;&nbsp;Static Link</b>
							</label>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<label class="checkbox-inline">
							  <input type="checkbox" id="TransactionLink" name="TransactionLink" 
							  <%
							  if(transactionLink.equalsIgnoreCase("y")){
								  %>checked<%
							  }else
								  if(accountNumber.equals("")){
									  %>checked<%
								  }
							  %>
							  value="y"><b> &nbsp;&nbsp;Transaction Link</b>
							</label>
				 			</td>
				 			<td>&nbsp;</td>
				 			<td>Counter Account No</td>
				 			<td>
								<input type="text" class="form-control input-sm" id="CounterAccountNo" value="<%=counterAccountNo%>" name="CounterAccountNo"/>
				 			</td>
				 		</tr>
				 		<tr>
				 			<td>Excluded Product Code</td>
				 			<td colspan="4">
									<input type="text" class="form-control input-sm" id="ProductCode" name="ProductCode" 
									<% if(!userTypeCode.equals("AMLO") && !userTypeCode.equals("MLRO")){ %>
									readonly="readonly"
									<%} %>
									value="<%=productCode%>"/>
				 			</td>
				 		</tr>
				 		<tr>
				 			<td>Minimum Links</td>
				 			<td>
								<input type="text" class="form-control input-sm" id="MinLinks" value="<%=displayMinLinks%>" name="MinLinks"/>
				 			</td>
				 			<td>&nbsp;</td>
				 			<td>Level Count</td>
				 			<td>
								<input type="text" class="form-control input-sm" id="LevelCount" value="<%=displayLevelCount%>" name="LevelCount"/>
				 			</td>
				 		</tr>
				 	</tbody>
				 </table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" class="btn btn-success btn-sm" id="Save"><spring:message code="app.common.saveButton"/></button>
					<button type="button" class="btn btn-primary btn-sm" id="AdvSearch"><spring:message code="app.common.searchButton"/></button>
					<button type="button" class="btn btn-danger btn-sm" data-dismiss="modal"><spring:message code="app.common.closeButton"/></button>
				</div>
			</div>
			</form>
		</div>
		</div>
	</div>
</body>
</html>