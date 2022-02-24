<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#approveUserSearch").click(function(){
		var userDetails = $("#approveUserSelect").val();
		if(userDetails != ""){
			var button = $(this);
			var buttonMessage = $(button).html();
			$(button).attr("disabled","disabled");
			$(button).html("Searching...");
			$("#approveUserSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			$.ajax({
	    		url : "${pageContext.request.contextPath}/checker/getUserDetailsForChecker?userDetails="+userDetails,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			$("#approveUserSearchResult").html(resData);
	    			$(button).removeAttr("disabled");
	    			$(button).html("Search");
	    		},
	    		error : function(){
	    			$("#approveUserSearchResult").html("Something went wrong");
	    		}
	    	});
		}else{
			alert("Select an UserCode");
		}
	});
});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-default">
			<div class="card-header approveUser_search clearfix">
				<h6 class="card-title pull-${dirL}">Select User</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable approveUserTable">
					<tbody>
						<tr>
							<td width="30%">UserCode</td>
							<td width="70%">
								<select class="form-control input-sm" id="approveUserSelect">
									<option value="">Select UserCode</option>
									<c:forEach items="${ALLUSERCODE}" var="userDetails">
										<option value="${userDetails['VALUE']}">${userDetails['DISPLAY']}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="approveUserSearch" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="approveUserSearchResult"></div>