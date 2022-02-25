<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
	var id = '${UNQID}';
	var userRole = '${USERROLE}';
	compassTopFrame.init(id, 'compassReportingUsersSearchTable'+id, 'dd/mm/yy');
	
	if(userRole == 'MLRO' || userRole == 'ROLE_MLRO' || userRole == 'MLROL1' || userRole == 'ROLE_MLROL1' || userRole == 'MLROL2' || userRole == 'ROLE_MLROL2'){
		$(document).find("#saveMapping"+id).css({display:'none'});
	}else if(userRole == 'ADMIN' || userRole == 'ROLE_ADMIN' || userRole == 'AMLO' || userRole == 'ROLE_AMLO'){
		$(document).find("#viewDetails"+id).css({display:'none'});
		$(document).find("#mlroAction"+id).css({display:'none'});
	}
	
	$('.panelSlidingReportingUsers'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'reportingUsersSerachResultPanel'+id);
    });
	
	$("#searchReportingUsersMapping"+id).click(function(){
		var mainRow = $(this).parents(".compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		var userCodeField = $("#userCode"+id).val();
		var reportingUserCodeField = $("#reportingUserCode"+id).val();
		var reviewersCodeField = $("#reviewersCode"+id).val();
		var statusField = $("#status"+id).val();
		var fullData = "userCodeField="+userCodeField+"&reportingUserCodeField="+reportingUserCodeField+"&reviewersCodeField="+reviewersCodeField+"&statusField="+statusField;
		//alert(fullData);
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/searchReportingUsersMapping",
			cache: false,
			type: "POST",
			data: fullData+"&userRole="+userRole,
			success: function(res) {
				$("#reportingUsersSerachResultPanel"+id).css("display", "block");
				$("#reportingUsersSerachResult"+id).html(res);
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
	
	$("#saveMapping"+id).click(function(){
		var searchButton = "searchReportingUsersMapping${UNQID}"; 
		var fullData = "";
		var selectedCount = 0;
		var makerComments = "";
		var statusSelected = "";
		$("#reportingUsersSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
			var row = $(this).children("td").eq(0).children("input[type='checkbox']");
			if($(row).prop("checked")){
				var isChecked = $(this).children("td:nth-child(2)").find("select").val();
				var userCode = $(this).children("td:nth-child(3)").text().trim();
				var reportingUserCode = $(this).children("td:nth-child(4)").find("select").val();
				var reviewersCode = $(this).children("td:nth-child(5)").find("select").val();
				statusSelected = $(this).children("td:nth-child(6)").text().trim().charAt(0);
				fullData = fullData+isChecked+"--"+userCode+"--"+reportingUserCode+"--"+reviewersCode;
				selectedCount++;
			}
		});
		//alert("fullData="+fullData);
		if (selectedCount > 1 || selectedCount == 0){
			alert("Please select only one record at a time.");
		}else{
			if(statusSelected == "P"){
				alert("This record is already pending for checker.");
			}else{
				makerComments = prompt("Please enter comments.");
				fullData = fullData+"--"+makerComments+";";
				if(!makerComments == ""){
					$.ajax({
						url: "${pageContext.request.contextPath}/admin/saveMappingRepUser",
						cache: false,
						type: "POST",
						data: "fullData="+fullData,
						success: function(res) {
							alert(res);
							$("#"+searchButton).click();
						},
						error: function(a,b,c) {
							alert(a+b+c);
						} 
					});
				}else{
					alert("Maker's comment is necessary.");
				}
			}
		}
	});
	
	$("#viewDetails"+id).click(function(){
		var actionForModal = "View";
		var userCode = "";
		var selectedCount = 0;
		
		$("#reportingUsersSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
			var row = $(this).children("td").eq(0).children("input[type='checkbox']");
			if($(row).prop("checked")){
				userCode = $(this).children("td:nth-child(3)").text().trim();
				selectedCount++;
			}
		});
		
		if (selectedCount > 1 || selectedCount == 0){
			alert("You can select a single record only at a time.");
		}else{
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/getReportingUserComments",
				cache: false,
				data: "userCode="+userCode+"&actionForModal="+actionForModal,
				type: "POST",
				success: function(res) {
					$("#compassSearchModuleModal").modal('show');
					$("#compassSearchModuleModal-title").html("View Comments");
					$("#compassSearchModuleModal-body").html(res);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				} 
			});
		}
	});
	
	$("#mlroAction"+id).click(function(){
		var actionForModal = "Edit";
		var searchButton = "searchReportingUsersMapping${UNQID}";
		var userCode = "";
		var statusSelected = "";
		var selectedCount = 0;
		$("#reportingUsersSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
			var row = $(this).children("td").eq(0).children("input[type='checkbox']");
			if($(row).prop("checked")){
				userCode = $(this).children("td:nth-child(3)").text().trim();
				statusSelected = $(this).children("td:nth-child(6)").text().trim();
				selectedCount++;
			}
		});
		
		if (selectedCount > 1 || selectedCount == 0){
			alert("Please select only one record at a time.");
		}else{
			if(statusSelected.charAt(0) == "A" || statusSelected.charAt(0) == "R"){
				alert("Please select a pending record.");
			}else{
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/getReportingUserComments",
					cache: false,
					data: "userCode="+userCode+"&searchButton="+searchButton+"&actionForModal="+actionForModal,
					type: "POST",
					success: function(res) {
						$("#compassSearchModuleModal").modal('show');
						$("#compassSearchModuleModal-title").html("Add Comments");
						$("#compassSearchModuleModal-body").html(res);
					},
					error: function(a,b,c) {
						alert(a+b+c);
					} 
				});
			}
		}
	});
	
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_reportingUsers">
			<div class="card-header panelSlidingReportingUsers${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Reporting Users Mapping</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassReportingUsersSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">User Code</td>
						<td width="30%">
							<div class="userCodeFields">
								<select class="form-control input-sm" id="userCode${UNQID}" name="reportingUserCode" style="width: 100%;">
									<option value="ALL">ALL</option>
									<c:forEach var="LISTVALUE" items="${USERSLIST}">
										<option value="${LISTVALUE.key}">${LISTVALUE.key}</option>
									</c:forEach>
								</select>
							</div>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Reporting User Code</td>
						<td width="30%">
							<div class="reportingUserCodeFields">
								<select class="form-control input-sm" id="reportingUserCode${UNQID}" name="reportingUserCode" style="width: 100%;">
									<option value="ALL">ALL</option>
									<c:forEach var="LISTVALUE" items="${REPORTINGUSERSLIST}">
										<option value="${LISTVALUE.key}">${LISTVALUE.key}</option>
									</c:forEach>
								</select>
							</div>
						</td>
					</tr>
					<tr>
						<td width="15%">Reviewer's Code</td>
						<td width="30%">
							<div class="reviewersCodeFields">
								<select class="form-control input-sm" id="reviewersCode${UNQID}" name="reviewersCode" style="width: 100%;">
									<option value="ALL">ALL</option>
									<c:forEach var="LISTVALUE2" items="${REVIEWERUSERSLIST}">
										<option value="${LISTVALUE2.key}">${LISTVALUE2.key}</option>
									</c:forEach>
								</select>
							</div>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Status</td>
						<td width="30%">
							<div class="statusFields">
								<select class="form-control input-sm" id="status${UNQID}" name="status" style="width: 100%;">
									<option value="ALL">ALL</option>
									<option value="P">Pending</option>
									<option value="A">Approved</option>
									<option value="R">Rejected</option>
								</select>
							</div>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchReportingUsersMapping${UNQID}" class="btn btn-primary btn-sm" name="Search" value="Search">Search</button>
						<input type="reset" id="clearReportingUsersMapping${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear">
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="reportingUsersSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingReportingUsers${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Reporting Users Mapping List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="reportingUsersSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-primary btn-sm" id="viewDetails${UNQID}" name="View" value="View"/>
					<input type="button" class="btn btn-success btn-sm" id="mlroAction${UNQID}" name="MlroAction" value="Approve/Reject"/>
					<input type="button" class="btn btn-success btn-sm" id="saveMapping${UNQID}" name="SaveMapping" value="Save Mapping"/>
				</div>
			</div>
		</div>
	</div>
</div>