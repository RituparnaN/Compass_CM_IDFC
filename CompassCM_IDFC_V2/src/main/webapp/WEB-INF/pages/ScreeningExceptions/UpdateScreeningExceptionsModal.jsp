<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
		compassTopFrame.init(id, 'updateScreeningExceptionsTable'+id, 'dd/mm/yy');
		
		$("#updateScreeningExceptionsModal"+id).click(function(){
			var custId = $("#custId"+id).val();
			var custName = $("#custName"+id).val();
			var matchedList = $("#matchedList"+id).val();
			var matchedEntity = $("#matchedEntity"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var listId = $("#listId"+id).val();
			var reason = $("#reason"+id).val();
			var fullData = "custId="+custId+"&custName="+custName+"&matchedList="+matchedList+
						   "&matchedEntity="+matchedEntity+"&isEnabled="+isEnabled+"&listId="+listId+"&reason="+reason;
			if(confirm("Confirm updation")){
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/updateScreeningException",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res){
						$("#"+searchButton).click();
						$("#compassCaseWorkFlowGenericModal").modal("hide");
						alert(res);
					},
					error: function(a,b,c){
						alert(a+b+c);
					}
				});
			}
		});
		
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
	<div class="card card-primary updateScreeningExceptionsModalForm">
		<form action="javascript:void(0)" method="POST" id="updateScreeningExceptionForm${UNQID}">
			<table class="table updateScreeningExceptionsTable${UNQID} table-striped" style="margin-bottom: 0px;">
				<tr>
					<td width="15%">Customer Id</td>
					<td width="30%">
						<div class="input-group" style="z-index: 1">
							<input type="text" class="form-control input-sm" name="custId" id="custId${UNQID}" value="${RESULTMAP['CUSTOMERID']}" readonly="readonly"/>
							<span class="input-group-addon formSearchIcon" id="basic-addon${UNQID}" onclick="alert('search')" style="cursor: pointer;" title="Search">
								<i class="fa fa-search"></i>
							</span>
						</div>
					</td>
					<td width="10%">&nbsp;</td>
						<td width="15%">Customer Name</td>
						<td width="30%">
						<input type="text" class="form-control input-sm" name="custName" id="custName${UNQID}" value="${RESULTMAP['CUSTOMERNAME']}" readonly="readonly"/>	
					</td>
					</tr>
					<tr>	
						<td width="15%">Matched List</td>
						<td width="30%">
							<select class="form-control input-sm" name="matchedList" id="matchedList${UNQID}">
								<c:forEach var="matchedList" items="${MATCHEDLIST}">
									<option value="${matchedList.key}" <c:if test="${matchedList.key eq RESULTMAP['MATCHEDLIST']}">selected="selected"</c:if> >${matchedList.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Matched Entity</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="matchedEntity" id="matchedEntity${UNQID}" value="${RESULTMAP['MATCHEDENTITY']}" readonly="readonly"/></td>
					</tr>
					<tr>	
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}">
								<option value=""></option>
								<option value="Y" <c:if test="${'Y' eq RESULTMAP['ISREMOVED']}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${'N' eq RESULTMAP['ISREMOVED']}">selected="selected"</c:if>>No</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">List Id</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="listId" id="listId${UNQID}" value="${RESULTMAP['LISTID']}"/></td>
					</tr>
					<tr>
						<td width="15%">Reason</td>
						<td width="30%"><textarea class="form-control input-sm" name="reason" id="reason${UNQID}">${RESULTMAP['REASON']}</textarea></td>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="updateScreeningExceptionsModal${UNQID}" class="btn btn-primary btn-sm">Update</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>