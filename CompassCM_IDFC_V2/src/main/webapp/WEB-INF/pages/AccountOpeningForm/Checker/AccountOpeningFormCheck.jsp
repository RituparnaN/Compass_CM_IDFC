<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*, com.quantumdataengines.aml.model.AOFDisabledFiledsMap"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
String accountNo = request.getAttribute("ACCOUNTNO") != null ? (String) request.getAttribute("ACCOUNTNO") : "";
String cifNo = request.getAttribute("CIFNO") != null ? (String) request.getAttribute("CIFNO") : "";
String caseNo = request.getAttribute("CASE_NO") != null ? (String) request.getAttribute("CASE_NO") : "";
String canCheck = request.getAttribute("CAN_CHECK") != null ? (String) request.getAttribute("CAN_CHECK") : "";

String MESSAGE = request.getAttribute("MESSAGE") != null ? (String) request.getAttribute("MESSAGE") : "";
boolean SEARCHDONE = request.getAttribute("SEARCHDONE") != null ? (Boolean) request.getAttribute("SEARCHDONE") : false;
String FORM_SECTION = request.getAttribute("FORM_SECTION") != null ? (String) request.getAttribute("FORM_SECTION") : "";
Map<String, String> allCountries = request.getAttribute("ALLCOUNTRIES") != null ? (Map<String, String>) request.getAttribute("ALLCOUNTRIES") : new HashMap<String, String>();
Iterator<String> countryItr = allCountries.keySet().iterator();

Map<String, String> cifData = (Map<String, String>) request.getAttribute("CIF_DATA");
List<Map<String, String>> jointHolder = (List<Map<String, String>>) request.getAttribute("JOINT_HOLDER");
List<Map<String, String>> uploadData = (List<Map<String, String>>) request.getAttribute("UPLOAD_DATA");
Map<String, List<Map<String, String>>> accountsAndMandates = (Map<String, List<Map<String, String>>>) request.getAttribute("ACCOUNTS_AND_MANDATES");
Map<String, String> FORMSTATUS = (Map<String, String>) request.getAttribute("FORMSTATUS");
List<Map<String, String>> AUDITLOG = (List<Map<String, String>>) request.getAttribute("AUDITLOG");

%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta name="Content-Type" content="txt/html; charset=ISO-8859-1">
<!--[if lt IE 9]>
                <script src="<%=contextPath%>/scripts/html5shiv.js"></script>
                <script src="<%=contextPath%>/scripts/html5shiv.min.js"></script>
                <script src="<%=contextPath%>/scripts/respond.min.js"></script>
<![endif]-->
 
<script type="text/javascript" src="<%=contextPath%>/scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/bootstrap.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/scripts/jquery.dataTables.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/scripts/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-ui.js"></script>

<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap-responsive.min.css" />
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/dataTables.bootstrap.css" />
<link rel="stylesheet" href="<%=contextPath%>/css/jquery-ui.css">
<style type="text/css">
	.card-body{
		margin: 0px 15px;
		padding: 0px;
	}
	.section{
		width: 100%;
		margin: 2px 0 10px 0;
		border: 1px solid #000000;
	}
	.sectionHeader{
		background: gray;
		color: #FFFFFF;
		font-weight: bold;
		font-size: 15px;
		padding: 2px;
		height: 30px;
	}
	.sectionBody{
		padding: 3px;
	}
	.sectionFooter{
		background: gray;
		padding-left: 80%;
		padding-right: 5%;
	}
	ul.inlineUL{
		line-height: 0px;
		margin-bottom: 0px;
		list-style-type: none;
	}
	ul.inlineUL li{
		display: inline;
		padding: 0 5px;
		line-height: 0px;
		margin-bottom: 3px;
	}
	.datepicker{
		background-image:url("<%=contextPath%>/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	input[type=text]{		
		margin: 2px 0;
	}
	select{		
		margin: 2px 0;
	}
	input[type=text].input-ovr {
		text-align: justify;
		padding:2px 5px;
		height: 28px;
		font-size:14px;
		font-weight: normal;
		line-height:1.42857143;
		color:#555;
		border:1px solid #ccc;
		border-radius:4px;
		-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		-webkit-transition:border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
		-o-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s
	}
	#accountHolderDetails{
		overflow: auto;
	}
	#informationPanel{
		overflow: auto;
		margin-top: 2px;
	}
	
	.nav-tabs{
	  background-color: #ACBAE6;
	}
	
	.nav-tabs > li > a{
	  color: #191970 !important;
	}
	
	.nav-tabs > li > a:hover{
	  color: #4B0082 !important;
	}
	
	.fullWidthTable{
		width: 100%;
	}
	
	.card-header{
		font-size: 13px;
		padding: 3px 5px;
		line-height: 20px; 
	}
	.sectionRight{
		color: #F58BB7;
		float: right;
		margin-left: 25%;
	}
	.red{
		color: #E77471;
	}
