<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
		compassTopFrame.init(id, 'updateFalsePositiveTable'+id, 'dd/mm/yy');
		
		$("#updateFalsePositiveModal"+id).click(function(){
			var custId = $("#custId"+id).val();
			var accNo = $("#accNo"+id).val();
			var alertCode = $("#alertCode"+id).val();
			var alertMsg = $("#alertMsg"+id).val();
			var activeFrom = $(".activeFrom"+id).val();
			var activeTo = $(".activeTo"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var reason = $("#reason"+id).val();
			var toleranceRating = $("#toleranceRating"+id).val();
			var fullData = "custId="+custId+"&accNo="+accNo+"&alertCode="+alertCode+"&alertMsg="+alertMsg+"&activeFrom="+activeFrom+
						   "&activeTo="+activeTo+"&isEnabled="+isEnabled+"&reason="+reason+"&toleranceRating="+toleranceRating;
			
			if(confirm("Confirm updation")){
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/updateFalsePositive",
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
	<div class="card card-primary updateFalsePositiveModalForm">
		<form action="javascript:void(0)" method="POST" id="updateFalsePositiveForm${UNQID}">
			<table class="table updateFalsePositiveTable${UNQID} table-striped" style="margin-bottom: 0px;">
				<tr>
						<td width="15%">Customer Id</td>
							<td width="30%">
								<div class="input-group" style="z-index: 1">
									<input type="text" class="form-control input-sm" value="${RESULTMAP['CUSTOMERID']}" name="custId" id="custId${UNQID}" readonly="readonly"/>
									<span class="input-group-addon" id="basic-addon${UNQID}" onclick="alert('search')" style="cursor: pointer;" title="Search">
										<i class="fa fa-search"></i>
									</span>
								</div>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Account No</td>
						<td width="30%">
							<div class="input-group" style="z-index: 1">
								<input type="text" class="form-control input-sm" name="accNo"  value="${RESULTMAP['ACCOUNTNO']}" id="accNo${UNQID}" readonly="readonly"/>
								<span class="input-group-addon" id="basic-addon${UNQID}" onclick="alert('search')" style="cursor: pointer;" title="Search">
									<i class="fa fa-search"></i>
								</span>
							</div>
						</td>
					</tr>
					<tr>	
						<td width="15%">Alert Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="alertCode" id="alertCode${UNQID}" disabled="disabled">
								<c:forEach var="alertCodes" items="${ALERTCODES}">
									<option value="${alertCodes.key}" <c:if test="${alertCodes.key eq RESULTMAP['ALERTCODE']}">selected="selected"</c:if> >${alertCodes.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Alert Message</td>
						<td width="30%"><input type="text" class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}" value="${RESULTMAP['ALERTMESSAGE']}"/></td>
					</tr>
					<tr>	
						<td width="15%">Active From</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker activeFrom${UNQID}" name="activeFrom" value="${RESULTMAP['ACTIVEFROMDATE']}"/></td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Active To</td>
						<td width="30%">
							<input type="text" class="form-control input-sm datepicker activeTo${UNQID}" name="activeTo" value="${RESULTMAP['ACTIVETODATE']}"/></td>
					</tr>
					<tr>	
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}">
								<option value=""></option>
								<option value="Y" <c:if test="${'Y' eq RESULTMAP['ISENABLED']}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${'N' eq RESULTMAP['ISENABLED']}">selected="selected"</c:if>>No</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Reason</td>
						<td width="30%">
							<textarea class="form-control input-sm" name="reason" id="reason${UNQID}">${RESULTMAP['REASON']}</textarea>
						</td>
						</tr>
						<tr>	
						<td width="15%">Tolerance Level</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="toleranceLevel" id="toleranceLevel${UNQID}" value="${RESULTMAP['TOLERANCELEVEL']}">
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">&nbsp;</td>
						<td width="30%">&nbsp;</td>
						</tr>
				</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="updateFalsePositiveModal${UNQID}" class="btn btn-primary btn-sm">Update</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>