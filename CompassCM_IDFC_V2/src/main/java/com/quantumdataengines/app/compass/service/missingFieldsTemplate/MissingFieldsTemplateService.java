package com.quantumdataengines.app.compass.service.missingFieldsTemplate;

import java.util.Map;

public interface MissingFieldsTemplateService {
	public Map<String,Map<String, String>> getRequiredFields();
	public Map<String, Object> searchMissingFields(String templateId, String templateName, String productCode, String custType, 
			  String isEnabled);
	public Map<String, Object> addMissingFieldsTemplate(String templateId, String templateName, String productCode, String custType, 
			String isEnabled, String userCode, String CURRENTROLE);
	public Map<String,String> fetchMissingFieldsToUpdate(String selectedTempId, String selectedTempName, String	selectedProductCode,
			String selectedCustomerType, String selectedIsEnabled);
	public String updateMissingFields(String templateId, String templateName, String productCode, String custType, 
			String isEnabled, String userCode, String CURRENTROLE);
	public Map<String, Object> searchAddFieldsToTemplate(String template, String detailType);
	public String updateComplianceScore(String fullData, String searchTemplate, String detailType);
	}
