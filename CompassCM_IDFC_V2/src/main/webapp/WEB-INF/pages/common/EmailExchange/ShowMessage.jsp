<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
	});
	
</script>
<style type="text/css">
.fileAttachment{
	overflow: hidden;
	white-space: nowrap;
	cursor: pointer;
}
.fileAttachment:HOVER {
	overflow: visible;
}
</style>
<c:forEach var="emailDetails" items="${EMAILDETAIL}">
	<fmt:parseNumber var="attachmentCount" type="number" value="${emailDetails['ATTACHMENTCOUNT']}" />
	<div class="row" style="width: 99%;">
		<div class="col-sm-12">
			<div style="width: 100%; font-size: 22px; font-family: Segoe UI Semibold">
				${emailDetails['SUBJECT']}
			</div>
		</div>
	</div>
	<div class="row" style="border-bottom: 1px solid black; width: 99%; padding-bottom: 10px;">
		<div class="col-sm-6">
			<div style="width: 100%; font-size: 10px; font-family: Segoe UI Semibold">
				FROM : ${emailDetails['SENDERID']}
			</div>
			<div style="width: 100%; font-size: 10px; font-family: Segoe UI Semibold">
				TO : ${emailDetails['RECIPIENTSTO']}
			</div>
			<div style="width: 100%; font-size: 10px; font-family: Segoe UI Semibold">
				CC : ${emailDetails['RECIPIENTSCC']}
			</div>
		</div>
		<div class="col-sm-6">
			<div class="pull-right" style="width: 100%; font-size: 12px; font-family: Segoe UI;">
				${emailDetails['RECEIVEDDATE']}
			</div>
			<br/>
			<div style="padding-top: 15px;  margin-left: 170px;">
				<button title="Back to ${emailDetails['FOLDERTYPE']}" class="btn btn-primary btn-sm" onclick="compassEmailExchange.showAllMessage('${pageContext.request.contextPath}','${emailDetails['CASENO']}','${emailDetails['FOLDERTYPE']}')">
					<i style="padding: 0 10px;" class="fa fa-arrow-left" aria-hidden="true"></i>
				</button>
				<button title="Reply" class="btn btn-success btn-sm" onclick="compassEmailExchange.composeMessage('${pageContext.request.contextPath}', '${caseNo}', '${emailNumber}', '${folder}','REPLY')">
					<i style="padding: 0 10px;" class="fa fa-reply" aria-hidden="true"></i>
				</button>
				<button title="Reply All" class="btn btn-success btn-sm" onclick="compassEmailExchange.composeMessage('${pageContext.request.contextPath}', '${caseNo}', '${emailNumber}', '${folder}','REPLYALL')">
					<i style="padding: 0 10px;" class="fa fa-reply-all" aria-hidden="true"></i>
				</button>
				<button title="Forward" class="btn btn-primary btn-sm" onclick="compassEmailExchange.composeMessage('${pageContext.request.contextPath}', '${caseNo}', '${emailNumber}', '${folder}','FORWARD')">
					<i style="padding: 0 10px;" class="fa fa-forward" aria-hidden="true"></i>
				</button>
				<c:if test="${attachmentCount > 1}">
					<button title="Download All Attachments" class="btn btn-warning btn-sm" onclick="compassEmailExchange.downloadAttachment('${pageContext.request.contextPath}','${emailDetails['CASENO']}','${emailDetails['MESSAGEINTERNALNO']}', '')">
						<i style="padding: 0 10px;" class="fa fa-download" aria-hidden="true"></i>
					</button>
				</c:if>
			</div>
		</div>
	</div>
	<c:if test="${attachmentCount > 0}">
		<div class="row" style="border-bottom: 1px solid black; width: 99%; padding: 10px 0px;">
			<c:forEach var="attachment" items="${EMAILATTACHMENTS}">
				<c:set var="fileType" value="${attachment['FILETYPE']}"/>
				<div class="col-sm-2 fileAttachment" onclick="compassEmailExchange.downloadAttachment('${pageContext.request.contextPath}','${attachment['CASENO']}','${attachment['MESSAGEINTERNALNO']}', '${attachment['ATTACHMENTNO']}')">
					<c:choose>
						<c:when test="${f:containsIgnoreCase(fileType, 'pdf')}">
							<i class="fa fa-file-pdf-o" aria-hidden="true"></i>
						</c:when>
						<c:when test="${f:containsIgnoreCase(fileType, 'xls') or f:containsIgnoreCase(fileType, 'xlsx')}">
							<i class="fa fa-file-excel-o" aria-hidden="true"></i>
						</c:when>
						<c:when test="${f:containsIgnoreCase(fileType, 'doc') or f:containsIgnoreCase(fileType, 'docx')}">
							<i class="fa fa-file-word-o" aria-hidden="true"></i>
						</c:when>
						<c:when test="${f:containsIgnoreCase(fileType, 'txt')}">
							<i class="fa fa-file-text-o" aria-hidden="true"></i>
						</c:when>
						<c:when test="${f:containsIgnoreCase(fileType, 'zip') or f:containsIgnoreCase(fileType, 'rar')}">
							<i class="fa fa-file-archive-o" aria-hidden="true"></i>
						</c:when>
						<c:when test="${f:containsIgnoreCase(fileType, 'jpg') or f:containsIgnoreCase(fileType, 'png') or f:containsIgnoreCase(fileType, 'jpeg')}">
							<i class="fa fa-file-image-o" aria-hidden="true"></i>
						</c:when>
						<c:otherwise>
							<i class="fa fa-file" aria-hidden="true"></i>
						</c:otherwise>
					</c:choose>
					${attachment['FILENAME']} <em style="font-size: 10px;">(${attachment['FILESIZE']})</em>
				</div>
			</c:forEach>
		</div>
	</c:if>
	
	<div class="row" style="margin-top: 10px;">
		<div class="col-sm-12">
			${emailDetails['MESSAGECONTENT']}
		</div>
	</div>
</c:forEach>