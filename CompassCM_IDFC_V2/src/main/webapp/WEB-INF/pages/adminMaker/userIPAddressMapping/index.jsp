<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap-combobox.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	$("#searchIPAddressForUserMappingSelect").select2();
	$("#searchUserForUserIPAddressMappingSelect").select2();
	
	$("#searchUserForUserIPAddressMapping").click(function(){
		var userCode = $("#searchUserForUserIPAddressMappingSelect").val();
		var searchBtn = $(this);
		$(searchBtn).attr("disabled","disabled");
		$(searchBtn).html("Searching...");
		searchIPAddressForMapping(userCode);
		$(searchBtn).removeAttr("disabled");
		$(searchBtn).html("Search");
	});
	
	$("#searchIPAddressForUserIPAddressMapping").click(function(){
		var ipAddress = $("#searchIPAddressForUserMappingSelect").val();
		if(ipAddress != null && ipAddress != "null"){
			var searchBtn = $(this);
			$(searchBtn).attr("disabled","disabled");
			$(searchBtn).html("Searching...");
			$("#searchUserForUserIPAddressMappingSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			$.ajax({
	    		url : "${pageContext.request.contextPath}/adminMaker/searchUserForIPAddressMapping?ipAddress="+ipAddress,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			$("#searchUserForUserIPAddressMappingSearchResult").html(resData);
	    			$(searchBtn).removeAttr("disabled");
	    			$(searchBtn).html("Search");
	    		},
	    		error : function(){
	    			$("#searchUserForUserIPAddressMappingSearchResult").html("Something went wrong");
	    		}
	    	});	
		}else
			alert("Select an IPAddress");
	});
});
</script>
<script type="text/javascript">
	function searchIPAddressForMapping(userCode){
		$("#searchUserForUserIPAddressMappingSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
    		url : "${pageContext.request.contextPath}/adminMaker/searchIPAddressForUserMapping?usercode="+userCode,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			$("#searchUserForUserIPAddressMappingSearchResult").html(resData);
    		},
    		error : function(){
    			$("#searchUserForUserIPAddressMappingSearchResult").html("Something went wrong");
    		}
    	});	
	}
</script>
<div class="row">
	<div class="col-sm-6">
		<div class="card card-primary">
			<div class="card-header userIPAddressMapping_searchUser clearfix">
				<h6 class="card-title pull-${dirL}">User-IPAddress Mapping</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable userIPAddressMappingUserTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">UserCode</td>
							<td width="70%">
								<select class="form-control input-sm" id="searchUserForUserIPAddressMappingSelect">
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
					<a href="javascript:void(0)" id="searchUserForUserIPAddressMapping" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
	
	<div class="col-sm-6">
		<div class="card card-primary">
			<div class="card-header userIPAddressMapping_searchIPAddress clearfix">
				<h6 class="card-title pull-left">IPAddress-User Mapping</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable userIPAddressMappingIPAddressTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">IPAddress</td>
							<td width="70%">
								<select class="ipAddressombobox form-control input-sm" id="searchIPAddressForUserMappingSelect">
									<c:forEach items="${ALLIPADDRESS}" var="ipAddressDetails">
										<option value="${ipAddressDetails['VALUE']}">${ipAddressDetails['DISPLAY']}&#x200E;</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-right">
					<a href="javascript:void(0)" id="searchIPAddressForUserIPAddressMapping" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="searchUserForUserIPAddressMappingSearchResult"></div>