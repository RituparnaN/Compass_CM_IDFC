package com.quantumdataengines.app.compass.dao.falsePositive;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.access.method.P;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class FalsePositiveDAOImpl implements FalsePositiveDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	      
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	/*public List<Map<String, String>> getAlertMessages(String viewName){
		List<Map<String, String>> selectList = new LinkedList<Map<String,String>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT OPTIONNAME, OPTIONVALUE FROM "+viewName);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
				
				selectList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		System.out.println(selectList);
		return selectList;
	}*/
	
	public List<Map<String, String>> getAlertMessages(String alertCode){
		List<Map<String, String>> selectList = new LinkedList<Map<String,String>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT OPTIONNAME, OPTIONVALUE FROM VW_FALSEPOSITIVE_ALERTMESSAGE WHERE OPTIONNAME = ?");
			preparedStatement.setString(1, alertCode);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("CODE", resultSet.getString("OPTIONNAME"));
				dataMap.put("MESSAGE",resultSet.getString("OPTIONVALUE"));
				
				selectList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println(selectList);
		return selectList;
	}
	
	@Override
	public Map<String, Object> searchFalsePositives(String customerId, String accountNo, String alertCode, String alertMsg, 
													String activeFrom, String activeTo, String isEnabled, String reason, String toleranceLevel, String status, String userRole) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		int count = 1;
		try{
			
			/*if(status.equals("Pending")){
					sql= "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, STATUS, "+
					     "       ALERTMESSAGE, FUN_DATETOCHAR(ACTIVEFROMDATE) ACTIVEFROMDATE, FUN_DATETOCHAR(ACTIVETODATE) ACTIVETODATE, REASON, ISENABLED, "+
					     "		 TOLERANCELEVEL, UPDATETIMESTAMP LASTUPDATEDON, UPDATEDBY "+
					     "  FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
					     " 	WHERE STATUS = 'Pending' ";
			}
			else if(status.equals("Approved")){*/
				// if(userRole.equalsIgnoreCase("ROLE_MLRO") || userRole.equalsIgnoreCase("MLRO") && status.equals("Pending")){
                if(userRole.contains("MLRO") || userRole.contains("MLRO") && status.equals("Pending")){
					sql= "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, STATUS, "+
						 "       ALERTMESSAGE, FUN_DATETOCHAR(ACTIVEFROMDATE) ACTIVEFROMDATE, FUN_DATETOCHAR(ACTIVETODATE) ACTIVETODATE, REASON, ISENABLED, "+
						 "		 TOLERANCELEVEL, UPDATETIMESTAMP LASTUPDATEDON, UPDATEDBY "+
						 "  FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
						 " WHERE UPPER(TRIM(STATUS)) = 'PENDING' ";
				// }else if (userRole.equalsIgnoreCase("ROLE_ADMIN") || userRole.equalsIgnoreCase("ADMIN")){
                }else if (userRole.contains("ADMIN") || userRole.contains("ADMIN") || userRole.contains("AMLO")){
                	sql= "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, STATUS,"+
                		 "       ALERTMESSAGE, FUN_DATETOCHAR(ACTIVEFROMDATE) ACTIVEFROMDATE, FUN_DATETOCHAR(ACTIVETODATE) ACTIVETODATE, REASON, ISENABLED,"+
                		 "	     TOLERANCELEVEL, FUN_DATETOCHAR(UPDATETIMESTAMP) LASTUPDATEDON, UPDATEDBY "+
                		 "  FROM ( "+
                		 "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, STATUS,"+
                		 "       ALERTMESSAGE, ACTIVEFROMDATE, ACTIVETODATE, REASON, ISENABLED,"+
                		 "	     TOLERANCELEVEL, UPDATETIMESTAMP, UPDATEDBY "+
                		 "  FROM "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST "+
                		 " UNION "+ 
                		 "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, STATUS, "+
                		 "       ALERTMESSAGE, ACTIVEFROMDATE, ACTIVETODATE, REASON, ISENABLED, "+
                		 "	     TOLERANCELEVEL, UPDATETIMESTAMP, UPDATEDBY "+
                		 "  FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
                	  // " WHERE STATUS NOT IN ('Rejected') "+
                		     " ) X WHERE 1 = 1  ";
				}
			/*}*/
			
			
			if(customerId != null && customerId.length()>0)
				//sql = sql + " AND CUSTOMERID = '"+customerId+"' ";
				sql = sql + " AND CUSTOMERID = ? ";
			if(accountNo != null && accountNo.length()>0)
				//sql = sql + " AND ACCOUNTNO = '"+accountNo+"' ";
				sql = sql + " AND ACCOUNTNO = ? ";
			if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL"))
				//sql = sql + " AND ALERTCODE = '"+alertCode+"' ";
				sql = sql + " AND ALERTCODE = ? ";
			if(alertMsg != null && alertMsg.length()>0)
				//sql = sql + " AND ALERTMESSAGE = '"+alertMsg+"' ";
				sql = sql + " AND ALERTMESSAGE = ? ";
			if(activeFrom != null && activeFrom.length()>0)
				//sql = sql + " AND ACTIVEFROMDATE >= FUN_CHARTODATE('"+activeFrom+"') ";
				sql = sql + " AND ACTIVEFROMDATE >= FUN_CHARTODATE(?) ";
			if(activeTo != null && activeTo.length()>0)
				//sql = sql + " AND ACTIVETODATE <= (FUN_CHARTODATE('"+activeTo+"')+1) ";
				sql = sql + " AND ACTIVETODATE <= FUN_CHARTODATE(?)+1 ";
			if(isEnabled != null && isEnabled.length()>0)
				//sql = sql + " AND ISENABLED = '"+isEnabled+"' ";
				sql = sql + " AND ISENABLED = ? ";
			if(reason != null && reason.length()>0)
				//sql = sql + " AND REASON = '"+reason+"' ";
				sql = sql + " AND REASON = ? ";
			if(toleranceLevel != null && toleranceLevel.length()>0)
				//sql = sql + " AND TOLERANCELEVEL = '"+toleranceLevel+"' ";
				sql = sql + " AND TOLERANCELEVEL = ? ";

			sql = sql +  " ORDER BY CUSTOMERID, ACCOUNTNO, ALERTCODE ";
			/*
			System.out.println("sql: "+sql);
			System.out.println(" AND CUSTOMERID: "+customerId);
			System.out.println(" AND ACCOUNTNO: "+accountNo);
			System.out.println(" AND ALERTCODE: "+alertCode);
			System.out.println(" AND ALERTMESSAGE: "+alertMsg);
			System.out.println(" AND ACTIVEFROMDATE: "+activeFrom);
			System.out.println(" AND ACTIVETODATE: "+activeTo);
			System.out.println(" AND ISENABLED: "+isEnabled);
			System.out.println(" AND REASON: "+reason);
			System.out.println(" AND TOLERANCELEVEL: "+toleranceLevel);
			*/
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);

			if(customerId != null && customerId.length()>0){
				preparedStatement.setString(count, customerId);
				count++;
			}
			if(accountNo != null && accountNo.length()>0){
				preparedStatement.setString(count, accountNo);
				count++;
			}
			if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL")){
				preparedStatement.setString(count, alertCode);
				count++;
			}
			if(alertMsg != null && alertMsg.length()>0){
				preparedStatement.setString(count, alertMsg);
				count++;
			}
			if(activeFrom != null && activeFrom.length()>0){
				preparedStatement.setString(count, activeFrom);
				count++;
			}
			if(activeTo != null && activeTo.length()>0){
				preparedStatement.setString(count, activeTo);
				count++;
			}
			if(isEnabled != null && isEnabled.length()>0){
				preparedStatement.setString(count, isEnabled);
				count++;
			}
			if(reason != null && reason.length()>0){
				preparedStatement.setString(count, reason);
				count++;
			}
			if(toleranceLevel != null && toleranceLevel.length()>0){
				preparedStatement.setString(count, toleranceLevel);
			}
			resultSet = preparedStatement.executeQuery();
			count = 1; 
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			//for(int count = 1; count <= numberofcols; count++ ){
			for(count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(CommonUtil.changeColumnName(colname));
			}
			/*
			while(resultSet.next()){				
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(String header : headers){
					dataMap.put(header, resultSet.getString(header));
				}
				mainList.add(dataMap);
			}
			*/
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
				mainList.add(dataMap);
			}
			
			resultMap.put("HEADER", headers);
			resultMap.put("RECORDDATA", mainList);
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return resultMap;
	}

	@SuppressWarnings("resource")
	@Override
	public Map<String, Object> addFalsePositive(String custId, String accNo, String alertCode, String alertMsg, 
												String activeFrom, String activeTo, String isEnabled,
												String reason, String toleranceLevel, String status, String adminComments, String userCode, String userRole) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int count = 0;	
		String sql= "";
		Boolean isNeedLog = false;
		try{
			sql= " SELECT COUNT(1) EXISTINGDATA "+
			     "   FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
				 "  WHERE CUSTOMERID = ? "+
				 "    AND ACCOUNTNO = ? "+
				 "    AND ALERTCODE = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, custId);
			preparedStatement.setString(2, accNo);
			preparedStatement.setString(3, alertCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("EXISTINGDATA"); 
			}
			//System.out.println("existing data = "+count);
			if(count == 0){
				String customerName = "N.A.";
				if(!accNo.equalsIgnoreCase("ALL")){
					sql= " SELECT A.CUSTOMERNAME "+
							 "   FROM "+schemaName+"TB_ACCOUNTSMASTER A "+
							 "  WHERE A.ACCOUNTNO  = ? ";
						preparedStatement = connection.prepareStatement(sql);
						preparedStatement.setString(1, accNo);	
				}
				else if(!custId.equalsIgnoreCase("ALL")){
					sql= " SELECT A.CUSTOMERNAME "+
						 "   FROM "+schemaName+"TB_CUSTOMERMASTER A "+
						 "  WHERE A.CUSTOMERID  = ? ";
						preparedStatement = connection.prepareStatement(sql);
						preparedStatement.setString(1, custId);	
				}
				/*
				sql= " SELECT A.CUSTOMERNAME "+
					 "   FROM "+schemaName+"TB_ACCOUNTSMASTER A "+
					 "  WHERE A.ACCOUNTNO  = CASE WHEN ? = 'ALL' THEN A.ACCOUNTNO ELSE ? END "+
					 "    AND A.CUSTOMERID = CASE WHEN ? = 'ALL' THEN A.CUSTOMERID ELSE ? END  ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, accNo);
				preparedStatement.setString(2, accNo);
				preparedStatement.setString(3, custId);
				preparedStatement.setString(4, custId);
				*/
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					customerName = resultSet.getString("CUSTOMERNAME"); 
				}	
				
				sql= "INSERT INTO "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING( "+
					 "		 CUSTOMERID , ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
					 "		 ACTIVEFROMDATE, ACTIVETODATE, ISENABLED, REASON, TOLERANCELEVEL, "+
					 "		 STATUS, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, UPDATETIMESTAMP, UPDATEDBY) "+
					 "VALUES (?,?,?,?,?,"+
					 "		 FUN_CHARTODATE(?),FUN_CHARTODATE(?),?,?,?,"+
					 "		 ?,?,?,SYSTIMESTAMP,SYSTIMESTAMP,?) ";
				
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, custId);
				preparedStatement.setString(2, accNo);
				preparedStatement.setString(3, customerName);
				preparedStatement.setString(4, alertCode);
				preparedStatement.setString(5, alertMsg);
				preparedStatement.setString(6, activeFrom);
				preparedStatement.setString(7, activeTo);
				preparedStatement.setString(8, isEnabled);
				preparedStatement.setString(9, reason);
				preparedStatement.setString(10, toleranceLevel);
				preparedStatement.setString(11, status);
				preparedStatement.setString(12, userCode);
				preparedStatement.setString(13, adminComments);
				preparedStatement.setString(14, userCode);
				preparedStatement.executeUpdate();
				isNeedLog = true;
			}
			else if(count == 1){
				sql = "	UPDATE "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
					  "    SET ALERTMESSAGE = ?, ACTIVEFROMDATE = FUN_CHARTODATE(?), ACTIVETODATE = FUN_CHARTODATE(?), ISENABLED = ?, REASON = ?, "+
					  "		   TOLERANCELEVEL = ?, STATUS = ?, MAKERCODE = ?, ADMINCOMMENTS = ?, ADMINTIMESTAMP = SYSTIMESTAMP, "+
					  "		   UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? " +
					  "  WHERE CUSTOMERID = ? "+
					  "    AND ACCOUNTNO = ? "+
					  "    AND ALERTCODE = ? " ;
					connection = connectionUtil.getConnection();
					preparedStatement = connection.prepareStatement(sql);
					preparedStatement.setString(1, alertMsg);
					preparedStatement.setString(2, activeFrom);
					preparedStatement.setString(3, activeTo);
					preparedStatement.setString(4, isEnabled);
					preparedStatement.setString(5, reason);
					preparedStatement.setString(6, toleranceLevel);
					preparedStatement.setString(7, status);
					preparedStatement.setString(8, userCode);
					preparedStatement.setString(9, adminComments);
					preparedStatement.setString(10, userCode);
					preparedStatement.setString(11, custId);
					preparedStatement.setString(12, accNo);
					preparedStatement.setString(13, alertCode);
					preparedStatement.executeUpdate();
					isNeedLog = true;
			}
			else{
				isNeedLog = false;
				return searchFalsePositives(custId, accNo, alertCode, "", "", "", "", "", "", "", "");
			}
			if(isNeedLog){
				getNewDataForLog(custId, accNo, alertCode,false);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return searchFalsePositives(custId, accNo, alertCode, alertMsg, activeFrom, activeTo, isEnabled, reason, toleranceLevel, status, userRole);
	}

	public Map<String,String> fetchFalsePositiveToUpdate(String selectedCustId, String selectedAccNo,
														 String selectedAlertCode, String selectedStatus){
		//System.out.println("DAO INPUT --- selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
			//	  "&selectedAlertCode="+selectedAlertCode+"&selectedStatus="+selectedStatus);
		Map<String, String> falsePositiveMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String tableName = "";
		tableName = (("APPROVED".equalsIgnoreCase(selectedStatus)) ? "TB_CUSTOMERFALSEPOSITIVELIST" : "TB_CUSTFALSEPOSITIVE_PENDING");
		//System.out.println(tableName);
		try{
			String sql = "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
						 "		 FUN_DATETOCHAR(ACTIVEFROMDATE) ACTIVEFROMDATE, FUN_DATETOCHAR(ACTIVETODATE) ACTIVETODATE, REASON, ISENABLED, TOLERANCELEVEL, "+
						 "		 MAKERCODE, ADMINCOMMENTS, FUN_DATETOCHAR(ADMINTIMESTAMP) ADMINTIMESTAMP, CHECKERCODE, MLROCOMMENTS, "+
						 "		 FUN_DATETOCHAR(MLROTIMESTAMP) MLROTIMESTAMP, STATUS, UPDATETIMESTAMP, UPDATEDBY "+
						 "  FROM "+schemaName+""+tableName+
						 " WHERE CUSTOMERID = ? "+
						 "   AND ACCOUNTNO = ? "+
						 "   AND ALERTCODE = ? "+
						 "   AND STATUS = ? ";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, selectedCustId);
			preparedStatement.setString(2, selectedAccNo);
			preparedStatement.setString(3, selectedAlertCode);
			preparedStatement.setString(4, selectedStatus);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				falsePositiveMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				falsePositiveMap.put("ACCOUNTNO", resultSet.getString("ACCOUNTNO"));
				falsePositiveMap.put("CUSTOMERNAME", resultSet.getString("CUSTOMERNAME"));
				falsePositiveMap.put("ALERTCODE", resultSet.getString("ALERTCODE"));
				falsePositiveMap.put("ALERTMESSAGE", resultSet.getString("ALERTMESSAGE"));
				falsePositiveMap.put("ACTIVEFROMDATE", resultSet.getString("ACTIVEFROMDATE"));
				falsePositiveMap.put("ACTIVETODATE", resultSet.getString("ACTIVETODATE"));
				falsePositiveMap.put("REASON", resultSet.getString("REASON"));
				falsePositiveMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				falsePositiveMap.put("TOLERANCELEVEL", resultSet.getString("TOLERANCELEVEL"));
				falsePositiveMap.put("STATUS", resultSet.getString("STATUS"));
				falsePositiveMap.put("UPDATEDON", resultSet.getString("UPDATETIMESTAMP"));
				falsePositiveMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				falsePositiveMap.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				falsePositiveMap.put("ADMINCOMMENTS", resultSet.getString("ADMINCOMMENTS"));
				falsePositiveMap.put("ADMINTIMESTAMP", resultSet.getString("ADMINTIMESTAMP"));
				falsePositiveMap.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
				falsePositiveMap.put("MLROCOMMENTS", resultSet.getString("MLROCOMMENTS"));
				falsePositiveMap.put("MLROTIMESTAMP", resultSet.getString("MLROTIMESTAMP"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println("DAO OUTPUT --- "+falsePositiveMap);
		return falsePositiveMap; 
	}
	
	public String processFalsePositiveUploadedFile(String PROCESSPROCEDURE, String userCode){
		Connection connection = null;
		CallableStatement callableStatement = null;
		String result = "";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+PROCESSPROCEDURE+"(?)}");
			callableStatement.setString(1, userCode);
			callableStatement.execute();
			result = "Data processed successfully";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error occurred while processing data";
		}
		finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
	return result;
	}
	
	@SuppressWarnings("resource")
	public String updateFalsePositive(String custId, String accNo, String alertCode, String alertMsg, 
										String activeFrom, String activeTo, String isEnabled, 
										String reason, String toleranceLevel, String status, String adminComments, String userCode, String CURRENTROLE){
		//System.out.println("DAO ---- activeFrom = "+activeFrom+" activeTo"+activeTo);
		String result = null;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		//PreparedStatement preparedStatement2 = null;
		ResultSet resultSet = null;
		int count = 0;	
		String sql= "";
		Boolean isNeedLog = false;
		try{
			sql= " SELECT COUNT(1) EXISTINGDATA "+
			     "   FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
				 "  WHERE CUSTOMERID = ? "+
				 "    AND ACCOUNTNO = ? "+
				 "    AND ALERTCODE = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, custId);
			preparedStatement.setString(2, accNo);
			preparedStatement.setString(3, alertCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("EXISTINGDATA"); 
			}

			if(count == 0){
			String customerName = "N.A.";
			
			if(!accNo.equalsIgnoreCase("ALL")){
				sql= " SELECT A.CUSTOMERNAME "+
						 "   FROM "+schemaName+"TB_ACCOUNTSMASTER A "+
						 "  WHERE A.ACCOUNTNO  = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, accNo);	
			}
			else if(!custId.equalsIgnoreCase("ALL")){
				sql= " SELECT A.CUSTOMERNAME "+
					 "   FROM "+schemaName+"TB_CUSTOMERMASTER A "+
					 "  WHERE A.CUSTOMERID  = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, custId);	
			}
			/*
			sql= " SELECT A.CUSTOMERNAME "+
				 "   FROM "+schemaName+"TB_ACCOUNTSMASTER A "+
				 "  WHERE A.ACCOUNTNO  = CASE WHEN ? = 'ALL' THEN A.ACCOUNTNO ELSE ? END "+
				 "    AND A.CUSTOMERID = CASE WHEN ? = 'ALL' THEN A.CUSTOMERID ELSE ? END  ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, accNo);
			preparedStatement.setString(2, accNo);
			preparedStatement.setString(3, custId);
			preparedStatement.setString(4, custId);
			*/
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				customerName = resultSet.getString("CUSTOMERNAME"); 
			}	
			sql= "INSERT INTO "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING( "+
				 "		 CUSTOMERID , ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
				 "		 ACTIVEFROMDATE, ACTIVETODATE, ISENABLED, REASON, TOLERANCELEVEL, "+
				 "		 STATUS, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, UPDATETIMESTAMP, UPDATEDBY) "+
				 "VALUES (?,?,?,?,?,"+
			   	 "		 FUN_CHARTODATE(?),FUN_CHARTODATE(?),?,?,?,"+
				 "	     ?,?,?,SYSTIMESTAMP,SYSTIMESTAMP,?) ";		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, custId);
			preparedStatement.setString(2, accNo);
			preparedStatement.setString(3, customerName);
			preparedStatement.setString(4, alertCode);
			preparedStatement.setString(5, alertMsg);
			preparedStatement.setString(6, activeFrom);
			preparedStatement.setString(7, activeTo);
			preparedStatement.setString(8, isEnabled);
			preparedStatement.setString(9, reason);
			preparedStatement.setString(10, toleranceLevel);
			preparedStatement.setString(11, status);
			preparedStatement.setString(12, userCode);
			preparedStatement.setString(13, adminComments);
			preparedStatement.setString(14, userCode);
			preparedStatement.executeUpdate();
			isNeedLog = true;
			}else{
				sql = "UPDATE "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
					  "   SET ALERTMESSAGE = ? , ACTIVEFROMDATE = FUN_CHARTODATE(?), ACTIVETODATE = FUN_CHARTODATE(?), "+
					  "		  ISENABLED = ?, REASON = ?, TOLERANCELEVEL = ?, STATUS = ?, MAKERCODE = ?, "+
					  "       ADMINCOMMENTS = ?, ADMINTIMESTAMP = SYSTIMESTAMP, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? " +
					  " WHERE CUSTOMERID = ? "+
					  "   AND ACCOUNTNO = ? "+
					  "   AND ALERTCODE = ? " ;
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, alertMsg);
				preparedStatement.setString(2, activeFrom);
				preparedStatement.setString(3, activeTo);
				preparedStatement.setString(4, isEnabled);
				preparedStatement.setString(5, reason);
				preparedStatement.setString(6, toleranceLevel);
				preparedStatement.setString(7, status);
				preparedStatement.setString(8, userCode);
				preparedStatement.setString(9, adminComments);
				preparedStatement.setString(10, userCode);
				preparedStatement.setString(11, custId);
				preparedStatement.setString(12, accNo);
				preparedStatement.setString(13, alertCode);
				preparedStatement.executeUpdate();
				isNeedLog = true;
			}
			result = "False+ve Record Updated Successfully";
			
			if(isNeedLog){
				getNewDataForLog(custId, accNo, alertCode,false);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);
		}
		return result;
	}
	
	
	@SuppressWarnings("resource")
	public String rejectFalsePositive(String selectedCustId, String selectedAccNo, String selectedAlertCode, String mlroComments, String userCode){
		String result = null;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		String rejectStatus = "Rejected";
		Boolean isNeedLog = false;
		try{
			sql = "	UPDATE "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
				  "    SET STATUS = ?, CHECKERCODE = ?, MLROCOMMENTS = ?, MLROTIMESTAMP = SYSTIMESTAMP, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? " +
				  "  WHERE CUSTOMERID = ? "+
				  "    AND ACCOUNTNO = ? "+
				  "    AND ALERTCODE = ? " ;
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, rejectStatus);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, mlroComments);
			preparedStatement.setString(4, userCode);
			preparedStatement.setString(5, selectedCustId);
			preparedStatement.setString(6, selectedAccNo);
			preparedStatement.setString(7, selectedAlertCode);
			preparedStatement.executeUpdate();
			isNeedLog = true;
			result = "False+ve Record Rejected Successfully";
			
			if(isNeedLog){
				getNewDataForLog(selectedCustId, selectedAccNo, selectedAlertCode,false);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	public String approveFalsePositive(String selectedCustId, String selectedAccNo, String selectedAlertCode, 
			String selectedAlertMessage, String selectedActiveFrom, String selectedActiveTo, 
			String selectedReason, String selectedIsEnabled, String selectedToleranceLevel, String selectedAdminComments,
			String selectedAdminTimestamp, String selectedMlroComments, String userCode){
		/*System.out.println("selectedCustId="+selectedCustId+"&selectedAccNo="+selectedAccNo+
							  "&selectedAlertCode="+selectedAlertCode+"&selectedAlertMessage="+selectedAlertMessage+
							  "&selectedActiveFrom="+selectedActiveFrom+"&selectedActiveTo="+selectedActiveTo+
							  "&selectedReason="+selectedReason+"&selectedIsEnabled="+selectedIsEnabled+
							  "&selectedToleranceLevel="+selectedToleranceLevel+"&selectedMlroComments="+selectedMlroComments+
							  "&selectedAdminComments="+selectedAdminComments+"&selectedAdminTimestamp="+selectedAdminTimestamp);*/
		String result = null;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement2 = null;
		ResultSet resultSet = null;
		String status = "Approved";
		int count = 0;	
		String sql= "";
		Boolean isNeedLog = false;
		try{
			sql= " SELECT COUNT(1) EXISTINGDATA "+
			     "   FROM "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST "+
				 "  WHERE CUSTOMERID = ? "+
				 "    AND ACCOUNTNO = ? "+
				 "    AND ALERTCODE = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, selectedCustId);
			preparedStatement.setString(2, selectedAccNo);
			preparedStatement.setString(3, selectedAlertCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("EXISTINGDATA"); 
			}

			if(count == 0){
			String customerName = "N.A.";
			
			if(!selectedAccNo.equalsIgnoreCase("ALL")){
				sql= " SELECT A.CUSTOMERNAME "+
						 "   FROM "+schemaName+"TB_ACCOUNTSMASTER A "+
						 "  WHERE A.ACCOUNTNO  = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, selectedAccNo);	
			}
			else if(!selectedCustId.equalsIgnoreCase("ALL")){
				sql= " SELECT A.CUSTOMERNAME "+
					 "   FROM "+schemaName+"TB_CUSTOMERMASTER A "+
					 "  WHERE A.CUSTOMERID  = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, selectedCustId);	
			}
			/*
			sql= " SELECT A.CUSTOMERNAME "+
				 "   FROM "+schemaName+"TB_ACCOUNTSMASTER A "+
				 "  WHERE A.ACCOUNTNO  = CASE WHEN ? = 'ALL' THEN A.ACCOUNTNO ELSE ? END "+
				 "    AND A.CUSTOMERID = CASE WHEN ? = 'ALL' THEN A.CUSTOMERID ELSE ? END  ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, selectedAccNo);
			preparedStatement.setString(2, selectedAccNo);
			preparedStatement.setString(3, selectedCustId);
			preparedStatement.setString(4, selectedCustId);
			*/
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				customerName = resultSet.getString("CUSTOMERNAME"); 
			}
			/*
			sql= "INSERT INTO "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST( "+
				 "		 CUSTOMERID , ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
				 "		 ACTIVEFROMDATE, ACTIVETODATE, ISENABLED, REASON, TOLERANCELEVEL, "+
				 "		 STATUS, ADMINCOMMENTS, ADMINTIMESTAMP, MLROCOMMENTS, MLROTIMESTAMP, "+
				 "		 UPDATETIMESTAMP, UPDATEDBY) "+
				 "VALUES(?,?,?,?,?, "+
				 "		 FUN_CHARTODATE(?),FUN_CHARTODATE(?),?,?,?, "+
				 "		 ?,?,FUN_CHARTODATE(?),?,SYSTIMESTAMP, "+
				 "		 SYSTIMESTAMP,?) ";		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, selectedCustId);
			preparedStatement.setString(2, selectedAccNo);
			preparedStatement.setString(3, customerName);
			preparedStatement.setString(4, selectedAlertCode);
			preparedStatement.setString(5, selectedAlertMessage);
			preparedStatement.setString(6, selectedActiveFrom);
			preparedStatement.setString(7, selectedActiveTo);
			preparedStatement.setString(8, selectedIsEnabled);
			preparedStatement.setString(9, selectedReason);
			preparedStatement.setString(10, selectedToleranceLevel);
			preparedStatement.setString(11, status);
			preparedStatement.setString(12, selectedAdminComments);
			preparedStatement.setString(13, selectedAdminTimestamp);
			preparedStatement.setString(14, selectedMlroComments);
			preparedStatement.setString(15, userCode);
			preparedStatement.executeUpdate();
			*/
			sql= "INSERT INTO "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST( "+
				 "		 CUSTOMERID , ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
				 "		 ACTIVEFROMDATE, ACTIVETODATE, ISENABLED, REASON, TOLERANCELEVEL, "+
				 "		 STATUS, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				 "       CHECKERCODE, MLROCOMMENTS, MLROTIMESTAMP, "+
				 "		 UPDATETIMESTAMP, UPDATEDBY) "+
				 "SELECT CUSTOMERID , ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
				 "		 ACTIVEFROMDATE, ACTIVETODATE, ISENABLED, REASON, TOLERANCELEVEL, "+
				 "		 ?, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				 "       ?, ?, SYSTIMESTAMP, "+
				 "		 SYSTIMESTAMP, ? "+
				 "  FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING A "+
				 " WHERE CUSTOMERID = ? "+
				 "   AND ACCOUNTNO = ? "+
				 "   AND ALERTCODE = ?  ";		
			preparedStatement = connection.prepareStatement(sql);
			
			preparedStatement.setString(1, status);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, selectedMlroComments);
			preparedStatement.setString(4, userCode);
            preparedStatement.setString(5, selectedCustId);
            preparedStatement.setString(6, selectedAccNo);
            preparedStatement.setString(7, selectedAlertCode);
			preparedStatement.executeUpdate();
			isNeedLog = true;
			}else{
				/*
				sql = "   UPDATE "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST "+
					  "   SET ALERTMESSAGE = ? , ACTIVEFROMDATE = FUN_CHARTODATE(?), ACTIVETODATE = FUN_CHARTODATE(?), "+
					  "		  ISENABLED = ?, REASON = ?, TOLERANCELEVEL = ?, "+
					  "       STATUS = ?, MLROCOMMENTS = ?, MLROTIMESTAMP = SYSTIMESTAMP, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? " +
					  "   WHERE CUSTOMERID = ? "+
					  "   AND ACCOUNTNO = ? "+
					  "   AND ALERTCODE = ? " ;
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, selectedAlertMessage);
				preparedStatement.setString(2, selectedActiveFrom);
				preparedStatement.setString(3, selectedActiveTo);
				preparedStatement.setString(4, selectedIsEnabled);
				preparedStatement.setString(5, selectedReason);
				preparedStatement.setString(6, selectedToleranceLevel);
				preparedStatement.setString(7, status);
				preparedStatement.setString(8, selectedMlroComments);
				preparedStatement.setString(9, userCode);
				preparedStatement.setString(10, selectedCustId);
				preparedStatement.setString(11, selectedAccNo);
				preparedStatement.setString(12, selectedAlertCode);
				preparedStatement.executeUpdate();
				*/

				sql = "   UPDATE "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST "+
					  "      SET (CUSTOMERID , ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
				      "		      ACTIVEFROMDATE, ACTIVETODATE, ISENABLED, REASON, TOLERANCELEVEL, "+
				      "		      STATUS, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				      "           CHECKERCODE, MLROCOMMENTS, MLROTIMESTAMP, "+
				      "		      UPDATETIMESTAMP, UPDATEDBY) "+
				      "        = ( "+
				      "    SELECT CUSTOMERID , ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
				      "		      ACTIVEFROMDATE, ACTIVETODATE, ISENABLED, REASON, TOLERANCELEVEL, "+
				      "		      ?, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				      "           ?, ?, SYSTIMESTAMP, "+
				      "		      SYSTIMESTAMP, ? "+ 
				      "      FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING A "+
					  "     WHERE A.CUSTOMERID = ? "+
					  "       AND A.ACCOUNTNO = ? "+
					  "       AND A.ALERTCODE = ? ) "+
					  "    WHERE CUSTOMERID = ? "+
					  "      AND ACCOUNTNO = ? "+
					  "      AND ALERTCODE = ? " ;
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, status);
				preparedStatement.setString(2, userCode);
				preparedStatement.setString(3, selectedMlroComments);
				preparedStatement.setString(4, userCode);
				preparedStatement.setString(5, selectedCustId);
				preparedStatement.setString(6, selectedAccNo);
				preparedStatement.setString(7, selectedAlertCode);
				preparedStatement.setString(8, selectedCustId);
				preparedStatement.setString(9, selectedAccNo);
				preparedStatement.setString(10, selectedAlertCode);
				preparedStatement.executeUpdate();
				isNeedLog = true;
			}
			result = "False+ve Record Approved Successfully";
			
			String sql2 = "DELETE FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING WHERE CUSTOMERID = ? AND ACCOUNTNO = ? AND ALERTCODE = ?  ";
            preparedStatement2 = connection.prepareStatement(sql2);
            preparedStatement2.setString(1, selectedCustId);
            preparedStatement2.setString(2, selectedAccNo);
            preparedStatement2.setString(3, selectedAlertCode);
            preparedStatement2.executeUpdate();
            if(isNeedLog){
				getNewDataForLog(selectedCustId, selectedAccNo, selectedAlertCode,true);
			}
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	public Boolean getNewDataForLog(String custId,String accNo,String alertCode,Boolean isApproved){
		Map<String,String> row = new LinkedHashMap <String,String>();
		String sql = "";
		boolean isSuccess = true;
		/*String tableName = isApproved?"TB_CUSTOMERFALSEPOSITIVELIST":"TB_CUSTFALSEPOSITIVE_PENDING";*/
		String tableName = "";
		if(isApproved == true){
			//tableName = "TB_CUSTOMERFALSEPOSITIVELIST";
			sql = "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, STATUS, "+
				  "       ALERTMESSAGE, FUN_DATETOCHAR(ACTIVEFROMDATE) ACTIVEFROMDATE, FUN_DATETOCHAR(ACTIVETODATE) ACTIVETODATE, REASON, ISENABLED, "+
				  "		  TOLERANCELEVEL, MAKERCODE, ADMINCOMMENTS, FUN_DATETOCHAR(ADMINTIMESTAMP) ADMINTIMESTAMP, CHECKERCODE, "+
				  "		  MLROCOMMENTS, FUN_DATETOCHAR(MLROTIMESTAMP) MLROTIMESTAMP, UPDATETIMESTAMP LASTUPDATEDON, UPDATEDBY "+
				  "  FROM "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST "+
				  " WHERE CUSTOMERID = ? "+
				  "   AND ACCOUNTNO = ? "+
				  "   AND ALERTCODE = ? ";
			
			sql = " INSERT INTO "+schemaName+"TB_CUSTOMERFALSEPOSITIVE_LOG ( "+
				  "		  SEQNO, CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, STATUS, "+
				  "		  ACTIVEFROMDATE, ACTIVETODATE, REASON, ISENABLED, UPDATETIMESTAMP, "+
				  "		  UPDATEDBY, TOLERANCELEVEL, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				  "	      CHECKERCODE, MLROCOMMENTS, MLROTIMESTAMP) "+
				  "SELECT "+schemaName+"SEQ_FALSEPOSITIVE.NEXTVAL, CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, STATUS, "+
				  "       ACTIVEFROMDATE, ACTIVETODATE, REASON, ISENABLED, UPDATETIMESTAMP, "+
				  "		  UPDATEDBY, TOLERANCELEVEL, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				  "		  CHECKERCODE, MLROCOMMENTS, MLROTIMESTAMP "+
				  "  FROM "+schemaName+"TB_CUSTOMERFALSEPOSITIVELIST "+
				  " WHERE CUSTOMERID = ? "+
				  "   AND ACCOUNTNO = ? "+
				  "   AND ALERTCODE = ? ";
		}else{
			//tableName = "TB_CUSTFALSEPOSITIVE_PENDING";
			sql = "SELECT CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, STATUS, "+
				  "       ALERTMESSAGE, FUN_DATETOCHAR(ACTIVEFROMDATE) ACTIVEFROMDATE, FUN_DATETOCHAR(ACTIVETODATE) ACTIVETODATE, REASON, ISENABLED, "+
			      "		  TOLERANCELEVEL, MAKERCODE, ADMINCOMMENTS, FUN_DATETOCHAR(ADMINTIMESTAMP) ADMINTIMESTAMP, UPDATETIMESTAMP LASTUPDATEDON, UPDATEDBY "+
				  "  FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
			      " WHERE CUSTOMERID = ? "+
				  "   AND ACCOUNTNO = ? "+
			      "   AND ALERTCODE = ? ";
			
			sql = "INSERT INTO "+schemaName+"TB_CUSTOMERFALSEPOSITIVE_LOG ( "+
				  "		  SEQNO, CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, STATUS, "+
				  "		  ACTIVEFROMDATE, ACTIVETODATE, REASON, ISENABLED, UPDATETIMESTAMP, "+
				  "		  UPDATEDBY, TOLERANCELEVEL, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				  "	      CHECKERCODE, MLROCOMMENTS, MLROTIMESTAMP) "+
				  "SELECT "+schemaName+"SEQ_FALSEPOSITIVE.NEXTVAL, CUSTOMERID, ACCOUNTNO, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, STATUS, "+
				  "       ACTIVEFROMDATE, ACTIVETODATE, REASON, ISENABLED, UPDATETIMESTAMP, "+
				  "		  UPDATEDBY, TOLERANCELEVEL, MAKERCODE, ADMINCOMMENTS, ADMINTIMESTAMP, "+
				  "		  CHECKERCODE, MLROCOMMENTS, MLROTIMESTAMP "+
				  "  FROM "+schemaName+"TB_CUSTFALSEPOSITIVE_PENDING "+
				  " WHERE CUSTOMERID = ? "+
				  "   AND ACCOUNTNO = ? "+
				  "   AND ALERTCODE = ? ";
		}
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		/*System.out.println("parameters = "+custId+"..."+accNo+"..."+alertCode+"..."+isApproved);
		System.out.println("sql = "+sql);*/
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, custId);
			preparedStatement.setString(2, accNo);
			preparedStatement.setString(3, alertCode);
			preparedStatement.executeUpdate();
			/*
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					row.put(columnName, resultSet.getString(columnName));
				}
			}
			*/
			//System.out.println("Last Updated row first = "+row);
		}catch(Exception e){
			isSuccess = false;
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		//System.out.println("Last Updated row sec = "+row);
		//insertDataInLog(row);
		//System.out.println(row);
		// return insertDataInLog(row);
		return isSuccess;
		
	}
	public  Boolean insertDataInLog (Map<String,String> Data){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		Boolean isSuccess = true;
		ResultSet resultSet = null;
		ResultSet resultSet1 = null;
		//System.out.println("Data = "+Data);
		String sql = " INSERT INTO "+schemaName+"TB_CUSTOMERFALSEPOSITIVE_LOG ( "+
					 "		  SEQNO, CUSTOMERID, CUSTOMERNAME, ALERTCODE, ALERTMESSAGE, "+
					 "		  ACTIVEFROMDATE, ACTIVETODATE, REASON, ISENABLED, UPDATETIMESTAMP, "+
					 "		  UPDATEDBY, ACCOUNTNO, TOLERANCELEVEL, STATUS, MAKERCODE, "+
					 "	      ADMINCOMMENTS, ADMINTIMESTAMP, CHECKERCODE, MLROCOMMENTS, MLROTIMESTAMP) "+
					 " VALUES (?,?,?,?,?,"+
					 "        FUN_CHARTODATE(?),FUN_CHARTODATE(?),?,?,SYSTIMESTAMP, "+
					 "		  ?,?,?,?,?,"+
					 "		  ?,SYSTIMESTAMP,?,?,SYSTIMESTAMP) ";
		//System.out.println("sql = "+sql);
		/*if(Data.get("MLROTIMESTAMP") != null){
			sql += " ,MLROTIMESTAMP ";
		}
		sql += ")";
		
		sql += " VALUES (?,?,?,?,?,"+
			   "         FUN_CHARTODATE(?),FUN_CHARTODATE(?),?,?,SYSTIMESTAMP, "+
			   "		 ?,?,?,?,?,"+
			   "		 FUN_CHARTODATE(?),? ";
		if(Data.get("MLROTIMESTAMP") != null){
			sql += " ,FUN_CHARTODATE(?) ";
		}
		sql += ")";*/
					
		String seqNo = ""; 
		try{
			connection = connectionUtil.getConnection();			
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_FALSEPOSITIVE.NEXTVAL AS SEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				seqNo = resultSet.getString("SEQNO");
			}
			// System.out.println("ACTIVEFROMDATE: "+Data.get("ACTIVEFROMDATE")+" ,ACTIVETODATE : "+Data.get("ACTIVETODATE"));
			preparedStatement1 = connection.prepareStatement(sql);
			preparedStatement1.setString(1, seqNo);
			preparedStatement1.setString(2, Data.get("CUSTOMERID"));
			preparedStatement1.setString(3, Data.get("CUSTOMERNAME"));
			preparedStatement1.setString(4, Data.get("ALERTCODE"));
			preparedStatement1.setString(5, Data.get("ALERTMESSAGE"));
			preparedStatement1.setString(6, Data.get("ACTIVEFROMDATE"));//formatStringFromTimestamp(Data.get("ACTIVEFROMDATE")));
			preparedStatement1.setString(7, Data.get("ACTIVETODATE"));
			preparedStatement1.setString(8, Data.get("REASON"));
			preparedStatement1.setString(9, Data.get("ISENABLED"));
			//preparedStatement1.setString(10, Data.get("UPDATETIMESTAMP"));
			preparedStatement1.setString(10, Data.get("UPDATEDBY"));
			preparedStatement1.setString(11, Data.get("ACCOUNTNO"));
			preparedStatement1.setString(12, Data.get("TOLERANCELEVEL"));
			preparedStatement1.setString(13, Data.get("STATUS"));
			preparedStatement1.setString(14, Data.get("MAKERCODE"));
			preparedStatement1.setString(15, Data.get("ADMINCOMMENTS"));
			// preparedStatement1.setString(16, Data.get("ADMINTIMESTAMP"));
			preparedStatement1.setString(16, Data.get("CHECKERCODE"));
			preparedStatement1.setString(17, Data.get("MLROCOMMENTS"));
			// preparedStatement1.setString(19, Data.get("MLROTIMESTAMP"));
			/*if(Data.get("MLROTIMESTAMP") != null){
				preparedStatement1.setString(17, Data.get("MLROTIMESTAMP"));
			}*/
			
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
	
	/*public String formatStringFromTimestamp (String stringData){
		String str = stringData.split("\\s+")[0];
		String year = str.split("-")[0];
		String month = str.split("-")[1];
		String day = str.split("-")[2];
		return day+"/"+month+"/"+year;
		
	}*/

}

