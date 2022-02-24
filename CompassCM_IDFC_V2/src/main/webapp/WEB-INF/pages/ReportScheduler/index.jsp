<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%> 
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		compassTopFrame.init(id, 'reportScheduler'+id, 'dd/mm/yy');
		
		
		$("#searchScheduledReports").click(function(){
			var reportID = $("#reportID").val();
			var reportName = $('#reportID option:selected').text();
		//	var reportName = $("#reportID").options[$("#reportID").selectedIndex].text;
			var targetUrl = "${pageContext.request.contextPath}/admin/searchAllReportForScheduling";
			$.ajax({
				url : targetUrl,
				data : "reportName="+reportName+"&reportID="+reportID,
				type : "GET",
				cache : false,
				success : function(res){
					$("#scheduledReportsSerachResultPanel"+id).css("display", "block");
					$("#scheduledReportsSerachResult"+id).html(res);
				}
			});
			
		});
		
		$("#downloadScheduledReports").click(function(){
			$("#compassSearchModuleModal").modal("show");
			$("#compassSearchModuleModal-title").html("Download Scheduled Report");
			$.ajax({
				url : "${pageContext.request.contextPath}/admin/downloadScheduledReport",
				data : "path=root",
				type : "GET",
				cache : false,
				success : function(res){
					$("#compassSearchModuleModal-body").html(res);
				}
			});
		});
	});
	
	function openScheduledReportDownloadFolder(path,back){
		$.ajax({
			url : "${pageContext.request.contextPath}/admin/downloadScheduledReport",
			data : "path="+path+"&b="+back,
			type : "GET",
			cache : false,
			success : function(res){
				$("#compassSearchModuleModal-body").html(res);
			}
		});
	}
	
	function displayReportDetails(reportGroup){
		var targetUrl = "${pageContext.request.contextPath}/admin/getReportNameList?group="+reportGroup;
		$.ajax({
			url : targetUrl,
			type : "GET",
			cache : false,
			success : function(res){
				$("#reportDetails").html(res);
			}
		});
	}
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_reportScheduler">
			<div class="card-header panelSlidingReportScheduler${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Report Scheduler</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
				<table class="table  reportScheduler${UNQID}"  style="margin-bottom: 0px;">
					<tbody>
						<tr>
							<td width="15%">
								Report Type
							</td>
							<td width="30%">
								<select class="form-control input-sm" id="reportGroup" onchange="displayReportDetails(this.value)">
									<option value="">Select One</option>
									<option value="TRANSACTIONREPORTS">Transaction Based Reports</option>
									<option value="MISCELLANEOUSREPORTS">Miscellaneous Reports</option>
								</select>
							</td>
							<td>&nbsp;</td>
							<td width="15%">
								Report Name
							</td>
							<td width="30%" id="reportDetails">
								<select class="form-control input-sm" id="reportGroup">
									<option value="">Select One</option>
								</select>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button type="button" class="btn btn-primary btn-sm" id="searchScheduledReports">Search</button>
					<button type="button" id="downloadScheduledReports" class="btn btn-warning btn-sm">Download Generated Reports</button>
				</div>
			</div>
		</div>
		<div class="card card-primary" id="scheduledReportsSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingScheduledReports${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Scheduled Reports</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="scheduledReportsSerachResult${UNQID}"></div>
		</div>
	</div>
</div>