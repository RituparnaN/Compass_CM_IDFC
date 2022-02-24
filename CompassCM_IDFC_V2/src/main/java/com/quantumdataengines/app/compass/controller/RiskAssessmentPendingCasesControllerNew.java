package com.quantumdataengines.app.compass.controller;

import java.util.Collections;
import java.util.Comparator;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.service.riskAssessmentPendingCasesNew.RiskAssessmentPendingCasesNewService;
//import com.quantumdataengines.app.compass.service.riskAssessmentPendingCases.RiskAssessmentPendingCasesService;

@Controller
@RequestMapping(value="/common")
public class RiskAssessmentPendingCasesControllerNew {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired 
	private GenericMasterService genericMasterService;
	
	@Autowired
	private RiskAssessmentPendingCasesNewService riskAssessmentPendingCasesServiceNew;
	
	@RequestMapping(value="/riskAssessmentPendingCasesNew", method=RequestMethod.GET)
	public String purge(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String moduleType = request.getParameter("moduleType");
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));

		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RiskAssessmentPendingCases", "OPEN", "Module Accessed");
		return "RiskAssessmentPendingCasesNew/index";
	}	
		
	@RequestMapping(value="/checkerActionNew", method=RequestMethod.POST)
	public ResponseEntity<String> checkerAction(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNo = request.getParameter("caseNo");
		String caseId = request.getParameter("caseId");
		String userId = authentication.getPrincipal().toString(); 
		String comments = request.getParameter("comments");
		String checkerAction = request.getParameter("checkerAction");
		String compassRefNo = request.getParameter("compassRefNo");

//		String caseVersion = request.getParameter("caseVersion");
		
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		Map<String,String> userDetails  = new LinkedHashMap<String, String>();
		userDetails.put("userRole", userRole);
		userDetails.put("userCode", authentication.getPrincipal().toString());
		userDetails.put("ipAddress", request.getRemoteAddr().toString());
		
		String caseStatus = riskAssessmentPendingCasesServiceNew.checkerAction(caseNo, caseId, userId, comments, userDetails,checkerAction,compassRefNo);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RiskAssessmentPendingCases", "CHECKERACTION", "Module Accessed");
		return ResponseEntity.ok(caseStatus);
		
	}	
	
	@RequestMapping(value="/escalateCaseNew", method=RequestMethod.POST)
	public ResponseEntity<String> escalateCase(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String caseNo = request.getParameter("caseNo");
		String caseId = request.getParameter("caseId");
		String options = request.getParameter("options");
		String remarks = request.getParameter("remarks");
		String[] checkerList = request.getParameterValues("checkerList");
		String comments = request.getParameter("comments");
		String compassRefNo = request.getParameter("compassRefNo");

		
		String checkers="";
		for(String checker:checkerList) {
			checkers += checker +",";
		}
		
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		Map<String,String> userDetails  = new LinkedHashMap<String, String>();
		userDetails.put("userRole", userRole);
		userDetails.put("userCode", authentication.getPrincipal().toString());
		userDetails.put("ipAddress", request.getRemoteAddr().toString());
		String escalateStatus = riskAssessmentPendingCasesServiceNew.escalateCase(caseNo, caseId, options,remarks,checkers,comments,userDetails,compassRefNo);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "RiskAssessmentPendingCases", "ESCALATECASE", "Module Accessed");
		return ResponseEntity.ok(escalateStatus);
		
	}	
	
	
	
	@RequestMapping(value="/riskAssessmentSearchPendingCasesNew", method=RequestMethod.POST)
	public String searchPendingCases(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		String buttomPageUrl = request.getParameter("bottomPageUrl");
		String submitButton = request.getParameter("submitButton");
		
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName) && !"submitButton".equals(tempParamName)){
				paramTempMap.put(tempParamName, tempParamValue);
			}
		}
		
		
		List<String> paramKeyList = new Vector<String>(paramTempMap.keySet());
		
		Collections.sort(paramKeyList, new Comparator<String>(){
			@Override
			public int compare(String str1, String str2) {
				return  (Integer.parseInt(str1.substring(0, str1.indexOf("_")))) - Integer.parseInt(str2.substring(0, str2.indexOf("_")));
			}
		});
		
		for(String paramName : paramKeyList) {
			String paramValue = formData.get(paramName)[0];
			paramMap.put(paramName, paramValue);
		}
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAdress = request.getRemoteAddr();
		
		System.out.println(paramMap.toString());
		System.out.println(moduleType);
		System.out.println(userCode);
		System.out.println(userRole);
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("moduleName", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("submitButton", submitButton);
		request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PENDING CASES", "SEARCH", "Cases Searched");
		return buttomPageUrl;
	}
	
	@RequestMapping(value="/riskAssessmentPendingCasesNew/getCaseWorkflowModuleDetails", method=RequestMethod.GET)
	public String getModuleDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		System.out.println("in here mann");
		String moduleCode = request.getParameter("moduleCode");
		String moduleValue = request.getParameter("moduleValue");
		String caseId = request.getParameter("caseId");
		String caseVersion = request.getParameter("caseVersion");
		String detailPage = request.getParameter("detailPage");
		String moduleHeader = request.getParameter("moduleHeader");
		String action = request.getParameter("actionType");
		String caseStatus = request.getParameter("caseStatus");
		String flagType = request.getParameter("flagType");
		String parentFormId = request.getParameter("formId");
		String caseNos = moduleValue;
		String addedToMarkedAll = request.getParameter("AddedToMarkedAll");
		String userCode = authentication.getPrincipal().toString();
		String ipAddress = request.getRemoteAddr();
		String userRole = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String compassRefNo = request.getParameter("compassRefNo");
		//sysout

		Map<String, Object> mainMap = riskAssessmentPendingCasesServiceNew.getCaseWorkflowModuleDetails(moduleCode, moduleValue, action,
				userCode, userRole, ipAddress, caseStatus,compassRefNo);
		
		request.setAttribute("moduleDetails", mainMap);
		request.setAttribute("moduleCode", moduleCode);
		request.setAttribute("caseNo", moduleValue);
		request.setAttribute("detailPage", detailPage);
		request.setAttribute("moduleHeader", moduleHeader);
		request.setAttribute("action", action);
		request.setAttribute("flagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		request.setAttribute("userCode", authentication.getPrincipal().toString());
		request.setAttribute("userRole",userRole);
		request.setAttribute("loggedUserRegion", "India");
		request.setAttribute("caseStatus", caseStatus);
		
		request.setAttribute("inputCaseNos",caseNos);
		request.setAttribute("inputCaseStatus",caseStatus);
		request.setAttribute("inputAddedToMarkAll",addedToMarkedAll);
		request.setAttribute("inputLastReviewedDate","N.A.");
		request.setAttribute("inputFromDate",request.getParameter("fromDate"));
		request.setAttribute("inputToDate",request.getParameter("toDate"));
		request.setAttribute("inputAlertCode",request.getParameter("alertCode"));
		request.setAttribute("inputBranchCode",request.getParameter("branchCode"));
		request.setAttribute("inputAccountNo",request.getParameter("accountNo"));
		request.setAttribute("inputCustomerId",request.getParameter("customerId"));
		request.setAttribute("inputHasAnyOldCases",request.getParameter("hasAnyOldCases"));
		request.setAttribute("inputCaseRating",request.getParameter("caseRating"));
		request.setAttribute("inputFromCaseNo",request.getParameter("fromCaseNo"));
		request.setAttribute("inputToCaseNo",request.getParameter("toCaseNo"));
		request.setAttribute("COMPASSREFNO",compassRefNo);
		
		if(!userRole.equals("ROLE_CM_OFFICER")) {
			request.setAttribute("CASEMETADETAILS", riskAssessmentPendingCasesServiceNew.getRFICaseData(caseNos, caseId,caseVersion,
					caseStatus, userCode, userRole, ipAddress, compassRefNo));
		}
		else{
			
			request.setAttribute("APPROVEDCASERESPONSES", riskAssessmentPendingCasesServiceNew.getApprovedCaseResponses(caseNos,moduleValue,caseVersion,
					caseStatus, userCode, userRole, ipAddress, compassRefNo));
		}
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleCode, "SEARCH", moduleValue+" details viewed in tab");
		return detailPage;
	}
	
}