package com.quantumdataengines.app.compass.dao.reports;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import oracle.jdbc.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ScheduledReportDAOImpl implements ScheduledReportDAO{
	
	private static final Logger log = LoggerFactory.getLogger(ScheduledReportDAOImpl.class);
	private Connection connection = null;
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : ScheduledReportDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public List<HashMap<String, Object>> getReportsToGenerate(){
		List<HashMap<String, Object>> mainMap = new ArrayList<HashMap<String, Object>>();
		Connection connection = getConnection();
		CallableStatement callableStatement  = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql = "{CALL "+schemaName+"STP_AUTOREPORTSGENERATION1(?)}";
			callableStatement = connection.prepareCall(sql);
			callableStatement.registerOutParameter(1, OracleTypes.CURSOR);
			callableStatement.executeQuery();
			resultSet = (ResultSet) callableStatement.getObject(1);			
			while(resultSet.next()){
				HashMap<String, Object> reportMap = new HashMap<String, Object>();
				reportMap.put("SEQNO", resultSet.getInt(1));
				reportMap.put("REPORTNAME", resultSet.getString(2));
				reportMap.put("PROCEDURENAME", resultSet.getString(3));
				reportMap.put("NOOFINPUTPARAM", resultSet.getInt(4));
				reportMap.put("INPUTPARAMS", resultSet.getString(5));
				reportMap.put("NOOFOUTPUTPARAM", resultSet.getInt(6));
				mainMap.add(reportMap);
			}
		}catch(Exception e){
			log.error("Error occurred while generating scheduled report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return mainMap;
	}
	
	private String getProcName(String procName, int noOfParams){
		String sql = "{CALL "+schemaName+""+procName;
		if(noOfParams > 0){
			sql = sql+"(";
			for(int i = 1; i <= noOfParams; i++){
				sql = sql+"?";
				if(i != noOfParams){
					sql = sql+",";
				}
			}
			sql = sql+")";
		}
		sql = sql+"}";
		return sql;
	}
	
	public Map<String, Object> getReportData(String reportName, String procName, int noOfInputParam, String inputParams, int noOfOutputParams){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		String[] arrInputParams = CommonUtil.splitString(inputParams, "^~^");
		int totalParams = noOfInputParam+noOfOutputParams;
		String sql = getProcName(procName, totalParams);
		Connection connection = getConnection();
		CallableStatement callableStatement  = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall(sql);
			for(int i = 1; i <= noOfInputParam; i++){
				callableStatement.setString(i, arrInputParams[i-1]);
			}
			for(int i = (noOfInputParam+1); i <= (noOfInputParam+noOfOutputParams); i++){
				callableStatement.registerOutParameter(i, OracleTypes.CURSOR);
			}
			callableStatement.execute();
			int reportIndex = 1;
			for(int i = (noOfInputParam+1); i <= totalParams; i++){
				resultSet = (ResultSet) callableStatement.getObject(i);
				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();
				
		    	ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
		    	ArrayList<String> eachHeader = new ArrayList<String>();
		    	
		    	for(int j = 1; j <= resultSetMetaData.getColumnCount(); j++){
		    		eachHeader.add(resultSetMetaData.getColumnName(j));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		ArrayList<String> eachRecord = new ArrayList<String>();
		    		for(int j = 1; j <= resultSetMetaData.getColumnCount(); j++){
		    			eachRecord.add(resultSet.getString(j));
		    		}
		    		resultList.add(eachRecord);
		    	}
		    	
		    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new HashMap<String, ArrayList<ArrayList<String>>>();
		    	innerMap.put("listResultHeader", headerList);
		    	innerMap.put("listResultData", resultList);
		    	mainMap.put("RreportSheet_"+reportIndex, innerMap);
		    	reportIndex++;
			}
		}catch(Exception e){
			log.error("Error occurred while generating scheduled report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return mainMap;
	}

	public List<Map<String, String>> getAllReportsDetails(String reportGroup) {
		List<Map<String, String>> mainMap = new ArrayList<Map<String, String>>();		
		Connection connection = getConnection();
		PreparedStatement preparedStatement  = null;
		ResultSet resultSet = null;
		try{
			String sql = " SELECT DISTINCT A.REPORTID, A.REPORTNAME, A.SEQNO "+
			             "   FROM "+schemaName+"TB_REPORTDETAILS A "+
			             "  WHERE UPPER(TRIM(A.REPORTTYPE)) = ? "+
			             "    AND ISENABLED = 'Y' "+
			             "  ORDER BY SEQNO ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportGroup.trim().toUpperCase());
			
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> recordDetails = new HashMap<String, String>();
				recordDetails.put("SEQNO", resultSet.getString("SEQNO"));
				recordDetails.put("REPORTNAME", resultSet.getString("REPORTNAME"));
				recordDetails.put("REPORTID", resultSet.getString("REPORTID"));
				mainMap.add(recordDetails);
			}
		}catch(Exception e){
			log.error("Error while fetching all reposrt details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	
	public Map<String, Object> getReportBenchmarkDetails(String reportId){
		String sql = "";
		int headerCount = 0;
		String[] l_Headers = null;
		int val = 0;
		Connection connection = getConnection();
		PreparedStatement preparedStatement  = null;
		ResultSet resultSet = null;
		ArrayList<Map<String, String>> list = new ArrayList<Map<String, String>>();
		Map<String, Object> mainMap = new HashMap<String, Object>();
		try{
			sql = "	SELECT COUNT(*) COUNTVAL "+
			      "   FROM "+schemaName+"TB_REPORTPARAMS A"+
			      "  WHERE A.REPORTID = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next())
				headerCount	= resultSet.getInt("COUNTVAL");
			
			l_Headers=new String[headerCount+1];
			resultSet = null;
			sql = "	SELECT A.REPORTPARAMNAME "+
			  	  "   FROM "+schemaName+"TB_REPORTPARAMS A "+
			  	  "  WHERE A.REPORTID=? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				l_Headers[val] = resultSet.getString("REPORTPARAMNAME");
				val = val+1;
			}
			l_Headers[val] = "USERID";
			
			sql = "	SELECT B.USERID, A.REPORTPARAMINDEX, A.REPORTPARAMNAME, A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE "+
				  "   FROM "+schemaName+"TB_REPORTPARAMS A, "+schemaName+"TB_REPORTPARAMDEFAULTVALUES B "+
				  "  WHERE A.REPORTID = B.REPORTID "+
				  "    AND A.REPORTPARAMNAME = B.REPORTPARAMNAME "+
			      "    AND A.REPORTID = ? "+
			      "  ORDER BY B.USERID, A.REPORTPARAMINDEX ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			resultSet = preparedStatement.executeQuery();
			String userId = "";
			HashMap<String, String> data = null;
			while(resultSet.next()){
				if(!userId.equals("") && resultSet.getString("USERID").equals(userId)){
					data.put(resultSet.getString("REPORTPARAMNAME"),resultSet.getString("PARAMDEFAULTVALUE"));
				} else {
					if(data != null) 
						list.add(data);
					data = new HashMap<String, String>();
					data.put(resultSet.getString("REPORTPARAMNAME"),resultSet.getString("PARAMDEFAULTVALUE"));
					userId = resultSet.getString("USERID");
					data.put("USERID",userId);
				}
			}
			if(data != null)
				list.add(data);
			
			mainMap.put("ReportBenchmarkHeader", l_Headers);
			mainMap.put("ReportBenchMarkList", list);
		}catch(Exception e){
			log.error("Error while fetching all reposrt details : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	
	public Map<String, String> getBenchmarkScheduleDetails(String userId, String reportId){
		Connection connection = getConnection();
		PreparedStatement preparedStatement  = null;
		ResultSet resultSet = null;
		Map<String, String> mainMap = new LinkedHashMap<String, String>();
		String sql = "SELECT B.USERID, A.REPORTPARAMINDEX, A.REPORTPARAMNAME, A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE "+
					 "  FROM "+schemaName+"TB_REPORTPARAMS A, "+schemaName+"TB_REPORTPARAMDEFAULTVALUES B "+
					 " WHERE A.REPORTID = B.REPORTID "+
					 "   AND A.REPORTPARAMNAME = B.REPORTPARAMNAME "+ 
					 "   AND A.REPORTID = ? "+
					 "   AND B.USERID = ? "+
					 " ORDER BY B.USERID, A.REPORTPARAMINDEX ";
		try{
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.setString(2, userId);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				mainMap.put(resultSet.getString("REPORTPARAMNAME"), resultSet.getString("PARAMDEFAULTVALUE"));
			}
			
			sql = "SELECT A.REPORTFREQUENCY, A.REPORTGENERATIONDATES "+
				  "  FROM "+schemaName+"TB_REPORTSCHEDULER A "+
				  " WHERE A.REPORTID = ? "+
				  "   AND A.USERID = ?";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.setString(2, userId);
			resultSet = preparedStatement.executeQuery();
			if (resultSet.next()) {
				mainMap.put("ISREPORTSCHEDULED", "Y");
				mainMap.put("REPORTFREQUENCY", resultSet.getString("REPORTFREQUENCY"));
				mainMap.put("REPORTGENERATIONDATES", resultSet.getString("REPORTGENERATIONDATES"));
			}else{
				mainMap.put("ISREPORTSCHEDULED", "N");
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;
	}
	
	public String saveOrUpdateReportBenchMark(String reportId, String userId, Map<String, String> paramMap){
		String latestUserId = null;
		Connection connection = getConnection();
		PreparedStatement preparedStatement  = null;
		PreparedStatement preparedStatement1 = null;
		PreparedStatement preparedStatement2 = null;
		ResultSet resultSet = null;
		ResultSet resultSet1 = null;
		Map<String, String> mainMap = new LinkedHashMap<String, String>();
		String sql = "SELECT B.USERID, A.REPORTPARAMINDEX, A.REPORTPARAMNAME, A.PARAMFIELDINDEX, B.PARAMDEFAULTVALUE "+
					 "  FROM "+schemaName+"TB_REPORTPARAMS A, "+schemaName+"TB_REPORTPARAMDEFAULTVALUES B "+
					 " WHERE A.REPORTID = ? "+
					 "   AND A.REPORTID = B.REPORTID "+
					 "   AND A.REPORTPARAMNAME = B.REPORTPARAMNAME "+ 
					 "   AND B.USERID = ? "+
					 " ORDER BY B.USERID, A.REPORTPARAMINDEX ";
		
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.setString(2, userId);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				mainMap.put(resultSet.getString("REPORTPARAMNAME"), paramMap.get(resultSet.getString("REPORTPARAMNAME")));
			}
			
			sql = "SELECT A.USERID FROM "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
			      " WHERE UPPER(TRIM(REPORTID)) = ? "+
			      "   AND UPPER(TRIM(USERID)) = ? "+
			      "   AND UPPER(TRIM(USERID)) NOT IN ('DEFAULT') " ;
			
			preparedStatement = connection.prepareStatement(sql);
            preparedStatement.setString(1, reportId.trim().toUpperCase());
            preparedStatement.setString(2, userId.trim().toUpperCase());
            resultSet = preparedStatement.executeQuery();
            if(resultSet.next()){
            	sql = " UPDATE "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
            	      "    SET A.PARAMDEFAULTVALUE = ?, "+
            	      "        A.UPDATETIMESTAMP = SYSTIMESTAMP "+
            	      "  WHERE A.REPORTID = ?  "+
            	      "    AND A.REPORTPARAMNAME = ? "+
            	      "    AND A.USERID = ? "+
            	      "    AND UPPER(USERID) NOT IN ('DEFAULT') ";
                preparedStatement1 = connection.prepareStatement(sql);
                Iterator<String> itr = paramMap.keySet().iterator();
                while (itr.hasNext()) {
					String paramName = itr.next();
					String paramValue = paramMap.get(paramName);
					
					preparedStatement1.setString(1, paramValue);
                    preparedStatement1.setString(2, reportId);
                    preparedStatement1.setString(3, paramName);
                    preparedStatement1.setString(4, userId);
                    preparedStatement1.addBatch();
				}
                preparedStatement1.executeBatch();
                latestUserId = userId;
            }else{
            	sql = " SELECT MAX(A.USERID) "+
            	      "   FROM "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
            	      "  WHERE UPPER(USERID) NOT IN ('DEFAULT') ";
            	preparedStatement1 = connection.prepareStatement(sql);
            	resultSet1 = preparedStatement1.executeQuery();
            	if(resultSet1.next()){
            		latestUserId = new Integer(resultSet1.getInt(1)+1).toString();
            	}
            	sql = " INSERT INTO "+schemaName+"TB_REPORTPARAMDEFAULTVALUES ( "+
            	      "        REPORTID, REPORTPARAMNAME, PARAMDEFAULTVALUE, "+
            	      "        USERID, UPDATETIMESTAMP) "+
            	      "  VALUES(?,?,?,?,SYSTIMESTAMP) ";
            	preparedStatement2 = connection.prepareStatement(sql);
            	Iterator<String> itr = paramMap.keySet().iterator();
                while (itr.hasNext()) {
					String paramName = itr.next();
					String paramValue = paramMap.get(paramName);
					
                    preparedStatement2.setString(1, reportId);
                    preparedStatement2.setString(2, paramName);
					preparedStatement2.setString(3, paramValue);
                    preparedStatement2.setString(4, latestUserId);
                    preparedStatement2.addBatch();
				}
                preparedStatement2.executeBatch();
            }
		}catch(Exception e){
			log.error("Error while saving/updating the benchmark for report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return latestUserId;
	}
	
	public void saveOrUpdateSchedulingDetailsForReport(String userId, String reportId, 
			String schedulingFrequency, String generationDates){
		Connection connection = getConnection();
		PreparedStatement preparedStatement  = null;
		PreparedStatement preparedStatement1  = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql = " SELECT A.USERID "+
			      "   FROM "+schemaName+"TB_REPORTSCHEDULER A "+
			      "  WHERE A.REPORTID = ? "+
			      "    AND A.USERID = ? ";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.setString(2, userId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				sql = " UPDATE "+schemaName+"TB_REPORTSCHEDULER A "+
				      "    SET A.REPORTFREQUENCY = ? , "+
				      "        A.REPORTGENERATIONDATES = ? "+
				      "  WHERE A.REPORTID = ? "+
				      "    AND A.USERID = ? ";
				
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, schedulingFrequency);
				preparedStatement1.setString(2, generationDates);
				preparedStatement1.setString(3, reportId);
				preparedStatement1.setString(4, userId);
				preparedStatement1.executeUpdate();
			}else{
				sql = " INSERT INTO "+schemaName+"TB_REPORTSCHEDULER( "+
				      "        REPORTFREQUENCY,REPORTGENERATIONDATES,REPORTID,USERID) "+
				      "  VALUES(?,?,?,?)";
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, schedulingFrequency);
				preparedStatement1.setString(2, generationDates);
				preparedStatement1.setString(3, reportId);
				preparedStatement1.setString(4, userId);
				preparedStatement1.executeUpdate();
			}
		}catch(Exception e){
			log.error("Error while saving scheduling details for the report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public void deleteScheduling(String userId, String reportId){
		Connection connection = getConnection();
		PreparedStatement preparedStatement  = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql = " DELETE FROM "+schemaName+"TB_REPORTSCHEDULER A "+
			      "  WHERE A.REPORTID = ? "+
			      "    AND A.USERID = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.setString(2, userId);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while deleting scheduling details for the report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}

	public void deleteBenchmark(String userId, String reportId){
		Connection connection = getConnection();
		PreparedStatement preparedStatement  = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql = " DELETE FROM "+schemaName+"TB_REPORTPARAMDEFAULTVALUES A "+
			      "  WHERE A.REPORTID = ?  "+
			      "    AND A.USERID = ? "+
			      "    AND UPPER(A.USERID) NOT IN ('DEFAULT') " ;
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.setString(2, userId);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error while deleting scheduling details for the report : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
}