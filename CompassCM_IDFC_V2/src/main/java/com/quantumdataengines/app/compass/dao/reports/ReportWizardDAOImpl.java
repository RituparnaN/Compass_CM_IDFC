package com.quantumdataengines.app.compass.dao.reports;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class ReportWizardDAOImpl implements ReportWizardDAO{
	private static final Logger log = LoggerFactory.getLogger(ReportWizardDAOImpl.class);
	
	@Autowired
	private ConnectionUtil connectionUtil;

	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public Connection getConnection(){
		Connection connection = null;
		try{
			connection = connectionUtil.getConnection();
		}catch(Exception e){
			log.error("Error in creating db connection : ReportWidgetDAOImpl -> "+e.getMessage());
			e.printStackTrace();
		}
		return connection;
	}
	
	public List<Map<String, Object>> getAllBusinessObject(){
		List<Map<String, Object>> businessObjList = new ArrayList<Map<String, Object>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT ROWNUM AS ROWPOSITION, TABLENAME, DISPLAYNAME "+
	  		  												"  FROM "+schemaName+"TB_REPORTWIDGET_TAB_NAMES");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, Object> boMap = new HashMap<String, Object>();
				boMap.put("ROWPOSITION", resultSet.getInt("ROWPOSITION"));
				boMap.put("TABLENAME", resultSet.getString("TABLENAME"));
				boMap.put("DISPLAYNAME", resultSet.getString("DISPLAYNAME"));
				businessObjList.add(boMap);
			}
		}catch(Exception e){
			log.error("Error occurred while getting all business objects : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return businessObjList;
	}
	
	public Map<String, List<String>> getBusinessObjectsDetails(List<String> objectNameList){
		Map<String, List<String>> businessObjList = new HashMap<String, List<String>>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT COLUMN_ID AS ROWPOSITION, COLUMN_NAME, DATA_TYPE " +
					   "  FROM "+schemaName+"TB_REPORTWIDGET_TAB_COLUMNS " +
					   " WHERE TABLE_NAME = ? " +
					   " ORDER BY COLUMN_ID ASC ";
		try{
			for(String objectName : objectNameList){
				List<String> objectDetailsList = new Vector<String>();
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, objectName);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {					
					objectDetailsList.add(resultSet.getString("COLUMN_NAME"));
				}
				businessObjList.put(objectName, objectDetailsList);
			}
		}catch(Exception e){
			log.error("Error occurred while getting details of business objects : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return businessObjList;
	}
	
	
	public List<String> getObjectColumns(String objectName){
		List<String> businessObjFieldList = new Vector<String>();
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT COLUMN_ID AS ROWPOSITION, COLUMN_NAME, DATA_TYPE " +
					   "  FROM "+schemaName+"TB_REPORTWIDGET_TAB_COLUMNS " +
					   " WHERE TABLE_NAME = ? " +
					   " ORDER BY COLUMN_ID ASC ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, objectName);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {					
				businessObjFieldList.add(resultSet.getString("COLUMN_NAME"));
			}
		}catch(Exception e){
			log.error("Error occurred while getting details of business objects : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return businessObjFieldList;
	}
	
	public String getColumnsDatatype(String objectName, String fieldName){
		String dataType = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT DATA_TYPE " +
					   "  FROM "+schemaName+"TB_REPORTWIDGET_TAB_COLUMNS " +
					   " WHERE TABLE_NAME= ? " +
					   "   AND COLUMN_NAME= ? ";
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, objectName);
			preparedStatement.setString(2, fieldName);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				dataType = resultSet.getString(1);
		}catch(Exception e){
			log.error("Error occurred while getting details of business objects : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataType;
	}
	
	
	
	@SuppressWarnings("resource")
	public String saveReport(String reportObjects, String reportJoinDetails, String reportColumns, String conditionDetails, String aggregateConditions, 
			String reportId, String reportCode, String reportName, String reportHeader, String reportFooter, String isEnabled, String userCode,
			String objectHtml, String joinHtml, String reportHtml, String conditionHtml, String aggregateConditionHtml, String noOfParams){
		boolean isNew = true;
		
		String message = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String insertQuery = "INSERT INTO "+schemaName+"TB_REPORTWIDGETDETAILS_NEW (REPORTID, REPORTCODE, REPORTNAME, REPORTHEADER, REPORTFOOTER, ISENABLED, "+
					   "			REPORTOBJECTNAMES, REPORTCOLUMNNAMES, REPORTJOINDETAILS, REPORTCONDITIONDETAILS, AGGREGATEDCONDITIONDETAILS, "+
					   "			REPORTEXECUTEQUERY, UPDATEDBY, CREATEDON, UPDATETIMESTAMP, OBJECTHTML, JOINTABLEHTML, REPORTTABLEHTML, " +
					   "            CONDITIONTABLEHTML, AGGREGATETABLEHTML, NOOFPARAMETERS) "+
					   "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP,SYSTIMESTAMP,?,?,?,?,?,?)";
		String updateQuery = "UPDATE "+schemaName+"TB_REPORTWIDGETDETAILS_NEW "+
							 "   SET REPORTCODE = ?, REPORTNAME = ?, REPORTHEADER = ?, REPORTFOOTER = ?, ISENABLED = ?, "+
							 "       REPORTOBJECTNAMES = ?, REPORTCOLUMNNAMES = ?, REPORTJOINDETAILS = ?, "+
							 "		 REPORTCONDITIONDETAILS = ?, AGGREGATEDCONDITIONDETAILS = ?, "+
							 "		 REPORTEXECUTEQUERY = ?, UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP, OBJECTHTML = ?, "+
							 "       JOINTABLEHTML = ?, REPORTTABLEHTML = ?, CONDITIONTABLEHTML = ?, AGGREGATETABLEHTML = ?, NOOFPARAMETERS = ?"+
							 " WHERE REPORTID = ?";
		try{
			preparedStatement = connection.prepareStatement("SELECT REPORTID FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW WHERE REPORTID = ?");
			preparedStatement.setString(1, reportId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				isNew = false;
			}
			
			if(reportId.trim().length() <= 0){
				preparedStatement = connection.prepareStatement("SELECT SEQ_REPORTWIDGETID.NEXTVAL REPORTID FROM DUAL");
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					reportId = resultSet.getString("REPORTID");
				}
			}
			
			String finalQuery = "";
			
			if(reportJoinDetails.trim().length() > 0){
				finalQuery = "SELECT "+reportColumns+" FROM "+reportJoinDetails+" WHERE 1 = 1 "+conditionDetails+" "+aggregateConditions;
			}else{
				finalQuery = "SELECT "+reportColumns+" FROM "+reportObjects+" WHERE 1 = 1 "+conditionDetails+" "+aggregateConditions;
			}
			
			if(isNew){
				preparedStatement = connection.prepareStatement(insertQuery);
				preparedStatement.setString(1, reportId);
				preparedStatement.setString(2, reportCode);
				preparedStatement.setString(3, reportName);
				preparedStatement.setString(4, reportHeader);
				preparedStatement.setString(5, reportFooter);
				preparedStatement.setString(6, isEnabled);
				preparedStatement.setString(7, reportObjects);
				preparedStatement.setString(8, reportColumns);
				preparedStatement.setString(9, reportJoinDetails);
				preparedStatement.setString(10, conditionDetails);
				preparedStatement.setString(11, aggregateConditions);
				preparedStatement.setString(12, finalQuery);
				preparedStatement.setString(13, userCode);
				preparedStatement.setString(14, objectHtml);
				preparedStatement.setString(15, joinHtml);
				preparedStatement.setString(16, reportHtml);
				preparedStatement.setString(17, conditionHtml);
				preparedStatement.setString(18, aggregateConditionHtml);
				preparedStatement.setString(19, noOfParams);
				preparedStatement.executeUpdate();
				message = reportId;
			}else{
				preparedStatement = connection.prepareStatement(updateQuery);
				preparedStatement.setString(1, reportCode);
				preparedStatement.setString(2, reportName);
				preparedStatement.setString(3, reportHeader);
				preparedStatement.setString(4, reportFooter);
				preparedStatement.setString(5, isEnabled);
				preparedStatement.setString(6, reportObjects);
				preparedStatement.setString(7, reportColumns);
				preparedStatement.setString(8, reportJoinDetails);
				preparedStatement.setString(9, conditionDetails);
				preparedStatement.setString(10, aggregateConditions);
				preparedStatement.setString(11, finalQuery);
				preparedStatement.setString(12, userCode);
				preparedStatement.setString(13, objectHtml);
				preparedStatement.setString(14, joinHtml);
				preparedStatement.setString(15, reportHtml);
				preparedStatement.setString(16, conditionHtml);
				preparedStatement.setString(17, aggregateConditionHtml);
				preparedStatement.setString(18, noOfParams);
				preparedStatement.setString(19, reportId);
				preparedStatement.executeUpdate();
				message = reportId;				
			}			
		}catch(Exception e){
			log.error("Error occurred while saving report : "+e.getMessage());
			e.printStackTrace();
			message = "Error occured while saving report!";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return message;
	}
	
	public String getObjectSelected(String reportId){
		String objectHtml = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT OBJECTHTML FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW WHERE REPORTID = ?");
			preparedStatement.setString(1, reportId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				objectHtml = resultSet.getString("OBJECTHTML");
			}
		}catch(Exception e){
			log.error("Error occurred checking object : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return objectHtml;
	}
	
	public String createNewReportId(){
		String reportId = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_REPORTWIDGETID.NEXTVAL REPORTID FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				reportId = resultSet.getString("REPORTID");
			}
		}catch(Exception e){
			log.error("Error occurred checking object : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return reportId;
	}
	
	public String getReportDetails(String reportId, String section){
		String value = "";
		Connection connection = getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+section+" FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW WHERE REPORTID = ?");
			preparedStatement.setString(1, reportId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				value = resultSet.getString(1);
			}
		}catch(Exception e){
			log.error("Error occurred checking object : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return value;
	}
	
	@SuppressWarnings("resource")
	public HashMap<String,Object> builReportData(String userName, String builtCondition, String reportId, String noOfParameters, HashMap<String,String> hashMap)
    {
    	ArrayList<HashMap<String, String>> arrayList = new ArrayList<HashMap<String, String>>();
		ResultSet resultSet = null;
		Connection connection = getConnection();
		//CallableStatement callableStatement = null;
		PreparedStatement pstatement = null;
        HashMap<String,Object> reportData = new HashMap<String,Object>();
        String queryString = "";
        //String columnString = "";
        String reportName = "";
        String reportHeader = "";
        String reportFooter = "";
        String reportExecuteQuery = "";
        // String reportConditionDetails = "";
        int intNoOfParameters = 0;
        try{
        	intNoOfParameters = Integer.parseInt(noOfParameters);
        }catch(Exception e){}
		try
    	{  
		  queryString = " SELECT REPORTNAME, REPORTHEADER, REPORTFOOTER "+
		  			    "   FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW A "+
				        //"  WHERE REPORTID = '"+reportId+"' " ;
		  			    "  WHERE REPORTID = ? " ;
		  pstatement = connection.prepareStatement(queryString);
		  pstatement.setString(1, reportId);
		  resultSet = pstatement.executeQuery();
		  while(resultSet.next())
		  {
			  reportName = resultSet.getString("REPORTNAME");
			  reportHeader = resultSet.getString("REPORTHEADER");
			  reportFooter = resultSet.getString("REPORTFOOTER");
		  }
		  
		  queryString = " SELECT REPORTEXECUTEQUERY "+
          				"   FROM "+schemaName+"TB_REPORTWIDGETDETAILS_NEW A "+
          				//"  WHERE REPORTID = '"+reportId+"'  " ;
          				"  WHERE REPORTID = ? " ;
   		  pstatement = connection.prepareStatement(queryString);
		  pstatement.setString(1, reportId);
		  resultSet = pstatement.executeQuery();
		  while(resultSet.next())
		  {
			  reportExecuteQuery = resultSet.getString("REPORTEXECUTEQUERY") ;
			  // reportConditionDetails = resultSet.getString("REPORTCONDITIONDETAILS") ;
		  }
		  for(int i=1; i<=intNoOfParameters;i++){
				reportExecuteQuery = reportExecuteQuery.replaceAll("@param"+i, hashMap.get("@param"+i));
		  }
			
		  queryString = reportExecuteQuery;
		  /*	  
	      queryString = "SELECT ROWNUM AS ROWPOSITION, "+schemaName+"TB_TRANSACTIONS.* "+
              			"  FROM "+schemaName+"TB_TRANSACTIONS, "+schemaName+"TB_ACCOUNTSMASTER, "+schemaName+"TB_CUSTOMERMASTER "+
              			" WHERE "+schemaName+"TB_TRANSACTIONS.ACCOUNTNO = "+schemaName+"TB_ACCOUNTSMASTER.ACCOUNTNO "+
              			"   AND "+schemaName+"TB_ACCOUNTSMASTER.CUSTOMERID = "+schemaName+"TB_CUSTOMERMASTER.CUSTOMERID "+
              			" "+builtCondition;
		  queryString = "SELECT ROWNUM AS ROWPOSITION, "+columnString+
						"  FROM "+schemaName+"TB_TRANSACTIONS, "+schemaName+"TB_ACCOUNTSMASTER, "+schemaName+"TB_CUSTOMERMASTER "+
						" WHERE "+schemaName+"TB_TRANSACTIONS.ACCOUNTNO = "+schemaName+"TB_ACCOUNTSMASTER.ACCOUNTNO "+
						"   AND "+schemaName+"TB_ACCOUNTSMASTER.CUSTOMERID = "+schemaName+"TB_CUSTOMERMASTER.CUSTOMERID "+
						" "+builtCondition;
		  */
		  
   		  pstatement = connection.prepareStatement(queryString);
		  resultSet = pstatement.executeQuery();
         
		  ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
	      String[] l_Headers=new String[resultSetMetaData.getColumnCount()];
		  for(int i=l_Headers.length;i>=1;i--)
		    l_Headers[i-1]=resultSetMetaData.getColumnName(i);
				  						 	 	
		  while(resultSet.next())
		  {	
			HashMap<String, String> l_DTO=new HashMap<String, String>();
			for(int i=l_Headers.length;i>=1;i--)
			  l_DTO.put(l_Headers[i-1],resultSet.getString(i));
			arrayList.add(l_DTO);
		  }
		  reportData.put("reportName", reportName);
		  reportData.put("reportHeader", reportHeader);
		  reportData.put("reportFooter", reportFooter);
		  
		  reportData.put("Header", l_Headers);
		  reportData.put("ReportData", arrayList);
    	}
    	catch(Exception e)
    	{
    		log.error("The exception in ReportData for is "+e.toString()+" for builtCondition : "+queryString);
    	    System.out.println("The exception in ReportData for is "+e.toString()+" for builtCondition : "+queryString);	
    	    e.printStackTrace();
    	}
    	finally
    	{
    	try
    	{
    		connectionUtil.closeResources(connection, pstatement, resultSet, null);
 		}
    	catch(Exception e)
    	{
    		log.error("Exception in finally exception block is "+e.toString());
		    System.out.println("Exception in finally exception block is "+e.toString());
		    e.printStackTrace();
		}
    	}
    	return reportData;
    }
	
	public List<Map<String, String>> fetchReportBuilderParameters(String reportId, String paramIndex){
		List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql= "SELECT REPORTID, PARAMINDEX, PARAMNAME, PARAMALIASNAME, "+
						"		PARAMTYPE, DEFAULTVALUE, ISMANDATORY, STATICVALUES, VALIDATINGFIELD, VALIDATIONTYPE, "+
						"       FUN_DATETOCHAR(UPDATEDDATE) UPDATEDDATE, UPDATEDBY, DEFAULTVALUETYPE "+
						"  FROM "+schemaName+"TB_REPORTBUILDERPARAMS WHERE REPORTID = ? ";
						
			if(paramIndex != null && paramIndex.trim().length() >= 0){
							sql = sql + " AND PARAMINDEX = '"+ paramIndex + "' ";
			}
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("REPORTID", resultSet.getString("REPORTID"));
				dataMap.put("PARAMINDEX", resultSet.getString("PARAMINDEX"));
				dataMap.put("PARAMNAME", resultSet.getString("PARAMNAME"));
				dataMap.put("PARAMALIASNAME", resultSet.getString("PARAMALIASNAME"));
				dataMap.put("PARAMTYPE", resultSet.getString("PARAMTYPE"));
				dataMap.put("DEFAULTVALUE", resultSet.getString("DEFAULTVALUE"));
				dataMap.put("ISMANDATORY", resultSet.getString("ISMANDATORY"));
				dataMap.put("STATICVALUES", resultSet.getString("STATICVALUES"));
				dataMap.put("VALIDATINGFIELD", resultSet.getString("VALIDATINGFIELD"));
				dataMap.put("VALIDATIONTYPE", resultSet.getString("VALIDATIONTYPE"));
				dataMap.put("UPDATEDDATE", resultSet.getString("UPDATEDDATE"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				dataMap.put("DEFAULTVALUETYPE", resultSet.getString("DEFAULTVALUETYPE"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}

	@SuppressWarnings("resource")
	public String saveUpdateReportParameters(String noOfParam, String reportId, String parameterIndex, String userCode,
									String parameterLabel,String parameterType, String isMandatory, String defaultValueType, String defaultValue){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		int count = 0;
		String result = "";
		try{
			String sql = "SELECT COUNT(*) REPORTIDCOUNT FROM "+schemaName+"TB_REPORTBUILDERPARAMS WHERE REPORTID = ? AND 	PARAMINDEX = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.setString(2, parameterIndex);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				count = resultSet.getInt("REPORTIDCOUNT");
			}
			if(count == 0){	
				sql= "INSERT INTO "+schemaName+"TB_REPORTBUILDERPARAMS(REPORTID, PARAMINDEX, PARAMNAME, PARAMALIASNAME, "+
					 "		 PARAMTYPE, DEFAULTVALUE, ISMANDATORY, STATICVALUES, VALIDATINGFIELD, VALIDATIONTYPE, "+
					 "       UPDATEDDATE, UPDATEDBY, DEFAULTVALUETYPE) "+
					 "VALUES (?,?,?,?,?,?,?,?,?,?, SYSTIMESTAMP,?,?) ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, reportId);
				preparedStatement.setString(2, parameterIndex);
				preparedStatement.setString(3, "@param"+parameterIndex);
				preparedStatement.setString(4, parameterLabel);
				preparedStatement.setString(5, parameterType);
				preparedStatement.setString(6, defaultValue);
				preparedStatement.setString(7, isMandatory);
				preparedStatement.setString(8, "N");
				preparedStatement.setString(9, "N.A.");
				preparedStatement.setString(10, "N.A.");
				preparedStatement.setString(11, userCode);
				preparedStatement.setString(12, defaultValueType);
				preparedStatement.executeUpdate();
				result = "Inserted successfully.";
			}
			else{
				sql= "UPDATE "+schemaName+"TB_REPORTBUILDERPARAMS SET PARAMNAME = ?, PARAMALIASNAME = ?, PARAMTYPE = ?, "+
					 "		 DEFAULTVALUE = ?, ISMANDATORY = ?, STATICVALUES = ?, VALIDATINGFIELD = ?, "+
					 "       VALIDATIONTYPE = ?, UPDATEDDATE = SYSTIMESTAMP, UPDATEDBY = ?, DEFAULTVALUETYPE = ? "+
					 " WHERE REPORTID = ? AND PARAMINDEX = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, "@param"+parameterIndex);
				preparedStatement.setString(2, parameterLabel);
				preparedStatement.setString(3, parameterType);
				preparedStatement.setString(4, defaultValue);
				preparedStatement.setString(5, isMandatory);
				preparedStatement.setString(6, "N");
				preparedStatement.setString(7, "N.A.");
				preparedStatement.setString(8, "N.A.");
				preparedStatement.setString(9, userCode);
				preparedStatement.setString(10, defaultValueType);
				preparedStatement.setString(11, reportId);
				preparedStatement.setString(12, parameterIndex);
				preparedStatement.executeUpdate();
				result="Updated successfully";
			}
		}catch(Exception e){
			result="Error while inserting/updating.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	public String deleteReportParameters(String selected, String reportId){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String result = "";
		selected = selected.replaceAll(",", "','");
		String sql = "DELETE FROM "+schemaName+"TB_REPORTBUILDERPARAMS WHERE REPORTID = ? AND PARAMNAME IN ('"+selected+"') ";
		try{
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, reportId);
			preparedStatement.executeUpdate();
			result = "Successfully Deleted";
		}catch(Exception e){
			result="Error while deleting.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return result;
	}
	
}
