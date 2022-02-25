package com.quantumdataengines.app.compass.service.riskAssessment;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.riskAssessment.RiskAssessmentDAO;
import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerDataModel;

@Service
public class RiskAssessmentServiceImpl implements RiskAssessmentService{

	@Autowired
	public RiskAssessmentDAO riskAssessmentDAO;

	@Override
	public String generateCompassRefNo() {
		return riskAssessmentDAO.generateCompassRefNo();
	}
	
	@Override
	public List<Map<String, String>> searchRiskAssessmentData(String ASSESSMENTUNIT, String COMPASSREFERENCENO){
		return riskAssessmentDAO.searchRiskAssessmentData(ASSESSMENTUNIT, COMPASSREFERENCENO);
	}
	
	@Override
	public List<String> getDistinctAssessmentUnits() {
		return riskAssessmentDAO.getDistinctAssessmentUnits();
	} 
	

	@Override
	public Map<String, Object> getRiskAssessmentForm(String ASSESSMENTUNIT, String ASSESSMENTSECTIONCODE, String COMPASSREFERENCENO, String ISNEWFORM) {
		return riskAssessmentDAO.getRiskAssessmentForm(ASSESSMENTUNIT, ASSESSMENTSECTIONCODE, COMPASSREFERENCENO, ISNEWFORM);
	}

	@Override
	public String saveRiskAssessmentData(Map<String, Object> formData, String status, String userCode, String userRole,
			String ipAddress) {
		return riskAssessmentDAO.saveRiskAssessmentData(formData, status, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> generateCMReport(String compassRefNo, String userCode, String userRole,
			String ipAddress) {
		return riskAssessmentDAO.generateCMReport(compassRefNo, userCode, userRole, ipAddress);
	}

	@Override
	public JSONObject getMakerCheckerList(String qId,String compassRefId) {
		return riskAssessmentDAO.getMakerCheckerList(qId,compassRefId);
	} 
	
	@Override
	public Map<String, Object> saveRaiseToRFI(MakerCheckerDataModel makerCheckerData) {
		return riskAssessmentDAO.saveRaiseToRFI(makerCheckerData);
	} 
	

	@Override
	public String saveImageUrlData(String imageUrl) {
		// TODO Auto-generated method stub
		return riskAssessmentDAO.saveImageUrlData(imageUrl);
	} 
	
	@Override
	public String getImageUrlData(String imageId) {
		// TODO Auto-generated method stub
		return riskAssessmentDAO.getImageUrlData(imageId);
	}

	@Override
	public Map<String, Object> getGraphDataPoints(String cmRefNo) {
		// TODO Auto-generated method stub
		return riskAssessmentDAO.getGraphDataPoints(cmRefNo);
	} 

}
