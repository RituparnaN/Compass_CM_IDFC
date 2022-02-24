package com.quantumdataengines.app.compass.dao.etl.extraction;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.model.ExtractionDBMessage;
import com.quantumdataengines.app.compass.model.ExtractionProcedure;
import com.quantumdataengines.app.compass.schema.Configuration;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ExtractionDAOImpl implements ExtractionDAO{
	
	private static final Logger log = LoggerFactory.getLogger(ExtractionDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Override
	public String getFromDateFromDB() {
		String fromDate = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT NEXTPROCESSEDATE FROM TB_ETL_PROCESSSTATUS WHERE PROCESSNAME = 'ETLPROCESS'";
		try{
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				fromDate = resultSet.getString("NEXTPROCESSEDATE");
		}catch(Exception e){
			log.error("Error while fetching the From Date from Extraction : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return fromDate;
	}
	
	@Override
	public List<ExtractionProcedure> getAllProcedureList(Configuration configuration){
		createLogDump(configuration);
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;		
		List<ExtractionProcedure> procList = new ArrayList<ExtractionProcedure>();
		String sqlQuery = "SELECT GROUP_ID, PROC_NUMBER, PROC_NAME, CASE NVL(INPARALLEL,'N') WHEN 'Y' THEN 'true' ELSE 'false' END AS INPARALLEL, "+
						  " 	  CASE NVL(INENABLED,'N') WHEN 'Y' THEN 'true' ELSE 'false' END AS INENABLED "+
						  "  FROM TB_PROCLIST ORDER BY PROC_NUMBER ASC";
		try{
			preparedStatement = connection.prepareStatement(sqlQuery);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				ExtractionProcedure extractionProcedure = new ExtractionProcedure(resultSet.getInt("GROUP_ID"), 
						resultSet.getInt("PROC_NUMBER"), resultSet.getString("PROC_NAME"), 
						Boolean.valueOf(resultSet.getString("INPARALLEL")), 
						Boolean.valueOf(resultSet.getString("INENABLED"))); 
				procList.add(extractionProcedure);
			}
		}catch(Exception e){
			log.error("Error in getting the procedure list : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		// System.out.println("procList size : "+procList);
		return procList;
	}
	
	private void createLogDump(Configuration configuration){
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "INSERT INTO TB_DAILYEXTRACTIONIMPORTDUMP(IMPORTTYPE,IMPORTMESSAGE,IMPORTTIMESTAMP) "+
					   "SELECT IMPORTTYPE, IMPORTMESSAGE, IMPORTTIMESTAMP FROM TB_DAILYEXTRACTIONIMPORTLOG";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.executeUpdate();
			log.info("Previous ETL log dump successfully created");
			
			query = "TRUNCATE TABLE TB_DAILYEXTRACTIONIMPORTLOG";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.execute();
			
			query = "TRUNCATE TABLE TB_DAILYEXTRACTIONLOG";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.execute();
			
			query = "TRUNCATE TABLE TB_PROCESSLOG";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.execute();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	public List<Integer> getAllGroup(Configuration configuration) {
		List<Integer> l_objGroupList = new ArrayList<Integer>();
		String sqlQuery = "SELECT DISTINCT GROUP_ID FROM TB_PROCLIST ORDER BY GROUP_ID ASC";
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sqlQuery);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				l_objGroupList.add(resultSet.getInt(1));
			}
		}catch(Exception e){
			log.error("Error in getting the group list : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return l_objGroupList;
	}
	
	public List<ExtractionProcedure> getAllProcedureInGroup(Configuration configuration, int a_intGroupId){
		List<ExtractionProcedure> l_objProcedureList = new ArrayList<ExtractionProcedure>();
		String sqlQuery = "SELECT GROUP_ID, PROC_NUMBER, PROC_NAME, CASE NVL(INPARALLEL,'N') WHEN 'Y' THEN 'true' ELSE 'false' END AS INPARALLEL, "+
						  " 	  CASE NVL(INENABLED,'N') WHEN 'Y' THEN 'true' ELSE 'false' END AS INENABLED "+
						  "  FROM TB_PROCLIST WHERE GROUP_ID = ? ORDER BY PROC_NUMBER ASC";
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sqlQuery);
			preparedStatement.setInt(1, a_intGroupId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				l_objProcedureList.add(new ExtractionProcedure(resultSet.getInt("GROUP_ID"), resultSet.getInt("PROC_NUMBER"), 
						resultSet.getString("PROC_NAME"), Boolean.valueOf(resultSet.getString("INPARALLEL")), Boolean.valueOf(resultSet.getString("INENABLED"))));
			}
		}catch(Exception e){
			log.error("Error in getting procedure list in the group( "+a_intGroupId+" ): "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return l_objProcedureList;
	}
	
	public List<ExtractionDBMessage> getProcessMessage(Configuration configuration){
		int rowNum = 0;
		List<ExtractionDBMessage> messageList = new ArrayList<ExtractionDBMessage>();
		String sqlQuery = "SELECT IMPORTTIMESTAMP, IMPORTTYPE ,IMPORTMESSAGE FROM TB_DAILYEXTRACTIONIMPORTLOG ORDER BY IMPORTTIMESTAMP DESC ";
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sqlQuery);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				messageList.add(new ExtractionDBMessage(rowNum, resultSet.getString("IMPORTTIMESTAMP"), resultSet.getString("IMPORTTYPE"),
						resultSet.getString("IMPORTMESSAGE")));
				rowNum++;
			}
		}catch(Exception e){
			log.error("Error in getting the process messages "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return messageList;
	}
	
	public List<ExtractionProcedure> getCompletedProcedureList(Configuration configuration){
		List<ExtractionProcedure> messageList = new ArrayList<ExtractionProcedure>();
		String sqlQuery = "SELECT GROUP_ID, SL_NO, PROC_NAME "+
						  "  FROM TB_PROCESSLOG "+
						  " ORDER BY GROUP_ID ASC ";
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement(sqlQuery);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				messageList.add(new ExtractionProcedure(resultSet.getInt("GROUP_ID"), resultSet.getInt("SL_NO"), resultSet.getString("PROC_NAME"), 
						true, true));
			}
		}catch(Exception e){
			log.error("Error in getting the process messages "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return messageList;
	}
	
	public void saveSkippedProcedureInProcessLog(Configuration configuration, ExtractionProcedure a_objProc){
		String sqlQuery = "INSERT INTO TB_PROCESSLOG(GROUP_ID, SL_NO, PROC_NAME, STARTTIMESTAMP, ENDTIMESTAMP, LOGTIMESTAMP) "+
						  "VALUES (?, ?, ?, SYSTIMESTAMP, SYSTIMESTAMP, SYSTIMESTAMP)";
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		PreparedStatement preparedStatement = null;
		try{
			preparedStatement = connection.prepareStatement(sqlQuery);
			preparedStatement.setInt(1, a_objProc.getGroupId());
			preparedStatement.setInt(2, a_objProc.getProcedureNumber());
			preparedStatement.setString(3, a_objProc.getProcedureName()+" Skipped");
			preparedStatement.executeUpdate();
		}catch(Exception e){
			log.error("Error in saving skipped procedure the process messages "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
	}
	
	public String ExecuteProcedure(Configuration configuration, ExtractionProcedure a_objProc, String a_strFromdate, String a_strToDate, String l_strUserCode) throws Exception{
		String a_strProcName = a_objProc.getProcedureName();
		Connection connection = connectionUtil.getConnection(configuration.getJndiDetails().getJndiName());
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{call "+a_strProcName+"(?,?,?)}");
			callableStatement.setString(1, a_strFromdate);
			callableStatement.setString(2, a_strToDate);
			callableStatement.setString(3, l_strUserCode);
			callableStatement.execute();
		}catch(Exception e){
			log.error("Error executing the procedure -- > "+a_strProcName+" : "+e.getMessage());
			e.printStackTrace();
			throw e;
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return a_strProcName;
	}
}
