<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="java.util.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="../../tags/tags.jsp"%>
<%@ include file="../../tags/staticFiles.jsp"%>
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
String caseNo = (String) request.getAttribute("CASENO");
Map<String, String> statement = (Map<String, String>) request.getAttribute("STATEMENTDETAILS");
List<Map<String, Object>> report = (List<Map<String, Object>>) request.getAttribute("REPORTDETAILS");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<link rel="stylesheet" href="${pageContext.request.contextPath}/includes/styles/indFATCA.css">
		<script type="text/javascript">
			$(document).ready(function(){
				$(".input-ovr").keypress(function(evt){
					$(this).val("");
					return true;
				});
				
				$(".input-ovr").keyup(function(evt){
					if(evt.which != 46){
						if(evt.which == 8 || evt.which == 37){
							if(evt.which == 8)
								$(this).val("");
							else
								$(this).prev().focus();
						}else{
							$(this).next().focus();
						}
					}
				});
			});
			
			function closeModal(){
				$("#fatcaModal").modal('hide');
			}
			
			function addUpdateAccount(caseNo, action, accountNo){
				$("#fatcaModal").modal('show');
				$("#fatcaModalTitle").html(action+" account for case no : "+caseNo);
				$("#fatcaModalBody").html("<br/><center>Loading...</center><br/>");
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/addUpdateINDFATCAAccount?caseNo="+caseNo+"&action="+action+"&accountNo="+accountNo,
					cache : false,
					success : function(res){
						$("#fatcaModalBody").html(res);
					},
					error : function(a,b,c){
						alert("Error while process. "+c);
					}
				});
			}
			
			function deleteAccount(caseNo, accountNo, elm){
				$(elm).html("Deleting...");
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/deleteINDFATCAAccount?caseNo="+caseNo+"&accountNo="+accountNo,
					cache : false,
					success : function(res){
						$(elm).removeClass("btn-danger").addClass("btn-default");
						$(elm).html("Deleted");
						window.location.reload();
					},
					error : function(a,b,c){
						alert("Error while deleting . "+c);
					}
				});
			}
			
			function addUpdateIndividualEntityControllingPerson(caseNo, accountNo, type, typeId){
				$("#fatcaModal").modal('show');
				$("#fatcaModalTitle").html(type+" for account no : "+accountNo);
				$("#fatcaModalBody").html("<br/><center>Loading...</center><br/>");
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/addUpdateIndividualEntityControllingPerson?caseNo="+caseNo+"&accountNo="+accountNo+"&type="+type+"&typeId="+typeId,
					cache : false,
					success : function(res){
						$("#fatcaModalBody").html(res);
					},
					error : function(a,b,c){
						alert("Error while process. "+c);
					}
				});
			}
			
			function deleteIndividualEntityControllingPerson(caseNo, accountNo, type, typeId, elm){
				$(elm).html("Deleting...");
				$.ajax({
					type : "POST",
					url : "<%=contextPath%>/common/deleteIndividualEntityControllingPerson?caseNo="+caseNo+"&accountNo="+accountNo+"&type="+type+"&typeId="+typeId,
					cache : false,
					success : function(res){
						$(elm).removeClass("btn-danger").addClass("btn-default");
						$(elm).html("Deleted");
						window.location.reload();
					},
					error : function(a,b,c){
						alert("Error while deleting . "+c);
					}
				});
			}

			function generateAndDownloadINDFATCAXML(caseNo){
				window.open("<%=contextPath%>/common/generateAndDownloadINDFATCAXML?caseNo="+caseNo,'FATCAXML','width=200px,height=50px');
			}
		</script>
		<style type="text/css">
			.table-header{
				font-size: 20px;
				font-weight: bold;
				color: white;
				background: black;
			}
						
			.input-ovr{
				text-align: justify;
				padding:2px 5px;
				height: 28px;
				width: 30px;
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
	</head>
	<body>
		<div class="modal fade" id="fatcaModal" tabindex="-1" role="dialog" aria-labelledby="fatcaModalLabel">
		  <div class="modal-dialog modal-lg" role="document">
		    <div class="modal-content">
		      <div class="modal-header">
		        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
		        <h4 class="modal-title" id="fatcaModalTitle">...</h4>
		      </div>
		      <div class="modal-body" id="fatcaModalBody">
		        ...
		      </div>
		    </div>
		  </div>
		</div>
		<div style="padding: 5px 15%;">
			<div style="text-align: center;">
				<span style="font-size: 20px; font-weight: bold;">FORM NO. 61B</span><br/>
				<span>[See sub-rule (8) of rule 114G]</span><br/>
				<span style="font-size: 20px; font-weight: bold;">
					Statement of Reportable Account under sub-section (1) section 285BA of the Income-tax Act, 1961
				</span><br/>
				<span>(see instructions for guidance)</span><br/><br/>
				<span style="font-size: 20px; font-weight: bold;">
					PART A: STATEMENT DETAILS
				</span><br/>
				<span>
					(This information should be provided for each Statement of Reports submitted together)
				</span>
			</div>
			<form action="<%=contextPath%>/common/saveINDFATCAStatementDetails?${_csrf.parameterName}=${_csrf.token}" method="POST">
			<input type="hidden" name="CASENO" value="<%=caseNo%>">
			<table class="table table-bordered">
				<tr class="table-header">
					<td width="10%">A.1</td>
					<td  width="90%" colspan="2">
						REPORTING ENTITY DETAILS
					</td>
				</tr>
				<tr>
					<td width="10%">A.1.1</td>
					<td width="30%">Reporting Entity Name</td>
					<td width="60%">
						<input type="text" class="form-control input-sm" name="REPORTINGENTITYNAME" value="<%= statement.get("REPORTINGENTITYNAME") != null ? statement.get("REPORTINGENTITYNAME") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.1.2</td>
					<td>ITDREIN</td>
					<td>
						<% 
							String itdrein = statement.get("ITDREIN");
							String itdrein1 = "", itdrein2 = "", itdrein3 = "", itdrein4 = "", itdrein5 = "", itdrein6 = "", itdrein7 = "", itdrein8 = "", itdrein9 = "", itdrein10 = "", itdrein11 = "", itdrein12 = "", itdrein13 = "", itdrein14 = "", itdrein15 = "", itdrein16 = "";
							if(itdrein != null && itdrein.length() == 16){
								itdrein1 = String.valueOf(itdrein.charAt(0)); itdrein2 = String.valueOf(itdrein.charAt(1)); itdrein3 = String.valueOf(itdrein.charAt(2)); itdrein4 = String.valueOf(itdrein.charAt(3));
								itdrein5 = String.valueOf(itdrein.charAt(4)); itdrein6 = String.valueOf(itdrein.charAt(5)); itdrein7 = String.valueOf(itdrein.charAt(6)); itdrein8 = String.valueOf(itdrein.charAt(7));
								itdrein9 = String.valueOf(itdrein.charAt(8)); itdrein10 = String.valueOf(itdrein.charAt(9)); itdrein11 = String.valueOf(itdrein.charAt(10)); itdrein12 = String.valueOf(itdrein.charAt(11));
								itdrein13 = String.valueOf(itdrein.charAt(12)); itdrein14 = String.valueOf(itdrein.charAt(13)); itdrein15 = String.valueOf(itdrein.charAt(14)); itdrein16 = String.valueOf(itdrein.charAt(15));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="ITDREIN1" value="<%=itdrein1%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN2" value="<%=itdrein2%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN3" value="<%=itdrein3%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN4" value="<%=itdrein4%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN5" value="<%=itdrein5%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN6" value="<%=itdrein6%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN7" value="<%=itdrein7%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN8" value="<%=itdrein8%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN9" value="<%=itdrein9%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN10" value="<%=itdrein10%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN11" value="<%=itdrein11%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN12" value="<%=itdrein12%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN13" value="<%=itdrein13%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN14" value="<%=itdrein14%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN15" value="<%=itdrein15%>"/>
						<input type="text" class="input-sm input-ovr" name="ITDREIN16" value="<%=itdrein16%>"/>
					</td>
				</tr>
				<tr>
					<td>A.1.3</td>
					<td>Global Intermediary Identification Number (GIIN)</td>
					<td>
						<input type="text" class="form-control input-sm" name="GIIN" value="<%= statement.get("GIIN") != null ? statement.get("GIIN") : "" %>">
					</td>
				</tr>
				<tr>
					<td>A.1.4</td>
					<td>Registration Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="REGNO" value="<%= statement.get("REGNO") != null ? statement.get("REGNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>A.1.5</td>
					<td>Reporting Entity Category</td>
					<td>
						<% 
							String reportingEntityCat = statement.get("REPORTINGENTITYCAT");
							String reportingEntityCat1 = "", reportingEntityCat2 = "";
							if(reportingEntityCat != null && reportingEntityCat.length() == 2){
								reportingEntityCat1 = String.valueOf(reportingEntityCat.charAt(0));
								reportingEntityCat2 = String.valueOf(reportingEntityCat.charAt(1));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="REPORTINGENTITYCAT1" value="<%=reportingEntityCat1%>"/>
						<input type="text" class="input-sm input-ovr" name="REPORTINGENTITYCAT2" value="<%=reportingEntityCat2%>"/>
					</td>
				</tr>
				<tr class="table-header">
					<td width="10%">A.2</td>
					<td  width="90%" colspan="2">
						STATEMENT DETAILS
					</td>
				</tr>
				<tr>
					<td>A.2.1</td>
					<td>Statement Type</td>
					<td>
						<% 
							String statementType = statement.get("STATEMENTTYPE");
							String statementType1 = "", statementType2 = "";
							if(statementType != null && statementType.length() == 2){
								statementType1 = String.valueOf(statementType.charAt(0));
								statementType2 = String.valueOf(statementType.charAt(1));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="STATEMENTTYPE1" value="<%=statementType1%>"/>
						<input type="text" class="input-sm input-ovr" name="STATEMENTTYPE2" value="<%=statementType2%>"/>
					</td>
				</tr>
				<tr>
					<td>A.2.2</td>
					<td>Statement Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="STATEMENTNO" value="<%= statement.get("STATEMENTNO") != null ? statement.get("STATEMENTNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>A.2.3</td>
					<td>Original Statement Id</td>
					<td>
						<input type="text" class="form-control input-sm" name="ORIGINALSTATEMENTID" value="<%= statement.get("ORIGINALSTATEMENTID") != null ? statement.get("ORIGINALSTATEMENTID") : "" %>">
					</td>
				</tr>
				<tr>
					<td>A.2.4</td>
					<td>Reason for Correction</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="REASONOFCORRECTION" value="<%= statement.get("REASONOFCORRECTION") != null ? statement.get("REASONOFCORRECTION") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.2.5</td>
					<td>Statement Date</td>
					<td>
						<input type="text" class="form-control input-sm" name="STATEMENTDATE" value="<%= statement.get("STATEMENTDATE") != null ? statement.get("STATEMENTDATE") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.2.6</td>
					<td>Reporting Period</td>
					<td>
						<input type="text" class="form-control input-sm" name="REPORTINGPERIOD" value="<%= statement.get("REPORTINGPERIOD") != null ? statement.get("REPORTINGPERIOD") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.2.7</td>
					<td>Report Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="REPORTTYPE" value="<%= statement.get("REPORTTYPE") != null ? statement.get("REPORTTYPE") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.2.8</td>
					<td>Number of Reports</td>
					<td>
						<input type="text" class="form-control input-sm" name="NOOFREPORTS" value="<%= statement.get("NOOFREPORTS") != null ? statement.get("NOOFREPORTS") : "" %>"/>
					</td>
				</tr>
				<tr class="table-header">
					<td width="10%">A.3</td>
					<td  width="90%" colspan="2">
						PRINCIPAL OFFICER DETAIL
					</td>
				</tr>
				<tr>
					<td>A.3.1</td>
					<td>Principal Officer Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="PRINCIPALOFFICERNAME" value="<%= statement.get("PRINCIPALOFFICERNAME") != null ? statement.get("PRINCIPALOFFICERNAME") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.2</td>
					<td>Principal Officer Designation</td>
					<td>
						<input type="text" class="form-control input-sm" name="PRINCIPALOFFICERDESGN" value="<%= statement.get("PRINCIPALOFFICERDESGN") != null ? statement.get("PRINCIPALOFFICERDESGN") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.3</td>
					<td>Principal Officer Address</td>
					<td>
						<input type="text" class="form-control input-sm" name="PRINCIPALOFFICERADDRESS" value="<%= statement.get("PRINCIPALOFFICERADDRESS") != null ? statement.get("PRINCIPALOFFICERADDRESS") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.4</td>
					<td>City / Town</td>
					<td>
						<input type="text" class="form-control input-sm" name="PRINCIPALOFFICERCITY" value="<%= statement.get("PRINCIPALOFFICERCITY") != null ? statement.get("PRINCIPALOFFICERCITY") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.5</td>
					<td>Postal Code</td>
					<td>
						<input type="text" class="form-control input-sm"  name="PRINCIPALOFFICERPOSTALCODE" value="<%= statement.get("PRINCIPALOFFICERPOSTALCODE") != null ? statement.get("PRINCIPALOFFICERPOSTALCODE") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.6</td>
					<td>State Code</td>
					<td>
						<% 
							String principalOfficerStateCode = statement.get("STATECODE");
							String principalOfficerStateCode1 = "", principalOfficerStateCode2 = "";
							if(principalOfficerStateCode != null && principalOfficerStateCode.length() == 2){
								principalOfficerStateCode1 = String.valueOf(principalOfficerStateCode.charAt(0));
								principalOfficerStateCode2 = String.valueOf(principalOfficerStateCode.charAt(1));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="STATECODE1" value="<%=principalOfficerStateCode1%>"/>
						<input type="text" class="input-sm input-ovr" name="STATECODE2" value="<%=principalOfficerStateCode2%>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.7</td>
					<td>Country Code</td>
					<td>
						<% 
							String principalOfficerCountryCode = statement.get("COUNTRYCODE");
							String principalOfficerCountryCode1 = "", principalOfficerCountryCode2 = "";
							if(principalOfficerCountryCode != null && principalOfficerCountryCode.length() == 2){
								principalOfficerCountryCode1 = String.valueOf(principalOfficerCountryCode.charAt(0));
								principalOfficerCountryCode2 = String.valueOf(principalOfficerCountryCode.charAt(1));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="COUNTRYCODE1" value="<%=principalOfficerCountryCode1%>"/>
						<input type="text" class="input-sm input-ovr" name="COUNTRYCODE2" value="<%=principalOfficerCountryCode2%>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.8</td>
					<td>Telephone</td>
					<td>
						<input type="text" class="form-control input-sm" name="TELEPHONE" value="<%= statement.get("TELEPHONE") != null ? statement.get("TELEPHONE") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.9</td>
					<td>Mobile</td>
					<td>
						<input type="text" class="form-control input-sm" name="MOBILE" value="<%= statement.get("MOBILE") != null ? statement.get("MOBILE") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.10</td>
					<td>Fax</td>
					<td>
						<input type="text" class="form-control input-sm" name="FAX" value="<%= statement.get("FAX") != null ? statement.get("FAX") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>A.3.11</td>
					<td>Email</td>
					<td>
						<input type="text" class="form-control input-sm" name="EMAIL" value="<%= statement.get("EMAIL") != null ? statement.get("EMAIL") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td colspan="3" style="text-align: center;">
						<button type="submit" class="btn btn-success">Save</button>
						<!-- <button type="button" class="btn btn-primary">Export XML</button>-->
						<button type="button" class="btn btn-primary" onclick="generateAndDownloadINDFATCAXML('<%=caseNo%>')">Export XML</button>
						<button type="button" onclick="this.window.close()" class="btn btn-danger">Close</button>
					</td>
				</tr>
			</table>
			</form>
			
			<div class="addedAccounts">
				<table class="table table-bordered">
					<tr style="background-color: gray;">
						<td width="80%" style="font-size: 20px; font-weight: bold;">
							Accounts Added to this Report
						</td>
						<td colspan="2" width="20%" style="text-align: center;">
							<button onclick="addUpdateAccount('<%=caseNo%>', 'ADD', '')" class="btn btn-primary">Add Account</button>
						</td>
					</tr>
					<%
					if(report != null && report.size() > 0){
						for(int i = 0; i < report.size(); i++){
							Map<String, Object> reportDetails = report.get(i);
							List<Map<String, String>> individualDetails = (List<Map<String, String>>) reportDetails.get("INDIVIDUALDETAILS");
							List<Map<String, String>> entityDetails = (List<Map<String, String>>) reportDetails.get("ENTITYDETAILS");
							List<Map<String, String>> controllingPersonDetails = (List<Map<String, String>>) reportDetails.get("CONTROLLINGPERSONDETAILS");
						%>
						<tr>
							<td width="80%">
								<div class="pull-left" style="font-family: Segoe UI Semibold; font-size: 22px;">
									<%=reportDetails.get("ACCOUNTHOLDERNAME")%> [<%=reportDetails.get("ACCOUNTNUMBER")%>]
								</div>
								<div class="pull-right">
									<button class="btn btn-primary btn-sm" onclick="addUpdateIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','INDIVIDUAL','')" >Add Individual</button>
									<button class="btn btn-primary btn-sm" onclick="addUpdateIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','ENTITY','')">Add Entity</button>
									<button class="btn btn-primary btn-sm" onclick="addUpdateIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','CONTROLLINGPRSN','')">Add Controlling Person</button>
								</div>
								<% if((individualDetails != null && individualDetails.size() > 0) || 
										entityDetails != null && entityDetails.size() > 0 ||
										controllingPersonDetails != null && controllingPersonDetails.size() > 0){ %>
								<br/>
								<table class="table table-bordered">
									<tr>
										<th width="60%">Name</th>
										<th width="20%">Type</th>
										<th width="20%">Action</th>
									</tr>
									<%
									for(int j = 0; j < individualDetails.size(); j++){
										Map<String, String> individualDetail = individualDetails.get(j);
									%>
									<tr>
										<td><%= individualDetail.get("NAME") %></td>
										<td>Individual</td>
										<td style="text-align: center;">
											<button class="btn btn-success btn-sm" onclick="addUpdateIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','INDIVIDUAL','<%= individualDetail.get("INDIVIDUALID") %>')">Edit/View</button>
											<button class="btn btn-danger btn-sm" onclick="deleteIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','INDIVIDUAL','<%= individualDetail.get("INDIVIDUALID") %>', this)">Delete</button>
										</td>
									</tr>
									<%} %>
									
									<%
									for(int j = 0; j < entityDetails.size(); j++){
										Map<String, String> entityDetail = entityDetails.get(j);
									%>
									<tr>
										<td><%= entityDetail.get("NAME") %></td>
										<td>Entity</td>
										<td style="text-align: center;">
											<button class="btn btn-success btn-sm" onclick="addUpdateIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','ENTITY','<%= entityDetail.get("ENTITYID") %>')">Edit/View</button>
											<button class="btn btn-danger btn-sm" onclick="deleteIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','ENTITY','<%= entityDetail.get("ENTITYID") %>', this)">Delete</button>
										</td>
									</tr>
									<%} %>
									
									<%
									for(int j = 0; j < controllingPersonDetails.size(); j++){
										Map<String, String> controllingPersonDetail = controllingPersonDetails.get(j);
									%>
									<tr>
										<td><%= controllingPersonDetail.get("NAME") %></td>
										<td>Controlling Person</td>
										<td style="text-align: center;">
											<button class="btn btn-success btn-sm" onclick="addUpdateIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','CONTROLLINGPRSN','<%= controllingPersonDetail.get("CONTROLLINGPERSONID") %>')">Edit/View</button>
											<button class="btn btn-danger btn-sm" onclick="deleteIndividualEntityControllingPerson('<%=caseNo%>','<%=reportDetails.get("ACCOUNTNUMBER")%>','CONTROLLINGPRSN','<%= controllingPersonDetail.get("CONTROLLINGPERSONID") %>', this)">Delete</button>
										</td>
									</tr>
									<%} %>
								</table>
								<%} %>
							</td>
							<td width="10%" style="text-align: center;">
								<button  onclick="addUpdateAccount('<%=caseNo%>', 'UPDATE', '<%=reportDetails.get("ACCOUNTNUMBER")%>')" class="btn btn-success btn-sm">Edit/View</button>
							</td>
							<td width="10%" style="text-align: center;">
								<button onclick="deleteAccount('<%=caseNo%>', '<%=reportDetails.get("ACCOUNTNUMBER")%>', this)" class="btn btn-danger btn-sm">Delete</button>
							</td>
						</tr>
						<%
						}
					}else{
						%>
						<tr style="text-align: center; font-family: Segoe UI Semibold; font-size: 20px;">
							<td colspan="3">No Account is added to this report yet.</td>
						</tr>
						<%
					}
					%>
				</table>
			</div>
			<%
				if(report != null && report.size() > 0){
					for(int i = 0; i < report.size(); i++){
						Map<String, Object> reportDetails = report.get(i);
						List<Map<String, String>> individualDetails = (List<Map<String, String>>) reportDetails.get("INDIVIDUALDETAILS");
						List<Map<String, String>> entityDetails = (List<Map<String, String>>) reportDetails.get("ENTITYDETAILS");
						List<Map<String, String>> controllingPersonDetails = (List<Map<String, String>>) reportDetails.get("CONTROLLINGPERSONDETAILS");
			%>
			<div style="text-align: center;">
				<span style="font-size: 20px; font-weight: bold;">
					PART B: REPORT DETAILS
				</span><br/>
				<span>
					(This information should be provided for each Account being reported)
				</span>
			</div>
			<table class="table table-bordered">
				<tr class="table-header">
					<td width="10%">B.1</td>
					<td  width="90%" colspan="2">
						ACCOUNT DETAILS (To be provided for each account being reported)
					</td>
				</tr>
				<tr>
					<td width="10%">B.1.1</td>
					<td width="30%">Report Serial Number</td>
					<td width="60%"><input type="text" class="form-control input-sm" name="REPORTSERIALNO"  value="<%= reportDetails.get("REPORTSERIALNO") != null ? (String) reportDetails.get("REPORTSERIALNO") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.1.2</td>
					<td>Original Report Serial Number</td>
					<td><input type="text" class="form-control input-sm" name="ORIGINALREPORTSERIALNO"  value="<%= reportDetails.get("ORIGINALREPORTSERIALNO") != null ? (String) reportDetails.get("ORIGINALREPORTSERIALNO") : "" %>"></td>
				</tr>
				<tr>
					<td>B.1.3</td>
					<td>Account Type</td>
					<td>
						<% 
							String accountType = (String) reportDetails.get("ACCOUNTTYPE");
							String accountType1 = "", accountType2 = "";
							if(accountType != null && accountType.length() == 2){
								accountType1 = String.valueOf(accountType.charAt(0));
								accountType2 = String.valueOf(accountType.charAt(1));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="ACCOUNTTYPE1" value="<%=accountType1%>"/>
						<input type="text" class="input-sm input-ovr" name="ACCOUNTTYPE2" value="<%=accountType2%>" />
					</td>
				</tr>
				<tr>
					<td>B.1.4</td>
					<td>Account Number</td>
					<td><input type="text" class="form-control input-sm" name="ACCOUNTNUMBER"  value="<%= reportDetails.get("ACCOUNTNUMBER") != null ? (String) reportDetails.get("ACCOUNTNUMBER") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.1.5</td>
					<td>Account Number Type</td>
					<td><input type="text" class="input-sm input-ovr"  name="ACCOUNTNUMBERTYPE"  value="<%= reportDetails.get("ACCOUNTNUMBERTYPE") != null ? (String) reportDetails.get("ACCOUNTNUMBERTYPE") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.1.6</td>
					<td>Account Holder Name</td>
					<td><input type="text" class="form-control input-sm" name="ACCOUNTHOLDERNAME"  value="<%= reportDetails.get("ACCOUNTHOLDERNAME") != null ? (String) reportDetails.get("ACCOUNTHOLDERNAME") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.1.7</td>
					<td>Account Status</td>
					<td><input type="text" class="input-sm input-ovr"  name="ACCOUNTSTATUS"  value="<%= reportDetails.get("ACCOUNTSTATUS") != null ? (String) reportDetails.get("ACCOUNTSTATUS") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.1.8</td>
					<td>Account Treatment</td>
					<td><input type="text" class="input-sm input-ovr"  name="ACCOUNTTREATMENT"  value="<%= reportDetails.get("ACCOUNTTREATMENT") != null ? (String) reportDetails.get("ACCOUNTTREATMENT") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.1.9</td>
					<td>Self- certification</td>
					<td><input type="text" class="input-sm input-ovr"  name="SELFCERTIFICATION"  value="<%= reportDetails.get("SELFCERTIFICATION") != null ? (String) reportDetails.get("SELFCERTIFICATION") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.1.10</td>
					<td>Documentation Status</td>
					<td><input type="text" class="input-sm input-ovr"  name="DOCSTATUS"  value="<%= reportDetails.get("DOCSTATUS") != null ? (String) reportDetails.get("DOCSTATUS") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.1.11</td>
					<td>Date of closure of account, if closed during the year</td>
					<td><input type="text" class="form-control input-sm" name="ACCOUNTCLOSEDDATE"  value="<%= reportDetails.get("ACCOUNTCLOSEDDATE") != null ? (String) reportDetails.get("ACCOUNTCLOSEDDATE") : "" %>"/></td>
				</tr>
				<tr class="table-header">
					<td width="10%">B.2</td>
					<td  width="90%" colspan="2">
						BRANCH DETAILS
					</td>
				</tr>
				<tr>
					<td>B.2.1</td>
					<td>Branch Number Type</td>
					<td><input type="text" class="input-sm input-ovr"  name="BRANCHNUMBERTYPE"  value="<%= reportDetails.get("BRANCHNUMBERTYPE") != null ? (String) reportDetails.get("BRANCHNUMBERTYPE") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.2</td>
					<td>Branch Reference Number</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHREFNO"  value="<%= reportDetails.get("BRANCHREFNO") != null ? (String) reportDetails.get("BRANCHREFNO") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.3</td>
					<td>Branch Name</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHNAME"  value="<%= reportDetails.get("BRANCHNAME") != null ? (String) reportDetails.get("BRANCHNAME") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.4</td>
					<td>Branch Address</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHADDR"  value="<%= reportDetails.get("BRANCHADDR") != null ? (String) reportDetails.get("BRANCHADDR") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.5</td>
					<td>City Town</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHCITY"  value="<%= reportDetails.get("BRANCHCITY") != null ? (String) reportDetails.get("BRANCHCITY") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.6</td>
					<td>Postal Code</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHPOSTALCODE"  value="<%= reportDetails.get("BRANCHPOSTALCODE") != null ? (String) reportDetails.get("BRANCHPOSTALCODE") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.7</td>
					<td>State Code</td>
					<td>
						<% 
							String branchStateCode = (String) reportDetails.get("BRANCHSTATECODE");
							String branchStateCode1 = "", branchStateCode2 = "";
							if(branchStateCode != null && branchStateCode.length() == 2){
								branchStateCode1 = String.valueOf(branchStateCode.charAt(0));
								branchStateCode2 = String.valueOf(branchStateCode.charAt(1));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="BRANCHSTATECODE1"  value="<%=branchStateCode1%>"/> 
						<input type="text" class="input-sm input-ovr" name="BRANCHSTATECODE2"  value="<%=branchStateCode2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.2.8</td>
					<td>Country Code</td>
					<td>
						<% 
							String branchCountryCode = (String) reportDetails.get("BRANCHCOUNTRYCODE");
							String branchCountryCode1 = "", branchCountryCode2 = "";
							if(branchCountryCode != null && branchCountryCode.length() == 2){
								branchCountryCode1 = String.valueOf(branchCountryCode.charAt(0));
								branchCountryCode2 = String.valueOf(branchCountryCode.charAt(1));
							}
						%>
						<input type="text" class="input-sm input-ovr" name="BRANCHCOUNTRYCODE1"  value="<%=branchCountryCode1%>"/>
						<input type="text" class="input-sm input-ovr" name="BRANCHCOUNTRYCODE2"  value="<%=branchCountryCode2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.2.9</td>
					<td>Telephone</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHTELEPHONE"  value="<%= reportDetails.get("BRANCHTELEPHONE") != null ? (String) reportDetails.get("BRANCHTELEPHONE") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.10</td>
					<td>Mobile</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHMOBILE"  value="<%= reportDetails.get("BRANCHMOBILE") != null ? (String) reportDetails.get("BRANCHMOBILE") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.11</td>
					<td>Fax</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHFAX"  value="<%= reportDetails.get("BRANCHFAX") != null ? (String) reportDetails.get("BRANCHFAX") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.2.12</td>
					<td>Email</td>
					<td><input type="text" class="form-control input-sm" name="BRANCHEMAIL"  value="<%= reportDetails.get("BRANCHEMAIL") != null ? (String) reportDetails.get("BRANCHEMAIL") : "" %>"/></td>
				</tr>
				<tr class="table-header">
					<td width="10%">B.3</td>
					<td  width="90%" colspan="2">
						ACCOUNT SUMMARY
					</td>
				</tr>
				<tr>
					<td>B.3.1</td>
					<td>Account balance or value at the end of reporting period</td>
					<td><input type="text" class="form-control input-sm" name="ACCOUNTBALANCE"  value="<%= reportDetails.get("ACCOUNTBALANCE") != null ? (String) reportDetails.get("ACCOUNTBALANCE") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.3.2</td>
					<td>Aggregate gross interest paid or credited</td>
					<td><input type="text" class="form-control input-sm" name="AGGRGROSSINSTPAID"  value="<%= reportDetails.get("AGGRGROSSINSTPAID") != null ? (String) reportDetails.get("AGGRGROSSINSTPAID") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.3.3</td>
					<td>Aggregate gross dividend paid or credited</td>
					<td><input type="text" class="form-control input-sm" name="AGGRGROSSDVDNTPAID"  value="<%= reportDetails.get("AGGRGROSSDVDNTPAID") != null ? (String) reportDetails.get("AGGRGROSSDVDNTPAID") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.3.4</td>
					<td>Gross proceeds from sale of property</td>
					<td><input type="text" class="form-control input-sm" name="GROSSPROCEEDFROMSALE"  value="<%= reportDetails.get("GROSSPROCEEDFROMSALE") != null ? (String) reportDetails.get("GROSSPROCEEDFROMSALE") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.3.5</td>
					<td>Aggregate gross amount of all other income paid or credited</td>
					<td><input type="text" class="form-control input-sm" name="AGGRGROSSAMNTALLOTHINCOME"  value="<%= reportDetails.get("AGGRGROSSAMNTALLOTHINCOME") != null ? (String) reportDetails.get("AGGRGROSSAMNTALLOTHINCOME") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.3.6</td>
					<td>Aggregate gross amount credited</td>
					<td><input type="text" class="form-control input-sm" name="AGGRGROSSAMNTCRDT"  value="<%= reportDetails.get("AGGRGROSSAMNTCRDT") != null ? (String) reportDetails.get("AGGRGROSSAMNTCRDT") : "" %>"/></td>
				</tr>
				<tr>
					<td>B.3.7</td>
					<td>Aggregate gross amount debited</td>
					<td><input type="text" class="form-control input-sm" name="AGGRGROSSAMNTDEBT"  value="<%= reportDetails.get("AGGRGROSSAMNTDEBT") != null ? (String) reportDetails.get("AGGRGROSSAMNTDEBT") : "" %>"/></td>
				</tr>
				<%
				if(individualDetails != null && individualDetails.size() > 0){
					for(int j = 0; j < individualDetails.size(); j++){
						Map<String, String> individualDetail = individualDetails.get(j);
				%>
				<tr class="table-header">
					<td width="10%">B.4</td>
					<td  width="90%" colspan="2">
						INDIVIDUAL DETAILS (To be provided for individual account holder )
					</td>
				</tr>
				<tr>
					<td>B.4.1</td>
					<td>Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="NAME" value="<%= individualDetail.get("NAME") != null ? individualDetail.get("NAME") : "" %>">
					</td>
				</tr>
			<tr>
				<td>B.4.2</td>
				<td>Customer ID</td>
				<td><input type="text" class="form-control input-sm" name="CUSTOMERID" value="<%= individualDetail.get("CUSTOMERID") != null ? individualDetail.get("CUSTOMERID") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.3</td>
				<td>Father's Name</td>
				<td><input type="text" class="form-control input-sm" name="FATHERNAME" value="<%= individualDetail.get("FATHERNAME") != null ? individualDetail.get("FATHERNAME") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.4</td>
				<td>Spouse's Name</td>
				<td><input type="text" class="form-control input-sm" name="SPOUSENAME" value="<%= individualDetail.get("SPOUSENAME") != null ? individualDetail.get("SPOUSENAME") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.5</td>
				<td>Gender</td>
				<td><input type="text" class="input-sm input-ovr"  name="GENDER" value="<%= individualDetail.get("GENDER") != null ? individualDetail.get("GENDER") : "" %>"/></td>
			</tr>
			<tr>
				<td>B.4.6</td>
				<td>PAN</td>
				<td>
					<% 
					String pan = individualDetail.get("PAN");
					String pan1 = "", pan2 = "", pan3 = "", pan4 = "", pan5 = "", pan6 = "", pan7 = "", pan8 = "", pan9 = "", pan10 = "";
					if(pan != null && pan.length() == 10){
						pan1 = String.valueOf(pan.charAt(0));
						pan2 = String.valueOf(pan.charAt(1));
						pan3 = String.valueOf(pan.charAt(2));
						pan4 = String.valueOf(pan.charAt(3));
						pan5 = String.valueOf(pan.charAt(4));
						pan6 = String.valueOf(pan.charAt(5));
						pan7 = String.valueOf(pan.charAt(6));
						pan8 = String.valueOf(pan.charAt(7));
						pan9 = String.valueOf(pan.charAt(8));
						pan10 = String.valueOf(pan.charAt(9));
					}
					%>
					<input type="text" class="input-sm input-ovr"  name="PAN1" value="<%=pan1%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN2" value="<%=pan2%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN3" value="<%=pan3%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN4" value="<%=pan4%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN5" value="<%=pan5%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN6" value="<%=pan6%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN7" value="<%=pan7%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN8" value="<%=pan8%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN9" value="<%=pan9%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN10" value="<%=pan10%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.7</td>
				<td>Aadhaar Number</td>
				<td><input type="text" class="form-control input-sm" name="ADHAARNO" value="<%= individualDetail.get("ADHAARNO") != null ? individualDetail.get("ADHAARNO") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.8</td>
				<td>Identification Type</td>
				<td><input type="text" class="input-sm input-ovr"  name="IDTYPE" value="<%= individualDetail.get("IDTYPE") != null ? individualDetail.get("IDTYPE") : "" %>"/></td>
			</tr>
			<tr>
				<td>B.4.9</td>
				<td>Identification Number</td>
				<td><input type="text" class="form-control input-sm" name="IDNO" value="<%= individualDetail.get("IDNO") != null ? individualDetail.get("IDNO") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.10</td>
				<td>Occupation Type</td>
				<td><input type="text" class="input-sm input-ovr" name="OCCUPATIONTYPE" value="<%= individualDetail.get("OCCUPATIONTYPE") != null ? individualDetail.get("OCCUPATIONTYPE") : "" %>" /></td>
			</tr>
			<tr>
				<td>B.4.11</td>
				<td>Occupation</td>
				<td><input type="text" class="form-control input-sm" name="OCCUPATION" value="<%= individualDetail.get("OCCUPATION") != null ? individualDetail.get("OCCUPATION") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.12</td>
				<td>Birth Date</td>
				<td><input type="text" class="form-control input-sm" name="DATEOFBIRTH" value="<%= individualDetail.get("DATEOFBIRTH") != null ? individualDetail.get("DATEOFBIRTH") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.13</td>
				<td>Nationality</td>
				<td>
					<% 
					String nationality = individualDetail.get("NATIONALITY");
					String nationality1 = "", nationality2 = "";
					if(nationality != null && nationality.length() == 2){
						nationality1 = String.valueOf(nationality.charAt(0));
						nationality2 = String.valueOf(nationality.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="NATIONALITY1" value="<%=nationality1%>"/> 
					<input type="text" class="input-sm input-ovr" name="NATIONALITY2" value="<%=nationality2%>" />
				</td>
			</tr>
			<tr>
				<td>B.4.14</td>
				<td>Country of Residence as per tax laws</td>
				<td>
					<% 
					String countryOfResidence = individualDetail.get("COUNTRYOFRESIDENCE");
					String countryOfResidence1 = "", countryOfResidence2 = "";
					if(countryOfResidence != null && countryOfResidence.length() == 2){
						countryOfResidence1 = String.valueOf(countryOfResidence.charAt(0));
						countryOfResidence2 = String.valueOf(countryOfResidence.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE1" value="<%=countryOfResidence1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE2" value="<%=countryOfResidence2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.15</td>
				<td>Place of Birth</td>
				<td><input type="text" class="form-control input-sm" name="PLACEOFBIRTH" value="<%= individualDetail.get("PLACEOFBIRTH") != null ? individualDetail.get("PLACEOFBIRTH") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.16</td>
				<td>Country of Birth</td>
				<td>
					<% 
					String countryOfBirth = individualDetail.get("COUNTRYOFBIRTH");
					String countryOfBirth1 = "", countryOfBirth2 = "";
					if(countryOfBirth != null && countryOfBirth.length() == 2){
						countryOfBirth1 = String.valueOf(countryOfBirth.charAt(0));
						countryOfBirth2 = String.valueOf(countryOfBirth.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFBIRTH1" value="<%=countryOfBirth1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFBIRTH2" value="<%=countryOfBirth2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.17</td>
				<td>Tax Identification Number (TIN) allotted by tax resident
					country</td>
				<td><input type="text" class="form-control input-sm" name="TIN" value="<%= individualDetail.get("TIN") != null ? individualDetail.get("TIN") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.18</td>
				<td>TIN Issuing Country</td>
				<td>
					<% 
					String tinIssuingCountry = individualDetail.get("TINISSUNINGCOUNTRY");
					String tinIssuingCountry1 = "", tinIssuingCountry2 = "";
					if(tinIssuingCountry != null && tinIssuingCountry.length() == 2){
						tinIssuingCountry1 = String.valueOf(tinIssuingCountry.charAt(0));
						tinIssuingCountry2 = String.valueOf(tinIssuingCountry.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY1" value="<%=tinIssuingCountry1%>"/> 
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY2" value="<%=tinIssuingCountry2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.19</td>
				<td>Address Type</td>
				<td>
					<% 
					String addrType = individualDetail.get("ADDRTYPE");
					String addrType1 = "", addrType2 = "";
					if(addrType != null && addrType.length() == 2){
						addrType1 = String.valueOf(addrType.charAt(0));
						addrType2 = String.valueOf(addrType.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="ADDRTYPE1" value="<%=addrType1%>" /> 
					<input type="text" class="input-sm input-ovr" name="ADDRTYPE2" value="<%=addrType2%>" />
				</td>
			</tr>
			<tr>
				<td>B.4.20</td>
				<td>Address</td>
				<td><textarea rows="3" cols="3" class="form-control input-sm" name="ADDR"><%= individualDetail.get("ADDR") != null ? individualDetail.get("ADDR") : "" %></textarea>
				</td>
			</tr>
			<tr>
				<td>B.4.21</td>
				<td>City / Town</td>
				<td><input type="text" class="form-control input-sm" name="CITY" value="<%= individualDetail.get("CITY") != null ? individualDetail.get("CITY") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.22</td>
				<td>Postal Code</td>
				<td><input type="text" class="form-control input-sm" name="POSTALCODE" value="<%= individualDetail.get("POSTALCODE") != null ? individualDetail.get("POSTALCODE") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.23</td>
				<td>State Code</td>
				<td>
					<% 
					String stateCode = individualDetail.get("STATECODE");
					String stateCode1 = "", stateCode2 = "";
					if(stateCode != null && stateCode.length() == 2){
						stateCode1 = String.valueOf(stateCode.charAt(0));
						stateCode2 = String.valueOf(stateCode.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="STATECODE1" value="<%=stateCode1%>" /> 
					<input type="text" class="input-sm input-ovr" name="STATECODE2" value="<%=stateCode2%>" />
				</td>
			</tr>
			<tr>
				<td>B.4.24</td>
				<td>Country Code</td>
				<td>
					<% 
					String countryCode = individualDetail.get("COUNTRYCODE");
					String countryCode1 = "", countryCode2 = "";
					if(countryCode != null && countryCode.length() == 2){
						countryCode1 = String.valueOf(countryCode.charAt(0));
						countryCode2 = String.valueOf(countryCode.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYCODE1" value="<%=countryCode1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYCODE2" value="<%=countryCode2%>"/>
				</td>
			</tr>
			<tr>
				<td>B.4.25</td>
				<td>Mobile/Telephone Number</td>
				<td><input type="text" class="form-control input-sm" name="TELEPHONE" value="<%= individualDetail.get("TELEPHONE") != null ? individualDetail.get("TELEPHONE") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.26</td>
				<td>Other Contact Number</td>
				<td><input type="text" class="form-control input-sm" name="OTHERCONTACTNO" value="<%= individualDetail.get("OTHERCONTACTNO") != null ? individualDetail.get("OTHERCONTACTNO") : "" %>"></td>
			</tr>
			<tr>
				<td>B.4.27</td>
				<td>Remarks</td>
				<td><input type="text" class="form-control input-sm" name="REMARKS" value="<%= individualDetail.get("REMARKS") != null ? individualDetail.get("REMARKS") : "" %>"></td>
			</tr>
				<% } }%>
				<%
				if(entityDetails != null && entityDetails.size() > 0){
					for(int j = 0; j < entityDetails.size(); j++){
						Map<String, String> entityDetail = entityDetails.get(j);
				%>
				<tr class="table-header">
					<td width="10%">B.5</td>
					<td  width="90%" colspan="2">
						LEGAL ENTITY DETAILS (To be provided for entity account holder)
					</td>
				</tr>
				<tr>
					<td>B.5.1</td>
					<td>Name of the Entity</td>
					<td>
						<input type="text" class="form-control input-sm" name="NAME" value="<%=entityDetail.get("NAME") != null ? entityDetail.get("NAME") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.2</td>
					<td>Customer ID</td>
					<td>
						<input type="text" class="form-control input-sm" name="CUSTOMERID" value="<%=entityDetail.get("CUSTOMERID") != null ? entityDetail.get("CUSTOMERID") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.3</td>
					<td>Account Holder Type for US Reportable Person</td>
					<td>
						<% 
						String usAccountHolderType = entityDetail.get("USACCOUNTHOLDERTYPE");
						String usAccountHolderType1 = "", usAccountHolderType2 = "";
						if(usAccountHolderType != null && usAccountHolderType.length() == 2){
							usAccountHolderType1 = String.valueOf(usAccountHolderType.charAt(0));
							usAccountHolderType2 = String.valueOf(usAccountHolderType.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="USACCOUNTHOLDERTYPE1" value="<%=usAccountHolderType1%>"/>
						<input type="text" class="input-sm input-ovr" name="USACCOUNTHOLDERTYPE2" value="<%=usAccountHolderType2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.4</td>
					<td>Account Holder Type for Other Reportable Person</td>
					<td>
						<% 
						String otherAccountHolderType = entityDetail.get("OTHACCOUNTHOLDERTYPE");
						String otherAccountHolderType1 = "", otherAccountHolderType2 = "";
						if(otherAccountHolderType != null && otherAccountHolderType.length() == 2){
							otherAccountHolderType1 = String.valueOf(otherAccountHolderType.charAt(0));
							otherAccountHolderType2 = String.valueOf(otherAccountHolderType.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="OTHACCOUNTHOLDERTYPE1" value="<%=otherAccountHolderType1%>"/>
						<input type="text" class="input-sm input-ovr" name="OTHACCOUNTHOLDERTYPE2" value="<%=otherAccountHolderType2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.5</td>
					<td>Entity Constitution Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="CONSTITUTIONTYPE" value="<%=entityDetail.get("CONSTITUTIONTYPE") != null ? entityDetail.get("CONSTITUTIONTYPE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.6</td>
					<td>Date of Incorporation</td>
					<td>
						<input type="text" class="form-control input-sm" name="DATEOFINCORPORATION" value="<%=entityDetail.get("DATEOFINCORPORATION") != null ? entityDetail.get("DATEOFINCORPORATION") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.7</td>
					<td>Nature of Business</td>
					<td>
						<input type="text" class="form-control input-sm" name="NATUREOFBUSINESS" value="<%=entityDetail.get("NATUREOFBUSINESS") != null ? entityDetail.get("NATUREOFBUSINESS") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.8</td>
					<td>PAN</td>
					<td>
						<% 
					String pan = entityDetail.get("PAN");
					String pan1 = "", pan2 = "", pan3 = "", pan4 = "", pan5 = "", pan6 = "", pan7 = "", pan8 = "", pan9 = "", pan10 = "";
					if(pan != null && pan.length() == 10){
						pan1 = String.valueOf(pan.charAt(0));
						pan2 = String.valueOf(pan.charAt(1));
						pan3 = String.valueOf(pan.charAt(2));
						pan4 = String.valueOf(pan.charAt(3));
						pan5 = String.valueOf(pan.charAt(4));
						pan6 = String.valueOf(pan.charAt(5));
						pan7 = String.valueOf(pan.charAt(6));
						pan8 = String.valueOf(pan.charAt(7));
						pan9 = String.valueOf(pan.charAt(8));
						pan10 = String.valueOf(pan.charAt(9));
					}
					%>
					<input type="text" class="input-sm input-ovr"  name="PAN1" value="<%=pan1%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN2" value="<%=pan2%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN3" value="<%=pan3%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN4" value="<%=pan4%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN5" value="<%=pan5%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN6" value="<%=pan6%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN7" value="<%=pan7%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN8" value="<%=pan8%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN9" value="<%=pan9%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN10" value="<%=pan10%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.9</td>
					<td>Identification Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="IDTYPE" value="<%=entityDetail.get("IDTYPE") != null ? entityDetail.get("IDTYPE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.10</td>
					<td>Identification No</td>
					<td>
						<input type="text" class="form-control input-sm" name="IDNO" value="<%=entityDetail.get("IDNO") != null ? entityDetail.get("IDNO") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.11</td>
					<td>Identification issuing Country</td>
					<td>
						<% 
						String idIssuingCountry = entityDetail.get("IDISSUINGCOUNTRY");
						String idIssuingCountry1 = "", idIssuingCountry2 = "";
						if(idIssuingCountry != null && idIssuingCountry.length() == 2){
							idIssuingCountry1 = String.valueOf(idIssuingCountry.charAt(0));
							idIssuingCountry2 = String.valueOf(idIssuingCountry.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="IDISSUINGCOUNTRY1" value="<%=idIssuingCountry1%>"/>
						<input type="text" class="input-sm input-ovr" name="IDISSUINGCOUNTRY2" value="<%=idIssuingCountry2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.12</td>
					<td>Place of Incorporation</td>
					<td>
						<input type="text" class="form-control input-sm" name="PLACEOFINCORPORATION" value="<%=entityDetail.get("PLACEOFINCORPORATION") != null ? entityDetail.get("PLACEOFINCORPORATION") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.13</td>
					<td>Country of Incorporation</td>
					<td>
						<% 
						String countryOfIncorp = entityDetail.get("COUNTRYOFINCORPORATION");
						String countryOfIncorp1 = "", countryOfIncorp2 = "";
						if(countryOfIncorp != null && countryOfIncorp.length() == 2){
							countryOfIncorp1 = String.valueOf(countryOfIncorp.charAt(0));
							countryOfIncorp2 = String.valueOf(countryOfIncorp.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="COUNTRYOFINCORPORATION1" value="<%=countryOfIncorp1%>"/>
						<input type="text" class="input-sm input-ovr" name="COUNTRYOFINCORPORATION2" value="<%=countryOfIncorp2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.14</td>
					<td>Country of Residence as per tax laws</td>
					<td>
					<% 
					String countryOfResidence = entityDetail.get("COUNTRYOFRESIDENCE");
					String countryOfResidence1 = "", countryOfResidence2 = "";
					if(countryOfResidence != null && countryOfResidence.length() == 2){
						countryOfResidence1 = String.valueOf(countryOfResidence.charAt(0));
						countryOfResidence2 = String.valueOf(countryOfResidence.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE1" value="<%=countryOfResidence1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE2" value="<%=countryOfResidence2%>"/>
				</td>
				</tr>
				<tr>
					<td>B.5.15</td>
					<td>Tax Identification Number (TIN) allotted by tax resident country</td>
					<td>
						<input type="text" class="form-control input-sm" name="TIN" value="<%=entityDetail.get("TIN") != null ? entityDetail.get("TIN") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.16</td>
					<td>TIN Issuing Country</td>
					<td>
					<% 
					String tinIssuingCountry = entityDetail.get("TINISSUNINGCOUNTRY");
					String tinIssuingCountry1 = "", tinIssuingCountry2 = "";
					if(tinIssuingCountry != null && tinIssuingCountry.length() == 2){
						tinIssuingCountry1 = String.valueOf(tinIssuingCountry.charAt(0));
						tinIssuingCountry2 = String.valueOf(tinIssuingCountry.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY1" value="<%=tinIssuingCountry1%>"/> 
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY2" value="<%=tinIssuingCountry2%>"/>
				</td>
				</tr>
				<tr>
					<td>B.5.17</td>
					<td>Address Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="ADDRTYPE" value="<%=entityDetail.get("ADDRTYPE") != null ? entityDetail.get("ADDRTYPE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.18</td>
					<td>Address</td>
					<td>
						<textarea rows="3" cols="3" class="form-control input-sm" name="ADDR"><%=entityDetail.get("ADDR") != null ? entityDetail.get("ADDR") : ""%></textarea>
					</td>
				</tr>
				<tr>
					<td>B.5.19</td>
					<td>City / Town</td>
					<td>
						<input type="text" class="form-control input-sm" name="CITY" value="<%=entityDetail.get("CITY") != null ? entityDetail.get("CITY") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.20</td>
					<td>Postal Code</td>
					<td>
						<input type="text" class="form-control input-sm" name="POSTALCODE" value="<%=entityDetail.get("POSTALCODE") != null ? entityDetail.get("POSTALCODE") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.21</td>
					<td>State Code</td>
					<td>
					<% 
					String stateCode = entityDetail.get("STATECODE");
					String stateCode1 = "", stateCode2 = "";
					if(stateCode != null && stateCode.length() == 2){
						stateCode1 = String.valueOf(stateCode.charAt(0));
						stateCode2 = String.valueOf(stateCode.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="STATECODE1" value="<%=stateCode1%>" /> 
					<input type="text" class="input-sm input-ovr" name="STATECODE2" value="<%=stateCode2%>" />
				</td>
				</tr>
				<tr>
					<td>B.5.22</td>
					<td>Country Code</td>
					<td>
						<% 
						String countryCode = entityDetail.get("COUNTRYCODE");
						String countryCode1 = "", countryCode2 = "";
						if(countryCode != null && countryCode.length() == 2){
							countryCode1 = String.valueOf(countryCode.charAt(0));
							countryCode2 = String.valueOf(countryCode.charAt(1));
						}
						%>
						<input type="text" class="input-sm input-ovr" name="COUNTRYCODE1" value="<%=countryCode1%>"/> 
						<input type="text" class="input-sm input-ovr" name="COUNTRYCODE2" value="<%=countryCode2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.23</td>
					<td>Mobile/Telephone Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="TELEPHONENO" value="<%=entityDetail.get("TELEPHONENO") != null ? entityDetail.get("TELEPHONENO") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.24</td>
					<td>Other Contact Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="OTHCONTACTNO" value="<%=entityDetail.get("OTHCONTACTNO") != null ? entityDetail.get("OTHCONTACTNO") : ""%>"/>
					</td>
				</tr>
				<tr>
					<td>B.5.25</td>
					<td>Remarks</td>
					<td>
						<input type="text" class="form-control input-sm" name="REMARKS" value="<%=entityDetail.get("REMARKS") != null ? entityDetail.get("REMARKS") : ""%>"/>
					</td>
				</tr>
				<% 
					}
				}
				%>
				<%
				if(controllingPersonDetails != null && controllingPersonDetails.size() > 0){
					for(int j = 0; j < controllingPersonDetails.size(); j++){
						Map<String, String> controllingPersonDetail = controllingPersonDetails.get(j);
				%>
				<tr class="table-header">
					<td width="10%">B.6</td>
					<td  width="90%" colspan="2">
						CONTROLLING PERSON DETAILS (To be provided for each controlling person of the entity)
					</td>
				</tr>
				<tr>
					<td>B.6.1</td>
					<td>Controlling Person Type</td>
					<td>
						<% 
							String personType = controllingPersonDetail.get("PERSONTYPE");
							String personType1 = "", personType2 = "", personType3 = "";
							if(personType != null && personType.length() == 3){
								personType1 = String.valueOf(personType.charAt(0));
								personType2 = String.valueOf(personType.charAt(1));
								personType3 = String.valueOf(personType.charAt(2));
							}
							%>
						<input type="text" class="input-sm input-ovr" name="PERSONTYPE1" value="<%=personType1%>"/>
						<input type="text" class="input-sm input-ovr" name="PERSONTYPE2" value="<%=personType2%>"/>
						<input type="text" class="input-sm input-ovr" name="PERSONTYPE3" value="<%=personType3%>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.2</td>
					<td>Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="NAME" value="<%= controllingPersonDetail.get("NAME") != null ? controllingPersonDetail.get("NAME") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.3</td>
					<td>Customer ID</td>
					<td>
						<input type="text" class="form-control input-sm" name="CUSTOMERID" value="<%= controllingPersonDetail.get("CUSTOMERID") != null ? controllingPersonDetail.get("CUSTOMERID") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.4</td>
					<td>Father's Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="FATHERNAME" value="<%= controllingPersonDetail.get("FATHERNAME") != null ? controllingPersonDetail.get("FATHERNAME") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.5</td>
					<td>Spouse's Name</td>
					<td>
						<input type="text" class="form-control input-sm" name="SPOUSENAME" value="<%= controllingPersonDetail.get("SPOUSENAME") != null ? controllingPersonDetail.get("SPOUSENAME") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.6</td>
					<td>Gender</td>
					<td>
						<input type="text" class="input-sm input-ovr"  name="GENDER" value="<%= controllingPersonDetail.get("GENDER") != null ? controllingPersonDetail.get("GENDER") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.7</td>
					<td>PAN</td>
					<td>
					<% 
					String pan = controllingPersonDetail.get("PAN");
					String pan1 = "", pan2 = "", pan3 = "", pan4 = "", pan5 = "", pan6 = "", pan7 = "", pan8 = "", pan9 = "", pan10 = "";
					if(pan != null && pan.length() == 10){
						pan1 = String.valueOf(pan.charAt(0));
						pan2 = String.valueOf(pan.charAt(1));
						pan3 = String.valueOf(pan.charAt(2));
						pan4 = String.valueOf(pan.charAt(3));
						pan5 = String.valueOf(pan.charAt(4));
						pan6 = String.valueOf(pan.charAt(5));
						pan7 = String.valueOf(pan.charAt(6));
						pan8 = String.valueOf(pan.charAt(7));
						pan9 = String.valueOf(pan.charAt(8));
						pan10 = String.valueOf(pan.charAt(9));
					}
					%>
					<input type="text" class="input-sm input-ovr"  name="PAN1" value="<%=pan1%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN2" value="<%=pan2%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN3" value="<%=pan3%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN4" value="<%=pan4%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN5" value="<%=pan5%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN6" value="<%=pan6%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN7" value="<%=pan7%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN8" value="<%=pan8%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN9" value="<%=pan9%>"/> 
					<input type="text" class="input-sm input-ovr"  name="PAN10" value="<%=pan10%>"/>
				</td>
				</tr>
				<tr>
					<td>B.6.8</td>
					<td>Aadhaar Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="ADHAARNO" value="<%= controllingPersonDetail.get("ADHAARNO") != null ? controllingPersonDetail.get("ADHAARNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.9</td>
					<td>Identification Type</td>
					<td>
						<input type="text" class="input-sm input-ovr"  name="IDTYPE" value="<%= controllingPersonDetail.get("IDTYPE") != null ? controllingPersonDetail.get("IDTYPE") : "" %>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.10</td>
					<td>Identification Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="IDNO" value="<%= controllingPersonDetail.get("IDNO") != null ? controllingPersonDetail.get("IDNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.11</td>
					<td>Occupation Type</td>
					<td>
						<input type="text" class="input-sm input-ovr" name="OCCUPATIONTYPE" value="<%= controllingPersonDetail.get("OCCUPATIONTYPE") != null ? controllingPersonDetail.get("OCCUPATIONTYPE") : "" %>" />
					</td>
				</tr>
				<tr>
					<td>B.6.12</td>
					<td>Occupation</td>
					<td>
						<input type="text" class="form-control input-sm" name="OCCUPATION" value="<%= controllingPersonDetail.get("OCCUPATION") != null ? controllingPersonDetail.get("OCCUPATION") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.13</td>
					<td>Birth Date</td>
					<td>
						<input type="text" class="form-control input-sm" name="DATEOFBIRTH" value="<%= controllingPersonDetail.get("DATEOFBIRTH") != null ? controllingPersonDetail.get("DATEOFBIRTH") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.14</td>
					<td>Nationality</td>
					<td>
					<% 
					String nationality = controllingPersonDetail.get("NATIONALITY");
					String nationality1 = "", nationality2 = "";
					if(nationality != null && nationality.length() == 2){
						nationality1 = String.valueOf(nationality.charAt(0));
						nationality2 = String.valueOf(nationality.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="NATIONALITY1" value="<%=nationality1%>"/> 
					<input type="text" class="input-sm input-ovr" name="NATIONALITY2" value="<%=nationality2%>" />
					</td>
				</tr>
				<tr>
					<td>B.6.15</td>
					<td>Country of Residence as per tax laws</td>
					<td>
					<% 
					String countryOfResidence = controllingPersonDetail.get("COUNTRYOFRESIDENCE");
					String countryOfResidence1 = "", countryOfResidence2 = "";
					if(countryOfResidence != null && countryOfResidence.length() == 2){
						countryOfResidence1 = String.valueOf(countryOfResidence.charAt(0));
						countryOfResidence2 = String.valueOf(countryOfResidence.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE1" value="<%=countryOfResidence1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFRESIDENCE2" value="<%=countryOfResidence2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.16</td>
					<td>Place of Birth</td>
					<td>
						<input type="text" class="form-control input-sm" name="PLACEOFBIRTH" value="<%= controllingPersonDetail.get("PLACEOFBIRTH") != null ? controllingPersonDetail.get("PLACEOFBIRTH") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.17</td>
					<td>Country of Birth</td>
					<td>
					<% 
					String countryOfBirth = controllingPersonDetail.get("COUNTRYOFBIRTH");
					String countryOfBirth1 = "", countryOfBirth2 = "";
					if(countryOfBirth != null && countryOfBirth.length() == 2){
						countryOfBirth1 = String.valueOf(countryOfBirth.charAt(0));
						countryOfBirth2 = String.valueOf(countryOfBirth.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFBIRTH1" value="<%=countryOfBirth1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYOFBIRTH2" value="<%=countryOfBirth2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.18</td>
					<td>Tax Identification Number (TIN) allotted by tax resident country</td>
					<td>
						<input type="text" class="form-control input-sm" name="TIN" value="<%= controllingPersonDetail.get("TIN") != null ? controllingPersonDetail.get("TIN") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.19</td>
					<td>TIN Issuing Country</td>
					<td>
					<% 
					String tinIssuingCountry = controllingPersonDetail.get("TINISSUNINGCOUNTRY");
					String tinIssuingCountry1 = "", tinIssuingCountry2 = "";
					if(tinIssuingCountry != null && tinIssuingCountry.length() == 2){
						tinIssuingCountry1 = String.valueOf(tinIssuingCountry.charAt(0));
						tinIssuingCountry2 = String.valueOf(tinIssuingCountry.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY1" value="<%=tinIssuingCountry1%>"/> 
					<input type="text" class="input-sm input-ovr" name="TINISSUNINGCOUNTRY2" value="<%=tinIssuingCountry2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.20</td>
					<td>Address Type</td>
					<td>
					<% 
					String addrType = controllingPersonDetail.get("ADDRTYPE");
					String addrType1 = "", addrType2 = "";
					if(addrType != null && addrType.length() == 2){
						addrType1 = String.valueOf(addrType.charAt(0));
						addrType2 = String.valueOf(addrType.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="ADDRTYPE1" value="<%=addrType1%>" /> 
					<input type="text" class="input-sm input-ovr" name="ADDRTYPE2" value="<%=addrType2%>" />
					</td>
				</tr>
				<tr>
					<td>B.6.21</td>
					<td>Address</td>
					<td>
						<textarea rows="3" cols="3" class="form-control input-sm" name="ADDR"><%= controllingPersonDetail.get("ADDR") != null ? controllingPersonDetail.get("ADDR") : "" %></textarea>
					</td>
				</tr>
				<tr>
					<td>B.6.22</td>
					<td>City / Town</td>
					<td>
						<input type="text" class="form-control input-sm" name="CITY" value="<%= controllingPersonDetail.get("CITY") != null ? controllingPersonDetail.get("CITY") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.23</td>
					<td>Postal Code</td>
					<td>
						<input type="text" class="form-control input-sm" name="POSTALCODE" value="<%= controllingPersonDetail.get("POSTALCODE") != null ? controllingPersonDetail.get("POSTALCODE") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.24</td>
					<td>State Code</td>
					<td>
					<% 
					String stateCode = controllingPersonDetail.get("STATECODE");
					String stateCode1 = "", stateCode2 = "";
					if(stateCode != null && stateCode.length() == 2){
						stateCode1 = String.valueOf(stateCode.charAt(0));
						stateCode2 = String.valueOf(stateCode.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="STATECODE1" value="<%=stateCode1%>" /> 
					<input type="text" class="input-sm input-ovr" name="STATECODE2" value="<%=stateCode2%>" />
					</td>
				</tr>
				<tr>
					<td>B.6.25</td>
					<td>Country Code</td>
					<td>
					<% 
					String countryCode = controllingPersonDetail.get("COUNTRYCODE");
					String countryCode1 = "", countryCode2 = "";
					if(countryCode != null && countryCode.length() == 2){
						countryCode1 = String.valueOf(countryCode.charAt(0));
						countryCode2 = String.valueOf(countryCode.charAt(1));
					}
					%>
					<input type="text" class="input-sm input-ovr" name="COUNTRYCODE1" value="<%=countryCode1%>"/> 
					<input type="text" class="input-sm input-ovr" name="COUNTRYCODE2" value="<%=countryCode2%>"/>
					</td>
				</tr>
				<tr>
					<td>B.6.26</td>
					<td>Mobile/Telephone Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="TELEPHONE" value="<%= controllingPersonDetail.get("TELEPHONE") != null ? controllingPersonDetail.get("TELEPHONE") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.27</td>
					<td>Other Contact Number</td>
					<td>
						<input type="text" class="form-control input-sm" name="OTHERCONTACTNO" value="<%= controllingPersonDetail.get("OTHERCONTACTNO") != null ? controllingPersonDetail.get("OTHERCONTACTNO") : "" %>">
					</td>
				</tr>
				<tr>
					<td>B.6.28</td>
					<td>Remarks</td>
					<td>
						<input type="text" class="form-control input-sm" name="REMARKS" value="<%= controllingPersonDetail.get("REMARKS") != null ? controllingPersonDetail.get("REMARKS") : "" %>">
					</td>
				</tr>
				<% 
					}
				}
				%>
			</table>
			<%	}
			}
			%>
		</div>
	</body>
</html>
