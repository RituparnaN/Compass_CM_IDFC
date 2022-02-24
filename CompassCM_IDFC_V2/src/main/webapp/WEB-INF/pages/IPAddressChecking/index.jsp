<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%> 
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#approveIPAddressSearch").click(function(){
		var ipmakercode = $("#approveIPAddressForCheck").val();
		if(ipmakercode != ""){
			var button = $(this);
			var buttonMessage = $(button).html();
			$(button).attr("disabled","disabled");
			$(button).html("Searching...");
			$("#approveIPAddressSearchResult").html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			$.ajax({
	    		url : "${pageContext.request.contextPath}/checker/getIPDetailsForChecker?ipmakercode="+ipmakercode,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			$("#approveIPAddressSearchResult").html(resData);
	    			$(button).removeAttr("disabled");
	    			$(button).html("Search");
	    		},
	    		error : function(){
	    			$("#approveIPAddressSearchResult").html("Something went wrong");
	    		}
	    	});
		}else{
			alert("Select a IP address");
		}
	});
});
</script>
<style type="text/css">
	option:empty
	{
	 display:none;
	}
</style>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header approveIPAddress_search clearfix">
				<h6 class="card-title pull-${dirL}">Select IPAddress</h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable approveIPAddressTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">IPAddress</td>
							<td width="70%">
								<select class="form-control input-sm" style="height: 30px" id="approveIPAddressForCheck">
									<option value="">Select IPAddress</option>
									<c:forEach items="${ALLIPADDRESS}" var="ipAddressDetails">
										<option value="${ipAddressDetails['VALUE']}">${ipAddressDetails['DISPLAY']}</option>
									</c:forEach>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="approveIPAddressSearch" class="btn btn-success btn-sm">Search</a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="approveIPAddressSearchResult"></div>