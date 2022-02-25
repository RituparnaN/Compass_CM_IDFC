package com.quantumdataengines.app.compass.service.userAlertMapping;

import java.util.Map;

public interface UserAlertMappingService {
	public Map<String, String> getUserDetails(String userRole);
	public Map<String, Object> searchUserALertMapping(String mappingType, String userLevel, String userCode);
	public String saveAssignment(String fullData, String currentUser);
}
