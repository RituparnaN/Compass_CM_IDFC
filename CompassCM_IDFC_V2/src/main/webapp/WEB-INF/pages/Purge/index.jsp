<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
	var id = '${UNQID}';
	var userRole = '${USERROLE}';
	compassTopFrame.init(id, 'compassPurgeSearchTable'+id, 'dd/mm/yy');
	
	$(".datepicker").datepicker({
		 dateFormat : "dd/mm/yy",
		 changeMonth: true,
	     changeYear: true
	});
	
	var start = 2018;
	var end = new Date().getFullYear()+15;
	/* var options = "<option value=''>Select Year</option>"; */
	var options = "<option value='2018'>2018</option>";
	for(var year = start+1 ; year <= end; year++){
	  options += "<option value = '"+year+"'>"+year+"</option>";
	}
	$("#yearField"+id).append(options);
	
	/* $('.panelSlidingPurge'+id).on("click", function (e) {
		var mainRow = $(this).parents(".compassrow"+id);
		compassTopFrame.searchPanelSliding(id, mainRow, 'purgeSerachResultPanel'+id);
    });
	
	$("#searchMasterForm"+id).submit(function(e){
		var submitButton = $("#searchPurge"+id);
			compassTopFrame.submitForm(id, e, submitButton, 'purgeSerachResultPanel', 
					'purgeSerachResult', '${pageContext.request.contextPath}/common/searchGenericMaster',
					'${pageContext.request.contextPath}/includes/images/qde-loadder.gif');
	}); */
	
	$("#updatePurge"+id).on("click",function(e){
		var month = $("#monthField"+id).val();
		var year = $("#yearField"+id).val();
		var table = $("#tableField"+id).val();
		var actionType = $("#actionTypeField"+id).val();
		if(year == ""){
			alert("Please select a valid year.");
		}
		else{
			$.ajax({
				url: "${pageContext.request.contextPath}/common/purgeUpdate",
				async: false,
				type:"POST",
				data: "month="+month+
				"&year="+year+"&table="+table+"&actionType="+actionType,
				success: function(result){
					alert(result);
			    },
			    error: function(a,b,c) {
					alert(a+b+c);
				}
			});
		}
	});
	
	
});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary panel_purge">
			<div class="card-header panelSlidingPurge${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Purge</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div class="panelSearchForm">
			<form action="javascript:void(0)" method="POST" id="searchMasterForm${UNQID}">
				<input type="hidden" name="moduleType" value="${MODULETYPE}">
				<input type="hidden" name="bottomPageUrl" value="Purge/SearchBottomPage">
				<table class="table compassPurgeSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">Month</td>
						<td width="30%">
							<select class="form-control input-sm" id="monthField${UNQID}" name="1_MONTH" style="width: 100%;">
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
								<option value="04">April</option>
								<option value="05">May</option>
								<option value="06">June</option>
								<option value="07">July</option>
								<option value="08">August</option>
								<option value="09">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Year</td>
						<td width="30%">
							<%-- <input type="text" class="form-control input-sm" name="2_YEAR" id="yearField${UNQID}"></input> --%>
							<select class="form-control input-sm" id="yearField${UNQID}" name="2_YEAR" style="width: 100%;">
								<!-- <option value="">Select year</option> -->
							</select>
						</td>
					</tr>
					<tr>
						<td width="15%">Table</td>
						<td width="30%">
							<select class="form-control input-sm" id="tableField${UNQID}" name="3_TABLE" style="width: 100%;">
								<option value="MAINTRANSACTIONS">Transactions</option>
								<option value="PROFILETRANSACTIONS">Accounts Profiling</option>
							</select>
						</td>
						<td width="10%">&nbsp;</td>
						<td width="15%">Action Type</td>
						<td width="30%">
							<select class="form-control input-sm" id="actionTypeField${UNQID}" name="4_ACTIONTYPE" style="width: 100%;">
								<option value="ARCHIVE">Archive</option>
								<option value="RESTORE">Restore</option>
							</select>
						</td>
					</tr>
				</table>
				<div class="card-footer clearfix">
					<div class="pull-${dirR}">
						<button type="submit" id="updatePurge${UNQID}" class="btn btn-primary btn-sm" name="Update" value="Update">Update</button>
						<%-- <input type="reset" id="clearPurge${UNQID}" class="btn btn-danger btn-sm" name="Clear" value="Clear"> --%>
					</div>
				</div>
			</form>
			</div>
		</div>
		<%-- <div class="card card-primary" id="purgeSerachResultPanel${UNQID}" style="display: none;">
			<div class="card-header panelSlidingPurge${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">List</h6>
				<div class="btn-group pull-${dirR} clearfix">
					<span class="pull-right"><i class="collapsable fa fa-chevron-up"></i></span>
				</div>
			</div>
			<div id="purgeSerachResult${UNQID}"></div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<input type="button" class="btn btn-primary btn-sm" id="viewDetails${UNQID}" name="View" value="View"/>
					<input type="button" class="btn btn-success btn-sm" id="approveReject${UNQID}" name="Approve/Reject" value="Approve/Reject"/>
					<input type="button" class="btn btn-success btn-sm" id="update${UNQID}" name="Update" value="Update"/>
				</div>
			</div>
		</div> --%>
	</div>
</div>