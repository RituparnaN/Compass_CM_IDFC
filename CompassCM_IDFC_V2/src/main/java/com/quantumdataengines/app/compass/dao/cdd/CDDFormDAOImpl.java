package com.quantumdataengines.app.compass.dao.cdd;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class CDDFormDAOImpl implements CDDFormDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
	int strLength = 6;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public String createNewCompassRefNo(String branchCode, String formType, int increment){
		String compassRefNo = "";
		int branchCount = 0;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) FROM "+schemaName+"TB_CDDFORM WHERE BRANCHCODE = ?");
			preparedStatement.setString(1, branchCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				branchCount = resultSet.getInt(1)+increment;
			
			preparedStatement = connection.prepareStatement("SELECT LPAD(?,5,0) COMPASSREFNO FROM DUAL");
			preparedStatement.setString(1, new Integer(branchCount).toString());
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				compassRefNo = branchCode+formType+resultSet.getString("COMPASSREFNO");
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return compassRefNo;		
	}
	
	public String finalizeCompassRefNo(String branchCode, String formType){
		int index = 1;
		String compassRefNo = null;
		boolean isFound = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			while(!isFound || compassRefNo == null){
				String tempCompassRefNo = createNewCompassRefNo(branchCode, formType, index);
				preparedStatement = connection.prepareStatement("SELECT COUNT(1) COUNTVAL FROM "+schemaName+"TB_CDDFORM WHERE COMPASSREFNO = ?");
				preparedStatement.setString(1, tempCompassRefNo);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					int COUNTVAL = resultSet.getInt("COUNTVAL");
					if(COUNTVAL == 0){
						compassRefNo = tempCompassRefNo;
						isFound = true;
					}
				}
				index++;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return compassRefNo;
	}
	
	public String startNewCDD(String formType, String compassRefNo, String userBranchCode, String startedBy){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String lineNo = new Integer(getLineNo()).toString();
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDFORM(COMPASSREFNO, FORMTYPE, LINENO, BRANCHCODE, STATUS, STARTEDBY, STARTTIMESTAMP, UPDATEBY, UPDATETIMESTAMP ) "+
															"VALUES (?,?,?,?,?,?,SYSTIMESTAMP, ?, SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, formType);
			preparedStatement.setString(3, lineNo);
			preparedStatement.setString(4, userBranchCode);
			preparedStatement.setString(5, "BPA-P");
			preparedStatement.setString(6, startedBy);
			preparedStatement.setString(7, startedBy);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return lineNo;
	}
	
	public String startReCDD(String FORMTYPE, String COMPASSREFERENCENO, String userBranchCode, String LASTREVIEWDATE, String previousRiskRating, String userCode){
		String newLineNo = new Integer(getLineNo()).toString();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDFORM(COMPASSREFNO, FORMTYPE, LINENO, BRANCHCODE, STATUS, STARTEDBY, STARTTIMESTAMP, UPDATEBY, UPDATETIMESTAMP, LASTREVIEWDATE, PREVIOUSRISKRATING ) "+
															"VALUES (?,?,?,?,?,?,SYSTIMESTAMP, ?, SYSTIMESTAMP, FUN_CHARTODATE(?), ?) ");
			preparedStatement.setString(1, COMPASSREFERENCENO);
			preparedStatement.setString(2, FORMTYPE);
			preparedStatement.setString(3, newLineNo);
			preparedStatement.setString(4, userBranchCode);
			preparedStatement.setString(5, "BPA-P");
			preparedStatement.setString(6, userCode);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, LASTREVIEWDATE);
			preparedStatement.setString(9, previousRiskRating);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return newLineNo;
	}
	
	public void createCDDCheckList(String formType, String compassRefNo, String lineNo){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDCHECKLIST(COMPASSREFNO, FORMTYPE, LINENO) VALUES(?,?,?)");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, formType);
			preparedStatement.setString(3, lineNo);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void cddAuditLog(String compassRefNo, String lineNo, String userCode, String userRole, String currentStatus, String newStatus, String message){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDFORMAUDITLOG(SEQNO, COMPASSREFNO, LINENO, USERCODE, USERROLE, FORMCURRENTSTATUS, FORMUPDATEDSTATUS, UPDATETIMESTAMP, USERCOMMENT) "+
															" VALUES("+schemaName+"SEQ_CDDFORMAUDITLOG.NEXTVAL,?,?,?,?,?,?,SYSTIMESTAMP,?)");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, lineNo);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, userRole);
			preparedStatement.setString(5, currentStatus);
			preparedStatement.setString(6, newStatus);
			preparedStatement.setString(7, message);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public List<Map<String, String>> searchCDD(String compassRefNo, String formType, String ccifNo, String status, String branchCode, String customerName){
		List<Map<String, String>> searchMap = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "SELECT X.* FROM ( "+
			            "SELECT COMPASSREFNO, CASE FORMTYPE WHEN 'INVDNEW' THEN 'New Individual' "+
						"									WHEN 'INVDEXISTING' THEN 'Existing Individual' "+
						"									WHEN 'CORPNEW' THEN 'New Corporate' "+
						"									ELSE 'Existing Corporate' END FORMTYPELONG , "+
						" 		FORMTYPE, LINENO, CUSTOMERID, CASE STATUS WHEN 'BPD-P' THEN 'Pending with BPD Maker' "+
						"												  WHEN 'BPD-A' THEN 'Pending with BPD Checker' "+
						"												  WHEN 'BPA-P' THEN 'Pending with BPA Maker' "+
						"												  WHEN 'BPA-A' THEN 'Pending with BPA Checker' "+						
						"												  WHEN 'COMP-P' THEN 'Pending with Compliance Maker' "+
						"												  WHEN 'COMP-A' THEN 'Pending with Compliance Checker' "+
						"												  WHEN 'JGM' THEN 'Pending with JGM' "+
						"												  WHEN 'GM' THEN 'Pending with GM' "+
						"												  WHEN 'A' THEN 'Approved' "+
						"												  ELSE 'Rejected' END FULLSTATUS, "+
						"		'CDD' CDDSTATUS, STATUS, UPDATEBY, FUN_DATETIMETOCHAR(UPDATETIMESTAMP) UPDATETIMESTAMP, UPDATETIMESTAMP UPDATEDDATE "+
						"  FROM "+schemaName+"TB_CDDFORM "+
						" WHERE BRANCHCODE = ? ";
		
		if("PENDING".equals(formType)){
			query = query + " AND FORMTYPE IN ('INVDNEW','INVDEXISTING','CORPNEW','CORPEXISTING') ";
			query = query + " AND STATUS = '"+status+"' ";
		}else if("APPROVED".equals(formType)){
			query = query + " AND FORMTYPE IN ('INVDNEW','INVDEXISTING','CORPNEW','CORPEXISTING') ";
			query = query + " AND STATUS = 'A' ";
		}else{
			query = query + " AND FORMTYPE  = '"+formType+"' ";
			query = query + " AND LINENO NOT IN (SELECT LINENO FROM "+schemaName+"TB_CDDFORM WHERE STATUS = 'A' AND RECDDDONE = 'N') ";
		}
		
		if(compassRefNo != null && !"".equals(compassRefNo)){
			query = query + " AND COMPASSREFNO = '"+compassRefNo+"' ";
		}
		
		if(ccifNo != null && !"".equals(ccifNo)){
			query = query + " AND CUSTOMERID = '"+ccifNo+"' ";
		}
		
		if(customerName != null && !"".equals(customerName)){
			query = query + " AND CUSTOMERNAME LIKE '%"+customerName+"%' ";
		}
		
		query = query + " UNION "+
					  	" SELECT COMPASSREFNO, CASE FORMTYPE WHEN 'INVDNEW' THEN 'New Individual' "+
                        "           						 WHEN 'INVDEXISTING' THEN 'Existing Individual' "+
                        "									 WHEN 'CORPNEW' THEN 'New Corporate' "+
                        "									 ELSE 'Existing Corporate' END FORMTYPELONG , "+
                        "		 FORMTYPE, LINENO, CUSTOMERID, CASE STATUS WHEN 'BPD-P' THEN 'Pending with BPD Maker' "+
                        "												   WHEN 'BPD-A' THEN 'Pending with BPD Checker' "+
                        "												   WHEN 'BPA-P' THEN 'Pending with BPA Maker' "+
                        "												   WHEN 'BPA-A' THEN 'Pending with BPA Checker' "+
                        "												   WHEN 'COMP-P' THEN 'Pending with Compliance Maker' "+
                        "												   WHEN 'COMP-A' THEN 'Pending with Compliance Checker' "+
                        "												   WHEN 'JGM' THEN 'Pending with JGM' "+
                        "												   WHEN 'GM' THEN 'Pending with GM' "+
                        "												   WHEN 'A' THEN 'Approved' "+
                        "												   ELSE 'Rejected' END FULLSTATUS, "+
                        "		'RECDD' CDDSTATUS, STATUS, UPDATEBY, FUN_DATETIMETOCHAR(UPDATETIMESTAMP) UPDATETIMESTAMP, UPDATETIMESTAMP UPDATEDDATE "+
                        "  FROM "+schemaName+"TB_CDDFORM "+
                        " WHERE BRANCHCODE = ? "+
                        "   AND STATUS = 'A' "+
                        "   AND RECDDDONE  = 'N' "+
                        "   AND TRUNC(SYSDATE) > TRUNC(NEXTREVIEWDATE) ";
		
		if("PENDING".equals(formType)){
			query = query + " AND FORMTYPE IN ('INVDNEW','INVDEXISTING','CORPNEW','CORPEXISTING') ";
		}else if("APPROVED".equals(formType)){
			query = query + " AND FORMTYPE IN ('INVDNEW','INVDEXISTING','CORPNEW','CORPEXISTING') ";
			query = query + " AND STATUS = 'A' ";
		}else{
			query = query + " AND FORMTYPE  = '"+formType+"' ";
		}
		
		if(compassRefNo != null && !"".equals(compassRefNo)){
			query = query + " AND COMPASSREFNO = '"+compassRefNo+"' ";
		}
		
		if(ccifNo != null && !"".equals(ccifNo)){
			query = query + " AND CUSTOMERID = '"+ccifNo+"' ";
		}
		
		if(customerName != null && !"".equals(customerName)){
			query = query + " AND CUSTOMERNAME LIKE '%"+customerName+"%' ";
		}
		query = query + " ) X ORDER BY UPDATEDDATE DESC ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, branchCode);
			preparedStatement.setString(2, branchCode);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				dataMap.put("FORMTYPELONG", resultSet.getString("FORMTYPELONG"));
				dataMap.put("FORMTYPE", resultSet.getString("FORMTYPE"));
				dataMap.put("LINENO", resultSet.getString("LINENO"));
				dataMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				dataMap.put("FULLSTATUS", resultSet.getString("FULLSTATUS"));
				dataMap.put("STATUS", resultSet.getString("STATUS"));
				dataMap.put("CDDSTATUS", resultSet.getString("CDDSTATUS"));
				dataMap.put("UPDATEBY", resultSet.getString("UPDATEBY"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				
				searchMap.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return searchMap;
	}
	
	private int getLineNo(){
		int lineNo = 0;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_CDDSEQNO.NEXTVAL LINENO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				lineNo = resultSet.getInt("LINENO");
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return lineNo;
	}
	
	public String saveJointHolder(String compassRefNo, String lineNo, String jointHolderName, String jointHolderAddress,
			String jointHolderPan, String jointHolderAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDJOINTHOLDER(COMPASSREFNO,LINENO, JOINTHOLDERNAME, JOINTHOLDERADDRESS, JOINTHOLDERPAN, "+
															"		JOINTHOLDERAADHAR, RELATIONWITHPRIMARY, RELATIONWITHPRIMARYOTHER, SANCTIONLISTMATCH, SANCTIONLISTNAME, "+
															"		ADDEDBY, ADDEDTIMESTAMP, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,'N','',?,SYSTIMESTAMP,?,SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, new Integer(getLineNo()).toString());
			preparedStatement.setString(3, jointHolderName);
			preparedStatement.setString(4, jointHolderAddress);
			preparedStatement.setString(5, jointHolderPan);
			preparedStatement.setString(6, jointHolderAadhar);
			preparedStatement.setString(7, relationWithPrimary);
			preparedStatement.setString(8, otherRelationWithPrimaty);
			preparedStatement.setString(9, userCode);
			preparedStatement.setString(10, userCode);
			preparedStatement.executeUpdate();
			message = "Joint Holder Added successfully";
		}catch(Exception e){
			message = "Error while saving Joint Holder";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updateJointHolder(String compassRefNo, String lineNo, String jointHolderName, String jointHolderAddress,
			String jointHolderPan, String jointHolderAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDJOINTHOLDER SET JOINTHOLDERNAME = ?, JOINTHOLDERADDRESS = ?, JOINTHOLDERPAN = ?, "+
															"		JOINTHOLDERAADHAR = ?, RELATIONWITHPRIMARY = ?, RELATIONWITHPRIMARYOTHER = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, jointHolderName);
			preparedStatement.setString(2, jointHolderAddress);
			preparedStatement.setString(3, jointHolderPan);
			preparedStatement.setString(4, jointHolderAadhar);
			preparedStatement.setString(5, relationWithPrimary);
			preparedStatement.setString(6, otherRelationWithPrimaty);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, compassRefNo);
			preparedStatement.setString(9, lineNo);
			preparedStatement.executeUpdate();
			message = "Joint Holder Updated successfully";
		}catch(Exception e){
			message = "Error while updating Joint Holder";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String saveNomineeDetail(String compassRefNo, String lineNo, String nomineeName, String nomineeAddress,
			String nomineeDob, String nomineeAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDNOMINEEDETAIL(COMPASSREFNO,LINENO, NOMINEENAME, NOMINEEADDRESS, NOMINEEDOB, "+
															"		NOMINEEAADHAR, RELATIONWITHPRIMARY, RELATIONWITHPRIMARYOTHER, SANCTIONLISTMATCH, SANCTIONLISTNAME, "+
															"		ADDEDBY, ADDEDTIMESTAMP, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,'N','',?,SYSTIMESTAMP,?,SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, new Integer(getLineNo()).toString());
			preparedStatement.setString(3, nomineeName);
			preparedStatement.setString(4, nomineeAddress);
			preparedStatement.setString(5, nomineeDob);
			preparedStatement.setString(6, nomineeAadhar);
			preparedStatement.setString(7, relationWithPrimary);
			preparedStatement.setString(8, otherRelationWithPrimaty);
			preparedStatement.setString(9, userCode);
			preparedStatement.setString(10, userCode);
			preparedStatement.executeUpdate();
			message = "Nominee Detail Added successfully";
		}catch(Exception e){
			message = "Error while saving Nominee Detail";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updateNomineeDetail(String compassRefNo, String lineNo, String nomineeName, String nomineeAddress,
			String nomineeDob, String nomineeAadhar, String relationWithPrimary, String otherRelationWithPrimaty, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDNOMINEEDETAIL SET NOMINEENAME = ?, NOMINEEADDRESS = ?, NOMINEEDOB = ?, "+
															"		NOMINEEAADHAR = ?, RELATIONWITHPRIMARY = ?, RELATIONWITHPRIMARYOTHER = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, nomineeName);
			preparedStatement.setString(2, nomineeAddress);
			preparedStatement.setString(3, nomineeDob);
			preparedStatement.setString(4, nomineeAadhar);
			preparedStatement.setString(5, relationWithPrimary);
			preparedStatement.setString(6, otherRelationWithPrimaty);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, compassRefNo);
			preparedStatement.setString(9, lineNo);
			preparedStatement.executeUpdate();
			message = "Nominee Detail Updated successfully";
		}catch(Exception e){
			message = "Error while updating Joint Holder";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updateScreeningResult(String compassRefNo, String lineNo, String type, String screeningMatch, String sanctionList, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String tableName = "";
		
		if(type.equals("JOINTHOLDER")){
			tableName = ""+schemaName+"TB_CDDJOINTHOLDER";
		} else if(type.equals("NOMINEEDETAIL")){
			tableName = ""+schemaName+"TB_CDDNOMINEEDETAIL";
		} else if(type.equals("INTERMEDIARY")){
			tableName = ""+schemaName+"TB_CDDINTERMEDIARY";
		} else if(type.equals("PEP")){
			tableName = ""+schemaName+"TB_CDDPEP";
		} else if(type.equals("BENEFICIALOWNER")){
			tableName = ""+schemaName+"TB_CDDBENEFICIALOWNER";
		}else if(type.equals("DIRECTOR")){
			tableName = ""+schemaName+"TB_CDDDIRECTOR";
		}else if(type.equals("AUTHORIZEDSIGNATORY")){
			tableName = ""+schemaName+"TB_CDDAUTHORIZESIGNATORY";
		}
		
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+tableName+" SET SANCTIONLISTMATCH = ?, SANCTIONLISTNAME = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, screeningMatch);
			preparedStatement.setString(2, sanctionList);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, compassRefNo);
			preparedStatement.setString(5, lineNo);
			preparedStatement.executeUpdate();
			message = "Screening Result Updated";
		}catch(Exception e){
			message = "Error while updating Screening Result";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String removeEntity(String type, String compassRefNo, String lineNo){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String tableName = "";
		
		if(type.equals("JOINTHOLDER")){
			tableName = ""+schemaName+"TB_CDDJOINTHOLDER";
		} else if(type.equals("NOMINEEDETAIL")){
			tableName = ""+schemaName+"TB_CDDNOMINEEDETAIL";
		} else if(type.equals("INTERMEDIARY")){
			tableName = ""+schemaName+"TB_CDDINTERMEDIARY";
		} else if(type.equals("PEP")){
			tableName = ""+schemaName+"TB_CDDPEP";
		} else if(type.equals("BENEFICIALOWNER")){
			tableName = ""+schemaName+"TB_CDDBENEFICIALOWNER";
		}else if(type.equals("DIRECTOR")){
			tableName = ""+schemaName+"TB_CDDDIRECTOR";
		}else if(type.equals("AUTHORIZEDSIGNATORY")){
			tableName = ""+schemaName+"TB_CDDAUTHORIZESIGNATORY";
		}
		
		try{
			preparedStatement = connection.prepareStatement("DELETE FROM "+tableName+" WHERE COMPASSREFNO = ? AND LINENO = ? ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, lineNo);
			preparedStatement.executeUpdate();
			message = "Entity removed";
		}catch(Exception e){
			message = "Error while removing";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getAllJointHolderDetails(String compassRefNo, String lineNo){
		List<Map<String, String>> jointHolderDetails = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =  "SELECT COMPASSREFNO, LINENO, JOINTHOLDERNAME, JOINTHOLDERADDRESS, JOINTHOLDERPAN, JOINTHOLDERAADHAR, RELATIONWITHPRIMARY, "+
							"		RELATIONWITHPRIMARYOTHER, SANCTIONLISTMATCH, SANCTIONLISTNAME, SCREENINGREFERENCENO "+
							"  FROM "+schemaName+"TB_CDDJOINTHOLDER "+
							" WHERE COMPASSREFNO = ? ";
			if(lineNo != null && !"".equals(lineNo))
				query = query + " AND LINENO = '"+lineNo+"'";
			
			query = query + " ORDER BY LINENO ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> jointHolderDetail = new HashMap<String, String>();
				jointHolderDetail.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				jointHolderDetail.put("LINENO", resultSet.getString("LINENO"));
				jointHolderDetail.put("JOINTHOLDERNAME", resultSet.getString("JOINTHOLDERNAME"));
				jointHolderDetail.put("JOINTHOLDERADDRESS", resultSet.getString("JOINTHOLDERADDRESS"));
				jointHolderDetail.put("JOINTHOLDERPAN", resultSet.getString("JOINTHOLDERPAN"));
				jointHolderDetail.put("JOINTHOLDERAADHAR", resultSet.getString("JOINTHOLDERAADHAR"));
				jointHolderDetail.put("RELATIONWITHPRIMARY", resultSet.getString("RELATIONWITHPRIMARY"));
				jointHolderDetail.put("RELATIONWITHPRIMARYOTHER", resultSet.getString("RELATIONWITHPRIMARYOTHER"));
				jointHolderDetail.put("SANCTIONLISTMATCH", resultSet.getString("SANCTIONLISTMATCH"));
				jointHolderDetail.put("SANCTIONLISTNAME", resultSet.getString("SANCTIONLISTNAME"));
				jointHolderDetail.put("SCREENINGREFERENCENO", resultSet.getString("SCREENINGREFERENCENO"));
				
				jointHolderDetails.add(jointHolderDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return jointHolderDetails;
	}
	
	public List<Map<String, String>> getAllNomineeDetails(String compassRefNo, String lineNo){
		List<Map<String, String>> nomineeDetails = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =  "SELECT COMPASSREFNO, LINENO, NOMINEENAME, NOMINEEADDRESS, NOMINEEDOB, NOMINEEAADHAR, RELATIONWITHPRIMARY, "+
							"		RELATIONWITHPRIMARYOTHER, SANCTIONLISTMATCH, SANCTIONLISTNAME, SCREENINGREFERENCENO "+
							"  FROM "+schemaName+"TB_CDDNOMINEEDETAIL "+
							" WHERE COMPASSREFNO = ? ";
			if(lineNo != null && !"".equals(lineNo))
				query = query + " AND LINENO = '"+lineNo+"'";
			
			query = query + " ORDER BY LINENO ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> nomineeDetail = new HashMap<String, String>();
				nomineeDetail.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				nomineeDetail.put("LINENO", resultSet.getString("LINENO"));
				nomineeDetail.put("NOMINEENAME", resultSet.getString("NOMINEENAME"));
				nomineeDetail.put("NOMINEEADDRESS", resultSet.getString("NOMINEEADDRESS"));
				nomineeDetail.put("NOMINEEDOB", resultSet.getString("NOMINEEDOB"));
				nomineeDetail.put("NOMINEEAADHAR", resultSet.getString("NOMINEEAADHAR"));
				nomineeDetail.put("RELATIONWITHPRIMARY", resultSet.getString("RELATIONWITHPRIMARY"));
				nomineeDetail.put("RELATIONWITHPRIMARYOTHER", resultSet.getString("RELATIONWITHPRIMARYOTHER"));
				nomineeDetail.put("SANCTIONLISTMATCH", resultSet.getString("SANCTIONLISTMATCH"));
				nomineeDetail.put("SANCTIONLISTNAME", resultSet.getString("SANCTIONLISTNAME"));
				nomineeDetail.put("SCREENINGREFERENCENO", resultSet.getString("SCREENINGREFERENCENO"));
				
				nomineeDetails.add(nomineeDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return nomineeDetails;
	}
	
	public String saveIntermediary(String compassRefNo, String lineNo, String intermediaryName, String intermediaryNationality, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDINTERMEDIARY(COMPASSREFNO, LINENO, INTERMEDIARYNAME, "+
															"		INTERMEDIARYNATIONALITY, SANCTIONLISTMATCH, SANCTIONLISTNAME, "+
															"		ADDEDBY, ADDEDTIMESTAMP, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,'N','',?,SYSTIMESTAMP,?,SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, new Integer(getLineNo()).toString());
			preparedStatement.setString(3, intermediaryName);
			preparedStatement.setString(4, intermediaryNationality);
			preparedStatement.setString(5, userCode);
			preparedStatement.setString(6, userCode);
			preparedStatement.executeUpdate();
			message = "Intermediary Added successfully";
		}catch(Exception e){
			message = "Error while saving Intermediary";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updateIntermediary(String compassRefNo, String lineNo, String intermediaryName, String intermediaryNationality, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDINTERMEDIARY SET INTERMEDIARYNAME = ?, INTERMEDIARYNATIONALITY = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, intermediaryName);
			preparedStatement.setString(2, intermediaryNationality);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, compassRefNo);
			preparedStatement.setString(5, lineNo);
			preparedStatement.executeUpdate();
			message = "Intermediary Updated successfully";
		}catch(Exception e){
			message = "Error while updating Intermediary";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getAllIntermediariesDetails(String compassRefNo, String lineNo){
		List<Map<String, String>> intermediariesDetails = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =  "SELECT COMPASSREFNO, LINENO, INTERMEDIARYNAME, INTERMEDIARYNATIONALITY, SANCTIONLISTMATCH, SANCTIONLISTNAME, SCREENINGREFERENCENO "+
							"  FROM "+schemaName+"TB_CDDINTERMEDIARY "+
							" WHERE COMPASSREFNO = ? ";
			if(lineNo != null && !"".equals(lineNo))
				query = query + " AND LINENO = '"+lineNo+"'";
			
			query = query + " ORDER BY LINENO ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> intermediariesDetail = new HashMap<String, String>();
				intermediariesDetail.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				intermediariesDetail.put("LINENO", resultSet.getString("LINENO"));
				intermediariesDetail.put("INTERMEDIARYNAME", resultSet.getString("INTERMEDIARYNAME"));
				intermediariesDetail.put("INTERMEDIARYNATIONALITY", resultSet.getString("INTERMEDIARYNATIONALITY"));
				intermediariesDetail.put("SANCTIONLISTMATCH", resultSet.getString("SANCTIONLISTMATCH"));
				intermediariesDetail.put("SANCTIONLISTNAME", resultSet.getString("SANCTIONLISTNAME"));
				intermediariesDetail.put("SCREENINGREFERENCENO", resultSet.getString("SCREENINGREFERENCENO"));
				
				intermediariesDetails.add(intermediariesDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return intermediariesDetails;
	}
	
	public String savePEP(String compassRefNo, String lineNo, String pepName, String pepNationality, String pepPositionInGovt, String pepPositionInCompany, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDPEP(COMPASSREFNO, LINENO, PEPNAME, "+
															"		PEPNATIONALITY, PEPPOSITIONINGOVT, PEPPOSITIONINCOMPANY, "+
															"		SANCTIONLISTMATCH, SANCTIONLISTNAME, "+
															"		ADDEDBY, ADDEDTIMESTAMP, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,'N','',?,SYSTIMESTAMP,?,SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, new Integer(getLineNo()).toString());
			preparedStatement.setString(3, pepName);
			preparedStatement.setString(4, pepNationality);
			preparedStatement.setString(5, pepPositionInGovt);
			preparedStatement.setString(6, pepPositionInCompany);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, userCode);
			preparedStatement.executeUpdate();
			message = "PEP Added successfully";
		}catch(Exception e){
			message = "Error while saving PEP Details";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updatePEP(String compassRefNo, String lineNo, String pepName, String pepNationality, String pepPositionInGovt, String pepPositionInCompany, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDPEP SET PEPNAME = ?, PEPNATIONALITY = ?, PEPPOSITIONINGOVT = ?, "+
															"		PEPPOSITIONINCOMPANY = ?, UPDATEBY = ?,  UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, pepName);
			preparedStatement.setString(2, pepNationality);
			preparedStatement.setString(3, pepPositionInGovt);
			preparedStatement.setString(4, pepPositionInCompany);
			preparedStatement.setString(5, userCode);
			preparedStatement.setString(6, compassRefNo);
			preparedStatement.setString(7, lineNo);
			preparedStatement.executeUpdate();
			message = "PEP Updated successfully";
		}catch(Exception e){
			message = "Error while updating PEP Details";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getAllPEPDetails(String compassRefNo, String lineNo){
		List<Map<String, String>> pepDetails = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =  "SELECT COMPASSREFNO, LINENO, PEPNAME, PEPNATIONALITY, PEPPOSITIONINGOVT, PEPPOSITIONINCOMPANY, "+
							"       SANCTIONLISTMATCH, SANCTIONLISTNAME, SCREENINGREFERENCENO "+
							"  FROM "+schemaName+"TB_CDDPEP "+
							" WHERE COMPASSREFNO = ? ";
			if(lineNo != null && !"".equals(lineNo))
				query = query + " AND LINENO = '"+lineNo+"'";
			
			query = query + " ORDER BY LINENO ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> pepDetail = new HashMap<String, String>();
				pepDetail.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				pepDetail.put("LINENO", resultSet.getString("LINENO"));
				pepDetail.put("PEPNAME", resultSet.getString("PEPNAME"));
				pepDetail.put("PEPNATIONALITY", resultSet.getString("PEPNATIONALITY"));
				pepDetail.put("PEPPOSITIONINGOVT", resultSet.getString("PEPPOSITIONINGOVT"));
				pepDetail.put("PEPPOSITIONINCOMPANY", resultSet.getString("PEPPOSITIONINCOMPANY"));
				pepDetail.put("SANCTIONLISTMATCH", resultSet.getString("SANCTIONLISTMATCH"));
				pepDetail.put("SANCTIONLISTNAME", resultSet.getString("SANCTIONLISTNAME"));
				pepDetail.put("SCREENINGREFERENCENO", resultSet.getString("SCREENINGREFERENCENO"));
				
				pepDetails.add(pepDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return pepDetails;
	}
	
	public String saveBeneficialOwner(String compassRefNo, String lineNo, String name, String effectiveShareholding, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDBENEFICIALOWNER(COMPASSREFNO, LINENO, NAME, "+
															"		EFFECTIVESHAREHOLDING, NATIONALITY, DATEOFBIRTH, PANNO, AADHARNO, "+
															"		SANCTIONLISTMATCH, SANCTIONLISTNAME, "+
															"		ADDEDBY, ADDEDTIMESTAMP, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,'N','',?,SYSTIMESTAMP,?,SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, new Integer(getLineNo()).toString());
			preparedStatement.setString(3, name);
			preparedStatement.setString(4, effectiveShareholding);
			preparedStatement.setString(5, nationality);
			preparedStatement.setString(6, dateOfBirth);
			preparedStatement.setString(7, panNo);
			preparedStatement.setString(8, aadharNo);
			preparedStatement.setString(9, userCode);
			preparedStatement.setString(10, userCode);
			preparedStatement.executeUpdate();
			message = "Beneficial Owner Added successfully";
		}catch(Exception e){
			message = "Error while saving Beneficial Owner";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updateBeneficialOwner(String compassRefNo, String lineNo, String name, String effectiveShareholding, 
			String nationality, String dateOfBirth, String panNo, String aadharNo,String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDBENEFICIALOWNER SET NAME = ?, EFFECTIVESHAREHOLDING = ?, NATIONALITY = ?, DATEOFBIRTH = ?, PANNO = ?, AADHARNO = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, name);
			preparedStatement.setString(2, effectiveShareholding);
			preparedStatement.setString(3, nationality);
			preparedStatement.setString(4, dateOfBirth);
			preparedStatement.setString(5, panNo);
			preparedStatement.setString(6, aadharNo);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, compassRefNo);
			preparedStatement.setString(9, lineNo);
			preparedStatement.executeUpdate();
			message = "Beneficial Owner Updated successfully";
		}catch(Exception e){
			message = "Error while updating Beneficial Owner";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getAllBeneficialOwnerDetails(String compassRefNo, String lineNo){
		List<Map<String, String>> beneficialOwnerDetails = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =  "SELECT COMPASSREFNO, LINENO, NAME, EFFECTIVESHAREHOLDING, NATIONALITY, DATEOFBIRTH, PANNO, AADHARNO, "+
							"		SANCTIONLISTMATCH, SANCTIONLISTNAME, SCREENINGREFERENCENO "+
							"  FROM "+schemaName+"TB_CDDBENEFICIALOWNER "+
							" WHERE COMPASSREFNO = ? ";
			if(lineNo != null && !"".equals(lineNo))
				query = query + " AND LINENO = '"+lineNo+"'";
			
			query = query + " ORDER BY LINENO ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> beneficialOwnerDetail = new HashMap<String, String>();
				beneficialOwnerDetail.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				beneficialOwnerDetail.put("LINENO", resultSet.getString("LINENO"));
				beneficialOwnerDetail.put("NAME", resultSet.getString("NAME"));
				beneficialOwnerDetail.put("EFFECTIVESHAREHOLDING", resultSet.getString("EFFECTIVESHAREHOLDING"));
				beneficialOwnerDetail.put("NATIONALITY", resultSet.getString("NATIONALITY"));
				beneficialOwnerDetail.put("DATEOFBIRTH", resultSet.getString("DATEOFBIRTH"));
				beneficialOwnerDetail.put("PANNO", resultSet.getString("PANNO"));
				beneficialOwnerDetail.put("AADHARNO", resultSet.getString("AADHARNO"));
				beneficialOwnerDetail.put("SANCTIONLISTMATCH", resultSet.getString("SANCTIONLISTMATCH"));
				beneficialOwnerDetail.put("SANCTIONLISTNAME", resultSet.getString("SANCTIONLISTNAME"));
				beneficialOwnerDetail.put("SCREENINGREFERENCENO", resultSet.getString("SCREENINGREFERENCENO"));
				
				beneficialOwnerDetails.add(beneficialOwnerDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return beneficialOwnerDetails;
	}
	
	public String saveDirector(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String aadharNo, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDDIRECTOR(COMPASSREFNO, LINENO, NAME, "+
															"		ADDRESS, NATIONALITY, DATEOFBIRTH, PANNO, AADHARNO, "+
															"		SANCTIONLISTMATCH, SANCTIONLISTNAME, "+
															"		ADDEDBY, ADDEDTIMESTAMP, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,'N','',?,SYSTIMESTAMP,?,SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, new Integer(getLineNo()).toString());
			preparedStatement.setString(3, name);
			preparedStatement.setString(4, address);
			preparedStatement.setString(5, nationality);
			preparedStatement.setString(6, dateOfBirth);
			preparedStatement.setString(7, panNo);
			preparedStatement.setString(8, aadharNo);
			preparedStatement.setString(9, userCode);
			preparedStatement.setString(10, userCode);
			preparedStatement.executeUpdate();
			message = "Director Added successfully";
		}catch(Exception e){
			message = "Error while saving Director";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updateDirector(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String aadharNo,String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDDIRECTOR SET NAME = ?, ADDRESS = ?, NATIONALITY = ?, DATEOFBIRTH = ?, PANNO = ?, AADHARNO = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, name);
			preparedStatement.setString(2, address);
			preparedStatement.setString(3, nationality);
			preparedStatement.setString(4, dateOfBirth);
			preparedStatement.setString(5, panNo);
			preparedStatement.setString(6, aadharNo);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, compassRefNo);
			preparedStatement.setString(9, lineNo);
			preparedStatement.executeUpdate();
			message = "Director Updated successfully";
		}catch(Exception e){
			message = "Error while updating Director";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getAllDirectorDetails(String compassRefNo, String lineNo){
		List<Map<String, String>> directorDetails = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =  "SELECT COMPASSREFNO, LINENO, NAME, ADDRESS, NATIONALITY, DATEOFBIRTH, "+
							"		PANNO, AADHARNO, SANCTIONLISTMATCH, SANCTIONLISTNAME, SCREENINGREFERENCENO "+
							"  FROM "+schemaName+"TB_CDDDIRECTOR "+
							" WHERE COMPASSREFNO = ? ";
			if(lineNo != null && !"".equals(lineNo))
				query = query + " AND LINENO = '"+lineNo+"'";
			
			query = query + " ORDER BY LINENO ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> directorDetail = new HashMap<String, String>();
				directorDetail.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				directorDetail.put("LINENO", resultSet.getString("LINENO"));
				directorDetail.put("NAME", resultSet.getString("NAME"));
				directorDetail.put("ADDRESS", resultSet.getString("ADDRESS"));
				directorDetail.put("NATIONALITY", resultSet.getString("NATIONALITY"));
				directorDetail.put("DATEOFBIRTH", resultSet.getString("DATEOFBIRTH"));
				directorDetail.put("PANNO", resultSet.getString("PANNO"));
				directorDetail.put("AADHARNO", resultSet.getString("AADHARNO"));
				directorDetail.put("SANCTIONLISTMATCH", resultSet.getString("SANCTIONLISTMATCH"));
				directorDetail.put("SANCTIONLISTNAME", resultSet.getString("SANCTIONLISTNAME"));
				directorDetail.put("SCREENINGREFERENCENO", resultSet.getString("SCREENINGREFERENCENO"));
				
				directorDetails.add(directorDetail);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return directorDetails;
	}
	
	public String saveAuthorizedSignatory(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String panNSDLResponse, String aadharNo, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDDAUTHORIZESIGNATORY (COMPASSREFNO, LINENO, NAME, "+
															"		ADDRESS, NATIONALITY, DATEOFBIRTH, PANNO, PANNSDLRESPONSE, AADHARNO, "+
															"		SANCTIONLISTMATCH, SANCTIONLISTNAME, "+
															"		ADDEDBY, ADDEDTIMESTAMP, UPDATEBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,?,'N','',?,SYSTIMESTAMP,?,SYSTIMESTAMP) ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, new Integer(getLineNo()).toString());
			preparedStatement.setString(3, name);
			preparedStatement.setString(4, address);
			preparedStatement.setString(5, nationality);
			preparedStatement.setString(6, dateOfBirth);
			preparedStatement.setString(7, panNo);
			preparedStatement.setString(8, panNSDLResponse);
			preparedStatement.setString(9, aadharNo);
			preparedStatement.setString(10, userCode);
			preparedStatement.setString(11, userCode);
			preparedStatement.executeUpdate();
			message = "Authorize Signatory Added successfully";
		}catch(Exception e){
			message = "Error while saving Authorize Signatory";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String updateAuthorizedSignatory(String compassRefNo, String lineNo, String name, String address, 
			String nationality, String dateOfBirth, String panNo, String panNSDLResponse, String aadharNo,String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDAUTHORIZESIGNATORY SET NAME = ?, ADDRESS = ?, NATIONALITY = ?, "+
					                                        "       DATEOFBIRTH = ?, PANNO = ?, PANNSDLRESPONSE = ?, AADHARNO = ?, "+
					                                        "       UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
															" WHERE COMPASSREFNO = ? "+
															"   AND LINENO = ? ");
			preparedStatement.setString(1, name);
			preparedStatement.setString(2, address);
			preparedStatement.setString(3, nationality);
			preparedStatement.setString(4, dateOfBirth);
			preparedStatement.setString(5, panNo);
			preparedStatement.setString(6, panNSDLResponse);
			preparedStatement.setString(7, aadharNo);
			preparedStatement.setString(8, userCode);
			preparedStatement.setString(9, compassRefNo);
			preparedStatement.setString(10, lineNo);
			preparedStatement.executeUpdate();
			message = "Authorize Signatory Updated successfully";
		}catch(Exception e){
			message = "Error while updating Authorize Signatory";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getAllAuthorizeSignatoryDetails(String compassRefNo, String lineNo){
		List<Map<String, String>> authorizeSignatories = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =  "SELECT COMPASSREFNO, LINENO, NAME, ADDRESS, NATIONALITY, DATEOFBIRTH, PANNO, PANNSDLRESPONSE, AADHARNO, "+
							"		SANCTIONLISTMATCH, SANCTIONLISTNAME, IDF_RELATIONWITHCUST, IDF_TXN_TYPE, "+
							"		IDF_TXN_TYPE_OTR_DET, IDF_MOI, IDF_CERT_TYPE, IDF_CERT_ISSUED_BY, IDF_CERT_NO, "+
							"		IDF_CERT_SHOWN, IDF_DOCMAILEDDATE, IDF_DOC_TITLE, IDF_DOC_TITLE_OTR_DETAILS, "+
							"		IDF_DLV_METHOD, IDF_DLV_MAIL_COURIER, IDF_DIC_IDFIC, IDF_TIME_IDFIC, IDF_COFM_DATE, "+
							"		IDF_TXN_DATE, IDF_CHNG_INFO, IDF_CHNG_INFO_OTR, IDF_ENTITY_VERF, IDF_ENTITY_CERT_Y, IDF_ENTITY_CERT_N, "+
							"		SCREENINGREFERENCENO "+		
							"  FROM "+schemaName+"TB_CDDAUTHORIZESIGNATORY "+
							" WHERE COMPASSREFNO = ? ";
			if(lineNo != null && !"".equals(lineNo))
				query = query + " AND LINENO = '"+lineNo+"'";
			
			query = query + " ORDER BY LINENO ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> authorizeSignatory = new HashMap<String, String>();
				authorizeSignatory.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				authorizeSignatory.put("LINENO", resultSet.getString("LINENO"));
				authorizeSignatory.put("NAME", resultSet.getString("NAME"));
				authorizeSignatory.put("ADDRESS", resultSet.getString("ADDRESS"));
				authorizeSignatory.put("NATIONALITY", resultSet.getString("NATIONALITY"));
				authorizeSignatory.put("DATEOFBIRTH", resultSet.getString("DATEOFBIRTH"));
				authorizeSignatory.put("PANNO", resultSet.getString("PANNO"));
				authorizeSignatory.put("PANNSDLRESPONSE", resultSet.getString("PANNSDLRESPONSE"));
				authorizeSignatory.put("AADHARNO", resultSet.getString("AADHARNO"));
				authorizeSignatory.put("SANCTIONLISTMATCH", resultSet.getString("SANCTIONLISTMATCH"));
				authorizeSignatory.put("SANCTIONLISTNAME", resultSet.getString("SANCTIONLISTNAME"));
				
				authorizeSignatory.put("IDF_RELATIONWITHCUST", resultSet.getString("IDF_RELATIONWITHCUST"));
				authorizeSignatory.put("IDF_TXN_TYPE", resultSet.getString("IDF_TXN_TYPE"));
				authorizeSignatory.put("IDF_TXN_TYPE_OTR_DET", resultSet.getString("IDF_TXN_TYPE_OTR_DET"));
				authorizeSignatory.put("IDF_MOI", resultSet.getString("IDF_MOI"));
				authorizeSignatory.put("IDF_CERT_TYPE", resultSet.getString("IDF_CERT_TYPE"));
				authorizeSignatory.put("IDF_CERT_ISSUED_BY", resultSet.getString("IDF_CERT_ISSUED_BY"));
				authorizeSignatory.put("IDF_CERT_NO", resultSet.getString("IDF_CERT_NO"));
				authorizeSignatory.put("IDF_CERT_SHOWN", resultSet.getString("IDF_CERT_SHOWN"));
				authorizeSignatory.put("IDF_DOCMAILEDDATE", resultSet.getString("IDF_DOCMAILEDDATE"));
				authorizeSignatory.put("IDF_DOC_TITLE", resultSet.getString("IDF_DOC_TITLE"));
				authorizeSignatory.put("IDF_DOC_TITLE_OTR_DETAILS", resultSet.getString("IDF_DOC_TITLE_OTR_DETAILS"));
				authorizeSignatory.put("IDF_DLV_METHOD", resultSet.getString("IDF_DLV_METHOD"));
				authorizeSignatory.put("IDF_DLV_MAIL_COURIER", resultSet.getString("IDF_DLV_MAIL_COURIER"));
				authorizeSignatory.put("IDF_DIC_IDFIC", resultSet.getString("IDF_DIC_IDFIC"));
				authorizeSignatory.put("IDF_TIME_IDFIC", resultSet.getString("IDF_TIME_IDFIC"));
				authorizeSignatory.put("IDF_COFM_DATE", resultSet.getString("IDF_COFM_DATE"));
				authorizeSignatory.put("IDF_TXN_DATE", resultSet.getString("IDF_TXN_DATE"));
				
				authorizeSignatory.put("IDF_CHNG_INFO", resultSet.getString("IDF_CHNG_INFO"));
				authorizeSignatory.put("IDF_CHNG_INFO_OTR", resultSet.getString("IDF_CHNG_INFO_OTR"));
				authorizeSignatory.put("IDF_ENTITY_VERF", resultSet.getString("IDF_ENTITY_VERF"));
				authorizeSignatory.put("IDF_ENTITY_CERT_Y", resultSet.getString("IDF_ENTITY_CERT_Y"));
				authorizeSignatory.put("IDF_ENTITY_CERT_N", resultSet.getString("IDF_ENTITY_CERT_N"));
				authorizeSignatory.put("SCREENINGREFERENCENO", resultSet.getString("SCREENINGREFERENCENO"));

				authorizeSignatories.add(authorizeSignatory);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return authorizeSignatories;
	}
	
	public String getCDDFormFieldData(String field, String compassRefNo, String lineNo){
		String data = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			// System.out.println("SELECT "+field+" FROM "+schemaName+"TB_CDDFORM WHERE COMPASSREFNO = ? AND LINENO = ?" );
			preparedStatement = connection.prepareStatement("SELECT "+field+" FROM "+schemaName+"TB_CDDFORM WHERE COMPASSREFNO = ? AND LINENO = ?");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, lineNo);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				data = resultSet.getString(1);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return data;
	}
	
	public Map<String, Object> getCDDAuditLog(String compassRefNo, String linoNo){
		Map<String, Object> auditLog = new HashMap<String, Object>();
		List<Map<String, String>> auditLogList = new Vector<Map<String, String>>();
		Map<String, Map<String, String>> updateStatus = new HashMap<String, Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETCDDFORMAUDITLOG(?,?,?,?)}");
			callableStatement.setString(1, compassRefNo);
			callableStatement.setString(2, linoNo);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(3);
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("SEQNO", resultSet.getString("SEQNO"));
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
				dataMap.put("USERROLE", resultSet.getString("USERROLE"));
				dataMap.put("ROLEID", resultSet.getString("ROLEID"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				dataMap.put("USERCOMMENT", resultSet.getString("USERCOMMENT"));
				dataMap.put("CURRENTSTATUS", resultSet.getString("CURRENTSTATUS"));
				dataMap.put("UPDATEDSTATUS", resultSet.getString("UPDATEDSTATUS"));
				
				auditLogList.add(dataMap);
			}
			
			resultSet = (ResultSet) callableStatement.getObject(4);
			while(resultSet.next()){
				String rolename = resultSet.getString("ROLEID");
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
				dataMap.put("MAXTIMESTAMP", resultSet.getString("MAXTIMESTAMP"));
				dataMap.put("ROLEID", resultSet.getString("ROLEID"));				
				updateStatus.put(rolename, dataMap);
			}
			
			auditLog.put("AUDITLOGLIST", auditLogList);
			auditLog.put("UPDATESTATUS", updateStatus);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return auditLog;
	}
	
	public String setCDDFormStatus(String status, String compassRefNo, String lineNo, String userCode, String userRole){
		String data = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		try{
			queryString = "UPDATE "+schemaName+"TB_CDDFORM SET STATUS = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP WHERE COMPASSREFNO = ? AND LINENO = ?";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, status);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, compassRefNo); 
			preparedStatement.setString(4, lineNo); 
			preparedStatement.executeUpdate();
			
			//if(userRole.equalsIgnoreCase("ROLE_BPAMAKER") || userRole.equalsIgnoreCase("ROLE_BPDMAKER") ){
			if(userRole.equalsIgnoreCase("ROLE_GM")){
			queryString = "UPDATE "+schemaName+"TB_CDDFORM A "+
			              "   SET NEXTREVIEWDATE = CASE WHEN SUBSTR(NVL(TRIM(FINALRISKRATING),'1'),1,1) IN ('4','5') THEN ADD_MONTHS(SYSDATE, 12) "+
			              "                             WHEN SUBSTR(NVL(TRIM(FINALRISKRATING),'1'),1,1) IN ('3') THEN ADD_MONTHS(SYSDATE, 36) "+
			              "                             WHEN SUBSTR(NVL(TRIM(FINALRISKRATING),'1'),1,1) IN ('1','2') THEN ADD_MONTHS(SYSDATE, 60) "+
			              "                        ELSE NEXTREVIEWDATE END "+
			              " WHERE A.COMPASSREFNO = ? "+
			              "   AND LINENO = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, compassRefNo); 
			preparedStatement.setString(2, lineNo); 
			preparedStatement.executeUpdate();
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return data;
	}
	
	public void setReCDDStatus(String status, String compassRefNo, String lineNo){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDFORM SET RECDDDONE = '"+status+"' WHERE COMPASSREFNO = ? AND LINENO = ?");
			preparedStatement.setString(1, compassRefNo); 
			preparedStatement.setString(2, lineNo); 
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void setCDDNextReviewDate(String reviewDate, String compassRefNo, String lineNo, String userCode){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDFORM SET NEXTREVIEWDATE = FUN_CHARTODATE(?), UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP WHERE COMPASSREFNO = ? AND LINENO = ?");
			preparedStatement.setString(1, reviewDate);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, compassRefNo); 
			preparedStatement.setString(4, lineNo); 
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public String updateCustomerIdentificationForm(Map<String, String> formData, String compassRefNo, String lineNo, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDFORM SET CUSTOMERNAME = ?, IDF_TXN_TYPE = ?, IDF_TXN_TYPE_OTR_DET = ?, IDF_MOI = ?, "+
															"		IDF_CERT_TYPE = ?, IDF_CERT_ISSUED_BY = ?, IDF_CERT_NO = ?, IDF_CERT_SHOWN = ?, "+
															"		IDF_DOCMAILEDDATE = ?, IDF_DOC_TITLE = ?, IDF_DOC_TITLE_OTR_DETAILS = ?, "+
															"		IDF_DLV_METHOD = ?, IDF_DLV_MAIL_COURIER = ?, IDF_DIC_IDFIC = ?, IDF_TIME_IDFIC = ?, "+
															"		IDF_COFM_DATE = ?, IDF_TXN_DATE = ?, IDF_UPDATEDBY = ?, IDF_UPDATETIMESTAMP = SYSTIMESTAMP, "+
															"		IDF_CHNG_INFO = ?, IDF_CHNG_INFO_OTR = ?, IDF_ENTITY_VERF = ?, IDF_ENTITY_CERT_Y = ?, IDF_ENTITY_CERT_N = ? "+
															" WHERE COMPASSREFNO = ? AND LINENO = ?");
			preparedStatement.setString(1, formData.get("IDF_CUSTOMERNAME"));
			preparedStatement.setString(2, formData.get("IDF_TXN_TYPE"));
			preparedStatement.setString(3, formData.get("IDF_TXN_TYPE_OTR_DET"));
			preparedStatement.setString(4, formData.get("IDF_MOI"));
			preparedStatement.setString(5, formData.get("IDF_CERT_TYPE"));
			preparedStatement.setString(6, formData.get("IDF_CERT_ISSUED_BY"));
			preparedStatement.setString(7, formData.get("IDF_CERT_NO"));
			preparedStatement.setString(8, formData.get("IDF_CERT_SHOWN"));
			preparedStatement.setString(9, formData.get("IDF_DOCMAILEDDATE"));
			preparedStatement.setString(10, formData.get("IDF_DOC_TITLE"));
			preparedStatement.setString(11, formData.get("IDF_DOC_TITLE_OTR_DETAILS"));
			preparedStatement.setString(12, formData.get("IDF_DLV_METHOD"));
			preparedStatement.setString(13, formData.get("IDF_DLV_MAIL_COURIER"));
			preparedStatement.setString(14, formData.get("IDF_DIC_IDFIC"));
			preparedStatement.setString(15, formData.get("IDF_TIME_IDFIC"));
			preparedStatement.setString(16, formData.get("IDF_COFM_DATE"));
			preparedStatement.setString(17, formData.get("IDF_TXN_DATE"));
			preparedStatement.setString(18, userCode);
			preparedStatement.setString(19, formData.get("IDF_CHNG_INFO"));
			preparedStatement.setString(20, formData.get("IDF_CHNG_INFO_OTR"));
			preparedStatement.setString(21, formData.get("IDF_ENTITY_VERF"));
			preparedStatement.setString(22, formData.get("IDF_ENTITY_CERT_Y"));
			preparedStatement.setString(23, formData.get("IDF_ENTITY_CERT_N"));
			preparedStatement.setString(24, formData.get("COMPASSREFERENCENO"));
			preparedStatement.setString(25, formData.get("LINENO"));
			preparedStatement.executeUpdate();
			message = "Customer Identification form successfully saved";
		}catch(Exception e){
			message = "Error while updating Customer Indentification Form";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public String updateAuthSignIdentificationForm(Map<String, String> formData, String compassRefNo, String lineNo, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("UPDATE "+schemaName+"TB_CDDAUTHORIZESIGNATORY SET NAME = ?, DATEOFBIRTH = ?, ADDRESS = ?, "+
															"		IDF_RELATIONWITHCUST = ?, IDF_TXN_TYPE = ?, IDF_TXN_TYPE_OTR_DET = ?, IDF_MOI = ?, "+
															"		IDF_CERT_TYPE = ?, IDF_CERT_ISSUED_BY = ?, IDF_CERT_NO = ?, IDF_CERT_SHOWN = ?, "+
															"		IDF_DOCMAILEDDATE = ?, IDF_DOC_TITLE = ?, IDF_DOC_TITLE_OTR_DETAILS = ?, "+
															"		IDF_DLV_METHOD = ?, IDF_DLV_MAIL_COURIER = ?, IDF_DIC_IDFIC = ?, IDF_TIME_IDFIC = ?, "+
															"		IDF_COFM_DATE = ?, IDF_TXN_DATE = ?, IDF_UPDATEDBY = ?, IDF_UPDATETIMESTAMP = SYSTIMESTAMP, "+
															"		IDF_CHNG_INFO = ?, IDF_CHNG_INFO_OTR = ?, IDF_ENTITY_VERF = ?, IDF_ENTITY_CERT_Y = ?, IDF_ENTITY_CERT_N = ? "+
															" WHERE COMPASSREFNO = ? AND LINENO = ? ");
			preparedStatement.setString(1, formData.get("IDF_CUSTOMERNAME"));
			preparedStatement.setString(2, formData.get("IDF_DATEOFBIRTH"));
			preparedStatement.setString(3, formData.get("IDF_ADDRESS"));
			preparedStatement.setString(4, formData.get("IDF_RELATIONWITHCUST"));
			preparedStatement.setString(5, formData.get("IDF_TXN_TYPE"));
			preparedStatement.setString(6, formData.get("IDF_TXN_TYPE_OTR_DET"));
			preparedStatement.setString(7, formData.get("IDF_MOI"));
			preparedStatement.setString(8, formData.get("IDF_CERT_TYPE"));
			preparedStatement.setString(9, formData.get("IDF_CERT_ISSUED_BY"));
			preparedStatement.setString(10, formData.get("IDF_CERT_NO"));
			preparedStatement.setString(11, formData.get("IDF_CERT_SHOWN"));
			preparedStatement.setString(12, formData.get("IDF_DOCMAILEDDATE"));
			preparedStatement.setString(13, formData.get("IDF_DOC_TITLE"));
			preparedStatement.setString(14, formData.get("IDF_DOC_TITLE_OTR_DETAILS"));
			preparedStatement.setString(15, formData.get("IDF_DLV_METHOD"));
			preparedStatement.setString(16, formData.get("IDF_DLV_MAIL_COURIER"));
			preparedStatement.setString(17, formData.get("IDF_DIC_IDFIC"));
			preparedStatement.setString(18, formData.get("IDF_TIME_IDFIC"));
			preparedStatement.setString(19, formData.get("IDF_COFM_DATE"));
			preparedStatement.setString(20, formData.get("IDF_TXN_DATE"));
			preparedStatement.setString(21, userCode);
			preparedStatement.setString(22, formData.get("IDF_CHNG_INFO"));
			preparedStatement.setString(23, formData.get("IDF_CHNG_INFO_OTR"));
			preparedStatement.setString(24, formData.get("IDF_ENTITY_VERF"));
			preparedStatement.setString(25, formData.get("IDF_ENTITY_CERT_Y"));
			preparedStatement.setString(26, formData.get("IDF_ENTITY_CERT_N"));
			preparedStatement.setString(27, formData.get("COMPASSREFERENCENO"));
			preparedStatement.setString(28, formData.get("LINENO"));
			preparedStatement.executeUpdate();
			message = "Authorize Signatory Identification form successfully saved";
		}catch(Exception e){
			message = "Error while updating Authorize Signatory Indentification Form";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	public Map<String, Object> getFormData(String formType, String compassRefNo, String lineNo){
		Map<String, Object> formData = new HashMap<String, Object>();
		Map<String, String> cddData = new HashMap<String, String>();
		Map<String, String> checkListData = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETCDDFORMDATA(?,?,?,?,?)}");
			callableStatement.setString(1, formType);
			callableStatement.setString(2, compassRefNo);
			callableStatement.setString(3, lineNo);
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(4);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			
			if(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					cddData.put(columnName, resultSet.getString(columnName));
				}
			}
			
			resultSet = (ResultSet) callableStatement.getObject(5);
			resultSetMetaData = resultSet.getMetaData();
			columnCount = resultSetMetaData.getColumnCount();
			
			if(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					checkListData.put(columnName, resultSet.getString(columnName));
				}
			}
			
			cddData.put("FETCHSTATUS", "0");
			cddData.put("FETCHMSG", "CDD Form Data fetched successfully");
		}catch(Exception e){
			cddData.put("FETCHSTATUS", "1");
			cddData.put("FETCHMSG", "Error while fetching CDD Form Data");
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		formData.put("CDD_DATA", cddData);
		formData.put("CHECKLIST_DATA", checkListData);
		return formData;
	}
	
	public Map<String, String> saveCDDFormData(String userCode, String userRole, Map<String, String> formData, String status, String compassRefNo, String lineNo){
		Map<String, String> responseMessage = new HashMap<String, String>();
		responseMessage.put("STATUS", "0");
		responseMessage.put("MSG", "No Action");
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int recordCount = 0;
		String query =  "";
		String columnName = "";
		String columnValue = "";
		try{
			
			
			if(userRole.equals("ROLE_BPDMAKER")){
				query =  "UPDATE "+schemaName+"TB_CDDFORM "+
					     "   SET GENERALCHECKING1 = ?, GENERALCHECKING2 = ?, GENERALCHECKING3 = ?, GENERALCHECKING4 = ?, "+
					     "		 GENERALCHECKING5 = ?, GENERALCHECKING6 = ?, GENERALCHECKING7 = ?, "+
					     "		 PRODUCTSERVICE_TD = ?, PRODUCTSERVICE_SA = ?, PRODUCTSERVICE_GR = ?, PRODUCTSERVICE_CA = ?, "+
					     "		 PRODUCTSERVICE_LN = ?, PRODUCTSERVICE_RE = ?, PRODUCTSERVICE_IB = ?, PRODUCTSERVICE_TF = ?, "+
					     "		 PRODUCTSERVICE_OT = ?, OTHERPRODUCTSERVICE = ?, "+
					     "		 RISKRATINGCHANNEL_1 = ?, RISKRATINGCHANNEL_2 = ?, RISKRATINGCHANNEL_3 = ?, RISKRATINGCHANNEL_4 = ?, "+
					     "		 RR_CHARACTERISTICS_1 = ?, RR_CHARACTERISTICS_2 = ?, RR_CHARACTERISTICS_3 = ?, RR_CHARACTERISTICS_4 = ?, "+
					     "		 RR_CHARACTERISTICS_5 = ?, RR_CHARACTERISTICS_6 = ?, RR_CHARACTERISTICS_7 = ?, "+
					     "		 STATUS = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
					     " WHERE COMPASSREFNO = ? "+
					     "   AND LINENO = ? ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, formData.get("GENERALCHECKING1"));
			preparedStatement.setString(2, formData.get("GENERALCHECKING2"));
			preparedStatement.setString(3, formData.get("GENERALCHECKING3"));
			preparedStatement.setString(4, formData.get("GENERALCHECKING4"));
			preparedStatement.setString(5, formData.get("GENERALCHECKING5"));
			preparedStatement.setString(6, formData.get("GENERALCHECKING6"));
			preparedStatement.setString(7, formData.get("GENERALCHECKING7"));
	
			preparedStatement.setString(8, formData.get("PRODUCTSERVICE_TD"));
			preparedStatement.setString(9, formData.get("PRODUCTSERVICE_SA"));
			preparedStatement.setString(10, formData.get("PRODUCTSERVICE_GR"));
			preparedStatement.setString(11, formData.get("PRODUCTSERVICE_CA"));
			preparedStatement.setString(12, formData.get("PRODUCTSERVICE_LN"));
			preparedStatement.setString(13, formData.get("PRODUCTSERVICE_RE"));
			preparedStatement.setString(14, formData.get("PRODUCTSERVICE_IB"));
			preparedStatement.setString(15, formData.get("PRODUCTSERVICE_TF"));
			preparedStatement.setString(16, formData.get("PRODUCTSERVICE_OT"));
			preparedStatement.setString(17, formData.get("OTHERPRODUCTSERVICE"));
			
			preparedStatement.setString(18, formData.get("RISKRATINGCHANNEL_1"));
			preparedStatement.setString(19, formData.get("RISKRATINGCHANNEL_2"));
			preparedStatement.setString(20, formData.get("RISKRATINGCHANNEL_3"));
			preparedStatement.setString(21, formData.get("RISKRATINGCHANNEL_4"));
			
			preparedStatement.setString(22, formData.get("RR_CHARACTERISTICS_1"));
			preparedStatement.setString(23, formData.get("RR_CHARACTERISTICS_2"));
			preparedStatement.setString(24, formData.get("RR_CHARACTERISTICS_3"));
			preparedStatement.setString(25, formData.get("RR_CHARACTERISTICS_4"));
			preparedStatement.setString(26, formData.get("RR_CHARACTERISTICS_5"));
			preparedStatement.setString(27, formData.get("RR_CHARACTERISTICS_6"));
			preparedStatement.setString(28, formData.get("RR_CHARACTERISTICS_7"));
			
			preparedStatement.setString(29, status);
			preparedStatement.setString(30, userCode);
			preparedStatement.setString(31, compassRefNo);
			preparedStatement.setString(32, lineNo);
			recordCount = preparedStatement.executeUpdate();
			}
			
			//if(userRole.equals("ROLE_BPAMAKER")){
			if(userRole.equals("ROLE_NOROLEUSER")){
			       query =  "UPDATE "+schemaName+"TB_CDDFORM "+
							"   SET CUSTOMERNAME = ?, CUSTOMERPREVNAME = ?, CUSTOMERALIASNAME = ?, RELATIONSHIPMANAGER = ?, "+
							"		DEPTINCHARGE = ?, EXISTINGCUSTOMER = ?, EXISTINGBRANCH = ?, EXISTINGRISKRATING = ?, "+
							"		GENERALCHECKING1 = ?, GENERALCHECKING2 = ?, GENERALCHECKING3 = ?, GENERALCHECKING4 = ?, "+
							"		GENERALCHECKING5 = ?, GENERALCHECKING6 = ?, GENERALCHECKING7 = ?, GOVERNMENTENTITY = ?, "+
							"		GOVERNMENTENTITYCOUNTRY = ?, ENTITYSTOCKEXCHANGE = ?, ENTITYSTKEXCHNGCOUNTRY = ?, "+
							"		CUSTOMERSTOCKEXCHANGE = ?, CUSTOMERSTKEXCHNGCOUNTRY = ?, OTHERREGULATORY = ?, "+
							"		OTHERREGULATORYCOUNTRY = ?, FACETOFACEINTRACTION = ?, REASONFORNOINTRACTION = ?, "+
							"		RESIDENTIALADDRESS = ?, MAILINGADDRESS = ?, BUSINESSTYPE = ?, OTHERBUSINESSTYPE = ?, "+
							"		NATUREOFBUSINESS = ?, PANNO = ?, AADHARNO = ?, OCCUPATION = ?, OTHEROCCUPATION = ?, "+
							"		PURPOSEOFACCOUNT = ?, SOURCEOFFUND = ?, OTHERSOURCEOFFUND = ?, COUNRYOFINCORPORATION = ?, "+
							"		DATEOFINCORPORATION = ?, PRINCIPALCOUNTRIES = ?, PRINCIPALCOUNTRIESNAMES = ?, "+
							"		COMPANYSTRUCTURETYPE = ?, OTHERCOMPANYSTRUCTURE = ?, DOMICILE = ?, CITIZEN = ?, "+
							"		PRODUCTSERVICE_TD = ?, PRODUCTSERVICE_SA = ?, PRODUCTSERVICE_GR = ?, PRODUCTSERVICE_CA = ?, "+
							"		PRODUCTSERVICE_LN = ?, PRODUCTSERVICE_RE = ?, PRODUCTSERVICE_IB = ?, PRODUCTSERVICE_TF = ?, "+
							"		PRODUCTSERVICE_OT = ?, OTHERPRODUCTSERVICE = ?, EXPECTEDTXNAMT = ?, EXPECTEDTXNCURRENCY = ?, "+
							"		EXPECTEDTXNFRQ = ?, INTERMEDIARIESTYPE = ?, INTERMEDIARIESTYPEOTHER = ?, CLAFMATCH = ?, "+
							"		SLSMATCH = ?, PEPMATCH = ?, ADVINFO = ?, ASEMATCH = ?, OTHERMATCH = ?, SCREENINGMATCHDETAILS = ?, "+
							"		DIRECTDEALINGWITHSANCTION = ?, SANCTIONCOUNTRIES = ?, SANCTIONSCREENHITS = ?, SANCTIONGOODSSERVICE = ?, "+
							"		SANCTIONINVOLVEMENT = ?, SOURCEOFWEALTH = ?, OTHERSOURCEOFWEALTH = ?, ADDITIONALINFORMATION  = ?, "+
							"		PASSPORT = ?, DRIVINGLICENCE = ?, EXPECTEDTXNCOUNT = ?, "+
							"		ATTRIBUTETYPERISKRATING_DESC = ?, ATTRIBUTETYPERISKRATING_VALUE = ?, ATTRIBUTETYPERISKRATING = ?, "+
							"		INDUSTRYTYPERISKRATING_DESC = ?, INDUSTRYTYPERISKRATING_VALUE = ?, INDUSTRYTYPERISKRATING = ?, "+
							"		INCROPCOUNTRYRISKRATING_DESC = ?, INCROPCOUNTRYRISKRATING_VALUE = ?, INCROPCOUNTRYRISKRATING = ?, "+
							"		PRINCICOUNTRYRISKRATING_DESC = ?, PRINCICOUNTRYRISKRATING_VALUE = ?, PRINCICOUNTRYRISKRATING = ?, "+
							"		GEOGRAPHICRISKRATING_VALUE = ?, GEOGRAPHICRISKRATING = ?, ECONOMICSANCTIONS = ?, SANCTIONJURISDICTION = ?, "+
							"		PRODUCTRISKRATING_DESC = ?, PRODUCTRISKRATING_VALUE = ?, PRODUCTRISKRATING = ?, RISKRATINGCHANNEL_1 = ?, "+
							"		RISKRATINGCHANNEL_2 = ?, RISKRATINGCHANNEL_3 = ?, RISKRATINGCHANNEL_4 = ?, CHANNELRISKRATING_VALUE = ?, "+
							"		CHANNELRISKRATING = ?, SYSTEMRISKRATING = ?, RR_CHARACTERISTICS_1 = ?, RR_CHARACTERISTICS_2 = ?, "+
							"		RR_CHARACTERISTICS_3 = ?, RR_CHARACTERISTICS_4 = ?, RR_CHARACTERISTICS_5 = ?, RR_CHARACTERISTICS_6 = ?, "+
							"		RR_CHARACTERISTICS_7 = ?, PROVISIONALRISKRATING = ?, FINALRISKRATING = ?, RISKRATINGREASON = ?, "+
							"		REVIEWPURPOSE = ?, OTHERREVIEWPURPOSE = ?, CUSTCONTACTDATE = ?, CUSTCONTACTMETHOD = ?, CUSTCONTACTNAME = ?, CUSTCONTACTPOSITION = ?, "+
							"		PANNSDLRESPONSE = ?, MIZUHOBRANCHSUBSIDIARIES = ?, FRGNCRSPNDNTBNKCSTOMR = ?, FRGNCRSPNDNTBNKCSTOMRHR = ?, "+
							"		NGOCHARITY = ?, CASHINTENSIVE = ?, EMBASSYCUSTOMER = ?, RESIDENTIALADDRESS2 = ?, RESIDENTIALADDRESS3 = ?, "+
							"		MAILINGADDRESS2 = ?, MAILINGADDRESS3 = ?, CUSTOMERID = ?, "+
							"       NGOCUSTOMER = ?, TRUSTCUSTOMER = ?, CKYCNO = ?, "+
							"		STATUS = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
							" WHERE COMPASSREFNO = ? "+
							"   AND LINENO = ? ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, formData.get("CUSTOMERNAME"));
			preparedStatement.setString(2, formData.get("CUSTOMERPREVNAME"));
			preparedStatement.setString(3, formData.get("CUSTOMERALIASNAME"));
			preparedStatement.setString(4, formData.get("RELATIONSHIPMANAGER"));
			preparedStatement.setString(5, formData.get("DEPTINCHARGE"));
			
			preparedStatement.setString(6, formData.get("EXISTINGCUSTOMER"));
			preparedStatement.setString(7, formData.get("EXISTINGBRANCH"));
			preparedStatement.setString(8, formData.get("EXISTINGRISKRATING"));
			preparedStatement.setString(9, formData.get("GENERALCHECKING1"));
			preparedStatement.setString(10, formData.get("GENERALCHECKING2"));
			
			preparedStatement.setString(11, formData.get("GENERALCHECKING3"));
			preparedStatement.setString(12, formData.get("GENERALCHECKING4"));
			preparedStatement.setString(13, formData.get("GENERALCHECKING5"));
			preparedStatement.setString(14, formData.get("GENERALCHECKING6"));
			preparedStatement.setString(15, formData.get("GENERALCHECKING7"));
			
			preparedStatement.setString(16, formData.get("GOVERNMENTENTITY"));
			preparedStatement.setString(17, formData.get("GOVERNMENTENTITYCOUNTRY"));
			preparedStatement.setString(18, formData.get("ENTITYSTOCKEXCHANGE"));
			preparedStatement.setString(19, formData.get("ENTITYSTKEXCHNGCOUNTRY"));
			preparedStatement.setString(20, formData.get("CUSTOMERSTOCKEXCHANGE"));
			
			preparedStatement.setString(21, formData.get("CUSTOMERSTKEXCHNGCOUNTRY"));
			preparedStatement.setString(22, formData.get("OTHERREGULATORY"));
			preparedStatement.setString(23, formData.get("OTHERREGULATORYCOUNTRY"));
			preparedStatement.setString(24, formData.get("FACETOFACEINTRACTION"));
			preparedStatement.setString(25, formData.get("REASONFORNOINTRACTION"));
			
			preparedStatement.setString(26, formData.get("RESIDENTIALADDRESS"));
			preparedStatement.setString(27, formData.get("MAILINGADDRESS"));
			preparedStatement.setString(28, formData.get("BUSINESSTYPE"));
			preparedStatement.setString(29, formData.get("OTHERBUSINESSTYPE"));
			preparedStatement.setString(30, formData.get("NATUREOFBUSINESS"));
			
			preparedStatement.setString(31, formData.get("PANNO"));
			preparedStatement.setString(32, formData.get("AADHARNO"));
			preparedStatement.setString(33, formData.get("OCCUPATION"));
			preparedStatement.setString(34, formData.get("OTHEROCCUPATION"));
			preparedStatement.setString(35, formData.get("PURPOSEOFACCOUNT"));
			
			preparedStatement.setString(36, formData.get("SOURCEOFFUND"));
			preparedStatement.setString(37, formData.get("OTHERSOURCEOFFUND"));
			preparedStatement.setString(38, formData.get("COUNRYOFINCORPORATION"));
			preparedStatement.setString(39, formData.get("DATEOFINCORPORATION"));
			preparedStatement.setString(40, formData.get("PRINCIPALCOUNTRIES"));
			
			preparedStatement.setString(41, formData.get("PRINCIPALCOUNTRIESNAMES"));
			preparedStatement.setString(42, formData.get("COMPANYSTRUCTURETYPE"));
			preparedStatement.setString(43, formData.get("OTHERCOMPANYSTRUCTURE"));
			preparedStatement.setString(44, formData.get("DOMICILE"));
			preparedStatement.setString(45, formData.get("CITIZEN"));
			
			preparedStatement.setString(46, formData.get("PRODUCTSERVICE_TD"));
			preparedStatement.setString(47, formData.get("PRODUCTSERVICE_SA"));
			preparedStatement.setString(48, formData.get("PRODUCTSERVICE_GR"));
			preparedStatement.setString(49, formData.get("PRODUCTSERVICE_CA"));
			preparedStatement.setString(50, formData.get("PRODUCTSERVICE_LN"));
			
			preparedStatement.setString(51, formData.get("PRODUCTSERVICE_RE"));
			preparedStatement.setString(52, formData.get("PRODUCTSERVICE_IB"));
			preparedStatement.setString(53, formData.get("PRODUCTSERVICE_TF"));
			preparedStatement.setString(54, formData.get("PRODUCTSERVICE_OT"));
			preparedStatement.setString(55, formData.get("OTHERPRODUCTSERVICE"));
			
			preparedStatement.setString(56, formData.get("EXPECTEDTXNAMT"));
			preparedStatement.setString(57, formData.get("EXPECTEDTXNCURRENCY"));
			preparedStatement.setString(58, formData.get("EXPECTEDTXNFRQ"));
			preparedStatement.setString(59, formData.get("INTERMEDIARIESTYPE"));
			preparedStatement.setString(60, formData.get("INTERMEDIARIESTYPEOTHER"));
			
			preparedStatement.setString(61, formData.get("CLAFMATCH"));
			preparedStatement.setString(62, formData.get("SLSMATCH"));
			preparedStatement.setString(63, formData.get("PEPMATCH"));
			preparedStatement.setString(64, formData.get("ADVINFO"));
			preparedStatement.setString(65, formData.get("ASEMATCH"));
			
			preparedStatement.setString(66, formData.get("OTHERMATCH"));
			preparedStatement.setString(67, formData.get("SCREENINGMATCHDETAILS"));
			preparedStatement.setString(68, formData.get("DIRECTDEALINGWITHSANCTION"));
			preparedStatement.setString(69, formData.get("SANCTIONCOUNTRIES"));
			preparedStatement.setString(70, formData.get("SANCTIONSCREENHITS"));
			
			preparedStatement.setString(71, formData.get("SANCTIONGOODSSERVICE"));
			preparedStatement.setString(72, formData.get("SANCTIONINVOLVEMENT"));
			preparedStatement.setString(73, formData.get("SOURCEOFWEALTH"));
			preparedStatement.setString(74, formData.get("OTHERSOURCEOFWEALTH"));
			preparedStatement.setString(75, formData.get("ADDITIONALINFORMATION"));
			
			preparedStatement.setString(76, formData.get("PASSPORT"));
			preparedStatement.setString(77, formData.get("DRIVINGLICENCE"));
			preparedStatement.setString(78, formData.get("EXPECTEDTXNCOUNT"));
			
			preparedStatement.setString(79, formData.get("ATTRIBUTETYPERISKRATING_DESC"));
			preparedStatement.setString(80, formData.get("ATTRIBUTETYPERISKRATING_VALUE"));
			preparedStatement.setString(81, formData.get("ATTRIBUTETYPERISKRATING"));
			preparedStatement.setString(82, formData.get("INDUSTRYTYPERISKRATING_DESC"));
			preparedStatement.setString(83, formData.get("INDUSTRYTYPERISKRATING_VALUE"));
			
			preparedStatement.setString(84, formData.get("INDUSTRYTYPERISKRATING"));
			preparedStatement.setString(85, formData.get("INCROPCOUNTRYRISKRATING_DESC"));
			preparedStatement.setString(86, formData.get("INCROPCOUNTRYRISKRATING_VALUE"));
			preparedStatement.setString(87, formData.get("INCROPCOUNTRYRISKRATING"));
			preparedStatement.setString(88, formData.get("PRINCICOUNTRYRISKRATING_DESC"));
			
			preparedStatement.setString(89, formData.get("PRINCICOUNTRYRISKRATING_VALUE"));
			preparedStatement.setString(90, formData.get("PRINCICOUNTRYRISKRATING"));
			preparedStatement.setString(91, formData.get("GEOGRAPHICRISKRATING_VALUE"));
			preparedStatement.setString(92, formData.get("GEOGRAPHICRISKRATING"));
			preparedStatement.setString(93, formData.get("ECONOMICSANCTIONS"));
			
			preparedStatement.setString(94, formData.get("SANCTIONJURISDICTION"));
			preparedStatement.setString(95, formData.get("PRODUCTRISKRATING_DESC"));
			preparedStatement.setString(96, formData.get("PRODUCTRISKRATING_VALUE"));
			preparedStatement.setString(97, formData.get("PRODUCTRISKRATING"));
			preparedStatement.setString(98, formData.get("RISKRATINGCHANNEL_1"));
			
			preparedStatement.setString(99, formData.get("RISKRATINGCHANNEL_2"));
			preparedStatement.setString(100, formData.get("RISKRATINGCHANNEL_3"));
			preparedStatement.setString(101, formData.get("RISKRATINGCHANNEL_4"));
			preparedStatement.setString(102, formData.get("CHANNELRISKRATING_VALUE"));
			preparedStatement.setString(103, formData.get("CHANNELRISKRATING"));
			
			preparedStatement.setString(104, formData.get("SYSTEMRISKRATING"));
			preparedStatement.setString(105, formData.get("RR_CHARACTERISTICS_1"));
			preparedStatement.setString(106, formData.get("RR_CHARACTERISTICS_2"));
			preparedStatement.setString(107, formData.get("RR_CHARACTERISTICS_3"));
			preparedStatement.setString(108, formData.get("RR_CHARACTERISTICS_4"));
			
			preparedStatement.setString(109, formData.get("RR_CHARACTERISTICS_5"));
			preparedStatement.setString(110, formData.get("RR_CHARACTERISTICS_6"));
			preparedStatement.setString(111, formData.get("RR_CHARACTERISTICS_7"));
			preparedStatement.setString(112, formData.get("PROVISIONALRISKRATING"));
			preparedStatement.setString(113, formData.get("FINALRISKRATING"));
			
			preparedStatement.setString(114, formData.get("RISKRATINGREASON"));
			preparedStatement.setString(115, formData.get("REVIEWPURPOSE"));
			preparedStatement.setString(116, formData.get("OTHERREVIEWPURPOSE"));
			preparedStatement.setString(117, formData.get("CUSTCONTACTDATE"));
			preparedStatement.setString(118, formData.get("CUSTCONTACTMETHOD"));
			preparedStatement.setString(119, formData.get("CUSTCONTACTNAME"));
			preparedStatement.setString(120, formData.get("CUSTCONTACTPOSITION"));
			
			preparedStatement.setString(121, formData.get("PANNSDLRESPONSE"));
			preparedStatement.setString(122, formData.get("MIZUHOBRANCHSUBSIDIARIES"));
			preparedStatement.setString(123, formData.get("FRGNCRSPNDNTBNKCSTOMR"));
			preparedStatement.setString(124, formData.get("FRGNCRSPNDNTBNKCSTOMRHR"));
			preparedStatement.setString(125, formData.get("NGOCHARITY"));
			preparedStatement.setString(126, formData.get("CASHINTENSIVE"));
			preparedStatement.setString(127, formData.get("EMBASSYCUSTOMER"));
			
			preparedStatement.setString(128, formData.get("RESIDENTIALADDRESS2"));
			preparedStatement.setString(129, formData.get("RESIDENTIALADDRESS3"));
			preparedStatement.setString(130, formData.get("MAILINGADDRESS2"));
			preparedStatement.setString(131, formData.get("MAILINGADDRESS3"));
			preparedStatement.setString(132, formData.get("CUSTOMERID"));
			
			preparedStatement.setString(133, formData.get("NGOCUSTOMER"));
			preparedStatement.setString(134, formData.get("TRUSTCUSTOMER"));
			preparedStatement.setString(135, formData.get("CKYCNO"));
			
			preparedStatement.setString(136, status);
			preparedStatement.setString(137, userCode);
			preparedStatement.setString(138, compassRefNo);
			preparedStatement.setString(139, lineNo);
			recordCount = preparedStatement.executeUpdate();
			}
			else {
				List<String> tableColumns = new ArrayList<String>();;
				query = "SELECT COLUMN_NAME FROM ALL_TAB_COLUMNS "+
				        " WHERE OWNER = 'COMAML' "+
				        "   AND TABLE_NAME = 'TB_CDDFORM' "+
				        " ORDER BY COLUMN_ID "; 
				preparedStatement = connection.prepareStatement(query);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					tableColumns.add(resultSet.getString("COLUMN_NAME"));
				}
				
				Iterator<String> itr = formData.keySet().iterator();
				while(itr.hasNext()){
					preparedStatement = null;
					// recordCount = 0;
					columnName = itr.next();
					columnValue = formData.get(columnName);
					if(tableColumns.contains(columnName.trim().toUpperCase())){
					query = "UPDATE "+schemaName+"TB_CDDFORM SET "+columnName+" = ?, "+
							"		STATUS = ?, UPDATEBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
							" WHERE COMPASSREFNO = ? "+
							"   AND LINENO = ? "; 
					// System.out.println("columnName : "+columnName+" , And columnValue : "+columnValue);
					// System.out.println("query : "+query);
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, columnValue);
					preparedStatement.setString(2, status);
					preparedStatement.setString(3, userCode);
					preparedStatement.setString(4, compassRefNo);
					preparedStatement.setString(5, lineNo);
					recordCount = preparedStatement.executeUpdate();
					}
				}
			}
			
			if(recordCount == 1){
				responseMessage.put("STATUS", "1");
				responseMessage.put("MSG", "CDD Form updated successfully");
			}else{
				responseMessage.put("STATUS", "0");
				responseMessage.put("MSG", "No record updated");
			}
			
			
			
			
		}catch(Exception e){
			responseMessage.put("STATUS", "0");
			responseMessage.put("MSG", "Error while saving CDD form");
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return responseMessage;
	}
	
	public String saveCDDCheckList(Map<String, String> formData, String compassRefNo, String lineNo, String status, String userRole){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		try{
			String query = "UPDATE "+schemaName+"TB_CDDCHECKLIST SET ";
			Iterator<String> itr = formData.keySet().iterator();
			while(itr.hasNext()){
				String columnName = itr.next();
				String columnValue = formData.get(columnName);
				query = query + columnName+ " = '"+columnValue+"', ";
			}
			query = query + " COMPASSREFNO = '"+compassRefNo+"' "+
							" WHERE COMPASSREFNO = ? "+
							"   AND LINENO = ? ";
			// System.out.println(" query in CDDFormDAOImpl is : "+query);
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, lineNo);
			preparedStatement.executeUpdate();
			message = "1";
		}catch(Exception e){
			message = "0";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public List<Map<String, String>> getCDDCountryMaster(){
		List<Map<String, String>> countryMaster = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNTRYNAME, RATING FROM "+schemaName+"TB_CDD_COUNTRYMASTER");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> country = new HashMap<String, String>();
				country.put("OPTIONNAME", resultSet.getString("COUNTRYNAME"));
				country.put("OPTIONVALUE", resultSet.getString("COUNTRYNAME"));
				country.put("RISKRATING", resultSet.getString("RATING"));
				
				countryMaster.add(country);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return countryMaster;
	}
	
	public List<Map<String, String>> getCDDStockExchangeMaster(){
		List<Map<String, String>> stockExchangeMaster = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT NAME FROM "+schemaName+"TB_CDD_STOCKEXCHANGE");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> stockExchange = new HashMap<String, String>();
				stockExchange.put("OPTIONNAME", resultSet.getString("NAME"));
				stockExchange.put("OPTIONVALUE", resultSet.getString("NAME"));
				
				stockExchangeMaster.add(stockExchange);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return stockExchangeMaster;
	}
	
	public List<Map<String, String>> getCDDIndustryOccupationType(){
		List<Map<String, String>> industryOccupationTypeMaster = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT DESCRIPTION, RATING FROM "+schemaName+"TB_CDD_OCCUPATIONINDUSTRY");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> industryOccupationType = new HashMap<String, String>();
				industryOccupationType.put("OPTIONNAME", resultSet.getString("DESCRIPTION"));
				industryOccupationType.put("OPTIONVALUE", resultSet.getString("DESCRIPTION"));
				industryOccupationType.put("RISKRATING", resultSet.getString("RATING"));
				
				industryOccupationTypeMaster.add(industryOccupationType);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return industryOccupationTypeMaster;
	}
	
	
	public List<Map<String, String>> getCDDAttributeType(){
		List<Map<String, String>> attributeTypeMaster = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT DESCRIPTION, RATING FROM "+schemaName+"TB_CDD_ATTRIBUTETYPE");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> attributeType = new HashMap<String, String>();
				attributeType.put("OPTIONNAME", resultSet.getString("DESCRIPTION"));
				attributeType.put("OPTIONVALUE", resultSet.getString("DESCRIPTION"));
				attributeType.put("RISKRATING", resultSet.getString("RATING"));
				
				attributeTypeMaster.add(attributeType);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return attributeTypeMaster;
	}
	
	public List<Map<String, String>> getCDDSourceOfFund(){
		List<Map<String, String>> sourceOfFundMaster = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT DESCRIPTION FROM "+schemaName+"TB_CDD_SOURCEOFFUND");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> sourceOfFund = new HashMap<String, String>();
				sourceOfFund.put("OPTIONNAME", resultSet.getString("DESCRIPTION"));
				sourceOfFund.put("OPTIONVALUE", resultSet.getString("DESCRIPTION"));
				
				sourceOfFundMaster.add(sourceOfFund);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return sourceOfFundMaster;
	}
	
	public List<Map<String, String>> getCDDCurrencyMaster(){
		List<Map<String, String>> currencyMaster = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT CURRENCYCODE, CURRENCYNAME FROM "+schemaName+"TB_CURRENCYMASTER ORDER BY CURRENCYNAME");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> sourceOfFund = new HashMap<String, String>();
				sourceOfFund.put("OPTIONNAME", resultSet.getString("CURRENCYCODE"));
				sourceOfFund.put("OPTIONVALUE", resultSet.getString("CURRENCYNAME"));
				
				currencyMaster.add(sourceOfFund);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return currencyMaster;
	}
	
	public Map<String, String> calculateIndvRiskRating(String CHANNELRISKRATING, String PRODUCTRISKRATING, 
			String GEOGRAPHICRISKRATING, String INDUSTRYTYPERISKRATING){
		Map<String, String> riskRating = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT DUEDILIGENCE, RISKRATING "+
															"  FROM "+schemaName+"TB_CDD_INDV_RRMATRIX "+
															" WHERE INDUSTRYOCCUPATIONTYPERISK = ? "+
															"	AND GEOGRAPHICRISK = ? "+
															"	AND PRODUCTANDSERVICESRISK = ? "+
															"	AND CHANNELRISK = ? ");
			preparedStatement.setString(1, INDUSTRYTYPERISKRATING);
			preparedStatement.setString(2, GEOGRAPHICRISKRATING);
			preparedStatement.setString(3, PRODUCTRISKRATING);
			preparedStatement.setString(4, CHANNELRISKRATING);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				String RISKRATING = resultSet.getString("RISKRATING");
				riskRating.put("DUEDILIGENCE", resultSet.getString("DUEDILIGENCE"));
				riskRating.put("RISKRATING", RISKRATING);
				if("1".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "Low");
				} else if("2".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "Low");
				} else if("3".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "Medium");
				} else if("4".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "High");
				} else if("5".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "High");
				}
				
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return riskRating;
	}
	
	public Map<String, String> calculateCorpRiskRating(String CHANNELRISKRATING, String PRODUCTRISKRATING, 
			String GEOGRAPHICRISKRATING, String INDUSTRYTYPERISKRATING, String ATTRIBUTETYPERISKRATING){
		Map<String, String> riskRating = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT DUEDILIGENCE, RISKRATING "+
															"  FROM "+schemaName+"TB_CDD_CROP_RRMATRIX "+
															" WHERE ATTRIBUTETYPERISK = ? "+
															"   AND INDUSTRYOCCUPATIONTYPERISK = ? "+
															"	AND GEOGRAPHICRISK = ? "+
															"	AND PRODUCTANDSERVICESRISK = ? "+
															"	AND CHANNELRISK = ? ");
			preparedStatement.setString(1, ATTRIBUTETYPERISKRATING);
			preparedStatement.setString(2, INDUSTRYTYPERISKRATING);
			preparedStatement.setString(3, GEOGRAPHICRISKRATING);
			preparedStatement.setString(4, PRODUCTRISKRATING);
			preparedStatement.setString(5, CHANNELRISKRATING);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				String RISKRATING = resultSet.getString("RISKRATING");
				riskRating.put("DUEDILIGENCE", resultSet.getString("DUEDILIGENCE"));
				riskRating.put("RISKRATING", RISKRATING);
				if("1".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "Low");
				} else if("2".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "Low");
				} else if("3".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "Medium");
				} else if("4".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "High");
				} else if("5".equals(RISKRATING)){
					riskRating.put("RISKRATINGTEXT", "High");
				}
				
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return riskRating;
	}
	
	public int checkAccountOpeningKyogi(String compassRefNo, String type){
		int count = 0;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(1) FROM "+schemaName+"TB_CDD_ACCOUNTOPENINGKYOGI WHERE COMPASSREFNO = ? AND KYOGIFOR = ? ");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, type);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				count = resultSet.getInt(1);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return count;
	}
	
	public void createAFA(String compassRefNo, String kyogiType, String userCode){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDD_ACCOUNTOPENINGKYOGI(COMPASSREFNO, KYOGIFOR, CREATEDBY, CREATIONTIMESTAMP, UPDATEDBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, kyogiType);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, userCode);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}	
	}
	
	public Map<String, String> getAFAData(String compassRefNo, String lineNo, String kyogiType){
		Map<String, String> afaData = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "SELECT A.LINEOFBUSINESS, A.AUTHORISEDSHARECAPITAL, A.NUMBEROFSTAFF, A.HISTORY, A.MONTHLYTURNOVER, "+
						"		A.PARENTCOMPANY, A.ULTIMATEPARENTCOMPANY, A.THEIRSALES, A.THEIRPURCHASE, A.BANK, A.DOCUMENTSSUBMITTED, "+
						"		A.REMARKS, A.DATEOFVISITTOCUSTOMER, A.VISITEDBY, A.CUSTOMERIDCONFIRMED, A.DOWJONESRISKCHECKDATE, "+
						"		A.DOWJONESRISKCHECKREMARK, A.ESLHOSEARCHONDATE, A.ESLHOSEARCHONREMARK, A.UNCONCHECKDATE, "+
						"		A.UNCONCHECKREMARK, A.PANVERIFICATIONCHECKDATE, A.PANVERIFICATIONCHECKREMARK, A.CRILCCHECKDATE, "+
						"		A.CRILCCHECKREMARK, A.MANAGEMENTCOMMENT, A.DATEOFOPENING, A.CREATEDBY, A.CREATIONTIMESTAMP, "+
						"		A.UPDATEDBY, A.UPDATETIMESTAMP, A.BPACHECKED, "+
						"		A.BPDCHECKED, A.COMPCHECKED, A.JGMCHECKED, A.GMCHECKED, B.CUSTOMERNAME, "+
						"		B.RESIDENTIALADDRESS || ', ' || B.RESIDENTIALADDRESS2 || ', '|| B.RESIDENTIALADDRESS3 RESIDENTIALADDRESS, "+
						"		B.MAILINGADDRESS || ', ' || B.MAILINGADDRESS2 || ', ' || B.MAILINGADDRESS3 MAILINGADDRESS, "+
						"		B.DATEOFINCORPORATION, B.FINALRISKRATING "+
						"  FROM "+schemaName+"TB_CDD_ACCOUNTOPENINGKYOGI A "+
						"  LEFT OUTER JOIN "+schemaName+"TB_CDDFORM B ON A.COMPASSREFNO = B.COMPASSREFNO "+
						" WHERE A.COMPASSREFNO = ? "+
						"   AND A.KYOGIFOR = ? "+
						"   AND B.LINENO = ? ";
								
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, kyogiType);
			preparedStatement.setString(3, lineNo);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			
			while(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					afaData.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return afaData;
	}
	
	public String saveAFA(Map<String, String> dataMap, String userCode){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String query = "UPDATE "+schemaName+"TB_CDD_ACCOUNTOPENINGKYOGI "+
					   "   SET LINEOFBUSINESS = ?, AUTHORISEDSHARECAPITAL = ?, NUMBEROFSTAFF = ?, HISTORY = ?, MONTHLYTURNOVER = ?, "+
					   "	   PARENTCOMPANY = ?, ULTIMATEPARENTCOMPANY = ?, THEIRSALES = ?, THEIRPURCHASE = ?, BANK = ?, "+
					   "	   DOCUMENTSSUBMITTED = ?, REMARKS = ?, DATEOFVISITTOCUSTOMER = ?, VISITEDBY = ?, CUSTOMERIDCONFIRMED = ?, "+
					   "	   DOWJONESRISKCHECKDATE = ?, DOWJONESRISKCHECKREMARK = ?, ESLHOSEARCHONDATE = ?, ESLHOSEARCHONREMARK = ?, "+
					   "	   UNCONCHECKDATE = ?, UNCONCHECKREMARK = ?, PANVERIFICATIONCHECKDATE = ?, PANVERIFICATIONCHECKREMARK = ?, "+
					   "	   CRILCCHECKDATE = ?, CRILCCHECKREMARK = ?, MANAGEMENTCOMMENT = ?, DATEOFOPENING = ?, UPDATEDBY = ?, ";
		if("GM".equals(dataMap.get("KYOGIAPPROVAL"))){
			query = query + "  GMCHECKED = '"+userCode+"', ";
		}
		if("JGM".equals(dataMap.get("KYOGIAPPROVAL"))){
			query = query + "  JGMCHECKED = '"+userCode+"', ";
		}
		if("COMP".equals(dataMap.get("KYOGIAPPROVAL"))){
			query = query + "  COMPCHECKED = '"+userCode+"', ";
		}
		if("BPD".equals(dataMap.get("KYOGIAPPROVAL"))){
			query = query + "  BPDCHECKED = '"+userCode+"', ";
		}
		if("BPA".equals(dataMap.get("KYOGIAPPROVAL"))){
			query = query + "  BPACHECKED = '"+userCode+"', ";
		}
		
		query = query +"       UPDATETIMESTAMP = SYSTIMESTAMP "+
					   " WHERE COMPASSREFNO = ? "+
					   "   AND KYOGIFOR = ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, dataMap.get("LINEOFBUSINESS"));
			preparedStatement.setString(2, dataMap.get("AUTHORISEDSHARECAPITAL"));
			preparedStatement.setString(3, dataMap.get("NUMBEROFSTAFF"));
			preparedStatement.setString(4, dataMap.get("HISTORY"));
			preparedStatement.setString(5, dataMap.get("MONTHLYTURNOVER"));
			
			preparedStatement.setString(6, dataMap.get("PARENTCOMPANY"));
			preparedStatement.setString(7, dataMap.get("ULTIMATEPARENTCOMPANY"));
			preparedStatement.setString(8, dataMap.get("THEIRSALES"));
			preparedStatement.setString(9, dataMap.get("THEIRPURCHASE"));
			preparedStatement.setString(10, dataMap.get("BANK"));
			
			preparedStatement.setString(11, dataMap.get("DOCUMENTSSUBMITTED"));
			preparedStatement.setString(12, dataMap.get("REMARKS"));
			preparedStatement.setString(13, dataMap.get("DATEOFVISITTOCUSTOMER"));
			preparedStatement.setString(14, dataMap.get("VISITEDBY"));
			preparedStatement.setString(15, dataMap.get("CUSTOMERIDCONFIRMED"));
			
			preparedStatement.setString(16, dataMap.get("DOWJONESRISKCHECKDATE"));
			preparedStatement.setString(17, dataMap.get("DOWJONESRISKCHECKREMARK"));
			preparedStatement.setString(18, dataMap.get("ESLHOSEARCHONDATE"));
			preparedStatement.setString(19, dataMap.get("ESLHOSEARCHONREMARK"));
			preparedStatement.setString(20, dataMap.get("UNCONCHECKDATE"));
			
			preparedStatement.setString(21, dataMap.get("UNCONCHECKREMARK"));
			preparedStatement.setString(22, dataMap.get("PANVERIFICATIONCHECKDATE"));
			preparedStatement.setString(23, dataMap.get("PANVERIFICATIONCHECKREMARK"));
			preparedStatement.setString(24, dataMap.get("CRILCCHECKDATE"));
			preparedStatement.setString(25, dataMap.get("CRILCCHECKREMARK"));
			
			preparedStatement.setString(26, dataMap.get("MANAGEMENTCOMMENT"));
			preparedStatement.setString(27, dataMap.get("DATEOFOPENING"));
			preparedStatement.setString(28, dataMap.get("UPDATEDBY"));
			preparedStatement.setString(29, dataMap.get("COMPASSREFERENCENO"));
			preparedStatement.setString(30, dataMap.get("KYOGIFOR"));
			int x = preparedStatement.executeUpdate();
			if(x == 1){
				message ="Account Opening Kyogi successfully updated";
			}else
				message ="Account Opening Kyogi is not updated";
		}catch(Exception e){
			message ="Error while updating Account Opening Kyogi";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String saveScreeningMapping(String compassRefNo, String uniqueNumber, String fileName, String cddFormType, String cddNameType, String cddNameLineNo, String userCode, String userRole, String ipAddress){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String tableName = "";
		String queryString = "";
		try{
			preparedStatement = connection.prepareStatement("INSERT INTO "+schemaName+"TB_CDD_SCREENINGMAPPING(COMPASSREFNO, UNIQUENUMBER, FILENAME, CDDFORMTYPE, CDDNAMETYPE, CDDNAMELINENO, USERCODE, USERROLE, IPADDRESS, UPDATEDBY, UPDATETIMESTAMP) "+
															"VALUES (?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP)");
			preparedStatement.setString(1, compassRefNo);
			preparedStatement.setString(2, uniqueNumber);
			preparedStatement.setString(3, fileName);
			preparedStatement.setString(4, cddFormType);
			preparedStatement.setString(5, cddNameType);
			preparedStatement.setString(6, cddNameLineNo);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, userRole);
			preparedStatement.setString(9, ipAddress);
			preparedStatement.setString(10, userRole);
			preparedStatement.executeUpdate();
			
			if(cddNameType.equals("CUSTOMERNAME")){
				tableName = ""+schemaName+"TB_CDDFORM";
			} else if(cddNameType.equals("NOMINEEDETAIL")){
				tableName = ""+schemaName+"TB_CDDNOMINEEDETAIL";
			} else if(cddNameType.equals("JOINTHOLDER")){
				tableName = ""+schemaName+"TB_CDDJOINTHOLDER";
			} else if(cddNameType.equals("INTERMEDIARY")){
				tableName = ""+schemaName+"TB_CDDINTERMEDIARY";
			} else if(cddNameType.equals("PEP")){
				tableName = ""+schemaName+"TB_CDDPEP";
			} else if(cddNameType.equals("BENEFICIALOWNER")){
				tableName = ""+schemaName+"TB_CDDBENEFICIALOWNER";
			}else if(cddNameType.equals("DIRECTOR")){
				tableName = ""+schemaName+"TB_CDDDIRECTOR";
			}else if(cddNameType.equals("AUTHORIZEDSIGNATORY")){
				tableName = ""+schemaName+"TB_CDDAUTHORIZESIGNATORY";
			}
			
			queryString = "UPDATE "+tableName+" A "+
			              "   SET A.SCREENINGREFERENCENO = ? "+
			              " WHERE COMPASSREFNO = ? "+
			              "   AND LINENO = ? ";
			preparedStatement = connection.prepareStatement(queryString);
			preparedStatement.setString(1, fileName);
			preparedStatement.setString(2, compassRefNo); 
			preparedStatement.setString(3, cddNameLineNo); 
			preparedStatement.executeUpdate();

		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}	
		return "";
	}
	
	public Map<String, String> getCDDEmailDetails(String compassRefNo, String lineNo, String userCode, String userRole, String currentStatus, String newStatus, String message){	
		Map<String, String> cddEmailDetails = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETCDDEMAILDETAILS(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, compassRefNo);
			callableStatement.setString(2, lineNo);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, currentStatus);
			callableStatement.setString(6, newStatus);
			callableStatement.setString(7, message);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(8);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int columnCount = resultSetMetaData.getColumnCount();
			
			if(resultSet.next()){
				for(int i = 1; i <= columnCount; i++){
					String columnName = resultSetMetaData.getColumnName(i);
					cddEmailDetails.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return cddEmailDetails;
	}
}
