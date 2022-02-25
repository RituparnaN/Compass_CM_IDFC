package com.quantumdataengines.app.compass.dao.riskAssessmentPendingCases;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

@Repository
public class RiskAssessmentPendingCasesDAOImpl implements RiskAssessmentPendingCasesDAO{
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public String escalateCase(String caseNo, String caseId, String options, String remarks, String checkers,
			String comments, Map<String, String> userDetails,String compassRefNo) {		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String[] checkersArray = checkers.split(",");
//			System.out.println("chekersCount = "+String.valueOf(checkersArray.length));
			String query =    "UPDATE " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS "
					+ "   SET CASESTATUS = ?,RFISTATUS = 'IP',ESCALATEDTO = ?,ESCALATIONOPTIONS = ?,ESCALATIONREMARKS = ?,"
					+ " 		ESCALATIONCHECKERLIST = ?,ESCALATIONCOMMETNS = ?,CHECKERCOUNT = ?,CHECKERREVIEWCOUNT = ?,"
					+ " 		CURRENT_CASESTATUS = ?,CURRENT_USERCODE = ?,CURRENT_USERROLE = ?,PREVIOUS_USERCODE = ?,PREVIOUS_USERROLE = ?,"
					+ " 		COMMENTS = ?,PREVIOUS_CASESTATUS = ?" 
					+ " WHERE CASENO = ?" 
					+ "   AND CASEID = ?" 
					+ "   AND COMPASSREFNO = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, "1");
			preparedStatement.setString(2, checkers);
			preparedStatement.setString(3, options);
			preparedStatement.setString(4, remarks);
			preparedStatement.setString(5, checkers);
			preparedStatement.setString(6, comments);
			preparedStatement.setInt(7, checkersArray.length);
			preparedStatement.setInt(8, 0);
			preparedStatement.setString(9, "1");
			preparedStatement.setString(10, checkers.replace(",", ""));
			preparedStatement.setString(11, "ROLE_CM_CHECKER");
			preparedStatement.setString(12, userDetails.get("userCode"));
			preparedStatement.setString(13, userDetails.get("userRole"));
			preparedStatement.setString(14, comments+"(by "+userDetails.get("userCode")+")");
			preparedStatement.setString(15, "0");
			preparedStatement.setString(16, caseNo);
			preparedStatement.setString(17, caseId);
			preparedStatement.setString(18, compassRefNo);

			
			resultSet = preparedStatement.executeQuery();
			
			query =   "UPDATE " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS " 
					+ "   SET RFISTATUS = 'IP' "
					+ " WHERE CASEID = ? AND COMPASSREFNO = ?";
			preparedStatement = connection.prepareStatement(query);
			
			preparedStatement.setString(1, caseId);
			preparedStatement.setString(2, compassRefNo);

			resultSet = preparedStatement.executeQuery();

			query =   "INSERT INTO COMAML_CM.TB_RISKASSESSCWFCOMMENTSLOG(CASENO,SEQUENCENO,QUESTIONID,USERCODE,"
					+ "			USERROLE,IPADDRESS,CASESTATUS,COMMENTS,LASTREVIEWEDDATE,UPDATETIMESTAMP,COMPASSREFNO) "
					+ "VALUES(?,COMAML_CM.SEQ_RISKASSESSMENTSEQNO.NEXTVAL,?,?,?,?,'1',?,SYSTIMESTAMP,SYSTIMESTAMP,?)";

			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, caseNo);
			preparedStatement.setString(2, caseId);
			preparedStatement.setString(3, userDetails.get("userCode"));
			preparedStatement.setString(4, userDetails.get("userRole"));
			preparedStatement.setString(5, userDetails.get("ipAddress"));
			preparedStatement.setString(6, comments);
			preparedStatement.setString(7, compassRefNo);

