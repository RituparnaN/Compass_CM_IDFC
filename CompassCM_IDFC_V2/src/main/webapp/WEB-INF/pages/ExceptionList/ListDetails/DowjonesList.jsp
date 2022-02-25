<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1" import="java.util.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%@ include file="../../tags/tags.jsp"%>
<jsp:include page="../../tags/staticFiles.jsp" />
<%
String contextPath = request.getContextPath()==null?"":request.getContextPath();
Map<String, Object> recordDetails = (Map<String, Object>) request.getAttribute("RECORDDETAILS");

List<Map<String, String>> changeLog = (List<Map<String,String>>) recordDetails.get("CHANGELOG");
List<Map<String, String>> nameDetails = (List<Map<String,String>>) recordDetails.get("NAMEDETAILS");
List<Map<String, String>> descriptions = (List<Map<String,String>>) recordDetails.get("DESCRIPTIONS");
List<Map<String, String>> roleDetails = (List<Map<String,String>>) recordDetails.get("ROLEDETAILS");
List<Map<String, String>> dateDetails = (List<Map<String,String>>) recordDetails.get("DATEDETAILS");
List<Map<String, String>> birthPlace = (List<Map<String,String>>) recordDetails.get("BIRTHPLACE");
List<Map<String, String>> sancRef = (List<Map<String,String>>) recordDetails.get("SANCREF");
List<Map<String, String>> address = (List<Map<String,String>>) recordDetails.get("ADDRESSDETAILS");
List<Map<String, String>> country = (List<Map<String,String>>) recordDetails.get("COUNTRYDETAILS");
List<Map<String, String>> idDetails = (List<Map<String,String>>) recordDetails.get("IDDETAILS");
List<Map<String, String>> sourceDesc = (List<Map<String,String>>) recordDetails.get("SOURCEDESC");
List<Map<String, String>> image = (List<Map<String,String>>) recordDetails.get("IMAGE");
List<Map<String, String>> entityCompany = (List<Map<String,String>>) recordDetails.get("ENTITYCOMPANYDETAILS");
List<Map<String, String>> entityVessel = (List<Map<String,String>>) recordDetails.get("ENTITYVESSELDETAILS");
%>
<html>
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta name="Content-Type" content="txt/html; charset=ISO-8859-1">
<title>Dowjones WatchList</title>
<!--[if lt IE 9]>
	<script src="<%=contextPath%>/scripts/html5shiv.js"></script>
	<script src="<%=contextPath%>/scripts/html5shiv.min.js"></script>
	<script src="<%=contextPath%>/scripts/respond.min.js"></script>
<![endif]-->

<style type="text/css">
	.tabledesc{
		font-weight: bold;
		font-size: 16px;
	}
	
	.coldesc{
		font-weight: bold;
	}
</style>
<script type="text/javascript">
	function fetchProfileNote(uploadId, recordId){
		$.ajax({
			type : "POST",
			url : "${pageContext.request.contextPath}/common/dowjoneProfileNotes?uploadId="+uploadId+"&recordId="+recordId,
			cache : false,
			success : function(response){
				$("#profileNotes").html(response);
				$("#dowjonesProfileNoteModal").modal('show');
			},
			error : function(a,b,c){
				alert("Could not process the request");
			}
		});
	}
</script>
</head>
<body>
<div class="modal fade bs-example-modal-lg" id="dowjonesProfileNoteModal" tabindex="1" role="dialog" aria-labelledby="myLargeModalLabel">
  <div class="modal-dialog modal-lg">
    <div class="modal-content card-primary">
      <div class="modal-header card-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close">
        <span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title" id="modal-title">Profile Notes</h4>
      </div>
	  <div class="modal-body" id="profileNotes">
      	Loading...
      </div>
    </div>
  </div>
