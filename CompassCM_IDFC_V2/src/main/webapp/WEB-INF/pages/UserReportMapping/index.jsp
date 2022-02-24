<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'userReportMappingDetailsTable';
		compassDatatable.construct(tableClass, "User Report Mapping Details", false);
		compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingUserReportMapping'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'userReportMappingSerachResultPanel');
	    });

		/* function showUsersList(elm){
			var selectedUserRole = $(elm).val();
			alert(selectedUserRole);
		} */
		
		$("#userRole"+id).on("change", function(){
			var userRoleValue = $(this).val();
			//alert(userRoleValue);
			
			var userCodesArr = [];
			var roleIdVal = "";
			
			<c:forEach var="userRoleMaps" items="${PARAMDATA['USERROLEMAPPING']}">
				<c:set var="roleId" value="${userRoleMaps.key}"></c:set>
				 roleIdVal = '<c:out value="${roleId}"/>';
					if(roleIdVal == userRoleValue){
						<c:set var="userCodes" value="${userRoleMaps.value}"></c:set>
						<c:forEach var="userCode" items="${userCodes}">
							userCodesArr.push("${userCode}");
						</c:forEach>
					}
			</c:forEach>
			
			var userCodesOptionsString = "<option value=''>Select User Code</option>";
			if(userCodesArr.length > 0){
			//	$("#userCodeField").css("display", "table-row");
				$("#userCode"+id).prop("disabled", false);
				$.each(userCodesArr,function(i,value){
					userCodesOptionsString += "<option value = '"+value+"'>"+value+"</option>"
				});
					
				$("#userCode"+id).empty().append(userCodesOptionsString); 
			}
		});
		
		$("#reportType"+id).on("change", function(){
			var reportTypeValue = $(this).val();
			//alert(reportTypeValue);
			$("#reportName"+id).prop("disabled", true);
			var reportNamesArr = [];
			var reportTypeVal = "";
			
			<c:forEach var="reportDetailsMaps" items="${PARAMDATA['REPORTSMAPPING']}">
				<c:set var="reportType" value="${reportDetailsMaps.key}"></c:set>
				<c:set var="reportIdNameList" value="${reportDetailsMaps.value}"></c:set>
				reportTypeVal = '<c:out value="${reportType}"/>';
					if(reportTypeVal == reportTypeValue){
						<c:forEach var="reportIdNameMaps" items="${reportIdNameList}">
							<c:forEach var="reportIdNameMap" items="${reportIdNameMaps}">
								reportNamesArr.push({"REPORTID":"${reportIdNameMap.key}", "REPORTNAME":"${reportIdNameMap.value}"});
							</c:forEach>
						</c:forEach>
					}
			</c:forEach>
						
			var reportNamesOptionsString = "<option value='ALL'>ALL</option>";
			if(reportNamesArr.length > 0){
			//	$("#reportNameField").css("display", "table-row");
				$("#reportName"+id).prop("disabled", false);
				$.each(reportNamesArr,function(key,value){
					reportNamesOptionsString += "<option value = '"+value['REPORTID']+"'>"+value['REPORTNAME']+"</option>"
				});
					
				$("#reportName"+id).empty().append(reportNamesOptionsString); 
			}
		});
		
		$("#searchUserReportMapping"+id).click(function(){
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			//var userRole = $("#userRole"+id).val();
			var userCode = $("#userCode"+id).val();
			var reportType = $("#reportType"+id).val();
			var reportName = $("#reportName"+id).val();
			
			var fullData = "userCode="+userCode+"&reportType="+reportType+"&reportId="+reportName;
			//alert(fullData);
			console.log("1 = "+(userCode != '' && (reportName != '' && reportType != 'ALL' )));
			console.log("2 = "+(userCode != '' && reportType == 'ALL' ));
			console.log("3 = "+(userCode != '' && reportType != 'ALL' ));
			
			//if((userCode != '' && (reportName != '' && reportType != 'ALL' )) || (userCode != '' && reportType == 'ALL' )){
			if((userCode != '' && (reportName != 'ALL' && reportType != 'ALL' )) || (userCode != '' && reportType == 'ALL' ) || (userCode != '' && reportType != 'ALL' )){	
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/searchUserReportMapping",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res) {
						$("#userReportMappingSerachResultPanel"+id).css("display", "block");
						$("#userReportMappingSerachResult"+id).html(res);
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
				alert("Please select user code & report name.");
			}
		});
		
	$("#saveMapping"+id).click(function(){
		//alert($("#userReportMappingBottomFrame"+id)."selectedMappingType".value());
		//var selectedMappingType = $("#selectedMappingType").val();	
		//alert(selectedMappingType);
		var fullData = "";
		var table = $("#userReportMappingSerachResult"+id).find("table").children("tbody");
		var selectedUserCode = "";	
		var selectedReportId = "";
		var selectedReportType = "";
		var isChecked = "";
		$(table).children("tr").each(function(){		
			var checkbox = $(this).children("td:first-child").children("input[type='checkbox']");
			console.log($(checkbox).prop("checked"));
			if($(checkbox).prop("checked") === true){
				console.log("ischecked");
				isChecked = "Y";
			}else{
				console.log("is not checked");
				isChecked = "N";
			}
			console.log("isChecked = "+isChecked);
			selectedUserCode = $(this).children("td:nth-child(2)").html();
			selectedReportType = $(this).children("td:nth-child(3)").html();
			selectedReportId = $(this).children("td:nth-child(4)").html();
			
			//selectedReportType = $(checkbox).val();
			if((selectedUserCode !== undefined) && (selectedReportId !== undefined)){
				fullData = fullData + isChecked+","+selectedUserCode+","+selectedReportId+","+selectedReportType+"|~|" ;
				console.log("fullData = "+fullData);
			}
		});
		//console.log("fullData = "+fullData);
		 //alert(fullData);
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/saveUserReportMapping",
			cache: false,
			type: "POST",
			data: "fullData="+fullData,
			success: function(res) {
				alert(res);
				$("#searchUserReportMapping"+id).click();
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});  
	});			
			
});

