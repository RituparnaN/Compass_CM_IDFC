package com.quantumdataengines.app.compass.dao.riskAssessment;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.text.SimpleDateFormat;
import java.util.LinkedList;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.Map.Entry;
import java.util.Random;
import java.util.Set;
import java.util.Vector;

import oracle.jdbc.OracleTypes;

import org.json.JSONArray;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerDataModel;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class RiskAssessmentDAOImpl implements RiskAssessmentDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	public List<Map<String, String>> searchRiskAssessmentData(String ASSESSMENTUNIT, String COMPASSREFERENCENO){
		List<Map<String, String>> dataList = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "SELECT CREFNUM COMPASSREFNO, ASSESSMENTUNIT, ASSESSMENTPERIOD, "+
						"		DECODE(STATUS, 'CMO-P', 'Pending with CM Officer', "+
						"			   'CMM-P', 'Pending with CM Manager', "+
						"			   'CMM-A', 'Approved by CM Manager', "+
						"			   'CMM-R', 'Rejected by CM Manager') STATUS, "+
						"		DECODE(STATUS, 'CMO-P', CMOFFICERCODE, " + 
						"			   'CMM-P', CMOFFICERCODE, " + 
						"			   'CMM-A', CMMANAGERCODE, " + 
						"			   'CMM-R', CMMANAGERCODE) UPDATEDBY, "+
						"		FUN_DATETIMETOCHAR(DECODE(STATUS, 'CMO-P', CMOFFICERUPDATETIMESTAMP, " + 
						"			   'CMM-P', CMOFFICERUPDATETIMESTAMP, " + 
						"			   'CMM-A', CMMNGERUPDATETIMESTAMP, " + 
						"			   'CMM-R', CMMNGERUPDATETIMESTAMP)) UPDATEDON, "+
						"       STATUS STATUSCODE "+
						"  FROM TB_CMGENRLFINALRISKDETAILS "+
						" WHERE 1=1 ";
		
		if(COMPASSREFERENCENO != null && !"".equals(COMPASSREFERENCENO)){
			query = query + " AND CREFNUM = '"+COMPASSREFERENCENO+"' ";
		}
		
		if(ASSESSMENTUNIT != null && !"".equals(ASSESSMENTUNIT)){
			query = query + " AND ASSESSMENTUNIT = '"+ASSESSMENTUNIT+"' ";
		}
		
		query = query + " ORDER BY LOGTIMESTAMP DESC ";
		try{
			preparedStatement = connection.prepareStatement(query);
			
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()){
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("COMPASSREFNO", resultSet.getString("COMPASSREFNO"));
				dataMap.put("ASSESSMENTUNIT", resultSet.getString("ASSESSMENTUNIT"));
				dataMap.put("ASSESSMENTPERIOD", resultSet.getString("ASSESSMENTPERIOD"));
				dataMap.put("STATUS", resultSet.getString("STATUS"));
				dataMap.put("UPDATEBY", resultSet.getString("UPDATEDBY"));
				dataMap.put("UPDATETIMESTAMP", resultSet.getString("UPDATEDON"));
				dataMap.put("STATUSCODE", resultSet.getString("STATUSCODE"));
				dataList.add(dataMap);
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public List<String> getDistinctAssessmentUnits(){
		List<String> assessmentUnitsList = new LinkedList<String>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = "SELECT DISTINCT ASSESSMENTUNIT FROM "+schemaName+"TB_ASSESSMENTUNITMASTER ";
			preparedStatement = connection.prepareStatement(query);
		
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				assessmentUnitsList.add(resultSet.getString("ASSESSMENTUNIT"));
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return assessmentUnitsList;	
	}
		
	@SuppressWarnings("resource")
	public Map<String, Object> getRiskAssessmentForm(String ASSESSMENTUNIT, String ASSESSMENTSECTIONCODE, String COMPASSREFERENCENO, String ISNEWFORM){
		Map<String, Object> mainMap =  new LinkedHashMap<String, Object>();
		List<String> subGroupsList = new LinkedList<String>();
		List<Map<String, Object>> questionsList = new LinkedList<Map<String,Object>>();
		List<String> questionIdsList = new LinkedList<String>();
		List<Map<String, Object>> optionsList = new LinkedList<Map<String,Object>>();
		//List<Object> formDataList = new LinkedList<Object>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query = "";
		try{
			query = "SELECT DISTINCT UPPER(ASSESSMENTSECTIONCODE) ASSESSMENTSECTIONCODE, WEIGHTAGE FROM "+schemaName+"TB_ASSESSMENTUNITMASTER "+
					" WHERE UPPER(ASSESSMENTSECTIONCODE) NOT IN ('CONTROLPARAMETERS') "+
					" ORDER BY ASSESSMENTSECTIONCODE ";
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				mainMap.put(resultSet.getString("ASSESSMENTSECTIONCODE"), resultSet.getString("WEIGHTAGE"));
			}
			
			query = "SELECT DISTINCT UPPER(ASSESSMENTSUBGROUP) ASSESSMENTSUBGROUP, WEIGHTAGE FROM "+schemaName+"TB_ASSESSMENTUNITMASTER "+
					" WHERE UPPER(ASSESSMENTSECTIONCODE) IN ('CONTROLPARAMETERS') "+
					" ORDER BY ASSESSMENTSUBGROUP ";
			preparedStatement = connection.prepareStatement(query);
			resultSet = preparedStatement.executeQuery();
			List<Map<String, String>> ctrlParamWeightageList = new LinkedList<Map<String,String>>();
			while(resultSet.next()) {
				Map<String, String> ctrlParamWeightageMap = new LinkedHashMap<String, String>();
				ctrlParamWeightageMap.put(resultSet.getString("ASSESSMENTSUBGROUP"), resultSet.getString("WEIGHTAGE"));
				
				ctrlParamWeightageList.add(ctrlParamWeightageMap);
			}
			
			//System.out.println(ctrlParamWeightageList);
			mainMap.put("CONTROLPARAMSWEIGHTAGE", ctrlParamWeightageList);
			
			query = "SELECT ASSESSMENTSUBGROUP FROM "+schemaName+"TB_ASSESSMENTUNITMASTER "+
						   " WHERE ASSESSMENTUNIT = ? "+
						   "   AND ASSESSMENTSECTIONCODE = ? "+
						   " ORDER BY ASSESSMENTSUBGROUP ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, ASSESSMENTUNIT);
			preparedStatement.setString(2, ASSESSMENTSECTIONCODE);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				subGroupsList.add(resultSet.getString("ASSESSMENTSUBGROUP"));
			}
							
			//if(COMPASSREFERENCENO == null || COMPASSREFERENCENO.isEmpty()) {
			if(ISNEWFORM.equalsIgnoreCase("Y")) {
				for(String ASSESSMENTSUBGROUP : subGroupsList) {
					query = "SELECT QUESTIONID, QUESTIONDESCRIPTION, ISFREETEXTAREAREQUIRED, VERSION_SEQNO "+
					        "  FROM "+schemaName+"TB_ASSESSMENTQUESTIONMASTER "+
							" WHERE ASSESSMENTUNIT = ? " + 
							"   AND ASSESSMENTSECTIONCODE = ? "+
							"   AND ASSESSMENTSUBGROUP = ? "+
							"   AND ISENABLED = 'Y' "+
							" ORDER BY ASSESSMENTSUBGROUP, QUESTIONID ";
					//		" ORDER BY ASSESSMENTSUBGROUP, TO_NUMBER(QUESTIONID) ";
					
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, ASSESSMENTUNIT);
					preparedStatement.setString(2, ASSESSMENTSECTIONCODE);
					preparedStatement.setString(3, ASSESSMENTSUBGROUP);
					resultSet = preparedStatement.executeQuery();
					Map<String, Object> questionSetMap = new LinkedHashMap<String, Object>();
					List<Object> questionList = new LinkedList<Object>();
					while(resultSet.next()) {
						questionIdsList.add(resultSet.getString("QUESTIONID")+"."+resultSet.getString("VERSION_SEQNO"));
						
						Map<String, Object> questionsMap = new LinkedHashMap<String, Object>();
						questionsMap.put("QUESTIONID",resultSet.getString("QUESTIONID"));
						questionsMap.put("VERSION_SEQNO",resultSet.getString("VERSION_SEQNO"));
						questionsMap.put("QUESTIONDESCRIPTION",resultSet.getString("QUESTIONDESCRIPTION"));
						questionsMap.put("ISFREETEXTAREAREQUIRED",resultSet.getString("ISFREETEXTAREAREQUIRED"));
						
						query = "SELECT RFISTATUS FROM "+schemaName+"TB_CMQUES_CASEWORKFLOWDETAILS "+
								" WHERE CASEID = ?"+
								"   AND COMPASSREFNO = ?";
						//System.out.println("Q2 = "+query);
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, resultSet.getString("QUESTIONID")+"."+resultSet.getString("VERSION_SEQNO"));
						preparedStatement.setString(2, COMPASSREFERENCENO);
						ResultSet resultSet1 = preparedStatement.executeQuery();
						String rfiStatus = "NA";
						if(resultSet1.next()) {
							rfiStatus = resultSet1.getString("RFISTATUS");
						}
						questionsMap.put("RFISTATUS",rfiStatus);
						
						questionList.add(questionsMap);
						questionsMap = new LinkedHashMap<String, Object>();
					}
					questionSetMap.put(ASSESSMENTSUBGROUP, questionList);
					questionsList.add(questionSetMap);
				}
				
				for(String QUESTIONVERSIONID : questionIdsList) {
					query = "SELECT OPTIONNAME, OPTIONVALUE, "+ // -- OPTIONVALUE1, 
							//"       NVL((SELECT CASE WHEN X.ASSESSMENTSECTIONCODE = 'ControlParameters' THEN X.WEIGHTAGE||'' ELSE A.LIKELIHOODRISKRATING END "+
							"       NVL((SELECT CASE WHEN X.ASSESSMENTSECTIONCODE = 'ControlParameters' THEN ASSESSMENTCTRLSCORE ELSE A.IMPACTRISKRATING END "+
							" 			   FROM "+schemaName+"TB_ASSESSMENTUNITMASTER X,  "+schemaName+"TB_ASSESSMENTQUESTIONMASTER Y "+
							"             WHERE X.ASSESSMENTUNIT = Y.ASSESSMENTUNIT "+ 
							"               AND X.ASSESSMENTSECTIONCODE = Y.ASSESSMENTSECTIONCODE "+ 
							"               AND X.ASSESSMENTSUBGROUP = Y.ASSESSMENTSUBGROUP "+ 
							"               AND Y.ASSESSMENTUNIT = A.ASSESSMENTUNIT "+ 
							"               AND Y.QUESTIONID = A.QUESTIONID "+
							"				AND Y.ISENABLED = 'Y' ),1) "+ 
							"         AS IMPACTRISKRATING, "+
							"       NVL((SELECT CASE WHEN X.ASSESSMENTSECTIONCODE = 'ControlParameters' THEN TO_CHAR(X.WEIGHTAGE) ELSE A.LIKELIHOODRISKRATING END "+
							"              FROM "+schemaName+"TB_ASSESSMENTUNITMASTER X,  "+schemaName+"TB_ASSESSMENTQUESTIONMASTER Y "+
							"             WHERE X.ASSESSMENTUNIT = Y.ASSESSMENTUNIT "+ 
							"               AND X.ASSESSMENTSECTIONCODE = Y.ASSESSMENTSECTIONCODE "+ 
							"               AND X.ASSESSMENTSUBGROUP = Y.ASSESSMENTSUBGROUP "+ 
							"               AND Y.ASSESSMENTUNIT = A.ASSESSMENTUNIT "+ 
							"               AND Y.QUESTIONID = A.QUESTIONID "+
							"				AND Y.ISENABLED = 'Y' ),1) "+ 
							"       AS LIKELIHOODRISKRATING "+
							"  FROM "+schemaName+"TB_ASSESMNTQUESTIONNAIREMASTER A "+
							" WHERE QUESTIONID = ? "+
							"   AND VERSION_SEQNO = ? "+ 
					        "   AND ASSESSMENTUNIT = ? "+
							" ORDER BY A.OPTIONVALUE";

					String[] QUESTIONIDArr = QUESTIONVERSIONID.split("\\.");
					
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, QUESTIONIDArr[0]);
					preparedStatement.setString(2, QUESTIONIDArr[1]);
					preparedStatement.setString(3, ASSESSMENTUNIT);
					resultSet = preparedStatement.executeQuery();	
									
					Map<String, Object> optionSetMap = new LinkedHashMap<String, Object>();
					Map<String, String> optionsMap = new LinkedHashMap<String, String>();
					Map<String, String> optionsMap1 = new LinkedHashMap<String, String>();
					List<Object> optionList = new LinkedList<Object>();
					
					while(resultSet.next()) {
						optionsMap.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
						optionsMap1.put(resultSet.getString("OPTIONVALUE"), resultSet.getString("IMPACTRISKRATING").concat("~-~").concat(resultSet.getString("LIKELIHOODRISKRATING")));
					}
					
					optionList.add(optionsMap);
					optionList.add(optionsMap1);
					
					optionSetMap.put(QUESTIONIDArr[0], optionList);
						
					optionsList.add(optionSetMap);
								
				}
				
				mainMap.put("SUBGROUPSLIST", subGroupsList);
				mainMap.put("QUESTIONNAIRESLIST", questionsList);
				mainMap.put("OPTIONSLIST", optionsList);
			}else {
				String query1 = "SELECT DISTINCT ASQ.QUESTIONDESCRIPTION, ASQ.ASSESSMENTSECTIONCODE, ASQ.ASSESSMENTSUBGROUP, "+
								"		ASQ.ISFREETEXTAREAREQUIRED, X.* "+
								"  FROM (" + 
								"       SELECT A.CREFNUM, A.VERSION_SEQNO, A.QUESTIONID, NVL(A.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(A.REMARKS, 'NA') REMARKS "+
								//"		       NVL(A.IMPACTRISKRATING, ' ') IMPACTRISKRATING, NVL(A.LIKELIHOODRISKRATING, ' ') LIKELIHOODRISKRATING "+
						        "         FROM TB_CMCUSTOMERQUESTIONDETAILS A "+
								"        UNION ALL " + 
								"       SELECT C.CREFNUM, C.VERSION_SEQNO, C.QUESTIONID, NVL(C.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(C.REMARKS, 'NA') REMARKS "+
								//"			   NVL(C.IMPACTRISKRATING, ' ') IMPACTRISKRATING, NVL(C.LIKELIHOODRISKRATING, ' ') LIKELIHOODRISKRATING "+
						        "         FROM TB_CMTRANSQUESTIONDETAILS C "+
								"        UNION ALL " + 
								"       SELECT D.CREFNUM, D.VERSION_SEQNO, D.QUESTIONID, NVL(D.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(D.REMARKS, 'NA') REMARKS "+
								//"			   NVL(D.IMPACTRISKRATING, ' ') IMPACTRISKRATING, NVL(D.LIKELIHOODRISKRATING, ' ') LIKELIHOODRISKRATING "+
						        "         FROM TB_CMDELIVERYCHANNELDETAILS D "+
								"        UNION ALL " + 
								"       SELECT E.CREFNUM, E.VERSION_SEQNO, E.QUESTIONID, NVL(E.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(E.REMARKS, 'NA') REMARKS "+
								//"			   NVL(E.IMPACTRISKRATING, ' ') IMPACTRISKRATING, NVL(E.LIKELIHOODRISKRATING, ' ') LIKELIHOODRISKRATING "+
						        "         FROM TB_CMPRODUCTQUESTIONDETAILS E "+
								"        UNION ALL " + 
								"       SELECT F.CREFNUM, F.VERSION_SEQNO, F.QUESTIONID, NVL(F.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(F.REMARKS, 'NA') REMARKS "+
								//"			   NVL(F.IMPACTRISKRATING, ' ') IMPACTRISKRATING, NVL(F.LIKELIHOODRISKRATING, ' ') LIKELIHOODRISKRATING "+
						        "         FROM TB_CMGEOGQUESTIONDETAILS F "+
								"		 UNION ALL " + 
								"       SELECT B.CREFNUM, B.VERSION_SEQNO, B.QUESTIONID, NVL(B.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(B.REMARKS, 'NA') REMARKS " + 
								//"			   NVL(B.ASSESSMENTCTRLSCORE, ' ') IMPACTRISKRATING, '0' LIKELIHOODRISKRATING  " + 
								"         FROM TB_CMCONTROLPARAMETERDETAILS B "+
								"       )X " + 
						        " INNER JOIN TB_ASSESSMENTQUESTIONMASTER ASQ ON (X.QUESTIONID = ASQ.QUESTIONID AND X.VERSION_SEQNO = ASQ.VERSION_SEQNO) "+
								" WHERE X.CREFNUM = ? "+
								"   AND ASQ.ASSESSMENTSUBGROUP = ?"+
								" ORDER BY X.QUESTIONID, X.VERSION_SEQNO ";
				        
				for(String ASSESSMENTSUBGROUP : subGroupsList) {
					preparedStatement = connection.prepareStatement(query1);
					preparedStatement.setString(1, COMPASSREFERENCENO);
					preparedStatement.setString(2, ASSESSMENTSUBGROUP);
					resultSet = preparedStatement.executeQuery();
			
					Map<String, Object> questionSetMap = new LinkedHashMap<String, Object>();
					List<Object> questionList = new LinkedList<Object>();
					while(resultSet.next()) {
						questionIdsList.add(resultSet.getString("QUESTIONID")+"."+resultSet.getString("VERSION_SEQNO"));
						
						Map<String, Object> questionsMap = new LinkedHashMap<String, Object>();
						questionsMap.put("QUESTIONID",resultSet.getString("QUESTIONID"));
						questionsMap.put("VERSION_SEQNO",resultSet.getString("VERSION_SEQNO"));
						questionsMap.put("QUESTIONDESCRIPTION",resultSet.getString("QUESTIONDESCRIPTION"));
						questionsMap.put("ISFREETEXTAREAREQUIRED",resultSet.getString("ISFREETEXTAREAREQUIRED"));
						questionsMap.put("REMARKS_"+resultSet.getString("QUESTIONID"),resultSet.getString("REMARKS"));
						
						query = "SELECT RFISTATUS  FROM "+schemaName+"TB_CMQUES_CASEWORKFLOWDETAILS "+
								" WHERE CASEID = ?"+
								"   AND COMPASSREFNO = ?";
						//System.out.println("Q2 = "+query);
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, resultSet.getString("QUESTIONID")+"."+resultSet.getString("VERSION_SEQNO"));
						preparedStatement.setString(2, COMPASSREFERENCENO);
						ResultSet resultSett = preparedStatement.executeQuery();
						String rfiStatus = "NA";
						if(resultSett.next()) {
							rfiStatus = resultSett.getString("RFISTATUS");
						}
						questionsMap.put("RFISTATUS",rfiStatus);
						
						questionList.add(questionsMap);
						questionsMap = new LinkedHashMap<String, Object>();
					}
					questionSetMap.put(ASSESSMENTSUBGROUP, questionList);
					questionsList.add(questionSetMap);
				}
				
				for(String QUESTIONVERSIONID : questionIdsList) {
					query = "SELECT OPTIONNAME, OPTIONVALUE, "+
							//"       NVL((SELECT CASE WHEN X.ASSESSMENTSECTIONCODE = 'ControlParameters' THEN X.WEIGHTAGE||'' ELSE A.LIKELIHOODRISKRATING END "+
							//"       NVL((SELECT CASE WHEN X.ASSESSMENTSECTIONCODE = 'ControlParameters' THEN X.WEIGHTAGE||'' ELSE A.LIKELIHOODRISKRATING END "+
							"       NVL((SELECT CASE WHEN X.ASSESSMENTSECTIONCODE = 'ControlParameters' THEN ASSESSMENTCTRLSCORE ELSE A.IMPACTRISKRATING END "+
							" 			   FROM "+schemaName+"TB_ASSESSMENTUNITMASTER X,  "+schemaName+"TB_ASSESSMENTQUESTIONMASTER Y "+
							"             WHERE X.ASSESSMENTUNIT = Y.ASSESSMENTUNIT "+ 
							"               AND X.ASSESSMENTSECTIONCODE = Y.ASSESSMENTSECTIONCODE "+ 
							"               AND X.ASSESSMENTSUBGROUP = Y.ASSESSMENTSUBGROUP "+ 
							"               AND Y.ASSESSMENTUNIT = A.ASSESSMENTUNIT "+ 
							"               AND Y.QUESTIONID = A.QUESTIONID "+
							"				AND Y.ISENABLED = 'Y' ),1) "+ 
							"         AS IMPACTRISKRATING, "+
							"       NVL((SELECT CASE WHEN X.ASSESSMENTSECTIONCODE = 'ControlParameters' THEN TO_CHAR(X.WEIGHTAGE) ELSE A.LIKELIHOODRISKRATING END "+
							"              FROM "+schemaName+"TB_ASSESSMENTUNITMASTER X,  "+schemaName+"TB_ASSESSMENTQUESTIONMASTER Y "+
							"             WHERE X.ASSESSMENTUNIT = Y.ASSESSMENTUNIT "+ 
							"               AND X.ASSESSMENTSECTIONCODE = Y.ASSESSMENTSECTIONCODE "+ 
							"               AND X.ASSESSMENTSUBGROUP = Y.ASSESSMENTSUBGROUP "+ 
							"               AND Y.ASSESSMENTUNIT = A.ASSESSMENTUNIT "+ 
							"               AND Y.QUESTIONID = A.QUESTIONID "+
							"				AND Y.ISENABLED = 'Y' ),1) "+ 
							"       AS LIKELIHOODRISKRATING "+
							"  FROM "+schemaName+"TB_ASSESMNTQUESTIONNAIREMASTER A "+
							" WHERE QUESTIONID = ? "+
							"   AND VERSION_SEQNO = ? "+
							"   AND ASSESSMENTUNIT = ? "+
							" ORDER BY A.OPTIONVALUE";
				
					String[] QUESTIONIDArr = QUESTIONVERSIONID.split("\\.");
					/*System.out.println(query);
					System.out.println(QUESTIONIDArr[0]);
					System.out.println(QUESTIONIDArr[1]);
					System.out.println(ASSESSMENTUNIT);*/
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, QUESTIONIDArr[0]);
					preparedStatement.setString(2, QUESTIONIDArr[1]);
					preparedStatement.setString(3, ASSESSMENTUNIT);
					resultSet = preparedStatement.executeQuery();	
									
					Map<String, Object> optionSetMap = new LinkedHashMap<String, Object>();
					Map<String, String> optionsMap = new LinkedHashMap<String, String>();
					Map<String, String> optionsMap1 = new LinkedHashMap<String, String>();
					List<Object> optionList = new LinkedList<Object>();
					
					while(resultSet.next()) {
						optionsMap.put(resultSet.getString("OPTIONNAME"), resultSet.getString("OPTIONVALUE"));
						optionsMap1.put(resultSet.getString("OPTIONVALUE"), resultSet.getString("IMPACTRISKRATING").concat("~-~").concat(resultSet.getString("LIKELIHOODRISKRATING")));
					}
					
					optionList.add(optionsMap);
					optionList.add(optionsMap1);
					
					//filled up question and answers
					
					query1 = "SELECT DISTINCT ASQ.QUESTIONDESCRIPTION, ASQ.ASSESSMENTSECTIONCODE, ASQ.ASSESSMENTSUBGROUP, "+
							"		ASQ.ISFREETEXTAREAREQUIRED, X.* "+
							"  FROM (" + 
							"       SELECT A.CREFNUM, A.VERSION_SEQNO, A.QUESTIONID, NVL(A.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(A.REMARKS, 'NA') REMARKS, "+
							"		       NVL(A.IMPACTRISKRATING, 'NA') IMPACTRISKRATING, NVL(A.LIKELIHOODRISKRATING, 'NA') LIKELIHOODRISKRATING "+
					        "         FROM TB_CMCUSTOMERQUESTIONDETAILS A "+
							"        UNION ALL " + 
							"       SELECT C.CREFNUM, C.VERSION_SEQNO, C.QUESTIONID, NVL(C.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(C.REMARKS, 'NA') REMARKS, "+
							"			   NVL(C.IMPACTRISKRATING, 'NA') IMPACTRISKRATING, NVL(C.LIKELIHOODRISKRATING, 'NA') LIKELIHOODRISKRATING "+
					        "         FROM TB_CMTRANSQUESTIONDETAILS C "+
							"        UNION ALL " + 
							"       SELECT D.CREFNUM, D.VERSION_SEQNO, D.QUESTIONID, NVL(D.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(D.REMARKS, 'NA') REMARKS, "+
							"			   NVL(D.IMPACTRISKRATING, 'NA') IMPACTRISKRATING, NVL(D.LIKELIHOODRISKRATING, 'NA') LIKELIHOODRISKRATING "+
					        "         FROM TB_CMDELIVERYCHANNELDETAILS D "+
							"        UNION ALL " + 
							"       SELECT E.CREFNUM, E.VERSION_SEQNO, E.QUESTIONID, NVL(E.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(E.REMARKS, 'NA') REMARKS, "+
							"			   NVL(E.IMPACTRISKRATING, 'NA') IMPACTRISKRATING, NVL(E.LIKELIHOODRISKRATING, 'NA') LIKELIHOODRISKRATING "+
					        "         FROM TB_CMPRODUCTQUESTIONDETAILS E "+
							"        UNION ALL " + 
							"       SELECT F.CREFNUM, F.VERSION_SEQNO, F.QUESTIONID, NVL(F.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(F.REMARKS, 'NA') REMARKS, "+
							"			   NVL(F.IMPACTRISKRATING, 'NA') IMPACTRISKRATING, NVL(F.LIKELIHOODRISKRATING, 'NA') LIKELIHOODRISKRATING "+
					        "         FROM TB_CMGEOGQUESTIONDETAILS F "+
					        "		 UNION ALL " + 
							"       SELECT B.CREFNUM, B.VERSION_SEQNO, B.QUESTIONID, NVL(B.QUESTIONVALUE, 'NA') QUESTIONVALUE, NVL(B.REMARKS, 'NA') REMARKS, " + 
							"			   NVL(B.ASSESSMENTCTRLSCORE, 'NA') IMPACTRISKRATING, "+
							"			   NVL((SELECT TO_CHAR(X.WEIGHTAGE) FROM TB_ASSESSMENTUNITMASTER X, TB_ASSESSMENTQUESTIONMASTER Y "+ 
							"        WHERE X.ASSESSMENTUNIT = Y.ASSESSMENTUNIT "+ 
							"          AND X.ASSESSMENTSECTIONCODE = Y.ASSESSMENTSECTIONCODE "+ 
							"          AND X.ASSESSMENTSUBGROUP = Y.ASSESSMENTSUBGROUP "+ 
							"          AND Y.QUESTIONID = B.QUESTIONID "+ 
							"          AND Y.VERSION_SEQNO = B.VERSION_SEQNO "+ 
							"          AND Y.ISENABLED = 'Y' ), '0') LIKELIHOODRISKRATING  "+ 
							"         FROM TB_CMCONTROLPARAMETERDETAILS B "+
							"       )X " + 
					        " INNER JOIN TB_ASSESSMENTQUESTIONMASTER ASQ ON (X.QUESTIONID=ASQ.QUESTIONID AND X.VERSION_SEQNO = ASQ.VERSION_SEQNO) "+
							" WHERE X.CREFNUM = ? "+
							"   AND X.QUESTIONID = ? "+
							"   AND X.VERSION_SEQNO = ?"+
							" ORDER BY X.QUESTIONID, X.VERSION_SEQNO ";
					
					preparedStatement = connection.prepareStatement(query1);
					preparedStatement.setString(1, COMPASSREFERENCENO);
					preparedStatement.setString(2, QUESTIONIDArr[0]);
					preparedStatement.setString(3, QUESTIONIDArr[1]);
					resultSet = preparedStatement.executeQuery();	
					
					Map<String, Object> formDataMap = new LinkedHashMap<String, Object>();
					
					while(resultSet.next()) {
						String QUESTIONVALUE = resultSet.getString("QUESTIONVALUE").trim();
						String IMPACTRISKRATING = resultSet.getString("IMPACTRISKRATING").trim();
						String LIKELIHOODRISKRATING = resultSet.getString("LIKELIHOODRISKRATING").trim();
						formDataMap.put(QUESTIONVALUE, IMPACTRISKRATING.concat("~-~").concat(LIKELIHOODRISKRATING));
						
					}

					optionList.add(formDataMap);										
					optionSetMap.put(QUESTIONIDArr[0], optionList);
						
					optionsList.add(optionSetMap);
				}	
								
				mainMap.put("SUBGROUPSLIST", subGroupsList);
				mainMap.put("QUESTIONNAIRESLIST", questionsList);
				mainMap.put("OPTIONSLIST", optionsList);
				
				String sql = "SELECT CREFNUM, ASSESSMENTUNIT, ASSESSMENTPERIOD, POCNAME, POCEMAIL, COMPLIANCE1, BUSINESS1, OTHER1, KEYBUSINESSNAME1, " + 
							 "		 KEYBUSINESSROLE1, KEYBUSINESSNAME2, KEYBUSINESSROLE2, KEYBUSINESSNAME3, KEYBUSINESSROLE3, CUSTOMERSYSTEMGENRISK," + 
							 "		 CUSTOMERPROVISRISK, CUSTOMERFINALRISK, CUSTOMERREMARKS, GEOGSYSTEMGENRISK, GEOGPROVISRISK, GEOGFINALRISK, " + 
							 "		 GEOGREMARKS, PRODUCTSSYSTEMGENRISK, PRODUCTSPROVISRISK, PRODUCTSFINALRISK, PRODUCTSREMARKS, DELIVERYSYSTEMGENRISK, " + 
							 "		 DELIVERYPROVISRISK, DELIVERYFINALRISK, DELIVERYREMARKS, TRANSACTIONSSYSTEMGENRISK, TRANSACTIONSPROVISRISK, " + 
							 "		 TRANSACTIONSFINALRISK, TRANSACTIONSREMARKS, CONTROLSYSTEMGENRISK, CONTROLPROVISRISK, CONTROLFINALRISK, " + 
							 "		 CONTROLREMARKS, CMOFFICERCODE, CMOFFICERUPDATETIMESTAMP, CMMANAGERCODE, CMMNGERUPDATETIMESTAMP, STATUS, " + 
							 "		 CMOFFICERCOMMENTS, CMMANAGERCOMMENTS, COMPLIANCE2, BUSINESS2, OTHER2, RESIDUALSYSTEMGENRISK, RESIDUALPROVRISK, " +
							 "       RESIDUALFINALRISK, RESIDUALREMARKS, TOTINHSYSGENRISK, TOTINHPROVISRISK, TOTINHFINALRISK "+
							 "	FROM TB_CMGENRLFINALRISKDETAILS" + 
							 " WHERE CREFNUM = ?"; 
				
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, COMPASSREFERENCENO);
				resultSet = preparedStatement.executeQuery();
				while(resultSet.next()) {
					Map<String, String> generalDataMap = new LinkedHashMap<String, String>();
					generalDataMap.put("ASSESSMENTUNIT", resultSet.getString("ASSESSMENTUNIT"));
					generalDataMap.put("ASSESSMENTPERIOD", resultSet.getString("ASSESSMENTPERIOD"));
					generalDataMap.put("POCNAME", resultSet.getString("POCNAME"));
					generalDataMap.put("POCEMAIL", resultSet.getString("POCEMAIL"));
					generalDataMap.put("COMPLIANCE1", resultSet.getString("COMPLIANCE1"));
					generalDataMap.put("BUSINESS1", resultSet.getString("BUSINESS1"));
					generalDataMap.put("OTHER1", resultSet.getString("OTHER1"));
					generalDataMap.put("COMPLIANCE2", resultSet.getString("COMPLIANCE2"));
					generalDataMap.put("BUSINESS2", resultSet.getString("BUSINESS2"));
					generalDataMap.put("OTHER2", resultSet.getString("OTHER2"));
					generalDataMap.put("KEYBUSINESSNAME1", resultSet.getString("KEYBUSINESSNAME1"));
					generalDataMap.put("KEYBUSINESSROLE1", resultSet.getString("KEYBUSINESSROLE1"));
					generalDataMap.put("KEYBUSINESSNAME2", resultSet.getString("KEYBUSINESSNAME2"));
					generalDataMap.put("KEYBUSINESSROLE2", resultSet.getString("KEYBUSINESSROLE2"));
					generalDataMap.put("KEYBUSINESSNAME3", resultSet.getString("KEYBUSINESSNAME3"));
					generalDataMap.put("KEYBUSINESSROLE3", resultSet.getString("KEYBUSINESSROLE3"));
					
					generalDataMap.put("CUSTOMERSYSTEMGENRISK", resultSet.getString("CUSTOMERSYSTEMGENRISK"));
					generalDataMap.put("CUSTOMERPROVISRISK", resultSet.getString("CUSTOMERPROVISRISK"));
					double CUSTOMERFINALRISK = Double.parseDouble((resultSet.getString("CUSTOMERFINALRISK")));
					generalDataMap.put("CUSTOMERFINALRISK", (CUSTOMERFINALRISK <= 2) ? "Low - "+CUSTOMERFINALRISK : (CUSTOMERFINALRISK > 2 && CUSTOMERFINALRISK <= 6) ? "Medium - "+CUSTOMERFINALRISK : (CUSTOMERFINALRISK > 6) ? "High - "+CUSTOMERFINALRISK : "");
					generalDataMap.put("CUSTOMERREMARKS", resultSet.getString("CUSTOMERREMARKS"));
					
					generalDataMap.put("GEOGSYSTEMGENRISK", resultSet.getString("GEOGSYSTEMGENRISK"));
					generalDataMap.put("GEOGPROVISRISK", resultSet.getString("GEOGPROVISRISK"));
					//generalDataMap.put("GEOGFINALRISK", resultSet.getString("GEOGFINALRISK"));
					double GEOGFINALRISK = Double.parseDouble((resultSet.getString("GEOGFINALRISK")));
					generalDataMap.put("GEOGFINALRISK", (GEOGFINALRISK <= 2) ? "Low - "+GEOGFINALRISK : (GEOGFINALRISK > 2 && GEOGFINALRISK <= 6) ? "Medium - "+GEOGFINALRISK : (GEOGFINALRISK > 6) ? "High - "+GEOGFINALRISK : "");
					generalDataMap.put("GEOGREMARKS", resultSet.getString("GEOGREMARKS"));
					
					generalDataMap.put("PRODUCTSSYSTEMGENRISK", resultSet.getString("PRODUCTSSYSTEMGENRISK"));
					generalDataMap.put("PRODUCTSPROVISRISK", resultSet.getString("PRODUCTSPROVISRISK"));
					//generalDataMap.put("PRODUCTSFINALRISK", resultSet.getString("PRODUCTSFINALRISK"));
					double PRODUCTSFINALRISK = Double.parseDouble((resultSet.getString("PRODUCTSFINALRISK")));
					generalDataMap.put("PRODUCTSFINALRISK", (PRODUCTSFINALRISK <= 2) ? "Low - "+PRODUCTSFINALRISK : (PRODUCTSFINALRISK > 2 && PRODUCTSFINALRISK <= 6) ? "Medium - "+PRODUCTSFINALRISK : (PRODUCTSFINALRISK > 6) ? "High - "+PRODUCTSFINALRISK : "");
					generalDataMap.put("PRODUCTSREMARKS", resultSet.getString("PRODUCTSREMARKS"));
					
					generalDataMap.put("DELIVERYSYSTEMGENRISK", resultSet.getString("DELIVERYSYSTEMGENRISK"));
					generalDataMap.put("DELIVERYPROVISRISK", resultSet.getString("DELIVERYPROVISRISK"));
					//generalDataMap.put("DELIVERYFINALRISK", resultSet.getString("DELIVERYFINALRISK"));
					double DELIVERYFINALRISK = Double.parseDouble((resultSet.getString("DELIVERYFINALRISK")));
					generalDataMap.put("DELIVERYFINALRISK", (DELIVERYFINALRISK <= 2) ? "Low - "+DELIVERYFINALRISK : (DELIVERYFINALRISK > 2 && DELIVERYFINALRISK <= 6) ? "Medium - "+DELIVERYFINALRISK : (DELIVERYFINALRISK > 6) ? "High - "+DELIVERYFINALRISK : "");
					generalDataMap.put("DELIVERYREMARKS", resultSet.getString("DELIVERYREMARKS"));
					
					generalDataMap.put("TRANSACTIONSSYSTEMGENRISK", resultSet.getString("TRANSACTIONSSYSTEMGENRISK"));
					generalDataMap.put("TRANSACTIONSPROVISRISK", resultSet.getString("TRANSACTIONSPROVISRISK"));
					//generalDataMap.put("TRANSACTIONSFINALRISK", resultSet.getString("TRANSACTIONSFINALRISK"));
					double TRANSACTIONSFINALRISK = Double.parseDouble((resultSet.getString("TRANSACTIONSFINALRISK")));
					generalDataMap.put("TRANSACTIONSFINALRISK", (TRANSACTIONSFINALRISK <= 2) ? "Low - "+TRANSACTIONSFINALRISK : (TRANSACTIONSFINALRISK > 2 && TRANSACTIONSFINALRISK <= 6) ? "Medium - "+TRANSACTIONSFINALRISK : (TRANSACTIONSFINALRISK > 6) ? "High - "+TRANSACTIONSFINALRISK : "");
					generalDataMap.put("TRANSACTIONSREMARKS", resultSet.getString("TRANSACTIONSREMARKS"));
					
					generalDataMap.put("CONTROLSYSTEMGENRISK", resultSet.getString("CONTROLSYSTEMGENRISK"));
					generalDataMap.put("CONTROLPROVISRISK", resultSet.getString("CONTROLPROVISRISK"));
					//generalDataMap.put("CONTROLFINALRISK", resultSet.getString("CONTROLFINALRISK"));
					double CONTROLFINALRISK = Double.parseDouble((resultSet.getString("CONTROLFINALRISK")));
					generalDataMap.put("CONTROLFINALRISK", (CONTROLFINALRISK <= 2) ? "Low - "+CONTROLFINALRISK : (CONTROLFINALRISK > 2 && CONTROLFINALRISK <= 6) ? "Medium - "+CONTROLFINALRISK : (CONTROLFINALRISK > 6) ? "High - "+CONTROLFINALRISK : "");
					generalDataMap.put("CONTROLREMARKS", resultSet.getString("CONTROLREMARKS"));
					
					generalDataMap.put("TOTINHSYSGENRISK", resultSet.getString("TOTINHSYSGENRISK"));
					generalDataMap.put("TOTINHPROVISRISK", resultSet.getString("TOTINHPROVISRISK"));
					generalDataMap.put("TOTINHFINALRISK", resultSet.getString("TOTINHFINALRISK"));
					/*double TOTINHFINALRISK = Double.parseDouble((resultSet.getString("TOTINHFINALRISK")));
					generalDataMap.put("TOTINHFINALRISK", (TOTINHFINALRISK <= 2) ? "Low - "+TOTINHFINALRISK : (TOTINHFINALRISK > 2 && TOTINHFINALRISK <= 6) ? "Medium - "+TOTINHFINALRISK : (TOTINHFINALRISK > 6) ? "High - "+TOTINHFINALRISK : "");*/
					
					generalDataMap.put("RESIDUALSYSTEMGENRISK", resultSet.getString("RESIDUALSYSTEMGENRISK"));
					generalDataMap.put("RESIDUALPROVRISK", resultSet.getString("RESIDUALPROVRISK"));
					generalDataMap.put("RESIDUALFINALRISK", resultSet.getString("RESIDUALFINALRISK"));
					generalDataMap.put("RESIDUALREMARKS", resultSet.getString("RESIDUALREMARKS"));
					
					generalDataMap.put("CMOFFICERCODE", resultSet.getString("CMOFFICERCODE"));
					generalDataMap.put("CMOFFICERUPDATETIMESTAMP", resultSet.getString("CMOFFICERUPDATETIMESTAMP"));
					generalDataMap.put("CMOFFICERCOMMENTS", resultSet.getString("CMOFFICERCOMMENTS"));

					generalDataMap.put("CMMANAGERCODE", resultSet.getString("CMMANAGERCODE"));
					generalDataMap.put("CMMNGERUPDATETIMESTAMP", resultSet.getString("CMMNGERUPDATETIMESTAMP"));
					generalDataMap.put("CMMANAGERCOMMENTS", resultSet.getString("CMMANAGERCOMMENTS"));
					
					generalDataMap.put("STATUS", resultSet.getString("STATUS"));

					mainMap.put("GENERALDATAMAP", generalDataMap);
				}
				mainMap.put("STATUSAUDITLOG", getCMAuditLog(COMPASSREFERENCENO));
			}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return mainMap;		
	}
	
	public String saveRiskAssessmentData(Map<String, Object> formData, String status, String userCode, String userRole, String ipAddress) {
		String result = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		String COMPASSREFNO = "";
		boolean customerStatus = false;
		boolean geographyStatus = false;
		boolean productsStatus = false;
		boolean transactionsStatus = false;
		boolean deliveryStatus = false;
		boolean controlStatus = false;
		boolean isFormExistsWithCREFNUM = false;
		
		
		try{
			
			if(!formData.isEmpty()) {
			Map<String, Object> generalData = new LinkedHashMap<String, Object>();
			Map<String, Object> customerData = new LinkedHashMap<String, Object>();
			Map<String, Object> geographyData = new LinkedHashMap<String, Object>();
			Map<String, Object> transactionsData = new LinkedHashMap<String, Object>();
			Map<String, Object> deliveryChannelsData = new LinkedHashMap<String, Object>();
			Map<String, Object> productsServicesData = new LinkedHashMap<String, Object>();
			Map<String, Object> controlParametersData = new LinkedHashMap<String, Object>();
			Map<String, Object> totalRiskData = new LinkedHashMap<String, Object>();
			Map<String, Object> statusData = new LinkedHashMap<String, Object>();
			Map<String, Object> generalStatusRiskData = new LinkedHashMap<String, Object>();
			
			COMPASSREFNO = (String) (formData.get("COMPASSREFNO") != "" ? formData.get("COMPASSREFNO") : "");
			
			try {
				if(!COMPASSREFNO.isEmpty()) {
					
					sql = "SELECT COUNT(*) ROWCOUNT FROM TB_CMGENRLFINALRISKDETAILS WHERE CREFNUM= ?";
					
					preparedStatement = connection.prepareStatement(sql);
					preparedStatement.setString(1, COMPASSREFNO);
					ResultSet res = preparedStatement.executeQuery();
					if(res.next()) {
						if(res.getInt("ROWCOUNT") > 0) {
							isFormExistsWithCREFNUM = true;
						}
					}
				}
			}
			catch(Exception e) {
				System.out.println("error while checking for existing form with crefnum");
				e.printStackTrace();
			}
//			if(isFormExistsWithCREFNUM)
//				System.out.println("isFormExists: true");
//			else
//				System.out.println("isFormExists: false");
			
			for (Map.Entry<String,Object> entry : formData.entrySet()) {
				if(entry.getKey().startsWith("GENERAL_")) {
					generalData.put(entry.getKey(), entry.getValue());
				}
				
				if(entry.getKey().startsWith("CUSTOMER_")) {
					customerData.put(entry.getKey(), entry.getValue());
				}

				if(entry.getKey().startsWith("GEOGRAPHY_")) {
					geographyData.put(entry.getKey(), entry.getValue());
				}
				
				if(entry.getKey().startsWith("TRANSACTIONS_")) {
					transactionsData.put(entry.getKey(), entry.getValue());
				}
				
				if(entry.getKey().startsWith("DELIVERYCHANNELS_")) {
					deliveryChannelsData.put(entry.getKey(), entry.getValue());
				}
				
				if(entry.getKey().startsWith("PRODUCTSSERVICES_")) {
					productsServicesData.put(entry.getKey(), entry.getValue());
				}
				
				if(entry.getKey().startsWith("CONTROLPARAMETERS_")) {
					controlParametersData.put(entry.getKey(), entry.getValue());
				}
				
				if(entry.getKey().startsWith("TOTAL_")) {
					totalRiskData.put(entry.getKey(), entry.getValue());
				}
				
				if(entry.getKey().startsWith("STATUS_")) {
					statusData.put(entry.getKey(), entry.getValue());
				}
				
			}
			
			generalStatusRiskData.putAll(generalData);
			generalStatusRiskData.putAll(totalRiskData);
			generalStatusRiskData.putAll(statusData);
						
			//Saving as draft with Compass Ref No
			if(status.equals("CMO-P") && ! COMPASSREFNO.isEmpty() && isFormExistsWithCREFNUM) {
				System.out.println("Saving as draft with Compass Ref No");
					sql = "UPDATE TB_CMGENRLFINALRISKDETAILS "+
						  "   SET ASSESSMENTUNIT = ?, ASSESSMENTPERIOD = ?, POCNAME = ?, POCEMAIL = ?, "+
						  "       COMPLIANCE1 = ?, BUSINESS1 = ?, OTHER1 = ?, COMPLIANCE2 = ?, BUSINESS2 = ?, OTHER2 = ?, "+
						  "		  KEYBUSINESSNAME1 = ?, KEYBUSINESSROLE1 = ?, KEYBUSINESSNAME2 = ?, KEYBUSINESSROLE2 = ?, "+
						  "		  KEYBUSINESSNAME3 = ?, KEYBUSINESSROLE3 = ?, "+
						  "		  CUSTOMERSYSTEMGENRISK = ?, CUSTOMERPROVISRISK = ?, CUSTOMERFINALRISK = ?, CUSTOMERREMARKS = ?, "+
						  "		  GEOGSYSTEMGENRISK = ?, GEOGPROVISRISK = ?, GEOGFINALRISK = ?, GEOGREMARKS = ?, "+
						  "       PRODUCTSSYSTEMGENRISK = ?, PRODUCTSPROVISRISK = ?, PRODUCTSFINALRISK = ?, PRODUCTSREMARKS = ?, "+
						  "       DELIVERYSYSTEMGENRISK = ?, DELIVERYPROVISRISK = ?, DELIVERYFINALRISK = ?, DELIVERYREMARKS = ?, "+
						  "		  TRANSACTIONSSYSTEMGENRISK = ?, TRANSACTIONSPROVISRISK = ?, TRANSACTIONSFINALRISK = ?, TRANSACTIONSREMARKS = ?, "+
						  "       CONTROLSYSTEMGENRISK = ?, CONTROLPROVISRISK = ?, CONTROLFINALRISK = ?, CONTROLREMARKS = ?, "+
						  "       CMOFFICERCODE = ?, CMOFFICERUPDATETIMESTAMP = SYSTIMESTAMP, CMOFFICERCOMMENTS = ?, "+
						  "		  STATUS = ?, LOGTIMESTAMP = SYSTIMESTAMP, RESIDUALSYSTEMGENRISK = ?, RESIDUALPROVRISK = ?, RESIDUALFINALRISK = ?, "+
						  "       RESIDUALREMARKS = ?, TOTINHSYSGENRISK = ?, TOTINHPROVISRISK = ?, TOTINHFINALRISK = ? "+
						  " WHERE CREFNUM = ? ";

					preparedStatement = connection.prepareStatement(sql);
					preparedStatement.setString(1, generalData.get("GENERAL_ASSESSMENTUNIT").toString());
					preparedStatement.setString(2, generalData.get("GENERAL_ASSESSMENTPERIOD").toString());
					preparedStatement.setString(3, generalData.get("GENERAL_POCNAME").toString());
					preparedStatement.setString(4, generalData.get("GENERAL_POCEMAIL").toString());
					preparedStatement.setString(5, generalData.get("GENERAL_COMPLIANCE1").toString());
					preparedStatement.setString(6, generalData.get("GENERAL_BUSINESS1").toString());
					preparedStatement.setString(7, generalData.get("GENERAL_OTHER1").toString());
					preparedStatement.setString(8, generalData.get("GENERAL_COMPLIANCE2").toString());
					preparedStatement.setString(9, generalData.get("GENERAL_BUSINESS2").toString());
					preparedStatement.setString(10, generalData.get("GENERAL_OTHER2").toString());
					preparedStatement.setString(11, generalData.get("GENERAL_NAME1").toString());
					preparedStatement.setString(12, generalData.get("GENERAL_ROLE1").toString());
					preparedStatement.setString(13, generalData.get("GENERAL_NAME2").toString());
					preparedStatement.setString(14, generalData.get("GENERAL_ROLE2").toString());
					preparedStatement.setString(15, generalData.get("GENERAL_NAME3").toString());
					preparedStatement.setString(16, generalData.get("GENERAL_ROLE3").toString());
					preparedStatement.setString(17, customerData.get("CUSTOMER_SYSTEMRISKRATING").toString());
					preparedStatement.setString(18, customerData.get("CUSTOMER_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(19, customerData.get("CUSTOMER_FINALRISKRATING1").toString().concat(customerData.get("CUSTOMER_FINALRISKRATING2").toString()));
					preparedStatement.setString(20, customerData.get("CUSTOMER_RISKRATINGREASON").toString());
					preparedStatement.setString(21, geographyData.get("GEOGRAPHY_SYSTEMRISKRATING").toString());
					preparedStatement.setString(22, geographyData.get("GEOGRAPHY_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(23, geographyData.get("GEOGRAPHY_FINALRISKRATING1").toString().concat(geographyData.get("GEOGRAPHY_FINALRISKRATING2").toString()));
					preparedStatement.setString(24, geographyData.get("GEOGRAPHY_RISKRATINGREASON").toString());
					preparedStatement.setString(25, productsServicesData.get("PRODUCTSSERVICES_SYSTEMRISKRATING").toString());
					preparedStatement.setString(26, productsServicesData.get("PRODUCTSSERVICES_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(27, productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING1").toString().concat(productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING2").toString()));
					preparedStatement.setString(28, productsServicesData.get("PRODUCTSSERVICES_RISKRATINGREASON").toString());
					preparedStatement.setString(29, deliveryChannelsData.get("DELIVERYCHANNELS_SYSTEMRISKRATING").toString());
					preparedStatement.setString(30, deliveryChannelsData.get("DELIVERYCHANNELS_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(31, deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING1").toString().concat(deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING2").toString()));
					preparedStatement.setString(32, deliveryChannelsData.get("DELIVERYCHANNELS_RISKRATINGREASON").toString());
					preparedStatement.setString(33, transactionsData.get("TRANSACTIONS_SYSTEMRISKRATING").toString());
					preparedStatement.setString(34, transactionsData.get("TRANSACTIONS_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(35, transactionsData.get("TRANSACTIONS_FINALRISKRATING1").toString().concat(transactionsData.get("TRANSACTIONS_FINALRISKRATING2").toString()));
					preparedStatement.setString(36, transactionsData.get("TRANSACTIONS_RISKRATINGREASON").toString());
					preparedStatement.setString(37, controlParametersData.get("CONTROLPARAMETERS_SYSTEMRISKRATING").toString());
					preparedStatement.setString(38, controlParametersData.get("CONTROLPARAMETERS_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(39, controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING1").toString().concat(controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING2").toString()));
					preparedStatement.setString(40, controlParametersData.get("CONTROLPARAMETERS_RISKRATINGREASON").toString());
					preparedStatement.setString(41, statusData.get("STATUS_CMOFFICERCODE").toString());
					preparedStatement.setString(42, statusData.get("STATUS_CMOFFICERCOMMENTS").toString());
					preparedStatement.setString(43, status);
					preparedStatement.setString(44, totalRiskData.get("TOTAL_SYSTEMRISKRATING").toString());
					preparedStatement.setString(45, totalRiskData.get("TOTAL_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(46, totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING1").toString().concat(totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING2").toString()));
					preparedStatement.setString(47, totalRiskData.get("TOTAL_RISKRATINGREASON").toString());
					preparedStatement.setString(48, totalRiskData.get("TOTAL_INHERENTSYSTEMRISKRATING").toString());
					preparedStatement.setString(49, totalRiskData.get("TOTAL_INHERENTPROVRISKRATING").toString());
					preparedStatement.setString(50, totalRiskData.get("TOTAL_INHERENTFINALRISKRATING").toString());
										
					preparedStatement.setString(51, COMPASSREFNO);
					
					int isUpdated = preparedStatement.executeUpdate();
					//System.out.println(isUpdated);
					
					if(isUpdated > 0) {
						customerStatus = saveCMCustomerQuestionsData(COMPASSREFNO, status, customerData, statusData.get("STATUS_CMOFFICERCODE").toString());
						geographyStatus = saveCMGeographyQuestionsData(COMPASSREFNO, status, geographyData, statusData.get("STATUS_CMOFFICERCODE").toString());
						productsStatus = saveCMProductServicesQuestionsData(COMPASSREFNO, status, productsServicesData, statusData.get("STATUS_CMOFFICERCODE").toString());
						transactionsStatus = saveCMTransactionQuestionsData(COMPASSREFNO, status, transactionsData, statusData.get("STATUS_CMOFFICERCODE").toString());
						deliveryStatus = saveCMDeliveryChannelsQuestionsData(COMPASSREFNO, status, deliveryChannelsData, statusData.get("STATUS_CMOFFICERCODE").toString());
						controlStatus = saveCMControlParametersQuestionsData(COMPASSREFNO, status, controlParametersData, statusData.get("STATUS_CMOFFICERCODE").toString());
						saveCMAuditLog(COMPASSREFNO, status, statusData);
					}
					result = "Risk Assessment form successfully saved as draft.";
					
			//}else if(status.equals("CMO-P") && COMPASSREFNO.isEmpty()) {                    //Saving as draft without Compass Ref No
			}else if(status.equals("CMO-P")) {
				//COMPASSREFNO = generateCompassRefNo();
				
				sql = "INSERT INTO TB_CMGENRLFINALRISKDETAILS ( "+
					  "		  ASSESSMENTUNIT, ASSESSMENTPERIOD, POCNAME, POCEMAIL, " + 
					  "		  COMPLIANCE1, BUSINESS1, OTHER1, COMPLIANCE2, BUSINESS2, OTHER2, " + 
					  "       KEYBUSINESSNAME1, KEYBUSINESSROLE1, KEYBUSINESSNAME2, KEYBUSINESSROLE2, " + 
					  "		  KEYBUSINESSNAME3, KEYBUSINESSROLE3, " + 
					  "	      CUSTOMERSYSTEMGENRISK, CUSTOMERPROVISRISK, CUSTOMERFINALRISK, CUSTOMERREMARKS, " + 
					  "	  	  GEOGSYSTEMGENRISK, GEOGPROVISRISK, GEOGFINALRISK, GEOGREMARKS, " + 
					  "	  	  PRODUCTSSYSTEMGENRISK, PRODUCTSPROVISRISK, PRODUCTSFINALRISK, PRODUCTSREMARKS, " + 
					  "	  	  DELIVERYSYSTEMGENRISK, DELIVERYPROVISRISK, DELIVERYFINALRISK, DELIVERYREMARKS, " + 
					  "	  	  TRANSACTIONSSYSTEMGENRISK, TRANSACTIONSPROVISRISK, TRANSACTIONSFINALRISK, TRANSACTIONSREMARKS, " + 
					  "	  	  CONTROLSYSTEMGENRISK, CONTROLPROVISRISK, CONTROLFINALRISK, CONTROLREMARKS, " + 
					  "	  	  CMOFFICERCODE, CMOFFICERUPDATETIMESTAMP, CMOFFICERCOMMENTS, " + 
					  "	  	  STATUS, CREFNUM, LOGTIMESTAMP, RESIDUALSYSTEMGENRISK, RESIDUALPROVRISK, RESIDUALFINALRISK, RESIDUALREMARKS,"+
					  "		  TOTINHSYSGENRISK, TOTINHPROVISRISK, TOTINHFINALRISK ) "+
					  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
					  "       ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
					  "		  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
					  "		  ?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?, ?, "+
					  "		  ?, SYSTIMESTAMP, ?, ?, ?, ?, ?, ?, ?)";
				//System.out.println(sql);
				
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, generalData.get("GENERAL_ASSESSMENTUNIT").toString());
				preparedStatement.setString(2, generalData.get("GENERAL_ASSESSMENTPERIOD").toString());
				preparedStatement.setString(3, generalData.get("GENERAL_POCNAME").toString());
				preparedStatement.setString(4, generalData.get("GENERAL_POCEMAIL").toString());
				preparedStatement.setString(5, generalData.get("GENERAL_COMPLIANCE1").toString());
				preparedStatement.setString(6, generalData.get("GENERAL_BUSINESS1").toString());
				preparedStatement.setString(7, generalData.get("GENERAL_OTHER1").toString());
				preparedStatement.setString(8, generalData.get("GENERAL_COMPLIANCE2").toString());
				preparedStatement.setString(9, generalData.get("GENERAL_BUSINESS2").toString());
				preparedStatement.setString(10, generalData.get("GENERAL_OTHER2").toString());
				preparedStatement.setString(11, generalData.get("GENERAL_NAME1").toString());
				preparedStatement.setString(12, generalData.get("GENERAL_ROLE1").toString());
				preparedStatement.setString(13, generalData.get("GENERAL_NAME2").toString());
				preparedStatement.setString(14, generalData.get("GENERAL_ROLE2").toString());
				preparedStatement.setString(15, generalData.get("GENERAL_NAME3").toString());
				preparedStatement.setString(16, generalData.get("GENERAL_ROLE3").toString());
				preparedStatement.setString(17, customerData.get("CUSTOMER_SYSTEMRISKRATING").toString());
				preparedStatement.setString(18, customerData.get("CUSTOMER_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(19, customerData.get("CUSTOMER_FINALRISKRATING1").toString().concat(customerData.get("CUSTOMER_FINALRISKRATING2").toString()));
				preparedStatement.setString(20, customerData.get("CUSTOMER_RISKRATINGREASON").toString());
				preparedStatement.setString(21, geographyData.get("GEOGRAPHY_SYSTEMRISKRATING").toString());
				preparedStatement.setString(22, geographyData.get("GEOGRAPHY_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(23, geographyData.get("GEOGRAPHY_FINALRISKRATING1").toString().concat(geographyData.get("GEOGRAPHY_FINALRISKRATING2").toString()));
				preparedStatement.setString(24, geographyData.get("GEOGRAPHY_RISKRATINGREASON").toString());
				preparedStatement.setString(25, productsServicesData.get("PRODUCTSSERVICES_SYSTEMRISKRATING").toString());
				preparedStatement.setString(26, productsServicesData.get("PRODUCTSSERVICES_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(27, productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING1").toString().concat(productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING2").toString()));
				preparedStatement.setString(28, productsServicesData.get("PRODUCTSSERVICES_RISKRATINGREASON").toString());
				preparedStatement.setString(29, deliveryChannelsData.get("DELIVERYCHANNELS_SYSTEMRISKRATING").toString());
				preparedStatement.setString(30, deliveryChannelsData.get("DELIVERYCHANNELS_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(31, deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING1").toString().concat(deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING2").toString()));
				preparedStatement.setString(32, deliveryChannelsData.get("DELIVERYCHANNELS_RISKRATINGREASON").toString());
				preparedStatement.setString(33, transactionsData.get("TRANSACTIONS_SYSTEMRISKRATING").toString());
				preparedStatement.setString(34, transactionsData.get("TRANSACTIONS_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(35, transactionsData.get("TRANSACTIONS_FINALRISKRATING1").toString().concat(transactionsData.get("TRANSACTIONS_FINALRISKRATING2").toString()));
				preparedStatement.setString(36, transactionsData.get("TRANSACTIONS_RISKRATINGREASON").toString());
				preparedStatement.setString(37, controlParametersData.get("CONTROLPARAMETERS_SYSTEMRISKRATING").toString());
				preparedStatement.setString(38, controlParametersData.get("CONTROLPARAMETERS_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(39, controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING1").toString().concat(controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING2").toString()));
				preparedStatement.setString(40, controlParametersData.get("CONTROLPARAMETERS_RISKRATINGREASON").toString());
				preparedStatement.setString(41, statusData.get("STATUS_CMOFFICERCODE").toString());
				preparedStatement.setString(42, statusData.get("STATUS_CMOFFICERCOMMENTS").toString());
				preparedStatement.setString(43, status);
				preparedStatement.setString(44, COMPASSREFNO);
				preparedStatement.setString(45, totalRiskData.get("TOTAL_SYSTEMRISKRATING").toString());
				preparedStatement.setString(46, totalRiskData.get("TOTAL_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(47, totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING1").toString().concat(totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING2").toString()));
				preparedStatement.setString(48, totalRiskData.get("TOTAL_RISKRATINGREASON").toString());
				preparedStatement.setString(49, totalRiskData.get("TOTAL_INHERENTSYSTEMRISKRATING").toString());
				preparedStatement.setString(50, totalRiskData.get("TOTAL_INHERENTPROVRISKRATING").toString());
				preparedStatement.setString(51, totalRiskData.get("TOTAL_INHERENTFINALRISKRATING").toString());
				
				int isInserted = preparedStatement.executeUpdate();
				//System.out.println("isInserted in general = "+isInserted);
				
				if(isInserted > 0) {
					customerStatus = saveCMCustomerQuestionsData(COMPASSREFNO, status, customerData, statusData.get("STATUS_CMOFFICERCODE").toString());
					//if(customerStatus) {
						geographyStatus = saveCMGeographyQuestionsData(COMPASSREFNO, status, geographyData, statusData.get("STATUS_CMOFFICERCODE").toString());
						//if(geographyStatus) {
							productsStatus = saveCMProductServicesQuestionsData(COMPASSREFNO, status, productsServicesData, statusData.get("STATUS_CMOFFICERCODE").toString());
							//if(productsStatus) {
								transactionsStatus = saveCMTransactionQuestionsData(COMPASSREFNO, status, transactionsData, statusData.get("STATUS_CMOFFICERCODE").toString());
								//if(transactionsStatus) {
									deliveryStatus = saveCMDeliveryChannelsQuestionsData(COMPASSREFNO, status, deliveryChannelsData, statusData.get("STATUS_CMOFFICERCODE").toString());
									//if(deliveryStatus) {
										controlStatus = saveCMControlParametersQuestionsData(COMPASSREFNO, status, controlParametersData, statusData.get("STATUS_CMOFFICERCODE").toString());
									//}
								//}
							//}
						//}
					//}
					saveCMAuditLog(COMPASSREFNO, status, statusData);
				}
					
				result = "Risk Assessment form successfully saved as draft.";

			}else if(status.equals("CMM-P") && ! COMPASSREFNO.isEmpty() && isFormExistsWithCREFNUM) {					//Saving with Compass Ref No
				sql = "UPDATE TB_CMGENRLFINALRISKDETAILS "+
						  "   SET ASSESSMENTUNIT = ?, ASSESSMENTPERIOD = ?, POCNAME = ?, POCEMAIL = ?, "+
						  "       COMPLIANCE1 = ?, BUSINESS1 = ?, OTHER1 = ?, COMPLIANCE2 = ?, BUSINESS2 = ?, OTHER2 = ?, "+
						  "		  KEYBUSINESSNAME1 = ?, KEYBUSINESSROLE1 = ?, KEYBUSINESSNAME2 = ?, KEYBUSINESSROLE2 = ?, "+
						  "		  KEYBUSINESSNAME3 = ?, KEYBUSINESSROLE3 = ?, "+
						  "		  CUSTOMERSYSTEMGENRISK = ?, CUSTOMERPROVISRISK = ?, CUSTOMERFINALRISK = ?, CUSTOMERREMARKS = ?, "+
						  "		  GEOGSYSTEMGENRISK = ?, GEOGPROVISRISK = ?, GEOGFINALRISK = ?, GEOGREMARKS = ?, "+
						  "       PRODUCTSSYSTEMGENRISK = ?, PRODUCTSPROVISRISK = ?, PRODUCTSFINALRISK = ?, PRODUCTSREMARKS = ?, "+
						  "       DELIVERYSYSTEMGENRISK = ?, DELIVERYPROVISRISK = ?, DELIVERYFINALRISK = ?, DELIVERYREMARKS = ?, "+
						  "		  TRANSACTIONSSYSTEMGENRISK = ?, TRANSACTIONSPROVISRISK = ?, TRANSACTIONSFINALRISK = ?, TRANSACTIONSREMARKS = ?, "+
						  "       CONTROLSYSTEMGENRISK = ?, CONTROLPROVISRISK = ?, CONTROLFINALRISK = ?, CONTROLREMARKS = ?, "+
						  "       CMOFFICERCODE = ?, CMOFFICERUPDATETIMESTAMP = SYSTIMESTAMP, CMOFFICERCOMMENTS = ?, "+
						  "		  STATUS = ?, LOGTIMESTAMP = SYSTIMESTAMP, RESIDUALSYSTEMGENRISK = ?, RESIDUALPROVRISK = ?, RESIDUALFINALRISK = ?, "+ 
						  "       RESIDUALREMARKS = ?, TOTINHSYSGENRISK = ?, TOTINHPROVISRISK = ?, TOTINHFINALRISK = ? "+
						  " WHERE CREFNUM = ? ";
					
					preparedStatement = connection.prepareStatement(sql);
					preparedStatement.setString(1, generalData.get("GENERAL_ASSESSMENTUNIT").toString());
					preparedStatement.setString(2, generalData.get("GENERAL_ASSESSMENTPERIOD").toString());
					preparedStatement.setString(3, generalData.get("GENERAL_POCNAME").toString());
					preparedStatement.setString(4, generalData.get("GENERAL_POCEMAIL").toString());
					preparedStatement.setString(5, generalData.get("GENERAL_COMPLIANCE1").toString());
					preparedStatement.setString(6, generalData.get("GENERAL_BUSINESS1").toString());
					preparedStatement.setString(7, generalData.get("GENERAL_OTHER1").toString());
					preparedStatement.setString(8, generalData.get("GENERAL_COMPLIANCE2").toString());
					preparedStatement.setString(9, generalData.get("GENERAL_BUSINESS2").toString());
					preparedStatement.setString(10, generalData.get("GENERAL_OTHER2").toString());
					preparedStatement.setString(11, generalData.get("GENERAL_NAME1").toString());
					preparedStatement.setString(12, generalData.get("GENERAL_ROLE1").toString());
					preparedStatement.setString(13, generalData.get("GENERAL_NAME2").toString());
					preparedStatement.setString(14, generalData.get("GENERAL_ROLE2").toString());
					preparedStatement.setString(15, generalData.get("GENERAL_NAME3").toString());
					preparedStatement.setString(16, generalData.get("GENERAL_ROLE3").toString());
					preparedStatement.setString(17, customerData.get("CUSTOMER_SYSTEMRISKRATING").toString());
					preparedStatement.setString(18, customerData.get("CUSTOMER_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(19, customerData.get("CUSTOMER_FINALRISKRATING1").toString().concat(customerData.get("CUSTOMER_FINALRISKRATING2").toString()));
					preparedStatement.setString(20, customerData.get("CUSTOMER_RISKRATINGREASON").toString());
					preparedStatement.setString(21, geographyData.get("GEOGRAPHY_SYSTEMRISKRATING").toString());
					preparedStatement.setString(22, geographyData.get("GEOGRAPHY_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(23, geographyData.get("GEOGRAPHY_FINALRISKRATING1").toString().concat(geographyData.get("GEOGRAPHY_FINALRISKRATING2").toString()));
					preparedStatement.setString(24, geographyData.get("GEOGRAPHY_RISKRATINGREASON").toString());
					preparedStatement.setString(25, productsServicesData.get("PRODUCTSSERVICES_SYSTEMRISKRATING").toString());
					preparedStatement.setString(26, productsServicesData.get("PRODUCTSSERVICES_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(27, productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING1").toString().concat(productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING2").toString()));
					preparedStatement.setString(28, productsServicesData.get("PRODUCTSSERVICES_RISKRATINGREASON").toString());
					preparedStatement.setString(29, deliveryChannelsData.get("DELIVERYCHANNELS_SYSTEMRISKRATING").toString());
					preparedStatement.setString(30, deliveryChannelsData.get("DELIVERYCHANNELS_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(31, deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING1").toString().concat(deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING2").toString()));
					preparedStatement.setString(32, deliveryChannelsData.get("DELIVERYCHANNELS_RISKRATINGREASON").toString());
					preparedStatement.setString(33, transactionsData.get("TRANSACTIONS_SYSTEMRISKRATING").toString());
					preparedStatement.setString(34, transactionsData.get("TRANSACTIONS_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(35, transactionsData.get("TRANSACTIONS_FINALRISKRATING1").toString().concat(transactionsData.get("TRANSACTIONS_FINALRISKRATING2").toString()));
					preparedStatement.setString(36, transactionsData.get("TRANSACTIONS_RISKRATINGREASON").toString());
					preparedStatement.setString(37, controlParametersData.get("CONTROLPARAMETERS_SYSTEMRISKRATING").toString());
					preparedStatement.setString(38, controlParametersData.get("CONTROLPARAMETERS_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(39, controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING1").toString().concat(controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING2").toString()));
					preparedStatement.setString(40, controlParametersData.get("CONTROLPARAMETERS_RISKRATINGREASON").toString());
					preparedStatement.setString(41, statusData.get("STATUS_CMOFFICERCODE").toString());
					//preparedStatement.setString(42, statusData.get("STATUS_CMOFFICERTIMESTAMP").toString());
					preparedStatement.setString(42, statusData.get("STATUS_CMOFFICERCOMMENTS").toString());
					preparedStatement.setString(43, status);
					preparedStatement.setString(44, totalRiskData.get("TOTAL_SYSTEMRISKRATING").toString());
					preparedStatement.setString(45, totalRiskData.get("TOTAL_PROVISIONALRISKRATING").toString());
					preparedStatement.setString(46, totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING1").toString().concat(totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING2").toString()));
					preparedStatement.setString(47, totalRiskData.get("TOTAL_RISKRATINGREASON").toString());
					preparedStatement.setString(48, totalRiskData.get("TOTAL_INHERENTSYSTEMRISKRATING").toString());
					preparedStatement.setString(49, totalRiskData.get("TOTAL_INHERENTPROVRISKRATING").toString());
					preparedStatement.setString(50, totalRiskData.get("TOTAL_INHERENTFINALRISKRATING").toString());
										
					preparedStatement.setString(51, COMPASSREFNO);
										
					int isUpdated = preparedStatement.executeUpdate();
					//System.out.println(isUpdated);
					
					if(isUpdated > 0) {
						customerStatus = saveCMCustomerQuestionsData(COMPASSREFNO, status, customerData, statusData.get("STATUS_CMOFFICERCODE").toString());
						//if(customerStatus) {
							geographyStatus = saveCMGeographyQuestionsData(COMPASSREFNO, status, geographyData, statusData.get("STATUS_CMOFFICERCODE").toString());
							//if(geographyStatus) {
								productsStatus = saveCMProductServicesQuestionsData(COMPASSREFNO, status, productsServicesData, statusData.get("STATUS_CMOFFICERCODE").toString());
								//if(productsStatus) {
									transactionsStatus = saveCMTransactionQuestionsData(COMPASSREFNO, status, transactionsData, statusData.get("STATUS_CMOFFICERCODE").toString());
									//if(transactionsStatus) {
										deliveryStatus = saveCMDeliveryChannelsQuestionsData(COMPASSREFNO, status, deliveryChannelsData, statusData.get("STATUS_CMOFFICERCODE").toString());
										//if(deliveryStatus) {
											controlStatus = saveCMControlParametersQuestionsData(COMPASSREFNO, status, controlParametersData, statusData.get("STATUS_CMOFFICERCODE").toString());
										//}
									//}
								//}
							//}
						//}
						saveCMAuditLog(COMPASSREFNO, status, statusData);
					}
					
					result = "Risk Assessment form successfully saved.";

			//}else if(status.equals("CMM-P") && COMPASSREFNO.isEmpty()) {				//Saving without Compass Ref No
			}else if(status.equals("CMM-P")) {
				//COMPASSREFNO = generateCompassRefNo();
				
				sql = "INSERT INTO TB_CMGENRLFINALRISKDETAILS ( "+
					  "		  ASSESSMENTUNIT, ASSESSMENTPERIOD, POCNAME, POCEMAIL, " + 
					  "		  COMPLIANCE1, BUSINESS1, OTHER1, COMPLIANCE2, BUSINESS2, OTHER2, " + 
					  "       KEYBUSINESSNAME1, KEYBUSINESSROLE1, KEYBUSINESSNAME2, KEYBUSINESSROLE2, " + 
					  "		  KEYBUSINESSNAME3, KEYBUSINESSROLE3, " + 
					  "	      CUSTOMERSYSTEMGENRISK, CUSTOMERPROVISRISK, CUSTOMERFINALRISK, CUSTOMERREMARKS, " + 
					  "	  	  GEOGSYSTEMGENRISK, GEOGPROVISRISK, GEOGFINALRISK, GEOGREMARKS, " + 
					  "	  	  PRODUCTSSYSTEMGENRISK, PRODUCTSPROVISRISK, PRODUCTSFINALRISK, PRODUCTSREMARKS, " + 
					  "	  	  DELIVERYSYSTEMGENRISK, DELIVERYPROVISRISK, DELIVERYFINALRISK, DELIVERYREMARKS, " + 
					  "	  	  TRANSACTIONSSYSTEMGENRISK, TRANSACTIONSPROVISRISK, TRANSACTIONSFINALRISK, TRANSACTIONSREMARKS, " + 
					  "	  	  CONTROLSYSTEMGENRISK, CONTROLPROVISRISK, CONTROLFINALRISK, CONTROLREMARKS, " + 
					  "	  	  CMOFFICERCODE, CMOFFICERUPDATETIMESTAMP, CMOFFICERCOMMENTS, " + 
					  "	  	  STATUS, CREFNUM, LOGTIMESTAMP, RESIDUALSYSTEMGENRISK, RESIDUALPROVRISK, RESIDUALFINALRISK, RESIDUALREMARKS, " + 
					  "		  TOTINHSYSGENRISK, TOTINHPROVISRISK, TOTINHFINALRISK )"+
					  "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
					  "       ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
					  "		  ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, "+
					  "		  ?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?, ?, "+
					  "		  ?, SYSTIMESTAMP, ?, ?, ?, ?, ?, ?, ?)";
				System.out.println(customerData.get("CUSTOMER_FINALRISKRATING1").toString().concat(customerData.get("CUSTOMER_FINALRISKRATING2").toString()));
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, generalData.get("GENERAL_ASSESSMENTUNIT").toString());
				preparedStatement.setString(2, generalData.get("GENERAL_ASSESSMENTPERIOD").toString());
				preparedStatement.setString(3, generalData.get("GENERAL_POCNAME").toString());
				preparedStatement.setString(4, generalData.get("GENERAL_POCEMAIL").toString());
				preparedStatement.setString(5, generalData.get("GENERAL_COMPLIANCE1").toString());
				preparedStatement.setString(6, generalData.get("GENERAL_BUSINESS1").toString());
				preparedStatement.setString(7, generalData.get("GENERAL_OTHER1").toString());
				preparedStatement.setString(8, generalData.get("GENERAL_COMPLIANCE2").toString());
				preparedStatement.setString(9, generalData.get("GENERAL_BUSINESS2").toString());
				preparedStatement.setString(10, generalData.get("GENERAL_OTHER2").toString());
				preparedStatement.setString(11, generalData.get("GENERAL_NAME1").toString());
				preparedStatement.setString(12, generalData.get("GENERAL_ROLE1").toString());
				preparedStatement.setString(13, generalData.get("GENERAL_NAME2").toString());
				preparedStatement.setString(14, generalData.get("GENERAL_ROLE2").toString());
				preparedStatement.setString(15, generalData.get("GENERAL_NAME3").toString());
				preparedStatement.setString(16, generalData.get("GENERAL_ROLE3").toString());
				preparedStatement.setString(17, customerData.get("CUSTOMER_SYSTEMRISKRATING").toString());
				preparedStatement.setString(18, customerData.get("CUSTOMER_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(19, customerData.get("CUSTOMER_FINALRISKRATING1").toString().concat(customerData.get("CUSTOMER_FINALRISKRATING2").toString()));
				preparedStatement.setString(20, customerData.get("CUSTOMER_RISKRATINGREASON").toString());
				preparedStatement.setString(21, geographyData.get("GEOGRAPHY_SYSTEMRISKRATING").toString());
				preparedStatement.setString(22, geographyData.get("GEOGRAPHY_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(23, geographyData.get("GEOGRAPHY_FINALRISKRATING1").toString().concat(geographyData.get("GEOGRAPHY_FINALRISKRATING2").toString()));
				preparedStatement.setString(24, geographyData.get("GEOGRAPHY_RISKRATINGREASON").toString());
				preparedStatement.setString(25, productsServicesData.get("PRODUCTSSERVICES_SYSTEMRISKRATING").toString());
				preparedStatement.setString(26, productsServicesData.get("PRODUCTSSERVICES_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(27, productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING1").toString().concat(productsServicesData.get("PRODUCTSSERVICES_FINALRISKRATING2").toString()));
				preparedStatement.setString(28, productsServicesData.get("PRODUCTSSERVICES_RISKRATINGREASON").toString());
				preparedStatement.setString(29, deliveryChannelsData.get("DELIVERYCHANNELS_SYSTEMRISKRATING").toString());
				preparedStatement.setString(30, deliveryChannelsData.get("DELIVERYCHANNELS_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(31, deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING1").toString().concat(deliveryChannelsData.get("DELIVERYCHANNELS_FINALRISKRATING2").toString()));
				preparedStatement.setString(32, deliveryChannelsData.get("DELIVERYCHANNELS_RISKRATINGREASON").toString());
				preparedStatement.setString(33, transactionsData.get("TRANSACTIONS_SYSTEMRISKRATING").toString());
				preparedStatement.setString(34, transactionsData.get("TRANSACTIONS_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(35, transactionsData.get("TRANSACTIONS_FINALRISKRATING1").toString().concat(transactionsData.get("TRANSACTIONS_FINALRISKRATING2").toString()));
				preparedStatement.setString(36, transactionsData.get("TRANSACTIONS_RISKRATINGREASON").toString());
				preparedStatement.setString(37, controlParametersData.get("CONTROLPARAMETERS_SYSTEMRISKRATING").toString());
				preparedStatement.setString(38, controlParametersData.get("CONTROLPARAMETERS_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(39, controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING1").toString().concat(controlParametersData.get("CONTROLPARAMETERS_FINALRISKRATING2").toString()));
				preparedStatement.setString(40, controlParametersData.get("CONTROLPARAMETERS_RISKRATINGREASON").toString());
				preparedStatement.setString(41, statusData.get("STATUS_CMOFFICERCODE").toString());
				preparedStatement.setString(42, statusData.get("STATUS_CMOFFICERCOMMENTS").toString());
				preparedStatement.setString(43, status);
				preparedStatement.setString(44, COMPASSREFNO);
				preparedStatement.setString(45, totalRiskData.get("TOTAL_SYSTEMRISKRATING").toString());
				preparedStatement.setString(46, totalRiskData.get("TOTAL_PROVISIONALRISKRATING").toString());
				preparedStatement.setString(47, totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING1").toString().concat(totalRiskData.get("TOTAL_RESIDUALFINALRISKRATING2").toString()));
				preparedStatement.setString(48, totalRiskData.get("TOTAL_RISKRATINGREASON").toString());
				preparedStatement.setString(49, totalRiskData.get("TOTAL_INHERENTSYSTEMRISKRATING").toString());
				preparedStatement.setString(50, totalRiskData.get("TOTAL_INHERENTPROVRISKRATING").toString());
				preparedStatement.setString(51, totalRiskData.get("TOTAL_INHERENTFINALRISKRATING").toString());
				
				int isInserted = preparedStatement.executeUpdate();
				//System.out.println("isInserted in general = "+isInserted);
				
				if(isInserted > 0) {
					customerStatus = saveCMCustomerQuestionsData(COMPASSREFNO, status, customerData, statusData.get("STATUS_CMOFFICERCODE").toString());
					//if(customerStatus) {
						geographyStatus = saveCMGeographyQuestionsData(COMPASSREFNO, status, geographyData, statusData.get("STATUS_CMOFFICERCODE").toString());
						//if(geographyStatus) {
							productsStatus = saveCMProductServicesQuestionsData(COMPASSREFNO, status, productsServicesData, statusData.get("STATUS_CMOFFICERCODE").toString());
							//if(productsStatus) {
								transactionsStatus = saveCMTransactionQuestionsData(COMPASSREFNO, status, transactionsData, statusData.get("STATUS_CMOFFICERCODE").toString());
								//if(transactionsStatus) {
									deliveryStatus = saveCMDeliveryChannelsQuestionsData(COMPASSREFNO, status, deliveryChannelsData, statusData.get("STATUS_CMOFFICERCODE").toString());
									//if(deliveryStatus) {
										controlStatus = saveCMControlParametersQuestionsData(COMPASSREFNO, status, controlParametersData, statusData.get("STATUS_CMOFFICERCODE").toString());
									//}
								//}
							//}
						//}
					//}
					saveCMAuditLog(COMPASSREFNO, status, statusData);
				}
				
				result = "Risk Assessment form successfully saved.";

			}else if(status.equals("CMM-A")) {      ////Approve
				sql = "UPDATE TB_CMGENRLFINALRISKDETAILS "+
						  "   SET CMMANAGERCODE = ?, CMMNGERUPDATETIMESTAMP = SYSTIMESTAMP, CMMANAGERCOMMENTS = ?, "+
						  "		  STATUS = ?, LOGTIMESTAMP = SYSTIMESTAMP "+
						  " WHERE CREFNUM = ? ";
					
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, statusData.get("STATUS_CMMANAGERCODE").toString());
				preparedStatement.setString(2, statusData.get("STATUS_CMMANAGERCOMMENTS").toString());
				preparedStatement.setString(3, status);
				preparedStatement.setString(4, COMPASSREFNO);	
				int isUpdated = preparedStatement.executeUpdate();
				//System.out.println("APPROVED = "+isUpdated);
				result = isUpdated == 1 ? "Risk Assessment approved" : "Error while approving Risk Assessment";
				
			}else if(status.equals("CMM-R")) {		////Reject
				sql = "UPDATE TB_CMGENRLFINALRISKDETAILS "+
						  "   SET CMMANAGERCODE = ?, CMMNGERUPDATETIMESTAMP = SYSTIMESTAMP, CMMANAGERCOMMENTS = ?, "+
						  "		  STATUS = ?, LOGTIMESTAMP = SYSTIMESTAMP "+
						  " WHERE CREFNUM = ? ";
					
				preparedStatement = connection.prepareStatement(sql);
				preparedStatement.setString(1, statusData.get("STATUS_CMMANAGERCODE").toString());
				preparedStatement.setString(2, statusData.get("STATUS_CMMANAGERCOMMENTS").toString());
				preparedStatement.setString(3, status);
				preparedStatement.setString(4, COMPASSREFNO);	
				int isUpdated = preparedStatement.executeUpdate();
				//System.out.println("REJECTED = "+isUpdated);
				result = isUpdated == 1 ? "Risk Assessment rejected" : "Error while rejecting Risk Assessment";
			}else {
				result = "Error while saving";
			}
		}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		System.out.println("result = "+result);
		return result; 
	}
	
	public String generateCompassRefNo() {
		String COMPASSREFNO = "";
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("ddMMyyyy");
		String strDate= formatter.format(date);
		Random random = new Random();
		
		COMPASSREFNO = "CM"+strDate+random.nextInt(10000);
		return COMPASSREFNO;
	}
	
	private String saveCMAuditLog(String COMPASSREFNO, String status, Map<String, Object> statusData) {
		String result = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			sql = "INSERT INTO COMAML_CM.TB_CMFORMAUDITLOG( "+
				  "       SEQNO, CREFNUM, STATUS, CMOFFICERCODE, CMOFFICERUPDATETIMESTAMP, "+
				  "       CMOFFICERCOMMENTS, CMMANAGERCODE, CMMANAGERUPDATETIMESTAMP, "+
				  "       CMMANAGERCOMMENTS, LOGTIMESTAMP) "+
				  "VALUES (SEQ_CM_AUDITLOG.NEXTVAL, ?, ?, ?, ";
			if(status.equalsIgnoreCase("CMO-P") || status.equalsIgnoreCase("CMM-P")) {	  
				sql = sql + "SYSTIMESTAMP, ?, ?, FUN_CHARTODATE(?), ?, SYSTIMESTAMP)";
			}else {
				sql = sql + "FUN_CHARTODATE(?), ?, ?, SYSTIMESTAMP, ?, SYSTIMESTAMP)";
			}
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			preparedStatement.setString(2, status);
			if(status.equalsIgnoreCase("CMO-P") || status.equalsIgnoreCase("CMM-P")) {
				preparedStatement.setString(3, statusData.get("STATUS_CMOFFICERCODE").toString());
				preparedStatement.setString(4, statusData.get("STATUS_CMOFFICERCOMMENTS").toString());
				preparedStatement.setString(5, "");
				preparedStatement.setString(6, "");
				preparedStatement.setString(7, "");
			}else {
				preparedStatement.setString(3, "");
				preparedStatement.setString(4, "");
				preparedStatement.setString(5, "");
				preparedStatement.setString(6, statusData.get("STATUS_CMMANAGERCODE").toString());
				preparedStatement.setString(7, statusData.get("STATUS_CMMANAGERCOMMENTS").toString());
			}
			preparedStatement.executeUpdate();
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	private boolean saveCMCustomerQuestionsData(String COMPASSREFNO, String status, Map<String, Object> customerData, String userCode) {
		boolean result = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet = null;
		String sql = "";
		int logInserted = 0;
		int entryDeleted = 0;
		int count = 0;
		Map<String, Object> remarksMap = new LinkedHashMap<String, Object>();
		
		try{
			customerData.remove("CUSTOMER_SYSTEMRISKRATING");
			customerData.remove("CUSTOMER_PROVISIONALRISKRATING");
			customerData.remove("CUSTOMER_FINALRISKRATING1");
			customerData.remove("CUSTOMER_FINALRISKRATING2");
			customerData.remove("CUSTOMER_RISKRATINGREASON");
						
			//To avoid concurrent modification exception
			Set<Entry<String, Object>> entrySet = customerData.entrySet();
	        // Collection Iterator
	        Iterator<Entry<String, Object>> itr = entrySet.iterator();
	 
	        // iterate and remove items simultaneously
	        while(itr.hasNext()) {
	            Entry<String, Object> entry1 = itr.next();
	            String key = entry1.getKey();
	            String value = entry1.getValue().toString();
	            if(key.contains("REMARKS")){
					remarksMap.put(key, value);
				}
	        }
						
			sql = "SELECT COUNT(*) FROM TB_CMCUSTOMERQUESTIONDETAILS "+ 
				  " WHERE CREFNUM = ?";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				count = resultSet.getInt(1);
			}
		 
			if(count != 0) {
				sql = "INSERT INTO COMAML_CM.TB_CMCUSTQUESTIONDETAILS_LOG( "+
					  "       SEQNO, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "		  LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, LOGTIMESTAMP) "+
					  "SELECT SEQ_CM_CUSTQUESTIONLOG.NEXTVAL, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, "+
					  "       IMPACTRISKRATING, LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, SYSTIMESTAMP "+
					  "  FROM TB_CMCUSTOMERQUESTIONDETAILS "+
					  " WHERE CREFNUM = ?";
				
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, COMPASSREFNO);
				logInserted = preparedStatement1.executeUpdate();
				
				if(logInserted > 0) {
					sql = "DELETE FROM COMAML_CM.TB_CMCUSTOMERQUESTIONDETAILS WHERE CREFNUM = ? ";
					preparedStatement1 = connection.prepareStatement(sql);
					preparedStatement1.setString(1, COMPASSREFNO);
					entryDeleted = preparedStatement1.executeUpdate();
				}
			
				if(entryDeleted > 0) {
					for (Map.Entry<String,Object> entry : customerData.entrySet()) {
						if(!entry.getKey().contains("REMARKS")){
							sql = "INSERT INTO COMAML_CM.TB_CMCUSTOMERQUESTIONDETAILS "+
								  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP,?)";
							String[] questionVersion = entry.getKey().substring(16).split("\\.");
							String questionId = questionVersion[0];
							String versionNo = questionVersion[1];
							String questionValue = "";
							String impactRiskRating = "";
							String likelihoodRiskRating = "";
							String remarks = "";
							
							if(!entry.getValue().toString().isEmpty()) {
								String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
						    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
								questionValue = valuesArr[1];
								impactRiskRating = riskRatingArr[0];
								likelihoodRiskRating = riskRatingArr[1];
								for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
									String[] questionVersion1 = entry1.getKey().substring(17).split("\\.");
									if((questionId).equals(questionVersion1[0])){
										remarks = entry1.getValue().toString();
									}
								}
							}
							
							preparedStatement1 = connection.prepareStatement(sql);
							preparedStatement1.setString(1, COMPASSREFNO);
							preparedStatement1.setString(2, questionId);
							preparedStatement1.setString(3, questionValue);
							preparedStatement1.setString(4, impactRiskRating);
							preparedStatement1.setString(5, likelihoodRiskRating);
							preparedStatement1.setString(6, remarks);
							preparedStatement1.setString(7, userCode);
							preparedStatement1.setString(8, versionNo);
							
							preparedStatement1.executeUpdate();
							result = true;
						}
					}
				}
			}else {				
				for (Map.Entry<String,Object> entry : customerData.entrySet()) {
					if(!entry.getKey().contains("REMARKS")){
						sql = "INSERT INTO COMAML_CM.TB_CMCUSTOMERQUESTIONDETAILS "+
							  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
						String[] questionVersion = entry.getKey().substring(16).split("\\.");
						String questionId = questionVersion[0];
						String versionNo = questionVersion[1];
						String questionValue = "";
						String impactRiskRating = "";
						String likelihoodRiskRating = "";
						String remarks = "";

						if(!entry.getValue().toString().isEmpty()) {	
							String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
							String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
					    	questionValue = valuesArr[1];
							impactRiskRating = riskRatingArr[0];
							likelihoodRiskRating = riskRatingArr[1];
							for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
								if((questionId).equals(entry1.getKey().substring(17))){
									remarks = entry1.getValue().toString();
								}
							}
						}					
						
						preparedStatement1 = connection.prepareStatement(sql);
						preparedStatement1.setString(1, COMPASSREFNO);
						preparedStatement1.setString(2, questionId);
						preparedStatement1.setString(3, questionValue);
						preparedStatement1.setString(4, impactRiskRating);
						preparedStatement1.setString(5, likelihoodRiskRating);
						preparedStatement1.setString(6, remarks);
						preparedStatement1.setString(7, userCode);
						preparedStatement1.setString(8, versionNo);
						
						preparedStatement1.executeUpdate();
						result = true;
					}
				}
			}
		}catch(Exception e) {
			result = false;
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	private boolean saveCMGeographyQuestionsData(String COMPASSREFNO, String status, Map<String, Object> geographyData, String userCode) {
		boolean result = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet = null;
		String sql = "";
		int logInserted = 0;
		int entryDeleted = 0;
		int count = 0;
		Map<String, Object> remarksMap = new LinkedHashMap<String, Object>();
		
		try{
			geographyData.remove("GEOGRAPHY_SYSTEMRISKRATING");
			geographyData.remove("GEOGRAPHY_PROVISIONALRISKRATING");
			geographyData.remove("GEOGRAPHY_FINALRISKRATING1");
			geographyData.remove("GEOGRAPHY_FINALRISKRATING2");
			geographyData.remove("GEOGRAPHY_RISKRATINGREASON");

			//To avoid concurrent modification exception
			Set<Entry<String, Object>> entrySet = geographyData.entrySet();
	        // Collection Iterator
	        Iterator<Entry<String, Object>> itr = entrySet.iterator();
	 
	        // iterate and remove items simultaneously
	        while(itr.hasNext()) {
	            Entry<String, Object> entry1 = itr.next();
	            String key = entry1.getKey();
	            String value = entry1.getValue().toString();
	            if(key.contains("REMARKS")){
					remarksMap.put(key, value);
				}
	        }
	        
			sql = "SELECT COUNT(*) FROM TB_CMGEOGQUESTIONDETAILS "+ 
				  " WHERE CREFNUM = ?";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				count = resultSet.getInt(1);
			}
			
			if(count != 0) {
				sql = "INSERT INTO COMAML_CM.TB_CMGEOGQUESTIONDETAILS_LOG( "+
					  "       SEQNO, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "		  LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, LOGTIMESTAMP) "+
					  "SELECT SEQ_CM_GEOQUESTIONLOG.NEXTVAL, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "       LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, SYSTIMESTAMP "+
					  "  FROM TB_CMGEOGQUESTIONDETAILS "+ 
					  " WHERE CREFNUM = ?";
					
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, COMPASSREFNO);
				logInserted = preparedStatement1.executeUpdate();
				
				if(logInserted > 0) {
					sql = "DELETE FROM COMAML_CM.TB_CMGEOGQUESTIONDETAILS WHERE CREFNUM = ? ";
					preparedStatement1 = connection.prepareStatement(sql);
					preparedStatement1.setString(1, COMPASSREFNO);
					entryDeleted = preparedStatement1.executeUpdate();
				}
			
				if(entryDeleted > 0) {
					for (Map.Entry<String,Object> entry : geographyData.entrySet()) {
						if(!entry.getKey().contains("REMARKS")){
							sql = "INSERT INTO COMAML_CM.TB_CMGEOGQUESTIONDETAILS "+
								  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
							
							String[] questionVersion = entry.getKey().substring(17).split("\\.");
							String questionId = questionVersion[0];
							String versionNo = questionVersion[1];
							String questionValue = "";
							String impactRiskRating = "";
							String likelihoodRiskRating = "";
							String remarks = "";

							if(!entry.getValue().toString().isEmpty()) {
						    	String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
						    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
								questionValue = valuesArr[1];
								impactRiskRating = riskRatingArr[0];
								likelihoodRiskRating = riskRatingArr[1];
								for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
									String[] questionVersion1 = entry1.getKey().substring(18).split("\\.");
									if((questionId).equals(questionVersion1[0])){
										remarks = entry1.getValue().toString();
									}
								}
							}
							
							preparedStatement1 = connection.prepareStatement(sql);
							preparedStatement1.setString(1, COMPASSREFNO);
							preparedStatement1.setString(2, questionId);
							preparedStatement1.setString(3, questionValue);
							preparedStatement1.setString(4, impactRiskRating);
							preparedStatement1.setString(5, likelihoodRiskRating);
							preparedStatement1.setString(6, remarks);
							preparedStatement1.setString(7, userCode);
							preparedStatement1.setString(8, versionNo);
							
							preparedStatement1.executeUpdate();
							result = true;
						}
					}
				}
			}else {				
				for (Map.Entry<String,Object> entry : geographyData.entrySet()) {
					if(!entry.getKey().contains("REMARKS")){
						sql = "INSERT INTO COMAML_CM.TB_CMGEOGQUESTIONDETAILS "+
							  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
						String[] questionVersion = entry.getKey().substring(17).split("\\.");
						String questionId = questionVersion[0];
						String versionNo = questionVersion[1];
						String questionValue = "";
						String impactRiskRating = "";
						String likelihoodRiskRating = "";
						String remarks = "";

						if(!entry.getValue().toString().isEmpty()) {
							String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
					    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
							questionValue = valuesArr[1];
							impactRiskRating = riskRatingArr[0];
							likelihoodRiskRating = riskRatingArr[1];
							for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
								if((questionId).equals(entry1.getKey().substring(18))){
									remarks = entry1.getValue().toString();
								}
							}
						}					
											
						preparedStatement1 = connection.prepareStatement(sql);
						preparedStatement1.setString(1, COMPASSREFNO);
						preparedStatement1.setString(2, questionId);
						preparedStatement1.setString(3, questionValue);
						preparedStatement1.setString(4, impactRiskRating);
						preparedStatement1.setString(5, likelihoodRiskRating);
						preparedStatement1.setString(6, remarks);
						preparedStatement1.setString(7, userCode);
						preparedStatement1.setString(8, versionNo);
						preparedStatement1.executeUpdate();
						result = true;
					}
				}
			}
		}catch(Exception e) {
			result = false;
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	private boolean saveCMProductServicesQuestionsData(String COMPASSREFNO, String status, Map<String, Object> productsServicesData, String userCode) {
		boolean result = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet = null;
		String sql = "";
		int logInserted = 0;
		int entryDeleted = 0;
		int count = 0;
		Map<String, Object> remarksMap = new LinkedHashMap<String, Object>();
		
		try{
			productsServicesData.remove("PRODUCTSSERVICES_SYSTEMRISKRATING");
			productsServicesData.remove("PRODUCTSSERVICES_PROVISIONALRISKRATING");
			productsServicesData.remove("PRODUCTSSERVICES_FINALRISKRATING1");
			productsServicesData.remove("PRODUCTSSERVICES_FINALRISKRATING2");
			productsServicesData.remove("PRODUCTSSERVICES_RISKRATINGREASON");

			//To avoid concurrent modification exception
			Set<Entry<String, Object>> entrySet = productsServicesData.entrySet();
	        // Collection Iterator
	        Iterator<Entry<String, Object>> itr = entrySet.iterator();
	 
	        // iterate and remove items simultaneously
	        while(itr.hasNext()) {
	            Entry<String, Object> entry1 = itr.next();
	            String key = entry1.getKey();
	            String value = entry1.getValue().toString();
	            if(key.contains("REMARKS")){
					remarksMap.put(key, value);
				}
	        }
	        
			sql = "SELECT COUNT(*) FROM COMAML_CM.TB_CMPRODUCTQUESTIONDETAILS "+ 
				  " WHERE CREFNUM = ?";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				count = resultSet.getInt(1);
			}
			
			if(count != 0) {
				sql = "INSERT INTO COMAML_CM.TB_CMPRODQUESTIONDETAILS_LOG( "+
					  "       SEQNO, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "		  LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, LOGTIMESTAMP) "+
					  "SELECT SEQ_CM_PRODUCTQUESTIONLOG.NEXTVAL, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "       LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, SYSTIMESTAMP "+
					  "  FROM TB_CMPRODUCTQUESTIONDETAILS "+ 
					  " WHERE CREFNUM = ?";
				
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, COMPASSREFNO);
				logInserted = preparedStatement1.executeUpdate();
				
				if(logInserted > 0) {
					sql = "DELETE FROM COMAML_CM.TB_CMPRODUCTQUESTIONDETAILS WHERE CREFNUM = ? ";
					preparedStatement1 = connection.prepareStatement(sql);
					preparedStatement1.setString(1, COMPASSREFNO);
					entryDeleted = preparedStatement1.executeUpdate();
				}
			
				if(entryDeleted > 0) {
					for (Map.Entry<String,Object> entry : productsServicesData.entrySet()) {
						if(!entry.getKey().contains("REMARKS")){
							sql = "INSERT INTO COMAML_CM.TB_CMPRODUCTQUESTIONDETAILS "+
								  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
							
							String[] questionVersion = entry.getKey().substring(24).split("\\.");
							String questionId = questionVersion[0];
							String versionNo = questionVersion[1];
							String questionValue = "";
							String impactRiskRating = "";
							String likelihoodRiskRating = "";
							String remarks = "";
							
							if(!entry.getValue().toString().isEmpty()) {
						    	String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
						    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
								questionValue = valuesArr[1];
								impactRiskRating = riskRatingArr[0];
								likelihoodRiskRating = riskRatingArr[1];
								for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
									String[] questionVersion1 = entry1.getKey().substring(25).split("\\.");
									if((questionId).equals(questionVersion1[0])){
										remarks = entry1.getValue().toString();
									}
								}
							}
							
							preparedStatement1 = connection.prepareStatement(sql);
							preparedStatement1.setString(1, COMPASSREFNO);
							preparedStatement1.setString(2, questionId);
							preparedStatement1.setString(3, questionValue);
							preparedStatement1.setString(4, impactRiskRating);
							preparedStatement1.setString(5, likelihoodRiskRating);
							preparedStatement1.setString(6, remarks);
							preparedStatement1.setString(7, userCode);
							preparedStatement1.setString(8, versionNo);
							
							preparedStatement1.executeUpdate();
							result = true;
						}
					}
				}
			}else {			
				for (Map.Entry<String,Object> entry : productsServicesData.entrySet()) {
					if(!entry.getKey().contains("REMARKS")){
						sql = "INSERT INTO COMAML_CM.TB_CMPRODUCTQUESTIONDETAILS "+
							  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
						String[] questionVersion = entry.getKey().substring(24).split("\\.");
						String questionId = questionVersion[0];
						String versionNo = questionVersion[1];
						String questionValue = "";
						String impactRiskRating = "";
						String likelihoodRiskRating = "";
						String remarks = "";

						if(!entry.getValue().toString().isEmpty()) {
							String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
					    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
							questionValue = valuesArr[1];
							impactRiskRating = riskRatingArr[0];
							likelihoodRiskRating = riskRatingArr[1];
							for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
								if((questionId).equals(entry1.getKey().substring(25))){
									remarks = entry1.getValue().toString();
								}
							}
						}					
											
						preparedStatement1 = connection.prepareStatement(sql);
						preparedStatement1.setString(1, COMPASSREFNO);
						preparedStatement1.setString(2, questionId);
						preparedStatement1.setString(3, questionValue);
						preparedStatement1.setString(4, impactRiskRating);
						preparedStatement1.setString(5, likelihoodRiskRating);
						preparedStatement1.setString(6, remarks);
						preparedStatement1.setString(7, userCode);
						preparedStatement1.setString(8, versionNo);
						
						preparedStatement1.executeUpdate();
						result = true;
					}
				}
			}
		}catch(Exception e) {
			result = false;
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	private boolean saveCMTransactionQuestionsData(String COMPASSREFNO, String status, Map<String, Object> transactionsData, String userCode) {
		boolean result = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet = null;
		String sql = "";
		int logInserted = 0;
		int entryDeleted = 0;
		int count = 0;
		Map<String, Object> remarksMap = new LinkedHashMap<String, Object>();
		
		try{
			transactionsData.remove("TRANSACTIONS_SYSTEMRISKRATING");
			transactionsData.remove("TRANSACTIONS_PROVISIONALRISKRATING");
			transactionsData.remove("TRANSACTIONS_FINALRISKRATING1");
			transactionsData.remove("TRANSACTIONS_FINALRISKRATING2");
			transactionsData.remove("TRANSACTIONS_RISKRATINGREASON");
			
			//To avoid concurrent modification exception
			Set<Entry<String, Object>> entrySet = transactionsData.entrySet();
	        // Collection Iterator
	        Iterator<Entry<String, Object>> itr = entrySet.iterator();
	 
	        // iterate and remove items simultaneously
	        while(itr.hasNext()) {
	            Entry<String, Object> entry1 = itr.next();
	            String key = entry1.getKey();
	            String value = entry1.getValue().toString();
	            if(key.contains("REMARKS")){
					remarksMap.put(key, value);
				}
	        }
	        
			sql = "SELECT COUNT(*) FROM COMAML_CM.TB_CMTRANSQUESTIONDETAILS "+ 
				  " WHERE CREFNUM = ?";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				count = resultSet.getInt(1);
			}
			
			if(count != 0) {
				sql = "INSERT INTO COMAML_CM.TB_CMTRANSQUESTIONDETAILS_LOG( "+
					  "       SEQNO, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "		  LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, LOGTIMESTAMP) "+
					  "SELECT SEQ_CM_TXNQUESTIONLOG.NEXTVAL, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "       LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, SYSTIMESTAMP"+
					  "  FROM TB_CMTRANSQUESTIONDETAILS "+ 
					  " WHERE CREFNUM = ?";
				
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, COMPASSREFNO);
				logInserted = preparedStatement1.executeUpdate();
			
				if(logInserted > 0) {
					sql = "DELETE FROM COMAML_CM.TB_CMTRANSQUESTIONDETAILS WHERE CREFNUM = ? ";
					preparedStatement1 = connection.prepareStatement(sql);
					preparedStatement1.setString(1, COMPASSREFNO);
					entryDeleted = preparedStatement1.executeUpdate();
				}
			
				if(entryDeleted > 0) {
					for (Map.Entry<String,Object> entry : transactionsData.entrySet()) {
						if(!entry.getKey().contains("REMARKS")){
							sql = "INSERT INTO COMAML_CM.TB_CMTRANSQUESTIONDETAILS "+
								  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
							
							String[] questionVersion = entry.getKey().substring(20).split("\\.");
							String questionId = questionVersion[0];
							String versionNo = questionVersion[1];
							String questionValue = "";
							String impactRiskRating = "";
							String likelihoodRiskRating = "";
							String remarks = "";

							if(!entry.getValue().toString().isEmpty()) {
						    	String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
						    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
								questionValue = valuesArr[1];
								impactRiskRating = riskRatingArr[0];
								likelihoodRiskRating = riskRatingArr[1];

								for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
									String[] questionVersion1 = entry1.getKey().substring(21).split("\\.");
									if((questionId).equals(questionVersion1[0])){
										remarks = entry1.getValue().toString();
									}
								}
							}
							
							preparedStatement1 = connection.prepareStatement(sql);
							preparedStatement1.setString(1, COMPASSREFNO);
							preparedStatement1.setString(2, questionId);
							preparedStatement1.setString(3, questionValue);
							preparedStatement1.setString(4, impactRiskRating);
							preparedStatement1.setString(5, likelihoodRiskRating);
							preparedStatement1.setString(6, remarks);
							preparedStatement1.setString(7, userCode);
							preparedStatement1.setString(8, versionNo);
							
							preparedStatement1.executeUpdate();
							result = true;
						}
					}
				}
			}else {
				
				for (Map.Entry<String,Object> entry : transactionsData.entrySet()) {
					if(!entry.getKey().contains("REMARKS")){
						sql = "INSERT INTO COMAML_CM.TB_CMTRANSQUESTIONDETAILS "+
							  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
						String[] questionVersion = entry.getKey().substring(20).split("\\.");
						String questionId = questionVersion[0];
						String versionNo = questionVersion[1];
						String questionValue = "";
						String impactRiskRating = "";
						String likelihoodRiskRating = "";
						String remarks = "";

						if(!entry.getValue().toString().isEmpty()) {
							String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
					    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
							questionValue = valuesArr[1];
							impactRiskRating = riskRatingArr[0];
							likelihoodRiskRating = riskRatingArr[1];
							for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
								if((questionId).equals(entry1.getKey().substring(21))){
									remarks = entry1.getValue().toString();
								}
							}
						}					
											
						preparedStatement1 = connection.prepareStatement(sql);
						preparedStatement1.setString(1, COMPASSREFNO);
						preparedStatement1.setString(2, questionId);
						preparedStatement1.setString(3, questionValue);
						preparedStatement1.setString(4, impactRiskRating);
						preparedStatement1.setString(5, likelihoodRiskRating);
						preparedStatement1.setString(6, remarks);
						preparedStatement1.setString(7, userCode);
						preparedStatement1.setString(8, versionNo);
						
						preparedStatement1.executeUpdate();
						result = true;
					}
				}
			}
		}catch(Exception e) {
			result = false;
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	private boolean saveCMDeliveryChannelsQuestionsData(String COMPASSREFNO, String status, Map<String, Object> deliveryChannelsData, String userCode) {
		boolean result = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet = null;
		String sql = "";
		int logInserted = 0;
		int entryDeleted = 0;
		int count = 0;
		Map<String, Object> remarksMap = new LinkedHashMap<String, Object>();
		
		try{
			deliveryChannelsData.remove("DELIVERYCHANNELS_SYSTEMRISKRATING");
			deliveryChannelsData.remove("DELIVERYCHANNELS_PROVISIONALRISKRATING");
			deliveryChannelsData.remove("DELIVERYCHANNELS_FINALRISKRATING1");
			deliveryChannelsData.remove("DELIVERYCHANNELS_FINALRISKRATING2");
			deliveryChannelsData.remove("DELIVERYCHANNELS_RISKRATINGREASON");
			
			//To avoid concurrent modification exception
			Set<Entry<String, Object>> entrySet = deliveryChannelsData.entrySet();
	        // Collection Iterator
	        Iterator<Entry<String, Object>> itr = entrySet.iterator();
	 
	        // iterate and remove items simultaneously
	        while(itr.hasNext()) {
	            Entry<String, Object> entry1 = itr.next();
	            String key = entry1.getKey();
	            String value = entry1.getValue().toString();
	            if(key.contains("REMARKS")){
					remarksMap.put(key, value);
				}
	        }
	        
			sql = "SELECT COUNT(*) FROM COMAML_CM.TB_CMDELIVERYCHANNELDETAILS "+ 
				  " WHERE CREFNUM = ?";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				count = resultSet.getInt(1);
			}
						
			if(count != 0) {
				sql = "INSERT INTO COMAML_CM.TB_CMDELCHNQUESTIONDETAILS_LOG( "+
					  "       SEQNO, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "		  LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, LOGTIMESTAMP) "+
					  "SELECT SEQ_CM_DELIVERYQUESTIONLOG.NEXTVAL, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, IMPACTRISKRATING, "+
					  "       LIKELIHOODRISKRATING, REMARKS, UPDATEDBY, UPDATETIMESTAMP, SYSTIMESTAMP "+
					  "  FROM TB_CMDELIVERYCHANNELDETAILS "+ 
					  " WHERE CREFNUM = ?";
				
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, COMPASSREFNO);
				logInserted = preparedStatement1.executeUpdate();
				
				if(logInserted > 0) {
					sql = "DELETE FROM COMAML_CM.TB_CMDELIVERYCHANNELDETAILS WHERE CREFNUM = ? ";
					preparedStatement1 = connection.prepareStatement(sql);
					preparedStatement1.setString(1, COMPASSREFNO);
					entryDeleted = preparedStatement1.executeUpdate();
				}
			
				if(entryDeleted > 0) {
					for (Map.Entry<String,Object> entry : deliveryChannelsData.entrySet()) {
						if(!entry.getKey().contains("REMARKS")){
							sql = "INSERT INTO COMAML_CM.TB_CMDELIVERYCHANNELDETAILS "+
								  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";

							String[] questionVersion = entry.getKey().substring(24).split("\\.");
							String questionId = questionVersion[0];
							String versionNo = questionVersion[1];
							String questionValue = "";
							String impactRiskRating = "";
							String likelihoodRiskRating = "";
							String remarks = "";
							
							if(!entry.getValue().toString().isEmpty()) {
						    	String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
						    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
								questionValue = valuesArr[1];
								impactRiskRating = riskRatingArr[0];
								likelihoodRiskRating = riskRatingArr[1];

								for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
									String[] questionVersion1 = entry1.getKey().substring(25).split("\\.");
									if((questionId).equals(questionVersion1[0])){
										remarks = entry1.getValue().toString();
									}
								}
							}
							
							preparedStatement1 = connection.prepareStatement(sql);
							preparedStatement1.setString(1, COMPASSREFNO);
							preparedStatement1.setString(2, questionId);
							preparedStatement1.setString(3, questionValue);
							preparedStatement1.setString(4, impactRiskRating);
							preparedStatement1.setString(5, likelihoodRiskRating);
							preparedStatement1.setString(6, remarks);
							preparedStatement1.setString(7, userCode);
							preparedStatement1.setString(8, versionNo);
							
							preparedStatement1.executeUpdate();
							result = true;
						}
					}
				}
			}else {				
				for (Map.Entry<String,Object> entry : deliveryChannelsData.entrySet()) {
					if(!entry.getKey().contains("REMARKS")){
						sql = "INSERT INTO COMAML_CM.TB_CMDELIVERYCHANNELDETAILS "+
							  "VALUES (?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
						
						String[] questionVersion = entry.getKey().substring(24).split("\\.");
						String questionId = questionVersion[0];
						String versionNo = questionVersion[1];
						String questionValue = "";
						String impactRiskRating = "";
						String likelihoodRiskRating = "";
						String remarks = "";

						if(!entry.getValue().toString().isEmpty()) {
							String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
					    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
							questionValue = valuesArr[1];
							impactRiskRating = riskRatingArr[0];
							likelihoodRiskRating = riskRatingArr[1];
							for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
								if((questionId).equals(entry1.getKey().substring(25))){
									remarks = entry1.getValue().toString();
								}
							}
						}					
											
						preparedStatement1 = connection.prepareStatement(sql);
						preparedStatement1.setString(1, COMPASSREFNO);
						preparedStatement1.setString(2, questionId);
						preparedStatement1.setString(3, questionValue);
						preparedStatement1.setString(4, impactRiskRating);
						preparedStatement1.setString(5, likelihoodRiskRating);
						preparedStatement1.setString(6, remarks);
						preparedStatement1.setString(7, userCode);
						preparedStatement1.setString(8, versionNo);
						
						preparedStatement1.executeUpdate();
						result = true;
					}
				}
			}
		}catch(Exception e) {
			result = false;
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
		}
		return result;
	}
	
	@SuppressWarnings("resource")
	private boolean saveCMControlParametersQuestionsData(String COMPASSREFNO, String status, Map<String, Object> controlParametersData, String userCode) {
		boolean result = false;
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		PreparedStatement preparedStatement1 = null;
		ResultSet resultSet = null;
		String sql = "";
		int logInserted = 0;
		int entryDeleted = 0;
		int count = 0;
		Map<String, Object> remarksMap = new LinkedHashMap<String, Object>();
		
		try{
			controlParametersData.remove("CONTROLPARAMETERS_SYSTEMRISKRATING");
			controlParametersData.remove("CONTROLPARAMETERS_PROVISIONALRISKRATING");
			controlParametersData.remove("CONTROLPARAMETERS_FINALRISKRATING1");
			controlParametersData.remove("CONTROLPARAMETERS_FINALRISKRATING2");
			controlParametersData.remove("CONTROLPARAMETERS_RISKRATINGREASON");
			
			//To avoid concurrent modification exception
			Set<Entry<String, Object>> entrySet = controlParametersData.entrySet();
	        // Collection Iterator
	        Iterator<Entry<String, Object>> itr = entrySet.iterator();
	 
	        // iterate and remove items simultaneously
	        while(itr.hasNext()) {
	            Entry<String, Object> entry1 = itr.next();
	            String key = entry1.getKey();
	            String value = entry1.getValue().toString();
	            if(key.contains("REMARKS")){
					remarksMap.put(key, value);
				}
	        }
	        
			sql = "SELECT COUNT(*) FROM COMAML_CM.TB_CMCONTROLPARAMETERDETAILS "+ 
				  " WHERE CREFNUM = ?";
			
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			resultSet = preparedStatement.executeQuery();
			
			if(resultSet.next()) {
				count = resultSet.getInt(1);
			}
			
			//for update
			if(count != 0) {
				sql = "INSERT INTO COMAML_CM.TB_CMCNTPRMQUESTIONDETAILS_LOG( "+
					  "       SEQNO, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, ASSESSMENTCTRLSCORE, "+
					  "		  REMARKS, UPDATEDBY, UPDATETIMESTAMP, LOGTIMESTAMP) "+
					  "SELECT SEQ_CM_CTRLPARAMQUESTIONLOG.NEXTVAL, CREFNUM, QUESTIONID, VERSION_SEQNO, QUESTIONVALUE, ASSESSMENTCTRLSCORE, "+
					  "       REMARKS, UPDATEDBY, UPDATETIMESTAMP, SYSTIMESTAMP "+
					  "  FROM TB_CMCONTROLPARAMETERDETAILS "+
					  " WHERE CREFNUM = ? ";
				
				preparedStatement1 = connection.prepareStatement(sql);
				preparedStatement1.setString(1, COMPASSREFNO);
				logInserted = preparedStatement1.executeUpdate();
				
				if(logInserted > 0) {
					sql = "DELETE FROM COMAML_CM.TB_CMCONTROLPARAMETERDETAILS WHERE CREFNUM = ? ";
					preparedStatement1 = connection.prepareStatement(sql);
					preparedStatement1.setString(1, COMPASSREFNO);
					entryDeleted = preparedStatement1.executeUpdate();
				}
			
				if(entryDeleted > 0) {
					for (Map.Entry<String,Object> entry : controlParametersData.entrySet()) {
						if(!entry.getKey().contains("REMARKS")){
							sql = "INSERT INTO COMAML_CM.TB_CMCONTROLPARAMETERDETAILS "+
								  "VALUES (?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
							
							String[] questionVersion = entry.getKey().substring(18).split("\\.");
							String questionId = questionVersion[0];
							String versionNo = questionVersion[1];
							String questionValue = "";
							String assessmentCtrlScore = "";
							String remarks = "";

							if(!entry.getValue().toString().isEmpty()) {
								String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
						    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
								questionValue = valuesArr[1];
								assessmentCtrlScore = riskRatingArr[0];

								for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
									String[] questionVersion1 = entry1.getKey().substring(26).split("\\.");
									if((questionId).equals(questionVersion1[0])){
										remarks = entry1.getValue().toString();
									}
								}
							}

							preparedStatement1 = connection.prepareStatement(sql);
							preparedStatement1.setString(1, COMPASSREFNO);
							preparedStatement1.setString(2, questionId);
							preparedStatement1.setString(3, questionValue);
							preparedStatement1.setString(4, assessmentCtrlScore);
							preparedStatement1.setString(5, remarks);
							preparedStatement1.setString(6, userCode);
							preparedStatement1.setString(7, versionNo);
							
							preparedStatement1.executeUpdate();
							result = true;
						}
					}
				}
			}else {
				
				for (Map.Entry<String,Object> entry : controlParametersData.entrySet()) {
					if(!entry.getKey().contains("REMARKS")){
						sql = "INSERT INTO COMAML_CM.TB_CMCONTROLPARAMETERDETAILS "+
							  "VALUES (?, ?, ?, ?, ?, ?, SYSTIMESTAMP, ?)";
						String[] questionVersion = entry.getKey().substring(18).split("\\.");
						String questionId = questionVersion[0];
						String versionNo = questionVersion[1];
						String questionValue = "";
						String assessmentCtrlScore = "";
						String remarks = "";

						if(!entry.getValue().toString().isEmpty()) {
							String valuesArr[] = CommonUtil.splitString(entry.getValue().toString(), "~~");
					    	String riskRatingArr[] = CommonUtil.splitString(valuesArr[0], "~-~");
							questionValue = valuesArr[1];
							assessmentCtrlScore = riskRatingArr[0];
							for (Map.Entry<String,Object> entry1 : remarksMap.entrySet()) {
								if((questionId).equals(entry1.getKey().substring(26))){
									remarks = entry1.getValue().toString();
								}
							}
						}					
											
						preparedStatement1 = connection.prepareStatement(sql);
						preparedStatement1.setString(1, COMPASSREFNO);
						preparedStatement1.setString(2, questionId);
						preparedStatement1.setString(3, questionValue);
						preparedStatement1.setString(4, assessmentCtrlScore);
						preparedStatement1.setString(5, remarks);
						preparedStatement1.setString(6, userCode);
						preparedStatement1.setString(7, versionNo);
						
						preparedStatement1.executeUpdate();
						result = true;
					}
				}
			}
		}catch(Exception e) {
			result = false;
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
			connectionUtil.closeResources(connection, preparedStatement1, resultSet, null);
		}
		return result;
	}
	
	public List<Map<String, String>> getCMAuditLog(String COMPASSREFNO) {
		Connection connection = null;
		List<Map<String, String>> dataList = new LinkedList<Map<String,String>>();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String sql = "";
		try{
			connection = connectionUtil.getConnection();
			sql = "SELECT DECODE(STATUS, 'CMO-P', CMOFFICERCODE, 'CMM-P', CMOFFICERCODE, 'CMM-A', CMMANAGERCODE, 'CMM-R', CMMANAGERCODE) USERCODE, " + 
				  "       DECODE(STATUS, 'CMO-P', 'CM_OFFICER', 'CMM-P', 'CM_OFFICER', 'CMM-A', 'CM_MANAGER', 'CMM-R', 'CM_MANAGER') USERROLE, " + 
				  "       DECODE(STATUS, 'CMO-P', 'Pending with CM Officer', 'CMM-P', 'Pending with CM Manager', 'CMM-A', 'Approved by CM Manager', 'CMM-R', 'Rejected by CM Manager') STATUS,  " + 
				  "       FUN_DATETIMETOCHAR(DECODE(STATUS, 'CMO-P', CMOFFICERUPDATETIMESTAMP, 'CMM-P', CMOFFICERUPDATETIMESTAMP, 'CMM-A', CMMANAGERUPDATETIMESTAMP, 'CMM-R', CMMANAGERUPDATETIMESTAMP)) USERTIMESTAMP, " + 
				  "       DECODE(STATUS, 'CMO-P', CMOFFICERCOMMENTS, 'CMM-P', CMOFFICERCOMMENTS, 'CMM-A', CMMANAGERCOMMENTS, 'CMM-R', CMMANAGERCOMMENTS) COMMENTS " + 
				  "  FROM TB_CMFORMAUDITLOG "+
				  " WHERE CREFNUM = ? "+
				  " ORDER BY LOGTIMESTAMP DESC ";
		
			preparedStatement = connection.prepareStatement(sql);
			preparedStatement.setString(1, COMPASSREFNO);
			resultSet = preparedStatement.executeQuery();
			
			while(resultSet.next()) {
				Map<String, String> dataMap = new LinkedHashMap<String, String>();
				dataMap.put("USERCODE", resultSet.getString("USERCODE"));
				dataMap.put("USERROLE", resultSet.getString("USERROLE"));
				dataMap.put("STATUS", resultSet.getString("STATUS"));
				dataMap.put("USERTIMESTAMP", resultSet.getString("USERTIMESTAMP"));
				dataMap.put("COMMENTS", resultSet.getString("COMMENTS"));
				dataList.add(dataMap);
			}	
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dataList;
	}
	
	public Map<String, Object> generateCMReport(String compassRefNo, String userCode, String userRole, String ipAddress){
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
    	Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETCMREPORTDATA(?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, compassRefNo);
			callableStatement.setString(2, userCode);
			callableStatement.setString(3, userRole);
			callableStatement.setString(4, ipAddress);
            callableStatement.registerOutParameter(5, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(6, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(7, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(8, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(9, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(10, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(11, oracle.jdbc.OracleTypes.CURSOR);
            callableStatement.registerOutParameter(12, oracle.jdbc.OracleTypes.CURSOR);
            
            callableStatement.execute();
	            
            tabNameResultSet = (ResultSet)callableStatement.getObject(5);
            if(tabNameResultSet.next()){
            	arrTabName = CommonUtil.splitString(tabNameResultSet.getString(1), "^~^");
            }
            
            for(int i = 0; i < arrTabName.length; i++){
            	int resultSetInedx = i+6;
            	resultSetMap.put(arrTabName[i], (ResultSet)callableStatement.getObject(resultSetInedx));
            }
            
            Iterator<String> itr = resultSetMap.keySet().iterator();
			while (itr.hasNext()) {
				String sheetName = itr.next();
				ResultSet resultSet = resultSetMap.get(sheetName);
				
				ArrayList<ArrayList<String>> headerList = new ArrayList<ArrayList<String>>();
				ArrayList<ArrayList<String>> resultList = new ArrayList<ArrayList<String>>();
				
		    	ResultSetMetaData resultSetMetaData=resultSet.getMetaData();
		    	ArrayList<String> eachHeader = new ArrayList<String>();
		    	for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    		eachHeader.add(resultSetMetaData.getColumnName(i));
		    	}
		    	headerList.add(eachHeader);
		    	
		    	while(resultSet.next()){
		    		ArrayList<String> eachRecord = new ArrayList<String>();
		    		for(int i = 1; i <= resultSetMetaData.getColumnCount(); i++){
		    			eachRecord.add(resultSet.getString(i));
		    		}
		    		resultList.add(eachRecord);
		    }
		    	
	    	HashMap<String, ArrayList<ArrayList<String>>> innerMap = new LinkedHashMap<String, ArrayList<ArrayList<String>>>();
	    	innerMap.put("listResultHeader", headerList);
	    	innerMap.put("listResultData", resultList);
	    	mainMap.put(sheetName, innerMap);
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
		}
		return mainMap;
	}
	
	@SuppressWarnings("resource")
	public Map<String, Object> saveRaiseToRFI(MakerCheckerDataModel makerCheckerData){
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query="";
		String sql = "";
		String caseNo ="";
		
		
		Map<String, Object> caseDetails = new LinkedHashMap<String, Object>();
		
		
		try{
			for(int x = 0 ; x < makerCheckerData.makerCheckerData.size();x++) {
				
				if(makerCheckerData.makerCheckerData.get(x).editable.equals("")) {
					
					Map<String,Object> caseDetail = new LinkedHashMap<String, Object>();
					
					sql = "SELECT COMAML_CM.SEQ_RISKASSESSMENTCASENO.NEXTVAL FROM DUAL";
					preparedStatement = connection.prepareStatement(sql);
					ResultSet res = preparedStatement.executeQuery();
					while(res.next()) {
						
						caseNo = String.valueOf(res.getInt(1));
					}
					
					caseDetail.put("qId", makerCheckerData.questionId);
					caseDetail.put("caseNo", caseNo);
					caseDetail.put("makerCode", makerCheckerData.makerCheckerData.get(x).makerName);
					caseDetail.put("comments", makerCheckerData.makerCheckerData.get(x).comments);
					caseDetail.put("compassRefNo", makerCheckerData.compassRefNo);
					
					caseDetails.put(makerCheckerData.makerCheckerData.get(x).makerName,caseDetail);
					
					query = "INSERT INTO COMAML_CM.TB_CMQUES_CASEWORKFLOWDETAILS"
							+ "	(CASENO,CASEID,CASESTATUS,RFISTATUS,MAKERDUEDATE,CHECKERDUEDATE,ASSIGNEDMAKERCODE,"
							+ "		ASSIGNEDCHECKERCODES,CURRENT_CASESTATUS,CURRENT_USERCODE,CURRENT_USERROLE,"
							+ "		PREVIOUS_USERCODE,PREVIOUS_USERROLE,UPDATEDTIMESTAMP,COMMENTS,COMPASSREFNO)"
							+ "VALUES(?,?,'0','PE',"
							+ "		fun_chartodate(?),fun_chartodate(?),?,?,'0',?,?,?,?,SYSTIMESTAMP,?,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, caseNo);
					preparedStatement.setString(2, makerCheckerData.questionId);
					preparedStatement.setString(3, makerCheckerData.makerCheckerData.get(x).makerDueDate);
					preparedStatement.setString(4, makerCheckerData.makerCheckerData.get(x).checkerDueDate);
					preparedStatement.setString(5, makerCheckerData.makerCheckerData.get(x).makerName);
					preparedStatement.setString(6, makerCheckerData.makerCheckerData.get(x).checkerJoinNames);
					preparedStatement.setString(7, makerCheckerData.makerCheckerData.get(x).makerName);
					preparedStatement.setString(8, "ROLE_CM_MAKER");
					preparedStatement.setString(9, makerCheckerData.userCode);
					preparedStatement.setString(10, makerCheckerData.userRole);
					preparedStatement.setString(11, makerCheckerData.makerCheckerData.get(x).comments);
					preparedStatement.setString(12, makerCheckerData.compassRefNo);
					
					resultSet = preparedStatement.executeQuery();
					
					query = "	INSERT INTO COMAML_CM.TB_RISKASSESSCWFCOMMENTSLOG(CASENO,"
							+ "		SEQUENCENO,QUESTIONID,USERCODE,USERROLE,IPADDRESS,CASESTATUS,COMMENTS,LASTREVIEWEDDATE,"
							+ "		UPDATETIMESTAMP,COMPASSREFNO)"
							+ " VALUES(?,COMAML_CM.SEQ_RISKASSESSMENTSEQNO.NEXTVAL,?,?,?,?,'0',?,SYSTIMESTAMP,SYSTIMESTAMP,?)";
					
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, caseNo);
					preparedStatement.setString(2, makerCheckerData.questionId);
					preparedStatement.setString(3, makerCheckerData.userCode);
					preparedStatement.setString(4, makerCheckerData.userRole);
					preparedStatement.setString(5, makerCheckerData.ipAddress);
					preparedStatement.setString(6, makerCheckerData.makerCheckerData.get(x).comments);
					preparedStatement.setString(7, makerCheckerData.compassRefNo);
					
					resultSet = preparedStatement.executeQuery();
					
				}
			}
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return caseDetails;
	}
	
	public JSONObject getMakerCheckerList(String qId,String compassRefNo){
		JSONArray makerList = new JSONArray();
		JSONArray checkerList = new JSONArray();
		JSONArray rowDetails = new JSONArray();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query =    "SELECT USERCODE "
							+ "  FROM TB_USERROLEMAPPING "
							+ " WHERE ROLEID='CM_MAKER' ";
			preparedStatement = connection.prepareStatement(query);
			
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				makerList.put(resultSet.getString("USERCODE"));
			}
			query =   "SELECT USERCODE "
					+ "  FROM TB_USERROLEMAPPING "
					+ " WHERE ROLEID='CM_CHECKER' ";
			preparedStatement = connection.prepareStatement(query);
			
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				checkerList.put(resultSet.getString("USERCODE"));
			}
			
			query =   "SELECT ASSIGNEDMAKERCODE,ASSIGNEDCHECKERCODES,COMAML_CM.FUN_DATETOCHAR(MAKERDUEDATE) MAKERDUEDATE,"
					+ "			COMAML_CM.FUN_DATETOCHAR(CHECKERDUEDATE) CHECKERDUEDATE,COMMENTS "
					+ "  FROM COMAML_CM.TB_CMQUES_CASEWORKFLOWDETAILS "
					+ " WHERE CASEID = ? AND COMPASSREFNO = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, qId);
			preparedStatement.setString(2, compassRefNo);
			
			resultSet = preparedStatement.executeQuery();
			try {
				int count = 0;
				while(resultSet.next()) {
					JSONArray jArr = new JSONArray();
					String[] checkerNames = resultSet.getString("ASSIGNEDCHECKERCODES").split(",");
					for(String checker:checkerNames) {
						jArr.put(checker);
					}
					JSONObject jobj = new JSONObject();
					jobj.put("id", count);
					jobj.put("makerDueDate", resultSet.getString("MAKERDUEDATE"));
					jobj.put("checkerDueDate", resultSet.getString("CHECKERDUEDATE"));
					jobj.put("makerName", resultSet.getString("ASSIGNEDMAKERCODE"));
					jobj.put("checkerNames", jArr);
					jobj.put("comments", resultSet.getString("COMMENTS"));
					jobj.put("editable", "disabled");
					
					rowDetails.put(jobj);
					count ++;
				}
			}
			catch(Exception e) {
				System.out.println("no previous maker checker combinations found");
			}
			
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		JSONObject jObj = new JSONObject();
		try {
			jObj.put("makerList", makerList);
			jObj.put("checkerList", checkerList);
			jObj.put("rowDetails", rowDetails);
		}
		catch(Exception e) {
			e.printStackTrace();
			System.out.println("cannot create json string for maker checker list");
		
		}
		return jObj;	
	}
	
	@Override
	public String saveImageUrlData(String imageUrl){
		String id = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String AlphaNumericString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
					                + "0123456789"
					                + "abcdefghijklmnopqrstuvxyz";
					
					// create StringBuffer size of AlphaNumericString
					StringBuilder sb = new StringBuilder(16);
					
					for (int i = 0; i < 16; i++) {
					
					// generate a random number between
					// 0 to AlphaNumericString variable length
					int index
					= (int)(AlphaNumericString.length()
					    * Math.random());
					
					// add Character one by one in end of sb
					sb.append(AlphaNumericString
					      .charAt(index));
					}
		id = sb.toString();

		try{
			String query = "INSERT INTO COMAML_CM.TB_IMAGEDATA VALUES(?,?,SYSTIMESTAMP) ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, id);
			preparedStatement.setString(2, imageUrl);
			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return id;	
	}
	
	@Override
	public String getImageUrlData(String imageId){
		System.out.println("in Here");
		String imageData = "";
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = "SELECT IMAGEDATA FROM COMAML_CM.TB_IMAGEDATA WHERE IMAGEID = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, imageId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				System.out.println(resultSet.getString("IMAGEDATA"));
				imageData = resultSet.getString("IMAGEDATA");
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return imageData;	
	}
	
	
	@Override
	public Map<String, Object> getGraphDataPoints(String cmRefNo){
		Map<String, Object> graphDataPoints = new LinkedHashMap<String,Object>();
		List<String> dataPointLabels = new LinkedList<String>();
		dataPointLabels.add("Customer");
		dataPointLabels.add("Geography");
		dataPointLabels.add("ProductsAndServices");
		dataPointLabels.add("DeliveryChannels");
		dataPointLabels.add("Transactions");
		dataPointLabels.add("ControlParameters");
		dataPointLabels.add("ResidualRiskRating");
		dataPointLabels.add("TotalInherentFinalRisk");
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = "SELECT CUSTOMERFINALRISK, GEOGFINALRISK, PRODUCTSFINALRISK, "
						+ "		   DELIVERYFINALRISK, TRANSACTIONSFINALRISK, CONTROLFINALRISK,"
						+ "        RESIDUALFINALRISK, TOTINHFINALRISK"
						+ "   FROM COMAML_CM.TB_CMGENRLFINALRISKDETAILS"
						+ "  WHERE CREFNUM = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, cmRefNo);
			resultSet = preparedStatement.executeQuery();
			Map<String,String> dataPoints = new LinkedHashMap<String, String>();
			while(resultSet.next()) {
				dataPoints.put("Customer",resultSet.getString("CUSTOMERFINALRISK"));
				dataPoints.put("Geography",resultSet.getString("GEOGFINALRISK"));
				dataPoints.put("ProductsAndServices",resultSet.getString("PRODUCTSFINALRISK"));
				dataPoints.put("DeliveryChannels",resultSet.getString("DELIVERYFINALRISK"));
				dataPoints.put("Transactions",resultSet.getString("TRANSACTIONSFINALRISK"));
				dataPoints.put("ControlParameters",resultSet.getString("CONTROLFINALRISK"));
				dataPoints.put("ResidualRiskRating",resultSet.getString("RESIDUALFINALRISK"));
				try {
					//to handle null values from db
					dataPoints.put("TotalInherentFinalRisk",resultSet.getString("TOTINHFINALRISK").split("- ")[1]);
				}catch(Exception e) {
					dataPoints.put("TotalInherentFinalRisk","0");
				}
				
			}
			graphDataPoints.put("labels",dataPointLabels);
			graphDataPoints.put("dataPoints", dataPoints);
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return graphDataPoints;	
	}
}
