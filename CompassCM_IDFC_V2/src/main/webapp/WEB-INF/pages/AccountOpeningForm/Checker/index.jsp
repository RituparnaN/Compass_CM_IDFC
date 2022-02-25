<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();
	String search = (String) request.getAttribute("SEARCH");
	List<Map<String, String>> formStatus = (List<Map<String, String>>) request.getAttribute("FORMSTATUS");
	String fromDate = request.getAttribute("FROMDATE") != null ? (String) request.getAttribute("FROMDATE") : "";
	String toDate = request.getAttribute("TODATE") != null ? (String) request.getAttribute("TODATE") : "";
	String status = request.getAttribute("STATUS") != null ? (String) request.getAttribute("STATUS") : "";
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
	$(document).ready(function(){
		$("#formStatusTable").DataTable({
			"bLengthChange" : false,
			"bSort" : false
		});
		
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
		
		$("#searchAOF").keyup(function(){
			 $("#formStatusTable_filter input").val(this.value);
			 $("#formStatusTable_filter input").keyup();
	 	 });
		
		$("#fetchAOF").click(function(){
			$.ajax({
				type : "POST",
				url : "<%=contextPath%>/fetchAccountOpeningMandateFiles",
				cache : false,
				success : function(response){
					alert(response);
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
</script>
</head>
<body>
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-header">Search Forms Status</div>
				<form id="AccountOpeningForm" action="<%=contextPath%>/viewAOFCheckerStatus" method="GET">
					<table class="table table-bordered" style="margin-bottom: 0px;">
						<tr>
							<td width="45%">
								<div class="input-group">
									<label class="input-group-addon btn-info" for="fromData" id="basic-addon1">From Date</label> 
									<input id="fromData" name="fromDate" type="text" class="form-control input-sm datepicker" placeholder="From Date"
										aria-describedby="basic-addon1" autocomplete="off" value="<%=fromDate%>"/>
										
									<label class="input-group-addon btn-info" for="toDate" id="basic-addon1">To Date</label> 
									<input id="toDate" name="toDate" type="text" class="form-control input-sm datepicker" placeholder="To Date"
										aria-describedby="basic-addon1" autocomplete="off" value="<%=toDate%>" />
								</div>
							</td>
							<td width="45%">
								<div class="input-group">
									<label class="input-group-addon btn-info" for="status" id="basic-addon1">Status</label> 
									<select class="form-control input-sm" aria-describedby="basic-addon1" id="status" name="status">
										<option value="U" <% if(status.equals("U")){ %> selected="selected" <%} %>>Not Submitted</option>
										<option value="P" <% if(status.equals("P") || "".equals(status)){ %> selected="selected" <%} %>>Pending</option>
										<option value="A" <% if(status.equals("A")){ %> selected="selected" <%} %>>Approved</option>
										<option value="R" <% if(status.equals("R")){ %> selected="selected" <%} %>>Rejected</option>
									</select>
								</div>
							</td>
							<td width="10%"><input type="submit" class="btn btn-primary btn-sm" value="Search"></td>
						</tr>
						<tr>
							<td colspan="3">
								<table width="100%">
									<tr>
										<td width="50%" style="text-align: right;">
											<input type="button" id="fetchAOF" class="btn btn-success btn-sm" value="Fetch AOF Mandate" style="margin-right: 2px;">
										</td>
										<td width="50%" style="text-align: left;">
											<input type="button" id="fetchStatus" class="btn btn-info btn-sm" value="Fetch Status" style="margin-left: 2px;"/>
										</td>
									</tr>
								</table>							
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	
	<%
		if("1".equals(search)){
	%>
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-header">
						Forms Status
					<span class="pull-right">
					<%
						if(formStatus != null && formStatus.size() > 0){
					%>
						Search: <input type="text" class="input-ovr" id="searchAOF">
					<%} %>
					</span>
				</div>
	<%
			if(formStatus != null && formStatus.size() > 0){
	%>
		<table class="table table-bordered table-stripped" id="formStatusTable">
			<thead>
				<tr>
					<th>Case No/th>
					<th>CIF No</th>
					<th>Account No</th>
					<th>Update time</th>
					<th>Status</th>
					<th>Open</th>
				</tr>
			</thead>
			<tbody>
				<%
				for(int i = 0; i < formStatus.size() ; i++){
					Map<String, String> map = formStatus.get(i);
					%>
					<tr>
						<td><%=map.get("CASE_NO") != null ? map.get("CASE_NO") : ""%></td>
						<td><%=map.get("CIF_NO") != null ? map.get("CIF_NO") : ""%></td>
						<td><%=map.get("ACCOUNT_NO") != null ? map.get("ACCOUNT_NO") : ""%></td>
						<td><%=map.get("DATA_UPDATE_TIMESTAMP")%></td>
						<td><%=map.get("STATUS")%></td>
						<td><a class="nav-link" href="javascript:void(0)" onclick="openCheckerWindow('<%=map.get("CASE_NO")%>')">Open</a></td>
					</tr>
					<%
				}
				%>
			</tbody>
		</table>
	<%
			}else{
			%>
			<br/><br/><center>No record found</center><br/>
			<%	
			}
	%>
			</div>
		</div>
	</div>
	<%
		} 
	%>
</div>
</body>
</html>