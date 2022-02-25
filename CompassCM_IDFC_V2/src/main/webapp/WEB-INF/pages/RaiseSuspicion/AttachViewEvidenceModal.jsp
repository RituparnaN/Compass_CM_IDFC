<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	var id = '${alertNo}';
	$("#uploadEvidence"+id).click(function(){
		
	});
	
	$("#closeAttachViewEvidenceModal"+id).click(function(){
		$("#compassCaseWorkFlowGenericModal").modal("hide");
	});
</script>
<div class="row compassrow${alertNo}">
	<div class="col-sm-12">
	<div class="card card-primary attachViewEvidenceModal">
		<form action="javascript:void(0)" method="POST" id="attachViewEvidenceForm${alertNo}">
			<table class="table table-striped" style="margin-bottom: 0px;">
				<tr>
					<td width="30%">Attach File</td>
					<td width="70%">
						<input type="file" class="form-control input-sm" />
					</td> 
				</tr>
			</table>
			<div class="card-footer clearfix">
				<div class="pull-right">
					<button type="button" id="uploadEvidence${alertNo}" class="btn btn-warning btn-sm">Upload</button>
					<button type="button" id="closeAttachViewEvidenceModal${alertNo}" class="btn btn-danger btn-sm">Close</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>