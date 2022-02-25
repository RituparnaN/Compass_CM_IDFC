<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var tableClass = 'userAlertMappingDetailsTable';
		compassDatatable.construct(tableClass, "User Alert Mapping Details", false);
		compassTopFrame.init(id, 'compassModuleDetailsSearchTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingUserAlertMapping'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'userAlertMappingSerachResultPanel');
	    });

		$("#userLevel"+id).on("change", function(){
			var userLevelValue = $(this).val();
			//alert(userLevelValue);
			if(userLevelValue == "AMLO"){
				$("#userListFields").css("display", "none");
				$("#amloListFields").css("display", "table-row");
				$("#amlUserListFields").css("display", "none");
				$("#mlroListFields").css("display", "none");
			}
			else if(userLevelValue == "USER"){
				$("#userListFields").css("display", "table-row");
				$("#amloListFields").css("display", "none");
				$("#amlUserListFields").css("display", "none");
				$("#mlroListFields").css("display", "none");
			}
			else if(userLevelValue == "AMLUSER" || 
					userLevelValue == "AMLUSERL1" || 
					userLevelValue == "AMLUSERL2" || 
					userLevelValue == "AMLUSERL3" ){
				$("#userListFields").css("display", "none");
				$("#amloListFields").css("display", "none");
				$("#amlUserListFields").css("display", "table-row");
				$("#mlroListFields").css("display", "none");
			}
			else if(userLevelValue == "MLRO"){
				$("#userListFields").css("display", "none");
				$("#amloListFields").css("display", "none");
				$("#amlUserListFields").css("display", "none");
				$("#mlroListFields").css("display", "table-row");
			}
		});
		
		$("#searchUserALertMapping"+id).click(function(){
			var mainRow = $(this).parents(".compassrow"+id);
			var slidingDiv = $(mainRow).children().children().children();
			var panelBody = $(mainRow).children().children().find(".panelSearchForm");
			
			var userCode = "";
			var mappingType = $("#mappingType"+id).val();
			var userLevel = $("#userLevel"+id).val();
			if(userLevel == "USER")
				userCode = $("#userList"+id).val();
			if(userLevel == "AMLUSER" || 
			   userLevel == "AMLUSERL1" || 
			   userLevel == "AMLUSERL2" || 
			   userLevel == "AMLUSERL3" )
				userCode = $("#amlUserList").val();
			if(userLevel == "AMLO")
				userCode = $("#amloList").val();
			if(userLevel == "MLRO")
				userCode = $("#mlroList").val();
			
			var fullData = "mappingType="+mappingType+"&userLevel="+userLevel+"&userCode="+userCode;
		
			if(mappingType != 'ALL' && userLevel != 'ALL' ){
				//alert(fullData);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/searchUserALertMapping",
				cache: false,
				type: "POST",
				data: fullData,
				success: function(res) {
					$("#userAlertMappingSerachResultPanel"+id).css("display", "block");
					$("#userAlertMappingSerachResult"+id).html(res);
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
				alert("Please select mapping type and user level.");
			}
		});
		
			$("#saveAssignment"+id).click(function(){
			//alert($("#userAlertMappingBottomFrame"+id)."selectedMappingType".value());
			//var selectedMappingType = $("#selectedMappingType").val();	
			//alert(selectedMappingType);
			var fullData = $("#selectedUserCode").val()+","+$("#selectedUserLevel").val()+","+$("#selectedMappingType").val()+",NOT.AVAILABLE;";
			var table = $("#userAlertMappingSerachResult"+id).find("table").children("tbody");
			var selectedUserCode = "";	
			var selectedUserLevel = "";
			var selectedFieldType = "";
			var selectedFieldValue = "";
			$(table).children("tr").each(function(){
				var checkbox = $(this).children("td:first-child").children("input");
				var userCode = $(this).children("td:nth-child(2)").html();
				var userLevel = $(this).children("td:nth-child(3)").html();
				var fieldType = $(this).children("td:nth-child(4)").html();
				var fieldValue = $(this).children("td:nth-child(5)").html();
				if($(checkbox).prop("checked")){
					selectedUserCode = userCode;
					selectedUserLevel = userLevel;
					selectedFieldType = fieldType;
					selectedFieldValue = fieldValue;
					fullData = fullData + selectedUserCode+","+selectedUserLevel+","+selectedFieldType+","+selectedFieldValue+";" ;
				}
			});
			// alert(fullData);
			$.ajax({
				url: "${pageContext.request.contextPath}/admin/saveAssignment",
				cache: false,
				type: "POST",
				data: "fullData="+fullData,
				success: function(res) {
					alert(res);
				},
				error: function(a,b,c) {
					alert(a+b+c);
			}
			});
	});
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_userAlertMapping">
			<div class="card-header panelSlidingUserAlertMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.userAlertMappingSearchHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped compassModuleDetailsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Mapping Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="mappingType${UNQID}" name="mappingType" style="width: 100%;">
								<option value="ALL">ALL</option>
								<option value="AlertCodeMapping">AlertCodeMapping</option>
								<!-- <option value="AccountMapping">AccountMapping</option>
								<option value="BranchMapping">BranchMapping</option>
								<option value="CustomerTypeMapping">CustomerTypeMapping</option>
								<option value="ProductCodeMapping">ProductCodeMapping</option>
								<option value="RiskRatingMapping">RiskRatingMapping</option> -->
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">User Level</td>
						<td width="30%">
							<select class="form-control input-sm" id="userLevel${UNQID}" name="userLevel" style="width: 100%;">
								<option value="ALL">ALL</option>						
								<option value="AMLUSER">AMLUser</option>
								<!-- <option value="AMLUSERL1">AMLUserL1</option>
								<option value="AMLUSERL2">AMLUserL2</option>
								<option value="AMLUSERL3">AMLUserL3</option> -->
								<!-- <option value="USER">User</option>		
								<option value="AMLO">AMLO</option>
								<option value="MLRO">MLRO</option> -->
							</select>
						</td>
					</tr>
					<%-- <tr id = "userListFields" style="display: none;">
						<td width="15%">USER List</td>
						<td width="30%">
							<select class="form-control input-sm" id="userList${UNQID}" name="userList" style="width: 100%;">
								<c:forEach var="LISTVALUE" items="${USERLIST}">
									<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr> --%>
				<%-- 	<tr id = "amloListFields" style="display: none;">
						<td width="15%">AMLO List</td>
						<td width="30%">
							<select class="form-control input-sm" id="amloList" name="amloList" style="width: 100%;">
									<c:forEach var="LISTVALUE" items="${AMLOLIST}">
										<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
									</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr> --%>
					<tr id = "amlUserListFields" style="display: none;">
						<td width="15%">AMLUser List</td>
						<td width="30%">
							<select class="form-control input-sm" id="amlUserList" name="amlUserList" style="width: 100%;">
								<c:forEach var="LISTVALUE" items="${AMLUSERLIST}">
									<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
					<%-- <tr id = "mlroListFields" style="display: none;">
						<td width="15%">MLRO List</td>
						<td width="30%"> 
							<select class="form-control input-sm" id="mlroList" name="mlroList" style="width: 100%;">
								<c:forEach var="LISTVALUE" items="${MLROLIST}">
									<option value="${LISTVALUE.key}">${LISTVALUE.value}</option>
								</c:forEach>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr> --%>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="button" id="searchUserALertMapping${UNQID}" class="btn btn-success btn-sm" name="Search" value="Search">Search</button>
					</div>
				</div>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="userAlertMappingSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingUserAlertMapping${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.userAlertMappingResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="userAlertMappingSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
				<input type="button" class="btn btn-primary btn-sm" id="saveAssignment${UNQID}" name="SaveAssignment" value="Save Assignment"/>
				</div>
			</div>
		</div>
	</div>
</div>