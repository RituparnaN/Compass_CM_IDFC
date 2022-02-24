package com.quantumdataengines.app.compass.dao.caseWorkFlow;

import java.util.List;
import java.util.Map;

public interface RoboScanDAO {
	
	public List<String> getRoboscanConfigDetails(String roleId);
	
	public Map<String, Object> fetchRoboscanData(String caseNos,String userCode,String ipAddress,String CURRENTROLE);
	
	public String saveRoboscanScreeningMapping(String roboscanCaseNo, String uniqueNumber, String fileName, String userCode, String userRole, String ipAddress);

	public Map<String, String> getRoboscanScreeningDetails(String roboscanCaseNo);
}
