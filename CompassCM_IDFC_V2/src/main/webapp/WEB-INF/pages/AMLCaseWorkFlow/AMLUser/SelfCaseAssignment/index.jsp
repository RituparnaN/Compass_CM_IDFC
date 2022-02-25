<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		$('.selectpicker').selectpicker({
		   size: '5'
		});
		
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassSelfCaseAssignmentSearchTable'+id, 'dd/mm/yy');
				
		$('.panelSlidingSelfCaseAssignment'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'selfCaseAssignmentSerachResultPanel'+id);
	    });
 		
		$("#searchCasesForSelfAssignment"+id).click(function(){
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var fromDate = $("#FROMDATE"+id).val();
			var toDate = $("#TODATE"+id).val();
			var customerId = $("#customerId"+id).val();
			var customerType = $("#customerType"+id).val() === null ? "" : $("#customerType"+id).val();
			var caseRangeFrom = $("#caseRangeFrom"+id).val();
			var caseRangeTo = $("#caseRangeTo"+id).val();
			
			var fullData = "fromDate="+fromDate+"&toDate="+toDate+"&customerId="+customerId+"&customerType="+customerType+
						   "&caseRangeFrom="+caseRangeFrom+"&caseRangeTo="+caseRangeTo;
			//alert(fullData);
			
			$.ajax({
				url: "${pageContext.request.contextPath}/amlCaseWorkFlow/searchCasesForSelfAssignment",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#selfCaseAssignmentSerachResultPanel"+id).css("display", "block");
					$("#selfCaseAssignmentSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
			
		});
		
		$("#viewEvidence"+id).click(function(){
			var caseNo = "";
			var count = 0;
			$("#selfCaseAssignmentSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				if($(this).children("td").children("input").prop("checked")){
					caseNo = $(this).children("td").children("input").val();
					count++;
				}
			});
			if(count == 0){
				alert("Select a record");
			}else if(count > 1){
				alert("Select only one record");
			} else {
			compassFileUpload.init("viewEvidence","${pageContext.request.contextPath}","5678","selfCaseAssignmentSerachResult"+id,"Y","Y");
			}
		});
		
		$("#assignCases"+id).click(function(){
			var searchButton = "searchSelfCaseAssignment${UNQID}"; 
			var selectedCases = "";
			var customerId = $("#customerId"+id).val();
			var customerType = $("#customerType"+id).val() === null ? "" : $("#customerType"+id).val();
			var caseRangeFrom = $("#caseRangeFrom"+id).val();
			var caseRangeTo = $("#caseRangeTo"+id).val();
			
			$("#selfCaseAssignmentSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var caseNo = $(this).children("td:nth-child(3)").html();
				if($(checkbox).prop("checked")){
					selectedCases = selectedCases + caseNo + ",";
				}
    		});
			//alert(selectedCases);
			var intSelectedCount = (selectedCases.split(",").length)-1;
			//alert(intSelectedCount);
			var selectedCase = selectedCases.substr(0,selectedCases.length-1);
			//alert(selectedCase);
			
			var fullData = "selectedCase="+selectedCase+"&CaseStatus=1&FlagType=Y&searchButton="+searchButton+
						   "&customerId="+customerId+"&customerType="+customerType+"&caseRangeFrom="+caseRangeFrom+"&caseRangeTo="+caseRangeTo;
			
			//alert(fullData);
			
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to assign.');
			} /*else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			}*/
			 else {
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Self Assign Cases");
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/openModalToAssignCasesToSelf",
					cache: false,
					type: "GET",
					data: fullData,
					success: function(response) {
						$("#compassCaseWorkFlowGenericModal-body").html(response);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					}
				});
			}
		});
		
		genericClear(id);
		
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_selfCaseAssignment">
			<div class="card-header panelSlidingSelfCaseAssignment${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.selfCaseAssignmentSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassSelfCaseAssignmentSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%"><spring:message code="app.common.FROMDATE"/></td>
						<td width="30%"><input type="text" class="form-control input-sm datepicker" name="fromDate" id="FROMDATE${UNQID}" /></td>
						<td width="10%">&nbsp;</td>
						<td width="15%"><spring:message code="app.common.TODATE"/></td>
						<td width="30%"><input type="text" class="form-control input-sm datepicker" name="toDate" id="TODATE${UNQID}" /></td>
					</tr>
					<tr>
						<td width="15%">Customer Type</td>
						<td width="30%">
							<%-- <select class="form-control input-sm selectpicker" name="custType" id="custType${UNQID}"> --%>
							<select class="selectpicker" id="customerType${UNQID}" name="customerType" multiple="multiple" data-live-search="true" data-width="100%"  title="Select an option">
								<!-- <option value="ALL">ALL</option> -->
								<c:forEach var="custType" items="${CUSTOMERTYPE}">
									<option value="${custType.key}">${custType.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Customer Id</td>
						<td width="30%">
							<div class="input-group" style="z-index: 1">
								<input type="text" class="form-control input-sm" name="customerId" id="customerId${UNQID}"/>
								<span class="input-group-addon formSearchIcon" id="basic-addon${UNQID}" 
									onclick="compassTopFrame.moduleSearch('customerId${UNQID}','CUSTOMERID','VW_CUSTOMERID_SEARCH','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
									<i class="fa fa-search"></i>
								</span>
							</div>
						</td>
					</tr>
					<tr>
						<td width="15%">Case Range From</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="caseRangeFrom${UNQID}" name="caseRangeFrom"/>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Case Range To</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="caseRangeTo${UNQID}" name="caseRangeTo"/>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchCasesForSelfAssignment${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
						<input type="button" id="clear${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="selfCaseAssignmentSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingSelfCaseAssignment${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.selfCaseAssignmentResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="selfCaseAssignmentSerachResult${UNQID}"></div>
			 <div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-primary btn-sm" id="viewComments${UNQID}" name="viewComments" value="View Comments" onclick="caseWorkFlowActions.viewComments('selfCaseAssignmentSerachResult${UNQID}','${UNQID}')"/>
					<input type="button" class="btn btn-success btn-sm" id="assignCases${UNQID}" name="assignCases" value="Assign Cases" />
					<input type="button" class="btn btn-warning btn-sm" id="viewEvidence${UNQID}" name="viewEvidence" value="View Evidence"/>
				</div>
			</div>
		</div>
	</div>
</div>