<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var searchButtonId = '${searchButtonId}';
		var tableClass = 'manageTemplateScreening${UNQID}';
		//compassDatatable.construct(tableClass, "ManageTemplateScreening", false);
		//compassDatatable.enableCheckBoxSelection();
		$(".templateScreeningId").click(function(){
			var templateId = $(this).html();
			var templateName = $(this).closest('tr').find("td:eq(1)").text();
			var url = "${pageContext.request.contextPath}/common/templateScreeningDetail?templateId="+templateId+"&templateName="+templateName;
			window.open(url,'Watchlist Details','height=600px,width=1000px');
		});

		$(".templateScan").click(function(){
			var blackListTemplateScan = $("#blackListTemplateScan"+id).val();
			alert(blackListTemplateScan);
			var templateSeqNo = $(this).html();
			var scanName1 = "";
			var scanName2 = "";
			var scanName3 = "";
			var scanName4 = "";
			var scanName5 = "";
			var scanDOB = "";
			var scanPassportNo = "";
			var scanPanNo = "";
			var scanAccountNo = "";
			var scanCustomerId = "";
			var blackList = "Y";
			var rejectList = "Y";
			var customerDatabase = "Y";
			var employeeDatabase = "Y";
			var selectedBlackList = "Y";
			
			var fullData = "NAME1="+scanName1+"&NAME2="+scanName2+"&NAME3="+scanName3+"&NAME4="+scanName4+"&NAME5="+scanName5+"&DATEOFBIRTH="+scanDOB+
			   "&PASSPORTNO="+scanPassportNo+"&PANNO="+scanPanNo+"&ACCOUNTNO="+scanAccountNo+"&CUSTOMERID="+scanCustomerId+"&TEMPLATESEQNO="+templateSeqNo+"&userCode=NA&BlackListCheck="+blackList+
			   "&CustomerDataBaseCheck="+customerDatabase+"&RejectedListCheck="+rejectList+"&EmployeeDataBaseCheck="+employeeDatabase+"&SelectedBlackListCheck="+selectedBlackList;

			// window.open('${pageContext.request.contextPath}/common/dataEntryFormScanning?'+fullData);
			$("#compassRTScanningModal").modal("show");
			$("#compassRTScanningModal-title").html("Real Time Scanning");
			$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
			
			$("#openRTModalInWindow").attr("url-attr", "/common/dataEntryFormScanning");
			$("#openRTModalInWindow").attr("data-attr", fullData);
			$.ajax({
		 		url : '${pageContext.request.contextPath}/common/dataEntryFormScanning',
		 		cache : true,
		 		type : 'POST',
		 		data : fullData,
		 		success : function(resData){
		 			$("#compassRTScanningModal-body").html(resData);
		 		}
		 	});
		});
		
		
		//ajax call for Create and freeze 
		$(".createAndFreeze"+id).click(function(){
			
			var templateSeqNo = $(this).closest('tr').find("td:eq(0)").text();
			var templateId = $(this).closest('tr').find("td:eq(1)").text();
			
			$.ajax({
		 		url : '${pageContext.request.contextPath}/common/createAndFreeze',
		 		cache : true,
		 		type : 'POST',
		 		data : {templateSeqNo:templateSeqNo,templateId:templateId},
		 		success : function(resData){
		 			
		 			
		 			if(resData['STATUS'] == true)
		 			{
		 				alert(resData['MESSAGE']);
		 				$("#"+searchButtonId).click();	
		 			}
		 				 			
		 		}
		 	});
			//console.log("templateSeqNo= "+templateSeqNo+" templateId=  "+templateId);
		});
		
		//ajax call for create new version 
		$(".createNewVersion"+id).click(function(){
			var templateSeqNo = $(this).closest('tr').find("td:eq(0)").text();
			var templateId = $(this).closest('tr').find("td:eq(1)").text();
			$.ajax({
		 		url : '${pageContext.request.contextPath}/common/createNewVersion',
		 		cache : true,
		 		type : 'POST',
		 		data : {templateSeqNo:templateSeqNo,templateId:templateId},
		 		success : function(resData){
			 		alert(resData);
		 			//console.log(resData);
			 		$("#"+searchButtonId).click();
		 		}
		 	});
		});	
	});

	function screenedName(screenedReferenceNo){
		$("#compassRTScanningModal").modal("show");
		$("#compassRTScanningModal-title").html("Real Time Scanning");
		$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");

		var url = "${pageContext.request.contextPath}/common/fileMatches?counter=0&filename="+screenedReferenceNo+"&FileImport=N&UserCode=ALL&RecordStatus=ALL&ScanningFromDate=&ScanningToDate=&ProcessingFromDate=&ProcessingToDate=";
		$("#openRTModalInWindow").attr("url-attr", url);
		$("#openRTModalInWindow").attr("data-attr", screenedReferenceNo);
		$.ajax({
	 		url : url, // '${pageContext.request.contextPath}/common/fileMatches',
	 		cache : true,
	 		type : 'POST',
	 		data : data,
	 		success : function(resData){
	 			$("#compassRTScanningModal-body").html(resData);
	 		}
	 	});
	}
	
