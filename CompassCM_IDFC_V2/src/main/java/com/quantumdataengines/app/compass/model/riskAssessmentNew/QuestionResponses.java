package com.quantumdataengines.app.compass.model.riskAssessmentNew;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

public class QuestionResponses {
	public ArrayList<Object> questionsResponseList = new ArrayList<Object>();
	
	public QuestionResponses(JSONArray questionListObj) {
		System.out.println(questionListObj.toString());
		for(int x = 0 ; x < questionListObj.length();x++) {
			Map<String,String> questionResponseData = new LinkedHashMap<String, String>();
			
			try {
				questionResponseData.put("QUESTIONID", questionListObj.getJSONObject(x).getString("QUESTIONID"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QINPUT", questionListObj.getJSONObject(x).getString("QINPUT"));
//				System.out.println("qinput: "+questionListObj.getJSONObject(x).getString("QINPUT"));
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
//				e.printStackTrace();
				questionResponseData.put("QINPUT", "");
			}
			try {
				questionResponseData.put("QRESULT", questionListObj.getJSONObject(x).getString("QRESULT"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QRESULT", "");
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QIMPACTCRITERIA", questionListObj.getJSONObject(x).getString("QIMPACTCRITERIA"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QIMPACTCRITERIA", "");
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QINHERENTRISK", questionListObj.getJSONObject(x).getString("QINHERENTRISK"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QINHERENTRISK", "");
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QLIKELYHOOD", questionListObj.getJSONObject(x).getString("QLIKELYHOOD"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QLIKELYHOOD", "");
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QDESIGNRATING", questionListObj.getJSONObject(x).getString("QDESIGNRATING"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QDESIGNRATING", "");
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QDOCREFSAMTESTING", questionListObj.getJSONObject(x).getString("QDOCREFSAMTESTING"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QDOCREFSAMTESTING", "");
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QOBSERVATION", questionListObj.getJSONObject(x).getString("QOBSERVATION"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QOBSERVATION", "");
//				e.printStackTrace();
			}
			try {
				questionResponseData.put("QOPERATINGRATING", questionListObj.getJSONObject(x).getString("QOPERATINGRATING"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				questionResponseData.put("QOPERATINGRATING", "");
//				e.printStackTrace();
			}
			this.questionsResponseList.add(questionResponseData);
//			System.out.println(questionResponseData.toString());
		}
	}
}
