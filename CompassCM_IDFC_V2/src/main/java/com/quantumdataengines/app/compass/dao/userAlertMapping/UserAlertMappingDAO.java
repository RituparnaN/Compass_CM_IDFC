package com.quantumdataengines.app.compass.dao.userAlertMapping;

import java.util.Map;

public interface UserAlertMappingDAO {
	public Map<String, String> getUserDetails(String userRole);
	public Map<String, Object> searchUserALertMapping(String mappingType, String userLevel, String userCode);
	public String saveAssignment(String fullData, String currentUser);
}
