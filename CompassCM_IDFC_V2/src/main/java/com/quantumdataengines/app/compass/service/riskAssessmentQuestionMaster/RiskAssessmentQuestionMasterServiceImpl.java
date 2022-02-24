package com.quantumdataengines.app.compass.service.riskAssessmentQuestionMaster;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.riskAssessmentQuestionMaster.RiskAssessmentQuestionMasterDAO;

@Service
public class RiskAssessmentQuestionMasterServiceImpl implements RiskAssessmentQuestionMasterService {

	@Autowired
	private RiskAssessmentQuestionMasterDAO riskAssessmentQuestionMasterDAO;
	
	@Override
	public Object getQuestionCategory() {
		return riskAssessmentQuestionMasterDAO.getQuestionCategory();
	}

	@Override
	public String addRiskAssessmentQuestion(String userCode, String userRole, String ipAddress,
			Map<String, String> questionData) {		
		return riskAssessmentQuestionMasterDAO.addRiskAssessmentQuestion( userCode,  userRole,  ipAddress,questionData);
	}

	@Override
	public Map<String, Object> getQuestionDetails(String questionId, String status, String questionVersion, String userCode, String userRole,
			String ipAddress) {
		return riskAssessmentQuestionMasterDAO.getQuestionDetails( questionId, status, questionVersion, userCode,  userRole, ipAddress);
	}

	@Override
	public String updateRiskAssessmentQuestion(String userCode, String userRole, String ipAddress,
			Map<String, String> questionData) {
		return riskAssessmentQuestionMasterDAO.updateRiskAssessmentQuestion( userCode, userRole, ipAddress, questionData);
	}

	@Override
	public String addRiskAssessmentSubGroup(Map<String, String> paramMap, String userCode, String userRole,
			String ipAddress) {		
		return riskAssessmentQuestionMasterDAO.addRiskAssessmentSubGroup(paramMap,  userCode,  userRole, ipAddress);
	}

	@Override
	public String saveRiskAssessmentQuestionnaire(Map<String, String> questionData, String userCode, String userRole,
			String ipAddress) {
		return riskAssessmentQuestionMasterDAO.saveRiskAssessmentQuestionnaire(questionData, userCode, userRole, ipAddress);
	}

	@Override
	public List<Map<String, String>> getAssessmentWeightageList(String userCode, String userRole) {
		return riskAssessmentQuestionMasterDAO.getAssessmentWeightageList(userCode, userRole);
	}

	@Override
	public String saveWeightage(String fullData, String userCode, String userRole) {
		return riskAssessmentQuestionMasterDAO.saveWeightage(fullData, userCode, userRole);
	}
}
