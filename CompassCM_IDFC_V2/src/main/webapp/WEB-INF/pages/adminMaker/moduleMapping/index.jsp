<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#searchUserForModuleMappingSelect").on("change", function(){
			var userCode = $(this).val();
			var select = "<select class='form-control input-sm' id='searchGroupForUserModuleMappingSelect'><option value='ALL'>Select one</option>";
	
			$.ajax({
				url: "${pageContext.request.contextPath}/adminMaker/getGroupCode",
				cache: false,
				type: "POST",
				data: "userCode="+userCode,
				success: function(res) {
					$.each(res, function(k,v){
						select = select + "<option values='"+v.GROUPCODE+"'>"+v.GROUPCODE+"</option>"
					});
					select = select + "</select>";
					$("#groupCodeTd").html(select);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
	    });
	
	$("#searchGroupForModuleMapping").click(function(){
		var groupCode = $("#searchGroupForGroupModuleMappingSelect").val();
		$.ajax({
			url: "${pageContext.request.contextPath}/adminMaker/searchGroupForModuleMapping",
			cache: false,
			type: "POST",
			data: "groupCode="+groupCode,
			success: function(res) {
				$("#moduleMappingSearchResult").html(res);
			},
			error: function(a,b,c) {
				alert(a+b+c);
			}
		});
	});
});
</script>
	<%--	$("#searchUserForUserRoleMappingSelect").select2();
	
	$("#searchUserForUserRoleMapping").click(function(){
		var usercode = $("#searchUserForUserRoleMappingSelect").val();
		var searchBtn = $(this);
		$(searchBtn).attr("disabled","disabled");
		$(searchBtn).html("Searching...");
		$("#searchUserForUserRoleMappingSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
    		url : "${pageContext.request.contextPath}/adminMaker/searchUserForGroupMapping?usercode="+usercode,
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
    		url : "${pageContext.request.contextPath}/adminMaker/searchGroupForUserMapping?roleId="+roleId,
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
--%>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header groupModuleMapping_searchGroup clearfix">
				<h6 class="card-title pull-${dirL}">Group-Module Mapping</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable groupModuleMappingTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">Group Code</td>
							<td width="70%">
								<select class="form-control input-sm" id="searchGroupForGroupModuleMappingSelect">
									<c:forEach items="${ALLGROUP}" var="groupDetails">
										<option value="${groupDetails['VALUE']}">${groupDetails['DISPLAY']}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="searchGroupForModuleMapping" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="moduleMappingSearchResult"></div>
<%--<div class="col-sm-6">
		<div class="card card-primary">
			<div class="card-header userModuleMapping_searchUser clearfix">
				<h6 class="card-title pull-${dirL}">User-Module Mapping</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable userModuleMappingTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">User Code</td>
							<td width="70%">
								<select class="form-control input-sm" id="searchUserForModuleMappingSelect">
								<option value='ALL'>Select one</option>
									<c:forEach items="${ALLUSERS}" var="userDetails">
										<option dir="ltr" value="${userDetails['VALUE']}">${userDetails['DISPLAY']}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
						<tr>
							<td width="30%">Group Code</td>
							<td width="70%" id="groupCodeTd">
								<select class="form-control input-sm" id="searchGroupForUserModuleMappingSelect">
									<option value='ALL'>Select one</option>
									<c:forEach items="${SPECIFICGROUP}" var="specificGroupDetails">
										<option dir="ltr" value="${specificGroupDetails['GROUPCODE']}">${specificGroupDetails['GROUPCODE']}</option>
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
</div>--%>
