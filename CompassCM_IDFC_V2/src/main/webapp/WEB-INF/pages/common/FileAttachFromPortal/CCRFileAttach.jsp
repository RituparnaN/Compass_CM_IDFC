<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var uploadRefNo = '${uploadRefNo}';
		var moduleRefNo = '${moduleRefId}';
		
		$("#attachFile").click(function(){
			var month = $("#ccrReportingMonth").val();
			var year = $("#ccrReportingYear").val();
			var btn = (this);
			$(btn).html("Processing...");
			$(btn).attr("disabled", true);
			$.ajax({
				url : "${pageContext.request.contextPath}/commonFromPortal/attachAndProcessCCRUploadedFile",
				type: "POST",
				cache : false,
				data : "uploadRefNo="+uploadRefNo+"&moduleRefNo="+moduleRefNo+"&month="+month+"&year="+year,
				success : function(resData){
					if(resData == true){
						$(btn).parent("td").html("CCR File Processing Successfully Completed");
					}else{
						$(btn).parent("td").html("Error while Processing CCR File");
					}
				},
				error : function(){
					alert("Error while file processing");
				}
			});
		});
	});
</script>
<table class="table table-bordered table-striped">
	<tr>
		<td width="25%">File Name</td>
		<td width="25%">Uploaded For</td>
		<td width="25%">File Size</td>
		<td width="25%">
			<button type="button" class="btn btn-warning btn-xs" onclick="compassFileUploadFromPortal.downloadFile(this, '', '${uploadRefNo}', '${moduleRefId}', '')">Download All</button>
		</td>
	</tr>
	<c:forEach var="fileInfo" items="${FILEINFO}">
		<tr>
			<td>${fileInfo['FILENAME']}</td>
			<td>${fileInfo['MODULENAME']}</td>
			<td>${fileInfo['FILESIZE']}</td>
			<td><button class="btn btn-warning btn-xs" onclick="compassFileUploadFromPortal.downloadFile(this, ${fileInfo['SEQNO']},'${uploadRefNo}','${moduleRefId}', '')">Download</button></td>
		</tr>
	</c:forEach>
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td>
			Enter Month
		</td>
		<td>
			<select id="ccrReportingMonth" class="form-control input-sm">
				<c:forEach var="month" items="${months}">
					<option value="${month['NO']}" <c:if test="${month['NO'] eq currentMonth}">selected="selected"</c:if>>${month['NAME']}</option>
				</c:forEach>
			</select>
		</td>
		<td>
			Enter Year
		</td>
		<td>
			<select id="ccrReportingYear" class="form-control input-sm">
				<c:forEach var="year" items="${years}">
					<option value="${year['NO']}" <c:if test="${year['NO'] eq currentYear}">selected="selected"</c:if> >${year['NAME']}</option>
				</c:forEach>
			</select>
		</td>
	</tr>
	<tr>
		<td colspan="4" style="text-align: center;">
			<button class="btn btn-primary btn-sm" id="attachFile">Process Uploaded CCR Data</button>
		</td>
	</tr>
</table>