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
	String[] strAccountNoArray 			= null;
	String[] strAccountNameArray 			= null;
	String[] strAccountDataTypeArray		= null;
	
	int intNoOfAccounts=0;
	int intRecordsCount = 0;

	if(objManualDetailsVO!=null){
		intNoOfAccounts = objManualDetailsVO.getNoOfAcctRec();
		intRecordsCount = intNoOfAccounts;
		 
		if(intNoOfAccounts < 5)
			intNoOfAccounts = 5;
		
		
		strAccountNoArray 			= new String[intNoOfAccounts];
	    strAccountNameArray 		= new String[intNoOfAccounts];
	    strAccountDataTypeArray	= new String[intNoOfAccounts]; 
		
		if(intRecordsCount > 0)
		{
		 for(int i=0; i<objManualDetailsVO.getAcctNoLinkedToTrans().length; i++)
		 {
		  strAccountNoArray[i] 			= objManualDetailsVO.getAcctNoLinkedToTrans()[i];
		  strAccountNameArray[i] 			= objManualDetailsVO.getAcctNameLinkedToTrans()[i];
		  strAccountDataTypeArray[i]		= objManualDetailsVO.getDataTypeForAccount()[i];
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
function addNewAccount()
{
var l_strAlertNo = '<%= a_strAlertNo%>';
// var win= window.open('<%=contextPath%>/IndianRegulatoryReport/str/addAccountDetails.jsp?l_strAlertNo='+l_strAlertNo,'NEWANNEXUREC',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
var win= window.open('<%=contextPath%>/common/addNewAccountDetails?l_strAlertNo='+l_strAlertNo,'NEWANNEXUREC',"top=150, height=600, width=800,scrollbars=yes,toolbar=yes,resizable=yes,location=no");
}
function updateAccountDetails(strAcctName,strAcctNO,strAnnexure)
{
callfrom = '';//document.form1.CallFrom.value;
acctName = strAcctName;
accountNo = strAcctNO;
annexure = strAnnexure;

var l_strAlertNo = '<%= a_strAlertNo%>';
window.open('<%=contextPath%>/common/getNewINDSTRAccounts?UpdateAccts=true&accountNo='+accountNo+'&CustName='+acctName+'&annexure='+annexure+'&CallFrom='+callfrom,'ANNEXUREC','top=150, height=600, width=750,scrollbars=yes,toolbar=yes,location=no,resizable=yes');
}

function deleteAccountDetails(strAcctName,strAcctNO,strAnnexure,strDataType)
{
callfrom = '';//document.form1.CallFrom.value;
acctName = strAcctName;
accountNo = strAcctNO;
annexure = strAnnexure;
dataType = strDataType;
var conf=confirm('Do you want to delete the data?'); 
if(conf)
{	
	this.parent.location.replace('<%=contextPath%>/common/deleteNewINDSTRAccounts?indvName='+acctName+'&acctNo='+accountNo+'&dataType='+dataType+'&CallFrom='+callfrom);
}
}

function exportAccountTxnDetails(strAcctName,strAcctNO,strAnnexure,strDataType)
{
callfrom = '';//document.form1.CallFrom.value;
acctName = strAcctName;
accountNo = strAcctNO;
annexure = strAnnexure;
dataType = strDataType;
var generationType = "exportExcel";
window.open("${pageContext.request.contextPath}/common/exportAccountTxnDetails?indvName="+acctName+"&acctNo="+accountNo+"&dataType="+dataType+"&CallFrom="+callfrom+"&generationType="+generationType);
/*
if(confirm("Are you sure you want to Generate Report?")){
	$.ajax({
		url: "${pageContext.request.contextPath}/common/exportAccountTxnDetails" ,
		cache: false,
		data: "indvName="+acctName+"&acctNo="+accountNo+"&dataType="+dataType+"&CallFrom="+callfrom+"&generationType="+generationType,
		type: 'GET',
		success: function(res){
		},
		error: function(a,b,c){
			alert(a+b+c);
		}
	});
}
*/

}
		
-->
</script>


<div class="section">
	<div class="mainHeader">
	6. List of Related Accounts
	<div class="addButton">
		<input type="button" value="Add New Account" <%if(canUpdated.equals("N")){%> disabled <%}%> onclick="addNewAccount()"/>
	</div>
	</div>
	<table class="info-table">
		<tr>
			<th width="7%">&nbsp;</th>
			<th width="20%">Account Number</th>
			<th width="50%">Name Of First Account Holder</th>
			<th width="13%">Annexure</th>
			<th width="10%">&nbsp;</th>
		</tr>
        <%
	    for(int i=0; i < intNoOfAccounts; i++){ 
		if(strAccountDataTypeArray!=null && strAccountDataTypeArray[i]!=null && strAccountDataTypeArray[i].equalsIgnoreCase("M"))		
		{	
		%>
	   <tr>
			<th>6.<%=i+1%></th>
			<td><input type="text" readonly name="accountNumber1" value="<%= (strAccountNoArray[i] == null) ? "" : strAccountNoArray[i]  %>" /></td>
			<td><input type="text" readonly name="firstAccountHolder1" value="<%= (strAccountNameArray[i] == null) ? "" : strAccountNameArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>ACC</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:""%></li>
				</ul>
			</td>
			<td style="text-align : center;">
				<a href="#1" onclick="updateAccountDetails('<%=strAccountNameArray[i]%>','<%=strAccountNoArray[i]%>','<%=i+1%>')"><img alt="update details" title="Update Details" src="${pageContext.request.contextPath}/includes/images/edit.png"/></a>
				<a href="#1" onclick="deleteAccountDetails('<%=strAccountNameArray[i]%>','<%=strAccountNoArray[i]%>','<%=i+1%>','M')"><img alt="delete details" title="Delete Details" src="${pageContext.request.contextPath}/includes/images/delete.png"/></a>
				<a href="#1" onclick="exportAccountTxnDetails('<%=strAccountNameArray[i]%>','<%=strAccountNoArray[i]%>','<%=i+1%>','A')"><img alt="Export Transactions" title="Export Transactions" src="${pageContext.request.contextPath}/includes/images/export.png"/></a>
			</td>
		</tr>
		<% }
		else if(strAccountDataTypeArray!=null && strAccountDataTypeArray[i]!=null && strAccountDataTypeArray[i].equalsIgnoreCase("A"))	
		{
		%>
		<tr>
			<th>6.<%=i+1%></th>
			<td><input type="text" readonly name="accountNumber1" value="<%= (strAccountNoArray[i] == null) ? "" : strAccountNoArray[i]  %>" /></td>
			<td><input type="text" readonly name="firstAccountHolder1" value="<%= (strAccountNameArray[i] == null) ? "" : strAccountNameArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>ACC</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:"&nbsp;&nbsp;"%></li>
				</ul>
			</td>
			<!--<td class="leftAligned"></td>-->
			<td style="text-align : center;">
				<a href="#1" onclick="deleteAccountDetails('<%=strAccountNameArray[i]%>','<%=strAccountNoArray[i]%>','<%=i+1%>','A')"><img alt="delete details" title="Delete Details" src="${pageContext.request.contextPath}/includes/images/delete.png"/></a>
				<a href="#1" onclick="exportAccountTxnDetails('<%=strAccountNameArray[i]%>','<%=strAccountNoArray[i]%>','<%=i+1%>','A')"><img alt="Export Transactions" title="Export Transactions" src="${pageContext.request.contextPath}/includes/images/export.png"/></a>
			</td>
		</tr>
		<% }
		else
		{
		%>
		<tr>
			<th>6.<%=i+1%></th>
			<td><input type="text" readonly name="accountNumber1" value="<%= (strAccountNoArray[i] == null) ? "" : strAccountNoArray[i]  %>" /></td>
			<td><input type="text" readonly name="firstAccountHolder1" value="<%= (strAccountNameArray[i] == null) ? "" : strAccountNameArray[i]  %>" /></td>
			<td style="text-align : center;">
				<ul class="box">
					<li>ACC</li>
					<li class="last"><%=(i+1) <= intRecordsCount ? i+1:"&nbsp;&nbsp;"%></li>
				</ul>
			</td>
			<td class="leftAligned"></td>
		</tr>
		<% } } %>
	</table>
</div>
<%}catch(Exception e){e.printStackTrace();}%>