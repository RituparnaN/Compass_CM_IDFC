package com.quantumdataengines.app.compass.dao.regulatoryReports.maldives;

import java.util.Map;

public interface MaldivesSTRDAO {
	public Map<String, String> fetchMaldivesSTRData(String caseNo, String userCode, String ipAddress, String CURRENTROLE);
	public String saveMALDIVES_STR(Map<String,String> paramMap, String caseNo, String userCode);
}
