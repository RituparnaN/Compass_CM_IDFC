package com.quantumdataengines.app.compass.service.regulatoryReports.maldives;

import java.util.Map;

public interface MaldivesSTRService {
	public Map<String, String> fetchMaldivesSTRData(String caseNo, String userCode, String ipAddress, String CURRENTROLE);
	public String saveMALDIVES_STR(Map<String,String> paramMap, String caseNo, String userCode);
}
