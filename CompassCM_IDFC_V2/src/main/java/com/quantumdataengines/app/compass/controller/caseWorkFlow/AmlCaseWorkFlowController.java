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

import oracle.net.aso.i;

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
import com.quantumdataengines.app.compass.service.caseWorkFlow.AmlCaseWorkFlowService;
import com.quantumdataengines.app.compass.service.master.GenericMasterService;
import com.quantumdataengines.app.compass.util.CommonUtil;

@Controller
@RequestMapping("/amlCaseWorkFlow")
public class AmlCaseWorkFlowController {
	private static final Logger log = LoggerFactory.getLogger(AmlCaseWorkFlowController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private GenericMasterService genericMasterService;
	@Autowired
	private AmlCaseWorkFlowService amlCaseWorkFlowService;
	
	@RequestMapping(value="/pendingCases", method=RequestMethod.GET)
	public String pendingCase(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
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
		
		if(CURRENTROLE.equals("ROLE_USER")){
			page = "AMLCaseWorkFlow/User/PendingCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_BRANCHUSER")){
			page = "AMLCaseWorkFlow/BranchUser/PendingCases/index";
		}
		// else if(CURRENTROLE.equals("ROLE_AMLUSER")){
		else if(CURRENTROLE.contains("AMLUSER")){
			page = "AMLCaseWorkFlow/AMLUser/PendingCases/index";
		}
		// else if(CURRENTROLE.equals("ROLE_AMLO")){
		else if(CURRENTROLE.contains("AMLO")){
			page = "AMLCaseWorkFlow/AMLO/PendingCases/index";
		}
		// else if(CURRENTROLE.equals("ROLE_MLRO")){
		else if(CURRENTROLE.contains("MLRO")){
			page = "AMLCaseWorkFlow/MLRO/PendingCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_AMLREP")){
			page = "AMLCaseWorkFlow/AMLREP/PendingCases/index";
		}
		
		
		String moduleType = "pendingCases";
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PENDING CASES", "OPEN", "Module Accessed");
		return page;
		
	}

	@RequestMapping(value="/escalatedCasesToAMLUserL3", method=RequestMethod.GET)
	public String escalatedCasesToAMLUserL3(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "";
		
		page = "AMLCaseWorkFlow/AMLO/PendingCases/index";
		
		String moduleType = "escalatedCasesToAMLUserL3";
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PENDING CASES", "OPEN", "Module Accessed");
		return page;
		
	}

	@RequestMapping(value="/approvedCasesByMLRO", method=RequestMethod.GET)
	public String approvedCasesByMLRO(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "";
		
		page = "AMLCaseWorkFlow/AMLREP/PendingCases/index";
		
		String moduleType = "approvedCasesByMLRO";
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "approvedCasesByMLRO", "OPEN", "Module Accessed");
		return page;
		
	}

	@RequestMapping(value="/closedCasesByLowerUsers", method=RequestMethod.GET)
	public String closedCasesByLowerUsers(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "";
		
		if(CURRENTROLE.equals("ROLE_USER")){
			page = "AMLCaseWorkFlow/User/PendingCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_BRANCHUSER")){
			page = "AMLCaseWorkFlow/BranchUser/PendingCases/index";
		}
		// else if(CURRENTROLE.equals("ROLE_AMLUSER")){
		else if(CURRENTROLE.contains("AMLUSER")){
			page = "AMLCaseWorkFlow/AMLUser/ClosedCasesWithUser/index";
		}
		// else if(CURRENTROLE.equals("ROLE_AMLO")){
		else if(CURRENTROLE.contains("AMLO")){
			page = "AMLCaseWorkFlow/AMLO/ClosedCasesWithAMLUser/index";
		}
		// else if(CURRENTROLE.equals("ROLE_MLRO")){
		else if(CURRENTROLE.contains("MLRO")){
			page = "AMLCaseWorkFlow/MLRO/ClosedCasesWithAMLO/index";
		}
		else if(CURRENTROLE.equals("ROLE_AUDITUSER")){
			page = "AMLCaseWorkFlow/AuditUser/ReviewCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_BTGUSER")){
			page = "AMLCaseWorkFlow/AuditUser/ReviewCases/index";
		}
		else if(CURRENTROLE.equals("ROLE_ITUSER")){
			page = "AMLCaseWorkFlow/AuditUser/ReviewCases/index";
		}
		
		
		String moduleType = "closedCasesByLowerUsers";
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CLOSED CASES", "OPEN", "Module Accessed");
		return page;
		
	}

	@RequestMapping(value="/viewClosedCases", method=RequestMethod.GET)
	public String viewClosedCases(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "";
		String userFolder = request.getParameter("userFolder");
		String moduleType = request.getParameter("moduleType");
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		page = userFolder;
		//System.out.println("moduleType= "+moduleType);
		request.setAttribute("MODULETYPE", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("MASTERSEARCHFRAME", genericMasterService.getModuleParameters(moduleType, 
				authentication.getPrincipal().toString(), userRole, request.getRemoteAddr()));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CLOSED CASES", "OPEN", "Module Accessed");
		//System.out.println("folder = "+page);
		return page;
	}

	@RequestMapping(value="/addViewComments", method=RequestMethod.GET)
	public String addViewComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "AMLCaseWorkFlow/AddViewCommentsNew";
			
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
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNos, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));

		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "OPEN", "ADD/VIEW COMMENTS");
		return page;
		//return "forward:"+page;
		
	}

	@RequestMapping(value="/addViewAMLRepComments", method=RequestMethod.GET)
	public String addViewAMLRepComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "AMLCaseWorkFlow/AddViewAMLRepComments";

		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String addedToMarkedAll = request.getParameter("AddedToMarkedAll");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String parentFormId = request.getParameter("formId");
		
		String ipAddress = request.getRemoteAddr();
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("FlagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNos);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("addedToMarkAll",addedToMarkedAll);
		commentMapDetails.put("lastReviewedDate","N.A.");
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));

		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNos, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "OPEN", "ADD/VIEW AML REP COMMENTS");
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		return page;
	}

	@RequestMapping(value="/saveComments", method=RequestMethod.POST)
	@ResponseStatus(value=HttpStatus.OK)
	public @ResponseBody Map saveComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		//String page = "AMLCaseWorkFlow/AddViewCommentsNew";
		String page = "AMLCaseWorkFlow/AddViewCommentsWithHistory";
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType");
		String comments = request.getParameter("Comments");
		String fraudIndicator = request.getParameter("FraudIndicator");
		String removalReason = request.getParameter("RemovalReason");
		String outcomeIndicator = request.getParameter("OutcomeIndicator");
		String highRiskReasonCode = request.getParameter("HighRiskReasonCode");
		String addedToFalsePositive = request.getParameter("AddedToFalsePositive");
		String lastReviewedDate = request.getParameter("LastReviewedDate");
		String exitRecommended = request.getParameter("ExitRecommended");
		String userActionType = request.getParameter("userActionType");
		String amlUserAddToMarkAll = request.getParameter("amlUserAddToMarkAll");
		String reassignToUserCode = request.getParameter("reassignToUserCode");
		String alertNos = request.getParameter("alertNos");
		String assignedBranchCode = request.getParameter("AssignedBranchCode");
		
		String fromDate = request.getParameter("FROMDATE");
		String toDate = request.getParameter("TODATE");
		String alertCode = request.getParameter("ALERTCODE");
		String branchCode = request.getParameter("BRANCHCODE");
		String accountNo = request.getParameter("ACCOUNTNO");
		String customerId = request.getParameter("CUSTOMERID");
		String hasAnyOldCases = request.getParameter("HASANYOLDCASES");
		String caseRating = request.getParameter("CASERATING");
		String fromCaseNo = request.getParameter("FROMCASENO");
		String toCaseNo = request.getParameter("TOCASENO");
		
		//System.out.println(caseNos+" "+lastReviewedDate+" "+comments+" "+outcomeIndicator+" "+caseStatus+" "+flagType+" "+removalReason+" "+highRiskReasonCode+" "+addedToFalsePositive);
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
		commentMapDetails.put("exitRecommended",exitRecommended);
		commentMapDetails.put("userActionType",userActionType);
		commentMapDetails.put("reassignToUserCode", reassignToUserCode);
		commentMapDetails.put("amlUserAddToMarkAll", amlUserAddToMarkAll);
		commentMapDetails.put("addedToMarkAll", amlUserAddToMarkAll);
		commentMapDetails.put("alertNos", alertNos);
		commentMapDetails.put("assignedBranchCode", assignedBranchCode);
		
		commentMapDetails.put("fromDate",fromDate);
		commentMapDetails.put("toDate",toDate);
		commentMapDetails.put("alertCode",alertCode);
		commentMapDetails.put("branchCode",branchCode);
		commentMapDetails.put("accountNo",accountNo);
		commentMapDetails.put("customerId",customerId);
		commentMapDetails.put("hasAnyOldCases",hasAnyOldCases);
		commentMapDetails.put("caseRating",caseRating);
		commentMapDetails.put("fromCaseNo",fromCaseNo);
		commentMapDetails.put("toCaseNo",toCaseNo);
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("FlagType", flagType);
		request.setAttribute("ActionType", "saveComments");
		request.setAttribute("userActionType", userActionType);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("UNQID", otherCommonService.getElementId());

		Map returnMap = amlCaseWorkFlowService.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		request.setAttribute("CASECOMMENTDETAILS", returnMap);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		
		String updateMsg = (String) returnMap.get("updateMessage");
		System.out.println("userActionType = "+userActionType+" caseStatus = "+caseStatus+" updateMsg = "+updateMsg);
		if(userActionType.equals("saveAndClose") && caseStatus.equals("1") && updateMsg.equals("The status of the case has been updated successfully")) {
			System.out.println("sendEmail");
			try{
				commonService.sendEmailFromCommon(caseNos, "AMLCaseWorkFlow", userCode, userRole, ipAddress);
			}
			catch(Exception e){
				System.out.println("Assign case to branch, Error while sending email from : "+e.toString());
				e.printStackTrace();
			}
		}
		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "INSERT", "SAVE COMMENTS");
		return returnMap;
		//return "forward:"+page;
	}

	@RequestMapping(value="/addOtherComments", method=RequestMethod.GET)
	public String addOtherComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "AMLCaseWorkFlow/AddOtherComments";
			
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String addedToMarkedAll = request.getParameter("AddedToMarkedAll");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String parentFormId = request.getParameter("formId");
		
		String ipAddress = request.getRemoteAddr();
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("FlagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNos);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("addedToMarkAll",addedToMarkedAll);
		commentMapDetails.put("lastReviewedDate","N.A.");
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));

		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNos, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		
		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "INSERT", "ADD OTHER COMMENTS");
		return page;
		//return "forward:"+page;
	}
	
	@RequestMapping(value="/saveOtherComments", method=RequestMethod.POST)
	@ResponseStatus(value=HttpStatus.OK)
	public @ResponseBody Map saveOtherComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "AMLCaseWorkFlow/AddOtherComments";
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType");
		String comments = request.getParameter("Comments");
		String addedToMarkAll = request.getParameter("AddedToMarkAll");
		String lastReviewedDate = request.getParameter("LastReviewedDate");
		String fromDate = request.getParameter("FROMDATE");
		String toDate = request.getParameter("TODATE");
		String alertCode = request.getParameter("ALERTCODE");
		String branchCode = request.getParameter("BRANCHCODE");
		String accountNo = request.getParameter("ACCOUNTNO");
		String customerId = request.getParameter("CUSTOMERID");
		String hasAnyOldCases = request.getParameter("HASANYOLDCASES");
		String caseRating = request.getParameter("CASERATING");
		String fromCaseNo = request.getParameter("FROMCASENO");
		String toCaseNo = request.getParameter("TOCASENO");
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNos);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("comments",comments);
		commentMapDetails.put("addedToMarkAll",addedToMarkAll);
		commentMapDetails.put("lastReviewedDate",lastReviewedDate);
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("FlagType", flagType);
		request.setAttribute("ActionType", "saveComments");
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("UNQID", otherCommonService.getElementId());

		Map returnMap = amlCaseWorkFlowService.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		request.setAttribute("CASECOMMENTDETAILS", returnMap);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "INSERT", "SAVE OTHER COMMENTS");
		return returnMap;
	}

	@RequestMapping(value="/saveAMLREPComments", method=RequestMethod.POST)
	@ResponseStatus(value=HttpStatus.OK)
	public @ResponseBody Map saveAMLREPComments(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "AMLCaseWorkFlow/AddViewAMLRepComments";
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String comments = request.getParameter("Comments");
		String fiuReferenceNo = request.getParameter("FIUReferenceNo");
		String fiuReferenceDate = request.getParameter("FIUReferenceDate");
		String exitRecommended = request.getParameter("ExitRecommended");
		
		String addedToMarkAll = request.getParameter("AddedToMarkAll");
		String lastReviewedDate = request.getParameter("LastReviewedDate");
		String fromDate = request.getParameter("FROMDATE");
		String toDate = request.getParameter("TODATE");
		String alertCode = request.getParameter("ALERTCODE");
		String branchCode = request.getParameter("BRANCHCODE");
		String accountNo = request.getParameter("ACCOUNTNO");
		String customerId = request.getParameter("CUSTOMERID");
		String hasAnyOldCases = request.getParameter("HASANYOLDCASES");
		String caseRating = request.getParameter("CASERATING");
		String fromCaseNo = request.getParameter("FROMCASENO");
		String toCaseNo = request.getParameter("TOCASENO");
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNos);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("comments",comments);
		commentMapDetails.put("fiuReferenceNo",fiuReferenceNo);
		commentMapDetails.put("exitRecommended",exitRecommended);
		
		commentMapDetails.put("addedToFalsePositive",fiuReferenceNo);
		
		commentMapDetails.put("addedToMarkAll",addedToMarkAll);
		commentMapDetails.put("fiuReferenceDate",fiuReferenceDate);
		commentMapDetails.put("lastReviewedDate",fiuReferenceDate);
		
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("FlagType", flagType);
		request.setAttribute("ActionType", "saveComments");
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("UNQID", otherCommonService.getElementId());

		Map returnMap = amlCaseWorkFlowService.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		request.setAttribute("CASECOMMENTDETAILS", returnMap);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "INSERT", "SAVE AML REP COMMENTS");
		return returnMap;
	}

	@RequestMapping(value="/assignToBranchUser", method=RequestMethod.GET)
	public String assignToBranchUser(HttpServletRequest request, HttpServletResponse response, 
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
	request.setAttribute("USERSLIST", amlCaseWorkFlowService.getListOfUsers());
	request.setAttribute("caseNo", caseNos);
	request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	commonService.auditLog(authentication.getPrincipal().toString(), request, "Assign to Branch User", "OPEN", "Module Accessed");
	return "AMLCaseWorkFlow/AssignToBranchUser";
	}
	
	@RequestMapping(value="/assignCaseToBranchUser", method=RequestMethod.POST)
	public @ResponseBody String assignCaseToBranchUser(HttpServletRequest request, HttpServletResponse response, 
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
	request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "Assign to Branch User", "OPEN", "Module Accessed");
	return amlCaseWorkFlowService.assignCaseToBranchUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating,
			branchCode,listOfCaseNos, listOfUsers, comments, userCode, ipAddress, userRole);
	}
	
	@RequestMapping(value="/searchPendingCases", method=RequestMethod.POST)
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
		
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("moduleName", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("submitButton", submitButton);
		request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
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
		String submitButton = request.getParameter("submitButton");
		
		Map<String, String[]> formData =  request.getParameterMap();
		Iterator<String> itr = formData.keySet().iterator();
		while (itr.hasNext()) {
			String tempParamName = itr.next();
			String tempParamValue = formData.get(tempParamName)[0];
			//if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)){
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
		
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("submitButton", submitButton);
		request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CLOSED CASES", "SEARCH", "Cases Searched");
		return buttomPageUrl;
	}
	
	@RequestMapping(value="/searchViewClosedCases", method=RequestMethod.POST)
	public String searchViewClosedCases(HttpServletRequest request, HttpServletResponse response, 
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
			//if(!"moduleType".equals(tempParamName) && !"bottomPageUrl".equals(tempParamName)){
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
		
		request.setAttribute("moduleType", moduleType);
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("submitButton", submitButton);
		//request.setAttribute("SEARCHRESULT", genericMasterService.searchGenericMaster(paramMap, moduleType, userCode, userRole, ipAdress));
		request.setAttribute("SEARCHRESULT", genericMasterService.searchMasterWithModuleType(paramMap, moduleType, userCode, userRole, ipAdress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CLOSED CASES", "SEARCH", "Cases Searched");
		return buttomPageUrl;
	}
	
	@RequestMapping(value="/getLinkedTransactionsForAlerts", method=RequestMethod.GET)
	public String getLinkedTransactionsForAlerts(HttpServletRequest request, HttpServletResponse response, Authentication authentication){
		String alertNo = request.getParameter("alertNo");
		request.setAttribute("LINKEDTXNS", genericMasterService.getLinkedTransactions(alertNo));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "PENDING CASES", "READ", "Displayed Linked Transaction for Alert No : "+alertNo);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		return "AMLCaseWorkFlow/AlertLinkedTransactions";
	}
	
	@RequestMapping(value="/caseReassignment", method=RequestMethod.GET)
	public String getUserDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERLIST", amlCaseWorkFlowService.getUserDetails("USER"));
		request.setAttribute("AMLUSERLIST", amlCaseWorkFlowService.getUserDetails("AMLUSER"));
		request.setAttribute("AMLOLIST", amlCaseWorkFlowService.getUserDetails("AMLO"));
		request.setAttribute("MLROLIST", amlCaseWorkFlowService.getUserDetails("MLRO"));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "CASE REASSIGNMENT", "OPEN", "Module Accessed");
		return "AMLCaseWorkFlow/AMLO/CaseReassignment/index";
	}
	
	@RequestMapping(value="/searchCaseReassignment", method=RequestMethod.POST)
	public String searchCaseReassignment(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fromDate = request.getParameter("fromDate");
	    String toDate = request.getParameter("toDate");
	    String reassignmentFor = request.getParameter("reassignmentFor");
	    String pendingWith = request.getParameter("pendingWith");
	    // String pendingUsersCode = request.getParameter("pendingUsersCode");
	    String pendingWithUsersCode = request.getParameter("pendingWithUsersCode");
	    String closedBy = request.getParameter("closedBy");
	    String closedByUsersCode = request.getParameter("closedByUsersCode");
	    
	    String userCode = authentication.getPrincipal().toString();
	    String groupCode = request.getSession().getAttribute("GROUPOFLOGGEDUSER") == null ? "N.A.": request.getSession().getAttribute("GROUPOFLOGGEDUSER").toString();  
	    String ipAddress = request.getRemoteAddr();
	    
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("ROLEID", pendingWith);
	    request.setAttribute("CURRUSERLIST", amlCaseWorkFlowService.getUserDetails(pendingWith));
	    
	    // request.setAttribute("resultData", amlCaseWorkFlowService.searchCaseReassignment(fromDate, toDate, reassignmentFor, pendingWith, pendingUsersCode, userCode, groupCode, ipAddress));
	    request.setAttribute("resultData", amlCaseWorkFlowService.searchCaseReassignment(fromDate, toDate, reassignmentFor, pendingWith,
				pendingWithUsersCode, closedBy, closedByUsersCode, userCode, groupCode, ipAddress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "CASE REASSIGNMENT", "SEARCH", "Module Accessed");
		return "AMLCaseWorkFlow/AMLO/CaseReassignment/SearchBottomPage";
	}

	@RequestMapping(value="/reAssignToUser", method=RequestMethod.GET)
	public String reAssignToUser(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
	String caseNo = request.getParameter("selectedCase");
	String caseStatus = request.getParameter("CaseStatus");
	String roleId = request.getParameter("roleId");
	String reassignmentFor = request.getParameter("reassignmentFor"); 
	String pendingWith = request.getParameter("pendingWith");
	//String pendingUsersCode = request.getParameter("pendingUsersCode");
	String pendingWithUsersCode = request.getParameter("pendingWithUsersCode");
	String closedBy = request.getParameter("closedBy");
    String closedByUsersCode = request.getParameter("closedByUsersCode");
	
	/*String userCode = authentication.getPrincipal().toString();
	String ipAddress = request.getRemoteAddr();
	*/
    String selectedUserCode = "";
    /*
    if(pendingWith == "" && pendingWithUsersCode == ""){
    	selectedUserCode = closedByUsersCode;
    }else if(closedBy == "" && closedByUsersCode == ""){
    	selectedUserCode = pendingWithUsersCode;
    }
    */
    if(reassignmentFor.equalsIgnoreCase("PendingCases"))
    	selectedUserCode = pendingWithUsersCode;
    else if(reassignmentFor.equalsIgnoreCase("ClosedCases"))
    	selectedUserCode = closedByUsersCode;
    
	request.setAttribute("roleId", roleId);
	request.setAttribute("reassignmentFor", reassignmentFor);
	request.setAttribute("pendingWith", pendingWith);
	// request.setAttribute("pendingUsersCode", pendingUsersCode);
	request.setAttribute("pendingWithUsersCode", pendingWithUsersCode);
	request.setAttribute("closedBy", closedBy);
	request.setAttribute("closedByUsersCode", closedByUsersCode);
	request.setAttribute("caseStatus", caseStatus);
	// request.setAttribute("USERSLIST", amlCaseWorkFlowService.getListOfCurrUser(roleId, reassignmentFor, pendingUsersCode));
	request.setAttribute("USERSLIST", amlCaseWorkFlowService.getListOfCurrUser(roleId, reassignmentFor, pendingWithUsersCode, closedByUsersCode));
	
	request.setAttribute("caseNo", caseNo);
	request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	request.setAttribute("searchButton", request.getParameter("searchButton"));
	request.setAttribute("selectedUserCode", selectedUserCode);
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CASE REASSIGNMENT", "OPEN", "Module Accessed");
	return "AMLCaseWorkFlow/AMLO/CaseReassignment/ReassignCases";
	}
	
	@RequestMapping(value="/reAssignCaseToUser", method=RequestMethod.POST)
	public @ResponseBody String reAssignCaseToUser(HttpServletRequest request, HttpServletResponse response, 
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
	
	String fromDate = request.getParameter("fromDate");
    String toDate = request.getParameter("toDate");
    String reassignmentFor = request.getParameter("reassignmentFor");
    String pendingWith = request.getParameter("pendingWith");
    // String pendingUsersCode = request.getParameter("pendingUsersCode");
    String pendingWithUsersCode = request.getParameter("pendingWithUsersCode");
    String closedBy = request.getParameter("closedBy");
    String closedByUsersCode = request.getParameter("closedByUsersCode");
    String reassignmentReason = request.getParameter("reassignmentReason");
    String ageingFor = request.getParameter("ageingFor");
    
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	String ipAddress = request.getRemoteAddr();
	
	String parentFormId = request.getParameter("formId");
	request.setAttribute("parentFormId", parentFormId);
	request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	request.setAttribute("reassignmentReason", reassignmentReason);
	request.setAttribute("ageingFor", ageingFor);
	
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CASE REASSIGNMENT", "OPEN", "Module Accessed");
	/*
	return amlCaseWorkFlowService.reAssignCaseToUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating, listOfCaseNos, branchCode, listOfUsers, comments, 
			fromDate, toDate, reassignmentFor, pendingWith, pendingUsersCode,
			userCode, ipAddress, userRole);
	*/
	return amlCaseWorkFlowService.reAssignCaseToUser(caseNo, caseStatus, caseRangeFrom, caseRangeTo, hasOldCases, caseRating, listOfCaseNos, branchCode, listOfUsers, comments, 
			fromDate, toDate, reassignmentFor, pendingWith, pendingWithUsersCode, closedBy, closedByUsersCode, reassignmentReason, 
			ageingFor, userCode, ipAddress, userRole);

	}

	@RequestMapping(value="/getCaseWorkflowModuleDetails", method=RequestMethod.GET)
	public String getModuleDetails(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws Exception{
		String moduleCode = request.getParameter("moduleCode");
		String moduleValue = request.getParameter("moduleValue");
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
		
		Map<String, Object> mainMap = amlCaseWorkFlowService.getCaseWorkflowModuleDetails(moduleCode, moduleValue, action,
				userCode, userRole, ipAddress, caseStatus);
		
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
		
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNos, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("ALLUSERSLIST", amlCaseWorkFlowService.getAllUserList(caseNos, action, caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("AMLUserAMLOMappingDetails", amlCaseWorkFlowService.getAMLUserAMLOMappingDetails(userCode, userRole));
		request.setAttribute("AMLOMLROMappingDetails", amlCaseWorkFlowService.getAMLOMLROMappingDetails(userCode, userRole));
		request.setAttribute("SUSPICIONINDICATORS", amlCaseWorkFlowService.getSuspicionIndicators(caseNos, caseStatus, action, userCode, 
				userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("AlertDetails", amlCaseWorkFlowService.getAlertsDetailsForAssignment(moduleValue, userCode, userRole, ipAddress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		request.setAttribute("ALLBRANCHESLIST", amlCaseWorkFlowService.getAllBranchesList(caseNos, userCode, userRole, ipAddress));
		commonService.auditLog(authentication.getPrincipal().toString(), request, moduleCode, "SEARCH", moduleValue+" details viewed in tab");
		/*System.out.println("SUSPICIONINDICATORS = "+amlCaseWorkFlowService.getSuspicionIndicators(caseNos, caseStatus, action, userCode, 
				userRole, ipAddress));*/
		/*
		System.out.println("userRole = "+userRole);*/
		//System.out.println("inputCustomerId = "+request.getParameter("customerId"));
		//System.out.println("AlertDetails = "+amlCaseWorkFlowService.getAlertsDetailsForAssignment(moduleValue, userCode, userRole, ipAddress));
		return detailPage;
	}
	
	@RequestMapping(value="/getEvidenceAttachedCount", method=RequestMethod.POST)
	public @ResponseBody int getEvidenceAttachedCount(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		//System.out.println("caseNo"+caseNo);
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		//System.out.println(amlCaseWorkFlowService.getEvidenceAttachedCount(caseNo,userCode,userRole));
		return amlCaseWorkFlowService.getEvidenceAttachedCount(caseNo,userCode,userRole);
	}
	
	@RequestMapping(value="/hasDistinctCustId", method=RequestMethod.POST)
	public @ResponseBody Map <String,Object> hasDistinctCustId(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
	String caseNo = request.getParameter("caseNo");
	/*System.out.println("caseNo"+caseNo);*/
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	String ipAddress = request.getRemoteAddr();
	request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	return amlCaseWorkFlowService.hasDistinctCustId(caseNo,userCode,userRole,ipAddress);
	}
	
	//for reAssignToAMLUser from AMLO   
	@RequestMapping(value="/reAssignToAMLUser", method=RequestMethod.GET)
	public String  reAssignToAMLUser(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String page = "AMLCaseWorkFlow/ReAssignToAMLUser";
			
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String addedToMarkedAll = request.getParameter("AddedToMarkedAll");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String parentFormId = request.getParameter("formId");
		String ipAddress = request.getRemoteAddr();
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("FlagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNos);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("addedToMarkAll",addedToMarkedAll);
		commentMapDetails.put("lastReviewedDate","N.A.");
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));

		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("userCode", userCode);
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNos, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		// request.setAttribute("AMLUSERCODE",amlCaseWorkFlowService.getUserDetails("AMLUSER"));
		request.setAttribute("ALLUSERSLIST",amlCaseWorkFlowService.getAllUserList(caseNos,"reAssignToAMLUser",caseStatus, userCode, userRole, ipAddress));
		
		//System.out.println("amluser list = "+amlCaseWorkFlowService.getUserDetails("AMLUSER"));
		//request.setAttribute("AMLUSERAGAINSTCASENO", amlCaseWorkFlowService.amlUserAgainstCaseNo(caseNos, userCode, userRole,ipAddress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));

		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "INSERT", "ADD OTHER COMMENTS");
		return page;

	}
	
	@RequestMapping(value="/saveCommentWhileReAssigningToAMLUser", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object>  saveCommentWhileReAssigningToAMLUser(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		//String page = "AMLCaseWorkFlow/AddOtherComments";
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String caseNos = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType");
		String comments = request.getParameter("Comments");
		String addedToMarkAll = request.getParameter("AddedToMarkAll");
		String lastReviewedDate = request.getParameter("LastReviewedDate");
		String fromDate = request.getParameter("FROMDATE");
		String toDate = request.getParameter("TODATE");
		String alertCode = request.getParameter("ALERTCODE");
		String branchCode = request.getParameter("BRANCHCODE");
		String accountNo = request.getParameter("ACCOUNTNO");
		String customerId = request.getParameter("CUSTOMERID");
		String hasAnyOldCases = request.getParameter("HASANYOLDCASES");
		String caseRating = request.getParameter("CASERATING");
		String fromCaseNo = request.getParameter("FROMCASENO");
		String toCaseNo = request.getParameter("TOCASENO");
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNos);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("comments",comments);
		commentMapDetails.put("fraudIndicator",request.getParameter("fraudIndicator"));
		commentMapDetails.put("addedToMarkAll",addedToMarkAll);
		commentMapDetails.put("lastReviewedDate",lastReviewedDate);
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));
		commentMapDetails.put("amlUserCode", request.getParameter("amlUserCode"));
		commentMapDetails.put("reassignToUserCode", request.getParameter("amlUserCode"));
		
		request.setAttribute("CaseNos", request.getParameter("CaseNos"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("FlagType", flagType);
		request.setAttribute("ActionType", "saveComments");
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("userCode", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));

		//Map<String,Object> returnMap = amlCaseWorkFlowService.saveCommentWhileReAssigningToAMLUser(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		Map<String,Object> returnMap = amlCaseWorkFlowService.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
		request.setAttribute("CASECOMMENTDETAILS", returnMap);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "INSERT", "SAVE OTHER COMMENTS");
		//System.out.println("commentmap = "+commentMapDetails);
		//System.out.println(returnMap);
		return returnMap;
	}
	
	
	@RequestMapping(value="/reAllocatingToAMLUser", method=RequestMethod.GET)
	public String  reAllocatingToAMLUser(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String caseNo = request.getParameter("CaseNo");
		String caseStatus = request.getParameter("CaseStatus");
		String addedToMarkedAll = request.getParameter("AddedToMarkedAll");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String parentFormId = request.getParameter("formId");
		String ipAddress = request.getRemoteAddr();
		
		request.setAttribute("CaseNos", request.getParameter("CaseNo"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("FlagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNo);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("addedToMarkAll",addedToMarkedAll);
		commentMapDetails.put("lastReviewedDate",request.getParameter("LastReviewedDate"));
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));

		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("userCode", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNo, 
				caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		/*
		Map<String,String>amlUserCode = amlCaseWorkFlowService.getUserDetails("AMLUSER");
		amlUserCode.remove(userCode);
		request.setAttribute("AMLUSERCODE",amlUserCode);
		*/
		request.setAttribute("ALLUSERSLIST",amlCaseWorkFlowService.getAllUserList(request.getParameter("CaseNo"), "reAllocateToAMLUser", caseStatus, userCode, userRole, ipAddress));
		//System.out.println("amluser list = "+amlCaseWorkFlowService.getUserDetails("AMLUSER"));
		//request.setAttribute("AMLUSERAGAINSTCASENO", amlCaseWorkFlowService.amlUserAgainstCaseNo(caseNo, userCode, userRole,ipAddress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));

		// request.getSession().setAttribute("CURRENTROLE",LOGGEDUSER);
		
	commonService.auditLog(userCode, request, "AML CASE WORKFLOW", "OPEN", "CASE REALLOCATING TO AML USER");
	 return "AMLCaseWorkFlow/ReAllocateToAMLUser";
	}
	
	
	@RequestMapping(value="/saveCommentWhileReAllocatingToAMLUser", method=RequestMethod.POST)
	public @ResponseBody Map<String,Object>  saveCommentWhileReAllocatingToAMLUser(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
	HashMap<String, String> commentMapDetails = new HashMap<String, String>();
	String caseNos = request.getParameter("CaseNo");
	String caseStatus = request.getParameter("CaseStatus");
	String userCode = authentication.getPrincipal().toString();
	String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
	String ipAddress = request.getRemoteAddr();
	commentMapDetails.put("caseNos",caseNos);
	commentMapDetails.put("caseStatus",caseStatus);
	commentMapDetails.put("comments",request.getParameter("Comments"));
	commentMapDetails.put("addedToMarkAll",request.getParameter("AddedToMarkAll"));
	commentMapDetails.put("lastReviewedDate",request.getParameter("LastReviewedDate"));
	commentMapDetails.put("fromDate",request.getParameter("fromDate"));
	commentMapDetails.put("toDate",request.getParameter("toDate"));
	commentMapDetails.put("alertCode",request.getParameter("alertCode"));
	commentMapDetails.put("branchCode",request.getParameter("branchCode"));
	commentMapDetails.put("accountNo",request.getParameter("accountNo"));
	commentMapDetails.put("customerId",request.getParameter("customerId"));
	commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
	commentMapDetails.put("caseRating",request.getParameter("caseRating"));
	commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
	commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));
	commentMapDetails.put("amlUserCode", request.getParameter("amlUserCode"));
	commentMapDetails.put("reassignToUserCode", request.getParameter("amlUserCode"));
	commentMapDetails.put("fraudIndicator", request.getParameter("fraudIndicator"));
	
	request.setAttribute("CaseNos", request.getParameter("CaseNos"));
	request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
	request.setAttribute("CommentMapDetails", commentMapDetails);
	request.setAttribute("ActionType", "saveComments");
	request.setAttribute("LOGGEDUSER", userCode);
	request.setAttribute("GROUPOFLOGGEDUSER", userRole);
	request.setAttribute("LOGGED_USER_REGION", "India");
	request.setAttribute("UNQID", otherCommonService.getElementId());
	request.setAttribute("userCode", userCode);
	request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	// Map<String,Object> returnMap = amlCaseWorkFlowService.saveCommentWhileReAllocatingToAMLUser(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
	Map<String,Object> returnMap = amlCaseWorkFlowService.saveCaseCommentDetails(caseNos, caseStatus, commentMapDetails, userCode, userRole, ipAddress);
	commonService.auditLog(authentication.getPrincipal().toString(), request, "CASE REALLOCATING TO AML USER", "OPEN", "Module Accessed");
	request.setAttribute("CASECOMMENTDETAILS", returnMap);
	 return returnMap;
	}
	
	@RequestMapping(value = "/getAlertsForAddingToFalsePositive", method=RequestMethod.POST) 
	public String getAlertsForAddingToFalsePositive(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws Exception {
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		String searchButton = request.getParameter("searchButton");
		
		Map<String, Object> resultMap =  amlCaseWorkFlowService.getAlertsForAddingToFalsePositive(caseNo, userCode, userRole, ipAddress);
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("resultData", resultMap);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "SEARCH", "Module Accessed");
		//System.out.println("searchButton 1 = "+searchButton);
		// return "AMLCaseWorkFlow/AMLO/PendingCases/AlertsListForFalsePositive";
		return "AMLCaseWorkFlow/AlertsListForFalsePositive";
		//return "AMLCaseWorkFlow/AMLUser/PendingCases/AlertsListForFalsePositive";
	}
	
	@RequestMapping(value = "/getDetailsForUpdatingFalsePositive", method=RequestMethod.POST) 
	public String getDetailsForUpdatingFalsePositive(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws Exception {
		String caseNo = request.getParameter("caseNo");
		String refNo = request.getParameter("refNo");
		String searchButton = request.getParameter("searchButton");
		String userRole = (String)request.getSession(false).getAttribute("CURRENTROLE");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("ROLE", userRole);
		request.setAttribute("resultData", amlCaseWorkFlowService.getDetailsForUpdatingFalsePositive(caseNo, refNo));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "SEARCH", "Module Accessed");
		//System.out.println("resultData = "+amlCaseWorkFlowService.getDetailsForUpdatingFalsePositive(caseNo, refNo));
		//System.out.println("searchButton 2 = "+searchButton);
		//return "AMLCaseWorkFlow/AMLUser/PendingCases/UpdateFalsePositiveDetails";
		// return "AMLCaseWorkFlow/AMLO/PendingCases/UpdateFalsePositiveDetails";
		return "AMLCaseWorkFlow/UpdateFalsePositiveDetails";
	}
	
	@RequestMapping(value = "/saveToFalsePositive", method=RequestMethod.POST) 
	public @ResponseBody String saveToFalsePositive(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws Exception {
		String refNo = request.getParameter("refNo");
		String caseNo = request.getParameter("caseNo");
		String activeFrom = request.getParameter("activeFromDate");
		String activeTo = request.getParameter("activeTo");
		String isEnabled = request.getParameter("isEnabled");
		String reason = request.getParameter("reason");
		String toleranceLevel = request.getParameter("toleranceLevel");
		String isToBeDeleted = request.getParameter("isToBeDeleted");
		String searchButton = request.getParameter("searchButton");
		String userCode = authentication.getPrincipal().toString();
		/*System.out.println("refNo="+refNo+"activeFrom="+activeFrom+"activeTo="+activeTo+"isEnabled="+isEnabled+"reason="+reason+
						   "toleranceLevel="+toleranceLevel+"isToBeDeleted="+isToBeDeleted);*/
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("searchButton", searchButton);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		String result = amlCaseWorkFlowService.saveToFalsePositive(caseNo, refNo, activeFrom, activeTo, 
				isEnabled, reason, toleranceLevel, isToBeDeleted, userCode);
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "SEARCH", "Module Accessed");
		//System.out.println("resultData = "+amlCaseWorkFlowService.getDetailsForUpdatingFalsePositive(caseNo, refNo));
		return result;
	}
	
	@RequestMapping(value="/openSplitAssignCasesModal", method=RequestMethod.POST) 
	public String openSplitAssignCasesModal(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws Exception {
		String alertNos = request.getParameter("alertNos");
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String)request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		String caseStatus = request.getParameter("caseStatus");
		String action = request.getParameter("action");
		String parentFormId = request.getParameter("formId");
		String modalId = request.getParameter("modalId");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("alertNos", alertNos);
		request.setAttribute("userCode", userCode);
		request.setAttribute("userRole", userRole);
		request.setAttribute("parentFormId", parentFormId);
		request.setAttribute("caseStatus", caseStatus);
		request.setAttribute("modalId", modalId);
		request.setAttribute("SUSPICIONINDICATORS", amlCaseWorkFlowService.getSuspicionIndicators(caseNo, caseStatus, action, userCode, 
				userRole, ipAddress));
		request.setAttribute("AMLUSERLIST", amlCaseWorkFlowService.getUserDetails("AMLUSER"));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "SEARCH", "Module Accessed");
		return "AMLCaseWorkFlow/SplitAssignCases";
	}
	
	@RequestMapping(value="/openAddAlertCommentsModal", method=RequestMethod.POST) 
	public String openAddAlertCommentsModal(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication) throws Exception {
		String alertNos = request.getParameter("alertNos");
		String caseNo = request.getParameter("caseNo");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String)request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		String caseStatus = request.getParameter("caseStatus");
		String action = request.getParameter("action");
		String parentFormId = request.getParameter("formId");
		String modalId = request.getParameter("modalId");
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("alertNos", alertNos);
		request.setAttribute("userCode", userCode);
		request.setAttribute("userRole", userRole);
		request.setAttribute("parentFormId", parentFormId);
		request.setAttribute("caseStatus", caseStatus);
		request.setAttribute("modalId", modalId);
		//System.out.println("modalId = "+modalId);
		request.setAttribute("SUSPICIONINDICATORS", amlCaseWorkFlowService.getSuspicionIndicators(caseNo, caseStatus, action, userCode, 
				userRole, ipAddress));
		request.setAttribute("AMLUSERLIST", amlCaseWorkFlowService.getUserDetails("AMLUSER"));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		commonService.auditLog(authentication.getPrincipal().toString(), request, "AML CASE WORKFLOW", "SEARCH", "Module Accessed");
		return "AMLCaseWorkFlow/AddAlertComments";
	}
	
	@RequestMapping(value="/casesToBeReviewedByAMLO", method=RequestMethod.GET)
	public String  casesToBeReviewedByAMLO(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String CURRENTROLE = request.getSession(false) != null ? (String) request.getSession(false).getAttribute("CURRENTROLE") : "";
		String caseNo = request.getParameter("CaseNos");
		String caseStatus = request.getParameter("CaseStatus");
		String flagType = request.getParameter("FlagType") == null ? "N":request.getParameter("FlagType");
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String parentFormId = request.getParameter("formId");
		String ipAddress = request.getRemoteAddr();
		String action = request.getParameter("action");
		
		request.setAttribute("CaseNos", request.getParameter("CaseNo"));
		request.setAttribute("CaseStatus", request.getParameter("CaseStatus"));
		request.setAttribute("FlagType", flagType);
		request.setAttribute("parentFormId", parentFormId);
		HashMap<String, String> commentMapDetails = new HashMap<String, String>();
		commentMapDetails.put("caseNos",caseNo);
		commentMapDetails.put("caseStatus",caseStatus);
		commentMapDetails.put("lastReviewedDate",request.getParameter("LastReviewedDate"));
		commentMapDetails.put("fromDate",request.getParameter("fromDate"));
		commentMapDetails.put("toDate",request.getParameter("toDate"));
		commentMapDetails.put("alertCode",request.getParameter("alertCode"));
		commentMapDetails.put("branchCode",request.getParameter("branchCode"));
		commentMapDetails.put("accountNo",request.getParameter("accountNo"));
		commentMapDetails.put("customerId",request.getParameter("customerId"));
		commentMapDetails.put("hasAnyOldCases",request.getParameter("hasAnyOldCases"));
		commentMapDetails.put("caseRating",request.getParameter("caseRating"));
		commentMapDetails.put("fromCaseNo",request.getParameter("fromCaseNo"));
		commentMapDetails.put("toCaseNo",request.getParameter("toCaseNo"));
		
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
		request.setAttribute("CommentMapDetails", commentMapDetails);
		request.setAttribute("LOGGEDUSER", userCode);
		request.setAttribute("GROUPOFLOGGEDUSER", userRole);
		request.setAttribute("LOGGED_USER_REGION", "India");
		request.setAttribute("CASECOMMENTDETAILS", amlCaseWorkFlowService.getCaseCommentDetails(caseNo, 
		caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("ALLUSERSLIST", amlCaseWorkFlowService.getAllUserList(caseNo, action, caseStatus, userCode, userRole, ipAddress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		request.setAttribute("action", action);
		request.setAttribute("caseNo", caseNo);
		request.setAttribute("caseStatus", caseStatus);
		//System.out.println(userCode+" "+action+" "+caseNo+" "+caseStatus+" "+amlCaseWorkFlowService.getAllUserList(caseNo, action, caseStatus, userCode, userRole, ipAddress));
		commonService.auditLog(userCode, request, "AML CASE WORKFLOW", "OPEN", "CASE TO BE REVIEWED BY AMLO");
		return "AMLCaseWorkFlow/AMLO/CasesToBeReviewed/CasesToBeReviewedComments";
	}
	
	@RequestMapping(value="/selfCaseAssignment", method=RequestMethod.GET)
	public String getParamsForSelfCaseAssignment(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		request.setAttribute("CUSTOMERTYPE", genericMasterService.getOptionNameValueFromView("VW_CUSTOMERTYPE"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SELF CASE ASSIGNMENT", "OPEN", "Module Accessed");
		return "AMLCaseWorkFlow/AMLUser/SelfCaseAssignment/index";
	}
	
	@RequestMapping(value="/searchCasesForSelfAssignment", method=RequestMethod.POST)
	public String searchCasesForSelfAssignment(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fromDate = request.getParameter("fromDate");
	    String toDate = request.getParameter("toDate");
	    String customerId = request.getParameter("customerId");
	    String customerType = request.getParameter("customerType");
	    String caseRangeFrom = request.getParameter("caseRangeFrom");
	    String caseRangeTo = request.getParameter("caseRangeTo");

	    String userCode = authentication.getPrincipal().toString();
	    String groupCode = request.getSession().getAttribute("GROUPOFLOGGEDUSER") == null ? "N.A.": request.getSession().getAttribute("GROUPOFLOGGEDUSER").toString();  
	    String ipAddress = request.getRemoteAddr();
	    
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("resultData", amlCaseWorkFlowService.searchCasesForSelfAssignment(fromDate, toDate, customerId, customerType,
	    		caseRangeFrom, caseRangeTo, userCode, groupCode, ipAddress));
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "SELF CASE ASSIGNMENT", "SEARCH", "Module Accessed");
		return "AMLCaseWorkFlow/AMLUser/SelfCaseAssignment/SearchBottomPage";
	}
	
	@RequestMapping(value="/openModalToAssignCasesToSelf", method=RequestMethod.GET)
	public String openModalToAssignCasesToSelf(HttpServletRequest request, HttpServletResponse response, 
											Authentication authentication) throws Exception{
		String selectedCase = request.getParameter("selectedCase");
		String caseStatus = request.getParameter("CaseStatus");
	
		String selectedCustomerType = request.getParameter("customerType");
		String selectedCustomerId = request.getParameter("customerId"); 
		String selectedCaseRangeFrom = request.getParameter("caseRangeFrom");
	    String selectedCaseRangeTo = request.getParameter("caseRangeTo");
	    
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("selectedCustomerType", selectedCustomerType);
		request.setAttribute("selectedCustomerId", selectedCustomerId);
		request.setAttribute("selectedCaseRangeFrom", selectedCaseRangeFrom);
		request.setAttribute("selectedCaseRangeTo", selectedCaseRangeTo);
		request.setAttribute("caseStatus", caseStatus);
		
		request.setAttribute("selectedCases", selectedCase);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		request.setAttribute("searchButton", request.getParameter("searchButton"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SELF CASE ASSIGNMENT", "OPEN", "Module Accessed");
		return "AMLCaseWorkFlow/AMLUser/SelfCaseAssignment/AssignCasesToSelf";
	}
	
	@RequestMapping(value="/assignCasesToSelf", method=RequestMethod.POST)
	public @ResponseBody String assignCasesToSelf(HttpServletRequest request, HttpServletResponse response, 
			Authentication authentication) throws Exception{
		String caseNo = request.getParameter("caseNo");
		String caseStatus = request.getParameter("caseStatus");
		String caseRangeFrom = request.getParameter("caseRangeFrom");
		String caseRangeTo = request.getParameter("caseRangeTo");
		String listOfCustType = request.getParameter("listOfCustType");
		String listOfCustId = request.getParameter("listOfCustId");
		String listOfBranchCodes = request.getParameter("listOfBranchCodes");
		String listOfCaseNos = request.getParameter("listOfCaseNos");
		String maxCaseCount = request.getParameter("maxCaseCount");
		String comments = request.getParameter("comments");
		
		String userCode = authentication.getPrincipal().toString();
		String userRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		
		String parentFormId = request.getParameter("formId");
		request.setAttribute("parentFormId", parentFormId);
		request.setAttribute("userRole",(String) request.getSession(false).getAttribute("CURRENTROLE"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "SELF CASE ASSIGNMENT", "UPDATE", "Assigned Cases To Self");
		
		return amlCaseWorkFlowService.assignCasesToSelf(caseNo, caseStatus, caseRangeFrom, caseRangeTo, listOfCustType, listOfCustId, listOfBranchCodes, 
			listOfCaseNos, maxCaseCount, comments, userCode, ipAddress, userRole);
	}
	
	
}
