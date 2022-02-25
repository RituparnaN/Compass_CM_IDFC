package com.quantumdataengines.app.compass.dao.riskCategorization;

import java.util.List;
import java.util.Map;

public interface RiskCategorizationDAO {
	public List<Map<String, String>> getRiskParameterList();
	public void saveParameterList(String strRiskParameters);
	public List<Map<String,String>> searchRiskAssignment(String searchParamId);
	public void updateRiskAssignmentValue(String fullData, String paramId);
	public void updateParameterWeightageList(String strParameters);
	public String calculateRisk(String userCode, String CURRENTROLE, String ipAddress);
	public String fetchISFromToReqValue(String paramId);
	public String saveNewRiskParam(String paramId, String paramCode ,String paramDesc ,String paramRangeFrom ,
			String paramRangeTo ,String paramRiskValue, String priorityRiskValue, String userCode);
	public Map<String, String> fetchParamCodeToDeleteRiskParameter(String searchParamId, String paramCode);
	public String deleteNewRiskParam(String paramId, String paramCode);
	public String updateNewRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
			String paramRangeTo, String paramRiskValue, String priorityRiskValue, String userCode);
	
	public Map<String,Map<String, String>> getRequiredFields();
	public Map<String, Object> searchRiskParamFields(String templateId, String templateName, String productCode, String custType, 
			  String isEnabled);
	public Map<String, Object> addRiskParamFieldsTemplate(String templateId, String templateName, String productCode, String custType, 
			String productCodeRiskValue, String custTypeRiskValue, String isEnabled, String userCode, String CURRENTROLE);
	public Map<String,String> fetchRiskParamFieldsToUpdate(String selectedTempId, String selectedTempName, String	selectedProductCode,
			String selectedCustomerType, String selectedIsEnabled);
	public String updateRiskParamFields(String templateId, String templateName, String productCode, String custType, 
			String productCodeRiskValue, String custTypeRiskValue, String isEnabled, String userCode, String CURRENTROLE);
	public Map<String, Object> searchAddFieldsToTemplate(String template, String detailType);
	public String updateComplianceScore(String fullData, String searchTemplate);

}
