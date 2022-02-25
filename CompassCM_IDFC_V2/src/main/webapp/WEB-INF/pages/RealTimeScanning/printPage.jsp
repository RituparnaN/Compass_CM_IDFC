<%@page import="java.util.*,com.quantumdataengines.app.compass.model.scanning.RTMatchResultVO"%>
<%@ include file="../tags/tags.jsp"%>
<%-- <%@ include file="../tags/staticFiles.jsp" %> --%>
<script type="text/javascript" src="${pageContext.request.contextPath}/includes/scripts/html2canvas.js"></script>
<% 
String contextPath = request.getContextPath()==null?"":request.getContextPath();
LinkedHashMap lnkHashMapSearchResult = null;
String l_strFurtherInfo = "";
int totalRecords = 0;
ArrayList resultedRecords = new ArrayList();
RTMatchResultVO objRTMatchResultVO = null;
int counter = 0;
String l_strKey ="";
String LOGGEDUSER = request.getAttribute("LOGGEDUSER").toString();
Date trialTime = new Date(); 

if(request.getAttribute("PrintRecords") != null)
{
	lnkHashMapSearchResult = (LinkedHashMap)request.getAttribute("PrintRecords");
}
if(lnkHashMapSearchResult.get("ResultedRecords") != null)
	resultedRecords=(ArrayList)lnkHashMapSearchResult.get("ResultedRecords");
if(request.getAttribute("counter") != null)
	counter= Integer.parseInt((String)request.getAttribute("counter"));
if(lnkHashMapSearchResult.get("TotalRecords") != null)
	totalRecords=((Integer)lnkHashMapSearchResult.get("TotalRecords")).intValue();

//System.out.println("resultedRecords = "+resultedRecords);

%>
<HTML>
	<HEAD>
		<TITLE>
			Print Match Details
		</TITLE>
<style>
.rightMainSearch {		
		background-color: #606062;
}

