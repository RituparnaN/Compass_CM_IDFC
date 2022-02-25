<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ include file="../tags/tags.jsp"%>
<%@page import="java.util.*"%>
<%
String l_mode = (String)request.getParameter("mode");
String l_selected = (String)request.getParameter("selected");
String l_action = (String)request.getParameter("action");
String l_counter = (String)request.getParameter("counter"); 
String l_fileName = (String)request.getParameter("FileName"); 
String l_comment = (String)request.getParameter("comment");
String l_fileimport = (String)request.getParameter("FileImport");
 
String l_UserCode = (String)request.getParameter("UserCode");
String l_strTopN = request.getParameter("TopN") == null ? "0":(String)request.getParameter("TopN");
String l_strFromDate = (String)request.getParameter("l_strFromDate");
String l_strToDate = (String)request.getParameter("l_strToDate");
String l_strCustomerNameCheck = (String)request.getParameter("l_strCustomerNameCheck");
String l_strMotherNameCheck = (String)request.getParameter("l_strMotherNameCheck");
String l_strPermanentAddressLine1Check = (String)request.getParameter("l_strPermanentAddressLine1Check");
String l_strCommAddressLine1Check = (String)request.getParameter("l_strCommAddressLine1Check");
String l_strPanNoCheck = (String)request.getParameter("l_strPanNoCheck");
String l_strPassportNoCheck = (String)request.getParameter("l_strPassportNoCheck");
String l_strDrivingLicenseNoCheck = (String)request.getParameter("l_strDrivingLicenseNoCheck");
String l_strDateOfBirthCheck = (String)request.getParameter("l_strDateOfBirthCheck");

String contextPath = request.getContextPath()==null?"":request.getContextPath();

%>
<body bgcolor="#F2F2F1">
<HEAD>
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
	<title>AddComments</title>
	<style>
	.but1 {  font-size: 10px; color: #000000; text-align: center; background-color: #F2F2F1; background-repeat: no-repeat;height: 17px; width: 140px;border: 1px #000000 solid; clip:  rect(   )}

	</style>
<script>
<!--function saveComments(){
  var comments= document.saveFrm.comments.value;
  var counter = '<%=l_counter%>';
  //alert('comments  '+comments);
  var URL = '<%=contextPath%>/common/deDupUpdateRecord?action=<%=l_action%>&selected=<%=l_selected%>&counter='+counter+'&TopN='+counter+'&l_strFromDate=<%=l_strFromDate%>&l_strToDate=<%=l_strToDate%>&l_strCustomerNameCheck=<%=l_strCustomerNameCheck%>&l_strMotherNameCheck=<%=l_strMotherNameCheck%>&l_strPermanentAddressLine1Check=<%=l_strPermanentAddressLine1Check%>&l_strCommAddressLine1Check=<%=l_strCommAddressLine1Check%>&l_strPanNoCheck=<%=l_strPanNoCheck%>&l_strPassportNoCheck=<%=l_strPassportNoCheck%>&l_strDrivingLicenseNoCheck=<%=l_strDrivingLicenseNoCheck%>&l_strDateOfBirthCheck=<%=l_strDateOfBirthCheck%>&comments='+comments;  
  //alert(URL);
  opener.location.replace(URL);
  window.close();
}-->
</script>
<script type="text/javascript">
	$(document).ready(function(){
		var UserCode = '${UserCode}';
		var action = '${action}';
		var selected = '${selected}';
		var l_strFromDate = '${l_strFromDate}';
		var l_strToDate = '${l_strToDate}';
		var l_strCustomerNameCheck = '${l_strCustomerNameCheck}';
		var l_strMotherNameCheck = '${l_strMotherNameCheck}';
		var l_strPermanentAddressLine1Check = '${l_strPermanentAddressLine1Check}';
		var l_strCommAddressLine1Check = '${l_strCommAddressLine1Check}';
		var l_strPanNoCheck = '${l_strPanNoCheck}';
		var l_strPassportNoCheck = '${l_strPassportNoCheck}';
		var l_strDrivingLicenseNoCheck = '${l_strDrivingLicenseNoCheck}';
		var l_strDateOfBirthCheck = '${l_strDateOfBirthCheck}';
		
		$("#saveMatchComments").click(function(){
		  var comments= $("#rt_comments").val();
		  var mode = '<%=l_mode%>';
		  var counter = '<%=l_counter%>';

		  if(mode == 'auditlog')
			var url = '<%=contextPath%>/common/deDupUpdateRecord?action='+mode+'&selected='+selected+'&counter='+counter+'&TopN='+counter+'&l_strFromDate='+l_strFromDate+'&usercode='+UserCode+'&l_strToDate='+l_strToDate+'&l_strCustomerNameCheck='+l_strCustomerNameCheck+'&l_strMotherNameCheck='+l_strMotherNameCheck+'&l_strPermanentAddressLine1Check='+l_strPermanentAddressLine1Check+'&l_strCommAddressLine1Check='+l_strCommAddressLine1Check+'&l_strPanNoCheck='+l_strPanNoCheck+'&l_strPassportNoCheck='+l_strPassportNoCheck+'&l_strDrivingLicenseNoCheck='+l_strDrivingLicenseNoCheck+'&l_strDateOfBirthCheck='+l_strDateOfBirthCheck+'&comments='+comments;
		  else  
			var url = '<%=contextPath%>/common/deDupUpdateRecord?action='+action+'&selected='+selected+'&counter='+counter+'&TopN='+counter+'&l_strFromDate='+l_strFromDate+'&usercode='+UserCode+'&l_strToDate='+l_strToDate+'&l_strCustomerNameCheck='+l_strCustomerNameCheck+'&l_strMotherNameCheck='+l_strMotherNameCheck+'&l_strPermanentAddressLine1Check='+l_strPermanentAddressLine1Check+'&l_strCommAddressLine1Check='+l_strCommAddressLine1Check+'&l_strPanNoCheck='+l_strPanNoCheck+'&l_strPassportNoCheck='+l_strPassportNoCheck+'&l_strDrivingLicenseNoCheck='+l_strDrivingLicenseNoCheck+'&l_strDateOfBirthCheck='+l_strDateOfBirthCheck+'&comments='+comments;
			alert(url);
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
</HEAD>
<body>
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
						<tr>
							<td colspan="2">
								<center>
									<button type="button" class="btn btn-success btn-sm" id="saveMatchComments">Save</button>
								</center>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
		</div>
	</div>
</div>

</body>
