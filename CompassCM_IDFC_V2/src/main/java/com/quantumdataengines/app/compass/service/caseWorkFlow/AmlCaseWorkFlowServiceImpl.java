package com.quantumdataengines.app.compass.service.caseWorkFlow;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.caseWorkFlow.AmlCaseWorkFlowDAO;

@Service
public class AmlCaseWorkFlowServiceImpl implements AmlCaseWorkFlowService {
	
	@Autowired
	private AmlCaseWorkFlowDAO amlCaseWorkFlowDAO;
	
	@Override
	public List<Map<String, Object>> getModuleParameters(String moduleType, String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.getModuleParameters(moduleType, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> getCaseCommentDetails(String caseNos, String caseStatus, String userCode, String userRole, String ipAddress){
		return amlCaseWorkFlowDAO.getCaseCommentDetails(caseNos, caseStatus, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> saveCaseCommentDetails(String caseNos, String caseStatus, HashMap<String, String> commentMapDetails, String userCode, String userRole, String ipAddress){
		return amlCaseWorkFlowDAO.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		
	}

	@Override
	public List<Map<String, String>> getListOfUsers() {
		return amlCaseWorkFlowDAO.getListOfUsers();
	}

	@Override
	public String assignCaseToBranchUser(String caseNo, String caseStatus,
			String caseRangeFrom, String caseRangeTo, String hasOldCases,
			String caseRating, String listOfCaseNos,String branchCode, String listOfUsers,
			String comments, String userCode, String ipAddress, String userRole) {
		return amlCaseWorkFlowDAO.assignCaseToBranchUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating, branchCode, listOfCaseNos, listOfUsers, comments, userCode, ipAddress, userRole);
	}

	@Override
	public Map<String, String> getUserDetails(String userRole) {
		return amlCaseWorkFlowDAO.getUserDetails(userRole);
	}
	/*
	@Override
	public Map<String, Object> searchCaseReassignment(String fromDate, String toDate, String reassignmentFor, String pendingWith,
														String pendingUsersCode, String userCode, String groupCode, String ipAddress) {
		return amlCaseWorkFlowDAO.searchCaseReassignment(fromDate, toDate, reassignmentFor, pendingWith, pendingUsersCode, userCode, groupCode, ipAddress);
	}

	@Override
	public List<Map<String, String>> getListOfCurrUser(String roleId,
			String reassignmentFor, String pendingUsersCode) {
		return amlCaseWorkFlowDAO.getListOfCurrUser(roleId, reassignmentFor, pendingUsersCode);
	}

	@Override
	public String reAssignCaseToUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases,
									 String caseRating, String listOfCaseNos, String branchCode, String listOfUsers, String comments, 
									 String fromDate, String toDate, String reassignmentFor, String pendingWith, String pendingUsersCode,
									 String userCode, String ipAddress, String userRole) {
		return amlCaseWorkFlowDAO.reAssignCaseToUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating, listOfCaseNos, branchCode, listOfUsers, comments, fromDate, toDate, reassignmentFor, pendingWith, pendingUsersCode, userCode, ipAddress, userRole);
	}
	*/
	
	@Override
	public Map<String, Object> searchCaseReassignment(String fromDate, String toDate, String reassignmentFor, String pendingWith,
			String pendingWithUsersCode, String closedBy, String closedByUsersCode, String userCode, String groupCode, String ipAddress) {
		return amlCaseWorkFlowDAO.searchCaseReassignment(fromDate, toDate, reassignmentFor, pendingWith, 
								  pendingWithUsersCode, closedBy, closedByUsersCode, userCode, groupCode, ipAddress);
	}

	@Override
	public List<Map<String, String>> getListOfCurrUser(String roleId,
			String reassignmentFor, String pendingWithUsersCode, String closedByUsersCode) {
		return amlCaseWorkFlowDAO.getListOfCurrUser(roleId, reassignmentFor, pendingWithUsersCode, closedByUsersCode);
	}

	@Override
	public String reAssignCaseToUser(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo, String hasOldCases,
									 String caseRating, String listOfCaseNos, String branchCode, String listOfUsers, String comments, 
									 String fromDate, String toDate, String reassignmentFor, String pendingWith, String pendingWithUsersCode,
									 String closedBy, String closedByUsersCode, String reassignmentReason, String ageingFor, String userCode, String ipAddress, String userRole) {
		return amlCaseWorkFlowDAO.reAssignCaseToUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating, 
								listOfCaseNos, branchCode, listOfUsers, comments, fromDate, toDate, reassignmentFor, pendingWith,
								closedBy, closedByUsersCode, pendingWithUsersCode, reassignmentReason, ageingFor, userCode, ipAddress, userRole);
	}
	
	@Override
	public Map<String, Object> getCaseWorkflowModuleDetails(String moduleCode,String moduleValue, String action, String userCode, String groupCode,String ipAddress, String caseStatus) {
		return amlCaseWorkFlowDAO.getCaseWorkflowModuleDetails(moduleCode, moduleValue, action, userCode, groupCode, ipAddress, caseStatus);
	}

	@Override
	public Map<String, Object> hasDistinctCustId(String caseNo, String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.hasDistinctCustId(caseNo, userCode, userRole, ipAddress);
	}

	@Override
	public ArrayList<String> amlUserAgainstCaseNo(String caseNo,String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.amlUserAgainstCaseNo(caseNo,userCode,userRole,ipAddress);
	}

	/*@Override
	public Map<String, Object> saveCommentWhileReAllocatingToAMLUser(Map<String, String> parameter) {
		// TODO Auto-generated method stub
		return amlCaseWorkFlowDAO.saveCommentWhileReAllocatingToAMLUser(parameter);
	}*/

	@Override
	public Map<String, Object> saveCommentWhileReAssigningToAMLUser(
			String caseNos, String caseStatus,HashMap<String, String> commentMapDetails, String userCode,String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.saveCommentWhileReAssigningToAMLUser(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> saveCommentWhileReAllocatingToAMLUser(String caseNos, String caseStatus,HashMap<String, String> commentMapDetails, String userCode,
			String userRole, String ipAddress) {
		return  amlCaseWorkFlowDAO.saveCommentWhileReAllocatingToAMLUser(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
	}

	@Override
	public List<Map<String, String>> getAMLUserAMLOMappingDetails(
			String userCode, String userRole) {
		return amlCaseWorkFlowDAO.getAMLUserAMLOMappingDetails(userCode, userRole);
	}

	@Override
	public List<Map<String, String>> getAMLOMLROMappingDetails(String userCode,
			String userRole) {
		return amlCaseWorkFlowDAO.getAMLOMLROMappingDetails(userCode, userRole);
	}

	@Override
	public int getEvidenceAttachedCount(String caseNos,
			String userCode, String userRole) {
		return amlCaseWorkFlowDAO.getEvidenceAttachedCount(caseNos, userCode, userRole);
	}

	@Override
	public List<Map<String, String>> getSuspicionIndicators(String caseNos, String caseStatus, String action, 
			String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.getSuspicionIndicators(caseNos, caseStatus, action, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> getAlertsForAddingToFalsePositive(String caseNo,
			String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.getAlertsForAddingToFalsePositive(caseNo, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, String> getDetailsForUpdatingFalsePositive(
			String caseNo, String refNo) {
		return amlCaseWorkFlowDAO.getDetailsForUpdatingFalsePositive(caseNo, refNo);
	}

	@Override
	public String saveToFalsePositive(String caseNo, String refNo, String activeFrom, String activeTo, String isEnabled,
			String reason, String toleranceLevel, String isToBeDeleted,	String userCode) {
		return amlCaseWorkFlowDAO.saveToFalsePositive(caseNo, refNo, activeFrom, activeTo, isEnabled, reason, 
				toleranceLevel, isToBeDeleted, userCode);
	}

	@Override
	public Map<String, Object> getAlertsDetailsForAssignment(
			String caseNo, String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.getAlertsDetailsForAssignment(caseNo, userCode, userRole, ipAddress);
	}

	@Override
	public List<Map<String, String>> getAllUserList(String caseNos, String action,String caseStatus, String userCode, String userRole,
			String ipAddress) {
		return amlCaseWorkFlowDAO.getAllUserList(caseNos, action, caseStatus, userCode, userRole, ipAddress);
	}

	@Override	
	public List<Map<String, String>> getAllBranchesList(String caseNos, String userCode, String userRole, String ipAddress) {
		return amlCaseWorkFlowDAO.getAllBranchesList(caseNos, userCode, userRole, ipAddress);
	}

	@Override
	public Map<String, Object> searchCasesForSelfAssignment(String fromDate, String toDate, String customerId,
			String customerType, String caseRangeFrom, String caseRangeTo, String userCode, String groupCode, String ipAddress) {
		return amlCaseWorkFlowDAO.searchCasesForSelfAssignment(fromDate, toDate, customerId, customerType, caseRangeFrom, caseRangeTo, userCode, groupCode, ipAddress);
	}

	@Override
	public String assignCasesToSelf(String caseNo, String caseStatus, String caseRangeFrom, String caseRangeTo,
			String listOfCustType, String listOfCustId, String listOfBranchCodes, String listOfCaseNos,
			String maxCaseCount, String comments, String userCode, String ipAddress, String userRole) {
		return amlCaseWorkFlowDAO.assignCasesToSelf(caseNo, caseStatus, caseRangeFrom, caseRangeTo, listOfCustType, listOfCustId, listOfBranchCodes, listOfCaseNos, maxCaseCount, comments, userCode, ipAddress, userRole);
	}
	
}
