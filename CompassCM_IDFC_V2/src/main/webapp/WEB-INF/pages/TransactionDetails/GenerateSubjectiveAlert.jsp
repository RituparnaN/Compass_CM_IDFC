<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Generate Subjective Alert</title>
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
	
	<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'subjectiveAlertResultTable';
		compassDatatable.construct(tableClass, "GenerateSubjectiveAlert", false);
		
		$(".subjectiveAlertResultTable"+id).children("tbody").children("tr").each(function(){
			var tdVal = $(this).children("td").children("first-child").html();
			$(this).children("td").children("first-child").html("<a href='javascript:void(0)' class='alertCodeLink'>"+tdVal+"</a>");
		});
		
		$(".alertCodeLink").click(function(){
			var alertCode = ($(this).html());
			var transactionNo = '${transactionNo}';
			if(confirm("Are you sure to generate alert?")){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/generateSubjectiveAlert",
					cache: false,
					type: "GET",
					data: "transactionNo="+transactionNo+"&alertCode="+alertCode,
					success: function(resData) {
						alert(resData);
				    	window.close();
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
		      }
			});
		});
		
	</script>
	<style type="text/css">
	.alertCodeLink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
</head>
<body>
<div class="row compassrow${UNQID}" style="padding: 20px; margin: 0 ;">
		<div class="card card-primary panel_generateSubjectiveAlert">
			<div class="card-header panelGenerateSubjectiveAlert${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Generate Subjective Alert</h6>
			</div>
			<div id="subjectiveAlertResult${UNQID}">
				<table class=" table table-bordered table-striped searchResultGenericTable subjectiveAlertResultTable${UNQID}" style="margin-bottom: 0px;">
					<thead>
						<tr>
							<th class="info sort">Alert Code</th>
							<th class="info sort">Description</th>
						</tr>
					</thead>
					<tbody> 
						<c:forEach var="record" items="${RECORDS}">
							<tr>
								<td class = "alertCodeLink">${record['ALERTCODE']}</td>
								<td>${record['DESCRIPTION']}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</div>
		</div>
</div>
</body>
</html>