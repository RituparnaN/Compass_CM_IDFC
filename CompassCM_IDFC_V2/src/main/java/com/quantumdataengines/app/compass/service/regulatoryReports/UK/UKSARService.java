package com.quantumdataengines.app.compass.service.regulatoryReports.UK;

import java.util.Map;

public interface UKSARService {
	public Map<String, String> fetchUKSARData(String caseNo, String userCode, String ipAddress, String CURRENTROLE);
	public String saveUKSAR(Map<String,String> paramMap, String caseNo, String userCode);
}
