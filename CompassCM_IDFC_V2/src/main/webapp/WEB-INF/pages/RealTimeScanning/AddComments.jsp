<%@ include file="../tags/tags.jsp"%>
<%
String l_mode = (String)request.getAttribute("mode");
String l_selected = (String)request.getAttribute("selected");
String l_action = (String)request.getAttribute("action");
String l_counter = (String)request.getAttribute("counter"); 
String l_fileName = (String)request.getAttribute("FileName"); 
String l_comment = (String)request.getAttribute("comment");
String l_fileimport = (String)request.getAttribute("FileImport");
 
String l_ScanningFromDate = (String)request.getAttribute("ScanningFromDate");
String l_ScanningToDate = (String)request.getAttribute("ScanningToDate");
String l_ProcessingFromDate = (String)request.getAttribute("ProcessingFromDate");
String l_ProcessingToDate = (String)request.getAttribute("ProcessingToDate");
String l_UserCode = (String)request.getAttribute("UserCode");
String l_RecordStatus = (String)request.getAttribute("RecordStatus");
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String LOGGEDUSER = request.getParameter("LOGGEDUSER") == null ? "AMLUser":(String)request.getParameter("LOGGEDUSER");

%>
<body bgcolor="#F2F2F1">
<HEAD>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>AddComments</title>
	<style>
	.but1 {  font-size: 10px; color: #000000; text-align: center; background-color: #F2F2F1; background-repeat: no-repeat;height: 17px; width: 140px;border: 1px #000000 solid; clip:  rect(   )}

	</style>
<script type="text/javascript">
	$(document).ready(function(){

		$("#saveMatchComments").click(function(){
		  var comments= $("#rt_comments").val();
		  var mode = '<%=l_mode%>';
		  if(mode == 'auditlog')
		  	var url = '<%=contextPath%>/common/updateRecord?action='+mode+'&selected=<%=l_selected%>&FileName=<%=l_fileName%>&FileImport=<%=l_fileimport%>&counter=<%=l_counter%>&UserCode=<%=l_UserCode%>&ProcessingFromDate=<%=l_ProcessingFromDate%>&ProcessingToDate=<%=l_ProcessingToDate%>&comments='+comments;
		  else  
		  var url = '<%=contextPath%>/common/updateRecord?action=<%=l_action%>&selected=<%=l_selected%>&FileName=<%=l_fileName%>&counter=<%=l_counter%>&UserCode=<%=l_UserCode%>&RecordStatus=<%=l_RecordStatus%>&ScanningFromDate=<%=l_ScanningFromDate%>&ScanningToDate=<%=l_ScanningToDate%>&ProcessingFromDate=<%=l_ProcessingFromDate%>&ProcessingToDate=<%=l_ProcessingToDate%>&FileImport=<%=l_fileimport%>&comments='+comments;  
		
		  $.ajax({
	 		url : url,
	 		cache : true,
	 		type : 'GET',
	 		success : function(resData){
	 			$("#compassMediumGenericModal").modal("hide");
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
<script>
<!--
function saveComments(){
	//alert('dsfsdfsd');
  var comments= document.saveFrm.comments.value;
  var mode = '<%=l_mode%>';
  if(mode == 'auditlog')
  	var URL = '<%=contextPath%>/common/updateRecord?action='+mode+'&selected=<%=l_selected%>&FileName=<%=l_fileName%>&FileImport=<%=l_fileimport%>&counter=<%=l_counter%>&UserCode=<%=l_UserCode%>&ProcessingFromDate=<%=l_ProcessingFromDate%>&ProcessingToDate=<%=l_ProcessingToDate%>&comments='+comments;
  else  
  var URL = '<%=contextPath%>/common/updateRecord?action=<%=l_action%>&selected=<%=l_selected%>&FileName=<%=l_fileName%>&counter=<%=l_counter%>&UserCode=<%=l_UserCode%>&RecordStatus=<%=l_RecordStatus%>&ScanningFromDate=<%=l_ScanningFromDate%>&ScanningToDate=<%=l_ScanningToDate%>&ProcessingFromDate=<%=l_ProcessingFromDate%>&ProcessingToDate=<%=l_ProcessingToDate%>&FileImport=<%=l_fileimport%>&comments='+comments;  
  //opener.location.replace(URL);
  opener.location.reload(URL);
  window.close();
}
-->
</script>	
</HEAD>

<div class="row">
	<div class="col-sm-12">
		<div class="card card-primary">
			<div class="card-search-card">
				<table class="table table-striped formSearchTable">
					<tbody>
						<tr>
							<td width="15%">Enter Comments</td>
							<td width="85%">
								<%if(l_comment!=null){%>
									<textarea class="form-control" rows=9 cols=45 name='comments' id="rt_comments"><%=l_comment%></textarea>
									<%} else {%>
									<textarea class="form-control" rows=9 cols=45 name='comments' id="rt_comments"></textarea>
								<%}%>								
							</td>
						</tr>
						<%if(l_action!=null && !l_action.equalsIgnoreCase("view")){%>
						<tr>
							<td colspan="2">
								<center>
									<button type="button" class="btn btn-success btn-sm" id="saveMatchComments">Save</button>
								</center>
							</td>
						</tr>
					   <%}%>
					   <%if(l_action!=null && l_action.equalsIgnoreCase("view")){%>
						<tr>
							<td colspan="2">
								<center>
									<button type="button" class="btn btn-success btn-sm" id="closeWindow" onclick="window.close()">Close</button>
								</center>
							</td>
						</tr>
					   <%}%>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>
</body>
