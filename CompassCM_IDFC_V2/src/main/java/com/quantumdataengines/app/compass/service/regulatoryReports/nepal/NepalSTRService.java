package com.quantumdataengines.app.compass.service.regulatoryReports.nepal;

import java.util.Map;

public interface NepalSTRService {
	public Map<String, String> fetchNepalSTRData(String caseNo, String userCode, String ipAddress, String CURRENTROLE);
	public String saveNEPAL_STR(Map<String,String> paramMap, String caseNo, String userCode);
	public Map<String, Object> getNepalSTRXMLFileContent(String caseNo, String userCode, String ipAddress, String CURRENTROLE);
}
