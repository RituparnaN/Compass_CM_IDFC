<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>

<c:set var="parameterIndex" value="1" scope="page"/>
<c:set var="parameterLabel" value="" scope="page"/>
<c:set var="parameterType" value="Date" scope="page"/>
<c:set var="isMandatory" value="Y" scope="page"/>
<c:set var="defaultValueType" value="Static" scope="page"/>
<c:set var="defaultValue" value="" scope="page"/>

<c:if test="${f:length(RECORDS) == 1 }">
	<c:forEach var="record" items="${RECORDS}">
		<c:set var="parameterIndex" value="${record['PARAMINDEX']}" scope="page"/>
		<c:set var="parameterLabel" value="${record['PARAMALIASNAME']}" scope="page"/>
		<c:set var="parameterType" value="${record['PARAMTYPE']}" scope="page"/>
		<c:set var="isMandatory" value="${record['ISMANDATORY']}" scope="page"/>
		<c:set var="defaultValueType" value="${record['DEFAULTVALUETYPE']}" scope="page"/>
		<c:set var="defaultValue" value="${record['DEFAULTVALUE']}" scope="page"/>
	</c:forEach>
</c:if>

<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
List<Map<String, Object>> businessObjects = (List<Map<String, Object>>) request.getAttribute("BUSINESSOBJECTS");
String message = (String) request.getAttribute("message");
String reportID = (String) request.getAttribute("reportID");
%>
  <HTML>
  	<head>
  		<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
  		<title>Set/Manage_Parameters</title>
		<meta charset="utf-8">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<meta name="viewport" content="width=device-width, initial-scale=1">
		<!--[if lt IE 9]>
			<script src="${pageContext.request.contextPath}/scripts/oldBuilds/html5shiv.js"></script>
			<script src="${pageContext.request.contextPath}/scripts/oldBuilds/html5shiv.min.js"></script>
			<script src="${pageContext.request.contextPath}/scripts/respond.min.js"></script>
		<![endif]-->
		<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/oldBuilds/jquery-1.9.1.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
		<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/jquery.dataTables.min.js"></script>
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/bootstrap.min.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/bootstrap-responsive.min.css" />
		<link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/dataTables.bootstrap.css" />
		<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/oldBuilds/jquery-ui.css"/>
		
		
<script type="text/javascript">
	var id = '${UNQID}';
	
	$(document).ready(function() {
		$("#deleteReportParameters"+id).click(function(){
			var selected = "";
			var reportId = $("#reportId"+id).val();
			var noOfParam = $("#noOfParam"+id).val();
			$(".reportParametersResultTable"+id).children("tbody").children("tr").each(function(){
				var checkbox = $(this).children("td").children("input");
				if($(checkbox).prop("checked"))
					selected = selected + $(checkbox).val() + ","; 
			});
			window.location.href="${pageContext.request.contextPath}/admin/deleteReportParameters?selected="+selected+"&reportId="+reportId+"&noOfParam="+noOfParam;
		});
		
		$("#closeReportParameters"+id).click(function(){
			window.close();
		});
	});
	
	function checkform(){
		var isValid = true;
		var paramLabel = $("#parameterLabel"+id).val();
		var defaultValue = $("#defaultValue"+id).val();
		if(paramLabel == null || paramLabel.trim() == ""){
			isValid = false;
			alert("Enter Parameter Name");
		}
	 	if(defaultValue == null || defaultValue.trim() == ""){
	 		isValid = false;
			alert("Enter Default Value");
	 	}
	 	return isValid;
	}
</script>

<style type="text/css">
	.modal-header {
    	flex-direction: row-reverse;
	}
	.xtrSmlButton
	{
		padding: 1px 5px;
		font-size: 12px;
	}
	.table td
	{
		padding: 8px;
	}
	
	.card
{
	margin-bottom: 20px;
	background-color: #fff;
	border: 1px solid transparent;
	border-radius: 4px;
	box-shadow: 0 1px 1px rgba(0, 0, 0, .05);
}
	
	.card-primary
{
	border-color: #337ab7 !important;
}

.card-primary >.card-header
{
	color: #fff;
	background-color: #337ab7;
	border-color: #337ab7;
}

