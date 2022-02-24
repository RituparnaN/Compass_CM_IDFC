<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
    
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var searchButton = '${searchButton}';
	
		$("#updateWatchlistModal"+id).click(function(){
			
			var listCode = $("#listCode"+id).val();
			var listName = $("#listName"+id).val();
			var description = $("#description"+id).val();
			var riskRating = $("#riskRating"+id).val();
			var fullData = "listCode="+listCode+"&listName="+listName+"&description="+description+"&riskRating="+riskRating;
			
			if(confirm("Confirm updation")){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/updateWatchlist",
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
	<div class="card card-primary updateWatchlistModalForm">
		<form action="javascript:void(0)" method="POST" id="updateWatchlistForm${UNQID}">
			<table class="table  table-striped" style="margin-bottom: 0px;">
				<tr>
					<td width="15%">List Code</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="ListCode" id="listCode${UNQID}" value="${DATAMAP['LISTCODE']}" readonly="readonly"/> 
					</td>
					<td width="10%">&nbsp;</td>
					<td width="15%">List Name</td>
					<td width="30%">
						<input type="text" class="form-control input-sm" name="ListName" id="listName${UNQID}" value="${DATAMAP['LISTNAME']}"/> 
					</td>
				</tr>
				<tr>
					<td>
						Description
					</td>
					<td>
						<textarea class="form-control input-sm" name="description" id="description${UNQID}">${DATAMAP['DESCRIPTION']}</textarea>
					</td>
					<td>
						&nbsp;
					</td>
					<td>
						Risk Rating
					</td>
					<td>
						<select class="form-control input-sm" name="riskRating" id="riskRating${UNQID}">
							<option value="1" <c:if test="${DATAMAP['RISKRATING'] eq 1}">selected="selected"</c:if>>Low</option>
							<option value="2" <c:if test="${DATAMAP['RISKRATING'] eq 2}">selected="selected"</c:if>>Medium</option>
							<option value="3" <c:if test="${DATAMAP['RISKRATING'] eq 3}">selected="selected"</c:if>>High</option>
						</select> 
					</td>
				</tr>
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="updateWatchlistModal${UNQID}" class="btn btn-primary btn-sm">Update</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>