<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	var viewType = '${viewType}';
	
	$(document).ready(function() {
		var id = '${UNQID}';
		
		compassTopFrame.init(id, 'offlineAlertsListTable'+id, 'dd/mm/yy');
		
		$('.panelSlidingofflineAlertsDetails'+id).on("click", function (e) {
			var mainRow = $(this).parents(".compassrow"+id);
			compassTopFrame.searchPanelSliding(id, mainRow, 'offlineAlertsSerachResultPanel');
	    });
		
		var tableClass = 'offlineAlertsListTable'+id;
		compassDatatable.construct(tableClass, "offlineAlertsListTable", true);
		compassDatatable.enableCheckBoxSelection();	
		
		
	});
	
	function fetchListOfBenchMarks(elm, alertId){
		var id = '${UNQID}';
		var mainRow = $(elm).parents("div.compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		$("#loaderDiv").css("display","block");
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getListOfAlertBenchMarks" ,
			cache: false,
			data: "alertId="+alertId+"&id="+id+"&viewType="+viewType,
			type: "POST",
			success: function(res){
				$("#loaderDiv").css("display","none");
				$("#offlineAlertsSerachResultPanel"+id).css("display", "block");
				$("#listOfAlertBenchMarks"+id).html(res);
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
			},
			error: function(a,b,c){
				alert(a+b+c);
				$("#loaderDiv").css("display","none");
			}
		});
	}
	function fetchAlertDetails(elm, alertId){
		var id = '${UNQID}';
		//alert(alertId);
		$("#compassGenericModal").modal("show");
		$("#compassGenericModal-title").html(alertId + " - "+"Alert Details");
		$("#compassGenericModal-body").html("<br/><br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center>");
		
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/getAlertDetails" ,
			cache: false,
			data: "alertId="+alertId+"&id="+id,
			type: "POST",
			success: function(res){
				$("#compassGenericModal-body").html(res);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	}
</script>
<style type="text/css">
	.alertIdLink{
		text-decoration: underline;
		color: blue;
		cursor: pointer;
	}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_alertIdsDetails" >
			<div class="card-header panelSlidingofflineAlertsDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">IBA Alerts</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<table class="table searchResultGenericTable offlineAlertsListTable${UNQID} table-striped table-bordered" style="margin-bottom: 0px; text-align: center;">
					<thead>
					<tr style="font-weight: bold;">
						<th width="20%" class="info">Alert Id</th>
						<th width="20%" class="info">Alert Name</th>
						<th width="45%" class="info">Alert Frequency</th>
						<th width="15%" class="info">Source System</th>
					</tr>
					</thead>
					<tbody>
						<c:forEach var="record" items="${RESULT}">
						<tr>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['ALERTID']}" data-container="body" class = "alertIdLink" onclick="fetchListOfBenchMarks(this, '${record['ALERTID']}')">${record['ALERTID']}</td>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['ALERTNAME']}" data-container="body" class = "alertIdLink" onclick="fetchAlertDetails(this, '${record['ALERTID']}')">${record['ALERTNAME']}</td>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['ALERTFREQUENCY']}" data-container="body">${record['ALERTFREQUENCY']}</td>
							<td data-toggle="tooltip" data-placement="auto"  title="${record['SOURCESYSTEM']}" data-container="body">${record['SOURCESYSTEM']}</td>
						</tr>
						</c:forEach>
					</tbody>
					</table>
			</form>
			</div>
		</div>
		<div id = "loaderDiv" style="display:none">
			<br/><center><img alt='Loading...' src='${pageContext.request.contextPath}/includes/images/qde-loadder.gif'></center><br/>
		</div>
		<div class="card card-primary" id="offlineAlertsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingofflineAlertsDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Assigned Alert Parameters List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="listOfAlertBenchMarks${UNQID}"></div>
			
		</div>
	</div>
</div>