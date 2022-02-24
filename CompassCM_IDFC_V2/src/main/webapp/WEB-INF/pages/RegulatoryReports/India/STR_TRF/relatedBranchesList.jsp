<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india_STR_TRF.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<%
HttpSession l_CHttpSession = request.getSession(true);
String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");
//String caseNo = request.getParameter("caseNo").toString();
String contextPath = request.getContextPath()==null?"":request.getContextPath();
%>
<%
try
{
ISTRTRFManualDetailsVO objManualDetailsVO = (ISTRTRFManualDetailsVO)request.getAttribute("ManualFormDTO");
	String[] strBranchSeqNoArray 			= null;
	String[] strBranchRefNoArray 			= null;
	String[] strBranchNameArray 			= null;
	String[] strBranchDataTypeArray			= null;

	int intNoOfBranches = 0;
    int intRecordsCount = 0;

if(objManualDetailsVO!=null){
	intNoOfBranches = objManualDetailsVO.getNoOfBranchRec();
	intRecordsCount = intNoOfBranches; 
	
	if(intNoOfBranches < 5)
	   intNoOfBranches = 5;
		
	 strBranchSeqNoArray 			= new String[intNoOfBranches];
	 strBranchRefNoArray 			= new String[intNoOfBranches];
	 strBranchNameArray 			= new String[intNoOfBranches];
	 strBranchDataTypeArray	    	= new String[intNoOfBranches];
	 
	if(intRecordsCount > 0)
	{
	 for(int i=0; i<objManualDetailsVO.getBranchRefNo().length; i++)
	 {	
	  strBranchSeqNoArray[i]         = objManualDetailsVO.getBranchSeqNo()[i];	 
	  strBranchRefNoArray[i]         = objManualDetailsVO.getBranchRefNo()[i];
	  strBranchNameArray[i] 	 	 = objManualDetailsVO.getBranchName()[i];
	  strBranchDataTypeArray[i]      = objManualDetailsVO.getDataTypeForBranch()[i];
	 }
	}  
}
String l_disable =(String) request.getAttribute("disable");
%>
<script language="javascript">
<!--
var branchName;
var branchRefNo;
var annexure;
var callfrom;
function addNewBranch()
{
var caseNo = '<%= caseNo%>';
var win= window.open('<%=contextPath%>/common/addNewBranchDetails?caseNo='+caseNo,'NEWANNEXUREC',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}
function updateBranchDetails(strBranchName,strBranchRefNo,strBranchSeqNo,strAnnexure)
{
callfrom = '';//document.form1.CallFrom.value;
branchName = strBranchName;
branchRefNo = strBranchRefNo;
annexure = strAnnexure;
branchSeqNo = strBranchSeqNo;
//alert(branchSeqNo);

var caseNo = '<%= caseNo%>';
<%-- window.open('<%=contextPath%>/common/getNewINDSTRTRFBranches?UpdateBranches=true&branchRefNo='+branchRefNo+'&branchName='+branchName+'&annexure='+annexure+'&CallFrom='+callfrom,'ANNEXUREC','top=150, height=600, width=750,scrollbars=yes,toolbar=yes,location=no,resizable=yes');
 --%>
 window.open('<%=contextPath%>/common/getNewINDSTRTRFBranches?branchRefNo='+branchRefNo+'&branchName='+branchName+'&branchSeqNo='+branchSeqNo+'&annexure='+annexure+'&CallFrom='+callfrom,'ANNEXUREA','top=150, height=600, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no');
}

function deleteBranchDetails(strBranchName,strBranchRefNo,strBranchSeqNo,strAnnexure,strDataType)
{
callfrom = '';//document.form1.CallFrom.value;
branchName = strBranchName;
branchRefNo = strBranchRefNo;
annexure = strAnnexure;
dataType = strDataType;
branchSeqNo = strBranchSeqNo;
var conf=confirm('Do you want to delete the data?'); 
if(conf)
{	
	this.parent.location.replace('<%=contextPath%>/common/deleteNewINDSTRTRFBranches?branchName='+branchName+'&branchSeqNo='+branchSeqNo+'&branchRefNo='+branchRefNo+'&dataType='+dataType+'&CallFrom='+callfrom);
}
}
-->
</script>


<div class="section">
	<div class="mainHeader">
	5. List of Branches / Locations Related to Transactions
	<div class="addButton">
		<input type="button" value="Add New Branch / Location" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="addNewBranch()"/>
	</div>
	</div>
	<table class="info-table">
		<tr>
			<th width="7%">&nbsp;</th>
			<th width="50%">Name of Institution</th>
			<th width="20%">Branch Reference Number</th>
			<th width="13%">Annexure</th>
			<th width="10%">&nbsp;</th>
		</tr>
	<% for(int i=0; i < intNoOfBranches; i++){ 
	 	if(strBranchDataTypeArray!=null && strBranchDataTypeArray[i]!=null && strBranchDataTypeArray[i].equalsIgnoreCase("M"))
		{
		%>
		<tr>
			<th>5.<%=i+1%></th>
			<td><input type="text" readonly name="nameOfInstitution1" value="<%= (strBranchNameArray[i] == null) ? "" : strBranchNameArray[i]  %>" /></td>
			<td><input type="text" readonly name="branchRefNo1" value="<%= (strBranchRefNoArray[i] == null) ? "" : strBranchRefNoArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>BRC</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:""%></li>
				</ul>
			</td>
			<td style="text-align : center;" <%if(canUpdated.equals("N")){%> hidden="hidden" <%}%> >
				<a href="#1" onclick="updateBranchDetails('<%=strBranchNameArray[i]%>','<%=strBranchRefNoArray[i]%>','<%=strBranchSeqNoArray[i]%>','<%=i+1%>')"><img alt="update details" title="Update Details" src="${pageContext.request.contextPath}/includes/images/edit.png"/></a>
				<a href="#1" onclick="deleteBranchDetails('<%=strBranchNameArray[i]%>','<%=strBranchRefNoArray[i]%>','<%=strBranchSeqNoArray[i]%>','<%=i+1%>')"><img alt="delete details" title="Delete Details" src="${pageContext.request.contextPath}/includes/images/delete.png"/></a>
			</td>
		</tr>
		<% }
		else
		{
		%>
		<tr>
			<th>5.<%=i+1%></th>
			<td><input type="text" readonly name="nameOfInstitution1" value="<%= (strBranchNameArray[i] == null) ? "" : strBranchNameArray[i]  %>" /></td>
			<td><input type="text" readonly name="branchRefNo1" value="<%= (strBranchRefNoArray[i] == null) ? "" : strBranchRefNoArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>BRC</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:"&nbsp;&nbsp;"%></li>
				</ul>
			</td>
			<td class="leftAligned"></td>
		</tr>
		<% } } %>
	</table>
</div>
<%}catch(Exception e){e.printStackTrace();}%>