.forContentSearch {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	background-color: #F2F2F1;
	padding-left: 10px;
}
.but1 {  font-size: 10px; color: #000000; text-align: center; background-color: #F2F2F1; background-repeat: no-repeat;height: 17px; width: 140px;border: 1px #000000 solid; clip:  rect(   )}

table{
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
	
}

</style>
<script language='javascript'>
<!--
function goNext(key)
{
var counter = '<%=counter%>';
counter = 3;
window.open('<%=contextPath%>/printpage?key='+key+'&counter='+counter,'','width=1000,height=680,left=0,top=0,screenX=250,screenY=300,OuterWidth=370,OuterHeight=150,toolbar=yes,location=no,resizable=yes, scrollbars=yes');
}
-->
function printDetails(divName){
	var printContents = document.getElementById(divName).innerHTML;
	//alert(printContents);
	w=window.open();
	w.document.write(printContents);
	w.print();
	w.close();
}

function downloadTIFF(divName){
	window.scrollTo(0,0);
	html2canvas(document.getElementById(divName))
    .then(function(canvas){
        dataurl = canvas.toDataURL('image/tiff',0.92);
        var img = new Image();
        img.src = dataurl;
        //document.body.appendChild(img);
        var downButton = document.createElement('a');
        downButton.href = dataurl;
        downButton.innerHTML = 'download result';
        downButton.download = 'MatchDetails.tiff';
       // document.body.appendChild(downButton);
        downButton.click();
   });
}

</script>
 
	</HEAD>
	
      <BODY  bgcolor="#F2F2F1" >  
	
		<FORM METHOD='POST'>
		<div id="resultDiv">
		<c:if test="${FromBulkScreening eq 'N'}">
			<%
			if(resultedRecords == null || resultedRecords.size() == 0)
			{
			%>
				<B><U><font  face="verdana" size=2 align='right'><b>Dated On : <%=trialTime%></b></U>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<U></font><font  face="verdana" size=2 align='right'><b>UserCode : <%=LOGGEDUSER %> </b></U></font></B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</br>
				<BR><BR>
			<%}%>
			
			<table class="table table-bordered table-striped " border=1 width="100%" cellspacing="1" cellpadding="2" >
				<tr>
					<th class="info">FieldName</th>
					<th class="info">FieldValue</th>
					<th class="info">IsMatchFound</th>
				</tr>
				<c:forEach var="fieldScanSummaryDetail" items="${FieldScanSummaryDetails}">
					<tr>
						<td>${fieldScanSummaryDetail['FIELDNAME']}</td>
						<td>${fieldScanSummaryDetail['FIELDVALUE']}</td>
						<td>
							<c:choose>
								<c:when test="${fieldScanSummaryDetail['COUNTOFMATCHES'] eq 0}">No</c:when>
								<c:otherwise>Yes</c:otherwise>
							</c:choose>
						</td>  
					</tr>
				</c:forEach>
			</table>
		</c:if>
<%
if(resultedRecords != null && resultedRecords.size() > 0)
{
	String strCustomerName = "";
	for(int l_intSize = 0; l_intSize < resultedRecords.size();l_intSize++)
	{
    objRTMatchResultVO = (RTMatchResultVO) resultedRecords.get(l_intSize);	
	
	String strSourceInfoField = objRTMatchResultVO.getSourceInfo();
	if(!(objRTMatchResultVO.getCustomerName().trim()+strSourceInfoField).equals(strCustomerName+"")) {
%>
	<div id="entriesDiv">
		<B><U><font face="verdana" size="2"></br>Source Name : <%=strSourceInfoField.substring(strSourceInfoField.indexOf("~")+1,strSourceInfoField.length())%></font></U>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<U><font  face="verdana" size=2 align='right'><b>Dated On : <%=trialTime%></b></U>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<U></font><font  face="verdana" size=2 align='right'><b>UserCode : <%=LOGGEDUSER %> </b></U></font></B>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</br>
		<U><font  face="verdana" size=2 align='right'><B>Serial No : <%=objRTMatchResultVO.getCustomerName().trim()%></B></font></U>
		<BR><BR>
	   <% }	
		strCustomerName = objRTMatchResultVO.getCustomerName().trim()+strSourceInfoField;
		%>
	   <TABLE id="tableid" BORDER=0 cellspacing="1" cellpadding="2" bgcolor="#606062">
	   <tr><td><font face="verdana" size="2" color="white"><b>Black List Details : </b></font></td><td><font face="verdana" size="2" color="white"><B></font></td></tr>
	   <TR  bordercolor="black" bgcolor="#F2F2F1">
	   <TD  nowrap width='150'><font face="verdana" size="2">ListName</font></TD>
	   <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=objRTMatchResultVO.getListName()%></b></font></TD>
	   </tr>
	   <TR  bordercolor="black" bgcolor="#F2F2F1">
	   <TD  nowrap width='150'><font face="verdana" size="2">ListId</font></TD>
	   <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=objRTMatchResultVO.getListId()%></b></font></TD>
	   </tr>
	   <TR  bordercolor="black" bgcolor="#F2F2F1">
	   <TD  nowrap width='150'><font face="verdana" size="2">MatchScore</font></TD>
	   <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=objRTMatchResultVO.getRank()%></b></font></TD>
	   </tr>
	   <TR  bordercolor="black" bgcolor="#F2F2F1">
	   <TD  nowrap width='150'><font face="verdana" size="2">MatchedInfo</font></TD>
	   <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=objRTMatchResultVO.getMatchedInfo()%></b></font></TD>
	   </tr>
	   <TR  bordercolor="black" bgcolor="#F2F2F1">
	   <TD  nowrap width='150'><font face="verdana" size="2">MatchedDate</font></TD>
	   <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=objRTMatchResultVO.getMatchDate()%></b></font></TD>
	   </tr>
	   <TR  bordercolor="black" bgcolor="#F2F2F1">
	   <TD  nowrap width='150'><font face="verdana" size="2">Comments</font></TD>
	   <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=objRTMatchResultVO.getComments()==null?"":objRTMatchResultVO.getComments()%></b></font></TD>
	   </tr>
	   <TR  bordercolor="black" bgcolor="#F2F2F1">
	   <TD  nowrap width='150'><font face="verdana" size="2">Status</font></TD>
	   <TD align='left' wrap width='850'><font face="verdana" size="2"><b><%=objRTMatchResultVO.getStatus()%></b></font></TD>
	   </tr>

		</table>	
		<%}} else { %>
			<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#606062">
		<tr>
		<td>
		<!-- <div class="span1">
			<font  face="verdana" size=2 align='center'><b>No Processed Records</b></font>
		</div>	 -->
		</td>
		</tr>
		</table>
		<%}%>
		<BR><BR>
	</div>
	</div>
		<table border=0 width="100%">
			<tr>
				<td align="center" colspan="7">
			    	<input type='button' name='Print' value='PRINT' class="but1" onClick="printDetails('resultDiv');">
					<!--<INPUT TYPE='button' NAME='Print' VALUE='PRINT' class="but1" onClick="javascript:window.print();">-->
					<input type='button' name='Download TIFF' value='Download TIFF' class="but1" onClick="downloadTIFF('resultDiv');">
					<INPUT TYPE='button' NAME='Close' VALUE='CLOSE' class="but1" onClick="window.close();">
				</td>
			</tr>
		<table>
		</FORM>
	</BODY>
</HTML>
