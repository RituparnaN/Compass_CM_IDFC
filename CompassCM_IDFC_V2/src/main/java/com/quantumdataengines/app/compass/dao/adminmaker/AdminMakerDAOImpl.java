package com.quantumdataengines.app.compass.dao.adminmaker;

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

import oracle.net.aso.f;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class AdminMakerDAOImpl implements AdminMakerDAO{
	private static final Logger log = LoggerFactory.getLogger(AdminMakerDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@SuppressWarnings("resource")
	@Override
	public List<Map<String, String>> searchUser(String userCode, String firstName, String lastName, String emailId, String mobileNo) {
		List<Map<String, String>> mainMap = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;		
		String query = "SELECT Y.* FROM ( "+
					   "	   SELECT X.*, ROW_NUMBER() OVER(PARTITION BY USERCODE ORDER BY USERCODE, UPDATETIMESTAMP DESC) ROWPOS FROM ( "+ 
				       "			  SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
                       "					 A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, '_USER' AS USETABLE, "+
                       "					 CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+ 
                       "					 CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
                       "					 CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
                       "					 CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+ 
                       "					 CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
                       "					 CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+ 
                       "					 CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
                       "					 'Checked' AS USERSTATUS, A.ACCESSSTARTTIME ACCESSSTARTTIME, A.ACCESSENDTIME ACCESSENDTIME, "+ 
				       "		        	 A.CREATIONTIME CREATIONTIME, CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE FUN_DATETOCHAR(A.ACCOUNTEXIPYDATE) END ACCOUNTEXIPYDATE, A.MAKERCODE, "+ 
				  	   "        			 A.EMPLOYEECODE EMPLOYEECODE, B.ROLEID GROUPCODE, A.MAKERID MAKERID, A.UPDATETIMESTAMP "+
				       " 				FROM TB_USER A, TB_USERROLEMAPPING B "+ 
				       "               WHERE A.USERCODE = B.USERCODE "+
				       "			   UNION ALL "+
				       "			  SELECT C.USERCODE USERCODE, C.FIRSTNAME FIRSTNAME, C.LASTNAME LASTNAME, "+ 
				       "                 	 C.EMAILID EMAILID, C.MOBILENO MOBILENO, C.DESIGNATION DESIGNATION, '_USER_MAKER' AS USETABLE,"+
				       "                	 CASE NVL(C.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+ 
				       "               		 CASE NVL(C.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
				       "              		 CASE NVL(C.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
				       "             		 CASE NVL(C.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+
				       "            		 CASE NVL(C.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
				       "           			 CASE NVL(C.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+ 
				       "          			 CASE NVL(C.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
				       "         			 CASE NVL(D.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' ELSE 'Rejected' END USERSTATUS, "+ 
				       "  		             C.ACCESSSTARTTIME ACCESSSTARTTIME, C.ACCESSENDTIME ACCESSENDTIME, "+
				       " 		             C.CREATIONTIME CREATIONTIME, CASE NVL(C.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE FUN_DATETOCHAR(C.ACCOUNTEXIPYDATE) END ACCOUNTEXIPYDATE, C.MAKERCODE, "+ 
				       "		             C.EMPLOYEECODE EMPLOYEECODE, E.ROLEID GROUPCODE, C.MAKERID MAKERID, "+
				       "           			 GREATEST(C.UPDATETIMESTAMP, NVL(D.UPDATETIMESTAMP, SYSDATE-1000000)) UPDATETIMESTAMP "+  
				       "                FROM TB_USER_MAKER C, TB_USER_CHECKERACTIVITY D, TB_USERROLEMAPPING_MAKER E "+
				       "               WHERE C.USERCODE = D.USERCODE "+
				       "                 AND C.MAKERCODE = D.MAKERCODE "+
				       "                 AND C.USERCODE = E.USERCODE "+
				       "                 AND D.ACTIONSTATUS <> 'A' "+
				       "      ) X ORDER BY UPDATETIMESTAMP DESC "+ 
				       " ) Y WHERE ROWPOS = 1 ";
		try{
			if(userCode != null && !"".equals(userCode)){
				
				// query = query + "AND UPPER(USERCODE)  = '"+userCode+"'";
			//	query1 = query1 + "AND UPPER(A.USERCODE)  = '"+userCode+"'";
				
				query = query + " AND UPPER(USERCODE)  = ? ";
			//	query1 = query1 + " AND UPPER(A.USERCODE)  = ? ";
			}
			if(firstName != null && !"".equals(firstName)){
				
				// query = query + "AND UPPER(FIRSTNAME) LIKE UPPER('%"+firstName+"%')";
			//	query1 = query1 + "AND UPPER(A.FIRSTNAME) LIKE UPPER('%"+firstName+"%')";
				
				query = query + " AND UPPER(FIRSTNAME) LIKE UPPER(?)";
			//	query1 = query1 + " AND UPPER(A.FIRSTNAME) LIKE UPPER(?)";
			}
			if(lastName != null && !"".equals(lastName)){
				
				// query = query + "AND UPPER(LASTNAME) LIKE UPPER('%"+lastName+"%')";
			//	query1 = query1 + "AND UPPER(A.LASTNAME) LIKE UPPER('%"+lastName+"%')";
				
				query = query + " AND UPPER(LASTNAME) LIKE UPPER(?) ";
			//	query1 = query1 + " AND UPPER(A.LASTNAME) LIKE UPPER(?) ";
			}
			if(emailId != null && !"".equals(emailId)){
				
				// query = query + "AND UPPER(EMAILID) = '"+emailId+"'";
			//	query1 = query1 + "AND UPPER(A.EMAILID) = '"+emailId+"'";
				
				query = query + " AND UPPER(EMAILID) = UPPER(?) ";
			//	query1 = query1 + " AND UPPER(A.EMAILID) = UPPER(?) ";
			}
			if(mobileNo != null && !"".equals(mobileNo)){
				
				// query = query + "AND UPPER(MOBILENO) = '"+mobileNo+"'";
			//	query1 = query1 + "AND UPPER(A.MOBILENO) = '"+mobileNo+"'";
				
				query = query + " AND UPPER(MOBILENO) = UPPER(?) ";
			//	query1 = query1 + " AND UPPER(A.MOBILENO) = UPPER(?) ";
			}
			
			query = query + " ORDER BY USERCODE DESC, CREATIONTIME DESC ";
			//query1 = query1 + " ORDER BY A.USERCODE DESC , A.CREATIONTIME DESC ";
			int count = 1;		
			preparedStatement = connection.prepareStatement(query);
			if(userCode != null && !"".equals(userCode)){
				preparedStatement.setString(count, userCode);
				count++;
			}
			if(firstName != null && !"".equals(firstName)){
				preparedStatement.setString(count, "%"+firstName+"%");
				count++;
			}
			if(lastName != null && !"".equals(lastName)){
				preparedStatement.setString(count, "%"+lastName+"%");
				count++;
			}
			if(emailId != null && !"".equals(emailId)){
				preparedStatement.setString(count, emailId);
				count++;
			}
			if(mobileNo != null && !"".equals(mobileNo)){
				preparedStatement.setString(count, mobileNo);
			}
			resultSet = preparedStatement.executeQuery();
			
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
				dataMap.put("EMAILID", resultSet.getString("EMAILID"));
				dataMap.put("MOBILENO", resultSet.getString("MOBILENO"));
				dataMap.put("DESIGNATION", resultSet.getString("DESIGNATION"));
				dataMap.put("STARTTIME", resultSet.getString("ACCESSSTARTTIME"));
				dataMap.put("ENDTIME", resultSet.getString("ACCESSENDTIME"));
				dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
				dataMap.put("PASSWORDEXPIRY", resultSet.getString("CREDENTIALEXPIRED"));
				dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
				dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
				dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
				dataMap.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
				dataMap.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
				dataMap.put("CHECKER", resultSet.getString("USERSTATUS"));
				dataMap.put("TABLE", resultSet.getString("USETABLE"));
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
				dataMap.put("GROUPCODE", resultSet.getString("GROUPCODE"));
				dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
				dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
				dataMap.put("MAKERID", resultSet.getString("MAKERID"));
				
				mainMap.add(dataMap);
			}
			
		}catch(Exception e){
			log.error("Error while searching user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	/*public List<Map<String, String>> searchUser(String userCode, String firstName, String lastName, String emailId, String mobileNo) {
		List<Map<String, String>> mainMap = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;		
		String query =  "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
						"       A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, "+
						"  CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
				  		"  CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
				  		"  CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
				  		"  CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+
				  		"  CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
				  		"  CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
				  		"  CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
				  		"       A.ACCESSSTARTTIME ACCESSSTARTTIME, A.ACCESSENDTIME ACCESSENDTIME, "+
				  		"       A.CREATIONTIME CREATIONTIME, CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE FUN_DATETOCHAR(A.ACCOUNTEXIPYDATE) END ACCOUNTEXIPYDATE, A.MAKERCODE, "+
				  		"       A.EMPLOYEECODE EMPLOYEECODE, B.ROLEID GROUPCODE, A.MAKERID MAKERID "+
				  		"  FROM TB_USER A, TB_USERROLEMAPPING B "+
				  		" WHERE A.USERCODE = B.USERCODE";
		
		String query1 =  "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
						 "       A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, "+
						 "  CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
						 "  CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
						 "  CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
						 "  CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+
						 "  CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
						 "  CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' ELSE 'Rejected' END USERSTATUS, "+
						 "  CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
						 "  CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
						 "       A.ACCESSSTARTTIME ACCESSSTARTTIME, A.ACCESSENDTIME ACCESSENDTIME, "+
						 "       A.CREATIONTIME CREATIONTIME, CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE FUN_DATETOCHAR(A.ACCOUNTEXIPYDATE) END ACCOUNTEXIPYDATE, A.MAKERCODE, "+
						 "       A.EMPLOYEECODE EMPLOYEECODE, C.ROLEID GROUPCODE, A.MAKERID MAKERID "+
						 "  FROM TB_USER_MAKER A, TB_USER_CHECKERACTIVITY B, TB_USERROLEMAPPING_MAKER C "+
						 " WHERE A.USERCODE = B.USERCODE "+
						 "   AND A.MAKERCODE = B.MAKERCODE "+
						 "   AND A.USERCODE = C.USERCODE "+
					  	 "   AND B.ACTIONSTATUS <> 'A' ";
		try{
			if(userCode != null && !"".equals(userCode)){
				
				query = query + "AND UPPER(A.USERCODE)  = '"+userCode+"'";
				query1 = query1 + "AND UPPER(A.USERCODE)  = '"+userCode+"'";
				
				query = query + " AND UPPER(A.USERCODE)  = ? ";
				query1 = query1 + " AND UPPER(A.USERCODE)  = ? ";
			}
			if(firstName != null && !"".equals(firstName)){
				
				query = query + "AND UPPER(A.FIRSTNAME) LIKE UPPER('%"+firstName+"%')";
				query1 = query1 + "AND UPPER(A.FIRSTNAME) LIKE UPPER('%"+firstName+"%')";
				
				query = query + " AND UPPER(A.FIRSTNAME) LIKE UPPER(?)";
				query1 = query1 + " AND UPPER(A.FIRSTNAME) LIKE UPPER(?)";
			}
			if(lastName != null && !"".equals(lastName)){
				
				query = query + "AND UPPER(A.LASTNAME) LIKE UPPER('%"+lastName+"%')";
				query1 = query1 + "AND UPPER(A.LASTNAME) LIKE UPPER('%"+lastName+"%')";
				
				query = query + " AND UPPER(A.LASTNAME) LIKE UPPER(?) ";
				query1 = query1 + " AND UPPER(A.LASTNAME) LIKE UPPER(?) ";
			}
			if(emailId != null && !"".equals(emailId)){
				
				query = query + "AND UPPER(A.EMAILID) = '"+emailId+"'";
				query1 = query1 + "AND UPPER(A.EMAILID) = '"+emailId+"'";
				
				query = query + " AND UPPER(A.EMAILID) = UPPER(?) ";
				query1 = query1 + " AND UPPER(A.EMAILID) = UPPER(?) ";
			}
			if(mobileNo != null && !"".equals(mobileNo)){
				
				query = query + "AND UPPER(A.MOBILENO) = '"+mobileNo+"'";
				query1 = query1 + "AND UPPER(A.MOBILENO) = '"+mobileNo+"'";
				
				query = query + " AND UPPER(A.MOBILENO) = UPPER(?) ";
				query1 = query1 + " AND UPPER(A.MOBILENO) = UPPER(?) ";
			}
			
			query = query + " ORDER BY A.USERCODE DESC, CREATIONTIME DESC ";
			query1 = query1 + " ORDER BY A.USERCODE DESC , A.CREATIONTIME DESC ";
			int count = 1;		
			preparedStatement = connection.prepareStatement(query);
			if(userCode != null && !"".equals(userCode)){
				preparedStatement.setString(count, userCode);
				count++;
			}
			if(firstName != null && !"".equals(firstName)){
				preparedStatement.setString(count, "%"+firstName+"%");
				count++;
			}
			if(lastName != null && !"".equals(lastName)){
				preparedStatement.setString(count, "%"+lastName+"%");
				count++;
			}
			if(emailId != null && !"".equals(emailId)){
				preparedStatement.setString(count, emailId);
				count++;
			}
			if(mobileNo != null && !"".equals(mobileNo)){
				preparedStatement.setString(count, mobileNo);
			}
			resultSet = preparedStatement.executeQuery();
			
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
				dataMap.put("EMAILID", resultSet.getString("EMAILID"));
				dataMap.put("MOBILENO", resultSet.getString("MOBILENO"));
				dataMap.put("DESIGNATION", resultSet.getString("DESIGNATION"));
				dataMap.put("STARTTIME", resultSet.getString("ACCESSSTARTTIME"));
				dataMap.put("ENDTIME", resultSet.getString("ACCESSENDTIME"));
				dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
				dataMap.put("PASSWORDEXPIRY", resultSet.getString("CREDENTIALEXPIRED"));
				dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
				dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
				dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
				dataMap.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
				dataMap.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
				dataMap.put("CHECKER", "Checked");
				dataMap.put("TABLE", "_USER");
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
				dataMap.put("GROUPCODE", resultSet.getString("GROUPCODE"));
				dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
				dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
				dataMap.put("MAKERID", resultSet.getString("MAKERID"));
				
				mainMap.add(dataMap);
			}
			count = 1;
			preparedStatement = connection.prepareStatement(query1);
			if(userCode != null && !"".equals(userCode)){
				preparedStatement.setString(count, userCode);
				count++;
			}
			if(firstName != null && !"".equals(firstName)){
				preparedStatement.setString(count, "%"+firstName+"%");
				count++;
			}
			if(lastName != null && !"".equals(lastName)){
				preparedStatement.setString(count, "%"+lastName+"%");
				count++;
			}
			if(emailId != null && !"".equals(emailId)){
				preparedStatement.setString(count, emailId);
				count++;
			}
			if(mobileNo != null && !"".equals(mobileNo)){
				preparedStatement.setString(count, mobileNo);
			}
			resultSet = preparedStatement.executeQuery();
			
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
				dataMap.put("EMAILID", resultSet.getString("EMAILID"));
				dataMap.put("MOBILENO", resultSet.getString("MOBILENO"));
				dataMap.put("DESIGNATION", resultSet.getString("DESIGNATION"));
				dataMap.put("STARTTIME", resultSet.getString("ACCESSSTARTTIME"));
				dataMap.put("ENDTIME", resultSet.getString("ACCESSENDTIME"));
				dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
				dataMap.put("PASSWORDEXPIRY", resultSet.getString("CREDENTIALEXPIRED"));
				dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
				dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
				dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
				dataMap.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
				dataMap.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
				dataMap.put("CHECKER", resultSet.getString("USERSTATUS"));
				dataMap.put("TABLE", "_USER_MAKER");
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
				dataMap.put("GROUPCODE", resultSet.getString("GROUPCODE"));
				dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
				dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
				dataMap.put("MAKERID", resultSet.getString("MAKERID"));
				mainMap.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while searching user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}*/
	
	@Override
	public List<Map<String, String>> createUser(String userCode, String userPass, String firstName, String lastName,
			String emailId, String mobileNo, String designation,
			String accessStartTime, String accessEndTime, String passwordExpiry, String accountExpiryDate, 
			String chatEnabled, String BRANCHCODE, String ISETLUSER, String createdBy, String makerCode){
		List<Map<String, String>> mainMap = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String result = "";
		int count = 0;
		String query = ""; 
		
		try{
			query = "SELECT COUNT(1) AS EXISTINGCOUNT "+
			        "  FROM ( "+
				    "SELECT USERCODE FROM TB_USER "+
				    " WHERE USERCODE = ? "+
					"  UNION ALL "+
				    "SELECT USERCODE FROM TB_USER_MAKER "+
				    " WHERE USERCODE = ? "+
				    "UNION ALL "+
				    "SELECT USERCODE FROM TB_USER_CHECKERACTIVITY "+
				    " WHERE USERCODE = ? "+
				    " ) A "; 

			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, userCode);
			resultSet = preparedStatement.executeQuery();

			if(resultSet.next()){
				count = resultSet.getInt("EXISTINGCOUNT");
			}

			if(count == 0){
			query =  " INSERT INTO TB_USER_MAKER(USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, DESIGNATION, "+
			 		 "        ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, ACCOUNTLOCKED, CHATENABLE, ACCESSSTARTTIME, "+
			 		 "        ACCESSENDTIME, ACCESSPOINTS, CREATIONTIME, ACCOUNTEXIPYDATE, MAKERCODE, BRANCHCODE, ISETLUSER) "+
			 		 " VALUES (?, ?, ?, ?, ?, ?, ?, 'Y', 'N', ?, 'N', ?, ?, ?, '', SYSTIMESTAMP, FUN_CHARTODATE('"+accountExpiryDate+"'), ?, ?, ?)";

			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userPass);
			preparedStatement.setString(3, firstName);
			preparedStatement.setString(4, lastName);
			preparedStatement.setString(5, emailId);
			preparedStatement.setString(6, mobileNo);
			preparedStatement.setString(7, designation);
			preparedStatement.setString(8, passwordExpiry);
			preparedStatement.setString(9, chatEnabled);
			preparedStatement.setString(10, accessStartTime+":00");
			preparedStatement.setString(11, accessEndTime+":59");
			preparedStatement.setString(12, makerCode);
			preparedStatement.setString(13, BRANCHCODE);
			preparedStatement.setString(14, ISETLUSER);
			preparedStatement.executeUpdate();
			
			query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE, ISNEWUSER, USERDETAILSUPDATEED, "+
					"       USERDETAILSUPDATEDBY, USERDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
					"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, "Y");
			preparedStatement.setString(3, "Y");
			preparedStatement.setString(4, createdBy);
			preparedStatement.setString(5, "P");
			preparedStatement.setString(6, makerCode);
			preparedStatement.executeUpdate();
			
			query =  "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
					 "       A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, "+
					 "  CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
					 "  CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
					 "  CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+
					 "  CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
					 "  CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' ELSE 'Rejected' END USERSTATUS, "+
					 "       A.ACCESSSTARTTIME ACCESSSTARTTIME, A.ACCESSENDTIME ACCESSENDTIME, "+
					 "       A.CREATIONTIME CREATIONTIME, CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE TO_CHAR(A.ACCOUNTEXIPYDATE, 'DD/MM/YYYY') END ACCOUNTEXIPYDATE, A.MAKERCODE "+
					 "  FROM TB_USER_MAKER A, TB_USER_CHECKERACTIVITY B "+
	  				 " WHERE A.USERCODE = B.USERCODE "+
					 "   AND A.MAKERCODE = B.MAKERCODE "+
	  				 "   AND A.USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
				dataMap.put("EMAILID", resultSet.getString("EMAILID"));
				dataMap.put("MOBILENO", resultSet.getString("MOBILENO"));
				dataMap.put("DESIGNATION", resultSet.getString("DESIGNATION"));
				dataMap.put("STARTTIME", resultSet.getString("ACCESSSTARTTIME"));
				dataMap.put("ENDTIME", resultSet.getString("ACCESSENDTIME"));
				dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
				dataMap.put("PASSWORDEXPIRY", resultSet.getString("CREDENTIALEXPIRED"));
				dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
				dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
				dataMap.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
				dataMap.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
				dataMap.put("TABLE", "_USER_MAKER");
				dataMap.put("CHECKER", resultSet.getString("USERSTATUS"));
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				mainMap.add(dataMap);	
				result = "User created successfully";
			}
			}
			else{
				result = "User already exists";
				return searchUser(userCode, firstName, lastName, emailId, mobileNo);
			}
		}catch(Exception e){
			result = "Error while creating user";
			log.error("Error while creating user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	
	/*public List<Map<String, String>> getAllUserFromEdit(String loggedInUsercode){
		List<Map<String, String>> mainList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.USERCODE USERCODE, '_USER' AS USETABLE, A.MAKERCODE MAKERCODE, A.FIRSTNAME || ' ' || A.LASTNAME || '  [ ' || A.USERCODE || ' ] (Checked)' AS USERSTATUS "+
				       "  FROM TB_USER A "+
				       " WHERE A.USERCODE <> ? "+
				       " UNION ALL "+
				       "SELECT B.USERCODE, '_USER_MAKER' AS USETABLE, B.MAKERCODE MAKERCODE, "+
				       "  CASE NVL(C.ACTIONSTATUS , 'P') WHEN 'P' THEN B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Pending)' WHEN 'R' THEN B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Rejected)' ELSE B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Approved)' END AS USERSTATUS "+
				       "  FROM TB_USER_MAKER B, TB_USER_CHECKERACTIVITY C "+
				       " WHERE B.USERCODE = C.USERCODE "+
				       "   AND B.MAKERCODE = C.MAKERCODE "+
				       "   AND C.ACTIONSTATUS <> ? "+
				       "   AND C.USERDETAILSUPDATEED = ? "+
				       "   AND B.USERCODE <> ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, loggedInUsercode);
			preparedStatement.setString(2, "A");
			preparedStatement.setString(3, "Y");
			preparedStatement.setString(4, loggedInUsercode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("DISPLAY", resultSet.getString("USERSTATUS"));
				dataMap.put("VALUE", resultSet.getString("USERCODE")+","+resultSet.getString("USETABLE")+","+resultSet.getString("MAKERCODE"));
				dataMap.put("TABLE", resultSet.getString("USETABLE"));
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				//dataMap.put("EMPLOYEECODES", resultSet.getString("EMPLOYEECODE"));
				mainList.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while getting users from edit : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainList;
	}*/
	public List<Map<String, String>> getAllUserFromEdit(String loggedInUsercode){
		List<Map<String, String>> mainList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT Y.* FROM ( "+
					   "	SELECT X.*, ROW_NUMBER() OVER(PARTITION BY USERCODE ORDER BY USERCODE, UPDATETIMESTAMP DESC) ROWPOS FROM ( "+
					   "		SELECT A.USERCODE USERCODE, '_USER' AS USETABLE, A.MAKERCODE MAKERCODE, A.EMPLOYEECODE EMPLOYEECODE, "+
					   "               A.FIRSTNAME || ' ' || A.LASTNAME || '  [ ' || A.USERCODE || ' ] (Checked)' AS USERSTATUS, "+
					   "		       A.UPDATETIMESTAMP "+
					   "		  FROM TB_USER A "+
					   "		 WHERE A.USERCODE <> ? "+
					   "		 UNION ALL "+
					   "		SELECT B.USERCODE, '_USER_MAKER' AS USETABLE, B.MAKERCODE MAKERCODE, B.EMPLOYEECODE EMPLOYEECODE, "+
					   "		  CASE NVL(C.ACTIONSTATUS , 'P') "+
					   "		  WHEN 'P' THEN B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Pending)' "+
					   "		  WHEN 'R' THEN B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Rejected)' "+
					   "		  ELSE B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Approved)' END AS USERSTATUS, "+
					   "	      GREATEST(B.UPDATETIMESTAMP, NVL(C.UPDATETIMESTAMP, SYSDATE-1000000)) UPDATETIMESTAMP  "+
					   "		  FROM TB_USER_MAKER B, TB_USER_CHECKERACTIVITY C "+
					   "		 WHERE B.USERCODE = C.USERCODE "+
					   "		  AND B.MAKERCODE = C.MAKERCODE "+ 
					   "		  AND C.ACTIONSTATUS <> ? "+
					   "		  AND (C.USERDETAILSUPDATEED = ? OR C.USERSTATUSDETAILSUPDATED = ? )"+
					   "		  AND B.USERCODE <> ? "+
					   "		) X ORDER BY UPDATETIMESTAMP DESC "+
					   "	) Y WHERE ROWPOS = 1 ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, loggedInUsercode);
			preparedStatement.setString(2, "A");
			preparedStatement.setString(3, "Y");
			preparedStatement.setString(4, "Y");
			preparedStatement.setString(5, loggedInUsercode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("DISPLAY", resultSet.getString("USERSTATUS"));
				dataMap.put("VALUE", resultSet.getString("USERCODE")+","+resultSet.getString("USETABLE")+","+resultSet.getString("MAKERCODE"));
				dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
				dataMap.put("EMPDETAILS", resultSet.getString("EMPLOYEECODE")+","+resultSet.getString("USETABLE")+","+resultSet.getString("MAKERCODE"));
				mainList.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while getting users from edit : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainList;
	}
	
	public Map<String, String> getUserForEdit(String userCode, String tableName, String makerCode, String employeeCode, String employeeName){
		Map<String, String> dataMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";
		//System.out.println("userCode = "+userCode+" table = "+tableName+" maker = "+makerCode+" empcode = "+employeeCode);
		try{
			if(tableName.contains("MAKER")){
				//System.out.println("inMaker");
				query =  "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
						 "       A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, "+
						 "       CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
						 "       CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
						 "       CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
						 "       CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CREDENTIALEXPIRED, "+
						 "       CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
						 "       CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
						 "       CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CHATENABLE, "+
						 "       CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' WHEN 'R' THEN 'Rejected' ELSE 'Approved' END USERSTATUS, "+
						 "       SUBSTR(NVL(A.ACCESSSTARTTIME,'00:00:00'),0,5) ACCESSSTARTTIME, SUBSTR(NVL(A.ACCESSENDTIME,'23:59:59'),0,5) ACCESSENDTIME, "+
						 "       CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN NULL ELSE TO_CHAR(A.ACCOUNTEXIPYDATE, 'DD/MM/YYYY') END ACCOUNTEXIPYDATE, "+
						 "       B.APPROVEDBY APPROVEDBY, B.CHECKERREMAKRS CHECKERREMAKRS, CASE APPROVEDTIMESTAMP WHEN NULL THEN '' ELSE TO_CHAR(APPROVEDTIMESTAMP, 'DD/MM/YYYY') END APPROVEDTIMESTAMP, "+
						 "       A.BRANCHCODE, A.ISETLUSER, A.MAKERID MAKERID, "+
						 "       A.DEPARTMENTCODE DEPARTMENTCODE, A.EMPLOYEECODE EMPLOYEECODE, C.ROLEID ROLEID "+
						 "  FROM TB_USER_MAKER A "+
						 "  LEFT OUTER JOIN TB_USER_CHECKERACTIVITY B ON A.USERCODE = B.USERCODE AND A.MAKERCODE = B.MAKERCODE "+
						 "	LEFT OUTER JOIN TB_USERROLEMAPPING_MAKER C ON A.USERCODE = C.USERCODE "+
						 " WHERE B.MAKERCODE = ? ";
				
				if(!("ALL").equals(userCode)){
					query = query + " AND A.USERCODE = ? ";
				}
				if(!("ALL").equals(employeeCode)){
					query = query + "   AND A.EMPLOYEECODE  = ? ";
				}
				/*if(!("").equals(employeeName)){
					query = query + "   AND UPPER(D.EMPNAME) LIKE UPPER(?) ";
				}*/
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, makerCode);
				int count = 2;		
				if(!("ALL").equals(userCode)){
					preparedStatement.setString(count, userCode);
					count++;
				}
				if(!("ALL").equals(employeeCode)){
					preparedStatement.setString(count, employeeCode);
					/*count++;
				}
				if(!("").equals(employeeName)){
					preparedStatement.setString(count, employeeName);*/
				}
				
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					dataMap.put("USERCODE", resultSet.getString("USERCODE"));
					dataMap.put("FIRSTNAME", resultSet.getString("FIRSTNAME"));
					dataMap.put("LASTNAME", resultSet.getString("LASTNAME"));
					dataMap.put("EMAILID", resultSet.getString("EMAILID"));
					dataMap.put("MOBILENO", resultSet.getString("MOBILENO"));
					dataMap.put("DESIGNATION", resultSet.getString("DESIGNATION"));
					dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
					dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
					dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
					dataMap.put("CREDENTIALEXPIRED", resultSet.getString("CREDENTIALEXPIRED"));
					dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
					dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
					dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
					dataMap.put("USERSTATUS", resultSet.getString("USERSTATUS"));
					dataMap.put("ACCESSSTARTTIME", resultSet.getString("ACCESSSTARTTIME"));
					dataMap.put("ACCESSENDTIME", resultSet.getString("ACCESSENDTIME"));
					dataMap.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
					dataMap.put("APPROVEDBY", resultSet.getString("APPROVEDBY"));
					dataMap.put("CHECKERREMAKRS", resultSet.getString("CHECKERREMAKRS"));
					dataMap.put("APPROVEDTIMESTAMP", resultSet.getString("APPROVEDTIMESTAMP"));
					dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
					dataMap.put("ISETLUSER", resultSet.getString("ISETLUSER"));
					dataMap.put("DEPARTMENTCODE", resultSet.getString("DEPARTMENTCODE"));
					dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
					dataMap.put("GROUPCODE", resultSet.getString("ROLEID"));
					dataMap.put("MAKERID", resultSet.getString("MAKERID"));
					dataMap.put("MAKERCODE", makerCode);
					//System.out.println("result dataMap if maker = "+dataMap);
				}
			}else{
				//System.out.println("in else");
				query = "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
						"       A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, "+
						"       CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
						"       CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
						"       CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
						"       CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CREDENTIALEXPIRED, "+
						"       CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
						"       CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
						"       CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CHATENABLE, "+
						"       SUBSTR(NVL(A.ACCESSSTARTTIME,'00:00:00'),0,5) ACCESSSTARTTIME, SUBSTR(NVL(A.ACCESSENDTIME,'23:59:59'),0,5) ACCESSENDTIME, "+
						"       CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN NULL ELSE TO_CHAR(A.ACCOUNTEXIPYDATE, 'DD/MM/YYYY') END ACCOUNTEXIPYDATE, "+
						"       B.APPROVEDBY APPROVEDBY, B.CHECKERREMAKRS CHECKERREMAKRS, TO_CHAR(NVL(B.APPROVEDTIMESTAMP, SYSDATE), 'DD/MM/YYYY') APPROVEDTIMESTAMP, "+
						"       A.BRANCHCODE, A.ISETLUSER, A.MAKERID MAKERID, "+
						"       A.DEPARTMENTCODE DEPARTMENTCODE, A.EMPLOYEECODE EMPLOYEECODE, C.ROLEID ROLEID "+
						"  FROM TB_USER A "+
						"  LEFT OUTER JOIN TB_USER_CHECKERACTIVITY B ON A.USERCODE = B.USERCODE AND A.MAKERCODE = B.MAKERCODE "+
						"  LEFT OUTER JOIN TB_USERROLEMAPPING C ON A.USERCODE = C.USERCODE "+
						" WHERE B.MAKERCODE = ? ";
						
				if(!("ALL").equals(userCode)){
					query = query + " AND A.USERCODE = ? ";
				}
				if(!("ALL").equals(employeeCode)){
					query = query + " AND A.EMPLOYEECODE  = ? ";
				}
				/*if(!("").equals(employeeName)){
					query = query + "   AND UPPER(D.EMPNAME) LIKE UPPER(?) ";
				}*/
				//System.out.println(query);
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, makerCode);
				int count = 2;		
				if(!("ALL").equals(userCode)){
					preparedStatement.setString(count, userCode);
					count++;
				}
				if(!("ALL").equals(employeeCode)){
					preparedStatement.setString(count, employeeCode);
					/*count++;
				}
				if(!("").equals(employeeName)){
					preparedStatement.setString(count, employeeName);*/
				}
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					dataMap.put("USERCODE", resultSet.getString("USERCODE"));
					dataMap.put("FIRSTNAME", resultSet.getString("FIRSTNAME"));
					dataMap.put("LASTNAME", resultSet.getString("LASTNAME"));
					dataMap.put("EMAILID", resultSet.getString("EMAILID"));
					dataMap.put("MOBILENO", resultSet.getString("MOBILENO"));
					dataMap.put("DESIGNATION", resultSet.getString("DESIGNATION"));
					dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
					dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
					dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
					dataMap.put("CREDENTIALEXPIRED", resultSet.getString("CREDENTIALEXPIRED"));
					dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
					dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
					dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
					dataMap.put("USERSTATUS", "Approved");
					dataMap.put("ACCESSSTARTTIME", resultSet.getString("ACCESSSTARTTIME"));
					dataMap.put("ACCESSENDTIME", resultSet.getString("ACCESSENDTIME"));
					dataMap.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
					dataMap.put("APPROVEDBY", resultSet.getString("APPROVEDBY"));
					dataMap.put("CHECKERREMAKRS", resultSet.getString("CHECKERREMAKRS"));
					dataMap.put("APPROVEDTIMESTAMP", resultSet.getString("APPROVEDTIMESTAMP"));
					dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
					dataMap.put("ISETLUSER", resultSet.getString("ISETLUSER"));
					dataMap.put("DEPARTMENTCODE", resultSet.getString("DEPARTMENTCODE"));
					dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
					dataMap.put("GROUPCODE", resultSet.getString("ROLEID"));
					dataMap.put("MAKERID", resultSet.getString("MAKERID"));
					dataMap.put("MAKERCODE", makerCode);
					//System.out.println("result dataMap = "+dataMap);
				}
			}
			
		}catch(Exception e){
			log.error("Error while getting users from edit : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println("userresult="+dataMap);
		return dataMap;
	}
	
	public String updateUserDetails(Map<String, String> userDetails, String actionFlag, String makerId, String updatedBy){
		String message = "";
		boolean isInsert = true;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet = null;
		String statusChangeMsg = "";
		String queryLog = "";
		try{
			
			String query = " SELECT ACCOUNTENABLE, ACCOUNTLOCKED, ACCOUNTDELETED, ACCOUNTDORMANT "+
					       "   FROM TB_USER "+
					       "  WHERE USERCODE = ? ";
			
			/*System.out.println(userDetails.get("USERCODE"));
			System.out.println(userDetails.get("MAKERCODEFROMSEARCH"));*/
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userDetails.get("USERCODE"));
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()) {
				if(!resultSet.getString("ACCOUNTENABLE").equals(userDetails.get("ACCOUNTENABLE"))){
					statusChangeMsg = "User's Account Enabling Status has been updated.";
				}
				if(!resultSet.getString("ACCOUNTLOCKED").equalsIgnoreCase(userDetails.get("ACCOUNTLOCKED"))){
					statusChangeMsg = statusChangeMsg +"& "+"User's Account Locking Status has been updated.";
				}
				if(!resultSet.getString("ACCOUNTDELETED").equalsIgnoreCase(userDetails.get("ACCOUNTDELETED"))){
					statusChangeMsg = statusChangeMsg+"& "+"User's Account Deletion Status has been updated.";
				}
				if(!resultSet.getString("ACCOUNTDORMANT").equalsIgnoreCase(userDetails.get("ACCOUNTDORMANT"))){
					statusChangeMsg = statusChangeMsg+"& "+"User's Account Dormancy Status has been updated.";
				}
			}
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();

			query = "SELECT USERCODE, MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = ?";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userDetails.get("USERCODE"));
			preparedStatement.setString(2, "P");
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				makerId = resultSet.getString("MAKERCODE");
				isInsert = false;
				//System.out.println("Details Maker Code = "+makerId);
			}
			
			String userPass = userDetails.get("USERPASS");
			if(userPass.length() == 0){
				userPass = "SAME";
			}
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			
			if(isInsert){
				//System.out.println("INSERT"+statusChangeMsg);
				queryLog = "INSERT INTO TB_USER_MAKER_LOG( "+
						   "	   USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, DESIGNATION, "+
						   "	   ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, CHATENABLE, ACCOUNTLOCKED, "+
						   "	   ACCESSSTARTTIME, ACCESSENDTIME, ACCESSPOINTS, CREATIONTIME, ACCOUNTEXIPYDATE, "+
						   "	   BRANCHCODE, ISETLUSER, MAKERCODE, ACCOUNTDELETED, DEPARTMENTCODE, EMPLOYEECODE, "+
						   "	   ROLECODE, MAKERID, ACCOUNTDORMANT, UPDATETIMESTAMP, UPDATEDON, UPDATEDBY) "+
						   "SELECT USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, DESIGNATION, "+
				  		   "	   ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, CHATENABLE, ACCOUNTLOCKED, "+ 
				  		   "       ACCESSSTARTTIME, ACCESSENDTIME, ACCESSPOINTS, CREATIONTIME, ACCOUNTEXIPYDATE, "+
				  		   "	   BRANCHCODE, ISETLUSER, ?, ACCOUNTDELETED, DEPARTMENTCODE, EMPLOYEECODE, "+ 
				  		   "       ROLECODE, MAKERID, ACCOUNTDORMANT, UPDATETIMESTAMP, SYSTIMESTAMP, ? "+
				  		   "  FROM TB_USER WHERE USERCODE = ? ";
				
				preparedStatement1 = connection.prepareStatement(queryLog);
				preparedStatement1.setString(1, makerId);
				preparedStatement1.setString(2, updatedBy);
				preparedStatement1.setString(3, userDetails.get("USERCODE"));
				preparedStatement1.executeUpdate();
				
				connectionUtil.closeResources(connection, preparedStatement1, null, null);
				connection = connectionUtil.getConnection();
				
				
				if(("UserProfile").equalsIgnoreCase(actionFlag)){
				query = "INSERT INTO TB_USER_MAKER( "+
						"		USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, DESIGNATION, "+
						"		ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, CHATENABLE, ACCOUNTLOCKED, "+
						"		ACCESSSTARTTIME, ACCESSENDTIME, ACCESSPOINTS, CREATIONTIME, ACCOUNTEXIPYDATE, "+
						"		BRANCHCODE, ISETLUSER, MAKERCODE, ACCOUNTDELETED, DEPARTMENTCODE, EMPLOYEECODE, "+
						"		ROLECODE, MAKERID, ACCOUNTDORMANT, UPDATETIMESTAMP, ACTIONTYPE, STATUSCHANGEMESSAGE ) "+
					 	"VALUES (?, ?, ?, ?, ?, ?, ?, "+
						"		 ?, ?, ?, ?, ?, "+
					 	"		 ?, ?, '', SYSTIMESTAMP, FUN_CHARTODATE(?), "+
						"		 ?, ?, ?, ?, ?, ?,"+
					 	"		 ?, ?, ?, SYSTIMESTAMP, ?, ?)";
				}else{
					query = "INSERT INTO TB_USER_MAKER( "+
							"		USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, DESIGNATION, "+
							"		ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, CHATENABLE, ACCOUNTLOCKED, "+
							"		ACCESSSTARTTIME, ACCESSENDTIME, ACCESSPOINTS, CREATIONTIME, ACCOUNTEXIPYDATE, "+
							"		BRANCHCODE, ISETLUSER, MAKERCODE, ACCOUNTDELETED, DEPARTMENTCODE, EMPLOYEECODE, "+
							"		ROLECODE, MAKERID, ACCOUNTDORMANT, UPDATETIMESTAMP, STATUSUPDATETIMESTAMP, ACTIONTYPE, STATUSCHANGEMESSAGE) "+
						 	"VALUES (?, ?, ?, ?, ?, ?, ?, "+
							"		 ?, ?, ?, ?, ?, "+
						 	"		 ?, ?, '', SYSTIMESTAMP, FUN_CHARTODATE(?), "+
							"		 ?, ?, ?, ?, ?, ?,"+
						 	"		 ?, ?, ?, SYSTIMESTAMP, SYSTIMESTAMP, ?, ?)";
				}
				System.out.println(makerId+" "+userDetails.get("GROUPCODE"));
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userDetails.get("USERCODE"));
				preparedStatement.setString(2, userPass);
				preparedStatement.setString(3, userDetails.get("FIRSTNAME"));
				preparedStatement.setString(4, userDetails.get("LASTNAME"));
				preparedStatement.setString(5, userDetails.get("EMAILID"));
				preparedStatement.setString(6, userDetails.get("MOBILENO"));
				preparedStatement.setString(7, userDetails.get("DESIGNATION"));
				preparedStatement.setString(8, userDetails.get("ACCOUNTENABLE"));
				preparedStatement.setString(9, userDetails.get("ACCOUNTEXPIRED"));
				preparedStatement.setString(10, userDetails.get("CREDENTIALEXPIRED"));
				preparedStatement.setString(11, userDetails.get("CHATENABLE"));
				preparedStatement.setString(12, userDetails.get("ACCOUNTLOCKED"));
				preparedStatement.setString(13, userDetails.get("ACCESSSTARTTIME")+":00");
				preparedStatement.setString(14, userDetails.get("ACCESSENDTIME")+":59");
				preparedStatement.setString(15, userDetails.get("ACCOUNTEXIPYDATE"));
				preparedStatement.setString(16, userDetails.get("BRANCHCODE"));
				preparedStatement.setString(17, userDetails.get("ISETLUSER"));
				preparedStatement.setString(18, makerId);
				preparedStatement.setString(19, userDetails.get("ACCOUNTDELETED"));
				preparedStatement.setString(20, userDetails.get("DEPARTMENTCODE"));
				preparedStatement.setString(21, userDetails.get("EMPLOYEECODE"));
				preparedStatement.setString(22, userDetails.get("GROUPCODE"));
				preparedStatement.setString(23, updatedBy);
				preparedStatement.setString(24, userDetails.get("ACCOUNTDORMANT"));
				preparedStatement.setString(25, actionFlag);
				preparedStatement.setString(26, statusChangeMsg);
				preparedStatement.executeUpdate();
				
				if(("UserProfile").equalsIgnoreCase(actionFlag)){
					query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE, ISNEWUSER, USERDETAILSUPDATEED, USERDETAILSUPDATEDBY, "+
							"		USERDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
							"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userDetails.get("USERCODE"));
					preparedStatement.setString(2, "N");
					preparedStatement.setString(3, "Y");
					preparedStatement.setString(4, updatedBy);
					preparedStatement.setString(5, "P");
					preparedStatement.setString(6, makerId);
					
				}else{
					query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE, ISNEWUSER, USERDETAILSUPDATEED, USERDETAILSUPDATEDBY, "+
							"		USERDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE, USERSTATUSDETAILSUPDATED, "+
							"		USERSTATUSDETAILSUPDATEDBY, USERSTATUSDETAILSUPDATEDTIME) "+
							"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?,?,?,SYSTIMESTAMP)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userDetails.get("USERCODE"));
					preparedStatement.setString(2, "N");
					preparedStatement.setString(3, "Y");
					preparedStatement.setString(4, updatedBy);
					preparedStatement.setString(5, "P");
					preparedStatement.setString(6, makerId);
					preparedStatement.setString(7, "Y");
					preparedStatement.setString(8, updatedBy);
				}
				
				preparedStatement.executeUpdate();
				
			/*	query = " DELETE FROM TB_USERROLEMAPPING_MAKER "+
				        "  WHERE USERCODE = ? ";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userDetails.get("USERCODE"));
				preparedStatement.executeUpdate();
				
				query = "INSERT INTO TB_USERROLEMAPPING_MAKER(ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP) "+
						"VALUES (?,?,(SELECT PRIORITY FROM TB_ROLE WHERE ROLEID = ?),?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userDetails.get("GROUPCODE"));
				preparedStatement.setString(2, userDetails.get("USERCODE"));
				preparedStatement.setString(3, userDetails.get("GROUPCODE"));
				preparedStatement.setString(4, updatedBy);
				
				preparedStatement.executeUpdate();
		    */		
				if(("UserProfile").equalsIgnoreCase(actionFlag)){
					message = "New user profile details update request has been raised for "+userDetails.get("USERCODE");
				}else{
					message = "New user status details update request has been raised for "+userDetails.get("USERCODE");
				}
			}else{
				//System.out.println("UPDATE"+statusChangeMsg);
				if(("UserProfile").equalsIgnoreCase(actionFlag)){
					query = "UPDATE TB_USER_MAKER SET "+
							"	    USERPASS = ?, FIRSTNAME = ?, LASTNAME = ?, EMAILID = ?, MOBILENO = ?, DESIGNATION = ?, "+
							"		ACCOUNTENABLE = ?, ACCOUNTEXPIRED = ?, CREDENTIALEXPIRED = ?, CHATENABLE = ?, "+
							"		ACCOUNTEXIPYDATE = FUN_CHARTODATE(?), ACCESSSTARTTIME = ?, ACCESSENDTIME = ?, "+
							"       BRANCHCODE = ?, ISETLUSER = ?, ACCOUNTDELETED = ?, ACCOUNTLOCKED = ?, DEPARTMENTCODE = ?, "+
							"       EMPLOYEECODE = ?, ROLECODE = ?, MAKERID = ?, ACCOUNTDORMANT = ?, UPDATETIMESTAMP = SYSTIMESTAMP, "+
							"		ACTIONTYPE = ?, STATUSCHANGEMESSAGE = ? "+
							" WHERE MAKERCODE = ?";
				}else{
					//System.out.println(actionFlag);
					query = "UPDATE TB_USER_MAKER SET "+
							"	    USERPASS = ?, FIRSTNAME = ?, LASTNAME = ?, EMAILID = ?, MOBILENO = ?, DESIGNATION = ?, "+
							"		ACCOUNTENABLE = ?, ACCOUNTEXPIRED = ?, CREDENTIALEXPIRED = ?, CHATENABLE = ?, "+
							"		ACCOUNTEXIPYDATE = FUN_CHARTODATE(?), ACCESSSTARTTIME = ?, ACCESSENDTIME = ?, "+
							"       BRANCHCODE = ?, ISETLUSER = ?, ACCOUNTDELETED = ?, ACCOUNTLOCKED = ?, DEPARTMENTCODE = ?, "+
							"       EMPLOYEECODE = ?, ROLECODE = ?, MAKERID = ?, ACCOUNTDORMANT = ?, UPDATETIMESTAMP = SYSTIMESTAMP, "+
							"		STATUSUPDATETIMESTAMP = SYSTIMESTAMP, ACTIONTYPE = ?, STATUSCHANGEMESSAGE = ? "+
							" WHERE MAKERCODE = ?";
				}
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userPass);
				preparedStatement.setString(2, userDetails.get("FIRSTNAME"));
				preparedStatement.setString(3, userDetails.get("LASTNAME"));
				preparedStatement.setString(4, userDetails.get("EMAILID"));
				preparedStatement.setString(5, userDetails.get("MOBILENO"));
				preparedStatement.setString(6, userDetails.get("DESIGNATION"));
				preparedStatement.setString(7, userDetails.get("ACCOUNTENABLE"));
				preparedStatement.setString(8, userDetails.get("ACCOUNTEXPIRED"));
				preparedStatement.setString(9, userDetails.get("CREDENTIALEXPIRED"));
				preparedStatement.setString(10, userDetails.get("CHATENABLE"));
				preparedStatement.setString(11, userDetails.get("ACCOUNTEXIPYDATE"));
				preparedStatement.setString(12, userDetails.get("ACCESSSTARTTIME")+":00");
				preparedStatement.setString(13, userDetails.get("ACCESSENDTIME")+":59");
				preparedStatement.setString(14, userDetails.get("BRANCHCODE"));
				preparedStatement.setString(15, userDetails.get("ISETLUSER"));
				preparedStatement.setString(16, userDetails.get("ACCOUNTDELETED"));
				preparedStatement.setString(17, userDetails.get("ACCOUNTLOCKED"));
				preparedStatement.setString(18, userDetails.get("DEPARTMENTCODE"));
				preparedStatement.setString(19, userDetails.get("EMPLOYEECODE"));
				preparedStatement.setString(20, userDetails.get("GROUPCODE"));
				preparedStatement.setString(21, updatedBy);
				preparedStatement.setString(22, userDetails.get("ACCOUNTDORMANT"));
				preparedStatement.setString(23, actionFlag);
				preparedStatement.setString(24, statusChangeMsg);
				preparedStatement.setString(25, makerId);
				preparedStatement.executeUpdate();
				
				if(("UserProfile").equalsIgnoreCase(actionFlag)){
			 		query = "UPDATE TB_USER_CHECKERACTIVITY SET USERDETAILSUPDATEED = 'Y', USERDETAILSUPDATEDBY = ?, USERDETAILSUPDATETIME = SYSTIMESTAMP, "+
							"       ACTIONSTATUS = 'P', UPDATETIMESTAMP = SYSTIMESTAMP "+
			 				" WHERE MAKERCODE = ?";
				}else{
					query = "UPDATE TB_USER_CHECKERACTIVITY SET USERSTATUSDETAILSUPDATED = 'Y', USERSTATUSDETAILSUPDATEDBY = ?, USERSTATUSDETAILSUPDATEDTIME = SYSTIMESTAMP, "+
							"       ACTIONSTATUS = 'P', UPDATETIMESTAMP = SYSTIMESTAMP "+
			 				" WHERE MAKERCODE = ?";
				}
		 		preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, updatedBy);
				preparedStatement.setString(2, makerId);
				preparedStatement.executeUpdate();
				//System.out.println(query);
				
			/*	query = "UPDATE TB_USERROLEMAPPING_MAKER SET "+
						"		ROLEID = ?, USERCODE = ?, LOGINPRIORITY = (SELECT PRIORITY FROM TB_ROLE WHERE ROLEID = ?), UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE USERCODE = ? ";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userDetails.get("GROUPCODE"));
				preparedStatement.setString(2, userDetails.get("USERCODE"));
				preparedStatement.setString(3, userDetails.get("GROUPCODE"));
				preparedStatement.setString(4, updatedBy);
				preparedStatement.setString(5, userDetails.get("USERCODE"));
				
				preparedStatement.executeUpdate();
			*/	
				if(("UserProfile").equalsIgnoreCase(actionFlag)){
					message = "User profile details update request has been raised for "+userDetails.get("USERCODE");
				}else{
					message = "User status details update request has been raised for "+userDetails.get("USERCODE");
				}
			}
			
		}catch(Exception e){
			message = "Failed to raised user update request";
			log.error("Error while saving user update : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(null, preparedStatement1, null, null);
		}		
		return message;
	}
	
	@Override
	public List<Map<String, String>> searchIPAddress(String ipAddress, String systemName){
		List<Map<String, String>> mainMap = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;		
		String query =  "SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME, CASE NVL(A.ISENABLED, 'Y') WHEN 'Y' THEN 'Yes' ELSE 'No' END ISENABLED, A.UPDATEDBY UPDATEDBY, "+
				  		"       CASE A.UPDATETIMESTAMP WHEN NULL THEN '''' ELSE TO_CHAR(A.UPDATETIMESTAMP, 'DD/MM/YYYY') END UPDATETIMESTAMP, A.MAKERCODE MAKERCODE "+
				  		"  FROM TB_IPADDRESS A "+
				  		" WHERE 1 = 1 ";
		String query1 = "SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME, CASE NVL(A.ISENABLED, 'Y') WHEN 'Y' THEN 'Yes' ELSE 'No' END ISENABLED, A.UPDATEDBY UPDATEDBY, "+
				  		"		CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' ELSE 'Rejected' END IPSTATUS, "+	
				  		"       CASE A.UPDATETIMESTAMP WHEN NULL THEN '''' ELSE TO_CHAR(A.UPDATETIMESTAMP, 'DD/MM/YYYY') END UPDATETIMESTAMP, A.MAKERCODE MAKERCODE "+
				  		"  FROM TB_IPADDRESS_MAKER A, TB_IPADDRESS_CHECKERACTIVITY B "+
				  		" WHERE A.IPADDRESS = B.IPADDRESS "+
				  		"   AND A.MAKERCODE = B.MAKERCODE "+
				  		"   AND B.ACTIONSTATUS <> 'A' ";
		try{
			if(ipAddress != null && !"".equals(ipAddress)){
				/*
				query = query + "AND UPPER(A.IPADDRESS) LIKE UPPER('%"+ipAddress+"%') ";
				query1 = query1 + "AND UPPER(A.IPADDRESS) LIKE UPPER('%"+ipAddress+"%') ";
				*/
				query = query + " AND UPPER(A.IPADDRESS) LIKE UPPER(?) ";
				query1 = query1 + " AND UPPER(A.IPADDRESS) LIKE UPPER(?) ";
			}
			if(systemName != null && !"".equals(systemName)){
				/*				
				query = query + "AND UPPER(A.SYSTEMNAME) LIKE UPPER('%"+systemName+"%') ";
				query1 = query1 + "AND UPPER(A.SYSTEMNAME) LIKE UPPER('%"+systemName+"%') ";
				 */
				query = query + " AND UPPER(A.SYSTEMNAME) LIKE UPPER(?) ";
				query1 = query1 + " AND UPPER(A.SYSTEMNAME) LIKE UPPER(?) ";
			}
			query = query + " ORDER BY A.UPDATETIMESTAMP DESC";
			query1 = query1 + " ORDER BY A.UPDATETIMESTAMP DESC";
			int count = 1;
			preparedStatement = connection.prepareStatement(query);
			if(ipAddress != null && !"".equals(ipAddress)){
				preparedStatement.setString(count, "%"+ipAddress+"%");
				count++;
			}
			if(systemName != null && !"".equals(systemName)){
				preparedStatement.setString(count, "%"+systemName+"%");
			}
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("IPADDRESS", resultSet.getString("IPADDRESS"));
				dataMap.put("SYSTEMNAME", resultSet.getString("SYSTEMNAME"));
				dataMap.put("IPSTATUS", "Checked");
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				dataMap.put("TABLE", "_IPADDRESS");
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				mainMap.add(dataMap);
			}
			
			count = 1;
			preparedStatement = connection.prepareStatement(query1);
			if(ipAddress != null && !"".equals(ipAddress)){
				preparedStatement.setString(count, ipAddress);
				count++;
			}
			if(systemName != null && !"".equals(systemName)){
				preparedStatement.setString(count, systemName);
			}
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("IPADDRESS", resultSet.getString("IPADDRESS"));
				dataMap.put("SYSTEMNAME", resultSet.getString("SYSTEMNAME"));
				dataMap.put("IPSTATUS", resultSet.getString("IPSTATUS"));
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				dataMap.put("TABLE", "_IPADDRESS_MAKER");
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				mainMap.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while searching ipaddress : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	
	@Override
	public List<Map<String, String>> createIPAddress(String ipAddress, String systemName, String createdBy, String makerCode){
		List<Map<String, String>> mainMap = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "INSERT INTO TB_IPADDRESS_MAKER(IPADDRESS, SYSTEMNAME, ISENABLED, UPDATEDBY, UPDATETIMESTAMP, MAKERCODE) "+
						"VALUES (?,?,?,?,SYSTIMESTAMP,?)";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, ipAddress);
			preparedStatement.setString(2, systemName);
			preparedStatement.setString(3, "Y");
			preparedStatement.setString(4, createdBy);
			preparedStatement.setString(5, makerCode);
			preparedStatement.executeQuery();
			
			query = "INSERT INTO TB_IPADDRESS_CHECKERACTIVITY(IPADDRESS, ISNEWIPADDRESS, ACTIONSTATUS, UPDATEDBY, UPDATETIMESTAMP, MAKERCODE) "+
					"VALUES (?,?,?,?,SYSTIMESTAMP,?)";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, ipAddress);
			preparedStatement.setString(2, "Y");
			preparedStatement.setString(3, "P");
			preparedStatement.setString(4, createdBy);
			preparedStatement.setString(5, makerCode);
			preparedStatement.executeUpdate();
			
			query = "SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME, CASE NVL(A.ISENABLED, 'Y') WHEN 'Y' THEN 'Yes' ELSE 'No' END ISENABLED, A.UPDATEDBY UPDATEDBY, "+
			  		"		CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' ELSE 'Rejected' END IPSTATUS, "+	
			  		"       CASE A.UPDATETIMESTAMP WHEN NULL THEN '''' ELSE TO_CHAR(A.UPDATETIMESTAMP, 'DD/MM/YYYY') END UPDATETIMESTAMP "+
			  		"  FROM TB_IPADDRESS_MAKER A, TB_IPADDRESS_CHECKERACTIVITY B "+
			  		" WHERE A.IPADDRESS = B.IPADDRESS "+
			  		"   AND A.MAKERCODE = B.MAKERCODE "+
			  		"   AND A.IPADDRESS = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, ipAddress);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("IPADDRESS", resultSet.getString("IPADDRESS"));
				dataMap.put("SYSTEMNAME", resultSet.getString("SYSTEMNAME"));
				dataMap.put("IPSTATUS", resultSet.getString("IPSTATUS"));
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				dataMap.put("TABLE", "_IPADDRESS_MAKER");
				mainMap.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while creating ip address : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	
	@Override
	public List<Map<String, String>> getAllIPAddressFromEdit(){
		List<Map<String, String>> mainList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.IPADDRESS IPADDRESS, '_IPADDRESS' AS USETABLE, A.MAKERCODE MAKERCODE, A.IPADDRESS || '  [ ' || A.SYSTEMNAME || ' ] (Checked)' AS IPSTATUS "+
				       "  FROM TB_IPADDRESS A "+
				       " UNION ALL "+
				       "SELECT B.IPADDRESS IPADDRESS, '_IPADDRESS_MAKER' AS USETABLE, B.MAKERCODE MAKERCODE, "+
				       "  CASE NVL(C.ACTIONSTATUS , 'P') WHEN 'P' THEN B.IPADDRESS || '  [ ' || B.SYSTEMNAME || ' ] (Pending)' WHEN 'R' THEN B.IPADDRESS || '  [ ' || B.SYSTEMNAME || ' ] (Rejected)' ELSE B.IPADDRESS || '  [ ' || B.SYSTEMNAME || ' ] (Approved)' END AS IPSTATUS "+
				       "  FROM TB_IPADDRESS_MAKER B, TB_IPADDRESS_CHECKERACTIVITY C "+
				       " WHERE B.IPADDRESS = C.IPADDRESS "+
				       "   AND B.MAKERCODE = C.MAKERCODE "+
				       "   AND C.ACTIONSTATUS <> ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, "A");
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("DISPLAY", resultSet.getString("IPSTATUS"));
				dataMap.put("VALUE", resultSet.getString("IPADDRESS")+","+resultSet.getString("USETABLE")+","+resultSet.getString("MAKERCODE"));
				mainList.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while getting users from edit : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainList;
	}
	
	public Map<String, String> getIPAddressForEdit(String ipAddress, String tableName, String makerCode){
		Map<String, String> dataMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";		
		try{
			if(tableName.contains("MAKER")){
				query = "SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME, "+
						"       CASE NVL(A.ISENABLED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ISENABLED, "+
						"		CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' WHEN 'R' THEN 'Rejected' ELSE 'Approved' END IPSTATUS, "+
						"       B.APPROVEDBY APPROVEDBY, B.CHECKERREMAKRS CHECKERREMAKRS, CASE APPROVEDTIMESTAMP WHEN NULL THEN '' ELSE TO_CHAR(APPROVEDTIMESTAMP, 'DD/MM/YYYY') END APPROVEDTIMESTAMP "+
						"  FROM TB_IPADDRESS_MAKER A, TB_IPADDRESS_CHECKERACTIVITY B "+
						" WHERE A.IPADDRESS = B.IPADDRESS "+
						"   AND A.MAKERCODE = B.MAKERCODE "+
						"   AND A.IPADDRESS = ? "+
						"   AND A.MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, ipAddress);
				preparedStatement.setString(2, makerCode);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					dataMap.put("IPADDRESS", resultSet.getString("IPADDRESS"));
					dataMap.put("SYSTEMNAME", resultSet.getString("SYSTEMNAME"));
					dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
					dataMap.put("IPSTATUS", resultSet.getString("IPSTATUS"));
					dataMap.put("APPROVEDBY", resultSet.getString("APPROVEDBY"));
					dataMap.put("CHECKERREMAKRS", resultSet.getString("CHECKERREMAKRS"));
					dataMap.put("APPROVEDTIMESTAMP", resultSet.getString("APPROVEDTIMESTAMP"));
				}
			}else{
				query = "SELECT A.IPADDRESS IPADDRESS, A.SYSTEMNAME SYSTEMNAME, "+
						"       CASE NVL(A.ISENABLED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ISENABLED, "+
						"       B.APPROVEDBY APPROVEDBY, B.CHECKERREMAKRS CHECKERREMAKRS, CASE APPROVEDTIMESTAMP WHEN NULL THEN '' ELSE TO_CHAR(APPROVEDTIMESTAMP, 'DD/MM/YYYY') END APPROVEDTIMESTAMP "+
						"  FROM TB_IPADDRESS A, TB_IPADDRESS_CHECKERACTIVITY B "+
						" WHERE A.IPADDRESS = B.IPADDRESS "+
						"   AND A.MAKERCODE = B.MAKERCODE "+
						"   AND A.IPADDRESS = ? "+
						"   AND A.MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, ipAddress);
				preparedStatement.setString(2, makerCode);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					dataMap.put("IPADDRESS", resultSet.getString("IPADDRESS"));
					dataMap.put("SYSTEMNAME", resultSet.getString("SYSTEMNAME"));
					dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
					dataMap.put("IPSTATUS", "Approved");
					dataMap.put("APPROVEDBY", resultSet.getString("APPROVEDBY"));
					dataMap.put("CHECKERREMAKRS", resultSet.getString("CHECKERREMAKRS"));
					dataMap.put("APPROVEDTIMESTAMP", resultSet.getString("APPROVEDTIMESTAMP"));
				}
			}
		}catch(Exception e){
			log.error("Error while getting users from edit : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	public String updateIPAddress(Map<String, String> ipDetails, String makerId, String createdBy){
		String message = "";
		boolean isInsert = true;
		String isNewIPAddress = "Y";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";		
		try{
			query = "SELECT IPADDRESS, MAKERCODE FROM TB_IPADDRESS_CHECKERACTIVITY WHERE ACTIONSTATUS = ? AND IPADDRESS = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, "P");
			preparedStatement.setString(2, ipDetails.get("IPADDRESS"));
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				isInsert = false;
				makerId = resultSet.getString("MAKERCODE");
			}
			
			query = "SELECT IPADDRESS FROM TB_IPADDRESS WHERE IPADDRESS = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, ipDetails.get("IPADDRESS"));
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				isNewIPAddress = "N";
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			
			if(isInsert){
				query = "INSERT INTO TB_IPADDRESS_MAKER(IPADDRESS, SYSTEMNAME, ISENABLED, UPDATEDBY, UPDATETIMESTAMP, MAKERCODE) "+
						"VALUES (?,?,?,?,SYSTIMESTAMP,?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, ipDetails.get("IPADDRESS"));
				preparedStatement.setString(2, ipDetails.get("SYSTEMNAME"));
				preparedStatement.setString(3, ipDetails.get("ENABLED"));
				preparedStatement.setString(4, createdBy);
				preparedStatement.setString(5, makerId);
				preparedStatement.executeUpdate();
				
				query = "INSERT INTO TB_IPADDRESS_CHECKERACTIVITY(IPADDRESS, ISNEWIPADDRESS, ACTIONSTATUS, UPDATEDBY, UPDATETIMESTAMP, MAKERCODE) "+
						"VALUES (?,?,?,?,SYSTIMESTAMP,?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, ipDetails.get("IPADDRESS"));
				preparedStatement.setString(2, isNewIPAddress);
				preparedStatement.setString(3, "P");
				preparedStatement.setString(4, createdBy);
				preparedStatement.setString(5, makerId);
				preparedStatement.executeUpdate();
				message = "New IP details updated request has been raised for : "+ipDetails.get("IPADDRESS");
			}else{
				query = "UPDATE TB_IPADDRESS_MAKER SET SYSTEMNAME = ?, ISENABLED = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE IPADDRESS = ? "+
						"   AND MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, ipDetails.get("SYSTEMNAME"));
				preparedStatement.setString(2, ipDetails.get("ENABLED"));
				preparedStatement.setString(3, createdBy);
				preparedStatement.setString(4, ipDetails.get("IPADDRESS"));
				preparedStatement.setString(5, makerId);
				preparedStatement.executeUpdate();
				
				query = "UPDATE TB_IPADDRESS_CHECKERACTIVITY SET UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE IPADDRESS = ? "+
						"   AND MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, createdBy);
				preparedStatement.setString(2, ipDetails.get("IPADDRESS"));
				preparedStatement.setString(3, makerId);
				preparedStatement.executeUpdate();
				message = "IP details updated request has been updated for : "+ipDetails.get("IPADDRESS");
			}
		}catch(Exception e){
			message = "Failed to raise IP details update";
			log.error("Error while update ip address : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public List<Map<String, String>> getAllUserForGroupMapping(String loggedInUsercode){
		List<Map<String, String>> allUsers = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, 'Checked' USERSTATUS, '' USETABLE "+
					   "  FROM TB_USER A "+
					   " WHERE A.USERCODE <> ? "+
					   " UNION ALL "+
					   "SELECT B.USERCODE USERCODE, B.FIRSTNAME FIRSTNAME, B.LASTNAME LASTNAME, 'Pending' USERSTATUS, '_MAKER' USETABLE "+ 
					   "  FROM TB_USER B, TB_USER_CHECKERACTIVITY C "+  
					   " WHERE B.USERCODE = C.USERCODE "+
					   "   AND C.ACTIONSTATUS = 'P' "+
					   "   AND C.ROLEDETAILSUPDATED = 'Y' "+
					   " UNION "+
					   "SELECT D.USERCODE USERCODE, D.FIRSTNAME FIRSTNAME, D.LASTNAME LASTNAME, 'Pending' USERSTATUS, '_MAKER' USETABLE  "+
					   "  FROM TB_USER_MAKER D, TB_USER_CHECKERACTIVITY E "+ 
					   " WHERE D.MAKERCODE = E.MAKERCODE "+
					   "   AND E.ACTIONSTATUS = 'P' "+
					   "   AND (E.ROLEDETAILSUPDATED = 'Y' "+
					   "    OR E.ISNEWUSER = 'Y')";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, loggedInUsercode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> userMap = new HashMap<String, String>();
				userMap.put("DISPLAY", resultSet.getString("USERCODE") +"  [ "+resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME")+" ]  "+"("+resultSet.getString("USERSTATUS")+")");
				userMap.put("VALUE", resultSet.getString("USERCODE")+","+resultSet.getString("USETABLE"));
				allUsers.add(userMap);
			}
		}catch(Exception e){
			log.error("Error while getting users for group mapping : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allUsers;
	}
	
	@Override
	public List<String> getAllRolesAvailable(){
		List<String> allRoles = new Vector<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT ROLEID FROM TB_ROLE ORDER BY PRIORITY ASC";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				allRoles.add(resultSet.getString("ROLEID"));
			}
		}catch(Exception e){
			log.error("Error while getting all roles : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allRoles;
	}
	
	@Override
	public Map<String, Map<String, List<Map<String, String>>>> getAllModulesForRoles(List<String> allRoles){
		Map<String, Map<String, List<Map<String, String>>>> allModules = new HashMap<String, Map<String, List<Map<String, String>>>>();
		Map<String, List<Map<String, String>>> allMainModule = new LinkedHashMap<String, List<Map<String, String>>>();
		Map<String, List<Map<String, String>>> allSubModule = new LinkedHashMap<String, List<Map<String, String>>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		Connection connection1 = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet1 = null;
		
		String query = "SELECT A.MODULECODE MODULECODE, A.MODULENAME MODULENAME "+
					   "  FROM TB_MODULE A, TB_ROLEMODULEMAPPING B "+
					   " WHERE A.MODULECODE = B.MODULECODE "+
					   "   AND B.ROLEID = ? "+
					   "   AND A.MAINORSUBMODULE = 'M' "+
					   " ORDER BY DISPLAYORDER ASC ";
		String query1 = "SELECT A.MODULECODE MODULECODE, A.MODULENAME MODULENAME "+
					    "  FROM TB_MODULE A "+
					    " WHERE A.MAINORSUBMODULE = 'S' "+
					    "   AND MAINMODULECODE = ?";
		for(String roleId : allRoles){
			connection = connectionUtil.getConnection();
			List<Map<String, String>> mainModules = new Vector<Map<String, String>>();
			try{
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, roleId);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					Map<String, String> moduleDetails = new HashMap<String, String>();
					moduleDetails.put("MODULECODE", resultSet.getString("MODULECODE"));
					moduleDetails.put("MODULENAME", resultSet.getString("MODULENAME"));
					mainModules.add(moduleDetails);
					
					connection1 = connectionUtil.getConnection();
					List<Map<String, String>> subModules = new Vector<Map<String, String>>();
					try{
						preparedStatement1 = connection.prepareStatement(query1);
						preparedStatement1.setString(1, resultSet.getString("MODULECODE"));
						resultSet1 = preparedStatement1.executeQuery();
						while (resultSet1.next()) {
							Map<String, String> subModuleDetails = new HashMap<String, String>();
							subModuleDetails.put("MODULECODE", resultSet1.getString("MODULECODE"));
							subModuleDetails.put("MODULENAME", resultSet1.getString("MODULENAME"));
							subModules.add(subModuleDetails);
						}
						if(subModules.size() > 0)
							allSubModule.put(resultSet.getString("MODULECODE"), subModules);
					}catch(Exception e){
						log.warn("Error while getting sub modules for main module : "+resultSet.getString("MODULECODE"));
					}finally{
						connectionUtil.closeResources(connection1, preparedStatement1, resultSet1, null);
					}					
				}
				allMainModule.put(roleId, mainModules);
			}catch(Exception e){
				log.error("Error while getting all modules for all roles : "+e.getMessage());
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
		}			
		allModules.put("MAINMODULES", allMainModule);
		allModules.put("SUBMODULES", allSubModule);
		return allModules;
	}
	
	@Override
	public Map<String, Object> getUserAssingedAllRolesModules(String userCode, String table){
		Map<String, Object> rolesModules = new HashMap<String, Object>();
		Map<String, Map<String, String>> allFullRoles = new HashMap<String, Map<String, String>>();		
		Map<String, Map<String, String>> allModules = new HashMap<String, Map<String, String>>(); 		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		if(!"_MAKER".equals(table))
			table = "";
		
		String query = "SELECT A.ROLEID ROLEID "+
					   "  FROM TB_USERROLEMAPPING"+table+" A "+
					   " WHERE A.ROLEID NOT IN (SELECT B.ROLEID "+
					   "						  FROM TB_USERMODULEMAPPING"+table+" B "+
					   "                         WHERE A.USERCODE = B.USERCODE) "+
					   "   AND A.USERCODE = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> roleList = new HashMap<String, String>();
				roleList.put(resultSet.getString("ROLEID"), resultSet.getString("ROLEID"));
				allFullRoles.put(resultSet.getString("ROLEID"), roleList);
			}
			
			query = "SELECT DISTINCT ROLEID FROM TB_USERMODULEMAPPING"+table+" WHERE USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				allModules.put(resultSet.getString("ROLEID"), new HashMap<String, String>());
			}
			
			query = "SELECT ROLEID, MODULECODE FROM TB_USERMODULEMAPPING"+table+" WHERE USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				allModules.get(resultSet.getObject("ROLEID")).put(resultSet.getString("MODULECODE"), resultSet.getString("MODULECODE"));
			}
		}catch(Exception e){
			log.error("Error while getting all roles and module assigned to user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		rolesModules.put("ROLESASSIGNED", allFullRoles);
		rolesModules.put("MODULESASSIGNED", allModules);
		return rolesModules;
	}
	
	@Override
	public Map<String, Object> rolesNotAllowed(List<String> roles){
		Map<String, Object> resultMap = new HashMap<String, Object>();
		boolean isValid = true;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT NOTALLOWEDROLES FROM TB_ROLE WHERE ROLEID = ?";
		try{
			MAINFOR : for(String role : roles){
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, role);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					String rolesNotAllowed = resultSet.getString("NOTALLOWEDROLES") != null ? resultSet.getString("NOTALLOWEDROLES") : "";
					String[] rolesArr = rolesNotAllowed.split(",");
					if(rolesArr.length > 0)
						for(String notAllowedRole : rolesArr){
							if(roles.contains(notAllowedRole)){
								isValid = false;
								resultMap.put("MESSAGE", role+" and "+notAllowedRole+" are not allowed together");
								break MAINFOR;
							}
						}
				}
			}
		resultMap.put("VALID", isValid);
		}catch(Exception e){
			resultMap.put("VALID", false);
			log.error("Error while checking roles not allowed : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resultMap;
	}
	
	public boolean checkRolesModulesAlreadyAssigned(String userCode, List<String> roles, Map<String, List<String>> modulesMap){
		boolean hasNewRoleModule = false;
		List<String> existingRoles = new ArrayList<String>();
		Map<String, List<String>> existingModules = new HashMap<String, List<String>>(); 
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.ROLEID ROLEID "+
					   "  FROM TB_USERROLEMAPPING A "+
					   " WHERE A.USERCODE = ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				existingRoles.add(resultSet.getString("ROLEID"));
			}
			
			if(existingRoles.size() == roles.size()){
				ROLECHECK : for(String role : roles){
					if(!existingRoles.contains(role)){
						hasNewRoleModule = true;
						break ROLECHECK;
					}
				}
			}else{
				hasNewRoleModule = true;
			}
			
		
			if(!hasNewRoleModule){
				query = "SELECT ROLEID, MODULECODE FROM TB_USERMODULEMAPPING WHERE USERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {
					String roleId = resultSet.getString("ROLEID");
					String moduleCode = resultSet.getString("MODULECODE");
					if(existingModules.containsKey(roleId)){
						existingModules.get(roleId).add(moduleCode);
					}else{
						List<String> modules = new ArrayList<String>();
						modules.add(moduleCode);
						existingModules.put(roleId, modules);
					}
				}
				
				if(modulesMap.size() == existingModules.size()){
					int listSize = modulesMap.size();
					List<String> originalList = new ArrayList<String>(modulesMap.keySet());
					List<String> existingList = new ArrayList<String>(existingModules.keySet());
					
					MODULECHECK : for(int i = 0; i < listSize; i++){
						List<String> originalValue = modulesMap.get(originalList.get(i));
						List<String> existingValue = existingModules.get(existingList.get(i));
						if(originalValue.size() == existingValue.size()){
							for(String value : originalValue){
								if(!existingValue.contains(value)){
									hasNewRoleModule = true;
									break MODULECHECK;
								}
							}
						}else{
							hasNewRoleModule = true;
							break MODULECHECK;
						}
					}					
				}else{
					hasNewRoleModule = true;
				}
			}
		}catch(Exception e){
			log.error("Error while checking roles and modules already assigned : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return hasNewRoleModule;
	}
	
	@Override
	public String assignRoleModules(String userCode, List<String> roles, Map<String, List<String>> modules, String makerCode, String createdBy){
		//System.out.println("DAO - Roles= "+roles+", modules= "+modules);
		String message = "";
		boolean isNewEntry = true;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = 'P'";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				makerCode = resultSet.getString("MAKERCODE");
				isNewEntry = false;
			}
			
			query = "DELETE FROM TB_USERROLEMAPPING_MAKER WHERE USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.executeUpdate();
			
			query = "DELETE FROM TB_USERMODULEMAPPING_MAKER WHERE USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.executeUpdate();
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			connection.setAutoCommit(false);
			
			query = "INSERT INTO TB_USERROLEMAPPING_MAKER(ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP) "+
					"VALUES (?,?,(SELECT PRIORITY FROM TB_ROLE WHERE ROLEID = ?),?,SYSTIMESTAMP)";
			preparedStatement = connection.prepareStatement(query);
			for(String role : roles){				
				preparedStatement.setString(1, role);
				preparedStatement.setString(2, userCode);
				preparedStatement.setString(3, role);
				preparedStatement.setString(4, createdBy);
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			
			query = "INSERT INTO TB_USERMODULEMAPPING_MAKER(USERCODE,ROLEID,MODULECODE,UPDATEDBY,UPDATETIMESTAMP) "+
					"VALUES (?,?,?,?,SYSTIMESTAMP)";
			
			preparedStatement = connection.prepareStatement(query);
			Iterator<String> roleItr = modules.keySet().iterator();
			while (roleItr.hasNext()) {
				String role = roleItr.next();
				List<String> mainSubModules = modules.get(role);
				for(String mainSubModule : mainSubModules){
					preparedStatement.setString(1, userCode);
					preparedStatement.setString(2, role);
					preparedStatement.setString(3, mainSubModule);
					preparedStatement.setString(4, createdBy);
					preparedStatement.addBatch();
				}
			}
			preparedStatement.executeBatch();
			connection.commit();
			
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			
			if(isNewEntry){
				query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE,ISNEWUSER,ROLEDETAILSUPDATED,ROLEDETAILSUPDATEDBY, "+
						"       ROLEDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
						"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, "N");
				preparedStatement.setString(3, "Y");
				preparedStatement.setString(4, createdBy);
				preparedStatement.setString(5, "P");
				preparedStatement.setString(6, makerCode);
				preparedStatement.executeUpdate();
			}else{
				query = "UPDATE TB_USER_CHECKERACTIVITY "+
						"   SET ROLEDETAILSUPDATED = ?, ROLEDETAILSUPDATEDBY = ?, ROLEDETAILSUPDATETIME = SYSTIMESTAMP, "+
						"       UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, "Y");
				preparedStatement.setString(2, createdBy);
				preparedStatement.setString(3, makerCode);
				preparedStatement.executeUpdate();
			}
			message = "Selected roles and modules have been assigned to "+userCode;
		}catch(Exception e){
			message = "Error while assigning roles and modules";
			log.error("Error while assigning roles and modules to user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public Map<String, Map<String, Map<String, Object>>> getAllUserForRoleMapping(String roleId){
		Map<String, Map<String, Map<String, Object>>> finalResult = new HashMap<String, Map<String, Map<String, Object>>>();
		Map<String, Map<String, Object>> allUserAlreadyAssigned = new HashMap<String, Map<String, Object>>();
		Map<String, Map<String, Object>> allUserAllowedToAssigned = new HashMap<String, Map<String, Object>>();
		Map<String, Map<String, Object>> allUserNotAllowedToAssigned = new HashMap<String, Map<String, Object>>();
		Map<String, Map<String, Object>> allUserNotAssigned = new HashMap<String, Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = " SELECT A.*, CASE WHEN B.USERCODE IS NOT NULL THEN 'Y' ELSE 'N' END AS ISPRESENT "+
					   "   FROM ( "+
					   " 		SELECT C.USERCODE, C.FIRSTNAME, C.LASTNAME "+
					   "   		  FROM TB_USER C "+
					   "  		 UNION "+
					   " 		SELECT D.USERCODE, D.FIRSTNAME, D.LASTNAME "+
					   "   		  FROM TB_USER_MAKER D, TB_USER_CHECKERACTIVITY E "+
					   "  		 WHERE D.USERCODE = E.USERCODE "+
					   "    	   AND E.ACTIONSTATUS = 'P' "+
					   "        ) A "+
					   "   LEFT OUTER JOIN "+
					   "        ( "+
					   "  		SELECT C.USERCODE, C.ROLEID "+
					   "          FROM TB_USERROLEMAPPING C "+
					   "         WHERE C.ROLEID = ? "+
					   "         UNION "+
					   "		SELECT D.USERCODE, D.ROLEID "+
					   "		  FROM TB_USERROLEMAPPING_MAKER D "+
					   "		 WHERE D.ROLEID = ? "+
					   "        ) B "+
					   "     ON A.USERCODE = B.USERCODE";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, roleId);
			preparedStatement.setString(2, roleId);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, Object> userDetails = new HashMap<String, Object>();
				userDetails.put("USERCODE", resultSet.getString("USERCODE"));
				userDetails.put("FIRSTNAME", resultSet.getString("FIRSTNAME"));
				userDetails.put("LASTNAME", resultSet.getString("LASTNAME"));
				userDetails.put("OTHERROLES", userOtherRoles(resultSet.getString("USERCODE"), roleId));
				userDetails.put("STATUS", PendingOrChecked(resultSet.getString("USERCODE"), roleId));
				if(resultSet.getString("ISPRESENT").equals("Y")){
					allUserAlreadyAssigned.put(resultSet.getString("USERCODE"), userDetails);
				}else{
					allUserNotAssigned.put(resultSet.getString("USERCODE"), userDetails);
				}				
			}
			
			query = "SELECT NVL(NOTALLOWEDROLES, 'NOTFOUND') NOTALLOWEDROLES"+
					"  FROM TB_ROLE "+
					"  WHERE ROLEID IN ( "+
					"                  SELECT ROLEID "+
					"					 FROM TB_USERROLEMAPPING "+
					"                   WHERE USERCODE = ? "+
					"                   UNION "+
					"                  SELECT ROLEID FROM TB_USERROLEMAPPING_MAKER "+
					"                   WHERE USERCODE = ? "+
					"                  )";
			List<String> allUserList = new ArrayList<String>(allUserNotAssigned.keySet());
			for(String userCode : allUserList){
				boolean isAllowed = true;
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, userCode);
				resultSet = preparedStatement.executeQuery();
				NOTALLOWEDCHECK : while (resultSet.next()) {
					if(resultSet.getString("NOTALLOWEDROLES").contains(roleId)){
						isAllowed = false;
						break NOTALLOWEDCHECK;
					}
				}
				Map<String, Object> userDetails = allUserNotAssigned.get(userCode);
				userDetails.put("OTHERROLES", userOtherRoles(userCode, roleId));
				if(isAllowed){					
					allUserAllowedToAssigned.put(userCode, userDetails);
				}else{
					allUserNotAllowedToAssigned.put(userCode, userDetails);
				}
			}
			finalResult.put("ALREADYASSIGNED", allUserAlreadyAssigned);
			finalResult.put("ALLOWED", allUserAllowedToAssigned);
			finalResult.put("NOTALLOWED", allUserNotAllowedToAssigned);
		}catch(Exception e){
			log.error("Error while getting users for role : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return finalResult;
	}
	
	
	private List<String> userOtherRoles(String userCode, String exceptRole){
		List<String> otherRoleList = new ArrayList<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT ROLEID "+
					   "  FROM TB_USERROLEMAPPING "+
					   " WHERE USERCODE = ? "+
					   " UNION "+
					   "SELECT ROLEID FROM TB_USERROLEMAPPING_MAKER "+
					   " WHERE USERCODE = ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if(!resultSet.getString("ROLEID").equals(exceptRole))
					otherRoleList.add(resultSet.getString("ROLEID")+PendingOrChecked(userCode, resultSet.getString("ROLEID")));
			}
		}catch(Exception e){
			log.error("Error while finding user other roles : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return otherRoleList;
	}
	
	private List<String> userOtherIPAddress(String userCode, String exceptIPAddress){
		List<String> otherIPAddressList = new ArrayList<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT IPADDRESS "+
					   "  FROM TB_USERIPADDRESSMAPPING "+
					   " WHERE USERCODE = ? "+
					   " UNION "+
					   "SELECT IPADDRESS FROM TB_USERIPADDRESSMAPPING_MAKER "+
					   " WHERE USERCODE = ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				if(!resultSet.getString("IPADDRESS").equals(exceptIPAddress))
					otherIPAddressList.add(resultSet.getString("IPADDRESS")+PendingOrCheckedIPAddress(userCode, resultSet.getString("IPADDRESS")));
			}
		}catch(Exception e){
			log.error("Error while finding user other roles : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return otherIPAddressList;
	}
	
	@Override
	public Map<String, String> assingRoleToUserByRole(String roleId, List<String> selectedUser, List<String> unSelectedUser, String createdBy, List<String> makerCodeList){
		int makerCodeIndex = 0;
		Map<String, String> result = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";
		try{
			for(String userCode : selectedUser){
				boolean insert = true;
				String makerCode = "";
				query = "SELECT MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = 'P'";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					insert = false;
					makerCode = resultSet.getString("MAKERCODE");
				}else{
					makerCode = makerCodeList.get(makerCodeIndex);
					makerCodeIndex++;
				}
				
				query = "INSERT INTO TB_USERROLEMAPPING_MAKER(ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP) "+
						"VALUES (?,?,(SELECT PRIORITY FROM TB_ROLE WHERE ROLEID = ?),?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, roleId);
				preparedStatement.setString(2, userCode);
				preparedStatement.setString(3, roleId);
				preparedStatement.setString(4, createdBy);
				preparedStatement.executeUpdate();
				
				if(insert){
					query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE,ISNEWUSER,ROLEDETAILSUPDATED,ROLEDETAILSUPDATEDBY, "+
							"       ROLEDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
							"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.setString(2, "N");
					preparedStatement.setString(3, "Y");
					preparedStatement.setString(4, createdBy);
					preparedStatement.setString(5, "P");
					preparedStatement.setString(6, makerCode);
					preparedStatement.executeUpdate();
				}else{
					query = "UPDATE TB_USER_CHECKERACTIVITY "+
							"   SET ROLEDETAILSUPDATED = ?, ROLEDETAILSUPDATEDBY = ?, ROLEDETAILSUPDATETIME = SYSTIMESTAMP, "+
							"       UPDATETIMESTAMP = SYSTIMESTAMP "+
							" WHERE MAKERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, "Y");
					preparedStatement.setString(2, createdBy);
					preparedStatement.setString(3, makerCode);
					preparedStatement.executeUpdate();
				}
			}
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			
			for(String userCode : unSelectedUser){
				boolean insert = true;
				String makerCode = "";
				query = "SELECT MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = 'P'";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					insert = false;
					makerCode = resultSet.getString("MAKERCODE");
				}else{
					makerCode = makerCodeList.get(makerCodeIndex);
					makerCodeIndex++;
				}
				
				query = "DELETE FROM TB_USERROLEMAPPING_MAKER WHERE USERCODE = ? AND ROLEID = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, roleId);
				preparedStatement.executeUpdate();
				
				query = "DELETE FROM TB_USERMODULEMAPPING_MAKER WHERE USERCODE = ? AND ROLEID = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, roleId);
				preparedStatement.executeUpdate();
				
				if(insert){
					query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE,ISNEWUSER,ROLEDETAILSUPDATED,ROLEDETAILSUPDATEDBY, "+
							"       ROLEDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
							"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.setString(2, "N");
					preparedStatement.setString(3, "Y");
					preparedStatement.setString(4, createdBy);
					preparedStatement.setString(5, "P");
					preparedStatement.setString(6, makerCode);
					preparedStatement.executeUpdate();
				}else{
					query = "UPDATE TB_USER_CHECKERACTIVITY "+
							"   SET ROLEDETAILSUPDATED = ?, ROLEDETAILSUPDATEDBY = ?, ROLEDETAILSUPDATETIME = SYSTIMESTAMP, "+
							"       UPDATETIMESTAMP = SYSTIMESTAMP "+
							" WHERE MAKERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, "Y");
					preparedStatement.setString(2, createdBy);
					preparedStatement.setString(3, makerCode);
					preparedStatement.executeUpdate();
				}
			}
			result.put("STATUS", "1");
			result.put("MESSAGE", "Successfully assigned");
		}catch(Exception e){
			result.put("STATUS", "0");
			result.put("MESSAGE", "Failed to assign");
			log.error("Error while assigning role to users : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	private String PendingOrChecked(String userCode, String roleId){
		boolean mainFound = false;
		boolean subFound = false;
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";
		try{			
			query = "SELECT ROLEID FROM TB_USERROLEMAPPING WHERE USERCODE = ? AND ROLEID = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, roleId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				mainFound = true;
			
			query = "SELECT ROLEID FROM TB_USERROLEMAPPING_MAKER WHERE USERCODE = ? AND ROLEID = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, roleId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				subFound = true;
			
			if(mainFound && subFound)
				message = "&nbsp;&nbsp;(<em>Checked</em>)";
			if(mainFound && !subFound)
				message = "&nbsp;&nbsp;<em>(Pending to remove)</em>";
			if(!mainFound && subFound)
				message = "&nbsp;&nbsp;<em>(Pendind to add)</em>";
		}catch(Exception e){
			log.error("Error while assigning role to users : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	private String PendingOrCheckedIPAddress(String userCode, String ipAddress){
		boolean mainFound = false;
		boolean subFound = false;
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";
		try{			
			query = "SELECT IPADDRESS FROM TB_USERIPADDRESSMAPPING WHERE USERCODE = ? AND IPADDRESS = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, ipAddress);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				mainFound = true;
			
			query = "SELECT IPADDRESS FROM TB_USERIPADDRESSMAPPING_MAKER WHERE USERCODE = ? AND IPADDRESS = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, ipAddress);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				subFound = true;
			
			if(mainFound && subFound)
				message = "&nbsp;&nbsp;(<em>Checked</em>)";
			if(mainFound && !subFound)
				message = "&nbsp;&nbsp;<em>(Pending to remove)</em>";
			if(!mainFound && subFound)
				message = "&nbsp;&nbsp;<em>(Pendind to add)</em>";
		}catch(Exception e){
			log.error("Error while checking IP address to users : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public List<Map<String, String>> getAllUserForIPAddressMapping(){
		List<Map<String, String>> allUsers = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, 'Checked' USERSTATUS, '' USETABLE "+
					   "  FROM TB_USER A "+
					   " UNION ALL "+
					   "SELECT B.USERCODE USERCODE, B.FIRSTNAME FIRSTNAME, B.LASTNAME LASTNAME, 'Pending' USERSTATUS, '_MAKER' USETABLE "+ 
					   "  FROM TB_USER B, TB_USER_CHECKERACTIVITY C "+  
					   " WHERE B.USERCODE = C.USERCODE "+
					   "   AND C.ACTIONSTATUS = 'P' "+
					   "   AND C.IPDETAILSUPDATEED = 'Y' "+
					   " UNION "+
					   "SELECT D.USERCODE USERCODE, D.FIRSTNAME FIRSTNAME, D.LASTNAME LASTNAME, 'Pending' USERSTATUS, '_MAKER' USETABLE  "+
					   "  FROM TB_USER_MAKER D, TB_USER_CHECKERACTIVITY E "+ 
					   " WHERE D.MAKERCODE = E.MAKERCODE "+
					   "   AND E.ACTIONSTATUS = 'P' "+
					   "   AND (E.IPDETAILSUPDATEED = 'Y' "+
					   "    OR E.ISNEWUSER = 'Y')";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> userMap = new HashMap<String, String>();
				userMap.put("DISPLAY", resultSet.getString("USERCODE") +"  [ "+resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME")+" ]  "+"("+resultSet.getString("USERSTATUS")+")");
				userMap.put("VALUE", resultSet.getString("USERCODE")+","+resultSet.getString("USETABLE"));
				allUsers.add(userMap);
			}
		}catch(Exception e){
			log.error("Error while getting users for group mapping : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allUsers;
	}
	
	@Override
	public List<Map<String, String>> getAllIPAddress(){
		List<Map<String, String>> allIPAddress = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT IPADDRESS, SYSTEMNAME FROM TB_IPADDRESS WHERE ISENABLED = 'Y'";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> ipAddressDetails = new HashMap<String, String>();
				ipAddressDetails.put("DISPLAY", resultSet.getString("SYSTEMNAME") +"  [ "+resultSet.getString("IPADDRESS")+" ]");
				ipAddressDetails.put("VALUE", resultSet.getString("IPADDRESS"));
				allIPAddress.add(ipAddressDetails);
			}
		}catch(Exception e){
			log.error("Error while getting all ipaddresses : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allIPAddress;
	}
	
	@Override
	public List<Map<String, Object>> getAllIPAddressForMapping(String userCode){
		List<Map<String, Object>> allIPAddress = new ArrayList<Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT E.IPADDRESS, E.SYSTEMNAME, F.IPSTATUS "+
				       "  FROM ( "+
				       "       SELECT * "+
				       "         FROM TB_IPADDRESS "+
				       "        WHERE ISENABLED = 'Y' "+
				       "	   ) E "+
				       "  LEFT OUTER JOIN "+
				       "       ( "+
				       "       SELECT CASE "+
				       "                   WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN A.IPASSIGN "+
				       "                   WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN A.IPASSIGN "+
				       "                   WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN B.IPASSIGN "+
				       "                   ELSE '' "+
				       "               END IPASSIGN, "+
				       "              CASE "+
				       "                   WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Checked' "+
				       "                   WHEN NVL(A.STATUS, 'R') IN ('C') AND NVL(B.STATUS, 'R') IN ('R') THEN 'Pending for remove' "+
				       "                   WHEN NVL(A.STATUS, 'R') IN ('R') AND NVL(B.STATUS, 'R') IN ('P') THEN 'Pending to add' "+
				       "                   ELSE 'A' "+
				       "               END IPSTATUS "+
				       "          FROM ( "+
				       "               SELECT C.IPADDRESS IPASSIGN, 'C' AS STATUS "+
				       "                 FROM TB_USERIPADDRESSMAPPING C "+
				       "                WHERE C.USERCODE = ? "+
				       "               ) A "+
				       "          FULL OUTER JOIN "+
				       "               ( "+
				       "               SELECT DISTINCT(D.IPADDRESS) IPASSIGN, 'P' AS STATUS "+
				       "                 FROM TB_USERIPADDRESSMAPPING_MAKER D, TB_USER_CHECKERACTIVITY G "+
				       "                WHERE D.USERCODE = ? "+
				       "                  AND D.USERCODE = G.USERCODE "+
				       "                  AND (G.ACTIONSTATUS = 'P' OR IPDETAILSUPDATEED = 'Y') "+
				       "               ) B "+
				       "            ON A.IPASSIGN = B.IPASSIGN "+
				       "       ) F "+
				       "    ON E.IPADDRESS = F.IPASSIGN ";
		try{
			//System.out.println(query);
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, Object> ipAddressDetails = new HashMap<String, Object>();
				ipAddressDetails.put("IPADDRESS", resultSet.getString("IPADDRESS"));
				ipAddressDetails.put("SYSTEMNAME", resultSet.getString("SYSTEMNAME"));
				ipAddressDetails.put("IPSTATUS", resultSet.getString("IPSTATUS"));
				ipAddressDetails.put("OTHERUSERS", otherUserOnIPAddress(resultSet.getString("IPADDRESS")));
				allIPAddress.add(ipAddressDetails);
			}
		}catch(Exception e){
			log.error("Error while getting all IP Address for assignment : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allIPAddress;
	}
	
	private List<String> otherUserOnIPAddress(String ipAddress){
		List<String> otherUser = new ArrayList<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT C.USERDETAILS, C.USERCODE "+
					   "  FROM ( "+
					   "       SELECT "+
					   "              CASE "+
					   "                   WHEN NVL(A.USERSTATUS, 'R') IN ('C') AND NVL(B.USERSTATUS, 'R') IN ('P') THEN A.FIRSTNAME||' '||A.LASTNAME || '  [ ' || A.USERCODE || ' ]  ' "+
					   "                   WHEN NVL(A.USERSTATUS, 'R') IN ('C') AND NVL(B.USERSTATUS, 'R') IN ('R') THEN A.FIRSTNAME||' '||A.LASTNAME || '  [ ' || A.USERCODE || ' ]  ' "+
					   "                   WHEN NVL(A.USERSTATUS, 'R') IN ('R') AND NVL(B.USERSTATUS, 'R') IN ('P') THEN B.FIRSTNAME||' '||B.LASTNAME || '  [ ' || B.USERCODE || ' ]  ' "+
					   "                   ELSE '' "+
					   "               END USERDETAILS, "+
					   "              CASE "+
					   "                   WHEN NVL(A.USERSTATUS, 'R') IN ('C') AND NVL(B.USERSTATUS, 'R') IN ('P') THEN A.USERCODE "+
					   "                   WHEN NVL(A.USERSTATUS, 'R') IN ('C') AND NVL(B.USERSTATUS, 'R') IN ('R') THEN A.USERCODE "+
					   "                   WHEN NVL(A.USERSTATUS, 'R') IN ('R') AND NVL(B.USERSTATUS, 'R') IN ('P') THEN B.USERCODE "+
					   "           	       ELSE '' "+
					   "               END USERCODE "+
					   "         FROM "+
					   "              ( "+
					   "              SELECT USERCODE, FIRSTNAME, LASTNAME, 'C' AS USERSTATUS "+
					   "                FROM TB_USER "+
					   "              ) A "+
					   "         FULL OUTER JOIN "+
					   "              ( "+
					   "              SELECT USERCODE, FIRSTNAME, LASTNAME, 'P' AS USERSTATUS "+
					   "	            FROM TB_USER_MAKER "+
					   "              ) B "+
					   "           ON A.USERCODE = B.USERCODE "+
					   "       ) C "+
					   " WHERE C.USERCODE IN ( "+
					   "                     SELECT D.USERCODE FROM ( "+
					   "                                            SELECT USERCODE "+
					   "											  FROM TB_USERIPADDRESSMAPPING "+
					   "										     WHERE IPADDRESS = ? "+
					   "                                             UNION "+
					   "											SELECT USERCODE "+
					   "											  FROM TB_USERIPADDRESSMAPPING_MAKER "+
					   "                                             WHERE IPADDRESS = ? "+
					   "                                            ) D "+
					   "                       )";
		
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, ipAddress);
			preparedStatement.setString(2, ipAddress);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				otherUser.add(resultSet.getString("USERDETAILS"));
			}
		}catch(Exception e){
			log.error("Error while getting other user of ipaddress : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return otherUser;
	}
	
	@Override
	public String assignIPAddressToUser(String userCode, List<String> ipAddressList, String makerCode, String createdBy){
		boolean isInsert = true;
		String message = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = 'P'";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				isInsert = false;
				makerCode = resultSet.getString("MAKERCODE");
			}
			
			query = "DELETE FROM TB_USERIPADDRESSMAPPING_MAKER WHERE USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.executeUpdate();
			
			query = "INSERT INTO TB_USERIPADDRESSMAPPING_MAKER(USERCODE,IPADDRESS,UPDATEDBY,UPDATETIMESTAMP) "+
					"VALUES (?,?,?,SYSTIMESTAMP)";
			preparedStatement = connection.prepareStatement(query);
			for(String ipAddress : ipAddressList){
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, ipAddress);
				preparedStatement.setString(3, createdBy);
				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			
			if(isInsert){
				query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE,ISNEWUSER,IPDETAILSUPDATEED,IPDETAILSUPDATEBY, "+
						"       IPDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
						"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, "N");
				preparedStatement.setString(3, "Y");
				preparedStatement.setString(4, createdBy);
				preparedStatement.setString(5, "P");
				preparedStatement.setString(6, makerCode);
				preparedStatement.executeUpdate();
			}else{
				query = "UPDATE TB_USER_CHECKERACTIVITY "+
						"   SET IPDETAILSUPDATEED = ?, IPDETAILSUPDATEBY = ?, ROLEDETAILSUPDATETIME = SYSTIMESTAMP, "+
						"       UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, "Y");
				preparedStatement.setString(2, createdBy);
				preparedStatement.setString(3, makerCode);
				preparedStatement.executeUpdate();
			}
			if(ipAddressList.size() > 1)
				message = ipAddressList.size()+" IPAddresses have been assigned to "+userCode;
			else
				message = ipAddressList.size()+" IPAddress has been assigned to "+userCode;
		}catch(Exception e){
			message = "IPAddress assignment to "+userCode+" failed";
			log.error("Error while assigning IPAddress to user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return message;
	}
	
	@Override
	public Map<String, Map<String, Map<String, Object>>> getAllUserForIPAddressMapping(String ipAddress){
		Map<String, Map<String, Map<String, Object>>> finalResult = new HashMap<String, Map<String, Map<String, Object>>>();
		Map<String, Map<String, Object>> allUserAlreadyAssigned = new HashMap<String, Map<String, Object>>();
		Map<String, Map<String, Object>> allUserNotAssigned = new HashMap<String, Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = " SELECT A.*, CASE WHEN B.USERCODE IS NOT NULL THEN 'Y' ELSE 'N' END AS ISPRESENT "+
					   "   FROM ( "+
					   " 		SELECT C.USERCODE, C.FIRSTNAME, C.LASTNAME "+
					   "   		  FROM TB_USER C "+
					   "  		 UNION "+
					   " 		SELECT D.USERCODE, D.FIRSTNAME, D.LASTNAME "+
					   "   		  FROM TB_USER_MAKER D, TB_USER_CHECKERACTIVITY E "+
					   "  		 WHERE D.USERCODE = E.USERCODE "+
					   "    	   AND E.ACTIONSTATUS = 'P' "+
					   "        ) A "+
					   "   LEFT OUTER JOIN "+
					   "        ( "+
					   "  		SELECT C.USERCODE, C.IPADDRESS "+
					   "          FROM TB_USERIPADDRESSMAPPING C "+
					   "         WHERE C.IPADDRESS = ? "+
					   "         UNION "+
					   "		SELECT D.USERCODE, D.IPADDRESS "+
					   "		  FROM TB_USERIPADDRESSMAPPING_MAKER D "+
					   "		 WHERE D.IPADDRESS = ? "+
					   "        ) B "+
					   "     ON A.USERCODE = B.USERCODE";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, ipAddress);
			preparedStatement.setString(2, ipAddress);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, Object> userDetails = new HashMap<String, Object>();
				userDetails.put("USERCODE", resultSet.getString("USERCODE"));
				userDetails.put("FIRSTNAME", resultSet.getString("FIRSTNAME"));
				userDetails.put("LASTNAME", resultSet.getString("LASTNAME"));
				userDetails.put("OTHERROLES", userOtherIPAddress(resultSet.getString("USERCODE"), ipAddress));
				userDetails.put("STATUS", PendingOrChecked(resultSet.getString("USERCODE"), ipAddress));
				if(resultSet.getString("ISPRESENT").equals("Y")){
					allUserAlreadyAssigned.put(resultSet.getString("USERCODE"), userDetails);
				}else{
					allUserNotAssigned.put(resultSet.getString("USERCODE"), userDetails);
				}
			}
		}catch(Exception e){
			log.error("Error while getting all user from IPAddress mapping : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		finalResult.put("ALREADYASSIGNED", allUserAlreadyAssigned);
		finalResult.put("AVAILABLETOASSIGN", allUserNotAssigned);
		return finalResult;
	}
	
	
	public Map<String, String> assignUserIPAddress(String ipAddress, List<String> selectedUser, List<String> unSelectedUser, List<String> makerCodeList, String createdBy){
		int makerCodeIndex = 0;
		Map<String, String> result = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";
		try{
			for(String userCode : selectedUser){
				boolean insert = true;
				String makerCode = "";
				query = "SELECT MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = 'P'";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					insert = false;
					makerCode = resultSet.getString("MAKERCODE");
				}else{
					makerCode = makerCodeList.get(makerCodeIndex);
					makerCodeIndex++;
				}
				
				query = "INSERT INTO TB_USERIPADDRESSMAPPING_MAKER(USERCODE,IPADDRESS,UPDATEDBY,UPDATETIMESTAMP) "+
						"VALUES (?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, ipAddress);
				preparedStatement.setString(3, createdBy);
				preparedStatement.executeUpdate();
				
				if(insert){
					query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE,ISNEWUSER,IPDETAILSUPDATEED,IPDETAILSUPDATEBY, "+
							"       IPDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
							"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.setString(2, "N");
					preparedStatement.setString(3, "Y");
					preparedStatement.setString(4, createdBy);
					preparedStatement.setString(5, "P");
					preparedStatement.setString(6, makerCode);
					preparedStatement.executeUpdate();
				}else{
					query = "UPDATE TB_USER_CHECKERACTIVITY "+
							"   SET IPDETAILSUPDATEED = ?, IPDETAILSUPDATEBY = ?, IPDETAILSUPDATETIME = SYSTIMESTAMP, "+
							"       UPDATETIMESTAMP = SYSTIMESTAMP "+
							" WHERE MAKERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, "Y");
					preparedStatement.setString(2, createdBy);
					preparedStatement.setString(3, makerCode);
					preparedStatement.executeUpdate();
				}
			}
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			
			for(String userCode : unSelectedUser){
				boolean insert = true;
				String makerCode = "";
				query = "SELECT MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = 'P'";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					insert = false;
					makerCode = resultSet.getString("MAKERCODE");
				}else{
					makerCode = makerCodeList.get(makerCodeIndex);
					makerCodeIndex++;
				}
				
				query = "DELETE FROM TB_USERIPADDRESSMAPPING_MAKER WHERE USERCODE = ? AND IPADDRESS = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, ipAddress);
				preparedStatement.executeUpdate();
				
				if(insert){
					query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE,ISNEWUSER,IPDETAILSUPDATEED,IPDETAILSUPDATEBY, "+
							"       IPDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
							"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, userCode);
					preparedStatement.setString(2, "N");
					preparedStatement.setString(3, "Y");
					preparedStatement.setString(4, createdBy);
					preparedStatement.setString(5, "P");
					preparedStatement.setString(6, makerCode);
					preparedStatement.executeUpdate();
				}else{
					query = "UPDATE TB_USER_CHECKERACTIVITY "+
							"   SET IPDETAILSUPDATEED = ?, IPDETAILSUPDATEBY = ?, IPDETAILSUPDATETIME = SYSTIMESTAMP, "+
							"       UPDATETIMESTAMP = SYSTIMESTAMP "+
							" WHERE MAKERCODE = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, "Y");
					preparedStatement.setString(2, createdBy);
					preparedStatement.setString(3, makerCode);
					preparedStatement.executeUpdate();
				}
			}
			result.put("STATUS", "1");
			result.put("MESSAGE", "Successfully assigned");
		}catch(Exception e){
			result.put("STATUS", "0");
			result.put("MESSAGE", "Failed to assign");
			log.error("Error while assigning ipaddress to user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	@Override
	public List<Map<String, String>> getAllGroupForModuleMapping(){
		List<Map<String, String>> allGroups = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT ROLEID, ROLENAME FROM TB_ROLE ";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> groupMap = new HashMap<String, String>();
				groupMap.put("DISPLAY", resultSet.getString("ROLEID"));
				groupMap.put("VALUE", resultSet.getString("ROLENAME"));
				allGroups.add(groupMap);
			}
		}catch(Exception e){
			log.error("Error while getting groups for module mapping : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allGroups;
	}
	
	@Override
	public List<Map<String, String>> getAllUserForModuleMapping(){
		List<Map<String, String>> allUsers = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT USERCODE, LASTNAME FROM TB_USER ";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> groupMap = new HashMap<String, String>();
				groupMap.put("DISPLAY", resultSet.getString("LASTNAME"));
				groupMap.put("VALUE", resultSet.getString("USERCODE"));
				allUsers.add(groupMap);
			}
		}catch(Exception e){
			log.error("Error while getting users for module mapping : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allUsers;
	}
	
	public List<Map<String, String>> getGroupCode(String userCode){
		List<Map<String, String>> dataList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT ROLEID FROM TB_USERROLEMAPPING  "+
					 " WHERE 1=1 ";
		if(userCode != null && userCode.length() > 0)
			//sql = sql + " AND USERCODE = '"+userCode+"' ";
			sql = sql + " AND USERCODE = ? ";
		
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			if(userCode != null && userCode.length() > 0)
				preparedStatement.setString(1, userCode);
			
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("GROUPCODE", resultSet.getString("ROLEID"));
			dataList.add(dataMap);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	@Override
	public List<Map<String, String>> getAllModulesForMapping(String groupCode){
		List<Map<String, String>> allModules = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT MODULECODE FROM TB_ROLEMODULEMAPPING WHERE ROLEID = ? ";

		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, groupCode.replaceFirst("ROLE_", ""));
			//System.out.println(groupCode.replaceFirst("ROLE_", ""));
			resultSet = preparedStatement.executeQuery();
			//System.out.println(query);
			while (resultSet.next()) {
				Map<String, String> module = new HashMap<String, String>();
				module.put("MODULECODE", resultSet.getString("MODULECODE"));
				allModules.add(module);
			}
		}catch(Exception e){
			log.error("Error while getting all Modules for assignment : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allModules;
	}
	
	public List<Map<String, String>> getAllEmpCodes(){
		List<Map<String, String>> allEmpCodes = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = " SELECT DISTINCT EMPLOYEECODE FROM TB_USER_MAKER "+
						 "	UNION "+ 
						 " SELECT DISTINCT EMPLOYEECODE FROM TB_USER";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> empCode = new HashMap<String, String>();
				empCode.put("EMPCODE", resultSet.getString("EMPLOYEECODE"));
				
				allEmpCodes.add(empCode);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return allEmpCodes;
	}

	@SuppressWarnings("resource")
	public String createUserWithRole(String userCode, String userPass, String firstName, String lastName,
			String emailId, String mobileNo, String designation, String employeeCode, String departmentCode,
			String accessStartTime, String accessEndTime, String passwordExpiry, String accountExpiryDate, 
			String chatEnabled, String BRANCHCODE, String ISETLUSER, String groupCode, String createdBy, String makerCode){
		/*System.out.println("DAO ---- userCode="+userCode+"&userPass="+userPass+"&firstName="+firstName+"&lastName="+lastName+
				   "&emailId="+emailId+"&mobileNo="+mobileNo+"&designation="+designation+
				   "&employeeCode="+employeeCode+"&branchCode="+BRANCHCODE+"&departmentCode="+departmentCode+
				   "&groupCode="+groupCode);*/
		List<Map<String, String>> mainMap = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String result = "";
		int count = 0;
		String query = ""; 
		boolean isNewEntry = true;
		
		try{
			query = "SELECT COUNT(1) AS EXISTINGCOUNT "+
			        "  FROM ( "+
				    "SELECT USERCODE FROM TB_USER "+
				    " WHERE USERCODE = ? "+
					"  UNION ALL "+
				    "SELECT USERCODE FROM TB_USER_MAKER "+
				    " WHERE USERCODE = ? "+
				    "UNION ALL "+
				    "SELECT USERCODE FROM TB_USER_CHECKERACTIVITY "+
				    " WHERE USERCODE = ? "+
				    " ) A "; 

			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, userCode);
			resultSet = preparedStatement.executeQuery();

			if(resultSet.next()){
				count = resultSet.getInt("EXISTINGCOUNT");
			}

			if(count == 0){
				query =  " INSERT INTO TB_USER_MAKER( "+
						 "		  USERCODE, USERPASS, FIRSTNAME, LASTNAME, EMAILID, MOBILENO, ACCOUNTDELETED, "+
				 		 "        DESIGNATION, ACCOUNTENABLE, ACCOUNTEXPIRED, CREDENTIALEXPIRED, ACCOUNTLOCKED, CHATENABLE, "+
				 		 "        ACCESSSTARTTIME, ACCESSENDTIME, ACCESSPOINTS, CREATIONTIME, ACCOUNTEXIPYDATE, MAKERCODE, "+
				 		 "		  BRANCHCODE, DEPARTMENTCODE, EMPLOYEECODE, ISETLUSER, ROLECODE, MAKERID, UPDATETIMESTAMP) "+
				 		 " VALUES ( "+
				 		 "		  ?, ?, ?, ?, ?, ?, 'N', "+
				 		 "		  ?, 'Y', 'N', ?, 'N', ?, "+
				 		 "		  ?, ?, '', SYSTIMESTAMP, FUN_CHARTODATE('"+accountExpiryDate+"'), ?, "+
				 		 "		  ?, ?, ?, ?, ?, ?, SYSTIMESTAMP)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, userPass);
			preparedStatement.setString(3, firstName);
			preparedStatement.setString(4, lastName);
			preparedStatement.setString(5, emailId);
			preparedStatement.setString(6, mobileNo);
			preparedStatement.setString(7, designation);
			preparedStatement.setString(8, passwordExpiry);
			preparedStatement.setString(9, chatEnabled);
			preparedStatement.setString(10, accessStartTime+":00");
			preparedStatement.setString(11, accessEndTime+":59");
			preparedStatement.setString(12, makerCode);
			preparedStatement.setString(13, BRANCHCODE);
			preparedStatement.setString(14, departmentCode);
			preparedStatement.setString(15, employeeCode);
			preparedStatement.setString(16, ISETLUSER);
			preparedStatement.setString(17, groupCode);
			preparedStatement.setString(18, createdBy);
			preparedStatement.executeUpdate();
			
			query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE, ISNEWUSER, USERDETAILSUPDATEED, "+
					"       USERDETAILSUPDATEDBY, USERDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE, "+
					"		USERSTATUSDETAILSUPDATED, USERSTATUSDETAILSUPDATEDBY, USERSTATUSDETAILSUPDATEDTIME) "+
					"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?,?,?,SYSTIMESTAMP)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, "Y");
			preparedStatement.setString(3, "Y");
			preparedStatement.setString(4, createdBy);
			preparedStatement.setString(5, "P");
			preparedStatement.setString(6, makerCode);
			preparedStatement.setString(7, "Y");
			preparedStatement.setString(8, createdBy);
			preparedStatement.executeUpdate();
			
			//Role Assignment
			
			query = "SELECT MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = 'P'";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				makerCode = resultSet.getString("MAKERCODE");
				isNewEntry = false;
			}
			
			query = "DELETE FROM TB_USERROLEMAPPING_MAKER WHERE USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.executeUpdate();
			
			query = "DELETE FROM TB_USERMODULEMAPPING_MAKER WHERE USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.executeUpdate();
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			connection.setAutoCommit(false);
			
			query = "INSERT INTO TB_USERROLEMAPPING_MAKER(ROLEID, USERCODE, LOGINPRIORITY, UPDATEDBY, UPDATETIMESTAMP) "+
					"VALUES (?,?,(SELECT PRIORITY FROM TB_ROLE WHERE ROLEID = ?),?,SYSTIMESTAMP)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, groupCode);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, groupCode);
			preparedStatement.setString(4, createdBy);
			
			preparedStatement.executeUpdate();
			
			query = "INSERT INTO TB_USERMODULEMAPPING_MAKER(USERCODE,ROLEID,MODULECODE,UPDATEDBY,UPDATETIMESTAMP) "+
					"VALUES (?,?,?,?,SYSTIMESTAMP)";
			
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, groupCode);
			preparedStatement.setString(3, "");
			preparedStatement.setString(4, createdBy);
			preparedStatement.executeUpdate();
			connection.commit();
						
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			
			if(isNewEntry){
				query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE,ISNEWUSER,ROLEDETAILSUPDATED,ROLEDETAILSUPDATEDBY, "+
						"       ROLEDETAILSUPDATETIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
						"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, "N");
				preparedStatement.setString(3, "Y");
				preparedStatement.setString(4, createdBy);
				preparedStatement.setString(5, "P");
				preparedStatement.setString(6, makerCode);
				preparedStatement.executeUpdate();
			}else{
				query = "UPDATE TB_USER_CHECKERACTIVITY "+
						"   SET ROLEDETAILSUPDATED = ?, ROLEDETAILSUPDATEDBY = ?, ROLEDETAILSUPDATETIME = SYSTIMESTAMP, "+
						"       UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE MAKERCODE = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, "Y");
				preparedStatement.setString(2, createdBy);
				preparedStatement.setString(3, makerCode);
				preparedStatement.executeUpdate();
			}
			
			query =  "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
					 "       A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, "+
					 "  CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDELETED, "+
					 "  CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTENABLE, "+
					 "  CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTEXPIRED, "+
					 "  CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTDORMANT, "+
					 "  CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END ACCOUNTLOCKED, "+
					 "  CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CREDENTIALEXPIRED, "+
					 "  CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END CHATENABLE, "+
					 "  CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' ELSE 'Rejected' END USERSTATUS, "+
					 "       A.ACCESSSTARTTIME ACCESSSTARTTIME, A.ACCESSENDTIME ACCESSENDTIME, "+
					 "       A.CREATIONTIME CREATIONTIME, CASE NVL(A.ACCOUNTEXIPYDATE, SYSDATE) WHEN SYSDATE THEN 'Never' ELSE TO_CHAR(A.ACCOUNTEXIPYDATE, 'DD/MM/YYYY') END ACCOUNTEXIPYDATE, A.MAKERCODE, "+
					 "       A.DEPARTMENTCODE DEPARTMENTCODE, A.EMPLOYEECODE EMPLOYEECODE, C.ROLEID ROLEID, A.MAKERID MAKERID "+
					 "  FROM TB_USER_MAKER A, TB_USER_CHECKERACTIVITY B, TB_USERROLEMAPPING_MAKER C "+
	  				 " WHERE A.USERCODE = B.USERCODE "+
					 "   AND A.MAKERCODE = B.MAKERCODE "+
					 "   AND A.USERCODE = C.USERCODE "+
	  				 "   AND A.USERCODE = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERNAME", resultSet.getString("FIRSTNAME")+" "+resultSet.getString("LASTNAME"));
				dataMap.put("EMAILID", resultSet.getString("EMAILID"));
				dataMap.put("MOBILENO", resultSet.getString("MOBILENO"));
				dataMap.put("DESIGNATION", resultSet.getString("DESIGNATION"));
				dataMap.put("STARTTIME", resultSet.getString("ACCESSSTARTTIME"));
				dataMap.put("ENDTIME", resultSet.getString("ACCESSENDTIME"));
				dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
				dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
				dataMap.put("PASSWORDEXPIRY", resultSet.getString("CREDENTIALEXPIRED"));
				dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
				dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
				dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
				dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
				dataMap.put("ACCOUNTEXIPYDATE", resultSet.getString("ACCOUNTEXIPYDATE"));
				dataMap.put("CREATIONTIME", resultSet.getString("CREATIONTIME"));
				dataMap.put("TABLE", "_USER_MAKER");
				dataMap.put("CHECKER", resultSet.getString("USERSTATUS"));
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				dataMap.put("DEPARTMENTCODE", resultSet.getString("DEPARTMENTCODE"));
				dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
				dataMap.put("GROUPCODE", resultSet.getString("ROLEID"));
				dataMap.put("MAKERID", resultSet.getString("MAKERID"));
				mainMap.add(dataMap);	
				result = "User created and role assigned successfully";
			}
			}
			else{
				result = "User already exists";
				//return searchUser(userCode, firstName, lastName, emailId, mobileNo);
				
			}
		}catch(Exception e){
			log.error("Error while creating user : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		System.out.println(result);
		return result;
	}
	
	/*public List<Map<String, String>> getAllUserFromEditForStatusUpdate(String loggedInUsercode){
		List<Map<String, String>> mainList = new ArrayList<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT A.USERCODE USERCODE, '_USER' AS USETABLE, A.MAKERCODE MAKERCODE, A.EMPLOYEECODE EMPLOYEECODE, "+
				   "	   A.FIRSTNAME || ' ' || A.LASTNAME || '  [ ' || A.USERCODE || ' ] (Checked)' AS USERSTATUS "+
			       "  FROM TB_USER A "+
			       " WHERE A.USERCODE <> ? "+
			       " UNION ALL "+
			       "SELECT B.USERCODE, '_USER_MAKER' AS USETABLE, B.MAKERCODE MAKERCODE, B.EMPLOYEECODE EMPLOYEECODE, "+
			       "  CASE NVL(C.ACTIONSTATUS , 'P') WHEN 'P' THEN B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Pending)' WHEN 'R' THEN B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Rejected)' ELSE B.FIRSTNAME || ' ' || B.LASTNAME || '  [ ' || B.USERCODE || ' ] (Approved)' END AS USERSTATUS "+
			       "  FROM TB_USER_MAKER B, TB_USER_CHECKERACTIVITY C "+
			       " WHERE B.USERCODE = C.USERCODE "+
			       "   AND B.MAKERCODE = C.MAKERCODE "+
			       "   AND C.ACTIONSTATUS <> ? "+
			       "   AND C.USERSTATUSDETAILSUPDATED = ? "+
			       "   AND B.USERCODE <> ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, loggedInUsercode);
			preparedStatement.setString(2, "A");
			preparedStatement.setString(3, "Y");
			preparedStatement.setString(4, loggedInUsercode);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("DISPLAY", resultSet.getString("USERSTATUS"));
				dataMap.put("VALUE", resultSet.getString("USERCODE")+","+resultSet.getString("USETABLE")+","+resultSet.getString("MAKERCODE"));
				dataMap.put("EMPLOYEECODE", resultSet.getString("EMPLOYEECODE"));
				dataMap.put("EMPDETAILS", resultSet.getString("EMPLOYEECODE")+","+resultSet.getString("USETABLE")+","+resultSet.getString("MAKERCODE"));
				mainList.add(dataMap);
			}
		}catch(Exception e){
			log.error("Error while getting users from edit : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainList;
	}*/
	
	//for getting all user status
		public Map<String, String> getAllStatusOfUser(Map<String,String>inputData){
			Map<String, String> dataMap = new HashMap<String, String>();
			Connection connection = connectionUtil.getConnection();
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			String query = "";
			try{
				if(inputData.get("TABLENAME").contains("MAKER")){
					query =  "SELECT A.USERCODE USERCODE,"+
							 "       CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTENABLE, "+
							 "       CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTEXPIRED, "+
							 "       CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTDORMANT, "+
							 "       CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CREDENTIALEXPIRED, "+
							 "       CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTLOCKED, "+
							 "       CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTDELETED, "+
							 "       CASE NVL(A.CHATENABLE, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CHATENABLE, "+
							 "       CASE NVL(B.ACTIONSTATUS, 'P') WHEN 'P' THEN 'Pending' WHEN 'R' THEN 'Rejected' ELSE 'Approved' END USERSTATUS "+
							 "  FROM TB_USER_MAKER A "+
							 "  LEFT OUTER JOIN TB_USER_CHECKERACTIVITY B ON A.USERCODE = B.USERCODE AND A.MAKERCODE = B.MAKERCODE "+
							 "	LEFT OUTER JOIN TB_USERROLEMAPPING_MAKER C ON A.USERCODE = C.USERCODE "+
							 " WHERE B.MAKERCODE = ? ";
					
					if(!("ALL").equals(inputData.get("USERCODE"))){
						query = query + " AND A.USERCODE = ? ";
					}
					if(!("ALL").equals(inputData.get("EMPLOYEECODE"))){
						query = query + "   AND A.EMPLOYEECODE  = ? ";
					}
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, inputData.get("MAKERCODE"));
					int count = 2;		
					if(!("ALL").equals(inputData.get("USERCODE"))){
						preparedStatement.setString(count, inputData.get("USERCODE"));
						count++;
					}
					if(!("ALL").equals(inputData.get("EMPLOYEECODE"))){
						preparedStatement.setString(count, inputData.get("EMPLOYEECODE"));
						
					}
					
					resultSet = preparedStatement.executeQuery();
					if(resultSet.next()){
						dataMap.put("USERCODE", resultSet.getString("USERCODE"));
						dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
						dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
						dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
						dataMap.put("CREDENTIALEXPIRED", resultSet.getString("CREDENTIALEXPIRED"));
						dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
						dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
						dataMap.put("CHATENABLE", resultSet.getString("CHATENABLE"));
						dataMap.put("USERSTATUS", resultSet.getString("USERSTATUS"));
					//	System.out.println("result 1 dataMap  ="+dataMap);
					}
				}else{
					//System.out.println("in else");
					query = "SELECT A.USERCODE USERCODE, A.FIRSTNAME FIRSTNAME, A.LASTNAME LASTNAME, "+
							"       A.EMAILID EMAILID, A.MOBILENO MOBILENO, A.DESIGNATION DESIGNATION, "+
							"       CASE NVL(A.ACCOUNTENABLE, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTENABLE, "+
							"       CASE NVL(A.ACCOUNTEXPIRED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTEXPIRED, "+
							"       CASE NVL(A.ACCOUNTDORMANT, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTDORMANT, "+
							"       CASE NVL(A.CREDENTIALEXPIRED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END CREDENTIALEXPIRED, "+
							"       CASE NVL(A.ACCOUNTLOCKED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTLOCKED, "+
							"       CASE NVL(A.ACCOUNTDELETED, 'N') WHEN 'Y' THEN 'Y' ELSE 'N' END ACCOUNTDELETED "+
							"  FROM TB_USER A "+
							"  LEFT OUTER JOIN TB_USER_CHECKERACTIVITY B ON A.USERCODE = B.USERCODE AND A.MAKERCODE = B.MAKERCODE "+
							"  LEFT OUTER JOIN TB_USERROLEMAPPING C ON A.USERCODE = C.USERCODE "+
							" WHERE B.MAKERCODE = ? ";
							
					if(!("ALL").equals(inputData.get("USERCODE"))){
						query = query + " AND A.USERCODE = ? ";
					}
					if(!("ALL").equals(inputData.get("EMPLOYEECODE"))){
						query = query + "   AND A.EMPLOYEECODE  = ? ";
					}
					/*if(!("").equals(employeeName)){
						query = query + "   AND UPPER(D.EMPNAME) LIKE UPPER(?) ";
					}*/
					
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, inputData.get("MAKERCODE"));
					int count = 2;		
					if(!("ALL").equals(inputData.get("USERCODE"))){
						preparedStatement.setString(count, inputData.get("USERCODE"));
						count++;
					}
					if(!("ALL").equals(inputData.get("EMPLOYEECODE"))){
						preparedStatement.setString(count, inputData.get("EMPLOYEECODE"));
				    }
					/*System.out.println(query);
					System.out.println(inputData);*/
					resultSet = preparedStatement.executeQuery();
					if(resultSet.next()){
						dataMap.put("USERCODE", resultSet.getString("USERCODE"));
						dataMap.put("ACCOUNTENABLE", resultSet.getString("ACCOUNTENABLE"));
						dataMap.put("ACCOUNTEXPIRED", resultSet.getString("ACCOUNTEXPIRED"));
						dataMap.put("ACCOUNTDORMANT", resultSet.getString("ACCOUNTDORMANT"));
						dataMap.put("CREDENTIALEXPIRED", resultSet.getString("CREDENTIALEXPIRED"));
						dataMap.put("ACCOUNTLOCKED", resultSet.getString("ACCOUNTLOCKED"));
						dataMap.put("ACCOUNTDELETED", resultSet.getString("ACCOUNTDELETED"));
						dataMap.put("USERSTATUS", "Approved");
						//System.out.println("result 2 dataMap= "+dataMap);
					}
				}
				
			}catch(Exception e){
				log.error("Error while getting users from edit : "+e.getMessage());
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
			return dataMap;
		}
		
	/*public String updateUserStatus(String userCode, String userStatus, String accountEnabled, String accountExpired,
			String accountDormant, String accountLocked, String accountDeleted, String makerCode, String updatedBy){
		System.out.println("DAO --- userCode="+userCode+"&userStatus="+userStatus+"&accountEnabled="+accountEnabled+
				"&accountExpired="+accountExpired+"&accountLocked="+accountLocked+"&accountDeleted="+accountDeleted+
				"makerCode="+makerCode+"updatedBy="+updatedBy);
		String message = "";
		boolean isInsert = true;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT USERCODE, MAKERCODE FROM TB_USER_CHECKERACTIVITY WHERE USERCODE = ? AND ACTIONSTATUS = ?";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, userCode);
			preparedStatement.setString(2, "P");
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				makerCode = resultSet.getString("MAKERCODE");
				isInsert = false;
				System.out.println("Status Maker Code = "+makerCode);
			}
			
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connection = connectionUtil.getConnection();
			if(isInsert){
				System.out.println("IN insert");
				String firstname = "";
				String lastname = "";
				query = "SELECT FIRSTNAME, LASTNAME FROM TB_USER_MAKER WHERE USERCODE = ? AND MAKERCOE";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				if (resultSet.next()) {
					firstname = resultSet.getString("FIRSTNAME");
					lastname = resultSet.getString("LASTNAME");
				}
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
				connection = connectionUtil.getConnection();
				query = "INSERT INTO TB_USER_MAKER( "+
						"		USERCODE, FIRSTNAME, LASTNAME, ACCOUNTENABLE, ACCOUNTEXPIRED, ACCOUNTLOCKED, ACCOUNTDELETED, "+
						"		CREATIONTIME, MAKERCODE, MAKERID, ACCOUNTDORMANT, UPDATETIMESTAMP) "+
					 	"VALUES (?, ?, ?, ?, ?, ?, ?, "+
						"		SYSTIMESTAMP, ?, ?, ?, SYSTIMESTAMP)";
				//System.out.println(makerCode);
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, firstname);
				preparedStatement.setString(3, lastname);
				preparedStatement.setString(4, accountEnabled);
				preparedStatement.setString(5, accountExpired);
				preparedStatement.setString(6, accountLocked);
				preparedStatement.setString(7, accountDeleted);
				preparedStatement.setString(8, makerCode);
				preparedStatement.setString(9, updatedBy);
				preparedStatement.setString(10, accountDormant);
				preparedStatement.executeUpdate();
				//System.out.println("Inserted in maker");
				query = "INSERT INTO TB_USER_CHECKERACTIVITY(USERCODE, ISNEWUSER, USERSTATUSDETAILSUPDATED, USERSTATUSDETAILSUPDATEDBY, "+
						"		USERSTATUSDETAILSUPDATEDTIME, ACTIONSTATUS, UPDATETIMESTAMP, MAKERCODE) "+
						"VALUES (?,?,?,?,SYSTIMESTAMP,?,SYSTIMESTAMP,?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, userCode);
				preparedStatement.setString(2, "N");
				preparedStatement.setString(3, "Y");
				preparedStatement.setString(4, updatedBy);
				preparedStatement.setString(5, "P");
				preparedStatement.setString(6, makerCode);
				preparedStatement.executeUpdate();
				
				message = "New user status details update request has been raised for "+userCode;
			}else{
				System.out.println("In update");
				query = "UPDATE TB_USER_MAKER SET "+
						"		ACCOUNTENABLE = ?, ACCOUNTEXPIRED = ?, ACCOUNTDELETED = ?, ACCOUNTLOCKED = ?, "+
						"		MAKERID = ?, STATUSUPDATETIMESTAMP =  SYSTIMESTAMP, ACCOUNTDORMANT = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						" WHERE MAKERCODE = ?";
				
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, accountEnabled);
				preparedStatement.setString(2, accountExpired);
				preparedStatement.setString(3, accountDeleted);
				preparedStatement.setString(4, accountLocked);
				preparedStatement.setString(5, updatedBy);
				preparedStatement.setString(6, makerCode);
				preparedStatement.setString(7, accountDormant);
				preparedStatement.executeUpdate();
				
		 		query = "UPDATE TB_USER_CHECKERACTIVITY SET USERSTATUSDETAILSUPDATED = 'Y', USERSTATUSDETAILSUPDATEDBY = ?, USERSTATUSDETAILSUPDATEDTIME = SYSTIMESTAMP, "+
						"       ACTIONSTATUS = 'P', UPDATETIMESTAMP = SYSTIMESTAMP "+
		 				" WHERE MAKERCODE = ?";
		 		preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, updatedBy);
				preparedStatement.setString(2, makerCode);
				preparedStatement.executeUpdate();
				//System.out.println(query);
				
				message = "User status details update request has been raised for "+userCode;
			}
			
		}catch(Exception e){
			message = "Failed to raise user status update request";
			log.error("Error while saving user status update : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}		
		//System.out.println("Message = "+message);
		return message;
	}*/
		
}