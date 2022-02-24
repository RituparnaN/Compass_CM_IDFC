package com.quantumdataengines.app.compass.service.riskAssessmentPendingCasesNew;

import java.util.List;
import java.util.Map;


public interface RiskAssessmentPendingCasesNewService {
	
	public Map<String,Object> getRFICaseData(String caseNos, String caseId,String caseVersion, String caseStatus, String userCode, String userRole, String ipAddress, String compassRefNo);
	
	public Map<String,Object> getApprovedCaseResponses(String caseNos, String caseId,String caseVersion, String caseStatus, String userCode, String userRole, String ipAddress, String compassRefNo);
	
	public String checkerAction(String caseNo, String caseId, String userId, String comments, Map<String,String> userDetails,String checkerAction, String compassRefNo);
	
	public String escalateCase(String caseNo, String caseId, String options, String remarks, String checkers, String comments,Map<String,String> userDetails, String compassRefNo);
	
	public Map<String, Object> getCaseWorkflowModuleDetails(String moduleCode, String moduleValue, String action, String userCode, String groupCode, String ipAddress, String caseStatus, String compassRefNo);

}
