package com.quantumdataengines.app.compass.model.riskAssessment;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;
import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerData;

public class MakerCheckerDataModel {

	public List<MakerCheckerData> makerCheckerData= new ArrayList<MakerCheckerData>(); 
	public String questionId = "";
	public String userRole = "";
	public String userCode = "";
	public String ipAddress = "";
	public String compassRefNo = "";
//	public String rowDetails = "";
	
	public MakerCheckerDataModel(String makerCheckerData,String userRole,String userCode, String ipAddress) throws JSONException {
		
		JSONObject jObj = new JSONObject(makerCheckerData);
		
		for(int i = 0; i < jObj.getJSONArray("makerCheckerData").length(); i++) {
			this.makerCheckerData.add(new MakerCheckerData(jObj.getJSONArray("makerCheckerData").getJSONObject(i)));
		}
		this.compassRefNo = jObj.getString("compassRefNo");
		this.questionId = jObj.getString("qId");
		this.userRole = userRole;
		this.userCode = userCode;
		this.ipAddress = ipAddress;
//		this.rowDetails = makerCheckerData;
	}
}