</script>

<style type="text/css">
	.templateScreeningId{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	.banIcon{
		color: red;
	}
	.plusIcon{
		color: green;
	}
</style>

<!-- for scanning search parameter  -->
		
		<div class="card card-primary" id="screeningSearchParameter${UNQID}" style="display: none;">
			<div class="card-header panelSlidingTemplateScanning${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Checklist Form</h6>
			</div>
			<div class="panelSearchForm">
				<table class="table table-bordered table-striped" style="text-align: center; margin-bottom: 0px;">
					<tr>
						<td width="20%">
							
								<input checked="checked" type="checkbox" id="blackListTemplateScan" style="vertical-align: middle; position: relative; bottom: 2px">
								<b>Black List</b>
						
						</td>
						<td width="20%">
							<input checked="checked" type="checkbox" id="rejectListTemplateScan" style="vertical-align: middle; position: relative; bottom: 2px">
							<b>Reject List</b>
						</td>
						<td width="20%">
							<input checked="checked" type="checkbox" id="customerDatabaseTemplateScan" style="vertical-align: middle; position: relative; bottom: 2px">
							<b> Customer Database</b>
						</td>
						<td width="20%">
							<input checked="checked" type="checkbox" id="employeeDatabaseTemplateScan" style="vertical-align: middle; position: relative; bottom: 2px">
							<b>Employee Database</b>
						</td>
						<td width = "20%" >
							<input checked="checked" type="checkbox" id="selectedBlackListCheckTemplateScan" style="vertical-align: middle; position: relative; bottom: 2px">
							<b>Selected BlackList Check</b>
						</td>
					</tr>
				</table>
			</div>
		</div>

<table class=" table table-bordered table-striped manageTemplateScreening${UNQID}" style="margin-bottom: 0px;">
	<thead>
		<tr>
			<c:forEach var="TH" items="${RESULTDATA['HEADER']}">
				<c:set var="colArray" value="${f:split(TH, '.')}" />
				<c:set var="colArrayCnt" value="${f:length(colArray)}" />
				<c:choose>
				  <c:when test =  "${TH == 'app.common.ISFREEZED'}">
				    
				  </c:when>
				 <c:otherwise>
				    <th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${TH}"/></th>
				  </c:otherwise>
				</c:choose>
				
			</c:forEach>
			<th colspan="2" class="info">Action</th>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${RESULTDATA['DATA']}">
			<tr>
				<c:forEach var="field" items="${record}" varStatus="status">
				<c:choose>
					<c:when test = "${field.key == 'TEMPLATESCAN'}" >
						<td><a href="#" class="templateScan">${field.value}</a></td>
					</c:when> 
					<c:when test = "${field.key == 'TEMPLATEID'}" >
						<td><a href="#" class="templateScreeningId">${field.value}</a></td>
					</c:when> 
					<c:when test = "${field.key == 'TEMPLATETYPE'}" >
						<c:choose>
							  <c:when test="${field.value == 'i'}">
							  	<td>Individual</td>
							  </c:when>
							  <c:when test="${field.value == 'c'}">
							    <td>Company</td>
							  </c:when>
							  <c:when test="${field.value == 'r'}">
							    <td>Remittance</td>
							  </c:when>
							  <c:when test="${empty field.value}">
							    <td></td>
							  </c:when>
						</c:choose>
					</c:when>
					<c:when test = "${field.key == 'ISFREEZED'}" >
						<c:choose>
							 <c:when test="${field.value == 'N'}">
								 <td class="text-center"><a href="javascript:void(0)" title ="Freeze"    class="createAndFreeze${UNQID}"><span class="fa fa-ban banIcon "></span></a></td>
							</c:when>
							<c:when test="${field.value == 'Y'}">
								  <td class="text-center"><a  title ="Already Freezed" ><span class="fa fa-save"></span></a></td>
							</c:when>
								 
						</c:choose>
						<td class="text-center"><a href="javascript:void(0)" title ="Create New Version" class="createNewVersion${UNQID}"  > <span class="fa fa-plus plusIcon"></span></a></td>
					</c:when>
				
					<c:otherwise>
						<td>${field.value}</td>
					</c:otherwise>
				</c:choose>
				</c:forEach>
				
				
			</tr>
		</c:forEach>
	</tbody>
</table>