<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="ROLE" value="${f:substring(userRole,5,userRole.length())}"/>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		var searchButtonId = '${searchButtonId}';
		var tableClass = 'manageTemplateScreening${UNQID}';
		
		compassDatatable.construct(tableClass, "ManageTemplateScreening", true);
		compassDatatable.enableCheckBoxSelection();
		
		var userRole = '${userRole}';
		var subModuleCode = '${subModuleCode}';
		//compassDatatable.enableCheckBoxSelection();
		$(".templateScreeningId"+id).click(function(){
			var templateId = $(this).html();
			var templateName = $(this).closest('tr').find("td:eq(1)").text();
			var subModuleCode = '${subModuleCode}';
			var url = "${pageContext.request.contextPath}/common/templateScreeningDetail?templateId="+templateId+"&templateName="+templateName+"&subModuleCode="+subModuleCode;
			window.open(url,'Watchlist Details','height=600px,width=1000px');
		});

		$("#viewComments"+id).click(function(){
			var detailPageUrl = "TemplateScreening/TemplateScreeningCommentsLog";
			var templateSeqNo = "";
		    $("#searchResultGenericDiv"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					templateSeqNo = $(this).children("td").children("input").val();
				}
			});
		    if(templateSeqNo == ""){
				alert('please select one to view comments');
				return false;
			}
			
			openDetails(this, 'TemplateScreeningCommentsLog', templateSeqNo,'templateScreeningCommentsLog', detailPageUrl);
		});
		
		function openDetails(elm, moduleHeader, value, moduleCode, detailPage){
			var childWindow = $("#childWindow").val() != undefined ? "1" : "0";
			if(childWindow == "1"){
				openModalInWindow(elm, moduleHeader, value, moduleCode, detailPage, false);
			}else{
				if($("#compassGenericModal").hasClass("in") && ($(elm).prop("tagName") != "BUTTON")){
					openModalInWindow(elm, moduleHeader, value, moduleCode, detailPage, false);
				}else{
					$(elm).tooltip('hide');
					$(elm).attr("disabled", "disabled");
					var accValue = $(elm).html();
					$(elm).html("Searching...");
					$("#compassGenericModal").modal("show");
					$("#compassGenericModal-title").html(moduleHeader);
					var ctx = window.location.href;
					ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
					var url = ctx + '/common/getModuleDetails?moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+value+'&detailPage='+detailPage;
					var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
					$("#tabUrl").val('/common/getModuleDetails?moduleCode='+moduleCode+'&moduleHeader='+moduleHeader+'&moduleValue='+value+'&detailPage='+detailPage);
					$("#tabModuleCode").val(moduleCode);
					$("#compassGenericModal-body").html("<br/><center><img src='"+loaderUrl+"'/></center><br/>");
					
					$.ajax({
						url :  url,
						cache : false,
						type : 'GET',
						success : function(response){
							$("#compassGenericModal-body").html(response);
							$(elm).html(accValue);
							$(elm).removeAttr("disabled");
						},
						error : function(a,b,c){
							$(elm).html(accValue);
							$(elm).removeAttr("disabled");
							alert("Something went wrong"+a+b+c);
						}
					});
				}
				
			}
		}
		
		//ajax call for Create and freeze 
		$(".escalate"+id).click(function(){
			//alert($(this).attr('id'));
			//alert($(this).attr('buttonVal'));
		    var button = $(this);
		    var templateSeqNo = "";
		    $("#searchResultGenericDiv"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					templateSeqNo = $(this).children("td").children("input").val();
				}
			});
		    /* 
			if(templateSeqNo == ""){
				alert('please select one to escalate');
				return false;
			}
			
			 */
			//var userComments = prompt("Please enter your comments before saving.");
			var templateScreeningStatus = $(this).attr('buttonVal');
			if(templateSeqNo == ""){
				if(templateScreeningStatus == "6"){
					alert('please select one to discard');
				}
				else{
					alert('please select one to escalate');	
				}
				return false;
			}
			else{
				$("#compassGenericModal").modal("show");
				$("#compassGenericModal-title").html("Escalate");
				var ctx = window.location.href;
				ctx = ctx.substring(0, ctx.split("/", 4).join("/").length);
				var loaderUrl = ctx + '/includes/images/qde-loadder.gif';
				$("#compassGenericModal-body").html("<br/><center><img src='"+loaderUrl+"'/></center><br/>");
				//if(userComments != null){
					$.ajax({
				 		url : '${pageContext.request.contextPath}/common/addCommentsToUpdateTemplateScreeningStatus',
				 		cache : true,
				 		type : 'POST',
				 		data : {templateSeqNo:templateSeqNo,templateScreeningStatus:templateScreeningStatus,searchButtonId:searchButtonId},//,userComments:userComments},
				 		success : function(resData){
				 			$("#compassGenericModal-body").html(resData);
				 			/* if(resData['STATUS'] == true)
				 			{
				 				alert(resData['MESSAGE']);
				 				$("#"+searchButtonId).click();	
				 			} */	 			
				 		}
				 	});
				/* }else{
					button.removeAttr("disabled");
				} */
			}
			/* 
			if(count == 0){
				alert("Select a record");
			}else if(count > 1){
				alert("Select only one record");
			} else {
			compassFileUpload.init("attachEvedence","${pageContext.request.contextPath}","5678","amlUserPendingCaseSerachResult"+id,"Y","Y");
			}
			*/
		});
		
		$("#attachEvidence"+id).click(function(){
		    var templateSeqNo = "";
		    $("#searchResultGenericDiv"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					templateSeqNo = $(this).children("td").children("input").val();
				}
			});
			if(templateSeqNo == ""){
				alert('please select one to add file as attachments');
				return false;
			}else{
				compassFileUpload.init("attachEvidence","${pageContext.request.contextPath}","templateScreening","searchResultGenericDiv"+id,"Y","N",templateSeqNo);
			}
		}); 
		 
		$("#viewEvidence"+id).click(function(){
		    var templateSeqNo = "";
		    $("#searchResultGenericDiv"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					templateSeqNo = $(this).children("td").children("input").val();
				}
			});
			if(templateSeqNo == ""){
				alert('please select one to view attachments');
				return false;
			}else{
				compassFileUpload.init("attachEvidence","${pageContext.request.contextPath}","templateScreening","searchResultGenericDiv"+id,"N","N",templateSeqNo);
			}
		});
		

		$(".templateScan"+id).click(function(){
			var templateSeqNo = $(this).html();
			var isFreezedStatus = 'N';
			var isScreeningReferenceNo = 'N';
			getScanningDetails(templateSeqNo, function() {
			//getScanningDetails(templateSeqNo, isFreezedStatus, isScreeningReferenceNo);
			isFreezedStatus = document.viewBottomFrame.isFreezedStatus.value;
			isScreeningReferenceNo = document.viewBottomFrame.screeningReferenceNo.value;
			if(isFreezedStatus == 'N'){
				screenName(templateSeqNo);
			}
			else if(isFreezedStatus == 'Y'){
				screenedNameMatches(isScreeningReferenceNo);
			}
			//getScanningDetails(templateSeqNo);
			//screenName(templateSeqNo);
			});
						
		});

		//ajax call for Create and freeze 
		$(".createAndFreeze"+id).click(function(){
			var templateSeqNo = $(this).closest('tr').find("td:eq(1)").text();
			var templateId = $(this).closest('tr').find("td:eq(2)").text();
			var subModuleCode = '${subModuleCode}';

			$.ajax({
		 		url : '${pageContext.request.contextPath}/common/createAndFreeze',
		 		cache : true,
		 		type : 'POST',
		 		data : {templateSeqNo:templateSeqNo,templateId:templateId, subModuleCode:subModuleCode},
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
			var templateSeqNo = $(this).closest('tr').find("td:eq(1)").text();
			var templateId = $(this).closest('tr').find("td:eq(2)").text();
			var subModuleCode = '${subModuleCode}';
			$.ajax({
		 		url : '${pageContext.request.contextPath}/common/createNewVersion',
		 		cache : true,
		 		type : 'POST',
		 		data : {templateSeqNo:templateSeqNo,templateId:templateId, subModuleCode:subModuleCode},
		 		success : function(resData){
			 		alert(resData);
		 			//console.log(resData);
			 		$("#"+searchButtonId).click();
		 		}
		 	});
		});	
	});

	function getScanningDetails(templateSeqNo, callback) {
		var subModuleCode = '${subModuleCode}';
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getTemplateScreeningDetails",
			cache: false,
			type: "GET",
			data: {templateSeqNo:templateSeqNo, subModuleCode:subModuleCode},
			success: function(res) {
				document.viewBottomFrame.isFreezedStatus.value = res['isFreezed'];
				document.viewBottomFrame.screeningReferenceNo.value = res['screeningReferenceNo'];
			},
			complete: function(){
				callback();
			},
			error: function(a,b,c) {
				console.log();
			}
		});
		//alert("bellow alert");
	}

	function screenName(templateSeqNo){
		var blackList = "N";
		var id = '${UNQID}';
		if($("#blackListTemplateScan"+id).prop("checked")){
			blackList = "Y";
		}
		var rejectList = "N";
		if($("#rejectListTemplateScan"+id).prop("checked")){
			rejectList = "Y";
		}
		var customerDatabase = "N";
		if($("#customerDatabaseTemplateScan"+id).prop("checked")){
			customerDatabase = "Y";
		}
		var employeeDatabase = "N";
		if($("#employeeDatabaseTemplateScan"+id).prop("checked")){
			employeeDatabase = "Y";
		}
		var selectedBlackList = "N";
		if($("#selectedBlackListCheckTemplateScan"+id).prop("checked")){
			selectedBlackList = "Y";
		}
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
		/*
		var blackList = "Y";
		var rejectList = "Y";
		var customerDatabase = "Y";
		var employeeDatabase = "Y";
		var selectedBlackList = "Y";
		*/
		if(blackList == "N" && rejectList == "N" && customerDatabase == "N" && employeeDatabase == "N" && selectedBlackList == "N")
			alert("Select atleast a list from Checklist Form");
		else{
			getScanningDetails(templateSeqNo);
					
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
		}
	}
	
	function screenedNameMatches(screenedReferenceNo){
		$("#compassRTScanningModal").modal("show");
		$("#compassRTScanningModal-title").html("Real Time Scanning");
		$("#compassRTScanningModal-body").html("<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'><center><br/>");
		var userRole = '${userRole}';
		var subModuleCode = '${subModuleCode}';
		var isActionAllowed = 'N';
		if(subModuleCode == 'N.A.' && (userRole == 'ROLE_AMLUSER' || userRole == 'ROLE_SCREENINGMAKER')){
			isActionAllowed = 'Y';
		}
		//var url = "${pageContext.request.contextPath}/common/fileMatches?counter=0&filename="+screenedReferenceNo+"&FileImport=N&UserCode=ALL&RecordStatus=ALL&ScanningFromDate=&ScanningToDate=&ProcessingFromDate=&ProcessingToDate=";
		//alert(${pageContext.request.contextPath});
		var fullData = "counter=0&filename="+screenedReferenceNo+"&FileImport=N&UserCode=ALL&RecordStatus=ALL&ScanningFromDate=&ScanningToDate=&ProcessingFromDate=&ProcessingToDate=&isActionAllowed="+isActionAllowed;
		$("#openRTModalInWindow").attr("url-attr", "/common/fileMatches");
	    //$("#openRTModalInWindow").attr("data-attr", screenedReferenceNo);
		$("#openRTModalInWindow").attr("data-attr", fullData);
		$.ajax({
	 		url : '${pageContext.request.contextPath}/common/fileMatches',
	 		cache : true,
	 		type : 'POST',
	 		data : fullData,
	 		success : function(resData){
	 			$("#compassRTScanningModal-body").html(resData);
	 		}
	 	});
	}
