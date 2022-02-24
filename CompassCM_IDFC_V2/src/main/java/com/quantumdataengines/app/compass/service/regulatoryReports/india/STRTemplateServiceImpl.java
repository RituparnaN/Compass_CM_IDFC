package com.quantumdataengines.app.compass.service.regulatoryReports.india;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.regulatoryReports.india.STRTemplateDAO;

@Service
public class STRTemplateServiceImpl implements STRTemplateService {

	@Autowired
	private STRTemplateDAO strTemplateDAO;
	
	public List<String> getAllVariables() {
		return strTemplateDAO.getAllVariables();
	}

	public Map<String, String> getTemplateDetails(String templateId) {
		return strTemplateDAO.getTemplateDetails(templateId);
	}

	public List<Map<String, String>> getAllSTRTemplate() {
		return strTemplateDAO.getAllSTRTemplate();
	}
	
	public List<Map<String, String>> getAllTypeOfSuspicions() {
		return strTemplateDAO.getAllTypeOfSuspicions();
	}

	public String addUpdateSTRTemplate(Map<String, String> formData, String userCode) {
		return strTemplateDAO.addUpdateSTRTemplate(formData, userCode);
	}
	
	public String generateAutoSTR(Map<String, String> formDate, String userId, String groupCode){
		return strTemplateDAO.generateAutoSTR(formDate, userId, groupCode);
	}
	
	public List<Map<String, String>> selectAccountNumbers(String primaryCustomerId, String secondaryCustomerId){
		return strTemplateDAO.selectAccountNumbers(primaryCustomerId, secondaryCustomerId);
	}
	
	public String generateGOS(String primaryCustomerId, String secondaryCustomerId, String accountNumbers, String templateId, String fromDate, String toDate, String caseNo){
		return strTemplateDAO.generateGOS(primaryCustomerId, secondaryCustomerId, accountNumbers, templateId, fromDate, toDate, caseNo);
	}
}
