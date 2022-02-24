package com.quantumdataengines.app.compass.dao.graphicalMasterModule;

import java.sql.Connection;
import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
@Repository
public class GraphicalMasterDAOImpl implements GraphicalMasterDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String, Object> getGraphicalMasterData(String userCode,String userRole, String remoteAddr,String moduleType) {
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		int noOfResultSet = getNoOfINOUTParam(procedureName);
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Map<String, Object> chartData = new LinkedHashMap<String, Object>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; ResultSet resultSet2 = null;
		String colNames = "";
		String chartTitle = "";
		String x_axis = "";
		String y_axis = "";
		
		String sql = "{CALL "+procedureName+"( :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, ";
		for(int i = 2; i <= noOfResultSet; i++){
			if(i == noOfResultSet)
				sql = sql + ":RESULTSET"+i+" ";
			else
				sql = sql + ":RESULTSET"+i+", ";
		}
		sql = sql + ")}";
		//System.out.println(sql);
		try{
			callableStatement = connection.prepareCall(sql);
			
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("GROUPCODE", userRole);
			callableStatement.setString("IPADDRESS", remoteAddr);
			
			callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
		
			for(int i = 2; i <= noOfResultSet; i++){
				String indexName = "RESULTSET"+i;
				callableStatement.registerOutParameter(indexName, OracleTypes.CURSOR);
			}
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject("RESULTSET1");
			if(resultSet1.next()){
				colNames = resultSet1.getString("COLNAMES");
				chartTitle = resultSet1.getString("CHARTTITLE");
				x_axis = resultSet1.getString("XAXIS");
				y_axis = resultSet1.getString("YAXIS");
			}
			//System.out.println("col names  = "+colNames);
			List<String> colNameList = Arrays.asList(CommonUtil.splitString(colNames, "^~^"));
			for(int i = 2; i <= noOfResultSet; i++){
				ResultSet resultSet = (ResultSet) callableStatement.getObject("RESULTSET"+i);
				chartData.put(colNameList.get(i-2),manageDataFormOne(resultSet));
			}	
			
			
			mainMap.put("chartData", chartData);
			mainMap.put("chartTitle", chartTitle);
			mainMap.put("x_axis", x_axis);
			mainMap.put("y_axis", y_axis);
			//System.out.println("data = "+mainMap);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		return mainMap;
	}
	
