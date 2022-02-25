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
<title>ADD VALUE ADDED SERVICES</title>
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
				  	<i class="fa fa-bar-chart-o fa-fw"></i>VALUE ADDED SERVICES  FOR <%=accountHolderType%> ACCOUNT HOLDER
				  </div>
				</div>
				</div>
				<div class="card-body">
					<table class="table table-bordered table-stripped">
						<tbody>
							<tr>
								<td width="25%">
									card Type
								</td>
								<td width="75%">
									<table>
										<tr>
											<td>
												<input type="radio" name="cardType" id="cardType1" value="1">
												<label for="cardType1"> VISA Debit card&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</label>
											</td>
											<td>
												<input type="radio" name="cardType" id="cardType2" value="2">
												<label for="cardType2"> ATM card</label>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									Name to Appear in card
								</td>
								<td>
									<input type="text" name="nameOnCard" class="form-control input-sm"/>
								</td>
							</tr>
							<tr>
								<td>
									Other Accounts to be linked
								</td>
								<td>
									<input type="text" name="otherAccountToLinkOnCard" class="form-control imput-sm"/>
								</td>
							</tr>
							<tr>
								<td>
									E-Banking
								</td>
								<td>
									<table width="100%">
										<tr>
											<td>E-Banking Enabled</td>
											<td>
												<ul class="inlineUL">
													<li>
														<input type="radio" name="ebankingenabled" id="ebankingenabledY" value="Y">
														<label for="ebankingenabledY">Yes</label>
													</li>
													<li>
														<input type="radio" name="ebankingenabled" id="ebankingenabledN" value="N">
														<label for="ebankingenabledN">No</label>
													</li>
												</ul>
											</td>
										</tr>
										<tr>
											<td>UserName for E-Banking</td>
											<td>
												<table>
													<tr>
														<td>1st Preference</td>
														<td><input type="text" name="username1" class="form-control input-sm"/> </td>
													</tr>
													<tr>
														<td>2nd Preference</td>
														<td><input type="text" name="username2" class="form-control input-sm"/> </td>
													</tr>
													<tr>
														<td>3rd Preference</td>
														<td><input type="text" name="username3" class="form-control input-sm"/> </td>
													</tr>
												</table>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									SMS Alerts
								</td>
								<td>
									<table width="100%">
										<tr>
											<td>SMS Alerts Enabled</td>
											<td>
												<ul class="inlineUL">
													<li>
														<input type="radio" name="smsAlertEnabled" id="smsAlertEnabledY" value="Y">
														<label for="smsAlertEnabledY">Yes</label>
													</li>
													<li>
														<input type="radio" name="smsAlertEnabled" id="smsAlertEnabledN" value="N">
														<label for="smsAlertEnabledN">No</label>
													</li>
												</ul>
											</td>
										</tr>
										<tr>
											<td>Mobile No.</td>
											<td>
												94<input type="text" name="mobileNoForSMSAlert"/>
											</td>
										</tr>
									</table>
								</td>
							</tr>
							<tr>
								<td>
									Account Holder's Mother's Maiden Name
								</td>
								<td>
									<input type="text" class="form-control input-sm" name="accholderMotherMaidenName"/>
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