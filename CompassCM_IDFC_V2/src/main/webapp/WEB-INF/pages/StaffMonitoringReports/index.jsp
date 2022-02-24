<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
	var id = '${UNQID}';
	var preloaderUrl = "${pageContext.request.contextPath}/includes/images/qde-loadder.gif";
	compassTopFrame.init(id, 'compassStaffReportsSearchTable'+id, 'dd/mm/yy');
	
	$('.panelSlidingStaffMonitoringReports'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'staffMonitoringReportsSerachResultPanel'+id);
    });
	
	$("#reportId"+id).change(function(){
		var reportId = $(this).val();
		if(reportId != 'NA'){
			//alert(reportId);
			$("#reportParamsResultPanel"+id).css("display", "block");
			$("#reportParamsResult"+id).html("<br/><center> <img src='"+preloaderUrl+"' alt='Loading...'/></center>");
			$.ajax({
				url: "${pageContext.request.contextPath}/common/getStaffReportParams" ,
				cache: false,
				data: "reportId="+reportId,
				type: 'POST',
				success: function(res){
					$("#reportParamsResult"+id).html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		}
	});
		
	$("#searchStaffReports"+id).click(function(){
		var button = $("#searchStaffReports"+id);
		var formObj = $("#staffMonitoringReportsForm"+id);
		var formData = (formObj).serialize();
		//alert(formData);
		var mainRow = $(this).parents(".compassrow"+id);
		var slidingDiv = $(mainRow).children().children().children();
		var panelBody = $(mainRow).children().children().find(".panelSearchForm");
		$(button).html("Searching...");
		$(button).attr("disabled","disabled");
		$("#staffMonitoringReportsSerachResultPanel"+id).css("display", "block");
		$("#staffMonitoringReportsSerachResult"+id).html("<br/><center> <img src='"+preloaderUrl+"' alt='Loading...'/></center>");
		
		$.ajax({
			url : "${pageContext.request.contextPath}/common/getStaffMonitoringReportsData",
			type : "POST",
			cache : false,
			data : formData,
			success : function(res){
				$("#staffMonitoringReportsSerachResult"+id).html(res);
				$(button).html("Search");
				$(button).removeAttr("disabled");
				$(panelBody).slideUp();
				$(slidingDiv).addClass('card-collapsed');
				$(slidingDiv).find('i.collapsable').removeClass('fa-chevron-up').addClass('fa-chevron-down');
				$(mainRow).next().find(".compassrow"+id).find(".card-header").next().slideDown();
			},
			error : function(a,b,c){
				alert("Error while fetching data "+a+b+c);
			}
		});
	});
	
	$("#clearReportParams"+id).click(function(){
		reloadTabContent();
	});
	
	$("#emailExchange"+id).click(function(){
		var reportCaseNo = "";
		var reportId = "";
		var fromDate = "";
		var toDate = "";
		var staffAccNo = "";
		var count = 0;
		$("#staffMonitoringReportsSerachResult"+id).find("table").children("tbody").children("tr").each(function(){
			fromDate = $(this).children("td").children("input[name=fromDate]").val();
			toDate = $(this).children("td").children("input[name=toDate]").val();
			//toDate = $(this).children("td").children("input").val();
			if($(this).children("td").children("input").prop("checked")){
				reportId = $(this).children("td").children("input").val();
				reportCaseNo = $(this).children("td:nth-child(2)").html();
				staffAccNo = $(this).children("td:nth-child(6)").html();
				count++;
			}
		});
		if(reportCaseNo == ""){
			alert("Select a record");
		}else if(count > 1){
			alert("Select only one record");
		} else {
			//alert("reportId = "+reportId+" reportCaseNo = "+reportCaseNo+" fromDate = "+fromDate+" toDate = "+toDate+" staffAccNo = ");
			compassStaffEmailExchange.openEmail('${pageContext.request.contextPath}', reportId, reportCaseNo, fromDate, toDate, staffAccNo, '', 'COMPOSE');
		}
	});
	
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_staffMonitoringReports">
			<div class="card-header panelSlidingStaffMonitoringReports${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Staff Monitoring Reports</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="staffMonitoringReportsForm${UNQID}">
				<table class="table compassStaffMonitoringReportsSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Report Name</td>
						<td colspan="4">
							<select class="form-control input-sm" name="reportId" id="reportId${UNQID}">
								<option value="NA">Select a report</option>
								<c:forEach var="staffReportsList" items="${STAFFREPORTSLIST}">
									<option value="${staffReportsList['REPORTID']}">${staffReportsList['REPORTNAME']}</option>
								</c:forEach>
							</select>
						</td>
					</tr>
				</table>
				<div id="reportParamsResultPanel${UNQID}" style="display: none;">
				<div id="reportParamsResult${UNQID}"></div>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="submit" class="btn btn-primary btn-sm"  id="searchStaffReports${UNQID}" name="Search" value="Search">Search</button>
						<button type="button" class="btn btn-danger btn-sm" id="clearReportParams${UNQID}">Clear</button>
					</div>
					</div>
				</div>
			</form>
			</div>
		</div>
		
		
		<div class="card card-primary" id="staffMonitoringReportsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingStaffMonitoringReports${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Staff Monitoring Reports List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="staffMonitoringReportsSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" class="btn btn-primary btn-sm" id="emailExchange${UNQID}">Email Exchange</button>
				</div>
			</div>
		</div>
	</div>
</div>