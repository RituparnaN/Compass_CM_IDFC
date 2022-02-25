package com.quantumdataengines.app.compass.service.caseWorkFlow;

import java.util.List;
import java.util.Map;

public interface RoboScanService {
	
	public List<String> getRoboscanConfigDetails(String roleId);
	
	//getting roboscan data
		public Map<String, Object>fetchRoboscanData(String caseNos,String userCode,String ipAddress,String CURRENTROLE);
		
		public String saveRoboscanScreeningMapping(String roboscanCaseNo, String uniqueNumber, String fileName, String userCode, String userRole, String ipAddress);

		public Map<String, String> getRoboscanScreeningDetails(String roboscanCaseNo);

}
