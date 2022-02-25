<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
	pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
	String contextPath = request.getContextPath() == null ? "" : request.getContextPath();

	Map<String, List<Map<String, String>>> branchCifType = (Map<String, List<Map<String, String>>>) request.getAttribute("BRANCH_CIFTYPE");

	Map<String, List<Map<String, String>>> checkerMaker = (Map<String, List<Map<String, String>>>) request.getAttribute("CHECKER_MAKER");

	List<Map<String, String>> cases = (List<Map<String, String>>) request.getAttribute("CASES");

	List<Map<String, String>> branchList = branchCifType.get("BRANCH");
	List<Map<String, String>> cifTypeList = branchCifType.get("CIF_TYPE");
	List<Map<String, String>> checker = checkerMaker.get("CHECKER");
	List<Map<String, String>> maker = checkerMaker.get("MAKER");

	String branchCode = request.getAttribute("BRANCH_CODE") != null ? (String) request.getAttribute("BRANCH_CODE") : "";
	String cifType = request.getAttribute("CIF_TYPE") != null ? (String) request.getAttribute("CIF_TYPE") : "";
	String cifNumber = request.getAttribute("CIF_NUMBER") != null ? (String) request.getAttribute("CIF_NUMBER") : "";
	String accountNo = request.getAttribute("ACCOUNT_NO") != null ? (String) request.getAttribute("ACCOUNT_NO") : "";
	String makerCode = request.getAttribute("MAKER") != null ? (String) request.getAttribute("MAKER") : "";
	String checkerCode = request.getAttribute("CHECKER") != null ? (String) request.getAttribute("CHECKER") : "";
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
		$("#reassignCaseTable").DataTable({
			"bSort" : false
		});

		$("form").each(function(){
		     var form = $(this);
			 $("input[type='submit']", form).bind("click keypress", function(){
				$(form).data("callerid", $(this).attr("id"));
			 });
		});

		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });

		 $("#searchCase").keyup(function(){
			 $("#reassignCaseTable_filter input").val(this.value);
			 $("#reassignCaseTable_filter input").keyup();
	 	 });

		 $("#checkAll").click(function(){
			 if($(this).is(":checked")){
				 $("#reassignCaseTable > tbody > tr").each(function(index){
					 $(this).find("td:first > input").prop("checked",true);
				 });
			 }else{
				 $("#reassignCaseTable > tbody > tr").each(function(index){
					 $(this).find("td:first > input").prop("checked",false);
				 });
			 }
		 });
	});
	
	function checkForm(elm){
		var callerid = $(elm).data("callerid");

		if(callerid == "reassign"){
			if($("#SELECTED_MAKKER").val() == ""){
				alert("Select Maker to whom you want to reassign");
				return false;
			}
			if($("#SELECTED_CHECKER").val() == ""){
				alert("Select Checker to whom you want to reassign");
				return false;
			}
		}
		$("#L_BRANCH_CODE").val($("#branchCode").val());
		$("#L_CIF_TYPE").val($("#cifType").val());
		$("#L_CIF_NUMBER").val($("#cifNo").val());
		$("#L_ACCOUNT_NO").val($("#accountNo").val());
		$("#L_MAKER").val($("#MAKER").val());
		$("#L_CHECKER").val($("#CHECKER").val());
		var count = 0;
		var cases = "'";
		$("#reassignCaseTable > tbody > tr").each(function(index){
			var input = $(this).find("td:first > input");
			if($(input).is(":checked")) {
				count++;
				cases = cases + $(input).attr("value") +"','";
			}
		});
		cases = cases + "'";
		$("#L_CASES").val(cases);

		if(count > 0){
			if(confirm("Do you want to "+callerid+" these "+count+" cases"))
				return true;
			else
				return false;
		}else{
			alert("Select case no")
		}

		
	}
