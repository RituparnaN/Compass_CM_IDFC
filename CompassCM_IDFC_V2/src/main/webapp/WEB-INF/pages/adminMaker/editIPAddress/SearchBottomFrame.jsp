<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var elmId = '${ELMID}';
		$("#updateIPAddress"+elmId).click(function(){
			var button = $(this);
			$(button).html("Updating...");
			$(button).attr("disabled","disabled");
			
			var ipAddress = $("#editIPAddress"+elmId).val();
			var systemName = escape($("#editSystemName"+elmId).val());
			
			var ipEnabled = "Y";
			if($("#editIPAddressEnabledNo"+elmId).is(":checked")){
				ipEnabled = "N";
			}
			
			var fulldate = "ipAddress="+ipAddress+"&systemName="+systemName+"&enabled="+ipEnabled;
			
			$.ajax({
	    		url : "${pageContext.request.contextPath}/adminMaker/updateIPAddress",
	    		cache : false,
	    		type : 'POST',
	    		data : fulldate,
	    		success : function(resData){
	    			alert(resData);
	    			$(button).removeAttr("disabled");
	    			$(button).html("Update IPAddress");
	    		},
	    		error : function(){
	    			alert("Something went wrong");
	    		}
	    	});
		});
	});
</script>
<div class="row resultRow">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-header clearfix">
		      <h6 class="card-title pull-${dirL}"><spring:message code="app.common.editIPAddressHeader"/> : ${IPADDRESSFOREDIT['IPADDRESS']}</h6>
		      </div>				
					<table class="table table-striped">
						<tr>
							<td width="18%">IPAddress</td>
							<td width="30%"><input type="text" class="form-control input-sm" readonly="readonly" id="editIPAddress${ELMID}" value="${IPADDRESSFOREDIT['IPADDRESS']}"/> </td>
							<td width="4%">&nbsp;</td>
							<td width="18%">System Name</td>
							<td width="30%"><input type="text" class="form-control input-sm" id="editSystemName${ELMID}" value="${IPADDRESSFOREDIT['SYSTEMNAME']}"/></td>
						</tr>
						<tr>
							<td width="18%">IP Enable</td>
							<td width="30%">
								<label class="btn btn-default btn-sm" for="editIPAddressEnabledYes${ELMID}">
									<input type="radio" name="editIPAddressEnabled${ELMID}" id="editIPAddressEnabledYes${ELMID}" value="Y" <c:if test="${IPADDRESSFOREDIT['ISENABLED'] == 'Y'}">checked</c:if> />
									Yes
								</label>
								<label class="btn btn-default btn-sm" for="editIPAddressEnabledNo${ELMID}">
									<input type="radio" name="editIPAddressEnabled${ELMID}" id="editIPAddressEnabledNo${ELMID}" value="N" <c:if test="${IPADDRESSFOREDIT['ISENABLED'] != 'Y'}">checked</c:if> />
									No
								</label>
							</td>
							<td colspan="3">&nbsp;</td>
						</tr>
						<tr>
							<td width="18%">Checker Action</td>
							<td width="30%">${IPADDRESSFOREDIT['IPSTATUS']} <c:if test="${IPADDRESSFOREDIT['IPSTATUS'] != 'Pending'}">by ${IPADDRESSFOREDIT['APPROVEDBY']}</c:if> </td>
							<td width="4%">&nbsp;</td>
							<td width="18%">Checker Action Date</td>
							<td width="30%" >${IPADDRESSFOREDIT['APPROVEDTIMESTAMP']}</td>
						</tr>
						<tr>
							<td width="18%">Checker Remarks</td>
							<td width="82%" colspan="4">${IPADDRESSFOREDIT['CHECKERREMAKRS']}</td>
						</tr>
					</table>
					<div class="card-footer clearfix">
				        <div class="pull-${dirR}">
				            <button type="button" class="btn btn-primary btn-sm" id="updateIPAddress${ELMID}"><spring:message code="app.common.editIPAddressButton"/></button>
				        </div>
			    	</div>
			</div>
	</div>
</div>