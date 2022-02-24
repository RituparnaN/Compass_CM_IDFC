package com.quantumdataengines.app.compass.model.riskAssessment;

import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

public class MakerCheckerData {
	public String makerDueDate ="";
	public String checkerDueDate = "";
	public String makerName = "";
	public String checkerJoinNames = "";
	public String editable="";
	public ArrayList<String> checkerNames = new ArrayList<String>();
	public String comments = "";
	public MakerCheckerData(JSONObject jObj) throws JSONException {
		this.makerDueDate = jObj.getString("makerDueDate");
		this.checkerDueDate = jObj.getString("checkerDueDate");
		this.makerName = jObj.getString("makerName");
		this.comments = jObj.getString("comments");
		this.checkerJoinNames = jObj.getString("checkerJoinNames");
		this.editable = jObj.getString("editable");
		for(int x = 0 ; x < jObj.getJSONArray("checkerNames").length(); x++) {
			this.checkerNames.add(jObj.getJSONArray("checkerNames").getString(x));
		}
		
	}
}
