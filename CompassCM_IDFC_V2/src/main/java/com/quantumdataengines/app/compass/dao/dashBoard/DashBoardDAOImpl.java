package com.quantumdataengines.app.compass.dao.dashBoard;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
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
public class DashBoardDAOImpl implements DashBoardDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
	    
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
    public Map<String, Object> getDashBoardInTabView(String fromDate, String toDate, String userCode, String userRole, String sourceSystem){
	Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
	Connection connection = null;
	CallableStatement callableStatement = null;
    ResultSet tabNameResultSet = null;
	Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
	String[] arrTabName = null;
	try{
		connection = connectionUtil.getConnection();
		if(userCode.indexOf("FATCA") > -1)
    		callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_FATCADASHBOARD_SUMMARYDATA(?,?,?,?,?,?,?,?,?,?,?)}");
        else
        	callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_DASHBOARD_NEW_SUMMARYDATA(?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, sourceSystem);
            callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
            
            tabNameResultSet = (ResultSet)callableStatement.getObject(6);
            if(tabNameResultSet.next()){
            	arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
            }
            
            for(int i = 0; i < arrTabName.length; i++){
            	int resultSetInedx = i+7;
            	resultSetMap.put(arrTabName[i], (ResultSet)callableStatement.getObject(resultSetInedx));
            }
            
            Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				// System.out.println("Sheet Name : "+sheetName);
				ResultSet resultSet = resultSetMap.get(sheetName);
				
				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();
				
		    	ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		    	ArrayList<String> eachHeader = new ArrayList<String>();
		    	for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    		eachHeader.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(i)));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		ArrayList<String> eachRecord = new ArrayList<String>();
		    		for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    			eachRecord.add(resultSet.getString(i));
		    		}
		    		resultList.add(eachRecord);
		    	}
		    	
		    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new LinkedHashMap<String, ArrayList<ArrayList<String>>>();
		    	innerMap.put("listResultHeader", headerList);
		    	innerMap.put("listResultData", resultList);
		    	mainMap.put(sheetName, innerMap);
			}
	}catch(Exception e){
		e.printStackTrace();
	}finally{
		connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
	}
	//System.out.println("mainMap in DAO = "+mainMap);
	return mainMap;
    }
    
    public Map<String, Object> getSwiftDashBoardInTabView(String fromDate, String toDate, String userCode, String userRole, String messageFlowType){
    	Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETSWIFTDASHBOARDDATA(?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, messageFlowType);
            callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.execute();
	            
            tabNameResultSet = (ResultSet)callableStatement.getObject(6);
            if(tabNameResultSet.next()){
            	arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
            }
            
            for(int i = 0; i < arrTabName.length; i++){
            	int resultSetInedx = i+7;
            	resultSetMap.put(arrTabName[i], (ResultSet)callableStatement.getObject(resultSetInedx));
            }
            
            Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				// System.out.println("Sheet Name : "+sheetName);
				ResultSet resultSet = resultSetMap.get(sheetName);
				
				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();
				
		    	ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		    	ArrayList<String> eachHeader = new ArrayList<String>();
		    	for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    		eachHeader.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(i)));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		ArrayList<String> eachRecord = new ArrayList<String>();
		    		for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    			eachRecord.add(resultSet.getString(i));
		    		}
		    		resultList.add(eachRecord);
		    	}
			    	
	    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new LinkedHashMap<String, ArrayList<ArrayList<String>>>();
	    	innerMap.put("listResultHeader", headerList);
	    	innerMap.put("listResultData", resultList);
	    	mainMap.put(sheetName, innerMap);
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);		}
		return mainMap;
    }

    public Map<String, Object> getMISReportTabView(String fromDate, String toDate, String userCode, String reportFrequency){
    	Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
    	Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETMISREPORTDATA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, reportFrequency);
            callableStatement.registerOutParameter(5, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(13, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(14, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(15, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(16, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(17, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(18, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(19, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(20, oracle.jdbc.OracleTypes.CURSOR);

            callableStatement.execute();
	            
            tabNameResultSet = (ResultSet)callableStatement.getObject(5);
            if(tabNameResultSet.next()){
            	arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
            }
            
            for(int i = 0; i < arrTabName.length; i++){
            	int resultSetInedx = i+6;
            	resultSetMap.put(arrTabName[i], (ResultSet)callableStatement.getObject(resultSetInedx));
            }
            
            Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				// System.out.println("Sheet Name : "+sheetName);
				ResultSet resultSet = resultSetMap.get(sheetName);
				
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
		    	
	    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new LinkedHashMap<String, ArrayList<ArrayList<String>>>();
	    	innerMap.put("listResultHeader", headerList);
	    	innerMap.put("listResultData", resultList);
	    	mainMap.put(sheetName, innerMap);
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
		}
		return mainMap;
    }
    
    @Override
	public List<Map<String, Object>> getTotalAmluserWiseRecordStats(String fromDate, String toDate,
    		String sourceSystem, String userCode, String userRole, String ipAddress) {
		List<Map<String, Object>> mainList = new Vector<Map<String,Object>>();
		Map<String, Object> userSummaryMap = new LinkedHashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETAMLUSERSSUMMARYRECORDS(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, sourceSystem);
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userRole);
			callableStatement.setString(6, ipAddress);
			callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            
            callableStatement.execute();
			resultSet = (ResultSet)callableStatement.getObject(7);
			ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
					if(!resultSetMetaData.getColumnName(i).equals("AMLUSERCODE")){
						dataMap.put(resultSetMetaData.getColumnName(i), resultSet.getString(resultSetMetaData.getColumnName(i)));
						
					}else{
						userSummaryMap.put(resultSet.getString("AMLUSERCODE"),dataMap);
					}
		    	}
			}
			mainList.add(userSummaryMap);
			
		}catch(Exception e){
			e.printStackTrace();	
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);		
		}
		return mainList;
		
	}

}
