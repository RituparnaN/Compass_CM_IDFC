package com.quantumdataengines.app.compass.controller;

import java.util.ArrayList;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import oracle.net.aso.i;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import antlr.collections.List;

import com.quantumdataengines.app.compass.otherservice.OtherCommonService;
import com.quantumdataengines.app.compass.service.CommonService;
import com.quantumdataengines.app.compass.service.userHierarchyMapping.UserHierarchyMappingService;

@Controller
@RequestMapping(value="/admin")
public class UserHierarchyMappingController {
private static final Logger log = LoggerFactory.getLogger(CommonController.class);
	
	@Autowired
	private CommonService commonService;
	@Autowired
	private OtherCommonService otherCommonService;
	@Autowired
	private UserHierarchyMappingService userHierarchyMappingService;
	
	@RequestMapping(value="/userHierarchyMapping", method=RequestMethod.GET)
	public String getUserDetails(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERLIST", userHierarchyMappingService.getUserDetails("USER"));
		request.setAttribute("AMLUSERLIST", userHierarchyMappingService.getUserDetails("AMLUSER"));
		request.setAttribute("AMLOLIST", userHierarchyMappingService.getUserDetails("AMLO"));
		request.setAttribute("MLROLIST", userHierarchyMappingService.getUserDetails("MLRO"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "USER HIERARCHY MAPPING", "OPEN", "Module Accessed");
		return "UserHierarchyMapping/index";
	}
	
	@RequestMapping(value="/searchUserHierarchyMapping", method=RequestMethod.POST)
	public String searchUserHierarchyMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String mappingType = request.getParameter("mappingType");
	    String mappingAMLUsersCode = request.getParameter("mappingAMLUsersCode");
	    String mappingAMLOUsersCode = request.getParameter("mappingAMLOUsersCode");
	    String mappingMLROUsersCode = request.getParameter("mappingMLROUsersCode");
	    	    
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("RESULTDATA", userHierarchyMappingService.searchUserHierarchyMapping(mappingType, mappingAMLUsersCode, mappingAMLOUsersCode, mappingMLROUsersCode));
	    request.setAttribute("mappingType", mappingType);
	    request.setAttribute("mappingAMLUsersCode", mappingAMLUsersCode);
	    request.setAttribute("mappingAMLOUsersCode", mappingAMLOUsersCode);
	    request.setAttribute("mappingMLROUsersCode", mappingMLROUsersCode);
	    request.setAttribute("AMLUSERLIST", userHierarchyMappingService.getUserDetails("AMLUSER"));
		request.setAttribute("AMLOLIST", userHierarchyMappingService.getUserDetails("AMLO"));
		request.setAttribute("MLROLIST", userHierarchyMappingService.getUserDetails("MLRO"));
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER HIERARCHY MAPPING", "SEARCH", "Module Accessed");
	    return "UserHierarchyMapping/SearchBottomPage";
	}
	
	
	@RequestMapping(value="/saveMapping", method=RequestMethod.POST)
	public @ResponseBody String saveMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String mappingType = request.getParameter("mappingType");
		String fullData = request.getParameter("fullData");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println(fullData);
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "USER HIERARCHY MAPPING", "INSERT", "User Hierarchy Mapping Assignment Saved");
	    return userHierarchyMappingService.saveMapping(fullData, mappingType, currentUser, currentRole, ipAddress);
	   
	}
	
	@RequestMapping(value="/reportingUsersMapping", method=RequestMethod.GET)
	public String reportingUsersMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		request.setAttribute("UNQID", otherCommonService.getElementId());
		request.setAttribute("USERROLE", request.getSession(false).getAttribute("CURRENTROLE") == null ? "N.A.":request.getSession(false).getAttribute("CURRENTROLE").toString());
		request.setAttribute("USERSLIST", userHierarchyMappingService.getUsersList("USER","USERCODE"));
		/*
		request.setAttribute("REPORTINGUSERSLIST", userHierarchyMappingService.getUsersList("USER","REPORTINGUSERCODE"));
		request.setAttribute("REVIEWERUSERSLIST", userHierarchyMappingService.getUsersList("USER","REVIEWERSCODE"));
		*/
		request.setAttribute("REPORTINGUSERSLIST", userHierarchyMappingService.getUsersList("USER","USERCODE"));
		request.setAttribute("REVIEWERUSERSLIST", userHierarchyMappingService.getUsersList("USER","USERCODE"));
		
		commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTING USERS MAPPING", "OPEN", "Module Accessed");
		return "ReportingUsersMapping/index";
	}
	
	@RequestMapping(value="/searchReportingUsersMapping", method=RequestMethod.POST)
	public String searchReportingUsersMapping(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		
		String userCodeField = request.getParameter("userCodeField");
	    String reportingUserCodeField = request.getParameter("reportingUserCodeField");
	    String reviewersCodeField = request.getParameter("reviewersCodeField");
	    String statusField = request.getParameter("statusField");
	    String userRole = request.getParameter("userRole");
	    
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("userRole", userRole);
	    request.setAttribute("RESULTDATA", userHierarchyMappingService.searchReportingUsersMapping(userCodeField, reportingUserCodeField, reviewersCodeField, statusField));
	    //ArrayList<String> AllReportingUserList = userHierarchyMappingService.getAllReportingUserList();
	    request.setAttribute("WHOLELIST_REPORTINGUSERCODE", userHierarchyMappingService.getAllUserList("REPORTINGUSERCODE"));
	    request.setAttribute("WHOLELIST_REVIEWERSCODE", userHierarchyMappingService.getAllUserList("REVIEWERSCODE"));
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTING USERS MAPPING", "SEARCH", "Module Accessed");
	    return "ReportingUsersMapping/SearchBottomPage";
	}
	
	@RequestMapping(value="/saveMappingRepUser", method=RequestMethod.POST)
	public @ResponseBody String saveMappingRepUser(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fullData = request.getParameter("fullData");
		String makerComments = request.getParameter("makerComments");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		/*System.out.println(fullData);
		System.out.println(makerComments);*/
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTING USERS MAPPING", "UPDATE", "Reporting Users Mapping Assignment Saved");
	    return userHierarchyMappingService.saveMappingRepUser(fullData, makerComments, currentUser, currentRole, ipAddress);
	}
	
	@RequestMapping(value="/getReportingUserComments", method=RequestMethod.POST)
	public String getReportingUserComments(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String userCode = request.getParameter("userCode");
		String searchButton = request.getParameter("searchButton");
		String actionForModal = request.getParameter("actionForModal");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();

	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    request.setAttribute("USERCODE", userCode);
	    request.setAttribute("SEARCHBUTTON", searchButton);
	    request.setAttribute("ACTIONFORMODAL", actionForModal);
	    request.setAttribute("RESULTDATA", userHierarchyMappingService.getReportingUserComments(userCode, currentUser, currentRole, ipAddress));
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTING USERS MAPPING", "UPDATE", "Reporting Users Mapping Assignment Approved");
	    return "ReportingUsersMapping/commentsModal";
	}
	
	@RequestMapping(value="/approveOrRejectRepUser", method=RequestMethod.POST)
	public @ResponseBody String approveOrRejectRepUser(HttpServletRequest request, HttpServletResponse response,
			Authentication authentication)throws Exception{
		String fullData = request.getParameter("fullData");
		String actionToTake = request.getParameter("actionToTake");
		String currentUser = authentication.getPrincipal().toString();
		String currentRole = (String) request.getSession(false).getAttribute("CURRENTROLE");
		String ipAddress = request.getRemoteAddr();
		//System.out.println(fullData);
	    request.setAttribute("UNQID", otherCommonService.getElementId());
	    
	    commonService.auditLog(authentication.getPrincipal().toString(), request, "REPORTING USERS MAPPING", "UPDATE", "Reporting Users Mapping Assignment Approved");
	    return userHierarchyMappingService.approveOrRejectRepUser(fullData, actionToTake, currentUser, currentRole, ipAddress);
	}
}