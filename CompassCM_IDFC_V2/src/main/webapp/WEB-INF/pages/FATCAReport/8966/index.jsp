<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" import="java.util.*"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String caseNo = (String) request.getAttribute("caseNo");
String message = request.getAttribute("message") != null ? (String) request.getAttribute("message") : " ";
Map<String, String> formData = request.getAttribute("FORMDATA") != null ? (Map<String, String>) request.getAttribute("FORMDATA") : new HashMap<String, String>();
List<Map<String, String>> individualDetailsList = request.getAttribute("INDIVIDUALDETAILS") != null ? (List<Map<String, String>>) request.getAttribute("INDIVIDUALDETAILS") : new ArrayList<Map<String, String>>();
List<Map<String, String>> accountHolderDetailsList = request.getAttribute("ACCOUNTHOLDERDETAILS") != null ? (List<Map<String, String>>) request.getAttribute("ACCOUNTHOLDERDETAILS") : new ArrayList<Map<String, String>>();

List<String[]> allTitles = request.getAttribute("ALLTITLES") != null ? (List<String[]>) request.getAttribute("ALLTITLES") : new ArrayList<String[]>();
List<String[]> allContries = request.getAttribute("ALLCOUNTRIES") != null ? (List<String[]>) request.getAttribute("ALLCOUNTRIES") : new ArrayList<String[]>();
%>
<style type="text/css">
.customHeaderTable{
	border: 0px;
}
.table{
	margin-bottom: 0px;
}
.borderless > tbody > tr > td, .borderless > tfoot > tr > td{
    border: none;
}
.sectionHeader{
	padding: 1px;
	border-bottom: 1px solid black;
}
.headerLeft{
	padding: 5px 5px;
	float: left;
	position: relative !important;
	width: 60px;
	color: white;
	background: black;
	font-weight: bold;
	border-top-left-radius: 4px;
}
.headerRight{
	padding: 5px 10px;
	position: relative !important;
	font-size: 15px;
	font-weight: bold;
}

.FATCAdatepicker{
	background-image:url("${pageContext.request.contextPath}/includes/images/calendar.png");
	background-repeat:no-repeat;
	background-position: 98%;
}

#fatcaForm input[type="text"]{
	background-color: #DCDCFF;
}
#fatcaForm input[type="text"]:FOCUS{
	background-color: #FFF;
}
#fatcaForm input[type=text].input-ovr, input[type=text].input-ovr1 {
		text-align: justify;
		padding:2px 5px;
		height: 28px;
		width: 22px;
		text-align: center;
		font-size:14px;
		font-weight: normal;
		line-height:1.42857143;
		color:#555;
		border:1px solid #ccc;
		border-radius:4px;
		-webkit-box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		box-shadow:inset 0 1px 1px rgba(0,0,0,.075);
		-webkit-transition:border-color ease-in-out .15s,-webkit-box-shadow ease-in-out .15s;
		-o-transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s;
		transition:border-color ease-in-out .15s,box-shadow ease-in-out .15s
}
</style>
<script type="text/javascript">
	$(document).ready(function(){
		$("button[data-number=2]").click(function(e){
			e.preventDefault();
		    $('#addNewIndividualModal').modal('hide');
		    $('#compassCaseWorkFlowGenericModal').modal('show');
		});
		
		$(".FATCAdatepicker").datepicker({
			 dateFormat : "yy-mm-dd",
			 changeMonth: true,
		     changeYear: true
		 });
		
		$(".input-ovr").keypress(function(evt){
			$(this).val("");
			return true;
		});
		
		$(".input-ovr").keyup(function(evt){
			if(evt.which != 46){
				if(evt.which == 8 || evt.which == 37){
					if(evt.which == 8)
						$(this).val("");
					$(this).prev().focus();
				}else{
					$(this).next().focus();
				}
			}
		});
		
		var icons = {
			header: "ui-icon-circle-arrow-e",
			activeHeader: "ui-icon-circle-arrow-s"
		};
		
		$( "#accordion" ).accordion({
			icons: icons,
			collapsible: true,
			active: false
		});

		$("#generateFATCAPackage").click(function(){
			var mywin = window.open("<%=contextPath%>/common/generateFATCAPackage?caseNo=<%=caseNo%>", 'GENERATE_FATCA_PACKAGE', 'height=800,width=1250,resizable=Yes,scrollbars=Yes');
			mywin.moveTo(5,02);
		});
		
		$(".addNewIndividual").click(function(){
			var caseNo = $("#caseNo").val();
			var action = $(this).attr("action");
			
			if(action == "add"){
				$("#addNewIndividualModal").modal("show");
				$("#modal-title").html("...");
				$("#addNewIndividualDetails").html("Lading...");
				
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/addIndividual?caseNo="+caseNo,
					cache : false,
					success : function(res){
						$("#modal-title").html("Identifying Information of U.S. Owners that are specified U.S. Persons");
						$("#addNewIndividualDetails").html(res);
					},
					error : function(a,b,c){
						$('#addNewIndividualModal').modal('hide');
						alert("Error occured while getting data : "+c);
					}
				});
			}
			
			if(action == "update"){
				$("#addNewIndividualModal").modal("show");
				$("#modal-title").html("...");
				$("#addNewIndividualDetails").html("Lading...");
				var lineno = $(this).attr("lineno");
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/updateIndividual?caseNo="+caseNo+"&lineNo="+lineno,
					cache : false,
					success : function(res){
						$("#modal-title").html("Identifying Information of U.S. Owners that are specified U.S. Persons");
						$("#addNewIndividualDetails").html(res);
					},
					error : function(a,b,c){
						$('#addNewIndividualModal').modal('hide');
						alert("Error occured while getting data : "+c);
					}
				});
			}
			
			if(action == "delete"){
				var lineno = $(this).attr("lineno");
				if (confirm("Are you sure you want to delete?")){
					$.ajax({
						type : "POST",
						url : "<%=contextPath%>/common/deleteIndividual?caseNo="+caseNo+"&lineNo="+lineno,
						cache : false,
						success : function(res){
							if(res == "0"){
								$(".individualDetailsPanel"+lineno).removeClass("individualDetailsPanel");
								$(".individualDetailsPanel"+lineno).hide();
								alert("Individual details deleted");
							}else{
								alert("Error while deleting individual details");
							}
							var count = 0;
							$(".individualDetailsPanel").each(function(){
								count = count+1;
							});
							if(count < 1){
								$("#individualDetailsAllPanel").html("<br/><br/><center><strong>All U.S. Persons has deleted</strong></center><br/><br/>");
							}
						},
						error : function(a,b,c){
							alert("Error occured while deleting : "+c);
						}
					});
				}
			}
		});

		$(".addNewAccountHolder").click(function(){
			var caseNo = $("#caseNo").val();
			var action = $(this).attr("action");
			
			if(action == "add"){
				$("#addNewIndividualModal").modal("show");
				$("#modal-title").html("...");
				$("#addNewIndividualDetails").html("Lading...");
				
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/addFATCAAccountHolder?caseNo="+caseNo,
					cache : false,
					success : function(res){
						$("#modal-title").html("Account Holder or Payee Information & Financial Information");
						$("#addNewIndividualDetails").html(res);
					},
					error : function(a,b,c){
						$('#addNewIndividualModal').modal('hide');
						alert("Error occured while getting data : "+c);
					}
				});
			}
			
			if(action == "update"){
				$("#addNewIndividualModal").modal("show");
				$("#modal-title").html("...");
				$("#addNewIndividualDetails").html("Lading...");
				var lineno = $(this).attr("lineno");
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/updateFATCAAccountHolder?caseNo="+caseNo+"&lineNo="+lineno,
					cache : false,
					success : function(res){
						$("#modal-title").html("Account Holder or Payee Information & Financial Information");
						$("#addNewIndividualDetails").html(res);
					},
					error : function(a,b,c){
						$('#addNewIndividualModal').modal('hide');
						alert("Error occured while getting data : "+c);
					}
				});
			}
			
			if(action == "delete"){
				var lineno = $(this).attr("lineno");
				if (confirm("Are you sure you want to delete?")){
					$.ajax({
						type : "POST",
						url : "<%=contextPath%>/common/deleteFATCAAccountHolder?caseNo="+caseNo+"&lineNo="+lineno,
						cache : false,
						success : function(res){
							if(res == "0"){
								$(".accountHolderDetailsPanel"+lineno).removeClass("accountHolderDetailsPanel");
								$(".accountHolderDetailsPanel"+lineno).hide();
								alert("Account Holder details deleted");
							}else{
								alert("Error while deleting account holder details");
							}
							var count = 0;
							$(".accountHolderDetailsPanel").each(function(){
								count = count+1;
							});
							if(count < 1){
								$("#accountHolderDetailsSection").html("<br/><center><strong>All Account Holders has deleted</strong></center><br/>");
							}
						},
						error : function(a,b,c){
							alert("Error occured while deleting : "+c);
						}
					});
				}
			}
		});

		$(".titleChange").change(function(){
			var targetattr = $(this).attr("targetattr");
			var sourceattr = $(this).attr("sourceattr");
			changeName(sourceattr, targetattr);
		});
		$(".nameChange").keyup(function(){
			var targetattr = $(this).attr("targetattr");
			var sourceattr = $(this).attr("sourceattr");
			changeName(sourceattr, targetattr);
		});
		
		var message = "<%=message%>";
		if(message != " ")
			alert(message);
		
		$("#saveFATCAForm").click(function(){
			var formObj = $("#fatcaForm");
			var formData = $(formObj).serialize();
			var caseNo = $(formObj).find("input#caseNo").val();
			$.ajax({
				url : "<%=contextPath%>/common/saveFATCAForm",
				type : 'POST',
				cache : false,
				data : formData,
				success : function(res){
					alert(res);
				},
				error : function(a,b,c){
					alert("Error occured while saving data : "+c);
				}
			});
		});
		
		$("#exportFATCAForm").click(function(){
			var formObj = $("#fatcaForm");
			var formData = $(formObj).serialize();
			var caseNo = $(formObj).find("input#caseNo").val();
			$.fileDownload('<%=contextPath%>/common/exportFATCAForm?'+formData, {
			    httpMethod : "GET",
				successCallback: function (url) {
			    },
			    failCallback: function (html, url) {
			        alert('Failed to download file'+url+"\n"+html);
			    }
			});
		});
	});
	
	function closeWindow(){
		if(confirm('Are you sure?')){
			window.close();
		}
	}

	function changeName(sourceattr, targetattr){
		var name = "";
		var title = $("#"+sourceattr+"_TITLE").val();
		var firstname = $("#"+sourceattr+"_FIRSTNAME").val();
		var middlename = $("#"+sourceattr+"_MIDDLENAME").val();
		var lastname = $("#"+sourceattr+"_LASTNAME").val();

		if(title != "")
			name = name + title+" ";
		if(firstname != "")
			name = name + firstname+" ";
		if(middlename != "")
			name = name + middlename+" ";
		if(lastname != "")
			name = name + lastname;
		$("#"+targetattr).val(name);
	}
