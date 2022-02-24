<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
	    var parameters = '${parameters}';
		var selectedFiles = '${selectedFiles}';
		var status = '${status}';
		
		$("#saveFileUploadComments"+id).click(function(){
			var markAll = 'N'; // $("#markAll"+id).val();
			/* 
			if($("#markAll"+id).prop("checked")){	
				markAll = 'Y';
			}
			 */
			var comments = $("#comments"+id).val();
			var fullData = "markAll="+markAll+"&comments="+comments+"&parameters="+parameters+"&selectedFiles="+selectedFiles+"&status="+status;
			if(confirm("Confirm saving")){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/saveFileUploadComments",
					cache: false,
					type: "POST",
					data: fullData,
					success: function(res){
						$("#"+searchButton).click();
						$("#compassGenericModal").modal("hide");
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
	<div class="card card-primary saveFileUploadCommentsModalForm">
			<table class="table  table-striped" style="margin-bottom: 0px;">
				<%-- 
				<tr>
					<td width="15%">Mark All</td>
					<td width="10%">
						<input type="checkbox" class="form-control input-sm" name="markAll" id="markAll${UNQID}"/> 
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
				 --%>
				<tr>
					<td width="15%">
						Comments
					</td>
					<td colspan="4">
						<textarea class="form-control input-sm" name="comments" id="comments${UNQID}"></textarea>
					</td>
				</tr>
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="saveFileUploadComments${UNQID}" class="btn btn-primary btn-sm">Save</button>
				</div>
			</div>
	</div>
	</div>
</div>