package com.quantumdataengines.app.compass.dao.riskAssessment;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerDataModel;

public interface RiskAssessmentDAO {
	public String generateCompassRefNo();
	public List<Map<String, String>> searchRiskAssessmentData(String ASSESSMENTUNIT, String COMPASSREFERENCENO);
	public List<String> getDistinctAssessmentUnits();
	public Map<String, Object> getRiskAssessmentForm(String ASSESSMENTUNIT, String ASSESSMENTSECTIONCODE, String COMPASSREFERENCENO, String ISNEWFORM);
	public String saveRiskAssessmentData(Map<String, Object> formData, String status, String userCode, String userRole, String ipAddress);
	public Map<String, Object> generateCMReport(String compassRefNo, String userCode, String userRole, String ipAddress);
	
	public JSONObject getMakerCheckerList(String qId,String compassRefNo);
	public Map<String, Object> saveRaiseToRFI(MakerCheckerDataModel makerCheckerData);
	
	public String saveImageUrlData(String imageUrl);
	public String getImageUrlData(String imageId);
	public Map<String, Object> getGraphDataPoints(String cmRefNo);
}
