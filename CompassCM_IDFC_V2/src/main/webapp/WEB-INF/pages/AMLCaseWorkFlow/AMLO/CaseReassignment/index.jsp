<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		compassTopFrame.init(id, 'compassCaseReassignmentSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingCaseReassignment'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'caseReassignmentSerachResultPanel'+id);
	    });
 
		$("#pendingWith"+id+", #closedBy"+id).on("change", function(){
			if($(this).val() == "AMLO"){
				$("#userListFields").css("display", "none");
				$("#amloListFields").css("display", "table-row");
				$("#amlUserListFields").css("display", "none");
				$("#mlroListFields").css("display", "none");
			}
			else if($(this).val() == "USER"){
				$("#userListFields").css("display", "table-row");
				$("#amloListFields").css("display", "none");
				$("#amlUserListFields").css("display", "none");
				$("#mlroListFields").css("display", "none");
			}
			else if($(this).val() == "AMLUSER"){
				$("#userListFields").css("display", "none");
				$("#amloListFields").css("display", "none");
				$("#amlUserListFields").css("display", "table-row");
				$("#mlroListFields").css("display", "none");
			}
		});
		
		$("#reassignmentFor"+id).on("change", function(){
			if($(this).val() == "PendingCases"){
				$(".pendingCasesDiv").css("display", "block");
				$(".closedCasesDiv").css("display", "none");
			}
			if($(this).val() == "ClosedCases"){
				$(".closedCasesDiv").css("display", "block");
				$(".pendingCasesDiv").css("display", "none");
			}
		});
		
		$("#searchCaseReassignment"+id).click(function(){
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			var fromDate = $("#FROMDATE"+id).val();
			var toDate = $("#TODATE"+id).val();
			var reassignmentFor = $("#reassignmentFor"+id).val();
			var pendingWith = $("#pendingWith"+id).val();
			var closedBy = $("#closedBy"+id).val();
			var pendingWithUsersCode = "";
			var closedByUsersCode = "";
			
			if(pendingWith == "USER")
				pendingWithUsersCode = $("#userList"+id).val();
			if(closedBy == "USER")
				closedByUsersCode = $("#userList"+id).val();
			
			if(pendingWith == "AMLUSER")
				pendingWithUsersCode = $("#amlUserList"+id).val();
			if(closedBy == "AMLUSER")
				closedByUsersCode = $("#amlUserList"+id).val();
			
			if(pendingWith == "AMLO")
				pendingWithUsersCode = $("#amloList"+id).val();
			if(closedBy == "AMLO")
				closedByUsersCode = $("#amloList"+id).val();
			
			var fullData = "fromDate="+fromDate+"&toDate="+toDate+"&reassignmentFor="+reassignmentFor+"&pendingWith="+pendingWith+
						   "&pendingWithUsersCode="+pendingWithUsersCode+"&closedBy="+closedBy+"&closedByUsersCode="+closedByUsersCode;
			//alert(fullData);
			if(reassignmentFor != 'all' && (pendingWith != 'all' || closedBy != 'all')){
			$.ajax({
				url: "${pageContext.request.contextPath}/amlCaseWorkFlow/searchCaseReassignment",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#caseReassignmentSerachResultPanel"+id).css("display", "block");
					$("#caseReassignmentSerachResult"+id).html(res);
					$(panelBody).slideUp();
					$(slidingDiv).addClass('card-collapsed');
					$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
					$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
			}else{
				alert("Please select options for reassignment for and pending with/closed by.");
			}
		});
		
		$("#viewEvidence"+id).click(function(){
			var caseNo = "";
			var count = 0;
			$("#caseReassignmentSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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
			compassFileUpload.init("viewEvidence","${pageContext.request.contextPath}","5678","caseReassignmentSerachResult"+id,"Y","Y");
			}
		});
		
		$("#reassignCases"+id).click(function(){
			var searchButton = "searchCaseReassignment${UNQID}"; 
			var selectedCases = "";
			var pendingWith = $("#pendingWith"+id).val();
			var closedBy = $("#closedBy"+id).val();
			var roleId = "";
			var reassignmentFor = $("#reassignmentFor"+id).val();
			if(reassignmentFor == "PendingCases")
				roleId = pendingWith;
			if(reassignmentFor == "ClosedCases")
				roleId = closedBy;
			
			var pendingWithUsersCode = "";
			var closedByUsersCode = "";
			
			if(pendingWith == "USER")
				pendingWithUsersCode = $("#userList"+id).val();
			if(closedBy == "USER")
				closedByUsersCode = $("#userList"+id).val();
			
			if(pendingWith == "AMLUSER")
				pendingWithUsersCode = $("#amlUserList"+id).val();
			if(closedBy == "AMLUSER")
				closedByUsersCode = $("#amlUserList"+id).val();
			
			if(pendingWith == "AMLO")
				pendingWithUsersCode = $("#amloList"+id).val();
			if(closedBy == "AMLO")
				closedByUsersCode = $("#amloList"+id).val();
			
			
			$("#caseReassignmentSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
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
			
			var fullData = "selectedCase="+selectedCase+"&CaseStatus=1&FlagType=Y&roleId="+roleId+"&reassignmentFor="+reassignmentFor+
						   "&pendingWith="+pendingWith+"&pendingWithUsersCode="+pendingWithUsersCode+"&closedBy="+closedBy+
						   "&closedByUsersCode="+closedByUsersCode+"&searchButton="+searchButton;
			//alert(fullData);
			if(intSelectedCount == 0 ) {
			   alert('Please select atleast one case to assign.');
			} /*else if(intSelectedCount > 1 ) {
			   alert('Please select only one case to assign.');
			}*/
			 else {
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Reassign Case");
				$.ajax({
					url: "${pageContext.request.contextPath}/amlCaseWorkFlow/reAssignToUser",
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
		
		//Called the generic clear function
		genericClear(id);
		
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_caseReassignment">
			<div class="card-header panelSlidingCaseReassignment${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.caseReassignmentSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassCaseReassignmentSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%"><spring:message code="app.common.FROMDATE"/></td>
						<td width="30%"><input type="text" class="form-control input-sm datepicker" name="fromDate" id="FROMDATE${UNQID}" /></td>
						<td width="10%">&nbsp;</td>
						<td width="15%"><spring:message code="app.common.TODATE"/></td>
						<td width="30%"><input type="text" class="form-control input-sm datepicker" name="toDate" id="TODATE${UNQID}" /></td>
					</tr>
					<tr>
						<td width="15%"><spring:message code="app.common.reassignmentFor"/></td>
						<td width="30%">
							<select class="form-control input-sm" id="reassignmentFor${UNQID}" name="reassignmentFor" style="width: 100%;">
								<option value="">Select</option>
								<option value="PendingCases">Pending Cases</option>
								<option value="ClosedCases">Closed Cases</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">
							<div class="pendingCasesDiv" style="display: none;"><spring:message code="app.common.pendingWith"/></div>
							<div class="closedCasesDiv" style="display: none;"><spring:message code="app.common.closedBy"/></div>
						</td>
						<td width="30%">
							<div class="pendingCasesDiv" style="display: none;">
								<select class="form-control input-sm" id="pendingWith${UNQID}" name="pendingWith" style="width:100%;">
									<option value="">Select Role</option>
									<!-- <option value="USER">User</option> -->								
									<option value="AMLUSER">Assigned User</option>
									<option value="AMLO">AMLO</option>
								</select>
							</div>
							<div class="closedCasesDiv" style="display: none;">
								<select class="form-control input-sm" id="closedBy${UNQID}" name="closedBy" style="width:100%;">
									<option value="">Select Role</option>
									<!-- <option value="USER">User</option> -->								
									<option value="AMLUSER">Assigned User</option>
									<!-- <option value="AMLO">AMLO</option> -->
								</select>
							</div>
						</td>
					</tr>
					<tr id = "userListFields" style="display: none;">
						<td width="15%"><spring:message code="app.common.userList"/></td>
						<td width="30%">
							<select class="form-control input-sm" id="userList${UNQID}" name="userList" style="width: 100%;">
								<option value="">Select</option>
								<c:forEach var="LISTVALUE" items="${USERLIST}">
									<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<tr id = "amloListFields" style="display: none;">
					<td width="15%"><spring:message code="app.common.amlosList"/></td>
					<td width="30%">
						<select class="form-control input-sm" id="amloList${UNQID}" name="amloList" style="width: 100%;">
							<option value="">Select</option>
							<c:forEach var="LISTVALUE" items="${AMLOLIST}">
								<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
							</c:forEach>
						</select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id = "amlUserListFields" style="display: none;">
					<td width="15%"><spring:message code="app.common.amlusersList"/></td>
					<td width="30%">
						<select class="form-control input-sm" id="amlUserList${UNQID}" name="amlUserList" style="width: 100%;">
							<option value="">Select</option>
							<c:forEach var="LISTVALUE" items="${AMLUSERLIST}">
								<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
							</c:forEach>
						</select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchCaseReassignment${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
						<%-- <input type="reset" id="clearCaseReassignment${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"> --%>
						<!-- 28.05.2019 -->
						<input type="button" id="clear${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"/>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="caseReassignmentSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingCaseReassignment${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.caseReassignmentResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="caseReassignmentSerachResult${UNQID}"></div>
			 <div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-primary btn-sm" id="viewComments${UNQID}" name="viewComments" value="View Comments" onclick="caseWorkFlowActions.viewComments('caseReassignmentSerachResult${UNQID}','${UNQID}')"/>
					<input type="button" class="btn btn-success btn-sm" id="reassignCases${UNQID}" name="reassignCases" value="Reassign Cases" />
					<input type="button" class="btn btn-warning btn-sm" id="viewEvidence${UNQID}" name="viewEvidence" value="View Evidence"/>
				</div>
			</div>
		</div>
	</div>
</div>