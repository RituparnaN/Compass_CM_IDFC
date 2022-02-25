<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
		compassTopFrame.init(id, 'updateMissingFieldsTable'+id, 'dd/mm/yy');
		
		$("#updateMissingFieldsModal"+id).click(function(){
			var templateId = $("#templateId"+id).val();
			var templateName = $("#templateName"+id).val();
			var productCode = $("#productCode"+id).val();
			var custType = $("#custType"+id).val();
			var productCodeRiskValue = $("#productCodeRiskValue"+id).val();
			var custTypeRiskValue = $("#custTypeRiskValue"+id).val();
			var isEnabled = $("#isEnabled"+id).val();
			var fullData = "templateId="+templateId+"&templateName="+templateName+"&productCode="+productCode+
								"&custType="+custType+"&productCodeRiskValue="+productCodeRiskValue+
								"&custTypeRiskValue="+custTypeRiskValue+"&isEnabled="+isEnabled;
			if(confirm("Confirm updation")){
				$.ajax({
					url: "${pageContext.request.contextPath}/admin/updateRiskParamFields",
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
	<div class="card card-primary updateMissingFieldsModalForm">
		<form action="javascript:void(0)" method="POST" id="updateMissingFieldsForm${UNQID}">
			<table class="table updateMissingFieldsTable${UNQID} table-striped" style="margin-bottom: 0px;">
				<tr>
					<td width="15%">Template Id</td>
							<td width="30%">
								<input type="text" class="form-control input-sm" name="templateId" id="templateId${UNQID}" value="${RESULTMAP['TEMPLATEID']}" readonly="readonly"/>
							</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Template Name</td>
						<td width="30%">
							<input type="text" class="form-control input-sm" name="templateName" id="templateName${UNQID}" value="${RESULTMAP['TEMPLATENAME']}"/>	
						</td>
					</tr>
					<tr>	
						<td width="15%">Product Code</td>
						<td width="30%">
							<select class="form-control input-sm" name="productCode" id="productCode${UNQID}">
								<option value="ALL">ALL</option>
								<c:forEach var="productCode" items="${FIELDSMAP['PRODUCT']}">
									<option value="${productCode.key}" <c:if test="${productCode.key eq RESULTMAP['PRODUCTCODE']}">selected="selected"</c:if>>${productCode.value}</option>
								</c:forEach>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Customer Type</td>
						<td width="30%">
							<select class="form-control input-sm" name="custType" id="custType${UNQID}">
								<option value="ALL">ALL</option>
								<c:forEach var="custType" items="${FIELDSMAP['CUSTOMER']}">
									<option value="${custType.key}" <c:if test="${custType.key eq RESULTMAP['CUSTOMERTYPE']}">selected="selected"</c:if>>${custType.value}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
					<tr>	
						<td width="15%">ProductCode Risk Value</td>
						<td width="30%">
							<select class="form-control input-sm" name="productCodeRiskValue" id="productCodeRiskValue${UNQID}">
								<option value="1">1 - Low</option>
								<option value="2">2 - Medium</option>
								<option value="3">3 - High</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">CustomerType RiskValue</td>
						<td width="30%">
							<select class="form-control input-sm" name="custTypeRiskValue" id="custTypeRiskValue${UNQID}">
								<option value="1">1 - Low</option>
								<option value="2">2 - Medium</option>
								<option value="3">3 - High</option>
							</select>
						</td>
					</tr>
					<tr>	
						<td width="15%">Is Enabled</td>
						<td width="30%">
							<select class="form-control input-sm" name="isEnabled" id="isEnabled${UNQID}">
								<option value="Y" <c:if test="${'Y' eq RESULTMAP['ISENABLED']}">selected="selected"</c:if>>Yes</option>
								<option value="N" <c:if test="${'N' eq RESULTMAP['ISENABLED']}">selected="selected"</c:if>>No</option>
							</select>
						</td>
						<td colspan="3">&nbsp;</td>
					</tr>
				</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="updateMissingFieldsModal${UNQID}" class="btn btn-primary btn-sm">Update</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>