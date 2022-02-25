<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#searchUserForUserRoleMappingSelect").select2();
	
	$("#searchUserForUserRoleMapping").click(function(){
		var usercode = $("#searchUserForUserRoleMappingSelect").val();
		var searchBtn = $(this);
		$(searchBtn).attr("disabled","disabled");
		$(searchBtn).html("Searching...");
		$("#searchUserForUserRoleMappingSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
    		url : "${pageContext.request.contextPath}/cmUAMMaker/searchUserForGroupMapping?usercode="+usercode,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			$(searchBtn).removeAttr("disabled");
    			$(searchBtn).html("Search");
    			$("#searchUserForUserRoleMappingSearchResult").html(resData);
    		},
    		error : function(){
    			$("#searchUserForUserRoleMappingSearchResult").html("Something went wrong");
    		}
    	});	
	});
	
	$("#searchGroupForUserRoleMapping").click(function(){
		var roleId = $("#searchGroupForUserRoleMappingSelect").val();
		var searchBtn = $(this);
		$(searchBtn).attr("disabled","disabled");
		$(searchBtn).html("Searching...");
		$("#searchUserForUserRoleMappingSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
    		url : "${pageContext.request.contextPath}/cmUAMMaker/searchGroupForUserMapping?roleId="+roleId,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			$(searchBtn).removeAttr("disabled");
    			$(searchBtn).html("Search");
    			$("#searchUserForUserRoleMappingSearchResult").html(resData);
    		},
    		error : function(){
    			$("#searchUserForUserRoleMappingSearchResult").html("Something went wrong");
    		}
    	});	
	});
});
</script>
<div class="row">
	<div class="col-sm-6">
		<div class="card card-primary">
			<div class="card-header userRoleMapping_searchUser clearfix">
				<h6 class="card-title pull-${dirL}">User-Group Mapping</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable userRoleMappingUserTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">UserCode</td>
							<td width="70%">
								<select class="form-control input-sm" id="searchUserForUserRoleMappingSelect">
									<c:forEach items="${ALLUSER}" var="userDetails">
										<option value="${userDetails['VALUE']}">${userDetails['DISPLAY']}&#x200E;</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="searchUserForUserRoleMapping" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
	
	<div class="col-sm-6">
		<div class="card card-primary">
			<div class="card-header userRoleMapping_searchRole clearfix">
				<h6 class="card-title pull-${dirL}">Group-User Mapping</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable userRoleMappingRoleTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">Group</td>
							<td width="70%">
								<select class="form-control input-sm" id="searchGroupForUserRoleMappingSelect">
									<c:forEach items="${ALLROLES}" var="roleDetails">
										<option dir="ltr" value="${roleDetails}">${roleDetails}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="searchGroupForUserRoleMapping" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="searchUserForUserRoleMappingSearchResult"></div>