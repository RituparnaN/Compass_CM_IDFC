<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	var userselected = '${SELECTEDUSER}';
	var tableName = $("#tableName"+id).val();
	var makerCode = $("#makerCode"+id).val();
	
	$("#searchUserForEditSelect"+id).select2();

	$("#searchUserForEditStatus"+id).click(function(){
		var userCode = $("#searchUserForEditSelect"+id).val();
		var employeeCode = $("#employeeCode"+id).val();
		var employeeName = "";
		var searchBtn = $("#searchUserForEditStatus"+id);
	
		if(userCode == 'ALL' && employeeCode == 'ALL'){
			alert("Please select atleast one parameter to search.");
		}else{
			$(searchBtn).attr("disabled","disabled");
			$(searchBtn).html("Searching...");
			$("#searchResult"+id).html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			//alert(userCode);
			//alert(makerCode);
			$.ajax({
	    		url : "${pageContext.request.contextPath}/cmUAMMaker/getAllStatusOfUser",
	    		cache : false,
	    		data : "userCode="+userCode+"&employeeCode="+employeeCode+"&employeeName="+employeeName+"&elmId="+id,
	    		type : 'POST',
	    		success : function(resData){
	    			$("#searchResult"+id).html(resData);
	    		},complete:function(){
	    			$(searchBtn).removeAttr("disabled");
	    			$(searchBtn).html("Search");
	    		},
	    		error : function(){
	    			$("#editUserSearchResult"+id).html("Something went wrong");
	    		}
	    	});
		}
	});
});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header editUser_search clearfix">
				<h6 class="card-title pull-${dirL}">Search User</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable editUserTable" style="margin-bottom: 0px;">
					<tbody>
						<%-- <tr><td>${ALLUSER}</td></tr> --%>
						<tr>
							<td width="20%">User Code</td>
							<td width="25%">
								<select class="form-control input-sm" style="height: 30px" id="searchUserForEditSelect${UNQID}">
									<option value="ALL">Select User Code</option>
									<c:forEach items="${ALLUSER}" var="userDetails">
										<option value="${userDetails['VALUE']}"
										 <c:if test="${userDetails['VALUE'] == SELECTEDUSER}"> selected </c:if> 
										 >${userDetails['DISPLAY']}&#x200E;</option>
									</c:forEach>
								</select>
							</td>
							<td width="10%">&nbsp;</td>
							<td width="20%">Employee Code</td>
							<td width="25%">
								<select class="form-control input-sm" style="height: 30px" id="employeeCode${UNQID}">
									<option value="ALL">Select Employee Code</option>
									<c:forEach items="${ALLEMPCODES}" var="employeeDetails">
										<option value="${employeeDetails['EMPCODE']}">${employeeDetails['EMPCODE']}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<%-- <tr>
							<td width="20%">Employee Name</td>
							<td width="25%">
								<input type="text" class="form-control input-sm" style="height: 30px" id="employeeName${UNQID}">
							</td>
							<td colspan="3">&nbsp;</td>
						</tr> --%>
						<tr style="display: none;">
							<td>
								<select class="form-control input-sm" style="height: 30px" id="tableName${UNQID}">
									<c:forEach items="${ALLUSER}" var="tableDetails">
										<option value="${tableDetails['TABLE']}"
										 <c:if test="${userDetails['VALUE'] == SELECTEDUSER}"> selected </c:if>>${userDetails['DISPLAY']}</option>
									</c:forEach>
								</select>
							</td>
							<td>
								<select class="form-control input-sm" style="height: 30px"  id="makerCode${UNQID}">
									<c:forEach items="${ALLUSER}" var="makerDetails">
										<option value="${makerDetails['MAKERCODE']}"
										 <c:if test="${userDetails['VALUE'] == SELECTEDUSER}"> selected </c:if>>${userDetails['DISPLAY']}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="searchUserForEditStatus${UNQID}" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="searchResult${UNQID}"></div>