</script>
<c:set var="paramsData" value="${PARAMDATA}"></c:set>
<c:set var="USERROLEMAPPING" value="${paramsData['USERROLEMAPPING']}"></c:set>
<c:set var="REPORTSMAPPING" value="${paramsData['REPORTSMAPPING']}"></c:set>
<c:forEach var="reportDetailsMaps" items="${REPORTSMAPPING}">
	<c:set var="reportType" value="${reportDetailsMaps.key}"></c:set>
	<c:set var="reportIdNameList" value="${reportDetailsMaps.value}"></c:set>
	<c:forEach var="reportIdNameMaps" items="${reportIdNameList}">
		<c:forEach var="reportIdNameMap" items="${reportIdNameMaps}">
			<%-- ${reportIdNameMap.key} --%>
		</c:forEach>
	</c:forEach>
</c:forEach>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_userReportMapping">
			<div class="card-header panelSlidingUserReportMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.userReportMappingSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">User Role</td>
						<td width="30%">
							<select class="form-control input-sm" id="userRole${UNQID}" name="userRole" style="width: 100%;">
								<option value="">Select User Role</option>	
								<c:forEach var="userRoleMaps" items="${USERROLEMAPPING}">
									<c:set var="roleId" value="${userRoleMaps.key}"></c:set>
									<option value="${roleId}">${roleId}</option>
								</c:forEach>
							</select>
						<td width="10%">&nbsp;</td>
						<td width="15%">Report Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="reportType${UNQID}" name="reportType" style="width: 100%;">
								<option value="ALL">ALL</option>						
								<c:forEach var="reportMap" items="${REPORTSMAPPING}">
									<c:set var="reportType" value="${reportMap.key}"></c:set>
									<option value="${reportType}">${reportType}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>
						<td width="15%">User Code</td>
						<td width="30%">
							<select class="form-control input-sm" id="userCode${UNQID}" name="userCode" style="width: 100%;" disabled="disabled">
								<option value="">Select User Code</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Report Name</td>
						<td width="30%">
							<select class="form-control input-sm" id="reportName${UNQID}" name="reportName" style="width: 100%;" disabled="disabled">
								<option value="ALL">ALL</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchUserReportMapping${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="userReportMappingSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingUserReportMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.userReportMappingResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="userReportMappingSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
				<input type="button" class="btn btn-primary btn-sm" id="saveMapping${UNQID}" name="saveMapping" value="Save"/>
				</div>
			</div>
		</div>
	</div>
</div>