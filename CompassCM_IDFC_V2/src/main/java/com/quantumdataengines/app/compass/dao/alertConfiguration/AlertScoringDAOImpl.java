package com.quantumdataengines.app.compass.dao.alertConfiguration;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
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
public class AlertScoringDAOImpl implements AlertScoringDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> getAlertParameterList(){
		List<Map<String, String>> alertParameterList = new Vector<Map<String, String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT PARAM_FLAG, PARAMID, PARAMNAME "+
					 	 "	FROM "+schemaName+"TB_ALERTSCORINGPARAMETERS "+
					 	 " ORDER BY PARAMID ASC ";
			
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){				
				Map<String, String> alertParameterMap = new HashMap<String, String>();
				alertParameterMap.put("PARAM_FLAG", resultSet.getString("PARAM_FLAG"));
				alertParameterMap.put("PARAMID", resultSet.getString("PARAMID"));
				alertParameterMap.put("PARAMNAME", resultSet.getString("PARAMNAME"));
				alertParameterList.add(alertParameterMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return alertParameterList;
	}
	
	public void saveAlertParameterList(String strAlertParameters){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		String sql = "UPDATE "+schemaName+"TB_ALERTSCORINGPARAMETERS "+
					 "	 SET PARAM_FLAG = ? "+
					 " WHERE PARAMID = ? ";
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrAlertParameters = CommonUtil.splitString(strAlertParameters, ",");
			for(String strAlertParameter : arrAlertParameters){
				if(strAlertParameter.length() > 0){
					String[] arrAlertParameter = CommonUtil.splitString(strAlertParameter, "=");
					preparedStatement.setString(1, arrAlertParameter[1]);
					preparedStatement.setString(2, arrAlertParameter[0]);
					preparedStatement.addBatch();
				}
			}
			int[] x = preparedStatement.executeBatch();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public String calculateAlertScore(String userCode, String CURRENTROLE, String ipAddress){
		Connection connection = null;
		CallableStatement callableStatement = null;
		String result = "";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_CALCULATEALERTSCORE(?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, CURRENTROLE);
			callableStatement.setString(3, ipAddress);
			callableStatement.execute();
			result = "Alert Score calculated successfully";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error occured while calculating risk.";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return result;
	}

	
	
	public List<Map<String,String>> searchAlertScoreAssignment(String searchParamId){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = " SELECT PARAMID, CODE, DESCRIPTION, SCOREVALUE  "+ 
					 "   FROM "+schemaName+"TB_ALERTSCORINGPARAMETERVALUES A "+
					 "  WHERE PARAMID = ? ";

		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, searchParamId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("CODE", resultSet.getString("CODE"));
				dataMap.put("DESCRIPTION", resultSet.getString("DESCRIPTION"));
				dataMap.put("SCOREVALUE", resultSet.getInt("SCOREVALUE")+"");
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public void updateAlertScoreAssignmentValue(String fullData, String paramId){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		try{
			String sql = "UPDATE "+schemaName+"TB_ALERTSCORINGPARAMETERVALUES "+
						 "	 SET SCOREVALUE = ? "+
						 " WHERE PARAMID = ? AND CODE = ? " ;
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			String[] arrFullData = CommonUtil.splitString(fullData, ",");
			for(String strData : arrFullData){
				if(strData.length()>0){
					String[] arrData = CommonUtil.splitString(strData, "=");
					// System.out.println(arrData[1]+"  "+arrData[0]);
					preparedStatement.setString(1, arrData[1]);
					preparedStatement.setString(2, paramId);
					preparedStatement.setString(3, arrData[0]);
					preparedStatement.addBatch();
				}
			}
			preparedStatement.executeBatch();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
				
}
