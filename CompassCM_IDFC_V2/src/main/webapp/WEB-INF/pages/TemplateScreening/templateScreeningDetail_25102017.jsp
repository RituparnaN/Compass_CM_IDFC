<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>

<%@ include file="../tags/tags.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Template Details</title>
<jsp:include page="../tags/staticFiles.jsp"/>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var templateId = '${TEMPLATEID}';
		var templateName = '${TEMPLATENAME}';
		
		var tableClass = 'templateScreeningDetailTable';
		compassDatatable.construct(tableClass, "ManageTemplateScreening", false);
		compassDatatable.enableCheckBoxSelection();
		
		$(".add-detail${UNQID}").click(function(){
			var url = "${pageContext.request.contextPath}/common/enterDetailForTemplateScreening";
			$.ajax({
				url: url,
				cache: false,
				type: "POST",
				data: {templateId:templateId,templateName:templateName},
				success: function(res){
					$("#compassGenericModal").modal("show");
					$("#compassGenericModal-title").html("Add Details For Template Screening");
					$("#compassGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});
		
		$("#delete${UNQID}").click(function(){
			var seqNo = ''; //new Array();
			//for getting all details of checkbox
			$(':checkbox:checked').each(function(i) {
				//seqNo.push($(this).val());
				seqNo = seqNo+$(this).val()+',';
				
		     });
			if(seqNo.length > 0){
				if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/deleteTemplateDetails",
						cache: false,
						type: "POST",
						data: {templateId:templateId,templateName:templateName,seqNo:seqNo},
						success: function(res) {
							alert(res);
							window.location.reload();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						}
					});
				}
			}else
				alert("Select atleast one record");
		});
	
	});
	
</script>

<style type="text/css">
	.panel_watchlistDetails, 
	.panel_watchlistRecords{
		margin-left: 10px;
		margin-right: 10px;
		margin-top: 5px;
	}
</style>
</head>
<body>

<!-- for getting template type -->
<c:choose>
  <c:when test="${RESULTDATA['TEMPLATEDATA'][0]['TEMPLATETYPE'] == 'i'}">
  	<c:set var = "templateType" scope = "session" value = "Individual"/>
  </c:when>
  <c:when test="${RESULTDATA['TEMPLATEDATA'][0]['TEMPLATETYPE'] == 'c'}">
    <c:set var = "templateType" scope = "session" value = "Company "/>
  </c:when>
  <c:when test="${RESULTDATA['TEMPLATEDATA'][0]['TEMPLATETYPE'] == 'r'}">
    <c:set var = "templateType" scope = "session" value = "Remittance "/>
  </c:when>
</c:choose>

<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary panel_watchlistDetails">
			<div class="card-header panelSlidingTemplateScreening${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Template Details</h6>
			</div>
			<div class="panelWatchlistDetailsForm">
			<form action="javascript:void(0)" method="POST" id="templateScreeningDetailForm${UNQID}">
				<table class="table table-striped templateScreeningDetailsTable" style="margin-bottom: 0px;">
					 <tr>
						<td width="15%">Template ID</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${RESULTDATA['TEMPLATEDATA'][0]['TEMPLATEID']}"  readonly /></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Template Name</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${RESULTDATA['TEMPLATEDATA'][0]['TEMPLATENAME']}" readonly /></td>
					</tr>
					<tr>	
						<td width="15%">Template Type</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${templateType}" readonly /></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Template Date</td>
						<td width="30%"><input type="text" class="form-control input-sm" value="${RESULTDATA['TEMPLATEDATA'][0]['TEMPLATEDATE']}" readonly /></td>
					</tr> 
				<!-- 	 
					${RESULTDATA['TEMPLATEDATA'][0]['TEMPLATEID']}</br>
					${RESULTDATA['TEMPLATEDETAILDATA'][0].TEMPLATEID}
					<c:forEach var =  "tdHeading" items ="${RESULTDATA['TEMPLATEHEADER']}" >
						<tr>
							<td width="15%"><spring:message code="${tdHeading}" /></td>
						<c:forEach var =  "tdValue" items ="${RESULTDATA['TEMPLATEDATA']}"  varStatus ="status"  >
							<c:forEach var ="field" items = "${value}">
								<td width="30%"><input type="text" class="form-control input-sm" value="${field.value}"/></td>
							</c:forEach>
						</c:forEach>
					</c:forEach> 
				-->
				</table>
				<div class="card-footer clearfix">
					<div class="pull-right">
						<button type="button" id="closeTemplateScreening${UNQID}" class="btn btn-danger btn-sm" onclick="window.close()">Close</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	
	<div class="card card-primary panel_watchlistRecords">
		<div class="card-header">
			<h6 class="card-title">Template Screening  Records</h6>
		</div>
		<table class="table table-bordered table-striped templateScreeningDetailTable" >
			<thead>
					<tr>
						<th class="info no-sort" style="text-align: center;">
							<input type="checkbox" class="checkbox-check-all" compassTable="deleteWatchListDetailsRecords${UNQID}" id="deleteWatchListDetailsRecords${UNQID}" />
						</th>
						<c:forEach var="TH" items="${RESULTDATA['TEMPLATEDETAILHEADER']}">
						
							<c:set var="colArray" value="${f:split(TH, '.')}" />
							<c:set var="colArrayCnt" value="${f:length(colArray)}" />
							<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
					</c:forEach>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="record" items="${RESULTDATA['TEMPLATEDETAILDATA']}">
					<tr>
						<td style="text-align: center;"><input type="checkbox" name = "seqDetails[]" value="${record['SEQNO']}"> </td>
						<c:forEach var="field" items="${record}" varStatus="status">
								<td>${field.value}</td>
						</c:forEach>
					</tr>
				</c:forEach>
			</tbody>
		</table>
		<div class="card-footer clearfix">
			<div class="pull-right">
				<button class="btn btn-primary btn-sm add-detail${UNQID}" value="addCountry" >Add Details</button>
				<button class="btn btn-danger btn-sm" id="delete${UNQID}">Delete</button>
			</div>
		</div>
	</div>
	</div>
</div>
<div class="modal fade bs-example-modal-lg" id="compassGenericModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
		<div class="modal-dialog modal-lg">
			<div class="modal-content card-primary">
				<div class="modal-header card-header" style="cursor: move;">
					<div class="modal-button">
						<button type="button" class="close" data-dismiss="modal" aria-label="Close" title="Close">
							<span aria-hidden="true" class="fa fa-remove"></span>
						</button>
					</div>
					<h4 class="modal-title" id="compassGenericModal-title">...</h4>					
				</div>
				<div class="modal-body" id="compassGenericModal-body">
				<br/>
					<input type="text" class="form-control" name = "name" id = "name${UNIQD	}"  />
					<center>
						<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
					</center>
				<br/>
				</div>
			</div>
		</div>
	</div>
</body>
</html>