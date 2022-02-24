<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		compassTopFrame.init('', 'dashboardSearchTable', 'dd/mm/yy');

		$("#viewDashboard").click(function(){
			var fromDate = $(".dashboardFromDate").val();
			var toDate = $(".dashboardToDate").val();
			var sourceSystem = $(".dashboardSourceSystem").val();
			alert("No dashboard available");

			$.ajax({
				url: "${pageContext.request.contextPath}/common/getCheckerDashboard",
				cache: false,
				type: "POST",
				//data: "fromDate"+fromDate+"&toDate"+toDate+"&sourceSystem"+sourceSystem,
				success: function(res){
					//alert(res);
				},
				error: function(a,b,c){
					alert(a+b+c);
				}
			})
		});
	});
</script>
<div id="page-wrapper">
	<div class="row">
		<div class="col-lg-12">
			<ul class="nav nav-tabs compass-nav-tabs" role="tablist">
				<li class="active litabdashboard">
					<a class="nav-link active" href="#dashboard" data-toggle="tab">Dash Board</a></li>
			</ul>
			<div class="tab-content compass-tab-content">
				<div class="tab-pane active" id="dashboard">
					<div class="row">
						<div class="col-sm-12">
							<div class="card card-primary">
								<div class="card-header">
									<h6 class="card-title">
										Dash Board
									</h6>
								</div>
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
													<option>All</option>
													</select>
												</td>
												<td colspan="3">&nbsp;</td>
											</tr>
										</tbody>
									</table>
									<div class="card-footer clearfix">
										<div class="pull-${dirR}" >
											<button  type="submit" id="viewDashboard" class="btn btn-success btn-sm">
											<spring:message code="app.common.searchButton"/></button>
										</div>	
									</div>
									</div>	
									</div>	
									</div>	
									</div>
							</div>
							</div>
						</div>
	</div>
</div>