package com.quantumdataengines.app.compass.dao.userReportMapping;

import java.util.Map;

public interface UserReportMappingDAO {
	public Map<String, Object> userReportMapping();
	public Map<String, Object> searchUserReportMapping(String selectedUserCode, String reportType, String reportId, String userCode, 
			String userRole, String ipAddress);
	public String saveUserReportMapping(String fullData, String currentUser);
}