</script>

<style type="text/css">
	/* .templateScreeningId {
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	.banIcon {
		color: red;
	}
	.plusIcon {
		color: green;
	} */
	
	.templateScreeningId${UNQID}, .templateScan${UNQID} {
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
	a .banIcon {
		color: red;
	}
	a .plusIcon {
		color: green;
	}
</style>

<form name="viewBottomFrame">
<input type = "hidden" name = "isFreezedStatus" value = ""/>
<input type = "hidden" name = "screeningReferenceNo" value = ""/>
</form>

 <table class="table table-bordered table-striped checklistForm${UNQID}" style="text-align: center; margin-bottom: 0px;">
	<tr>
		<td width="20%">
			<input checked="checked" type="checkbox" id="blackListTemplateScan${UNQID}" style="vertical-align: middle; position: relative; bottom: 2px">
			<b>Black List</b>
		</td>
		<td width="20%">
			<input checked="checked" type="checkbox" id="rejectListTemplateScan${UNQID}" style="vertical-align: middle; position: relative; bottom: 2px">
			<b>Reject List</b>
		</td>
		<td width="20%">
			<input checked="checked" type="checkbox" id="customerDatabaseTemplateScan${UNQID}" style="vertical-align: middle; position: relative; bottom: 2px">
			<b> Customer Database</b>
		</td>
		<td width="20%">
			<input checked="checked" type="checkbox" id="employeeDatabaseTemplateScan${UNQID}" style="vertical-align: middle; position: relative; bottom: 2px">
			<b>Employee Database</b>
		</td>
		<td width = "20%" >
			<input checked="checked" type="checkbox" id="selectedBlackListCheckTemplateScan${UNQID}" style="vertical-align: middle; position: relative; bottom: 2px">
			<b>Selected BlackList Check</b>
		</td>
	</tr>
</table> 
<div id="searchResultGenericDiv${UNQID}">
<table class=" table table-bordered table-striped searchResultGenericTable manageTemplateScreening${UNQID}"  style="margin-bottom: 0px;">
	<thead>
		<tr>
			<th class="info no-sort"></th>
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
			<!--  <th colspan="2" class="info">Action</th> -->
			<%-- <c:when test="${ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER'}"> --%>
			<c:if test="${subModuleCode eq 'N.A.' && (ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER')}"> 
			<th class="info">Freeze</th>
			<th class="info">New Version</th>
			</c:if>
			<%-- </c:when> --%>
		</tr>
	</thead>
	<tbody>
		<c:forEach var="record" items="${RESULTDATA['DATA']}">
			<tr>
				<c:forEach var="field" items="${record}" varStatus="status">
				<c:choose>
					<c:when test = "${field.key == 'TEMPLATESCAN'}" >
						<td>
							<input type="checkbox" class="checkbox-check-one" value="${field.value}" compassId="${field.value}" /> 
						</td>
						<td><a href="#" class="templateScan${UNQID}">${field.value}</a></td>
					</c:when> 
					<c:when test = "${field.key == 'TEMPLATEID'}" >
						<td><a href="#" class="templateScreeningId${UNQID}">${field.value}</a></td>
					</c:when> 
					<c:when test = "${field.key == 'TEMPLATETYPE'}" >
						<c:choose>
							  <c:when test="${field.value == 'e'}">
							  	<td>Export</td>
							  </c:when>
							  <c:when test="${field.value == 'i'}">
							    <td>Import</td>
							  </c:when>
							  <c:when test="${field.value == 'r'}">
							    <td>Remittance</td>
							  </c:when>
							  <c:when test="${field.value == 'o'}">
							    <td>Others</td>
							  </c:when>
							  <c:when test="${empty field.value}">
							  <td></td>
							  </c:when>
						</c:choose>
					</c:when>
					<%-- <c:when test="${ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER'}"> --%>
					<c:when test = "${field.key == 'ISFREEZED'}" >
						<c:choose>
							 <c:when test="${field.value == 'N'}">
							 <c:if test="${subModuleCode eq 'N.A.' && (ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER')}">
								 <td class="text-center"><a href="javascript:void(0)" title ="Freeze"  class="createAndFreeze${UNQID}"><span class="fa fa-ban banIcon "></span></a></td>
							</c:if>	 
							</c:when>
							<c:when test="${field.value == 'Y'}">
							<c:if test="${subModuleCode eq 'N.A.' && (ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER')}">
								  <td class="text-center"><a  title ="Already Freezed" ><span class="fa fa-save"></span></a></td>
							</c:if>
							</c:when>
						</c:choose>
						<c:if test="${subModuleCode eq 'N.A.' && (ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER')}">
						<td class="text-center"><a href="javascript:void(0)" title ="Create New Version" class="createNewVersion${UNQID}"  > <span class="fa fa-plus plusIcon"></span></a></td>
						</c:if>
					</c:when>
					<%-- </c:when> --%>
					<c:otherwise>
						<td>${field.value}</td>
					</c:otherwise>
				</c:choose>
				</c:forEach>
			</tr>
		</c:forEach>
	</tbody>
</table>
</div>

<div class="card-footer action-footer clearfix">
	<div class="pull-${dirR} clearfix">
		<c:if test="${subModuleCode eq 'N.A.' && (ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER')}">
		   <button type="button" class="btn btn-primary btn-sm escalate${UNQID}" buttonVal = "1" id="escalatedByMaker${UNQID}">Escalate</button>
		   <button type="button" class="btn btn-primary btn-sm escalate${UNQID}" buttonVal = "6" id="escalatedByMaker${UNQID}">Discard</button>
		</c:if>
		<c:if test="${subModuleCode eq 'N.A.' && ROLE eq 'SCREENINGCHECKER'}">
		   <button type="button" class="btn btn-primary btn-sm escalate${UNQID}" buttonVal = "5" id="approvedByChecker${UNQID}">Approve</button>
		   <button type="button" class="btn btn-primary btn-sm escalate${UNQID}" buttonVal = "4" id="rejectdByChecker${UNQID}">Reject</button>
		   <button type="button" class="btn btn-primary btn-sm escalate${UNQID}" buttonVal = "2" id="escalatedToCompliance${UNQID}">Escalate To Compliance</button>
		</c:if>
		<c:if test="${subModuleCode eq 'N.A.' && (ROLE eq 'AMLO' || ROLE eq 'MLRO')}">
		   <button type="button" class="btn btn-primary btn-sm escalate${UNQID}" buttonVal = "3" id="escalateByCompliance${UNQID}">Escalate</button>
		</c:if>
		<%-- <button type="button" class="btn btn-primary btn-sm" id="escalate${UNQID}">Escalate</button> --%>
		
		<button type="button" class="btn btn-primary btn-sm" id="viewComments${UNQID}">View Comment</button>
		<c:choose>
			<c:when test="${subModuleCode eq 'N.A.' && (ROLE eq 'AMLUSER' || ROLE eq 'SCREENINGMAKER')}">
				<button type="button" class="btn btn-primary btn-sm" id="attachEvidence${UNQID}"><spring:message code="app.common.attachOrViewEvidence"/></button>
		    </c:when>
		    <c:otherwise>
				<button type="button" class="btn btn-primary btn-sm" id="viewEvidence${UNQID}"><spring:message code="app.common.viewEvidence"/></button>
			</c:otherwise>
		</c:choose>		
	</div>
</div>