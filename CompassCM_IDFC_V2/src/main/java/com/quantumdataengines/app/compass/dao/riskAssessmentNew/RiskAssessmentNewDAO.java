package com.quantumdataengines.app.compass.dao.riskAssessmentNew;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;

import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerDataModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormConfigurationModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormDataModel;

public interface RiskAssessmentNewDAO {
	public Map<String,Object> getQuestionsFormDetails(String assessmentUnit, String cmRefNo);
	public void saveRiskAssesesmentFormConfiguration(FormConfigurationModel formConfigurationModel );
	public void saveRiskAssesesmentForm(FormDataModel fromData );
	
	public List<Map<String, String>> searchRiskAssessmentData(String ASSESSMENTUNIT, String COMPASSREFERENCENO);
	public String generateCompassRefNo();
	
	public Map<String, Object> generateCMReport(String compassRefNo, String userCode, String userRole, String ipAddress);
	public Map<String, Object> generateCMReportNew(String compassRefNo, String userCode, String userRole, String ipAddress);
	
	public JSONObject getMakerCheckerList(String qId,String compassRefNo);
	public Map<String, Object> saveRaiseToRFI(MakerCheckerDataModel makerCheckerData);
	public Map<Object, Object> getRASummaryData(int assessmentPeriod);
	public Object getGraphDataPoints(String cmRefNo);
}