	@Override
	public Map<String, Object> getAccountMasterDataView1(String userCode,String userRole, String remoteAddr, String moduleType) {
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		int noOfResultSet = getNoOfINOUTParam(procedureName);
		//System.out.println(" module type ="+moduleType+"  pro name = "+procedureName+ "  no of o/p = "+noOfResultSet);
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Map<String, Object> chartData = new LinkedHashMap<String, Object>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; ResultSet resultSet2 = null;
		String colNames = "";
		String chartTitle = "";
		String x_axis = "";
		String y_axis = "";
		
		String sql = "{CALL "+procedureName+"( :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, ";
		for(int i = 2; i <= noOfResultSet; i++){
			if(i == noOfResultSet)
				sql = sql + ":RESULTSET"+i+" ";
			else
				sql = sql + ":RESULTSET"+i+", ";
		}
		sql = sql + ")}";
	//	System.out.println(sql);
		try{
			callableStatement = connection.prepareCall(sql);
			
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("GROUPCODE", userRole);
			callableStatement.setString("IPADDRESS", remoteAddr);
			
			callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
		
			for(int i = 2; i <= noOfResultSet; i++){
				String indexName = "RESULTSET"+i;
				callableStatement.registerOutParameter(indexName, OracleTypes.CURSOR);
			}
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject("RESULTSET1");
			if(resultSet1.next()){
				colNames = resultSet1.getString("COLNAMES");
				chartTitle = resultSet1.getString("CHARTTITLE");
				x_axis = resultSet1.getString("XAXIS");
				y_axis = resultSet1.getString("YAXIS");	
			}
			//System.out.println("col names  = "+colNames);
			List<String> colNameList = Arrays.asList(CommonUtil.splitString(colNames, "^~^"));
			for(int i = 2; i <= noOfResultSet; i++){
				ResultSet resultSet = (ResultSet) callableStatement.getObject("RESULTSET"+i);
				chartData.put(colNameList.get(i-2),manageDataFormTwo(colNameList.get(i-2),resultSet));
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		mainMap.put("chartData", chartData);
		mainMap.put("chartTitle", chartTitle);
		mainMap.put("x_axis", x_axis);
		mainMap.put("y_axis", y_axis);
		return mainMap;
	}
	
	
	
	@Override
	public Map<String, Object> getKeyValueData(String userCode,String userRole, String remoteAddr, String moduleType) {
		
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		int noOfResultSet = getNoOfINOUTParam(procedureName);
		System.out.println(" module type ="+moduleType+"  pro name = "+procedureName+ "  no of o/p = "+noOfResultSet);
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		List<Map<String, String>> chartData = new ArrayList<Map<String,String>>();
		List<String> colNameList = new ArrayList<String>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; ResultSet resultSet2 = null;
		String colNames = "";
		String chartTitle = "";
		String x_axis = "";
		String y_axis = "";
		
		String sql = "{CALL "+procedureName+"( :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, ";
		for(int i = 2; i <= noOfResultSet; i++){
			if(i == noOfResultSet)
				sql = sql + ":RESULTSET"+i+" ";
			else
				sql = sql + ":RESULTSET"+i+", ";
		}
		sql = sql + ")}";
	//	System.out.println(sql);
		try{
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("GROUPCODE", userRole);
			callableStatement.setString("IPADDRESS", remoteAddr);
			callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
			for(int i = 2; i <= noOfResultSet; i++){
				String indexName = "RESULTSET"+i;
				callableStatement.registerOutParameter(indexName, OracleTypes.CURSOR);
			}
			callableStatement.execute();
			resultSet1 = (ResultSet) callableStatement.getObject("RESULTSET1");
			if(resultSet1.next()){
				colNames = resultSet1.getString("COLNAMES");
				chartTitle = resultSet1.getString("CHARTTITLE");
				x_axis = resultSet1.getString("XAXIS");
				y_axis = resultSet1.getString("YAXIS");	
			}
			//System.out.println("col names  = "+colNames);
			colNameList = Arrays.asList(CommonUtil.splitString(colNames, "^~^"));
			for(int i = 2; i <= noOfResultSet; i++){
				ResultSet resultSet = (ResultSet) callableStatement.getObject("RESULTSET"+i);
				ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
				while(resultSet.next()){
					Map<String, String> dataMap = new LinkedHashMap<String, String>();
					for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
						String columnName = resultSetMetaData.getColumnName(colIndex);
						dataMap.put(columnName, resultSet.getString(columnName));
					}
					chartData.add(dataMap);
				}
				resultSet = null;
				resultSetMetaData = null;
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		mainMap.put("chartData", chartData);
		mainMap.put("chartTitle", chartTitle);
		mainMap.put("ColumnName",colNameList);
		mainMap.put("x_axis", x_axis);
		mainMap.put("y_axis", y_axis);
		//System.out.println(mainMap);
		return mainMap;
	}
	
	
	@Override
	public Map<String, Object> getUserStatsData(String userCode,String userRole, String remoteAddr, String moduleType) {
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		int noOfResultSet = getNoOfINOUTParam(procedureName);
		//System.out.println(" module type ="+moduleType+"  pro name = "+procedureName+ "  no of o/p = "+noOfResultSet);
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Map<String, Object> chartData = new LinkedHashMap<String, Object>();
		List<String> colNameList = new ArrayList<String>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; ResultSet resultSet2 = null;
		String colNames = "";
		String chartTitle = "";
		String x_axis = "";
		String y_axis = "";
		
		String sql = "{CALL "+procedureName+"( :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, ";
		for(int i = 2; i <= noOfResultSet; i++){
			if(i == noOfResultSet)
				sql = sql + ":RESULTSET"+i+" ";
			else
				sql = sql + ":RESULTSET"+i+", ";
		}
		sql = sql + ")}";
	//	System.out.println(sql);
		try{
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("GROUPCODE", userRole);
			callableStatement.setString("IPADDRESS", remoteAddr);
			
			callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
		
			for(int i = 2; i <= noOfResultSet; i++){
				String indexName = "RESULTSET"+i;
				callableStatement.registerOutParameter(indexName, OracleTypes.CURSOR);
			}
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject("RESULTSET1");
			if(resultSet1.next()){
				colNames = resultSet1.getString("COLNAMES");
				chartTitle = resultSet1.getString("CHARTTITLE");
				x_axis = resultSet1.getString("XAXIS");
				y_axis = resultSet1.getString("YAXIS");	
			}
			//System.out.println("col names  = "+colNames);
			colNameList = Arrays.asList(CommonUtil.splitString(colNames, "^~^"));
			
			for(int i = 2; i <= noOfResultSet; i++){
				resultSet2 = (ResultSet) callableStatement.getObject("RESULTSET"+i);
				while(resultSet2.next()){
					ArrayList<String> rowValues = new ArrayList<String>();
					for(int j = 0;j<colNameList.size() ;j++ ){
						rowValues.add(resultSet2.getString(colNameList.get(j)));
				}
					chartData.put(resultSet2.getString(1),rowValues);
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
		}
		mainMap.put("chartData", chartData);
		mainMap.put("chartTitle", chartTitle);
		mainMap.put("ColumnName",colNameList);
		mainMap.put("x_axis", x_axis);
		mainMap.put("y_axis", y_axis);
		return mainMap;
	}

	
	
	
	
	public int getNoOfINOUTParam(String procedureName){
		int count = 0 ;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT COUNT(IN_OUT) COUNT FROM USER_ARGUMENTS WHERE OBJECT_NAME = ? AND IN_OUT = ?");
			preparedStatement.setString(1, procedureName);
			preparedStatement.setString(2, "IN/OUT");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				count = resultSet.getInt("COUNT");
		}catch(Exception e){
			e.printStackTrace();
		}
		return count;
	}
	
	
	
	

	
	private Map<String, String> manageDataFormOne(ResultSet resultSet) throws SQLException{
		Map<String, String> map = new LinkedHashMap<String, String>();
		ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
		
		int columnsNumber = resultSetMetaData.getColumnCount();
		while(resultSet.next()){
			String columnName = resultSetMetaData.getColumnName(2);
			map.put(resultSet.getString(columnName), resultSet.getString("COUNT"));
		}
		return map;
	}
	
	
	
	// 
	private ArrayList<String> manageDataFormTwo(String columnName, ResultSet resultSet) throws SQLException{
		ArrayList<String> data = new ArrayList<String>();
		while(resultSet.next()){
			data.add(resultSet.getString(columnName));
		}
		return data;
	}
		
	
	
	
	
	
	/*@Override
	public Map<String, Object> getGraphDetails(String columnName,String columnValue, String moduleType, String userCode, String userRole,String remoteAddr) {
		Map<String, Object> resultMap = new HashMap<String, Object>();		
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		//System.out.println("module type="+moduleType+" col name = "+columnName+"  col value = "+columnValue );
		String procedureName = getProcedureName("DETAILPROCEDURENAME", moduleType);
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String queryString = "";
		System.out.println(" module type ="+moduleType+"  pro name get Details = "+procedureName);
							
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+procedureName+"(?,?,?,?,?,?)}");
			callableStatement.setString(1, columnName);
			callableStatement.setString(2, columnValue);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, remoteAddr);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);  
			callableStatement.execute();
			 resultSet = (ResultSet) callableStatement.getObject(6);
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(CommonUtil.changeColumnName(colname));
			}
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName1 = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName1, resultSet.getString(columnName1));
				}
				mainList.add(dataMap);
			}
			resultMap.put("HEADER", headers);
			resultMap.put("DATA", mainList);
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, preparedStatement,resultSet,null);		
		}
		
		//System.out.println(resultMap);
		return resultMap;
	}*/
	
	
	private String getProcedureName(String columnName, String moduleType){
		String procName = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+columnName+" PROCNAME FROM TB_MASTERMODULESEARCHCONFIG WHERE MODULECODE = ?");
			preparedStatement.setString(1, moduleType);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				procName = resultSet.getString("PROCNAME");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return procName;
	}

	@Override
	public List<Map<String, String>> savingAccGraphicalMaster(String userCode,String userRole, String remoteAddr) {
		
		List<Map<String, String>> dataList = new ArrayList<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			//for currency
			String query = " SELECT * FROM "+schemaName+"TB_FIXEDDEPOSIT ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
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
	public Map<String, Object> searchPendingCases(Map<String, String> paramMap,String moduleType, String userCode, String userRole,String ipAddress) {
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		// System.out.println(moduleType+" "+procedureName);
		Iterator<String> itr = paramMap.keySet().iterator();
		String sql = prepareProcedureName(procedureName, paramMap);
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new ArrayList<String>();
		List<Map<String, String>> chartData = new ArrayList<Map<String,String>>();
		
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall(sql);
			while(itr.hasNext()){
				String paramName = itr.next();
				String paramValue = paramMap.get(paramName);
				callableStatement.setString(paramName, paramValue);
			}
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("ROLECODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(resultSetMetaData.getColumnName(colIndex));
			}
			
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
				chartData.add(dataMap);
			}
			
		resultData.put("chartData",chartData);
		resultData.put("columnName", header);
		resultData.put("charTitle","Pending Cases");
		
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return resultData;
		
	}
	
	private String prepareProcedureName(String procedureName, Map<String, String> paramMap){
		Iterator<String> itr = paramMap.keySet().iterator();
		String finalProcedureName = "{CALL "+procedureName+"(";
		while(itr.hasNext()){
			finalProcedureName = finalProcedureName + ":"+itr.next()+",";
		}
		finalProcedureName = finalProcedureName + ":USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
		return finalProcedureName;
	}

	@Override
	public Map<String, Object> customerPeerGroup(Map<String, String> paramMap,String moduleType,String userCode, String userRole, String remoteAddr) {
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		//System.out.println("module type = "+moduleType+"  params = "+paramMap+"  procedure name = "+procedureName);
		int noOfResultSet = getNoOfINOUTParam(procedureName);
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; 
		String colNames = "";
		String chartTitle = "";
		String x_axis = "";
		String y_axis = "";
		
		String sql = "{CALL "+procedureName+"( :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, ";
		for(int i = 2; i <= noOfResultSet; i++){
			if(i == noOfResultSet)
				sql = sql + ":RESULTSET"+i+" ";
			else
				sql = sql + ":RESULTSET"+i+", ";
		}
		sql = sql + ")}";
		//System.out.println(sql);
		try{
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("GROUPCODE", userRole);
			callableStatement.setString("IPADDRESS", remoteAddr);
			callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
			
			for(int i = 2; i <= noOfResultSet; i++){
				String indexName = "RESULTSET"+i;
				callableStatement.registerOutParameter(indexName, OracleTypes.CURSOR);
			}
			callableStatement.execute();
			resultSet1 = (ResultSet) callableStatement.getObject("RESULTSET1");
			if(resultSet1.next()){
				colNames = resultSet1.getString("COLNAMES");
				chartTitle = resultSet1.getString("CHARTTITLE");
				x_axis = resultSet1.getString("XAXIS");
				y_axis = resultSet1.getString("YAXIS");
			}
			//System.out.println("col names  = "+colNames);
			List<String> colNameList = Arrays.asList(CommonUtil.splitString(colNames, "^~^"));
			ResultSet resultSet = (ResultSet) callableStatement.getObject("RESULTSET2");
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			Map<String, ArrayList<Map<String,String>>> customersMap = new LinkedHashMap<String, ArrayList<Map<String,String>>>();
			ArrayList<Map<String,String>> customerValue = new ArrayList<Map<String,String>>();
			List<Map<String,String>> dcChartData = new ArrayList<Map<String,String>>();
			while(resultSet.next()){
				if(!customersMap.containsKey(resultSet.getString("TRANSACTIONTYPE")))
					customerValue = new ArrayList<Map<String,String>>();
				Map<String, String> rowData = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					rowData.put(columnName, resultSet.getString(columnName));
				}
				customerValue.add(rowData);
				//dcChartData.add(rowData);
				customersMap.put(resultSet.getString("TRANSACTIONTYPE"), customerValue);
			}
			
			//mainMap.put("dcChartData", dcChartData);
			mainMap.put("chartData", customersMap);
			mainMap.put("columnName", colNameList);
			mainMap.put("chartTitle", chartTitle);
			mainMap.put("x_axis", x_axis);
			mainMap.put("y_axis", y_axis);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		return mainMap;
	}

	@Override
	public Map<String, Object> getCustomerPeerGroupDetail(Map<String, String> paramMap, String moduleType, String userCode,String userRole, String ipAdress) {
		//System.out.println("customer id = "+ paramMap.get("CUSTOMERID") +" time = "+paramMap.get("x"));
		String procedureName = getProcedureName("DETAILPROCEDURENAME", moduleType);
		Map<String, Object> mainMap = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<Map<String, String>> data = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+procedureName+"(?,?,?,?,?,?)}");
			callableStatement.setString(1, userCode);
			callableStatement.setString(2, userRole);
			callableStatement.setString(3, ipAdress);
			callableStatement.setString(4, paramMap.get("CUSTOMERID"));
			callableStatement.setString(5, paramMap.get("x"));
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);  
			callableStatement.execute();
			 resultSet = (ResultSet) callableStatement.getObject(6);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(resultSetMetaData.getColumnName(colIndex));
			}
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String colName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(colName, resultSet.getString(colName));
				}
				data.add(dataMap);
			}
			mainMap.put("HEADER", header);
			mainMap.put("DATA", data);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return mainMap;
	}

	
	

	

}
