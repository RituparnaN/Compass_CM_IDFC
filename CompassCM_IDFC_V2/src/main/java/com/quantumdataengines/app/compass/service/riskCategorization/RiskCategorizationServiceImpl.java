package com.quantumdataengines.app.compass.service.riskCategorization;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.riskCategorization.RiskCategorizationDAO;

@Service
public class RiskCategorizationServiceImpl implements RiskCategorizationService{
	@Autowired
	private RiskCategorizationDAO riskCategorizationDAO;
	
	@Override
	public List<Map<String, String>> getRiskParameterList() {
		return riskCategorizationDAO.getRiskParameterList();
	}

	@Override
	public void saveParameterList(String strRiskParameters) {
		riskCategorizationDAO.saveParameterList(strRiskParameters);
	}

	@Override
	public List<Map<String, String>> searchRiskAssignment(String searchParamId) {
		return riskCategorizationDAO.searchRiskAssignment(searchParamId);
	}

	
	@Override
	public void updateParameterWeightageList(String strParameters) {
		riskCategorizationDAO.updateParameterWeightageList(strParameters);
	}

	@Override
	public String calculateRisk(String userCode, String CURRENTROLE,
			String ipAddress) {
		return riskCategorizationDAO.calculateRisk(userCode, CURRENTROLE, ipAddress);
	}

	@Override
	public String fetchISFromToReqValue(String paramId) {
		return riskCategorizationDAO.fetchISFromToReqValue(paramId);
	}

	@Override
	public String saveNewRiskParam(String paramId, String paramCode,
			String paramDesc, String paramRangeFrom, String paramRangeTo,
			String paramRiskValue,String priorityRiskValue, String userCode) {
		return riskCategorizationDAO.saveNewRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, paramRangeTo, paramRiskValue, priorityRiskValue, userCode);
	}

	@Override
	public void updateRiskAssignmentValue(String fullData, String paramId) {
      riskCategorizationDAO.updateRiskAssignmentValue(fullData, paramId);		
	}

	@Override
	public String deleteNewRiskParam(String paramId, String paramCode) {
		return riskCategorizationDAO.deleteNewRiskParam(paramId, paramCode);
	}

	@Override
	public Map<String, String> fetchParamCodeToDeleteRiskParameter(String searchParamId, String paramCode) {
		return riskCategorizationDAO.fetchParamCodeToDeleteRiskParameter(searchParamId, paramCode);
	}

	@Override
	public String updateNewRiskParam(String paramId, String paramCode,
			String paramDesc, String paramRangeFrom, String paramRangeTo,
			String paramRiskValue,String priorityRiskValue, String userCode) {
		return riskCategorizationDAO.updateNewRiskParam(paramId, paramCode, paramDesc, paramRangeFrom, paramRangeTo, paramRiskValue, priorityRiskValue, userCode);
	}

	@Override
	public Map<String, Map<String, String>> getRequiredFields() {
		return riskCategorizationDAO.getRequiredFields();
	}

	@Override
	public Map<String, Object> searchRiskParamFields(String templateId,
			String templateName, String productCode, String custType,
			String isEnabled) {
		return riskCategorizationDAO.searchRiskParamFields(templateId, templateName, productCode, custType, isEnabled);
	}

	@Override
	public Map<String, Object> addRiskParamFieldsTemplate(String templateId,
			String templateName, String productCode, String custType,
			String productCodeRiskValue, String custTypeRiskValue, String isEnabled, 
			String userCode, String CURRENTROLE) {
		return riskCategorizationDAO.addRiskParamFieldsTemplate(templateId, templateName, productCode, custType, 
				productCodeRiskValue, custTypeRiskValue, isEnabled, userCode, CURRENTROLE);
	}

	@Override
	public Map<String, String> fetchRiskParamFieldsToUpdate(
			String selectedTempId, String selectedTempName,
			String selectedProductCode, String selectedCustomerType,
			String selectedIsEnabled) {
		return riskCategorizationDAO.fetchRiskParamFieldsToUpdate(selectedTempId, selectedTempName, selectedProductCode, selectedCustomerType, selectedIsEnabled);
	}

	@Override
	public String updateRiskParamFields(String templateId,
			String templateName, String productCode, String custType,
			String productCodeRiskValue, String custTypeRiskValue, 
			String isEnabled, String userCode, String CURRENTROLE) {
		return riskCategorizationDAO.updateRiskParamFields(templateId, templateName, productCode, custType, 
				productCodeRiskValue, custTypeRiskValue, isEnabled, userCode, CURRENTROLE);
	}

	@Override
	public Map<String, Object> searchAddFieldsToTemplate(String template,
			String detailType) {
		return riskCategorizationDAO.searchAddFieldsToTemplate(template, detailType);
	}

	@Override
	public String updateComplianceScore(String fullData, String searchTemplate) {
		return riskCategorizationDAO.updateComplianceScore(fullData, searchTemplate);
	}
}