</script>
</head>
<body>
<div class="modal fade bs-example-modal-lg addNewIndividualModal" id="addNewIndividualModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content card-primary">
      <div class="modal-header card-header">
        <button type="button" class="close" data-number="2" data-dismiss="addNewIndividualModal" aria-label="Close">
        <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="modal-title">...</h4>
      </div>
	  <div class="modal-body" id="addNewIndividualDetails">
      	Loading...
      </div>
    </div>
  </div>
</div>
	<div style="width: 100%">
	<form action="<%=contextPath%>/saveOrExportFATCAForm" method="POST" id="fatcaForm">	
	<input type="hidden" name="caseNo" id="caseNo" value="<%=caseNo%>">
	<div class="section" style="padding: 5px 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-primary">
				<div class="card-body">
					<table class="table customHeaderTable" style="text-align: center;">
						<tr>
							<td width="18%" style="border-right: 2px solid black;">
								Form <font style="font-weight: bold; font-size: 30px" face="Helvetica">8966</font>
							</td>
							<td width="65%">
								<font style="font-weight: bold; font-size: 30px" face="ITC Franklin Gothic Std Book">FATCA Report</font>
							</td>
							<td width="17%" style="border-left: 2px solid black;">
								OMB No. 1545-2246
							</td>
						</tr>
						<tr>
							<td style="border-right: 2px solid black; border-bottom: 2px solid black">
								Department of the Treasury Internal Revenue Service
							</td>
							<td style="border-bottom: 2px solid black">
								Information about Form 8966 and its separate instructions is at <a href="javascript:void(0)" onclick="window.open('http://www.irs.gov/form8966')">www.irs.gov/form8966</a>.
							</td>
							<td style="border-left: 2px solid black; border-bottom: 2px solid black">
								<font style="font-weight: bold; font-size: 30px" face="Helvetica">20</font><font style="font-weight: bold; font-size: 30px" face="Helvetica">14</font>
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="3" style="margin-top: 3px; font-size: 16px; font-weight: bold;">
								Check if report is being corrected, amended, or voided
							</td>
						</tr>
						<tr style="text-align: left;">
							<td colspan="2">
								<table width="100%">
									<tr>
										<td width="33%">
											<label for="REPORT_TYPE_FATCA2">
												Corrected report &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
												<input type="checkbox" name="REPORT_TYPE_FATCA2" id="REPORT_TYPE_FATCA2" value="FATCA2"
												<% if("FATCA2".equals(formData.get("REPORT_TYPE_FATCA2"))){ %> checked="checked" <%} %>
												/>
											</label>
										</td>
										<td width="33%">
											<label for="REPORT_TYPE_FATCA4">
												Amended report &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
												<input type="checkbox" id="REPORT_TYPE_FATCA4" name="REPORT_TYPE_FATCA4" value="FATCA4"
												<% if("FATCA4".equals(formData.get("REPORT_TYPE_FATCA4"))){ %> checked="checked" <%} %>/>
											</label>
										</td>
										<td width="33%">
											<label for="REPORT_TYPE_FATCA3">
												Voided report &nbsp; &nbsp;&nbsp;&nbsp;&nbsp;
												<input type="checkbox" id="REPORT_TYPE_FATCA3" name="REPORT_TYPE_FATCA3" value="FATCA3"
												<% if("FATCA3".equals(formData.get("REPORT_TYPE_FATCA3"))){ %> checked="checked" <%} %>/>
											</label>
										</td>
									</tr>
								</table>
							</td>
							<td>
								<button class="btn btn-primary btn-sm" type="button" data-toggle="collapse" data-target="#collapseExample" aria-expanded="false" aria-controls="collapseExample">
									Additional Details
								</button>
							</td>
						</tr>
						<tr class="collapse" id="collapseExample">
							<td colspan="3" style="text-align: left;">							
								<table class="table borderless">
										<tr>
											<td width="50%">
												Message Reference ID
												<br/>
												<input type="text" class="input-sm form-control" id="MESSAGE_REF_ID" name="MESSAGE_REF_ID"
												 value="<%=formData.get("MESSAGE_REF_ID") != null ? formData.get("MESSAGE_REF_ID") : "" %>"/>
											</td>
											<td width="50%">
												Corrected Message Reference ID
												<br/>
												<input type="text" class="input-sm form-control" id="CORR_MESSAGE_REF_ID" name="CORR_MESSAGE_REF_ID"
												 value="<%=formData.get("CORR_MESSAGE_REF_ID") != null ? formData.get("CORR_MESSAGE_REF_ID") : "" %>"/>
											</td>
										</tr>
										<tr>
											<td>
												Document Reference ID
												<br/>
												<input type="text" class="input-sm form-control" id="DOC_REF_ID" name="DOC_REF_ID"
												 value="<%=formData.get("DOC_REF_ID") != null ? formData.get("DOC_REF_ID") : "" %>"/>
											</td>
											<td>
												Corrected Document Reference ID
												<br/>
												<input type="text" class="input-sm form-control" id="CORR_DOC_REF_ID" name="CORR_DOC_REF_ID"
												 value="<%=formData.get("CORR_DOC_REF_ID") != null ? formData.get("CORR_DOC_REF_ID") : "" %>"/>
											</td>
										</tr>
										<tr>
											<td>
												Reporting Period
												<br/>
												<%
													String reportingYear = formData.get("REPORTING_YEAR");
													String currentYear = formData.get("CURRENTYEAR");
													int year = 2014;
													int currYear = 0;
													if(reportingYear != null){
														try{
															year = new Integer(Integer.parseInt(reportingYear)).intValue();
															currYear = new Integer(Integer.parseInt(currentYear)).intValue();
														}catch(Exception e){}
													}
												%>
												<select class="input-sm form-control" id="REPORTING_PERIOD" name="REPORTING_PERIOD">
													<%
														for(int i = (year - 10); i <= year; i++){
													%>
														<option value="<%=i%>" <% if(year == i){ %> selected="selected" <%} %>><%= i %>-12-31</option>
													<% } %>
													<%
														if(currYear > year){
															for(int i = year+1; i <= currYear; i++){
																%>
																<option value="<%=i%>"><%= i %>-12-31</option>
																<%
															}
														}
													%>
												</select>
											</td>
											<td>
												Reporting Timestamp
												<br/>
												<input type="text" class="input-ovr1 FATCAdatepicker" style="width: 200px; text-align: left;" id="REPORTING_TIMESTAMP_DATE" name="REPORTING_TIMESTAMP_DATE" value="<%=formData.get("REPORTING_TIMESTAMP_DATE") != null ? formData.get("REPORTING_TIMESTAMP_DATE") : "" %>"/>
												T
												<input type="text" class="input-ovr1" style="width: 200px; text-align: left;" id="REPORTING_TIMESTAMP_TIME" name="REPORTING_TIMESTAMP_TIME" value="<%=formData.get("REPORTING_TIMESTAMP_TIME") != null ? formData.get("REPORTING_TIMESTAMP_TIME") : "" %>"/>
												Z
											</td>
										</tr>
										<tr>
											<td colspan="2">
												Email ID
												<br/>
												<input type="text" class="input-sm form-control" id="EMAIL_ID" name="EMAIL_ID"
												 value="<%=formData.get("EMAIL_ID") != null ? formData.get("EMAIL_ID") : "" %>"/>
											</td>
										</tr>
									</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
	
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger">
				<div class="sectionHeader">
					<div class="headerLeft">
						Part I
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Identification of Filer
					</div>
				</div>
				<table class="table">
					<tr>
						<td colspan="4">
							1. Name
							<br/>
							<input type="text" class="input-sm form-control" id="IF_NAME" name="IF_NAME"
							value="<%=formData.get("IF_NAME") != null ? formData.get("IF_NAME") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							2. Number, street, and room or suite no. (if P.O. box, see instructions)
							<br/>
							<input type="text" class="input-sm form-control" id="IF_ROOM_STREET" name="IF_ROOM_STREET"
							value="<%=formData.get("IF_ROOM_STREET") != null ? formData.get("IF_ROOM_STREET") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="25%">
							3a. City or town
							<br/>
							<input type="text" class="input-sm form-control" id="IF_CITY" name="IF_CITY"
							value="<%=formData.get("IF_CITY") != null ? formData.get("IF_CITY") : ""%>"/>
						</td>
						<td width="25%">
							3b. State/Province/Region
							<br/>
							<input type="text" class="input-sm form-control" id="IF_STATE" name="IF_STATE"
							value="<%=formData.get("IF_STATE") != null ? formData.get("IF_STATE") : ""%>"/>
						</td>
						<td width="25%">
							3c. Country
							<br/>
							<select class="input-sm form-control" id="IF_COUNTRY" name="IF_COUNTRY">
								<option value=""></option>
								<%
								for(int i = 0; i < allContries.size(); i++){
									String[] country = allContries.get(i);
								%>
								<option value="<%=country[0]%>" <%=country[0].equals(formData.get("IF_COUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
								<%}%>
							</select>
						</td>
						<td width="25%">
							3d. Postal Code
							<br/>
							<input type="text" class="input-sm form-control" id="IF_POSTALCODE" name="IF_POSTALCODE"
							value="<%=formData.get("IF_POSTALCODE") != null ? formData.get("IF_POSTALCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							4. Global Intermediary Identification Number (GIIN)
								<%
								String IF_GIIN = formData.get("IF_GIIN") != null ? formData.get("IF_GIIN") : "";
								%>
								<br/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_1" name="IF_GIIN_1" 
								<% if(IF_GIIN.length() >= 1 && IF_GIIN.charAt(0) != '.'){ %>
									value="<%=IF_GIIN.charAt(0)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_2" name="IF_GIIN_2" 
								<% if(IF_GIIN.length() >= 2 && IF_GIIN.charAt(1) != '.'){ %>
									value="<%=IF_GIIN.charAt(1)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_3" name="IF_GIIN_3" 
								<% if(IF_GIIN.length() >= 3 && IF_GIIN.charAt(2) != '.'){ %>
									value="<%=IF_GIIN.charAt(2)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_4" name="IF_GIIN_4" 
								<% if(IF_GIIN.length() >= 4 && IF_GIIN.charAt(3) != '.'){ %>
									value="<%=IF_GIIN.charAt(3)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_5" name="IF_GIIN_5" 
								<% if(IF_GIIN.length() >= 5 && IF_GIIN.charAt(4) != '.'){ %>
									value="<%=IF_GIIN.charAt(4)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_6" name="IF_GIIN_6" 
								<% if(IF_GIIN.length() >= 6 && IF_GIIN.charAt(5) != '.'){ %>
									value="<%=IF_GIIN.charAt(5)%>"
								<%} %>
								/>
								&nbsp;&nbsp;.&nbsp;&nbsp;
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_7" name="IF_GIIN_7" 
								<% if(IF_GIIN.length() >= 8 && IF_GIIN.charAt(7) != '.'){ %>
									value="<%=IF_GIIN.charAt(7)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_8" name="IF_GIIN_8" 
								<% if(IF_GIIN.length() >= 9 && IF_GIIN.charAt(8) != '.'){ %>
									value="<%=IF_GIIN.charAt(8)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_9" name="IF_GIIN_9" 
								<% if(IF_GIIN.length() >= 10 && IF_GIIN.charAt(9) != '.'){ %>
									value="<%=IF_GIIN.charAt(9)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_10" name="IF_GIIN_10" 
								<% if(IF_GIIN.length() >= 11 && IF_GIIN.charAt(10) != '.'){ %>
									value="<%=IF_GIIN.charAt(10)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_11" name="IF_GIIN_11" 
								<% if(IF_GIIN.length() >= 12 && IF_GIIN.charAt(11) != '.'){ %>
									value="<%=IF_GIIN.charAt(11)%>"
								<%} %>
								/>
								&nbsp;&nbsp;.&nbsp;&nbsp;
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_12" name="IF_GIIN_12" 
								<% if(IF_GIIN.length() >= 14 && IF_GIIN.charAt(13) != '.'){ %>
									value="<%=IF_GIIN.charAt(13)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_13" name="IF_GIIN_13" 
								<% if(IF_GIIN.length() >= 15 && IF_GIIN.charAt(14) != '.'){ %>
									value="<%=IF_GIIN.charAt(14)%>"
								<%} %>
								/>
								&nbsp;&nbsp;.&nbsp;&nbsp;
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_14" name="IF_GIIN_14" 
								<% if(IF_GIIN.length() >= 17 && IF_GIIN.charAt(16) != '.'){ %>
									value="<%=IF_GIIN.charAt(16)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_15" name="IF_GIIN_15" 
								<% if(IF_GIIN.length() >= 18 && IF_GIIN.charAt(17) != '.'){ %>
									value="<%=IF_GIIN.charAt(17)%>"
								<%} %>
								/>
								<input type="text" class="input-sm input-ovr" id="IF_GIIN_16" name="IF_GIIN_16" 
								<% if(IF_GIIN.length() >= 19 && IF_GIIN.charAt(18) != '.'){ %>
									value="<%=IF_GIIN.charAt(18)%>"
								<%} %>
								/>
						</td>
						<td colspan="2">
							5 TIN
							<br/>
							<input type="text" class="input-sm form-control" id="IF_TIN" name="IF_TIN" 
							value="<%=formData.get("IF_TIN") != null ? formData.get("IF_TIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							6 Name of Sponsored Entity or Intermediary, if applicable
							<br/>
							<input type="text" class="input-sm form-control" id="IF_SPNSR_ENTY_NAME" name="IF_SPNSR_ENTY_NAME" 
							value="<%=formData.get("IF_SPNSR_ENTY_NAME") != null ? formData.get("IF_SPNSR_ENTY_NAME") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							7 Number, street, and room or suite no. (if P.O. box, see instructions)	
							<br/>
							<input type="text" class="input-sm form-control"id="IF_SPNSR_ENTY_ROOM_STREET" name="IF_SPNSR_ENTY_ROOM_STREET" 
							value="<%=formData.get("IF_SPNSR_ENTY_ROOM_STREET") != null ? formData.get("IF_SPNSR_ENTY_ROOM_STREET") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="25%">
							8a City or town
							<br/>
							<input type="text" class="input-sm form-control" id="IF_SPNSR_ENTY_CITY" name="IF_SPNSR_ENTY_CITY" 
							value="<%=formData.get("IF_SPNSR_ENTY_CITY") != null ? formData.get("IF_SPNSR_ENTY_CITY") : ""%>"/>
						</td>
						<td width="25%">
							8b State/Province/Region
							<br/>
							<input type="text" class="input-sm form-control" id="IF_SPNSR_ENTY_STATE" name="IF_SPNSR_ENTY_STATE" 
							value="<%=formData.get("IF_SPNSR_ENTY_STATE") != null ? formData.get("IF_SPNSR_ENTY_STATE") : ""%>"/>
						</td>
						<td width="25%">
							8c Country
							<br/>
							<select class="input-sm form-control" id="IF_SPNSR_ENTY_COUNTRY" name="IF_SPNSR_ENTY_COUNTRY">
								<option value=""></option>
								<%
								for(int i = 0; i < allContries.size(); i++){
									String[] country = allContries.get(i);
								%>
								<option value="<%=country[0]%>" <%=country[0].equals(formData.get("IF_SPNSR_ENTY_COUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
								<%}%>
							</select>
						</td>
						<td width="25%">
							8d Postal Code
							<br/>
							<input type="text" class="input-sm form-control" id="IF_SPNSR_ENTY_POSTALCODE" name="IF_SPNSR_ENTY_POSTALCODE" 
							value="<%=formData.get("IF_SPNSR_ENTY_POSTALCODE") != null ? formData.get("IF_SPNSR_ENTY_POSTALCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							9 GIIN
							<%
							String IF_SPNSR_ENTY_GIIN = formData.get("IF_SPNSR_ENTY_GIIN") != null ? formData.get("IF_SPNSR_ENTY_GIIN") : "";
							%>
							<br/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_1" name="IF_SPNSR_ENTY_GIIN_1" 
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 1 && IF_SPNSR_ENTY_GIIN.charAt(0) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(0)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_2" name="IF_SPNSR_ENTY_GIIN_2"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 2 && IF_SPNSR_ENTY_GIIN.charAt(1) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(1)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_3" name="IF_SPNSR_ENTY_GIIN_3"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 3 && IF_SPNSR_ENTY_GIIN.charAt(2) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(2)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_4" name="IF_SPNSR_ENTY_GIIN_4"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 4 && IF_SPNSR_ENTY_GIIN.charAt(3) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(3)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_5" name="IF_SPNSR_ENTY_GIIN_5"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 5 && IF_SPNSR_ENTY_GIIN.charAt(4) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(4)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_6" name="IF_SPNSR_ENTY_GIIN_6"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 6 && IF_SPNSR_ENTY_GIIN.charAt(5) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(5)%>"
							<%} %>
							/>
							&nbsp;&nbsp;.&nbsp;&nbsp;
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_7" name="IF_SPNSR_ENTY_GIIN_7"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 8 && IF_SPNSR_ENTY_GIIN.charAt(7) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(7)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_8" name="IF_SPNSR_ENTY_GIIN_8"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 9 && IF_SPNSR_ENTY_GIIN.charAt(8) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(8)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_9" name="IF_SPNSR_ENTY_GIIN_9"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 10 && IF_SPNSR_ENTY_GIIN.charAt(9) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(9)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_10" name="IF_SPNSR_ENTY_GIIN_10"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 11 && IF_SPNSR_ENTY_GIIN.charAt(10) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(10)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_11" name="IF_SPNSR_ENTY_GIIN_11"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 12 && IF_SPNSR_ENTY_GIIN.charAt(11) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(11)%>"
							<%} %>
							/>
							&nbsp;&nbsp;.&nbsp;&nbsp;
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_12" name="IF_SPNSR_ENTY_GIIN_12"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 14 && IF_SPNSR_ENTY_GIIN.charAt(13) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(13)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_13" name="IF_SPNSR_ENTY_GIIN_13"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 15 && IF_SPNSR_ENTY_GIIN.charAt(14) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(14)%>"
							<%} %>
							/>
							&nbsp;&nbsp;.&nbsp;&nbsp;
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_14" name="IF_SPNSR_ENTY_GIIN_14"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 17 && IF_SPNSR_ENTY_GIIN.charAt(16) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(16)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_15" name="IF_SPNSR_ENTY_GIIN_15"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 18 && IF_SPNSR_ENTY_GIIN.charAt(17) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(17)%>"
							<%} %>
							/>
							<input type="text" class="input-sm input-ovr" id="IF_SPNSR_ENTY_GIIN_16" name="IF_SPNSR_ENTY_GIIN_16"  
							<% if(IF_SPNSR_ENTY_GIIN.length() >= 19 && IF_SPNSR_ENTY_GIIN.charAt(18) != '.'){ %>
								value="<%=IF_SPNSR_ENTY_GIIN.charAt(18)%>"
							<%} %>
							/>
						</td>
						<td colspan="2">
							10 TIN
							<br/>
							<input type="text" class="input-sm form-control" id="IF_SPNSR_ENTY_TIN" name="IF_SPNSR_ENTY_TIN" 
							value="<%=formData.get("IF_SPNSR_ENTY_TIN") != null ? formData.get("IF_SPNSR_ENTY_TIN") : ""%>"/>
						</td>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</div>
	
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger">
				<div class="sectionHeader">
					<div class="headerLeft">
						Part II
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Account Holder or Payee Information
						<div style="float: right; margin-top: -4px;">
							<button type="button" class="btn btn-primary btn-sm addNewAccountHolder" action="add">Add New Account Holder</button>
						</div>
					</div>
				</div>
				<div id="accountHolderDetailsSection">
				</div>
				<% if(accountHolderDetailsList.size() > 0){
						for(int i = 0; i < accountHolderDetailsList.size(); i++){
							Map<String, String> accountHolder = accountHolderDetailsList.get(i);
					%>
				<div class="card card-success accountHolderDetailsPanel accountHolderDetailsPanel<%=accountHolder.get("LINENO")%>" style="margin-top: 2px; border: 1px green solid;">
				<table class="table">
					<tr>
						<td colspan="4">
							<table class="table">
								<tr>
									<td width="15%">
										Title
										<select name="ACC_HLDR_TITLE" id="ACC_HLDR_TITLE" class="form-control input-sm titleChange" targetattr="ACC_HLDR_NAME" sourceattr="ACC_HLDR" disabled="disabled">
											<option value=""></option>
											<%
											for(int j = 0; j < allTitles.size(); j++){
												String[] title = allTitles.get(j);
											%>
												<option value="<%=title[0]%>" <%=title[0].equals(accountHolder.get("II_TITLE")) ? "selected='selected'" : ""%> > <%=title[1]%> </option>
											<%}%>
										</select>
									</td>
									<td width="28%">
										First Name
										<br/>
										<input type="text" class="input-sm form-control nameChange" id="ACC_HLDR_FIRSTNAME" targetattr="ACC_HLDR_NAME"  sourceattr="ACC_HLDR" name="ACC_HLDR_FIRSTNAME"
										readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_FIRSTNAME") != null ? accountHolder.get("ACC_HLDR_FIRSTNAME") : ""%>"/>
									</td>
									<td width="28%">
										Middle Name
										<br/>
										<input type="text" class="input-sm form-control nameChange" id="ACC_HLDR_MIDDLENAME" targetattr="ACC_HLDR_NAME"  sourceattr="ACC_HLDR" name="ACC_HLDR_MIDDLENAME"
										readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_MIDDLENAME") != null ? accountHolder.get("ACC_HLDR_MIDDLENAME") : ""%>"/>
									</td>
									<td width="29%">
										Last Name
										<br/>
										<input type="text" class="input-sm form-control nameChange" id="ACC_HLDR_LASTNAME" targetattr="ACC_HLDR_NAME"  sourceattr="ACC_HLDR" name="ACC_HLDR_LASTNAME"
										readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_LASTNAME") != null ? accountHolder.get("ACC_HLDR_LASTNAME") : ""%>"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							1 Name of Account Holder or Payee
							<br/>
							<div class="input-group" style="width: 100%">
								<input type="text" class="input-sm form-control" id="ACC_HLDR_NAME" name="ACC_HLDR_NAME" 
								readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_NAME") != null ? accountHolder.get("ACC_HLDR_NAME") : ""%>"/>
								<span class="input-group-btn">
									<button type="button" class="btn btn-success btn-sm addNewAccountHolder" action="update" lineno="<%=accountHolder.get("LINENO")%>">Update</button>
									<button type="button" class="btn btn-danger btn-sm addNewAccountHolder" action="delete" lineno="<%=accountHolder.get("LINENO")%>">Delete</button>
								</span>
							</div>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							2 Number, street, and room or suite no. (if P.O. box, see instructions)
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_ROOM_STREET" name="ACC_HLDR_ROOM_STREET" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_ROOM_STREET") != null ? accountHolder.get("ACC_HLDR_ROOM_STREET") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td width="25%">
							3a City or town
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_CITY" name="ACC_HLDR_CITY" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_CITY") != null ? accountHolder.get("ACC_HLDR_CITY") : ""%>"/>
						</td>
						<td width="25%">
							3b State/Province/Region
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_STATE" name="ACC_HLDR_STATE" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_STATE") != null ? accountHolder.get("ACC_HLDR_STATE") : ""%>"/>
						</td>
						<td width="25%">
							3c Country
							<br/>
							<select class="input-sm form-control" id="ACC_HLDR_COUNTRY" name="ACC_HLDR_COUNTRY" disabled="disabled">
								<option value=""></option>
								<%
									for(int j = 0; j < allContries.size(); j++){
										String[] country = allContries.get(j);
									%>
									<option value="<%=country[0]%>" <%=country[0].equals(accountHolder.get("ACC_HLDR_COUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
								<%}%>
							</select>
						</td>
						<td width="25%">
							3d Postal Code
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_POSTALCODE" name="ACC_HLDR_POSTALCODE" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_POSTALCODE") != null ? accountHolder.get("ACC_HLDR_POSTALCODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							4 Nationality
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_NATIONALITY" name="ACC_HLDR_NATIONALITY" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_NATIONALITY") != null ? accountHolder.get("ACC_HLDR_NATIONALITY") : ""%>"/>
						</td>
						<td colspan="2">
							5 TIN
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_TIN" name="ACC_HLDR_TIN" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_TIN") != null ? accountHolder.get("ACC_HLDR_TIN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td>
							6a Date of Birth
							<br/>
							<input type="text" class="input-sm form-control FATCAdatepicker" id="ACC_HLDR_DOB" name="ACC_HLDR_DOB" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_DOB") != null ? accountHolder.get("ACC_HLDR_DOB") : ""%>"/>
						</td>
						<td>
							6b Birth City
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_BIRTHCITY" name="ACC_HLDR_BIRTHCITY" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_BIRTHCITY") != null ? accountHolder.get("ACC_HLDR_BIRTHCITY") : ""%>"/>
						</td>
						<td>
							6c Birth Country
							<br/>
							<select class="input-sm form-control" class="input-sm form-control" id="ACC_HLDR_BIRTHCOUNTRY" disabled="disabled">
								<option value=""></option>
								<%
									for(int j = 0; j < allContries.size(); j++){
										String[] country = allContries.get(j);
									%>
									<option value="<%=country[0]%>" <%=country[0].equals(accountHolder.get("ACC_HLDR_BIRTHCOUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
								<%}%>
							</select>
						</td>
						<td>
							6d Formar Country Name
							<br/>
							<input type="text" class="input-sm form-control" id="ACC_HLDR_BIRTHFORMARCOUNTRY" name="ACC_HLDR_BIRTHFORMARCOUNTRY" 
							readonly="readonly" value="<%=accountHolder.get("ACC_HLDR_BIRTHFORMARCOUNTRY") != null ? accountHolder.get("ACC_HLDR_BIRTHFORMARCOUNTRY") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="4">
							5 If account holder or payee is an entity, check applicable box to specify the entity's type:
							<br/>
							<table width="100%">
								<tr>
									<td width="50%">
										<label for="ACC_HLDR_OWNR_DOC_FFI">
											<input type="checkbox" id="ACC_HLDR_OWNR_DOC_FFI" name="ACC_HLDR_OWNR_DOC_FFI" value="FATCA101" disabled="disabled"
											<% if("FATCA101".equals(accountHolder.get("ACC_HLDR_OWNR_DOC_FFI"))){ %> checked="checked" <%} %>
											/>
											Owner-Documented FFI with specified U.S. owner(s)
										</label>
									</td>
									<td width="50%">
										<label for="ACC_HLDR_PSSV_NFFE">
											<input type="checkbox" id="ACC_HLDR_PSSV_NFFE" name="ACC_HLDR_PSSV_NFFE" value="FATCA102" disabled="disabled"
											<% if("FATCA102".equals(accountHolder.get("ACC_HLDR_PSSV_NFFE"))){ %> checked="checked" <%} %>
											/>
											Passive NFFE with substantial U.S. owner(s)
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<label for="ACC_HLDR_NONPRTCIPTING_FFI">
											<input type="checkbox" id="ACC_HLDR_NONPRTCIPTING_FFI" name="ACC_HLDR_NONPRTCIPTING_FFI" value="FATCA103" disabled="disabled"
											<% if("FATCA103".equals(accountHolder.get("ACC_HLDR_NONPRTCIPTING_FFI"))){ %> checked="checked" <%} %>
											/>
											Non-Participating FFI
										</label>
									</td>
									<td>
										<label for="ACC_HLDR_US_PERSON">
											<input type="checkbox" id="ACC_HLDR_US_PERSON" name="ACC_HLDR_US_PERSON" value="FATCA104" disabled="disabled"
											<% if("FATCA104".equals(accountHolder.get("ACC_HLDR_US_PERSON"))){ %> checked="checked" <%} %>
											/>
											Specified U.S. Person
										</label>
									</td>
								</tr>
								<tr>
									<td colspan="2">
										<label for="ACC_HLDR_DRCT_REPORTING">
											<input type="checkbox" id="ACC_HLDR_DRCT_REPORTING" name="ACC_HLDR_DRCT_REPORTING" value="FATCA105" disabled="disabled"
											<% if("FATCA105".equals(accountHolder.get("ACC_HLDR_DRCT_REPORTING"))){ %> checked="checked" <%} %>
											/>
											Direct Reporting NFFE
										</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				</div>
					<%
						}
					} else {%>
					<center>
						<br/>
						No Account Holder Details Added
						<br/>
						<br/>
					</center>
					<%} %>
			</div>
		</div>
	</div>
	
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger">
				<div class="sectionHeader">
					<div class="headerLeft">
						Part III
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Identifying Information of U.S. Owners that are specified U.S. Persons
						<div style="float: right; margin-top: -4px;">
							<button type="button" class="btn btn-primary btn-sm addNewIndividual" action="add">Add New Individual</button>
						</div>
					</div>
				</div>
				<div id="individualDetailsAllPanel">
				<% if(individualDetailsList.size() > 0){
					for(int i = 0; i < individualDetailsList.size(); i++){
						Map<String, String> individualDetailsMap =  individualDetailsList.get(i);
				%>
				<div class="card card-success individualDetailsPanel individualDetailsPanel<%=individualDetailsMap.get("LINENO")%>" style="margin-top: 2px; border: 1px green solid;">
					<table class="table">						
						<tr>
							<td colspan="4">
								Account Number
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_ACCOUNTNUMBER" name="II<%=i%>_ACCOUNTNUMBER" readonly="readonly" 
								value="<%=individualDetailsMap.get("FI_ACCOUNTNUMBER") != null ? individualDetailsMap.get("FI_ACCOUNTNUMBER") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								1 Name of Owner
								<br/>
								<div class="input-group"  style="width: 100%">
									<input type="text" class="input-sm form-control" id="II<%=i%>_NAME" name="II<%=i%>_NAME" readonly="readonly"
									value="<%=individualDetailsMap.get("II_NAME") != null ? individualDetailsMap.get("II_NAME") : ""%>"/>
									<span class="input-group-btn">
										<button type="button" class="btn btn-success btn-sm addNewIndividual" action="update" lineno="<%=individualDetailsMap.get("LINENO")%>">Update</button>
										<button type="button" class="btn btn-danger btn-sm addNewIndividual" action="delete" lineno="<%=individualDetailsMap.get("LINENO")%>">Delete</button>
									</span>
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="4">
								2 Number, street, and room or suite no. (if P.O. box, see instructions)
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_ROOM_STREET" name="II<%=i%>_ROOM_STREET" readonly="readonly" 
								value="<%=individualDetailsMap.get("II_ROOM_STREET") != null ? individualDetailsMap.get("II_ROOM_STREET") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td width="25%">
								3a. City or town
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_CITY" name="II<%=i%>_CITY" readonly="readonly" 
								value="<%=individualDetailsMap.get("II_CITY") != null ? individualDetailsMap.get("II_CITY") : ""%>"/>
							</td>
							<td width="25%">
								3b. State/Province/Region
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_STATE" name="II<%=i%>_STATE" readonly="readonly" 
								value="<%=individualDetailsMap.get("II_STATE") != null ? individualDetailsMap.get("II_STATE") : ""%>"/>
							</td>
							<td width="25%">
								3c. Country
								<br/>
								<select class="input-sm form-control" id="II<%=i%>_COUNTRY" name="II<%=i%>_COUNTRY" disabled="disabled">
									<option value=""></option>
									<%
										for(int j = 0; j < allContries.size(); j++){
											String[] country = allContries.get(j);
										%>
										<option value="<%=country[0]%>" <%=country[0].equals(individualDetailsMap.get("II_COUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
									<%}%>
								</select>
							</td>
							<td width="25%">
								3d. Postal Code
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_POSTALCODE" name="II<%=i%>_POSTALCODE" readonly="readonly" 
								value="<%=individualDetailsMap.get("II_POSTALCODE") != null ? individualDetailsMap.get("II_POSTALCODE") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td colspan="2">
								4 Nationality
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_NATOINALITY" name="II<%=i%>_NATOINALITY" readonly="readonly" 
								value="<%=individualDetailsMap.get("II_NATOINALITY") != null ? individualDetailsMap.get("II_NATOINALITY") : ""%>"/>
							</td>
							<td colspan="2">
								5 TIN of Owner
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_TIN" name="II<%=i%>_TIN" readonly="readonly" 
								value="<%=individualDetailsMap.get("II_TIN") != null ? individualDetailsMap.get("II_TIN") : ""%>"/>
							</td>
						</tr>
						<tr>
							<td>
								6a. Date of Birth
								<br/>
								<input type="text" class="input-sm form-control FATCAdatepicker" id="II<%=i%>_DOB" name="II<%=i%>_DOB" readonly="readonly" 
								value="<%= individualDetailsMap.get("II_DOB") != null ? individualDetailsMap.get("II_DOB") : "" %>" />
							</td>
							<td>
								6b. Birth City
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_BIRTHCITY" name="II<%=i%>_BIRTHCITY" readonly="readonly" 
								value="<%= individualDetailsMap.get("II_BIRTHCITY") != null ? individualDetailsMap.get("II_BIRTHCITY") : "" %>" />
							</td>
							<td>
								6c. Birth Country
								<br/>
								<select class="input-sm form-control" id="II<%=i%>_BIRTHCOUNTRY" name="II<%=i%>_BIRTHCOUNTRY" disabled="disabled">
									<option value=""></option>
									<%
										for(int j = 0; j < allContries.size(); j++){
											String[] country = allContries.get(j);
										%>
										<option value="<%=country[0]%>" <%=country[0].equals(individualDetailsMap.get("II_BIRTHCOUNTRY")) ? "selected='selected'" : ""%> > <%=country[1]%> </option>
									<%}%>
								</select>
							</td>
							<td>
								6d. Formar Country Name
								<br/>
								<input type="text" class="input-sm form-control" id="II<%=i%>_BIRTHFORMARCOUNTRY" name="II<%=i%>_BIRTHFORMARCOUNTRY" 
								value="<%= individualDetailsMap.get("II_BIRTHFORMARCOUNTRY") != null ? individualDetailsMap.get("II_BIRTHFORMARCOUNTRY") : "" %>" />
							</td>
						</tr>
					</table>
				</div>
				<% 
					}
					}else{ %>
					<br/><br/><center><strong>No U.S. Persons has been added yet</strong></center><br/><br/>
				<% } %>
				</div>
			</div>
		</div>
	</div>
	
	<div class="section" style="padding: 0 7.5% 0 7.5%;">
		<div class="col-lg-12">
			<div class="card card-danger">
				<div class="sectionHeader">
					<div class="headerLeft">
						Part IV
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Financial Information
					</div>
				</div>
				<% if(accountHolderDetailsList.size() > 0){
						for(int i = 0; i < accountHolderDetailsList.size(); i++){
							Map<String, String> accountHolder = accountHolderDetailsList.get(i);
					%>
				<div class="card card-success accountHolderDetailsPanel accountHolderDetailsPanel<%=accountHolder.get("LINENO")%>" style="margin-top: 2px; border: 1px green solid;">
				
				<table class="table">
					<tr>
						<td>
							1 Account Number
							<br/>
							<input type="text" class="input-sm form-control" id="FI_ACCOUNT_NO" name="FI_ACCOUNT_NO"  
							value="<%=accountHolder.get("FI_ACCOUNT_NO") != null ? accountHolder.get("FI_ACCOUNT_NO") : ""%>"/>
						</td>
						<td>
							2 Currency Code
							<br/>
							<input type="text" class="input-sm form-control" id="FI_CURRENCY_CODE" name="FI_CURRENCY_CODE"  
							value="<%=accountHolder.get("FI_CURRENCY_CODE") != null ? accountHolder.get("FI_CURRENCY_CODE") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td colspan="2">
							3 Account Balance
							<br/>
							<input type="text" class="input-sm form-control" id="FI_ACCOUNT_BAL" name="FI_ACCOUNT_BAL"  
							value="<%=accountHolder.get("FI_ACCOUNT_BAL") != null ? accountHolder.get("FI_ACCOUNT_BAL") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td>
							4a Interest
							<br/>
							<input type="text" class="input-sm form-control" id="FI_INTEREST" name="FI_INTEREST"  
							value="<%=accountHolder.get("FI_INTEREST") != null ? accountHolder.get("FI_INTEREST") : ""%>"/>
						</td>
						<td>
							4c Gross proceeds/Redemptions
							<br/>
							<input type="text" class="input-sm form-control" id="FI_GROSS_PRCD_RDMPTN" name="FI_GROSS_PRCD_RDMPTN"  
							value="<%=accountHolder.get("FI_GROSS_PRCD_RDMPTN") != null ? accountHolder.get("FI_GROSS_PRCD_RDMPTN") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td>
							4b Dividends
							<br/>
							<input type="text" class="input-sm form-control" id="FI_DIVIDENTS" name="FI_DIVIDENTS"  
							value="<%=accountHolder.get("FI_DIVIDENTS") != null ? accountHolder.get("FI_DIVIDENTS") : ""%>"/>
						</td>
						<td>
							4d Other
							<br/>
							<input type="text" class="input-sm form-control" id="FI_OTHERS" name="FI_OTHERS"  
							value="<%=accountHolder.get("FI_OTHERS") != null ? accountHolder.get("FI_OTHERS") : ""%>"/>
						</td>
					</tr>
				</table>
				</div>
				<%	}
				}
				%>
			</div>
		</div>
	</div>
	
	<div class="section" style="padding: 0 7.5% 0 7.5%;" id="partVSection">
		<div class="col-lg-12">
			<div class="card card-danger">
				<div class="sectionHeader">
					<div class="headerLeft">
						Part V
					</div>
					<div class="headerRight">
						&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Pooled Reporting Type
					</div>
				</div>
				<table class="table">
					<tr>
						<td colspan="2">
							1 Check applicable Pooled Reporting Type (check only one):
							<br/>
							<table width="100%">
								<tr>
									<td width="50%">
										<label for="PRT_POOL_REPORT_TYPE_FATCA201">
											<input type="radio" id="PRT_POOL_REPORT_TYPE_FATCA201" name="PRT_POOL_REPORT_TYPE" value="FATCA201"
											<% if("FATCA201".equals(formData.get("PRT_POOL_REPORT_TYPE"))){ %> checked="checked" <%} %>
											/>
											Recalcitrant account holders with U.S. Indicia
										</label>
									</td>
									<td width="50%">
										<label for="PRT_POOL_REPORT_TYPE_FATCA202">
											<input type="radio" id="PRT_POOL_REPORT_TYPE_FATCA202" name="PRT_POOL_REPORT_TYPE" value="FATCA202"
											<% if("FATCA202".equals(formData.get("PRT_POOL_REPORT_TYPE"))){ %> checked="checked" <%} %>
											/>
											Recalcitrant account holders without U.S. Indicia
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<label for="PRT_POOL_REPORT_TYPE_FATCA203">
											<input type="radio" id="PRT_POOL_REPORT_TYPE_FATCA203" name="PRT_POOL_REPORT_TYPE" value="FATCA203"
											<% if("FATCA203".equals(formData.get("PRT_POOL_REPORT_TYPE"))){ %> checked="checked" <%} %>
											/>
											Dormant Accounts
										</label>
									</td>
									<td>
										<label for="PRT_POOL_REPORT_TYPE_FATCA204">
											<input type="radio" id="PRT_POOL_REPORT_TYPE_FATCA204" name="PRT_POOL_REPORT_TYPE" value="FATCA204"
											<% if("FATCA204".equals(formData.get("PRT_POOL_REPORT_TYPE"))){ %> checked="checked" <%} %>
											/>
											Non-participating FFI
										</label>
									</td>
								</tr>
								<tr>
									<td>
										<label for="PRT_POOL_REPORT_TYPE_FATCA205">
											<input type="radio" id="PRT_POOL_REPORT_TYPE_FATCA205" name="PRT_POOL_REPORT_TYPE" value="FATCA205"
											<% if("FATCA205".equals(formData.get("PRT_POOL_REPORT_TYPE"))){ %> checked="checked" <%} %>
											/>
											Recalcitrant account holders that are U.S. persons
										</label>
									</td>
									<td>
										<label for="PRT_POOL_REPORT_TYPE_FATCA206">
											<input type="radio" id="PRT_POOL_REPORT_TYPE_FATCA206" name="PRT_POOL_REPORT_TYPE" value="FATCA206"
											<% if("FATCA206".equals(formData.get("PRT_POOL_REPORT_TYPE"))){ %> checked="checked" <%} %>
											/>
											Recalcitrant account holders that are passive NFFEs
										</label>
									</td>
								</tr>
							</table>
						</td>
					</tr>
					<tr>
						<td>
							2 Number of Accounts
							<br/>
							<input type="text" class="input-sm form-control" id="PRT_ACCOUNT_NO" name="PRT_ACCOUNT_NO"  
							value="<%=formData.get("PRT_ACCOUNT_NO") != null ? formData.get("PRT_ACCOUNT_NO") : ""%>"/>
						</td>
						<td>
							3 Aggregate payment amount
							<br/>
							<input type="text" class="input-sm form-control" id="PRT_AGGR_PAYMNT_AMNT" name="PRT_AGGR_PAYMNT_AMNT"  
							value="<%=formData.get("PRT_AGGR_PAYMNT_AMNT") != null ? formData.get("PRT_AGGR_PAYMNT_AMNT") : ""%>"/>
						</td>
					</tr>
					<tr>
						<td>
							4 Aggregate account balance
							<br/>
							<input type="text" class="input-sm form-control" id="PRT_AGGR_ACCOUNT_BAL" name="PRT_AGGR_ACCOUNT_BAL"  
							value="<%=formData.get("PRT_AGGR_ACCOUNT_BAL") != null ? formData.get("PRT_AGGR_ACCOUNT_BAL") : ""%>"/>
						</td>
						<td>
							5 Currency Code
							<br/>
							<input type="text" class="input-sm form-control" id="PRT_CURRENCY_CODE" name="PRT_CURRENCY_CODE"  
							value="<%=formData.get("PRT_CURRENCY_CODE") != null ? formData.get("PRT_CURRENCY_CODE") : ""%>"/>
						</td>
					</tr>
				</table>
			</div>
			<div style="width: 100%; text-align: right; border-top: 2px solid black;">Form 8966 (2014)</div>
		</div>
	</div>
	<div class="section" style="padding: 15px 7.5% 0 7.5%; text-align: center;">
		<div class="col-lg-12">
			<div class="card card-danger" style="padding: 5px 0;">
				<button class="btn btn-primary btn-sm" type="button" id="saveFATCAForm">Save</button>
				<button class="btn btn-success btn-sm" type="button" id="exportFATCAForm">Export XML</button>
				<button class="btn btn-info btn-sm" type="button" id="generateFATCAPackage" onclick="generateFATCAPackage()">Generate FATCA Package</button>
			</div>
		</div>
	</div>
	</form>
	</div>
</body>
</html>