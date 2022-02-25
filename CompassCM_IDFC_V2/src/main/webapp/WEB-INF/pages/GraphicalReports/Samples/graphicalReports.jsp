<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
function openGraph(graphId){
	$.ajax({
		url: "${pageContext.request.contextPath}/common/openModalForSampleGraph?graphIdValue="+graphId,
		cache: false,
		type: "GET",
		success: function(res){
			$("#compassCaseWorkFlowGenericModal").modal("show");
			$("#compassCaseWorkFlowGenericModal-title").html("Graph"+graphId);
			$("#compassCaseWorkFlowGenericModal-body").html(res);
		},
		error: function(a,b,c){
			alert(a+b+c);
		}
	});
}
</script>
<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary" >
			<div class="card-header">List of Graphical Reports</div>
			<div class="panelSearchForm">
				<table class="table graphicalReportsTable table-striped table-bordered" style="margin-bottom: 0px;">
					<tr>
						<td width="50%" align="center">
							<a id="graph1" style="cursor: pointer;" onclick="openGraph('1')">Graph1</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph2" style="cursor: pointer;" onclick="openGraph('2')">Graph2</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph3" style="cursor: pointer;" onclick="openGraph('3')">Graph3</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph4" style="cursor: pointer;" onclick="openGraph('4')">Graph4</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph5" style="cursor: pointer;" onclick="openGraph('5')">Graph5</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph6" style="cursor: pointer;" onclick="openGraph('6')">Graph6</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph7" style="cursor: pointer;" onclick="openGraph('7')">Graph7</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph8" style="cursor: pointer;" onclick="openGraph('8')">Graph8</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph9" style="cursor: pointer;" onclick="openGraph('9')">Graph9</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph10" style="cursor: pointer;" onclick="openGraph('10')">Graph10</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph11" style="cursor: pointer;" onclick="openGraph('11')">Graph11</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph12" style="cursor: pointer;" onclick="openGraph('12')">Graph12</a>
						</td>
					</tr>
					<tr>
						<td width="50%" align="center">
							<a id="graph13" style="cursor: pointer;" onclick="openGraph('13')">Graph13</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph14" style="cursor: pointer;" onclick="openGraph('14')">Graph14</a>
						</td>
					</tr>
					<!-- <tr>
						<td width="50%" align="center">
							<a id="graph15" style="cursor: pointer;" onclick="openGraph('15')">Graph15</a>
						</td>
						
						<td width="50%" align="center">
							<a id="graph16" style="cursor: pointer;" onclick="openGraph('16')">Graph16</a>
						</td>
					</tr>-->
				</table>
			</div>
		</div>
	</div>
</div>
