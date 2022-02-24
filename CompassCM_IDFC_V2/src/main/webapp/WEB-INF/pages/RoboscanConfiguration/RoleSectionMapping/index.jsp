<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	
	$("#searchSectionForRoleSectionMapping").click(function(){
		var roleId = $("#roleId").val();
		var searchBtn = $(this);
		$(searchBtn).attr("disabled","disabled");
		$(searchBtn).html("Searching...");
		$("#searchSectionForRoleSectionMappingSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
    		url : "${pageContext.request.contextPath}/admin/searchSectionForRoleSectionMapping?roleId="+roleId+"&searchBtn=searchSectionForRoleSectionMapping",
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			$(searchBtn).removeAttr("disabled");
    			$(searchBtn).html("Search");
    			$("#searchSectionForRoleSectionMappingSearchResult").html(resData);
    		},
    		error : function(){
    			$("#searchSectionForRoleSectionMappingSearchResult").html("Something went wrong");
    		}
    	});	
	});
});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header roleSectionMapping_searchSection clearfix">
				<h6 class="card-title pull-${dirL}">Role-Section Mapping</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped roleSectionMappingTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">Role Id</td>
							<td width="70%">
								<select class="form-control input-sm" id="roleId">
									<c:forEach items="${ROLES}" var="allRoles">
										<option value="${allRoles}">${allRoles}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="searchSectionForRoleSectionMapping" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
</div>

<div id="searchSectionForRoleSectionMappingSearchResult"></div>