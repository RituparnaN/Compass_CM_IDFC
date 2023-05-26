package com.quantumdataengines.app.compass.dao.riskAssessmentNew;

import java.lang.reflect.Array;
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
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Repository;

import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerDataModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormConfigurationModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormDataModel;
import com.quantumdataengines.app.compass.util.CommonUtil;
import com.quantumdataengines.app.compass.util.ConnectionUtil;

@Repository
public class RiskAssessmentNewDAOImpl implements RiskAssessmentNewDAO {
	
	@Autowired
	private ConnectionUtil connectionUtil;
	
	@Value("${compass.aml.config.schemaName}")
	private String schemaName;
	
	@Override
	public Map<String,Object> getQuestionsFormDetails(String assessmentUnit, String cmRefNo){
		
		//creating categories list
		ArrayList<String> categoryList = new ArrayList<String>();
		categoryList.add("customer");
		categoryList.add("geography");
		categoryList.add("products and services");
		categoryList.add("transactions");
		categoryList.add("delivery channels");
		
		
		
		// adding subcategories 
		ArrayList<String> customerSubCategories = new ArrayList<String>();
		customerSubCategories.add("Enitity type");
		customerSubCategories.add("Industry / profession");
		customerSubCategories.add("Customer Risk Rating");
		customerSubCategories.add("Politically Exposed Persons (PEPs)");
		customerSubCategories.add("Others");
		
		ArrayList<String> geoSubCategories = new ArrayList<String>();
		geoSubCategories.add("Nationalities");
		geoSubCategories.add("Residence / Country of Incorporation / Operation");
		
		ArrayList<String> pAndSSubCategories = new ArrayList<String>();
		pAndSSubCategories.add("Retail Assets Products");
		
		ArrayList<String> tranSubCategories = new ArrayList<String>();
		tranSubCategories.add("Transactions");
		
		ArrayList<String> delChannelsSubCategories = new ArrayList<String>();
		delChannelsSubCategories.add("Delivery Channel");
		
		// assigning sub categories to categories
		Map<String,Object> categoresAndSubCategories = new LinkedHashMap<String, Object>();
		categoresAndSubCategories.put("customer", customerSubCategories);
		categoresAndSubCategories.put("geography", geoSubCategories);
		categoresAndSubCategories.put("products and services", pAndSSubCategories);
		categoresAndSubCategories.put("transactions", tranSubCategories);
		categoresAndSubCategories.put("delivery channels", delChannelsSubCategories);
		
		JSONObject controlReviewCategoryWeights = new JSONObject();
		try {
			controlReviewCategoryWeights.put("Governance & Management Oversight",10);
			controlReviewCategoryWeights.put("Customer Due Diligence & Risk Management",25);
			controlReviewCategoryWeights.put("Transactions Monitoring",10);
			controlReviewCategoryWeights.put("Internal Quality Assurance and Compliance Testing",10);
			controlReviewCategoryWeights.put("Name/Sanctions Screening",10);
			controlReviewCategoryWeights.put("Training",15);
			controlReviewCategoryWeights.put("Foreign Correspondent Banking Relationships",5);
			controlReviewCategoryWeights.put("Internal Audit",10);
			controlReviewCategoryWeights.put("Reporting Requirements",5);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		JSONObject categoryWeights = new JSONObject();
		try {
			categoryWeights.put("customer", 30);
			categoryWeights.put("geography", 25);
			categoryWeights.put("products and services", 25);
			categoryWeights.put("transactions", 10);
			categoryWeights.put("delivery channels", 10);
		} catch (JSONException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		
		
		Map<String,Object> controlReview = new LinkedHashMap<String, Object>();
		ArrayList<String> crSubCategories = new ArrayList<String>();
		crSubCategories.add("Governance & Management Oversight");
		crSubCategories.add("Customer Due Diligence & Risk Management");
		crSubCategories.add("Transactions Monitoring");
		crSubCategories.add("Internal Quality Assurance and Compliance Testing");
		crSubCategories.add("Name/Sanctions Screening");
		crSubCategories.add("Training");
		crSubCategories.add("Foreign Correspondent Banking Relationships");
		crSubCategories.add("Internal Audit");
		crSubCategories.add("Reporting Requirements");
		
		controlReview.put("subCategories",crSubCategories);
		
		Map<String,Object> crSubandSubSubMap = new LinkedHashMap<String, Object>();
			ArrayList<String> cr0SubSubCateg = new ArrayList<String>();
			cr0SubSubCateg.add("Policy");
			cr0SubSubCateg.add("Oversight & Team Structure");
			cr0SubSubCateg.add("Third Party Service Provider");
			cr0SubSubCateg.add("Management Information");
		
			crSubandSubSubMap.put(crSubCategories.get(0), cr0SubSubCateg);
			
			ArrayList<String> cr1SubSubCateg = new ArrayList<String>();
			cr1SubSubCateg.add("CDD Procedures");
			cr1SubSubCateg.add("Customer Risk Rating (CRR)");
			cr1SubSubCateg.add("Periodic Updation of KYC");
			
			crSubandSubSubMap.put(crSubCategories.get(1), cr1SubSubCateg);
			
			ArrayList<String> cr2SubSubCateg = new ArrayList<String>();
			cr2SubSubCateg.add("Transaction Monitoring Programme");
			cr2SubSubCateg.add("Transaction Monitoring Alert Investigation & Suspicious Transaction Reporting (TMAI & STR)");
			
			crSubandSubSubMap.put(crSubCategories.get(2), cr2SubSubCateg);
			
			ArrayList<String> cr3SubSubCateg = new ArrayList<String>();
			cr3SubSubCateg.add("AML Compliance Testing");
			cr3SubSubCateg.add("Independent Testing of AML Complaince Program");
			cr3SubSubCateg.add("Internal Testing and Programme Monitoring Issues Management");
			
			crSubandSubSubMap.put(crSubCategories.get(3), cr3SubSubCateg);
			
			ArrayList<String> cr4SubSubCateg = new ArrayList<String>();
			cr4SubSubCateg.add("Customer Screening");
			cr4SubSubCateg.add("Customer Screening - Technology");
			cr4SubSubCateg.add("Payment/Transaction Screening");
			cr4SubSubCateg.add("Payment/Transaction Screening - Technology");
			cr4SubSubCateg.add("List Management");
			cr4SubSubCateg.add("Sanctions alert Investigation");
			cr4SubSubCateg.add("Blocked / Rejected Transactions");
			
			crSubandSubSubMap.put(crSubCategories.get(4), cr4SubSubCateg);
			
			ArrayList<String> cr5SubSubCateg = new ArrayList<String>();
			cr5SubSubCateg.add("Training Program");
			
			crSubandSubSubMap.put(crSubCategories.get(5), cr5SubSubCateg);
			
			ArrayList<String> cr6SubSubCateg = new ArrayList<String>();
			cr6SubSubCateg.add("Foreign Correspondent Banking (FCB) Relationships (Vostro accounts held for other banks)");
			
			crSubandSubSubMap.put(crSubCategories.get(6), cr6SubSubCateg);
			
			ArrayList<String> cr7SubSubCateg = new ArrayList<String>();
			cr7SubSubCateg.add("Internal Audit Findings");
			
			crSubandSubSubMap.put(crSubCategories.get(7), cr7SubSubCateg);
			
			ArrayList<String> cr8SubSubCateg = new ArrayList<String>();
			cr8SubSubCateg.add("Reporting");
			
			crSubandSubSubMap.put(crSubCategories.get(8), cr8SubSubCateg);
		
		controlReview.put("subAndSubSubCateg", crSubandSubSubMap);
		
//		System.out.println(controlReview.toString());
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "";
		
		Map<String,Object> generalAndstatusDetails = new LinkedHashMap<String, Object>();
		JSONObject generalAndstatusDetailsJson = new JSONObject();
		try {
			query = "SELECT ASSESSMENTPERIOD,POCNAME,POCEMAIL,COMPLIANCE1,COMPLIANCE2,BUSINESS1,"
				   +"		BUSINESS2,OTHER1,OTHER2,KEYBUSINESSNAME1,KEYBUSINESSNAME2,KEYBUSINESSNAME3,"
				   + "      KEYBUSINESSROLE1,KEYBUSINESSROLE2,KEYBUSINESSROLE3,FORMSTATUS,CMOFFICERCODE,"
				   + "      FUN_DATETIMETOCHAR(CMOFFICERTIMESTAMP) CMOFFICERTIMESTAMP,CMOFFICERCOMMENTS,CMMANAGERCODE,"
				   + "		FUN_DATETIMETOCHAR(CMMANAGERTIMESTAMP) CMMANAGERTIMESTAMP,CMMANAGERCOMMENTS"
				   + " FROM COMAML_CM.TB_RAFORMGENERALDETAILS "
				   + "WHERE CMREFNO = ? "
				   + "  AND ASSESSMENTUNIT = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, cmRefNo);
			preparedStatement.setString(2, assessmentUnit);
			resultSet = preparedStatement.executeQuery();
			if(resultSet.next()) {
				generalAndstatusDetails.put("ASSESSMENTPERIOD", resultSet.getString("ASSESSMENTPERIOD"));
				generalAndstatusDetails.put("POCNAME", resultSet.getString("POCNAME"));
				generalAndstatusDetails.put("POCEMAIL", resultSet.getString("POCEMAIL"));
				generalAndstatusDetails.put("COMPLIANCE1", resultSet.getString("COMPLIANCE1"));
				generalAndstatusDetails.put("COMPLIANCE2", resultSet.getString("COMPLIANCE2"));
				generalAndstatusDetails.put("BUSINESS1", resultSet.getString("BUSINESS1"));
				generalAndstatusDetails.put("BUSINESS2", resultSet.getString("BUSINESS2"));
				generalAndstatusDetails.put("OTHER1", resultSet.getString("OTHER1"));
				generalAndstatusDetails.put("OTHER2", resultSet.getString("OTHER2"));
				generalAndstatusDetails.put("KEYBUSINESSNAME1", resultSet.getString("KEYBUSINESSNAME1"));
				generalAndstatusDetails.put("KEYBUSINESSNAME2", resultSet.getString("KEYBUSINESSNAME2"));
				generalAndstatusDetails.put("KEYBUSINESSNAME3", resultSet.getString("KEYBUSINESSNAME3"));
				generalAndstatusDetails.put("KEYBUSINESSROLE1", resultSet.getString("KEYBUSINESSROLE1"));
				generalAndstatusDetails.put("KEYBUSINESSROLE2", resultSet.getString("KEYBUSINESSROLE2"));
				generalAndstatusDetails.put("KEYBUSINESSROLE3", resultSet.getString("KEYBUSINESSROLE3"));
				generalAndstatusDetails.put("FORMSTATUS", resultSet.getString("FORMSTATUS"));
				generalAndstatusDetails.put("CMOFFICERCODE", resultSet.getString("CMOFFICERCODE"));
				generalAndstatusDetails.put("CMOFFICERTIMESTAMP", resultSet.getString("CMOFFICERTIMESTAMP"));
				generalAndstatusDetails.put("CMOFFICERCOMMENTS", resultSet.getString("CMOFFICERCOMMENTS"));
				generalAndstatusDetails.put("CMMANAGERCODE", resultSet.getString("CMMANAGERCODE"));
				generalAndstatusDetails.put("CMMANAGERTIMESTAMP", resultSet.getString("CMMANAGERTIMESTAMP"));
				generalAndstatusDetails.put("CMMANAGERCOMMENTS", resultSet.getString("CMMANAGERCOMMENTS"));
				
				generalAndstatusDetailsJson.put("ASSESSMENTPERIOD", resultSet.getString("ASSESSMENTPERIOD"));
				generalAndstatusDetailsJson.put("POCNAME", resultSet.getString("POCNAME"));
				generalAndstatusDetailsJson.put("POCEMAIL", resultSet.getString("POCEMAIL"));
				generalAndstatusDetailsJson.put("COMPLIANCE1", resultSet.getString("COMPLIANCE1"));
				generalAndstatusDetailsJson.put("COMPLIANCE2", resultSet.getString("COMPLIANCE2"));
				generalAndstatusDetailsJson.put("BUSINESS1", resultSet.getString("BUSINESS1"));
				generalAndstatusDetailsJson.put("BUSINESS2", resultSet.getString("BUSINESS2"));
				generalAndstatusDetailsJson.put("OTHER1", resultSet.getString("OTHER1"));
				generalAndstatusDetailsJson.put("OTHER2", resultSet.getString("OTHER2"));
				generalAndstatusDetailsJson.put("KEYBUSINESSNAME1", resultSet.getString("KEYBUSINESSNAME1"));
				generalAndstatusDetailsJson.put("KEYBUSINESSNAME2", resultSet.getString("KEYBUSINESSNAME2"));
				generalAndstatusDetailsJson.put("KEYBUSINESSNAME3", resultSet.getString("KEYBUSINESSNAME3"));
				generalAndstatusDetailsJson.put("KEYBUSINESSROLE1", resultSet.getString("KEYBUSINESSROLE1"));
				generalAndstatusDetailsJson.put("KEYBUSINESSROLE2", resultSet.getString("KEYBUSINESSROLE2"));
				generalAndstatusDetailsJson.put("KEYBUSINESSROLE3", resultSet.getString("KEYBUSINESSROLE3"));
				generalAndstatusDetailsJson.put("FORMSTATUS", resultSet.getString("FORMSTATUS"));
				generalAndstatusDetailsJson.put("CMOFFICERCODE", resultSet.getString("CMOFFICERCODE"));
				generalAndstatusDetailsJson.put("CMOFFICERTIMESTAMP", resultSet.getString("CMOFFICERTIMESTAMP"));
				generalAndstatusDetailsJson.put("CMOFFICERCOMMENTS", resultSet.getString("CMOFFICERCOMMENTS"));
				generalAndstatusDetailsJson.put("CMMANAGERCODE", resultSet.getString("CMMANAGERCODE"));
				generalAndstatusDetailsJson.put("CMMANAGERTIMESTAMP", resultSet.getString("CMMANAGERTIMESTAMP"));
				generalAndstatusDetailsJson.put("CMMANAGERCOMMENTS", resultSet.getString("CMMANAGERCOMMENTS"));
				
			}
			else {
				generalAndstatusDetails.put("ASSESSMENTPERIOD", "");
				generalAndstatusDetails.put("POCNAME", "");
				generalAndstatusDetails.put("POCEMAIL", "");
				generalAndstatusDetails.put("COMPLIANCE1", "");
				generalAndstatusDetails.put("COMPLIANCE2", "");
				generalAndstatusDetails.put("BUSINESS1", "");
				generalAndstatusDetails.put("BUSINESS2", "");
				generalAndstatusDetails.put("OTHER1", "");
				generalAndstatusDetails.put("OTHER2", "");
				generalAndstatusDetails.put("KEYBUSINESSNAME1", "");
				generalAndstatusDetails.put("KEYBUSINESSNAME2", "");
				generalAndstatusDetails.put("KEYBUSINESSNAME3", "");
				generalAndstatusDetails.put("KEYBUSINESSROLE1", "");
				generalAndstatusDetails.put("KEYBUSINESSROLE2", "");
				generalAndstatusDetails.put("KEYBUSINESSROLE3", "");
				generalAndstatusDetails.put("FORMSTATUS", "");
				generalAndstatusDetails.put("CMOFFICERCODE", "");
				generalAndstatusDetails.put("CMOFFICERTIMESTAMP", "");
				generalAndstatusDetails.put("CMOFFICERCOMMENTS", "");
				generalAndstatusDetails.put("CMMANAGERCODE", "");
				generalAndstatusDetails.put("CMMANAGERTIMESTAMP", "");
				generalAndstatusDetails.put("CMMANAGERCOMMENTS", "");
				
				generalAndstatusDetailsJson.put("ASSESSMENTPERIOD", "");
				generalAndstatusDetailsJson.put("POCNAME", "");
				generalAndstatusDetailsJson.put("POCEMAIL", "");
				generalAndstatusDetailsJson.put("COMPLIANCE1", "");
				generalAndstatusDetailsJson.put("COMPLIANCE2", "");
				generalAndstatusDetailsJson.put("BUSINESS1", "");
				generalAndstatusDetailsJson.put("BUSINESS2", "");
				generalAndstatusDetailsJson.put("OTHER1", "");
				generalAndstatusDetailsJson.put("OTHER2", "");
				generalAndstatusDetailsJson.put("KEYBUSINESSNAME1", "");
				generalAndstatusDetailsJson.put("KEYBUSINESSNAME2", "");
				generalAndstatusDetailsJson.put("KEYBUSINESSNAME3", "");
				generalAndstatusDetailsJson.put("KEYBUSINESSROLE1", "");
				generalAndstatusDetailsJson.put("KEYBUSINESSROLE2", "");
				generalAndstatusDetailsJson.put("KEYBUSINESSROLE3", "");
				generalAndstatusDetailsJson.put("FORMSTATUS", "");
				generalAndstatusDetailsJson.put("CMOFFICERCODE", "");
				generalAndstatusDetailsJson.put("CMOFFICERTIMESTAMP", "");
				generalAndstatusDetailsJson.put("CMOFFICERCOMMENTS", "");
				generalAndstatusDetailsJson.put("CMMANAGERCODE", "");
				generalAndstatusDetailsJson.put("CMMANAGERTIMESTAMP", "");
				generalAndstatusDetailsJson.put("CMMANAGERCOMMENTS", "");
			}
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		ArrayList<Map<String,Object>> formCommentLogs = new ArrayList<Map<String,Object>>();
		try {
			query = " SELECT USERNAME,USERROLE,COMMENTS,"
					+ "      FUN_DATETIMETOCHAR(UPDATEDTIMESTAMP) TIMESTAMP"
					+ " FROM COMAML_CM.TB_RAFORMCOMMENTSLOG "
					+ "WHERE CMREFNO = ? "
					+ "  AND ASSESSMENTUNIT = ? ORDER BY UPDATEDTIMESTAMP DESC";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, cmRefNo);
			preparedStatement.setString(2, assessmentUnit);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
				Map<String,Object> commentLog = new LinkedHashMap<String, Object>();
				commentLog.put("USERNAME", resultSet.getString("USERNAME"));
				commentLog.put("USERROLE", resultSet.getString("USERROLE"));
				commentLog.put("COMMENTS", resultSet.getString("COMMENTS"));
				commentLog.put("TIMESTAMP", resultSet.getString("TIMESTAMP"));
				formCommentLogs.add(commentLog);
			}
			
		}
		catch(Exception e) {
			e.printStackTrace();
		}
		
		Map<String,Object> questionsFormDetails = new LinkedHashMap<String, Object>();
		Map<String,Object> categoryWiseQuestions = new LinkedHashMap<String, Object>();
		JSONObject categoryWiseQuestionsJson = new JSONObject();
		JSONObject questionResponsesData = new JSONObject();
		Map<String,Object> questionResponsesDataMap = new LinkedHashMap<String, Object>();
		Map<String,Object> categSubcategInherentRiskRatings = new LinkedHashMap<String, Object>();
		JSONObject categSubcategInherentRiskRatingsJson = new JSONObject();
		Map<String,Object> categoryRiskRatings = new LinkedHashMap<String, Object>();
		JSONObject categoryRiskRatingsJson = new JSONObject();
		
		questionsFormDetails.put("generalAndstatusDetails", generalAndstatusDetails);
		questionsFormDetails.put("generalAndstatusDetailsJson", generalAndstatusDetailsJson);
		questionsFormDetails.put("formCommentLogs", formCommentLogs);
		try{
			
			for(String category: categoryList) {
//				System.out.println("category:"+category);
				
				query = "SELECT SYSGENRISKRATING, PROVRISKRATING, FINALRISKRATING, REASONFORDEVIATION "
						+ "  FROM COMAML_CM.TB_RARISKRATINGS "
						+ " WHERE ASSESSMENTUNIT = ? "
						+ "   AND CATEGORY = ? "
						+ "   AND SUBCATEGORY = ?"
						+ "   AND CMREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, assessmentUnit);
				preparedStatement.setString(2, category);
				preparedStatement.setString(3, category);
				preparedStatement.setString(4, cmRefNo);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					Map<String,Object> categRiskRatings = new LinkedHashMap<String, Object>();
					JSONObject categRiskRatingsJson = new JSONObject();
					categRiskRatings.put("SYSGENRISKRATING", resultSet.getString("SYSGENRISKRATING"));
					categRiskRatings.put("PROVRISKRATING", resultSet.getString("PROVRISKRATING"));
					categRiskRatings.put("FINALRISKRATING", resultSet.getString("FINALRISKRATING"));
					categRiskRatings.put("REASONFORDEVIATION", resultSet.getString("REASONFORDEVIATION"));
					categoryRiskRatings.put(category, categRiskRatings);
					
					categRiskRatingsJson.put("SYSGENRISKRATING", resultSet.getString("SYSGENRISKRATING"));
					categRiskRatingsJson.put("PROVRISKRATING", resultSet.getString("PROVRISKRATING"));
					categRiskRatingsJson.put("FINALRISKRATING", resultSet.getString("FINALRISKRATING"));
					categRiskRatingsJson.put("REASONFORDEVIATION", resultSet.getString("REASONFORDEVIATION"));
					categoryRiskRatingsJson.put(category, categRiskRatingsJson);
				}
				else {
					Map<String,Object> categRiskRatings = new LinkedHashMap<String, Object>();
					JSONObject categRiskRatingsJson = new JSONObject();
					categRiskRatings.put("SYSGENRISKRATING", "0.0");
					categRiskRatings.put("PROVRISKRATING", "0.0");
					categRiskRatings.put("FINALRISKRATING", "0.0");
					categRiskRatings.put("REASONFORDEVIATION", "");
					categoryRiskRatings.put(category, categRiskRatings);
					
					categRiskRatingsJson.put("SYSGENRISKRATING", "0.0");
					categRiskRatingsJson.put("PROVRISKRATING", "0.0");
					categRiskRatingsJson.put("FINALRISKRATING", "0.0");
					categRiskRatingsJson.put("REASONFORDEVIATION", "");
					categoryRiskRatingsJson.put(category, categRiskRatingsJson);
				}
				
				Map<String,Object> subCategoryRiskrating = new LinkedHashMap<String, Object>();
				JSONObject subCategoryRiskratingJson = new JSONObject();
				Map<String,Object> subCategoryWiseQuestions = new LinkedHashMap<String, Object>();
				JSONObject subCategoryWiseQuestionsJson = new JSONObject();
				for( String subCategory:(ArrayList<String>) categoresAndSubCategories.get(category)) {
//					System.out.println("subCategory:"+subCategory);
					
					query = "SELECT INHERENTRISKRATING "
							+ "  FROM COMAML_CM.TB_RARISKRATINGS "
							+ " WHERE ASSESSMENTUNIT = ? "
							+ "   AND CATEGORY = ? "
							+ "   AND SUBCATEGORY = ?"
							+ "   AND CMREFNO = ?";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentUnit);
					preparedStatement.setString(2, category);
					preparedStatement.setString(3, subCategory);
					preparedStatement.setString(4, cmRefNo);
					resultSet = preparedStatement.executeQuery();
					if(resultSet.next()){
						subCategoryRiskrating.put(subCategory, resultSet.getString("INHERENTRISKRATING"));
						subCategoryRiskratingJson.put(subCategory, resultSet.getString("INHERENTRISKRATING"));
					}
					else {
						subCategoryRiskrating.put(subCategory, "0.0");
						subCategoryRiskratingJson.put(subCategory, "0.0");
					}
					ArrayList<Object> questionsList = new ArrayList<Object>();
					JSONArray questionsListJson = new JSONArray();
					
					query = "SELECT QUESTIONID, QUESTION, INPUTTYPE, INPUTOPTIONSLIST, "
							+ "		ISSUPERPARENT, HASPARENT, PARENTQSIDS, HASRISKIMPACT, INPUTOPTIONSLISTFORNUMERIC,CREATEDBY,CREATEDON,COMMENTS "
							+ "  FROM COMAML_CM.TB_RISKASSESSQUESTIONSCONFIG "
							+ " WHERE ASSESSMENTUNIT = ? "
							+ "   AND CATEGORY = ? "
							+ "   AND SUBCATEGORY = ?"
							+ "   AND QUESTIONID NOT LIKE '%.%' ORDER BY QUESTIONID ASC";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentUnit);
					preparedStatement.setString(2, category);
					preparedStatement.setString(3, subCategory);
					resultSet = preparedStatement.executeQuery();
					while(resultSet.next()){
						
										
						Map<String,Object> questionDetails = new LinkedHashMap<String, Object>();
						questionDetails.put("QUESTIONID", resultSet.getString("QUESTIONID"));
						questionDetails.put("QUESTION", resultSet.getString("QUESTION"));
						questionDetails.put("INPUTTYPE", resultSet.getString("INPUTTYPE"));
						questionDetails.put("INPUTOPTIONSLIST", resultSet.getString("INPUTOPTIONSLIST"));
						questionDetails.put("ISSUPERPARENT", resultSet.getString("ISSUPERPARENT"));
						questionDetails.put("HASPARENT", resultSet.getString("HASPARENT"));
						questionDetails.put("PARENTQSIDS", resultSet.getString("PARENTQSIDS"));
						questionDetails.put("HASRISKIMPACT", resultSet.getString("HASRISKIMPACT"));
						questionDetails.put("INPUTOPTIONSLISTFORNUMERIC", resultSet.getString("INPUTOPTIONSLISTFORNUMERIC"));
						questionDetails.put("CREATEDBY", resultSet.getString("CREATEDBY"));
						questionDetails.put("CREATEDON", resultSet.getString("CREATEDON"));
						questionDetails.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
						questionDetails.put("DISABLED", "Y");
						
						
						
						JSONObject questionDetailsJson = new JSONObject();
						questionDetailsJson.put("QUESTIONID", resultSet.getString("QUESTIONID"));
						questionDetailsJson.put("QUESTION", resultSet.getString("QUESTION"));
						questionDetailsJson.put("INPUTTYPE", resultSet.getString("INPUTTYPE"));
						questionDetailsJson.put("INPUTOPTIONSLIST", resultSet.getString("INPUTOPTIONSLIST"));
						questionDetailsJson.put("ISSUPERPARENT", resultSet.getString("ISSUPERPARENT"));
						questionDetailsJson.put("HASPARENT", resultSet.getString("HASPARENT"));
						questionDetailsJson.put("PARENTQSIDS", resultSet.getString("PARENTQSIDS"));
						questionDetailsJson.put("HASRISKIMPACT", resultSet.getString("HASRISKIMPACT"));
						questionDetailsJson.put("INPUTOPTIONSLISTFORNUMERIC", resultSet.getString("INPUTOPTIONSLISTFORNUMERIC"));
						questionDetailsJson.put("CREATEDBY", resultSet.getString("CREATEDBY"));
						questionDetailsJson.put("CREATEDON", resultSet.getString("CREATEDON"));
						questionDetailsJson.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
						questionDetailsJson.put("DISABLED", "Y");
						
						query = "SELECT RFISTATUS FROM "+schemaName+"TB_CMQUES_CASEWORKFLOWDETAILS "+
								" WHERE CASEID = ?"+
								"   AND COMPASSREFNO = ?";
						//System.out.println("Q2 = "+query);
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, resultSet.getString("QUESTIONID"));
						preparedStatement.setString(2, cmRefNo);
						ResultSet resultSet1 = preparedStatement.executeQuery();
						String rfiStatus = "NA";
						if(resultSet1.next()) {
							rfiStatus = resultSet1.getString("RFISTATUS");
						}
						questionDetails.put("RFISTATUS",rfiStatus);
						
						
						Map<String,String> qResponses = new LinkedHashMap<String, String>();
						JSONObject qResponsesJson = new JSONObject();
						
						
						query = "  SELECT QINPUT,QRESULT,QIMPACTCRITERIA,QLIKELYHOOD,QINHERENTRISK "
								+ "  FROM COMAML_CM.TB_RAQUESTIONRESPONSES"
								+ " WHERE ASSESSMENTUNIT = ?"
								+ "   AND CMREFNO = ?"
								+ "   AND QUESTIONID = ?";
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, assessmentUnit);
						preparedStatement.setString(2, cmRefNo);
						preparedStatement.setString(3, resultSet.getString("QUESTIONID"));
						ResultSet responseResultSet = preparedStatement.executeQuery();
						if(responseResultSet.next()) {
							qResponses.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponses.put("QINPUT", responseResultSet.getString("QINPUT"));
							qResponses.put("QRESULT", responseResultSet.getString("QRESULT"));
							qResponses.put("QIMPACTCRITERIA", responseResultSet.getString("QIMPACTCRITERIA"));
							qResponses.put("QLIKELYHOOD", responseResultSet.getString("QLIKELYHOOD"));
							qResponses.put("QINHERENTRISK", responseResultSet.getString("QINHERENTRISK"));
							
							questionDetails.put("QRESPONSES", qResponses);
							questionResponsesDataMap.put(resultSet.getString("QUESTIONID"), qResponses);
							
							qResponsesJson.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponsesJson.put("QINPUT", responseResultSet.getString("QINPUT"));
							qResponsesJson.put("QRESULT", responseResultSet.getString("QRESULT"));
							qResponsesJson.put("QIMPACTCRITERIA", responseResultSet.getString("QIMPACTCRITERIA"));
							qResponsesJson.put("QLIKELYHOOD", responseResultSet.getString("QLIKELYHOOD"));
							qResponsesJson.put("QINHERENTRISK", responseResultSet.getString("QINHERENTRISK"));
							
							questionDetailsJson.put("QRESPONSES", qResponsesJson);
							questionResponsesData.put(resultSet.getString("QUESTIONID"), qResponsesJson);
						}
						else {
							qResponses.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponses.put("QINPUT", "");
							qResponses.put("QRESULT", "0");
							qResponses.put("QIMPACTCRITERIA", "0");
							qResponses.put("QLIKELYHOOD", "0");
							qResponses.put("QINHERENTRISK", "0");
							
							questionDetails.put("QRESPONSES", qResponses);
							questionResponsesDataMap.put(resultSet.getString("QUESTIONID"), qResponses);
							
							qResponsesJson.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponsesJson.put("QINPUT", "");
							qResponsesJson.put("QRESULT", "0");
							qResponsesJson.put("QIMPACTCRITERIA", "0");
							qResponsesJson.put("QLIKELYHOOD", "0");
							qResponsesJson.put("QINHERENTRISK", "0");
							
							questionDetailsJson.put("QRESPONSES", qResponsesJson);
							questionResponsesData.put(resultSet.getString("QUESTIONID"), qResponsesJson);
						}
						
						ArrayList<Object> subQuestionsArrayList = new ArrayList<Object>();
						JSONArray subQuestionArrayJson = new JSONArray();
						query = "SELECT QUESTIONID, QUESTION, INPUTTYPE, INPUTOPTIONSLIST, "
								+ "		ISSUPERPARENT, HASPARENT, PARENTQSIDS, HASRISKIMPACT,INPUTOPTIONSLISTFORNUMERIC,CREATEDBY,CREATEDON,COMMENTS "
								+ "  FROM COMAML_CM.TB_RISKASSESSQUESTIONSCONFIG "
								+ " WHERE ASSESSMENTUNIT = ? "
								+ "   AND CATEGORY = ? "
								+ "   AND SUBCATEGORY = ? "
								+ "   AND QUESTIONID LIKE '%"+resultSet.getString("QUESTIONID")+"."+"%' ORDER BY QUESTIONID ASC";
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, assessmentUnit);
						preparedStatement.setString(2, category);
						preparedStatement.setString(3, subCategory);
						ResultSet resultSetSub = preparedStatement.executeQuery();
						while(resultSetSub.next()) {
							JSONObject subQuestionObject = new JSONObject();
							subQuestionObject.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
							subQuestionObject.put("QUESTION", resultSetSub.getString("QUESTION"));
							subQuestionObject.put("INPUTTYPE", resultSetSub.getString("INPUTTYPE"));
							subQuestionObject.put("INPUTOPTIONSLIST", resultSetSub.getString("INPUTOPTIONSLIST"));
							subQuestionObject.put("ISSUPERPARENT", resultSetSub.getString("ISSUPERPARENT"));
							subQuestionObject.put("HASPARENT", resultSetSub.getString("HASPARENT"));
							subQuestionObject.put("PARENTQSIDS", resultSetSub.getString("PARENTQSIDS"));
							subQuestionObject.put("HASRISKIMPACT", resultSetSub.getString("HASRISKIMPACT"));
							subQuestionObject.put("INPUTOPTIONSLISTFORNUMERIC", resultSetSub.getString("INPUTOPTIONSLISTFORNUMERIC"));
							subQuestionObject.put("CREATEDBY", resultSet.getString("CREATEDBY"));
							subQuestionObject.put("CREATEDON", resultSet.getString("CREATEDON"));
							subQuestionObject.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
							subQuestionObject.put("DISABLED", "Y");
							
							Map<String,Object> subQuestionObjectMap = new LinkedHashMap<String, Object>();
							subQuestionObjectMap.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
							subQuestionObjectMap.put("QUESTION", resultSetSub.getString("QUESTION"));
							subQuestionObjectMap.put("INPUTTYPE", resultSetSub.getString("INPUTTYPE"));
							subQuestionObjectMap.put("INPUTOPTIONSLIST", resultSetSub.getString("INPUTOPTIONSLIST"));
							subQuestionObjectMap.put("ISSUPERPARENT", resultSetSub.getString("ISSUPERPARENT"));
							subQuestionObjectMap.put("HASPARENT", resultSetSub.getString("HASPARENT"));
							subQuestionObjectMap.put("PARENTQSIDS", resultSetSub.getString("PARENTQSIDS"));
							subQuestionObjectMap.put("HASRISKIMPACT", resultSetSub.getString("HASRISKIMPACT"));
							subQuestionObjectMap.put("INPUTOPTIONSLISTFORNUMERIC", resultSetSub.getString("INPUTOPTIONSLISTFORNUMERIC"));
							subQuestionObjectMap.put("CREATEDBY", resultSet.getString("CREATEDBY"));
							subQuestionObjectMap.put("CREATEDON", resultSet.getString("CREATEDON"));
							subQuestionObjectMap.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
							subQuestionObjectMap.put("DISABLED", "Y");
							
							query = "SELECT RFISTATUS FROM "+schemaName+"TB_CMQUES_CASEWORKFLOWDETAILS "+
									" WHERE CASEID = ?"+
									"   AND COMPASSREFNO = ?";
							//System.out.println("Q2 = "+query);
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, resultSetSub.getString("QUESTIONID"));
							preparedStatement.setString(2, cmRefNo);
							resultSet1 = preparedStatement.executeQuery();
							rfiStatus = "NA";
							if(resultSet1.next()) {
								rfiStatus = resultSet1.getString("RFISTATUS");
							}
							subQuestionObjectMap.put("RFISTATUS",rfiStatus);
							
