<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	var listCode = '${listCode}';
	var viewType = '';

	$(document).ready(function() {
		var id = '${UNQID}';
		//var listCode = '${listCode}';
		var isFileUploadEnabled = '${isFileUploadEnabled}';
				
		var tableClass = 'exceptionListRecordsTable${UNQID}';
		compassDatatable.construct(tableClass, "ExceptionListRecords", true);
		compassDatatable.enableCheckBoxSelection();
		/*
		var listIdLink = $(".exceptionListRecordsTable"+id).children('tbody');
		$(listIdLink).children('tr').each(function(){
			$(this).children('td:nth-child(2)').addClass('listIdHyperlink');
		});
		*/
		$("#viewDetailsButton"+id).click(function(){
			var listCode_Id = $("#listCode_Id"+id).val();
			var listCode_Name = $("#listCode_Name"+id).val();
			var fullData = "listCode="+listCode+"&listCode_Id="+listCode_Id+"&listCode_Name="+listCode_Name;
			$.ajax({
				url: "${pageContext.request.contextPath}/common/getExceptionListRecords" ,
				cache: false,
				data: fullData,
				type: "POST",
				success: function(res){
					$("#listDetailsSerachResultPanel"+id).css("display", "block");
					$("#listDetailsSerachResult"+id).html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});		
	});
	
	function openListIdDetails(elm){
		var listId = $(elm).html();
		var fullData = "listId="+listId+"&listCode="+listCode+"&viewType="+viewType;
		if(listCode == 'DOWJONELIST'){
			var url = "${pageContext.request.contextPath}/common/viewDowjonesRecord?recordId="+listId;
			window.open(url,'Dow Jones List Details','height=600px,width=1000px');
		}
		else{
			$("#compassGenericModal").modal("show");
			$("#compassGenericModal-body").on("hidden.bs.modal",function(){
				$(this).removeData();
			});
			$.ajax({
				url: "${pageContext.request.contextPath}/common/exceptionListIdDetails",
				cache: false,
				data: fullData,
				type: "POST",
				success: function(res){
					$("#compassGenericModal-title").html("List Details");
					$("#compassGenericModal-body").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		}
	}

	function uploadDetailsButton(elm, listCode, isFileUploadEnabled){
		compassFileUpload.init("uploadFile","${pageContext.request.contextPath}",listCode,"0","Y","Y","");
	}
	
</script>
<style type="text/css">
	.listCodeLink,
	.listIdHyperlink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	
</style>
</head>
<body>
<table class="table" style="text-align: center; margin-bottom: 0px;">
	<tr style="text-align: center;">
		<td width="10%">LIST ID</td>
		<td width="20%">
			<input type="text" class="form-control input-sm" id= "listCode_Id${UNQID}" name= "listCode_Id${UNQID}" value="${listCode_Id}">
		</td>
		<td width="5%">&nbsp;</td>
		<td width="10%">LIST NAME</td>
		<td width="20%">
			<input type="text" class="form-control input-sm" id= "listCode_Name${UNQID}" name= "listCode_Name${UNQID}" value="${listCode_Name}">
		</td>
		<td width="20%"><button type="button" class="btn btn-sm btn-success" id="viewDetailsButton${UNQID}" name="View Details">View Details</button></td>
		<c:if test="${isFileUploadEnabled eq 'Y'}">
		<td width="15%"><button type="button" class="btn btn-sm btn-success" id="uploadDetailsButton${UNQID}" name="Upload Details" onclick="uploadDetailsButton(this, '${listCode}', '${isFileUploadEnabled}')">Upload Details</button></td>
		</c:if>
	</tr>
</table>
<table class="table table-bordered table-striped searchResultGenericTable exceptionListRecordsTable${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<c:forEach var="TH" items="${resultData['HEADER']}">
				<c:set var="colArray" value="${f:split(TH, '.')}" />
				<c:set var="colArrayCnt" value="${f:length(colArray)}" />
				<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
			</c:forEach>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${resultData['DATA']}">
			<tr>
				<c:forEach var="field" items="${record}">
					<td data-toggle="tooltip" data-placement="auto"  title="${field}" data-container="body">${field}</td>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>
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
				<center>
					<img alt="Loading..." src="${pageContext.request.contextPath}/includes/images/qde-loadder.gif">
				</center>
			<br/>
			</div>
		</div>
	</div>
</div>
