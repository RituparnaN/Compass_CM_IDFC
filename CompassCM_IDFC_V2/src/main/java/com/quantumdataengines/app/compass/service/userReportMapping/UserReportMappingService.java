package com.quantumdataengines.app.compass.service.userReportMapping;

import java.util.Map;

public interface UserReportMappingService {
	public Map<String, Object> userReportMapping();
	public Map<String, Object> searchUserReportMapping(String selectedUserCode, String reportType, String reportId, String userCode, 
			String userRole, String ipAddress);
	public String saveUserReportMapping(String fullData, String currentUser);
}
