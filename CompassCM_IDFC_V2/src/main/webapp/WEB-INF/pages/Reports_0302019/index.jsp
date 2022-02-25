<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	var viewType = '${viewType}';
	
	$(document).ready(function() {
		var id = '${UNQID}';
		
		compassTopFrame.init(id, 'reportsGenericListTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingreportsGenericDetails'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'reportsGenericSerachResultPanel');
	    });
		
		var tableClass = 'reportsGenericListTable'+id;
		compassDatatable.construct(tableClass, "reportsGenericListTable", true);
		compassDatatable.enableCheckBoxSelection();	
		
		
	});
	
	function fetchListOfBenchMarks(elm, reportId, unqId){
		var id = unqId;
		var mainRow = $(elm).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		var group = '${group}';
		//alert(reportId);
		$.ajax({
			url: "${pageContext.request.contextPath}/common/getListOfReportBenchMarks" ,
			cache: false,
			data: "reportId="+reportId+"&id="+id+"&viewType="+viewType+"&group="+group,
			type: "POST",
			success: function(res){
				$("#reportsGenericSerachResultPanel"+id).css("display", "block");
				$("#listOfReportBenchMarks"+id).html(res);
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
	
</script>
<style type="text/css">
	.reportIdLink, .reportNameLink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_reportIdsDetails" >
			<div class="card-header panelSlidingreportsGenericDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Reports</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table searchResultGenericTable reportsGenericListTable${UNQID} table-striped table-bordered" style="margin-bottom: 0px; text-align: center;">
					<thead>
					<tr style="font-weight: bold;">
						<th width="20%" class="info">Report No</th>
						<th width="20%" class="info">Report Name</th>
					</tr>
					</thead>
					<tbody>
						<c:forEach var="record" items="${RESULT}">
						<%-- <tr>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['REPORTID']}" data-container="body" class = "reportIdLink" onclick="fetchListOfBenchMarks(this, '${record['REPORTID']}', '${UNQID}')">${record['REPORTID']}</td>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['REPORTNAME']}" data-container="body">${record['REPORTNAME']}</td>
						</tr> --%>
						<tr>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['SERIALNO']}" data-container="body" >${record['SERIALNO']}</td>
							<%-- <td data-toggle="tooltip" data-placement="auto"  title="${record['REPORTID']}" data-container="body" >${record['REPORTID']}</td> --%>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['REPORTNAME']}" data-container="body" 
								class = "reportNameLink" onclick="fetchListOfBenchMarks(this, '${record['REPORTID']}', '${UNQID}')" >${record['REPORTNAME']}
								<input type="hidden" id="reportIdValue" value="${record['REPORTID']}">
							</td>
						</tr>
						</c:forEach>
					</tbody>
					</table>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="reportsGenericSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingreportsGenericDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Assigned Report Parameters List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="listOfReportBenchMarks${UNQID}"></div>
			
		</div>
	</div>
</div>