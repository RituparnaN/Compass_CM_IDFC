package com.quantumdataengines.app.compass.dao.alertConfiguration;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
public class AlertCodesDAOImpl implements AlertCodesDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> getAlertCodeForAlertType(String alertType){
		List<Map<String, String>> dataList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT ALERTCODE, ALERTMESSAGE "+
					 "	FROM "+schemaName+"TB_ALERTMASTER "+
					 " WHERE ALERTTYPE = ?";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertType);
			// System.out.println(sql+" "+alertType);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("ALERTCODE", resultSet.getString("ALERTCODE"));
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
	
	
	public Map<String, String> searchAlertCodeDetails(String alertType, String alertCode){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT ALERTCODE, ALERTNAME, DESCRIPTION, ALERTMESSAGE, "+
					 "		 ALERTTYPE, PRIORITY, ISENABLED "+
					 "	FROM "+schemaName+"TB_ALERTMASTER "+
					 " WHERE 1=1 ";
		/*
		if(alertType != null && alertType.length()>0 && !alertType.equalsIgnoreCase("ALL"))
			sql = sql + " AND ALERTTYPE = '"+alertType+"' ";
		if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL"))
			sql = sql + " AND ALERTCODE = '"+alertCode+"' ";
		*/
		if(alertType != null && alertType.length()>0 && !alertType.equalsIgnoreCase("ALL"))
			sql = sql + " AND ALERTTYPE = ? ";
		if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL"))
			sql = sql + " AND ALERTCODE = ? ";

		try{
			int count = 1;
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			
			if(alertType != null && alertType.length()>0 && !alertType.equalsIgnoreCase("ALL")){
				preparedStatement.setString(count, alertType);
				count++;
			}
			if(alertCode != null && alertCode.length()>0 && !alertCode.equalsIgnoreCase("ALL"))
				preparedStatement.setString(count, alertCode);
			
			
			// System.out.println(sql+" "+ alertCode+" "+alertType);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				dataMap.put("ALERTCODE", resultSet.getString("ALERTCODE"));
				dataMap.put("ALERTNAME", resultSet.getString("ALERTNAME"));
				dataMap.put("DESCRIPTION", resultSet.getString("DESCRIPTION"));
				dataMap.put("ALERTMESSAGE", resultSet.getString("ALERTMESSAGE"));
				dataMap.put("PRIORITY", resultSet.getString("PRIORITY"));
				dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	@SuppressWarnings("resource")
	public Map<String, String> createSubjectiveAlert(String alertCode, String alertName, String description, 
								String alertMsg, String alertPriority, String alertEnabled, String userCode){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int count = 0;
		try{
			String sql = "SELECT COUNT(1) ALERTCODECOUNT FROM "+schemaName+"TB_ALERTMASTER WHERE ALERTCODE = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertCode);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("ALERTCODECOUNT"); 
			}
			
			if(count == 0){
				sql= "INSERT INTO "+schemaName+"TB_ALERTMASTER(ALERTCODE, ALERTNAME, DESCRIPTION, ALERTMESSAGE, PRIORITY, "+
					 "       ISENABLED, ALERTTYPE, UPDATETIMESTAMP, UPDATEDBY) "+
					 "VALUES (?,?,?,?,?,?,?,SYSTIMESTAMP,?) ";			
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, alertCode);
				preparedStatement.setString(2, alertName);
				preparedStatement.setString(3, description);
				preparedStatement.setString(4, alertMsg);
				preparedStatement.setString(5, alertPriority);
				preparedStatement.setString(6, alertEnabled);
				preparedStatement.setString(7, "S");
				preparedStatement.setString(8, userCode);
				preparedStatement.executeUpdate();
				return searchAlertCodeDetails("S", alertCode);
			}else
				return searchAlertCodeDetails("", alertCode);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}	
		return null;
	}
	
	public String updateAlertDetails(String alertCode, String alertName, String description, 
									String alertMsg, String alertPriority, String alertEnabled, String userCode){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String result = null;
		// System.out.println(alertCode);
		try{
		String sql= "UPDATE "+schemaName+"TB_ALERTMASTER "+
					"   SET ALERTCODE = ?, ALERTNAME = ?, DESCRIPTION = ?, ALERTMESSAGE = ?, PRIORITY = ?, "+
					"       ISENABLED = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ? "+
					" WHERE ALERTCODE = ? ";			
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertCode);
			preparedStatement.setString(2, alertName);
			preparedStatement.setString(3, description);
			preparedStatement.setString(4, alertMsg);
			preparedStatement.setString(5, alertPriority);
			preparedStatement.setString(6, alertEnabled);
			preparedStatement.setString(7, userCode);
			preparedStatement.setString(8, alertCode);
			preparedStatement.executeUpdate();
			// System.out.println(sql);
			result = "Alert Details updated";
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}	
		return result;
		}
	
}