							Map<String,String> qResponsess = new LinkedHashMap<String, String>();
							JSONObject qResponsesJsonn = new JSONObject();
							
							query = "  SELECT QINPUT,QRESULT,QIMPACTCRITERIA,QLIKELYHOOD,QINHERENTRISK "
									+ "  FROM COMAML_CM.TB_RAQUESTIONRESPONSES"
									+ " WHERE ASSESSMENTUNIT = ?"
									+ "   AND CMREFNO = ?"
									+ "   AND QUESTIONID = ?";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentUnit);
							preparedStatement.setString(2, cmRefNo);
							preparedStatement.setString(3, resultSetSub.getString("QUESTIONID"));
							responseResultSet = preparedStatement.executeQuery();
							if(responseResultSet.next()) {
								qResponsess.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsess.put("QINPUT", responseResultSet.getString("QINPUT"));
								qResponsess.put("QRESULT", responseResultSet.getString("QRESULT"));
								qResponsess.put("QIMPACTCRITERIA", responseResultSet.getString("QIMPACTCRITERIA"));
								qResponsess.put("QLIKELYHOOD", responseResultSet.getString("QLIKELYHOOD"));
								qResponsess.put("QINHERENTRISK", responseResultSet.getString("QINHERENTRISK"));
								
								subQuestionObjectMap.put("QRESPONSES", qResponsess);
								questionResponsesDataMap.put(resultSetSub.getString("QUESTIONID"), qResponsess);
								
								qResponsesJsonn.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsesJsonn.put("QINPUT", responseResultSet.getString("QINPUT"));
								qResponsesJsonn.put("QRESULT", responseResultSet.getString("QRESULT"));
								qResponsesJsonn.put("QIMPACTCRITERIA", responseResultSet.getString("QIMPACTCRITERIA"));
								qResponsesJsonn.put("QLIKELYHOOD", responseResultSet.getString("QLIKELYHOOD"));
								qResponsesJsonn.put("QINHERENTRISK", responseResultSet.getString("QINHERENTRISK"));
								
								subQuestionObject.put("QRESPONSES", qResponsesJsonn);
								questionResponsesData.put(resultSetSub.getString("QUESTIONID"), qResponsesJsonn);
							}
							else {
								qResponsess.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsess.put("QINPUT", "");
								qResponsess.put("QRESULT", "0");
								qResponsess.put("QIMPACTCRITERIA", "0");
								qResponsess.put("QLIKELYHOOD", "0");
								qResponsess.put("QINHERENTRISK", "0");
								
								subQuestionObjectMap.put("QRESPONSES", qResponsess);
								questionResponsesDataMap.put(resultSetSub.getString("QUESTIONID"), qResponsess);
								
								qResponsesJsonn.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsesJsonn.put("QINPUT", "");
								qResponsesJsonn.put("QRESULT", "0");
								qResponsesJsonn.put("QIMPACTCRITERIA", "0");
								qResponsesJsonn.put("QLIKELYHOOD", "0");
								qResponsesJsonn.put("QINHERENTRISK", "0");
								
								subQuestionObject.put("QRESPONSES", qResponsesJsonn);
								questionResponsesData.put(resultSetSub.getString("QUESTIONID"), qResponsesJsonn);
							}
							
							
							subQuestionArrayJson.put(subQuestionObject);
							subQuestionsArrayList.add(subQuestionObjectMap);
						}
						questionDetails.put("SUBQUESTIONLIST", subQuestionsArrayList);
						questionsList.add(questionDetails);
						
						questionDetailsJson.put("SUBQUESTIONLIST", subQuestionArrayJson);
						questionsListJson.put(questionDetailsJson);
					}
					subCategoryWiseQuestions.put(subCategory, questionsList);
					subCategoryWiseQuestionsJson.put(subCategory, questionsListJson);
				}
				categoryWiseQuestions.put(category, subCategoryWiseQuestions);
				categoryWiseQuestionsJson.put(category, subCategoryWiseQuestionsJson);
				
				categSubcategInherentRiskRatings.put(category, subCategoryRiskrating);
				categSubcategInherentRiskRatingsJson.put(category, subCategoryRiskratingJson);
			}
			questionsFormDetails.put("categoryList", categoryList);
			questionsFormDetails.put("categoresAndSubCategories", categoresAndSubCategories);
			questionsFormDetails.put("categoryWiseQuesitons", categoryWiseQuestions);
			questionsFormDetails.put("categoryWiseQuesitonsJson", categoryWiseQuestionsJson.toString());
			
			Map<String,Object> controlReviewQuestionsMap = new LinkedHashMap<String, Object>();
			JSONObject controlReviewQuestionsMapJson = new JSONObject();
			String mainCategory = "Controls Review";
			
			Map<String,Object> crCategoryRiskRatings = new LinkedHashMap<String, Object>();
			JSONObject crCategoryRiskRatingsJson = new JSONObject();
			
			for(String crCategory : (ArrayList<String>)controlReview.get("subCategories")) {
//				System.out.println("++"+crCategory);
				query = "SELECT SYSGENRISKRATING, PROVRISKRATING, FINALRISKRATING, REASONFORDEVIATION "
						+ "  FROM COMAML_CM.TB_RARISKRATINGS "
						+ " WHERE ASSESSMENTUNIT = ? "
						+ "   AND CATEGORY = ? "
						+ "   AND SUBCATEGORY = ?"
						+ "   AND CMREFNO = ?";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, assessmentUnit);
				preparedStatement.setString(2, crCategory);
				preparedStatement.setString(3, crCategory);
				preparedStatement.setString(4, cmRefNo);
				resultSet = preparedStatement.executeQuery();
				if(resultSet.next()){
					Map<String,Object> categRiskRatings = new LinkedHashMap<String, Object>();
					JSONObject categRiskRatingsJson = new JSONObject();
					categRiskRatings.put("SYSGENRISKRATING", resultSet.getString("SYSGENRISKRATING"));
					categRiskRatings.put("PROVRISKRATING", resultSet.getString("PROVRISKRATING"));
					categRiskRatings.put("FINALRISKRATING", resultSet.getString("FINALRISKRATING"));
					categRiskRatings.put("REASONFORDEVIATION", resultSet.getString("REASONFORDEVIATION"));
					crCategoryRiskRatings.put(crCategory, categRiskRatings);
					
					categRiskRatingsJson.put("SYSGENRISKRATING", resultSet.getString("SYSGENRISKRATING"));
					categRiskRatingsJson.put("PROVRISKRATING", resultSet.getString("PROVRISKRATING"));
					categRiskRatingsJson.put("FINALRISKRATING", resultSet.getString("FINALRISKRATING"));
					categRiskRatingsJson.put("REASONFORDEVIATION", resultSet.getString("REASONFORDEVIATION"));
					crCategoryRiskRatingsJson.put(crCategory, categRiskRatingsJson);
				}
				else {
					Map<String,Object> categRiskRatings = new LinkedHashMap<String, Object>();
					JSONObject categRiskRatingsJson = new JSONObject();
					categRiskRatings.put("SYSGENRISKRATING", "0.0");
					categRiskRatings.put("PROVRISKRATING", "0.0");
					categRiskRatings.put("FINALRISKRATING", "0.0");
					categRiskRatings.put("REASONFORDEVIATION", "");
					crCategoryRiskRatings.put(crCategory, categRiskRatings);
					
					categRiskRatingsJson.put("SYSGENRISKRATING", "0.0");
					categRiskRatingsJson.put("PROVRISKRATING", "0.0");
					categRiskRatingsJson.put("FINALRISKRATING", "0.0");
					categRiskRatingsJson.put("REASONFORDEVIATION", "");
					crCategoryRiskRatingsJson.put(crCategory, categRiskRatingsJson);
				}
				
				Map<String,Object> crCategoryQuestionsMap = new LinkedHashMap<String, Object>();
				JSONObject crCategoryQuestionsMapJson = new JSONObject();
				for(String crSubCategory: (ArrayList<String>)((Map<String,Object>) controlReview.get("subAndSubSubCateg")).get(crCategory)) {
//					System.out.println("==="+crSubCategory);
					ArrayList<Object> QuestionList = new ArrayList<Object>();
					JSONArray questionListjson = new JSONArray();
					query = "SELECT QUESTIONID, QUESTION, INPUTTYPE, INPUTOPTIONSLIST, "
							+ "		ISSUPERPARENT, HASPARENT, PARENTQSIDS, HASRISKIMPACT, INPUTOPTIONSLISTFORNUMERIC,CREATEDBY,CREATEDON,COMMENTS "
							+ "  FROM COMAML_CM.TB_RISKASSESSQUESTIONSCONFIG "
							+ " WHERE ASSESSMENTUNIT = ? "
							+ "   AND CATEGORY = ? "
							+ "   AND SUBCATEGORY = ?"
							+ "	  AND SUBSUBCATEG = ?"
							+ "   AND QUESTIONID NOT LIKE '%.%' ORDER BY QUESTIONID ASC";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentUnit);
					preparedStatement.setString(2, mainCategory);
					preparedStatement.setString(3, crCategory);
					preparedStatement.setString(4, crSubCategory);
					resultSet = preparedStatement.executeQuery();
					while(resultSet.next()) {
						Map<String,Object> questionObj = new LinkedHashMap<String, Object>();
						questionObj.put("QUESTIONID", resultSet.getString("QUESTIONID"));
						questionObj.put("QUESTION", resultSet.getString("QUESTION"));
						questionObj.put("INPUTTYPE", resultSet.getString("INPUTTYPE"));
						questionObj.put("INPUTOPTIONSLIST", resultSet.getString("INPUTOPTIONSLIST"));
						questionObj.put("ISSUPERPARENT", resultSet.getString("ISSUPERPARENT"));
						questionObj.put("HASPARENT", resultSet.getString("HASPARENT"));
						questionObj.put("PARENTQSIDS", resultSet.getString("PARENTQSIDS"));
						questionObj.put("HASRISKIMPACT", resultSet.getString("HASRISKIMPACT"));
						questionObj.put("INPUTOPTIONSLISTFORNUMERIC", resultSet.getString("INPUTOPTIONSLISTFORNUMERIC"));
						questionObj.put("CREATEDBY", resultSet.getString("CREATEDBY"));
						questionObj.put("CREATEDON", resultSet.getString("CREATEDON"));
						questionObj.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
						questionObj.put("DISABLED", "Y");
						
						JSONObject questionDetailsJson = new JSONObject();
						questionDetailsJson.put("QUESTIONID", resultSet.getString("QUESTIONID"));
						questionDetailsJson.put("QUESTION", resultSet.getString("QUESTION"));
						questionDetailsJson.put("INPUTTYPE", resultSet.getString("INPUTTYPE"));
						questionDetailsJson.put("INPUTOPTIONSLIST", resultSet.getString("INPUTOPTIONSLIST"));
						questionDetailsJson.put("ISSUPERPARENT", resultSet.getString("ISSUPERPARENT"));
						questionDetailsJson.put("HASPARENT", resultSet.getString("HASPARENT"));
						questionDetailsJson.put("PARENTQSIDS", resultSet.getString("PARENTQSIDS"));
						questionDetailsJson.put("HASRISKIMPACT", resultSet.getString("HASRISKIMPACT"));
						questionDetailsJson.put("INPUTOPTIONSLISTFORNUMERIC", resultSet.getString("INPUTOPTIONSLISTFORNUMERIC"));
						questionDetailsJson.put("CREATEDBY", resultSet.getString("CREATEDBY"));
						questionDetailsJson.put("CREATEDON", resultSet.getString("CREATEDON"));
						questionDetailsJson.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
						questionDetailsJson.put("DISABLED", "Y");
						
						query = "SELECT RFISTATUS FROM "+schemaName+"TB_CMQUES_CASEWORKFLOWDETAILS "+
								" WHERE CASEID = ?"+
								"   AND COMPASSREFNO = ?";
						//System.out.println("Q2 = "+query);
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, resultSet.getString("QUESTIONID"));
						preparedStatement.setString(2, cmRefNo);
						ResultSet resultSet1 = preparedStatement.executeQuery();
						String rfiStatus = "NA";
						if(resultSet1.next()) {
							rfiStatus = resultSet1.getString("RFISTATUS");
						}
						questionObj.put("RFISTATUS",rfiStatus);
						
						Map<String,String> qResponses = new LinkedHashMap<String, String>();
						JSONObject qResponsesJson = new JSONObject();
						
						query = "  SELECT QINPUT,QDESIGNRATING,QOPERATINGRATING,QOBSERVATION,QDOCREFSAMTESTING "
								+ "  FROM COMAML_CM.TB_RAQUESTIONRESPONSES"
								+ " WHERE ASSESSMENTUNIT = ?"
								+ "   AND CMREFNO = ?"
								+ "   AND QUESTIONID = ?";
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, assessmentUnit);
						preparedStatement.setString(2, cmRefNo);
						preparedStatement.setString(3, resultSet.getString("QUESTIONID"));
						ResultSet responseResultSet = preparedStatement.executeQuery();
						if(responseResultSet.next()) {
							qResponses.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponses.put("QDESIGNRATING", responseResultSet.getString("QDESIGNRATING"));
							qResponses.put("QOPERATINGRATING", responseResultSet.getString("QOPERATINGRATING"));
							qResponses.put("QOBSERVATION", responseResultSet.getString("QOBSERVATION"));
							qResponses.put("QDOCREFSAMTESTING", responseResultSet.getString("QDOCREFSAMTESTING"));
							qResponses.put("QINPUT", responseResultSet.getString("QINPUT"));
							
							questionObj.put("QRESPONSES", qResponses);
							questionResponsesDataMap.put(resultSet.getString("QUESTIONID"), qResponses);
							
							qResponsesJson.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponsesJson.put("QDESIGNRATING", responseResultSet.getString("QDESIGNRATING"));
							qResponsesJson.put("QOPERATINGRATING", responseResultSet.getString("QOPERATINGRATING"));
							qResponsesJson.put("QOBSERVATION", responseResultSet.getString("QOBSERVATION"));
							qResponsesJson.put("QDOCREFSAMTESTING", responseResultSet.getString("QDOCREFSAMTESTING"));
							qResponsesJson.put("QINPUT", responseResultSet.getString("QINPUT"));
							
							questionDetailsJson.put("QRESPONSES", qResponsesJson);
							questionResponsesData.put(resultSet.getString("QUESTIONID"), qResponsesJson);
						}
						else {
							qResponses.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponses.put("QDESIGNRATING", "NA");
							qResponses.put("QOPERATINGRATING", "NA");
							qResponses.put("QOBSERVATION", "");
							qResponses.put("QDOCREFSAMTESTING", "");
							qResponses.put("QINPUT", "");
							
							questionObj.put("QRESPONSES", qResponses);
							questionResponsesDataMap.put(resultSet.getString("QUESTIONID"), qResponses);
							
							qResponsesJson.put("QUESTIONID", resultSet.getString("QUESTIONID"));
							qResponsesJson.put("QDESIGNRATING", "NA");
							qResponsesJson.put("QOPERATINGRATING", "NA");
							qResponsesJson.put("QOBSERVATION", "");
							qResponsesJson.put("QDOCREFSAMTESTING", "");
							qResponsesJson.put("QINPUT", "");
							
							questionDetailsJson.put("QRESPONSES", qResponsesJson);
							questionResponsesData.put(resultSet.getString("QUESTIONID"), qResponsesJson);
						}
						
						
						ArrayList<Object> subQuestionsArrayList = new ArrayList<Object>();
						JSONArray subQuestionArrayJson = new JSONArray();
						query = "SELECT QUESTIONID, QUESTION, INPUTTYPE, INPUTOPTIONSLIST, "
								+ "		ISSUPERPARENT, HASPARENT, PARENTQSIDS, HASRISKIMPACT,INPUTOPTIONSLISTFORNUMERIC,CREATEDBY,CREATEDON,COMMENTS "
								+ "  FROM COMAML_CM.TB_RISKASSESSQUESTIONSCONFIG "
								+ " WHERE ASSESSMENTUNIT = ? "
								+ "   AND CATEGORY = ? "
								+ "   AND SUBCATEGORY = ? "
								+ "	  AND SUBSUBCATEG = ?"
								+ "   AND QUESTIONID LIKE '%"+resultSet.getString("QUESTIONID")+"."+"%' ORDER BY QUESTIONID ASC";
						preparedStatement = connection.prepareStatement(query);
						preparedStatement.setString(1, assessmentUnit);
						preparedStatement.setString(2, mainCategory);
						preparedStatement.setString(3, crCategory);
						preparedStatement.setString(4, crSubCategory);
						ResultSet resultSetSub = preparedStatement.executeQuery();
						while(resultSetSub.next()) {
							JSONObject subQuestionObject = new JSONObject();
							subQuestionObject.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
							subQuestionObject.put("QUESTION", resultSetSub.getString("QUESTION"));
							subQuestionObject.put("INPUTTYPE", resultSetSub.getString("INPUTTYPE"));
							subQuestionObject.put("INPUTOPTIONSLIST", resultSetSub.getString("INPUTOPTIONSLIST"));
							subQuestionObject.put("ISSUPERPARENT", resultSetSub.getString("ISSUPERPARENT"));
							subQuestionObject.put("HASPARENT", resultSetSub.getString("HASPARENT"));
							subQuestionObject.put("PARENTQSIDS", resultSetSub.getString("PARENTQSIDS"));
							subQuestionObject.put("HASRISKIMPACT", resultSetSub.getString("HASRISKIMPACT"));
							subQuestionObject.put("INPUTOPTIONSLISTFORNUMERIC", resultSetSub.getString("INPUTOPTIONSLISTFORNUMERIC"));
							subQuestionObject.put("CREATEDBY", resultSet.getString("CREATEDBY"));
							subQuestionObject.put("CREATEDON", resultSet.getString("CREATEDON"));
							subQuestionObject.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
							subQuestionObject.put("DISABLED", "Y");
							
							Map<String,Object> subQuestionObjectMap = new LinkedHashMap<String, Object>();
							subQuestionObjectMap.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
							subQuestionObjectMap.put("QUESTION", resultSetSub.getString("QUESTION"));
							subQuestionObjectMap.put("INPUTTYPE", resultSetSub.getString("INPUTTYPE"));
							subQuestionObjectMap.put("INPUTOPTIONSLIST", resultSetSub.getString("INPUTOPTIONSLIST"));
							subQuestionObjectMap.put("ISSUPERPARENT", resultSetSub.getString("ISSUPERPARENT"));
							subQuestionObjectMap.put("HASPARENT", resultSetSub.getString("HASPARENT"));
							subQuestionObjectMap.put("PARENTQSIDS", resultSetSub.getString("PARENTQSIDS"));
							subQuestionObjectMap.put("HASRISKIMPACT", resultSetSub.getString("HASRISKIMPACT"));
							subQuestionObjectMap.put("INPUTOPTIONSLISTFORNUMERIC", resultSetSub.getString("INPUTOPTIONSLISTFORNUMERIC"));
							subQuestionObjectMap.put("CREATEDBY", resultSet.getString("CREATEDBY"));
							subQuestionObjectMap.put("CREATEDON", resultSet.getString("CREATEDON"));
							subQuestionObjectMap.put("COMMENTS", resultSet.getString("COMMENTS") == null?"":resultSet.getString("COMMENTS"));
							subQuestionObjectMap.put("DISABLED", "Y");
							
							query = "SELECT RFISTATUS FROM "+schemaName+"TB_CMQUES_CASEWORKFLOWDETAILS "+
									" WHERE CASEID = ?"+
									"   AND COMPASSREFNO = ?";
							//System.out.println("Q2 = "+query);
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, resultSetSub.getString("QUESTIONID"));
							preparedStatement.setString(2, cmRefNo);
							resultSet1 = preparedStatement.executeQuery();
							rfiStatus = "NA";
							if(resultSet1.next()) {
								rfiStatus = resultSet1.getString("RFISTATUS");
							}
							subQuestionObjectMap.put("RFISTATUS",rfiStatus);
							
							Map<String,String> qResponsess = new LinkedHashMap<String, String>();
							JSONObject qResponsesJsonn = new JSONObject();
							
							query = "  SELECT QINPUT,QDESIGNRATING,QOPERATINGRATING,QOBSERVATION,QDOCREFSAMTESTING "
									+ "  FROM COMAML_CM.TB_RAQUESTIONRESPONSES"
									+ " WHERE ASSESSMENTUNIT = ?"
									+ "   AND CMREFNO = ?"
									+ "   AND QUESTIONID = ?";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentUnit);
							preparedStatement.setString(2, cmRefNo);
							preparedStatement.setString(3, resultSetSub.getString("QUESTIONID"));
							responseResultSet = preparedStatement.executeQuery();
							if(responseResultSet.next()) {
								qResponsess.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsess.put("QDESIGNRATING", responseResultSet.getString("QDESIGNRATING"));
								qResponsess.put("QOPERATINGRATING", responseResultSet.getString("QOPERATINGRATING"));
								qResponsess.put("QOBSERVATION", responseResultSet.getString("QOBSERVATION"));
								qResponsess.put("QDOCREFSAMTESTING", responseResultSet.getString("QDOCREFSAMTESTING"));
								qResponsess.put("QINPUT", responseResultSet.getString("QINPUT"));
								
								subQuestionObjectMap.put("QRESPONSES", qResponsess);
								questionResponsesDataMap.put(resultSetSub.getString("QUESTIONID"), qResponsess);
								
								qResponsesJsonn.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsesJsonn.put("QDESIGNRATING", responseResultSet.getString("QDESIGNRATING"));
								qResponsesJsonn.put("QOPERATINGRATING", responseResultSet.getString("QOPERATINGRATING"));
								qResponsesJsonn.put("QOBSERVATION", responseResultSet.getString("QOBSERVATION"));
								qResponsesJsonn.put("QDOCREFSAMTESTING", responseResultSet.getString("QDOCREFSAMTESTING"));
								qResponsesJsonn.put("QINPUT", responseResultSet.getString("QINPUT"));
								
								subQuestionObject.put("QRESPONSES", qResponsesJsonn);
								questionResponsesData.put(resultSetSub.getString("QUESTIONID"), qResponsesJsonn);
							}
							else {
								qResponsess.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsess.put("QDESIGNRATING", "NA");
								qResponsess.put("QOPERATINGRATING", "NA");
								qResponsess.put("QOBSERVATION", "");
								qResponsess.put("QDOCREFSAMTESTING", "");
								qResponsess.put("QINPUT", "");
								
								subQuestionObjectMap.put("QRESPONSES", qResponsess);
								questionResponsesDataMap.put(resultSetSub.getString("QUESTIONID"), qResponsess);
								
								qResponsesJsonn.put("QUESTIONID", resultSetSub.getString("QUESTIONID"));
								qResponsesJsonn.put("QDESIGNRATING", "NA");
								qResponsesJsonn.put("QOPERATINGRATING", "NA");
								qResponsesJsonn.put("QOBSERVATION", "");
								qResponsesJsonn.put("QDOCREFSAMTESTING", "");
								qResponsesJsonn.put("QINPUT", "");
								
								subQuestionObject.put("QRESPONSES", qResponsesJsonn);
								questionResponsesData.put(resultSetSub.getString("QUESTIONID"), qResponsesJsonn);
							}
							
							
							subQuestionArrayJson.put(subQuestionObject);
							subQuestionsArrayList.add(subQuestionObjectMap);
						}
						questionObj.put("SUBQUESTIONLIST", subQuestionsArrayList);
						QuestionList.add(questionObj);
						
						questionDetailsJson.put("SUBQUESTIONLIST", subQuestionArrayJson);
						questionListjson.put(questionDetailsJson);
						
						
					}
					crCategoryQuestionsMap.put(crSubCategory,QuestionList);
					crCategoryQuestionsMapJson.put(crSubCategory,questionListjson);
					
					
				}
				controlReviewQuestionsMap.put(crCategory, crCategoryQuestionsMap);
				controlReviewQuestionsMapJson.put(crCategory, crCategoryQuestionsMapJson);
				
			}
			questionsFormDetails.put("controlsReviewCategSubCateg",controlReview);
			questionsFormDetails.put("controlsReviewQuestions", controlReviewQuestionsMap);
			questionsFormDetails.put("controlsReviewQuestionsJson", controlReviewQuestionsMapJson);
			
			questionsFormDetails.put("questionResponsesData", questionResponsesData);
			questionsFormDetails.put("questionResponsesDataMap", questionResponsesDataMap);
			
			questionsFormDetails.put("categSubcategInherentRiskRatings", categSubcategInherentRiskRatings);
			questionsFormDetails.put("categSubcategInherentRiskRatingsJson", categSubcategInherentRiskRatingsJson);
			
			questionsFormDetails.put("categoryRiskRatings", categoryRiskRatings);
			questionsFormDetails.put("categoryRiskRatingsJson", categoryRiskRatingsJson);
			
			questionsFormDetails.put("crCategoryRiskRatings", crCategoryRiskRatings);
			questionsFormDetails.put("crCategoryRiskRatingsJson", crCategoryRiskRatingsJson);
			
			questionsFormDetails.put("controlReviewCategoryWeights", controlReviewCategoryWeights);
			questionsFormDetails.put("categoryWeights", categoryWeights);
			
			
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return questionsFormDetails;
	}

	@Override
	public void saveRiskAssesesmentFormConfiguration(FormConfigurationModel formConfigurationModel) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "";
		try{
			if(formConfigurationModel.questionsList.size() > 0) {
				query = "DELETE FROM COMAML_CM.TB_RISKASSESSQUESTIONSCONFIG WHERE ASSESSMENTUNIT = ?";
				preparedStatement = connection.prepareStatement(query);
				
				preparedStatement.setString(1, (String) formConfigurationModel.questionsList.get(0).get("assessmentUnit"));
				preparedStatement.executeUpdate();
				
				for(Map<String, Object> question: formConfigurationModel.questionsList) {
					
					query = "INSERT INTO COMAML_CM.TB_RISKASSESSQUESTIONSCONFIG(QUESTIONID, QUESTION, INPUTTYPE, INPUTOPTIONSLIST, "
							+ "		ISSUPERPARENT, HASPARENT, PARENTQSIDS, HASRISKIMPACT, ASSESSMENTUNIT,CATEGORY, SUBCATEGORY, UPDATETIMESTAMP,"
							+ "		ISENABLED, INPUTOPTIONSLISTFORNUMERIC,CREATEDBY,CREATEDON,COMMENTS) "
							+ "VALUES (?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP,'Y',?,?,?,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, (String) question.get("QUESTIONID"));
					preparedStatement.setString(2, ((String) question.get("QUESTION")).replaceAll("\n", " ").replaceAll("'", ""));
					preparedStatement.setString(3, (String) question.get("INPUTTYPE"));
					preparedStatement.setString(4, (String) question.get("INPUTOPTIONSLIST"));
					preparedStatement.setString(5, (String) question.get("ISSUPERPARENT"));
					preparedStatement.setString(6, (String) question.get("HASPARENT"));
					preparedStatement.setString(7, (String) question.get("PARENTQSIDS"));
					preparedStatement.setString(8, (String) question.get("HASRISKIMPACT"));
					preparedStatement.setString(9, (String) question.get("assessmentUnit"));
					preparedStatement.setString(10, (String) question.get("category"));
					preparedStatement.setString(11, (String) question.get("subCategory"));
					preparedStatement.setString(12, (String) question.get("INPUTOPTIONSLISTFORNUMERIC"));
					preparedStatement.setString(13, (String) question.get("CREATEDBY"));
					preparedStatement.setString(14, (String) question.get("CREATEDON"));
					preparedStatement.setString(15, (String) question.get("COMMENTS"));
					preparedStatement.executeUpdate();
				}
			}
			if(formConfigurationModel.controlsReviewQsList.size() > 0) {
				
				for(Map<String, Object> question: formConfigurationModel.controlsReviewQsList) {
					
					query = "INSERT INTO COMAML_CM.TB_RISKASSESSQUESTIONSCONFIG(QUESTIONID, QUESTION, INPUTTYPE, INPUTOPTIONSLIST, "
							+ "		ISSUPERPARENT, HASPARENT, PARENTQSIDS, HASRISKIMPACT, ASSESSMENTUNIT,CATEGORY, SUBCATEGORY, UPDATETIMESTAMP,"
							+ "		ISENABLED, INPUTOPTIONSLISTFORNUMERIC,SUBSUBCATEG,CREATEDBY,CREATEDON,COMMENTS) "
							+ "VALUES (?,?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP,'Y',?,?,?,?,?)";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, (String) question.get("QUESTIONID"));
					preparedStatement.setString(2, ((String) question.get("QUESTION")).replaceAll("\n", " ").replaceAll("'", ""));
					preparedStatement.setString(3, (String) question.get("INPUTTYPE"));
					preparedStatement.setString(4, (String) question.get("INPUTOPTIONSLIST"));
					preparedStatement.setString(5, (String) question.get("ISSUPERPARENT"));
					preparedStatement.setString(6, (String) question.get("HASPARENT"));
					preparedStatement.setString(7, (String) question.get("PARENTQSIDS"));
					preparedStatement.setString(8, (String) question.get("HASRISKIMPACT"));
					preparedStatement.setString(9, (String) question.get("assessmentUnit"));
					preparedStatement.setString(10, ((String) question.get("category")).replace("&amp;","&"));
					preparedStatement.setString(11, ((String) question.get("subCategory")).replace("&amp;","&"));
					preparedStatement.setString(12, (String) question.get("INPUTOPTIONSLISTFORNUMERIC"));
					preparedStatement.setString(13, ((String) question.get("subSubCategory")).replace("&amp;","&"));
					preparedStatement.setString(14, (String) question.get("CREATEDBY"));
					preparedStatement.setString(15, (String) question.get("CREATEDON"));
					preparedStatement.setString(16, (String) question.get("COMMENTS"));
					preparedStatement.executeUpdate();
				}
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveRiskAssesesmentForm(FormDataModel formData) {
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "";
		try{
			//removing previous general details and status details of the existing form
			query =   "DELETE FROM COMAML_CM.TB_RAFORMGENERALDETAILS "
					+ " WHERE ASSESSMENTUNIT = ? "
					+ "   AND CMREFNO = ?";
			preparedStatement = connection.prepareStatement(query);
			
			preparedStatement.setString(1, formData.assessmentUnit);
			preparedStatement.setString(2, formData.cmRefNo);
			preparedStatement.executeUpdate();
			
			// inserting the general and status details of the form
			query = 	"INSERT INTO COMAML_CM.TB_RAFORMGENERALDETAILS(CMREFNO,ASSESSMENTUNIT,ASSESSMENTPERIOD,POCNAME,POCEMAIL,COMPLIANCE1,COMPLIANCE2,BUSINESS1,"
					   +"		BUSINESS2,OTHER1,OTHER2,KEYBUSINESSNAME1,KEYBUSINESSNAME2,KEYBUSINESSNAME3,"
					   +"       KEYBUSINESSROLE1,KEYBUSINESSROLE2,KEYBUSINESSROLE3,FORMSTATUS,CMOFFICERCODE,"
					   +"       CMOFFICERTIMESTAMP,CMOFFICERCOMMENTS,CMMANAGERCODE,"
					   +"		CMMANAGERTIMESTAMP,CMMANAGERCOMMENTS,UPDATEDTIMESTAMP,FORMDATA)"
					   +"VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,FUN_CHARTODATE(?),?,?,FUN_CHARTODATE(?),?,SYSTIMESTAMP,?) ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, formData.cmRefNo);
			preparedStatement.setString(2, formData.assessmentUnit);
			preparedStatement.setString(3, formData.generalAndStatusDetails.ASSESSMENTPERIOD);
			preparedStatement.setString(4, formData.generalAndStatusDetails.POCNAME);
			preparedStatement.setString(5, formData.generalAndStatusDetails.POCEMAIL);
			preparedStatement.setString(6, formData.generalAndStatusDetails.COMPLIANCE1);
			preparedStatement.setString(7, formData.generalAndStatusDetails.COMPLIANCE2);
			preparedStatement.setString(8, formData.generalAndStatusDetails.BUSINESS1);
			preparedStatement.setString(9, formData.generalAndStatusDetails.BUSINESS2);
			preparedStatement.setString(10, formData.generalAndStatusDetails.OTHER1);
			preparedStatement.setString(11, formData.generalAndStatusDetails.OTHER2);
			preparedStatement.setString(12, formData.generalAndStatusDetails.KEYBUSINESSNAME1);
			preparedStatement.setString(13, formData.generalAndStatusDetails.KEYBUSINESSNAME2);
			preparedStatement.setString(14, formData.generalAndStatusDetails.KEYBUSINESSNAME3);
			preparedStatement.setString(15, formData.generalAndStatusDetails.KEYBUSINESSROLE1);
			preparedStatement.setString(16, formData.generalAndStatusDetails.KEYBUSINESSROLE2);
			preparedStatement.setString(17, formData.generalAndStatusDetails.KEYBUSINESSROLE3);
			preparedStatement.setString(18, formData.generalAndStatusDetails.FORMSTATUS);
			preparedStatement.setString(19, formData.generalAndStatusDetails.CMOFFICERCODE);
			preparedStatement.setString(20, formData.generalAndStatusDetails.CMOFFICERTIMESTAMP);
			preparedStatement.setString(21, formData.generalAndStatusDetails.CMOFFICERCOMMENTS);
			preparedStatement.setString(22, formData.generalAndStatusDetails.CMMANAGERCODE);
			preparedStatement.setString(23, formData.generalAndStatusDetails.CMMANAGERTIMESTAMP);
			preparedStatement.setString(24, formData.generalAndStatusDetails.CMMANAGERCOMMENTS);
			preparedStatement.setString(25, formData.formData);
			preparedStatement.executeUpdate();
			
			//inserting comment logs for the form
			query = "  INSERT INTO COMAML_CM.TB_RAFORMCOMMENTSLOG(CMREFNO,ASSESSMENTUNIT,USERNAME,USERROLE,COMMENTS,"
					+ "       UPDATEDTIMESTAMP)"
					+ "VALUES (?,?,?,?,?,SYSTIMESTAMP)";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, formData.cmRefNo);
			preparedStatement.setString(2, formData.assessmentUnit);
			preparedStatement.setString(3, formData.userName);
			preparedStatement.setString(4, formData.userRole);
			if(formData.userRole.endsWith("OFFICER"))
				preparedStatement.setString(5, formData.generalAndStatusDetails.CMOFFICERCOMMENTS);
			else
				preparedStatement.setString(5, formData.generalAndStatusDetails.CMMANAGERCOMMENTS);
			preparedStatement.executeUpdate();
			
			//removing previous category wise risk rating details of the existing form
			query =   "DELETE FROM COMAML_CM.TB_RARISKRATINGS "
					+ " WHERE ASSESSMENTUNIT = ? "
					+ "   AND CMREFNO = ?";
			preparedStatement = connection.prepareStatement(query);
			
			preparedStatement.setString(1, formData.assessmentUnit);
			preparedStatement.setString(2, formData.cmRefNo);
			preparedStatement.executeUpdate();
			
			// inserting category wise risk ratings
			for(int x = 0; x < formData.categoryRiskRatings.categoryRisksList.size();x++) {
				query = "  INSERT INTO COMAML_CM.TB_RARISKRATINGS(CMREFNO,CATEGORY,SUBCATEGORY,"
						+ "		  SYSGENRISKRATING, PROVRISKRATING, FINALRISKRATING, REASONFORDEVIATION,"
						+ "       ASSESSMENTUNIT,UPDATEDTIMESTAMP) "
						+ "VALUES (?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, formData.cmRefNo);
				preparedStatement.setString(2, ((LinkedHashMap<String,String>) formData.categoryRiskRatings.categoryRisksList.get(x)).get("categoryName").replace("&amp;", "&"));
				preparedStatement.setString(3, ((LinkedHashMap<String,String>) formData.categoryRiskRatings.categoryRisksList.get(x)).get("categoryName").replace("&amp;", "&"));
				preparedStatement.setString(4, ((LinkedHashMap<String,String>) formData.categoryRiskRatings.categoryRisksList.get(x)).get("sysgenRisk"));
				preparedStatement.setString(5, ((LinkedHashMap<String,String>) formData.categoryRiskRatings.categoryRisksList.get(x)).get("provisionalRisk"));
				preparedStatement.setString(6, ((LinkedHashMap<String,String>) formData.categoryRiskRatings.categoryRisksList.get(x)).get("finalRisk"));
				preparedStatement.setString(7, ((LinkedHashMap<String,String>) formData.categoryRiskRatings.categoryRisksList.get(x)).get("reasonsForDeviation"));
				preparedStatement.setString(8, formData.assessmentUnit);
				
				preparedStatement.executeUpdate();
				
			}
			// inserting category and sub category wise inherent risk ratings
			for(int x = 0; x < formData.categSubcategInherentRiskRatings.inherentRisksList.size();x++) {
				query = "  INSERT INTO COMAML_CM.TB_RARISKRATINGS(CMREFNO,CATEGORY,SUBCATEGORY,"
						+ "		  INHERENTRISKRATING,"
						+ "       ASSESSMENTUNIT,UPDATEDTIMESTAMP) "
						+ "VALUES (?,?,?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, formData.cmRefNo);
				preparedStatement.setString(2, ((LinkedHashMap<String,String>) formData.categSubcategInherentRiskRatings.inherentRisksList.get(x)).get("category").replace("&amp;", "&"));
				preparedStatement.setString(3, ((LinkedHashMap<String,String>) formData.categSubcategInherentRiskRatings.inherentRisksList.get(x)).get("subCategory").replace("&amp;", "&"));
				preparedStatement.setString(4, ((LinkedHashMap<String,String>) formData.categSubcategInherentRiskRatings.inherentRisksList.get(x)).get("inherentRisk"));
				preparedStatement.setString(5, formData.assessmentUnit);
				preparedStatement.executeUpdate();
				
			}
			
			for(int x = 0; x < formData.crCategoryRiskRatings.crCategoryRisksList.size();x++) {
				query = "  INSERT INTO COMAML_CM.TB_RARISKRATINGS(CMREFNO,CATEGORY,SUBCATEGORY,"
						+ "		  SYSGENRISKRATING, PROVRISKRATING, FINALRISKRATING, REASONFORDEVIATION,"
						+ "       ASSESSMENTUNIT,UPDATEDTIMESTAMP) "
						+ "VALUES (?,?,?,?,?,?,?,?,SYSTIMESTAMP)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, formData.cmRefNo);
				preparedStatement.setString(2, ((LinkedHashMap<String,String>) formData.crCategoryRiskRatings.crCategoryRisksList.get(x)).get("categoryName").replace("&amp;", "&"));
				preparedStatement.setString(3, ((LinkedHashMap<String,String>) formData.crCategoryRiskRatings.crCategoryRisksList.get(x)).get("categoryName").replace("&amp;", "&"));
				preparedStatement.setString(4, ((LinkedHashMap<String,String>) formData.crCategoryRiskRatings.crCategoryRisksList.get(x)).get("sysgenRisk"));
				preparedStatement.setString(5, ((LinkedHashMap<String,String>) formData.crCategoryRiskRatings.crCategoryRisksList.get(x)).get("provisionalRisk"));
				preparedStatement.setString(6, ((LinkedHashMap<String,String>) formData.crCategoryRiskRatings.crCategoryRisksList.get(x)).get("finalRisk"));
				preparedStatement.setString(7, ((LinkedHashMap<String,String>) formData.crCategoryRiskRatings.crCategoryRisksList.get(x)).get("reasonsForDeviation"));
				preparedStatement.setString(8, formData.assessmentUnit);
				
				preparedStatement.executeUpdate();
				
			}
			query = "DELETE FROM COMAML_CM.TB_RAQUESTIONRESPONSES WHERE CMREFNO = '"+formData.cmRefNo+"'";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.executeQuery(query);
			for(int x = 0; x < formData.questionResponses.questionsResponseList.size(); x++) {
				
				query = "  INSERT INTO COMAML_CM.TB_RAQUESTIONRESPONSES(CMREFNO,QUESTIONID,"
						+ "		  QINPUT,QRESULT,QIMPACTCRITERIA,QLIKELYHOOD,QDESIGNRATING,"
						+ "       QOPERATINGRATING,QOBSERVATION,QDOCREFSAMTESTING,UPDATEDTIMESTAMP,ASSESSMENTUNIT,QINHERENTRISK) "
						+ "VALUES (?,?,?,?,?,?,?,?,?,?,SYSTIMESTAMP,?,?)";
				preparedStatement = connection.prepareStatement(query);
				preparedStatement.setString(1, formData.cmRefNo);
				preparedStatement.setString(2, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QUESTIONID"));
				System.out.println("qid:"+((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QUESTIONID"));
				System.out.println("qinput again:"+((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QINPUT"));
				System.out.println("response:"+((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).toString());
				preparedStatement.setString(3, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QINPUT"));
				preparedStatement.setString(4, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QRESULT"));
				preparedStatement.setString(5, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QIMPACTCRITERIA"));
				preparedStatement.setString(6, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QLIKELYHOOD"));
				preparedStatement.setString(7, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QDESIGNRATING"));
				preparedStatement.setString(8, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QOPERATINGRATING"));
				preparedStatement.setString(9, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QOBSERVATION"));
				preparedStatement.setString(10, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QDOCREFSAMTESTING"));
				preparedStatement.setString(11, formData.assessmentUnit );
				preparedStatement.setString(12, ((LinkedHashMap<String,String>) formData.questionResponses.questionsResponseList.get(x)).get("QINHERENTRISK"));
				preparedStatement.executeUpdate();
			}

			
			
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
	}
	
	
	@Override
	public List<Map<String, String>> searchRiskAssessmentData(String ASSESSMENTUNIT, String COMPASSREFERENCENO){
//		System.out.println("inhere");
		List<Map<String, String>> dataList = new Vector<Map<String, String>>();
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "SELECT CMREFNO COMPASSREFNO, ASSESSMENTUNIT, ASSESSMENTPERIOD, "+
						"		DECODE(FORMSTATUS, 'CMO-P', 'Pending with CM Officer', "+
						"			   'CMM-P', 'Pending with CM Manager', "+
						"			   'CMM-A', 'Approved by CM Manager', "+
						"			   'CMM-R', 'Rejected by CM Manager') STATUS, "+
						"		DECODE(FORMSTATUS, 'CMO-P', CMOFFICERCODE, " + 
						"			   'CMM-P', CMOFFICERCODE, " + 
						"			   'CMM-A', CMMANAGERCODE, " + 
						"			   'CMM-R', CMMANAGERCODE) UPDATEDBY, "+
						"		FUN_DATETIMETOCHAR(DECODE(FORMSTATUS, 'CMO-P', CMOFFICERTIMESTAMP, " + 
						"			   'CMM-P', CMOFFICERTIMESTAMP, " + 
						"			   'CMM-A', CMMANAGERTIMESTAMP, " + 
						"			   'CMM-R', CMMANAGERTIMESTAMP)) UPDATEDON, "+
						"       FORMSTATUS STATUSCODE "+
						"  FROM TB_RAFORMGENERALDETAILS "+
						" WHERE 1=1 ";
		
		if(COMPASSREFERENCENO != null && !"".equals(COMPASSREFERENCENO)){
			query = query + " AND CMREFNO = '"+COMPASSREFERENCENO+"' ";
		}
		
		if(ASSESSMENTUNIT != null && !"".equals(ASSESSMENTUNIT)){
			query = query + " AND ASSESSMENTUNIT = '"+ASSESSMENTUNIT+"' ";
		}
		
		query = query + " ORDER BY UPDATEDTIMESTAMP DESC ";
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
	
	@Override
	public String generateCompassRefNo() {
		String COMPASSREFNO = "";
		Date date = new Date();
		SimpleDateFormat formatter = new SimpleDateFormat("ddMMyyyy");
		String strDate= formatter.format(date);
		Random random = new Random();
		
		COMPASSREFNO = "CM"+strDate+random.nextInt(10000);
		return COMPASSREFNO;
	}
	@Override
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
	
	@Override
	public Map<String, Object> generateCMReportNew(String compassRefNo, String assessmentUnit, String userCode, String userRole, String ipAddress){
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
		
		//System.out.println("assessmentUnit in NEW controller: "+assessmentUnit);
		
    	Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETCMREPORTDATANEW(?,?,?,?,?,?,?,?,?,?,?,?)}");
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
				
				//System.out.println("sheetName: "+sheetName+" "+"resultSet: "+resultSet);
				
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
	    	if(assessmentUnit.equals("Treasury"))
	    	{
	    		mainMap.put("Treasury_Report", innerMap);
	    	}
	    	if(assessmentUnit.equals("RetailLiabilities"))
	    	{
	    		mainMap.put("Retail_Liabilities_Report", innerMap);
	    	}
	    	if(assessmentUnit.equals("RetailAssets"))
	    	{
	    		mainMap.put("Retail_Assets_Report", innerMap);
	    	}
	    	if(assessmentUnit.equals("WholesaleBanking"))
	    	{
	    		mainMap.put("Wholesale_Banking_Report", innerMap);
	    	}
	    	//mainMap.put(sheetName, innerMap);
		}
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, callableStatement, tabNameResultSet, null);
		}
		return mainMap;
	}
	
	@Override
	public Map<String, Object> generateCMReportSummary(String assessmentPeriod, String userCode, String userRole, String ipAddress){
		System.out.println("In generateCMReportSummary dao assessmentPeriod: "+assessmentPeriod);
		
		Map<String, Object> mainMap = new LinkedHashMap<String, Object>();
    	Connection connection = null;
		CallableStatement callableStatement = null;
        ResultSet tabNameResultSet = null;
		Map<String, ResultSet> resultSetMap = new LinkedHashMap<String, ResultSet>();
		String[] arrTabName = null;
		try{
			connection = connectionUtil.getConnection();
			callableStatement = connection.prepareCall("{CALL "+schemaName+"STP_GETCMREPORTDATASUMMARY(?,?,?,?,?,?,?,?,?,?,?,?)}");
			callableStatement.setString(1, assessmentPeriod);
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
	public Map<Object, Object> getRASummaryData(int assessmentPeriod) {
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		String query =  "";
		
		
		
		ArrayList<String> assessmentUnitList = new ArrayList<String>();
		assessmentUnitList.add("Treasury");
		assessmentUnitList.add("RetailLiabilities");
		assessmentUnitList.add("RetailAssets");
		assessmentUnitList.add("WholesaleBanking");
		
		
		ArrayList<String> inherentRiskCategoryList = new ArrayList<String>();
		inherentRiskCategoryList.add("customer");
		inherentRiskCategoryList.add("geography");
		inherentRiskCategoryList.add("products and services");
		inherentRiskCategoryList.add("transactions");
		inherentRiskCategoryList.add("delivery channels");
		
		ArrayList<String> internalControlCategoryList = new ArrayList<String>();
		internalControlCategoryList.add("Governance & Management Oversight");
		internalControlCategoryList.add("Customer Due Diligence & Risk Management");
		internalControlCategoryList.add("Transactions Monitoring");
		internalControlCategoryList.add("Internal Quality Assurance and Compliance Testing");
		internalControlCategoryList.add("Name/Sanctions Screening");
		internalControlCategoryList.add("Training");
		internalControlCategoryList.add("Foreign Correspondent Banking Relationships");
		internalControlCategoryList.add("Internal Audit");
		internalControlCategoryList.add("Reporting Requirements");
		
		Map<Object,Object> raSummaryData = new LinkedHashMap<Object, Object>();
		Map<Object,Object> riskData = new LinkedHashMap<Object, Object>();
		for(String assessmentUnit:assessmentUnitList) {
			
			Map<Object,Object> auSummaryData = new LinkedHashMap<Object, Object>();
			try{
				Map<String,Object> inherentRisk = new LinkedHashMap<String,Object>();
				for(String category : inherentRiskCategoryList) {
					
					query = " SELECT A.FINALRISKRATING RISK FROM COMAML_CM.TB_RARISKRATINGS A "
							+ " LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.CATEGORY = ?"
							+ "  AND A.SUBCATEGORY = ?"
							+ "  AND B.ASSESSMENTPERIOD = ?"
							+ "	 AND A.ASSESSMENTUNIT = ?"
							+ "ORDER BY B.UPDATEDTIMESTAMP";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, category);
					preparedStatement.setString(2, category);
					preparedStatement.setString(3, String.valueOf(assessmentPeriod));
					preparedStatement.setString(4, assessmentUnit);
					resultSet = preparedStatement.executeQuery();
					if(resultSet.next()) {
						inherentRisk.put(category, Double.parseDouble(resultSet.getString("RISK")));
					}
					else {
						inherentRisk.put(category, 0.0);
					}
				}
				
				auSummaryData.put("INHERENTRISKS", inherentRisk);
				
				Map<String,Object> internalControl = new LinkedHashMap<String,Object>();
				for(String category : internalControlCategoryList) {
					
					query = " SELECT A.FINALRISKRATING RISK FROM COMAML_CM.TB_RARISKRATINGS A "
							+ " LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.CATEGORY = ?"
							+ "  AND A.SUBCATEGORY = ?"
							+ "  AND B.ASSESSMENTPERIOD = ?"
							+ "	 AND A.ASSESSMENTUNIT = ?"
							+ "ORDER BY B.UPDATEDTIMESTAMP";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, category);
					preparedStatement.setString(2, category);
					preparedStatement.setString(3, String.valueOf(assessmentPeriod));
					preparedStatement.setString(4, assessmentUnit);

					resultSet = preparedStatement.executeQuery();
					if(resultSet.next()) {
						internalControl.put(category, Double.parseDouble(resultSet.getString("RISK")));
					}
					else {
						internalControl.put(category, 0.0);
					}
				}
				
				auSummaryData.put("INTERNALCONTROLRISKS", internalControl);
			}catch(Exception e){
				e.printStackTrace();
			}
			riskData.put(assessmentUnit,auSummaryData);
		}
		raSummaryData.put("auList", assessmentUnitList);
		raSummaryData.put("riskRatings", riskData);
		raSummaryData.put("inherentRiskCategories", inherentRiskCategoryList);
		raSummaryData.put("internalControlRiskCategories", internalControlCategoryList);
		
		connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		return raSummaryData;
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
		
		//System.out.println("graphDataPoints: "+graphDataPoints);
		
		return graphDataPoints;	
	}
	
	@Override
	public Map<String, Object> getGraphDataPointsNew(String cmRefNo){
		Map<String, Object> graphDataPoints = new LinkedHashMap<String,Object>();
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = "SELECT CATEGORY, FINALRISKRATING, "
					+ "CASE WHEN CATEGORY = 'customer' THEN FINALRISKRATING*0.30 "
					+ "WHEN CATEGORY = 'geography' THEN FINALRISKRATING*0.25"
					+ " WHEN CATEGORY = 'products and services' THEN FINALRISKRATING*0.25 "
					+ "WHEN CATEGORY = 'transactions' THEN FINALRISKRATING*0.10 "
					+ "WHEN CATEGORY = 'delivery channels' THEN FINALRISKRATING*0.10 "
					+ "ELSE 0.0 END "
					+ "AS WEIGHTED_SCORE FROM COMAML_CM.TB_RARISKRATINGS "
					+ "WHERE CATEGORY = SUBCATEGORY "
					+ "AND CATEGORY IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND CMREFNO = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, cmRefNo);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("FINALRISKRATING"));
				data.put("WEIGHTED_SCORE",resultSet.getString("WEIGHTED_SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("InherentRisk", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		try{
			String query = "SELECT CATEGORY, FINALRISKRATING, "
					+ "CASE WHEN CATEGORY = 'Training' THEN FINALRISKRATING*0.15 "
					+ "WHEN CATEGORY = 'Reporting Requirements' THEN FINALRISKRATING*0.05 "
					+ "WHEN CATEGORY = 'Internal Audit' THEN FINALRISKRATING*0.10 "
					+ "WHEN CATEGORY = 'Foreign Correspondent Banking Relationships' THEN FINALRISKRATING*0.05 "
					+ "WHEN CATEGORY = 'Name/Sanctions Screening' THEN FINALRISKRATING*0.10 "
					+ "WHEN CATEGORY = 'Governance & Management Oversight' THEN FINALRISKRATING*0.10 "
					+ "WHEN CATEGORY = 'Internal Quality Assurance and Compliance Testing' THEN FINALRISKRATING*0.10 "
					+ "WHEN CATEGORY = 'Customer Due Diligence & Risk Management' THEN FINALRISKRATING*0.25 "
					+ "WHEN CATEGORY = 'Transactions Monitoring' THEN FINALRISKRATING*0.10 "
					+ "ELSE 0.0 END "
					+ "AS WEIGHTED_SCORE FROM COMAML_CM.TB_RARISKRATINGS "
					+ "WHERE CATEGORY = SUBCATEGORY "
					+ "AND CATEGORY NOT IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND CMREFNO = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, cmRefNo);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("FINALRISKRATING"));
				data.put("WEIGHTED_SCORE",resultSet.getString("WEIGHTED_SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("InternalControl", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		//System.out.println("graphDataPoints: "+graphDataPoints);
		
		return graphDataPoints;	
	}
	
	
	@Override
	public Map<String, Object> getGraphDataPointsSummary(String assessmentPeriod){
		Map<String, Object> graphDataPoints = new LinkedHashMap<String,Object>();
		
		//System.out.println("In mixedChartSummary dao assessmentPeriod is "+assessmentPeriod);
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		//Treasury
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'Treasury'"
					+ "AND A.CATEGORY IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("TreasuryInherentRisk", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'Treasury'"
					+ "AND A.CATEGORY NOT IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("TreasuryInternalControl", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		
		//RetailLiabilities
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'RetailLiabilities'"
					+ "AND A.CATEGORY IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("RetailLiabilitiesInherentRisk", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'RetailLiabilities'"
					+ "AND A.CATEGORY NOT IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("RetailLiabilitiesInternalControl", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		//RetailAssets
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'RetailAssets'"
					+ "AND A.CATEGORY IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("RetailAssetsInherentRisk", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'RetailAssets'"
					+ "AND A.CATEGORY NOT IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("RetailAssetsInternalControl", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		
		//WholesaleBanking
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'WholesaleBanking'"
					+ "AND A.CATEGORY IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("WholesaleBankingInherentRisk", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		try{
			String query = "SELECT A.CATEGORY AS CATEGORY, A.FINALRISKRATING AS SCORE "
					+ "FROM COMAML_CM.TB_RARISKRATINGS A  "
					+ "LEFT OUTER JOIN "
					+ "TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO  "
					+ "WHERE A.CATEGORY = A.SUBCATEGORY "
					+ "AND A.ASSESSMENTUNIT = 'WholesaleBanking'"
					+ "AND A.CATEGORY NOT IN ('customer', 'geography', 'products and services', 'transactions', 'delivery channels')"
					+ "AND B.ASSESSMENTPERIOD = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				data.put("CATEGORY",resultSet.getString("CATEGORY"));
				data.put("FINALRISKRATING",resultSet.getString("SCORE"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("WholesaleBankingInternalControl", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		//DESIGN
		//Treasury
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
					+ "AND A.QDESIGNRATING = 'E' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("E_Design_T", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
					+ "AND A.QDESIGNRATING = 'NA' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("NA_Design_T", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
					+ "AND A.QDESIGNRATING = 'NI' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("NI_Design_T", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
					+ "AND A.QDESIGNRATING = 'NC' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("NC_Design_T", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		//RL
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
					+ "AND A.QDESIGNRATING = 'E' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("E_Design_RL", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
					+ "AND A.QDESIGNRATING = 'NA' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("NA_Design_RL", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
					+ "AND A.QDESIGNRATING = 'NI' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("NI_Design_RL", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		try{
			String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
					+ "FROM TB_RAQUESTIONRESPONSES A "
					+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
					+ "ON A.CMREFNO = B.CMREFNO "
					+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
					+ "AND A.QDESIGNRATING = 'NC' "
					+ "AND B.ASSESSMENTPERIOD = ? "
					+ "GROUP BY A.QDESIGNRATING "
					+ "ORDER BY QDESIGNRATING";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, assessmentPeriod);
			resultSet = preparedStatement.executeQuery();
			ArrayList<Object> dataPoints = new ArrayList<Object>();
			while(resultSet.next()) {
				Map<String,String> data = new LinkedHashMap<String, String>();
				//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
				data.put("TYPE",resultSet.getString("QDESIGNRATING"));
				data.put("TOTAL",resultSet.getString("TOTAL"));
				dataPoints.add(data);;
			}
			graphDataPoints.put("NC_Design_RL", dataPoints);			
		}
		catch(Exception e){
			e.printStackTrace();
		}
		
		//RA
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
							+ "AND A.QDESIGNRATING = 'E' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("E_Design_RA", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
							+ "AND A.QDESIGNRATING = 'NA' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NA_Design_RA", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
							+ "AND A.QDESIGNRATING = 'NI' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NI_Design_RA", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
							+ "AND A.QDESIGNRATING = 'NC' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NC_Design_RA", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				//WB
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
							+ "AND A.QDESIGNRATING = 'E' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("E_Design_WB", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
							+ "AND A.QDESIGNRATING = 'NA' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NA_Design_WB", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
							+ "AND A.QDESIGNRATING = 'NI' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NI_Design_WB", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QDESIGNRATING, COUNT(A.QDESIGNRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
							+ "AND A.QDESIGNRATING = 'NC' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QDESIGNRATING "
							+ "ORDER BY QDESIGNRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QDESIGNRATING"));	
						data.put("TYPE",resultSet.getString("QDESIGNRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NC_Design_WB", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}

		
				//OPEARATING
				//Treasury
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
							+ "AND A.QOPERATINGRATING = 'E' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("E_Operating_T", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
							+ "AND A.QOPERATINGRATING = 'NA' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NA_Operating_T", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
							+ "AND A.QOPERATINGRATING = 'NI' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
						//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NI_Operating_T", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'Treasury' "
							+ "AND A.QOPERATINGRATING = 'NC' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
					//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NC_Operating_T", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				//RL
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
							+ "AND A.QOPERATINGRATING = 'E' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
					//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("E_Operating_RL", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
							+ "AND A.QOPERATINGRATING = 'NA' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
					//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NA_Operating_RL", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
							+ "AND A.QOPERATINGRATING = 'NI' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
					//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NI_Operating_RL", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				try{
					String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
							+ "FROM TB_RAQUESTIONRESPONSES A "
							+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
							+ "ON A.CMREFNO = B.CMREFNO "
							+ "WHERE A.ASSESSMENTUNIT = 'RetailLiabilities' "
							+ "AND A.QOPERATINGRATING = 'NC' "
							+ "AND B.ASSESSMENTPERIOD = ? "
							+ "GROUP BY A.QOPERATINGRATING "
							+ "ORDER BY QOPERATINGRATING";
					preparedStatement = connection.prepareStatement(query);
					preparedStatement.setString(1, assessmentPeriod);
					resultSet = preparedStatement.executeQuery();
					ArrayList<Object> dataPoints = new ArrayList<Object>();
					while(resultSet.next()) {
						Map<String,String> data = new LinkedHashMap<String, String>();
					//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
						data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
						data.put("TOTAL",resultSet.getString("TOTAL"));
						dataPoints.add(data);;
					}
					graphDataPoints.put("NC_Operating_RL", dataPoints);			
				}
				catch(Exception e){
					e.printStackTrace();
				}
				
				//RA
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND A.QOPERATINGRATING = 'E' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("E_Operating_RA", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND A.QOPERATINGRATING = 'NA' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("NA_Operating_RA", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND A.QOPERATINGRATING = 'NI' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("NI_Operating_RA", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND A.QOPERATINGRATING = 'NC' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("NC_Operating_RA", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						//WB
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND A.QOPERATINGRATING = 'E' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("E_Operating_WB", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND A.QOPERATINGRATING = 'NA' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("NA_Operating_WB", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND A.QOPERATINGRATING = 'NI' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("NI_Operating_WB", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT A.QOPERATINGRATING, COUNT(A.QOPERATINGRATING) AS TOTAL "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND A.QOPERATINGRATING = 'NC' "
									+ "AND B.ASSESSMENTPERIOD = ? "
									+ "GROUP BY A.QOPERATINGRATING "
									+ "ORDER BY QOPERATINGRATING";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("TYPE",resultSet.getString("QOPERATINGRATING"));
								data.put("TOTAL",resultSet.getString("TOTAL"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("NC_Operating_WB", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
				//IMPACT AND LIKELIHOOD
				//Treasury
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'A%' "
									+ "AND A.ASSESSMENTUNIT = 'Treasury' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("T_CUSTOMER", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'B%' "
									+ "AND A.ASSESSMENTUNIT = 'Treasury' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("T_GEO", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'C%' "
									+ "AND A.ASSESSMENTUNIT = 'Treasury' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("T_PROD_SERV", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'D%' "
									+ "AND A.ASSESSMENTUNIT = 'Treasury' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("T_TRANS", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'E%' "
									+ "AND A.ASSESSMENTUNIT = 'Treasury' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("T_DC", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						//RetailLiabilities
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'A%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailLiabilities' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RL_CUSTOMER", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'B%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailLiabilities' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RL_GEO", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'C%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailLiabilities' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RL_PROD_SERV", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'D%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailLiabilities' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RL_TRANS", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'E%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailLiabilities' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RL_DC", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}			

						//RetailAssets
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'A%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RA_CUSTOMER", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'B%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RA_GEO", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'C%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RA_PROD_SERV", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'D%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RA_TRANS", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'E%' "
									+ "AND A.ASSESSMENTUNIT = 'RetailAssets' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("RA_DC", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}			
						
						//WholesaleBanking
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'A%' "
									+ "AND A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("WB_CUSTOMER", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'B%' "
									+ "AND A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("WB_GEO", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'C%' "
									+ "AND A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("WB_PROD_SERV", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}	
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'D%' "
									+ "AND A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("WB_TRANS", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}
						
						try{
							String query = "SELECT CASE WHEN COUNT(A.QIMPACTCRITERIA) > 0 THEN NVL(SUM(A.QIMPACTCRITERIA), 0)/COUNT(A.QIMPACTCRITERIA) ELSE 0 END AS RESULT_IMPACT, "
									+ "CASE WHEN COUNT(A.QLIKELYHOOD) > 0 THEN NVL(SUM(A.QLIKELYHOOD), 0)/COUNT(A.QLIKELYHOOD) ELSE 0 END AS RESULT_LIKELYHOOD "
									+ "FROM TB_RAQUESTIONRESPONSES A "
									+ "LEFT OUTER JOIN TB_RAFORMGENERALDETAILS B  "
									+ "ON A.CMREFNO = B.CMREFNO "
									+ "WHERE QUESTIONID like 'E%' "
									+ "AND A.ASSESSMENTUNIT = 'WholesaleBanking' "
									+ "AND B.ASSESSMENTPERIOD = ? ";
							preparedStatement = connection.prepareStatement(query);
							preparedStatement.setString(1, assessmentPeriod);
							resultSet = preparedStatement.executeQuery();
							ArrayList<Object> dataPoints = new ArrayList<Object>();
							while(resultSet.next()) {
								Map<String,String> data = new LinkedHashMap<String, String>();
							//System.out.println("RESULT"+resultSet.getString("QOPERATINGRATING"));	
								data.put("IMPACT",resultSet.getString("RESULT_IMPACT"));
								data.put("LIKELYHOOD",resultSet.getString("RESULT_LIKELYHOOD"));
								dataPoints.add(data);;
							}
							graphDataPoints.put("WB_DC", dataPoints);			
						}
						catch(Exception e){
							e.printStackTrace();
						}			

		finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		
		//System.out.println("graphDataPoints: "+graphDataPoints);
		
		return graphDataPoints;	
	}
	
	
	@Override
	public String saveImageUrlData(String imageUrl){
		//System.out.println("saveImageUrlData in NEW DAO CALLED!!");
		//System.out.println("imageURL data: "+imageUrl);
		
		String imageUrlData = imageUrl;
		String[] parts = imageUrlData.split("@~@");
		String defaultVALUECHART = parts[0];
		String t_ResidualRISK = parts[1];
		String rl_ResidualRISK = parts[2];
		String ra_ResidualRISK = parts[3];
		String wb_ResidualRISK = parts[4];
		String residualRISK = parts[5]; 
		String assessmentWISECAT = parts[6];
		String bl_IR = parts[7]; 
		String bl_IC = parts[8];
		String a_TOTALWEIGHTEDSCOREIR = parts[9];
		String a_TOTALWEIGHTEDSCOREIC = parts[10];
		String s_TotalTresuryIR = parts[11];
		String s_TotalTresuryIC = parts[12];
		String s_TotalRetailLiabiltiesIR = parts[13];
		String s_totalRetailLiabiltiesIC = parts[14];
		String s_TotalRetailAssetsIR = parts[15];
		String s_TotalRetailAssetsIC = parts[16];
		String s_TotalWholesaleIR = parts[17];
		String s_TotalWholesaleIC = parts[18];
		
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
					int index = (int)(AlphaNumericString.length() * Math.random());
					
					// add Character one by one in end of sb
					sb.append(AlphaNumericString.charAt(index));
					}
		id = sb.toString();

		try{
			String query = "INSERT INTO COMAML_CM.TB_IMAGEDATA VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, SYSTIMESTAMP) ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, id);
			preparedStatement.setString(2, defaultVALUECHART);
			preparedStatement.setString(3, t_ResidualRISK);
			preparedStatement.setString(4, rl_ResidualRISK);
			preparedStatement.setString(5, ra_ResidualRISK);
			preparedStatement.setString(6, wb_ResidualRISK);
			preparedStatement.setString(7, residualRISK);
			preparedStatement.setString(8, assessmentWISECAT);
			preparedStatement.setString(9, bl_IR);
			preparedStatement.setString(10, bl_IC);
			preparedStatement.setString(11, a_TOTALWEIGHTEDSCOREIR);
			preparedStatement.setString(12, a_TOTALWEIGHTEDSCOREIC);
			preparedStatement.setString(13, s_TotalTresuryIR);
			preparedStatement.setString(14, s_TotalTresuryIC);
			preparedStatement.setString(15, s_TotalRetailLiabiltiesIR);
			preparedStatement.setString(16, s_totalRetailLiabiltiesIC);
			preparedStatement.setString(17, s_TotalRetailAssetsIR);
			preparedStatement.setString(18, s_TotalRetailAssetsIC);
			preparedStatement.setString(19, s_TotalWholesaleIR);
			preparedStatement.setString(20, s_TotalWholesaleIC);

			preparedStatement.executeUpdate();
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return id;	
	}
	
	
	@Override
	public String getImageUrlDataNew(String imageId){
		System.out.println("in Here");
		
 		String a_RESIDUALRISK = "";
 		String a_ASSESSMENTWISECAT = "";
 		double a_TOTALWEIGHTEDSCOREIR = 0.0;
 		double a_TOTALWEIGHTEDSCOREIC = 0.0;
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = "SELECT RESIDUALRISK, ASSESSMENTWISECAT, A_TOTALWEIGHTEDSCOREIR, A_TOTALWEIGHTEDSCOREIC FROM TB_IMAGEDATA WHERE IMAGEID = ? ";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, imageId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
            	a_RESIDUALRISK = resultSet.getString("RESIDUALRISK");
            	a_ASSESSMENTWISECAT = resultSet.getString("ASSESSMENTWISECAT");
            	a_TOTALWEIGHTEDSCOREIR = resultSet.getDouble("A_TOTALWEIGHTEDSCOREIR");
            	a_TOTALWEIGHTEDSCOREIC = resultSet.getDouble("A_TOTALWEIGHTEDSCOREIC");
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return a_RESIDUALRISK+"@~@"+a_ASSESSMENTWISECAT+"@~@"+a_TOTALWEIGHTEDSCOREIR+"@~@"+a_TOTALWEIGHTEDSCOREIC;	
	}
	

	@Override
	public String getImageUrlDataSummary(String imageId){
		System.out.println("in Here");
		
		String dEFAULTVALUECHART = "";
	 	String t_RESIDUALRISK = "";
	 	String rl_RESIDUALRISK = "";
	 	String ra_RESIDUALRISK = "";
	 	String wb_RESIDUALRISK = "";
 		String rESIDUALRISK = "";
 		String aSSESSMENTWISECAT = "";
 		String bl_IR = "";
 		String bl_IC = "";
 		double a_TOTALWEIGHTEDSCOREIR = 0.0;
 		double a_TOTALWEIGHTEDSCOREIC = 0.0;
 		double s_TotalTresuryIR = 0.0;
 		double s_TotalTresuryIC = 0.0;
 		double s_TotalRetailLiabiltiesIR = 0.0;
 		double s_totalRetailLiabiltiesIC = 0.0;
 		double s_TotalRetailAssetsIR = 0.0;
 		double s_TotalRetailAssetsIC = 0.0;
 		double s_TotalWholesaleIR = 0.0;
 		double s_TotalWholesaleIC = 0.0;
		
		Connection connection = connectionUtil.getConnection();
		PreparedStatement preparedStatement = null;
		ResultSet resultSet = null;
		try{
			String query = "SELECT DEFAULTVALUECHART, T_RESIDUALRISK, RL_RESIDUALRISK, RA_RESIDUALRISK, WB_RESIDUALRISK, RESIDUALRISK, ASSESSMENTWISECAT, BL_IR, BL_IC, "
            		+ "A_TOTALWEIGHTEDSCOREIR, A_TOTALWEIGHTEDSCOREIC, TOTALTRESURYIR, TOTALTRESURYIC, "
            		+ "TOTALRLIR, TOTALRLIC, TOTALRAIR, TOTALRAIC, TOTALWBIR, TOTALWBIC FROM TB_IMAGEDATA WHERE IMAGEID = ?";
			preparedStatement = connection.prepareStatement(query);
			preparedStatement.setString(1, imageId);
			resultSet = preparedStatement.executeQuery();
			while(resultSet.next()) {
            	dEFAULTVALUECHART = resultSet.getString("DEFAULTVALUECHART");
            	t_RESIDUALRISK = resultSet.getString("T_RESIDUALRISK");
            	rl_RESIDUALRISK = resultSet.getString("RL_RESIDUALRISK");
            	ra_RESIDUALRISK = resultSet.getString("RA_RESIDUALRISK");
            	wb_RESIDUALRISK = resultSet.getString("WB_RESIDUALRISK");
            	rESIDUALRISK = resultSet.getString("RESIDUALRISK");
            	aSSESSMENTWISECAT = resultSet.getString("ASSESSMENTWISECAT");
            	bl_IR = resultSet.getString("BL_IR");
            	bl_IC = resultSet.getString("BL_IC");
            	a_TOTALWEIGHTEDSCOREIR = resultSet.getDouble("A_TOTALWEIGHTEDSCOREIR");
            	a_TOTALWEIGHTEDSCOREIC = resultSet.getDouble("A_TOTALWEIGHTEDSCOREIC");
            	s_TotalTresuryIR = resultSet.getDouble("TOTALTRESURYIR");
            	s_TotalTresuryIC = resultSet.getDouble("TOTALTRESURYIC");
            	s_TotalRetailLiabiltiesIR = resultSet.getDouble("TOTALRLIR");
            	s_totalRetailLiabiltiesIC = resultSet.getDouble("TOTALRLIC");
            	s_TotalRetailAssetsIR = resultSet.getDouble("TOTALRAIR");
            	s_TotalRetailAssetsIC = resultSet.getDouble("TOTALRAIC");
            	s_TotalWholesaleIR = resultSet.getDouble("TOTALWBIR");
            	s_TotalWholesaleIC = resultSet.getDouble("TOTALWBIC");
			}
			
		}catch(Exception e){
			e.printStackTrace();
		}finally{
			connectionUtil.closeResources(connection, preparedStatement, resultSet, null);
		}
		return dEFAULTVALUECHART+"@~@"+t_RESIDUALRISK+"@~@"+rl_RESIDUALRISK+"@~@"+ra_RESIDUALRISK+"@~@"
				+wb_RESIDUALRISK+"@~@"+rESIDUALRISK+"@~@"+aSSESSMENTWISECAT+"@~@"+bl_IR+"@~@"
				+bl_IC+"@~@"+a_TOTALWEIGHTEDSCOREIR+"@~@"+a_TOTALWEIGHTEDSCOREIC+"@~@"+s_TotalTresuryIR+"@~@"
				+s_TotalTresuryIC+"@~@"+s_TotalRetailLiabiltiesIR+"@~@"+s_totalRetailLiabiltiesIC+"@~@"+s_TotalRetailAssetsIR+"@~@"	
				+s_TotalRetailAssetsIC+"@~@"+s_TotalWholesaleIR+"@~@"+s_TotalWholesaleIC;
	}
}