</style>
<script type="text/javascript">

	var rejectedFileds = "<%=FORMSTATUS.get("REJECTED_SECTION") != null ? FORMSTATUS.get("REJECTED_SECTION") : ""%>";
	var rejectedSection = "";
	
	$(document).ready(function(){
		
		rejectedSection = $("#reasonOfRejection").val();
		
		$("#formStatusTable").DataTable({
			"bLengthChange" : false,
			"bSort" : false
		});
		
		$("div.card-body").keydown(function(e){
			var keycode =  e.keyCode ? e.keyCode : e.which;
		    if(keycode == 8){
		    	if(e.target.isContentEditable)
		    		return true;
		    	else
		    		return false;
		    }
		});
				
		var MESSAGE = '<%=MESSAGE%>';
		if(MESSAGE != ' ')
			alert(MESSAGE);
		
		
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		
		var rejectedFiledsArr = rejectedFileds.split(";");
		var arrayLength = rejectedFiledsArr.length;
		for (var i = 0; i < arrayLength; i++) {
			$('.rejectReason[name="'+rejectedFiledsArr[i]+'"]').prop("checked", true);
			$('.rejectReason[name="'+rejectedFiledsArr[i]+'"]').parent().removeClass("btn-success");
			$('.rejectReason[name="'+rejectedFiledsArr[i]+'"]').parent().addClass("btn-danger");
						
			if(rejectedFiledsArr[i].indexOf("accountSection_") >= 0){
				$("#"+rejectedFiledsArr[i]).removeClass("btn-primary");
				$("#"+rejectedFiledsArr[i]).addClass("btn-danger");
			}
		}
		
		$(".rejectReason").each(function(){
			if(rejectedFileds.indexOf($(this).attr("name")) > 0){
				$(this).prop("checked", true);
				$(this).parent().removeClass("btn-success");
				$(this).parent().addClass("btn-danger");
			}else{
				$(this).prop("checked", false);
				$(this).parent().removeClass("btn-danger");
				$(this).parent().addClass("btn-success");
			}
		});
		
		$(".rejectReason").click(function(){			
			if($(this).prop("checked")){
				$(this).parent().removeClass("btn-success");
				$(this).parent().addClass("btn-danger");
				addReject($(this).attr("name"), $(this).val());
			}else{
				$(this).parent().removeClass("btn-danger");
				$(this).parent().addClass("btn-success");
				removeReject($(this).attr("name"), $(this).val());
			}
			updateReject();
		});
		
		$(".addAccountHolderModal").click(function(){
			var cSector = $(this).attr("cSector");
			var cType = $(this).attr("cType");
			var cCIF = $(this).attr("cCIF");
			var cAccountNo = $(this).attr("cAccountNo");
			var cLineNo = $(this).attr("cLineNo");
			var cCaseNo = '<%=caseNo%>';
			$("#modal-title").html("...");
			$("#accountHolderDetails").html("");
			$('#accountHolderModal').modal('show');
			if(cSector == "BIH"){
				$.ajax({
					type : "GET",
					url : "<%=contextPath%>/checkAccountHolder?type="+cType+"&CIF="+cCIF+"&AccountNo="+cAccountNo+"&LineNo="+cLineNo,
					cache : false,
					success : function(res){
						$("#modal-title").html("BAISC INFORMATION OF "+cType+" ACCOUNT HOLDER");
						$("#accountHolderDetails").html(res);
						$("#accountHolderDetails").css("height",$(window).height()-80);
					},
					error : function(a,b,c){
						$('#accountHolderModal').modal('hide');
						alert("error"+a+"\n"+b+"\n"+c);
					}
				});
			}else if(cSector == "ACC"){
				$.ajax({
					type : "GET",
					url : "<%=contextPath%>/checkAccountNo?CIF="+cCIF+"&AccountNo="+cAccountNo+"&CaseNo="+cCaseNo,
					cache : false,
					success : function(res){
						$("#modal-title").html("ACCOUNT INFORMATION : "+cAccountNo);
						$("#accountHolderDetails").html(res);
						$("#accountHolderDetails").css("height",$(window).height()-80);
					},
					error : function(a,b,c){
						$('#accountHolderModal').modal('hide');
						alert("error"+a+"\n"+b+"\n"+c);
					}
				});
			}else if(cSector == "VAS"){
				$.ajax({
					type : "GET",
					url : "<%=contextPath%>/checkValueAddedService?type="+cType+"&CIF="+cCIF+"&AccountNo="+cAccountNo+"&LineNo="+cLineNo,
					cache : false,
					success : function(res){
						$("#modal-title").html("VALUE ADDED SERVICE "+cType+" ACCOUNT HOLDER");
						$("#accountHolderDetails").html(res);
						$("#accountHolderDetails").css("height",$(window).height()-80);
					},
					error : function(a,b,c){
						$('#accountHolderModal').modal('hide');
						alert("error"+a+"\n"+b+"\n"+c);
					}
				});
			}
		});
		
		 $('input[name=formApprove]').click(function (e) {
			 if(confirm("Are you sure you want to approve?")){
		     	return true;
		     }else{
		    	 return false;
		     }
		  });
		 
		 $('input[name=formReject]').click(function (e) {
			 if(confirm("Are you sure you want to reject?")){
		     	return true;
		     }else{
		    	 return false;
		     }
		  });
		
	});
	
	function viewServerDocument(fileRefNo, accountNo, isServerFile){
		var serverFileWin = window.open('<%=contextPath%>/viewUploadAndServerFile?serverFileRefNo='+fileRefNo+'&accountNo='+accountNo+'&isServerFile='+isServerFile,'AccountOpeningMandate','height=800, width=1200, resizable=Yes, scrollbars=Yes');
		serverFileWin.focus();
	}
	
	function addReject(fields, sections){
		rejectedFileds = rejectedFileds + fields+";";
		rejectedSection = rejectedSection + sections+";\n";
	}
	
	function removeReject(fields, sections){
		rejectedFileds = rejectedFileds.replace(fields+";", "");
		rejectedSection = rejectedSection.replace(sections+";\n", "");
	}
	
	function updateReject(){
		$("#rejectedFileds").val(rejectedFileds);
		$("#reasonOfRejection").val(rejectedSection);
	}
	
	function updateRejectFlag(count, accountNo){
		if(count > 0){
			if(rejectedFileds.indexOf("accountSection_"+accountNo+";") < 0){
				rejectedFileds = rejectedFileds+"accountSection_"+accountNo+";";
			}
			$("#accountSection_"+accountNo).removeClass("btn-primary");
			$("#accountSection_"+accountNo).addClass("btn-danger");
		}else{
			rejectedFileds = rejectedFileds.replace("accountSection_"+accountNo+";", "");
			$("#accountSection_"+accountNo).removeClass("btn-danger");
			$("#accountSection_"+accountNo).addClass("btn-primary");
		}
		updateReject();
	}
</script>

</head>
<body>
<div class="modal fade bs-example-modal-lg" id="accountHolderModal" tabindex="999" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content card-primary">
      <div class="modal-header card-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="modal-title">...</h4>
      </div>
	  <div class="modal-body" id="accountHolderDetails">
      	Loading...
      </div>
    </div>
  </div>
