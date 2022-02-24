package com.quantumdataengines.app.compass.dao.overviewGlance;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.Vector;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

@Repository
public class OverviewGlanceDAOImpl implements OverviewGlanceDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public LinkedHashMap<String,Object> getETLSummary(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			String sql = "SELECT * FROM "+schemaName+"TB_OVERALL_ETL_SUMMARY";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			List<String> columnList = new ArrayList<String>();
			for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
				columnList.add(resultSetMetaData.getColumnName(colIndex));
			}
			List<LinkedHashMap<String,Object>> tableData = new ArrayList<LinkedHashMap<String,Object>>();
			while(resultSet.next()) {
				LinkedHashMap<String,Object>rowData = new LinkedHashMap<String,Object>();
				for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rowData.put(columnName, resultSet.getString(columnName));
				}
				tableData.add(rowData);
			}
			resData.put("DATA", tableData);
			resData.put("COLUMNS", columnList);
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}

	@Override
	public Map<String, Object> accountGlance(String userCode, String userRole, String ipAddr) {
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Map<String, Object> chartData = new LinkedHashMap<String, Object>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; 
		String colNames = "";
		String chartTitle = "";
		String x_axis = "";
		String y_axis = "";
		try{
			callableStatement = connection.prepareCall("{ call STP_SEARCHACCOUNTGRAPH( ?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, userRole);
			callableStatement.setString(3, ipAddr);
			
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject(4);
			if(resultSet1.next()){
				colNames = resultSet1.getString("COLNAMES");
				chartTitle = resultSet1.getString("CHARTTITLE");
				x_axis = resultSet1.getString("XAXIS");
				y_axis = resultSet1.getString("YAXIS");
			}
			//System.out.println("col names  = "+colNames);
			List<String> colNameList = Arrays.asList(CommonUtil.splitString(colNames, "^~^"));
			System.out.println("col names = "+colNameList);
			for(int i = 5; i <= 8; i++){
				ResultSet resultSet = (ResultSet) callableStatement.getObject(i);
				ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
				List<LinkedHashMap<String, String>> dataList = new ArrayList<LinkedHashMap<String, String>>();
				while(resultSet.next()){
					LinkedHashMap<String, String> dataMap = new LinkedHashMap<String, String>();
					for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
						String columnName = resultSetMetaData.getColumnName(colIndex);
						dataMap.put(columnName, resultSet.getString(columnName));
					}
					dataList.add(dataMap);
					//dataMap.put(resultSet.getString(columnName), resultSet.getString("COUNT"));
				}
				chartData.put(colNameList.get(i-5),dataList);
			}	
			mainMap.put("chartData", chartData);
			mainMap.put("chartTitle", chartTitle);
			mainMap.put("x_axis", x_axis);
			mainMap.put("y_axis", y_axis);
			
			//System.out.println(mainMap);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		return mainMap;
	}
	
	@Override
	public Map<String, Object> customerGlance( String userCode, String userRole, String ipAddr) {
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Map<String, Object> chartData = new LinkedHashMap<String, Object>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; 
		String colNames = "";
		String chartTitle = "";
		String x_axis = "";
		String y_axis = "";
		try{
			callableStatement = connection.prepareCall("{ call STP_SEARCHCUSTOMERGRAPH( ?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, userRole);
			callableStatement.setString(3, ipAddr);
			
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(10, OracleTypes.CURSOR);
			
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject(4);
			if(resultSet1.next()){
				colNames = resultSet1.getString("COLNAMES");
				chartTitle = resultSet1.getString("CHARTTITLE");
				x_axis = resultSet1.getString("XAXIS");
				y_axis = resultSet1.getString("YAXIS");
			}
			//System.out.println("col names  = "+colNames);
			List<String> colNameList = Arrays.asList(CommonUtil.splitString(colNames, "^~^"));
			System.out.println("col names = "+colNameList);
			for(int i = 5; i <= 10; i++){
				ResultSet resultSet = (ResultSet) callableStatement.getObject(i);
				ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
				List<LinkedHashMap<String, String>> dataList = new ArrayList<LinkedHashMap<String, String>>();
				while(resultSet.next()){
					LinkedHashMap<String, String> dataMap = new LinkedHashMap<String, String>();
					for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
						String columnName = resultSetMetaData.getColumnName(colIndex);
						dataMap.put(columnName, resultSet.getString(columnName));
					}
					dataList.add(dataMap);
					//dataMap.put(resultSet.getString(columnName), resultSet.getString("COUNT"));
				}
				chartData.put(colNameList.get(i-5),dataList);
			}	
			mainMap.put("chartData", chartData);
			mainMap.put("chartTitle", chartTitle);
			mainMap.put("x_axis", x_axis);
			mainMap.put("y_axis", y_axis);
			
			//System.out.println(mainMap);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		return mainMap;
	}
	
	public int getNoOfINOUTParam(String procedureName){
		int count = 0 ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = " SELECT COUNT(IN_OUT) COUNT FROM USER_ARGUMENTS "+ 
						 "	WHERE OBJECT_NAME = ? AND IN_OUT = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, procedureName);
			preparedStatement.setString(2, "IN/OUT");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				count = resultSet.getInt("COUNT");
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return count;
	}

	@Override
	public Map<String, Object> etlWorkflowData(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			String sql = "SELECT * FROM "+schemaName+"TB_ETL_WORKFLOW_SUMMARY";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			List<String> columnList = new ArrayList<String>();
			for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
				columnList.add(resultSetMetaData.getColumnName(colIndex));
			}
			List<LinkedHashMap<String,Object>> tableData = new ArrayList<LinkedHashMap<String,Object>>();
			while(resultSet.next()) {
				LinkedHashMap<String,Object>rowData = new LinkedHashMap<String,Object>();
				for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rowData.put(columnName, resultSet.getString(columnName));
				}
				tableData.add(rowData);
			}
			resData.put("DATA", tableData);
			resData.put("COLUMNS", columnList);
			
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}

	@Override
	public Map<String, Object> etlAlertData(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			String sql = "SELECT * FROM "+schemaName+"TB_ETL_ALERT_SUMMARY";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			Set<String> columnList = new HashSet<String>();
			List<Map<String,String>> tableData = new ArrayList<Map<String,String>>();
			Map<String, Map<String, String>> rowData = new LinkedHashMap<String, Map<String, String>>();
			while(resultSet.next()) {
				columnList.add(resultSet.getString("ALERTCODE"));
				if(rowData.get(resultSet.getString("ETLDATETIME")) == null) {
					//System.out.println("does not exist");
					Map<String, String> eachData = new LinkedHashMap<String, String>();
					eachData.put(resultSet.getString("ALERTCODE"), resultSet.getString("TOTALALERTCOUNT"));
					rowData.put(resultSet.getString("ETLDATETIME"), eachData);
				}else {
					//System.out.println("exists");
					rowData.get(resultSet.getString("ETLDATETIME")).put(
							resultSet.getString("ALERTCODE"), resultSet.getString("TOTALALERTCOUNT"));
				}
			}
			
			for (Iterator<Entry<String, Map<String, String>>> entries = rowData.entrySet().iterator(); entries.hasNext(); ) {
			    Entry<String, Map<String, String>> entry = entries.next();
			    //System.err.println(" "+entry.getKey() +"---"+ entry.getValue());
			    Map<String, String> dataMap = entry.getValue();
			    dataMap.put("ETLDATETIME", entry.getKey());
			    //System.err.println(dataMap);
			    tableData.add(dataMap);
			}
			
			resData.put("DATA", tableData);
			resData.put("COLUMNS", columnList);
			
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}
	
	@Override
	public Map<String, Object> etlRegReportData(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			String sql = "SELECT * FROM "+schemaName+"TB_ETL_REGREPORT_SUMMARY";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			List<String> columnList = new ArrayList<String>();
			for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
				columnList.add(resultSetMetaData.getColumnName(colIndex));
			}
			List<LinkedHashMap<String,Object>> tableData = new ArrayList<LinkedHashMap<String,Object>>();
			while(resultSet.next()) {
				LinkedHashMap<String,Object>rowData = new LinkedHashMap<String,Object>();
				for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rowData.put(columnName, resultSet.getString(columnName));
				}
				tableData.add(rowData);
			}
			resData.put("DATA", tableData);
			resData.put("COLUMNS", columnList);
			
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}
	
	@Override
	public Map<String, Object> etlUserRoleData(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			String sql = "SELECT * FROM "+schemaName+"TB_ETL_OVERALL_USERROLE";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			List<String> columnList = new ArrayList<String>();
			for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
				columnList.add(resultSetMetaData.getColumnName(colIndex));
			}
			List<LinkedHashMap<String,Object>> tableData = new ArrayList<LinkedHashMap<String,Object>>();
			while(resultSet.next()) {
				LinkedHashMap<String,Object>rowData = new LinkedHashMap<String,Object>();
				for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rowData.put(columnName, resultSet.getString(columnName));
				}
				tableData.add(rowData);
			}
			resData.put("DATA", tableData);
			resData.put("COLUMNS", columnList);
			
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}
	
	@Override
	public Map<String, Object> etlAccountTypeStatusData(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			String sql = "SELECT * FROM "+schemaName+"TB_ETL_ACCOUNTTYPE_STATUS";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			List<String> columnList = new ArrayList<String>();
			for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
				columnList.add(resultSetMetaData.getColumnName(colIndex));
			}
			List<LinkedHashMap<String,Object>> tableData = new ArrayList<LinkedHashMap<String,Object>>();
			while(resultSet.next()) {
				LinkedHashMap<String,Object>rowData = new LinkedHashMap<String,Object>();
				for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rowData.put(columnName, resultSet.getString(columnName));
				}
				tableData.add(rowData);
			}
			resData.put("DATA", tableData);
			resData.put("COLUMNS", columnList);
			
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}
	
	@Override
	public Map<String, Object> etlCustomerTypeData(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			String sql = "SELECT * FROM "+schemaName+"TB_ETL_CUSTOMERTYPE";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			List<String> columnList = new ArrayList<String>();
			for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
				columnList.add(resultSetMetaData.getColumnName(colIndex));
			}
			List<LinkedHashMap<String,Object>> tableData = new ArrayList<LinkedHashMap<String,Object>>();
			while(resultSet.next()) {
				LinkedHashMap<String,Object>rowData = new LinkedHashMap<String,Object>();
				for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rowData.put(columnName, resultSet.getString(columnName));
				}
				tableData.add(rowData);
			}
			resData.put("DATA", tableData);
			resData.put("COLUMNS", columnList);
			
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}
	
	@Override
	public Map<String, Object> etlCaseProductivityData(String userCode, String userRole, String ipAddr) {
		LinkedHashMap<String,Object> resData = new LinkedHashMap<String,Object>();
		List<String> rolesList = new ArrayList<String>();
		rolesList.add("USER");
		rolesList.add("AMLUSER");
		rolesList.add("AMLO");
		rolesList.add("MLRO");
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			for(String role: rolesList) {
				String sql = " SELECT * FROM "+schemaName+"TB_CASEWORKFLOW_PRODUCTIVITY "+ 
							 " WHERE ROLEID = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, role);
				resultSet = preparedStatement.executeQuery();
				ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
				
				List<Map<String, Map<String, String>>> dataList = new ArrayList<Map<String,Map<String,String>>>();
				Map<String, Map<String, String>> roleData = new LinkedHashMap<String, Map<String, String>>();
				while(resultSet.next()) {
					Map<String, String> userData = new LinkedHashMap<String, String>();
					for(int colIndex=1;colIndex<=resultSetMetaData.getColumnCount();colIndex++) {
						String columnName = resultSetMetaData.getColumnName(colIndex);
						userData.put(columnName, resultSet.getString(columnName));
					}
					roleData.put(resultSet.getString("EMPLOYEENAME"), userData);
				}
				dataList.add(roleData);
				resData.put(role, dataList);
			}
			//System.out.println(resData);
		
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resData;
	}

	@Override
	public Map<String, Object> getETLAlertData(String fromDate, String toDate, String reportType, String reportValue,
			String moduleType, String userCode, String userRole, String ipAddr) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try {
			List<String> header = new Vector<String>();
			List<List<String>> data = new Vector<List<String>>();
			
			connection = connectionUtil.getConnection();
			
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETETLALERTDATA(?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, reportType);
			callableStatement.setString(4, reportValue);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(5);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
			}
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(columnName));
				}
				data.add(record);
			}
			
			resultData.put("HEADER", header);
			resultData.put("DATA", data);
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return resultData;
	}

	@Override
	public Map<String, Object> getETLRegulatoryReportData(String fromDate, String toDate, String reportType,
			String reportValue, String moduleType, String userCode, String userRole, String ipAddr) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try {
			List<String> header = new Vector<String>();
			List<List<String>> data = new Vector<List<String>>();
			
			connection = connectionUtil.getConnection();
			
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETETLREGREPORTDATA(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, reportType);
			callableStatement.setString(4, reportValue);
			callableStatement.setString(5, userCode);
			callableStatement.setString(6, userRole);
			callableStatement.setString(7, ipAddr);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(8);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
			}
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(columnName));
				}
				data.add(record);
			}
			
			resultData.put("HEADER", header);
			resultData.put("DATA", data);
		
		}catch(Exception e) {
			System.out.println("error = "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return resultData;
	}
	

}
