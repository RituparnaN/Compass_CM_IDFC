<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../../tags/tags.jsp"%>

<c:forEach var="record" items="${result}">
	<c:set var="reference_number" value="${record['FIUREFERENCENO']}"></c:set>
	<c:set var="fiu_remarks" value="${record['FIUREMARKS']}"></c:set>
</c:forEach>

<%-- <script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/bootstrap.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/metisMenu.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/jquery-ui.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/dataTableBottons/dataTables.buttons.min.js"></script>
<script type="text/javascript"	src="${pageContext.request.contextPath}/includes/scripts/select2.min.js"></script> --%>

<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var selectedFileSeq = '${selectedFileSeq}';
		var viewCcrButton = '${viewCcrButton}';
		//alert(viewCcrButton);
		
		
		$("#closeCCRFilesModal").click(function(){
			$("#compassGenericModal").modal("hide");
		});

		
		$("#updateCCRFilesModal").click(function(){
			var formObj = $("#ccrFilesForm"+id);
			var formData = $(formObj).serialize();
			var flag = 0;
			$(".validInput").each(function(){
				var a = $(this).val();
				if(a == '')
				{
					alert("Fill Every field");
					flag = flag+1;
					$(this).focus();
					return false;
				}
			});
			//alert(formData);
			
			if(flag==0){
				$.ajax({
					url: "${pageContext.request.contextPath}/common/updateCCRDetails",
					cache: false,
					type: "POST",
					data: formData+"&selectedFileSeq="+selectedFileSeq,
					success: function(res){
						//console.log("this is res="+res);
						$("#compassGenericModal").modal("hide");
						$("#"+viewCcrButton).click();
					},
					error: function(res){
						alert(a+b+c);
					}
				});
			}
		});
	});
</script>

<style type="text/css">

.datepicker
{
		background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
		background-repeat:no-repeat;
		background-position: 98%;
}
</style>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
	<div class="card card-primary ccrFilesModalForm">
		<form action="javascript:void(0)" method="POST" id="ccrFilesForm${UNQID}">
			<table class="table table-striped" style="margin-bottom: 0px;">
				<tr>
					<td>FIU Reference No.</td>
					<td>
						<input type="text" value="${record['FIUREFERENCENO']}" class="form-control input-sm validInput" name="FIUREFERENCENO" id="reference_number${UNQID}"  />
					</td>
				</tr>
				<tr>
					<td>FIU Remarks</td>
					<td>
						<input type="text"  value="${record['FIUREMARKS']}" class="form-control input-sm validInput" name="FIUREMARKS" id="fiu_remarks${UNQID}"/>
					</td>
				</tr>
			</table>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" id="updateCCRFilesModal" class="btn btn-success btn-sm">Update</button>
					<button type="button" id="closeCCRFilesModal" class="btn btn-primary btn-sm">Close</button>
				</div>
			</div>
		</form>
	</div>
	</div>
</div>