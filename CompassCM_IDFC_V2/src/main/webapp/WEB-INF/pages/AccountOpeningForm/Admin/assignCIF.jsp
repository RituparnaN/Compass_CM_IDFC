<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();

	Map<String, List<Map<String, String>>> branchCifType = (Map<String, List<Map<String, String>>>) request.getAttribute("BRANCH_CIFTYPE");

	Map<String, List<Map<String, String>>> checkerMaker = (Map<String, List<Map<String, String>>>) request.getAttribute("CHECKER_MAKER");
	
	List<Map<String, String>> branchList = branchCifType.get("BRANCH");
	List<Map<String, String>> cifTypeList = branchCifType.get("CIF_TYPE");
	List<Map<String, String>> checker = checkerMaker.get("CHECKER");
	List<Map<String, String>> maker = checkerMaker.get("MAKER");

	String branchCode = request.getAttribute("BRANCH_CODE") != null ? (String) request.getAttribute("BRANCH_CODE") : "";
	String cifType = request.getAttribute("CIF_TYPE") != null ? (String) request.getAttribute("CIF_TYPE") : "";
	String cifNumber = request.getAttribute("CIF_NUMBER") != null ? (String) request.getAttribute("CIF_NUMBER") : "";
	String accountNo = request.getAttribute("ACCOUNT_NO") != null ? (String) request.getAttribute("ACCOUNT_NO") : "";
	String excludeApproved = request.getAttribute("EXCLUDE_APPROVED") != null ? (String) request.getAttribute("EXCLUDE_APPROVED") : "N";	
	String caseCount = request.getAttribute("CASE_COUNT") != null ? (String) request.getAttribute("CASE_COUNT") : "0";

	int count = Integer.parseInt(caseCount);
	int assignedCount = request.getAttribute("ASSIGNED_COUNT") != null ? (Integer) request.getAttribute("ASSIGNED_COUNT") : -1;
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
.datepicker{
	background-image:url("<%=contextPath%>/images/calendar.png");
	background-repeat:no-repeat;
	background-position: 98%;
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
.dataTables_filter{
	display: none;
}
</style>
<script type="text/javascript">
	var calculatedCIF;
	$(document).ready(function(){
		var assignedCount = '<%=assignedCount%>';
		if(parseInt(assignedCount) > -1)
			alert(assignedCount+" cases assigned");

		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		$("#calculateCIF").click(function(){
			var branchCode = $("#branchCode").val();
			var cifType = $("#cifType").val();
			var cifNumber = $("#cifNo").val();
			var accountNo = $("#accountNo").val();
			var excludeApproved = $("#EXCLUDE_APPROVED").is(":checked");
			if(excludeApproved)
				excludeApproved = "Y";
			else
				excludeApproved = "N";
			$("#makerCheckerTR").hide();
			$("#assignTR").hide();
			$("#NUMBER_OF_CASE").val("");
			$("#calculatedCIF").html("Calculating...");
			$.ajax({
				type : "POST",
				url : "<%=contextPath%>/calculateCIFForAssign?BRANCH_CODE="+branchCode+"&CIF_TYPE="+cifType+"&CIF_NUMBER="+cifNumber+"&ACCOUNT_NO="+accountNo+"&EXCLUDE_APPROVED="+excludeApproved,
				cache : false,
				success : function(response){
					calculatedCIF = parseInt(response);
					$("#calculatedCIFTR").show();
					$("#NUMBER_OF_CASE").val("");
					$("#calculatedCIF").html("<strong>"+calculatedCIF+"</strong> CIF can be assigned based on the above parameters");

					if(calculatedCIF > 0){
						if(calculatedCIF < 200)
							$("#NUMBER_OF_CASE").val(calculatedCIF);
						else
							$("#NUMBER_OF_CASE").val("200");

						$("#makerCheckerTR").show();
						$("#assignTR").show();						 
					}else{
						$("#makerCheckerTR").hide();
						$("#assignTR").hide();
					}
				},
				error : function(a,b,c){
					alert("Could not process the request");
				}
			});
		});
		
		$("#fetchStatus").click(function(){
			$.ajax({
				type : "POST",
				url : "<%=contextPath%>/getAccountOpeningMandateFetchStatus",
				cache : false,
				success : function(response){
					var resData = "Status: ";
					if(response.STATUS == 1){
						resData = resData+ "Running. ";
					}else if(response.STATUS == 2){
						resData = resData+ "Completed. ";
					}else{
						resData = resData+ "Not started. ";
					}
					resData = resData + "Count: "+response.COUNT;
					alert(resData);
				},
				error : function(a,b,c){
					alert("Could not process the request");
				}
			});
		});
	});
	
	function openCheckerWindow(caseNo){		
		var myWindow = window.open("<%=contextPath%>/AccountOpeningFormChecker?caseNo="+caseNo,'Account_Opening_Form_Check','height=800,width=1250,resizable=Yes,scrollbars=Yes');
		myWindow.focus();
	}

	function checkForm(){
		var noOfCases = $("#NUMBER_OF_CASE").val();
		var checker = $("#CHECKER").val();
		var maker = $("#MAKER").val();


		if(noOfCases.length == 0){
			alert("Enter no of CIF you want to assign");
			return false;
		}
		if(checker == ""){
			alert("Select a Checker");
			return false;
		}
		if(maker == ""){
			alert("Select a Maker");
			return false;
		}
		return true;
	}
</script>
</head>
<body>
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-header">Assign CIF to CPU Checker & CPU Maker</div>
				<form action="<%=contextPath%>/assignCIFToCheckerMaker" method="POST" onsubmit="return checkForm()">
					<table class="table table-bordered" style="margin-bottom: 0px;">
						<tr>
							<td width="15%">
								Branch
							</td>
							<td width="30%">
								<select class="form-control input-sm" id="branchCode" name="BRANCH_CODE">
									<option value="">ALL</option>
									<%
									for(int i = 0; i < branchList.size(); i++){
										Map<String, String> branchDetails = branchList.get(i);
									%>
									<option <%=branchCode.equals(branchDetails.get("BRANCHCODE")) ? "selected='selected'" : ""%> value="<%=branchDetails.get("BRANCHCODE")%>"><%=branchDetails.get("BRANCHNAME")%></option>
									<%
									}
									%>
								</select>
							</td>
							<td width="10%">
							</td>
							<td width="15%">
								CIF TYPE
							</td>
							<td width="30%">
								<select class="form-control input-sm" name="CIF_TYPE" id="cifType">
									<option value="">ALL</option>
									<%
									for(int i = 0; i < cifTypeList.size(); i++){
										Map<String, String> cifTypeDetails = cifTypeList.get(i);
									%>
									<option <%=cifType.equals(cifTypeDetails.get("TYPECODE")) ? "selected='selected'" : ""%>value="<%=cifTypeDetails.get("TYPECODE")%>"><%=cifTypeDetails.get("TYPENAME")%></option>
									<%
									}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td>
								CIF NUMBER
							</td>
							<td>
								<input type="text" class="form-control input-sm" value="<%=cifNumber%>" name="CIF_NUMBER" id="cifNo"/>
							</td>
							<td>
							</td>
							<td>
								ACCOUNT NUMBER
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" value="<%=accountNo%>" name="ACCOUNT_NO" id="accountNo"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								Exclude Approved Cases : 
								<label for="EXCLUDE_APPROVED">
									<input type="checkbox" <%="Y".equals(excludeApproved) ? "checked='checked'" : ""%> value="Y" name="EXCLUDE_APPROVED" id="EXCLUDE_APPROVED"/> Yes
								</label>
							</td>
							<td colspan="3" style="text-align:center">
								<input type="button" id="calculateCIF" class="btn btn-primary btn-small" value="Search"/>
							</td>
						</tr>
						<tr id="calculatedCIFTR" <% if(count == 0){%>style="display:none;"<%}%>>
							<td>
								No of CIF
							</td>
							<td>
								<input type="text" class="form-control input-sm" value="<%=count > 200 ? "200" : count%>" name="NUMBER_OF_CASE" id="NUMBER_OF_CASE"/>
							</td>
							<td colspan="3" style="text-align:center;" id="calculatedCIF">
								<strong><%=count%></strong> CIF can be assigned based on the above parameters
							</td>
						</tr>
						<tr id="makerCheckerTR" <% if(count == 0){%>style="display:none;"<%}%>>
							<td>
								Maker
							</td>
							<td>
								<select class="form-control input-sm" name="MAKER" id="MAKER">
									<option value="">Select one</option>
									<%
									for(int i = 0; i < maker.size(); i++){
										Map<String, String> makerDetails = maker.get(i);
									%>
									<option value="<%=makerDetails.get("USERCODE")%>"><%=makerDetails.get("USERCODE")%></option>
									<%
									}
									%>
								</select>
							</td>
							<td>
							</td>
							<td>
								Checker
							</td>
							<td width="30%">
								<select class="form-control input-sm" name="CHECKER" id="CHECKER">
									<option value="">Select one</option>
									<%
									for(int i = 0; i < checker.size(); i++){
										Map<String, String> checkerDetails = checker.get(i);
									%>
									<option value="<%=checkerDetails.get("USERCODE")%>"><%=checkerDetails.get("USERCODE")%></option>
									<%
									}
									%>
								</select>
							</td>
						</tr>
						<tr id="assignTR" <% if(count == 0){%>style="display:none;"<%}%>>
							<td colspan="5" style="text-align:center">
								<input type="submit" class="btn btn-primary btn-small" value="Assign"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
</div>
</body>
</html>