package com.quantumdataengines.app.compass.service.missingFieldsTemplate;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.missingFieldsTemplate.MissingFieldsTemplateDAO;

@Service
public class MissingFieldsTemplateServiceImpl implements MissingFieldsTemplateService{

	@Autowired
	private MissingFieldsTemplateDAO missingFieldsTemplateDAO;

	@Override
	public Map<String, Map<String, String>> getRequiredFields() {
		return missingFieldsTemplateDAO.getRequiredFields();
	}

	@Override
	public Map<String, Object> searchMissingFields(String templateId,
			String templateName, String productCode, String custType,
			String isEnabled) {
		return missingFieldsTemplateDAO.searchMissingFields(templateId, templateName, productCode, custType, isEnabled);
	}

	@Override
	public Map<String, Object> addMissingFieldsTemplate(String templateId,
			String templateName, String productCode, String custType,
			String isEnabled, String userCode, String CURRENTROLE) {
		return missingFieldsTemplateDAO.addMissingFieldsTemplate(templateId, templateName, productCode, custType, isEnabled, userCode, CURRENTROLE);
	}

	@Override
	public Map<String, String> fetchMissingFieldsToUpdate(
			String selectedTempId, String selectedTempName,
			String selectedProductCode, String selectedCustomerType,
			String selectedIsEnabled) {
		return missingFieldsTemplateDAO.fetchMissingFieldsToUpdate(selectedTempId, selectedTempName, selectedProductCode, selectedCustomerType, selectedIsEnabled);
	}

	@Override
	public String updateMissingFields(String templateId,
			String templateName, String productCode, String custType,
			String isEnabled, String userCode, String CURRENTROLE) {
		return missingFieldsTemplateDAO.updateMissingFields(templateId, templateName, productCode, custType, isEnabled, userCode, CURRENTROLE);
	}

	@Override
	public Map<String, Object> searchAddFieldsToTemplate(String template,
			String detailType) {
		return missingFieldsTemplateDAO.searchAddFieldsToTemplate(template, detailType);
	}

	@Override
	public String updateComplianceScore(String fullData, String searchTemplate, String detailType) {
		return missingFieldsTemplateDAO.updateComplianceScore(fullData, searchTemplate, detailType);
	}

	
	
}
