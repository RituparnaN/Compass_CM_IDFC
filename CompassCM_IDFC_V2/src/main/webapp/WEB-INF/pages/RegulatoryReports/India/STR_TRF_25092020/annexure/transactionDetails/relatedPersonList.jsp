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
			objAccountDetailsVO.getBranchAddressLine2() == null ? "":(", "+objAccountDetailsVO.getBranchAddressLine3())+
			objAccountDetailsVO.getBranchAddressLine3() == null ? "":(", "+objAccountDetailsVO.getBranchAddressLine3());
	}
	String l_disable =(String) request.getAttribute("disable");
%>
    
    
   <div class="section">
	<div class="mainHeader">
	4. List of Related Persons
	</div>
	<table class="info-table">
		<tr>
			<th width="5%">&nbsp;</th>
			<th width="30%">Name of Individual / Legal Person / Entity</th>
			<th width="25%">Customer ID</th>
			<th width="30%">Relation</th>
		</tr>
		<% for(int k=0; k<5; k++){	%>	
		<tr>
			<th>4.<%=k+1%></th>
			<td><input type="text" readonly name="nameOfIndvLegalEntityRP1" value="<%= (strRelatedPersonsNameArray[k] == null) ? "" : strRelatedPersonsNameArray[k] %>"/></td>
			<td><input type="text" readonly name="custIdRP1" value="<%= (strRelatedPersonsIdArray[k] == null) ? "" : strRelatedPersonsIdArray[k] %>"/></td>
			<td><input type="text" readonly name="relation1" value="<%= (strRelatedPersonsAnnexABArray[k] == null) ? "" : strRelatedPersonsAnnexABArray[k]%>"/></td>
		</tr>
		<!--
		<tr>
			<th>4.1</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP1"/></td>
			<td><input type="text" name="custIdRP1"/></td>
			<td><input type="text" name="relation1"/></td>
		</tr>
		<tr>
			<th>4.2</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP2"/></td>
			<td><input type="text" name="custIdRP2"/></td>
			<td><input type="text" name="relation2"/></td>
		</tr>
		<tr>
			<th>4.3</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP3"/></td>
			<td><input type="text" name="custIdRP3"/></td>
			<td><input type="text" name="relation3"/></td>
		</tr>
		<tr>
			<th>4.4</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP4"/></td>
			<td><input type="text" name="custIdRP4"/></td>
			<td><input type="text" name="relation4"/></td>
		</tr>
		<tr>
			<th>4.5</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP5"/></td>
			<td><input type="text" name="custIdRP5"/></td>
			<td><input type="text" name="relation5"/></td>
		</tr>
		<tr>
			<th>4.6</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP6"/></td>
			<td><input type="text" name="custIdRP6"/></td>
			<td><input type="text" name="relation6"/></td>
		</tr>
		<tr>
			<th>4.7</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP7"/></td>
			<td><input type="text" name="custIdRP7"/></td>
			<td><input type="text" name="relation7"/></td>
		</tr>
		<tr>
			<th>4.8</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP8"/></td>
			<td><input type="text" name="custIdRP8"/></td>
			<td><input type="text" name="relation8"/></td>
		</tr>
		<tr>
			<th>4.9</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP9"/></td>
			<td><input type="text" name="custIdRP9"/></td>
			<td><input type="text" name="relation9"/></td>
		</tr>
		<tr>
			<th>4.10</th>
			<td><input type="text" name="nameOfIndvLegalEntityRP10"/></td>
			<td><input type="text" name="custIdRP10"/></td>
			<td><input type="text" name="relation10"/></td>
		</tr>
		-->
		<%
		 } 
		%>
	</table>
</div>
<% }catch(Exception e){e.printStackTrace();} %>
