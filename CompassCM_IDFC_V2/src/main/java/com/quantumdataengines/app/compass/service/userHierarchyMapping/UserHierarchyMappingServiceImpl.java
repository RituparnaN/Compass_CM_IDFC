package com.quantumdataengines.app.compass.service.userHierarchyMapping;


import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.userHierarchyMapping.UserHierarchyMappingDAO;

@Service
public class UserHierarchyMappingServiceImpl implements UserHierarchyMappingService{

	@Autowired
	private UserHierarchyMappingDAO userHierarchyMappingDAO;

	@Override
	public Map<String, String> getUserDetails(String userRole) {
		return userHierarchyMappingDAO.getUserDetails(userRole);
	}

	@Override
	public List<Map<String, String>> searchUserHierarchyMapping(String mappingType, String mappingAMLUsersCode,
			String mappingAMLOUsersCode, String mappingMLROUsersCode) {
		return userHierarchyMappingDAO.searchUserHierarchyMapping(mappingType, mappingAMLUsersCode, mappingAMLOUsersCode, mappingMLROUsersCode);
	}

	@Override
	public String saveMapping(String fullData, String mappingType, String currentUser, String currentRole, String ipAddress) {
		return userHierarchyMappingDAO.saveMapping(fullData, mappingType, currentUser, currentRole, ipAddress);
	}

	@Override
	public Map<String, String> getUsersList(String userRole, String column) {
		return userHierarchyMappingDAO.getUsersList(userRole, column);
	}
	
	@Override
	public List<Map<String, String>> searchReportingUsersMapping(String userCodeField, String reportingUserCodeField, String reviewersCodeField, String statusField) {
		return userHierarchyMappingDAO.searchReportingUsersMapping(userCodeField, reportingUserCodeField, reviewersCodeField, statusField);
	}
	
	@Override
	public String saveMappingRepUser(String fullData, String makerComments, String currentUser, String currentRole, String ipAddress) {
		return userHierarchyMappingDAO.saveMappingRepUser(fullData, makerComments, currentUser, currentRole, ipAddress);
	}
	
	@Override
	public List<Map<String, String>> getReportingUserComments(String userCode, String currentUser, String currentRole, String ipAddress) {
		return userHierarchyMappingDAO.getReportingUserComments(userCode, currentUser, currentRole, ipAddress);
	}
	
	@Override
	public String approveOrRejectRepUser(String fullData, String actionToTake, String currentUser, String currentRole, String ipAddress) {
		return userHierarchyMappingDAO.approveOrRejectRepUser(fullData, actionToTake, currentUser, currentRole, ipAddress);
	}

	@Override
	public List<String> getAllUserList(String column) {
		return userHierarchyMappingDAO.getAllUserList(column);
	}
}
