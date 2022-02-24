<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<c:set var="ROLE" value="${f:substring(userRole,5,12)}"/>
<script type="text/javascript">
	$(document).ready(function(){
		var id = '${UNQID}';
		var currentRole = '${CURRENTROLE}';
		var tableClass = 'crpExecutionSchedulerDetailsTable';
		compassDatatable.construct(tableClass, "CRP Execution Scheduler Details", false);
		
		$(".datepicker").datepicker({
			 dateFormat : "dd/mm/yy",
			 changeMonth: true,
		     changeYear: true
		 });
	
	$("#submitSchedulingDates"+id).click(function(){
		var executedFromDate = $("#executedFromDate").val();
		var executedToDate = $("#executedToDate").val();
		var executedDate = $("#executedDate").val();
		var scheduledFromDate = $("#scheduledFromDate").val();
		var scheduledToDate = $("#scheduledToDate").val();
		var executionDate = $("#executionDate").val();
		var fullData = "EXECUTED_FROMDATE="+executedFromDate+"&EXECUTED_TODATE="+executedToDate+
					   "&EXECUTED_DATE="+executedDate+"&SCHEDULED_FROMDATE="+scheduledFromDate+"&SCHEDULED_TODATE="+scheduledToDate+
					   "&EXECUTION_DATE="+executionDate;	
		//alert(fullData);
		
		$.ajax({
			url: "${pageContext.request.contextPath}/common/saveSchedulingDates",
			data : fullData,
			cache:	false,
			type: "POST",
			success: function(response){
				alert(response);
				reloadTabContent();
			}, 
			error: function(a,b,c){
				alert(a+b+c);
			}				
		});
	});
	
});

</script>
<style type="text/css">
	fieldset.crpScheduler{
	border: 1px groove #ddd !important;
    padding: -5px 10px 5px 10px!important;
    margin: 5px 0 0 0 !important;
    -webkit-box-shadow:  0px 0px 0px 0px #000;
            box-shadow:  0px 0px 0px 0px #000;
	}
	legend.crpScheduler {
	text-align: left !important;
	width:inherit; 
    border-bottom:none;
    margin: 0px;
    margin-left: 10px;
    margin-bottom : 5px;
    padding: 0px;
}
</style>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_crpExecutionScheduler">
			<div class="card-header panelCRPExecutionScheduler${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">CRP Execution Scheduler</h6>
			</div>
			<form id="crpExecutionSchedulerForm" >
			<div class="panelSearchForm previousPanel" style="padding: 0px 5px 5px 5px;">
			<fieldset class="crpScheduler">
					<legend class="crpScheduler" style=" color:red; font-size: 13px; font-weight: bold;" >Executed Details</legend>
						<table class="table executedTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="15%">Executed From Date</td>
								<td width="30%">
									<input type="text" disabled="disabled" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="executedFromDate" name="executedFromDate" value="${RESULTDATA['EXECUTED_FROMDATE']}"/>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Executed To Date</td>
								<td width="30%">
									<input type="text" disabled="disabled" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="executedToDate" name="executedToDate" value="${RESULTDATA['EXECUTED_TODATE']}"/>
								</td>
							</tr>
							<tr>
								<td width="15%">Executed Date</td>
								<td width="30%">
									<input type="text" disabled="disabled" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="executedDate" name="executedDate" value="${RESULTDATA['EXECUTED_DATE']}"/>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">&nbsp;</td>
								<td width="30%">&nbsp;</td>
							</tr>
						</table>
					</fieldset>
			</div>
			<div class="panelSearchForm scheduledPanel" style="padding: 0px 5px 5px 5px;">
			<fieldset class="crpScheduler">
					<legend class="crpScheduler" style=" color:red; font-size: 13px; font-weight: bold;" >Scheduled Details</legend>
						<table class="table scheduledTable table-striped" style="margin-bottom: 0px; margin-top: 0px;">
							<tr>
								<td width="15%">Scheduled From Date</td>
								<td width="30%">
									<input type="text" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="scheduledFromDate" name="scheduledFromDate" value="${RESULTDATA['SCHEDULED_FROMDATE']}"/>
								</td>
								<td width="10%">&nbsp;</td>
								<td width="15%">Scheduled To Date</td>
								<td width="30%">
									<input type="text" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="scheduledToDate" name="scheduledToDate" value="${RESULTDATA['SCHEDULED_TODATE']}"/>
								</td>
							</tr>
							<tr>
								<td width="15%">Execution Date</td>
								<td width="30%">
									<input type="text" class="form-control input-sm datepicker" aria-describedby="basic-addon" id="executionDate" name="executionDate" value="${RESULTDATA['EXECUTION_DATE']}"/>
								</td>
								<td colspan="3">&nbsp;</td>
							</tr>
						</table>
				</fieldset>
			</div>
		<div class="card-footer clearfix">
			<div class="pull-right">
				<input type="button" class="btn btn-success btn-sm" id="submitSchedulingDates${UNQID}" name="Submit" value="Post"/>
				<input type="reset" class="btn btn-danger btn-sm" id="clearForm${UNQID}" name="Clear" value="Clear"/>
			</div>
		</div>
	</form>
	</div>
</div>
</div>	