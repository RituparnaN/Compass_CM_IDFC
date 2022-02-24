package com.quantumdataengines.app.compass.dao.regulatoryReports.india;

import java.util.List;
import java.util.Map;

public interface STRTemplateDAO {
	public List<String> getAllVariables();
	public Map<String, String> getTemplateDetails(String templateId);
	public List<Map<String, String>> getAllSTRTemplate();
	public List<Map<String, String>> getAllTypeOfSuspicions();
	public String addUpdateSTRTemplate(Map<String, String> formData, String userCode);
	public String generateAutoSTR(Map<String, String> formDate, String userId, String groupCode);
	public List<Map<String, String>> selectAccountNumbers(String primaryCustomerId, String secondaryCustomerId);
	public String generateGOS(String primaryCustomerId, String secondaryCustomerId, String accountNumbers, String templateId, String fromDate, String toDate, String caseNo);
}