</script>
</head>
<body>
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-header">Re-assign CIF to CPU Checker & CPU Maker</div>
				<form action="<%=contextPath%>/checkCasesForReAssign" method="GET">
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
									<option <%=cifType.equals(cifTypeDetails.get("TYPECODE")) ? "selected='selected'" : ""%> value="<%=cifTypeDetails.get("TYPECODE")%>"><%=cifTypeDetails.get("TYPENAME")%></option>
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
									<option <%=makerCode.equals(makerDetails.get("USERCODE")) ? "selected='selected'" : ""%> value="<%=makerDetails.get("USERCODE")%>"><%=makerDetails.get("USERCODE")%></option>
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
									<option <%=checkerCode.equals(checkerDetails.get("USERCODE")) ? "selected='selected'" : ""%> value="<%=checkerDetails.get("USERCODE")%>"><%=checkerDetails.get("USERCODE")%></option>
									<%
									}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="5" style="text-align:center">
								<input type="submit" class="btn btn-primary btn-small" value="Search"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
		</div>
		<%
		if(cases != null){
		%>
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-header">
					Search Result
					<span class="pull-right">
					<%
						if(cases != null && cases.size() > 0){
					%>
						Search: <input type="text" class="input-ovr" id="searchCase">
					<%} %>
					</span>
					</div>
				<%
				if(cases.size() > 0){
					%>
					<form action="<%=contextPath%>/reAssignCIFToCheckerMaker" method="POST" onsubmit="return checkForm(this)">
					<table class="table table-bordered table-stripped" id="reassignCaseTable" style="height : 200px; overflow-y:auto;">
						<thead>
							<tr>
								<th style="text-align:center;">
									<input type="checkbox" id="checkAll"/>
								</th>
								<th>Case No</th>
								<th>CIF No</th>
								<th>CIF Name</th>
								<th>CIF Type</th>
								<th>Maker</th>
								<th>Checker</th>
								<th>Status</th>
								<th>Date</th>
							</tr>
						</thead>
						<tbody>
							<%
							for(int i = 0; i < cases.size() ; i++){
								Map<String, String> map = cases.get(i);
								%>
								<tr>
									<td style="text-align:center;">
										<input type="checkbox" name="case_<%=map.get("CASENO")%>" value="<%=map.get("CASENO")%>"/>
									</td>
									<td><%=map.get("CASENO") != null ? map.get("CASENO") : ""%></td>
									<td><%=map.get("CIF_NO") != null ? map.get("CIF_NO") : ""%></td>
									<td><%=map.get("FULLNAME") != null ? map.get("FULLNAME") : ""%></td>
									<td><%=map.get("CIF_TYPE") != null ? map.get("CIF_TYPE") : ""%></td>
									<td><%=map.get("MAKER") != null ? map.get("MAKER") : ""%></td>
									<td><%=map.get("CHECKER") != null ? map.get("CHECKER") : ""%></td>
									<td><%=map.get("STATUS") != null ? map.get("STATUS") : ""%></td>
									<td><%=map.get("UPDATETIMESTAMP") != null ? map.get("UPDATETIMESTAMP") : ""%></td>
								</tr>
								<%
							}
							%>
						</tbody>
					</table>
					<table class="table table-bordered table-stripped">
						<tr>
							<td>
								Maker
							</td>
							<td>
								<select class="form-control input-sm" name="SELECTED_MAKER" id="SELECTED_MAKER">
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
								<select class="form-control input-sm" name="SELECTED_CHECKER" id="SELECTED_CHECKER">
									<option value="">Select one</option>
									<%
									for(int i = 0; i < checker.size(); i++){
										Map<String, String> checkerDetails = checker.get(i);
									%>
									<option value="<%=checkerDetails.get("USERCODE")%>"><%=checkerDetails.get("USERCODE")%> </option>
									<%
									}
									%>
								</select>
							</td>
						</tr>
						<tr>
							<td colspan="5" style="text-align:center">
								<input type="submit" name="reassign" id="reassign" class="btn btn-primary btn-small" value="Re-assign"/>
								<input type="submit" name="unassign" id="unassign" class="btn btn-primary btn-small" value="Unassign"/>
							</td>
						</tr>
					<table>
					<input type="hidden" name="BRANCH_CODE" id="L_BRANCH_CODE" value=""/>
					<input type="hidden" name="CIF_TYPE" id="L_CIF_TYPE" value=""/>
					<input type="hidden" name="CIF_NUMBER" id="L_CIF_NUMBER" value=""/>
					<input type="hidden" name="ACCOUNT_NO" id="L_ACCOUNT_NO" value=""/>
					<input type="hidden" name="MAKER" id="L_MAKER" value=""/>
					<input type="hidden" name="CHECKER" id="L_CHECKER" value=""/>
					<input type="hidden" name="CASES" id="L_CASES" value=""/>
					</form>
					<%
				}else{
					%>
					No Record Found
					<%
				}
				%>
				</div>
			</div>
		</div>
		<%}%>
	</div>
</div>
</body>
</html>