package com.quantumdataengines.app.compass.dao.customerRiskProfiling;

import java.sql.CallableStatement;
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

import oracle.jdbc.OracleTypes;
import oracle.net.aso.q;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.dao.admin.Query;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
@Repository
public class CustomerRiskProfilingDAOImpl  implements CustomerRiskProfilingDAO{
	private static final Logger log = LoggerFactory.getLogger(CustomerRiskProfilingDAOImpl.class);

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public List<Map<String, Object>> getAllBusinessObject(String userCode,String userRole, String remoteAddr) {
		List<Map<String, Object>> businessObjList = new ArrayList<Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT ROWNUM AS ROWPOSITION, TABLENAME, DISPLAYNAME "+
	  		  												"  FROM "+schemaName+"TB_CUSTRISKPROFILE_TAB_NAME");
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
	
	public String createNewRuleId(String userCode,String userRole, String remoteAddr){
		String ruleId = "";
		Connection connection =  connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_CUSTRISKRULEID.NEXTVAL RULEID FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				ruleId = resultSet.getString("RULEID");
			}
		}catch(Exception e){
			log.error("Error occurred checking object : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return ruleId;
	}

	//get list of all column of a table..
	@Override
	public Map<String, List<String>> getAllTableColumns(List<String> listObject,String userCode,String userRole, String remoteAddr) {
		Map<String, List<String>> businessObjList = new HashMap<String, List<String>>();
		Connection connection =  connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		/*String query = "SELECT RISKPARAMETERID AS ROWPOSITION, RISKPARAMETERCODE, RISKPARAMETERNAME " +
					   "  FROM "+schemaName+""+
					   //".? "+
					   " ORDER BY RISKPARAMETERID ASC ";
		System.out.println("query = "+query);*/
		try{
			String query = "SELECT RISKPARAMETERID AS ROWPOSITION, RISKPARAMETERCODE, RISKPARAMETERNAME "+
						   "  FROM "+schemaName+"? ORDER BY RISKPARAMETERID ASC ";
			for(String objectName : listObject){
				/*System.out.println("obj = "+objectName);*/
				List<String> objectDetailsList = new Vector<String>();
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, objectName);
				resultSet = preparedStatement.executeQuery();
				while (resultSet.next()) {					
					objectDetailsList.add(resultSet.getString("RISKPARAMETERNAME"));
				}
				businessObjList.put(objectName, objectDetailsList);
			}
		}catch(Exception e){
			log.error("Error occurred while getting details of business objects : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		/*System.out.println("data in daoimpl = "+businessObjList);*/
		return businessObjList;
	}
	
	//for getting column data type..
	public String getColumnsDatatype(String objectName, String fieldName){
		String dataType = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = " SELECT RISKPARAMETERDATATYPE " +
					   "  FROM "+schemaName+""+objectName+
					   " WHERE  RISKPARAMETERCODE= ? ";
		/*System.out.println("query = "+query+"    f name= "+fieldName);*/
		try{
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, fieldName);
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

	//for getting all column list of a table...
	@Override
	public Map<String, String> getTableObjectColumns(String objectTableName,String userCode,String userRole, String remoteAddr) {
		Map<String, String> tableObjFieldList = new LinkedHashMap<String,String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		/*String query = "SELECT COLUMN_ID AS ROWPOSITION, COLUMN_NAME, DATA_TYPE " +
					   "  FROM "+schemaName+"TB_REPORTWIDGET_TAB_COLUMNS " +
					   " WHERE TABLE_NAME = ? " +
					   " ORDER BY COLUMN_ID ASC ";*/
		try{
			String query = "SELECT RISKPARAMETERID AS ROWPOSITION, RISKPARAMETERCODE, RISKPARAMETERNAME "+
						   "  FROM "+schemaName+""+objectTableName+" ORDER BY RISKPARAMETERID ASC ";
			
			preparedStatement = connection.prepareStatement(query);
			/*preparedStatement.setString(1, objectTableName);*/
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {					
				tableObjFieldList.put(resultSet.getString("RISKPARAMETERCODE"),resultSet.getString("RISKPARAMETERNAME"));
			}
		}catch(Exception e){
			log.error("Error occurred while getting details of business objects : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println(" table name= "+objectTableName+"  data== "+tableObjFieldList);
		return tableObjFieldList;
	}

	@Override
	public Map<String, String> getCRPTableColumnValues(String tableName,String columnName,String userCode,String userRole, String remoteAddr) {
		/*System.out.println("table name = "+tableName+"  column name = "+columnName);*/
		Map<String, String> tableObjFieldList = new HashMap<String,String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "SELECT SUBRISKPARAMETERID AS ROWPOSITION, SUBPARAMETERCODE, SUBPARAMETERDESCRIPTION "+
				       "  FROM "+schemaName+""+tableName+" " +
				       " WHERE RISKPARAMETERCODE = ? "+
				       " ORDER BY SUBRISKPARAMETERID ASC ";
		try{
			/*System.out.println("query = "+query);*/
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, columnName);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				/*System.out.println("sub parameter code = "+resultSet.getString("SUBPARAMETERCODE")+" description = "+resultSet.getString("SUBPARAMETERDESCRIPTION"));*/
				tableObjFieldList.put(resultSet.getString("SUBPARAMETERCODE"),resultSet.getString("SUBPARAMETERDESCRIPTION"));
			}
		}catch(Exception e){
			log.error("Error occurred while getting details of business objects : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println("column data = "+tableObjFieldList);
		return tableObjFieldList;
	}

	@SuppressWarnings("resource")
	@Override
	public Map<String, Object> saveCustomerRiskProfileRules(String tableNames,String ruleId,String ruleCode, String ruleName, String risk, String isEnable,
			String rule,String ruleConditionHTML, String userCode, String userRole, String remoteAddr,String makerComment,String CRPRuleFor) {
		Map<String,Object> output = new HashMap<String,Object>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		boolean isNew = true;
		String message = "";
		int versionNo = 1000;
		
		try{
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_CUSTRISKPROFILING_VERSION.NEXTVAL VERSIONNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			resultSet.next();
			versionNo = resultSet.getInt("VERSIONNO");
		}catch(Exception e){
			log.error("Error getting version no of crp rule : "+e.getMessage());
			e.printStackTrace();
		}
		
		String insertQuery = "INSERT INTO "+schemaName+"TB_CUSTRISKPROFILE_PENDING("+
							 " 		 RULEID, RULECODE, RULENAME, RISK, RULE, RULEHTML, ISENABLE, UPDATETIMESTAMP, "+
				             "       RULEOBJECTSNAME, MAKERCODE, MAKERTIMESTAMP, MAKERIPADDRESS, VERSIONNO, MAKERCOMMENTS, "+
							 "		 UPDATEDBY, STATUS, RULEFOR) "+
							 "VALUES(?,?,?,?,?,?,?,SYSTIMESTAMP,?,?,SYSTIMESTAMP,?,?,?,?,'PENDING',?) ";
		
		String updateQuery = "UPDATE "+schemaName+"TB_CUSTRISKPROFILE_PENDING "+
							 "   SET RULECODE = ?, RULENAME = ?, RULE = ?, RISK = ?, "+
				             "       RULEHTML = ?, ISENABLE = ?, UPDATETIMESTAMP = SYSTIMESTAMP, RULEOBJECTSNAME = ?,  "+
				             "       MAKERCODE = ?, MAKERTIMESTAMP = SYSTIMESTAMP, MAKERIPADDRESS = ?, VERSIONNO = ?,  " + 
				             "      MAKERCOMMENTS = ?,  UPDATEDBY = ?, STATUS = 'PENDING', RULEFOR = ? "
						 + " WHERE RULEID = ? ";
		try{
			preparedStatement = connection.prepareStatement("SELECT RULEID FROM "+schemaName+"TB_CUSTRISKPROFILE_PENDING WHERE RULEID = ?");
			preparedStatement.setString(1, ruleId);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				isNew = false;
			}
			
			/*if(reportId.trim().length() <= 0){
				preparedStatement = connection.prepareStatement("SELECT SEQ_REPORTWIDGETID.NEXTVAL REPORTID FROM DUAL");
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					reportId = resultSet.getString("REPORTID");
				}
			}*/
			if(isNew){
				preparedStatement = connection.prepareStatement(insertQuery);
				preparedStatement.setString(1, ruleId);
				preparedStatement.setString(2, ruleCode);
				preparedStatement.setString(3, ruleName);
				preparedStatement.setString(4, risk);
				preparedStatement.setString(5, rule);
			//	preparedStatement.setString(6, OBJECTHTML);
				preparedStatement.setString(6, ruleConditionHTML);
				preparedStatement.setString(7, isEnable);
				preparedStatement.setString(8, tableNames);
				preparedStatement.setString(9, userCode);
				preparedStatement.setString(10, remoteAddr);
				preparedStatement.setInt(11, versionNo);
				preparedStatement.setString(12, makerComment);
				preparedStatement.setString(13, userCode);
				preparedStatement.setString(14, CRPRuleFor);
				preparedStatement.execute();
				message = ruleId;
			}else{
				preparedStatement = connection.prepareStatement(updateQuery);
				preparedStatement.setString(1, ruleCode);
				preparedStatement.setString(2, ruleName);
				preparedStatement.setString(3, rule);
				preparedStatement.setString(4, risk);
				preparedStatement.setString(5, ruleConditionHTML);
				//preparedStatement.setString(6, OBJECTHTML);
				preparedStatement.setString(6, isEnable);
				preparedStatement.setString(7, tableNames);
				preparedStatement.setString(8, userCode);
				preparedStatement.setString(9, remoteAddr);
				preparedStatement.setInt(10, versionNo);
				preparedStatement.setString(11, makerComment);
				preparedStatement.setString(12, userCode);
				preparedStatement.setString(13, CRPRuleFor);
				preparedStatement.setString(14, ruleId);
				preparedStatement.executeUpdate();
				message = ruleId;				
			}
			//FOR CREATING LOG
			Map<String,String> ruleData = new HashMap<String,String>();
			ruleData.put("RULEID",ruleId);
			ruleData.put("RULECODE",ruleCode);
			ruleData.put("RULENAME",ruleName);
			ruleData.put("RISK",risk);
			ruleData.put("RULE",rule);
			ruleData.put("RULEHTML",ruleConditionHTML);
			ruleData.put("ISENABLE",isEnable);
			ruleData.put("RULEOBJECTSNAME",tableNames);
			ruleData.put("STATUS","PENDING");
			ruleData.put("MAKERCODE",userCode);
			ruleData.put("USERCODE",userCode);
			ruleData.put("USERROLE",userRole);
			ruleData.put("MAKERIPADDRESS",remoteAddr);
			ruleData.put("VERSIONNO",Integer.toString(versionNo));
			ruleData.put("MAKERCOMMENTS",makerComment);
			ruleData.put("RULEFOR", CRPRuleFor);
			createCRPLog(ruleData,userCode);
			output.put("MESSAGE", message);
			//createCRPLog(tableNames,ruleId,ruleCode, ruleName, risk, isEnable,rule,ruleConditionHTML,userCode, userRole, remoteAddr,versionNo,"PENDING");
		}catch(Exception e){
			log.error("Error occurred while saving report : "+e.getMessage());
			e.printStackTrace();
			message = "Error occured while saving report!";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
			}
		
		return output;
	}

	@Override
	public String getCRPRulesDetails(String ruleID, String section,String userCode,String userRole, String remoteAddr) {
		String value = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+section+" FROM "+schemaName+"TB_CUSTRISKPROFILE_PENDING WHERE RULEID = ?");
			preparedStatement.setString(1, ruleID);
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

	@Override
	public String CRPobjectToSelect(String ruleID,String userCode,String userRole, String remoteAddr) {
		String objectHtml = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT RULEOBJECTSNAME FROM "+schemaName+"TB_CUSTRISKPROFILE_PENDING WHERE RULEID = ?");
			preparedStatement.setString(1, ruleID);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				objectHtml = resultSet.getString("RULEOBJECTSNAME");
			}
		}catch(Exception e){
			log.error("Error occurred checking object : "+e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return objectHtml;
	}

	@Override
	public Map<String, Object> validateCRPRules(String rule, String ruleID, String userCode,String userRole, String remoteAddr) {
		Map<String,Object> output = new HashMap<String,Object>();
		Connection connection =connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String procedureName = "STP_CUSTRISKPROFILEVALIDATION";
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+procedureName+"(?,?,?,?,?,?)}");
			callableStatement.setString(1, rule);
			callableStatement.setString(2, ruleID);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.setString(5, remoteAddr);
			callableStatement.registerOutParameter(6, OracleTypes.CURSOR);  
			callableStatement.execute();
			 resultSet = (ResultSet) callableStatement.getObject(6);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();

			Map<String, String> dataMap = new LinkedHashMap<String, String>();
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String colName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(colName, resultSet.getString(colName));
				}
			}
			output.put("RULERESULT", dataMap);
			//output.put("STATUS", true);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return output;
	}

	@Override
	public Map<String, Object> getRuleDetails(String ruleID,String CRPRuleStatus, String userCode,String userRole, String remoteAddr) {
		Map<String,Object>ruleDetails = new HashMap<String,Object>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			//System.out.println(CRPRuleStatus);
			ruleDetails.put("MESSAGE", "SUCCESS");
			if(CRPRuleStatus.equals("APPROVED")){
				String sql = "SELECT B.RULEID, B.RULECODE, B.RULENAME, B.RULE, "+
							 "		 B.RULEHTML, B.ISENABLE, B.RISK, B.MAKERCOMMENTS,B.CHECKERCOMMENTS,"+
							 "		 B.MAKERCODE,FUN_DATETOCHAR(B.MAKERTIMESTAMP) MAKERTIMESTAMP,B.MAKERIPADDRESS,B.STATUS,  "+
							 "       B.CHECKERCODE,FUN_DATETOCHAR(B.CHECKERTIMESTAMP) CHECKERTIMESTAMP,B.CHECKERIPADDRESS, B.RULEFOR "+
							 "  FROM "+schemaName+"TB_CUSTOMERRISKPROFILEDETAILS B "+
							 " WHERE B.RULEID = ? ";
				preparedStatement = connection.prepareStatement(sql);
			}else{
				String sql1 = "SELECT A.RULEID, A.RULECODE, A.RULENAME, A.RULE, "+
							  "	 	  A.RULEHTML, A.ISENABLE, A.RISK, A.MAKERCOMMENTS,A.CHECKERCOMMENTS, "+
							  "		  A.MAKERCODE,FUN_DATETOCHAR(A.MAKERTIMESTAMP) MAKERTIMESTAMP,A.MAKERIPADDRESS,A.STATUS, "+
							  "       A.CHECKERCODE,FUN_DATETOCHAR(A.CHECKERTIMESTAMP) CHECKERTIMESTAMP,A.CHECKERIPADDRESS, A.RULEFOR "+
							  "  FROM "+schemaName+"TB_CUSTRISKPROFILE_PENDING A "+
							  " WHERE A.RULEID = ?";
				preparedStatement = connection.prepareStatement(sql1);
			}
			
			preparedStatement.setString(1, ruleID);
			resultSet = preparedStatement.executeQuery();
			//resultSet.next();
			while(resultSet.next()){
				ruleDetails.put("RULEID", resultSet.getString("RULEID"));
				ruleDetails.put("RULECODE", resultSet.getString("RULECODE"));
				ruleDetails.put("RULENAME", resultSet.getString("RULENAME"));
				ruleDetails.put("RULE", resultSet.getString("RULE"));
				ruleDetails.put("RULEHTML", resultSet.getString("RULEHTML"));
				ruleDetails.put("ISENABLE", resultSet.getString("ISENABLE"));
				ruleDetails.put("RISK", resultSet.getString("RISK"));
				ruleDetails.put("MAKERCOMMENTS", resultSet.getString("MAKERCOMMENTS"));
				ruleDetails.put("MAKERCODE", resultSet.getString("MAKERCODE"));
				ruleDetails.put("MAKERTIMESTAMP", resultSet.getString("MAKERTIMESTAMP"));
				ruleDetails.put("MAKERIPADDRESS", resultSet.getString("MAKERIPADDRESS"));
				ruleDetails.put("STATUS", resultSet.getString("STATUS"));
				ruleDetails.put("CHECKERCODE", resultSet.getString("CHECKERCODE"));
				ruleDetails.put("CHECKERTIMESTAMP", resultSet.getString("CHECKERTIMESTAMP"));
				ruleDetails.put("CHECKERIPADDRESS", resultSet.getString("CHECKERIPADDRESS"));
				ruleDetails.put("CHECKERCOMMENTS", resultSet.getString("CHECKERCOMMENTS"));
				ruleDetails.put("RULEFOR", resultSet.getString("RULEFOR"));
				/*if(CRPRuleStatus.equals("APPROVED")){
				ruleDetails.put("CHECKERCOMMENTS", resultSet.getString("CHECKERCOMMENTS"));
			}*/
			ruleDetails.put("MESSAGE", "SUCCESS");
			//ruleDetails.put("STATUS", true);
			}
		}catch(Exception e){
			e.printStackTrace();
			ruleDetails.put("MESSAGE", "FAIL");
			//ruleDetails.put("STATUS", false);
			
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return ruleDetails;
	}
	
	public String createCRPLog(Map<String,String>ruleData,String userCode){
		String status = "FAIL";
		String insertQuery = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
	    //System.out.println("user code = "+ruleData.get("USERCODE")+"  user role = "+ruleData.get("USERROLE") );
			/*String insertQuery = "	INSERT INTO "+schemaName+"TB_CUSTRISKPROFILING_LOG( RULEID, RULECODE, RULENAME, RISK, RULE,  RULEHTML, ISENABLE,"
				           + "  UPDATETIMESTAMP, RULEOBJECTSNAME, STATUS,  ";
			if(ruleData.get("USERROLE").equals("ROLE_MLRO")){
				insertQuery += "MAKERCODE, MAKERTIMESTAMP, MAKERIPADDRESS,VERSIONNO,"
							+ " CHECKERCODE, CHECKERTIMESTAMP, CHECKERIPADDRESS, CHECKERCOMMENTS)";
			}else{
				insertQuery += " MAKERCODE, MAKERTIMESTAMP, MAKERIPADDRESS, VERSIONNO ) ";
			}
			insertQuery += 		 "  VALUES(?,?,?,?,?,?,?,SYSTIMESTAMP,?,?,?,SYSTIMESTAMP,?,?  ";
			if(ruleData.get("USERROLE").equals("ROLE_MLRO"))
				insertQuery += " ,?,SYSTIMESTAMP,?,? ";
			
			insertQuery += ")";*/
			// if(ruleData.get("USERROLE").equals("ROLE_MLRO")){
		    if(ruleData.get("USERROLE").contains("MLRO")){
				//log query for checker  
				insertQuery = "INSERT INTO "+schemaName+"TB_CUSTRISKPROFILING_LOG( "+
							  "		  RULEID, RULECODE, RULENAME, RISK, RULE,OBJECTHTML, RULEHTML, ISENABLE, UPDATETIMESTAMP, "+
					          "  	  RULEOBJECTSNAME, STATUS, MAKERCODE, MAKERIPADDRESS,MAKERCOMMENTS,VERSIONNO,UPDATEDBY,RULEFOR, "+
							  "		  MAKERTIMESTAMP, CHECKERCODE, CHECKERTIMESTAMP, CHECKERIPADDRESS, CHECKERCOMMENTS) "+
					          "VALUES(?,?,?,?,?,?,?,?,SYSTIMESTAMP, ?,?,?,?,?,?,?,?, FUN_CHARTODATE(?),?,SYSTIMESTAMP,?,?) ";
			}else{
				//log query for maker
				insertQuery = "INSERT INTO "+schemaName+"TB_CUSTRISKPROFILING_LOG( "+
						  	  "		  RULEID, RULECODE, RULENAME, RISK, RULE,OBJECTHTML, RULEHTML, ISENABLE, UPDATETIMESTAMP, "+
				              "  	  RULEOBJECTSNAME, STATUS, MAKERCODE, MAKERIPADDRESS,MAKERCOMMENTS, VERSIONNO,UPDATEDBY,RULEFOR,"+
				              "     MAKERTIMESTAMP)"+
					          "VALUES(?,?,?,?,?,?,?,?,SYSTIMESTAMP, ?,?,?,?,?,?,?,?,SYSTIMESTAMP )";
			}
		//	System.out.println("query = "+insertQuery);
		try{
			preparedStatement = connection.prepareStatement(insertQuery);
			preparedStatement.setString(1, ruleData.get("RULEID"));
			preparedStatement.setString(2, ruleData.get("RULECODE"));
			preparedStatement.setString(3, ruleData.get("RULENAME"));
			preparedStatement.setString(4, ruleData.get("RISK"));
			preparedStatement.setString(5, ruleData.get("RULE"));
			preparedStatement.setString(6, ruleData.get("OBJECTHTML"));
			preparedStatement.setString(7, ruleData.get("RULEHTML"));
			preparedStatement.setString(8, ruleData.get("ISENABLE"));
			
			preparedStatement.setString(9, ruleData.get("RULEOBJECTSNAME"));
			preparedStatement.setString(10, ruleData.get("STATUS"));
			preparedStatement.setString(11, ruleData.get("MAKERCODE"));
			preparedStatement.setString(12, ruleData.get("MAKERIPADDRESS"));
			preparedStatement.setString(13, ruleData.get("MAKERCOMMENTS"));
			preparedStatement.setInt(14, Integer.parseInt(ruleData.get("VERSIONNO")));
			preparedStatement.setString(15, userCode);
			preparedStatement.setString(16,ruleData.get("RULEFOR"));
			// if(ruleData.get("URROLE").equals("ROLE_MLRO")){
		    if(ruleData.get("USERROLE").contains("MLRO")){
				preparedStatement.setString(17, ruleData.get("MAKERTIMESTAMP"));
				preparedStatement.setString(18, ruleData.get("CHECKERCODE"));
				preparedStatement.setString(19, ruleData.get("CHECKERIPADDRESS"));
				preparedStatement.setString(20, ruleData.get("CHECKERCOMMENTS"));
			}
			preparedStatement.execute();
			status = "SUCCESS";
		}catch(Exception e){
			e.printStackTrace();
			status = "FAIL";
			log.error("Error while maintaing log for CRP rules.");
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return status;
	}

	@SuppressWarnings("resource")
	@Override
	public String CRPRuleStatusChange(String ruleID, String comment,String CRPRuleStatus, String userCode, 
									  String userRole, String remoteAddr) {
		String status = "FAIL";
		String mainTableInsertStatus = "FAIL";
		String logTableInsertStatus = "FAIL";
		String message = "";
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		Map <String,String> ruleData = new HashMap<String,String>();
		PreparedStatement preparedStatement = null;
		try{
			String sql = "SELECT RULEID, RULECODE, RULENAME, RISK, RULE, OBJECTHTML, RULEHTML, ISENABLE, "+
						 "	  	 FUN_DATETOCHAR(UPDATETIMESTAMP) UPDATETIMESTAMP, RULEOBJECTSNAME,"+
						 "		 STATUS, MAKERCODE, FUN_DATETOCHAR(MAKERTIMESTAMP) MAKERTIMESTAMP, "+
						 "		 MAKERIPADDRESS, VERSIONNO, MAKERCOMMENTS,RULEFOR "+
						 "  FROM "+schemaName+"TB_CUSTRISKPROFILE_PENDING WHERE RULEID = ? ";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, ruleID);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				ruleData.put("RULEID",resultSet.getString("RULEID"));
				ruleData.put("RULECODE",resultSet.getString("RULECODE"));
				ruleData.put("RULENAME",resultSet.getString("RULENAME"));
				ruleData.put("RISK",resultSet.getString("RISK"));
				ruleData.put("RULE",resultSet.getString("RULE"));
				ruleData.put("OBJECTHTML",resultSet.getString("OBJECTHTML"));
				ruleData.put("RULEHTML",resultSet.getString("RULEHTML"));
				ruleData.put("ISENABLE",resultSet.getString("ISENABLE"));
				ruleData.put("UPDATETIMESTAMP",resultSet.getString("UPDATETIMESTAMP"));
				ruleData.put("RULEOBJECTSNAME",resultSet.getString("RULEOBJECTSNAME"));
				ruleData.put("STATUS",resultSet.getString("STATUS"));
				ruleData.put("MAKERCODE",resultSet.getString("MAKERCODE"));
				ruleData.put("MAKERTIMESTAMP",resultSet.getString("MAKERTIMESTAMP"));
				ruleData.put("MAKERIPADDRESS",resultSet.getString("MAKERIPADDRESS"));
				ruleData.put("VERSIONNO",resultSet.getString("VERSIONNO"));
				ruleData.put("MAKERCOMMENTS",resultSet.getString("MAKERCOMMENTS"));
				ruleData.put("RULEFOR",resultSet.getString("RULEFOR"));
			}
			//System.out.println("ruleData = "+ruleData);
			if(CRPRuleStatus.equals("APPROVED")){
				mainTableInsertStatus = insertRuleIntoMainTable(ruleData,userCode,remoteAddr,ruleID,CRPRuleStatus,comment);
			}
			//for creating logs..
			Map<String,String>ruleDataForLog = new HashMap<String,String>();
			ruleDataForLog.put("RULEID",ruleID);
			ruleDataForLog.put("RULECODE",ruleData.get("RULECODE"));
			ruleDataForLog.put("RULENAME",ruleData.get("RULENAME"));
			ruleDataForLog.put("RISK",ruleData.get("RISK"));
			ruleDataForLog.put("RULE",ruleData.get("RULE"));
			ruleDataForLog.put("OBJECTHTML",ruleData.get("OBJECTHTML"));
			ruleDataForLog.put("RULEHTML",ruleData.get("RULEHTML"));
			ruleDataForLog.put("ISENABLE",ruleData.get("ISENABLE"));
			ruleDataForLog.put("RULEOBJECTSNAME",ruleData.get("RULEOBJECTSNAME"));
			ruleDataForLog.put("STATUS",mainTableInsertStatus.equals("SUCCESS")?"APPROVED":"REJECTED");
			ruleDataForLog.put("CHECKERCODE",userCode);
			ruleDataForLog.put("USERCODE",userCode);
			ruleDataForLog.put("USERROLE",userRole);
			ruleDataForLog.put("CHECKERIPADDRESS",remoteAddr);
			ruleDataForLog.put("VERSIONNO",ruleData.get("VERSIONNO"));
			ruleDataForLog.put("CHECKERCOMMENTS",comment);
			ruleDataForLog.put("MAKERCODE", ruleData.get("MAKERCODE"));
			ruleDataForLog.put("MAKERIPADDRESS", ruleData.get("MAKERIPADDRESS"));
			ruleDataForLog.put("MAKERCOMMENTS", ruleData.get("MAKERCOMMENTS"));
			ruleDataForLog.put("MAKERTIMESTAMP", ruleData.get("MAKERTIMESTAMP"));
			ruleDataForLog.put("RULEFOR", ruleData.get("RULEFOR"));
			logTableInsertStatus = createCRPLog(ruleDataForLog,userCode);
			//for deletion from pending table 
			
			if(logTableInsertStatus.equals("SUCCESS") && CRPRuleStatus.equals("APPROVED")){
				try{
					preparedStatement = connection.prepareStatement("DELETE FROM "+schemaName+"TB_CUSTRISKPROFILE_PENDING WHERE RULEID = ?");
					preparedStatement.setString(1, ruleID);
					preparedStatement.execute();
					status = "SUCCESS";	
				}catch(Exception e){
					log.error("Error while deleting from pending table "+e.getMessage());
					e.printStackTrace();
				}
			}else{
				try{
					String updateQuery = " UPDATE "+schemaName+"TB_CUSTRISKPROFILE_PENDING SET STATUS = ?,CHECKERCODE = ?, "+
										 " CHECKERTIMESTAMP = SYSTIMESTAMP,CHECKERIPADDRESS = ?,CHECKERCOMMENTS = ?,UPDATEDBY = ?"+
							             " WHERE RULEID = ?";
					preparedStatement = connection.prepareStatement(updateQuery);
					preparedStatement.setString(1, CRPRuleStatus);
					preparedStatement.setString(2, userCode);
					preparedStatement.setString(3, remoteAddr);
					preparedStatement.setString(4, comment);
					preparedStatement.setString(5, userCode);
					preparedStatement.setString(6, ruleID);
					preparedStatement.executeUpdate();
					status = "SUCCESS";	
				}catch(Exception e){
					log.error("Error while Updating Status of Pending table "+e.getMessage());
					e.printStackTrace();
				}
				
			}
		}catch(Exception e){
			log.error("Error while approving/rejecting rule.");
			e.printStackTrace();
			status = "SUCCESS";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		
		if(status.equals("SUCCESS")){
			if(CRPRuleStatus.equals("APPROVED")){
				message = "The rule has been approved";
			}else{
				message = "The rule has been rejected";
			}
		}else{
			message = "Error while approving/rejecting rule.";
		}
	return message;
	}
	
	//function for inserting rule into main table after approved/reject from mlro
	@SuppressWarnings("resource")
	public String insertRuleIntoMainTable(Map<String,String> ruleData,String userCode,String remoteAddr,String ruleID,String CRPRuleStatus,String checkerComments){
		Connection connection = connectionUtil.getConnection();
		ResultSet resultSet = null;
		PreparedStatement preparedStatement = null;
		String mainTableInsertStatus = "FAIL";
		boolean isNew = true;
			String insertQuery = " INSERT INTO "+schemaName+"TB_CUSTOMERRISKPROFILEDETAILS( "+
								 "		  RULEID, RULECODE, RULENAME, RULE, RISK, OBJECTHTML, "+ 
								 "		  RULEHTML, ISENABLE, RULEOBJECTSNAME, STATUS, VERSIONNO, MAKERCODE, "+
								 "		  MAKERTIMESTAMP, MAKERIPADDRESS, MAKERCOMMENTS, CHECKERCODE, CHECKERTIMESTAMP, CHECKERIPADDRESS, "+
								 "		  CHECKERCOMMENTS, UPDATETIMESTAMP,UPDATEDBY,RULEFOR) "+
								 " VALUES(?,?,?,?,?,?,"+
								 "	      ?,?,?,?,?,?,"+
								 "		  FUN_CHARTODATE(?),?,?,?,SYSTIMESTAMP,?,"+
								 "		  ?,SYSTIMESTAMP,?,?)";
			
			String updateQuery ="UPDATE "+schemaName+"TB_CUSTOMERRISKPROFILEDETAILS SET "+
								"		RULECODE=?, RULENAME=?, RULE=?, RISK=?, OBJECTHTML=?, "+
								"		RULEHTML=?, ISENABLE=?, RULEOBJECTSNAME=?, STATUS=?, VERSIONNO=?, "+
								"		MAKERCODE=?, MAKERTIMESTAMP=FUN_CHARTODATE(?), MAKERIPADDRESS=?, "+
								" 		MAKERCOMMENTS=?, CHECKERCODE=?, CHECKERTIMESTAMP = SYSTIMESTAMP, "+
								"		CHECKERIPADDRESS=?, CHECKERCOMMENTS = ?,UPDATETIMESTAMP = SYSTIMESTAMP,UPDATEDBY = ?,RULEFOR=? "+
								" WHERE RULEID = ? ";
			try{
				
				preparedStatement = connection.prepareStatement("SELECT RULEID FROM "+schemaName+"TB_CUSTOMERRISKPROFILEDETAILS WHERE RULEID = ?");
				preparedStatement.setString(1, ruleID);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					isNew = false;
				}
				if(isNew){
					preparedStatement = connection.prepareStatement(insertQuery);
					preparedStatement.setString(1, ruleID);
					preparedStatement.setString(2, ruleData.get("RULECODE"));
					preparedStatement.setString(3, ruleData.get("RULENAME"));
					preparedStatement.setString(4, ruleData.get("RULE"));
					preparedStatement.setString(5, ruleData.get("RISK"));
					preparedStatement.setString(6, ruleData.get("OBJECTHTML"));
					preparedStatement.setString(7, ruleData.get("RULEHTML"));
					preparedStatement.setString(8, ruleData.get("ISENABLE"));
					preparedStatement.setString(9, ruleData.get("RULEOBJECTSNAME"));
					preparedStatement.setString(10, "APPROVED");
					preparedStatement.setString(11, ruleData.get("VERSIONNO"));
					preparedStatement.setString(12, ruleData.get("MAKERCODE"));
					preparedStatement.setString(13, ruleData.get("MAKERTIMESTAMP"));
					preparedStatement.setString(14, ruleData.get("MAKERIPADDRESS"));
					preparedStatement.setString(15, ruleData.get("MAKERCOMMENTS"));
					preparedStatement.setString(16, userCode);
					preparedStatement.setString(17, remoteAddr);
					preparedStatement.setString(18, checkerComments);
					preparedStatement.setString(19, userCode);
					preparedStatement.setString(20,ruleData.get("RULEFOR"));
					preparedStatement.executeUpdate();	
					mainTableInsertStatus = "SUCCESS";
				}else{
					preparedStatement = connection.prepareStatement(updateQuery);
					preparedStatement.setString(1, ruleData.get("RULECODE"));
					preparedStatement.setString(2, ruleData.get("RULENAME"));
					preparedStatement.setString(3, ruleData.get("RULE"));
					preparedStatement.setString(4, ruleData.get("RISK"));
					preparedStatement.setString(5, ruleData.get("OBJECTHTML"));
					preparedStatement.setString(6, ruleData.get("RULEHTML"));
					preparedStatement.setString(7, ruleData.get("ISENABLE"));
					preparedStatement.setString(8, ruleData.get("RULEOBJECTSNAME"));
					preparedStatement.setString(9, "APPROVED");
					preparedStatement.setString(10, ruleData.get("VERSIONNO"));
					preparedStatement.setString(11, ruleData.get("MAKERCODE"));
					preparedStatement.setString(12, ruleData.get("MAKERTIMESTAMP"));
					preparedStatement.setString(13, ruleData.get("MAKERIPADDRESS"));
					preparedStatement.setString(14, ruleData.get("MAKERCOMMENTS"));
					preparedStatement.setString(15, userCode);
					preparedStatement.setString(16, remoteAddr);
					preparedStatement.setString(17, checkerComments);
					preparedStatement.setString(18, userCode);
					preparedStatement.setString(19,ruleData.get("RULEFOR"));
					preparedStatement.setString(20, ruleID);
					preparedStatement.executeUpdate();	
					mainTableInsertStatus = "SUCCESS";
				}
				
			}catch(Exception e){
				log.error("error while inserting in main table ");
				e.printStackTrace();
			}
		return mainTableInsertStatus;
	}

	
	
}
