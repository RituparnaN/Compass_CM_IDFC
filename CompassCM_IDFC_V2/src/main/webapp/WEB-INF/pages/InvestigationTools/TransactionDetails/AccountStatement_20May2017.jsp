<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import="java.io.*,java.sql.*,java.util.*,java.sql.ResultSet,java.text.*,java.text.SimpleDateFormat" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">



    <html>
    	<head>
    	<title>Account Statement</title>
    		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta charset="utf-8">
<!--
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
-->
<meta http-equiv="X-UA-Compatible" content="IE=9" />
<!--[if lt IE 9]>
	<script src="${pageContext.request.contextPath}/includes/scripts/html5shiv.js"></script>
	<script src="${pageContext.request.contextPath}/includes/scripts/html5shiv.min.js"></script>
	<script src="${pageContext.request.contextPath}/includes/scripts/respond.min.js"></script>
<![endif]-->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<!--<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min.js"></script>-->
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min_AccountStatement.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/dataTables.bootstrap.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/FromDateToDateScript.js"></script>
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap-responsive.min.css" />
<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/dataTables.bootstrap.css" />

<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/jquery-ui.css"/>

<script type="text/javascript">
 	var js_fromDate = '';
 	var js_toDate = '';
	 if(js_fromDate == ''){
	    js_fromDate = setFromDate();
	 }

	 if(js_toDate == ''){
	    js_toDate = setToDate();
	 }

	$(document).ready(function(){
		$("#dashBoardTable1").dataTable();

		$( "#fromDate, #toDate" ).datepicker({
			 dateFormat : "mm/dd/yy",
			 changeMonth : true,
			 changeYear : true
		 });
		$( "#fromDate" ).val(js_fromDate);
		$( "#toDate" ).val(js_toDate);
	});	

	function checkForm(){
		var fromDate = $("#fromDate").val();
		var toDate = $("#toDate").val();
		var accountNumber = $("#AccountNumber").val();

		if(fromDate.length < 1 || toDate.length < 1 || accountNumber.length < 1){
			alert("Enter From Date, To Date and Account Number");
			return false;
		}else
			return true;
	}
</script>
	<style type="text/css">
	body{
		font-size:11px;
	}
	#fromDate, #toDate{
		background-image:url("/aml/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
	thead tr th{
		border:1px solid #FFF;
	}
	thead tr{
		background-color:#BBB;
		color : #B31D1D;
	}
</style>
</head>
<body>
<div class="card-body">		<!-- card-body/container -->
	<div class="row" id="searchPanel">
		<div class="col-lg-12">
			<div class="card card-info">
				<div class="card-header">
					Account Statement
				</div>
				<form id="AccountStatementForm" action="/TransactionDetails/Search/AccountStatement.jsp" method="GET" onsubmit="return checkForm()">
					<table class="table table-bordered" style="margin-bottom: 0px;">
						<tr>
							<td width="30%">
								<div class="input-group">
								  <label class="input-group-addon btn-info" for="fromDate" id="basic-addon1">From Date</label>
								  <input value="${FROMDATE}" id="fromDate" name="FROMDATE" type="text" class="form-control input-sm" placeholder="CIF" aria-describedby="basic-addon1" autocomplete="off"/>
								</div>
							</td>
							<td width="30%">
								<div class="input-group">
								  <label class="input-group-addon btn-info" for="toDate" id="basic-addon1">To Date</label>
								  <input value="" id="toDate" name="l_strToDate" type="text" class="form-control input-sm" placeholder="Account Number" aria-describedby="basic-addon1" autocomplete="off"/>
								</div>
							</td>
							<td width="30%">
								<div class="input-group">
								  <label class="input-group-addon btn-info" for="AccountNumber" id="basic-addon1">Account Number</label>
								  <input value="" id="AccountNumber" name="l_strAccountNo" type="text" class="form-control input-sm" placeholder="Account Number" aria-describedby="basic-addon1" autocomplete="off"/>
								</div>
							</td>
							<td width="30%">
								<div class="normalTextField left">
  								  <label class="input-group-addon btn-info" for="SourceSystem" id="basic-addon1">Source System</label>
								  <select name="l_strSourceSystem" id="SourceSystem">
								  <option value="ALL">ALL</option>
								  <option value="FINACLE">FINACLE</option>
								  <option value="CORE">CORE</option>
								  <option value="CREDITCARD">CREDITCARD</option>
								  <option value="DEMAT">DEMAT</option>
								  </select>
								</div>
							</td>
							<td width="8%"><input type="submit" class="btn btn-primary" value="Search"> </td>
						</tr>
					</table>
				</form>
			</div>
		</div>
	</div>
	<div class="row">
		<div class="col-lg-12">
					
		</div>
	</div>
</div>
</body>
</html>