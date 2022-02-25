<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		compassTopFrame.init('', 'dashboardSearchTable', 'dd/mm/yy');
		$(".dashboardFromDate").val('');
		$(".dashboardToDate").val('');

		$("#viewDashboard").click(function(){
			var fromDate = $(".dashboardFromDate").val();
			var toDate = $(".dashboardToDate").val();
			var sourceSystem = $(".dashboardSourceSystem").val();
			
			$.ajax({
				url: "${pageContext.request.contextPath}/common/getDashboardTabView",
				cache: false,
				type: "POST",
				data: "fromDate="+fromDate+"&toDate="+toDate+"&sourceSystem="+sourceSystem,
				success: function(res){
					$("#dashboardSerachResultPanel").css("display", "block");
					$("#dashboardSearchResult").html(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			});
		});

		$("#downloadDashboard").click(function(){
			var fromDate = $(".dashboardFromDate").val();
			var toDate = $(".dashboardToDate").val();
			var sourceSystem = $(".dashboardSourceSystem").val();
			//alert('fromDate : '+fromDate);
			// window.open("${pageContext.request.contextPath}/DashBoard?FromDate="+formDate+"&ToDate="+toDate+"&SourceSystem="+sourceSystem);
			if(confirm("Are you sure you want to Generate Excel Report?")){
				$.fileDownload("${pageContext.request.contextPath}/DashBoard?FromDate="+fromDate+"&ToDate="+toDate+"&SourceSystem="+sourceSystem, {
				    httpMethod : "GET",
					successCallback: function (url) {					 
				    	$(elm).html("Downloaded");
				    },
				    failCallback: function (html, url) {
				        alert('Failed to download file'+url+"\n"+html);
				    }
				});
			}
		});
		
		
		/*
		$("form").each(function(){
			var form = $(this);
			$("button[type='submit']", form).bind("click keypress", function(){
				$(form).data("callerid", $(this).attr("id"));
			});
			
		});
		*/
	});
	/*
	 onsubmit="checkForm(this)"
	function checkForm(elm){
		var callerid = $(elm).data("callerid");
		alert("callerid : "+callerid);
		return false;
	}
	*/
</script>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<ul class="nav nav-tabs compass-nav-tabs" role="tablist">
				<li class="active litabdashboard">
					<a href="#dashboard" data-toggle="tab">Dash Board</a></li>
			</ul>
			<div class="tab-content compass-tab-content">
				<div class="tab-pane active" id="dashboard">
					<div class="row">
						<div class="col-sm-12">
							<div class="card card-primary panel_dashBoard">
								<div class="card-header panelSlidingDashBoard${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Dashboard</h6>
									<div class="btn-group pull-${dirR} clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
								</div>
								<form action="javascript:void()" method="POST">
									<div class="panelSearchForm">
										<table class="table table-striped dashboardSearchTable" style="margin-bottom: 0px">
											<tbody>
												<tr>
													<td width="15%">
														From Date 
													</td>
													<td width="30%">	
														<input type="text" id="FROMDATE" class="form-control input-sm datepicker dashboardFromDate"/>
													</td>
													<td width="10%">&nbsp;</td>
													<td width="15%">
														To Date 
													</td>
													<td width="30%">
														<input type="text" id="TODATE" class="form-control input-sm datepicker dashboardToDate"/>
													</td>
												</tr>
												<tr>
													<td width="15%">
														Source System
													</td>
													<td width="30%">	
														<select id="SOURCESYSTEM" class="form-control input-sm dashboardSourceSystem ">
															<option value="ALL">All</option>
														</select>
													</td>
													<td colspan="3">&nbsp;</td>
												</tr>
											</tbody>
										</table>
										<div class="card-footer clearfix">
											<div class="pull-${dirR}" >
												<button type="button" id="viewDashboard" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
												<button type="button" id="downloadDashboard" class="btn btn-warning btn-sm">Download Excel</button>
											</div>	
											</div>
									</div>
								</form>
							</div>
							<div class="card card-primary" id="dashboardSerachResultPanel" style="display: none;">
								<div class="card-header panelSlidingDashBoard${UNQID} clearfix">
									<h6 class="card-title pull-${dirL}">Dashboard</h6>
									<div class="btn-group pull-${dirR} clearfix">
										<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
									</div>
								</div>
								<div id="dashboardSearchResult" style="overflow-y: auto"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>