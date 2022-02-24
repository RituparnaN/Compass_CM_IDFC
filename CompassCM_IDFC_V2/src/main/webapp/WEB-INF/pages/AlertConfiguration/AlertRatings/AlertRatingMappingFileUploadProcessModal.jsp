<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
$(document).ready(function() {
	var id = '${UNQID}';
	var uploadRefNo = '${uploadRefNo}';
	var moduleRefId = '${moduleRefId}';
	
	$("#processAlertRatingsMappingFile"+id).click(function(){
		var fullData = "uploadRefNo="+uploadRefNo+"&moduleRefId="+moduleRefId;
		$.ajax({
			url: "${pageContext.request.contextPath}/admin/processAlertRatingUploadedFile",
			cache: false,
			type: "POST",
			data: fullData,
			success: function(res){
				alert(res);
				$("#compassFileUploadModal").modal("hide");
			//	$(tr).children("td:first-child").children("input").prop("checked",true);
			},
			error: function(a,b,c){
				alert(a+b+c);
			}
		});
	});
});
</script>

<div class="row compassrow${UNQID}">
	<div class="col-sm-12">
		 <div class="card card-primary panel_processAlertRatingsMapping">
			<div class="card-header panelSlidingAlertRatingsMappingFile${UNQID} clearfix">
				<h6 class="card-title pull-${dirL}">Alert Ratings Mapping File Upload Process</h6>
			</div>
			<div class="card-footer clearfix">
				<p style="color: red;">Click the Process button to process the uploaded file.</p>
				<div style="float: right;">
					<input type="button" class="btn btn-success btn-sm" id="processAlertRatingsMappingFile${UNQID}" name="Process" value="Process"/>
				</div>
			</div>
		 </div>
	</div>
</div>