</div>
	<div class="card-body">
		<div class="row">
			<div class="col-lg-12">
				<div class="card card-default">
					<div class="card-header">
						<i class="fa fa-bar-chart-o fa-fw"><br/>Dowjones Watch List ID :</i>						
					</div>
					<table class="table table-bordered">
						<tr>
							<td width="15%" class="tabledesc">
								Primary Name
							</td>
							<td width="33%">
								<table class="table">
									<tr>
										<td class="coldesc">Name Type</td>
										<td class="coldesc">Full Name</td>
										<td class="coldesc">Maiden Name</td>
										<td class="coldesc">Single String Name</td>
									</tr>
									<%
									for(int i = 0; i < nameDetails.size(); i++){
										Map<String, String> names = nameDetails.get(i);
										if("Y".equals(names.get("ISPRIMARY"))){
										%>
										<tr>
											<td><%= names.get("NAMETYPE") == null ? "": names.get("NAMETYPE")%></td>
											<td><%= names.get("FULLNAME") == null ? "": names.get("FULLNAME")%></td>
											<td><%= names.get("MAIDENNAME") == null ? "": names.get("MAIDENNAME")%></td>
											<td><%= names.get("SINGLESTRINGNAME") == null ? "": names.get("SINGLESTRINGNAME")%></td>
										</tr>
										<%
										}
									}
									%>
								</table>
								<%
									for(int i = 0; i < image.size(); i++){
										Map<String, String> img = image.get(i);
										%>
										<img alt="Image" src="<%=img.get("IMAGEURL")%>" height="250px" width="250px">
										<%
									}
									%>
							</td>
							<td width="4%">&nbsp;</td>
							<td width="15%" class="tabledesc">
								Other Names
							</td>
							<td width="33%">
								<table class="table">
									<tr>
										<td class="coldesc">Name Type</td>
										<td class="coldesc">Full Name</td>
										<td class="coldesc">Maiden Name</td>
										<td class="coldesc">Single String Name</td>
									</tr>
									<%
									for(int i = 0; i < nameDetails.size(); i++){
										Map<String, String> names = nameDetails.get(i);
										if("N".equals(names.get("ISPRIMARY"))){
										%>
										<tr>
											<td><%= names.get("NAMETYPE") == null ? "": names.get("NAMETYPE")%></td>
											<td><%= names.get("FULLNAME") == null ? "": names.get("FULLNAME")%></td>
											<td><%= names.get("MAIDENNAME") == null ? "": names.get("MAIDENNAME")%></td>
											<td><%= names.get("SINGLESTRINGNAME") == null ? "": names.get("SINGLESTRINGNAME")%></td>
										</tr>
										<%
										}
									}
									%>
								</table>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">
								Change Log
							</td>
							<td colspan="4">
								<table class="table">
									<tr>
										<td class="coldesc">Record ID</td>
										<td class="coldesc">Record type</td>
										<td class="coldesc">Action</td>
										<td class="coldesc">Active Status</td>
										<td class="coldesc">Date Entered</td>
										<td class="coldesc">Profile Notes</td>
										<td class="coldesc">Gender</td>
										<td class="coldesc">Deceased</td>
									</tr>
								<% for(int i = 0; i < changeLog.size(); i++){
									Map<String, String> changeLogDetails = changeLog.get(i);
								%>
									<tr>
										<td><%= changeLogDetails.get("RECORDID") == null ? "": changeLogDetails.get("RECORDID") %></td>
										<td><%= changeLogDetails.get("RECORDTYPE") == null ? "": changeLogDetails.get("RECORDTYPE") %></td>
										<td><%= changeLogDetails.get("ACTION") == null ? "": changeLogDetails.get("ACTION") %></td>
										<td><%= changeLogDetails.get("ACTIVESTATUS") == null ? "": changeLogDetails.get("ACTIVESTATUS") %></td>
										<td><%= changeLogDetails.get("DATEVALUE") == null ? "": changeLogDetails.get("DATEVALUE") %></td>
										<td><button class="btn btn-primary btn-xs" onclick="fetchProfileNote('<%=changeLogDetails.get("UPLOADID")%>','<%=changeLogDetails.get("RECORDID")%>')">Profile Notes</button></td>
										<td><%= changeLogDetails.get("GENDER") == null ? "": changeLogDetails.get("GENDER") %></td>
										<td><%= changeLogDetails.get("DECEASED") == null ? "": changeLogDetails.get("DECEASED") %></td>
									</tr>
								<%
								}
								%>
								</table>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Descriptions</td>
							<td colspan="4">
								<table class="table">
									<tr>
										<td class="coldesc">First Description</td>
										<td class="coldesc">Second Description</td>
										<td class="coldesc">Third Description</td>
									</tr>
									<%
									for(int i = 0; i < descriptions.size(); i++){
										Map<String, String> desc = descriptions.get(i);
										%>
											<tr>
												<td><%=desc.get("DESC1") == null ? "": desc.get("DESC1")%></td>
												<td><%=desc.get("DESC2") == null ? "": desc.get("DESC2")%></td>
												<td><%=desc.get("DESC3") == null ? "": desc.get("DESC3")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Roles</td>
							<td colspan="4">
								<table class="table">
									<tr>
										<td class="coldesc">Role Type</td>
										<td class="coldesc">Role</td>
										<td class="coldesc">Occupation Name</td>
										<td class="coldesc">Since</td>
										<td class="coldesc">To</td>
									</tr>
									<%
									for(int i = 0; i < roleDetails.size(); i++){
										Map<String, String> roles = roleDetails.get(i);
										%>
											<tr>
												<td><%=roles.get("ROLETYPE") == null ? "": roles.get("ROLETYPE")%></td>
												<td><%=roles.get("ROLE") == null ? "": roles.get("ROLE")%></td>
												<td><%=roles.get("OCCUPATIONNAME") == null ? "": roles.get("OCCUPATIONNAME")%></td>
												<td><%=roles.get("ROLESINCEDD") == null ? "": roles.get("ROLESINCEDD")%>-<%=roles.get("ROLESINCEMM") == null ? "": roles.get("ROLESINCEMM")%>-<%=roles.get("ROLESINCEYY") == null ? "": roles.get("ROLESINCEYY")%></td>
												<td><%=roles.get("ROLETODD") == null ? "": roles.get("ROLETODD")%>-<%=roles.get("ROLETOMM") == null ? "": roles.get("ROLETOMM")%>-<%=roles.get("ROLETOYY") == null ? "": roles.get("ROLETOYY")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Date Details</td>
							<td>
								<table class="table">
									<tr>
										<td class="coldesc">Date Type</td>
										<td class="coldesc">Date</td>
									</tr>
									<%
									for(int i = 0; i < dateDetails.size(); i++){
										Map<String, String> dates = dateDetails.get(i);
										%>
											<tr>
												<td><%=dates.get("DATETYPE") == null ? "": dates.get("DATETYPE")%></td>
												<td><%=dates.get("DATEVALUE") == null ? "": dates.get("DATEVALUE")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
							<td>&nbsp;</td>
							<td class="tabledesc">Birth Place</td>
							<td>
								<%
									for(int i = 0; i < birthPlace.size(); i++){
										Map<String, String> place = birthPlace.get(i);
										%>
										<%=place.get("BIRTHPLACE")%><br/>
										<%
									}
									%>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Sanction Reference</td>
							<td colspan="4">
								<table class="table">
									<tr>
										<td class="coldesc">References</td>
										<td class="coldesc">Since</td>
										<td class="coldesc">To</td>
									</tr>
									<%
									for(int i = 0; i < sancRef.size(); i++){
										Map<String, String> ref = sancRef.get(i);
										%>
											<tr>
												<td><%=ref.get("REFERENCE") == null ? "": ref.get("REFERENCE")%></td>
												<td><%=ref.get("SINCEDD") == null ? "": ref.get("SINCEDD")%>-<%=ref.get("SINCEMM") == null ? "": ref.get("SINCEMM")%>-<%=ref.get("SINCEYY") == null ? "": ref.get("SINCEYY")%></td>
												<td><%=ref.get("TODD") == null ? "": ref.get("TODD")%>-<%=ref.get("TOMM") == null ? "": ref.get("TOMM")%>-<%=ref.get("TOYY") == null ? "": ref.get("TOYY")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Address Details</td>
							<td colspan="4">
								<table class="table">
									<tr>
										<td class="coldesc">Line</td>
										<td class="coldesc">City</td>
										<td class="coldesc">Country</td>
										<td class="coldesc">URL</td>
									</tr>
									<%
									for(int i = 0; i < address.size(); i++){
										Map<String, String> addr = address.get(i);
										%>
											<tr>
												<td><%=addr.get("LINE") == null ? "": addr.get("LINE")%></td>
												<td><%=addr.get("CITY") == null ? "": addr.get("CITY")%></td>
												<td><%=addr.get("COUNTRY") == null ? "": addr.get("COUNTRY")%></td>
												<td><%=addr.get("URL") == null ? "": addr.get("URL")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Country Details</td>
							<td>
								<table class="table">
									<tr>
										<td class="coldesc">Type</td>
										<td class="coldesc">Name</td>
									</tr>
									<%
									for(int i = 0; i < country.size(); i++){
										Map<String, String> cnty = country.get(i);
										%>
											<tr>
												<td><%=cnty.get("COUNTRYTYPE") == null ? "": cnty.get("COUNTRYTYPE")%></td>
												<td><%=cnty.get("COUNTRYNAME") == null ? "": cnty.get("COUNTRYTYPE")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
							<td>&nbsp;</td>
							<td class="tabledesc">ID Details</td>
							<td>
								<table class="table">
									<tr>
										<td class="coldesc">Type</td>
										<td class="coldesc">ID Number</td>
									</tr>
									<%
									for(int i = 0; i < idDetails.size(); i++){
										Map<String, String> ids = idDetails.get(i);
										%>
											<tr>
												<td><%=ids.get("IDTYPE") == null ? "": ids.get("IDTYPE")%></td>
												<td><%=ids.get("IDVALUE") == null ? "": ids.get("IDVALUE")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Source Description</td>
							<td colspan="4">
								<table class="table">
									<%
									for(int i = 0; i < sourceDesc.size(); i++){
										Map<String, String> srcDesc = sourceDesc.get(i);
										%>
											<tr>
												<td><%=srcDesc.get("SOURCE") == null ? "": srcDesc.get("SOURCE")%></td>
											</tr>
										<%
									}
									%>
								</table>
								
							</td>
						</tr>
						<tr>
							<td class="tabledesc">Entity Company Details</td>
							<td>
								<table class="table">
									<tr>
										<td class="coldesc">Line</td>
										<td class="coldesc">City</td>
										<td class="coldesc">Country</td>
										<td class="coldesc">URL</td>
									</tr>
									<%
									for(int i = 0; i < entityCompany.size(); i++){
										Map<String, String> company = entityCompany.get(i);
										%>
											<tr>
												<td><%=company.get("LINE") == null ? "": company.get("LINE")%></td>
												<td><%=company.get("CITY") == null ? "": company.get("CITY")%></td>
												<td><%=company.get("COUNTRY") == null ? "": company.get("COUNTRY")%></td>
												<td><%=company.get("URL") == null ? "": company.get("URL")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
							<td>&nbsp;</td>
							<td class="tabledesc">Entity Vessel Details</td>
							<td>
								<table class="table">
									<tr>
										<td class="coldesc">Call Sign</td>
										<td class="coldesc">Type</td>
										<td class="coldesc">Tonnage</td>
										<td class="coldesc">GRT</td>
										<td class="coldesc">Owner</td>
										<td class="coldesc">Flag</td>
									</tr>
									<%
									for(int i = 0; i < entityVessel.size(); i++){
										Map<String, String> vessel = entityVessel.get(i);
										%>
											<tr>
												<td><%=vessel.get("VESSELCALLSIGN") == null ? "": vessel.get("VESSELCALLSIGN")%></td>
												<td><%=vessel.get("VESSELTYPE") == null ? "": vessel.get("VESSELTYPE")%></td>
												<td><%=vessel.get("VESSELTONNAGE") == null ? "": vessel.get("VESSELTONNAGE")%></td>
												<td><%=vessel.get("VESSELGRT") == null ? "": vessel.get("VESSELGRT")%></td>
												<td><%=vessel.get("VESSELOWNER") == null ? "": vessel.get("VESSELOWNER")%></td>
												<td><%=vessel.get("VESSELFLAG") == null ? "": vessel.get("VESSELFLAG")%></td>
											</tr>
										<%
									}
									%>
								</table>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
	</div>
</body>
</html>