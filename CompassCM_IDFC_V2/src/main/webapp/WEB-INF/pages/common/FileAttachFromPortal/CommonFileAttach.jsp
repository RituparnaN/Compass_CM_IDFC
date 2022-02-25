<%@ page language="java" contentType="text/html;charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function(){
		var uploadRefNo = '${uploadRefNo}';
		var moduleRefNo = '${moduleRefId}';
	});
</script>
<table class="table table-bordered table-striped">
	<tr>
		<th width="20%">File Name</th>
		<th width="15%">Uploaded For</th>
		<th width="15%">File Size</th>
		<th width="15%">Uploaded By</th>
		<th width="15%">Uploaded On</th>
		<th width="20%">
			<button type="button" class="btn btn-warning btn-xs" onclick="compassFileUploadFromPortal.downloadFile(this, '', '', '${moduleRefId}', '${moduleUnqNo}')">Download All</button>
		</th>
	</tr>
	<c:forEach var="fileInfo" items="${FILEINFO}">
		<tr>
			<td>${fileInfo['FILENAME']}</td>
			<td>${fileInfo['MODULENAME']}</td>
			<td>${fileInfo['FILESIZE']}</td>
			<td>${fileInfo['UPLOADEDBY']}</td>
			<td>${fileInfo['UPLOADTIMESTMP']}</td>
			<td>
				<button class="btn btn-warning btn-xs" onclick="compassFileUploadFromPortal.downloadFile(this, '${fileInfo['SEQNO']}','${fileInfo['UPLOADREFNO']}','${moduleRefId}', '')">Download</button>
				<button class="btn btn-danger btn-xs" onclick="compassFileUploadFromPortal.removeFile(this, '${fileInfo['SEQNO']}','${fileInfo['UPLOADREFNO']}','${moduleRefId}', '')">Remove</button>
			</td>
		</tr>
	</c:forEach>
</table>