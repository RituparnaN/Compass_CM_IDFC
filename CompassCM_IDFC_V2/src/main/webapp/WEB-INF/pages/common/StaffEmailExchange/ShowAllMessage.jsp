<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
	});
	
</script>
<style type="text/css">
#emailTable > tbody > tr:HOVER{
	background: #DDD;
	cursor: pointer;
}
#emailTable > tbody > tr.unSeenEmail{
	font-size: 14px;
	font-weight: bold;
}
#emailTable > tbody > tr.seenEmail{
	font-size: 12px;
	font-weight: normal;
}
</style>
<div class="row">
	<div class="col-sm-12">
		<c:choose>
			<c:when test="${f:length(EMAILDETAIL) > 0}">
				<table class="table table-striped" id="emailTable">
					<thead>
						<tr>
							<th width="25%">Sender</th>
							<th width="50%">Subject</th>
							<th width="10%">Attachment</th>
							<th width="15%">Received On</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="emailDetails" items="${EMAILDETAIL}">
						<c:set var="seenFlag" value="seenEmail"/>
						<fmt:parseNumber var="attachmentCount" type="number" value="${emailDetails['ATTACHMENTCOUNT']}" />
						<c:if test="${emailDetails['SEENFLAG'] eq 'N' }">
							<c:set var="seenFlag" value="unSeenEmail"/>
						</c:if>
						<c:if test="${emailDetails['FOLDERTYPE'] ne 'DRAFTS'}">
							<tr class="${seenFlag}" onclick="compassEmailExchange.showMessage('${pageContext.request.contextPath}','${emailDetails['CASENO']}','${emailDetails['MESSAGEINTERNALNO']}','${emailDetails['FOLDERTYPE']}')">
								<td>${emailDetails['SENDERID']}</td>
								<td>${emailDetails['SUBJECT']}</td>
								<td>
									<c:if test="${attachmentCount > 0 }">
										<i class="fa fa-paperclip" aria-hidden="true">
									</c:if>
								</td>
								<td>${emailDetails['UPDATETIMESTAMP']}</td>
							</tr>
						</c:if>
						<c:if test="${emailDetails['FOLDERTYPE'] eq 'DRAFTS'}">
							<tr class="${seenFlag}" onclick="compassEmailExchange.composeMessage('${pageContext.request.contextPath}','${emailDetails['CASENO']}','${emailDetails['MESSAGEINTERNALNO']}','${emailDetails['FOLDERTYPE']}','DRAFTS')">
								<td>${emailDetails['SENDERID']}</td>
								<td>${emailDetails['SUBJECT']}</td>
								<td>${emailDetails['MESSAGEINTERNALNO']}
									<c:if test="${attachmentCount > 0 }">
										<i class="fa fa-paperclip" aria-hidden="true">
									</c:if>
								</td>
								<td>${emailDetails['UPDATETIMESTAMP']}</td>
							</tr>
						</c:if>	
						</c:forEach>
					</tbody>
				</table>
			</c:when>
			<c:otherwise>
				<br/>
				<br/>
				<div style="text-align: center;">
					No Email Found
				</div>
				<br/>
			</c:otherwise>
		</c:choose>
		
	</div>
</div>