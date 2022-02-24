package com.quantumdataengines.app.compass.dao.checker;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.mail.Session;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.dao.Query;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class CheckerDAOImpl implements CheckerDAO{
	
private static final Logger log = LoggerFactory.getLogger(CheckerDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public List<Map<String, String>> getAllIPAddressForCheck(){
		List<Map<String, String>> allIPAddressList = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement prepredStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT IPADDRESS, MAKERCODE "+ 
					   "  FROM TB_IPADDRESS_CHECKERACTIVITY "+
					   " WHERE ACTIONSTATUS = ? ";
		try{
			prepredStatement = connection.prepareStatement(query);
			prepredStatement.setString(1, "P");
			resultSet = prepredStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> ipDetails = new HashMap<String, String>();
				ipDetails.put("VALUE", resultSet.getString("IPADDRESS")+","+resultSet.getString("MAKERCODE"));
				ipDetails.put("DISPLAY", resultSet.getString("IPADDRESS"));
				allIPAddressList.add(ipDetails);
			}
		}catch(Exception e){
			log.error("Error while getting all IP address details for check : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
		}
		return allIPAddressList;
	}
	
	@Override
	public Map<String, String> getIPDetailsForChecker(String ipAddress, String makerCode){
		boolean isNewIPAddress = false;
		Map<String, String> ipDetails = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement prepredStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME, CASE NVL(A.ISENABLED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END MAKERISENABLED, A.MAKERCODE MAKERCODE, "+
					   "	   B.ISNEWIPADDRESS ISNEWIPADDRESS, B.UPDATEDBY MAKERUPDATEDBY, "+
					   "	   CASE NVL(B.UPDATETIMESTAMP, NULL) WHEN NULL THEN '''' ELSE TO_CHAR(B.UPDATETIMESTAMP,'DD/MM/YYYY') END MAKERUPDATETIMESTAMP "+
					   "  FROM TB_IPADDRESS_MAKER A, TB_IPADDRESS_CHECKERACTIVITY B "+
					   " WHERE A.MAKERCODE = B.MAKERCODE "+
					   "   AND A.IPADDRESS = ? "+
					   "   AND A.MAKERCODE = ?";
		try{
			prepredStatement = connection.prepareStatement(query);
			prepredStatement.setString(1, ipAddress);
			prepredStatement.setString(2, makerCode);
			resultSet = prepredStatement.executeQuery();
			if (resultSet.next()) {
				ipDetails.put("IPADDRESS", resultSet.getString("IPADDRESS"));				
				ipDetails.put("MAKERSYSTEMNAME", resultSet.getString("SYSTEMNAME"));
				ipDetails.put("MAKERISENABLED", resultSet.getString("MAKERISENABLED"));
				ipDetails.put("MAKERUPDATEDBY", resultSet.getString("MAKERUPDATEDBY"));
				ipDetails.put("MAKERUPDATETIMESTAMP", resultSet.getString("MAKERUPDATETIMESTAMP"));
				ipDetails.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				if(resultSet.getString("ISNEWIPADDRESS").equals("N")){
					isNewIPAddress = true;
					ipDetails.put("ISNEWIPADDRESS", "No");
				}else{
					ipDetails.put("ISNEWIPADDRESS", "Yes");
				}
			}
			
			if(isNewIPAddress){
				query = "SELECT SYSTEMNAME, CASE NVL(ISENABLED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ISENABLED, UPDATEDBY, "+
						"       CASE NVL(UPDATETIMESTAMP, NULL) WHEN NULL THEN '''' ELSE TO_CHAR(UPDATETIMESTAMP,'DD/MM/YYYY') END UPDATETIMESTAMP "+
						"  FROM TB_IPADDRESS "+
						" WHERE IPADDRESS = ? ";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, ipAddress);
				resultSet = prepredStatement.executeQuery();
				if(resultSet.next()){
					ipDetails.put("SYSTEMNAME", resultSet.getString("SYSTEMNAME"));
					ipDetails.put("ISENABLED", resultSet.getString("ISENABLED"));
					ipDetails.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
					ipDetails.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				}
			}
		}catch(Exception e){
			log.error("Error while geting IP details for checker : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
		}
		return ipDetails;
	}
	
	@Override
	public String approveIPAddress(String ipAddress, String makerCode, String remarks, String createdBy){
		String message = "";
		String isNewIPAddress = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement prepredStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT ISNEWIPADDRESS FROM TB_IPADDRESS_CHECKERACTIVITY WHERE MAKERCODE = ?";
		try{
			prepredStatement = connection.prepareStatement(query);
			prepredStatement.setString(1, makerCode);
			resultSet = prepredStatement.executeQuery();
			if(resultSet.next()){
				isNewIPAddress = resultSet.getString("ISNEWIPADDRESS");
			}else{
				message = "Something went wrong";
			}
			
			connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			
			if(isNewIPAddress.equals("Y")){
				query = "INSERT INTO TB_IPADDRESS(IPADDRESS, SYSTEMNAME, ISENABLED, UPDATEDBY, UPDATETIMESTAMP, MAKERCODE) "+
						"SELECT IPADDRESS, SYSTEMNAME, ISENABLED, UPDATEDBY, UPDATETIMESTAMP, MAKERCODE "+
						"  FROM TB_IPADDRESS_MAKER "+
						" WHERE MAKERCODE = ?";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, makerCode);
				prepredStatement.executeUpdate();
				
				query = "UPDATE TB_IPADDRESS_CHECKERACTIVITY "+
						"   SET ACTIONSTATUS = ?, APPROVEDBY = ?, APPROVEDTIMESTAMP = SYSTIMESTAMP, CHECKERREMAKRS = ? "+
						" WHERE MAKERCODE = ?";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, "A");
				prepredStatement.setString(2, createdBy);
				prepredStatement.setString(3, remarks);
				prepredStatement.setString(4, makerCode);
				prepredStatement.executeUpdate();
				message = "IP Address approved";
			}else{
				query = "UPDATE TB_IPADDRESS A "+
						"   SET (IPADDRESS, SYSTEMNAME, ISENABLED, UPDATEDBY, UPDATETIMESTAMP, MAKERCODE) = "+
						"     ( SELECT B.IPADDRESS, B.SYSTEMNAME, B.ISENABLED, B.UPDATEDBY, B.UPDATETIMESTAMP, B.MAKERCODE "+
						"		  FROM TB_IPADDRESS_MAKER B WHERE B.MAKERCODE = ?)"+
						" WHERE A.IPADDRESS = ?";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, makerCode);
				prepredStatement.setString(2, ipAddress);
				prepredStatement.executeUpdate();
				
				query = "UPDATE TB_IPADDRESS_CHECKERACTIVITY "+
						"   SET ACTIONSTATUS = ?, APPROVEDBY = ?, APPROVEDTIMESTAMP = SYSTIMESTAMP, CHECKERREMAKRS = ? "+
						" WHERE MAKERCODE = ?";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, "A");
				prepredStatement.setString(2, createdBy);
				prepredStatement.setString(3, remarks);
				prepredStatement.setString(4, makerCode);
				prepredStatement.executeUpdate();
				message = "IP Address approved";
			}
		}catch(Exception e){
			message = "Failed to approved";
			log.error("Error while approving IP : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public String rejectIPAddress(String makerCode, String remarks, String createdBy){
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement prepredStatement = null;
		ResultSet resultSet = null;
		String query = "UPDATE TB_IPADDRESS_CHECKERACTIVITY "+
					   "   SET ACTIONSTATUS = ?, APPROVEDBY = ?, APPROVEDTIMESTAMP = SYSTIMESTAMP, CHECKERREMAKRS = ? "+
					   " WHERE MAKERCODE = ?";
		try{
			prepredStatement = connection.prepareStatement(query);
			prepredStatement.setString(1, "R");
			prepredStatement.setString(2, createdBy);
			prepredStatement.setString(3, remarks);
			prepredStatement.setString(4, makerCode);
			prepredStatement.executeUpdate();
			message = "IP Address approval request has been rejected";
		}catch(Exception e){
			message = "Failed to reject";
			log.error("Error while rejecting IP : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public List<Map<String, String>> getAllUserForCheck(String loggedInUsercode){
		//System.out.println(loggedInUsercode);
		List<Map<String, String>> allUserList = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement prepredStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT USERCODE, MAKERCODE "+ 
					   "  FROM TB_USER_CHECKERACTIVITY "+
					   " WHERE ACTIONSTATUS = ? "+
					   "   AND (NVL(USERDETAILSUPDATEDBY, USERSTATUSDETAILSUPDATEDBY) <> ? "+
					   "	OR NVL(USERDETAILSUPDATEDBY, ROLEDETAILSUPDATEDBY) <> ?) "+
					   "   AND NVL(USERCODE, 'N.A.') <> ? ";
		try{
			prepredStatement = connection.prepareStatement(query);
			prepredStatement.setString(1, "P");
			prepredStatement.setString(2, loggedInUsercode);
			prepredStatement.setString(3, loggedInUsercode);
			prepredStatement.setString(4, loggedInUsercode);
			resultSet = prepredStatement.executeQuery();
			//System.out.println(query);
			while (resultSet.next()) {
				Map<String, String> userDetails = new HashMap<String, String>();
				userDetails.put("VALUE", resultSet.getString("USERCODE")+","+resultSet.getString("MAKERCODE"));
				userDetails.put("DISPLAY", resultSet.getString("USERCODE"));
				allUserList.add(userDetails);
			}
		}catch(Exception e){
			log.error("Error while getting all user details for check : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
		}
		return allUserList;
	}
	
	@SuppressWarnings("resource")
	public Map<String, Object> getUserDetailsForCheck(String userCode, String makerCode){
		Map<String, Object> userDetails = new HashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement prepredStatement = null;
		ResultSet resultSet = null;
		//System.out.println("userCode = "+userCode+" makerCode = "+makerCode);
		String query = "SELECT USERCODE,CASE NVL(ISNEWUSER,'N') WHEN 'N' THEN 'No' ELSE 'Yes' END AS ISNEWUSER,USERDETAILSUPDATEED,USERDETAILSUPDATEDBY, "+
					   "       TO_CHAR(NVL(USERDETAILSUPDATETIME,SYSDATE),'DD/MM/YYYY') USERDETAILSUPDATETIME,ROLEDETAILSUPDATED,ROLEDETAILSUPDATEDBY, "+
					   "       TO_CHAR(NVL(ROLEDETAILSUPDATETIME,SYSDATE),'DD/MM/YYYY') ROLEDETAILSUPDATETIME,IPDETAILSUPDATEED,IPDETAILSUPDATEBY, "+
					   "	   TO_CHAR(NVL(IPDETAILSUPDATETIME,SYSDATE),'DD/MM/YYYY') IPDETAILSUPDATETIME, USERSTATUSDETAILSUPDATED, USERSTATUSDETAILSUPDATEDBY, "+
					   "	   TO_CHAR(NVL(USERSTATUSDETAILSUPDATEDTIME,SYSDATE),'DD/MM/YYYY') USERSTATUSDETAILSUPDATEDTIME "+
					   "  FROM TB_USER_CHECKERACTIVITY "+
					   " WHERE USERCODE = ? "+
					   "   AND MAKERCODE = ?";
		try{
			prepredStatement = connection.prepareStatement(query);
			prepredStatement.setString(1, userCode);
			prepredStatement.setString(2, makerCode);
			resultSet = prepredStatement.executeQuery();
			if(resultSet.next()){
				userDetails.put("USERCODE", resultSet.getString("USERCODE"));
				userDetails.put("ISNEWUSER", resultSet.getString("ISNEWUSER"));
				userDetails.put("USERDETAILSUPDATEED", resultSet.getString("USERDETAILSUPDATEED"));
				userDetails.put("USERDETAILSUPDATEDBY", resultSet.getString("USERDETAILSUPDATEDBY"));
				userDetails.put("USERDETAILSUPDATETIME", resultSet.getString("USERDETAILSUPDATETIME"));
				userDetails.put("ROLEDETAILSUPDATED", resultSet.getString("ROLEDETAILSUPDATED"));
				userDetails.put("ROLEDETAILSUPDATEDBY", resultSet.getString("ROLEDETAILSUPDATEDBY"));
				userDetails.put("ROLEDETAILSUPDATETIME", resultSet.getString("ROLEDETAILSUPDATETIME"));
				userDetails.put("IPDETAILSUPDATEED", resultSet.getString("IPDETAILSUPDATEED"));
				userDetails.put("IPDETAILSUPDATEBY", resultSet.getString("IPDETAILSUPDATEBY"));
				userDetails.put("IPDETAILSUPDATETIME", resultSet.getString("IPDETAILSUPDATETIME"));
				userDetails.put("USERSTATUSDETAILSUPDATED", resultSet.getString("USERSTATUSDETAILSUPDATED"));
				userDetails.put("USERSTATUSDETAILSUPDATEDBY", resultSet.getString("USERSTATUSDETAILSUPDATEDBY"));
				userDetails.put("USERSTATUSDETAILSUPDATEDTIME", resultSet.getString("USERSTATUSDETAILSUPDATEDTIME"));
			}

			if("Y".equals(userDetails.get("USERDETAILSUPDATEED"))){
				Map<String, String> userInfo = new HashMap<String, String>();
				query = "SELECT A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, A.EMAILID EMAILID, "+
						 "      CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
						 "      CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
						 "      CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
						 "      CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+
						 "      CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
						 "		CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
						 "		CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
						 "      A.ACCESSSTARTTIME ACCESSSTARTTIME, A.ACCESSENDTIME ACCESSENDTIME, "+
						 "      CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE TO_CHAR(A.ACCOUNTEXIPYDATE, 'DD/MM/YYYY') END ACCOUNTEXIPYDATE, "+
						 "      A.EMPLOYEECODE EMPLOYEECODE, A.DESIGNATION DESIGNATIONCODE, A.DEPARTMENTCODE DEPARTMENTCODE, A.BRANCHCODE BRANCHCODE, "+
						 "      C.DESIGNATIONNAME DESIGNATIONNAME, D.DEPARTMENTNAME DEPARTMENTNAME, E.BRANCHNAME BRANCHNAME, A.ROLECODE, "+
						 "      A.MAKERID MAKERID, A.CREATIONTIME CREATIONTIME "+
						 "  FROM TB_USER_MAKER A "+
						 "  LEFT OUTER JOIN "+schemaName+"TB_DESIGNATIONMASTER C ON A.DESIGNATION = C.DESIGNATIONCODE "+
						 " 	LEFT OUTER JOIN "+schemaName+"TB_DEPARTMENTMASTER D ON A.DEPARTMENTCODE = D.DEPARTMENTCODE "+
               			 "	LEFT OUTER JOIN "+schemaName+"TB_BRANCHMASTER E ON A.BRANCHCODE = E.BRANCHCODE "+
		  				 " WHERE A.USERCODE = ? "+
						 "   AND A.MAKERCODE = ? ";
				
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				prepredStatement.setString(2, makerCode);
				resultSet = prepredStatement.executeQuery();
				if(resultSet.next()){
					userInfo.put("NAME", resultSet.getString("FIRSTNAME") +" "+resultSet.getString("LASTNAME"));
					userInfo.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
					userInfo.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
					userInfo.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
					userInfo.put("CREDENTIALEXPIRED", resultSet.getString("CREDENTIALEXPIRED"));
					userInfo.put("CHATENABLE", resultSet.getString("CHATENABLE"));
					userInfo.put("ACCESSSTARTTIME", resultSet.getString("ACCESSSTARTTIME"));
					userInfo.put("ACCESSENDTIME", resultSet.getString("ACCESSENDTIME"));
					userInfo.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
					userInfo.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
					userInfo.put("DESIGNATIONCODE", resultSet.getString("DESIGNATIONCODE"));
					userInfo.put("DEPARTMENTCODE", resultSet.getString("DEPARTMENTCODE"));
					userInfo.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
					userInfo.put("DESIGNATIONNAME", resultSet.getString("DESIGNATIONNAME"));
					userInfo.put("DEPARTMENTNAME", resultSet.getString("DEPARTMENTNAME"));
					userInfo.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
					userInfo.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
					userInfo.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
					userInfo.put("ROLECODE", resultSet.getString("ROLECODE"));
					userInfo.put("MAKERID", resultSet.getString("MAKERID"));
					userInfo.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
					userInfo.put("EMAILID", resultSet.getString("EMAILID"));
				}
				
				userDetails.put("USERNEWINFO", userInfo);
				//System.out.println("Update - "+userInfo);
			}
			
			if(userDetails.get("ISNEWUSER").equals("No") && "Y".equals(userDetails.get("USERDETAILSUPDATEED"))){
				Map<String, String> userInfo = new HashMap<String, String>();
				query =  "SELECT A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, A.EMAILID EMAILID, "+
						 "       CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
						 "       CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
						 "       CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
						 "       CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+
						 "       CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
						 "		 CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
						 "		 CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
						 "       A.ACCESSSTARTTIME ACCESSSTARTTIME, A.ACCESSENDTIME ACCESSENDTIME, "+
						 "       CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE TO_CHAR(A.ACCOUNTEXIPYDATE, 'DD/MM/YYYY') END ACCOUNTEXIPYDATE, "+
						 "       A.EMPLOYEECODE EMPLOYEECODE, A.DESIGNATION DESIGNATIONCODE, A.DEPARTMENTCODE DEPARTMENTCODE, A.BRANCHCODE BRANCHCODE, A.ROLECODE, "+
						 "       C.DESIGNATIONNAME DESIGNATIONNAME, D.DEPARTMENTNAME DEPARTMENTNAME, E.BRANCHNAME BRANCHNAME, "+
						 "       A.MAKERID MAKERID, A.CREATIONTIME CREATIONTIME "+
						 "  FROM TB_USER A "+
						 "  LEFT OUTER JOIN "+schemaName+"TB_DESIGNATIONMASTER C ON A.DESIGNATION = C.DESIGNATIONCODE "+
						 " 	LEFT OUTER JOIN "+schemaName+"TB_DEPARTMENTMASTER D ON A.DEPARTMENTCODE = D.DEPARTMENTCODE "+
               			 "	LEFT OUTER JOIN "+schemaName+"TB_BRANCHMASTER E ON A.BRANCHCODE = E.BRANCHCODE "+
		  				 " WHERE A.USERCODE = ? ";
						
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				resultSet = prepredStatement.executeQuery();
				if(resultSet.next()){
					
					userInfo.put("NAME", resultSet.getString("FIRSTNAME") +" "+resultSet.getString("LASTNAME"));
					userInfo.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
					userInfo.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
					userInfo.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
					userInfo.put("CREDENTIALEXPIRED", resultSet.getString("CREDENTIALEXPIRED"));
					userInfo.put("CHATENABLE", resultSet.getString("CHATENABLE"));
					userInfo.put("ACCESSSTARTTIME", resultSet.getString("ACCESSSTARTTIME"));
					userInfo.put("ACCESSENDTIME", resultSet.getString("ACCESSENDTIME"));
					userInfo.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
					userInfo.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
					userInfo.put("DEPARTMENTCODE", resultSet.getString("DEPARTMENTCODE"));
					userInfo.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
					userInfo.put("DESIGNATIONCODE", resultSet.getString("DESIGNATIONCODE"));
					userInfo.put("DESIGNATIONNAME", resultSet.getString("DESIGNATIONNAME"));
					userInfo.put("DEPARTMENTNAME", resultSet.getString("DEPARTMENTNAME"));
					userInfo.put("DESIGNATION", resultSet.getString("DESIGNATIONNAME"));
					userInfo.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
					userInfo.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
					userInfo.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
					userInfo.put("ROLECODE", resultSet.getString("ROLECODE"));
					userInfo.put("MAKERID", resultSet.getString("MAKERID"));
					userInfo.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
					userInfo.put("EMAILID", resultSet.getString("EMAILID"));
				}
				userDetails.put("USERCURRINFO", userInfo);
				//System.out.println("Current - "+userInfo);
			}
			
			if("Y".equals(userDetails.get("USERSTATUSDETAILSUPDATED"))){
				connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				Map<String, String> userStatusInfo = new HashMap<String, String>();
				query = "SELECT CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
						 "      CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
						 "      CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
						 "		CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
						 "		CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
						 "      A.MAKERID MAKERID, A.CREATIONTIME CREATIONTIME "+
						 "  FROM TB_USER_MAKER A "+
						 " WHERE A.USERCODE = ? "+
						 "   AND A.MAKERCODE = ? ";
				
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				prepredStatement.setString(2, makerCode);
				resultSet = prepredStatement.executeQuery();
				if(resultSet.next()){
					userStatusInfo.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
					userStatusInfo.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
					userStatusInfo.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
					userStatusInfo.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
					userStatusInfo.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
					userStatusInfo.put("MAKERID", resultSet.getString("MAKERID"));
					userStatusInfo.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
				}
				
				userDetails.put("USERSTATUSNEWINFO", userStatusInfo);
				//System.out.println("Update - "+userStatusInfo);
			}
			
			if(userDetails.get("ISNEWUSER").equals("No") && "Y".equals(userDetails.get("USERSTATUSDETAILSUPDATED"))){
				connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				Map<String, String> userStatusInfo = new HashMap<String, String>();
				query =  "SELECT CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
						 "       CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
						 "       CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
						 "		 CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
						 "		 CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
						 "       A.MAKERID MAKERID, A.STATUSUPDATETIMESTAMP STATUSUPDATETIMESTAMP "+
						 "  FROM TB_USER A "+
						 " WHERE A.USERCODE = ? ";
						
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				resultSet = prepredStatement.executeQuery();
				if(resultSet.next()){
					userStatusInfo.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
					userStatusInfo.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
					userStatusInfo.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
					userStatusInfo.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
					userStatusInfo.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
					userStatusInfo.put("MAKERID", resultSet.getString("MAKERID"));
					userStatusInfo.put("STATUSUPDATETIMESTAMP", resultSet.getString("STATUSUPDATETIMESTAMP"));
				}
				userDetails.put("USERSTATUSCURRINFO", userStatusInfo);
				//System.out.println("Current - "+userStatusInfo);
			}
			
			if("Y".equals(userDetails.get("ROLEDETAILSUPDATED"))){
				
				connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				List<Map<String, Object>> allRoleModules = new ArrayList<Map<String, Object>>();
				
				List<String> allRoles = new ArrayList<String>();
				query = "SELECT ROLEID "+
						"  FROM TB_USERROLEMAPPING_MAKER A "+
		  				" WHERE A.USERCODE = ? ";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				resultSet = prepredStatement.executeQuery();
				while(resultSet.next()){
					allRoles.add(resultSet.getString("ROLEID"));
				}
				
				for(String roleId : allRoles){
					Map<String, Object> roleModules = new HashMap<String, Object>();
					query = "SELECT A.MODULENAME "+
							"  FROM TB_MODULE A, TB_USERMODULEMAPPING_MAKER B "+
							" WHERE A.MODULECODE = B.MODULECODE "+
							"   AND B.USERCODE = ? "+
							"   AND B.ROLEID = ?";
					List<String> allModules = new ArrayList<String>();
					prepredStatement = connection.prepareStatement(query);
					prepredStatement.setString(1, userCode);
					prepredStatement.setString(2, roleId);
					resultSet = prepredStatement.executeQuery();
					while (resultSet.next()) {
						allModules.add(resultSet.getString("MODULENAME"));
					}
					
					 Map<String, Map<String, Map<String, Map<String, String>>>>  mainSub = userModule(userCode, roleId, "_MAKER");
					
					if(allModules.size() > 0){
						roleModules.put("NAME", roleId);
						roleModules.put("ROLE", mainSub);
						roleModules.put("STATUS", "Custom modules assigned");
					}else{
						roleModules.put("NAME", roleId);
						roleModules.put("ROLE", mainSub);
						roleModules.put("STATUS", "Full access");
					}
					allRoleModules.add(roleModules);
				}
				
				userDetails.put("ROLENEWINFO", allRoleModules);
				userDetails.put("ROLENEWINFOSIZE", allRoleModules.size());
				userDetails.put("ROLENEWINFOHALFSIZE", (allRoleModules.size()/2));
			}
			
			if(userDetails.get("ISNEWUSER").equals("No") && "Y".equals(userDetails.get("ROLEDETAILSUPDATED"))){
				
				connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				
				List<Map<String, Object>> allRoleModules = new ArrayList<Map<String, Object>>();
				List<String> allRoles = new ArrayList<String>();
				query = "SELECT ROLEID "+
						"  FROM TB_USERROLEMAPPING A "+
		  				" WHERE A.USERCODE = ? ";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				resultSet = prepredStatement.executeQuery();
				while(resultSet.next()){
					allRoles.add(resultSet.getString("ROLEID"));
				}
				
				for(String roleId : allRoles){
					Map<String, Object> roleModules = new HashMap<String, Object>();
					query = "SELECT A.MODULENAME "+
							"  FROM TB_MODULE A, TB_USERMODULEMAPPING B "+
							" WHERE A.MODULECODE = B.MODULECODE "+
							"   AND B.USERCODE = ? "+
							"   AND B.ROLEID = ?";
					List<String> allModules = new ArrayList<String>();
					prepredStatement = connection.prepareStatement(query);
					prepredStatement.setString(1, userCode);
					prepredStatement.setString(2, roleId);
					resultSet = prepredStatement.executeQuery();
					while (resultSet.next()) {
						allModules.add(resultSet.getString("MODULENAME"));
					}
					
					Map<String, Map<String, Map<String, Map<String, String>>>>  mainSub = userModule(userCode, roleId, "");
					//Map<String, Map<String, Map<String, Map<String, String>>>>  mainSub = userModule(userCode, roleId, "_MAKER");
					
					if(allModules.size() > 0){
						roleModules.put("NAME", roleId);
						roleModules.put("ROLE", mainSub);
						roleModules.put("STATUS", "Custom modules assigned");
					}else{
						roleModules.put("NAME", roleId);
						roleModules.put("ROLE", mainSub);
						roleModules.put("STATUS", "Full access");
					}
					allRoleModules.add(roleModules);
				}
				
				userDetails.put("ROLECURRINFO", allRoleModules);
				userDetails.put("ROLECURRINFOSIZE", allRoleModules.size());
				userDetails.put("ROLECURRINFOHALFSIZE", (allRoleModules.size()/2));
			}
			
			if("Y".equals(userDetails.get("IPDETAILSUPDATEED"))){
				
				connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				List<String> ipAddress = new ArrayList<String>();
				query = "SELECT A.IPADDRESS, A.SYSTEMNAME "+
						"  FROM TB_IPADDRESS A, TB_USERIPADDRESSMAPPING_MAKER B"+
						" WHERE A.IPADDRESS = B.IPADDRESS "+
						"   AND B.USERCODE = ?";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				resultSet = prepredStatement.executeQuery();
				while (resultSet.next()) {
					ipAddress.add(resultSet.getString("SYSTEMNAME")+" ["+resultSet.getString("IPADDRESS")+"]");
				}
				userDetails.put("IPNEWINFO", ipAddress);
			}
			
			if(userDetails.get("ISNEWUSER").equals("No") && "Y".equals(userDetails.get("IPDETAILSUPDATEED"))){
				
				connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				List<String> ipAddress = new ArrayList<String>();
				query = "SELECT A.IPADDRESS, A.SYSTEMNAME "+
						"  FROM TB_IPADDRESS A, TB_USERIPADDRESSMAPPING B"+
						" WHERE A.IPADDRESS = B.IPADDRESS "+
						"   AND B.USERCODE = ?";
				prepredStatement = connection.prepareStatement(query);
				prepredStatement.setString(1, userCode);
				resultSet = prepredStatement.executeQuery();
				while (resultSet.next()) {
					ipAddress.add(resultSet.getString("SYSTEMNAME")+" ["+resultSet.getString("IPADDRESS")+"]");
				}
				userDetails.put("IPCURRINFO", ipAddress);
			}
			
		}catch(Exception e){
			log.error("Error while getting user details for check : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, prepredStatement, resultSet, null);
		}
		return userDetails;
	}
	
	
	private Map<String, Map<String, Map<String, Map<String, String>>>> userModule(String userCode, String groupCode, String table){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Map<String, Map<String, String>> userAssignedModules = new LinkedHashMap<String, Map<String,String>>();
		Map<String, Map<String, String>> roleAssignedModules = new LinkedHashMap<String, Map<String,String>>();
		Map<String, Map<String, Map<String, Map<String, String>>>> userModules = new LinkedHashMap<String, Map<String, Map<String, Map<String, String>>>>();
		try{
			String query = "SELECT A.MODULECODE, A.MAINORSUBMODULE, A.MAINMODULECODE"+
		    		 "  FROM TB_USERMODULEMAPPING"+table+" B, TB_MODULE A"+
		    		 " WHERE A.MODULECODE = B.MODULECODE"+
		    		 "   AND B.USERCODE = ?"+
		    		 "   AND B.ROLEID  = ?"+
					 " ORDER BY A.DISPLAYORDER";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, groupCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> moduleDetails = new LinkedHashMap<String, String>();
				moduleDetails.put("MODULECODE", resultSet.getString("MODULECODE"));
				moduleDetails.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
				moduleDetails.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
				userAssignedModules.put(resultSet.getString("MODULECODE"), moduleDetails);
			}
		}catch(Exception e){
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		connection = connectionUtil.getConnection();
		preparedStatement = null;
		resultSet = null;
		
		if(userAssignedModules.size() > 0){
			log.info("User "+userCode+" from "+groupCode+" has custom modules assigned. Loading modules...");
			Iterator<String> moduleCodeItr = userAssignedModules.keySet().iterator();
			while (moduleCodeItr.hasNext()) {
				String moduleCode = moduleCodeItr.next();
				String mainSubModule = userAssignedModules.get(moduleCode).get("MAINORSUBMODULE");
				String mainModuleCode = userAssignedModules.get(moduleCode).get("MAINMODULECODE");
				
				if(mainSubModule.equalsIgnoreCase("M")){
					if(userModules.containsKey(moduleCode)){
					}else{
						userModules.put(moduleCode, getFullModule(moduleCode));
					}
				}else{
					if(userModules.containsKey(mainModuleCode)){
						userModules.get(mainModuleCode).get("SUBMODULE").put(moduleCode, getSubModuleDetails(moduleCode));
					}else{
						List<String> moduleCodes = new ArrayList<String>();
						moduleCodes.add(mainModuleCode);
						moduleCodes.add(moduleCode);
						userModules.put(mainModuleCode, getOnlyMainModuleAndSubModule(moduleCodes));
					}
				}
			}
		}else{
			log.info("Loading modules for User "+userCode+" from "+groupCode+"...");
			
			try{
				preparedStatement = connection.prepareStatement(Query.GETROLEASSIGNEDMODULES);
				preparedStatement.setString(1, groupCode);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					Map<String, String> moduleDetails = new LinkedHashMap<String, String>();
					moduleDetails.put("MODULECODE", resultSet.getString("MODULECODE"));
					moduleDetails.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
					moduleDetails.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
					roleAssignedModules.put(resultSet.getString("MODULECODE"), moduleDetails);
				}
			}catch(Exception e){
				log.error("Error while getting user modules : "+e.getMessage());
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
			
			Iterator<String> moduleCodeItr = roleAssignedModules.keySet().iterator();
			while (moduleCodeItr.hasNext()) {
				String moduleCode = moduleCodeItr.next();
				String mainSubModule = roleAssignedModules.get(moduleCode).get("MAINORSUBMODULE");
				String mainModuleCode = roleAssignedModules.get(moduleCode).get("MAINMODULECODE");
				
				if(mainSubModule.equalsIgnoreCase("M")){
					if(userModules.containsKey(moduleCode)){
					}else{
						userModules.put(moduleCode, getFullModule(moduleCode));
					}
				}else{
					if(userModules.containsKey(mainModuleCode)){
						userModules.get(mainModuleCode).get("SUBMODULE").put(moduleCode, getSubModuleDetails(moduleCode));
					}else{
						List<String> moduleCodes = new ArrayList<String>();
						moduleCodes.add(mainModuleCode);
						moduleCodes.add(moduleCode);
						userModules.put(mainModuleCode, getOnlyMainModuleAndSubModule(moduleCodes));
					}
				}
			}
		}
		return userModules;
	}
	
	
	private Map<String, String> getSubModuleDetails(String moduleCode){
		Map<String, String> moduleDetails = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(Query.GETMODULEDETAILSBYMODULE);
			preparedStatement.setString(1, moduleCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				moduleDetails.put("MODULECODE", resultSet.getString("MODULECODE"));
				moduleDetails.put("MODULENAME", resultSet.getString("MODULENAME"));
				moduleDetails.put("MODULEURL", resultSet.getString("MODULEURL"));
				moduleDetails.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
				moduleDetails.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
				moduleDetails.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
				moduleDetails.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
			}
		}catch(Exception e){
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return moduleDetails;
	}
	
	
	private Map<String, Map<String, Map<String, String>>> getOnlyMainModuleAndSubModule(List<String> moduleCodes){
		Map<String, Map<String, Map<String, String>>> moduleDetails = new LinkedHashMap<String, Map<String, Map<String, String>>>();
		Map<String, Map<String, String>> mainModule = new LinkedHashMap<String, Map<String, String>>();
		Map<String, Map<String, String>> subModule = new LinkedHashMap<String, Map<String, String>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			for(String moduleCode : moduleCodes){
				preparedStatement = connection.prepareStatement(Query.GETMODULEDETAILSBYMODULE);
				preparedStatement.setString(1, moduleCode);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					if("M".equals(resultSet.getString("MAINORSUBMODULE"))){
						Map<String, String> module = new HashMap<String, String>();
						module.put("MODULECODE", resultSet.getString("MODULECODE"));
						module.put("MODULENAME", resultSet.getString("MODULENAME"));
						module.put("MODULEURL", resultSet.getString("MODULEURL"));
						module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
						module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
						module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
						module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
						mainModule.put(resultSet.getString("MODULECODE"), module);
					}else{
						Map<String, String> module = new HashMap<String, String>();
						module.put("MODULECODE", resultSet.getString("MODULECODE"));
						module.put("MODULENAME", resultSet.getString("MODULENAME"));
						module.put("MODULEURL", resultSet.getString("MODULEURL"));
						module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
						module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
						module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
						module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
						subModule.put(resultSet.getString("MODULECODE"), module);
					}
				}
			}			
			moduleDetails.put("MAINMODULE", mainModule);
			moduleDetails.put("SUBMODULE", subModule);
		}catch(Exception e){
			log.error("Error while getting main module and sub module : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return moduleDetails;
	}
	
	private Map<String, Map<String, Map<String, String>>> getFullModule(String mainModuleId){
		Map<String, Map<String, Map<String, String>>> moduleDetails = new LinkedHashMap<String, Map<String, Map<String, String>>>();
		Map<String, Map<String, String>> mainModule = new LinkedHashMap<String, Map<String, String>>();
		Map<String, Map<String, String>> subModule = new LinkedHashMap<String, Map<String, String>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			// preparedStatement = connection.prepareStatement(Query.GETMODULEDETAILSBYMAINMODULE);
			preparedStatement = connection.prepareStatement(Query.GETMODULEDETAILSBYMAINMODULE_CHECKER);
			preparedStatement.setString(1, mainModuleId);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if("M".equals(resultSet.getString("MAINORSUBMODULE"))){
					Map<String, String> module = new HashMap<String, String>();
					module.put("MODULECODE", resultSet.getString("MODULECODE"));
					module.put("MODULENAME", resultSet.getString("MODULENAME"));
					module.put("MODULEURL", resultSet.getString("MODULEURL"));
					module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
					module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
					module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
					module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
					mainModule.put(resultSet.getString("MODULECODE"), module);
				}else{
					Map<String, String> module = new HashMap<String, String>();
					module.put("MODULECODE", resultSet.getString("MODULECODE"));
					module.put("MODULENAME", resultSet.getString("MODULENAME"));
					module.put("MODULEURL", resultSet.getString("MODULEURL"));
					module.put("MAINORSUBMODULE", resultSet.getString("MAINORSUBMODULE"));
					module.put("MAINMODULECODE", resultSet.getString("MAINMODULECODE"));
					module.put("DISPLAYORDER", resultSet.getString("DISPLAYORDER"));
					module.put("ISMULTIPLE", resultSet.getString("ISMULTIPLE"));
					subModule.put(resultSet.getString("MODULECODE"), module);
				}
			}
			moduleDetails.put("MAINMODULE", mainModule);
			moduleDetails.put("SUBMODULE", subModule);
			
		}catch(Exception e){
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return moduleDetails;
	}
	
	public String checkUserApprove(String userCode, String makerCode, String remarks, String createdBy){
		boolean isNewUser = false;
		boolean isUserDetailsUpDated = false;
		boolean isRoleDetailsUpDated = false;
		boolean isIPDetailsUpDated = false;
		//System.out.println(userCode+" "+makerCode);
		String approveString = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT CASE ISNEWUSER WHEN 'Y' THEN 'true' ELSE 'false' END AS ISNEWUSER, "+
					   "       CASE NVL(USERDETAILSUPDATEED,'N') WHEN 'Y' THEN 'true' ELSE 'false' END AS USERDETAILSUPDATEED, "+
					   "       CASE NVL(ROLEDETAILSUPDATED,'N') WHEN 'Y' THEN 'true' ELSE 'false' END AS ROLEDETAILSUPDATED, "+
					   "	   CASE NVL(IPDETAILSUPDATEED,'N') WHEN 'Y' THEN 'true' ELSE 'false' END AS IPDETAILSUPDATEED "+
					   "  FROM TB_USER_CHECKERACTIVITY "+
					   " WHERE USERCODE = ? "+
					   "   AND MAKERCODE = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, makerCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				isNewUser = Boolean.valueOf(resultSet.getString("ISNEWUSER"));
				isUserDetailsUpDated = Boolean.valueOf(resultSet.getString("USERDETAILSUPDATEED"));
				isRoleDetailsUpDated = Boolean.valueOf(resultSet.getString("ROLEDETAILSUPDATED"));
				isIPDetailsUpDated = Boolean.valueOf(resultSet.getString("IPDETAILSUPDATEED"));
			}
			/*System.out.println("isNewUser= "+isNewUser+" isUserDetailsUpDated= "+isUserDetailsUpDated+
						" isRoleDetailsUpDated="+isRoleDetailsUpDated);*/
			if(isNewUser){
				//System.out.println("in insert");
				query = "INSERT INTO TB_USER("+
						"		USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, DESIGNATION, ACCOUNTDELETED, "+
						"		ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, CHATENABLE, ACCOUNTLOCKED, ACCESSSTARTTIME, "+
						"		ACCESSENDTIME, CREATIONTIME, ACCOUNTEXIPYDATE, MAKERCODE, BRANCHCODE, ISETLUSER, DEPARTMENTCODE, "+
						"		EMPLOYEECODE, ROLECODE, MAKERID, STATUSUPDATETIMESTAMP, ACCOUNTDORMANT, UPDATETIMESTAMP) "+
						"SELECT A.USERCODE, CASE A.USERPASS WHEN 'SAME' THEN B.USERPASS ELSE A.USERPASS END USERPASS, A.FIRSTNAME, A.LASTNAME, A.EMAILID, A.MOBILENO, A.DESIGNATION, A.ACCOUNTDELETED, "+
						"		A.ACCOUNTENABLE, A.ACCOUNTEXPIRED, A.CREDENTIALEXPIRED, A.CHATENABLE, A.ACCOUNTLOCKED, A.ACCESSSTARTTIME, "+
						"		A.ACCESSENDTIME, A.CREATIONTIME, A.ACCOUNTEXIPYDATE, A.MAKERCODE, A.BRANCHCODE, A.ISETLUSER, A.DEPARTMENTCODE, "+
						"		A.EMPLOYEECODE, A.ROLECODE, A.MAKERID, A.STATUSUPDATETIMESTAMP, A.ACCOUNTDORMANT, SYSTIMESTAMP "+
						"  FROM TB_USER_MAKER A LEFT OUTER JOIN TB_USER B ON A.USERCODE = B.USERCODE "+
						" WHERE A.USERCODE = ? "+
						"   AND A.MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, makerCode);
				preparedStatement.executeUpdate();
				
				query = "INSERT INTO TB_USERROLEMAPPING(ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP) "+
						"SELECT ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP "+
						"  FROM TB_USERROLEMAPPING_MAKER "+
						" WHERE USERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.executeUpdate();
				
				query = "INSERT INTO TB_USERMODULEMAPPING(USERCODE,ROLEID,MODULECODE,UPDATEDBY,UPDATETIMESTAMP) "+
						"SELECT USERCODE, ROLEID, MODULECODE, UPDATEDBY, UPDATETIMESTAMP "+
						"  FROM TB_USERMODULEMAPPING_MAKER "+
						" WHERE USERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.executeUpdate();
				
				query = "INSERT INTO TB_USERIPADDRESSMAPPING(USERCODE,IPADDRESS,UPDATEDBY,UPDATETIMESTAMP) "+
						"SELECT USERCODE, IPADDRESS, UPDATEDBY, UPDATETIMESTAMP "+
						"  FROM TB_USERIPADDRESSMAPPING_MAKER "+
						" WHERE USERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.executeUpdate();
				
				List<String> ipAddresses = new ArrayList<String>();
				query = "SELECT IPADDRESS "+
						"  FROM TB_USERIPADDRESSMAPPING "+
						" WHERE USERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					ipAddresses.add(resultSet.getString("IPADDRESS"));
				}
				
				String ipString = "";
				
				for(int index = 0; index < ipAddresses.size(); index++){
					if(index+1 == ipAddresses.size()){
						ipString = ipString + ipAddresses.get(index);
					}else{
						ipString = ipString + ipAddresses.get(index)+";";
					}
				}
				
				query = "UPDATE TB_USER SET ACCESSPOINTS = ? WHERE USERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, ipString);
				preparedStatement.setString(2, userCode);
				preparedStatement.executeUpdate();
			}else{
				if(isUserDetailsUpDated){
					//System.out.println("update");
					int existingCount = 1;
					query = "SELECT COUNT(1) EXISTINGCOUNT "+
							"  FROM TB_USER "+
							" WHERE USERCODE = ? ";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						existingCount = resultSet.getInt("EXISTINGCOUNT");
					}
					
					if(existingCount == 0 ){
					query = "INSERT INTO TB_USER("+
							"		USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, DESIGNATION, ACCOUNTDELETED, "+
							"		ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, CHATENABLE, ACCOUNTLOCKED, ACCESSSTARTTIME, "+
							"		ACCESSENDTIME, CREATIONTIME, ACCOUNTEXIPYDATE, MAKERCODE, BRANCHCODE, ISETLUSER, DEPARTMENTCODE, "+
							"		EMPLOYEECODE, ROLECODE, MAKERID, STATUSUPDATETIMESTAMP, ACCOUNTDORMANT, UPDATETIMESTAMP) "+
							"SELECT A.USERCODE, CASE A.USERPASS WHEN 'SAME' THEN B.USERPASS ELSE A.USERPASS END USERPASS, A.FIRSTNAME, A.LASTNAME, A.EMAILID, A.MOBILENO, A.DESIGNATION, A.ACCOUNTDELETED, "+
							"		A.ACCOUNTENABLE, A.ACCOUNTEXPIRED, A.CREDENTIALEXPIRED, A.CHATENABLE, A.ACCOUNTLOCKED, A.ACCESSSTARTTIME, "+
							"		A.ACCESSENDTIME, A.CREATIONTIME, A.ACCOUNTEXIPYDATE, A.MAKERCODE, A.BRANCHCODE, A.ISETLUSER, A.DEPARTMENTCODE, "+
							"		A.EMPLOYEECODE, A.ROLECODE, A.MAKERID, A.STATUSUPDATETIMESTAMP, A.ACCOUNTDORMANT, SYSTIMESTAMP "+
							"  FROM TB_USER_MAKER A LEFT OUTER JOIN TB_USER B ON A.USERCODE = B.USERCODE "+
							" WHERE A.USERCODE = ? "+
							"   AND A.MAKERCODE = ?";
					
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.setString(2, makerCode);
					preparedStatement.executeUpdate();
					}
					
					query = "UPDATE TB_USER A "+
							"   SET (USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, "+
							"        MOBILENO, DESIGNATION, ACCOUNTENABLE, CREDENTIALEXPIRED, "+
							"        ACCOUNTEXPIRED, CHATENABLE, ACCESSSTARTTIME, ACCESSENDTIME, "+
							"        ACCOUNTEXIPYDATE, BRANCHCODE, ISETLUSER, MAKERCODE, UPDATETIMESTAMP, "+
							"        ACCOUNTDELETED, ACCOUNTLOCKED, DEPARTMENTCODE, EMPLOYEECODE, ROLECODE, "+
							"		 MAKERID, STATUSUPDATETIMESTAMP, ACCOUNTDORMANT) "+
							"    = "+
							"(SELECT B.USERCODE, CASE B.USERPASS WHEN 'SAME' THEN C.USERPASS ELSE B.USERPASS END USERPASS, B.FIRSTNAME, B.LASTNAME, B.EMAILID, "+
							"        B.MOBILENO, B.DESIGNATION, B.ACCOUNTENABLE, B.CREDENTIALEXPIRED, "+
							"        B.ACCOUNTEXPIRED, B.CHATENABLE, B.ACCESSSTARTTIME, B.ACCESSENDTIME, "+
							"        B.ACCOUNTEXIPYDATE, B.BRANCHCODE, B.ISETLUSER, B.MAKERCODE, SYSTIMESTAMP, "+
							"        B.ACCOUNTDELETED, B.ACCOUNTLOCKED, B.DEPARTMENTCODE, B.EMPLOYEECODE, B.ROLECODE, "+
							"		 B.MAKERID, B.STATUSUPDATETIMESTAMP STATUSUPDATETIMESTAMP, B.ACCOUNTDORMANT ACCOUNTDORMANT "+
							"	FROM TB_USER_MAKER B "+
							"   LEFT OUTER JOIN TB_USER C ON B.USERCODE = C.USERCODE "+
							"  WHERE B.MAKERCODE = ? "+
							" )"+
							" WHERE A.USERCODE = ? ";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, makerCode);
					preparedStatement.setString(2, userCode);
					preparedStatement.executeUpdate();
					
			/*		query = " DELETE FROM TB_USERROLEMAPPING "+
					        "  WHERE USERCODE = ? ";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
					
					query = "INSERT INTO TB_USERROLEMAPPING(ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP) "+
							"SELECT ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP "+
							"  FROM TB_USERROLEMAPPING_MAKER "+
							" WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
			 */
				}
				
				if(isRoleDetailsUpDated){
					query = "DELETE FROM TB_USERROLEMAPPING WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();					
					
					query = "INSERT INTO TB_USERROLEMAPPING(ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP) "+
							"SELECT ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP "+
							"  FROM TB_USERROLEMAPPING_MAKER "+
							" WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
					
					query = "DELETE FROM TB_USERMODULEMAPPING WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
					
					query = "INSERT INTO TB_USERMODULEMAPPING(USERCODE,ROLEID,MODULECODE,UPDATEDBY,UPDATETIMESTAMP) "+
							"SELECT USERCODE, ROLEID, MODULECODE, UPDATEDBY, UPDATETIMESTAMP "+
							"  FROM TB_USERMODULEMAPPING_MAKER "+
							" WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
				}
				
				if(isIPDetailsUpDated){
					query = "DELETE FROM TB_USERIPADDRESSMAPPING WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
					
					query = "INSERT INTO TB_USERIPADDRESSMAPPING(USERCODE,IPADDRESS,UPDATEDBY,UPDATETIMESTAMP) "+
							"SELECT USERCODE, IPADDRESS, UPDATEDBY, UPDATETIMESTAMP "+
							"  FROM TB_USERIPADDRESSMAPPING_MAKER "+
							" WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.executeUpdate();
					
					List<String> ipAddresses = new ArrayList<String>();
					query = "SELECT IPADDRESS "+
							"  FROM TB_USERIPADDRESSMAPPING "+
							" WHERE USERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					resultSet = preparedStatement.executeQuery();
					while (resultSet.next()) {
						ipAddresses.add(resultSet.getString("IPADDRESS"));
					}
					
					String ipString = "";
					
					for(int index = 0; index < ipAddresses.size(); index++){
						if(index+1 == ipAddresses.size()){
							ipString = ipString + ipAddresses.get(index);
						}else{
							ipString = ipString + ipAddresses.get(index)+";";
						}
					}
					
					query = "UPDATE TB_USER A "+
					        "   SET ACCESSPOINTS = ? "+
					        " WHERE USERCODE = ? ";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, ipString);
					preparedStatement.setString(2, userCode);
					preparedStatement.executeUpdate();
				}
			}
			
			query = "UPDATE TB_USER_CHECKERACTIVITY "+
					"   SET ACTIONSTATUS = 'A', APPROVEDBY = ?, APPROVEDTIMESTAMP = SYSTIMESTAMP, CHECKERREMAKRS = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
					" WHERE USERCODE = ? "+
					"   AND MAKERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, createdBy);
			preparedStatement.setString(2, remarks);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, makerCode);
			preparedStatement.executeUpdate();
			approveString = "User approved";
		}catch(Exception e){
			approveString = "Failed to approve user";
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return approveString;
	}
	
	public String checkUserReject(String userCode, String makerCode, String remarks, String createdBy){
		String rejectString = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = "UPDATE TB_USER_CHECKERACTIVITY "+
						   "   SET ACTIONSTATUS = 'R', APPROVEDBY = ?, APPROVEDTIMESTAMP = SYSTIMESTAMP, CHECKERREMAKRS = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						   " WHERE USERCODE = ? "+
						   "   AND MAKERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, createdBy);
			preparedStatement.setString(2, remarks);
			preparedStatement.setString(3, userCode);
			preparedStatement.setString(4, makerCode);
			preparedStatement.executeUpdate();
			rejectString = "User rejected";
		}catch(Exception e){
			rejectString = "Failed to reject user";
			log.error("Error while getting user modules : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return rejectString;
	}
}