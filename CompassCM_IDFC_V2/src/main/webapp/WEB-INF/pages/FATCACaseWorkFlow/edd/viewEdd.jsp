<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var caseNoForEDD = '${caseNoForEDD}';
		
		$("#addNewEdd").click(function(){
			$.ajax({
				url: "${pageContext.request.contextPath}/common/addViewEDD?seqNo=0",
				cache: false,
				type: "POST",
				data: "caseNoForEDD="+caseNoForEDD,
				success: function(response) {
					$("#compassCaseWorkFlowGenericModal-body").html(response);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
		
		$(".updateEdd").click(function(){
			var seqNo = $(this).attr("seqNo");

			$.ajax({
				url: "${pageContext.request.contextPath}/common/addViewEDD",
				cache: false,
				type: "POST",
				data: "seqNo="+seqNo+"&caseNoForEDD="+caseNoForEDD,
				success: function(response) {
					$("#compassCaseWorkFlowGenericModal-body").html(response);
				},
				error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		});
	});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_addEDD">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">Add EDD</h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped addEDD" style="margin-bottom: 0px;">
					<tr>
						<td align="center">
							<button type="button" class= "btn btn-primary btn-sm" id="addNewEdd">Add EDD</button>
						</td>
					</tr>
				</table>
			</form>
			</div>
		</div>
		<div class="card card-primary panel_viewEDD">
			<div class="card-header clearfix">
				<h6 class="card-title pull-${dirL}">View EDD</h6>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table table-striped table-bordered viewEDDTable" style="margin-bottom: 0px;">
					<tr>
						<td width="25%" class="info" align="center">Sequence No</td>
						<td width="25%" class="info" align="center">Created Time</td>
						<td width="25%" class="info" align="center">Created By</td>
						<td width="25%" class="info" align="center">&nbsp;</td>
					</tr>
					<c:forEach var="record" items="${RECORDS}" >
						<tr>
							<td width="25%" align="center">
								${record['S_NUMBER']}
							</td>
							<td width="25%" align="center">
								${record['UPDATETIMESTAMP']}
							</td>
							<td width="25%" align="center">
								${record['USERCODE']}
							</td>
							<td width="25%" align="center"><button class="btn btn-primary btn-sm updateEdd" seqNo="${record['S_NUMBER']}" type="button">Update</button></td>
						</tr>
					</c:forEach>
				</table>
			</form>
			</div>
		</div>
	</div>
</div>
			
	
