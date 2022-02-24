<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<style type="text/css">
.select2-container {
    width: 100% ! important;
}
</style>
<script type="text/javascript">
	$(document).ready(function() {
		var id = '${UNQID}';
		
		$(".datepicker").datepicker({
			changeMonth: true,
			changeYear: true,
			dateFormat: 'dd/mm/yy'
		});
		
		$("table.realTimeFileSearchTable"+id+" > tbody > tr > td > select").select2({
			width: 'resolve'
		});
		
		$("#searchRealTimeFile"+id).click(function(){
			var fileName = $("#rt_fileName_"+id).val();
			var reportStatus = $("#reportStatus"+id).val();
			var processingFromDate = $("#processingFromDate"+id).val();
			var processingToDate = $("#processingToDate"+id).val();
						
			var fullData = "counter=0&FileImport=Y&filename="+fileName+"&UserCode=NA&RecordStatus="+reportStatus+
			"&ScanningFromDate=&ScanningToDate=&ProcessingFromDate="+processingFromDate+"&ProcessingToDate="+processingToDate;
			
			$.ajax({
		 		url : "${pageContext.request.contextPath}/common/fileMatches",
		 		cache : true,
		 		type : "POST",
		 		data : fullData,
		 		success : function(resData){
		 			var RTWindow = $("#RTWindow").val();
		 			if(RTWindow != undefined){
		 				$("#RTScanningNewWindow").html(resData);
		 			}else{
		 				$("#compassRTScanningModal-body").html(resData);
		 			}
		 			
		 		}
		 	});
		});
	});
</script>
<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		<div class="card card-primary" id="realTimeFileMatch${UNQID}">
			<div class="card-header panelSlidingRealTimeFileMatch${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">File Match</h6>
			</div>
			<div class="panelSearchForm">
				<table class="table table-bordered table-striped realTimeFileSearchTable${UNQID}" style="margin-bottom: 0px;">
					<tr>
						<td width="15%">File Name</td>
						<td width="30%">
							<div class="input-group" style="z-index: 1">
								<input type="text" class="form-control input-sm" aria-describedby="basic-addon-filename" 
								id="rt_fileName_${UNQID}" name="fileName${UNQID}"/>
								<span class="input-group-addon formSearchIcon" id="basic-addon-filename${UNQID}" 
									onclick="compassTopFrame.moduleSearch('rt_fileName_${UNQID}','FILENAME','VW_RTSCANNINGUPLOADEDFILE','N','${pageContext.request.contextPath}')" style="cursor: pointer;" title="Search">
									<i class="fa fa-search"></i>
								</span>
							</div>
						</td>
						<td width="10%">
							&nbsp;
						</td>
						<td width="15%">Report Status</td>
						<td width="30%">
							<select class="form-control input-sm" id="reportStatus${UNQID}" name="reportStatus${UNQID}">
								<option value="ALL">ALL</option>
								<option value="Processed">Processed</option>
								<option value="True">True Match</option>
								<option value="False">False Match</option>
								<option value="Unprocessed">Unprocessed</option>
							</select>
						</td>
					</tr>
					<tr>
						<td>Processing From Date</td>
						<td>
							<input type="text" class="form-control input-sm datepicker" id="processingFromDate${UNQID}" name="processingFromDate${UNQID}"/>
						</td>
						<td>&nbsp;</td>
						<td>Processing To Date</td>
						<td>
							<input type="text" class="form-control input-sm datepicker" id="processingToDate${UNQID}" name="processingToDate${UNQID}"/>
						</td>
					</tr>
				</table>
			</div>
			<div class="card-footer clearfix">
				<div class="pull-${dirR}">
					<button  type="submit" id="searchRealTimeFile${UNQID}" class="btn btn-success btn-sm"><spring:message code="app.common.searchButton"/></button>
				</div>
			</div>
		</div>
		<div id="realTimeScanningFileSerachResult"></div>
	</div>
</div>