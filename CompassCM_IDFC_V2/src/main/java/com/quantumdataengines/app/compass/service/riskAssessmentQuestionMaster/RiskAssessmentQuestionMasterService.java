package com.quantumdataengines.app.compass.service.riskAssessmentQuestionMaster;

import java.util.List;
import java.util.Map;

public interface RiskAssessmentQuestionMasterService {

	public Object getQuestionCategory();
	public String addRiskAssessmentQuestion(String userCode, String userRole, String ipAddress,Map<String, String> questionData);
	public Map<String,Object> getQuestionDetails(String questionId, String status, String questionVersion, String userCode, String userRole, String ipAddress);
	public String updateRiskAssessmentQuestion(String userCode, String userRole, String ipAddress,Map<String, String> questionData);
	public String addRiskAssessmentSubGroup(Map<String, String> paramMap, String userCode, String userRole, String ipAddress);
	public String saveRiskAssessmentQuestionnaire(Map<String, String> questionData, String userCode, String userRole, String ipAddress);
	public List<Map<String, String>> getAssessmentWeightageList(String userCode, String userRole);
	public String saveWeightage(String fullData, String userCode, String userRole);
}
