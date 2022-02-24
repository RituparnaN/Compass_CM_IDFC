package com.quantumdataengines.app.compass.service.caseWorkFlow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface FATCACaseWorkFlowService {
	public List<Map<String, Object>> getModuleParameters(String moduleType, String userCode, String userRole, String ipAddress);
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress);
	public Map<String, Object> getCaseCommentDetails(String caseNos, String caseStatus, String userCode, String userRole, String ipAddress);
	public Map<String, Object> saveCaseCommentDetails(String caseNos, String caseStatus, HashMap<String, String> commentMapDetails, String userCode, String userRole, String ipAddress);
	public List<Map<String, String>> getListOfUsers();
	public String assignCaseToRMUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, String caseRating, String listOfCaseNos, 
			String branchCode, String listOfUsers, String comments, String userCode, String ipAddress, String userRole);
}
