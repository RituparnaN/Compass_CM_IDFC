package com.quantumdataengines.app.compass.model.riskAssessmentNew;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.springframework.util.LinkedCaseInsensitiveMap;

public class CategSubcategInherentRiskRatings {
	public ArrayList<Map<String,String>> inherentRisksList = new ArrayList<Map<String,String>>();
	public CategSubcategInherentRiskRatings(JSONArray inherentRisksObj) throws JSONException {
		for(int x = 0 ; x < inherentRisksObj.length();x++) {
			Map<String,String> inherentRisk = new LinkedHashMap<String, String>();
			try {
				inherentRisk.put("category", inherentRisksObj.getJSONObject(x).getString("category"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				inherentRisk.put("category", "");
			}
			try {
				inherentRisk.put("subCategory", inherentRisksObj.getJSONObject(x).getString("subCategory"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				inherentRisk.put("subCategory", "");
			}
			try {
				inherentRisk.put("inherentRisk", inherentRisksObj.getJSONObject(x).getString("inherentRisk"));
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				inherentRisk.put("inherentRisk", "");
			}
			this.inherentRisksList.add(inherentRisk);
			
		}
	}
}
