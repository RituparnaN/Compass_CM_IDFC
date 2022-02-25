package com.quantumdataengines.app.compass.dao.caseWorkFlow;

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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class FATCACaseWorkFlowDAOImpl implements FATCACaseWorkFlowDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Override
	public List<Map<String, Object>> getModuleParameters(String moduleType, String userCode, String userRole, String ipAddress) {
		List<Map<String, Object>> labelsList = new Vector<Map<String, Object>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETMODULEPARAMETERS(?,?,?,?,?)}");
			callableStatement.setString(1, moduleType);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(5);
			while(resultSet.next()){
				Map<String, Object> label = new HashMap<String, Object>();
				label.put("MODULECODE", resultSet.getString("MODULECODE"));
				label.put("MODULENAME", resultSet.getString("MODULENAME"));
				label.put("MODULEPARAMNAME", resultSet.getString("MODULEPARAMNAME"));
				label.put("MODULEPARAMALIASNAME", resultSet.getString("MODULEPARAMALIASNAME"));
				label.put("MODULEPARAMIDNAME", resultSet.getString("MODULEPARAMIDNAME"));
				label.put("MODULEPARAMINDEX", resultSet.getInt("MODULEPARAMINDEX"));
				label.put("MODULEPARAMDATATYPE", resultSet.getString("MODULEPARAMDATATYPE"));
				label.put("MODULEPARAMVIEWNAME", resultSet.getString("MODULEPARAMVIEWNAME"));
				label.put("MODULEPARAMSTATICVALUES", resultSet.getString("MODULEPARAMSTATICVALUES"));
				label.put("MODULEPARAMDEFAULTVALUE", resultSet.getString("MODULEPARAMDEFAULTVALUE"));
				label.put("MODULEPARAMVALIDATIONFIELD", resultSet.getString("MODULEPARAMVALIDATIONFIELD"));
				label.put("MODULEPARAMVALIDATIONTYPE", resultSet.getString("MODULEPARAMVALIDATIONTYPE"));
				
				
				if("select".equals(resultSet.getString("MODULEPARAMDATATYPE"))){
					Map<String, String> selectList = new LinkedHashMap<String, String>();
					if(!"NA".equals(resultSet.getString("MODULEPARAMVIEWNAME"))){
						selectList.putAll(getOptionNameValueFromView(resultSet.getString("MODULEPARAMVIEWNAME")));
					}else{
						String paramStaticValues = resultSet.getString("MODULEPARAMSTATICVALUES");
						String[] optionNameValueArr = paramStaticValues.split("\\^");
						for(String optionNameValue : optionNameValueArr){
							String [] optionArr = optionNameValue.split("\\|");
							selectList.put(optionArr[0], optionArr[1]);
						}
					}
					label.put("MODULEPARAMSELECTNAMEVALUES", selectList);
				}
				
				labelsList.add(label);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return labelsList;
	}
	
	private Map<String, String> getOptionNameValueFromView(String viewName){
		Map<String, String> selectList = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT OPTIONNAME, OPTIONVALUE FROM "+viewName);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				selectList.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return selectList;
	}
	
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
	
	private String prepareProcedureName(String procedureName, Map<String, String> paramMap){
		Iterator<String> itr = paramMap.keySet().iterator();
		String finalProcedureName = "{CALL "+procedureName+"(";
		while(itr.hasNext()){
			finalProcedureName = finalProcedureName + ":"+itr.next()+",";
		}
		finalProcedureName = finalProcedureName + ":USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
		return finalProcedureName;
	}
	
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress){
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		Iterator<String> itr = paramMap.keySet().iterator();
		String sql = prepareProcedureName(procedureName, paramMap);
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		
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
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(columnName));
				}
				data.add(record);
			}
			
			resultData.put("HEADER", header);
			resultData.put("DATA", data);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultData;
	}
	
	public Map<String, Object> getCaseCommentDetails(String caseNos, String caseStatus, String userCode, String userRole, String ipAddress){
		String procedureName = "{CALL STP_GETFATCACASECOMMENTDETAILS(:CASENOS, :CASESTATUS, :USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall(procedureName);
			callableStatement.setString("CASENOS", caseNos);
			callableStatement.setString("CASESTATUS", caseStatus);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("ROLECODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					resultData.put(columnName, resultSet.getString(columnName));
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultData;
	}
	
	public Map<String, Object> saveCaseCommentDetails(String caseNos, String caseStatus, HashMap<String, String> commentMapDetails, String userCode, String userRole, String ipAddress){
		String procedureName = "{CALL STP_SAVEFATCACASECOMMENTDETAIL(:CASENOS, :CASESTATUS, " +
				":COMMENTS, :FRAUDINDICATOR, :REMOVALREASON, :OUTCOMEINDICATOR, "+
				":HIGHRISKREASONCODE, :ADDESTOFALSEPOSITITVE, :LASTREVIEWEDDATE, "+
				":USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		String updateMessage = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall(procedureName);
			callableStatement.setString("CASENOS", caseNos);
			callableStatement.setString("CASESTATUS", caseStatus);
			callableStatement.setString("COMMENTS", commentMapDetails.get("comments"));
			callableStatement.setString("FRAUDINDICATOR", commentMapDetails.get("fraudIndicator"));
			callableStatement.setString("REMOVALREASON", commentMapDetails.get("removalReason"));
			callableStatement.setString("OUTCOMEINDICATOR", commentMapDetails.get("outcomeIndicator"));
			callableStatement.setString("HIGHRISKREASONCODE", commentMapDetails.get("highRiskReasonCode"));
			callableStatement.setString("ADDESTOFALSEPOSITITVE", commentMapDetails.get("addedToFalsePositive"));
			callableStatement.setString("LASTREVIEWEDDATE", commentMapDetails.get("lastReviewedDate"));
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("ROLECODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			
			while(resultSet.next()){
				updateMessage = resultSet.getString("UPDATEMESSAGE");
			}
			
			resultData = getCaseCommentDetails(caseNos, caseStatus, userCode, userRole, ipAddress);
			resultData.put("updateMessage", updateMessage);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultData;
	}
	
	public List<Map<String, String>> getListOfUsers(){
		List<Map<String, String>> usersList = new ArrayList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "SELECT A.USERCODE, A.FIRSTNAME || ' ' ||A.LASTNAME AS USERNAME FROM TB_USER A, TB_USERROLEMAPPING B "+
					 " WHERE A.USERCODE = B.USERCODE AND ROLEID = 'FATCARMUSER' ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> user = new LinkedHashMap<String, String>();
				user.put("USERCODE", resultSet.getString("USERCODE"));
				user.put("USERNAME", resultSet.getString("USERNAME"));
			usersList.add(user);	
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
		}
		return usersList;		
	}
	
	public String assignCaseToRMUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, String caseRating, String listOfCaseNos, 
								 	 String branchCode, String listOfUsers, String comments, String userCode, String ipAddress, String userRole){
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		
		caseNo = caseNo.replace(",", "','");
		caseNo = "'"+caseNo+"'";
		System.out.println(caseNo);
		
		String procedureName = "{CALL STP_ASSIGNCASESTORMUSER(:CASENO, :CASESTATUS, :CASERANGEFROM, :CASERANGETO, :HASOLDCASES," +
							":CASERATING, :BRANCHCODE, :LISTOFCASENOS, :LISTOFUSERS, :COMMENTS, :USERCODE, :IPADDRESS, :USERROLE, :RESULTSET)}";
		String result = "No cases have been assigned.";
		ResultSet resultSet = null;
			try{
			callableStatement = connection.prepareCall(procedureName);
			callableStatement.setString("CASENO", caseNo);
			callableStatement.setString("CASESTATUS", caseStatus);
			callableStatement.setString("CASERANGEFROM", caseRangeFrom);
			callableStatement.setString("CASERANGETO", caseRangeTo);
			callableStatement.setString("HASOLDCASES", hasOldCases);
			callableStatement.setString("CASERATING", caseRating);
			callableStatement.setString("BRANCHCODE", branchCode);
			callableStatement.setString("LISTOFCASENOS", listOfCaseNos);
			callableStatement.setString("LISTOFUSERS", listOfUsers);
			callableStatement.setString("COMMENTS", comments);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.setString("USERROLE", userRole);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			
			while(resultSet.next()){
				result = resultSet.getString("RESULTMESSAGE");
			}
		}catch(Exception e){
			e.printStackTrace();
			result = "Error occured while assigning cases to user.";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return result;
	}


}
