package com.quantumdataengines.app.compass.dao.regulatoryReports.UK;

import java.util.Map;

public interface UKSARDAO {
	public Map<String, String> fetchUKSARData(String caseNo, String userCode, String ipAddress, String CURRENTROLE);
	public String saveUKSAR(Map<String,String> paramMap, String caseNo, String userCode);
}
