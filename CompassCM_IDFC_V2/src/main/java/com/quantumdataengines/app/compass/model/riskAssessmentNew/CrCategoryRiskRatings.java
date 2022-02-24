package com.quantumdataengines.app.compass.model.riskAssessmentNew;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;

public class CrCategoryRiskRatings {
	
public ArrayList<Object> crCategoryRisksList = new ArrayList<Object>();
	
	public CrCategoryRiskRatings(JSONArray categoryRisksObj) throws JSONException {
		for(int x = 0 ; x < categoryRisksObj.length();x++) {
			Map<String,String> riskData = new LinkedHashMap<String, String>();
			try {
				riskData.put("categoryName", categoryRisksObj.getJSONObject(x).getString("categoryName"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				riskData.put("categoryName", "");
			}
			try {
				riskData.put("finalRisk", categoryRisksObj.getJSONObject(x).getString("finalRisk"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				riskData.put("finalRisk", "");
			}
			try {
				riskData.put("provisionalRisk", categoryRisksObj.getJSONObject(x).getString("provisionalRisk"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				riskData.put("provisionalRisk", "");
			}
			try {
				riskData.put("reasonsForDeviation", categoryRisksObj.getJSONObject(x).getString("reasonsForDeviation"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				riskData.put("reasonsForDeviation", "");
			}
			try {
				riskData.put("sysgenRisk", categoryRisksObj.getJSONObject(x).getString("sysgenRisk"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				riskData.put("sysgenRisk", "");
			}
			this.crCategoryRisksList.add(riskData);
			
		}
	}
}
