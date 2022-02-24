<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
    
<script type="text/javascript">
$(document).ready(function(){
	var id = '${UNQID}';
	
	$("#createSubjectiveAlert"+id).click(function(){
		var alertCode = $("#alertCode"+id).val();
		var alertName = $("#alertName"+id).val();
		var description = $("#description"+id).val();
		var alertMsg = $("#alertMsg"+id).val();
		var alertPriority = $("#alertPriority"+id).val();
		var alertEnabled = $("#alertEnabled"+id).val();
		var fullData = "alertCode="+alertCode+"&alertName="+alertName+"&description="+description+"&alertMsg="
						+alertMsg+"&alertPriority="+alertPriority+"&alertEnabled="+alertEnabled;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/createSubjectiveAlert",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				$("#compassCaseWorkFlowGenericModal").modal("hide");
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
	<div class="card card-primary CreateSubjectiveAlertModalForm">
		<form action="javascript:void(0)" method="POST" id="createSubjectiveAlertForm${UNQID}">
			<table class="table  table-striped" style="margin-bottom: 0px;">
				<tr>
					<td width="15%">Alert Code</td>
					<td width="30%"><input type="text" class="form-control input-sm" name="alertCode" id="alertCode${UNQID}" value="SA_"/></td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Alert Name</td>
					<td width="30%"><input type="text" class="form-control input-sm" name="alertName" id="alertName${UNQID}" /></td>
				</tr>
				<tr>
					<td width="15%">Description</td>
					<td width="30%"><input type="text" class="form-control input-sm" name="description" id="description${UNQID}" /></td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Alert Message</td>
					<td width="30%"><input type="text" class="form-control input-sm" name="alertMsg" id="alertMsg${UNQID}" /></td>
				</tr>
				<tr>
					<td width="15%">Alert Priority</td>
					<td width="30%">
						<select class="form-control input-sm" name="alertPriority" id="alertPriority${UNQID}">
							<option value="1">1</option>
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
							<option value="9">9</option>
							<option value="10">10</option>
						</select>
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">Alert Enabled</td>
					<td width="30%">
						<select class="form-control input-sm" name="alertEnabled" id="alertEnabled${UNQID}">
							<option value="Y">Yes</option>
							<option value="N">No</option>
						</select>		
					</td>
				</tr>		
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="createSubjectiveAlert${UNQID}" class="btn btn-primary btn-sm">Create</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>