			resultSet = preparedStatement.executeQuery();
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		return "Escalated" ;
	}
	
	@SuppressWarnings("resource")
	@Override
	public Map<String,Object> getRFICaseData(String caseNos, String caseId,String caseVersion, String caseStatus, String userCode, String userRole, String ipAddress,String compassRefNo){
		String procedureName = "{CALL STP_GETRISKASSESSQSDATA(:QUESTIONID, :STATUS,:VERSIONSEQUENCENO ,:USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
		Map<String, Object> resultData = new HashMap<String, Object>();
		List<String> header = new LinkedList<String>();
		List<List<String>> data = new LinkedList<List<String>>();
		
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall(procedureName);
			callableStatement.setString("QUESTIONID", caseId);
			callableStatement.setString("STATUS", caseStatus);
			callableStatement.setString("VERSIONSEQUENCENO", caseVersion);
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
			
			procedureName = "{CALL STP_GETRISKASSESSQSOPTIONS(:QUESTIONID, :STATUS,:VERSIONSEQUENCENO ,:USERCODE, :ROLECODE, :IPADDRESS, :RESULTSET)}";
			Map<String, Object> optionsValueList = new HashMap<String, Object>();
			List<String> optionsList = new ArrayList<String>();
			
			try{
				callableStatement = connection.prepareCall(procedureName);
				callableStatement.setString("QUESTIONID", caseId);
				callableStatement.setString("STATUS", caseStatus);
				callableStatement.setString("VERSIONSEQUENCENO", caseVersion);
				callableStatement.setString("USERCODE", userCode);
				callableStatement.setString("ROLECODE", userRole);
				callableStatement.setString("IPADDRESS", ipAddress);
				callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
				callableStatement.execute();
				
				resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
				resultSetMetaData = resultSet.getMetaData();
				
				while(resultSet.next()){
					optionsList.add(resultSet.getString("OPTIONNAME"));
					optionsValueList.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
				}
				resultData.put("OPTIONSLIST", optionsList);
				resultData.put("OPTIONSVALUELIST", optionsValueList);
			}catch(Exception e) {
				e.printStackTrace();
			}
			
			procedureName = "{CALL STP_GETRISKASSESSQSUSERS(:CASENO, :STATUS,:CASEID ,:USERCODE,:COMPASSREFNO, :ROLECODE, :IPADDRESS, :RESULTSET1, :RESULTSET2)}";
			String[] checkerList = null;
			
			try{
				System.out.println(caseNos);
				System.out.println(caseStatus);
				System.out.println(caseId+"."+caseVersion);
				System.out.println(userCode);
				System.out.println(compassRefNo);
				System.out.println(userRole);
				System.out.println(ipAddress);
				callableStatement = connection.prepareCall(procedureName);
				callableStatement.setString("CASENO", caseNos);
				callableStatement.setString("STATUS", caseStatus);
				callableStatement.setString("CASEID", caseId+"."+caseVersion);
				callableStatement.setString("USERCODE", userCode);
				callableStatement.setString("COMPASSREFNO", compassRefNo);

				callableStatement.setString("ROLECODE", userRole);
				callableStatement.setString("IPADDRESS", ipAddress);
				callableStatement.registerOutParameter("RESULTSET1", OracleTypes.CURSOR);
				callableStatement.registerOutParameter("RESULTSET2", OracleTypes.CURSOR);
				callableStatement.execute();
				
				resultSet = (ResultSet) callableStatement.getObject("RESULTSET1");
				resultSetMetaData = resultSet.getMetaData();
				
				while (resultSet.next()) {
					checkerList = resultSet.getString("ASSIGNEDCHECKERCODES").split(",");
				}
				List<String> checkersList = new ArrayList<String>();
				System.out.println(":checker List:");
				for (String checker : checkerList) {
					if (checker.length() > 0) {
						System.out.println(checker);
						checkersList.add(checker);
					}
				}
				
				resultData.put("CHECKERSLIST", checkersList);
				
				ResultSet resultSet2 = (ResultSet) callableStatement.getObject("RESULTSET2");
				String escalationOption = "";
				String escalationRemarks = "";
				if(resultSet2.next()){
					escalationOption = resultSet2.getString("ESCALATIONOPTIONS");
					escalationRemarks = resultSet2.getString("ESCALATIONREMARKS");
				}
				resultData.put("ESCALATIONOPTION", escalationOption);
				resultData.put("ESCALATIONREMARKS", escalationRemarks);
			}
			catch(Exception e) {
				e.printStackTrace();
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		//System.out.println("Get = "+resultData);
		return resultData;
	}

	@Override
	public String checkerAction(String caseNo, String caseId, String userId, String comments,Map<String, String> userDetails, String checkerAction,String compassRefNo) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		if (checkerAction.equals("A")) {
			try {
				String query =    "SELECT CHECKERCOUNT, CHECKERREVIEWCOUNT "
								+ "  FROM " + schemaName+ "TB_CMQUES_CASEWORKFLOWDETAILS " 
								+ " WHERE CASENO = ?" 
								+ "   AND CASEID = ?"
								+ "	  AND COMPASSREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, caseId);
				preparedStatement.setString(3, compassRefNo);

				resultSet = preparedStatement.executeQuery();
				int checkerCount = 0;
				int checkerReviewCount = 0;
				if (resultSet.next()) {
					checkerCount = resultSet.getInt("CHECKERCOUNT");
					checkerReviewCount = resultSet.getInt("CHECKERREVIEWCOUNT");
				}

				query =   "SELECT ESCALATIONCHECKERLIST "
						+ "  FROM " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS "
						+ " WHERE CASENO = ?" 
						+ "   AND CASEID = ?"
						+ "   AND COMPASSREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, caseId);
				preparedStatement.setString(3, compassRefNo);

				resultSet = preparedStatement.executeQuery();
				String escalationCheckerList = "";
				if (resultSet.next()) {
					escalationCheckerList = resultSet.getString("ESCALATIONCHECKERLIST");
				}
				escalationCheckerList = escalationCheckerList.replace(userId, "");


				query =   "UPDATE " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS "
						+ "   SET CHECKERREVIEWCOUNT = ?,ESCALATIONCHECKERLIST = ?,COMMENTS = ?,PREVIOUS_CASESTATUS = '1'"
						+ " WHERE CASENO = ?" 
						+ "   AND CASEID = ? "
						+ "   AND COMPASSREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setInt(1, checkerReviewCount + 1);
				preparedStatement.setString(2, escalationCheckerList);
				preparedStatement.setString(3, comments + "(by " + userDetails.get("userCode") + ")");
				preparedStatement.setString(4, caseNo);
				preparedStatement.setString(5, caseId);
				preparedStatement.setString(6, compassRefNo);

				resultSet = preparedStatement.executeQuery();

				query =   "SELECT RFISTATUS "
						+ "  FROM " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS " 
						+ " WHERE CASEID = ?"
						+ "   AND COMPASSREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, caseId);
				preparedStatement.setString(2, compassRefNo);
				resultSet = preparedStatement.executeQuery();

				int caseCount = 0;
				while (resultSet.next()) {
					caseCount++;
				}
				query =   "SELECT RFISTATUS "
						+ "  FROM " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS "
						+ " WHERE CASEID = ? "
						+ "   AND CHECKERCOUNT = CHECKERREVIEWCOUNT"
						+ "   AND COMPASSREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, caseId);
				preparedStatement.setString(2, compassRefNo);
				resultSet = preparedStatement.executeQuery();

				int reviewdCaseCount = 0;
				while (resultSet.next()) {
					reviewdCaseCount++;
				}
				String casestatus = "1";
				if (caseCount == reviewdCaseCount) {
					casestatus = "2";
					query =   "UPDATE " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS "
							+ "   SET CASESTATUS = '2', RFISTATUS = 'CO',PREVIOUS_CASESTATUS = '1'"
							+ " WHERE CASEID = ? "
							+ "   AND COMPASSREFNO = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, caseId);
					preparedStatement.setString(2, compassRefNo);
					resultSet = preparedStatement.executeQuery();
				}

				query =   "INSERT INTO COMAML_CM.TB_RISKASSESSCWFCOMMENTSLOG(CASENO,SEQUENCENO,"
						+ " 	 	QUESTIONID,USERCODE,USERROLE,IPADDRESS,CASESTATUS,COMMENTS,LASTREVIEWEDDATE,UPDATETIMESTAMP,COMPASSREFNO)"
						+ "VALUES(?,COMAML_CM.SEQ_RISKASSESSMENTSEQNO.NEXTVAL,?,?,?,?,?,?,SYSTIMESTAMP,SYSTIMESTAMP,?)";

				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, caseId);
				preparedStatement.setString(3, userDetails.get("userCode"));
				preparedStatement.setString(4, userDetails.get("userRole"));
				preparedStatement.setString(5, userDetails.get("ipAddress"));
				preparedStatement.setString(6, casestatus);
				preparedStatement.setString(7, comments);
				preparedStatement.setString(8, compassRefNo);
//				preparedStatement.setString(5, makerCheckerData.rowDetails);

				resultSet = preparedStatement.executeQuery();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}

			return "Approved";
		} else {
			try {
				String query =    "SELECT CURRENT_USERCODE,CURRENT_USERROLE,PREVIOUS_USERCODE,PREVIOUS_USERROLE "
								+ "  FROM "+ schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS " 
								+ " WHERE CASENO = ?" 
								+ "   AND CASEID = ?"
								+ "   AND COMPASSREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, caseId);
				preparedStatement.setString(3, compassRefNo);

				resultSet = preparedStatement.executeQuery();
				String currentUserCode = "";
				String currentUserRole = "";
				String previousUserCode = "";
				String previousUserRole = "";
				if (resultSet.next()) {
					currentUserCode = resultSet.getString("CURRENT_USERCODE");
					currentUserRole = resultSet.getString("CURRENT_USERROLE");
					previousUserCode = resultSet.getString("PREVIOUS_USERCODE");
					previousUserRole = resultSet.getString("PREVIOUS_USERROLE");
				}

				query =   "UPDATE " + schemaName + "TB_CMQUES_CASEWORKFLOWDETAILS "
						+ "   SET CASESTATUS = ?,CURRENT_CASESTATUS = '0',CURRENT_USERCODE = ?,CURRENT_USERROLE = ?,"
						+ "		  PREVIOUS_USERCODE = ?,PREVIOUS_USERROLE = ?,COMMENTS = ?,PREVIOUS_CASESTATUS='1' "
						+ " WHERE CASENO = ?" 
						+ "   AND CASEID = ? "
						+ "   AND COMPASSREFNO = ?";
				
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, "0");
				preparedStatement.setString(2, previousUserCode);
				preparedStatement.setString(3, previousUserRole);
				preparedStatement.setString(4, currentUserCode);
				preparedStatement.setString(5, currentUserRole);
				preparedStatement.setString(6, comments + "(by " + userDetails.get("userCode") + ")");
				preparedStatement.setString(7, caseNo);
				preparedStatement.setString(8, caseId);
				preparedStatement.setString(9, compassRefNo);

				resultSet = preparedStatement.executeQuery();

				query =   "INSERT INTO COMAML_CM.TB_RISKASSESSCWFCOMMENTSLOG(CASENO,SEQUENCENO,QUESTIONID,"
						+ "		  USERCODE,USERROLE,IPADDRESS,CASESTATUS,COMMENTS,LASTREVIEWEDDATE,UPDATETIMESTAMP,COMPASSREFNO)"
						+ "VALUES(?,COMAML_CM.SEQ_RISKASSESSMENTSEQNO.NEXTVAL,?,?,?,?,'0',?,SYSTIMESTAMP,SYSTIMESTAMP,?)";

				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, caseNo);
				preparedStatement.setString(2, caseId);
				preparedStatement.setString(3, userDetails.get("userCode"));
				preparedStatement.setString(4, userDetails.get("userRole"));
				preparedStatement.setString(5, userDetails.get("ipAddress"));
				preparedStatement.setString(6, comments);
				preparedStatement.setString(7, compassRefNo);
