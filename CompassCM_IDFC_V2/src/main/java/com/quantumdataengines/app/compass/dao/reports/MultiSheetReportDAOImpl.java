package com.quantumdataengines.app.compass.dao.reports;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class MultiSheetReportDAOImpl implements MultiSheetReportDAO{
	private static final Logger log = LoggerFactory.getLogger(MultiSheetReportDAOImpl.class);
	private Connection connection = null;
	@Autowired
	private ConnectionUtil connectionUtil;
	

	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : MultiSheetReportDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public Map<String, Object> getExtractionLog(String fromDate, String toDate, String logType, String status){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		Connection connection = getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		Map<String, ResultSet> resultSetMap = new HashMap<String, ResultSet>();
		
		try{
			callableStatement = connection.prepareCall("{CALL STP_ETLDASHBOARDREPORT(?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, logType);
			callableStatement.setString(4, status);
			callableStatement.registerOutParameter(5, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();
			resultSetMap.put("ETLSummaryDetails", (ResultSet)callableStatement.getObject(5));
			resultSetMap.put("ETLBreakUpDetails", (ResultSet)callableStatement.getObject(6));
			
			Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				resultSet = resultSetMap.get(sheetName);
				
				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();
				
		    	ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		    	ArrayList<String> eachHeader = new ArrayList<String>();
		    	for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    		eachHeader.add(resultSetMetaData.getColumnName(i));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		ArrayList<String> eachRecord = new ArrayList<String>();
		    		for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    			eachRecord.add(resultSet.getString(i));
		    		}
		    		resultList.add(eachRecord);
		    	}
		    	
		    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new HashMap<String, ArrayList<ArrayList<String>>>();
		    	innerMap.put("listResultHeader", headerList);
		    	innerMap.put("listResultData", resultList);
		    	mainMap.put(sheetName, innerMap);
			}
		}catch(Exception e){
			log.error("Error while getting log : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return mainMap;
	}
}
