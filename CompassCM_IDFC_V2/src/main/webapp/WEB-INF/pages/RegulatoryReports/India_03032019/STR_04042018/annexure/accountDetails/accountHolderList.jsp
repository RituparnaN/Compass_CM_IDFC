<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<%@ page import = "java.util.HashMap, com.quantumdataengines.app.compass.model.regulatoryReports.india.*" %>
<%@ page import="java.io.*,java.text.SimpleDateFormat" %>
<% try{
	String contextPath = request.getContextPath()==null?"":request.getContextPath();
	ISTRAccountDetailsVO objAccountDetailsVO = (ISTRAccountDetailsVO)request.getAttribute("AnnexC_AcctDetailsDTO");
	String strAnnexureNo = (String)request.getAttribute("AnnCNo");
	String strBankName 							= "";
	String strBranchBSRcode 					= "";
	String strBranchAddress 					= "";
	String strEnclosedAnnexture 				= "";
	String strAccountNo 						= "";
	String strAccountType 						= "";
	String strAccountHoldertype 				= "";
	String strAccountOpenedDate 				= "";
	String[] strAccountHoldersNameArray 		= new String[25];
	String[] strAccountHoldersIdArray 			= new String[25];
	String[] strAccountHoldersAnnexABArray 		= new String[25];
	String[] strAccountHoldersAnnexNoArray 	    = new String[25];
	boolean[] boolAccountHoldersAnnexFlagArray 	= new boolean[25];
	String[] strRelatedPersonsNameArray 		= new String[25];
	String[] strRelatedPersonsIdArray 			= new String[25];
	String[] strRelatedPersonsRelationArray 	= new String[25];
	String[] strRelatedPersonsAnnexABArray 		= new String[25];
	String[] strRelatedPersonsAnnexNoArray 	    = new String[25];
	boolean[] boolRelatedPersonsAnnexFlagArray 	= new boolean[25];
	String strBranchReferenceNumberType         = "";	 
	
	int AnnxA = 0,AnnxB=0;
	if(objAccountDetailsVO != null){
		strEnclosedAnnexture 			 = (objAccountDetailsVO.getAnnexEnclosed() == null) ? "" : objAccountDetailsVO.getAnnexEnclosed();
		strAccountNo 				     = (objAccountDetailsVO.getAccountNo() == null) ? "" : objAccountDetailsVO.getAccountNo();
		strAccountType 			         = (objAccountDetailsVO.getAccountType() == null) ? "" : objAccountDetailsVO.getAccountType();
		strAccountHoldertype 		     = (objAccountDetailsVO.getAccountHoldertype() == null) ? "" : objAccountDetailsVO.getAccountHoldertype();
		strAccountOpenedDate 			 = (objAccountDetailsVO.getAccountOpenDate() == null) ? "" : objAccountDetailsVO.getAccountOpenDate();
		strAccountHoldersNameArray 		 = objAccountDetailsVO.getListofAccountHoldersName();
		strAccountHoldersIdArray 		 = objAccountDetailsVO.getListofAccountHoldersID();
		strAccountHoldersAnnexABArray 	 = objAccountDetailsVO.getListofAccountHoldersAnnexAB();
		strAccountHoldersAnnexNoArray 	 = objAccountDetailsVO.getListofAccountHoldersAnnexNumber();
		boolAccountHoldersAnnexFlagArray = objAccountDetailsVO.getListofAccountHoldersAnnexFlag();
		strRelatedPersonsNameArray 		 = objAccountDetailsVO.getListofRelatedPersonsName();
		strRelatedPersonsIdArray 		 = objAccountDetailsVO.getListofRelatedPersonsID();
		strRelatedPersonsRelationArray 	 = objAccountDetailsVO.getListofRelatedPersonsRelation();
		strRelatedPersonsAnnexABArray 	 = objAccountDetailsVO.getListofRelatedPersonsAnnexAB();
		strRelatedPersonsAnnexNoArray 	 = objAccountDetailsVO.getListofRelatedPersonsAnnexNumber();
		boolRelatedPersonsAnnexFlagArray = objAccountDetailsVO.getListofRelatedPersonsAnnexFlag();
		strBranchReferenceNumberType     = objAccountDetailsVO.getBranchReferenceNumberType();
		strBranchAddress                 = (objAccountDetailsVO.getBranchAddressLine1() == null ? "":objAccountDetailsVO.getBranchAddressLine1())+
				(objAccountDetailsVO.getBranchAddressLine2() == null ? "": objAccountDetailsVO.getBranchAddressLine2())+
				(objAccountDetailsVO.getBranchAddressLine3() == null ? "": objAccountDetailsVO.getBranchAddressLine3());

	}
	String l_disable =(String) request.getAttribute("disable");
%>

    <div class="section">
	<div class="mainHeader">
	3. List of Account Holders
	</div>
	<table class="info-table">
		<tr>
			<th width="5%">&nbsp;</th>
			<th width="65%">Name of Individual / Legal Person / Entity</th>
			<th width="30%">Customer ID</th>
		</tr>
		<% for(int j=0; j < 10; j++){	%>	
		<tr>
			<th>3.<%=j+1%></th>
			<td><input type="text" readonly name="nameOfIndvLegalEntity1" value="<%= (strAccountHoldersNameArray[j] == null) ? "" : strAccountHoldersNameArray[j] %>"/></td>
			<td><input type="text" readonly name="custId1" value="<%= (strAccountHoldersIdArray[j] == null) ? "" : strAccountHoldersIdArray[j] %>"/></td>
		</tr>
		<!--
		<tr>
			<th>3.1</th>
			<td><input type="text" name="nameOfIndvLegalEntity1"/></td>
			<td><input type="text" name="custId1"/></td>
		</tr>
		<tr>
			<th>3.2</th>
			<td><input type="text" name="nameOfIndvLegalEntity2"/></td>
			<td><input type="text" name="custId2"/></td>
		</tr>
		<tr>
			<th>3.3</th>
			<td><input type="text" name="nameOfIndvLegalEntity3"/></td>
			<td><input type="text" name="custId3"/></td>
		</tr>
		<tr>
			<th>3.4</th>
			<td><input type="text" name="nameOfIndvLegalEntity4"/></td>
			<td><input type="text" name="custId4"/></td>
		</tr>
		<tr>
			<th>3.5</th>
			<td><input type="text" name="nameOfIndvLegalEntity5"/></td>
			<td><input type="text" name="custId5"/></td>
		</tr>
		-->
		<%
		 } 
		%>
	</table>
</div>
<% }catch(Exception e){e.printStackTrace();} %>
