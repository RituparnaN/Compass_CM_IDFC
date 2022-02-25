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
		
		//for getting flag for freeze
		var isfreez = '${ISFREEZED}';
		
		if(isfreez == 'Y'){
			$("#AddDetailButton"+id).attr("disabled", true);
			$("#delete"+id).attr("disabled", true);
		}
		
		$("#printTemplateDetails"+id).click(function(){
			var divName = 'templateDetailsDiv';
			var printContents = $('#'+divName).html();
			//alert(printContents);
			w=window.open();
			w.document.write(printContents);
			w.document.title='Template Details';
			w.print();
			w.close(); 
		});
		
		var tableClass = 'templateScreeningDetailTable${UNQID}';
		compassDatatable.construct(tableClass, "TemplateScreeningDetail", true);
		compassDatatable.enableCheckBoxSelection();
		
		
		
		 /* $('.templateScreeningDetailTable'+id)
		.DataTable({
			"bRetrieve":true,
			dom: '<"top"i>rt<"bottom"flp><"clear">',
			responsive : true,
			order: [],
			columnDefs: [ { targets: "no-sort", orderable: false }],
	        buttons: [
	                  {
			            	extend: 'copy',
			            	text: 'TSV'
			            },
			            {
			            	extend: 'csvHtml5'			                
			            }, 
			            {
			                extend: 'print',
			                customize: function ( win ) {
			                    $(win.document.body)
			                        .css( 'font-size', '10pt' )
			                        .prepend(
			                            '<img src="http://datatables.net/media/images/logo-fade.png" style="position:absolute; top:0; left:0;" />'
			                        );
			 
			                    $(win.document.body).find( 'table' )
			                        .addClass( 'compact' )
			                        .css( 'font-size', 'inherit' );
			                }
			            }
			         ]
	    }); 
		 */
	/*
	call for opening model  adding detail
	
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
		});*/
		
		
		//call for adding detail/record
		$("#AddDetailButton"+id).click(function(){
			var nameValue = $("#nameValue"+id).val();
			var countryValue = $("#countryValue"+id).val();
			var idValue = $("#idValue"+id).val();
			if(nameValue == '' && countryValue == '' && idValue == '')
			{
				alert("Please enter atleast one among Name, Country and ID Values");
				$("nameValue"+id).click();
				return false;
			}
			else {
			// if(confirm("Are you sure?")){
					$.ajax({
						url: "${pageContext.request.contextPath}/common/insertDetailForTemplateScreening?templateId="+templateId+"&templateName="+templateName+"&nameValue="+nameValue+"&countryValue="+countryValue+"&idValue="+idValue,                                   
						cache: false,
						type: "POST",
						success: function(res){
							alert(res);
							$("#compassGenericModal").modal("hide");
							var doc = $("#compassGenericModal-title")[0].ownerDocument;
							var win = doc.defaultView || doc.parentWindow;
							win.location.reload();
						},
						error: function(Data){
							
							alert(Data);
						}
					});
			// }
			}

		});
		
		$("#delete"+id).click(function(){
			var seqNo = ''; 
			$(':checkbox:checked').each(function(i) {
				seqNo = seqNo+$(this).val()+',';
				
		     });
			if(seqNo.length > 0){
				//if(confirm("Are you sure?")){
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
			 //}
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
		<div class="card card-primary panel_watchlistDetails" >
			<div class="card-header panelSlidingTemplateScreening${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Template Details</h6>
			</div>
			<div class="panelWatchlistDetailsForm">
			<form action="javascript:void(0)" method="POST" id="templateScreeningDetailForm${UNQID}">
			<div id= "templateDetailsDiv">
				<table class="table table-striped templateDetailsTable" style="margin-bottom: 0px;">
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
			</div>
				<div class="card-footer clearfix">
					<div class="pull-right noPrint">
						<button type="button" id="printTemplateDetails${UNQID}" class="btn btn-warning btn-sm">Print</button>
						<button type="button" id="closeTemplateScreening${UNQID}" class="btn btn-danger btn-sm" onclick="window.close()">Close</button>
					</div>
				</div>
			</form>
		</div>
	</div>
	<!-- div for add details/record   start here -->
	
	
	
		<div class="card card-primary panel_watchlistDetails">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Enter Field Details</h6>
			</div>
			<div class="panelTemplateScreeningForm">
				<form action="javascript:void(0)" method="POST" id="addCountryToTemplateScreenig">
					<table class="table table-striped" style="margin-bottom: 0px;">
						<!-- 
						<tr>
							<td width="15%">
								Field Type  
							</td>
							<td width="30%">
								<select class="form-control input-sm" id="fieldType${UNQID}">
									<option></option>
									<option value="NAME" selected>Name</option>
									<option value="COUNTRY">Country</option>
								</select>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="15%">
								Field Value
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="country" id="fieldValue${UNQID}"/>
							</td>
						</tr>
						-->
						<tr>
							<td width="15%">
								Enter Name  
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="nameValue" id="nameValue${UNQID}"/>
							</td>
							<td width="15%">
								Enter Country  
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="countryValue" id="countryValue${UNQID}"/>
							</td>
						</tr>
						<tr>
							<td width="15%">
								Enter ID Value  
							</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="idValue" id="idValue${UNQID}"/>
							</td>
						</tr>
					</table>
				</form>
			</div>
			<div class="card-footer clearfix">
				<div class="card-title pull-right">
					<button type="button" class="btn btn-primary btn-sm" id="AddDetailButton${UNQID}">Add</button>
				</div>
			</div>
		</div>
	
	
	
	<!-- div for add details/record   End here -->
	
	<div class="card card-primary panel_watchlistRecords">
		<div class="card-header">
			<h6 class="card-title">Template Screening  Records</h6>
		</div>
		<table class="table table-bordered table-striped toolbar templateScreeningDetailTable${UNQID}" >
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