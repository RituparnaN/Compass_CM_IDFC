package com.quantumdataengines.app.compass.dao.master;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import oracle.jdbc.OracleTypes;
import oracle.net.aso.p;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.quantumdataengines.app.compass.util.DocumentFromWSDL;

@Repository
public class GenericMasterDAOImpl implements GenericMasterDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	@Autowired
	private DocumentFromWSDL documentFromWSDL;
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
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
				label.put("SEARCHMULTIPLESELECT", resultSet.getString("SEARCHMULTIPLESELECT"));
				
				
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
	
	public Map<String, String> getOptionNameValueFromView(String viewName){
		Map<String, String> selectList = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		//System.out.println(connection);
		//System.out.println(viewName);
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
	
	public List<String> getViewOrTableColumns(String objectName){
		List<String> columns = new Vector<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		//System.out.println("objectName = "+objectName);
		try{
			preparedStatement = connection.prepareStatement("SELECT COLUMN_NAME FROM USER_TAB_COLUMNS WHERE TABLE_NAME = ? ORDER BY COLUMN_ID");
			preparedStatement.setString(1, objectName);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()){
				columns.add(resultSet.getString("COLUMN_NAME"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		return columns;
	}
	
	public Map<String, Object> searchGenericModuleFields(String viewName, String searchBy, String searchString, String columnName){
		Map<String, Object> mainMap = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETSEARCHDATA_FROMVIEW(?,?,?,?,?)}");
			callableStatement.setString(1, viewName);
			callableStatement.setString(2, searchBy);
			callableStatement.setString(3, searchString);
			callableStatement.setString(4, columnName);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(5);
			
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				header.add(resultSetMetaData.getColumnName(colIndex));
			}
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String colName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(colName));
				}
				data.add(record);
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
	
	private String prepareProcedureWithModuleType(String procedureName, Map<String, String> paramMap){
		Iterator<String> itr = paramMap.keySet().iterator();
		String finalProcedureName = "{CALL "+procedureName+"(";
		while(itr.hasNext()){
			finalProcedureName = finalProcedureName + ":"+itr.next()+",";
		}
		finalProcedureName = finalProcedureName + ":USERCODE, :ROLECODE, :IPADDRESS,  :MODULETYPE, :RESULTSET)}";
		return finalProcedureName;
	}
	
/*
	//changes start for reset(enable&disable columns)
		public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress){
			String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
			// System.out.println(moduleType+" "+procedureName);
			
			Iterator<String> itr = paramMap.keySet().iterator();
			String sql = prepareProcedureName(procedureName, paramMap);
			Map<String, Object> resultData = new HashMap<String, Object>();
			List<String> header = new Vector<String>();
			List<String> columnList = new ArrayList<String>();
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
					//header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
					columnList.add(resultSetMetaData.getColumnName(colIndex));
				}
				ArrayList<String> existClumnsList =  getExistingColumns(userCode,moduleType);
				ArrayList<String>  enabledColumnList = getEnabledColumns(userCode, moduleType, existClumnsList,columnList );
				
				Map<String,String> columnDetails = new LinkedHashMap<String,String>();
				for(String colName:columnList){
					if(enabledColumnList.contains(colName)){
						columnDetails.put(colName, "Y");
					}else{
						columnDetails.put(colName, "N");
					}
				}
				
				
				for(String enableColName : enabledColumnList){
					header.add(CommonUtil.changeColumnName(enableColName));
				}
				while(resultSet.next()){
					List<String> record = new Vector<String>();
					for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
						String columnName = resultSetMetaData.getColumnName(colIndex);
						if(enabledColumnList.contains(columnName)){
							record.add(resultSet.getString(columnName));
						}
					}
					data.add(record);
				}
				resultData.put("COLUMNDETAILS", columnDetails);
				resultData.put("HEADER", header);
				resultData.put("DATA", data);
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, callableStatement, resultSet, null);
			}
			return resultData;
		}
		
		//changes end for reset(enable&disable columns)
		
*/
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress){
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		System.out.println(moduleType+" "+procedureName);
		
		Iterator<String> itr = paramMap.keySet().iterator();
		String sql = prepareProcedureName(procedureName, paramMap);
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> columnList = new ArrayList<String>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Map<String,String> columnDetails = new LinkedHashMap<String,String>();
		//Map<String,String> columnDetails1 = new LinkedHashMap<String,String>();
		
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall(sql);
			while(itr.hasNext()){
				String paramName = itr.next();
				String paramValue = paramMap.get(paramName);
				//System.out.println(paramName+" "+paramValue);
				// callableStatement.setString(paramName, paramValue);
				callableStatement.setString(paramName, paramValue.replaceAll("[^a-zA-Z0-9@ /_-]", ""));
			}
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("ROLECODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				//header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
				//columnDetails.put(resultSetMetaData.getColumnName(colIndex), "Y");
				columnList.add(resultSetMetaData.getColumnName(colIndex));
			}
			ArrayList<String> existColumnsList =  getExistingColumns(userCode,moduleType);
			
			ArrayList<String>  enabledColumnList = getEnabledColumns(userCode, moduleType, columnList , existColumnsList);
			columnDetails = getAllColumnOfModule(userCode, moduleType); 
			for(String enableColName : enabledColumnList){
				header.add(CommonUtil.changeColumnName(enableColName));
			}
			
			/*while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					record.add(resultSet.getString(columnName));
				}
				data.add(record);
			}*/
			
			while(resultSet.next()){
				List<String> record = new Vector<String>();
				for(String columnName:enabledColumnList ){
					record.add(resultSet.getString(columnName));
				}
				data.add(record);
			}

			resultData.put("COLUMNDETAILS", columnDetails);
			resultData.put("HEADER", header);
			resultData.put("DATA", data);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultData;
	}
	
	public Map<String, Object> searchMasterWithModuleType(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress){
		String procedureName = getProcedureName("SEARCHPROCEDURENAME", moduleType);
		// System.out.println(moduleType+" "+procedureName);
		
		Iterator<String> itr = paramMap.keySet().iterator();
		String sql = prepareProcedureWithModuleType(procedureName, paramMap);
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
				// callableStatement.setString(paramName, paramValue);
				callableStatement.setString(paramName, paramValue.replaceAll("[^a-zA-Z0-9@ /_-]", ""));
			}
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("ROLECODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.setString("MODULETYPE", moduleType);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
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
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		
		return resultData;
	}
	
	public int getNoOfINOUTParam(String procedureName){
		int count = 0 ;
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement("SELECT COUNT(IN_OUT) COUNT FROM USER_ARGUMENTS WHERE OBJECT_NAME = ? AND IN_OUT = ?");
			preparedStatement.setString(1, procedureName);
			preparedStatement.setString(2, "IN/OUT");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next())
				count = resultSet.getInt("COUNT");
		}catch(Exception e){
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return count;
	}
	
	public Map<String, Object> getModuleDetails(String moduleCode, String moduleValue, String userCode, String groupCode, String ipAddress){
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		String procedureName = getProcedureName("DETAILPROCEDURENAME", moduleCode);
		int noOfResultSet = getNoOfINOUTParam(procedureName);
		String tabNames = "";
		String tabDisplay = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; ResultSet resultSet2 = null;
		List<ResultSet> resultSetList = new Vector<ResultSet>();
		
		String sql = "{CALL "+procedureName+"(:MODULEVALUE, :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, :RESULTSET2, ";
		for(int i = 3; i <= noOfResultSet; i++){
			if(i == noOfResultSet)
				sql = sql + ":RESULTSET"+i+" ";
			else
				sql = sql + ":RESULTSET"+i+", ";
		}
		sql = sql + ")}";
		
		System.out.println("Module Details Proc : "+sql);
		System.out.println("moduleValue : "+moduleValue+", userCode: "+userCode+", groupCode: "+groupCode+", ipAddress : "+ipAddress);
		
		try{
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString("MODULEVALUE", moduleValue);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("GROUPCODE", groupCode);
			callableStatement.setString("IPADDRESS", ipAddress);
			
			callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
			callableStatement.registerOutParameter("RESULTSET2", OracleTypes.CURSOR);
			
			for(int i = 3; i <= noOfResultSet; i++){
				String indexName = "RESULTSET"+i;
				callableStatement.registerOutParameter(indexName, OracleTypes.CURSOR);
			}
			
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject("RESULTSET1");
			if(resultSet1.next()){
				tabNames = resultSet1.getString("TABNAMES");
			}
			List<String> tabNameList = Arrays.asList(CommonUtil.splitString(tabNames, "^~^"));
			mainMap.put("TABNAMES", tabNameList);
			
			resultSet2 = (ResultSet) callableStatement.getObject("RESULTSET2");
			if(resultSet2.next()){
				tabDisplay = resultSet2.getString("TABDISPLAY");
			}
			List<String> tabDisplayList = Arrays.asList(CommonUtil.splitString(tabDisplay, "^~^"));
			Map<String, String> tabDisplayMap = new LinkedHashMap<String, String>();
			for(int i = 0; i < tabDisplayList.size(); i++){
				tabDisplayMap.put(Integer.toString(i), tabDisplayList.get(i));
			}
			mainMap.put("TABDISPLAY", tabDisplayMap);
			
			for(int i = 3; i <= noOfResultSet; i++){
				ResultSet resultSet = (ResultSet) callableStatement.getObject("RESULTSET"+i);
				resultSetList.add(resultSet);
			}
			
			for(int i = 0; i < resultSetList.size(); i++){
				mainMap.put(Integer.toString(i), processResultSet(resultSetList.get(i)));
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return mainMap;
	}
	
	private List<Map<String, String>> processResultSet(ResultSet resultSet) throws Exception{
		List<Map<String, String>> fieldsDetails = new Vector<Map<String, String>>();
		List<String> headers = new Vector<String>();
		ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
		for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
			headers.add(resultSetMetaData.getColumnName(colIndex));
		}
		
		while (resultSet.next()) {
			Map<String, String> field = new LinkedHashMap<String, String>();
			for(String header : headers){
				// field.put(header, resultSet.getString(header));
				field.put(CommonUtil.changeColumnName(header), resultSet.getString(header));
			}
			fieldsDetails.add(field);
		}
		return fieldsDetails;
	}
	
	@SuppressWarnings("resource")
	public String saveSuspiciousTransaction(String alertNo, String txnDate, String txnMode, String debitcredit,
			String amount, String remarks, String userCode){
		Connection connection = connectionUtil.getConnection();
		String seqNo = "";
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT "+schemaName+"SEQ_RAISESUSPICION_TRANSACTION.NEXTVAL AS SEQNO FROM DUAL");
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				seqNo = new Integer(resultSet.getInt("SEQNO")).toString();
			}
			
			String sql = "INSERT INTO "+schemaName+"TB_TYPEOFSUSPICIONTRANSACTION (ALERTNO, SEQUENCENO, TRANSACTIONDATE, TRANSACTIONMODE, "+
						 "		 DEBITCREDIT, TRANSACTIONAMOUNT, TRANSACTIONREMARKS, UPDATEDBY, UPDATETIMESTAMP) "+
						 "VALUES (?, ?, ?, ?, ?, ?, ? ,?, SYSTIMESTAMP) ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertNo);
			preparedStatement.setString(2, seqNo);
			preparedStatement.setString(3, txnDate);
			preparedStatement.setString(4, txnMode);
			preparedStatement.setString(5, debitcredit);
			preparedStatement.setString(6, amount);
			preparedStatement.setString(7, remarks);
			preparedStatement.setString(8, userCode);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return alertNo;
	}
	
	public List<Map<String,String>> getSuspiciousTransaction(String alertNo){
		List<Map<String,String>> dataList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT ALERTNO, SEQUENCENO, TRANSACTIONDATE, TRANSACTIONMODE, "+
						 "		 DEBITCREDIT, TRANSACTIONAMOUNT, TRANSACTIONREMARKS, UPDATEDBY "+
						 "  FROM "+schemaName+"TB_TYPEOFSUSPICIONTRANSACTION "+
						 " WHERE ALERTNO = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertNo);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new HashMap<String, String>();
				dataMap.put("ALERTNO", resultSet.getString("ALERTNO"));
				dataMap.put("SEQUENCENO", resultSet.getString("SEQUENCENO"));
				dataMap.put("TRANSACTIONDATE", resultSet.getString("TRANSACTIONDATE"));
				dataMap.put("TRANSACTIONMODE", resultSet.getString("TRANSACTIONMODE"));
				dataMap.put("DEBITCREDIT", resultSet.getString("DEBITCREDIT"));
				dataMap.put("TRANSACTIONAMOUNT", resultSet.getString("TRANSACTIONAMOUNT"));
				dataMap.put("TRANSACTIONREMARKS", resultSet.getString("TRANSACTIONREMARKS"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public Map<String, String> showSuspiciousTransactionDetails(String seqNo, String alertNo){
		Map<String, String> dataMap = new HashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "SELECT ALERTNO, SEQUENCENO, TRANSACTIONDATE, TRANSACTIONMODE, "+
						 "		 DEBITCREDIT, TRANSACTIONAMOUNT, TRANSACTIONREMARKS, UPDATEDBY "+
						 "  FROM "+schemaName+"TB_TYPEOFSUSPICIONTRANSACTION "+
						 " WHERE ALERTNO = ? "+
						 "	 AND SEQUENCENO = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertNo);
			preparedStatement.setString(2, seqNo);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()){
				dataMap.put("ALERTNO", resultSet.getString("ALERTNO"));
				dataMap.put("SEQUENCENO", resultSet.getString("SEQUENCENO"));
				dataMap.put("TRANSACTIONDATE", resultSet.getString("TRANSACTIONDATE"));
				dataMap.put("TRANSACTIONMODE", resultSet.getString("TRANSACTIONMODE"));
				dataMap.put("DEBITCREDIT", resultSet.getString("DEBITCREDIT"));
				dataMap.put("TRANSACTIONAMOUNT", resultSet.getString("TRANSACTIONAMOUNT"));
				dataMap.put("TRANSACTIONREMARKS", resultSet.getString("TRANSACTIONREMARKS"));
				dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}
	
	public String deleteSuspiciousTransactionDetails(String seqNo, String alertNo){
		String result = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		
		try{
			String sql = "DELETE FROM "+schemaName+"TB_TYPEOFSUSPICIONTRANSACTION "+
						 " WHERE ALERTNO = ? "+
						 "	 AND SEQUENCENO = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertNo);
			preparedStatement.setString(2, seqNo);
			preparedStatement.executeUpdate(); 
			result = "Suspicious Transaction Deleted";
		}catch(Exception e){
			e.printStackTrace();
			result = "Error while deleting";
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return alertNo;
	}
	
	public String updateSuspiciousTransaction(String alertNo, String seqNo, String txnDate, String txnMode, String debitcredit,
			String amount, String remarks, String userCode){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "UPDATE "+schemaName+"TB_TYPEOFSUSPICIONTRANSACTION "+
						 "   SET TRANSACTIONDATE = ?, TRANSACTIONMODE = ?, "+
						 "		 DEBITCREDIT = ?, TRANSACTIONAMOUNT = ?, TRANSACTIONREMARKS = ?, "+
						 "		 UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
						 " WHERE ALERTNO = ? "+
						 "   AND SEQUENCENO = ? ";
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, txnDate);
			preparedStatement.setString(2, txnMode);
			preparedStatement.setString(3, debitcredit);
			preparedStatement.setString(4, amount);
			preparedStatement.setString(5, remarks);
			preparedStatement.setString(6, userCode);
			preparedStatement.setString(7, alertNo);
			preparedStatement.setString(8, seqNo);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return alertNo;
	}
	        
	public String submitReportOfSuspicion(String alertNo, String reportingOn, String branchCode, String accountOrPersonName, String alertRating,
			   String accountNo, String customerId, String others, String address1, String address2, String typeOfSuspicion, String reasonForSuspicion,
			   String rasUserCode, String userCode, String userRole, String ipAddress){
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet =  null;
		String message = "";
		System.out.println(" al "+alertNo+" ro "+reportingOn+" bc "+branchCode+" ap "+accountOrPersonName+" ar "+alertRating+" ac "+accountNo+" cu "+customerId+" ot "+others+" a1 "+address1+" a2 "+address2+" ts "+typeOfSuspicion+" rs "+reasonForSuspicion+" ruc "+rasUserCode+" uc "+userCode+" ur "+userRole+" ia "+ipAddress);
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_RAISESUSPICIONALERT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, alertNo);
			callableStatement.setString(2, reportingOn);
			callableStatement.setString(3, branchCode);
			callableStatement.setString(4, accountOrPersonName);
			callableStatement.setString(5, alertRating);
			callableStatement.setString(6, accountNo);
			callableStatement.setString(7, customerId);
			callableStatement.setString(8, others);
			callableStatement.setString(9, address1);
			callableStatement.setString(10, address2);
			callableStatement.setString(11, typeOfSuspicion);
			callableStatement.setString(12, reasonForSuspicion);
			callableStatement.setString(13, rasUserCode);
			callableStatement.setString(14, userCode);
			callableStatement.setString(15, userRole);
			callableStatement.setString(16, ipAddress);
			callableStatement.registerOutParameter(17, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(17);
			message = "Alert has been generated and case has been assigned to user~~~SUCCESS";
			
			while(resultSet.next()) {
				message += "~~~"+resultSet.getString("ALERTNO");
				//System.out.println("msg = "+message);
			}
		}catch(Exception e){
			message = "Error while generating the alert~~~ERROR~~~NONE";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement , resultSet, null);
		}
		return message;
	}
	
	
/*    
	public String submitReportOfSuspicion(String alertNo, String reportingOn, String branchCode, String accountOrPersonName, String alertRating,
    	   String accountNo, String customerId, String address1, String address2, String typeOfSuspicion, String reasonForSuspicion, 
    	   String referenceCaseNo, String referenceCaseDate, String repeatSAR, String repeatSARRemarks, String sourceOfInternalSAR, 
    	   String scenarioType, String userCode, String userRole, String ipAddress){
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		//System.out.println("DAOImpl - repeatSAR = "+repeatSAR+"repeatSARRemarks = "+repeatSARRemarks+"sourceOfInternalSAR = "+sourceOfInternalSAR);
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_RAISESUSPICIONALERT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, alertNo);
			callableStatement.setString(2, reportingOn);
			callableStatement.setString(3, branchCode);
			callableStatement.setString(4, accountOrPersonName);
			callableStatement.setString(5, alertRating);
			callableStatement.setString(6, accountNo);
			callableStatement.setString(7, customerId);
			callableStatement.setString(8, address1);
			callableStatement.setString(9, address2);
			callableStatement.setString(10, typeOfSuspicion);
			callableStatement.setString(11, reasonForSuspicion);
			callableStatement.setString(12, referenceCaseNo);
			callableStatement.setString(13, referenceCaseDate);
			callableStatement.setString(14, repeatSAR);
			callableStatement.setString(15, repeatSARRemarks);
			callableStatement.setString(16, sourceOfInternalSAR);
			callableStatement.setString(17, scenarioType);
			callableStatement.setString(18, userCode);
			callableStatement.setString(19, userRole);
			callableStatement.setString(20, ipAddress);
			callableStatement.registerOutParameter(21, OracleTypes.CURSOR);
			callableStatement.execute();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement , null, null);
		}
		return alertNo;
	}
*/
	
	public String updateCustomerEntityEnrichment(String fieldsData, String status, String customerId, String userCode, String groupCode, String ipAddress){
		String result = "";
		Connection connection = connectionUtil.getConnection();
		//PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		String sql = "";
		String domesticPepFlagVal = "";
		String field1Val = "";
		String field2Val = "";
		String field3Val = "";
		String field4Val = "";
		String field5Val = "";
		String field6Val = "";
		String field7Val = "";
		String field8Val = "";
		String field9Val = "";
		String field10Val = "";
		String enrichmentMakerComments = "";
		String enrichmentCheckerComments = "";
		System.out.println("In DAO : "+fieldsData+" "+" ,status="+status+" ,usercode="+userCode);
		//app.common.FIELD2=a,app.common.FIELD3=b,app.common.FIELD4=c,app.common.FIELD5=d,app.common.FIELD6=e,app.common.FIELD7=f,app.common.FIELD8=g,app.common.ENRICHMENTMAKERDATE=09/03/2019,app.common.ENRICHMENTMAKERCODE=user1,app.common.ENRICHMENTCHECKERDATE=,app.common.ENRICHMENTCHECKERCODE=,  ,status=null ,usercode=User
		try{
			
			List<String> keys = new Vector<String>();
			List<String> values = new Vector<String>();
			String[] arrStr = CommonUtil.splitString(fieldsData, ",");
			for(String str : arrStr){
				String[] arrSubStr = CommonUtil.splitString(str, "=");
				if(arrSubStr.length == 2){
					keys.add(arrSubStr[0].replaceAll("app.common.", ""));
					values.add(arrSubStr[1]);
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD1")) { 
						field1Val = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD2")) { 
						field2Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD3")) { 
						field3Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD4")) { 
						field4Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD5")) { 
						field5Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD6")) { 
						field6Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD7")) { 
						field7Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD8")) { 
						field8Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD9")) { 
						field9Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("FIELD10")) { 
						field10Val  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("ISDOMESTICPEP")) {
						domesticPepFlagVal = arrSubStr[1];
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("ENRICHMENTMAKERCOMMENTS")) { 
						enrichmentMakerComments = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("ENRICHMENTCHECKERCOMMENTS")) { 
						enrichmentCheckerComments = arrSubStr[1] ; 
					}
				}
			}
			
			//System.out.println("overRideRiskRating="+overRideRiskRating);
			//System.out.println("overRideRiskMakerComments="+overRideRiskMakerComments);
			//System.out.println("overRideRiskCheckerComments="+overRideRiskCheckerComments);
			//System.out.println("field1Val = "+field1Val+" field2Val = "+field2Val+" field3Val = "+field3Val+" field4Val = "+field4Val);
			sql = "{CALL "+schemaName+"STP_UPDATECUSTOMERENRICHMENT(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}";
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, field1Val);
			callableStatement.setString(2, field2Val);
			callableStatement.setString(3, field3Val);
			callableStatement.setString(4, field4Val);
			callableStatement.setString(5, field5Val);
			callableStatement.setString(6, field6Val);
			callableStatement.setString(7, field7Val);
			callableStatement.setString(8, field8Val);
			callableStatement.setString(9, field9Val);
			callableStatement.setString(10, field10Val);
			callableStatement.setString(11, domesticPepFlagVal);
			callableStatement.setString(12, enrichmentMakerComments);
			callableStatement.setString(13, enrichmentCheckerComments);
			callableStatement.setString(14, status);
			callableStatement.setString(15, customerId);
			callableStatement.setString(16, userCode);
			callableStatement.setString(17, groupCode);
			callableStatement.setString(18, ipAddress);
			callableStatement.registerOutParameter(19, OracleTypes.CURSOR);
			callableStatement.execute();
			
			if("P".equals(status)){
				result = "Entity Enrichment Successfully Updated.";
			}
			else if("A".equals(status)){
				result = "Entity Enrichment Successfully Approved.";
			}
			else if("R".equals(status)){
				result = "Entity Enrichment Successfully Rejected.";
			}
		}catch(Exception e){
			result = "Error while saving Entity Enrichment Data.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement , null, null);
		}
		return result;
	}
	
	public String updateCustomerOverRideRiskDetails(String fieldsData, String status, String customerId, String userCode, String groupCode, String ipAddress){
		String result = "";
		Connection connection = connectionUtil.getConnection();
		//PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		String sql = "";
		String overRideRiskRatingSegment = "";
		String overRideRiskRating = "";
		String overRideRiskMakerComments = "";
		String overRideRiskCheckerComments = "";
		//System.out.println("In DAO : "+fieldsData+" "+" ,status="+status+" ,usercode="+userCode);
		try{
			List<String> keys = new Vector<String>();
			List<String> values = new Vector<String>();
			String[] arrStr = CommonUtil.splitString(fieldsData, ",");
			for(String str : arrStr){
				String[] arrSubStr = CommonUtil.splitString(str, "=");
				if(arrSubStr.length == 2){
					keys.add(arrSubStr[0].replaceAll("app.common.", ""));
					values.add(arrSubStr[1]);
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("OVERRIDERISKRATING_SEGMENT")) { 
						overRideRiskRatingSegment  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("OVERRIDERISKRATING")) { 
						overRideRiskRating  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("OVERRIDDINGMAKERCOMMENTS")) { 
						overRideRiskMakerComments = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("OVERRIDDINGCHECKERCOMMENTS")) { 
						overRideRiskCheckerComments  = arrSubStr[1] ; 
					}
				}
			}
			/*System.out.println("overRideRiskRatingSegment="+overRideRiskRatingSegment);
			System.out.println("overRideRiskRating="+overRideRiskRating);
			System.out.println("overRideRiskMakerComments="+overRideRiskMakerComments);
			System.out.println("overRideRiskCheckerComments="+overRideRiskCheckerComments);*/
			
			sql = "{CALL "+schemaName+"STP_UPDATECUSTOMEROVERRIDING (?,?,?,?,?,?,?,?,?,?)}";
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, overRideRiskRating);
			callableStatement.setString(2, overRideRiskMakerComments);
			callableStatement.setString(3, overRideRiskCheckerComments);
			callableStatement.setString(4, status);
			callableStatement.setString(5, customerId);
			callableStatement.setString(6, overRideRiskRatingSegment);
			callableStatement.setString(7, userCode);
			callableStatement.setString(8, groupCode);
			callableStatement.setString(9, ipAddress);
			callableStatement.registerOutParameter(10, OracleTypes.CURSOR);
			callableStatement.execute();
			
			/*updateCustomerReviewLog("OVERRIDERISKRATING-BEFORE", customerId, userCode);
			System.out.println("Executed OVERRIDERISKRATING-BEFORE");
			if("P".equals(status)){
				sql = "UPDATE "+schemaName+"TB_CUSTOMERMASTER A "+
				      "   SET A.OVERRIDERISKRATING = ?, "+
				      "		  A.OVERRIDERISKRATINGMAKERDATE = ?, "+	
				      "       A.OVERRIDERISKRATINGCHECKERDATE = ?, "+
				      "       A.OVERRIDDINGMAKERCODE = ?, "+
				      "		  A.OVERRIDDINGCHECKERCODE = ?, "+
				      "       A.OVERRIDDINGMAKERCOMMENTS = ?, "+
				      "       A.OVERRIDDINGCHECKERCOMMENTS = ?, "+
				      "		  A.OVERRIDDINGSTATUS = ? "+	
				      " WHERE A.CUSTOMERID = ? "+
				      "   AND NVL(A.OVERRIDERISKRATING,'N.A.') <>  ? ";
			
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, overRideRiskRating);
				preparedStatement.setString(2, "SYSTIMESTAMP");
				preparedStatement.setString(3, "");
				preparedStatement.setString(4, userCode);
				preparedStatement.setString(5, "");
				preparedStatement.setString(6, overRideRiskMakerComments);
				preparedStatement.setString(7, overRideRiskCheckerComments);
				preparedStatement.setString(8, status);
				preparedStatement.setString(9, customerId);
				preparedStatement.setString(10, overRideRiskRating);
				preparedStatement.executeUpdate();
				result = "Customer RiskRating Successfully OverRidden";
			}
			else{
				sql = "UPDATE "+schemaName+"TB_CUSTOMERMASTER A "+
					      "   SET A.OVERRIDERISKRATING = ?, "+
					      "		  A.OVERRIDERISKRATINGMAKERDATE = ? , "+	
					      "       A.OVERRIDERISKRATINGCHECKERDATE = ? , "+
					      "       A.OVERRIDDINGMAKERCODE = ?, "+
					      "		  A.OVERRIDDINGCHECKERCODE = ?, "+
					      "       A.OVERRIDDINGMAKERCOMMENTS = ?, "+
					      "       A.OVERRIDDINGCHECKERCOMMENTS = ?, "+
					      "		  A.OVERRIDDINGSTATUS = ? "+	
					      " WHERE A.CUSTOMERID = ? "+
					      "   AND NVL(A.OVERRIDERISKRATING,'N.A.') <>  ? ";
				
					preparedStatement = connection.prepareStatement(sql);
					preparedStatement.setString(1, overRideRiskRating);
					preparedStatement.setString(2, "");
					preparedStatement.setString(3, "SYSTIMESTAMP");
					preparedStatement.setString(4, "");
					preparedStatement.setString(5, userCode);
					preparedStatement.setString(6, overRideRiskMakerComments);
					preparedStatement.setString(7, overRideRiskCheckerComments);
					preparedStatement.setString(8, status);
					preparedStatement.setString(9, customerId);
					preparedStatement.setString(10, overRideRiskRating);
					preparedStatement.executeUpdate();
					System.out.println("Approve query="+sql);
					System.out.println("overRideRiskRating="+overRideRiskRating);
					System.out.println("overRideRiskMakerComments="+overRideRiskMakerComments);
					System.out.println("overRideRiskCheckerComments="+overRideRiskCheckerComments);
					if("A".equals(status)){
						result = "Approved Customer RiskRating Successfully for OverRidding";
					}else{
						result = "Rejected Customer RiskRating Successfully for OverRidding";
					}
			}
			
			updateCustomerReviewLog("OVERRIDERISKRATING-AFTER", customerId, userCode);*/
			if("P".equals(status)){
				result = "Customer RiskRating Successfully OverRidden";
			}
			else if("A".equals(status)){
				result = "Customer RiskRating Successfully Approved for OverRidding";
			}
			else if("R".equals(status)){
				result = "Customer RiskRating Successfully Rejected for OverRidding";
			}
		}catch(Exception e){
			result = "Error while saving Customer Risk Rating Overridden Data";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement , null, null);
		}
		//System.out.println( result);
		return result;
	}
	
	private void updateCustomerReviewLog(String requestType, String customerId, String userCode){
		String result = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		String sql = "";
		System.out.println("In update: "+requestType);
		try{
		
			sql = "INSERT INTO "+schemaName+"TB_CUSTOMERMASTER_REVIEWLOG( "+
				  "  	  CUSTOMERID, UPDATEREQUESTTYPE, LASTREVIEWEDBYUSER, "+ 
				  "  	  LASTREVIEWEDDATE, LASTREVIEWEDCOMMENTS, NEXTREVIEWDATE, "+ 
				  "  	  OVERRIDERISKRATING, OVERRIDDINGMAKERCODE, OVERRIDDINGCHECKERCODE, "+
				  "		  OVERRIDERISKRATINGMAKERDATE, OVERRIDERISKRATINGCHECKERDATE, OVERRIDDINGMAKERCOMMENTS, "+ 
				  "  	  OVERRIDERISKRATINGCOMMENTS, OVERRIDERISKRATING_SEGMENT, UPDATEDBY, UPDATETIMESTAMP) "+
                  "SELECT A.CUSTOMERID, ?, A.LASTREVIEWEDBYUSER, "+ 
		          "  	  A.LASTREVIEWEDDATE, A.LASTREVIEWEDCOMMENTS, A.NEXTREVIEWDATE, "+ 
				  "  	  A.OVERRIDERISKRATING, A.OVERRIDDINGMAKERCODE, A.OVERRIDDINGCHECKERCODE, "+
		          "		  A.OVERRIDERISKRATINGMAKERDATE, A.OVERRIDERISKRATINGCHECKERDATE, A.OVERRIDDINGMAKERCOMMENTS, "+ 
				  "  	  A.OVERRIDDINGCHECKERCOMMENTS, A.OVERRIDERISKRATING_SEGMENT, ?, SYSTIMESTAMP "+
				  "  FROM "+schemaName+"TB_CUSTOMERMASTER A "+
				  " WHERE A.CUSTOMERID = ? ";
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, requestType);
			preparedStatement.setString(2, userCode);
			preparedStatement.setString(3, customerId);
			preparedStatement.executeUpdate();

			result = "Customer RiskRating Successfully OverRidden";
			
		}catch(Exception e){
			result = "Error while saving Customer Risk Rating Overridden Data";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement , null, null);
		}
	}
	
	public String updateProductExclusionDetails(String fieldsData, String status, String productCode, 
			String userCode, String groupCode, String ipAddress){
		String result = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		String sql = "";
		String isExcluded = "";
		String makerComments = "";
		String checkerComments = "";
		//System.out.println("In DAO : "+fieldsData+" "+" ,status="+status+" ,usercode="+userCode);
		try{
			List<String> keys = new Vector<String>();
			List<String> values = new Vector<String>();
			String[] arrStr = CommonUtil.splitString(fieldsData, ",");
			for(String str : arrStr){
				String[] arrSubStr = CommonUtil.splitString(str, "=");
				if(arrSubStr.length == 2){
					keys.add(arrSubStr[0].replaceAll("app.common.", ""));
					values.add(arrSubStr[1]);
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("ISEXCLUDED")) { 
						isExcluded  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("MAKERCOMMENTS")) { 
						makerComments = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("CHECKERCOMMENTS")) { 
						checkerComments  = arrSubStr[1] ; 
					}
				}
			}
			/*System.out.println("isExcluded="+isExcluded);
			System.out.println("makerComments="+makerComments);
			System.out.println("overRideRiskCheckerComments="+checkerComments);*/
			
			sql = "{CALL "+schemaName+"STP_UPDATEPRODEXLUSIONDETAILS(?,?,?,?,?,?,?,?,?)}";
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, isExcluded);
			callableStatement.setString(2, makerComments);
			callableStatement.setString(3, checkerComments);
			callableStatement.setString(4, status);
			callableStatement.setString(5, productCode);
			callableStatement.setString(6, userCode);
			callableStatement.setString(7, groupCode);
			callableStatement.setString(8, ipAddress);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.execute();
			
			if("P".equals(status)){
				result = "Product Exlusion Details have been updated successfully.";
			}
			else if("A".equals(status)){
				result = "Product Exlusion Details have been approved successfully.";
			}
			else if("R".equals(status)){
				result = "Product Exlusion Details have been rejected successfully.";
			}
		}catch(Exception e){
			result = "Error while saving Product Exlusion Details.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement , null, null);
		}
		//System.out.println( result);
		return result;
	}
	
	public String updateSubGroupingCodeDetails(String fieldsData, String status, String transactionType, 
												String userCode, String groupCode, String ipAddress){
		String result = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		String sql = "";
		String subGroupingCode = "";
		String makerComments = "";
		String checkerComments = "";
	//	System.out.println("In DAO : "+fieldsData+" "+" ,status="+status+" ,usercode="+userCode);
		try{
			List<String> keys = new Vector<String>();
			List<String> values = new Vector<String>();
			String[] arrStr = CommonUtil.splitString(fieldsData, ",");
			for(String str : arrStr){
				String[] arrSubStr = CommonUtil.splitString(str, "=");
				if(arrSubStr.length == 2){
					keys.add(arrSubStr[0].replaceAll("app.common.", ""));
					values.add(arrSubStr[1]);
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("SUBGROUPINGCODE")) { 
						subGroupingCode  = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("MAKERCOMMENTS")) { 
						makerComments = arrSubStr[1] ; 
					}
					if(arrSubStr[0].replaceAll("app.common.", "").equalsIgnoreCase("CHECKERCOMMENTS")) { 
						checkerComments  = arrSubStr[1] ; 
					}
				}
			}
			/*System.out.println("subGroupingCode="+subGroupingCode);
			System.out.println("makerComments="+makerComments);
			System.out.println("CheckerComments="+checkerComments);*/
			
			sql = "{CALL "+schemaName+"STP_UPDATETXNSUBGROUPDETAILS(?,?,?,?,?,?,?,?,?)}";
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, subGroupingCode);
			callableStatement.setString(2, makerComments);
			callableStatement.setString(3, checkerComments);
			callableStatement.setString(4, status);
			callableStatement.setString(5, transactionType);
			callableStatement.setString(6, userCode);
			callableStatement.setString(7, groupCode);
			callableStatement.setString(8, ipAddress);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.execute();
			
			if("P".equals(status)){
				result = "Transaction Sub Grouping Code has been updated successfully.";
			}
			else if("A".equals(status)){
				result = "Transaction Sub Grouping Code has been approved successfully.";
			}
			else if("R".equals(status)){
				result = "Transaction Sub Grouping Code has been rejected successfully.";
			}
		}catch(Exception e){
			result = "Error while saving Transaction Sub Grouping Code.";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement , null, null);
		}
	//	System.out.println( result);
		return result;
	}
	
	public List<Map<String, String>> getLinkedTransactions(String alertNo){
		/*
		String sql = "SELECT TRANSACTIONNO,  TRANSACTIONBATCHID||'/'||TRANSACTIONID TRANSACTIONID, "+
					 "       NVL(TRIM(INSTRUMENTCODE),'N.A.') INSTRUMENTCODE, INSTRUMENTNO, FUN_DATETOCHAR(INSTRUMENTDATE) "+
					 "		 INSTRUMENTDATE, CUSTOMERID, ACCOUNTNO, NVL(TRIM(BRANCHCODE),'N.A.') BRANCHCODE, AMOUNT, "+
					 "		 TRANSACTIONTYPE, CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END DEPOSITORWITHDRAWAL, "+
					 " 		 CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN AMOUNT||' ' ELSE ' ' END CREDITAMOUNT, "+
					 "		 CASE WHEN DEPOSITORWITHDRAWAL = 'W' THEN AMOUNT||' ' ELSE ' ' END DEBITAMOUNT, "+
					 "		 FUN_DATETOCHAR(TRANSACTIONDATETIME) TRANSACTIONDATE, COUNTERPARTYID, "+
					 "		 COUNTERPARTYTYPE, COUNTERBRANCHCODE, COUNTERBANKCODE, ACCTCURRENCYCODE, CURRENCYCODE, RATECODE, "+
					 "		 CONVERSIONRATE, REPLACE(NARRATION,CHR(39),'') NARRATION, CHANNELID, COUNTERCOUNTRYCODE, "+
					 "		 CHANNELTYPE, COUNTERPARTYADDRESS, CUSTOMERNAME, ACCOUNTTYPE, PRODUCTCODE, COUNTERPARTYNAME, COUNTERACCOUNTNO, FLOWCODE "+
					 " FROM "+schemaName+"TB_TRANSACTIONS A "+
					 " WHERE TRANSACTIONNO IN (SELECT TRANSACTIONNO "+
					 "							 FROM "+schemaName+"TB_ALERTTRANSACTIONMAPPING "+
					 "							WHERE ALERTNO = ? ) ";
		*/			 
		Connection connection = connectionUtil.getConnection();
		// PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet =  null;
		List<Map<String, String>> txnList = new Vector<Map<String, String>>();
		String procedureName = "{CALL "+schemaName+"STP_GETALERTLINKEDTRANSACTIONS(:ALERTNO, :RESULTSET)}";
		
		try{
			/*
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> txn = new LinkedHashMap<String, String>();
				txn.put(CommonUtil.changeColumnName("TRANSACTIONNO"), resultSet.getString("TRANSACTIONNO"));
				txn.put(CommonUtil.changeColumnName("TRANSACTIONID"), resultSet.getString("TRANSACTIONID"));
				txn.put(CommonUtil.changeColumnName("INSTRUMENTCODE"), resultSet.getString("INSTRUMENTCODE"));
				txn.put(CommonUtil.changeColumnName("INSTRUMENTNO"), resultSet.getString("INSTRUMENTNO"));
				txn.put(CommonUtil.changeColumnName("INSTRUMENTDATE"), resultSet.getString("INSTRUMENTDATE"));
				txn.put(CommonUtil.changeColumnName("CUSTOMERID"), resultSet.getString("CUSTOMERID"));
				txn.put(CommonUtil.changeColumnName("ACCOUNTNO"), resultSet.getString("ACCOUNTNO"));
				txn.put(CommonUtil.changeColumnName("BRANCHCODE"), resultSet.getString("BRANCHCODE"));
				txn.put(CommonUtil.changeColumnName("AMOUNT"), resultSet.getString("AMOUNT"));
				txn.put(CommonUtil.changeColumnName("TRANSACTIONTYPE"), resultSet.getString("TRANSACTIONTYPE"));
				txn.put(CommonUtil.changeColumnName("DEPOSITORWITHDRAWAL"), resultSet.getString("DEPOSITORWITHDRAWAL"));
				txn.put(CommonUtil.changeColumnName("CREDITAMOUNT"), resultSet.getString("CREDITAMOUNT"));
				txn.put(CommonUtil.changeColumnName("DEBITAMOUNT"), resultSet.getString("DEBITAMOUNT"));
				txn.put(CommonUtil.changeColumnName("TRANSACTIONDATE"), resultSet.getString("TRANSACTIONDATE"));
				txnList.add(txn);
			}
			*/
			callableStatement = connection.prepareCall(procedureName);
			callableStatement.setString("ALERTNO", alertNo);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			while(resultSet.next()){
				Map<String, String> txn = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					txn.put(CommonUtil.changeColumnName(columnName), resultSet.getString(columnName));
					//resultData.put(columnName, resultSet.getString(columnName));
				}
				txnList.add(txn);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			// connectionUtil.closeResources(connection, preparedStatement , null, null);
			connectionUtil.closeResources(connection, callableStatement , resultSet, null);
		}
		return txnList;
	}
	
	public List<Map<String, String>> openSubjectiveAlertWindow(){
		List<Map<String, String>> alertCodeList = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet =  null;
		try{
			String sql = "SELECT ALERTCODE, DESCRIPTION FROM "+schemaName+"TB_ALERTMASTER A "+
			             " WHERE A.ALERTTYPE = 'S' ";
			preparedStatement = connection.prepareStatement(sql);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> alertCodeMap = new LinkedHashMap<String, String>();
				alertCodeMap.put("ALERTCODE", resultSet.getString("ALERTCODE"));
				alertCodeMap.put("DESCRIPTION", resultSet.getString("DESCRIPTION"));
				alertCodeList.add(alertCodeMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		return alertCodeList;
	}

	public String generateSubjectiveAlert(String transactionNo, String alertCode, String userCode, String userRole){
		String message = "Alert Generated Successfully";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GENERATESUBJECTIVEALERTS(?,?,?,?)}");
			callableStatement.setString(1, transactionNo);
			callableStatement.setString(2, alertCode);
			callableStatement.setString(3, userCode);
			callableStatement.setString(4, userRole);
			callableStatement.execute();	
		}catch(Exception e){
			message = "Error While Generating The Alert";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return message;
	}

	public List<Map<String, String>> viewAccountStatement(Map<String, String> paramMap){
		List<Map<String, String>> detailsList = new Vector<Map<String,String>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
				
		String ACCOUNTNO = paramMap.get("ACCOUNTNO");
		String FROMDATE = paramMap.get("FROMDATE");
		String ALERTNO = paramMap.get("ALERTNO");
		String CHANNELTYPE = paramMap.get("CHANNELTYPE");
		String TRANSACTIONNO = paramMap.get("TRANSACTIONNO");
		String BRANCHCODE = paramMap.get("BRANCHCODE");
		String TOAMOUNT = paramMap.get("TOAMOUNT");
		String FROMAMOUNT = paramMap.get("FROMAMOUNT");
		String CUSTOMERNAME = paramMap.get("CUSTOMERNAME");
		String TODATE = paramMap.get("TODATE");
		String CUSTOMERID = paramMap.get("CUSTOMERID");
		String INSTRUMENTCODE = paramMap.get("INSTRUMENTCODE");
		String TRANSACTIONTYPE = paramMap.get("TRANSACTIONTYPE");
		String DEBITCREDIT = paramMap.get("DEBITCREDIT");
		String SOURCESYSTEM = paramMap.get("SOURCESYSTEM");
		String sql= "";
		int count = 1;
		try{
			/*
			sql= " SELECT ROWNUM AS ROWPOSITION, A.* FROM ( SELECT TRANSACTIONNO, "+
				 "       TRANSACTIONBATCHID||'/'||TRANSACTIONID TRANSACTIONID, "+
				 "       NVL(TRIM(INSTRUMENTCODE),'N.A.') INSTRUMENTCODE, NVL(INSTRUMENTNO,' ') INSTRUMENTNO, "+
				 " 	    TO_CHAR(INSTRUMENTDATE,'DD-MON-YYYY') INSTRUMENTDATE,  NVL(REF_NUM,' ') REF_NUM, "+
				 "       CUSTOMERID, ACCOUNTNO, NVL(TRIM(BRANCHCODE),'N.A.') BRANCHCODE, AMOUNT, TRANSACTIONTYPE,  "+ 
				 "       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN 'CREDIT' ELSE 'DEBIT' END DEPOSITORWITHDRAWAL, "+
				 "       CASE WHEN DEPOSITORWITHDRAWAL = 'D' THEN AMOUNT||' ' ELSE '0' END CREDITAMOUNT, "+  
				 "       CASE WHEN DEPOSITORWITHDRAWAL = 'W' THEN AMOUNT||' ' ELSE '0' END DEBITAMOUNT, "+  
				 "       TO_CHAR(TRANSACTIONDATETIME,'DD-MON-YYYY') TRANSACTIONDATE, COUNTERPARTYID, "+  
				 "       COUNTERPARTYTYPE, COUNTERBRANCHCODE, COUNTERBANKCODE, ACCTCURRENCYCODE, CURRENCYCODE, RATECODE, "+ 
				 "       CONVERSIONRATE, REPLACE(NVL(TRIM(NARRATION),'N.A.'),CHR(39),'') NARRATION, "+
				 "       CHANNELID, COUNTERCOUNTRYCODE, CHANNELTYPE, COUNTERPARTYADDRESS, "+ 
				 "       CUSTOMERNAME, ACCOUNTTYPE, PRODUCTCODE, COUNTERPARTYNAME, COUNTERACCOUNTNO, FLOWCODE "+
				 "  FROM "+schemaName+"TB_TRANSACTIONS A "+
			*/
				 /*
				 " WHERE A.TRANSACTIONDATETIME >= FUN_CHARTODATE('"+FROMDATE+"') "+
				 "   AND A.TRANSACTIONDATETIME <  FUN_CHARTODATE('"+TODATE+"') + 1 ";
				 */
			/*
				 " WHERE A.TRANSACTIONDATETIME >= FUN_CHARTODATE(?) "+
				 "   AND A.TRANSACTIONDATETIME <  FUN_CHARTODATE(?) + 1 ";
			if(ACCOUNTNO != null && !ACCOUNTNO.equals("")) 
				//sql = sql + " AND A.ACCOUNTNO = '"+ACCOUNTNO+"' ";
			    sql = sql + " AND A.ACCOUNTNO = ? ";
			if(FROMAMOUNT != null && !FROMAMOUNT.equals("")) 
				//sql = sql + " AND A.AMOUNT >= "+FROMAMOUNT+" ";
				sql = sql + " AND A.AMOUNT >= ? ";
			if(TOAMOUNT != null && !TOAMOUNT.equals("")) 
				//sql = sql + " AND A.AMOUNT <= ? ";
				sql = sql + " AND A.AMOUNT <= "+TOAMOUNT+" ";
			if(TRANSACTIONTYPE != null && !TRANSACTIONTYPE.equals("") && !TRANSACTIONTYPE.equals("ALL")) 
				//sql = sql + " AND SUBSTR(A.TRANSACTIONTYPE,1,1) = '"+TRANSACTIONTYPE+"' ";
				sql = sql + " AND SUBSTR(A.TRANSACTIONTYPE,1,1) = ? ";
			if(DEBITCREDIT != null && !DEBITCREDIT.equals("") && !DEBITCREDIT.equals("ALL")) 
				//sql = sql + " AND A.DEPOSITORWITHDRAWAL = '"+DEBITCREDIT+"' ";
				sql = sql + " AND A.DEPOSITORWITHDRAWAL = ? ";
			if(BRANCHCODE != null && !BRANCHCODE.equals("") && !BRANCHCODE.equals("ALL")) 
				//sql = sql + " AND A.BRANCHCODE = '"+BRANCHCODE+"' ";
				sql = sql + " AND A.BRANCHCODE = ? ";
			if(CUSTOMERID != null && !CUSTOMERID.equals("")) 
				//sql = sql + " AND A.CUSTOMERID = '"+CUSTOMERID+"' ";
				sql = sql + " AND A.CUSTOMERID = ? ";
			if(CUSTOMERNAME != null && !CUSTOMERNAME.equals("")) 
				//sql = sql + " AND A.CUSTOMERNAME LIKE '%"+CUSTOMERNAME+"%' ";
				sql = sql + " AND A.CUSTOMERNAME LIKE ? ";
			if(INSTRUMENTCODE != null && !INSTRUMENTCODE.equals("")) 
				//sql = sql + " AND A.INSTRUMENTCODE = '"+INSTRUMENTCODE+"' ";
				sql = sql + " AND A.INSTRUMENTCODE = ? ";
			if(TRANSACTIONNO != null && !TRANSACTIONNO.equals("")) 
				//sql = sql + " AND A.TRANSACTIONNO = '"+TRANSACTIONNO+"' ";
				sql = sql + " AND A.TRANSACTIONNO = ? ";
			if(ALERTNO != null && !ALERTNO.equals("")) 
				//sql = sql + " AND A.TRANSACTIONNO IN (SELECT TRANSACTIONNO FROM TB_ALERTTRANSACTIONMAPPING WHERE ALERTNO = '"+ALERTNO+"') ";
				sql = sql + " AND A.TRANSACTIONNO IN (SELECT TRANSACTIONNO FROM TB_ALERTTRANSACTIONMAPPING WHERE ALERTNO = ?) ";

			sql = sql + " ORDER BY TRANSACTIONDATETIME ASC ) A ";
						
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(count, FROMDATE);
			count++;
			preparedStatement.setString(count, TODATE);
			count++;
			if(ACCOUNTNO != null && !ACCOUNTNO.equals("")){
				preparedStatement.setString(count, ACCOUNTNO);
			    count++;
			}
			if(FROMAMOUNT != null && !FROMAMOUNT.equals("")){
				preparedStatement.setString(count, FROMAMOUNT);
			    count++;
			}
			if(TOAMOUNT != null && !TOAMOUNT.equals("")){
				preparedStatement.setString(count, TOAMOUNT);
			    count++;
			}
			if(TRANSACTIONTYPE != null && !TRANSACTIONTYPE.equals("") && !TRANSACTIONTYPE.equals("ALL")){
				preparedStatement.setString(count, TRANSACTIONTYPE);
			    count++;
			}
			if(DEBITCREDIT != null && !DEBITCREDIT.equals("") && !DEBITCREDIT.equals("ALL")){
				preparedStatement.setString(count, DEBITCREDIT);
			    count++;
			}
			if(BRANCHCODE != null && !BRANCHCODE.equals("") && !BRANCHCODE.equals("ALL")){
				preparedStatement.setString(count, BRANCHCODE);
			    count++;
			}
			if(CUSTOMERID != null && !CUSTOMERID.equals("")){
				preparedStatement.setString(count, CUSTOMERID);
			    count++;
			}
			if(CUSTOMERNAME != null && !CUSTOMERNAME.equals("")){
				preparedStatement.setString(count, "%"+CUSTOMERNAME+"%");
			    count++;
			} 
			if(INSTRUMENTCODE != null && !INSTRUMENTCODE.equals("")){
				preparedStatement.setString(count, INSTRUMENTCODE);
			    count++;
			}
			if(TRANSACTIONNO != null && !TRANSACTIONNO.equals("")){
				preparedStatement.setString(count, TRANSACTIONNO);
			    count++;
			}
			if(ALERTNO != null && !ALERTNO.equals("")){
				preparedStatement.setString(count, ALERTNO);
			}
			
			resultSet = preparedStatement.executeQuery();
			*/
			callableStatement = connection.prepareCall("{CALL STP_VIEWACCOUNTSTATEMENT(?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, FROMDATE);
			callableStatement.setString(2, TODATE);
			callableStatement.setString(3, TRANSACTIONTYPE);
			callableStatement.setString(4, ACCOUNTNO);
			callableStatement.setString(5, CUSTOMERID);
			callableStatement.setString(6, DEBITCREDIT);
			callableStatement.setString(7, FROMAMOUNT);
			callableStatement.setString(8, TOAMOUNT);
			callableStatement.setString(9, SOURCESYSTEM);
			
			callableStatement.registerOutParameter(10, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(10);

			while(resultSet.next()){
				Map<String, String> detailsMap = new LinkedHashMap<String,String>();
				detailsMap.put("ROWPOSITION",resultSet.getString("ROWPOSITION"));
				detailsMap.put("TRANSACTIONNO",resultSet.getString("TRANSACTIONNO"));
				//detailsMap.put("TRANSACTIONBATCHID",resultSet.getString("TRANSACTIONBATCHID"));
				detailsMap.put("TRANSACTIONID",resultSet.getString("TRANSACTIONID"));
				detailsMap.put("TRANSACTIONTYPE",resultSet.getString("TRANSACTIONTYPE"));
				detailsMap.put("CUSTOMERID",resultSet.getString("CUSTOMERID"));
				detailsMap.put("INSTRUMENTCODE",resultSet.getString("INSTRUMENTCODE"));
				detailsMap.put("INSTRUMENTNO",resultSet.getString("INSTRUMENTNO"));
				detailsMap.put("INSTRUMENTDATE",resultSet.getString("INSTRUMENTDATE"));
				detailsMap.put("REF_NUM",resultSet.getString("REF_NUM"));
				detailsMap.put("ACCOUNTNO",resultSet.getString("ACCOUNTNO"));
				detailsMap.put("BRANCHCODE",resultSet.getString("BRANCHCODE"));
				detailsMap.put("AMOUNT",resultSet.getString("AMOUNT"));
				detailsMap.put("DEPOSITORWITHDRAWAL",resultSet.getString("DEPOSITORWITHDRAWAL"));
				detailsMap.put("CREDITAMOUNT",resultSet.getString("CREDITAMOUNT"));
				detailsMap.put("DEBITAMOUNT",resultSet.getString("DEBITAMOUNT"));
				detailsMap.put("TRANSACTIONDATE",resultSet.getString("TRANSACTIONDATE"));
				detailsMap.put("COUNTERPARTYID",resultSet.getString("COUNTERPARTYID"));
				detailsMap.put("COUNTERPARTYTYPE",resultSet.getString("COUNTERPARTYTYPE"));
				detailsMap.put("COUNTERBRANCHCODE",resultSet.getString("COUNTERBRANCHCODE"));
				detailsMap.put("COUNTERBANKCODE",resultSet.getString("COUNTERBANKCODE"));
				detailsMap.put("ACCTCURRENCYCODE",resultSet.getString("ACCTCURRENCYCODE"));
				detailsMap.put("CURRENCYCODE",resultSet.getString("CURRENCYCODE"));
				detailsMap.put("RATECODE",resultSet.getString("RATECODE"));
				detailsMap.put("CONVERSIONRATE",resultSet.getString("CONVERSIONRATE"));
				detailsMap.put("NARRATION",resultSet.getString("NARRATION"));
				detailsMap.put("CHANNELID",resultSet.getString("CHANNELID"));
				detailsMap.put("COUNTERCOUNTRYCODE",resultSet.getString("COUNTERCOUNTRYCODE"));
				detailsMap.put("CHANNELTYPE",resultSet.getString("CHANNELTYPE"));
				detailsMap.put("COUNTERPARTYADDRESS",resultSet.getString("COUNTERPARTYADDRESS"));
				detailsMap.put("CUSTOMERNAME",resultSet.getString("CUSTOMERNAME"));
				detailsMap.put("ACCOUNTTYPE",resultSet.getString("ACCOUNTTYPE"));
				detailsMap.put("PRODUCTCODE",resultSet.getString("PRODUCTCODE"));
				detailsMap.put("COUNTERPARTYNAME",resultSet.getString("COUNTERPARTYNAME"));
				detailsMap.put("COUNTERACCOUNTNO",resultSet.getString("COUNTERACCOUNTNO"));
				detailsMap.put("INR_AMOUNT",resultSet.getString("INR_AMOUNT"));
				detailsMap.put("SUBGROUPINGCODE",resultSet.getString("SUBGROUPINGCODE"));
				detailsList.add(detailsMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			//connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return detailsList;
	}
	
	public Map<String, Object> getDocumentFromWSDL(String customerId, String documentCode){
		Map<String, Object> dataMap =  new LinkedHashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
		//System.out.println("customerId:  "+customerId+", docCode: "+documentCode);
		dataMap = documentFromWSDL.getDocument(customerId, documentCode);
		}
		catch(Exception e){
			e.printStackTrace();
		}
		return dataMap;
	}
	
	/*reset columns (enable and disable)
	 * CHANGES STARTED*/
	public ArrayList<String> getExistingColumns(String userCode, String moduleCode){
		ArrayList<String> exestedColumns = new ArrayList<String>();
		String queryString = "";
        ResultSet resultSet = null;
        Connection connection = connectionUtil.getConnection();
        PreparedStatement preparedStatement = null;
        try{
	        queryString = "SELECT COLUMNNAME FROM "+schemaName+"TB_SYSTEMMODULECOLUMNS WHERE TRIM(USERCODE) = ? AND MODULECODE = ? ORDER BY COLUMNINDEX ASC";
	    	preparedStatement = connection.prepareStatement(queryString);
	    	preparedStatement.setString(1, userCode);
	        preparedStatement.setString(2, moduleCode);
	        resultSet = preparedStatement.executeQuery();
	        while(resultSet.next()){
	        	exestedColumns.add(resultSet.getString("COLUMNNAME"));
	        }
        }
        catch(Exception e)
        {
        	e.printStackTrace();
        }finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }

        //System.out.println("existing column List = "+exestedColumns);
		return exestedColumns;
	}
	
	public ArrayList<String> getEnabledColumns(String userCode, String moduleCode, List<String> columnList, ArrayList<String> existColumnsList){
		ArrayList<String> enableColumnList = new ArrayList<String>();
		String queryString = "";
        Connection connection = connectionUtil.getConnection();
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        int colIndex = 0;
        String enabledColumnName = "";
        
        try {
        	queryString = " SELECT NVL(MAX(COLUMNINDEX),0) COLUMNINDEX "+
		                  "   FROM "+schemaName+"TB_SYSTEMMODULECOLUMNS "+
	  		              "  WHERE USERCODE = ? "+
	  		              "    AND MODULECODE = ? ";
	        preparedStatement = connection.prepareStatement(queryString);
	        preparedStatement.setString(1, userCode);
	        preparedStatement.setString(2, moduleCode);
	        resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()){
				colIndex = resultSet.getInt("COLUMNINDEX");
			}
			
	        for(String columnName : columnList){
	        	if(!existColumnsList.contains(columnName)){
	        		try {
	        			queryString = " DELETE FROM "+schemaName+"TB_SYSTEMMODULECOLUMNS "+
	        		                  "  WHERE USERCODE = ? "+
	        					      "    AND MODULECODE = ? "+
	        		                  "    AND COLUMNNAME = ? ";
	        			preparedStatement = connection.prepareStatement(queryString);
	        			preparedStatement.setString(1, userCode);
	        			preparedStatement.setString(2, moduleCode);
	        			preparedStatement.setString(3, columnName);
			            preparedStatement.executeUpdate();
	        			
	        			queryString = "INSERT INTO "+schemaName+"TB_SYSTEMMODULECOLUMNS(USERCODE, MODULECODE, COLUMNNAME, ALIASNAME, ISENABLED, COLUMNINDEX )"+
	      				 	          "VALUES(?, ?, ?, ?, ?, ?) ";
						preparedStatement = connection.prepareStatement(queryString);
						preparedStatement.setString(1, userCode);
				        preparedStatement.setString(2, moduleCode);
			            preparedStatement.setString(3, columnName);
			            preparedStatement.setString(4, columnName);
			            preparedStatement.setString(5, "Y");
			            preparedStatement.setInt(6, colIndex++);
			            preparedStatement.executeUpdate();
					} catch (Exception e) {
						System.out.println("Error during getting Enabled Column "+e.getMessage());
						e.printStackTrace();
					}
	            }
	        }
	        // try {
        	queryString = " SELECT COLUMNNAME "+
        	              "   FROM "+schemaName+"TB_SYSTEMMODULECOLUMNS "+
            		      "  WHERE USERCODE = ? "+
            		      "     AND MODULECODE = ? "+
            		      "     AND ISENABLED = ?  "+
            		      "   ORDER BY COLUMNINDEX ASC";
        	preparedStatement = connection.prepareStatement(queryString);
        	preparedStatement.setString(1, userCode);
            preparedStatement.setString(2, moduleCode);
            preparedStatement.setString(3, "Y");
            resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()){
				// enableColumnList.add(resultSet.getString("COLUMNNAME"));
				enabledColumnName = resultSet.getString("COLUMNNAME");
				for(String columnName : columnList){
					if(columnName.equalsIgnoreCase(enabledColumnName)){
						if(!enableColumnList.contains(enabledColumnName))
							enableColumnList.add(enabledColumnName);
			  		}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
    	//System.out.println("enable column list= "+enableColumnList);
        //enableColumnDetails.put("ENABLECOLUMN", enabledColumnList);
		return enableColumnList;
	}
	
	@Override
	public Map<String,Object> saveDisabledColumnsData(String[] disabledColumns,String moduleCode,String userCode, String userRole, String ipAdress) {
		Map <String,Object> response = new HashMap<String,Object>();
		String statusMessage = "";
		Boolean status;
		String queryString = "";
        Connection connection = connectionUtil.getConnection();
        PreparedStatement preparedStatement = null;
        try{
	        for(int i=0;i<disabledColumns.length;i++){
	        	String columnName =  disabledColumns[i].split(":")[0].trim();
	        	String isEnableFlag = disabledColumns[i].split(":")[1].trim();
	        	String index = disabledColumns[i].split(":")[2].trim();
	        	//System.out.println(userCode+"   "+moduleCode+"  "+columnName+"  "+isEnableFlag+" "+index);
	        	queryString = "UPDATE "+schemaName+"TB_SYSTEMMODULECOLUMNS "+
	        	              " SET ISENABLED = ?, "+
	        	              "   COLUMNINDEX = ? "+
	        				  " WHERE USERCODE = ?    "+
	        				  "   AND MODULECODE = ?  "+
	        				  "   AND COLUMNNAME = ?  ";
	        	preparedStatement = connection.prepareStatement(queryString);
	        	preparedStatement.setString(1, isEnableFlag);
	        	preparedStatement.setString(2, index);
	        	preparedStatement.setString(3, userCode);
				preparedStatement.setString(4, moduleCode);
				preparedStatement.setString(5, columnName);
        		preparedStatement.executeUpdate();
	        }
	        statusMessage = "Column has been Reset for "+moduleCode;
	        status = true;
        }catch(Exception e){
        	statusMessage = "Error found while reseting columns";
    		status = false;
    		e.printStackTrace();
    	}finally{
			connectionUtil.closeResources(connection, preparedStatement, null, null);
		}
		response.put("STATUSMESSAGE", statusMessage);
		response.put("STATUS", status);
		//System.out.println(response);
		return response;
	}
	
	public Map<String,String> getAllColumnOfModule(String userCode, String moduleCode){
		Map<String,String> columnDetails = new LinkedHashMap<String,String>();
		String queryString = "";
        Connection connection = connectionUtil.getConnection();
        PreparedStatement preparedStatement = null;
        ResultSet resultSet = null;
        try {
        	queryString = " SELECT COLUMNNAME,ISENABLED "+
        	              "   FROM "+schemaName+"TB_SYSTEMMODULECOLUMNS "+
            		      "  WHERE USERCODE = ? "+
            		      "     AND MODULECODE = ? "+
            		      "   ORDER BY COLUMNINDEX ASC";
        	preparedStatement = connection.prepareStatement(queryString);
        	preparedStatement.setString(1, userCode);
            preparedStatement.setString(2, moduleCode);
            resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()){
				columnDetails.put(resultSet.getString("COLUMNNAME"),resultSet.getString("ISENABLED"));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}finally{
        	connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
        }
		
		return columnDetails;
	}

	/*@Override
	public Map<String, Object> getFileTypeAndName(String parameters,String number,String isLoggedData,String userCode, String userRole, String ipAddress) {
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,String> fileData = new HashMap<String,String>();
		boolean status = false;
		String [] paramArr = parameters.split(",");
		String fromDate = paramArr[0].split("=")[1];
		String toDate = paramArr[1].split("=")[1];
		String fileUploadType = paramArr[2].split("=")[1].split("}")[0];
		
		System.out.println(fromDate+" "+toDate+"  "+fileUploadType);
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETFILETYPEANDNAME(?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, fileUploadType);
			callableStatement.setString(4, isLoggedData);
			callableStatement.setString(5, number);
			callableStatement.setString(6, userCode);
			callableStatement.setString(7, userRole);
			callableStatement.setString(8, ipAddress);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(9);
			while(resultSet.next()){
				// resultSet.next();
				fileData.put("FILENAME", resultSet.getString("FILENAME"));
				fileData.put("FILETYPE", resultSet.getString("FILETYPE"));
				result.put("FILEDATA", fileData);
				status = true;
			}
		}catch(Exception e){
			System.out.println(e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		result.put("STATUS", status);
		System.out.println(result);
		return result;
	}*/
	
	/*CHANGES ENDED*/
	
	
	/*public Map<String, Object> validationCheck(String accountNo, String customerId){
		Map<String, Object> dataMap = new LinkedHashMap<String, Object>();
		Connection connection = connectionUtil.getConnection();
		String totalCustomers = null;
		String totalAccounts = null ;
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_RAISESUSPCHECK(?,?,?,?)}");
			callableStatement.setString(1, accountNo);
			callableStatement.setString(2, customerId);
			callableStatement.registerOutParameter(3, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING COUNT OF ACCOUNTNO
			ResultSet resultSetPartA = (ResultSet) callableStatement.getObject(3);
			while(resultSetPartA.next()){
				totalAccounts = resultSetPartA.getString("TOTALACCOUNT");
			}
			
			//FOR FETCHING COUNT OF CUSTOMERID
			ResultSet resultSetPartB = (ResultSet) callableStatement.getObject(4);
			Map<String, String> CUSTOMERID = new LinkedHashMap<String, String>();
			while(resultSetPartB.next()){
				totalCustomers = resultSetPartB.getString("TOTALCUSTOMER");
			}
			
			//INSERTING INTO DATAMAP
			dataMap.put("ACCOUNTNO", totalAccounts);
			dataMap.put("CUSTOMERID", totalCustomers);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement , null, null);
		}
		return dataMap;
	}*/

	 public List<Map<String, String>> getRASUsersList(String userCode, String userRole, String ipAddress){
		   List<Map<String, String>> dataList = new LinkedList<Map<String,String>>();
		   Connection connection = null;
		   CallableStatement callableStatement = null;
		   ResultSet resultSet = null;
		   String sql= "";
		 //  System.out.println(action+"  "+caseStatus+"   "+userCode+"   "+userRole+"  "+ipAddress);
		   
		   try{
			   	sql= "{CALL STP_GETRASUSERSLIST(?,?,?,?)}";
			   	
			   	connection = connectionUtil.getConnection();
			   	callableStatement = connection.prepareCall(sql);
			   	callableStatement.setString(1, userCode);
			   	callableStatement.setString(2, userRole);
			   	callableStatement.setString(3, ipAddress);
			   	callableStatement.registerOutParameter(4, OracleTypes.CURSOR);
			   	callableStatement.execute();
			   	resultSet = (ResultSet) callableStatement.getObject(4);
			   	
			    while(resultSet.next()){
				   Map<String, String> dataMap = new LinkedHashMap<String, String>();
				   dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				   dataMap.put("USERNAME", resultSet.getString("USERNAME"));
				   dataMap.put("ROLEID", resultSet.getString("ROLEID"));
				   dataList.add(dataMap);
				}
			   }catch(Exception e){
				   e.printStackTrace();
			   }finally{
				   connectionUtil.closeResources(connection, callableStatement, resultSet, null);
			   }
			//   System.out.println(dataList);
			   return dataList;
	   }
	
	public Map<String, String> getSuspicionScenarios(String tableName){
		Map<String, String> selectList = new LinkedHashMap<String, String>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT SCENARIOCODE, SCENARIODESC FROM "+tableName);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				selectList.put(resultSet.getString("SCENARIOCODE"), resultSet.getString("SCENARIODESC"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return selectList;
	}
	
	public List<Map<String, Object>> getReasonForSuspicion(String tableName){
		List<Map<String, Object>> selectList = new Vector<Map<String, Object>>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			preparedStatement = connection.prepareStatement("SELECT CODE, DESCRIPTION, SCENARIOTYPE FROM "+schemaName+""+tableName);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> optionMap = new LinkedHashMap<String, String>();
				Map<String, Object> selectMap = new LinkedHashMap<String, Object>();
				optionMap.put(resultSet.getString("CODE"), resultSet.getString("DESCRIPTION"));
				selectMap.put(resultSet.getString("SCENARIOTYPE"), optionMap);
				selectList.add(selectMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		//System.out.println("From DAO = "+selectList);
		return selectList;
	}

	@Override
	public Map<String, Object> getFileTypeAndName(String parameters,String number,String userCode, String userRole, String ipAddress) {
		Map<String,Object> result = new HashMap<String,Object>();
		Map<String,String> fileData = new HashMap<String,String>();
		boolean status = false;
		String [] paramArr = parameters.split(",");
		String fromDate = paramArr[0].split("=")[1];
		String toDate = paramArr[1].split("=")[1];
		String fileUploadType = paramArr[2].split("=")[1].split("}")[0];
		
		System.out.println(fromDate+" "+toDate+"  "+fileUploadType);
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETFILETYPEANDNAME(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, fileUploadType);
			callableStatement.setString(4, number);
			callableStatement.setString(5, userCode);
			callableStatement.setString(6, userRole);
			callableStatement.setString(7, ipAddress);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			resultSet = (ResultSet) callableStatement.getObject(8);
			resultSet.next();
			fileData.put("FILENAME", resultSet.getString("FILENAME"));
			fileData.put("FILETYPE", resultSet.getString("FILETYPE"));
			result.put("FILEDATA", fileData);
			status = true;
		}catch(Exception e){
			System.out.println(e.getMessage());
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		result.put("STATUS", status);
		//System.out.println("result = "+result);
		return result;
	}

	@Override
	public List<Map<String, String>> getNonCashChannelDetails(String channelType, String userCode,
			String ipAdress, String ap_fromDate, String ap_toDate, String ap_accountNo, String ap_custId) {
		List<Map<String, String>> mainList = new ArrayList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETNONCASHCHANNELDETAILS(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, ap_fromDate);
			callableStatement.setString(2, ap_toDate);
			callableStatement.setString(3, ap_accountNo);
			callableStatement.setString(4, ap_custId);
			callableStatement.setString(5, channelType);
			callableStatement.setString(6, userCode);
			callableStatement.setString(7, ipAdress);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			ResultSet resultSet = (ResultSet) callableStatement.getObject(8);
			ResultSetMetaData metaData = resultSet.getMetaData();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= metaData.getColumnCount(); colIndex++){
					String columnName = metaData.getColumnName(colIndex);
					dataMap.put("app.common."+columnName, resultSet.getString(columnName));
				}
				mainList.add(dataMap);
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		
		return mainList;
	}
	
	@Override
	public List<Map<String, String>> getNonCashTransactionDetails(String counterPartyName, String channelType,
			String userCode, String ipAdress, String ap_fromDate, String ap_toDate, String ap_accountNo,
			String ap_custId) {
		List<Map<String, String>> mainList = new ArrayList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETNONCASHTXNDETAILS(?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, ap_fromDate);
			callableStatement.setString(2, ap_toDate);
			callableStatement.setString(3, ap_accountNo);
			callableStatement.setString(4, ap_custId);
			callableStatement.setString(5, counterPartyName);
			callableStatement.setString(6, channelType);
			callableStatement.setString(7, userCode);
			callableStatement.setString(8, ipAdress);
			callableStatement.registerOutParameter(9, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			ResultSet resultSet = (ResultSet) callableStatement.getObject(9);
			ResultSetMetaData metaData = resultSet.getMetaData();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= metaData.getColumnCount(); colIndex++){
					String columnName = metaData.getColumnName(colIndex);
					dataMap.put("app.common."+columnName, resultSet.getString(columnName));
				}
				mainList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return mainList;
	}

	/*  07.12.2020 */
	@Override
	public Map<String, String> getEddQuestions(String accountType, String userCode, 
			String userRole, String ipAddress) {
		//System.out.println("accountType = "+accountType);
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETEDDQUESTIONS(?,?,?,?,?)}");
			callableStatement.setString(1, accountType);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			resultSet = (ResultSet) callableStatement.getObject(5);
			while(resultSet.next()){
				dataMap.put(resultSet.getString("QUESTIONID"), 
						resultSet.getString("QUESTIONDESC")+"^^^"+resultSet.getString("MINLENGTH"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return dataMap;
	}

	@Override
	public String saveEddQuestionRecords(String alertNo, String eddQuestions, String userCode, 
			String userRole, String ipAddress) {
		String response = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_SAVEEDDQUESTIONRECORDS(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, alertNo);
			callableStatement.setString(2, eddQuestions);
			callableStatement.setString(3, "RAISESUSPICION");
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userRole);
			callableStatement.setString(6, ipAddress);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.execute();
			response = "EDD Questions saved successfully";
		}catch(Exception e){
			response = "Error while saving EDD Questions";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return response;
	}

	@Override
	public Map<String, String> viewEDDQuestionRecords(String caseNo, String userCode, String userRole, String ipAddress) {
		//System.out.println(" caseNo = "+caseNo);
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETEDDQUESTIONRECORDS(?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			resultSet = (ResultSet) callableStatement.getObject(5);
			while(resultSet.next()){
				dataMap.put(resultSet.getString("QUESTIONID"), resultSet.getString("RESPONSE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return dataMap;
	}

	@Override
	public String updateEddQuestionRecords(String caseNo, String eddQuestions, String userCode, String userRole,
			String ipAddress) {
		String response = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_SAVEEDDQUESTIONRECORDS(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, eddQuestions);
			callableStatement.setString(3, "CASEWORKFLOW");
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userRole);
			callableStatement.setString(6, ipAddress);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.execute();
			response = "EDD Questions saved successfully";
		}catch(Exception e){
			response = "Error while saving EDD Questions";
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, null, null);
		}
		return response;
	}

	@Override
	public Map<String, String> fetchAccountRelatedData(String accountNo, String userCode, String userRole, String ipAddress) {
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETACCOUNTRELATEDDATA(?,?,?,?,?)}");
			callableStatement.setString(1, accountNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			resultSet = (ResultSet) callableStatement.getObject(5);
			ResultSetMetaData metaData = resultSet.getMetaData();
			while(resultSet.next()){
				for(int colIndex = 1; colIndex <= metaData.getColumnCount(); colIndex++){
					String columnName = metaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return dataMap;
	}

	@Override
	public Map<String, Object> fetchAlertNoTxnNoMappings(String alertNo, String userCode, String userRole,
			String ipAddress) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETALERTNOTXNNOMAPPINGS(?,?,?,?,?)}");
			callableStatement.setString(1, alertNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			resultSet = (ResultSet) callableStatement.getObject(5);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				//header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
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

	@Override
	public Map<String, Object> fetchAccountNoBasedTransactions(String accountNo,
			String fromDate, String toDate, String userCode, String userRole, String ipAddress) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_GETACCOUNTNOBASEDTXNS(?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, accountNo);
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userRole);
			callableStatement.setString(6, ipAddress);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			resultSet = (ResultSet) callableStatement.getObject(7);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				//header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
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

	@Override
	public Map<String, Object> updateAccountRSPTransactions(String alertNo, String accountNo, String transactionNo,
			String action, String userCode, String userRole, String ipAddress) {
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall("{CALL STP_UPDATEACCOUNTRSPTXNS(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, alertNo);
			callableStatement.setString(2, accountNo);
			callableStatement.setString(3, transactionNo);
			callableStatement.setString(4, action);
			callableStatement.setString(5, userCode);
			callableStatement.setString(6, userRole);
			callableStatement.setString(7, ipAddress);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			
			//FOR FETCHING DATA
			resultSet = (ResultSet) callableStatement.getObject(8);
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
				//header.add(CommonUtil.changeColumnName(resultSetMetaData.getColumnName(colIndex)));
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

	@Override
	public int getEddQuestionCount(String caseNo, String userCode, String userRole, String ipAddress) {
		int eddQuestionCount = 0;
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			String sql = "{CALL "+schemaName+"STP_GETEDDQUESTIONCOUNT(?,?,?,?,?)}";
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString(1, caseNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
			callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(5);
			
			while(resultSet.next()){
				eddQuestionCount = Integer.parseInt(resultSet.getString("EDDQUESTIONCOUNT"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return eddQuestionCount;
	}

}
