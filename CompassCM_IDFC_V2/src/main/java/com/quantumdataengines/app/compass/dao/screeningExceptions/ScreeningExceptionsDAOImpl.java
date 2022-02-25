package com.quantumdataengines.app.compass.dao.screeningExceptions;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.net.aso.s;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ScreeningExceptionsDAOImpl implements ScreeningExceptionsDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String, String> returnMatchedList(){
		Map<String, String> resultMap = new HashMap<String, String>();		
		Connection connection = null;
		PreparedStatement preparedStatement  = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT LISTNAME, LISTCODE "+
						 "  FROM "+schemaName+"TB_EXCEPTIONlISTMASTER "+
						 " WHERE LISTTYPE NOT IN ('Message List' , 'EmployeeList') " ; 
			
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				resultMap.put(resultSet.getString("LISTCODE"), resultSet.getString("LISTNAME"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resultMap;
	}
	
	@Override
	public Map<String, Object> searchScreeningExceptions(String customerId, String customerName, String matchedList, String matchedEntity, 
														  String isEnabled, String listId, String reason) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		int count = 0;
		
		try{
			sql= "SELECT CUSTOMERID, CUSTOMERNAME, NVL(TRIM(MATCHEDLIST), 'N.A.')MATCHEDLIST, "+
			     "       NVL(TRIM(MATCHEDENTITY), 'N.A.') MATCHEDENTITY, NVL(TRIM(LISTID), 'N.A.') LISTID, "+
			     "		REASON, ISREMOVED, FUN_DATETOCHAR (UPDATETIMESTAMP) UPDATEDON, UPDATEDBY UPDATEDBY "+
			     "  FROM "+schemaName+"TB_WHITELISTMANAGER "+
			     " WHERE 1 = 1 ";
			if(customerId != null && customerId.length()>0)
				//sql = sql + " AND CUSTOMERID = '"+customerId+"' ";
				sql = sql + " AND CUSTOMERID = ? ";
			if(customerName != null && customerName.length()>0)
				//sql = sql + " AND CUSTOMERNAME = '"+customerName+"' ";
				sql = sql + " AND CUSTOMERNAME = ? ";
			if(matchedList != null && matchedList.length()>0 && !matchedList.equalsIgnoreCase("ALL"))
				//sql = sql + " AND MATCHEDLIST = '"+matchedList+"' ";
				sql = sql + " AND MATCHEDLIST = ? ";
			if(matchedEntity != null && matchedEntity.length()>0)
				//sql = sql + " AND MATCHEDENTITY = '"+matchedEntity+"' ";
				sql = sql + " AND MATCHEDENTITY = ? ";
			if(isEnabled != null && isEnabled.length()>0)
				//sql = sql + " AND ISREMOVED = '"+isEnabled+"' ";
				sql = sql + " AND ISREMOVED = ? ";
			if(listId != null && listId.length()>0)
				//sql = sql + " AND LISTID = '"+listId+"' ";
				sql = sql + " AND LISTID = ? ";
			if(reason != null && reason.length()>0)
				//sql = sql + " AND REASON = '"+reason+"' ";
				sql = sql + " AND REASON = ? ";

			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);

			if(customerId != null && customerId.length()>0){
				preparedStatement.setString(count, customerId);
				count++;
			}
			if(customerName != null && customerName.length()>0){
				preparedStatement.setString(count, customerName);
				count++;
			}
			if(matchedList != null && matchedList.length()>0 && !matchedList.equalsIgnoreCase("ALL")){
				preparedStatement.setString(count, matchedList);
				count++;
			}
			if(matchedEntity != null && matchedEntity.length()>0){
				preparedStatement.setString(count, matchedEntity);
				count++;
			}
			if(isEnabled != null && isEnabled.length()>0){
				preparedStatement.setString(count, isEnabled);
				count++;
			}
			if(listId != null && listId.length()>0){
				preparedStatement.setString(count, listId);
				count++;
			}
			if(reason != null && reason.length()>0){
				preparedStatement.setString(count, reason);
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
	public Map<String, Object> addScreeningException(String custId, String custName, String matchedList, String reason, 
			 String matchedEntity, String isEnabled, String listId, String userCode, String CURRENTROLE) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql= "";
		int count = 0;		
		try{
			sql= "SELECT COUNT(1) EXISTINGDATA FROM "+schemaName+"TB_WHITELISTMANAGER "+
				 " WHERE CUSTOMERID = ? "+
				 "   AND MATCHEDLIST = ? "+
				 "   AND LISTID = ?";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, custId);
			preparedStatement.setString(2, matchedList);
			preparedStatement.setString(3, listId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("EXISTINGDATA"); 
			}
			
			if(count == 0){
					
				sql= "INSERT INTO "+schemaName+"TB_WHITELISTMANAGER(CUSTOMERID, CUSTOMERNAME, "+
					 "       MATCHEDLIST, MATCHEDENTITY , LISTID, "+
					 " 		 ISREMOVED, REASON, UPDATETIMESTAMP, UPDATEDBY) "+
					 "SELECT A.CUSTOMERID, A.CUSTOMERNAME, "+
					 "		 ?, 'N.A.', ?, "+
					 "       'N', ?, SYSTIMESTAMP,? "+
					 "	FROM "+schemaName+"TB_CUSTOMERMASTER A "+
					 " WHERE A.CUSTOMERID = ? ";
		
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, matchedList);
				preparedStatement.setString(2, listId);
				preparedStatement.setString(3, reason);
				preparedStatement.setString(4, userCode);
				preparedStatement.setString(5, custId);
				preparedStatement.executeUpdate();
			}else{
				return searchScreeningExceptions(custId, "", "", "", "", "", "");
			}
			}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
	return searchScreeningExceptions(custId, "", "", "", "", "", "");
	}

	public Map<String,String> fetchScreeningExceptionToUpdate(String selectedCustId, String selectedCustName,
																String selectedMatchedEntity){
		Map<String, String> screeningExceptionMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT CUSTOMERID, CUSTOMERNAME, NVL(TRIM(MATCHEDLIST), 'N.A.')MATCHEDLIST, "+
						 "       NVL(TRIM(MATCHEDENTITY), 'N.A.') MATCHEDENTITY, NVL(TRIM(LISTID), 'N.A.') LISTID, "+
						 "		 REASON, ISREMOVED, FUN_DATETOCHAR (UPDATETIMESTAMP) UPDATEDON, UPDATEDBY UPDATEDBY "+
						 "  FROM "+schemaName+"TB_WHITELISTMANAGER "+
						 " WHERE CUSTOMERID = ? "+
						 "   AND CUSTOMERNAME = ? " +
						 "   AND MATCHEDENTITY = ?" ;
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, selectedCustId);
			preparedStatement.setString(2, selectedCustName);
			preparedStatement.setString(3, selectedMatchedEntity);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				screeningExceptionMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				screeningExceptionMap.put("CUSTOMERNAME", resultSet.getString("CUSTOMERNAME"));
				screeningExceptionMap.put("MATCHEDLIST", resultSet.getString("MATCHEDLIST"));
				screeningExceptionMap.put("MATCHEDENTITY", resultSet.getString("MATCHEDENTITY"));
				screeningExceptionMap.put("LISTID", resultSet.getString("LISTID"));
				screeningExceptionMap.put("REASON", resultSet.getString("REASON"));
				screeningExceptionMap.put("ISREMOVED", resultSet.getString("ISREMOVED"));
				screeningExceptionMap.put("UPDATEDON", resultSet.getString("UPDATEDON"));
				screeningExceptionMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return screeningExceptionMap; 
	}
	
	public String updateScreeningException(String custId, String custName, String matchedList, String reason, 
			 String matchedEntity, String isEnabled, String listId, String userCode, String CURRENTROLE){
		String result;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "UPDATE "+schemaName+"TB_WHITELISTMANAGER "+
					 	 "   SET MATCHEDLIST = ?, LISTID = ?, "+
					 	 "		 ISREMOVED = ?, REASON = ?, "+
					 	 " 		 UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
					 	 " WHERE CUSTOMERID = ? AND MATCHEDENTITY = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, matchedList);
			preparedStatement.setString(2, listId);
			preparedStatement.setString(3, isEnabled);
			preparedStatement.setString(4, reason);
			preparedStatement.setString(5, userCode);
			preparedStatement.setString(6, custId);
			preparedStatement.setString(7, matchedEntity);
			preparedStatement.executeUpdate();
			result = "Whitelist Record Updated Successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while updating.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}

}

