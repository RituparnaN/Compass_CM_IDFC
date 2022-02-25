package com.quantumdataengines.app.compass.service.userCaseMapping;

import java.util.List;
import java.util.Map;

public interface UserCaseMappingService {
	public List<Map<String, String>> getUserDetailsForUserCaseMapping(String userRole);
	public String saveUserCaseAssignment(String fullData, String makerComments, String currentUser, String currentRole, String ipAddress);
	public String approveOrRejectUserCaseAssignment(String fullData, String action, String checkerComments, String currentUser, String currentRole, String ipAddress);
}
