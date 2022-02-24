<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function(){
	$("#graph").click(function(){
		var graphIdValue = $(this).attr('value');
		alert(graphIdValue);
		$.ajax({
			url: "${pageContext.request.contextPath}/common/openModalForGraph?graphIdValue="+graphIdValue,
			cache: false,
			type: "GET",
			success: function(res){
				$("#compassCaseWorkFlowGenericModal").modal("show");
				$("#compassCaseWorkFlowGenericModal-title").html("Profile Details");
				$("#compassCaseWorkFlowGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
});


function openGraphModal(graphIdValue)
{
	$.ajax({
		url: "${pageContext.request.contextPath}/common/openModalForGraph?graphIdValue="+graphIdValue,
		cache: false,
		type: "GET",
		success: function(res){
			$("#compassCaseWorkFlowGenericModal").modal("show");
			$("#compassCaseWorkFlowGenericModal-title").html("Profile Details");
			$("#compassCaseWorkFlowGenericModal-body").html(res);
		},
		error: function(a,b,c){
			alert(a+b+c);
		}
	});	
}

</script>
<!--PIE CHART-->
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary" >
			<div class="card-header">Graphical Profiled Details</div>
			<div class="panelSearchForm">
				<table class="table graphicalReportsTable table-striped table-bordered" style="margin-bottom: 0px;">
					<tr>
						<td width="50%" align="center">
							<a id="graph1" style="cursor: pointer;" onClick = "openGraphModal('11')">Cumulative Profile Details</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph4" style="cursor: pointer;" onClick = "openGraphModal('14')">Quarterly Profile Report</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph3" style="cursor: pointer;" onClick = "openGraphModal('13')">ChannelWise Profile Details</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph5" style="cursor: pointer;" onClick = "openGraphModal('16')">Outlierd Transaction Profile</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph5" style="cursor: pointer;" onClick = "openGraphModal('15')">Miscellaneous Profile Report</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
