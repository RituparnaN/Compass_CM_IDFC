<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<%
HttpSession l_CHttpSession = request.getSession(true);
String a_strAlertNo = request.getParameter("l_strAlertNo") == null?(String)l_CHttpSession.getAttribute("alertNo"):request.getParameter("l_strAlertNo").toString();
String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
//String a_strAlertNo = request.getParameter("l_strAlertNo").toString();
String contextPath = request.getContextPath()==null?"":request.getContextPath();
%>
<%
try
{
ISTRManualDetailsVO objManualDetailsVO = (ISTRManualDetailsVO)request.getAttribute("ManualFormDTO");
String[] strEntitiesNameArray 		= null;
String[] strEntitiesIdArray 		= null;
String[] strEntitiesAccountNoArray 	= null;
String[] strEntitiesDataTypeArray	= null;
int intNoOfEntities = 0;
int intRecordsCount = 0;

if(objManualDetailsVO!=null){
	intNoOfEntities = objManualDetailsVO.getNoOfLegalRec();
	intRecordsCount = intNoOfEntities; 
	
	if(intNoOfEntities < 5)
	   intNoOfEntities = 5;
		
	 strEntitiesNameArray 			= new String[intNoOfEntities];
	 strEntitiesIdArray 			= new String[intNoOfEntities];
	 strEntitiesAccountNoArray      = new String[intNoOfEntities];
	 strEntitiesDataTypeArray	    = new String[intNoOfEntities];
	 
	if(intRecordsCount > 0)
	{
	 for(int i=0; i<objManualDetailsVO.getLegalId().length; i++)
	 {	
	  strEntitiesNameArray[i] 		   = objManualDetailsVO.getLegalName()[i];
	  strEntitiesIdArray[i] 	       = objManualDetailsVO.getLegalId()[i];
	  strEntitiesAccountNoArray[i]     = objManualDetailsVO.getLegalAccountNo()[i];
	  strEntitiesDataTypeArray[i]      = objManualDetailsVO.getDataTypeForLegal()[i];
	 }
	}  
}
String l_disable =(String) request.getAttribute("disable");
%>
<script language="javascript">
<!--
var custName;
var custID;
var accountNo;
var annexure;
var callfrom;
function addNewLegal()
{
var l_strAlertNo = '<%= a_strAlertNo%>';
// var win= window.open('<%=contextPath%>/IndianRegulatoryReport/str/addLegalDetails.jsp?l_strAlertNo='+l_strAlertNo,'NEWANNEXUREB',"top=150, height=600, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
var win= window.open('<%=contextPath%>/common/addNewLegalDetails?l_strAlertNo='+l_strAlertNo,'NEWANNEXUREB',"top=150, height=600, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}
function updateLegalDetails(strAcctNo, strName,strID,strAnnexure)
{
callfrom = '';//document.form1.CallFrom.value;
custName = strName;
custID = strID;
annexure = strAnnexure;

var l_strAlertNo = '<%= a_strAlertNo%>';
window.open('<%=contextPath%>/common/getNewINDSTREntities?alertNo='+l_strAlertNo+'&legalAcctNo='+strAcctNo+'&legalName='+custName+'&legalId='+custID+'&annexure='+annexure+'&CallFrom='+callfrom,'ANNEXUREB','top=150, height=600, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no');
}

function deleteLegalDetails(strAcctNo, strName,strID,strAnnexure)
{
callfrom = '';//document.form1.CallFrom.value;
custName = strName;
custID = strID;
annexure = strAnnexure;
var l_strAlertNo = '<%= a_strAlertNo%>';

var conf=confirm('Do you want to delete the data?'); 
if(conf)
{	
	this.parent.location.replace('<%=contextPath%>/common/deleteNewINDSTREntities?alertNo='+l_strAlertNo+'&legalAcctNo='+strAcctNo+'&legalName='+custName+'&legalId='+custID+'&CallFrom='+callfrom);
}
}
-->
</script>


<div class="section">
	<div class="mainHeader">
	5. List of Related Legal Persons / Entities
	<div class="addButton">
		<input type="button" value="Add New Legal Person / Entity" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="addNewLegal()"/>
	</div>
	</div>
	<table class="info-table">
		<tr>
			<th width="7%">&nbsp;</th>
			<th width="20%">Account No</th>
			<th width="30%">Name of Legal Person / Entity</th>
			<th width="20%">Customer ID</th>
			<th width="13%">Annexure</th>
			<th width="10%">&nbsp;</th>
		</tr>
	<% for(int i=0; i < intNoOfEntities; i++){ 
	 	if(strEntitiesDataTypeArray!=null && strEntitiesDataTypeArray[i]!=null && strEntitiesDataTypeArray[i].equalsIgnoreCase("M"))
		{
		%>
		<tr>
			<th>5.<%=i+1%></th>
			<td><input type="text" readonly name="accountOfIndividual1" value="<%= (strEntitiesAccountNoArray[i] == null) ? "" : strEntitiesAccountNoArray[i]  %>" /></td>
			<td><input type="text" readonly name="nameOfLegalEntity1" value="<%= (strEntitiesNameArray[i] == null) ? "" : strEntitiesNameArray[i]  %>" /></td>
			<td><input type="text" readonly name="customerId11" value="<%= (strEntitiesIdArray[i] == null) ? "" : strEntitiesIdArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>LPE</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:""%></li>
				</ul>
			</td>
			<td style="text-align : center;" <%if(canUpdated.equals("N")){%> hidden="hidden" <%}%> >
				<a href="#1" onclick="updateLegalDetails('<%=strEntitiesAccountNoArray[i]%>','<%=strEntitiesNameArray[i]%>','<%=strEntitiesIdArray[i]%>','<%=i+1%>')"><img alt="update details" title="Update Details" src="${pageContext.request.contextPath}/includes/images/edit.png"/></a>
				<a href="#1" onclick="deleteLegalDetails('<%=strEntitiesAccountNoArray[i]%>','<%=strEntitiesNameArray[i]%>','<%=strEntitiesIdArray[i]%>','<%=i+1%>')"><img alt="delete details" title="Delete Details" src="${pageContext.request.contextPath}/includes/images/delete.png"/></a>
			</td>
		</tr>
		<% }
		else
		{
		%>
		<tr>
			<th>5.<%=i+1%></th>
			<td><input type="text" readonly name="accountOfIndividual1" value="<%= (strEntitiesAccountNoArray[i] == null) ? "" : strEntitiesAccountNoArray[i]  %>" /></td>
			<td><input type="text" readonly name="nameOfLegalEntity1" value="<%= (strEntitiesNameArray[i] == null) ? "" : strEntitiesNameArray[i]  %>" /></td>
			<td><input type="text" readonly name="customerId11" value="<%= (strEntitiesIdArray[i] == null) ? "" : strEntitiesIdArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>LPE</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:"&nbsp;&nbsp;"%></li>
				</ul>
			</td>
			<td class="leftAligned"></td>
		</tr>
		<% } } %>
	</table>
</div>
<%}catch(Exception e){e.printStackTrace();}%>