//				preparedStatement.setString(5, makerCheckerData.rowDetails);

				resultSet = preparedStatement.executeQuery();

			} catch (Exception e) {
				e.printStackTrace();
			} finally {
				connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			}

			return "rejected";
		}
	}

	private List<Map<String, String>> processResultSet(ResultSet resultSet) throws Exception{
		List<Map<String, String>> fieldsDetails = new LinkedList<Map<String, String>>();
		List<String> headers = new LinkedList<String>();
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
	
	@Override
	public Map<String, Object> getCaseWorkflowModuleDetails(String moduleCode, String moduleValue, String action, String userCode, String groupCode, String ipAddress, String caseStatus,String compassRefNo){
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		String procedureName = getProcedureName("DETAILPROCEDURENAME", moduleCode);
		int noOfResultSet = getNoOfINOUTParam(procedureName);
		String tabNames = "";
		String tabDisplay = "";
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null; ResultSet resultSet2 = null;
		List<ResultSet> resultSetList = new LinkedList<ResultSet>();
		String sql = "";
		if(procedureName.equals("STP_GETCMCASEWORKFLOWCOMMENTS")) {
			sql = "{CALL "+procedureName+"(:MODULEVALUE, :ACTION, :CASESTATUS, :USERCODE, :COMPASSREFNO, :GROUPCODE, :IPADDRESS, :RESULTSET1, :RESULTSET2,";
		}
		else {
			sql = "{CALL "+procedureName+"(:MODULEVALUE, :ACTION, :CASESTATUS, :USERCODE, :GROUPCODE, :IPADDRESS, :RESULTSET1, :RESULTSET2,";
			
		}		
		for(int i = 3; i <= noOfResultSet; i++){
			if(i == noOfResultSet)
				sql = sql + ":RESULTSET"+i+" ";
			else
				sql = sql + ":RESULTSET"+i+", ";
		}
		sql = sql + ")}";
		
		
		System.out.println("Module Details Proc : "+sql);
		/*System.out.println("moduleValue : "+moduleValue+", action: "+action+", caseStatus: "+caseStatus+", userCode: "+userCode+", groupCode: "+groupCode+", ipAddress : "+ipAddress);
		*/
		try{
			callableStatement = connection.prepareCall(sql);
			callableStatement.setString("MODULEVALUE", moduleValue);
			callableStatement.setString("ACTION", action);
			callableStatement.setString("CASESTATUS", caseStatus);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("COMPASSREFNO", compassRefNo);

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
				System.out.println("resultSet"+i);
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
	
	@Override
	public Map<String,Object> getApprovedCaseResponses(String caseNos, String caseId,String caseVersion, String caseStatus, String userCode, String userRole, String ipAddress,String compassRefNo){
		System.out.println("approved case responses");
		System.out.println(("getRFIDetails qsId="+caseId+"versionNo="+caseVersion));
		String procedureName = "{CALL STP_GETRISKASSESSAPPROVEDRESP(:CASENO, :STATUS,:CASEID ,:USERCODE,:COMPASSREFNO, :ROLECODE, :IPADDRESS, :RESULTSET)}";
		Map<String, Object> resultData = new HashMap<String, Object>();
		
		Connection connection = connectionUtil.getConnection();
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		try{
			callableStatement = connection.prepareCall(procedureName);
			callableStatement.setString("CASENO", caseNos);
			callableStatement.setString("STATUS", caseStatus);
			callableStatement.setString("CASEID", caseId);
			callableStatement.setString("USERCODE", userCode);
			callableStatement.setString("COMPASSREFNO", compassRefNo);

			callableStatement.setString("ROLECODE", userRole);
			callableStatement.setString("IPADDRESS", ipAddress);
			callableStatement.registerOutParameter("RESULTSET", OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject("RESULTSET");
			ResultSetMetaData resultSetMetaData = resultSet.getMetaData();
			
			List<Object> responses = new LinkedList<Object>();
			while(resultSet.next()){
				Map<String,String> resp = new LinkedHashMap<String, String>();
				resp.put("CASENO", resultSet.getString("CASENO"));
				resp.put("OPTIONS", resultSet.getString("ESCALATIONOPTIONS"));
				resp.put("REMARKS", resultSet.getString("ESCALATIONREMARKS"));
				resp.put("MAKERCODE", resultSet.getString("ASSIGNEDMAKERCODE"));
				resp.put("CHECKERCODE", resultSet.getString("ESCALATEDTO"));
				responses.add(resp);
			}
			System.out.println("responses:"+responses.toString());
			resultData.put("RESPONSES", responses);
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		//System.out.println("Get = "+resultData);
		return resultData;
	}
}
