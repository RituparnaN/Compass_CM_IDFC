package com.quantumdataengines.app.compass.dao.riskAssessmentQuestionMaster;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.plivo.helper.api.response.call.Call;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

import oracle.jdbc.OracleTypes;

@Repository
public class RiskAssessmentQuestionMasterDAOImpl implements RiskAssessmentQuestionMasterDAO {

	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Object getQuestionCategory() {
		Map<String,Map<String,List<String>>> assesmentUnitCategory = new LinkedHashMap<String, Map<String,List<String>>>();
		String assesmentUnit = null;
		String assesmentSectionCode = null;
		String assesmentGroup = null; 
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			String query =" SELECT ASSESSMENTUNIT,ASSESSMENTSECTIONCODE,ASSESSMENTSUBGROUP "+
					      "   FROM "+schemaName+"TB_ASSESSMENTUNITMASTER "+
					      "  ORDER BY ASSESSMENTSECTIONCODE ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);	
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				assesmentUnit = resultSet.getString("ASSESSMENTUNIT");
				assesmentSectionCode = resultSet.getString("ASSESSMENTSECTIONCODE");
				assesmentGroup = resultSet.getString("ASSESSMENTSUBGROUP");
				if(assesmentUnitCategory.containsKey(assesmentUnit)) {
					Map<String,List<String>> assesmentSectionCodeCategory = assesmentUnitCategory.get(assesmentUnit);
					if(assesmentSectionCodeCategory.containsKey(assesmentSectionCode)) {
						List<String> assesmentGroupList  = assesmentSectionCodeCategory.get(assesmentSectionCode);
						assesmentGroupList.add(assesmentGroup);
					}else {
						List<String> assesmentGroupList = new LinkedList<String>();
						assesmentGroupList.add(assesmentGroup);
						assesmentSectionCodeCategory.put(assesmentSectionCode, assesmentGroupList);
					}
					
					
				}else {
					Map<String,List<String>> assesmentSectionCodeCategory = new LinkedHashMap<>();
					List<String>assesmentGroupList = new LinkedList<String>();
					assesmentGroupList.add(assesmentGroup);
					assesmentSectionCodeCategory.put(assesmentSectionCode, assesmentGroupList);
					assesmentUnitCategory.put(assesmentUnit, assesmentSectionCodeCategory);
					
				}
			}
			System.out.println("data ="+assesmentUnitCategory);
		}catch(Exception e) {
			System.out.println("error while getting assessment question master = "+e.getMessage());
			e.printStackTrace();
			
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		return assesmentUnitCategory;
	}

	@Override
	public String addRiskAssessmentQuestion(String userCode, String userRole, String ipAddress,
			Map<String, String> questionData) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		
		try{
			String questionId = getNextQuestionSeqNo();
			/*if(!addQuestionOptions(questionId,questionData,userCode)) {
				return "Question Could not be added";
			}*/
						
			String query = "INSERT INTO "+schemaName+"TB_ASSESSMENTQUESTIONMASTER ( "+
				           "       ISENABLED, ASSESSMENTUNIT,ASSESSMENTSECTIONCODE, ASSESSMENTSUBGROUP, "+
				           "	   QUESTIONID, QUESTIONDESCRIPTION, ISFREETEXTAREAREQUIRED, CREATEDBY,"+
					       "       CREATEDTIMESTAMP, MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP,"+
				           "	   STATUS) "+
				           " VALUES(?,?,?,?,?,?,?,?,SYSTIMESTAMP,?,?,SYSTIMESTAMP,?)";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, questionData.get("isEnabled"));
			preparedStatement.setString(2, questionData.get("assessmentUnit"));
			preparedStatement.setString(3, questionData.get("assessmentSectionCode"));
			preparedStatement.setString(4, questionData.get("assessmentSubGroup"));
			preparedStatement.setString(5, questionId);
			preparedStatement.setString(6, questionData.get("question"));
			preparedStatement.setString(7, questionData.get("isFreeTextRequired") == null ? "N":questionData.get("isFreeTextRequired"));
			preparedStatement.setString(8, userCode);
			preparedStatement.setString(9, questionData.get("makerCode"));
			preparedStatement.setString(10, questionData.get("makerComments"));
			preparedStatement.setString(11, "P");
			preparedStatement.execute();
			
			return "Successfully saved.";
		}catch(Exception e) {
			e.printStackTrace();
			return "Question Could not be added, error= "+e.getMessage();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		//return status;
	}
	
	private boolean addQuestionOptions(String questionId,Map<String, String> questionData,String userCode) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(" DELETE FROM "+schemaName+"TB_ASSESMNTQUESTIONNAIREMASTER WHERE QUESTIONID= ?  ");
			preparedStatement.setString(1, questionId);
			int count = preparedStatement.executeUpdate();
			System.out.println("delete QUESTIONNAIRE = "+count+" where q id = "+questionId+"\n"+questionData);
			
			String query = "INSERT INTO "+schemaName+"TB_ASSESMNTQUESTIONNAIREMASTER ( "+
				           "       ASSESSMENTUNIT,QUESTIONID,OPTIONID,OPTIONVALUE,"+
					       "       OPTIONVALUE1,CREATEDBY,CREATEDTIMESTAMP) "+
				           "VALUES (?,?,?,?,?,?,SYSTIMESTAMP)";
			
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);	
			preparedStatement.setString(1, questionData.get("assessmentUnit"));
			preparedStatement.setString(2, questionId);
			preparedStatement.setString(3, questionData.get("option1Id"));
			preparedStatement.setString(4, questionData.get("option1ImpactRiskValue"));
			preparedStatement.setString(5, questionData.get("option1LikelihoodRiskValue"));
			preparedStatement.setString(6, userCode);
			preparedStatement.addBatch();
			
			preparedStatement.setString(1, questionData.get("assessmentUnit"));
			preparedStatement.setString(2, questionId);
			preparedStatement.setString(3, questionData.get("option2Id"));
			preparedStatement.setString(4, questionData.get("option2ImpactRiskValue"));
			preparedStatement.setString(5, questionData.get("option2LikelihoodRiskValue"));
			preparedStatement.setString(6, userCode);
			preparedStatement.addBatch();
			
			preparedStatement.setString(1, questionData.get("assessmentUnit"));
			preparedStatement.setString(2, questionId);
			preparedStatement.setString(3, questionData.get("option3Id"));
			preparedStatement.setString(4, questionData.get("option3ImpactRiskValue"));
			preparedStatement.setString(5, questionData.get("option3LikelihoodRiskValue"));
			preparedStatement.setString(6, userCode);
			preparedStatement.addBatch();
			
			preparedStatement.executeBatch();
			return true;
		}catch(Exception e) {
			e.printStackTrace();
			return false;
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
	}
	
	private String getNextQuestionSeqNo() {
		 try(Connection connection = connectionUtil.getConnection()) {
			 	String sql = "SELECT "+schemaName+"SEQ_RISKASSESSMENTQUESTION.NEXTVAL FROM DUAL";
			 	System.out.println(sql);
	            PreparedStatement preparedStatement = connection.prepareStatement(sql);
	            ResultSet resultSet = preparedStatement.executeQuery();
	            String nextValue = "";
	            while(resultSet.next()) {
	                nextValue = resultSet.getString(1);
	            }
	            return nextValue;
	        }catch (Exception e){
	        	System.out.println("Error while next value of sequence od assessment questions = ");
	            e.printStackTrace();
	            return null;
	        }
		
	}

	@Override
	public Map<String, Object> getQuestionDetails(String questionId, String status, String questionVersion, String userCode, String userRole,String ipAddress) {
		Connection connection = null;
		//PreparedStatement preparedStatement = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet1 = null;
		ResultSet resultSet2 = null;
		Map<String,Object> questionDetails  = new LinkedHashMap<String, Object>();
		try {
			/*Map<String,Object> questionDeatils =  getQuestionNaire(questionId);
			String query = " SELECT ISENABLED, ASSESSMENTUNIT,ASSESSMENTSECTIONCODE,ASSESSMENTSUBGROUP, QUESTIONDESCRIPTION,"+
					       "        ISFREETEXTAREAREQUIRED, CREATEDBY,CREATEDTIMESTAMP,UPDATEDBY, UPDATETIMESTAMP, "+
					       "        STATUS, MAKERCODE, MAKERCOMMENTS, MAKERTIMESTAMP, CHECKERCODE, CHECKERCOMMENTS, CHECKERTIMESTAMP "+
					       "   FROM "+schemaName+"TB_ASSESSMENTQUESTIONMASTER "+
					       "  WHERE QUESTIONID = ?";*/
			connection = connectionUtil.getConnection();
			/*preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1,questionId);
			resultSet = preparedStatement.executeQuery();*/
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETRISKASMNTQUESTNDETAILS(?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, questionId);
			callableStatement.setString(2, status);
			callableStatement.setString(3, questionVersion);
			callableStatement.setString(4, userCode);
			callableStatement.setString(5, userRole);
			callableStatement.setString(6, ipAddress);
			callableStatement.registerOutParameter(7, OracleTypes.CURSOR);
			callableStatement.registerOutParameter(8, OracleTypes.CURSOR);
			callableStatement.execute();
			
			resultSet1 = (ResultSet) callableStatement.getObject(7);
			resultSet2 = (ResultSet) callableStatement.getObject(8);
			
			while(resultSet1.next()) {
				questionDetails.put("ISENABLED", resultSet1.getString("ISENABLED"));
				questionDetails.put("ASSESSMENTUNIT", resultSet1.getString("ASSESSMENTUNIT"));
				questionDetails.put("ASSESSMENTSECTIONCODE", resultSet1.getString("ASSESSMENTSECTIONCODE"));
				questionDetails.put("ASSESSMENTSUBGROUP", resultSet1.getString("ASSESSMENTSUBGROUP"));
				questionDetails.put("QUESTIONDESCRIPTION", resultSet1.getString("QUESTIONDESCRIPTION"));
				questionDetails.put("ISFREETEXTAREAREQUIRED", resultSet1.getString("ISFREETEXTAREAREQUIRED"));
				questionDetails.put("CREATEDBY", resultSet1.getString("CREATEDBY"));
				questionDetails.put("CREATEDTIMESTAMP", resultSet1.getString("CREATEDTIMESTAMP"));
				questionDetails.put("UPDATEDBY", resultSet1.getString("UPDATEDBY"));
				questionDetails.put("UPDATETIMESTAMP", resultSet1.getString("UPDATETIMESTAMP"));
				questionDetails.put("STATUS", resultSet1.getString("STATUS"));
				questionDetails.put("MAKERCODE", resultSet1.getString("MAKERCODE"));
				questionDetails.put("MAKERCOMMENTS", resultSet1.getString("MAKERCOMMENTS"));
				questionDetails.put("MAKERTIMESTAMP", resultSet1.getString("MAKERTIMESTAMP"));
				questionDetails.put("CHECKERCODE", resultSet1.getString("CHECKERCODE"));
				questionDetails.put("CHECKERCOMMENTS", resultSet1.getString("CHECKERCOMMENTS"));
				questionDetails.put("CHECKERTIMESTAMP", resultSet1.getString("CHECKERTIMESTAMP"));
			}
			
			List<String> optionName = new LinkedList<String>();
			List<String> optionValue = new LinkedList<String>();
			List<String> impactRiskRating = new LinkedList<String>();
			List<String> likelihoodRiskRating = new LinkedList<String>();
			
			while(resultSet2.next()) {
				optionName.add( resultSet2.getString("OPTIONNAME"));
				optionValue.add( resultSet2.getString("OPTIONVALUE"));
				impactRiskRating.add(resultSet2.getString("IMPACTRISKRATING"));
				likelihoodRiskRating.add(resultSet2.getString("LIKELIHOODRISKRATING"));
			}
			questionDetails.put("OPTIONNAME", optionName);
			questionDetails.put("OPTIONVALUE", optionValue);
			questionDetails.put("IMPACTRISKRATING", impactRiskRating);
			questionDetails.put("LIKELIHOODRISKRATING", likelihoodRiskRating);
			
			System.out.println(questionDetails);
			return questionDetails;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}finally {
			connectionUtil.closeResources(connection, callableStatement, resultSet1, null);
			connectionUtil.closeResources(connection, callableStatement, resultSet2, null);
		}
	}

	private Map<String, Object> getQuestionNaire(String questionId) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		Map<String,Object>questionNaire = new LinkedHashMap<String,Object>();
		try {
			String query = " SELECT OPTIONNAME,OPTIONVALUE,IMPACTRISKRATING, LIKELIHOODRISKRATING "+
				           "   FROM "+schemaName+"TB_ASSESMNTQUESTIONNAIREMASTER "+
				           "  WHERE QUESTIONID = ?";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1,questionId);
			resultSet = preparedStatement.executeQuery();
			List<String> optionName = new LinkedList<String>();
			List<String> optionValue = new LinkedList<String>();
			List<String> impactRiskRating = new LinkedList<String>();
			List<String> likelihoodRiskRating = new LinkedList<String>();
			
			while(resultSet.next()) {
				optionName.add( resultSet.getString("OPTIONNAME"));
				optionValue.add( resultSet.getString("OPTIONVALUE"));
				impactRiskRating.add(resultSet.getString("IMPACTRISKRATING"));
				likelihoodRiskRating.add(resultSet.getString("LIKELIHOODRISKRATING"));
			}
			questionNaire.put("OPTIONNAME", optionName);
			questionNaire.put("OPTIONVALUE", optionValue);
			questionNaire.put("IMPACTRISKRATING", impactRiskRating);
			questionNaire.put("LIKELIHOODRISKRATING", likelihoodRiskRating);
			
			return questionNaire;
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}

	@SuppressWarnings("resource")
	@Override
	public String updateRiskAssessmentQuestion(String userCode, String userRole, String ipAddress,Map<String, String> questionData) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		System.out.println("question data dao = "+questionData);
		String query = "";
		try{
			/*if(!updateQuestionOptions(questionData.get("questionId"),questionData,userCode)) {
				return "Question Could not be update";
			}*/
			
			query = " DELETE FROM "+schemaName+"TB_ASSESMNTQUESTIONNAIREMASTER "+
			        "  WHERE QUESTIONID = ? ";
		
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);	
			preparedStatement.setString(1, questionData.get("questionId"));
			preparedStatement.execute();
			
			/*if(!addQuestionOptions(questionData.get("questionId"),questionData,userCode)) {
				return "Question Could not be update";
			}*/
			
			query = " UPDATE "+schemaName+"TB_ASSESSMENTQUESTIONMASTER "+
			        "    SET ISENABLED = ?, QUESTIONDESCRIPTION = ? , STATUS = ?, ";
			if(questionData.get("status").equals("P")) {
				query = query+" MAKERCODE = ?, MAKERCOMMENTS = ?, MAKERTIMESTAMP = SYSTIMESTAMP, ";
			}else {
				query = query+" CHECKERCODE = ?, CHECKERCOMMENTS = ?, CHECKERTIMESTAMP = SYSTIMESTAMP, ";
			}
			
			query = query+"		 UPDATEDBY = ?, UPDATETIMESTAMP = SYSTIMESTAMP "+
			        "  WHERE QUESTIONID = ? ";
			// connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, questionData.get("isEnabled"));
			preparedStatement.setString(2, questionData.get("questionDescription"));
			preparedStatement.setString(3, questionData.get("status"));
			if(questionData.get("status").equals("P")) {
				preparedStatement.setString(4, questionData.get("makerCode"));
				preparedStatement.setString(5, questionData.get("makerComments"));
			}else {
				preparedStatement.setString(4, questionData.get("checkerCode"));
				preparedStatement.setString(5, questionData.get("checkerComments"));
			}
			preparedStatement.setString(6, userCode);
			preparedStatement.setString(7, questionData.get("questionId"));
			preparedStatement.execute();
			
			return "Successfully updated";
		}catch(Exception e) {
			e.printStackTrace();
			return "Question Could not be update, error= "+e.getMessage();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}

	@Override
	public String addRiskAssessmentSubGroup(Map<String, String> paramMap, String userCode, String userRole,
			String ipAddress) {
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = " INSERT INTO "+schemaName+"TB_ASSESSMENTUNITMASTER ( "+
					       "        ASSESSMENTUNIT, ASSESSMENTSECTIONCODE, ASSESSMENTSUBGROUP, "+
					       "        WEIGHTAGE, UPDATEDBY, UPDATETIMESTAMP ) "+
					       " VALUES (?, ?, ?, ?, ?, SYSTIMESTAMP) ";
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);	
			preparedStatement.setString(1, paramMap.get("assessmentUnit"));
			preparedStatement.setString(2, paramMap.get("assessmentSectionCode"));
			preparedStatement.setString(3, paramMap.get("assessmentSubGroup"));
			preparedStatement.setString(4, paramMap.get("weightage"));
			preparedStatement.setString(5, userCode);
			preparedStatement.execute();
			
			return "Assessment SUb Group Added";
		}catch(Exception e) {
			e.printStackTrace();
			return "Assessment sub group could not added= "+e.getMessage();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
	}
	
	@Override
	public String saveRiskAssessmentQuestionnaire(Map<String, String> questionData, String userCode, String userRole, String ipAddress) {
		Connection connection = null;
		CallableStatement callableStatement = null;
		ResultSet resultSet = null;
		String result = "";
		System.out.println(Arrays.asList(questionData));
		try {
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_SAVERISKQUESTIONNAIREDATA(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, questionData.get("assessmentUnit"));
			callableStatement.setString(2, questionData.get("assessmentSectionCode"));
			callableStatement.setString(3, questionData.get("assessmentSubGroup"));
			callableStatement.setString(4, questionData.get("isFreeTextRequired"));
			callableStatement.setString(5, questionData.get("isEnabled"));
			callableStatement.setString(6, questionData.get("status"));
			callableStatement.setString(7, questionData.get("questionId") == null ? "" : questionData.get("questionId"));
			callableStatement.setString(8, questionData.get("question"));
			if(questionData.get("assessmentSectionCode").equals("ControlParameters")) {
				callableStatement.setString(9, questionData.get("acOption1Name")+"|~|"+questionData.get("acOption2Name")+"|~|"+questionData.get("acOption3Name"));
			}else {	
				callableStatement.setString(9, questionData.get("option1Name")+"|~|"+questionData.get("option2Name")+"|~|"+questionData.get("option3Name"));
			}
			callableStatement.setString(10, "1|~|2|~|3");
			if(questionData.get("assessmentSectionCode").equals("ControlParameters")) {
				callableStatement.setString(11, questionData.get("option1AssessmentCtrlScore")+"|~|"+questionData.get("option2AssessmentCtrlScore")+"|~|"+questionData.get("option3AssessmentCtrlScore"));
				callableStatement.setString(12, "");
			}else {
				callableStatement.setString(11, questionData.get("option1ImpactRiskValue")+"|~|"+questionData.get("option2ImpactRiskValue")+"|~|"+questionData.get("option3ImpactRiskValue"));
				callableStatement.setString(12, questionData.get("option1LikelihoodRiskValue")+"|~|"+questionData.get("option2LikelihoodRiskValue")+"|~|"+questionData.get("option3LikelihoodRiskValue"));
			}
			
			if(questionData.get("status").equals("P")) {
				callableStatement.setString(13, questionData.get("makerComments"));
				callableStatement.setString(14, questionData.get("makerCode"));
			}else {
				callableStatement.setString(13, questionData.get("checkerComments"));
				callableStatement.setString(14, questionData.get("checkerCode"));
			}
			callableStatement.setString(15, userRole);
			callableStatement.setString(16, ipAddress);
			callableStatement.registerOutParameter(17, OracleTypes.CURSOR);
			
			callableStatement.execute();
			
			resultSet = (ResultSet) callableStatement.getObject(17);
			
			if(resultSet.next()){
				System.out.println(resultSet.getString(1));
				result = resultSet.getString(1);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, callableStatement, resultSet, null);
		}
		return result;
	}
	
	public List<Map<String, String>> getAssessmentWeightageList(String userCode, String userRole){
		List<Map<String,String>> weightageList = new LinkedList<Map<String,String>>();
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try {
			String query =" SELECT DISTINCT CONTROLAREA, WEIGHTAGE FROM TB_ASSESSMENTUNITMASTER "+
						  "	 WHERE UPPER(ASSESSMENTSECTIONCODE) = 'CONTROLPARAMETERS' "+
						  "  GROUP BY CONTROLAREA, WEIGHTAGE " + 
						  "  ORDER BY CONTROLAREA, WEIGHTAGE ";
			
			connection = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);	
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				Map<String,String> weightageMap = new LinkedHashMap<String, String>();
				weightageMap.put(resultSet.getString("CONTROLAREA"), resultSet.getString("WEIGHTAGE"));
					
				weightageList.add(weightageMap);
			}
		}catch(Exception e) {
			System.out.println("Error while getting assessment weightage list = "+e.getMessage());
			e.printStackTrace();
			
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return weightageList;
	}
	
	public String saveWeightage(String fullData, String userCode, String userRole){
		Connection connection = null;
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String result = "";
		try {
			String query =" UPDATE TB_ASSESSMENTUNITMASTER "+
						  "	   SET WEIGHTAGE = ?, UPDATETIMESTAMP = SYSTIMESTAMP, UPDATEDBY = ?  "+
					  	  "	 WHERE UPPER(CONTROLAREA) = ? ";
			connection  = connectionUtil.getConnection();
			preparedStatement = connection.prepareStatement(query);
			String[] arrParameters = CommonUtil.splitString(fullData, ",");
			for(String parameter : arrParameters){
				if(parameter.length()>0){
					String[] arrStrParameter = CommonUtil.splitString(parameter, "=");
					//System.out.println(arrStrParameter[1]);
					//System.out.println(arrStrParameter[0].toUpperCase());
					preparedStatement.setString(1, arrStrParameter[1]);
					preparedStatement.setString(2, userCode);
					preparedStatement.setString(3, arrStrParameter[0].toUpperCase());
					preparedStatement.addBatch();
				}
			}
			preparedStatement.executeBatch();
			result = "Weightage updated successfully.";
		}catch(Exception e) {
			result = "Error while updating weightage.";
			e.printStackTrace();
		}finally {
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return result;
	}
}
