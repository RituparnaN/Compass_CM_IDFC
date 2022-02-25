<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isELIgnored="false"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
var viewType = '${viewType}';
var reportSubGroup = '${ALERTSUBGROUP}';

$(document).ready(function() {
	var id = '${UNQID}';

	compassTopFrame.init(id, 'offlineAlertsGenericListTable'+id, 'dd/mm/yy');
	
	$('.panelSlidingOfflineAlertsListGenericDetails'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'offlineAlertsGenericSerachResultPanel');
    });
});

function fetchListOfBenchMarks(elm, alertId, alertSubGroup){
	var id = '${UNQID}';
	var mainRow = $(elm).parents("div.compassrow"+id);
	var slidingDiv = $(mainRow).children().children().children();
	var panelBody = $(mainRow).children().children().find(".panelSearchForm");
	
	$.ajax({
		url: "${pageContext.request.contextPath}/admin/getListOfAlertBenchMarks" ,
		cache: false,
		data: "alertId="+alertId+"&id="+id+"&viewType="+viewType,
		type: "POST",
		success: function(res){
			$("#offlineAlertsSerachResultPanel"+id).css("display", "block");
			$("#listOfAlertBenchMarks"+id).html(res);
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

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary" >
		<div class="card-header panelSlidingOfflineAlertsListGenericDetails${UNQID} clearfix" style="margin-bottom: 10px !important ;">
				<h6 class="card-title pull-${dirL}">${alertGroupName}</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<c:forEach var="record" items="${ALERTSUBGROUP}">
				<div class="row compassrow${UNQID}" style="padding: 0px !important ;">
				<div class="col-sm-12">
					<div class="card card-danger">
						<div class="card-header clearfix">
								<h6 class="card-title pull-${dirL}">${record}</h6>
						</div>
						<div>
							<table class="table graphicalReportsTable table-striped table-bordered" style="margin-bottom: 0px; text-align: center;">
							<!-- 
							<thead>
								<tr style="font-weight: bold;">
									<th width="50%" style="text-align: center;" class="info">Report Id</th>
									<th width="50%" style="text-align: center;" class="info">Report Id</th>
								</tr>
							</thead>
							-->
							<tbody>
							    <c:set var="LABELSITRCOUNT" value="0" scope="page"/>
								<c:forEach var="subRecord" items="${RESULT}">
								<c:if test="${record eq subRecord['ALERTSUBGROUP']}">
								<c:choose>
								<c:when test="${LABELSITRCOUNT % 2 == 0}">
									<tr>
										<td width="50%" style="cursor: pointer; color: blue;" data-toggle="tooltip" data-placement="auto"  
											title="${subRecord['ALERTNAME']}" data-container="body" class = "reportIdLink" 
											onclick="fetchListOfBenchMarks(this, '${subRecord['ALERTID']}', '${UNQID}', '${subRecord['ALERTSUBGROUP']}')">${subRecord['ALERTNAME']}
										</td>
								</c:when>
								<c:otherwise>		
										<td width="50%" style="cursor: pointer; color: blue;" data-toggle="tooltip" data-placement="auto"  
											title="${subRecord['ALERTNAME']}" data-container="body" class = "reportIdLink" 
											onclick="fetchListOfBenchMarks(this, '${subRecord['ALERTID']}', '${UNQID}', '${subRecord['ALERTSUBGROUP']}')">${subRecord['ALERTNAME']}
										</td>
									</tr>
								</c:otherwise>
								</c:choose>
								<c:set var="LABELSITRCOUNT" value="${LABELSITRCOUNT + 1}" scope="page"/>	
								</c:if>
								</c:forEach>
							</tbody>
							</table>
						</div>
					</div>
					</div>
					</div>
				</c:forEach>
			</form>
			</div>
		</div>
		<div class="card card-primary" id="offlineAlertsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingOfflineAlertsListGenericDetails${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Alert Parameters List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="listOfAlertBenchMarks${UNQID}"></div>
		</div>
	</div>
</div>
