<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	var ipaddressselected = '${SELECTEDIPADDRESS}';
	
	$("#searchIPAddressForEditSelect"+id).select2();
	if(ipaddressselected != ""){
		var searchBtn = $("#searchIPAddressForEdit"+id);
		$(searchBtn).attr("disabled","disabled");
		$(searchBtn).html("Searching...");
		$("#editIPAddressSearchResult"+id).html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
    		url : "${pageContext.request.contextPath}/adminMaker/searchIPAddressFormForEdit?ipAddress="+ipaddressselected+"&elmId="+id,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			$("#editIPAddressSearchResult"+id).html(resData);
    			$(searchBtn).removeAttr("disabled");
    			$(searchBtn).html("Search");
    		},
    		error : function(){
    			$("#editIPAddressSearchResult"+id).html("Something went wrong");
    		}
    	});
	}
	
	$("#searchIPAddressForEdit"+id).click(function(){
		var ipAddress = $("#searchIPAddressForEditSelect"+id).val();
		var searchBtn = $("#searchIPAddressForEdit"+id);
		$(searchBtn).attr("disabled","disabled");
		$(searchBtn).html("Searching...");
		$("#editIPAddressSearchResult"+id).html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
		$.ajax({
    		url : "${pageContext.request.contextPath}/adminMaker/searchIPAddressFormForEdit?ipAddress="+ipAddress+"&elmId="+id,
    		cache : false,
    		type : 'POST',
    		success : function(resData){
    			$("#editIPAddressSearchResult"+id).html(resData);
    			$(searchBtn).removeAttr("disabled");
    			$(searchBtn).html("Search");
    		},
    		error : function(){
    			$("#editIPAddressSearchResult"+id).html("Something went wrong");
    		}
    	});		
	});
});
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header editIPAddress_search clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.editIPAddressHeader"/></h6>
			</div>
			<div class="card-search-card">
				<table class="table table-striped formSearchTable editIPAddressTable" style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="30%">IPAddress</td>
							<td width="70%">
									<select class="form-control input-sm" style="height: 30px" id="searchIPAddressForEditSelect${UNQID}">
										<c:forEach items="${ALLIPADDRESS}" var="ipAddressDetails">
											<option value="${ipAddressDetails['VALUE']}"
											 <c:if test="${ipAddressDetails['VALUE'] == SELECTEDIPADDRESS}"> selected </c:if> 
											 >${ipAddressDetails['DISPLAY']}&#x200E;</option>
										</c:forEach>
									</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<a href="javascript:void(0)" id="searchIPAddressForEdit${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></a>
				</div>
			</div>
		</div>
	</div>
</div>
<div id="editIPAddressSearchResult${UNQID}"></div>