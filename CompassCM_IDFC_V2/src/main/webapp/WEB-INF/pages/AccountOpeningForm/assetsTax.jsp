<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String userID = request.getAttribute("userID") != null ? (String) request.getAttribute("userID") : "";
String accountHolderType = request.getParameter("type");
%>
<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>ADD ASSETS AND TAX</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<!--[if lt IE 9]>
	<script src="<%=contextPath%>/scripts/html5shiv.js"></script>
	<script src="<%=contextPath%>/scripts/html5shiv.min.js"></script>
	<script src="<%=contextPath%>/scripts/respond.min.js"></script>
<![endif]-->

<script type="text/javascript" src="<%=contextPath%>/js/jquery-1.9.1.min.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/jquery-ui.js"></script>
<script type="text/javascript" src="<%=contextPath%>/js/bootstrap.js"></script>
<link rel="stylesheet" type="text/css" href="<%=contextPath%>/css/bootstrap.min.css"/>
<link rel="stylesheet" href="<%=contextPath%>/css/jquery-ui.css">
<style type="text/css">
	.section{
		width: 100%;
		margin: 2px 0 10px 0;
		border: 1px solid #000000;
	}
	.sectionHeader{
		background: #C1FBB9;
		color: #000000;
		font-size: 15px;
		padding: 2px;
	}
	.sectionFooter{
		background: gray;
		padding-left: 50%;
	}
	ul.inlineUL{
		line-height: 0px;
		margin-bottom: 0px;
	}
	ul.inlineUL li{
		display: table-cell;
		padding: 0 5px;
		line-height: 0px;
		margin-bottom: 0px;
	}
	.datepicker{
		background-image:url("<%=contextPath%>/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("#cifno").focus();
		
		$(".datepicker").datepicker({
			 dateFormat : "mm/dd/yy",
			 changeMonth: true,
		     changeYear: true
		 });
	});
</script>
</head>
<body>
<div class="card-body">
	<div class="row">
		<div class="col-lg-12">
			<div class="card card-default">
				<div class="card-header">
				<div class="row">
				  <div class="col-lg-12">
				  	<i class="fa fa-bar-chart-o fa-fw"></i>ASSETS AND TAX DECLARATION <%=accountHolderType%> ACCOUNT HOLDER
				  </div>
				</div>
				</div>
				<div class="card-body">
					<table class="table table-bordered table-stripped">
						<tbody>
							<tr>
								<td width="25%">
									Assets held by the Account Holder & their Market Value
								</td>
								<td width="75%">
									<table>
										<tr>
											<td>
												<input type="checkbox" name="assets1" id="assets1" value="assets1">
												<label for="assets1">Residential Property</label>
											</td>
											<td>
												Rs. <input type="text" name="assets1Value">
											</td>
										</tr>
										<tr>
											<td>
												<input type="checkbox" name="assets2" id="assets2" value="assets2">
												<label for="assets2">Motor Vehicles</label>
											</td>
											<td>
												Rs. <input type="text" name="assets2Value">
											</td>
										</tr>
										<tr>
											<td>
												<input type="checkbox" name="assets3" id="assets3" value="assets3">
												<label for="assets3">Land and Buildings</label>
											</td>
											<td>
												Rs. <input type="text" name="assets3Value">
											</td>
										</tr>
										<tr>
											<td>
												<input type="checkbox" name="assets4" id="assets4" value="assets4">
												<label for="assets4">Investments / Shares</label>
											</td>
											<td>
												Rs. <input type="text" name="assets4Value">
											</td>
										</tr>
										<tr>
											<td>
												<input type="checkbox" name="assets5" id="assets5" value="assets5">
												<label for="assets5">
													Other : <input type="text" name="assets5Name">
												</label>
											</td>
											<td>
												Rs. <input type="text" name="assets5Value">
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									Are you a Tax Payer?
								</td>
								<td>
									<ul class="inlineUL">
										<li>
											<input type="radio" name="taxPayer" id="taxPayerN" value="N">
											<label for="taxPayerN">No</label>
										</li>
										<li>
											<input type="radio" name="taxPayer" id="taxPayerY" value="Y">
											<label for="taxPayerY">Yes</label>
											<br/>
											Income Tax File No : <input type="text" name="taxFileNo"/>
										</li>
									</ul>
								</td>
							</tr>
							<tr>
								<td>
									Declaration Submitted
								</td>
								<td>
									<ul class="inlineUL">
										<li>
											<input type="radio" name="declarationSubmitted" id="declarationSubmittedY" value="Y">
											<label for="declarationSubmittedY">Yes</label>
										</li>
										<li>
											<input type="radio" name="declarationSubmitted" id="declarationSubmittedN" value="N">
											<label for="declarationSubmittedN">NO</label>
										</li>
									</ul>
									<ul class="inlineUL">
										<li>
											for Tax Year: <input type="text" name="forTaxYear">
										</li>
									</ul>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="sectionFooter">
					<input type="submit" value="Save" class="btn btn-success"/>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</HTML>