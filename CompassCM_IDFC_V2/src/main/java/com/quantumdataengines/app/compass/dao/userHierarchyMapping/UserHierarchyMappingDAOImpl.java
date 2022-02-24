package com.quantumdataengines.app.compass.dao.userHierarchyMapping;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class UserHierarchyMappingDAOImpl implements UserHierarchyMappingDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Map<String, String> getUserDetails(String userRole){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String sql = "SELECT A.USERCODE OPTIONNAME, A.FIRSTNAME ||' '|| A.LASTNAME OPTIONVALUE "+
					 "  FROM TB_USER A "+
					 " INNER JOIN TB_USERROLEMAPPING B "+
					 "	  ON A.USERCODE = B.USERCODE "+
					 " WHERE B.ROLEID = ? " ;
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userRole);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				dataMap.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	public List<Map<String, String>> searchUserHierarchyMapping(String mappingType, String mappingAMLUsersCode, 
															   String mappingAMLOUsersCode, String mappingMLROUsersCode){
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql= "";

			if(("AMLUserAMLO").equals(mappingType)){
				sql = "SELECT A.USERCODE AMLUSERCODE, B.AMLOCODE AMLOCODE, ISENABLED "+
					  "  FROM TB_USERROLEMAPPING A "+
					  "  LEFT OUTER JOIN "+schemaName+"TB_AMLUSER_AMLO_MAPPING B "+
					  "    ON A.USERCODE = B.AMLUSERCODE "+
					  "   AND (B.AMLOCODE = CASE WHEN ? = 'ALL' THEN B.AMLOCODE ELSE ? END) "+
					  " WHERE A.ROLEID = 'AMLUSER' "+
			          "   AND (A.USERCODE = CASE WHEN ? = 'ALL' THEN A.USERCODE ELSE ? END) "+
					  " ORDER BY ISENABLED DESC, A.USERCODE ASC ";
				
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, mappingAMLOUsersCode);
				preparedStatement.setString(2, mappingAMLOUsersCode);	
				preparedStatement.setString(3, mappingAMLUsersCode);
				preparedStatement.setString(4, mappingAMLUsersCode);
				resultSet = preparedStatement.executeQuery();
				
				while(resultSet.next()){
					Map<String, String> dataMap = new LinkedHashMap<String, String>();
						dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
						dataMap.put("AMLUSERCODE", resultSet.getString("AMLUSERCODE"));
						dataMap.put("AMLOCODE", resultSet.getString("AMLOCODE"));
						
						mainList.add(dataMap);
				}
			
			}else{
				sql = "SELECT A.USERCODE AMLOCODE, B.MLROCODE MLROCODE, ISENABLED "+
					  "	 FROM TB_USERROLEMAPPING A "+
					  "	 LEFT OUTER JOIN "+schemaName+"TB_AMLO_MLRO_MAPPING B "+ 
					  "    ON A.USERCODE = B.AMLOCODE "+
					  "   AND (B.MLROCODE = CASE WHEN ? = 'ALL' THEN B.MLROCODE ELSE ? END) "+
					  " WHERE A.ROLEID = 'AMLO' "+
			          "   AND (A.USERCODE = CASE WHEN ? = 'ALL' THEN A.USERCODE ELSE ? END) "+
			          " ORDER BY ISENABLED DESC, A.USERCODE ASC ";
				
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, mappingMLROUsersCode);
				preparedStatement.setString(2, mappingMLROUsersCode);
				preparedStatement.setString(3, mappingAMLOUsersCode);
				preparedStatement.setString(4, mappingAMLOUsersCode);	
				resultSet = preparedStatement.executeQuery();
				
				
				while(resultSet.next()){
					Map<String, String> dataMap = new LinkedHashMap<String, String>();
						dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
						dataMap.put("AMLOCODE", resultSet.getString("AMLOCODE"));
						dataMap.put("MLROCODE", resultSet.getString("MLROCODE"));
						
						mainList.add(dataMap);
				}			
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		//System.out.println(mainList);
		return mainList;
	}
		
	public String saveMapping(String fullData, String mappingType, String currentUser, String currentRole, String ipAddress){
		List<List<String>> mainList = new Vector<List<String>>();
		
		String[] arrStr = CommonUtil.splitString(fullData, ";");
		for(String strData : arrStr){
			String[] arrData1 = CommonUtil.splitString(strData, ",");
			if(arrData1.length == 3){
				List<String> dataList = new Vector<String>();
				for(String strData1 : arrData1)
					dataList.add(strData1);
				mainList.add(dataList);
				//System.out.println("mainList="+mainList);
			}
		}
		String result = "";
		String sql = "";
		String sql1 = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		
		try{
			if(("AMLUserAMLO").equals(mappingType)){
				sql1 = "DELETE FROM "+schemaName+"TB_AMLUSER_AMLO_MAPPING A "+
				      " WHERE A.AMLUSERCODE = ? ";
				preparedStatement1 = connection.prepareStatement(sql1);
				
				sql = " INSERT INTO "+schemaName+"TB_AMLUSER_AMLO_MAPPING ( "+
				      "        AMLUSERCODE, AMLOCODE, ISENABLED, UPDATEDBY,   "+
					  "        UPDATEDBYUSERROLE, IPADDRESS, UPDATETIMESTAMP ) "+
				      " VALUES(?, ?, ?, ?, "+
					  "       ?, ?, SYSTIMESTAMP ) ";
				preparedStatement= connection.prepareStatement(sql);
				for(List<String> list : mainList){
					preparedStatement1.setString(1, list.get(1));
					
					preparedStatement.setString(1, list.get(1));
					preparedStatement.setString(2, list.get(2));
					preparedStatement.setString(3, list.get(0));
					preparedStatement.setString(4, currentUser);
					preparedStatement.setString(5, currentRole);
					preparedStatement.setString(6, ipAddress);
					preparedStatement1.addBatch();
					preparedStatement.addBatch();
				}
				preparedStatement1.executeBatch();
				preparedStatement.executeBatch();
				result = "User hierarchy mapped successfully";
			}else{
				sql1 = "DELETE FROM "+schemaName+"TB_AMLO_MLRO_MAPPING"+
			           " WHERE AMLOCODE = ? ";
				preparedStatement1 = connection.prepareStatement(sql1);
				
				sql = "INSERT INTO "+schemaName+"TB_AMLO_MLRO_MAPPING ( "+
					  "       AMLOCODE, MLROCODE, ISENABLED, UPDATEDBY, "+
					  "		  UPDATEDBYUSERROLE, IPADDRESS, UPDATETIMESTAMP )"+
					  " VALUES(?, ?, ?, ?, "+
					  "       ?, ?, SYSTIMESTAMP ) ";
				preparedStatement= connection.prepareStatement(sql);
				for(List<String> list : mainList){
					preparedStatement1.setString(1, list.get(1));

					preparedStatement.setString(1, list.get(1));
					preparedStatement.setString(2, list.get(2));
					preparedStatement.setString(3, list.get(0));
					preparedStatement.setString(4, currentUser);
					preparedStatement.setString(5, currentRole);
					preparedStatement.setString(6, ipAddress);
					preparedStatement1.addBatch();
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				result = "User hierarchy mapped successfully";
			}
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while mapping.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
		
	public Map<String, String> getUsersList(String userRole, String column){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String sql = "SELECT DISTINCT "+column+" COL"+
					 "  FROM "+schemaName+"TB_USER_REPORTING_MAPPING ";

		/*
		String sql = "SELECT DISTINCT A.USERCODE COL "+
				     "  FROM QDE2.TB_USER A, QDE2.TB_USERROLEMAPPING B "+
				     " WHERE A.USERCODE = B.USERCODE "+
				     "   AND B.ROLEID IN ('AMLUSER','AMLUSERL1','AMLUSERL2','AMLUSERL3','AMLO','MLRO','MLROL1','MLROL2') ";
		*/
		
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				dataMap.put(resultSet.getString("COL"), resultSet.getString("COL"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	public List<Map<String, String>> searchReportingUsersMapping(String userCodeField, String reportingUserCodeField, String reviewersCodeField, String statusField){
	List<Map<String, String>> mainList = new Vector<Map<String,String>>();
	Connection connection = connectionUtil.getConnection();
	PreparedStatement preparedStatement = null;
	ResultSet resultSet = null;
	try{
	String sql= "";
	int count = 1;
	
	
	sql =  	" INSERT INTO "+schemaName+"TB_USER_REPORTING_MAPPING (USERCODE, REPORTINGUSERCODE, REVIEWERSCODE, ISENABLED) "+
			" SELECT DISTINCT A.USERCODE, A.USERCODE, A.USERCODE, 'N' ISENABLED "+
			"   FROM TB_USER A, TB_USERROLEMAPPING B "+
            "  WHERE A.USERCODE = B.USERCODE "+
            "    AND B.ROLEID IN ('AMLUSER','AMLUSERL1','AMLUSERL2','AMLUSERL3','AMLO','MLRO','MLROL1','MLROL2') "+
            "    and A.USERCODE NOT IN (SELECT C.USERCODE FROM "+schemaName+"TB_USER_REPORTING_MAPPING C ) ";
	/*
	sql =  	" INSERT INTO "+schemaName+"TB_USER_REPORTING_MAPPING (USERCODE, REPORTINGUSERCODE, REVIEWERSCODE, ISENABLED) "+
			" SELECT DISTINCT A.USERCODE, A.USERCODE, A.USERCODE, 'N' ISENABLED "+
			"   FROM QDE2.TB_USER A, QDE2.TB_USERROLEMAPPING B "+
            "  WHERE A.USERCODE = B.USERCODE "+
            "    AND B.ROLEID IN ('AMLUSER','AMLUSERL1','AMLUSERL2','AMLUSERL3','AMLO','MLROL1','MLROL2') "+
            "    and A.USERCODE NOT IN (SELECT C.USERCODE FROM "+schemaName+"TB_USER_REPORTING_MAPPING C ) ";	
	*/
	preparedStatement = connection.prepareStatement(sql);
	preparedStatement.executeUpdate();	
		
	sql = 	" SELECT USERCODE USERCODE, NVL(REPORTINGUSERCODE_PENDING, REPORTINGUSERCODE) REPORTINGUSERCODE, "+
			" 		 NVL(REVIEWERSCODE_PENDING, REVIEWERSCODE) REVIEWERSCODE, NVL(ISENABLED_PENDING, ISENABLED) ISENABLED, "+
			" 		 DECODE(STATUS, 'P', 'Pending', 'A', 'Approved', 'R', 'Rejected') STATUS "+
			"   FROM "+schemaName+"TB_USER_REPORTING_MAPPING "+
			"  WHERE 1=1";
	
			if(!userCodeField.equals("ALL")){
			    sql = sql + " AND USERCODE = ? ";
			}
			if(!reportingUserCodeField.equals("ALL")){
				sql = sql + " AND ( REPORTINGUSERCODE = ? OR REPORTINGUSERCODE_PENDING = ?) ";
			}
			if(!reviewersCodeField.equals("ALL")){
				sql = sql + " AND ( REVIEWERSCODE = ? OR REVIEWERSCODE = ?) ";
			}
			if(!statusField.equals("ALL")){
				sql = sql + " AND STATUS = ? ";
			}
			sql = sql + " ORDER BY UPDATETIMESTAMP DESC ";
		
			
			preparedStatement = connection.prepareStatement(sql);
			if(!userCodeField.equals("ALL")){
				preparedStatement.setString(count, userCodeField);
				count++;
			}
			if(!reportingUserCodeField.equals("ALL")){
				preparedStatement.setString(count, reportingUserCodeField);
				count++;
				preparedStatement.setString(count, reportingUserCodeField);
				count++;
			}
			if(!reviewersCodeField.equals("ALL")){
				preparedStatement.setString(count, reviewersCodeField);
				count++;
				preparedStatement.setString(count, reviewersCodeField);
				count++;
			}
			if(!statusField.equals("ALL")){
				preparedStatement.setString(count, statusField);
			}
			resultSet = preparedStatement.executeQuery();
			
			
		while(resultSet.next()){
			Map<String, String> dataMap = new LinkedHashMap<String, String>();
			dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
			dataMap.put("USERCODE", resultSet.getString("USERCODE"));
			dataMap.put("REPORTINGUSERCODE", resultSet.getString("REPORTINGUSERCODE"));
			dataMap.put("REVIEWERSCODE", resultSet.getString("REVIEWERSCODE"));
			dataMap.put("STATUS", resultSet.getString("STATUS"));
			
			mainList.add(dataMap);
		}
	}catch(Exception e){
		e.printStackTrace();	
	}finally{
		connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
	}
	//System.out.println(mainList);
	return mainList;
	}
	
	public String saveMappingRepUser(String fullData, String makerComments, String currentUser, String currentRole, String ipAddress){
		//System.out.println("Fulldata in dao = "+fullData+" com= "+makerComments);
		List<Map<String, String>> dataList = new LinkedList<Map<String,String>>();
						
		String[] arrStr = CommonUtil.splitString(fullData, ";");
		//System.out.println("arrStr = "+Arrays.toString(arrStr));
		for(String strData : arrStr){
			String[] arrData1 = CommonUtil.splitString(strData, "--");
			//System.out.println("arrData1 = "+Arrays.toString(arrData1));
			Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(String strData2 : arrData1){
					String[] arrData2 = CommonUtil.splitString(strData2, "=");
					if(arrData2.length > 0){
						dataMap.put(arrData2[0], arrData2[1]);
					}
				}
				dataList.add(dataMap);
			}
			
		String result = "";
		String sql = "";
		String status = "P";
		String userCode = "";
		Boolean logNeeded = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		
		try{
			sql =  " UPDATE "+schemaName+"TB_USER_REPORTING_MAPPING "+
				   "    SET REPORTINGUSERCODE_PENDING = ?, REVIEWERSCODE_PENDING = ?, ISENABLED_PENDING = ?, UPDATEDBY = ?, "+
				   " 	    UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBYUSERROLE = ?, IPADDRESS = ?, "+
				   " 	    STATUS = ?, MAKERCODE = ?, MAKERTIMESTAMP = SYSTIMESTAMP, MAKERCOMMENTS = ?, "+
				   " 	    CHECKERCODE = ?, CHECKERTIMESTAMP = ?, CHECKERCOMMENTS = ? "+
		           "  WHERE USERCODE = ? ";
			preparedStatement = connection.prepareStatement(sql);
			
			for(Map<String, String> dataMap :dataList){
				userCode = dataMap.get("USERCODE");
				preparedStatement.setString(1, dataMap.get("REPORTINGUSERCODE"));
				preparedStatement.setString(2, dataMap.get("REVIEWERSCODE"));
				preparedStatement.setString(3, dataMap.get("checkbox"));
				preparedStatement.setString(4, currentUser);
				preparedStatement.setString(5, currentRole);
				preparedStatement.setString(6, ipAddress);
				preparedStatement.setString(7, status);
				preparedStatement.setString(8, currentUser);
				preparedStatement.setString(9, makerComments);
				preparedStatement.setString(10, "");
				preparedStatement.setString(11, "");
				preparedStatement.setString(12, "");
				preparedStatement.setString(13, dataMap.get("USERCODE"));

				preparedStatement.addBatch();
			}
			preparedStatement.executeBatch();
			logNeeded = true;
			result = "Reporting Users mapped successfully";
			if(logNeeded){
				getNewDataForLog(userCode);
			}
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while mapping.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	public List<Map<String, String>> getReportingUserComments(String userCode, String currentUser, String currentRole, String ipAddress){
		List<Map<String, String>> wholeList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
		String sql= "";
		//System.out.println("userCode = "+userCode);
		
		/*FOR GETTING ALL THE COMMENTS, USE THIS SQL*/
		/*sql = " SELECT DISTINCT MAKERTIMESTAMP, MAKERCODE, MAKERCOMMENTS FROM "+schemaName+"TB_USER_REPORTING_MAPPING_LOG  "+
				" WHERE USERCODE = ? ORDER BY MAKERTIMESTAMP ASC";*/
		
		sql = 	" SELECT NVL(REPORTINGUSERCODE_PENDING, REPORTINGUSERCODE) REPORTINGUSERCODE, "+
				" 		 NVL(REVIEWERSCODE_PENDING, REVIEWERSCODE) REVIEWERSCODE, "+
				" 		 DECODE(NVL(ISENABLED_PENDING, ISENABLED), 'Y', 'Yes', 'N', 'No') ISENABLED, "+
				" 		 DECODE(STATUS, 'P', 'Pending', 'A', 'Approved', 'R', 'Rejected') STATUS, "+
				"		 MAKERCODE, MAKERTIMESTAMP, MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS "+
				"   FROM "+schemaName+"TB_USER_REPORTING_MAPPING WHERE USERCODE = ? ";
		
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, userCode);
				resultSet = preparedStatement.executeQuery();
				
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("REPORTINGUSERCODE", resultSet.getString("REPORTINGUSERCODE"));
				dataMap.put("REVIEWERSCODE", resultSet.getString("REVIEWERSCODE"));
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				dataMap.put("STATUS", resultSet.getString("STATUS"));
				dataMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				dataMap.put("MAKERTIMESTAMP", resultSet.getString("MAKERTIMESTAMP"));
				dataMap.put("MAKERCOMMENTS", resultSet.getString("MAKERCOMMENTS"));
				dataMap.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
				dataMap.put("CHECKERTIMESTAMP", resultSet.getString("CHECKERTIMESTAMP"));
				dataMap.put("CHECKERCOMMENTS", resultSet.getString("CHECKERCOMMENTS"));
				
				wholeList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		//System.out.println(wholeList);
		return wholeList;
	}
	
	public String approveOrRejectRepUser(String fullData, String actionToTake, String currentUser, String currentRole, String ipAddress){
		List<List<String>> mainList = new Vector<List<String>>();
		
		String[] arrStr = CommonUtil.splitString(fullData, ";");
		for(String strData : arrStr){
			String[] arrData1 = CommonUtil.splitString(strData, "--");
			if(arrData1.length == 5 ){
				List<String> dataList = new Vector<String>();
				for(String strData1 : arrData1)
					dataList.add(strData1);
				mainList.add(dataList);
				//System.out.println("mainList="+mainList);
			}
		}
		String result = "";
		String sql = "";
		String status = "";
		
		if("Approve".equals(actionToTake)){
			status = "A";
		}else if("Reject".equals(actionToTake)){
			status = "R";
		}
		
		String userCode = "";
		Boolean logNeeded = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		
		try{
			if("Approve".equals(actionToTake)){
				sql =  " UPDATE "+schemaName+"TB_USER_REPORTING_MAPPING "+
					   "    SET REPORTINGUSERCODE = ?, REPORTINGUSERCODE_PENDING = ?, "+ 
					   " 	    REVIEWERSCODE = ?, REVIEWERSCODE_PENDING = ?, "+
					   " 	    ISENABLED = ?, ISENABLED_PENDING = ?, UPDATEDBY = ?, "+
					   " 	    UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBYUSERROLE = ?, IPADDRESS = ?, "+
					   " 	    STATUS = ?, CHECKERCODE = ?, CHECKERTIMESTAMP = SYSTIMESTAMP, CHECKERCOMMENTS = ? "+
			           "  WHERE USERCODE = ? ";
				preparedStatement = connection.prepareStatement(sql);
				
				for(List<String> list : mainList){
					userCode = list.get(0);
					preparedStatement.setString(1, list.get(1));
					preparedStatement.setString(2, "");
					preparedStatement.setString(3, list.get(2));
					preparedStatement.setString(4, "");
					preparedStatement.setString(5, list.get(3));
					preparedStatement.setString(6, "");
					preparedStatement.setString(7, currentUser);
					preparedStatement.setString(8, currentRole);
					preparedStatement.setString(9, ipAddress);
					preparedStatement.setString(10, status);
					preparedStatement.setString(11, currentUser);
					preparedStatement.setString(12, list.get(4));
					preparedStatement.setString(13, list.get(0));
					
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				logNeeded = true;
				
				result = "Reporting Users mapping approved successfully";
			}else if("Reject".equals(actionToTake)){
				sql =  " UPDATE "+schemaName+"TB_USER_REPORTING_MAPPING "+
					   "    SET REPORTINGUSERCODE_PENDING = ?, REVIEWERSCODE_PENDING = ?, ISENABLED_PENDING = ?, "+ 
					   " 	    UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBYUSERROLE = ?, IPADDRESS = ?, "+
					   " 	    STATUS = ?, CHECKERCODE = ?, CHECKERTIMESTAMP = SYSTIMESTAMP, CHECKERCOMMENTS = ? "+
			           "  WHERE USERCODE = ? ";
				preparedStatement = connection.prepareStatement(sql);
				
				for(List<String> list : mainList){
					userCode = list.get(0);
					preparedStatement.setString(1, "");
					preparedStatement.setString(2, "");
					preparedStatement.setString(3, "");
					preparedStatement.setString(4, currentUser);
					preparedStatement.setString(5, currentRole);
					preparedStatement.setString(6, ipAddress);
					preparedStatement.setString(7, status);
					preparedStatement.setString(8, currentUser);
					preparedStatement.setString(9, list.get(4));
					preparedStatement.setString(10, list.get(0));
					
					preparedStatement.addBatch();
				}
				preparedStatement.executeBatch();
				logNeeded = true;
				
				result = "Reporting Users mapping rejected successfully";
			}
			if(logNeeded){
				getNewDataForLog(userCode);
			}
		}catch(Exception e){
			e.printStackTrace();
			
			if("Approve".equals(actionToTake)){
				result = "Error while approval.";
			}else if("Reject".equals(actionToTake)){
				result = "Error while rejection.";
			}
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
	public Boolean getNewDataForLog(String userCode){
		Map<String,String> row = new LinkedHashMap <String,String>();
		String sql = "";
		sql = " SELECT USERCODE, REPORTINGUSERCODE, REPORTINGUSERCODE_PENDING, REVIEWERSCODE, REVIEWERSCODE_PENDING, ISENABLED, "+
			  "		   ISENABLED_PENDING, UPDATEDBY, UPDATETIMESTAMP, UPDATEDBYUSERROLE, IPADDRESS, STATUS, MAKERCODE, "+
			  "		   MAKERTIMESTAMP, MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS "+
			  "   FROM "+schemaName+"TB_USER_REPORTING_MAPPING "+
			  "  WHERE UPDATETIMESTAMP = ( "+
			  "		   SELECT MAX(UPDATETIMESTAMP) "+
			  "          FROM "+schemaName+"TB_USER_REPORTING_MAPPING) "+
			  "    AND USERCODE = ? ";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, userCode);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					row.put(columnName, resultSet.getString(columnName));
				}
			}
			//System.out.println("Last Updated row first = "+row);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}

		return insertDataInLog(row);
	}
	
	public  Boolean insertDataInLog (Map<String,String> Data){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		Boolean isSuccess = true;
		ResultSet resultSet = null;
		ResultSet resultSet1 = null;
		String sql = " INSERT INTO "+schemaName+"TB_USER_REPORTING_MAPPING_LOG ( "+
					 "		  SEQNO, USERCODE, REPORTINGUSERCODE, REPORTINGUSERCODE_PENDING, REVIEWERSCODE, REVIEWERSCODE_PENDING, ISENABLED, "+
					 "		  ISENABLED_PENDING, UPDATEDBY, UPDATETIMESTAMP, UPDATEDBYUSERROLE, IPADDRESS, STATUS, MAKERCODE, "+
					 "		  MAKERTIMESTAMP, MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERCOMMENTS) "+
					 " VALUES (?, ?, ?, ?, ?, ?, ?,"+
					 "        ?, ?, SYSTIMESTAMP, ?, ?, ?, ?, "+
					 "		  to_timestamp(?,'YYYY-MM-DD HH24.MI.SSXFF'), ?, ?, to_timestamp(?,'YYYY-MM-DD HH24.MI.SSXFF'), ?) ";
		String seqNo = "";
		try{
			connection = connectionUtil.getConnection();			
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_REPUSERSMAPPING.NEXTVAL AS SEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				seqNo = resultSet.getString("SEQNO");
			}
			preparedStatement1 = connection.prepareStatement(sql);
			preparedStatement1.setString(1, seqNo);
			preparedStatement1.setString(2, Data.get("USERCODE"));
			preparedStatement1.setString(3, Data.get("REPORTINGUSERCODE"));
			preparedStatement1.setString(4, Data.get("REPORTINGUSERCODE_PENDING"));
			preparedStatement1.setString(5, Data.get("REVIEWERSCODE"));
			preparedStatement1.setString(6, Data.get("REVIEWERSCODE_PENDING"));
			preparedStatement1.setString(7, Data.get("ISENABLED"));
			preparedStatement1.setString(8, Data.get("ISENABLED_PENDING"));
			preparedStatement1.setString(9, Data.get("UPDATEDBY"));
			preparedStatement1.setString(10, Data.get("UPDATEDBYUSERROLE"));
			preparedStatement1.setString(11, Data.get("IPADDRESS"));
			preparedStatement1.setString(12, Data.get("STATUS"));
			preparedStatement1.setString(13, Data.get("MAKERCODE"));
			preparedStatement1.setString(14, Data.get("MAKERTIMESTAMP"));
			preparedStatement1.setString(15, Data.get("MAKERCOMMENTS"));
			preparedStatement1.setString(16, Data.get("CHECKERCODE"));
			preparedStatement1.setString(17, Data.get("CHECKERTIMESTAMP"));
			preparedStatement1.setString(18, Data.get("CHECKERCOMMENTS"));
			
			resultSet1 = preparedStatement1.executeQuery();
			
		}catch(Exception e){
			isSuccess = true;
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
			connectionUtil.closeResources(connection, preparedStatement1,resultSet1,null);
		}
		return isSuccess;
	}

	@Override
	public List<String> getAllUserList(String column) {
		List<String> userList = new ArrayList<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			// String sql = " SELECT DISTINCT "+column+" FROM "+schemaName+"TB_USER_REPORTING_MAPPING ";
			String sql = " SELECT DISTINCT A.USERCODE "+
			             "   FROM TB_USER A, TB_USERROLEMAPPING B "+
                         "  WHERE A.USERCODE = B.USERCODE "+
                         "    AND B.ROLEID IN ('AMLUSERL3','AMLO','MLRO','MLROL1','MLROL2') ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				//userList.add( resultSet.getString(column));
				userList.add( resultSet.getString("USERCODE"));
			}
		}catch(Exception e){
			System.out.println("error while getting all user for reporting mapping"+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);
		}
		
		return userList;
	}
	
}
