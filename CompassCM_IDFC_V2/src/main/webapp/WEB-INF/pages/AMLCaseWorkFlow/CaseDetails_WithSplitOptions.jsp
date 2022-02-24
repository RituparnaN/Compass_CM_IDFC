<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="MODULEDETAILS" value="${MODULEDETAILS}"/>
<c:set var="TABNAMES" value="${MODULEDETAILS['TABNAMES']}"/>
<c:set var="TABDISPLAY" value="${MODULEDETAILS['TABDISPLAY']}"/>

<style type="text/css">
	.modalNav li a{
		font-size: 12px;
		padding: 5px 10px;
	}
	table.compassModuleDetailsSearchTable tr td{
		border: 0px;
	}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		var id = "${UNQID}";
		var tableClass = "modalDetailsTable"+id;
		
		compassDatatable.construct(tableClass, "CaseAlertDetails", true);
		compassDatatable.enableCheckBoxSelection();
		
		$("#splitAndAssign"+id).click(function(){
			var rowCount =  ($("."+tableClass).children("tbody").children("tr")).size();
			var caseNo = "${moduleValue}"; 
			var selectedAlertNos = "";
			var caseStatus = "10001";
			var action = "Add Comments for Splitting and Assigning Cases";
			var formId = "${parentFormId}";
			var modalId = "compassCaseWorkFlowGenericModal";
			$("."+tableClass).children("tbody").children("tr").each(function(){
	   			var row = $(this).children("td").children("input[type='checkbox']");
	   			var alertNo = $(this).children("td:nth-child(2)").html();  
	   			
	   			if($(row).prop("checked")){
	   				selectedAlertNos = selectedAlertNos + alertNo +" ,";
	   				//alert("selectedAlertNos = "+selectedAlertNos);
	   			}
	   		});
			var intSelectedCount = ((selectedAlertNos.split(",").length)-1);
			if(intSelectedCount == 0 || intSelectedCount == rowCount) {
			   alert('Please select atleast 1 alert and not more than '+(rowCount - 1)+' alerts to split and assign.');
			   return false;
			}else{
				if(confirm("Are you sure to split and assign alerts to users?")){
					$("#compassCaseWorkFlowGenericModal").modal("show");
					$("#compassCaseWorkFlowGenericModal-title").html(action);
					$.ajax({
						url:"${pageContext.request.contextPath}/amlCaseWorkFlow/openSplitAssignCasesModal",
						data: "alertNos="+selectedAlertNos+"&caseNo="+caseNo+"&caseStatus="+caseStatus+"&action="+action+"&formId="+formId+"&modalId="+modalId,
						cache: false,
						type: "POST",
						success: function(res){
							$("#compassCaseWorkFlowGenericModal-body").html(res);
						},
						error: function(a,b,c){
							alert(a+b+c);
						}
					});	
				}
			}
		}); 
		
		$("#addAlertComments"+id).click(function(){
			var caseNo = "${moduleValue}"; 
			var selectedCount = "";
			var selectedAlertNo = "";
			var caseStatus = "20000";
			var action = "Add Alerts Comments";
			var formId = "${parentFormId}";
			var modalId = "compassCaseWorkFlowGenericModal";
 			$("."+tableClass).children("tbody").children("tr").each(function(){
	 			var row = $(this).children("td").children("input[type='checkbox']");
	 			var alertNo = $(this).children("td:nth-child(2)").html();  
	 			
	 			if($(row).prop("checked")){
	 				selectedAlertNo = alertNo;
	 				selectedCount++;
	 			}
 			});
			if(selectedCount == 0 || selectedCount > 1) {
			   alert('Please select only 1 alert to add comments.');
			   return false;
			}else{
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html(action);
				$.ajax({
					url:"${pageContext.request.contextPath}/amlCaseWorkFlow/openAddAlertCommentsModal",
					data: "alertNos="+selectedAlertNo+"&caseNo="+caseNo+"&caseStatus="+caseStatus+"&action="+action+"&formId="+formId+"&modalId="+modalId,
					cache: false,
					type: "POST",
					success: function(res){
						$("#compassCaseWorkFlowGenericModal-body").html(res);
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});	
			}
		}); 
		
		$("#openModalInTab").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInTab($(this), moduleHeader, moduleValue, moduleCode, detailPage);
		});
		
		$("#openModalInWindow").click(function(){
			var moduleCode = $("#compassGenericModal-body").find("div.card-body").children("input#moduleCode"+id).val();
			var moduleHeader = $("#compassGenericModal-body").find("div.card-body").children("input#moduleHeader"+id).val();
			var moduleValue = $("#compassGenericModal-body").find("div.card-body").find("input#moduleValue"+id).val();
			var detailPage = $("#compassGenericModal-body").find("div.card-body").children("input#detailPage"+id).val();
			if(moduleValue != undefined)
				openModalInWindow($(this), moduleHeader, moduleValue, moduleCode, detailPage, true);
		});
	});
	 
	function openAlertTransactions(elm){
		var alertNo = $(elm).parent("tr").children("td:nth-child(1)").html();
		var url = "${pageContext.request.contextPath}/common/getLinkedTransactionsForAlerts?alertNo="+alertNo;
		window.open(url,'Account Grouping Details','height=600px,width=1000px');
		/* $("#compassCaseWorkFlowGenericModal").modal("show");
		$("#compassCaseWorkFlowGenericModal-title").html("Linked Transactions");
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getLinkedTransactionsForAlerts",
			cache: false,
			type: "POST",
			data: "alertNo="+alertNo,
			success: function(res){
				$("#compassCaseWorkFlowGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		}); */
	}
	
	
