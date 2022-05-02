package com.quantumdataengines.app.compass.service.riskAssessmentNew;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.riskAssessment.RiskAssessmentDAO;
import com.quantumdataengines.app.compass.dao.riskAssessmentNew.RiskAssessmentNewDAO;
import com.quantumdataengines.app.compass.model.riskAssessment.MakerCheckerDataModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormConfigurationModel;
import com.quantumdataengines.app.compass.model.riskAssessmentNew.FormDataModel;

@Service
public class RiskAssessmentNewServiceImpl implements RiskAssessmentNewService{

	@Autowired
	public RiskAssessmentNewDAO riskAssessmentNewDAO;

	
	@Override
	public Map<String,Object> getQuestionsFormDetails(String assessementUnit, String cmRefNo ) {
		return riskAssessmentNewDAO.getQuestionsFormDetails(assessementUnit, cmRefNo);
	} 
	@Override
	public void saveRiskAssesesmentFormConfiguration(FormConfigurationModel formConfigurationModel ) {
		riskAssessmentNewDAO.saveRiskAssesesmentFormConfiguration(formConfigurationModel);
	} 
	
	@Override
	public List<Map<String, String>> searchRiskAssessmentData(String ASSESSMENTUNIT, String COMPASSREFERENCENO){
		return riskAssessmentNewDAO.searchRiskAssessmentData(ASSESSMENTUNIT, COMPASSREFERENCENO);
	}
	@Override
	public String generateCompassRefNo() {
		return riskAssessmentNewDAO.generateCompassRefNo();
	}
	
	@Override
	public void saveRiskAssesesmentForm(FormDataModel formDataModel) {
		riskAssessmentNewDAO.saveRiskAssesesmentForm(formDataModel);
		
	}
	
	@Override
	public Map<String, Object> generateCMReport(String compassRefNo, String userCode, String userRole,
			String ipAddress) {
		return riskAssessmentNewDAO.generateCMReport(compassRefNo, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> generateCMReportNew(String compassRefNo, String userCode, String userRole,
			String ipAddress) {
		return riskAssessmentNewDAO.generateCMReportNew(compassRefNo, userCode, userRole, ipAddress);
	}
	
	@Override
	public JSONObject getMakerCheckerList(String qId,String compassRefId) {
		return riskAssessmentNewDAO.getMakerCheckerList(qId,compassRefId);
	} 
	
	@Override
	public Map<String, Object> saveRaiseToRFI(MakerCheckerDataModel makerCheckerData) {
		return riskAssessmentNewDAO.saveRaiseToRFI(makerCheckerData);
	}
	@Override
	public Map<Object, Object> getRASummaryData(int assessmentPeriod) {
		// TODO Auto-generated method stub
		return riskAssessmentNewDAO.getRASummaryData(assessmentPeriod);
	}
	@Override
	public Object getGraphDataPoints(String cmRefNo) {
		// TODO Auto-generated method stub
		return riskAssessmentNewDAO.getGraphDataPoints(cmRefNo);
	} 

}
