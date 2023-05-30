package com.quantumdataengines.app.compass.model.riskAssessmentNew;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.lf5.viewer.categoryexplorer.CategoryExplorerModel;
import org.json.JSONException;
import org.json.JSONObject;

import com.google.gson.JsonObject;
import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerData;

public class FormConfigurationModel {

	public ArrayList<Map<String,Object>> questionsList = new ArrayList<Map<String,Object>>();
	public ArrayList<Map<String,Object>> controlsReviewQsList = new ArrayList<Map<String,Object>>();
	public FormConfigurationModel(String questionsList) throws JSONException {
		JSONObject jObj = new JSONObject(questionsList);
		
		for(int i = 0; i < jObj.getJSONArray("crQuestionsList").length(); i++) {
			Map<String,Object> questionDetails = new LinkedHashMap<String,Object>();
			JSONObject qObj = jObj.getJSONArray("crQuestionsList").getJSONObject(i);
			try {
				
				questionDetails.put("DISABLED",qObj.getString("DISABLED") );
			} catch (Exception e) {
				questionDetails.put("DISABLED","" );
			}
			try {
				
				questionDetails.put("HASPARENT",qObj.getString("HASPARENT") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("HASPARENT","" );
			}
			try {
				
				questionDetails.put("HASRISKIMPACT",qObj.getString("HASRISKIMPACT") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("HASRISKIMPACT","" );
			}
			try {
				
				questionDetails.put("INPUTOPTIONSLIST",qObj.getString("INPUTOPTIONSLIST") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("INPUTOPTIONSLIST","" );
			}
			try {
				
				questionDetails.put("INPUTTYPE",qObj.getString("INPUTTYPE") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("INPUTTYPE","" );
			}
			try {
				
				questionDetails.put("ISSUPERPARENT",qObj.getString("ISSUPERPARENT") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("ISSUPERPARENT","" );
			}
			try {
				
				questionDetails.put("QUESTION",qObj.getString("QUESTION") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("QUESTION","" );
			}
			try {
				
				questionDetails.put("QUESTIONID",qObj.getString("QUESTIONID") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("QUESTIONID","" );
			}
			try {
				
				questionDetails.put("assessmentUnit",qObj.getString("assessmentUnit") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("assessmentUnit","");
			}
			try {
				
				questionDetails.put("category","Controls Review" );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("category","" );
			}
			try {
				
				questionDetails.put("subCategory",qObj.getString("category") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("subCategory","" );
			}
			try {
				
				questionDetails.put("subSubCategory",qObj.getString("subCategory") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("subSubCategory","" );
			}
			try {
				
				questionDetails.put("PARENTQSIDS",qObj.getString("PARENTQSIDS") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("PARENTQSIDS","" );
			}
			try {
				
				questionDetails.put("INPUTOPTIONSLISTFORNUMERIC",qObj.getString("INPUTOPTIONSLISTFORNUMERIC") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("INPUTOPTIONSLISTFORNUMERIC","" );
			}
			try {
				
				questionDetails.put("CREATEDBY",qObj.getString("CREATEDBY") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("CREATEDBY","" );
			}
			try {
				
				questionDetails.put("CREATEDON",qObj.getString("CREATEDON") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("CREATEDON","" );
			}
			try {
				
				questionDetails.put("COMMENTS",qObj.getString("COMMENTS") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("COMMENTS","" );
			}

			this.controlsReviewQsList.add(questionDetails);
			
		}
			
		for(int i = 0; i < jObj.getJSONArray("questionsList").length(); i++) {
//			this.questionsList.add(new MakerCheckerData(jObj.getJSONArray("makerCheckerData").getJSONObject(i)));
			Map<String,Object> questionDetails = new LinkedHashMap<String,Object>();
			JSONObject qObj = jObj.getJSONArray("questionsList").getJSONObject(i);
			try {
				
				questionDetails.put("DISABLED",qObj.getString("DISABLED") );
			} catch (Exception e) {
				questionDetails.put("DISABLED","" );
			}
			try {
				
				questionDetails.put("HASPARENT",qObj.getString("HASPARENT") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("HASPARENT","" );
			}
			try {
				
				questionDetails.put("HASRISKIMPACT",qObj.getString("HASRISKIMPACT") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("HASRISKIMPACT","" );
			}
			try {
				
				questionDetails.put("INPUTOPTIONSLIST",qObj.getString("INPUTOPTIONSLIST") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("INPUTOPTIONSLIST","" );
			}
			try {
				
				questionDetails.put("INPUTTYPE",qObj.getString("INPUTTYPE") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("INPUTTYPE","" );
			}
			try {
				
				questionDetails.put("ISSUPERPARENT",qObj.getString("ISSUPERPARENT") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("ISSUPERPARENT","" );
			}
			try {
				
				questionDetails.put("QUESTION",qObj.getString("QUESTION") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("QUESTION","" );
			}
			try {
				
				questionDetails.put("QUESTIONID",qObj.getString("QUESTIONID") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("QUESTIONID","" );
			}
			try {
				
				questionDetails.put("assessmentUnit",qObj.getString("assessmentUnit") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("assessmentUnit","");
			}
			try {
				
				questionDetails.put("category",qObj.getString("category") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("category","" );
			}
			try {
				
				questionDetails.put("subCategory",qObj.getString("subCategory") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("subCategory","" );
			}
			try {
				
				questionDetails.put("PARENTQSIDS",qObj.getString("PARENTQSIDS") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("PARENTQSIDS","" );
			}
			try {
				
				questionDetails.put("INPUTOPTIONSLISTFORNUMERIC",qObj.getString("INPUTOPTIONSLISTFORNUMERIC") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("INPUTOPTIONSLISTFORNUMERIC","" );
			}
			try {
				
				questionDetails.put("CREATEDBY",qObj.getString("CREATEDBY") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("CREATEDBY","" );
			}
			try {
				
				questionDetails.put("CREATEDON",qObj.getString("CREATEDON") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("CREATEDON","" );
			}
			try {
				
				questionDetails.put("COMMENTS",qObj.getString("COMMENTS") );
			} catch (Exception e) {
				// TODO: handle exception
				questionDetails.put("COMMENTS","" );
			}
//			System.out.println(questionDetails);
			
			this.questionsList.add(questionDetails);
		}
			
	}

}
