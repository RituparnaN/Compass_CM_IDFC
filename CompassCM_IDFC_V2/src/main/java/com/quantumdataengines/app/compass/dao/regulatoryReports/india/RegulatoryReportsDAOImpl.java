package com.quantumdataengines.app.compass.dao.regulatoryReports.india;

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
import java.util.Vector;

import oracle.jdbc.OracleTypes;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class RegulatoryReportsDAOImpl implements RegulatoryReportsDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
		
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	private static final Logger log = LoggerFactory.getLogger(INDSTRDAOImpl.class);
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : STRTemplateDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}

	public String generateRegReportData(String reportType, String reportMonth, String reportYear, String userCode) {
		Connection connection = null;
	    CallableStatement callableStatement = null;
	    String l_strMessage = ""; 
	    try {
	        connection = getConnection();
	        callableStatement = connection.prepareCall("{CALL STP_GENERATEREGREPORTDATA(?,?,?,?)}");
	        callableStatement.setString(1, reportType);
	        callableStatement.setString(2, reportMonth);
	        callableStatement.setString(3, reportYear);
	        callableStatement.setString(4, userCode);
	        callableStatement.execute();
	        l_strMessage = "Data for "+reportType+" has been generated.";
	    } catch(Exception e) {
	    	l_strMessage = "Error occured during data generation for "+reportType;
	    	log.error("Error in generating generic data for "+reportType+" : "+e.getMessage());
	    	e.printStackTrace();
	    }finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
	    }
		return l_strMessage;
	   
	    }

   	public String generateReportXML(String reportType, String reportMonth, String reportYear, String reportFile, String batchType, String originalBatchID, String reasonOfRevision, String noOfLines, String userCode)
   	{
   		Connection connection = null;
        CallableStatement callableStatement = null;
        String l_strMessage = ""; 
        try {
            connection = getConnection();
            callableStatement = connection.prepareCall("{CALL STP_GENERATEREPORTXML(?,?,?,?,?,?,?,?,?)}");
            callableStatement.setString(1, reportType);
            callableStatement.setString(2, reportMonth);
            callableStatement.setString(3, reportYear);
            callableStatement.setString(4, reportFile);
            callableStatement.setString(5, batchType);
            callableStatement.setString(6, originalBatchID);
            callableStatement.setString(7, reasonOfRevision);
            callableStatement.setString(8, noOfLines);
            callableStatement.setString(9, userCode);
            callableStatement.execute();
            l_strMessage = "XML for "+reportType+" has been generated in the Server.";
        } catch(Exception e) {
        	l_strMessage = "Error occured during XML generation for "+reportType;
        	log.error("Error in generating generic report xml for "+reportType+" : "+e.getMessage());
        	e.printStackTrace();
        }finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
        }
    	return l_strMessage;
    }
   	
   	@Override
	public Map<String, Object> generateRegulatoryExceptionFile(Map<String, String> paramMap) {
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
    	Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		//System.out.println("PARAMS = "+paramMap.get("ReportingMonth")+"---"+paramMap.get("ReportingYear")+"---"+paramMap.get("ReportType"));
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL STP_GENERATEEXCEPTION_RP(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, paramMap.get("ReportingMonth"));
			callableStatement.setString(2, paramMap.get("ReportingYear"));
			callableStatement.setString(3, paramMap.get("ReportType"));
			callableStatement.setString(4, paramMap.get("UserCode"));
			callableStatement.setString(5, paramMap.get("UserRole"));
			callableStatement.setString(6, paramMap.get("IPAdress"));
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
            callableStatement.registerOutParameter(21, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(22, oracle.jdbc.OracleTypes.CURSOR);

            callableStatement.execute();
	            
            tabNameResultSet = (ResultSet)callableStatement.getObject(7);
            if(tabNameResultSet.next()){
            	arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
            }
            
            for(int i = 0; i < arrTabName.length; i++){
            	int resultSetInedx = i+8;
            	resultSetMap.put(arrTabName[i], (ResultSet)callableStatement.getObject(resultSetInedx));
            }
            
            Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				ResultSet resultSet = resultSetMap.get(sheetName);
				
				List<List<String>> headerList = new ArrayList<List<String>>();
				List<List<String>> resultList = new ArrayList<List<String>>();
				
		    	ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		    	List<String> eachHeader = new ArrayList<String>();
		    	for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    		eachHeader.add(resultSetMetaData.getColumnName(i));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		List<String> eachRecord = new ArrayList<String>();
		    		for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    			eachRecord.add(resultSet.getString(i));
		    		}
		    		resultList.add(eachRecord);
		    }
				HashMap<String, List<List<String>>> innerMap = new LinkedHashMap<String, List<List<String>>>();
				innerMap.put("listResultHeader", headerList);
				innerMap.put("listResultData", resultList);
				mainMap.put(sheetName, innerMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
		}
		// System.out.println("STP_GENERATEEXCEPTION_RP result = "+mainMap);
		return mainMap;
	}

	@Override
	public Map<String, Object> downloadRegulatoryExcel(Map<String, String> paramMap) {
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		
		try {
			connection = connectionUtil.getConnection();
			callableStatement = connection
					.prepareCall("{CALL "+schemaName+"STP_RP_REGULATORYREPORTFILES(?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, paramMap.get("ReportingMonth"));
			callableStatement.setString(2, paramMap.get("ReportingYear"));
			callableStatement.setString(3, paramMap.get("ReportType"));
			callableStatement.setString(4, paramMap.get("UserCode"));
			callableStatement.setString(5, paramMap.get("UserRole"));
			callableStatement.setString(6, paramMap.get("IPAdress"));
			callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.registerOutParameter(13, oracle.jdbc.OracleTypes.CURSOR);
			callableStatement.execute();

			tabNameResultSet = (ResultSet) callableStatement.getObject(7);
			if (tabNameResultSet.next()) {
				arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
			}

			for (int i = 0; i < arrTabName.length; i++) {
				int resultSetInedx = i + 8;
				resultSetMap.put(arrTabName[i], (ResultSet) callableStatement.getObject(resultSetInedx));
			}

			Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				ResultSet resultSet = resultSetMap.get(sheetName);

				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();

				ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
				ArrayList<String> eachHeader = new ArrayList<String>();
				for (int i = 1; i <= resultSetMetaData.getColumnCount(); i++) {
					eachHeader.add(resultSetMetaData.getColumnName(i));
				}
				headerList.add(eachHeader);

				while (resultSet.next()) {
					ArrayList<String> eachRecord = new ArrayList<String>();
					for (int i = 1; i <= resultSetMetaData.getColumnCount(); i++) {
						eachRecord.add(resultSet.getString(i));
					}
					resultList.add(eachRecord);
				}

				HashMap<String, ArrayList<ArrayList<String>>> innerMap = new LinkedHashMap<String, ArrayList<ArrayList<String>>>();
				innerMap.put("listResultHeader", headerList);
				innerMap.put("listResultData", resultList);
				mainMap.put(sheetName, innerMap);
			}
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
		}
		//System.out.println("mainMap = "+mainMap);
		return mainMap;
	}
	
 // GENERATED CTR FILES
 	@Override
 	public Map<String, Object> viewGeneratedCTRFilesMaster(String reportingMonth, String reportingYear, String moduleType,String userCode, String userRole, String ipAdress) {
 		Map<String, Object> resultData = new HashMap<String, Object>();
 		List<String> header = new Vector<String>();
 		List<List<String>> data = new Vector<List<String>>();
 		Connection connection = connectionUtil.getConnection();
 		CallableStatement callableStatement = null;
 		ResultSet resultSet = null;
 		try{
 			connection = connectionUtil.getConnection();
 			callableStatement = connection.prepareCall("{CALL STP_GENERATECTRFILES(?,?,?,?,?,?)}");
 			callableStatement.setString(1, reportingMonth);
 			callableStatement.setString(2, reportingYear);
 			callableStatement.setString(3, userCode);
 			callableStatement.setString(4, userRole);
 			callableStatement.setString(5, ipAdress);
 			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);  
 			callableStatement.execute();
 			resultSet = (ResultSet) callableStatement.getObject(6);
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
 			System.out.println("ctr file result data ="+resultData);
 		}catch(Exception e){
 			e.printStackTrace();
 		}finally{
 			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
 		}
 		return resultData;
 	}

 	@Override
 	public String updateCTRDetails(Map<String, String> paramMap,
 			String userCode, String selectedFileSeq) {
 		String response = "" ;
 		Connection connection = connectionUtil.getConnection();
 		
 		PreparedStatement preparedStatement = null;
 		ResultSet resultSet = null;
 		
 		try{
 			String sql =  " UPDATE "+schemaName+"TB_CTR_GENERATEDFILES SET FIUREFERENCENO = ?, "+
 						  " FIUREMARKS = ?, "+
 						  " UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+
 						  "	WHERE FILESEQUENCENO = ? ";
 					preparedStatement = connection.prepareStatement(sql);
 					preparedStatement.setString(1, paramMap.get("FIUREFERENCENO"));
 					preparedStatement.setString(2, paramMap.get("FIUREMARKS"));
 					preparedStatement.setString(3, userCode);
 					preparedStatement.setString(4, selectedFileSeq);
 					preparedStatement.executeUpdate();
 					response ="Successfully updated.";
 					
 		}catch(Exception e){
 			response="Error while Updating CTR Files.";
 			
 			e.printStackTrace();
 		}finally{
 			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
 		}
 		return response;
 	}
 	
 	
 	// GENERATED NTR FILES
 	@Override
 	public Map<String, Object> viewGeneratedNTRFilesMaster(String reportingMonth, String reportingYear, String moduleType,String userCode, String userRole, String ipAdress) {
 		Map<String, Object> resultData = new HashMap<String, Object>();
 		List<String> header = new Vector<String>();
 		List<List<String>> data = new Vector<List<String>>();
 		Connection connection = connectionUtil.getConnection();
 		CallableStatement callableStatement = null;
 		ResultSet resultSet = null;
 		try{
 			connection = connectionUtil.getConnection();
 			callableStatement = connection.prepareCall("{CALL STP_GENERATENTRFILES(?,?,?,?,?,?)}");
 			callableStatement.setString(1, reportingMonth);
 			callableStatement.setString(2, reportingYear);
 			callableStatement.setString(3, userCode);
 			callableStatement.setString(4, userRole);
 			callableStatement.setString(5, ipAdress);
 			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);  
 			callableStatement.execute();
 			resultSet = (ResultSet) callableStatement.getObject(6);
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
 			System.out.println("ntr file result data ="+resultData);
 		}catch(Exception e){
 			e.printStackTrace();
 		}finally{
 			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
 		}
 		return resultData;
 	}

 	@Override
 	public String updateNTRDetails(Map<String, String> paramMap,
 			String userCode, String selectedFileSeq) {
 		String response = "" ;
 		Connection connection = connectionUtil.getConnection();
 		
 		PreparedStatement preparedStatement = null;
 		ResultSet resultSet = null;
 		
 		try{
 			String sql =  " UPDATE "+schemaName+"TB_NTR_GENERATEDFILES SET FIUREFERENCENO = ?, "+
 						  " FIUREMARKS = ?, "+
 						  " UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+
 						  "	WHERE FILESEQUENCENO = ? ";
 					preparedStatement = connection.prepareStatement(sql);
 					preparedStatement.setString(1, paramMap.get("FIUREFERENCENO"));
 					preparedStatement.setString(2, paramMap.get("FIUREMARKS"));
 					preparedStatement.setString(3, userCode);
 					preparedStatement.setString(4, selectedFileSeq);
 					preparedStatement.executeUpdate();
 					response ="Successfully updated.";
 					
 		}catch(Exception e){
 			response="Error while Updating NTR Files.";
 			
 			e.printStackTrace();
 		}finally{
 			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
 		}
 		return response;
 	}
 	
 	
 	// GENERATED CBWTR FILES
 	@Override
 	public Map<String, Object> viewGeneratedCBWTRFilesMaster(String reportingMonth, String reportingYear, String moduleType,String userCode, String userRole, String ipAdress) {
 		Map<String, Object> resultData = new HashMap<String, Object>();
 		List<String> header = new Vector<String>();
 		List<List<String>> data = new Vector<List<String>>();
 		Connection connection = connectionUtil.getConnection();
 		CallableStatement callableStatement = null;
 		ResultSet resultSet = null;
 		try{
 			connection = connectionUtil.getConnection();
 			callableStatement = connection.prepareCall("{CALL STP_GENERATECBWTRFILES(?,?,?,?,?,?)}");
 			callableStatement.setString(1, reportingMonth);
 			callableStatement.setString(2, reportingYear);
 			callableStatement.setString(3, userCode);
 			callableStatement.setString(4, userRole);
 			callableStatement.setString(5, ipAdress);
 			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);  
 			callableStatement.execute();
 			resultSet = (ResultSet) callableStatement.getObject(6);
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
 			System.out.println("cbwtr file result data ="+resultData);
 		}catch(Exception e){
 			e.printStackTrace();
 		}finally{
 			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
 		}
 		return resultData;
 	}

 	@Override
 	public String updateCBWTRDetails(Map<String, String> paramMap,
 			String userCode, String selectedFileSeq) {
 		String response = "" ;
 		Connection connection = connectionUtil.getConnection();
 		
 		PreparedStatement preparedStatement = null;
 		ResultSet resultSet = null;
 		
 		try{
 			String sql =  " UPDATE "+schemaName+"TB_CBWTR_GENERATEDFILES SET FIUREFERENCENO = ?, "+
 						  " FIUREMARKS = ?, "+
 						  " UPDATEDBY = ?, UPDATEDTIMESTAMP = SYSTIMESTAMP "+
 						  "	WHERE FILESEQUENCENO = ? ";
 					preparedStatement = connection.prepareStatement(sql);
 					preparedStatement.setString(1, paramMap.get("FIUREFERENCENO"));
 					preparedStatement.setString(2, paramMap.get("FIUREMARKS"));
 					preparedStatement.setString(3, userCode);
 					preparedStatement.setString(4, selectedFileSeq);
 					preparedStatement.executeUpdate();
 					response ="Successfully updated.";
 					
 		}catch(Exception e){
 			response="Error while Updating CBWTR Files.";
 			
 			e.printStackTrace();
 		}finally{
 			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
 		}
 		return response;
 	}

}
