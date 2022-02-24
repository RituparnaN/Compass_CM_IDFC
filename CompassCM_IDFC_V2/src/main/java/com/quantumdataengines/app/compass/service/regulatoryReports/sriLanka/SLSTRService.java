package com.quantumdataengines.app.compass.service.regulatoryReports.sriLanka;

import java.util.Map;

public interface SLSTRService {
	public Map<String, String> getSLSTR(String caseNo, String userCode);
	public boolean saveSLSTR(String caseNo, Map<String, String> formData, String updatedBy);
}
