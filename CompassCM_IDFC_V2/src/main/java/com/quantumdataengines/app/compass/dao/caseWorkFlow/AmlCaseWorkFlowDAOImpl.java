package com.quantumdataengines.app.compass.dao.caseWorkFlow;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
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
import oracle.sql.ORAData;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;
import com.sun.org.apache.bcel.internal.generic.GETSTATIC;

@Repository
public class AmlCaseWorkFlowDAOImpl implements AmlCaseWorkFlowDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
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
		String procedureName = "{CALL STP_GETAMLCASECOMMENTDETAILS(:CASENOS, :CASESTATUS, :USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
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
		//System.out.println("Get = "+resultData);
		return resultData;
	}
	
	public Map<String, String> getAllCaseDetails(String moduleValue){
		Map<String, String> resultData = new HashMap<String, String>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		String caseNo = moduleValue;
		
		try{
			String sql = "SELECT CASENO, CUSTOMERID, CUSTOMERNAME, ACCOUNTNO, BRANCHCODE, "+
						 "       CASEPRIORITY, CASEID, CASESTATUS, STARTDATE, DUEDATE, "+
						 "       USERCODE, AMLUSERCODE, AMLOUSERCODE, MLROUSERCODE, USERCOMMENTS, "+ 
						 "       AMLUSERCOMMENTS, AMLOCOMMENTS, MLROCOMMENTS, USERTIMESTAMP, AMLUSERTIMESTAMP, "+ 
						 "       AMLOTIMESTAMP, MLROTIMESTAMP, USERREASONCODE, AMLUSERREASONCODE, AMLOREMOVALREASONCODE, "+ 
						 "       AMLOOUTCOMEINDICATOR, AMLOHIGHRISKREASONCODE, MLROREMOVALREASONCODE, MLROOUTCOMEINDICATOR, MLROHIGHRISKREASONCODE, "+ 
						 "       USERADDEDTOFALSEPOSITIVE, AMLUSERADDEDTOFALSEPOSITIVE, AMLOADDEDTOFALSEPOSITIVE, MLROADDEDTOFALSEPOSITIVE, LASTUPDATEDBY, "+ 
						 "       LASTUPDATEDON, PRODUCTCODE, USERASSIGNEE_CODE, USERASSIGNEE_DATE, USERASSIGNEE_COMMENTS,  "+
						 "       SOURCESYSTEM, LISTOFALERTS, AMOUNT, CASEDATE, ALERTCODE,  "+
						 "       ALERTMESSAGE, LASTSENTEMAILTIMESTAMP, LASTRECEIVEDEMAILTIMESTAMP, HASANYOLDCASES, LASTSENTEMAILORDER, "+ 
						 "       LASTSENTEMAIL_MSGUNQNO, LASTRECEIVEDEMAILORDER, LASTRECEIVEDEMAIL_MSGUNQNO, USERCASESTATUS, AMLUSERCASESTATUS, "+ 
						 "       AMLOCASESTATUS, MLROCASESTATUS, ACCOUNTREVIEWEDDATE, USER_ACCOUNTREVIEWEDDATE, AMLUSER_ACCOUNTREVIEWEDDATE,  "+
						 "       AMLO_ACCOUNTREVIEWEDDATE, MLRO_ACCOUNTREVIEWEDDATE, AMLUSER_BRCOMMENTS, AMLUSER_BRTIMESTAMP, AMLUSER_BRREASONCODE, "+ 
						 "       AMLUSER_BRADDEDTOFALSEPOSITIVE, AMLUSER_BRACCOUNTREVIEWEDDATE, AMLUSER_BRCASESTATUS, CASERATING, REGENRATE_FLAG,  "+
						 "       REGENRATE_REFCASENO, REGENRATE_MLROCODE, REGENRATE_MLROCOMMENTS, REGENRATE_MLROTIMESTAMP, EMAILCODE,  "+
						 "       ESCALATIONORDER, ESCALATEDEMAILSCOUNT, RAISESUSPICION_USERCODE, RAISESUSPICION_USERCOMMENTS, RAISESUSPICION_USERTIMESTAMP, "+ 
						 "       MLRO_ISEXITRECOMMENDED, USER_ISEXITRECOMMENDED, AMLUSER_ISEXITRECOMMENDED, AMLUSERBR_ISEXITRECOMMENDED, AMLO_ISEXITRECOMMENDED, "+ 
						 "       AMLREP_ISEXITRECOMMENDED, REFERENCECASEDATE, IS_REPEATSAR, REPEATSAR_REMARKS, SOURCEOF_INTERNAL_SAR,  "+
						 "       REFERENCECASENO, TYPEOFSUSPICION, DETECTION_SCENARIOS "+
						 "  FROM "+schemaName+"TB_CASEWORKFLOWDETAILS "+
						 " WHERE CASENO = ? ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, caseNo);
			resultSet = preparedStatement.executeQuery(sql);
			while(resultSet.next()){
				resultData.put("", resultSet.getString(""));
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return resultData;
	}
	
	public Map<String, Object> saveCaseCommentDetails(String caseNos, String caseStatus, HashMap<String, String> commentMapDetails, String userCode, String userRole, String ipAddress){
		//System.out.println("DAO = "+caseNos+", "+caseStatus+", "+commentMapDetails+", "+userCode+", "+userRole+", "+ipAddress);
		String procedureName = "{CALL STP_SAVEAMLCASECOMMENTDETAILS(:CASENOS, :CASESTATUS, " +
				":COMMENTS, :FRAUDINDICATOR, :REMOVALREASON, :OUTCOMEINDICATOR, "+
				":HIGHRISKREASONCODE, :ADDESTOFALSEPOSITITVE, :LASTREVIEWEDDATE, "+
				":ADDEDTOMARKALL, :EXITRECOMMENDED, :USERACTIONTYPE, :REASSIGNTOUSERCODE, "+
				":ALERTNOS, :FIUREFERENCENO, :FIUREFERENCEDATE, :ASSIGNEDBRANCHCODE, "+
				":FROMDATE, :TODATE, :ALERTCODE, "+
				":BRANCHCODE, :ACCOUNTNO, :CUSTOMERID, :HASANYOLDCASES, "+
				":CASERATING, :FROMCASENO, :TOCASENO,"+
				":USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new Vector<String>();
		List<List<String>> data = new Vector<List<String>>();
		String updateMessage = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		System.out.println(commentMapDetails.get("assignedBranchCode"));
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
			callableStatement.setString("ADDEDTOMARKALL", commentMapDetails.get("addedToMarkAll"));
			callableStatement.setString("EXITRECOMMENDED", commentMapDetails.get("exitRecommended"));
			callableStatement.setString("USERACTIONTYPE", commentMapDetails.get("userActionType"));
			callableStatement.setString("REASSIGNTOUSERCODE", commentMapDetails.get("reassignToUserCode"));
			callableStatement.setString("ALERTNOS", commentMapDetails.get("alertNos"));
			callableStatement.setString("FIUREFERENCENO", commentMapDetails.get("fiuReferenceNo"));
			callableStatement.setString("FIUREFERENCEDATE", commentMapDetails.get("fiuReferenceDate"));
			callableStatement.setString("ASSIGNEDBRANCHCODE", commentMapDetails.get("assignedBranchCode"));
			callableStatement.setString("FROMDATE", commentMapDetails.get("fromDate"));
			callableStatement.setString("TODATE", commentMapDetails.get("toDate"));
			callableStatement.setString("ALERTCODE", commentMapDetails.get("alertCode"));
			callableStatement.setString("BRANCHCODE", commentMapDetails.get("branchCode"));
			callableStatement.setString("ACCOUNTNO", commentMapDetails.get("accountNo"));
			callableStatement.setString("CUSTOMERID", commentMapDetails.get("customerId"));
			callableStatement.setString("HASANYOLDCASES", commentMapDetails.get("hasAnyOldCases"));
			callableStatement.setString("CASERATING", commentMapDetails.get("caseRating"));
			callableStatement.setString("FROMCASENO", commentMapDetails.get("fromCaseNo"));
			callableStatement.setString("TOCASENO", commentMapDetails.get("toCaseNo"));
			
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
			//System.out.println("updateMessage = "+updateMessage);
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
	//	System.out.println(resultData);
		return resultData;
	}

	 
	/*public List<Map<String, String>> getLinkedTransactions(String alertNo){
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
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet =  null;
		List<Map<String, String>> txnList = new Vector<Map<String, String>>();
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, alertNo);
			resultSet = preparedStatement.executeQuery();
			while (resultSet.next()) {
				Map<String, String> txn = new LinkedHashMap<String, String>();
				txn.put("TRANSACTIONNO", resultSet.getString("TRANSACTIONNO"));
				txn.put("TRANSACTIONID", resultSet.getString("TRANSACTIONID"));
				txn.put("INSTRUMENTCODE", resultSet.getString("INSTRUMENTCODE"));
				txn.put("INSTRUMENTNO", resultSet.getString("INSTRUMENTNO"));
				txn.put("INSTRUMENTDATE", resultSet.getString("INSTRUMENTDATE"));
				txn.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				txn.put("ACCOUNTNO", resultSet.getString("ACCOUNTNO"));
				txn.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
				txn.put("AMOUNT", resultSet.getString("AMOUNT"));
				txn.put("TRANSACTIONTYPE", resultSet.getString("TRANSACTIONTYPE"));
				txn.put("DEPOSITORWITHDRAWAL", resultSet.getString("DEPOSITORWITHDRAWAL"));
				txn.put("CREDITAMOUNT", resultSet.getString("CREDITAMOUNT"));
				txn.put("DEBITAMOUNT", resultSet.getString("DEBITAMOUNT"));
				txn.put("TRANSACTIONDATE", resultSet.getString("TRANSACTIONDATE"));
				txnList.add(txn);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement , null, null);
		}
		return txnList;
	}*/
	
	public List<Map<String, String>> getListOfUsers(){
		List<Map<String, String>> usersList = new ArrayList<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = " SELECT A.USERCODE, A.FIRSTNAME || ' ' ||A.LASTNAME AS USERNAME "+
		             "   FROM TB_USER A, TB_USERROLEMAPPING B "+
					 "  WHERE A.USERCODE = B.USERCODE "+
				   //"    AND ROLEID = 'BRANCHUSER' ";
					 "    AND ROLEID = ? ";
		try{
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, "BRANCHUSER");
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
	
	public String assignCaseToBranchUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, String caseRating, String listOfCaseNos, 
										String branchCode, String listOfUsers, String comments, String userCode, String ipAddress, String userRole){
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		
		caseNo = caseNo.replace(",", "','");
		caseNo = "'"+caseNo+"'";
		
		String procedureName = "{CALL STP_ASSIGNCASESTOUSER(:CASENO, :CASESTATUS, :CASERANGEFROM, :CASERANGETO, :HASOLDCASES," +
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
			result = "Error occurred while assigning cases to user.";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return result;
	}
	
	public Map<String, String> getUserDetails(String userRole){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		/*
		String sql = "SELECT A.USERCODE OPTIONNAME, A.FIRSTNAME ||' '|| A.LASTNAME OPTIONVALUE "+
					 "  FROM TB_USER A "+
					 " INNER JOIN TB_USERROLEMAPPING B "+
					 "	  ON A.USERCODE = B.USERCODE "+
					 " WHERE B.ROLEID = ? " ;
		*/
		String sql = "SELECT A.USERCODE OPTIONNAME, A.FIRSTNAME ||' '|| A.LASTNAME OPTIONVALUE "+
					 "  FROM TB_USER A "+
					 " INNER JOIN TB_USERROLEMAPPING B ON A.USERCODE = B.USERCODE "+
					 " WHERE UPPER(TRIM(B.ROLEID)) LIKE UPPER(TRIM(?))" ;
	
		try{
			preparedStatement = connection.prepareStatement(sql);
			//preparedStatement.setString(1, userRole);
			preparedStatement.setString(1, userRole.trim().toUpperCase()+"%");
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				dataMap.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataMap;
	}

	public Map<String, Object> searchCaseReassignment(String fromDate, String toDate, String reassignmentFor, String pendingWith, 
			String pendingWithUsersCode, String closedBy, String closedByUsersCode, String userCode, String groupCode, String ipAddress){
		Map<String, Object> resultData = new LinkedHashMap<String, Object>();
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;

		try{
		//callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_AMLCWF_GETCASEFORREASSIGN(?,?,?,?,?,?,?,?,?)}");
		callableStatement = connection.prepareCall("{CALL STP_AMLCWF_GETCASEFORREASSIGN(?,?,?,?,?,?,?,?,?,?,?)}");
		callableStatement.setString(1, fromDate);
		callableStatement.setString(2, toDate);
		callableStatement.setString(3, reassignmentFor);
		callableStatement.setString(4, pendingWith);
		//callableStatement.setString(5, pendingUsersCode);
		callableStatement.setString(5, pendingWithUsersCode);
		callableStatement.setString(6, closedBy);
		callableStatement.setString(7, closedByUsersCode);
		callableStatement.setString(8, userCode);
		callableStatement.setString(9, groupCode);
		callableStatement.setString(10, ipAddress);
		callableStatement.registerOutParameter(11, OracleTypes.CURSOR);
		callableStatement.execute();
		
		resultSet = (ResultSet) callableStatement.getObject(11);
		
		List<String> headers = new Vector<String>();
		ResultSetMetaData resultSetMetaData = resultSet.getMetaData();			
		
		int numberofcols = resultSetMetaData.getColumnCount();
		for(int count = 1; count <= numberofcols; count++ ){
		String colname = resultSetMetaData.getColumnName(count);
		headers.add(CommonUtil.changeColumnName(colname));
		}
		
		while(resultSet.next()){
		Map<String, String> dataMap = new LinkedHashMap<String, String>();
		for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
		String columnName = resultSetMetaData.getColumnName(colIndex);
		dataMap.put(columnName, resultSet.getString(columnName));
		}
		mainList.add(dataMap);
		}
		
		resultData.put("HEADER", headers);
		resultData.put("RECORDDATA", mainList);
		
		}catch(Exception e){
		e.printStackTrace();
		}finally{
		connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return resultData;
		}

		//public List<Map<String, String>> getListOfCurrUser(String roleId, String reassignmentFor, String pendingUsersCode){
	    public List<Map<String, String>> getListOfCurrUser(String roleId, String reassignmentFor, String pendingWithUsersCode, String closedByUsersCode){
			List<Map<String, String>> usersList = new ArrayList<Map<String,String>>();
			Connection connection = connectionUtil.getConnection();
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			/*
			String sql = "SELECT A.USERCODE, A.FIRSTNAME || ' ' ||A.LASTNAME AS USERNAME "+
			             "  FROM TB_USER A, TB_USERROLEMAPPING B "+
						 " WHERE A.USERCODE = B.USERCODE "+
						 "   AND B.ROLEID = ? ";
			*/
			String sql = "SELECT A.USERCODE, A.FIRSTNAME || ' ' ||A.LASTNAME AS USERNAME "+
			             "  FROM TB_USER A, TB_USERROLEMAPPING B "+
						 " WHERE A.USERCODE = B.USERCODE "+
						 "   AND UPPER(TRIM(B.ROLEID)) LIKE UPPER(TRIM(?))";
			try{
				preparedStatement = connection.prepareStatement(sql);
				// preparedStatement.setString(1, roleId);
				preparedStatement.setString(1, roleId.trim().toUpperCase()+"%");
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
	    
		/*
		public String reAssignCaseToUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, String caseRating, String listOfCaseNos, 
			String branchCode, String listOfUsers, String comments, 
			String fromDate, String toDate, String reassignmentFor, String pendingWith, String pendingUsersCode,
			String userCode, String ipAddress, String userRole){
		*/	
		public String reAssignCaseToUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, 
			   String caseRating, String listOfCaseNos, String branchCode, String listOfUsers, 
			   String comments, String fromDate, String toDate, String reassignmentFor, String pendingWith, 
			   String pendingWithUsersCode, String closedBy, String closedByUsersCode, String reassignmentReason, String ageingFor, 
			   String userCode, String ipAddress, String userRole){
			Connection connection = connectionUtil.getConnection();
			CallableStatement callableStatement = null;
			
			caseNo = caseNo.replace(",", "','");
			caseNo = "'"+caseNo+"'";
			/*
			String procedureName = "{CALL STP_REASSIGNCASESTOUSER(:CASENO, :CASESTATUS, :CASERANGEFROM, :CASERANGETO, :HASOLDCASES," +
								   ":CASERATING, :BRANCHCODE, :LISTOFCASENOS, :LISTOFUSERS, :COMMENTS, "+
								   ":FROMDATE, :TODATE, :REASSIGNMENTFOR, :PENDINGWITH, :PENDINGUSERSCODE, "+
								   ":USERCODE, :IPADDRESS, :USERROLE, :RESULTSET)}";
			*/
			String procedureName = "{CALL STP_REASSIGNCASESTOUSER(:CASENO, :CASESTATUS, :CASERANGEFROM, :CASERANGETO, :HASOLDCASES," +
								   ":CASERATING, :BRANCHCODE, :LISTOFCASENOS, :LISTOFUSERS, :COMMENTS, "+
								   ":FROMDATE, :TODATE, :REASSIGNMENTFOR, :PENDINGWITH, :PENDINGUSERSCODE, "+
								   ":CLOSEDBY, :CLOSEDBYUSERSCODE, :REASSIGNMENTREASON, "+
								   ":AGEINGFOR, :USERCODE, :IPADDRESS, :USERROLE, :RESULTSET)}";
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
				callableStatement.setString("FROMDATE", fromDate);
				callableStatement.setString("TODATE", toDate);
				callableStatement.setString("REASSIGNMENTFOR", reassignmentFor);
				callableStatement.setString("PENDINGWITH", pendingWith);
				//callableStatement.setString("PENDINGUSERSCODE", pendingUsersCode);
				callableStatement.setString("PENDINGWITHUSERSCODE", pendingWithUsersCode);
				callableStatement.setString("CLOSEDBY", closedBy);
				callableStatement.setString("CLOSEDBYUSERSCODE", closedByUsersCode);
				callableStatement.setString("REASSIGNMENTREASON", reassignmentReason);
				callableStatement.setString("AGEINGFOR", ageingFor);
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
				result = "Error occurred while assigning cases to user.";
			}finally{
				connectionUtil.closeResources(connection, callableStatement, resultSet, null);
			}
			return result;
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
		
		public Map<String, Object> getCaseWorkflowModuleDetails(String moduleCode, String moduleValue, String action, String userCode, String groupCode, String ipAddress, String caseStatus){
			Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
			String procedureName = getProcedureName("DETAILPROCEDURENAME", moduleCode);
			int noOfResultSet = getNoOfINOUTParam(procedureName);
			String tabNames = "";
			String tabDisplay = "";
			Connection connection = connectionUtil.getConnection();
			CallableStatement callableStatement = null;
			ResultSet resultSet1 = null; ResultSet resultSet2 = null;
			List<ResultSet> resultSetList = new Vector<ResultSet>();
			System.out.println(procedureName);
			//System.out.println("caseStatusDAO "+caseStatus);
			//System.out.println("noOfResultSet= "+noOfResultSet);
			String sql = "{CALL "+procedureName+"(:MODULEVALUE, :ACTION, :CASESTATUS, :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, :RESULTSET2, ";
			for(int i = 3; i <= noOfResultSet; i++){
				if(i == noOfResultSet)
					sql = sql + ":RESULTSET"+i+" ";
				else
					sql = sql + ":RESULTSET"+i+", ";
			}
			sql = sql + ")}";
			
			/*System.out.println("Module Details Proc : "+sql);
			System.out.println("moduleValue : "+moduleValue+", action: "+action+", caseStatus: "+caseStatus+", userCode: "+userCode+", groupCode: "+groupCode+", ipAddress : "+ipAddress);
			*/
			try{
				callableStatement = connection.prepareCall(sql);
				callableStatement.setString("MODULEVALUE", moduleValue);
				callableStatement.setString("ACTION", action);
				callableStatement.setString("CASESTATUS", caseStatus);
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
			//System.out.println("DAOMainMap = "+mainMap);
			return mainMap;
		}

		public Map<String, Object> getAlertsDetailsForAssignment(String caseNo, String userCode, String userRole, String ipAddress){
		   Map<String, Object> mainMap = new HashMap<String, Object>();
		   List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		   Connection connection = null;
		   CallableStatement callableStatement = null;
		   ResultSet resultSet = null;
		   int count = 1;
		   try{
			   String procedure = "{CALL STP_GETCASEALERTDETAILS(?,?,?,?,?,?,?)}";
			   
			   connection = connectionUtil.getConnection();
			   callableStatement = connection.prepareCall(procedure);
			   callableStatement.setString(1, caseNo);
			   callableStatement.setString(2, userCode);
			   callableStatement.setString(3, userRole);
			   callableStatement.setString(4, ipAddress);
			   callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			   callableStatement.registerOutParameter(6, OracleTypes.CURSOR);
			   callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			   callableStatement.execute();
			   
			   resultSet = (ResultSet) callableStatement.getObject(7);
			   
			   List<String> headers = new Vector<String>();
			   	ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			   	int numberofcols = resultSetMetaData.getColumnCount();
			   	for(count = 1; count <= numberofcols; count++ ){
			   		String colname = resultSetMetaData.getColumnName(count);
			   		headers.add(CommonUtil.changeColumnName(colname));
			   	}
			   	
			   	while(resultSet.next()){
			   		Map<String, String> dataMap = new LinkedHashMap<String, String>();
			   		for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
			   		   String columnName = resultSetMetaData.getColumnName(colIndex);
			   		   dataMap.put(columnName, resultSet.getString(columnName));
			   		}
			   		mainList.add(dataMap);
			   	}
			   	
			   	mainMap.put("HEADERS", headers);
			   	mainMap.put("RECORDS", mainList);
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		   }
		   //System.out.println(dataList);
		   return mainMap;
		}
		
		
		@Override
		public Map<String, Object> hasDistinctCustId(String caseNo, String userCode, String userRole, String ipAddress) {
			Map<String, Object> resultMap = new LinkedHashMap<String, Object>();
			//System.out.println("caseNo = "+caseNo);
			Connection connection = connectionUtil.getConnection();
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			int count = 0;
			caseNo = caseNo.replaceAll(",", "','");

			try{
				String sql = "SELECT COUNT(DISTINCT CUSTOMERID) CUSTIDCOUNT FROM "+schemaName+"TB_CASEWORKFLOWDETAILS WHERE CASENO IN ('"+caseNo+"')";
				//System.out.println(sql);
				preparedStatement = connection.prepareStatement(sql);
				//preparedStatement.setString(1, caseNo);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					 count = resultSet.getInt("CUSTIDCOUNT");
					 //System.out.println(count);
				}
				if(count != 1){
					resultMap.put("STATUS", true);
					//resultMap.put("MESSAGE", "MULTIPLE CASES WITH NON-DISTINCT CUSTOMERIDS CANNOT BE CLOSED BY DESKTOP CLOSURE.");
					resultMap.put("MESSAGE", "Multiple Cases With Non-Distinct CustomerIds CanNot Be Taken For Action.");
				}else{
					resultMap.put("STATUS", false);
					resultMap.put("MESSAGE", "CUSTOMERIDS ARE DISTINCT.");
				}
			}catch(Exception e){
				/*resultMap.put("STATUS", true);
				resultMap.put("MESSAGE", "MULTIPLE CASES WITH NON-DISTINCT CUSTOMERIDS CANNOT BE CLOSED BY DESKTOP CLOSURE.");*/
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
			}
			return resultMap;
		}

		@Override
		public ArrayList<String> amlUserAgainstCaseNo(String caseNo, String userCode, String userRole,String ipAddress) {
			ArrayList<String> amlUserCodeList = new ArrayList<String>();
			Connection connection = connectionUtil.getConnection();
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			try{
				String sql = " SELECT AMLUSERCODE FROM TB_CASEWORKFLOWDETAILS WHERE CASENO = ? AND CASESTATUS = ? ";
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setInt(2, 6);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					amlUserCodeList.add(resultSet.getString("AMLUSERCODE"));
				}
			//	System.out.println("user = "+amlUserCodeList);
			}catch(Exception e){
				
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
			}
			
			return amlUserCodeList;
		}

		/*@Override
		public Map<String, Object> saveCommentWhileReAllocatingToAMLUser(Map<String, String> parameter) {
			Map<String,Object> result = new HashMap<String,Object>();
			result.put("STATUS",true);
			result.put("MESSAGE", "SUCCESS");
			System.out.println("amluseCode = "+parameter.get("amlUserCode")+"  comment= "+parameter.get("comment"));
			System.out.println("fraudindicator = "+parameter.get("fraudIndicator")+"  caseNo= "+parameter.get("caseNo"));
			return result;
		}*/

		@Override
		public Map<String, Object> saveCommentWhileReAssigningToAMLUser(String caseNos, String caseStatus,HashMap<String, String> commentMapDetails, String userCode,
				String userRole, String ipAddress) {
			String procedureName = "{CALL STP_SAVEAMLCASECOMMENTDETAILS(:CASENOS, :CASESTATUS, " +
					":COMMENTS, :FRAUDINDICATOR,:LASTREVIEWEDDATE,:ADDEDTOMARKALL,  "+
					":FROMDATE, :TODATE, :ALERTCODE, "+
					":BRANCHCODE, :ACCOUNTNO, :CUSTOMERID, :HASANYOLDCASES, "+
					":CASERATING, :FROMCASENO, :TOCASENO, :AMLUSERCODE, "+
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
				callableStatement.setString("LASTREVIEWEDDATE", commentMapDetails.get("lastReviewedDate"));
				callableStatement.setString("ADDEDTOMARKALL", commentMapDetails.get("addedToMarkAll"));
				
				callableStatement.setString("FROMDATE", commentMapDetails.get("fromDate"));
				callableStatement.setString("TODATE", commentMapDetails.get("toDate"));
				callableStatement.setString("ALERTCODE", commentMapDetails.get("alertCode"));
				callableStatement.setString("BRANCHCODE", commentMapDetails.get("branchCode"));
				callableStatement.setString("ACCOUNTNO", commentMapDetails.get("accountNo"));
				callableStatement.setString("CUSTOMERID", commentMapDetails.get("customerId"));
				callableStatement.setString("HASANYOLDCASES", commentMapDetails.get("hasAnyOldCases"));
				callableStatement.setString("CASERATING", commentMapDetails.get("caseRating"));
				callableStatement.setString("FROMCASENO", commentMapDetails.get("fromCaseNo"));
				callableStatement.setString("TOCASENO", commentMapDetails.get("toCaseNo"));
				callableStatement.setString("AMLUSERCODE", commentMapDetails.get("amlUserCode"));
				
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
				//System.out.println("updateMessage = "+updateMessage);
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, callableStatement, resultSet, null);
			}
		//	System.out.println(resultData);
			return resultData;
		}

		@Override
		public Map<String, Object> saveCommentWhileReAllocatingToAMLUser(String caseNos, String caseStatus,HashMap<String, String> commentMapDetails, String userCode,
				String userRole, String ipAddress) {
			String procedureName = "{CALL STP_SAVEAMLCASECOMMENTDETAILS(:CASENOS, :CASESTATUS, " +
					":COMMENTS, :FRAUDINDICATOR,  "+
					":FROMDATE, :TODATE, :ALERTCODE, "+
					":BRANCHCODE, :ACCOUNTNO, :CUSTOMERID, :HASANYOLDCASES, "+
					":CASERATING, :FROMCASENO, :TOCASENO, :AMLUSERCODE, "+
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
				callableStatement.setString("FROMDATE", commentMapDetails.get("fromDate"));
				callableStatement.setString("TODATE", commentMapDetails.get("toDate"));
				callableStatement.setString("ALERTCODE", commentMapDetails.get("alertCode"));
				callableStatement.setString("BRANCHCODE", commentMapDetails.get("branchCode"));
				callableStatement.setString("ACCOUNTNO", commentMapDetails.get("accountNo"));
				callableStatement.setString("CUSTOMERID", commentMapDetails.get("customerId"));
				callableStatement.setString("HASANYOLDCASES", commentMapDetails.get("hasAnyOldCases"));
				callableStatement.setString("CASERATING", commentMapDetails.get("caseRating"));
				callableStatement.setString("FROMCASENO", commentMapDetails.get("fromCaseNo"));
				callableStatement.setString("TOCASENO", commentMapDetails.get("toCaseNo"));
				callableStatement.setString("AMLUSERCODE", commentMapDetails.get("amlUserCode"));
				
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
				//System.out.println("updateMessage = "+updateMessage);
			}catch(Exception e){
				e.printStackTrace();
			}finally{
				connectionUtil.closeResources(connection, callableStatement, resultSet, null);
			}
			//System.out.println(commentMapDetails);
			System.out.println("resultData = "+resultData);
			return resultData;

		}

		
		
		/*public ArrayList<String> getAllAMLuserList(){
			Map<String, Object> resultMap = new LinkedHashMap<String, Object>();
			ArrayList<String> amlUserCodeList = new ArrayList<String>();
			Connection connection = connectionUtil.getConnection();
			PreparedStatement preparedStatement = null;
			ResultSet resultSet = null;
			try{
				String sql = " SELECT USERCODE FROM TB_USER WHERE UPPER(USERCODE) = 'AMLUSER' ";
				preparedStatement = connection.prepareStatement(sql);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()){
					amlUserCodeList.add(resultSet.getString("USERCODE"));
				}
				System.out.println("user = "+amlUserCodeList);
				
			}catch(Exception e){
				
			}finally{
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);	
			}
			
			return amlUserCodeList;
			
		}*/
	   public List<Map<String, String>> getAMLUserAMLOMappingDetails(String userCode, String userRole){
		   List<Map<String, String>> amloList = new Vector<Map<String,String>>();
		   
		   Connection connection = null;
		   PreparedStatement preparedStatement = null;
		   ResultSet resultSet = null;
		   try{
			   String sql = "SELECT AMLUSERCODE, AMLOCODE "+
					   		"  FROM "+schemaName+"TB_AMLUSER_AMLO_MAPPING ";
			   connection = connectionUtil.getConnection();
			   preparedStatement = connection.prepareStatement(sql);
			   resultSet = preparedStatement.executeQuery();
			   
			   while(resultSet.next()){
				   Map<String,String> amloMap = new LinkedHashMap<String, String>();
				   amloMap.put("AMLUSERCODE", resultSet.getString("AMLUSERCODE"));
				   amloMap.put("AMLOCODE", resultSet.getString("AMLOCODE"));
				   amloList.add(amloMap);
			   }
			  
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		   }
		   //System.out.println(amloList);
		   return amloList;
	   }
	   
	   public List<Map<String, String>> getAMLOMLROMappingDetails(String userCode, String userRole){
		   List<Map<String, String>> mlroList = new Vector<Map<String,String>>();
		   
		   Connection connection = null;
		   PreparedStatement preparedStatement = null;
		   ResultSet resultSet = null;
		   try{
			   String sql = "SELECT AMLOCODE, MLROCODE "+
					   		"  FROM "+schemaName+"TB_AMLO_MLRO_MAPPING ";
			   connection = connectionUtil.getConnection();
			   preparedStatement = connection.prepareStatement(sql);
			   resultSet = preparedStatement.executeQuery();
			   
			   while(resultSet.next()){
				   Map<String,String> mlroMap = new LinkedHashMap<String, String>();
				   mlroMap.put("AMLOCODE", resultSet.getString("AMLOCODE"));
				   mlroMap.put("MLROCODE", resultSet.getString("MLROCODE"));
				   mlroList.add(mlroMap);
			   }
			  
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		   }
		  // System.out.println(mlroList);
		   return mlroList;
	   }
	   
	   public int getEvidenceAttachedCount(String caseNos, String userCode, String userRole){
		   Connection connection = null;
		   PreparedStatement preparedStatement = null;
		   ResultSet resultSet = null;
		   int count = 0;
		   try{
			   
			   String sql = "SELECT COUNT(*) ATTACHMENT_COUNT FROM "+schemaName+"TB_FILEUPLOADLOG "+
					        " WHERE MODULEREF = ? "+
					        "   AND MODULEUNQNO = ? ";
			   
			   connection = connectionUtil.getConnection();
			   preparedStatement = connection.prepareStatement(sql);
			   preparedStatement.setString(1, "5678");
			   preparedStatement.setString(2, caseNos);
			   resultSet = preparedStatement.executeQuery();
			   
			   if(resultSet.next()){
				   count = resultSet.getInt("ATTACHMENT_COUNT");
			   }
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		   }
		   return count;
	   } 
	   
	   public List<Map<String,String>> getSuspicionIndicators(String caseNos, String caseStatus, String action, 
			   String userCode, String userRole, String ipAddress){
		   List<Map<String, String>> dataList = new Vector<Map<String,String>>();
		   Connection connection = null;
		   CallableStatement callableStatement = null;
		   ResultSet resultSet = null;
		   //System.out.println(caseNos+" "+caseStatus+" "+action+" "+userCode+" "+userRole+" "+ipAddress);
		   try{
			   String procedure = "{CALL STP_GETSUSPICIONINDICATORS(?,?,?,?,?,?,?)}";
			   
			   connection = connectionUtil.getConnection();
			   callableStatement = connection.prepareCall(procedure);
			   callableStatement.setString(1, caseNos);
			   callableStatement.setString(2, caseStatus);
			   callableStatement.setString(3, action);
			   callableStatement.setString(4, userCode);
			   callableStatement.setString(5, userRole);
			   callableStatement.setString(6, ipAddress);
			   callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			   callableStatement.execute();
			   
			   resultSet = (ResultSet) callableStatement.getObject(7);
			   
			   while(resultSet.next()){
				   Map<String, String> dataMap = new LinkedHashMap<String, String>();
				   dataMap.put("SUSPICION_INDICATOR_CODE", resultSet.getString("SUSPICION_INDICATOR_CODE"));
				   dataMap.put("SUSPICION_INDICATOR_DESC", resultSet.getString("SUSPICION_INDICATOR_DESC"));
				   dataList.add(dataMap);
			   }
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		   }
		   //System.out.println(dataList);
		   return dataList;
	   }
	   
	   public Map<String, Object> getAlertsForAddingToFalsePositive(String caseNo, String userCode, String userRole, String ipAddress){
		   Map<String, Object> mainMap = new HashMap<String, Object>();		
		   List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		   Connection connection = null;
		   CallableStatement callableStatement = null;
		   ResultSet resultSet = null;
		   String sql= "";
		   int count = 1;
		   try{
			   	sql= "{CALL STP_GETALERTSFORFALSEPOSITIVE(?,?,?,?,?)}";
			   	
			   	connection = connectionUtil.getConnection();
			   	callableStatement = connection.prepareCall(sql);
			   	callableStatement.setString(1, caseNo);
			   	callableStatement.setString(2, userCode);
			   	callableStatement.setString(3, userRole);
			   	callableStatement.setString(4, ipAddress);
			   	callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			   	callableStatement.execute();
			   	resultSet = (ResultSet) callableStatement.getObject(5);
			   	List<String> headers = new Vector<String>();
			   	ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			   	int numberofcols = resultSetMetaData.getColumnCount();
			   	for(count = 1; count <= numberofcols; count++ ){
			   		String colname = resultSetMetaData.getColumnName(count);
			   		headers.add(CommonUtil.changeColumnName(colname));
			   	}
			   	
			   	while(resultSet.next()){
			   		Map<String, String> dataMap = new LinkedHashMap<String, String>();
			   		for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
			   		   String columnName = resultSetMetaData.getColumnName(colIndex);
			   		   dataMap.put(columnName, resultSet.getString(columnName));
			   		}
			   		mainList.add(dataMap);
			   	}
			   	
			   	mainMap.put("HEADER", headers);
			   	mainMap.put("RECORDDATA", mainList);
		   }catch(Exception e){
		      e.printStackTrace();
		   }finally{
		      connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		   }
		   //System.out.println(mainMap);
		   return mainMap;
	   }
	   
	   public Map<String, String> getDetailsForUpdatingFalsePositive(String caseNo, String refNo){
		   Map<String,String> dataMap = new HashMap<String, String>();
		   Connection connection = null;
		   PreparedStatement preparedStatement = null;
		   ResultSet resultSet = null;
		   try{
			   String sql = "SELECT REFERENCENO, CASENO, ALERTNO, CASESTATUS, "+
					   		"       BRANCHCODE, CUSTOMERID, CUSTOMERNAME, FUN_DATETOCHAR(ACTIVEFROMDATE) ACTIVEFROMDATE, "+
					   		"       FUN_DATETOCHAR(ACTIVETODATE) ACTIVETODATE, REASON, ISENABLED, UPDATETIMESTAMP,  "+
					   		"       UPDATEDBY, ACCOUNTNO, TOLERANCELEVEL, ISTOBEDELETED, "+
					   		"       ALERTCODE, ALERTMESSAGE "+
					   		"  FROM "+schemaName+"TB_ADDTOFALSEPOSITIVE_MAKER A "+
					   		" WHERE CASENO = ? "+
					   		"   AND REFERENCENO = ? ";
			   connection = connectionUtil.getConnection();
			   preparedStatement = connection.prepareStatement(sql);
			   preparedStatement.setString(1, caseNo);
			   preparedStatement.setString(2, refNo);
			   resultSet = preparedStatement.executeQuery();
			   if(resultSet.next()){
				   dataMap.put("REFERENCENO", resultSet.getString("REFERENCENO"));
				   dataMap.put("CASENO", resultSet.getString("CASENO"));
				   dataMap.put("ALERTNO", resultSet.getString("ALERTNO"));
				   dataMap.put("CASESTATUS", resultSet.getString("CASESTATUS"));
				   dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
				   dataMap.put("CUSTOMERID", resultSet.getString("CUSTOMERID"));
				   dataMap.put("CUSTOMERNAME", resultSet.getString("CUSTOMERNAME"));
				   dataMap.put("ACTIVEFROMDATE", resultSet.getString("ACTIVEFROMDATE"));
				   dataMap.put("ACTIVETODATE", resultSet.getString("ACTIVETODATE"));
				   dataMap.put("REASON", resultSet.getString("REASON"));
				   dataMap.put("ISENABLED", resultSet.getString("ISENABLED"));
				   dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATETIMESTAMP"));
				   dataMap.put("UPDATEDBY", resultSet.getString("UPDATEDBY"));
				   dataMap.put("ACCOUNTNO", resultSet.getString("ACCOUNTNO"));
				   dataMap.put("TOLERANCELEVEL", resultSet.getString("TOLERANCELEVEL"));
				   dataMap.put("ISTOBEDELETED", resultSet.getString("ISTOBEDELETED"));
				   dataMap.put("ALERTCODE", resultSet.getString("ALERTCODE"));
				   dataMap.put("ALERTMESSAGE", resultSet.getString("ALERTMESSAGE"));
			   }
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		   }
		   return dataMap;
	   }
	   
	   public String saveToFalsePositive(String caseNo, String refNo, String activeFrom, String activeTo, String isEnabled, 
			   String reason, String toleranceLevel, String isToBeDeleted, String userCode){
		   Connection connection = null;
		   PreparedStatement preparedStatement = null;
		   ResultSet resultSet = null;
		   String result = "";
		  /* System.out.println(caseNo+", "+refNo+", "+activeFrom+", "+activeTo+", "+isEnabled+", "+reason
				   +", "+toleranceLevel+", "+isToBeDeleted+", "+userCode);*/
		   try{
			   String sql = "UPDATE "+schemaName+"TB_ADDTOFALSEPOSITIVE_MAKER "+
					   		"   SET ACTIVEFROMDATE = FUN_CHARTODATE(?), ACTIVETODATE = FUN_CHARTODATE(?), REASON = ?, "+
					   		"		ISENABLED = ?, TOLERANCELEVEL = ?, ISTOBEDELETED = ?, "+
					   		"       UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+ 
					   		" WHERE CASENO = ? "+
					   		"   AND REFERENCENO = ? ";
			   connection = connectionUtil.getConnection();
			   preparedStatement = connection.prepareStatement(sql);
			   preparedStatement.setString(1, activeFrom);
			   preparedStatement.setString(2, activeTo);
			   preparedStatement.setString(3, reason);
			   preparedStatement.setString(4, isEnabled);
			   preparedStatement.setString(5, toleranceLevel);
			   preparedStatement.setString(6, isToBeDeleted);
			   preparedStatement.setString(7, userCode);
			   preparedStatement.setString(8, caseNo);
			   preparedStatement.setString(9, refNo);
			//   System.out.println(sql);
			   preparedStatement.executeUpdate();
			   result = "False Positive details have been saved successfully."; 
		   }catch(Exception e){
			   e.printStackTrace();
			   result = "Error while updating false positive details.";
		   }finally{
			   connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		   }
		   return result;
	   }

	   public List<Map<String, String>> getAllUserList(String caseNos, String action, String caseStatus, String userCode, String userRole, String ipAddress){
		   List<Map<String, String>> dataList = new LinkedList<Map<String,String>>();
		   Connection connection = null;
		   CallableStatement callableStatement = null;
		   ResultSet resultSet = null;
		   String sql= "";
		 //  System.out.println(action+"  "+caseStatus+"   "+userCode+"   "+userRole+"  "+ipAddress);
		   
		   try{
			   	sql= "{CALL STP_GETALLUSERSLIST(?,?,?,?,?,?,?)}";
			   	
			   	connection = connectionUtil.getConnection();
			   	callableStatement = connection.prepareCall(sql);
			   	callableStatement.setString(1, caseNos);
			   	callableStatement.setString(2, action);
			   	callableStatement.setString(3, caseStatus);
			   	callableStatement.setString(4, userCode);
			   	callableStatement.setString(5, userRole);
			   	callableStatement.setString(6, ipAddress);
			   	callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			   	callableStatement.execute();
			   	resultSet = (ResultSet) callableStatement.getObject(7);
			   	
			    while(resultSet.next()){
					   Map<String, String> dataMap = new LinkedHashMap<String, String>();
					   dataMap.put("USERCODE1", resultSet.getString("USERCODE1"));
					   dataMap.put("USERCODE2", resultSet.getString("USERCODE2"));
					   dataMap.put("USERNAME", resultSet.getString("USERNAME2"));
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
	   
	   public List<Map<String, String>> getAllBranchesList(String caseNos, String userCode, String userRole, String ipAddress){
		   List<Map<String, String>> dataList = new LinkedList<Map<String,String>>();
		   Connection connection = null;
		   CallableStatement callableStatement = null;
		   ResultSet resultSet = null;
		   String sql= "";
		   
		   try{
			   	sql= "{CALL STP_GETALLBRANCHESLIST(?,?,?,?,?)}";
			   	
			   	connection = connectionUtil.getConnection();
			   	callableStatement = connection.prepareCall(sql);
			   	callableStatement.setString(1, caseNos);
			   	callableStatement.setString(2, userCode);
			   	callableStatement.setString(3, userRole);
			   	callableStatement.setString(4, ipAddress);
			   	callableStatement.registerOutParameter(5, OracleTypes.CURSOR);
			   	callableStatement.execute();
			   	resultSet = (ResultSet) callableStatement.getObject(5);
			   	
			    while(resultSet.next()){
					   Map<String, String> dataMap = new LinkedHashMap<String, String>();
					   dataMap.put("CASEBRANCHCODE", resultSet.getString("CASEBRANCHCODE"));
					   dataMap.put("BRANCHCODE", resultSet.getString("BRANCHCODE"));
					   dataMap.put("BRANCHNAME", resultSet.getString("BRANCHNAME"));
					   dataList.add(dataMap);
				   }
		   }catch(Exception e){
			   e.printStackTrace();
		   }finally{
			   connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		   }
		   //System.out.println(dataList);
		   return dataList;
	}
	   
	public Map<String, Object> searchCasesForSelfAssignment(String fromDate, String toDate, String customerId, String customerType, 
			   String caseRangeFrom, String caseRangeTo, String userCode, String groupCode, String ipAddress){
		Map<String, Object> resultData = new LinkedHashMap<String, Object>();
		List<Map<String, String>> mainList = new Vector<Map<String,String>>();
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;

		try{
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_AMLCWF_GETCASE_SELFASSIGN(?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, fromDate);
			callableStatement.setString(2, toDate);
			callableStatement.setString(3, customerId);
			callableStatement.setString(4, customerType);
			callableStatement.setString(5, caseRangeFrom);
			callableStatement.setString(6, caseRangeTo);
			callableStatement.setString(7, userCode);
			callableStatement.setString(8, groupCode);
			callableStatement.setString(9, ipAddress);
			callableStatement.registerOutParameter(10, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(10);
			
			List<String> headers = new Vector<String>();
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();			
			
			int numberofcols = resultSetMetaData.getColumnCount();
			for(int count = 1; count <= numberofcols; count++ ){
				String colname = resultSetMetaData.getColumnName(count);
				headers.add(CommonUtil.changeColumnName(colname));
			}
			
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				for(int colIndex = 1; colIndex <= resultSetMetaData.getColumnCount(); colIndex++){
					String columnName = resultSetMetaData.getColumnName(colIndex);
					dataMap.put(columnName, resultSet.getString(columnName));
				}
				mainList.add(dataMap);
			}
			
			resultData.put("HEADER", headers);
			resultData.put("RECORDDATA", mainList);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return resultData;
	}
	  
	public String assignCasesToSelf(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String listOfCustType, 
			String listOfCustId, String listOfBranchCodes, String listOfCaseNos, String maxCaseCount, String comments, String userCode, 
			String ipAddress, String userRole) {
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		
		caseNo = caseNo.replace(",", "','");
		caseNo = "'"+caseNo+"'";
		
		String procedureName = "{CALL "+schemaName+"STP_ASSIGNCASESTOSELF(:CASENO, :CASESTATUS, :CASERANGEFROM, :CASERANGETO, :LISTOFCUSTOMERTYPE," +
							":LISTOFCUSTOMERID, :LISTOFBRANCHCODE, :LISTOFCASENOS, :MAXCASECOUNT, :COMMENTS, :USERCODE, :IPADDRESS, :USERROLE, :RESULTSET)}";
		String result = "No cases have been assigned.";
		ResultSet resultSet = null;
			try{
			callableStatement = connection.prepareCall(procedureName);
			callableStatement.setString("CASENO", caseNo);
			callableStatement.setString("CASESTATUS", caseStatus);
			callableStatement.setString("CASERANGEFROM", caseRangeFrom);
			callableStatement.setString("CASERANGETO", caseRangeTo);
			callableStatement.setString("LISTOFCUSTOMERTYPE", listOfCustType);
			callableStatement.setString("LISTOFCUSTOMERID", listOfCustId);
			callableStatement.setString("LISTOFBRANCHCODE", listOfBranchCodes);
			callableStatement.setString("LISTOFCASENOS", listOfCaseNos);
			callableStatement.setString("MAXCASECOUNT", maxCaseCount);
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
			result = "Error occurred while assigning cases to user.";
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return result;
	}
}