</div>
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active">
					<a class="nav-link active" href="#category1" aria-controls="category1" role="tab" data-toggle="tab">Customer Information</a>
				</li>
				<li role="presentation">
					<a class="nav-link" href="#category2" aria-controls="category2" role="tab" data-toggle="tab">Account Information</a>
				</li>
				<li role="presentation">
					<a class="nav-link" href="#category3" aria-controls="category3" role="tab" data-toggle="tab">Corporate Information</a>
				</li>
				<li role="presentation">
					<a class="nav-link" href="#category6" aria-controls="category6" role="tab" data-toggle="tab">Minor Information</a>
				</li>
				<li role="presentation">
					<a class="nav-link" href="#category4" aria-controls="category4" role="tab" data-toggle="tab">Bank Use</a>
				</li>
				<li role="presentation">
					<a class="nav-link" href="#category5" aria-controls="category5" role="tab" data-toggle="tab">Documents</a>
				</li>
				<li role="presentation">
					<a class="nav-link" href="#category7" aria-controls="category7" role="tab" data-toggle="tab">Checker</a>
				</li>
			</ul>
			<div class="tab-content" id="informationPanel">
				<div role="tabpanel" class="tab-pane active" id="category1">
				    <div class="section">
				    	<div class="sectionHeader">
				    		TYPE OF ACCOUNT OPENING FORM
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table">
				    			<tr>
				    				<td>
				    					<% if("I".equals(cifData.get("CIF_TYPE"))){ %>
				    						Individual
				    					<%} if("J".equals(cifData.get("CIF_TYPE"))){%>
				    						Joint
				    					<%} if("C".equals(cifData.get("CIF_TYPE"))){%>
				    						Public / Private Ltd. Company
				    					<%} if("M".equals(cifData.get("CIF_TYPE"))){%>
				    						Minor
				    					<%} if("SCA".equals(cifData.get("CIF_TYPE"))){%>
				    						Society / Club / Association
				    					<%} if("SPP".equals(cifData.get("CIF_TYPE"))){%>
				    						Sole Proprietorship / Partnership
				    					<%} if("OT".equals(cifData.get("CIF_TYPE"))){%>
				    						Other
				    					<%} %>
				    					&nbsp;&nbsp;(<%=cifData.get("CIF_TYPE_NAME")%>)
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
					</div>
					<div class="section">
				    	<div class="sectionHeader">
				    		BAISC INFORMATION OF ACCOUNT HOLDER/S
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered">
				    			<tr>
				    				<td>
					    				<div class="btn-group">
					    					<label title="Reason for Rejection" class="btn btn-sm btn-success" aria-haspopup="true" aria-expanded="false" for="section1">
										    	<input class="rejectReason" id="section1" name="reject_section1" value="Primary Holder: <%=cifData.get("FULLNAME")%>" type="checkbox" style="line-height: 0px; padding: 0px; margin: 0px;">&nbsp;
										  	</label>
					    					<button type="button" class="btn btn-sm btn-primary addAccountHolderModal" cSector="BIH" cType="PRIMARY" cCIF="<%=cifNo%>" cAccountNo="<%=accountNo%>" cLineNo="0"><%=cifData.get("FULLNAME")%></button>
										</div>	
				    				</td>
				    				<td>
				    					<% for(int i = 0; i < jointHolder.size(); i++){ 
				    						String lineNo = jointHolder.get(i).get("LINE_NO");
				    						String jointHolderName = jointHolder.get(i).get("NAME");
				    					%>
				    					<div class="btn-group">
					    					<label title="Reason for Rejection" class="btn btn-sm btn-success" aria-haspopup="true" aria-expanded="false" for="section2<%=lineNo%>">
										    	<input class="rejectReason" id="section2<%=lineNo%>" name="reject_section2<%=lineNo%>" value="Joint Holder: <%=jointHolderName%>" type="checkbox" style="line-height: 0px; padding: 0px; margin: 0px;">&nbsp;
										  	</label>
					    					<button type="button" class="btn btn-sm btn-primary addAccountHolderModal" cSector="BIH" cType="JOINT" cCIF="<%=cifNo%>" cAccountNo="<%=accountNo%>" cLineNo="<%=lineNo%>"><%=jointHolderName%></button>
										</div>
				    					<% } %>
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
				    </div>
				    <div class="section">
				    	<div class="sectionHeader">
				    		<div class="sectionRight">				    			
				    			<label for="section3" class="btn btn-sm btn-success" title="Reason for Rejection">
				    				<input type="checkbox" class="rejectReason" name="reject_section3" id="section3" value="Customer Information : Existing Account With Amana Bank"/>
				    			</label>
				    		</div>
				    		EXISTING ACCOUNTS MAINTAINED WITH AMANA BANK
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered">
				    			<tr>
				    				<td>
				    					<table width="100%">
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_1")){ %>class="red" <%} %>>Account No</td>
				    							<td><%= cifData.get("EXIST_BANK_ACC_NO_1") != null ? cifData.get("EXIST_BANK_ACC_NO_1") : "" %></td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    							<td>
				    								<% if("SA".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Savings Account
				    								<%}if("CA".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Current Account
				    								<%}if("TD".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Term Deposite
				    								<%}if("OT".equals(cifData.get("EXIST_BANK_ACC_TYPE_1"))){ %>
				    									Other: <%= cifData.get("EXIST_BANK_ACC_TYPE_1_OTR") != null ? cifData.get("EXIST_BANK_ACC_TYPE_1_OTR") : "" %>
				    								<%} %>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    							<td><%= cifData.get("EXIST_BANK_ACC_BRANCH_1") != null ? cifData.get("EXIST_BANK_ACC_BRANCH_1") : "" %></td>
				    						</tr>
				    					</table>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td>
				    					<table width="100%">
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    							<td><%= cifData.get("EXIST_BANK_ACC_NO_2") != null ? cifData.get("EXIST_BANK_ACC_NO_2") : "" %></td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    							<td>
							    					<% if("SA".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Savings Account
							    					<%}if("CA".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Current Account
							    					<%}if("TD".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Term Deposite
							    					<%}if("OT".equals(cifData.get("EXIST_BANK_ACC_TYPE_2"))){ %>
							    						Other: <%= cifData.get("EXIST_BANK_ACC_TYPE_2_OTR") != null ? cifData.get("EXIST_BANK_ACC_TYPE_2_OTR") : "" %>
							    					<%} %>
				    							</td>
				    						</tr>
				    						<tr>
				    							<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_BANK_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    							<td><%= cifData.get("EXIST_BANK_ACC_BRANCH_2") != null ? cifData.get("EXIST_BANK_ACC_BRANCH_2") : "" %></td>
				    						</tr>
				    					</table>
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
				    </div>
				    	<div class="section">
				    		<div class="sectionHeader">
					    		<div class="sectionRight">				    			
					    			<label for="section4" class="btn btn-sm btn-success" title="Reason for Rejection">
					    				<input type="checkbox" class="rejectReason" name="reject_section4" id="section4" value="Customer Information : Existing Account With Other Bank"/>
					    			</label>
				    			</div>
				    			ACCOUNTS HELD IN OTHER BANKS
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_1")){ %>class="red" <%} %>>Account No</td>
				    								<td><%= cifData.get("EXIST_OTHER_ACC_NO_1") != null ? cifData.get("EXIST_OTHER_ACC_NO_1") : "" %></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_1")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
								    					<% if("SA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Savings Account
								    					<%}if("CA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Current Account
								    					<%}if("TD".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Term Deposite
								    					<%}if("OT".equals(cifData.get("EXIST_OTHER_ACC_TYPE_1"))){ %>
								    						Other: <%= cifData.get("EXIST_OTHER_ACC_TYPE_1_OTR") != null ? cifData.get("EXIST_OTHER_ACC_TYPE_1_OTR") : "" %>
								    					<%} %>
					    							</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_1")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><%= cifData.get("EXIST_OTHER_ACC_BRANCH_1") != null ? cifData.get("EXIST_OTHER_ACC_BRANCH_1") : "" %></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_NO_2")){ %>class="red" <%} %>>Account No</td>
				    								<td><%= cifData.get("EXIST_OTHER_ACC_NO_2") != null ? cifData.get("EXIST_OTHER_ACC_NO_2") : "" %></td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_TYPE_2")){ %>class="red" <%} %>>Account Type</td>
				    								<td>
								    					<% if("SA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Savings Account
								    					<%}if("CA".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Current Account
								    					<%}if("TD".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Term Deposite
								    					<%}if("OT".equals(cifData.get("EXIST_OTHER_ACC_TYPE_2"))){ %>
								    						Other: <%= cifData.get("EXIST_OTHER_ACC_TYPE_2_OTR") != null ? cifData.get("EXIST_OTHER_ACC_TYPE_2_OTR") : "" %>
								    					<%} %>
					    							</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("EXIST_OTHER_ACC_BRANCH_2")){ %>class="red" <%} %>>Name of Account Branch</td>
				    								<td><%= cifData.get("EXIST_OTHER_ACC_BRANCH_2") != null ? cifData.get("EXIST_OTHER_ACC_BRANCH_2") : "" %></td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				    	<div class="section">
				    		<div class="sectionHeader">
					    		<div class="sectionRight">				    			
					    			<label for="section5" class="btn btn-sm btn-success" title="Reason for Rejection">
					    				<input type="checkbox" class="rejectReason" name="reject_section5" id="section5" value="Customer Information : Instructions to Bank"/>
					    			</label>
				    			</div>
				    			INSTRUCTIONS TO BANK
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table">
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("INSTRUCTION_TO_BANK")){ %>class="red" <%} %>>
				    						We authorise the Bank to act on instruction given by us by Facsimile message / Email or other similar medium
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<% if("Y".equals(cifData.get("INSTRUCTION_TO_BANK"))){%>
				    							Yes - Duly completed Indemnity form is attached
				    						<%}if("N".equals(cifData.get("INSTRUCTION_TO_BANK"))){%>
				    							No
				    						<%} %>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				</div>
				<div role="tabpanel" class="tab-pane" id="category2">
					<div class="section">
				    	<div class="sectionHeader">
				    		Accounts assigned for Check
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered table-stripped" width="100%">
				    		<%
				    		if(accountsAndMandates != null && accountsAndMandates.size() > 0){
				    			Iterator<String> accountItr = accountsAndMandates.keySet().iterator();
				    			while(accountItr.hasNext()){
				    				String listAccountNo = accountItr.next();
				    				List<Map<String, String>> mandates = accountsAndMandates.get(listAccountNo);
					    				%>
					    				<tr>
					    					<td style="text-align: center;">
					    						<button type="button" id="accountSection_<%=listAccountNo%>" class="btn btn-sm btn-primary addAccountHolderModal" cSector="ACC" cCIF="<%=cifNo%>" cAccountNo="<%=listAccountNo%>" cCaseNo=<%=caseNo%>><%=listAccountNo%></button>
					    					</td>
					    					<td style="text-align: center;">
					    						<% for(int i = 0; i < mandates.size(); i++){
							    					Map<String, String> mandate = mandates.get(i); 
							    				%>
							    					<a class="nav-link" href="javascript:void(0)" onclick="viewServerDocument('<%=mandate.get("SEQ_NO")%>','<%=listAccountNo%>','Y')"><%=mandate.get("FILE_NAME")%></a>
							    					<br/><br/>
							    				<% } %>
					    					</td>
					    				</tr>
					    				<%
				    				}
				    			}
				    		%>
					    	</table>
					    </div>
					</div>
				</div>
				<div role="tabpanel" class="tab-pane" id="category3">
				    <div class="section">
				    		<div class="sectionHeader">
						    	<div class="sectionRight">				    			
						    		<label for="section7" class="btn btn-sm btn-success" title="Reason for Rejection">
						    			<input type="checkbox" class="rejectReason" name="reject_section7" id="section7" value="Corporate Information : Document Checklist"/>
						    		</label>
					    		</div>
				    			DOCUMENT CHECK LIST
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table">
				    				<tr>
				    					<td>
				    						The following documents (duly certified by the Directory / Secretary of the Company) to be
				    						submitted upon verification of originals by the Bank Officer where necessary
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input disabled="disabled" type="checkbox" id="documentCheckList1" name="CORP_AOM_COMPLETED" value="Y" <%if("Y".equals(cifData.get("CORP_AOM_COMPLETED"))){%> checked="checked" <%} %>>
				    						<label for="documentCheckList1" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_AOM_COMPLETED")){ %> class="red" <%} %>>Completed Account opening mandate</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList2" name="CORP_INCROP_CERT_COPY" value="Y" <%if("Y".equals(cifData.get("CORP_INCROP_CERT_COPY"))){%> checked="checked" <%} %>
				    						disabled="disabled" >
				    						<label for="documentCheckList2" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_INCROP_CERT_COPY")){ %> class="red" <%} %>>Certified copy of the Certificate of Incorporation</label>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" id="documentCheckList211" name="COPR_CERT_COPY_TYPE" value="1" <%if("1".equals(cifData.get("COPR_CERT_COPY_TYPE"))){%> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentCheckList211" <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_CERT_COPY_TYPE")){ %> class="red" <%} %>>Re-registered Company : Form 41</label>
				    							</li>
				    							<li>
				    								<input type="radio" id="documentCheckList212" name="COPR_CERT_COPY_TYPE" value="2" <%if("2".equals(cifData.get("COPR_CERT_COPY_TYPE"))){%> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentCheckList212" <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_CERT_COPY_TYPE")){ %> class="red" <%} %>>New Company : Form 2 A</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList3" name="COPR_ART_ASSOC_COMP" value="Y" <%if("Y".equals(cifData.get("COPR_ART_ASSOC_COMP"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList3" <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_ART_ASSOC_COMP")){ %> class="red" <%} %>>Articles of Association of the Company</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList4" name="CORP_RC_FORM" value="Y" <%if("Y".equals(cifData.get("CORP_RC_FORM"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList4" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_RC_FORM")){ %> class="red" <%} %>>Copies of the following forms issued by the Registrar of Companies</label>
				    						<table width="100%">
				    							<tr>
				    								<td>
				    									<input type="radio" id="documentCheckList411" name="CORP_RC_FORM_TYPE" value="1" <%if("1".equals(cifData.get("CORP_RC_FORM_TYPE"))){%> checked="checked" <%} %>
				    									disabled="disabled">
				    									<label for="documentCheckList411">Re-registered Company : Form 48 - Director / Secretary details</label>
				    								</td>
				    								<td>
					    								<input type="radio" id="documentCheckList412" name="CORP_RC_FORM_TYPE" value="2" <%if("2".equals(cifData.get("CORP_RC_FORM_TYPE"))){%> checked="checked" <%} %>
					    								disabled="disabled">
					    								<label for="documentCheckList412">New Company : Certified copy of Form 1 - List of Directors</label>
				    								</td>
				    								<td>
				    									<input type="radio" id="documentCheckList413" name="CORP_RC_FORM_TYPE" value="3" <%if("3".equals(cifData.get("CORP_RC_FORM_TYPE"))){%> checked="checked" <%} %>
				    									disabled="disabled">
				    									<label for="documentCheckList413">Form 20 - If any changes on Directors / Secretary</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList5" name="COPR_COMMRC_BUSS_CERT" value="Y" <%if("Y".equals(cifData.get("COPR_COMMRC_BUSS_CERT"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList5" <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_COMMRC_BUSS_CERT")){ %> class="red" <%} %>>Cerificate to Commence Business (Only for Public Companies)</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList6" name="CORP_BORD_RESOL_CERT" value="Y" <%if("Y".equals(cifData.get("CORP_BORD_RESOL_CERT"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList6" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_BORD_RESOL_CERT")){ %> class="red" <%} %>>Cerified copy of the Board Resolution</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList7" name="CORP_REG_ADDR_COPY_FRM_13_36" value="Y" <%if("Y".equals(cifData.get("CORP_REG_ADDR_COPY_FRM_13_36"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList7" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_REG_ADDR_COPY_FRM_13_36")){ %> class="red" <%} %>>Cerified copy of Form 13/36 - 'Registered Address' issued by the Resistrar  of the Companies</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList8" name="CORP_ADDR_VERF_DOC" value="Y" <%if("Y".equals(cifData.get("CORP_ADDR_VERF_DOC"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList8" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_ADDR_VERF_DOC")){ %> class="red" <%} %>>Copy of Address verification document</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList9" name="CORP_AUTH_SIGNTR_COPY" value="Y" <%if("Y".equals(cifData.get("CORP_AUTH_SIGNTR_COPY"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList9" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_AUTH_SIGNTR_COPY")){ %> class="red" <%} %>>Specimen copy of authorised signatories</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList10" name="COPR_DIR_SIGNTR_NIC_PASPRT" value="Y" <%if("Y".equals(cifData.get("COPR_DIR_SIGNTR_NIC_PASPRT"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList10" <% if(AOFDisabledFiledsMap.isFieldDisabled("COPR_DIR_SIGNTR_NIC_PASPRT")){ %> class="red" <%} %>>Cerified copy of the National Identity card / Valid Passport of Directors and Authorised Signatories</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList11" name="CORP_DIR_SIGNTR_KYC" value="Y" <%if("Y".equals(cifData.get("CORP_DIR_SIGNTR_KYC"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList11" <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_DIR_SIGNTR_KYC")){ %> class="red" <%} %>>KYC Profile Form for Directors and Authorised Signatories</label>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						<input type="checkbox" id="documentCheckList12" name="CORP_OTHER_DOC" value="Y" <%if("Y".equals(cifData.get("CORP_OTHER_DOC"))){%> checked="checked" <%} %>
				    						disabled="disabled">
				    						<label for="documentCheckList12"  <% if(AOFDisabledFiledsMap.isFieldDisabled("CORP_OTHER_DOC")){ %> class="red" <%} %>>
				    							Other : <input type="text" name="CORP_OTHER_DOC_NAME"
				    							class="input-ovr" disabled="disabled"
				    							<%if("Y".equals(cifData.get("CORP_OTHER_DOC"))){%> 
				    								value="<%=cifData.get("CORP_OTHER_DOC_NAME") != null ? cifData.get("CORP_OTHER_DOC_NAME") : ""%>"
				    							<%} %>
				    							/>
				    						</label>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				</div>
				<div role="tabpanel" class="tab-pane" id="category6">
				    <div class="section">
				    	<div class="sectionHeader">
					    	<div class="sectionRight">				    			
						    	<label for="section8" class="btn btn-sm btn-success" title="Reason for Rejection">
						    		<input type="checkbox" class="rejectReason" name="reject_section8" id="section8" value="Minor Information"/>
						    	</label>
					    	</div>
				    		DETAILS OF PARENT / GUARDIAN / INITIATOR
				    	</div>
				    	<div class="sectionBody">
				    		<table class="table table-bordered">
				    			<tr>
				    				<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_RELATN")){ %> class="red" <%} %>>
				    					Relation with Primary Account Holder
				    				</td>
				    				<td>
				    					<%if("1".equals(cifData.get("MNR_GURDN_RELATN"))){%>
				    						Parent
				    					<% }if("2".equals(cifData.get("MNR_GURDN_RELATN"))){%>
				    						Guardian
				    					<% }if("3".equals(cifData.get("MNR_GURDN_RELATN"))){%>
				    						Initiator
				    					<%} %>
				    				</td>
				    			</tr>
					   			<tr>
									<td width="25%" <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TITLE")){ %> class="red" <%} %>>
										Title
									</td>
									<td width="75%">
										<% if("1".equals(cifData.get("MNR_TITLE"))){ %>
											Mr.
										<% }if("2".equals(cifData.get("MNR_TITLE"))){ %>
											Miss.
										<% }%>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_FULLNAME")){ %> class="red" <%} %>>
										Name of the Minor
									</td>
									<td>
										<%= cifData.get("MNR_FULLNAME") != null ? cifData.get("MNR_FULLNAME") : "" %>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_DOB")){ %> class="red" <%} %>>
										Date of Birth
									</td>
									<td>
										<%= cifData.get("MNR_DOB") != null ? cifData.get("MNR_DOB") : "" %>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_BIRTHCERT_NO")){ %> class="red" <%} %>>
										Birth Certificate No
									</td>
									<td>
										<%= cifData.get("MNR_BIRTHCERT_NO") != null ? cifData.get("MNR_BIRTHCERT_NO") : "" %>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_BIRTHCERT_ISS_DATE")){ %> class="red" <%} %>>
										Date of Issue
									</td>
									<td>
										<%= cifData.get("MNR_BIRTHCERT_ISS_DATE") != null ? cifData.get("MNR_BIRTHCERT_ISS_DATE") : "" %>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_NATIONALITY")){ %> class="red" <%} %>>
										Nationality
									</td>
									<td>
										<%
											while(countryItr.hasNext()){
												String countryCode = countryItr.next();
												String countryName = allCountries.get(countryCode);
										%>
											<% if(countryCode.equals(cifData.get("MNR_NATIONALITY"))){ %> <%=countryName%> <%} %>
										<%
											}
										%>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GENDER")){ %> class="red" <%} %>>Gender</td>
									<td>
										<% if("M".equals(cifData.get("MNR_GENDER"))){ %>
											Male
										<% }if("F".equals(cifData.get("MNR_GENDER"))){ %>
											Female
										<%} %>
									</td>
								</tr>
								<tr>
									<td>
										Residential Address
									</td>
									<td>
										<table width="100%">
											<tr>
												<td width="15%"  <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR1")){ %> class="red" <%} %>>AddressLine1</td>
												<td width="85%">
													<%= cifData.get("MNR_ADDR1") != null ? cifData.get("MNR_ADDR1") : ""%>
												</td>
											</tr>
											<tr>
												<td  <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR2")){ %> class="red" <%} %>>AddressLine2</td>
												<td>
													<%= cifData.get("MNR_ADDR2") != null ? cifData.get("MNR_ADDR2") : ""%>
												</td>
											</tr>
											<tr>
												<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_ADDR3")){ %> class="red" <%} %>>AddressLine3</td>
												<td>
													<%= cifData.get("MNR_ADDR3") != null ? cifData.get("MNR_ADDR3") : ""%>
												</td>
											</tr>
										</table>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_TELEPHONE")){ %> class="red" <%} %>>
										Telephone No
									</td>
									<td>
										<%= cifData.get("MNR_TELEPHONE") != null ? cifData.get("MNR_TELEPHONE") : ""%>
									</td>
								</tr>
								<tr>
									<td <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_CORRESPONDENCE")){ %> class="red" <%} %>>
										Correspondence
									</td>
									<td>
										<% if("1".equals(cifData.get("MNR_GURDN_CORRESPONDENCE"))){ %>
											Minor's Res. Address
										<% }if("2".equals(cifData.get("MNR_GURDN_CORRESPONDENCE"))){ %>
											Parent / Guardian / Initiator's Res. Address
										<% }if("3".equals(cifData.get("MNR_GURDN_CORRESPONDENCE"))){ %>
											Parent / Guardian / Initiator's Off. Address
										<%} %>
									</td>
								</tr>
								<tr>
									<td colspan="2" <% if(AOFDisabledFiledsMap.isFieldDisabled("MNR_GURDN_TAX_DECL")){ %> class="red" <%} %>>
										Declaration by Parent / Guardian / Inititator for withholding tax on profit earning
										as required by the Inland Revenue Act 10 of 2007
										<br/>
										<input type="checkbox" value="Y" name="MNR_GURDN_TAX_DECL" id="minorTax" <% if("Y".equals(cifData.get("MNR_GURDN_TAX_DECL"))){ %> checked="checked" <%} %>
										disabled="disabled">
										<label for="minorTax">Declaration attached in order to obtain WHT exemption</label>										
									</td>
								</tr>
				    		</table>
				    	</div>
				    </div>
				</div>
				<div role="tabpanel" class="tab-pane" id="category4">
				    <div class="section">
				    	<div class="sectionHeader">
						    <div class="sectionRight">				    			
						    	<label for="section9" class="btn btn-sm btn-success" title="Reason for Rejection">
						    		<input type="checkbox" class="rejectReason" name="reject_section9" id="section9" value="Bank Use"/>
						    	</label>
					    	</div>
				    			FOR BANK USE ONLY 
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bodered">
				    				<tr>
				    					<td width="25%">Name, Date of Birth and Nationality Verification By</td>
				    					<td width="75%">
				    						<table width="100%">
				    							<tr>
				    								<td width="50%">
				    								<input type="checkbox" name="NDN_VRF_BY_NIC" id="nameDobNationalityVerificationBy1" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_NIC"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="nameDobNationalityVerificationBy1" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_NIC")){ %> class="red" <%} %>>National Identity card</label>
				    								</td>
				    								<td width="50%">
				    								<input type="checkbox" name="NDN_VRF_BY_ARM_FRCE" id="nameDobNationalityVerificationBy2" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_ARM_FRCE"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="nameDobNationalityVerificationBy2" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_ARM_FRCE")){ %> class="red" <%} %>>Official Armed Forces Service card</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_PASSPORT" id="nameDobNationalityVerificationBy3" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_PASSPORT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="nameDobNationalityVerificationBy3" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_PASSPORT")){ %> class="red" <%} %>>Passport / Visa</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_DL" id="nameDobNationalityVerificationBy4" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_DL"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="nameDobNationalityVerificationBy4" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_DL")){ %> class="red" <%} %>>Official Driving License</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_POSTALID" id="nameDobNationalityVerificationBy5" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_POSTALID"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="nameDobNationalityVerificationBy5" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_POSTALID")){ %> class="red" <%} %>>Postal ID (for person under 18 years of age)</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="NDN_VRF_BY_MARIG_CERT" id="nameDobNationalityVerificationBy6" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_MARIG_CERT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="nameDobNationalityVerificationBy6" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_MARIG_CERT")){ %> class="red" <%} %>>Marriage Certificate (for only Name Change purpose)</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    									<input type="checkbox" name="NDN_VRF_BY_BRANCH" id="nameDobNationalityVerificationBy6" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_BRANCH"))){ %> checked="checked" <%} %>
				    									disabled="disabled">
				    									<label for="nameDobNationalityVerificationBy6" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_BRANCH")){ %> class="red" <%} %>>Marriage Certificate (for only Name Change purpose)</label>
				    								</td>
				    								<td>
				    									<input type="checkbox" name="NDN_VRF_BY_OTR" id="nameDobNationalityVerificationBy7" value="Y" <% if("Y".equals(cifData.get("NDN_VRF_BY_OTR"))){ %> checked="checked" <%} %>
				    									disabled="disabled">
						    							<label for="nameDobNationalityVerificationBy7" <% if(AOFDisabledFiledsMap.isFieldDisabled("NDN_VRF_BY_OTR_NAME")){ %> class="red" <%} %>>
						    								Other: <input type="text" name="NDN_VRF_BY_OTR_NAME"  class="input-ovr"
						    								disabled="disabled"
						    								<% if("Y".equals(cifData.get("NDN_VRF_BY_OTR"))){ %>
						    									value="<%= cifData.get("NDN_VRF_BY_OTR_NAME") != null ? cifData.get("NDN_VRF_BY_OTR_NAME") : "" %>"
						    								<%} %>
						    								/>
						    							</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>
				    						Address Verification By
				    					</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td width="50%">
				    								<input type="checkbox" name="ADDR_VERF_UTILITY_BILL" id="addressVerificationBy1" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_UTILITY_BILL"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy1" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_UTILITY_BILL")){ %> class="red" <%} %>>
				    									Utility Bill: <input type="text" name="ADDR_VERF_UTILITY_BILL_NAME"
				    									disabled="disabled"  class="input-ovr"
				    									<% if("Y".equals(cifData.get("ADDR_VERF_UTILITY_BILL"))){ %>
				    										value="<%= cifData.get("ADDR_VERF_UTILITY_BILL_NAME") != null ? cifData.get("ADDR_VERF_UTILITY_BILL_NAME") : "" %>"
				    									<%} %>
				    									/>
				    								</label>
				    								</td>
				    								<td width="50%">
				    								<input type="checkbox" name="ADDR_VERF_BANK_STMNT" id="addressVerificationBy2" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_BANK_STMNT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy2" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_BANK_STMNT")){ %> class="red" <%} %>>Statement of Other Bank</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_TENANCY_AGGR" id="addressVerificationBy3" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_TENANCY_AGGR"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy3" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_TENANCY_AGGR")){ %> class="red" <%} %>>Tenancy Agreement</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_EMP_CONTRACT" id="addressVerificationBy4" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_EMP_CONTRACT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy4" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_EMP_CONTRACT")){ %> class="red" <%} %>>Employment Contract</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_NIC" id="addressVerificationBy5" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_NIC"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy5" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_NIC")){ %> class="red" <%} %>>National Identity card</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_PUB_AUTH_LTTR" id="addressVerificationBy6" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_PUB_AUTH_LTTR"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy6" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_PUB_AUTH_LTTR")){ %> class="red" <%} %>>Letter from a Public Authority</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_INCOM_TAX_RECPT" id="addressVerificationBy7" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_INCOM_TAX_RECPT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy7" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_INCOM_TAX_RECPT")){ %> class="red" <%} %>>Income Tax Receipts / Assessment Notice</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="ADDR_VERF_OTR" id="addressVerificationBy8" value="Y" <% if("Y".equals(cifData.get("ADDR_VERF_OTR"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="addressVerificationBy8" <% if(AOFDisabledFiledsMap.isFieldDisabled("ADDR_VERF_OTR")){ %> class="red" <%} %>>
				    									Other: <input type="text" name="ADDR_VERF_OTR_NAME" 
				    									disabled="disabled"  class="input-ovr"
				    									<% if("Y".equals(cifData.get("ADDR_VERF_OTR"))){ %>
				    										value="<%= cifData.get("ADDR_VERF_OTR_NAME") != null ? cifData.get("ADDR_VERF_OTR_NAME") : "" %>"
				    									<%} %>
				    									/>
				    								</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td>Documents to be obtained</td>
				    					<td>
				    						<table width="100%">
				    							<tr>
				    								<td width="50%">
				    								<input type="checkbox" name="DOC_AOM" id="documentsObtained1" value="Y" <% if("Y".equals(cifData.get("DOC_AOM"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained1" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_AOM")){ %> class="red" <%} %>>Completed Account Opoening Mandate</label>
				    								</td>
				    								<td width="50%">
				    								<input type="checkbox" name="DOC_SIGN_CARD" id="documentsObtained2" value="Y" <% if("Y".equals(cifData.get("DOC_SIGN_CARD"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained2" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_SIGN_CARD")){ %> class="red" <%} %>>Specimen Signature card</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_NIC_PP_DL" id="documentsObtained3" value="Y" <% if("Y".equals(cifData.get("DOC_NIC_PP_DL"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained3" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_NIC_PP_DL")){ %> class="red" <%} %>>Copy of NIC/PP/DL</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_MUDARABA_AGGR" id="documentsObtained4" value="Y" <% if("Y".equals(cifData.get("DOC_MUDARABA_AGGR"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained4" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_MUDARABA_AGGR")){ %> class="red" <%} %>>Signed Mudaraba Agreement</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_MINOR_BIRTH_CERT" id="documentsObtained7" value="Y" <% if("Y".equals(cifData.get("DOC_MINOR_BIRTH_CERT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained7" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_MINOR_BIRTH_CERT")){ %> class="red" <%} %>>Copy of Minor's Birth Certificate</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_NIC_GUARDIAN" id="documentsObtained8" value="Y" <% if("Y".equals(cifData.get("DOC_NIC_GUARDIAN"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained8" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_NIC_GUARDIAN")){ %> class="red" <%} %>>NIC Copy of Parent/Guardian/Initiator</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_REG_CERT" id="documentsObtained9" value="Y" <% if("Y".equals(cifData.get("DOC_REG_CERT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained9" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_REG_CERT")){ %> class="red" <%} %>>Certified copy of the Registration Certificate</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_RULES_CONSTITUTION" id="documentsObtained10" value="Y" <% if("Y".equals(cifData.get("DOC_RULES_CONSTITUTION"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained10" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_RULES_CONSTITUTION")){ %> class="red" <%} %>>Certified copy of Rules / Constitution</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_OFF_BEARERS_MEET_EXTRCT" id="documentsObtained11" value="Y" <% if("Y".equals(cifData.get("DOC_OFF_BEARERS_MEET_EXTRCT"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained11" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_OFF_BEARERS_MEET_EXTRCT")){ %> class="red" <%} %>>Certified copy of the extracts of the meeting minutes where Office Bearers were elected</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_ACC_OPEN_RESOL_MEET" id="documentsObtained12" value="Y" <% if("Y".equals(cifData.get("DOC_ACC_OPEN_RESOL_MEET"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained12" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_ACC_OPEN_RESOL_MEET")){ %> class="red" <%} %>>Copy of the minutes of the meeting where it was resolved to open an account with Amana Bank</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_KYC" id="documentsObtained13" value="Y" <% if("Y".equals(cifData.get("DOC_KYC"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained13" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_KYC")){ %> class="red" <%} %>>KYC Form</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_BUSS_REG" id="documentsObtained14" value="Y" <% if("Y".equals(cifData.get("DOC_BUSS_REG"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained14" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_BUSS_REG")){ %> class="red" <%} %>>Copy of Business Registration</label>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td>
				    								<input type="checkbox" name="DOC_ADDR_VERF_COPY" id="documentsObtained5" value="Y" <% if("Y".equals(cifData.get("DOC_ADDR_VERF_COPY"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained5" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_ADDR_VERF_COPY")){ %> class="red" <%} %>>Copy of Address Verification Document</label>
				    								</td>
				    								<td>
				    								<input type="checkbox" name="DOC_OTHER" id="documentsObtained6" value="Y" <% if("Y".equals(cifData.get("DOC_OTHER"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="documentsObtained6" <% if(AOFDisabledFiledsMap.isFieldDisabled("DOC_OTHER")){ %> class="red" <%} %>>
				    									Other: <input type="text" name="DOC_OTHER_NANE" disabled="disabled" class="input-ovr"
				    									<% if("Y".equals(cifData.get("DOC_OTHER"))){ %>
				    										value="<%= cifData.get("DOC_OTHER_NANE") != null ? cifData.get("DOC_OTHER_NANE") : "" %>"
				    									<%} %>
				    									/>
				    								</label>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CLIENT_BLACK_LISTED")){ %> class="red" <%} %>>
				    						Does the client/s appear in any know suspected terrorist list or any other alert list
				    					</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="CLIENT_BLACK_LISTED" id="clientInBlackListY" value="Y" <% if("Y".equals(cifData.get("CLIENT_BLACK_LISTED"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="clientInBlackListY">Yes</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="CLIENT_BLACK_LISTED" id="clientInBlackListN" value="N" <% if("N".equals(cifData.get("CLIENT_BLACK_LISTED"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="clientInBlackListN">No</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CIF_PRIORITY")){ %> class="red" <%} %>>Priority</td>
				    					<td>
				    						<ul class="inlineUL">
				    							<li>
				    								<input type="radio" name="CIF_PRIORITY" id="priority1" value="1" <% if("1".equals(cifData.get("CIF_PRIORITY"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="priority1">Ordinary</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="CIF_PRIORITY" id="priority2" value="2" <% if("2".equals(cifData.get("CIF_PRIORITY"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="priority2">Prime</label>
				    							</li>
				    							<li>
				    								<input type="radio" name="CIF_PRIORITY" id="priority3" value="3" <% if("3".equals(cifData.get("CIF_PRIORITY"))){ %> checked="checked" <%} %>
				    								disabled="disabled">
				    								<label for="priority3">VIP</label>
				    							</li>
				    						</ul>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BANK_USER_CIF_TYPE")){ %> class="red" <%} %>>CIF Type</td>
				    					<td>
				    						<%= cifData.get("BANK_USER_CIF_TYPE") != null ? cifData.get("BANK_USER_CIF_TYPE") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ECO_SECTOR")){ %> class="red" <%} %>>Economic Sector</td>
				    					<td>
				    						<%= cifData.get("ECO_SECTOR") != null ? cifData.get("ECO_SECTOR") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ECO_SUB_SECTOR")){ %> class="red" <%} %>>Economic Sub Sector</td>
				    					<td>
				    						<%= cifData.get("ECO_SUB_SECTOR") != null ? cifData.get("ECO_SUB_SECTOR") : "" %>
				    						<br/>
				    						<%= cifData.get("NATURE_OF_BUSINESS") != null ? cifData.get("NATURE_OF_BUSINESS") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("DEVISION_CODE")){ %> class="red" <%} %>>Division</td>
				    					<td>
				    						<%= cifData.get("DEVISION_CODE") != null ? cifData.get("DEVISION_CODE") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("DEPT_CODE")){ %> class="red" <%} %>>Department</td>
				    					<td>
				    						<%= cifData.get("DEPT_CODE") != null ? cifData.get("DEPT_CODE") : "" %>
				    					</td>
				    				</tr>
				    				<tr>
				    					<td <% if(AOFDisabledFiledsMap.isFieldDisabled("ACCOUNT_TYPE")){ %> class="red" <%} %>>Account Type</td>
				    					<td>
				    						<%= cifData.get("ACCOUNT_TYPE") != null ? cifData.get("ACCOUNT_TYPE") : "" %>
				    					</td>
				    				</tr>
				    				<!-- 
				    				<tr>
				    					<td>For Branch Approval</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="30%" <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_DATE")){ %> class="red" <%} %>>Account Opened On</td>
				    								<td width="70%">
				    									<%= cifData.get("BRNCH_APPROVL_ACC_OPND_DATE") != null ? cifData.get("BRNCH_APPROVL_ACC_OPND_DATE") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_ACC_OPND_BY")){ %> class="red" <%} %>>Account Opened By</td>
				    								<td>
				    									<%= cifData.get("BRNCH_APPROVL_ACC_OPND_BY") != null ? cifData.get("BRNCH_APPROVL_ACC_OPND_BY") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUTH_OFF")){ %> class="red" <%} %>>Authorised Officer</td>
				    								<td>
				    									<%= cifData.get("BRNCH_APPROVL_AUTH_OFF") != null ? cifData.get("BRNCH_APPROVL_AUTH_OFF") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("BRNCH_APPROVL_AUDT_OFF")){ %> class="red" <%} %>>Audited By</td>
				    								<td>
				    									<%= cifData.get("BRNCH_APPROVL_AUDT_OFF") != null ? cifData.get("BRNCH_APPROVL_AUDT_OFF") : "" %>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    				 -->
				    				<tr>
				    					<td>For Central Operation</td>
				    					<td>
				    						<table class="table table-bordered">
				    							<tr>
				    								<td width="30%" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_RECV_DATE")){ %> class="red" <%} %>>Received Date</td>
				    								<td width="70%">
				    									<%= cifData.get("CPU_OP_RECV_DATE") != null ? cifData.get("CPU_OP_RECV_DATE") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td colspan="2">
				    									<table width="100%">
				    										<tr>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_CIF_COMPLETED" id="cpuCifCompleted" value="Y" <% if("Y".equals(cifData.get("CPU_OP_CIF_COMPLETED"))){ %> checked="checked" <%} %>
				    												disabled="disabled">
				    												<label for="cpuCifCompleted" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_CIF_COMPLETED")){ %> class="red" <%} %>>CIF Completed</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_DOC_CHECKED" id="cpuDocumentsChecked" value="Y" <% if("Y".equals(cifData.get("CPU_OP_DOC_CHECKED"))){ %> checked="checked" <%} %>
				    												disabled="disabled">
				    												<label for="cpuDocumentsChecked" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_DOC_CHECKED")){ %> class="red" <%} %>>Documents Checked</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_STANDING_ORDER_SETUP" id="cpuStandingOrdersSetup" value="Y" <% if("Y".equals(cifData.get("CPU_OP_STANDING_ORDER_SETUP"))){ %> checked="checked" <%} %>
				    												disabled="disabled">
				    												<label for="cpuStandingOrdersSetup" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_STANDING_ORDER_SETUP")){ %> class="red" <%} %>>Standing Orders Setup</label>
				    											</td>
				    										</tr>
				    										<tr>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_MANDATE_COMPLETED" id="cpuMandatesCompleted" value="Y" <% if("Y".equals(cifData.get("CPU_OP_MANDATE_COMPLETED"))){ %> checked="checked" <%} %>
				    												disabled="disabled">
				    												<label for="cpuMandatesCompleted" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_MANDATE_COMPLETED")){ %> class="red" <%} %>>Mandates Completed</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_SIGN_SCANNED" id="cpuSignatureScanned" value="Y" <% if("Y".equals(cifData.get("CPU_OP_SIGN_SCANNED"))){ %> checked="checked" <%} %>
				    												disabled="disabled">
				    												<label for="cpuSignatureScanned" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_SIGN_SCANNED")){ %> class="red" <%} %>>Signature Scanned</label>
				    											</td>
				    											<td>
				    												<input type="checkbox" name="CPU_OP_STATEMENT_SETUP" id="cpuStatementSetup" value="Y" <% if("Y".equals(cifData.get("CPU_OP_STATEMENT_SETUP"))){ %> checked="checked" <%} %>
				    												disabled="disabled">
				    												<label for="cpuStatementSetup" <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_STATEMENT_SETUP")){ %> class="red" <%} %>>Statement Setup</label>
				    											</td>
				    										</tr>
				    									</table>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_DATA_INPUT_BY")){ %> class="red" <%} %>>Data Input By</td>
				    								<td>
				    									<%= cifData.get("CPU_OP_DATA_INPUT_BY") != null ? cifData.get("CPU_OP_DATA_INPUT_BY") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTH_OFF1")){ %> class="red" <%} %>>Authorised Officer</td>
				    								<td>
				    									<%= cifData.get("CPU_OP_AUTH_OFF1") != null ? cifData.get("CPU_OP_AUTH_OFF1") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTH_OFF2")){ %> class="red" <%} %>>Authorised Officer</td>
				    								<td>
				    									<%= cifData.get("CPU_OP_AUTH_OFF2") != null ? cifData.get("CPU_OP_AUTH_OFF2") : "" %>
				    								</td>
				    							</tr>
				    							<tr>
				    								<td <% if(AOFDisabledFiledsMap.isFieldDisabled("CPU_OP_AUTD_OFF")){ %> class="red" <%} %>>Audited By</td>
				    								<td>
				    									<%= cifData.get("CPU_OP_AUTD_OFF") != null ? cifData.get("CPU_OP_AUTD_OFF") : "" %>
				    								</td>
				    							</tr>
				    						</table>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				</div>
				<div role="tabpanel" class="tab-pane" id="category5">
				    <div class="section">
				    		<div class="sectionHeader">
						    	<div class="sectionRight">				    			
						    		<label for="section10" class="btn btn-sm btn-success" title="Reason for Rejection">
						    			<input type="checkbox" class="rejectReason" name="reject_section10" id="section10" value="Document Upload"/>
						    		</label>
					    		</div>
				    			DOCUMENTS
				    		</div>
				    		<div class="sectionBody">
				    			<table class="table table-bordered">
				    				<tr>
				    					<td>
				    						Uploaded files
				    					</td>
				    					<td>
				    						<%
				    						if(uploadData != null && uploadData.size() > 0){
				    							%>
				    							<table class="table table-bordered">
				    							<tr>
				    								<th>Document Name</th>
				    								<th>File Name</th>
				    								<th>Uploaded By</th>
				    								<th>Uploaded on</th>
				    								<th>Download</th>
				    							</tr>
				    							<%
				    							for(int i = 0; i < uploadData.size(); i++){
				    								Map<String, String> upload = uploadData.get(i);
				    								%>
				    								<tr>
				    									<td><%=upload.get("DOC_NAME") != null ? upload.get("DOC_NAME") : ""%></td>
				    									<td><%=upload.get("FILENAME") != null ? upload.get("FILENAME") : ""%></td>
				    									<td><%=upload.get("UPLOADBY") != null ? upload.get("UPLOADBY") : ""%></td>
				    									<td><%=upload.get("UPLOADTIME") != null ? upload.get("UPLOADTIME") : ""%></td>
				    									<td>
				    										<a class="nav-link" href="javascript:void(0)" onclick="viewServerDocument('<%=upload.get("UPLOAD_REF_NO")%>','<%=accountNo%>','N')">View</a>
				    									</td>
				    								</tr>
				    								<%
				    							}
				    							%>
				    							</table>
				    							<%
				    						}
				    						%>
				    					</td>
				    				</tr>
				    			</table>
				    		</div>
				    	</div>
				</div>
				<div role="tabpanel" class="tab-pane" id="category7">
					<form action="<%= contextPath%>/saveCheckerAction" method="POST">
					<div class="section">
				    	<div class="sectionHeader">
				    		Checker Response
				    	</div>
				    	<div class="sectionBody">
				    		<input type="hidden" value="<%=caseNo%>" name="caseNo"/>
				    		<table class="table table-bordered">
				    			<tr>
				    				<td>CIF Number</td>
				    				<td>
				    					<%=cifNo%>
				    					<input type="hidden" value="<%=cifNo%>" name="cifNumber"/>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td>Account Number</td>
				    				<td>
				    					<%=accountNo%>
				    					<input type="hidden" value="<%=accountNo%>" name="accNumber"/>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td>Last Modified By</td>
				    				<td><%=FORMSTATUS.get("DATA_UPDATED_BY") != null ? FORMSTATUS.get("DATA_UPDATED_BY") : ""%></td>
				    			</tr>
				    			<tr>
				    				<td>Last Modify time</td>
				    				<td><%=FORMSTATUS.get("DATA_UPDATE_TIMESTAMP") != null ? FORMSTATUS.get("DATA_UPDATE_TIMESTAMP") : ""%></td>
				    			</tr>
				    			<tr>
				    				<td>Last Remarks</td>
				    				<td><%=FORMSTATUS.get("REMARKS") != null ? FORMSTATUS.get("REMARKS") : ""%></td>
				    			</tr>
				    			<tr>
				    				<td>Status</td>
				    				<td><%=FORMSTATUS.get("STATUS") != null ? FORMSTATUS.get("STATUS") : ""%></td>
				    			</tr>
				    			<tr>
				    				<td>Checked By</td>
				    				<td><%=FORMSTATUS.get("DATA_CHECKED_BY") != null ? FORMSTATUS.get("DATA_CHECKED_BY") : ""%></td>
				    			</tr>
				    			<tr>
				    				<td>Checked time</td>
				    				<td><%=FORMSTATUS.get("DATA_CHECK_TIMESTAMP") != null ? FORMSTATUS.get("DATA_CHECK_TIMESTAMP") : ""%></td>
				    			</tr>
				    			<tr>
				    				<td>Reason of rejection (if rejecting)</td>
				    				<td>
				    					<input type="hidden" name="rejectedFileds" id="rejectedFileds" />
				    					<textarea class="form-control" name="reasonOfRejection" id="reasonOfRejection"><%=FORMSTATUS.get("DETAILS_REASON") != null ? FORMSTATUS.get("DETAILS_REASON") : ""%></textarea>
				    				</td>
				    			</tr>
				    			<tr>
				    				<td>Remarks</td>
				    				<td>
				    					<textarea class="form-control" name="remark"><%=FORMSTATUS.get("REMARKS") != null ? FORMSTATUS.get("REMARKS") : ""%></textarea>
				    				</td>
				    			</tr>
				    		</table>
				    	</div>
				    	<% if(canCheck.equals("Y")){ %>
				    	<div class="sectionFooter">
				    		<input name="formApprove" type="submit" value="Approve" class="btn btn-success"/>
				    		<input name="formReject" type="submit" value="Reject" class="btn btn-danger"/>
				    	</div>
				    	<% } %>
				    </div>
				    </form>
				    <% if(AUDITLOG != null && AUDITLOG.size() > 0){ %>
				    <div class="row" style="margin-left: 0px">
				    	<div class="col-lg-12">
							<div class="card card-primary">
								<div class="card-body">
								    <table class="table table-bordered table-stripped" id="formStatusTable">
										<thead>
											<tr>
												<th>CIF No</th>
												<th>Account No</th>
												<th>Status</th>
												<th>Message</th>
												<th>Updated by</th>
												<th>Updated on</th>
											</tr>
										</thead>
										<tbody>
											<%
											for(int i = 0; i < AUDITLOG.size() ; i++){
												Map<String, String> map = AUDITLOG.get(i);
												%>
												<tr>
													<td><%=map.get("CIF_NO") != null ? map.get("CIF_NO") : ""%></td>
													<td><%=map.get("ACCOUNT_NO") != null ? map.get("ACCOUNT_NO") : ""%></td>
													<td><%=map.get("STATUS") != null ? map.get("STATUS") : ""%></td>
													<td><%=map.get("MESSAGE") != null ? map.get("MESSAGE") : ""%></td>
													<td><%=map.get("UPDATEDBY") != null ? map.get("UPDATEDBY") : ""%></td>
													<td><%=map.get("UPDATETIMESTAMP") != null ? map.get("UPDATETIMESTAMP") : ""%></td>
												</tr>
												<%
											}
											%>
										</tbody>
									</table>
				    			</div>
				    		</div>
				    	</div>
				     </div>
				    <%} %>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</HTML>