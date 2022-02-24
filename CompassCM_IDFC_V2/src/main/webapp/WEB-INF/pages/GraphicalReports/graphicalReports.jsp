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
				$("#compassCaseWorkFlowGenericModal-title").html("Graph");
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
			$("#compassCaseWorkFlowGenericModal-title").html("Graph");
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
			<div class="card-header">List of Graphical Reports</div>
			<div class="panelSearchForm">
				<table class="table graphicalReportsTable table-striped table-bordered" style="margin-bottom: 0px;">
					<tr>
						<td width="50%" align="center">
							<a id="graph1" style="cursor: pointer;" onClick = "openGraphModal('1')">Graph1</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph2" style="cursor: pointer;" onClick = "openGraphModal('2')">Graph2</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph3" style="cursor: pointer;" onClick = "openGraphModal('3')">Graph3</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph4" style="cursor: pointer;" onClick = "openGraphModal('4')">Graph4</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph5" style="cursor: pointer;" onClick = "openGraphModal('5')">Graph5</a>
						</td>

						<td width="50%" align="center">
							<a id="graph6" style="cursor: pointer;" onClick = "openGraphModal('6')">Graph6</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph7" style="cursor: pointer;" onClick = "openGraphModal('7')">Graph7</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
</div>
