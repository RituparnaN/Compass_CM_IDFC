<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<%try{%>
<%
HttpSession l_CHttpSession = request.getSession(true);
String caseNo = request.getParameter("caseNo") == null?(String)l_CHttpSession.getAttribute("caseNo"):request.getParameter("caseNo").toString();
String canUpdated = l_CHttpSession.getAttribute("canUpdated") == null ?"N":(String)l_CHttpSession.getAttribute("canUpdated");

String contextPath = request.getContextPath()==null?"":request.getContextPath();
%>
<% 
	ISTRManualDetailsVO objManualDetailsVO = (ISTRManualDetailsVO)request.getAttribute("ManualFormDTO");
	String[] strIndividualNameArray 			= null;
	String[] strIndividualIdArray 				= null;
	String[] strCounterAccountArray			    = null; 
	String[] strCounterTypeArray			= null; 		
	String[] strDataTypeArray					= null; 
    int intNoOfIndividuals = 0;
	int intRecordsCount = 0;
	if(objManualDetailsVO!=null){
		intNoOfIndividuals = objManualDetailsVO.getNoOfIndividualRec();
		intRecordsCount = intNoOfIndividuals; 
		if(intNoOfIndividuals < 10)
			intNoOfIndividuals=10;
			
		 strIndividualNameArray 			= new String[intNoOfIndividuals];
	     strIndividualIdArray 				= new String[intNoOfIndividuals];
	     strCounterAccountArray			    = new String[intNoOfIndividuals]; 	
		 strCounterTypeArray	            = new String[intNoOfIndividuals]; 
	     strDataTypeArray					= new String[intNoOfIndividuals];
		
		if(intRecordsCount > 0)
		{
		 for(int i=0; i<objManualDetailsVO.getCounterName().length; i++)
		 {
		  strIndividualNameArray[i] 			= objManualDetailsVO.getCounterName()[i];
		  strIndividualIdArray[i]			    = objManualDetailsVO.getCounterId()[i];
		  strCounterAccountArray[i]			    = objManualDetailsVO.getCounterAcc()[i];  
		  strCounterTypeArray[i]                = objManualDetailsVO.getCounterType()[i];  
		  strDataTypeArray[i]					= objManualDetailsVO.getDataTypeForIndiv()[i];
		 }
		} 
	}
	String strDisableFlag =(String) request.getAttribute("disable");
%>	

<script language="javascript">
<!--
var custName;
var custID;
var accountNo;
var annexure;
var callfrom;
var relationType;

function addNewIndividual()
{
	var caseNo = '<%= caseNo%>';
	//alert('caseNo:  '+caseNo);
	//var win= window.open('<%=contextPath%>/RegulatoryReports/India/STR/addIndividualDetails.jsp?caseNo='+caseNo,'NEWANNEXUREA',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
	var win= window.open('<%=contextPath%>/common/addNewIndividualDetails?caseNo='+caseNo,'NEWANNEXUREA',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}

function updateIndividualDetails(strName,strID,strAcct,strAnnexure)
{
	callfrom = '';//document.form1.CallFrom.value;
	custName = strName;
	custID = strID;
	accountNo = strAcct;	
	annexure = strAnnexure;
	
	var caseNo = '<%= caseNo%>';
	window.open('<%=contextPath%>/common/getNewINDSTRIndividuals?indvName='+custName+'&indvId='+custID+'&acctNo='+accountNo+'&annexure='+annexure+'&CallFrom='+callfrom,'ANNEXUREA','top=150, height=600, width=750,scrollbars=yes,toolbar=yes,resizable=yes,location=no');
}

function deleteIndividualDetails(strName,strID,strAcct,strAnnexure,strRelationType)
{
	callfrom = '';//document.form1.CallFrom.value;
	custName = strName;
	custID = strID;
	accountNo = strAcct;	
	annexure = strAnnexure;
	relationType = strRelationType;
	var conf=confirm('Do you want to delete the data?'); 
	if(conf)
	{	
		this.parent.location.replace('<%=contextPath%>/common/deleteNewINDSTRIndividuals?indvName='+custName+'&indvId='+custID+'&acctNo='+accountNo+'&CallFrom='+callfrom+'&relationType='+relationType);
	}
}
-->
</script>

<div class="section">
	<div class="mainHeader">
	4. List of Related Individuals
	<div class="addButton">
		<input type="button" value="Add New Individual" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="addNewIndividual()"/>
	</div>
	</div>
	<table class="info-table">
		<tr>
			<th width="7%">&nbsp;</th>
			<th width="20%">Account No</th>
			<th width="20%">Name of Individual</th>
			<th width="20%">Customer ID</th>
			<th width="10%">Relation Type</th>
			<th width="13%">Annexure</th>
			<th width="10%">&nbsp;</th>
		</tr>

		<%for(int i=0; i < intNoOfIndividuals; i++){ 
	  	if(strDataTypeArray!=null && strDataTypeArray[i]!=null && strDataTypeArray[i].equalsIgnoreCase("M"))
		{%>
		<tr>
			<th>4.<%=i+1%></th>
			<td><input type="text" readonly name="accountOfIndividual1" value="<%= (strCounterAccountArray[i] == null) ? "" : strCounterAccountArray[i]  %>" /></td>
			<td><input type="text" readonly name="nameOfIndividual1" value="<%= (strIndividualNameArray[i] == null) ? "" : strIndividualNameArray[i]  %>" /></td>
			<td><input type="text" readonly name="customerId1" value="<%= (strIndividualIdArray[i] == null) ? "" : strIndividualIdArray[i]  %>" /></td>
			<td><input type="text" readonly name="customerIdpartyType" value="<%= (strCounterTypeArray[i] == null) ? "" : strCounterTypeArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>INP</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:""%></li>
				</ul>
			</td>
			<td style="text-align : center;" <%if(canUpdated.equals("N")){%> hidden="hidden" <%}%> >
				<a href="#1" onclick="updateIndividualDetails('<%=strIndividualNameArray[i]%>','<%=strIndividualIdArray[i]%>','<%=strCounterAccountArray[i]%>','<%=i+1%>')"><img alt="update details" title="Update Details" src="${pageContext.request.contextPath}/includes/images/edit.png"/></a>
				<a href="#1" onclick="deleteIndividualDetails('<%=strIndividualNameArray[i]%>','<%=strIndividualIdArray[i]%>','<%=strCounterAccountArray[i]%>','<%=i+1%>','<%=strCounterTypeArray[i]%>')"><img alt="delete details" title="Delete Details" src="${pageContext.request.contextPath}/includes/images/delete.png"/></a>
			</td>
		</tr>
		<% }
		else
		{
		%>
		<tr>
			<th>4.<%=i+1%></th>
			<td><input type="text" readonly name="accountOfIndividual1" value="<%= (strCounterAccountArray[i] == null) ? "" : strCounterAccountArray[i]  %>" /></td>
			<td><input type="text" readonly name="nameOfIndividual1" value="<%= (strIndividualNameArray[i] == null) ? "" : strIndividualNameArray[i]  %>" /></td>
			<td><input type="text" readonly name="customerId1" value="<%= (strIndividualIdArray[i] == null) ? "" : strIndividualIdArray[i]  %>" /></td>
			<td><input type="text" readonly name="customerIdpartyType" value="<%= (strCounterTypeArray[i] == null) ? "" : strCounterTypeArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>INP</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:"&nbsp;&nbsp;"%></li>
				</ul>
			</td>
			<td class="leftAligned"></td>
		</tr>
		<% } } %>
	</table>
</div>
<%}catch(Exception e){e.printStackTrace();}%>