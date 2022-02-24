<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${ELMID}';
		
		$("#updateUser"+id).click(function(){
			var button = $(this);
			var userCode = $("#userCode"+id).val();
			var userStatus = $("#userStatus"+id).val();
			var accountLocked = $("input[name='editUserAccountLocked']:checked").val();
			var accountEnabled = $("input[name='editUserAccountEnabled']:checked").val();
			var accountDeleted = $("input[name='editUserAccountDeleted']:checked").val();
			var accountDormant = $("input[name='editUserAccountDormant']:checked").val();
			var accountExpired = "N";
			/* var accountExpired = $("input[name='editUserAccountExpired']:checked").val(); */
			//alert(userCode);
			var fullData = "userCode="+userCode+"&userStatus="+userStatus+"&accountEnabled="+accountEnabled+
				"&accountExpired="+accountExpired+"&accountLocked="+accountLocked+"&accountDeleted="+accountDeleted;
			//alert(fullData);
			$.ajax({
				url : "${pageContext.request.contextPath}/cmUAMMaker/updateUserStatus",
				cache : false,
				type : 'POST',
				data : fullData,
				success : function(resData){
					alert(resData);
					$(button).removeAttr("disabled");
					$(button).html("Update User Status");
				},
				error : function(){
					alert("Something went wrong");
				}
			});
			/* alert(userCode);
			alert(userStatus);
			alert(accountLocked);
			alert(accountEnabled);
			alert(accountDeleted);
			alert(accountExpired); */
		});
	});
</script>



<div class="row ">
<div class="col-sm-12">
	<div class="card card-primary">
  		<div class="card-header clearfix">
  			<h6 class="card-title pull-${dirL}">Edit User Status of ${ALLSTATUSOFUSER.USERCODE}</h6>
  		</div>				
  			<table class="table table-striped">
  				<tbody>
  					<tr>
  						<td width="18%">User Code</td>
  						<td width="30%">
  							<input type="text" class="form-control input-sm" id="userCode${ELMID}" value="${ALLSTATUSOFUSER['USERCODE']}" readonly="readonly"/>
  						</td>
  						<td width="4%">&nbsp;</td>
  						<td width="18%">User Status</td>
  						<td width="30%">
  							<input type="text" class="form-control input-sm" id="userStatus${ELMID}" value="${ALLSTATUSOFUSER['USERSTATUS']}" readonly="readonly"/>
  						</td>
  					</tr>
  					<tr>
  						<td width="18%">Account Locked</td>
  						<td width="30%">
  							<label class="btn btn-default btn-sm" for="editUserAccountLockedYes${ELMID}">
								<input type="radio" name="editUserAccountLocked${ELMID}" id="editUserAccountLockedYes${ELMID}" value="Y" disabled="disabled" <c:if test="${ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'Y'}">checked</c:if> /> Yes
							</label>
							<label class="btn btn-default btn-sm" for="editUserAccountLockedNo${ELMID}">
							  	<input type="radio" name="editUserAccountLocked${ELMID}" id="editUserAccountLockedNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'N'}">checked</c:if> /> No
							</label>
						</td>
  						<td width="4%">&nbsp;</td>
  						<td width="18%">Account Enabled</td>
  						<td width="30%">
  							<label class="btn btn-default btn-sm" for="editUserAccountEnabledYes${ELMID}">
								<input type="radio" name="editUserAccountEnabled${ELMID}" id="editUserAccountEnabledYes${ELMID}" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'Y'}">checked</c:if> /> Yes
							</label>
							<label class="btn btn-default btn-sm" for="editUserAccountEnabledNo${ELMID}">
							  	<input type="radio" name="editUserAccountEnabled${ELMID}" id="editUserAccountEnabledNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'N'}">checked</c:if> /> No
							</label>
						</td>
  					</tr>
  					<tr>
  						<td width="18%">Account Deleted</td>
  						<td width="30%">
  							<label class="btn btn-default btn-sm" for="editUserAccountDeletedYes${ELMID}">
								<input type="radio" name="editUserAccountDeleted${ELMID}" id="editUserAccountDeletedYes${ELMID}" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'Y'}">checked</c:if> /> Yes
							</label>
							<label class="btn btn-default btn-sm" for="editUserAccountDeletedNo${ELMID}">
							  	<input type="radio" name="editUserAccountDeleted${ELMID}" id="editUserAccountDeletedNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'N'}">checked</c:if> /> No
							</label>
						</td>
  						<td width="4%">&nbsp;</td>
  						<%-- <td width="18%">Account Expired </td>
  						<td width="30%">
  							<label class="btn btn-default btn-sm" for="editUserAccountExpiredYes${ELMID}">
								<input type="radio" name="editUserAccountExpired${ELMID}" id="editUserAccountExpiredYes${ELMID}" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTEXPIRED'] eq 'Y'}">checked</c:if> /> Yes
							</label>
							<label class="btn btn-default btn-sm" for="editUserAccountExpiredNo${ELMID}">
							  	<input type="radio" name="editUserAccountExpired${ELMID}" id="editUserAccountExpiredNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTEXPIRED'] eq 'N'}">checked</c:if> /> No
							</label>
						</td>  --%>
						<td width="18%">Account Dormant </td>
  						<td width="30%">
  							<label class="btn btn-default btn-sm" for="editUserAccountDormantYes${ELMID}">
								<input type="radio" name="editUserAccountDormant${ELMID}" id="editUserAccountDormantYes${ELMID}" disabled="disabled" value="Y" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDORMANT'] eq 'Y'}">checked</c:if> /> Yes
							</label>
							<label class="btn btn-default btn-sm" for="editUserAccountDormantNo${ELMID}">
							  	<input type="radio" name="editUserAccountDormant${ELMID}" id="editUserAccountDormantNo${ELMID}" value="N" <c:if test="${ALLSTATUSOFUSER['ACCOUNTDORMANT'] eq 'N'}">checked</c:if> /> No
							</label>
						</td>
  					</tr>
  				</tbody>
  			</table>	
  			<div class="card-footer clearfix searchButtonDiv" style="display: block;">
		        <div class="pull-${dirR}">
		            <button type="button" class="btn btn-primary btn-sm" id="updateUser${ELMID}"
		            <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'N' && ALLSTATUSOFUSER['ACCOUNTDORMANT'] eq 'Y'  && ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'Y' && ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'Y'}">disabled="disabled"</c:if>
		            >Update Status</button>
		            <%-- <c:if test="${ALLSTATUSOFUSER['ACCOUNTENABLE'] eq 'N' && ALLSTATUSOFUSER['ACCOUNTEXPIRED'] eq 'Y'  && ALLSTATUSOFUSER['ACCOUNTLOCKED'] eq 'Y' && ALLSTATUSOFUSER['ACCOUNTDELETED'] eq 'Y'}">disabled="disabled"</c:if>
		            >Update Status</button> --%>
		        </div>
	    	</div>
  		</div>
	</div>
</div>
