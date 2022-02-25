package com.quantumdataengines.app.compass.dao.alertConfiguration;


import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class AlertRatingsDAOImpl implements AlertRatingsDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> getAlertCode(){
			List<Map<String, String>> dataList = new Vector<Map<String, String>>();
			Connection connection = null;
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			String sql = "SELECT ALERTID, ALERTNAME "+
						 "	FROM "+schemaName+"TB_OFLALERTSDETAILS "+
						 " WHERE GROUPID = 'IBAALERTS' AND ISENABLED = 'Y'";
			try{
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					Map<String, String> dataMap = new LinkedHashMap<String, String>();
					dataMap.put("ALERTCODE", resultSet.getString("ALERTID"));
					dataMap.put("ALERTMESSAGE", resultSet.getString("ALERTNAME"));
				dataList.add(dataMap);	
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
			return dataList;
		}
	
	public List<Map<String, String>> getAlertMsg(String alertCode){
		List<Map<String, String>> dataList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT DISTINCT PARAMDEFAULTVALUE ALERTMESSAGE "+
					 "  FROM "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES "+
					 " WHERE UPPER(ALERTPARAMNAME) = 'ALERTMESSAGE' ";
		/*
		if(alertCode != null && alertCode.length() > 0 && !alertCode.equalsIgnoreCase("ALL"))
			sql = sql + " AND ALERTID = '"+alertCode+"' ";
		*/
		if(alertCode != null && alertCode.length() > 0 && !alertCode.equalsIgnoreCase("ALL"))
			sql = sql + " AND ALERTID = ? ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			if(alertCode != null && alertCode.length() > 0 && !alertCode.equalsIgnoreCase("ALL"))
				preparedStatement.setString(1, alertCode);
			
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("ALERTMESSAGE", resultSet.getString("ALERTMESSAGE"));
			dataList.add(dataMap);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	 
			
		public List<Map<String, String>> searchAlertRatingsDetails(String alertCode, String alertMsg){
			List<Map<String, String>> dataList = new Vector<Map<String,String>>();
			Connection connection = null;
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			String sql = " SELECT X.* FROM ( "+
						 " SELECT A.* FROM ( "+
						 " SELECT DISTINCT X.ALERTCODE, X.ALERTMESSAGE, "+ 
						 "        NVL(TRIM(Y.ALERTRATING),'LOW') ALERTRATING, "+ 
						 "        NVL(TRIM(Y.UPDATEDBY),'SYSTEM') UPDATEDBY, "+ 
						 "        NVL(TO_CHAR(Y.UPDATETIMESTAMP,'DD-MON-YYYY'),'N.A.') UPDATEDON, "+
						 "        CASE WHEN Y.UPDATEDBY IS NULL THEN 'N' ELSE 'Y' END ISUPDATED, "+
						 "        CASE WHEN Y.UPDATEDBY IS NULL THEN SYSTIMESTAMP ELSE Y.UPDATETIMESTAMP END UPDATETIMESTAMP "+
						 "   FROM "+ 
						 " ( "+
						 " SELECT DISTINCT A.ALERTID ALERTCODE, B.PARAMDEFAULTVALUE ALERTMESSAGE "+ 
						 "   FROM "+schemaName+"TB_OFLALERTSDETAILS A, "+schemaName+"TB_OFLALERTSPARAMDEFAULTVALUES B "+
						 "  WHERE A.GROUPID = 'IBAALERTS' "+ 
						 "    AND A.ISENABLED = 'Y' "+
						 "    AND A.ALERTID = B.ALERTID "+
						 "    AND UPPER(B.ALERTPARAMNAME) = 'ALERTMESSAGE' "+
						 " ) X LEFT OUTER JOIN "+schemaName+"TB_ALERTRATINGMASTER Y ON X.ALERTCODE = Y.ALERTID AND X.ALERTMESSAGE = Y.ALERTMESSAGE "+
						 " ) A ORDER BY ISUPDATED ASC, ALERTCODE, UPDATETIMESTAMP DESC, ALERTMESSAGE "+
						 " ) X WHERE 1 = 1 ";
			/*
			if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL"))
				sql = sql + " AND ALERTCODE = '"+alertCode+"' ";
			if(alertMsg != null && alertMsg.length()>0 && !alertMsg.equalsIgnoreCase("ALL"))
				sql = sql + " AND ALERTMESSAGE = '"+alertMsg+"' ";
			*/
			if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL"))
				sql = sql + " AND ALERTCODE = ? ";
			if(alertMsg != null && alertMsg.length()>0 && !alertMsg.equalsIgnoreCase("ALL"))
				sql = sql + " AND ALERTMESSAGE = ? ";

			try{
				int count = 1;
				connection = connectionUtil.getConnection();
				preparedStatement = connection.prepareStatement(sql);
				if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL")){
					preparedStatement.setString(count, alertCode);
					count++;
				}
				if(alertMsg != null && alertMsg.length()>0 && !alertMsg.equalsIgnoreCase("ALL"))
					preparedStatement.setString(count, alertMsg);
				
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					Map<String, String> dataMap = new HashMap<String, String>();
					dataMap.put("ISUPDATED", resultSet.getString("ISUPDATED"));
					dataMap.put("ALERTCODE", resultSet.getString("ALERTCODE"));
					dataMap.put("ALERTMESSAGE", resultSet.getString("ALERTMESSAGE"));
					dataMap.put("ALERTRATING", resultSet.getString("ALERTRATING"));
					dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
					dataMap.put("UPDATEDON", resultSet.getString("UPDATEDON"));
					dataList.add(dataMap);
				}
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}
			return dataList;
		}
		
		
		@SuppressWarnings("resource")
		public String updateAlertRatingsValues(String fullData, String userCode){
			Connection connection = connectionUtil.getConnection();
			PreparedStatement preparedStatement = null;
			ResultSet resultset = null;
			String result = "" ;
			List<Map<String, String>> dataList = new Vector<Map<String, String>>();
			try{
				String[] arr = CommonUtil.splitString(fullData, ",");
				for(String str : arr){
					String[] arr1 = CommonUtil.splitString(str, "|^|");
					Map<String, String> dataMap = new LinkedHashMap<String, String>();
					for(String str1 : arr1){
						String[] arr2 = CommonUtil.splitString(str1, "=");
						if(arr2.length > 0){		
							dataMap.put(arr2[0], arr2[1]);
							// System.out.println(arr2[0]+" : "+arr2[1]);
						}
					}
					dataList.add(dataMap);
				}
				
				String sql= "DELETE FROM "+schemaName+"TB_ALERTRATINGMASTER "+
							" WHERE ALERTID = ? "+
							"	AND ALERTMESSAGE = ? ";
				preparedStatement = connection.prepareStatement(sql);
				for(Map<String, String> dataMap : dataList){
					if(dataMap.get("ALERTID") != null){
						preparedStatement.setString(1, dataMap.get("ALERTID"));
						preparedStatement.setString(2, dataMap.get("ALERTMESSAGE"));
						preparedStatement.addBatch();
					}
				}
				preparedStatement.executeBatch();
				
				
				sql = "INSERT INTO "+schemaName+"TB_ALERTRATINGMASTER( "+
					  " 		ALERTID, ALERTMESSAGE, ALERTRATING, UPDATEDBY, UPDATETIMESTAMP) "+
					  "VALUES (?,?,?,?,SYSTIMESTAMP) ";
				preparedStatement = connection.prepareStatement(sql);
				for(Map<String, String> dataMap : dataList){
					if(dataMap.get("ALERTID") != null){
						preparedStatement.setString(1, dataMap.get("ALERTID"));
						preparedStatement.setString(2, dataMap.get("ALERTMESSAGE"));
						preparedStatement.setString(3, dataMap.get("ALERTRATING"));
						preparedStatement.setString(4, userCode);
						preparedStatement.addBatch();
					}
				}
				preparedStatement.executeBatch();
				
				result = "Alert Details updated";
			}catch(Exception e){
				e.printStackTrace();
				result = "Error while updating";
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultset, null);
			}	
			return result;
		}
		
		public String processAlertRatingUploadedFile(String PROCESSPROCEDURE, String userCode){
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
		
	}


