<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:include page="../tags/tags.jsp"/>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>LEA List Details</title>
<jsp:include page="../tags/staticFiles.jsp"/>

<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	
	$(".datepicker").datepicker({
		 dateFormat : "dd/mm/yy",
		 changeMonth: true,
	     changeYear: true
	 });
	
	$('#leaListDetailsForm'+id).find('input').prop('disabled', true);
	$('#leaListDetailsForm'+id).find('select').prop('disabled', 'disabled');
	
});
	
</script>
<style type="text/css">
	.panel_leaListDetails{
		margin-left: 10px;
		margin-right: 10px;
		margin-top: 5px;
	}
</style>
</head>
<body>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary panel_leaListDetails">
			<div class="card-header panelSlidingLEAList${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">LEA List Details</h6>
			</div>
			<div class="panelLEAlistDetailsForm">
			<form action="javascript:void(0)" method="POST" id="leaListDetailsForm${UNQID}">
				<table class="table table-striped leaListDetailsTable" style="margin-bottom: 0px;">
				
				<tr>
					<td width="15%">Serial No</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="serialNo" id="serialNo${UNQID}" value="${DATAMAP['SERIALNO']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%" id="listCodeText${UNQID}">List Code</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="listCode" id="listCode${UNQID}" value="${DATAMAP['LISTCODE']}" disabled="disabled"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">First Name</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="firstName" id="firstName${UNQID}" value="${DATAMAP['FIRST_NAME']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Middle Name</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="middleName" id="middleName${UNQID}" value="${DATAMAP['MIDDLE_NAME']}" /> 
					</td>
				</tr>
				<tr>
					<td width="15%">Surname</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="surname" id="surname${UNQID}" value="${DATAMAP['SURNAME']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Gender</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="gender" id="gender${UNQID}" value="${DATAMAP['GENDER']}">
					</td>
				</tr>
				<tr>
					<td width="15%">Source of Letter/Mail</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="sourceOfLetterMail" id="sourceOfLetterMail${UNQID}" value="${DATAMAP['SOURCE_OF_LETTER_MAIL']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Address Line</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="addressLine" id="addressLine${UNQID}" value="${DATAMAP['ADDRESS_LINE']}"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">Identification Type</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="identificationType" id="identificationType${UNQID}" value="${DATAMAP['IDENTIFICATION_TYPE']}"/>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Identification Number</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="identificationNumber" id="identificationNumber${UNQID}" value="${DATAMAP['IDENTIFICATION_NUMBER']}"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">Letter/Mail Received Date</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="letterReceivedDate" id="letterReceivedDate${UNQID}" value="${DATAMAP['LETTER_RECEIVED_DATE']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Scrubbing Date - LEA team</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="scrubbingDate" id="scrubbingDate${UNQID}" value="${DATAMAP['SCRUBBING_DATE']}"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">Scrubbing Result Match - (Y/N)</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="scrubbingResultMatch" id="scrubbingResultMatch${UNQID}" value="${DATAMAP['SCRUBBING_RESULT_MATCH']}"/>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">If Y to scrubbing - Customer Name</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="customerName" id="customerName${UNQID}" value="${DATAMAP['CUSTOMER_NAME']}"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">Customer UCIC</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="customerUCIC" id="customerUCIC${UNQID}" value="${DATAMAP['CUSTOMER_UCIC']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Customer Account</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="customerAccount" id="customerAccount${UNQID}" value="${DATAMAP['CUSTOMER_ACCOUNT']}"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">Home Branch of Customer</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="customerHomeBranch" id="customerHomeBranch${UNQID}" value="${DATAMAP['CUSTOMER_HOME_BRANCH']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Maker Code</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="makerCode" id="makerCode${UNQID}" value="${DATAMAP['MAKERCODE']}"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">Maker Timestamp </td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="makerTimestamp" id="makerTimestamp${UNQID}" value="${DATAMAP['MAKERTIMESTAMP']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Checker Code</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="checkerCode" id="checkerCode${UNQID}" value="${DATAMAP['CHECKERCODE']}"/> 
					</td>
				</tr>
				<tr>
					<td width="15%">Checker Timestamp </td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="checkerTimestamp" id="checkerTimestamp${UNQID}" value="${DATAMAP['CHECKERTIMESTAMP']}"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">&nbsp;</td>
					<td width="30%">&nbsp;</td>
				</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-right">
						<button type="button" id="closeWatchlist${UNQID}" class="btn btn-danger btn-sm" onclick="window.close()">Close</button>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>
</body>
</html>