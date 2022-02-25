<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@include file="../../tags/tags.jsp" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
    <html>
    	<head>
    	<title>Account Statement</title>
    		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<meta charset="utf-8">
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
 
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/metisMenu.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTables.bootstrap.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTables.tableTools.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/flot/jquery.flot.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.slimscroll.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/dataTables.buttons.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/buttons.flash.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/jszip.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/pdfmake.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/vfs_fonts.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/buttons.html5.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/buttons.print.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery.fileDownload.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/master-module-hyperlinks.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassDatatable.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassTopFrame.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassFileUpload.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CaseWorkFlowActions.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/CompassEmailExchange.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/ckeditor/ckeditor.js"></script>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/Graphs/moment.min.js"></script>

<!-- 
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min_AccountStatement.js"></script>
 -->
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/metisMenu.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/font-awesome.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/jquery-ui.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/buttons.dataTables.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/select2.min.css" />
<link rel="StyleSheet" type="text/css"	href="${pageContext.request.contextPath}/includes/styles/template/default.css" />


<script type="text/javascript">
 	$(document).ready(function(){
		
		var id = '${UNQID}';
		
		var tableClass = 'accountStatementDetailTable';
		compassDatatable.construct(tableClass, "Account_Statement", true);
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
</head>
<body>
<div class="row compassrow${UNQID}" style="padding: 10px 10px 0 10px;">
	<div class="col-sm-12" >
		<div class="card card-primary panel_accountStatement">
			<div class="card-header panelSlidingAccountStatement${UNQID} clearfix">
				<h6 class="card-title pull-left"><spring:message code="app.common.accountStatementHeader"/></h6>
				<div class="btn-group pull-right clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<form id="AccountStatementForm" action="${pageContext.request.contextPath}/common/viewAccountStatement" method="GET" onsubmit="return checkForm()">
					<table class="table table-striped" style="margin-bottom: 0px;">
						<tr>
							<td width="15%">From Date</td>
							<td width="30%"><input type="text" class="form-control input-sm" name="FROMDATE" id="fromDate" value="${FROMDATE}"/></td>
							<td width="10%">&nbsp;</td>
							<td width="15%">To Date</td>
							<td width="30%"><input type="text" class="form-control input-sm" name="TODATE" id="toDate" value="${TODATE}"/></td>
						</tr>
						<tr>
							<td width="15%">Account Number</td>
							<td width="30%"><input type="text" class="form-control input-sm" name="ACCOUNTNO" id="accountNo" value="${ACCOUNTNO}"/></td>
							<td width="10%">&nbsp;</td>
							<td width="15%">Source System</td>
							<td width="30%">
								<select class="form-control input-sm" name="SOURCESYSTEM" id="sourceSystem" value="${SOURCESYSTEM}" >
								  <option value="ALL">ALL</option>
								  <option value="FLEXCUBE">FLEXCUBE</option>
								  <!--<option value="CORE">CORE</option>-->
								  <option value="CREDITCARD">CREDITCARD</option>
								  <!--<option value="DEMAT">DEMAT</option>-->
								</select>
							</td>
						</tr>
					</table>
					<div class="card-footer clearfix">
						<div class="pull-right">
							<button type="submit" id="searchAccountStatement${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
						</div>
					</div>
				</form>
			</div>
		</div>
		<div class="card card-primary" id="accountStatementSerachResultPanel${UNQID}" >
			<div class="card-header panelSlidingAccountStatement${UNQID} clearfix">
				<h6 class="card-title pull-left"><spring:message code="app.common.accountStatementResultHeader"/></h6>
				<div class="btn-group pull-right clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="accountStatementSerachResult${UNQID}">
				<c:choose>
					<c:when test="${f:length(DETAILS) gt 0}">
						<table class="table table-bordered table-striped searchResultGenericTable accountStatementDetailTable" >
							<thead>
								<tr>
									<th>SeqNo</th>
                                    <th>TransactionNo</th>
                                    <th>TransactionId</th>
                                    <th>AccountNo</th>
                                    <th>CustomerId</th>
                                    <th>CustomerName</th>
                                    <th>BranchCode</th>
									<th>TransactionDate</th>
                                    <th>DebitCredit</th>
                                    <th>Amount</th>
                                    <th>ConversionRate</th>
                                    <th>INR_Amount</th>
                                    <th>CurrencyCode</th>
									<th>TransactionType</th>
                                    <th>SubGroupingCode</th>
									<th>Channel</th>
									<th>AcctCurrencyCode</th>
									<th>Narration</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="RECORD" items="${DETAILS}">
									<tr>
										<td>${RECORD['ROWPOSITION']}</td>
										<td>${RECORD['TRANSACTIONNO']}</td>
										<td>${RECORD['TRANSACTIONID']}</td>
										<td>${RECORD['ACCOUNTNO']}</td>
										<td>${RECORD['CUSTOMERID']}</td>
										<td>${RECORD['CUSTOMERNAME']}</td>
										<td>${RECORD['BRANCHCODE']}</td>
										<td>${RECORD['TRANSACTIONDATE']}</td>
										<td>${RECORD['DEPOSITORWITHDRAWAL']}</td>
										<td>${RECORD['AMOUNT']}</td>
										<td>${RECORD['CONVERSIONRATE']}</td>
										<td>${RECORD['INR_AMOUNT']}</td>
										<td>${RECORD['CURRENCYCODE']}</td>
										<td>${RECORD['TRANSACTIONTYPE']}</td>
										<td>${RECORD['SUBGROUPINGCODE']}</td>
										<td>${RECORD['CHANNELTYPE']}</td>
										<td>${RECORD['ACCTCURRENCYCODE']}</td>
										<td>${RECORD['NARRATION']}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</c:when>
					<c:otherwise>
						<center>No Record Found!</center>
					</c:otherwise>
				</c:choose>
			</div>
		</div>
	</div>
</div>
</body>
</html>