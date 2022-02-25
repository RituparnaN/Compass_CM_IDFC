<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
var id = '${UNQID}';
$(document).ready(function(){
	$(".createIPAddressButtons > button").click(function(e){
		e.preventDefault();
		var isValid = true;
		var url;
		var fullData;
		var buttonDisableMessage;
		var buttonActualMessage;
		
		var ipAddress = escape($("#ipAddress").val());
		var systemName = escape($("#systemName").val());
		
		if($(e.target).attr("id") == "searchIPAddress"){
			url = "${pageContext.request.contextPath}/adminMaker/searchIPAddressForm";
			fullData = "ipAddress="+ipAddress+"&systemName="+systemName;
			buttonDisableMessage = "Searching...";
		}
		if($(e.target).attr("id") == "createIPAddress"){
			url = "${pageContext.request.contextPath}/adminMaker/createIPAddressForm";
			fullData = "ipAddress="+ipAddress+"&systemName="+systemName;
			buttonDisableMessage = "Creating...";
		}
		
		if(isValid){
			$("#createIpAddressSerachResult"+id).html("<br/><center> <img src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif' alt='Loading...'/></center>");
			buttonActualMessage = $(e.target).html();
			$(e.target).attr("disabled", "disabled");
			$(e.target).html(buttonDisableMessage);
			$.ajax({
	    		url : url,
	    		data : fullData,
	    		cache : false,
	    		type : 'POST',
	    		success : function(resData){
	    			$("#createIpAddressSerachResultPanel"+id).css("display","block");
	    			$("#createIpAddressSerachResult"+id).html(resData);
	    			$(e.target).removeAttr("disabled");
					$(e.target).html(buttonActualMessage);		
	    		},
	    		error : function(){
	    			$("#createIpAddressSerachResult"+id).html("Something went wrong");
	    		}
	    	});
		}
	});
});

function editIPAddress(){
	var selectedCount = 0;
	var selectedValue = "";
	var enable = "";
	$("#createIpAddressSerachResult"+id).find("table.searchResultGenericTable").children("tbody").children("tr").each(function(){			
		if($(this).children("td:first-child").children("input[type='checkbox']").is(":checked")){
			selectedValue = $(this).find("td").children("input[type='checkbox']").val();
			selectedCount++;
		}
	});
	
	if(selectedCount == 1){
		navigate('Edit IPAddress','editIPAddress','adminMaker/editIPAddress?ipAddress='+escape(selectedValue),'1')
	}else{
		alert("Select one row");
	}
}
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header createIPAddress_search clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.createIPAddressHeader"/></h6>
			</div>
			<table class="table table-striped formSearchTable createIPAddressTable" style="margin-bottom: 0px;">
				<tbody>
					<tr>
						<td width="18%">IPAddress</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="ipAddress" name="ipAddress" placeholder="IP Address" />
						</td>
						<td width="4%">&nbsp;</td>
						<td width="18%">System Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" id="systemName" name="systemName" placeholder="System Name" />
						</td>
					</tr>
				</tbody>
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR} createIPAddressButtons">
					<button id="searchIPAddress" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
					<button id="createIPAddress" class="btn btn-primary btn-sm"><spring:message code="app.common.createIPAddressHeader"/></button>
				</div>
			</div>
		</div>
	
		<div class="card card-primary" id="createIpAddressSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingCreateIpAddress${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}"><spring:message code="app.common.ipAddressResultHeader"/></h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="createIpAddressSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-right">
					<button type="button" class="btn btn-primary btn-sm" onclick="editIPAddress()"><spring:message code="app.common.editIPAddressHeader"/></button>
				</div>
			</div>
		</div>
	</div>
</div>