</script>
<div class="card-body" style="text-align: center; padding: 5px 0px;">
	<input type="hidden" name="moduleCode" id="moduleCode${UNQID}" value="${moduleCode}"/>
	<input type="hidden" name="detailPage" id="detailPage${UNQID}" value="${detailPage}"/>
	<input type="hidden" name="moduleHeader" id="moduleHeader${UNQID}" value="${moduleHeader}"/>
	<input type="hidden" name="moduleValue" id="moduleValue${UNQID}" value="${moduleValue}"/>
</div>
<div class="container" id="caseDetailsDiv" style="width: 100%;">
	<div class="row">
		<div class="col-sm-12">
			<div class="card card-primary">
				<ul class="nav nav-pills modalNav" role="tablist">
					<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
						<li role="presentation">
							<a class="subTab nav-link <c:if test='${tabIndex.index == 0}'>active</c:if>" href="#${moduleCode}${UNQID}${tabIndex.index}" aria-controls="tab" role="tab" data-toggle="tab">${tab}</a>
						</li>
					</c:forEach>
				</ul>				
	<div class="tab-content">
		<c:forEach var="tab" items="${TABNAMES}" varStatus="tabIndex">
			<div role="tabpanel" class="tab-pane <c:if test="${tabIndex.index == 0}">active</c:if>" id="${moduleCode}${UNQID}${tabIndex.index}">
				<c:set var="tabIndex">${tabIndex.index}</c:set>
				<c:set var="tabDetail" value="${MODULEDETAILS[tabIndex]}"/>
				<c:set var="RECORDCOUNT" value="${f:length(tabDetail)}" scope="page"/>
				<c:choose>
					<c:when test="${TABDISPLAY[tabIndex] eq 'T'}">
						<c:choose>
							<c:when test="${RECORDCOUNT > 0}">
								<table class="table table-striped table-bordered searchResultGenericTable modalDetailsTable${UNQID}">
									<thead>
										<c:forEach var="recordDetails" items="${tabDetail}" begin="0" end="0">
											<tr>
												<th class="info no-sort" style="text-align: center;">
													<input type="checkbox" class="checkbox-check-all" compassTable="alertsForAssignment${UNQID}" id="alertsForAssignment${UNQID}" />
												</th>
												<c:forEach var="fieldDetails" items="${recordDetails}">
													<c:set var="colArray" value="${f:split(fieldDetails.key, '.')}" />
													<c:set var="colArrayCnt" value="${f:length(colArray)}" />
													<th class="info" id="${colArray[colArrayCnt-1]}"><spring:message code="${fieldDetails.key}"/></th>
												</c:forEach>
											</tr>
										</c:forEach>
									</thead>
									<tbody>
										<c:forEach var="recordDetails" items="${tabDetail}">
											<tr>
												<td style="text-align: center;"><input type="checkbox"></td>
												<c:forEach var="fieldDetails" items="${recordDetails}">
													<c:choose>
														<c:when test="${fieldDetails.value ne ' ' and fieldDetails.value ne ''}">
															<td data-toggle="tooltip" data-placement="auto"  title="${fieldDetails.value}" data-container="body">${fieldDetails.value}</td>
														</c:when>
														<c:otherwise>
															<td>${fieldDetails.value}</td>
														</c:otherwise>
													</c:choose>
												</c:forEach>
											</tr>
										</c:forEach>
									</tbody>
								</table>
							</c:when>
							<c:otherwise>
								<br/>
								<center>
								No ${tab} Record Found
								</center>
								<br/>
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise>
						<c:forEach var="fieldDeatails" items="${tabDetail}">
							<table class="table table-striped">
								<tbody>
									<c:set var="LABELSCOUNT" value="${f:length(fieldDeatails)}"/>
									<c:set var="LABELSITRCOUNT" value="0" scope="page"/>
									<c:forEach var="ALLLABELSMAP" items="${fieldDeatails}">
										<c:choose>
											<c:when test="${LABELSITRCOUNT % 2 == 0}">
												<tr>
													<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
													<td width="30%">
														<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
													</td>
													<td width="10%">&nbsp;</td>
											</c:when>
											<c:otherwise>
													<td width="15%"><spring:message code="${ALLLABELSMAP.key}"/></td>
													<td width="30%">
														<input type="text" class="form-control input-sm" value="${ALLLABELSMAP.value}" readonly="readonly"/>
													</td>
												</tr>
											</c:otherwise>
										</c:choose>
										<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>
									</c:forEach>
									<c:if test="${LABELSITRCOUNT % 2 != 0}">
											<td width="15%">&nbsp;</td>
											<td width="30%">&nbsp;</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</c:forEach>
					</c:otherwise>
				</c:choose>
				<br/>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<c:if test="${RECORDCOUNT ge 2}">
							<input type="button" class="btn btn-success btn-sm" id="splitAndAssign${UNQID}" name="splitAndAssign" value="Split and Assign Cases"/>
						</c:if>
						<c:if test="${RECORDCOUNT gt 0}">
							<input type="button" class="btn btn-primary btn-sm" id="addAlertComments${UNQID}" name="addAlertComments" value="Add Alert Comments"/>
						</c:if>
					</div>
				</div>
				<br/>
				<div class="row" id="caseAlertDetailsDiv" style="display: none;">
					<div class="col-sm-12">
						<div class="card">
							
						</div>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>
</div>
</div>
</div>
</div>

