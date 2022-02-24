package com.quantumdataengines.app.compass.controller.caseWorkFlow;

import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
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
import org.springframework.http.HttpStatus;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.caseWorkFlow.FATCACaseWorkFlowService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;

@Controller
@RequestMapping("/fatcaCaseWorkFlow")
public class FATCACaseWorkFlowController {
	private static final Logger log = LoggerFactory.getLogger(FATCACaseWorkFlowController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	@Autowired
	private FATCACaseWorkFlowService fatcaCaseWorkFlowService;
	
	@RequestMapping(value="/fatcaPendingCases", method=RequestMethod.GET)
	public String fatcaPendingCases(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "";
		
		if(CURRENTROLE.equals("ROLE_USER")){
			page = "/user/pendingCase";
		}
		/*
		Enumeration<String> paramEnum = request.getParameterNames();
		while (paramEnum.hasMoreElements()) {
			String paramName = paramEnum.nextElement();
			String paramValue = request.getParameter(paramName);
		}
		// return "redirect:"+page;
		return "forward:"+page;
		*/
		
		if(CURRENTROLE.equals("ROLE_FATCARMUSER")){
			page = "FATCACaseWorkFlow/FATCARMUser/PendingCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_FATCAUSER")){
			page = "FATCACaseWorkFlow/FATCAUser/PendingCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_FATCAOFFICER")){
			page = "FATCACaseWorkFlow/FATCAOfficer/PendingCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_FATCAMANAGER")){
			page = "FATCACaseWorkFlow/FATCAManager/PendingCases/index";
		}
		
		
		String moduleType = "fatcaPendingCases";
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA PENDING CASES", "OPEN", "Module Accessed");
		return page;
		
	}

	@RequestMapping(value="/fatcaClosedCasesByLowerUsers", method=RequestMethod.GET)
	public String fatcaClosedCasesByLowerUsers(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "";
		
		if(CURRENTROLE.equals("ROLE_FATCARMUSER")){
			page = "FATCACaseWorkFlow/FATCARMUser/PendingCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_FATCAUSER")){
			page = "FATCACaseWorkFlow/FATCAUser/ClosedCasesWithUser/index";
		}
		else if(CURRENTROLE.equals("ROLE_FATCAOFFICER")){
			page = "FATCACaseWorkFlow/FATCAOfficer/ClosedCasesWithFATCAUser/index";
		}
		else if(CURRENTROLE.equals("ROLE_FATCAMANAGER")){
			page = "FATCACaseWorkFlow/FATCAManager/ClosedCasesWithFATCAOfficer/index";
		}
		else if(CURRENTROLE.equals("ROLE_FATCAAUDITUSER")){
			page = "FATCACaseWorkFlow/FATCAAuditUser/ReviewCases/index";
		}
		
		
		String moduleType = "fatcaClosedCasesByLowerUsers";
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA CLOSED CASES", "OPEN", "Module Accessed");
		return page;
		
	}
	
	@RequestMapping(value="/fatcaAddViewComments", method=RequestMethod.GET)
	public String fatcaAddViewComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "FATCACaseWorkFlow/AddViewCommentsNew";
		
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String parentFormId = request.getParameter("formId");
		String ipAddress = request.getRemoteAddr();
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("FlagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("CASECOMMENTDETAILS", fatcaCaseWorkFlowService.getCaseCommentDetails(caseNos, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());

		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA CASE WORKFLOW", "OPEN", "Add/View Comments");
		return page;
		//return "forward:"+page;
		
	}
	
	@RequestMapping(value="/fatcaSaveComments", method=RequestMethod.POST)
	@ResponseStatus(value=HttpStatus.OK)
	public @ResponseBody Map fatcaSaveComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "FATCACaseWorkFlow/AddViewCommentsNew";
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String comments = request.getParameter("Comments");
		String fraudIndicator = request.getParameter("FraudIndicator");
		String removalReason = request.getParameter("RemovalReason");
		String outcomeIndicator = request.getParameter("OutcomeIndicator");
		String highRiskReasonCode = request.getParameter("HighRiskReasonCode");
		String addedToFalsePositive = request.getParameter("AddedToFalsePositive");
		String lastReviewedDate = request.getParameter("LastReviewedDate");
		
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNos);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("comments",comments);
		commentMapDetails.put("fraudIndicator",fraudIndicator);
		commentMapDetails.put("removalReason",removalReason);
		commentMapDetails.put("outcomeIndicator",outcomeIndicator);
		commentMapDetails.put("highRiskReasonCode",highRiskReasonCode);
		commentMapDetails.put("addedToFalsePositive",addedToFalsePositive);
		commentMapDetails.put("lastReviewedDate",lastReviewedDate);
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("FlagType", flagType);
		request.setAttribute("ActionType", "saveComments");
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		
		Map returnMap = fatcaCaseWorkFlowService.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		request.setAttribute("CASECOMMENTDETAILS", returnMap);
		
		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "FATCA", "INSERT", "Comment Saved for Case No. "+caseNos);
		return returnMap;
		//return "forward:"+page;
		
	}

	@RequestMapping(value="/assignToRMUser", method=RequestMethod.GET)
	public String assignToRMUser(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
	String caseNos = request.getParameter("CaseNos");
	String caseStatus = request.getParameter("CaseStatus");
	String formId = request.getParameter("formId");
	String parentFormId = request.getParameter("formId");
	/*String userCode = authentication.getPrincipal().toString();
	String ipAddress = request.getRemoteAddr();
	*/
	request.setAttribute("formId", formId);
	request.setAttribute("parentFormId", parentFormId);
	request.setAttribute("caseStatus", caseStatus);
	request.setAttribute("USERSLIST", fatcaCaseWorkFlowService.getListOfUsers());
	request.setAttribute("caseNo", caseNos);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CASE REASSIGNMENT", "OPEN", "Module Accessed");
	return "FATCACaseWorkFlow/AssignToRMUser";
	}
	
	@RequestMapping(value="/assignCaseToRMUser", method=RequestMethod.POST)
	public @ResponseBody String assignCaseToRMUser(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
	String caseNo = request.getParameter("caseNo");
	String caseStatus = request.getParameter("caseStatus");
	String caseRangeFrom = request.getParameter("caseRangeFrom");
	String caseRangeTo = request.getParameter("caseRangeTo");
	String hasOldCases = request.getParameter("hasOldCases");
	String caseRating = request.getParameter("caseRating");
	String branchCode = request.getParameter("branchCode");
	String listOfCaseNos = request.getParameter("listOfCaseNos");
	String listOfUsers = request.getParameter("listOfUsers");
	String comments = request.getParameter("comments");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	String ipAddress = request.getRemoteAddr();
	
	String parentFormId = request.getParameter("formId");
	request.setAttribute("parentFormId", parentFormId);
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CASE REASSIGNMENT", "OPEN", "Module Accessed");
	return fatcaCaseWorkFlowService.assignCaseToRMUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating,
			branchCode,listOfCaseNos, listOfUsers, comments, userCode, ipAddress, userRole);
	}

	@RequestMapping(value="/searchPendingCases", method=RequestMethod.POST)
	public String searchPendingCases(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		String buttomPageUrl = request.getParameter("bottomPageUrl");

		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)){
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
		
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PENDING CASES", "SEARCH", "Cases Searched");
		return buttomPageUrl;
	}


	@RequestMapping(value="/searchClosedCases", method=RequestMethod.POST)
	public String searchClosedCases(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		Map<String, String> paramMap = new LinkedHashMap<String, String>();
		Map<String, String> paramTempMap = new LinkedHashMap<String, String>();
		String moduleType = request.getParameter("moduleType");
		String buttomPageUrl = request.getParameter("bottomPageUrl");

		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)){
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
		
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CLOSED CASES", "SEARCH", "Cases Searched");
		return buttomPageUrl;
	}


}
