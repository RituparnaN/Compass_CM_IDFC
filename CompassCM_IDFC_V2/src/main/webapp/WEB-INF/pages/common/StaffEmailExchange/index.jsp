<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../../tags/tags.jsp"%>
<script type="text/javascript">
	$(document).ready(function() {
		var emailCount = "";
		var folderType = "${folderType}";
		var reportId = "${reportId}";
		var reportCaseNo = "${reportCaseNo}";
		var fromDate = "${fromDate}";
		var toDate = "${toDate}";
		var staffAccNo = "${staffAccNo}";
		var emailNumber = "${emailNumber}";
		
		//alert("reportCaseNo = "+reportCaseNo+" reportId = "+reportId);
		
		compassStaffEmailExchange.highlightFolder(folderType);
		
		$(".emailComponent").click(function(){
			var folder = $(this).attr("id");
			
			if(folder != "COMPOSE"){
				compassStaffEmailExchange.highlightFolder(folder);
				compassStaffEmailExchange.showAllMessage("${pageContext.request.contextPath}", reportId, reportCaseNo, folder);
			}else{
				compassStaffEmailExchange.highlightFolder(folder);
				compassStaffEmailExchange.composeMessage("${pageContext.request.contextPath}", reportId, reportCaseNo, '', fromDate, toDate, staffAccNo, '','NEW');
			}
		});
		 if(emailNumber != ""){
			compassStaffEmailExchange.showMessage("${pageContext.request.contextPath}", reportId, reportCaseNo, emailNumber, folderType);
		}else{
			//compassStaffEmailExchange.showAllMessage("${pageContext.request.contextPath}", reportId, reportRowId, folderType);
			compassStaffEmailExchange.composeMessage("${pageContext.request.contextPath}", reportId, reportCaseNo, '', fromDate, toDate, staffAccNo, '','NEW');
		} 
	});
	
</script>
<div class="row">
	<div class="col-sm-2" id="emailComponent">
		<div style="margin-bottom: 3px;">
			<button id="COMPOSE" type="button" class="btn btn-sm emailComponent" style="width: 100%; text-align: left;">Compose</button>
		</div>
		<!-- <div style="margin-bottom: 3px;">
			<button id="INBOX" type="button" class="btn btn-sm emailComponent" style="width: 100%; text-align: left;">Inbox</button>
		</div> -->
		<div style="margin-bottom: 3px;">
			<button id="SENT" type="button" class="btn btn-sm emailComponent" style="width: 100%; text-align: left;">Sent</button>
		</div>
		<!-- <div>
			<button id="DRAFTS" type="button" class="btn btn-sm emailComponent" style="width: 100%; text-align: left;">Drafts</button>
		</div> -->
	</div>
	<div class="col-sm-10" id="emailBodySubjectPanel">
		
	</div>
</div>