.card-header {
    /* padding: 10px 15px; */
    padding: 5px 15px 1px 15px;
    border-bottom: 3px solid transparent;
    border-top-left-radius: 3px !important;
    border-top-right-radius: 3px !important;
}
</style>
	</head>
	<body>

	<div class="row compassrow${UNQID}" style="padding: 20px; margin: 0; display: block;">
		<div class="card card-primary panel_setManageParameters">
			<div class="card-header panelSetManageParameters${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Parameter Information</h6>
			</div>
			<div class="panelSearchForm">
			<form action="${pageContext.request.contextPath}/admin/saveReportParameters" method="POST" id="setManageParametersForm${UNQID}" style="margin: 0;" onsubmit="return checkform()">
				<table class="table table-bordered setManageParametersTable${UNQID} table-striped" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Parameter Index</td>
							<td width="30%">
								<select class="form-control input-sm" name="parameterIndex" id="parameterIndex${UNQID}">
								<c:forEach var="i"  begin="1" end="${noOfParam}">
									<option value="${i}" <c:if test="${i == parameterIndex}">selected="selected"</c:if>>@param${i}</option>
								</c:forEach>
							</select>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Parameter Label</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="parameterLabel" id="parameterLabel${UNQID}" value="${parameterLabel}"/>	
						</td>
					</tr>
					<tr>	
						<td width="15%">Parameter Type</td>
						<td width="30%">
							<select class="form-control input-sm" name="parameterType" id="parameterType${UNQID}">
								<option value="Date" <c:if test="${parameterType eq 'Date'}">selected="selected"</c:if>>Date</option>
								<option value="Number" <c:if test="${parameterType eq 'Number'}">selected="selected"</c:if>>Number</option>
								<option value="Select" <c:if test="${parameterType eq 'Select'}">selected="selected"</c:if>>Select</option>
								<option value="Text" <c:if test="${parameterType eq 'Text'}">selected="selected"</c:if>>Text</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Mandatory</td>
						<td width="30%">
							<select class="form-control input-sm" name="isMandatory" id="isMandatory${UNQID}">
								<option value="Y" <c:if test="${isMandatory eq 'Y'}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${isMandatory eq 'N'}">selected="selected"</c:if>>No</option>
							</select>
						</td>
					</tr>
					<tr>	
						<td width="15%">Default Value Type</td>
						<td width="30%">
							<select class="form-control input-sm" name="defaultValueType" id="defaultValueType${UNQID}">
								<option value="Static" <c:if test="${defaultValueType eq 'Static'}">selected="selected"</c:if>>Static</option>
								<option value="Query"<c:if test="${defaultValueType eq 'Query'}">selected="selected"</c:if>>Query</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Default Value</td>
						<td width="30%">
							<textarea class="form-control input-sm" name="defaultValue" id="defaultValue${UNQID}">${defaultValue}</textarea>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="submit" id="saveReportParameters${UNQID}" class="btn btn-primary btn-sm" name="Save" value="Save">Save</button>
						<input type="reset" class="btn btn-danger btn-sm" id="clearReportParameters${UNQID}" name="Clear" value="Clear"/>
					</div>
				</div>
				<input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
				<input type="hidden" name="reportId" id="reportId${UNQID}" value="${reportId}" />
				<input type="hidden" name="noOfParam" id="noOfParam${UNQID}" value="${noOfParam}" />
			</form>
			</div>
		</div>
		<div class="card card-primary" id="setReportParametersResultPanel${UNQID}" style="display: block;">
			<div class="card-header panelSetManageParameters${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Report Parameters List</h6>
			</div>
			<div id="setReportParametersResult${UNQID}">
				<table class=" table table-bordered table-striped searchResultGenericTable reportParametersResultTable${UNQID}" style="margin-bottom: 0px;">
					<thead>
						<tr>
							<th class="info no-sort" style="text-align: center;">
								<input type="checkbox" class="checkbox-check-all" compassTable="screeningExceptions${UNQID}" id="screeningExceptions${UNQID}" />
							</th>
							<th class="info sort">Parameter Index</th>
							<th class="info sort">Parameter Label</th>
							<th class="info sort">Parameter Type</th>
							<th class="info sort">Default Value</th>
							<th class="info sort">Mandatory</th>
							<th class="info sort">Updated On</th>
							<th class="info sort">Updated By</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="record" items="${ALLRECORDS}">
							<tr>
								<td style="text-align: center;"><input type="checkbox" value="${record['PARAMNAME']}"></td>
								<td><a href="${pageContext.request.contextPath}/admin/setReportParameters?l_strNoOfParameters=${noOfParam}&l_strReportID=${reportId}&paramIndex=${record['PARAMINDEX']}">${record['PARAMNAME']}</a></td>
								<td>${record['PARAMALIASNAME']}</td>
								<td>${record['PARAMTYPE']}</td>
								<td>${record['DEFAULTVALUE']}</td>
								<td>${record['ISMANDATORY']}</td>
								<td>${record['UPDATEDDATE']}</td>
								<td>${record['UPDATEDBY']}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
				<button type="button" id="deleteReportParameters${UNQID}" class="btn btn-danger btn-sm" name="Delete" value="Delete">Delete</button>
				<button type="button" id="closeReportParameters${UNQID}" class="btn btn-danger btn-sm" name="Close" value="Close">Close</button>
				</div>
			</div>
		</div>
	</div>
</div>
</body>
</HTML>