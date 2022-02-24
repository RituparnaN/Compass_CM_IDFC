package com.quantumdataengines.app.compass.dao.crpExecScheduler;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class CRPExecSchedulerDAOImpl implements CRPExecSchedulerDAO{

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Map<String, String> getCRPExecutedDetails(){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String sql = "SELECT FUN_DATETOCHAR(EXECUTED_FROMDATE) EXECUTED_FROMDATE, "+
					 "       FUN_DATETOCHAR(EXECUTED_TODATE) EXECUTED_TODATE, "+
					 "		 FUN_DATETOCHAR(EXECUTED_DATE) EXECUTED_DATE, "+
       				 "		 FUN_DATETOCHAR(SCHEDULED_FROMDATE) SCHEDULED_FROMDATE, "+ 
       				 "		 FUN_DATETOCHAR(SCHEDULED_TODATE) SCHEDULED_TODATE, "+
       				 "       FUN_DATETOCHAR(EXECUTION_DATE) EXECUTION_DATE, "+
      				 " 		 UPDATEDBY, UPDATETIMESTAMP "+
      				 "  FROM "+schemaName+"TB_CRP_EXEC_SCHEDULER "+
      				 " ORDER BY UPDATETIMESTAMP DESC ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			if(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	
		
	public String saveSchedulingDates(String EXECUTED_FROMDATE, String EXECUTED_TODATE, 
			String EXECUTED_DATE, String SCHEDULED_FROMDATE, String SCHEDULED_TODATE, 
			String EXECUTION_DATE, String currentUser){
		String result = "";
		String sql = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;

		try{

			sql = " INSERT INTO "+schemaName+"TB_CRP_EXEC_SCHEDULER_AUDITLOG ( "+
				  "        EXECUTED_FROMDATE, EXECUTED_TODATE, "+
			      "        EXECUTED_DATE, SCHEDULED_FROMDATE, "+
				  "        SCHEDULED_TODATE, EXECUTION_DATE, UPDATEDBY, UPDATETIMESTAMP ) "+
			      " VALUES ( FUN_CHARTODATE(?), FUN_CHARTODATE(?), "+
				  "         FUN_CHARTODATE(?), FUN_CHARTODATE(?), "+
				  "         FUN_CHARTODATE(?), FUN_CHARTODATE(?), "+
				  "			?, SYSTIMESTAMP) ";
			preparedStatement= connection.prepareStatement(sql);
			preparedStatement.setString(1, EXECUTED_FROMDATE);
			preparedStatement.setString(2, EXECUTED_TODATE);
			preparedStatement.setString(3, EXECUTED_DATE);
			preparedStatement.setString(4, SCHEDULED_FROMDATE);
			preparedStatement.setString(5, SCHEDULED_TODATE);
			preparedStatement.setString(6, EXECUTION_DATE);
			preparedStatement.setString(7, currentUser);

			sql = " UPDATE "+schemaName+"TB_CRP_EXEC_SCHEDULER A "+
				  "    SET SCHEDULED_FROMDATE = FUN_CHARTODATE(?), "+
				  "        SCHEDULED_TODATE = FUN_CHARTODATE(?), "+
				  "        EXECUTION_DATE = FUN_CHARTODATE(?), "+
                  "        UPDATEDBY = ?, "+
				  "        UPDATETIMESTAMP = SYSTIMESTAMP ";
				preparedStatement= connection.prepareStatement(sql);
				preparedStatement.setString(1, SCHEDULED_FROMDATE);
				preparedStatement.setString(2, SCHEDULED_TODATE);
				preparedStatement.setString(3, EXECUTION_DATE);
				preparedStatement.setString(4, currentUser);
				preparedStatement.executeQuery();

				preparedStatement.executeQuery();
				result = "CRP Execution Scheduling details saved successfully.";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while saving CRP Execution Scheduling details.";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
}
