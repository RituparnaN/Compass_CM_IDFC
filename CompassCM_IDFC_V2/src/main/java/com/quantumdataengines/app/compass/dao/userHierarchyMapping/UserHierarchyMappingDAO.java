package com.quantumdataengines.app.compass.dao.userHierarchyMapping;

import java.util.List;
import java.util.Map;

public interface UserHierarchyMappingDAO {
	public Map<String, String> getUserDetails(String userRole);
	public List<Map<String, String>> searchUserHierarchyMapping(String mappingType, String mappingAMLUsersCode, 
			   String mappingAMLOUsersCode, String mappingMLROUsersCode);
	public String saveMapping(String fullData, String mappingType, String currentUser, String currentRole, String ipAddress);
	
	public Map<String, String> getUsersList(String userRole, String column);
	public List<Map<String, String>> searchReportingUsersMapping(String userCodeField, String reportingUserCodeField, String reviewersCodeField, String statusField);
	public String saveMappingRepUser(String fullData, String makerComments, String currentUser, String currentRole, String ipAddress);
	public List<Map<String, String>> getReportingUserComments(String userCode, String currentUser, String currentRole, String ipAddress);
	public String approveOrRejectRepUser(String fullData, String actionToTake, String currentUser, String currentRole, String ipAddress);
	public List<String> getAllUserList(String column);
}
