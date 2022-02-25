package com.quantumdataengines.app.compass.service.caseWorkFlow;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.caseWorkFlow.FATCACaseWorkFlowDAO;

@Service
public class FATCACaseWorkFlowServiceImpl implements FATCACaseWorkFlowService {
	
	@Autowired
	private FATCACaseWorkFlowDAO fatcaCaseWorkFlowDAO;
	
	@Override
	public List<Map<String, Object>> getModuleParameters(String moduleType, String userCode, String userRole, String ipAddress) {
		return fatcaCaseWorkFlowDAO.getModuleParameters(moduleType, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> searchGenericMaster(Map<String, String> paramMap, String moduleType, String userCode, String userRole, String ipAddress) {
		return fatcaCaseWorkFlowDAO.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> getCaseCommentDetails(String caseNos, String caseStatus, String userCode, String userRole, String ipAddress){
		return fatcaCaseWorkFlowDAO.getCaseCommentDetails(caseNos, caseStatus, userCode, userRole, ipAddress);
	}
	
	@Override
	public Map<String, Object> saveCaseCommentDetails(String caseNos, String caseStatus, HashMap<String, String> commentMapDetails, String userCode, String userRole, String ipAddress){
		return fatcaCaseWorkFlowDAO.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		
	}

	@Override
	public List<Map<String, String>> getListOfUsers() {
		return fatcaCaseWorkFlowDAO.getListOfUsers();
	}

	@Override
	public String assignCaseToRMUser(String caseNo, String caseStatus,
			String caseRangeFrom, String caseRangeTo, String hasOldCases,
			String caseRating, String listOfCaseNos,String branchCode, String listOfUsers,
			String comments, String userCode, String ipAddress, String userRole) {
		return fatcaCaseWorkFlowDAO.assignCaseToRMUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating, branchCode, listOfCaseNos, listOfUsers, comments, userCode, ipAddress, userRole);
	}

}
