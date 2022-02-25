package com.quantumdataengines.app.compass.dao.customerRiskCategorization;

import java.util.List;
import java.util.Map;

public interface CustomerRiskCategorizationDAO {
	public List<Map<String, String>> getStaticRiskParameterList(String customerType);
	public List<Map<String, String>> getDynamicRiskParameterList(String customerType);
	public void saveStaticParameterList(String strRiskParameters);
	public void saveDynamicParameterList(String strRiskParameters);
	public List<Map<String,String>> searchStaticRiskAssignment(String searchParamId, String customerType);
	public List<Map<String,String>> searchDynamicRiskAssignment(String searchParamId, String customerType);
	public void updateStaticRiskAssignmentValue(String fullData, String paramId);
	public void updateDynamicRiskAssignmentValue(String fullData, String paramId);
	public String fetchISFromToReqValueForDynamicCRC(String paramId);
	public String saveNewDynamicRiskParam(String paramId, String paramCode ,String paramDesc ,String paramRangeFrom ,
			String paramRangeTo ,String paramRiskValue, String paramOccupation, String userCode);
	public Map<String, String> fetchParamCodeToDeleteDynamicRiskParameter(String searchParamId, String paramCode);
	public String deleteNewDynamicRiskParam(String paramId, String paramCode);
	public String updateNewDynamicRiskParam(String paramId, String paramCode, String paramDesc, String paramRangeFrom,
			String paramRangeTo, String paramRiskValue, String paramOccupation, String userCode);
	public void updateStaticRiskWeightageList(String staticRiskWeightages);
	public void updateDynamicRiskWeightageList(String staticRiskWeightages);
	public String calculateStaticRisk(String userCode, String CURRENTROLE, String ipAddress);
	public String calculateDynamicRisk(String userCode, String CURRENTROLE, String ipAddress);
	public List<Map<String,String>> getOccupationCodes();
	/*
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
	public String updateComplianceScore(String fullData, String searchTemplate);*/

}
