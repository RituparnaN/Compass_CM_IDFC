package com.quantumdataengines.app.compass.service.caseWorkFlow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public interface AmlCaseWorkFlowService {
	public List<Map<String, Object>> getModuleParameters(String moduleType, String userCode, String userRole, String ipAddress);
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress);
	public Map<String, Object> getCaseCommentDetails(String caseNos, String caseStatus, String userCode, String userRole, String ipAddress);
	public Map<String, Object> saveCaseCommentDetails(String caseNos, String caseStatus, HashMap<String, String> commentMapDetails, String userCode, String userRole, String ipAddress);
	public List<Map<String, String>> getListOfUsers();
	public String assignCaseToBranchUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, String caseRating, String listOfCaseNos, 
			String branchCode, String listOfUsers, String comments, String userCode, String ipAddress, String userRole);
	public Map<String, String> getUserDetails(String userRole);
	/*
	public Map<String, Object> searchCaseReassignment(String fromDate, String toDate, String reassignmentFor, String pendingWith, 
			String pendingUsersCode, String userCode, String groupCode, String ipAddress);
	public List<Map<String, String>> getListOfCurrUser(String roleId, String reassignmentFor, String pendingUsersCode);
	public String reAssignCaseToUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, String caseRating, String listOfCaseNos, 
			String branchCode, String listOfUsers, String comments, 
			String fromDate, String toDate, String reassignmentFor, String pendingWith, String pendingUsersCode, 
			String userCode, String ipAddress, String userRole);
	*/
	public Map<String, Object> searchCaseReassignment(String fromDate, String toDate, String reassignmentFor, String pendingWith, 
			String pendingWithUsersCode, String closedBy, String closedByUsersCode, String userCode, String groupCode, String ipAddress);
	public List<Map<String, String>> getListOfCurrUser(String roleId, String reassignmentFor, String pendingWithUsersCode, String closedByUsersCode);
	public String reAssignCaseToUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases, String caseRating, String listOfCaseNos, 
			String branchCode, String listOfUsers, String comments, String fromDate, String toDate, String reassignmentFor, 
			String pendingWith, String pendingWithUsersCode, String closedBy, String closedByUsersCode, String reassignmentReason, String ageingFor, String userCode, String ipAddress, String userRole);
	public Map<String, Object> getCaseWorkflowModuleDetails(String moduleCode, String moduleValue, String action, String userCode, String groupCode, String ipAddress, String caseStatus);
	public Map<String, Object> hasDistinctCustId(String caseNo, String userCode, String userRole, String ipAddress);
	public ArrayList<String> amlUserAgainstCaseNo(String caseNo, String userCode,String userRole,String ipAddress);
	/*public Map<String, Object> saveCommentWhileReAllocatingToAMLUser(Map<String, String> parameter);*/
	public Map<String, Object> saveCommentWhileReAssigningToAMLUser(String caseNos,String caseStatus, HashMap<String, String> commentMapDetails,
			String userCode, String userRole, String ipAddress);
	public Map<String, Object> saveCommentWhileReAllocatingToAMLUser(String caseNos, String caseStatus,HashMap<String, String> commentMapDetails, String userCode,
			String userRole, String ipAddress);
	public List<Map<String, String>> getAMLUserAMLOMappingDetails(String userCode, String userRole);
	public List<Map<String, String>> getAMLOMLROMappingDetails(String userCode, String userRole);
	public int getEvidenceAttachedCount(String caseNos, String userCode, String userRole);
	public List<Map<String,String>> getSuspicionIndicators(String caseNos, String caseStatus, String action, 
			   String userCode, String userRole, String ipAddress);
	public Map<String, Object> getAlertsForAddingToFalsePositive(String caseNo, String userCode, String userRole, String ipAddress);
	public Map<String, String> getDetailsForUpdatingFalsePositive(String caseNo, String refNo);
	public String saveToFalsePositive(String caseNo, String refNo, String activeFrom, String activeTo, String isEnabled, 
			   String reason, String toleranceLevel, String isToBeDeleted, String userCode);
	public Map<String, Object> getAlertsDetailsForAssignment(String caseNo, String userCode, String userRole, String ipAddress);
	public List<Map<String, String>> getAllUserList(String caseNos, String action, String caseStatus, String userCode, String userRole, String ipAddress);
	public List<Map<String, String>> getAllBranchesList(String caseNos, String userCode, String userRole, String ipAddress);
	public Map<String, Object> searchCasesForSelfAssignment(String fromDate, String toDate, String customerId, String customerType, 
			String caseRangeFrom, String caseRangeTo, String userCode, String groupCode, String ipAddress);
	public String assignCasesToSelf(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String listOfCustType, 
			String listOfCustId, String listOfBranchCodes, String listOfCaseNos, String maxCaseCount, String comments, String userCode, 
			String ipAddress, String userRole);
}
