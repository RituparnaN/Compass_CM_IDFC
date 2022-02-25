package com.quantumdataengines.app.compass.dao.scanning;

import java.util.Map;

public interface TemplateScreeningDAO {
	public Map checkTemplateId(String templateId);
	public Map<String, Object> searchTemplateScreening(String templateId, String templateName, String templateType, String templateDate, String userCode, String userRole, String ipAddress, String subModuleCode);
	public Map<String, Object> createTemplateScreening(String templateId, String templateName, String templateType, String userCode, String userRole, String ipAddress);
	public Map<String, Object> templateScreeningDetail(String templateId, String userCode, String userRole, String ipAddress, String subModuleCode);
	public String insertDetailForTemplateScreening(String templateId, String templateName, String nameValue, String countryValue, String idValue, String userCode, String userRole, String ipAddress);
	public String deleteTemplateDetails(String templateId, String templateName, String seqNo, String userCode, String userRole, String ipAddress);
	public String getTemplateFieldValues(String templateSeqNo, String fieldType);
	public String saveScreeningMapping(String templateSeqNo, String uniqueNumber, String fileName, String userCode, String userRole, String ipAddress);
	
	public Map<String, Object> createAndFreeze(String templateSeqNo, String templateId, String userCode, String userRole, String ipAddress);
	public Map<String, Object> createNewVersion(String templateSeqNo, String templateId, String userCode, String userRole, String ipAddress);
	public Map<String, String> getTemplateScreeningDetails(String templateSeqNo);
	public Map<String, Object> updateTemplateScreeningStatus(String templateSeqNo, String templateScreeningStatus, String userComments, String userCode, String userRole, String ipAddress);
}
