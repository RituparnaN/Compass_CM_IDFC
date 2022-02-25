package com.quantumdataengines.app.compass.service.riskAssessmentPendingCases;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.quantumdataengines.app.compass.dao.riskAssessmentPendingCases.RiskAssessmentPendingCasesDAO ;

@Service
public class RiskAssessmentPendingCasesServiceImpl implements RiskAssessmentPendingCasesService{
	@Autowired
	public RiskAssessmentPendingCasesDAO riskAssessmentPendingCasesDAO;
	
	@Override
	public String checkerAction(String caseNo, String caseId, String userId, String comments, Map<String,String> userDetails,String checkerAction, String compassRefNo){
		return riskAssessmentPendingCasesDAO.checkerAction(caseNo, caseId, userId, comments, userDetails, checkerAction,compassRefNo);
	}

	@Override
	public Map<String, Object> getCaseWorkflowModuleDetails(String moduleCode,String moduleValue, String action, String userCode, String groupCode,String ipAddress, String caseStatus, String compassRefNo) {
		return riskAssessmentPendingCasesDAO.getCaseWorkflowModuleDetails(moduleCode, moduleValue, action, userCode, groupCode, ipAddress, caseStatus, compassRefNo);
	}
	
	@Override
	public Map<String,Object> getRFICaseData(String caseNos, String caseId, String caseVersion, String caseStatus, String userCode, String userRole, String ipAddress, String compassRefNo)
	{
		return riskAssessmentPendingCasesDAO.getRFICaseData(caseNos,caseId,caseVersion,caseStatus,userCode,userRole,ipAddress,compassRefNo);
	}
	
	@Override
	public Map<String,Object> getApprovedCaseResponses(String caseNos, String caseId, String caseVersion, String caseStatus, String userCode, String userRole, String ipAddress, String compassRefNo)
	{
		return riskAssessmentPendingCasesDAO.getApprovedCaseResponses(caseNos,caseId,caseVersion,caseStatus,userCode,userRole,ipAddress,compassRefNo);
	}
	
	@Override
	public String escalateCase(String caseNo, String caseId, String options, String remarks, String checkers, String comments,Map<String,String> userDetails, String compassRefNo){
		return riskAssessmentPendingCasesDAO.escalateCase(caseNo, caseId, options,remarks,checkers,comments, userDetails,compassRefNo);
	}
}
